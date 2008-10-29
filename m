Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail10.dslextreme.com ([66.51.199.98]:49148 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752392AbYJ2X5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:57:16 -0400
Subject: Re: Regression: USB Wi-Fi Device Removal Panic
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200810201159.12344.mb@bu3sch.de>
References: <gdhj21$hdq$1@ger.gmane.org>  <200810201159.12344.mb@bu3sch.de>
Content-Type: multipart/mixed; boundary="=-51DHSm1bOhXFj+gZ1iSC"
Date: Wed, 29 Oct 2008 16:48:50 -0700
Message-Id: <1225324130.7541.1.camel@the-omnibook> (sfid-20081030_005719_338005_FDC365C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-51DHSm1bOhXFj+gZ1iSC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-10-20 at 11:59 +0200, Michael Buesch wrote:
> On Monday 20 October 2008 11:29:37 Daniel Gimpelevich wrote:
> > Using the compat-wireless-old-2008-10-19.tar.bz2 tarball with Ubuntu 
> > Hardy's 2.6.24-21-generic kernel, anytime any USB wi-fi device is 
> > unplugged, regardless of anything else, the kernel panics. I have 
> > confirmed this to occur with a zd1211b device, an rt73 device, and an 
> > rtl8187b device. This is especially inconvenient in the rtl8187b case, 
> > because after some time, that driver inexplicably stops passing any 
> > traffic, seemingly triggered by HTTPS access in Firefox. The panic from 
> > removing the rtl8187b device is attached inline, and similar backtraces 
> > result from removing the rt73 or the zd1211b.
> 
> Any chance you can post a backtrace for zd1211?
> I reported a crash-on-pull issue earlier. Just want to check if this is
> a different one or the same.

Not sure whether you're still interested, but here it is.

--=-51DHSm1bOhXFj+gZ1iSC
Content-Description: zd1211rw
Content-Disposition: inline; filename=minicom.cap
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

[  265.945415] usb 1-2: USB disconnect, address 2
[  265.972937] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000001c
[  265.981654] printing eip: c02bca16 *pde = 00000000 
[  265.986632] Oops: 0000 [#1] SMP 
[  265.989927] Modules linked in: arc4 ecb blkcipher zd1211rw mac80211 cfg80211 savagefb fb_ddc i2c_algo_bit vgastate iptable_filter ip_tables x_tables omnibook video output sbs sbshc dock lp loop joydev pcmcia snd_maestro3 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc container snd_seq_dummy serio_raw battery ac button snd_seq_oss snd_seq_midi snd_rawmidi evdev snd_seq_midi_event parport_pc parport snd_seq intel_agp i2c_piix4 snd_timer snd_seq_device shpchp agpgart i2c_core yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug snd soundcore psmouse pcspkr jfs sg sr_mod cdrom sd_mod pata_acpi floppy uhci_hcd tulip usbcore ata_piix ata_generic libata scsi_mod thermal processor fan fbcon tileblit font bitblit softcursor fuse
[  266.057717] 
[  266.059236] Pid: 1501, comm: khubd Not tainted (2.6.24-21-generic #1)
[  266.065723] EIP: 0060:[<c02bca16>] EFLAGS: 00010286 CPU: 0
[  266.071274] EIP is at tcf_destroy+0x6/0x20
[  266.075409] EAX: cefa9884 EBX: cefa9884 ECX: 00000296 EDX: 00000000
[  266.081721] ESI: cefa9880 EDI: ce214180 EBP: 00000000 ESP: cf9e5e40
[  266.088033]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  266.093474] Process khubd (pid: 1501, ti=cf9e4000 task=cdf19700 task.ti=cf9e4000)
[  266.100821] Stack: 00000000 c02bca40 cefa9800 d0d14eef cefa9800 d0d337a0 ce8b0a00 c02bb2ea 
[  266.109394]        ce460800 ce214180 c02bb34a 00000000 00000001 cf9e5e74 cf9e5e74 ce460800 
[  266.117965]        c02a9e39 d0d0a8d8 00000000 00000000 ce8b0a5c ce460800 c02a9ee8 ce214180 
[  266.126537] Call Trace:
[  266.129216]  [<c02bca40>] tcf_destroy_chain+0x10/0x20
[  266.134335]  [<d0d14eef>] wme_qdiscop_destroy+0x2f/0x80 [mac80211]
[  266.140698]  [<c02bb2ea>] qdisc_destroy+0x6a/0xa0
[  266.145470]  [<c02bb34a>] dev_shutdown+0x2a/0x80
[  266.150158]  [<c02a9e39>] rollback_registered+0x99/0x140
[  266.155538]  [<d0d0a8d8>] ieee80211_remove_interfaces+0x48/0x80 [mac80211]
[  266.162521]  [<c02a9ee8>] unregister_netdevice+0x8/0x50
[  266.167816]  [<d0cfd720>] ieee80211_unregister_hw+0x30/0xd0 [mac80211]
[  266.174443]  [<d0d399b4>] disconnect+0x24/0x70 [zd1211rw]
[  266.179947]  [<d08ef7d0>] usb_unbind_interface+0x50/0xb0 [usbcore]
[  266.186298]  [<c0282744>] __device_release_driver+0x64/0xa0
[  266.191957]  [<c0282bb3>] device_release_driver+0x23/0x40
[  266.197423]  [<c028201b>] bus_remove_device+0x4b/0x70
[  266.202541]  [<c02805f5>] device_del+0x135/0x250
[  266.207228]  [<d08ec910>] usb_disable_device+0x80/0xf0 [usbcore]
[  266.213340]  [<d08e84e8>] usb_disconnect+0x98/0x130 [usbcore]
[  266.219196]  [<d08e9977>] hub_thread+0x447/0xcb0 [usbcore]
[  266.224781]  [<c0217fee>] rb_erase+0x15e/0x280
[  266.229330]  [<c0140b60>] autoremove_wake_function+0x0/0x40
[  266.234988]  [<d08e9530>] hub_thread+0x0/0xcb0 [usbcore]
[  266.240397]  [<c01408a2>] kthread+0x42/0x70
[  266.244637]  [<c0140860>] kthread+0x0/0x70
[  266.248794]  [<c0105667>] kernel_thread_helper+0x7/0x10
[  266.254100]  =======================
[  266.257708] Code: c5 74 ec 8b 4c 24 18 89 c2 89 d8 89 34 24 ff 17 89 ea 89 c6 89 d8 ff 57 10 eb b0 8d 76 00 8d bc 27 00 00 00 00 53 8b 50 20 89 c3 <ff> 52 1c 8b 43 20 8b 40 38 e8 fc 39 e9 ff 89 d8 5b e9 e4 0f ed 
[  266.277813] EIP: [<c02bca16>] tcf_destroy+0x6/0x20 SS:ESP 0068:cf9e5e40
[  266.284544] BUG: scheduling while atomic: khubd/1501/0x00000100
[  266.290516] Pid: 1501, comm: khubd Not tainted 2.6.24-21-generic #1
[  266.296839]  [<c031aee3>] schedule+0x553/0x600
[  266.301382]  [<c013632d>] __mod_timer+0x9d/0xb0
[  266.305991]  [<c031b27a>] schedule_timeout+0x4a/0xd0
[  266.311035]  [<c0135e50>] process_timeout+0x0/0x10
[  266.315897]  [<c031b275>] schedule_timeout+0x45/0xd0
[  266.320942]  [<c0254020>] acpi_ec_wait+0xf0/0x22c
[  266.325720]  [<d081d199>] soft_cursor+0x199/0x1f8 [softcursor]
[  266.331639]  [<c0140b60>] autoremove_wake_function+0x0/0x40
[  266.337293]  [<c0254252>] acpi_ec_transaction+0xf6/0x1fa
[  266.342681]  [<d081ab6e>] bit_cursor+0x32e/0x584 [bitblit]
[  266.348260]  [<c0254493>] acpi_ec_write+0x38/0x3c
[  266.353041]  [<d0d67785>] omnibook_set_backlight+0x35/0x60 [omnibook]
[  266.359611]  [<c023674b>] fb_notifier_callback+0x7b/0x90
[  266.365012]  [<c031e890>] notifier_call_chain+0x30/0x60
[  266.370327]  [<c014552a>] __blocking_notifier_call_chain+0x4a/0x70
[  266.376603]  [<c0145567>] blocking_notifier_call_chain+0x17/0x20
[  266.382689]  [<c022e8b6>] fb_blank+0x66/0x80
[  266.387036]  [<d0849324>] fbcon_blank+0x174/0x220 [fbcon]
[  266.392540]  [<c027e620>] serial8250_console_putchar+0x0/0xb0
[  266.398369]  [<c027dcd0>] serial8250_console_write+0x0/0x1b0
[  266.404106]  [<c012c743>] __call_console_drivers+0x53/0x60
[  266.409672]  [<c012cc8a>] release_console_sem+0x1aa/0x1d0
[  266.415168]  [<c01361e7>] lock_timer_base+0x27/0x60
[  266.420112]  [<c026f9b0>] blank_screen_t+0x0/0x40
[  266.424892]  [<c013632d>] __mod_timer+0x9d/0xb0
[  266.429499]  [<c02717ec>] do_unblank_screen+0x9c/0x160
[  266.434722]  [<c021b725>] bust_spinlocks+0x15/0x30
[  266.439584]  [<c0105ee9>] die+0x189/0x280
[  266.443672]  [<c031e518>] do_page_fault+0x3e8/0x730
[  266.448646]  [<c031e130>] do_page_fault+0x0/0x730
[  266.453423]  [<c031c902>] error_code+0x72/0x80
[  266.457944]  [<c02a007b>] sk_dst_check+0xfb/0x100
[  266.462727]  [<c02bca16>] tcf_destroy+0x6/0x20
[  266.467247]  [<c02bca40>] tcf_destroy_chain+0x10/0x20
[  266.472372]  [<d0d14eef>] wme_qdiscop_destroy+0x2f/0x80 [mac80211]
[  266.478700]  [<c02bb2ea>] qdisc_destroy+0x6a/0xa0
[  266.483477]  [<c02bb34a>] dev_shutdown+0x2a/0x80
[  266.488172]  [<c02a9e39>] rollback_registered+0x99/0x140
[  266.493558]  [<d0d0a8d8>] ieee80211_remove_interfaces+0x48/0x80 [mac80211]
[  266.500546]  [<c02a9ee8>] unregister_netdevice+0x8/0x50
[  266.505846]  [<d0cfd720>] ieee80211_unregister_hw+0x30/0xd0 [mac80211]
[  266.512482]  [<d0d399b4>] disconnect+0x24/0x70 [zd1211rw]
[  266.517987]  [<d08ef7d0>] usb_unbind_interface+0x50/0xb0 [usbcore]
[  266.524305]  [<c0282744>] __device_release_driver+0x64/0xa0
[  266.529962]  [<c0282bb3>] device_release_driver+0x23/0x40
[  266.535438]  [<c028201b>] bus_remove_device+0x4b/0x70
[  266.540561]  [<c02805f5>] device_del+0x135/0x250
[  266.545255]  [<d08ec910>] usb_disable_device+0x80/0xf0 [usbcore]
[  266.551372]  [<d08e84e8>] usb_disconnect+0x98/0x130 [usbcore]
[  266.557234]  [<d08e9977>] hub_thread+0x447/0xcb0 [usbcore]
[  266.562824]  [<c0217fee>] rb_erase+0x15e/0x280
[  266.567377]  [<c0140b60>] autoremove_wake_function+0x0/0x40
[  266.573037]  [<d08e9530>] hub_thread+0x0/0xcb0 [usbcore]
[  266.578451]  [<c01408a2>] kthread+0x42/0x70
[  266.582697]  [<c0140860>] kthread+0x0/0x70
[  266.586862]  [<c0105667>] kernel_thread_helper+0x7/0x10
[  266.592169]  =======================
[  266.595924] ACPI: EC: missing write data confirmation, don't expect it any longer.
[  266.610917] Kernel panic - not syncing: Fatal exception in interrupt

--=-51DHSm1bOhXFj+gZ1iSC--

