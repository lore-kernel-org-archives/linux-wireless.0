Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54414 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYJTJ3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:29:54 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Krr5D-0006q2-EB
	for linux-wireless@vger.kernel.org; Mon, 20 Oct 2008 09:29:51 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 09:29:51 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 09:29:51 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Regression: USB Wi-Fi Device Removal Panic
Date: Mon, 20 Oct 2008 09:29:37 +0000 (UTC)
Message-ID: <gdhj21$hdq$1@ger.gmane.org> (sfid-20081020_113001_120715_6127A78E)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the compat-wireless-old-2008-10-19.tar.bz2 tarball with Ubuntu 
Hardy's 2.6.24-21-generic kernel, anytime any USB wi-fi device is 
unplugged, regardless of anything else, the kernel panics. I have 
confirmed this to occur with a zd1211b device, an rt73 device, and an 
rtl8187b device. This is especially inconvenient in the rtl8187b case, 
because after some time, that driver inexplicably stops passing any 
traffic, seemingly triggered by HTTPS access in Firefox. The panic from 
removing the rtl8187b device is attached inline, and similar backtraces 
result from removing the rt73 or the zd1211b.

[   89.719471] usb 1-1: USB disconnect, address 2
[   89.763975] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000001c
[   89.772660] printing eip: c02bc946 *pde = 00000000 
[   89.777645] Oops: 0000 [#1] SMP 
[   89.780945] Modules linked in: arc4 ecb blkcipher rtl8187 mac80211 eeprom_93cx6 cfg80211 savagefb fb_ddc i2c_algo_bit vgastate iptable_filter ip_tables x_tables omnibook video output sbs sbshc dock lp loop joydev pcmcia snd_maestro3 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss evdev parport_pc parport snd_pcm snd_page_alloc container snd_seq_dummy psmouse serio_raw battery ac button snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq intel_agp snd_timer snd_seq_device i2c_piix4 pcspkr i2c_core agpgart shpchp yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug snd soundcore jfs sg sr_mod cdrom sd_mod pata_acpi floppy tulip uhci_hcd ata_piix ata_generic usbcore libata scsi_mod thermal processor fan fbcon tileblit font bitblit softcursor fuse
[   89.850156] 
[   89.851670] Pid: 1456, comm: khubd Not tainted (2.6.24-21-generic #1)
[   89.858204] EIP: 0060:[<c02bc946>] EFLAGS: 00010286 CPU: 0
[   89.863765] EIP is at tcf_destroy+0x6/0x20
[   89.867911] EAX: cde19884 EBX: cde19884 ECX: 00000292 EDX: 00000000
[   89.874237] ESI: cde19880 EDI: ce964180 EBP: 00000000 ESP: cf8a9e44
[   89.880563]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   89.886014] Process khubd (pid: 1456, ti=cf8a8000 task=cdff0b80 task.ti=cf8a8000)
[   89.893372] Stack: 00000000 c02bc970 cde19800 d0d10eef cde19800 d0d2f7a0 d0d3c800 c02bb21a 
[   89.901998]        cea12800 ce1ca400 c02bb27a 00000000 00000001 cf8a9e78 cf8a9e78 cea12800 
[   89.910624]        c02a9d69 d0d068d8 00000000 ce1ca45c c031b488 cea12800 c02a9e18 ce964180 
[   89.919246] Call Trace:
[   89.921940]  [<c02bc970>] tcf_destroy_chain+0x10/0x20
[   89.927077]  [<d0d10eef>] wme_qdiscop_destroy+0x2f/0x80 [mac80211]
[   89.933465]  [<c02bb21a>] qdisc_destroy+0x6a/0xa0
[   89.938251]  [<c02bb27a>] dev_shutdown+0x2a/0x80
[   89.942958]  [<c02a9d69>] rollback_registered+0x99/0x140
[   89.948355]  [<d0d068d8>] ieee80211_remove_interfaces+0x48/0x80 [mac80211]
[   89.955359]  [<c031b488>] mutex_lock+0x8/0x20
[   89.959793]  [<c02a9e18>] unregister_netdevice+0x8/0x50
[   89.965102]  [<d0cf9720>] ieee80211_unregister_hw+0x30/0xd0 [mac80211]
[   89.971753]  [<d08ec9a8>] usb_disable_interface+0x28/0x40 [usbcore]
[   89.978213]  [<d0d3101d>] rtl8187_disconnect+0x1d/0x50 [rtl8187]
[   89.984323]  [<d08ef7d0>] usb_unbind_interface+0x50/0xb0 [usbcore]
[   89.990638]  [<c0282674>] __device_release_driver+0x64/0xa0
[   89.996311]  [<c0282ae3>] device_release_driver+0x23/0x40
[   90.001796]  [<c0281f4b>] bus_remove_device+0x4b/0x70
[   90.006929]  [<c0280525>] device_del+0x135/0x250
[   90.011636]  [<d08ec910>] usb_disable_device+0x80/0xf0 [usbcore]
[   90.017771]  [<d08e84e8>] usb_disconnect+0x98/0x130 [usbcore]
[   90.023653]  [<d08e9977>] hub_thread+0x447/0xcb0 [usbcore]
[   90.029304]  [<c0140b00>] autoremove_wake_function+0x0/0x40
[   90.034981]  [<d08e9530>] hub_thread+0x0/0xcb0 [usbcore]
[   90.040411]  [<c0140842>] kthread+0x42/0x70
[   90.044668]  [<c0140800>] kthread+0x0/0x70
[   90.048843]  [<c0105667>] kernel_thread_helper+0x7/0x10
[   90.054166]  =======================
[   90.057783] Code: c5 74 ec 8b 4c 24 18 89 c2 89 d8 89 34 24 ff 17 89 ea 89 c6 89 d8 ff 57 10 eb b0 8d 76 00 8d bc 27 00 00 00 00 53 8b 50 20 89 c3 <ff> 52 1c 8b 43 20 8b 40 38 e8 6c 3a e9 ff 89 d8 5b e9 34 10 ed 
[   90.078221] EIP: [<c02bc946>] tcf_destroy+0x6/0x20 SS:ESP 0068:cf8a9e44
[   90.084982] Kernel panic - not syncing: Fatal exception in interrupt

