#!/bin/bash
#######################################################################
##                                                                   ##
##    This script installs and configures SimpleBashMonitor.         ##
##    It adds also some useful commands to control the node.         ##
##    Use it at your own risk.                                       ##
##    For other systems just take out|adapt the apt commands         ##
##                                                                   ##
#######################################################################

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as user root."
    exit 1
fi
echo "Installing needed stuff..."
apt update 
apt install -y bc nginx
service nginx start
systemctl enable nginx.service
echo "Copying files in /usr/local/bin..."
cp scripts/* /usr/local/bin
# Path to web, edit this if different 
cp api /var/www/html/api
cp SimpleBashMonitor /usr/local/bin/
#chmod a+x /usr/local/bin/*
#echo "Configuring config.json for curl comands...."
#sed -i 's/"rpc_enable": "false"/"rpc_enable": "true"/g' RaiBlocks/config.json
#sed -i 's/"enable_control": "false"/"enable_control": "true"/g' RaiBlocks/config.json
#sed -i 's/"address": "::1"/"address": "::ffff:127.0.0.1"/g' RaiBlocks/config.json
echo "Adding a crontab to  run the monitor every minute..."
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/SimpleBashMonitor") | crontab -
echo "Setup finished, edit your monitor settings:"
nano /usr/local/bin/SimpleBashMonitor
