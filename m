Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from be2.wartburg.edu ([216.159.168.186]:50179 "EHLO
	WARTBURG-EVS-01.wartburg.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753199AbYDXVgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 17:36:15 -0400
Message-ID: <4810F9BC.7030104@wartburg.edu> (sfid-20080424_233648_549012_71B9D19E)
Date: Thu, 24 Apr 2008 16:21:00 -0500
From: Charles Figura <charles.figura@wartburg.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems loading from compat-wireless-2008-04-24
Content-Type: multipart/mixed;
 boundary="------------020009050208040502040805"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020009050208040502040805
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Greetings -

I just tried to build, install and load the 2008-04-24 release of the
compat-wireless project.  The make and installation seemed to work just
fine (a couple of warnings, along the line of

include/asm/io_32.h: In function ‘memcpy_toio’:
include/asm/io_32.h:217: warning: passing argument 1 of ‘__memcpy’ 
discards qualifiers from pointer target type
   CC [M] 
/home/figura/compat-wireless-2008-04-24/drivers/net/wireless/rt2x00/rt2500pci.o
and
/home/figura/compat-wireless-2008-04-24/net/mac80211/wme.c:580: warning: 
initialization from incompatible pointer type
and make install showed no errors.

HOWEVER -
when I try to load the modules I get:
figura@nightfall:~/compat-wireless-2008-04-24$ sudo modprobe iwl3945
WARNING: Error inserting iwlwifi_mac80211 
(/lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/mac80211/compatible/net/mac80211/iwlwifi_mac80211.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting iwl3945 
(/lib/modules/2.6.24-16-generic/updates/wireless/iwlwifi/iwlwifi/compatible/iwl3945.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)

If I do a 'make load', I get the above plus a boatload of other similar
error messages for iwl4965, rt2x_mac80211, rt2x00lib, rt2x00pci, etc...

I've attached the relevant parts of dmesg.  Any ideas what's going on
here?

Thanks!

-- 
Charles Figura                      charles.figura@wartburg.edu
Associate Professor of Physics    http://mcsp.wartburg.edu/figura
Director, Wartburg Platte Observatory    (319) 352-8373
                                          (319) 352-8606 (fax)

--------------020009050208040502040805
Content-Type: text/plain;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

[  740.724518] iwlwifi_mac80211: disagrees about version of symbol wiphy_register
[  740.724528] iwlwifi_mac80211: Unknown symbol wiphy_register
[  740.724589] iwlwifi_mac80211: disagrees about version of symbol wiphy_new
[  740.724593] iwlwifi_mac80211: Unknown symbol wiphy_new
[  740.725608] iwlwifi_mac80211: disagrees about version of symbol wiphy_unregister
[  740.725613] iwlwifi_mac80211: Unknown symbol wiphy_unregister
[  740.726901] iwlwifi_mac80211: disagrees about version of symbol wiphy_free
[  740.726905] iwlwifi_mac80211: Unknown symbol wiphy_free
[  740.728204] iwl3945: Unknown symbol iwlwifi_ieee80211_rx_irqsafe
[  740.728335] iwl3945: Unknown symbol iwlwifi_ieee80211_get_hdrlen
[  740.728567] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_tx_status_irqsafe
[  740.728734] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_stop_queues
[  740.728832] iwl3945: Unknown symbol iwlwifi___ieee80211_get_rx_led_name
[  740.729083] iwl3945: Unknown symbol iwlwifi_ieee80211_tx_status
[  740.729173] iwl3945: Unknown symbol iwlwifi_ieee80211_rate_control_unregister
[  740.729423] iwl3945: Unknown symbol iwlwifi_ieee80211_stop_queue
[  740.729512] iwl3945: Unknown symbol iwlwifi_sta_info_put
[  740.729702] iwl3945: Unknown symbol iwlwifi_ieee80211_free_hw
[  740.729791] iwl3945: Unknown symbol iwlwifi_ieee80211_beacon_get
[  740.729892] iwl3945: Unknown symbol iwlwifi_sta_info_get
[  740.730087] iwl3945: Unknown symbol iwlwifi_ieee80211_alloc_hw
[  740.730216] iwl3945: Unknown symbol iwlwifi___ieee80211_get_tx_led_name
[  740.730305] iwl3945: Unknown symbol iwlwifi_ieee80211_scan_completed
[  740.730566] iwl3945: Unknown symbol iwlwifi_ieee80211_register_hw
[  740.730830] iwl3945: Unknown symbol iwlwifi_ieee80211_wake_queue
[  740.730924] iwl3945: Unknown symbol iwlwifi_ieee80211_rate_control_register
[  740.731089] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_register_hwmode
[  740.731469] iwl3945: Unknown symbol iwlwifi_ieee80211_unregister_hw
[  740.731620] iwl3945: Unknown symbol iwlwifi_ieee80211_start_queues
[  748.037538] ieee80211_crypt: registered algorithm 'NULL'
[  748.041239] ieee80211: 802.11 data/management/control stack, git-1.1.13
[  748.041244] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[  748.549610] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[  748.549617] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[  748.571579] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[  748.571585] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[  748.614618] usbcore: registered new interface driver usb8xxx
[  748.664834] usbcore: registered new interface driver prism54usb
[  748.705584] usbcore: registered new interface driver zd1211rw
[  748.732024] usbcore: registered new interface driver rtl8187
[  748.267222] iwlwifi_mac80211: disagrees about version of symbol wiphy_register
[  748.267230] iwlwifi_mac80211: Unknown symbol wiphy_register
[  748.267262] iwlwifi_mac80211: disagrees about version of symbol wiphy_new
[  748.267264] iwlwifi_mac80211: Unknown symbol wiphy_new
[  748.267779] iwlwifi_mac80211: disagrees about version of symbol wiphy_unregister
[  748.267782] iwlwifi_mac80211: Unknown symbol wiphy_unregister
[  748.268430] iwlwifi_mac80211: disagrees about version of symbol wiphy_free
[  748.268433] iwlwifi_mac80211: Unknown symbol wiphy_free
[  748.776147] iwl3945: Unknown symbol iwlwifi_ieee80211_rx_irqsafe
[  748.776220] iwl3945: Unknown symbol iwlwifi_ieee80211_get_hdrlen
[  748.776339] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_tx_status_irqsafe
[  748.776426] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_stop_queues
[  748.776477] iwl3945: Unknown symbol iwlwifi___ieee80211_get_rx_led_name
[  748.776600] iwl3945: Unknown symbol iwlwifi_ieee80211_tx_status
[  748.776648] iwl3945: Unknown symbol iwlwifi_ieee80211_rate_control_unregister
[  748.776779] iwl3945: Unknown symbol iwlwifi_ieee80211_stop_queue
[  748.776826] iwl3945: Unknown symbol iwlwifi_sta_info_put
[  748.776926] iwl3945: Unknown symbol iwlwifi_ieee80211_free_hw
[  748.776974] iwl3945: Unknown symbol iwlwifi_ieee80211_beacon_get
[  748.777028] iwl3945: Unknown symbol iwlwifi_sta_info_get
[  748.777128] iwl3945: Unknown symbol iwlwifi_ieee80211_alloc_hw
[  748.777195] iwl3945: Unknown symbol iwlwifi___ieee80211_get_tx_led_name
[  748.777242] iwl3945: Unknown symbol iwlwifi_ieee80211_scan_completed
[  748.777376] iwl3945: Unknown symbol iwlwifi_ieee80211_register_hw
[  748.777514] iwl3945: Unknown symbol iwlwifi_ieee80211_wake_queue
[  748.777564] iwl3945: Unknown symbol iwlwifi_ieee80211_rate_control_register
[  748.777650] iwl3945: Unknown symbol iwlwifi_iwlwifi_ieee80211_register_hwmode
[  748.777853] iwl3945: Unknown symbol iwlwifi_ieee80211_unregister_hw
[  748.777932] iwl3945: Unknown symbol iwlwifi_ieee80211_start_queues
[  748.784709] iwlwifi_mac80211: disagrees about version of symbol wiphy_register
[  748.784714] iwlwifi_mac80211: Unknown symbol wiphy_register
[  748.784747] iwlwifi_mac80211: disagrees about version of symbol wiphy_new
[  748.784749] iwlwifi_mac80211: Unknown symbol wiphy_new
[  748.785251] iwlwifi_mac80211: disagrees about version of symbol wiphy_unregister
[  748.785253] iwlwifi_mac80211: Unknown symbol wiphy_unregister
[  748.785916] iwlwifi_mac80211: disagrees about version of symbol wiphy_free
[  748.785918] iwlwifi_mac80211: Unknown symbol wiphy_free
[  748.786986] iwl4965: Unknown symbol iwlwifi_ieee80211_rx_irqsafe
[  748.787054] iwl4965: Unknown symbol iwlwifi_ieee80211_get_hdrlen
[  748.787186] iwl4965: Unknown symbol iwlwifi_iwlwifi_ieee80211_tx_status_irqsafe
[  748.787273] iwl4965: Unknown symbol iwlwifi_iwlwifi_ieee80211_stop_queues
[  748.787324] iwl4965: Unknown symbol iwlwifi___ieee80211_get_rx_led_name
[  748.787446] iwl4965: Unknown symbol iwlwifi_ieee80211_tx_status
[  748.787495] iwl4965: Unknown symbol iwlwifi_ieee80211_rate_control_unregister
[  748.787626] iwl4965: Unknown symbol iwlwifi_ieee80211_stop_queue
[  748.787673] iwl4965: Unknown symbol iwlwifi_sta_info_put
[  748.787771] iwl4965: Unknown symbol iwlwifi_ieee80211_free_hw
[  748.787818] iwl4965: Unknown symbol iwlwifi_ieee80211_beacon_get
[  748.787871] iwl4965: Unknown symbol iwlwifi_sta_info_get
[  748.787986] iwl4965: Unknown symbol iwlwifi_ieee80211_alloc_hw
[  748.788053] iwl4965: Unknown symbol iwlwifi___ieee80211_get_tx_led_name
[  748.788100] iwl4965: Unknown symbol iwlwifi_ieee80211_scan_completed
[  748.788234] iwl4965: Unknown symbol iwlwifi_ieee80211_register_hw
[  748.788410] iwl4965: Unknown symbol iwlwifi_ieee80211_wake_queue
[  748.788459] iwl4965: Unknown symbol iwlwifi_ieee80211_rate_control_register
[  748.788545] iwl4965: Unknown symbol iwlwifi_iwlwifi_ieee80211_register_hwmode
[  748.788764] iwl4965: Unknown symbol iwlwifi_ieee80211_unregister_hw
[  748.788842] iwl4965: Unknown symbol iwlwifi_ieee80211_start_queues
[  748.854565] sysfs: duplicate filename 'ieee80211' can not be created
[  748.854571] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 sysfs_add_one()
[  748.854575] Pid: 16390, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.854584]  [<c01d29af>] sysfs_add_one+0x9f/0xe0
[  748.854600]  [<c01d2ee8>] create_dir+0x48/0x90
[  748.854609]  [<c01d2f59>] sysfs_create_dir+0x29/0x50
[  748.854613]  [<c021098f>] kobject_get+0xf/0x20
[  748.854618]  [<c0210e53>] kobject_add+0x93/0x1b0
[  748.854623]  [<c021098f>] kobject_get+0xf/0x20
[  748.854629]  [<c0210fa1>] kset_register+0x21/0x50
[  748.854633]  [<c027e82f>] class_register+0x9f/0x140
[  748.854644]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.854652]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.854686]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.854701]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.854716]  =======================
[  748.854719] kobject_add failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.
[  748.854724] Pid: 16390, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.854728]  [<c0210ed3>] kobject_add+0x113/0x1b0
[  748.854733]  [<c021098f>] kobject_get+0xf/0x20
[  748.854740]  [<c0210fa1>] kset_register+0x21/0x50
[  748.854745]  [<c027e82f>] class_register+0x9f/0x140
[  748.854755]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.854762]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.854794]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.854807]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.854822]  =======================
[  748.376105] rt2x_mac80211: Unknown symbol rt2x_wiphy_free
[  748.376224] rt2x_mac80211: Unknown symbol rt2x___ieee80211_get_channel
[  748.376668] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_init
[  748.376760] rt2x_mac80211: Unknown symbol rt2x_wiphy_register
[  748.376990] rt2x_mac80211: Unknown symbol rt2x_wiphy_new
[  748.377414] rt2x_mac80211: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.377550] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_next
[  748.377894] rt2x_mac80211: Unknown symbol rt2x_wiphy_unregister
[  748.378009] rt2x_mac80211: Unknown symbol rt2x_ieee80211_frequency_to_channel
[  748.887964] rt2x00lib: Unknown symbol rt2x_ieee80211_iterate_active_interfaces
[  748.888060] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queues
[  748.888108] rt2x00lib: Unknown symbol rt2x_ieee80211_rts_get
[  748.888157] rt2x00lib: Unknown symbol rt2x_ieee80211_beacon_get
[  748.888203] rt2x00lib: Unknown symbol rt2x_ieee80211_ctstoself_get
[  748.888281] rt2x00lib: Unknown symbol rt2x_ieee80211_register_hw
[  748.888414] rt2x00lib: Unknown symbol rt2x_ieee80211_tx_status_irqsafe
[  748.888481] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queue
[  748.888531] rt2x00lib: Unknown symbol rt2x_ieee80211_start_queues
[  748.888578] rt2x00lib: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.888674] rt2x00lib: Unknown symbol rt2x_ieee80211_rx_irqsafe
[  748.888866] rt2x00lib: Unknown symbol rt2x_ieee80211_unregister_hw
[  748.889636] rt2x00pci: Unknown symbol rt2x_ieee80211_wake_queue
[  748.889682] rt2x00pci: Unknown symbol rt2x00lib_suspend
[  748.889729] rt2x00pci: Unknown symbol rt2x00lib_probe_dev
[  748.889790] rt2x00pci: Unknown symbol rt2x_ieee80211_get_hdrlen
[  748.889891] rt2x00pci: Unknown symbol rt2x00lib_rxdone
[  748.889937] rt2x00pci: Unknown symbol rt2x00queue_get_entry
[  748.890003] rt2x00pci: Unknown symbol rt2x00lib_remove_dev
[  748.890084] rt2x00pci: Unknown symbol rt2x00lib_txdone
[  748.890133] rt2x00pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.890225] rt2x00pci: Unknown symbol rt2x_ieee80211_free_hw
[  748.890286] rt2x00pci: Unknown symbol rt2x00lib_resume
[  748.890332] rt2x00pci: Unknown symbol rt2x00queue_index_inc
[  748.890399] rt2x00pci: Unknown symbol rt2x_ieee80211_alloc_hw
[  748.891192] rt2400pci: Unknown symbol rt2x00mac_add_interface
[  748.891240] rt2400pci: Unknown symbol rt2x00mac_get_stats
[  748.891301] rt2400pci: Unknown symbol rt2x00pci_initialize
[  748.891362] rt2400pci: Unknown symbol rt2x00pci_uninitialize
[  748.891409] rt2400pci: Unknown symbol rt2x00queue_get_entry
[  748.891455] rt2400pci: Unknown symbol rt2x00pci_suspend
[  748.891501] rt2400pci: Unknown symbol rt2x00mac_config_interface
[  748.891547] rt2400pci: Unknown symbol rt2x00pci_remove
[  748.891594] rt2400pci: Unknown symbol rt2x00mac_remove_interface
[  748.891640] rt2400pci: Unknown symbol rt2x00mac_config
[  748.891686] rt2400pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.891734] rt2400pci: Unknown symbol rt2x00queue_get_queue
[  748.891780] rt2400pci: Unknown symbol rt2x00mac_conf_tx
[  748.891855] rt2400pci: Unknown symbol rt2x00mac_start
[  748.891901] rt2400pci: Unknown symbol rt2x00pci_txdone
[  748.891947] rt2400pci: Unknown symbol rt2x00mac_stop
[  748.891996] rt2400pci: Unknown symbol rt2x00mac_configure_filter
[  748.892042] rt2400pci: Unknown symbol rt2x00mac_tx
[  748.892088] rt2400pci: Unknown symbol rt2x00pci_resume
[  748.892146] rt2400pci: Unknown symbol rt2x00pci_probe
[  748.892193] rt2400pci: Unknown symbol rt2x00mac_get_tx_stats
[  748.892255] rt2400pci: Unknown symbol rt2x00pci_rxdone
[  748.892301] rt2400pci: Unknown symbol rt2x00lib_beacondone
[  748.892350] rt2400pci: Unknown symbol rt2x00mac_bss_info_changed
[  748.892396] rt2400pci: Unknown symbol rt2x00pci_write_tx_data
[  748.420683] sysfs: duplicate filename 'ieee80211' can not be created
[  748.420690] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 sysfs_add_one()
[  748.420695] Pid: 16403, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.420714]  [<c01d29af>] sysfs_add_one+0x9f/0xe0
[  748.420731]  [<c01d2ee8>] create_dir+0x48/0x90
[  748.420743]  [<c01d2f59>] sysfs_create_dir+0x29/0x50
[  748.420749]  [<c021098f>] kobject_get+0xf/0x20
[  748.420754]  [<c0210e53>] kobject_add+0x93/0x1b0
[  748.420761]  [<c021098f>] kobject_get+0xf/0x20
[  748.420769]  [<c0210fa1>] kset_register+0x21/0x50
[  748.420774]  [<c027e82f>] class_register+0x9f/0x140
[  748.420787]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.420796]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.420837]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.420853]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.420870]  =======================
[  748.420873] kobject_add failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.
[  748.420878] Pid: 16403, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.420882]  [<c0210ed3>] kobject_add+0x113/0x1b0
[  748.420888]  [<c021098f>] kobject_get+0xf/0x20
[  748.420895]  [<c0210fa1>] kset_register+0x21/0x50
[  748.420900]  [<c027e82f>] class_register+0x9f/0x140
[  748.420910]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.420916]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.420950]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.420963]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.420978]  =======================
[  748.453459] rt2x_mac80211: Unknown symbol rt2x_wiphy_free
[  748.453582] rt2x_mac80211: Unknown symbol rt2x___ieee80211_get_channel
[  748.454032] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_init
[  748.454130] rt2x_mac80211: Unknown symbol rt2x_wiphy_register
[  748.454347] rt2x_mac80211: Unknown symbol rt2x_wiphy_new
[  748.454778] rt2x_mac80211: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.454915] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_next
[  748.455258] rt2x_mac80211: Unknown symbol rt2x_wiphy_unregister
[  748.455384] rt2x_mac80211: Unknown symbol rt2x_ieee80211_frequency_to_channel
[  748.456774] rt2x00lib: Unknown symbol rt2x_ieee80211_iterate_active_interfaces
[  748.456869] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queues
[  748.456916] rt2x00lib: Unknown symbol rt2x_ieee80211_rts_get
[  748.456965] rt2x00lib: Unknown symbol rt2x_ieee80211_beacon_get
[  748.457012] rt2x00lib: Unknown symbol rt2x_ieee80211_ctstoself_get
[  748.457090] rt2x00lib: Unknown symbol rt2x_ieee80211_register_hw
[  748.457223] rt2x00lib: Unknown symbol rt2x_ieee80211_tx_status_irqsafe
[  748.457289] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queue
[  748.457342] rt2x00lib: Unknown symbol rt2x_ieee80211_start_queues
[  748.457388] rt2x00lib: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.457483] rt2x00lib: Unknown symbol rt2x_ieee80211_rx_irqsafe
[  748.457675] rt2x00lib: Unknown symbol rt2x_ieee80211_unregister_hw
[  748.458205] rt2x00pci: Unknown symbol rt2x_ieee80211_wake_queue
[  748.458252] rt2x00pci: Unknown symbol rt2x00lib_suspend
[  748.458298] rt2x00pci: Unknown symbol rt2x00lib_probe_dev
[  748.458360] rt2x00pci: Unknown symbol rt2x_ieee80211_get_hdrlen
[  748.458461] rt2x00pci: Unknown symbol rt2x00lib_rxdone
[  748.458508] rt2x00pci: Unknown symbol rt2x00queue_get_entry
[  748.458573] rt2x00pci: Unknown symbol rt2x00lib_remove_dev
[  748.458655] rt2x00pci: Unknown symbol rt2x00lib_txdone
[  748.458704] rt2x00pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.458796] rt2x00pci: Unknown symbol rt2x_ieee80211_free_hw
[  748.458857] rt2x00pci: Unknown symbol rt2x00lib_resume
[  748.458905] rt2x00pci: Unknown symbol rt2x00queue_index_inc
[  748.458971] rt2x00pci: Unknown symbol rt2x_ieee80211_alloc_hw
[  748.459438] rt2500pci: Unknown symbol rt2x00mac_add_interface
[  748.459485] rt2500pci: Unknown symbol rt2x00mac_get_stats
[  748.459546] rt2500pci: Unknown symbol rt2x00pci_initialize
[  748.459607] rt2500pci: Unknown symbol rt2x00pci_uninitialize
[  748.459655] rt2500pci: Unknown symbol rt2x00queue_get_entry
[  748.459701] rt2500pci: Unknown symbol rt2x00pci_suspend
[  748.459747] rt2500pci: Unknown symbol rt2x00mac_config_interface
[  748.459794] rt2500pci: Unknown symbol rt2x00pci_remove
[  748.459841] rt2500pci: Unknown symbol rt2x00mac_remove_interface
[  748.459887] rt2500pci: Unknown symbol rt2x00mac_config
[  748.459933] rt2500pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.459979] rt2500pci: Unknown symbol rt2x00queue_get_queue
[  748.460026] rt2500pci: Unknown symbol rt2x00mac_conf_tx
[  748.460102] rt2500pci: Unknown symbol rt2x00mac_start
[  748.460148] rt2500pci: Unknown symbol rt2x00pci_txdone
[  748.460194] rt2500pci: Unknown symbol rt2x00mac_stop
[  748.460242] rt2500pci: Unknown symbol rt2x00mac_configure_filter
[  748.460289] rt2500pci: Unknown symbol rt2x00mac_tx
[  748.460336] rt2500pci: Unknown symbol rt2x00pci_resume
[  748.460394] rt2500pci: Unknown symbol rt2x00pci_probe
[  748.460441] rt2500pci: Unknown symbol rt2x00mac_get_tx_stats
[  748.460503] rt2500pci: Unknown symbol rt2x00pci_rxdone
[  748.460549] rt2500pci: Unknown symbol rt2x00lib_beacondone
[  748.460598] rt2500pci: Unknown symbol rt2x00mac_bss_info_changed
[  748.460645] rt2500pci: Unknown symbol rt2x00pci_write_tx_data
[  748.484284] sysfs: duplicate filename 'ieee80211' can not be created
[  748.484289] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 sysfs_add_one()
[  748.484293] Pid: 16411, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.484311]  [<c01d29af>] sysfs_add_one+0x9f/0xe0
[  748.484328]  [<c01d2ee8>] create_dir+0x48/0x90
[  748.484342]  [<c01d2f59>] sysfs_create_dir+0x29/0x50
[  748.484349]  [<c021098f>] kobject_get+0xf/0x20
[  748.484355]  [<c0210e53>] kobject_add+0x93/0x1b0
[  748.484362]  [<c021098f>] kobject_get+0xf/0x20
[  748.484370]  [<c0210fa1>] kset_register+0x21/0x50
[  748.484376]  [<c027e82f>] class_register+0x9f/0x140
[  748.484389]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.484398]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.484441]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.484458]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.484476]  =======================
[  748.484479] kobject_add failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.
[  748.484484] Pid: 16411, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.484489]  [<c0210ed3>] kobject_add+0x113/0x1b0
[  748.484495]  [<c021098f>] kobject_get+0xf/0x20
[  748.484502]  [<c0210fa1>] kset_register+0x21/0x50
[  748.484507]  [<c027e82f>] class_register+0x9f/0x140
[  748.484518]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.484525]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.484566]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.484582]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.484599]  =======================
[  748.496631] rt2x_mac80211: Unknown symbol rt2x_wiphy_free
[  748.496753] rt2x_mac80211: Unknown symbol rt2x___ieee80211_get_channel
[  748.497195] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_init
[  748.497290] rt2x_mac80211: Unknown symbol rt2x_wiphy_register
[  748.497500] rt2x_mac80211: Unknown symbol rt2x_wiphy_new
[  748.497923] rt2x_mac80211: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.498061] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_next
[  748.498403] rt2x_mac80211: Unknown symbol rt2x_wiphy_unregister
[  748.498518] rt2x_mac80211: Unknown symbol rt2x_ieee80211_frequency_to_channel
[  748.499855] rt2x00lib: Unknown symbol rt2x_ieee80211_iterate_active_interfaces
[  748.499950] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queues
[  748.499997] rt2x00lib: Unknown symbol rt2x_ieee80211_rts_get
[  748.500047] rt2x00lib: Unknown symbol rt2x_ieee80211_beacon_get
[  748.500093] rt2x00lib: Unknown symbol rt2x_ieee80211_ctstoself_get
[  748.500171] rt2x00lib: Unknown symbol rt2x_ieee80211_register_hw
[  748.500314] rt2x00lib: Unknown symbol rt2x_ieee80211_tx_status_irqsafe
[  748.500381] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queue
[  748.500432] rt2x00lib: Unknown symbol rt2x_ieee80211_start_queues
[  748.500478] rt2x00lib: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.500573] rt2x00lib: Unknown symbol rt2x_ieee80211_rx_irqsafe
[  748.500767] rt2x00lib: Unknown symbol rt2x_ieee80211_unregister_hw
[  748.501541] rt2x00pci: Unknown symbol rt2x_ieee80211_wake_queue
[  748.501589] rt2x00pci: Unknown symbol rt2x00lib_suspend
[  748.501635] rt2x00pci: Unknown symbol rt2x00lib_probe_dev
[  748.501696] rt2x00pci: Unknown symbol rt2x_ieee80211_get_hdrlen
[  748.501799] rt2x00pci: Unknown symbol rt2x00lib_rxdone
[  748.501845] rt2x00pci: Unknown symbol rt2x00queue_get_entry
[  748.501910] rt2x00pci: Unknown symbol rt2x00lib_remove_dev
[  748.501990] rt2x00pci: Unknown symbol rt2x00lib_txdone
[  748.502038] rt2x00pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.502130] rt2x00pci: Unknown symbol rt2x_ieee80211_free_hw
[  748.502190] rt2x00pci: Unknown symbol rt2x00lib_resume
[  748.502236] rt2x00pci: Unknown symbol rt2x00queue_index_inc
[  748.502303] rt2x00pci: Unknown symbol rt2x_ieee80211_alloc_hw
[  748.507002] rt61pci: Unknown symbol rt2x00mac_add_interface
[  748.507081] rt61pci: Unknown symbol rt2x00mac_get_stats
[  748.507143] rt61pci: Unknown symbol rt2x00pci_initialize
[  748.507274] rt61pci: Unknown symbol rt2x00pci_uninitialize
[  748.507321] rt61pci: Unknown symbol rt2x00queue_get_entry
[  748.507381] rt61pci: Unknown symbol rt2x00pci_suspend
[  748.507428] rt61pci: Unknown symbol rt2x00mac_config_interface
[  748.507476] rt61pci: Unknown symbol rt2x00pci_remove
[  748.507524] rt61pci: Unknown symbol rt2x00mac_remove_interface
[  748.507572] rt61pci: Unknown symbol rt2x00mac_config
[  748.507618] rt61pci: Unknown symbol rt2x00lib_write_tx_desc
[  748.507664] rt61pci: Unknown symbol rt2x00queue_get_queue
[  748.507712] rt61pci: Unknown symbol rt2x00mac_conf_tx
[  748.507789] rt61pci: Unknown symbol rt2x00mac_start
[  748.507836] rt61pci: Unknown symbol rt2x00pci_txdone
[  748.507884] rt61pci: Unknown symbol rt2x00mac_stop
[  748.507933] rt61pci: Unknown symbol rt2x00mac_configure_filter
[  748.507979] rt61pci: Unknown symbol rt2x00mac_tx
[  748.508025] rt61pci: Unknown symbol rt2x00pci_resume
[  748.508084] rt61pci: Unknown symbol rt2x00pci_probe
[  748.508130] rt61pci: Unknown symbol rt2x00mac_get_tx_stats
[  748.508222] rt61pci: Unknown symbol rt2x00pci_rxdone
[  748.508271] rt61pci: Unknown symbol rt2x00mac_bss_info_changed
[  748.508319] rt61pci: Unknown symbol rt2x00pci_write_tx_data
[  748.530881] sysfs: duplicate filename 'ieee80211' can not be created
[  748.530887] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 sysfs_add_one()
[  748.530890] Pid: 16420, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.530899]  [<c01d29af>] sysfs_add_one+0x9f/0xe0
[  748.530913]  [<c01d2ee8>] create_dir+0x48/0x90
[  748.530924]  [<c01d2f59>] sysfs_create_dir+0x29/0x50
[  748.530928]  [<c021098f>] kobject_get+0xf/0x20
[  748.530933]  [<c0210e53>] kobject_add+0x93/0x1b0
[  748.530939]  [<c021098f>] kobject_get+0xf/0x20
[  748.530946]  [<c0210fa1>] kset_register+0x21/0x50
[  748.530950]  [<c027e82f>] class_register+0x9f/0x140
[  748.530963]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.530970]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.531013]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.531031]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.531050]  =======================
[  748.531053] kobject_add failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.
[  748.531058] Pid: 16420, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.531062]  [<c0210ed3>] kobject_add+0x113/0x1b0
[  748.531068]  [<c021098f>] kobject_get+0xf/0x20
[  748.531075]  [<c0210fa1>] kset_register+0x21/0x50
[  748.531080]  [<c027e82f>] class_register+0x9f/0x140
[  748.531091]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.531097]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.531136]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.531151]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.531177]  =======================
[  748.552432] rt2x_mac80211: Unknown symbol rt2x_wiphy_free
[  748.552554] rt2x_mac80211: Unknown symbol rt2x___ieee80211_get_channel
[  748.552998] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_init
[  748.553091] rt2x_mac80211: Unknown symbol rt2x_wiphy_register
[  748.553303] rt2x_mac80211: Unknown symbol rt2x_wiphy_new
[  748.553727] rt2x_mac80211: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.553863] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_next
[  748.554204] rt2x_mac80211: Unknown symbol rt2x_wiphy_unregister
[  748.554319] rt2x_mac80211: Unknown symbol rt2x_ieee80211_frequency_to_channel
[  748.555147] rt2x00lib: Unknown symbol rt2x_ieee80211_iterate_active_interfaces
[  748.555240] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queues
[  748.555287] rt2x00lib: Unknown symbol rt2x_ieee80211_rts_get
[  748.555336] rt2x00lib: Unknown symbol rt2x_ieee80211_beacon_get
[  748.555382] rt2x00lib: Unknown symbol rt2x_ieee80211_ctstoself_get
[  748.555460] rt2x00lib: Unknown symbol rt2x_ieee80211_register_hw
[  748.555593] rt2x00lib: Unknown symbol rt2x_ieee80211_tx_status_irqsafe
[  748.555664] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queue
[  748.555715] rt2x00lib: Unknown symbol rt2x_ieee80211_start_queues
[  748.555761] rt2x00lib: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.555856] rt2x00lib: Unknown symbol rt2x_ieee80211_rx_irqsafe
[  748.556050] rt2x00lib: Unknown symbol rt2x_ieee80211_unregister_hw
[  748.556602] rt2x00usb: Unknown symbol rt2x_ieee80211_wake_queue
[  748.556649] rt2x00usb: Unknown symbol rt2x00lib_suspend
[  748.556697] rt2x00usb: Unknown symbol rt2x00lib_probe_dev
[  748.556886] rt2x00usb: Unknown symbol rt2x00lib_rxdone
[  748.556933] rt2x00usb: Unknown symbol rt2x00queue_get_entry
[  748.557091] rt2x00usb: Unknown symbol rt2x00lib_remove_dev
[  748.557158] rt2x00usb: Unknown symbol rt2x00lib_txdone
[  748.557206] rt2x00usb: Unknown symbol rt2x00lib_write_tx_desc
[  748.557306] rt2x00usb: Unknown symbol rt2x_ieee80211_free_hw
[  748.557356] rt2x00usb: Unknown symbol rt2x00lib_resume
[  748.557447] rt2x00usb: Unknown symbol rt2x00queue_index_inc
[  748.557494] rt2x00usb: Unknown symbol rt2x_ieee80211_get_hdrlen_from_skb
[  748.557565] rt2x00usb: Unknown symbol rt2x_ieee80211_alloc_hw
[  748.558021] rt2500usb: Unknown symbol rt2x00mac_add_interface
[  748.558069] rt2500usb: Unknown symbol rt2x00mac_get_stats
[  748.558116] rt2500usb: Unknown symbol rt2x00usb_init_rxentry
[  748.558209] rt2500usb: Unknown symbol rt2x00usb_disable_radio
[  748.558257] rt2500usb: Unknown symbol rt2x00usb_init_txentry
[  748.558304] rt2500usb: Unknown symbol rt2x00usb_vendor_request_buff
[  748.558433] rt2500usb: Unknown symbol rt2x00usb_write_tx_data
[  748.558480] rt2500usb: Unknown symbol rt2x00mac_config_interface
[  748.558528] rt2500usb: Unknown symbol rt2x00mac_remove_interface
[  748.558576] rt2500usb: Unknown symbol rt2x00usb_vendor_request
[  748.558623] rt2500usb: Unknown symbol rt2x00usb_probe
[  748.558670] rt2500usb: Unknown symbol rt2x00mac_config
[  748.558718] rt2500usb: Unknown symbol rt2x00lib_write_tx_desc
[  748.558769] rt2500usb: Unknown symbol rt2x00usb_suspend
[  748.558816] rt2500usb: Unknown symbol rt2x00mac_conf_tx
[  748.558864] rt2500usb: Unknown symbol rt2x00mac_start
[  748.558912] rt2500usb: Unknown symbol rt2x00mac_stop
[  748.559006] rt2500usb: Unknown symbol rt2x00mac_configure_filter
[  748.559053] rt2500usb: Unknown symbol rt2x00usb_disconnect
[  748.559101] rt2500usb: Unknown symbol rt2x00mac_tx
[  748.559170] rt2500usb: Unknown symbol rt2x00usb_vendor_req_buff_lock
[  748.559218] rt2500usb: Unknown symbol rt2x00mac_get_tx_stats
[  748.559281] rt2500usb: Unknown symbol rt2x00usb_resume
[  748.559329] rt2500usb: Unknown symbol rt2x00usb_uninitialize
[  748.559376] rt2500usb: Unknown symbol rt2x00usb_initialize
[  748.559426] rt2500usb: Unknown symbol rt2x00mac_bss_info_changed
[  748.581682] sysfs: duplicate filename 'ieee80211' can not be created
[  748.581688] WARNING: at /build/buildd/linux-2.6.24/fs/sysfs/dir.c:424 sysfs_add_one()
[  748.581693] Pid: 16427, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.581702]  [<c01d29af>] sysfs_add_one+0x9f/0xe0
[  748.581718]  [<c01d2ee8>] create_dir+0x48/0x90
[  748.581730]  [<c01d2f59>] sysfs_create_dir+0x29/0x50
[  748.581737]  [<c021098f>] kobject_get+0xf/0x20
[  748.581743]  [<c0210e53>] kobject_add+0x93/0x1b0
[  748.581751]  [<c021098f>] kobject_get+0xf/0x20
[  748.581759]  [<c0210fa1>] kset_register+0x21/0x50
[  748.581765]  [<c027e82f>] class_register+0x9f/0x140
[  748.581779]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.581788]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.581835]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.581855]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.581876]  =======================
[  748.581881] kobject_add failed for ieee80211 with -EEXIST, don't try to register things with the same name in the same directory.
[  748.581886] Pid: 16427, comm: modprobe Not tainted 2.6.24-16-generic #1
[  748.581892]  [<c0210ed3>] kobject_add+0x113/0x1b0
[  748.581900]  [<c021098f>] kobject_get+0xf/0x20
[  748.581908]  [<c0210fa1>] kset_register+0x21/0x50
[  748.581914]  [<c027e82f>] class_register+0x9f/0x140
[  748.581927]  [<f900b146>] rt2x_cfg80211_init+0x6/0x60 [rt2x_cfg80211]
[  748.581935]  [<c01506b6>] sys_init_module+0x126/0x19c0
[  748.581974]  [<c0189f90>] __kmalloc+0x0/0x110
[  748.581989]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
[  748.582007]  =======================
[  748.604513] rt2x_mac80211: Unknown symbol rt2x_wiphy_free
[  748.604636] rt2x_mac80211: Unknown symbol rt2x___ieee80211_get_channel
[  748.605079] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_init
[  748.605172] rt2x_mac80211: Unknown symbol rt2x_wiphy_register
[  748.605383] rt2x_mac80211: Unknown symbol rt2x_wiphy_new
[  748.605807] rt2x_mac80211: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.605945] rt2x_mac80211: Unknown symbol rt2x_ieee80211_radiotap_iterator_next
[  748.606286] rt2x_mac80211: Unknown symbol rt2x_wiphy_unregister
[  748.606401] rt2x_mac80211: Unknown symbol rt2x_ieee80211_frequency_to_channel
[  748.608239] rt2x00lib: Unknown symbol rt2x_ieee80211_iterate_active_interfaces
[  748.608333] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queues
[  748.608380] rt2x00lib: Unknown symbol rt2x_ieee80211_rts_get
[  748.608429] rt2x00lib: Unknown symbol rt2x_ieee80211_beacon_get
[  748.608476] rt2x00lib: Unknown symbol rt2x_ieee80211_ctstoself_get
[  748.608554] rt2x00lib: Unknown symbol rt2x_ieee80211_register_hw
[  748.608687] rt2x00lib: Unknown symbol rt2x_ieee80211_tx_status_irqsafe
[  748.608754] rt2x00lib: Unknown symbol rt2x_ieee80211_stop_queue
[  748.608805] rt2x00lib: Unknown symbol rt2x_ieee80211_start_queues
[  748.608852] rt2x00lib: Unknown symbol rt2x_ieee80211_channel_to_frequency
[  748.608948] rt2x00lib: Unknown symbol rt2x_ieee80211_rx_irqsafe
[  748.609141] rt2x00lib: Unknown symbol rt2x_ieee80211_unregister_hw
[  748.609722] rt2x00usb: Unknown symbol rt2x_ieee80211_wake_queue
[  748.609770] rt2x00usb: Unknown symbol rt2x00lib_suspend
[  748.609818] rt2x00usb: Unknown symbol rt2x00lib_probe_dev
[  748.610005] rt2x00usb: Unknown symbol rt2x00lib_rxdone
[  748.610052] rt2x00usb: Unknown symbol rt2x00queue_get_entry
[  748.610210] rt2x00usb: Unknown symbol rt2x00lib_remove_dev
[  748.610276] rt2x00usb: Unknown symbol rt2x00lib_txdone
[  748.610322] rt2x00usb: Unknown symbol rt2x00lib_write_tx_desc
[  748.610421] rt2x00usb: Unknown symbol rt2x_ieee80211_free_hw
[  748.610471] rt2x00usb: Unknown symbol rt2x00lib_resume
[  748.610560] rt2x00usb: Unknown symbol rt2x00queue_index_inc
[  748.610607] rt2x00usb: Unknown symbol rt2x_ieee80211_get_hdrlen_from_skb
[  748.610677] rt2x00usb: Unknown symbol rt2x_ieee80211_alloc_hw
[  748.613176] rt73usb: Unknown symbol rt2x00mac_add_interface
[  748.613255] rt73usb: Unknown symbol rt2x00mac_get_stats
[  748.613303] rt73usb: Unknown symbol rt2x00usb_init_rxentry
[  748.613395] rt73usb: Unknown symbol rt2x00usb_disable_radio
[  748.613446] rt73usb: Unknown symbol rt2x00usb_init_txentry
[  748.613493] rt73usb: Unknown symbol rt2x00usb_vendor_request_buff
[  748.613565] rt73usb: Unknown symbol rt2x00usb_write_tx_data
[  748.613611] rt73usb: Unknown symbol rt2x00mac_config_interface
[  748.613658] rt73usb: Unknown symbol rt2x00mac_remove_interface
[  748.613704] rt73usb: Unknown symbol rt2x00usb_vendor_request
[  748.613751] rt73usb: Unknown symbol rt2x00usb_probe
[  748.613797] rt73usb: Unknown symbol rt2x00mac_config
[  748.613843] rt73usb: Unknown symbol rt2x00lib_write_tx_desc
[  748.613894] rt73usb: Unknown symbol rt2x00usb_suspend
[  748.613940] rt73usb: Unknown symbol rt2x00mac_conf_tx
[  748.613986] rt73usb: Unknown symbol rt2x00mac_start
[  748.614033] rt73usb: Unknown symbol rt2x00mac_stop
[  748.614126] rt73usb: Unknown symbol rt2x00mac_configure_filter
[  748.614173] rt73usb: Unknown symbol rt2x00usb_disconnect
[  748.614219] rt73usb: Unknown symbol rt2x00mac_tx
[  748.614281] rt73usb: Unknown symbol rt2x00usb_vendor_req_buff_lock
[  748.614328] rt73usb: Unknown symbol rt2x00mac_get_tx_stats
[  748.614390] rt73usb: Unknown symbol rt2x00usb_resume
[  748.614466] rt73usb: Unknown symbol rt2x00usb_uninitialize
[  748.614513] rt73usb: Unknown symbol rt2x00usb_initialize
[  748.614568] rt73usb: Unknown symbol rt2x00mac_bss_info_changed
[  748.624894] usbcore: registered new interface driver cdc_ether
[  748.626843] usbcore: registered new interface driver rndis_host
[  749.136824] usbcore: registered new interface driver rndis_wlan
[  749.144194] Atmel at76x USB Wireless LAN Driver 0.17 loading
[  749.144236] usbcore: registered new interface driver at76_usb
[  753.373652] Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
[  753.400912] Broadcom 43xx-legacy driver loaded [ Features: PID, Firmware-ID: FW10 ]


--------------020009050208040502040805--
