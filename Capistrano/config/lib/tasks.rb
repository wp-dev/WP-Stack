namespace :shared do
	task :make_shared_dir do
		run "if [ ! -d #{shared_path}/files ]; then mkdir #{shared_path}/files; fi"
	end
	task :make_symlinks do
		run "if [ ! -h #{release_path}/shared ]; then ln -s #{shared_path}/files/ #{release_path}/shared; fi"
		run "for p in `find -L #{release_path} -type l`; do t=`readlink $p | grep -o 'shared/.*$'`; sudo mkdir -p #{release_path}/$t; sudo chown www-data:www-data #{release_path}/$t; done"
	end
end

namespace :nginx do
	desc "Restarts nginx"
	task :restart do
		run "sudo /etc/init.d/nginx restart"
	end
end

namespace :phpfpm do
  desc" Restarts PHP-FPM"
  task :restart do
    run "sudo /etc/init.d/php-fpm restart"
  end
end

namespace :git do
	desc "Updates git submodule tags"
	task :submodule_tags do
		run "if [ -d #{shared_path}/cached-copy/ ]; then cd #{shared_path}/cached-copy/ && git submodule foreach --recursive git fetch origin --tags; fi"
	end
end
