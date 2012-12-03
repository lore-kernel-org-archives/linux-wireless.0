Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:8774 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2LCPSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:18:20 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: rt2500usb/ kernel 3.7+: WARNING: at net/wireless/core.c:389 wiphy_register+0x3fd/0x431 [cfg80211]()
Date: Mon, 3 Dec 2012 16:11:52 +0100
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212031611.57351.s.L-H@gmx.de> (sfid-20121203_161824_029637_DDCE2DFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Using kernel v3.7-rc7-176-g7e5530a (current mainline HEAD), I notice 
the following WARN_ON() triggering with rt2500usb and no wireless 
interface appears.

[    1.123094] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.411076] usb 1-1: New USB device found, idVendor=050d, idProduct=7050
[    1.411085] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.411090] usb 1-1: Product: Belkin 54g USB Network Adapter
[    1.411093] usb 1-1: Manufacturer: Belkin
[…]
[    5.813412] cfg80211: Calling CRDA to update world regulatory domain
[…]
[    6.299974] ------------[ cut here ]------------
[    6.300004] WARNING: at /tmp/buildd/linux-aptosid-3.7~rc7/debian/build/source_i386_none/net/wireless/core.c:389 wiphy_register+0x3fd/0x431 [cfg80211]()
[    6.300025] Hardware name: SCENIC P300
[    6.300028] Modules linked in: hid_generic rt2500usb(+) rt2x00usb rt2x00lib snd_intel8x0(+) mac80211 snd_ac97_codec ac97_bus cfg80211 snd_pcm snd_page_alloc rfkill i915 snd_seq usbhid iTCO_wdt snd_seq_device hid iTCO_vendor_support snd_timer pcspkr lpc_ich snd video i2c_algo_bit drm_kms_helper drm psmouse serio_raw parport_pc evdev shpchp pci_hotplug soundcore intel_agp parport intel_gtt i2c_i801 microcode rng_core button processor container ext4 crc16 jbd2 mbcache dm_mod sg sr_mod sd_mod crc_t10dif cdrom ata_generic pata_acpi ata_piix libata scsi_mod e100 mii uhci_hcd floppy ehci_hcd usbcore usb_common
[    6.300110] Pid: 432, comm: modprobe Not tainted 3.7-rc7-aptosid-686 #1
[    6.300113] Call Trace:
[    6.300129]  [<c012912e>] ? warn_slowpath_common+0x7c/0x8f
[    6.300140]  [<e007ec6f>] ? wiphy_register+0x3fd/0x431 [cfg80211]
[    6.300150]  [<e007ec6f>] ? wiphy_register+0x3fd/0x431 [cfg80211]
[    6.300156]  [<c012915c>] ? warn_slowpath_null+0x1b/0x1f
[    6.300166]  [<e007ec6f>] ? wiphy_register+0x3fd/0x431 [cfg80211]
[    6.300177]  [<c01b59a1>] ? __kmalloc+0x9b/0xbe
[    6.300196]  [<e04608e7>] ? ieee80211_register_hw+0x11c/0x5a4 [mac80211]
[    6.300209]  [<e0460b3b>] ? ieee80211_register_hw+0x370/0x5a4 [mac80211]
[    6.300214]  [<c01b59a1>] ? __kmalloc+0x9b/0xbe
[    6.300222]  [<e00c0fd5>] ? rt2x00lib_probe_dev+0x50f/0x5f3 [rt2x00lib]
[    6.300230]  [<dffc3bc1>] ? rt2x00usb_probe+0x186/0x196 [rt2x00usb]
[    6.300238]  [<c03c6df8>] ? _raw_spin_unlock_irqrestore+0x19/0x23
[    6.300247]  [<c02de39b>] ? __pm_runtime_set_status+0xf4/0x118
[    6.300268]  [<e00247b0>] ? usb_probe_interface+0x10b/0x18f [usbcore]
[    6.300276]  [<c02d772e>] ? driver_probe_device+0x81/0x183
[    6.300292]  [<e00242b6>] ? usb_match_id+0x15/0x43 [usbcore]
[    6.300298]  [<c02d7874>] ? __driver_attach+0x44/0x5f
[    6.300303]  [<c02d6433>] ? bus_for_each_dev+0x33/0x5d
[    6.300311]  [<c02d733d>] ? driver_attach+0x14/0x16
[    6.300315]  [<c02d7830>] ? driver_probe_device+0x183/0x183
[    6.300319]  [<c02d709a>] ? bus_add_driver+0xc9/0x1d7
[    6.300327]  [<e0017000>] ? 0xe0016fff
[    6.300332]  [<c02d7d18>] ? driver_register+0x78/0xe6
[    6.300338]  [<c019de30>] ? page_address+0x20/0x93
[    6.300345]  [<e0017000>] ? 0xe0016fff
[    6.300361]  [<e00238eb>] ? usb_register_driver+0x5a/0xf8 [usbcore]
[    6.300370]  [<c014129a>] ? notifier_call_chain+0x20/0x42
[    6.300376]  [<e0017000>] ? 0xe0016fff
[    6.300382]  [<c010119d>] ? do_one_initcall+0x7d/0x130
[    6.300388]  [<c014138e>] ? __blocking_notifier_call_chain+0x45/0x51
[    6.300395]  [<c0163499>] ? sys_init_module+0x13ff/0x15e9
[    6.300415]  [<c03c780d>] ? sysenter_do_call+0x12/0x28
[    6.300469] ---[ end trace d7860c6b8d229567 ]---
[    6.300474] phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
[    6.300629] rt2500usb: probe of 1-1:1.0 failed with error -22
[    6.300704] usbcore: registered new interface driver rt2500usb
[…]
[    6.457536] cfg80211: World regulatory domain updated:
[    6.457547] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.457551] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.457555] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.457559] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.457562] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.457566] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

There is no problem with kernel <= 3.6.9-rc1; rt61pci/ rt73usb or 
rt2800{usb,pci} are not affected by this regression.

Regards
	Stefan Lippers-Hollmann
