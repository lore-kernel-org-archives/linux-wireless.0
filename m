Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:41134 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3KAVj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 17:39:57 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: BUG in rfcomm_sock_getsockopt+0x128/0x200
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <607082335.2055771383319324985.JavaMail.defaultUser@defaultHost>
Date: Fri, 1 Nov 2013 22:39:54 +0100
Cc: "linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>
Message-Id: <8BA764B1-0C68-4696-9116-9814AE47F4EE@holtmann.org> (sfid-20131101_224005_194458_3BA7B48D)
References: <607082335.2055771383319324985.JavaMail.defaultUser@defaultHost>
To: Fabio Rossi <rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabio,

>> what socket option is your client program setting? Do you happen to know that. 
> Would make it a lot easier to track this down.
> 
> Hi Marcel,
> I'm using the bluetoothd daemon at startup and it crashes as soon as the 
> dongle is inserted. To test the behaviour I removed the dongle and restart the 
> daemon with
> 
> # bluetoothd -n -d
> 
> bluetoothd[4450]: Bluetooth daemon 4.101
> bluetoothd[4450]: src/main.c:parse_config() parsing main.conf
> bluetoothd[4450]: src/main.c:parse_config() discovto=0
> bluetoothd[4450]: src/main.c:parse_config() pairto=0
> bluetoothd[4450]: src/main.c:parse_config() pageto=8192
> bluetoothd[4450]: src/main.c:parse_config() auto_to=60
> bluetoothd[4450]: src/main.c:parse_config() name=%h-%d
> bluetoothd[4450]: src/main.c:parse_config() class=0x000100
> bluetoothd[4450]: src/main.c:parse_config() Key file does not have key 
> 'DeviceID'
> bluetoothd[4450]: Starting SDP server
> bluetoothd[4450]: src/plugin.c:plugin_init() Loading builtin plugins
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading pnat plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading audio plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading input plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading serial plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading network plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading service plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading health plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading hciops plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading mgmtops plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading formfactor plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading storage plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading adaptername plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading wiimote plugin
> bluetoothd[4450]: src/plugin.c:add_plugin() Loading maemo6 plugin
> bluetoothd[4450]: src/plugin.c:plugin_init() Loading plugins 
> /usr/lib64/bluetooth/plugins
> bluetoothd[4450]: plugins/service.c:register_interface() path 
> /org/bluez/4450/any
> bluetoothd[4450]: plugins/service.c:register_interface() Registered interface 
> org.bluez.Service on path /org/bluez/4450/any
> bluetoothd[4450]: plugins/maemo6.c:maemo6_init() init maemo6 plugin
> bluetoothd[4450]: health/hdp.c:hdp_manager_start() Starting Health manager
> bluetoothd[4450]: network/manager.c:read_config() /etc/bluetooth/network.conf: 
> Key file does not have key 'DisableSecurity'
> bluetoothd[4450]: network/manager.c:read_config() Config options: 
> Security=true
> bluetoothd[4450]: input/manager.c:input_manager_init() input.conf: Key file 
> does not have key 'IdleTimeout'
> bluetoothd[4450]: audio/manager.c:audio_manager_init() audio.conf: Key file 
> does not have key 'AutoConnect'
> bluetoothd[4450]: plugins/pnat.c:pnat_init() Setup Phonet AT (DUN) plugin
> bluetoothd[4450]: plugins/hciops.c:hciops_init() 
> bluetoothd[4450]: Bluetooth Management interface initialized
> bluetoothd[4450]: Failed to open RFKILL control device
> bluetoothd[4450]: src/main.c:main() Entering main loop
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() cond 1
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() Received 12 bytes from 
> management socket
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_cmd_complete() 
> bluetoothd[4450]: plugins/mgmtops.c:read_version_complete() version 1 revision 
> 4
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() cond 1
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() Received 11 bytes from 
> management socket
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_cmd_complete() 
> 
> then I insert the dongle
> 
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() cond 1
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() Received 6 bytes from 
> management socket
> bluetoothd[4450]: plugins/mgmtops.c:add_controller() Added controller 0
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() cond 1
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_event() Received 289 bytes from 
> management socket
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_cmd_complete() 
> bluetoothd[4450]: plugins/mgmtops.c:read_info_complete() hci0 addr 00:09:DD:XX:
> XX:XX version 3 manufacturer 10 class 0x000000
> bluetoothd[4450]: plugins/mgmtops.c:read_info_complete() hci0 settings
> bluetoothd[4450]: plugins/mgmtops.c:read_info_complete() hci0 name CSR - bc4
> bluetoothd[4450]: plugins/mgmtops.c:read_info_complete() hci0 short name 
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_remove_uuid() index 0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=1
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_read_bdaddr() index 0 addr 00:09:DD:
> XX:XX:XX
> bluetoothd[4450]: src/sdpd-database.c:sdp_init_services_list() 
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_add_uuid() index 0
> bluetoothd[4450]: plugins/mgmtops.c:mgmt_add_uuid() index 0
> bluetoothd[4450]: plugins/service.c:register_interface() path 
> /org/bluez/4450/hci0
> bluetoothd[4450]: plugins/service.c:register_interface() Registered interface 
> org.bluez.Service on path /org/bluez/4450/hci0
> bluetoothd[4450]: plugins/maemo6.c:mce_probe() path /org/bluez/4450/hci0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=2
> bluetoothd[4450]: network/manager.c:network_server_probe() path 
> /org/bluez/4450/hci0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=3
> bluetoothd[4450]: network/server.c:server_register() Registered interface org.
> bluez.NetworkServer on path /org/bluez/4450/hci0
> bluetoothd[4450]: serial/manager.c:proxy_probe() path /org/bluez/4450/hci0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=4
> bluetoothd[4450]: serial/proxy.c:proxy_register() Registered interface org.
> bluez.SerialProxyManager on path /org/bluez/4450/hci0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=5
> bluetoothd[4450]: audio/manager.c:media_server_probe() path 
> /org/bluez/4450/hci0
> bluetoothd[4450]: src/adapter.c:btd_adapter_ref() 0x7f6c1794a800: ref=6
> bluetoothd[4450]: audio/manager.c:audio_adapter_ref() 0x7f6c1794b2b0: ref=1
> bluetoothd[4450]: audio/manager.c:headset_server_probe() path 
> /org/bluez/4450/hci0
> bluetoothd[4450]: audio/manager.c:audio_adapter_ref() 0x7f6c1794b2b0: ref=2
> bluetoothd[4450]: audio/manager.c:headset_server_init() audio.conf: Key file 
> does not have key 'Master'
> Killed
> 
> and I get the crash previously reported. If I use a working kernel the 
> bluetooth daemon continues its startup and the next lines are

can you quickly test a kernel build from bluetooth-next tree. I would like to see if that crashes as well. Since I have been running that one for weeks and never saw this bug.

Regards

Marcel

