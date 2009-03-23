Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:53095 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbZCWXEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:04:47 -0400
Subject: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
 dereference
From: Martin Capitanio <martin@capitanio.org>
To: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 24 Mar 2009 00:04:15 +0100
Message-Id: <1237849455.16745.41.camel@marvin> (sfid-20090324_000449_669990_355D97E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=EU)
seems to be working, but afterwards inserting the rtl8187 driver causes crash:

Linux version 2.6.29-rc8, at commit 59fcbddaff6f862cc1584b488866d9c4a5579085

[   13.872135] cfg80211: Using static regulatory domain info
[   13.872177] cfg80211: Regulatory domain: EU
[   13.872209]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   13.872258]  (2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, _2000_ mBm)
[   13.872294]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   13.872329]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   13.872364]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   13.872399]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   13.872434]  (5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
...
[   14.616725] rtl8187: 8187B chip detected.
[   14.616781] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   14.616848] IP: [<ffffffffa01644d7>] wiphy_update_regulatory+0x287/0x310 [cfg80211]
[   14.616914] PGD be1e7067 PUD be10f067 PMD 0 
[   14.616973] Oops: 0000 [#1] SMP 
[   14.617024] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda9/dev
[   14.617076] CPU 0 
[   14.617111] Modules linked in: snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss rtl8187(+) snd_seq_midi snd_rawmidi joydev mac80211 uvcvideo btusb snd_seq_midi_event snd_seq eeprom_93cx6 bluetooth evdev snd_timer snd_seq_device snd cfg80211 videodev v4l1_compat v4l2_compat_ioctl32 usbhid hid video output rfkill psmouse serio_raw soundcore snd_page_alloc pcspkr input_polldev ac battery button intel_agp iTCO_wdt iTCO_vendor_support shpchp pci_hotplug sd_mod crc_t10dif sr_mod cdrom sg pata_acpi r8169 mii uhci_hcd dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan fuse
[   14.617936] Pid: 1789, comm: modprobe Not tainted 2.6.29-rc8-mc29-01 #1 Satellite L300
[   14.617982] RIP: 0010:[<ffffffffa01644d7>]  [<ffffffffa01644d7>] wiphy_update_regulatory+0x287/0x310 [cfg80211]
[   14.618047] RSP: 0018:ffff8800be0adba8  EFLAGS: 00010246
[   14.618078] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa0169a10
[   14.618111] RDX: 0000000000004e20 RSI: 000000000025e720 RDI: 0000000000000000
[   14.618146] RBP: ffff8800be0adc18 R08: 000000000053c550 R09: 0000000000000006
[   14.618180] R10: 0000000000000001 R11: ffffffffa0169998 R12: 0000000000259900
[   14.618214] R13: 000000000025c010 R14: 0000000000000006 R15: ffff8800bdd79c4c
[   14.618248] FS:  00007fa2cdcea6e0(0000) GS:ffffffff8084f080(0000) knlGS:0000000000000000
[   14.618295] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   14.618327] CR2: 0000000000000008 CR3: 00000000bd925000 CR4: 00000000000006e0
[   14.618361] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   14.618395] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   14.618430] Process modprobe (pid: 1789, threadinfo ffff8800be0ac000, task ffff8800bcc6ac00)
[   14.618478] Stack:
[   14.618503]  0000000000000002 00263540be0adc88 0000000100260e30 ffff8800bdd78080
[   14.618567]  0000000d00000000 ffff8800bdd78180 ffff8800bdd79d00 0000000065f51f72
[   14.618661]  00000000000009b4 0000000000000044 ffff8800bdd78080 ffff8800bdd78000
[   14.618778] Call Trace:
[   14.618805]  [<ffffffffa0163436>] wiphy_register+0x106/0x200 [cfg80211]
[   14.618854]  [<ffffffffa01f11cf>] ieee80211_register_hw+0x5f/0x400 [mac80211]
[   14.618908]  [<ffffffffa02534ef>] rtl8187_probe+0x5ec/0x7d5 [rtl8187]
[   14.618953]  [<ffffffff80343d89>] ? __sysfs_add_one+0x39/0xb0
[   14.619007]  [<ffffffffa024b7e0>] ? rtl8187_eeprom_register_read+0x0/0x90 [rtl8187]
[   14.619066]  [<ffffffffa024b5e0>] ? rtl8187_eeprom_register_write+0x0/0xa0 [rtl8187]
[   14.619125]  [<ffffffff804deefa>] usb_probe_interface+0xfa/0x280
[   14.619171]  [<ffffffff8049ace4>] driver_probe_device+0xc4/0x320
[   14.619214]  [<ffffffff8049af40>] ? __driver_attach+0x0/0xb0
[   14.619257]  [<ffffffff8049afeb>] __driver_attach+0xab/0xb0
[   14.619299]  [<ffffffff8049af40>] ? __driver_attach+0x0/0xb0
[   14.619341]  [<ffffffff8049a30b>] bus_for_each_dev+0x6b/0xa0
[   14.619383]  [<ffffffff8049aa21>] driver_attach+0x21/0x30
[   14.619424]  [<ffffffff804999fd>] bus_add_driver+0x15d/0x2a0
[   14.619467]  [<ffffffff8049b231>] driver_register+0x71/0x150
[   14.619510]  [<ffffffff804dec09>] usb_register_driver+0xa9/0x120
[   14.619553]  [<ffffffffa0259000>] ? rtl8187_init+0x0/0x20 [rtl8187]
[   14.619596]  [<ffffffffa025901e>] rtl8187_init+0x1e/0x20 [rtl8187]
[   14.619639]  [<ffffffff80209041>] _stext+0x41/0x170
[   14.619681]  [<ffffffff80263f28>] ? __blocking_notifier_call_chain+0x68/0x90
[   14.619728]  [<ffffffff80275715>] sys_init_module+0xb5/0x200
[   14.619770]  [<ffffffff8020c94b>] system_call_fastpath+0x16/0x1b
[   14.619813] Code: 00 0f 8e 99 fe ff ff 89 f0 2b 41 0c 89 c2 c1 fa 1f 31 d0 29 d0 3d 80 84 1e 00 41 0f 9e c2 e9 7d fe ff ff 90 48 8b 05 d1 9a 00 00 <83> 78 08 04 74 64 83 4d cc 01 8b 45 cc 41 89 47 0c e9 2c ff ff 
[   14.620519] RIP  [<ffffffffa01644d7>] wiphy_update_regulatory+0x287/0x310 [cfg80211]
[   14.620578]  RSP <ffff8800be0adba8>
[   14.620606] CR2: 0000000000000008
[   14.620694] ---[ end trace 6cd00e5f40edb2f1 ]---


without changing the regulatory domain:

[   14.101092] cfg80211: Using static regulatory domain info
[   14.101132] cfg80211: Regulatory domain: US
[   14.101161]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.101207]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[   14.101240]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.101273]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.101307]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.101340]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.101373]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   14.101406] cfg80211: Calling CRDA for country: US
...
[   14.926271] rtl8187: 8187B chip detected.
[   14.926489] wmaster0 (rtl8187): not using net_device_ops yet
[   14.926822] phy0: Selected rate control algorithm 'minstrel'
[   14.953454] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input9
[   15.401956] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.402103] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.430230] wlan0 (rtl8187): not using net_device_ops yet
[   15.430630] phy0: hwaddr , RTL8187BvE V0 + rtl8225z2
[   15.430735] usbcore: registered new interface driver rtl8187
[   16.804031] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x003ba000
[   16.863070] Adding 6144820k swap on /dev/sda6.  Priority:-1 extents:1 across:6144820k 
[   21.000066] Clocksource tsc unstable (delta = -400111373 ns)

./iw list
Wiphy phy0
	Band 1:
		Frequencies:
			* 2412 MHz [1] (27.0 dBm)
			* 2417 MHz [2] (27.0 dBm)
			* 2422 MHz [3] (27.0 dBm)
			* 2427 MHz [4] (27.0 dBm)
			* 2432 MHz [5] (27.0 dBm)
			* 2437 MHz [6] (27.0 dBm)
			* 2442 MHz [7] (27.0 dBm)
			* 2447 MHz [8] (27.0 dBm)
			* 2452 MHz [9] (27.0 dBm)
			* 2457 MHz [10] (27.0 dBm)
			* 2462 MHz [11] (27.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates:
			* 1.0 Mbps
			* 2.0 Mbps
			* 5.5 Mbps
			* 11.0 Mbps
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	Supported interface modes:
		 * Station
		 * Monitor


