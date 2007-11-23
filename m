Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.matws.net ([88.175.162.123]:44865 "EHLO smtp.matws.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbXKWJy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 04:54:56 -0500
Received: from [192.168.24.6] (unknown [192.168.24.6])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.matws.net (smtp.matws.net) with ESMTP id F2E5C280320
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 10:32:26 +0100 (CET)
Message-ID: <47469E42.6050909@matws.net> (sfid-20071123_095501_529792_94EFACE1)
Date: Fri, 23 Nov 2007 12:32:50 +0300
From: Matthieu PATOU <mat@matws.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: BCM4312 status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

There is a BCM4312 wifi card bundled in my laptop.
Last week I used the everything branch of wireless-2.6 subtree and the patch of larry finger (from this email 
:http://www.mail-archive.com/bcm43xx-dev@lists.berlios.de/msg05586.html) and with commit 
755a957d407c3fcac58360d9309b1664078ac15d.

With this couple (patch + commit level) i was able to get my card working.
Here is the information about this card with lspci :

30:00.0 0280: 14e4:4312 (rev 02)
         Subsystem: 103c:1371
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at c8000000 (64-bit, non-prefetchable) [size=16K]

I have some warning:
[   36.199157] WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
[   36.199168]  [<f8ad48cb>] ssb_tmslow_reject_bitmask+0x4b/0x60 [ssb]
[   36.199179]  [<f8ad5201>] ssb_device_is_enabled+0x11/0x40 [ssb]
As I have understood they are harmless and a couple of second later I have this message :
[   74.142529] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   75.259913] b43-phy0 debug: Chip initialized
[   75.260134] b43-phy0 debug: 64-bit DMA initialized
[   75.280206] b43-phy0 ERROR: PHY transmission error
[   75.280214] b43-phy0 debug: Wireless interface started
[   75.280217] b43-phy0 debug: Adding Interface type 2
[   75.281746] ADDRCONF(NETDEV_UP): wlan0_rename: link is not ready
And finaly after logging through GDM, network manager manage to set the card so everything is ok.

The systems is quite stable, I use it since one week and there is no errors as I can recall.

In fact there is one problem: suspend to ram. After resuming from suspend to ram, i have the b43 constantly running and 
taking 50% at least of the CPU (as reported by top) and no network connection.
Even after killing NetworkManager, this "process" is still eating all the CPU.
It keeps saying :
Nov 23 10:05:54 ares kernel: [  104.081856] b43-phy0 debug: Adding Interface type 2
Nov 23 10:05:54 ares kernel: [  104.083553] ADDRCONF(NETDEV_UP): wlan0_rename: link is not ready
Nov 23 10:06:37 ares kernel: [  146.992517] b43-phy0 ERROR: Fatal DMA error: 0x00000000, 0x00000400, 0x00000000, 
0x00000000, 0x00000000, 0x00000000
Nov 23 10:06:37 ares kernel: [  146.992526] b43-phy0: Controller RESET (DMA error) ...
Nov 23 10:06:37 ares kernel: [  147.000484] b43-phy0 debug: Wireless interface stopped
Nov 23 10:06:37 ares kernel: [  147.000533] b43-phy0 debug: DMA-64 0x0200 (RX) max used slots: 0/64
Nov 23 10:06:37 ares kernel: [  147.000587] b43-phy0 debug: DMA-64 0x0340 (TX) max used slots: 0/128
Nov 23 10:06:37 ares kernel: [  147.008475] b43-phy0 debug: DMA-64 0x0300 (TX) max used slots: 0/128
Nov 23 10:06:37 ares kernel: [  147.016473] b43-phy0 debug: DMA-64 0x02C0 (TX) max used slots: 0/128
Nov 23 10:06:37 ares kernel: [  147.024466] b43-phy0 debug: DMA-64 0x0280 (TX) max used slots: 0/128
Nov 23 10:06:37 ares kernel: [  147.032463] b43-phy0 debug: DMA-64 0x0240 (TX) max used slots: 2/128
Nov 23 10:06:37 ares kernel: [  147.040463] b43-phy0 debug: DMA-64 0x0200 (TX) max used slots: 0/128
Nov 23 10:06:37 ares kernel: [  147.048478] WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
Nov 23 10:06:37 ares kernel: [  147.048497]  [<f8ea38cb>] ssb_tmslow_reject_bitmask+0x4b/0x60 [ssb]
Nov 23 10:06:37 ares kernel: [  147.048512]  [<f8ea39e7>] ssb_device_disable+0x47/0xf0 [ssb]
Nov 23 10:06:37 ares kernel: [  147.048520]  [<f8f43371>] b43_wireless_core_exit+0x91/0x100 [b43]
Nov 23 10:06:37 ares kernel: [  147.048539]  [<f8f43381>] b43_wireless_core_exit+0xa1/0x100 [b43]
Nov 23 10:06:37 ares kernel: [  147.048554]  [<f8f45fac>] b43_chip_reset+0x3c/0xc0 [b43]
Nov 23 10:06:37 ares kernel: [  147.048566]  [queue_delayed_work+81/112] queue_delayed_work+0x51/0x70
Nov 23 10:06:37 ares kernel: [  147.048574]  [<f8f45f70>] b43_chip_reset+0x0/0xc0 [b43]
Nov 23 10:06:37 ares kernel: [  147.048585]  [run_workqueue+116/256] run_workqueue+0x74/0x100
Nov 23 10:06:37 ares kernel: [  147.048594]  [prepare_to_wait+32/112] prepare_to_wait+0x20/0x70
Nov 23 10:06:37 ares kernel: [  147.048602]  [worker_thread+0/256] worker_thread+0x0/0x100
Nov 23 10:06:37 ares kernel: [  147.048607]  [worker_thread+164/256] worker_thread+0xa4/0x100
Nov 23 10:06:37 ares kernel: [  147.048612]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Nov 23 10:06:37 ares kernel: [  147.048621]  [worker_thread+0/256] worker_thread+0x0/0x100
Nov 23 10:06:37 ares kernel: [  147.048626]  [kthread+66/112] kthread+0x42/0x70
Nov 23 10:06:37 ares kernel: [  147.048629]  [kthread+0/112] kthread+0x0/0x70
Nov 23 10:06:37 ares kernel: [  147.048636]  [kernel_thread_helper+7/24] kernel_thread_helper+0x7/0x18
Nov 23 10:06:37 ares kernel: [  147.048647]  =======================
Nov 23 10:06:37 ares kernel: [  147.068448] WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
Nov 23 10:06:37 ares kernel: [  147.068455]  [<f8ea38cb>] ssb_tmslow_reject_bitmask+0x4b/0x60 [ssb]
Nov 23 10:06:37 ares kernel: [  147.068465]  [<f8ea4201>] ssb_device_is_enabled+0x11/0x40 [ssb]
Nov 23 10:06:37 ares kernel: [  147.068477]  [<f8f457ef>] b43_wireless_core_init+0x4f/0x700 [b43]
Nov 23 10:06:37 ares kernel: [  147.068490]  [__delay+6/16] __delay+0x6/0x10
Nov 23 10:06:37 ares kernel: [  147.068504]  [<f8f45fb3>] b43_chip_reset+0x43/0xc0 [b43]
Nov 23 10:06:37 ares kernel: [  147.068514]  [queue_delayed_work+81/112] queue_delayed_work+0x51/0x70
Nov 23 10:06:37 ares kernel: [  147.068520]  [<f8f45f70>] b43_chip_reset+0x0/0xc0 [b43]
Nov 23 10:06:37 ares kernel: [  147.068532]  [run_workqueue+116/256] run_workqueue+0x74/0x100
Nov 23 10:06:37 ares kernel: [  147.068541]  [prepare_to_wait+32/112] prepare_to_wait+0x20/0x70
Nov 23 10:06:37 ares kernel: [  147.068546]  [worker_thread+0/256] worker_thread+0x0/0x100
Nov 23 10:06:37 ares kernel: [  147.068551]  [worker_thread+164/256] worker_thread+0xa4/0x100
Nov 23 10:06:37 ares kernel: [  147.068557]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Nov 23 10:06:37 ares kernel: [  147.068565]  [worker_thread+0/256] worker_thread+0x0/0x100
Nov 23 10:06:37 ares kernel: [  147.068570]  [kthread+66/112] kthread+0x42/0x70
Nov 23 10:06:37 ares kernel: [  147.068574]  [kthread+0/112] kthread+0x0/0x70
Nov 23 10:06:37 ares kernel: [  147.068579]  [kernel_thread_helper+7/24] kernel_thread_helper+0x7/0x18
Nov 23 10:06:37 ares kernel: [  147.068588]  =======================
Nov 23 10:06:38 ares kernel: [  147.153535] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
Nov 23 10:06:39 ares kernel: [  148.320066] b43-phy0 debug: Chip initialized
Nov 23 10:06:39 ares kernel: [  148.320309] b43-phy0 debug: 64-bit DMA initialized
Nov 23 10:06:39 ares kernel: [  148.340469] b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 
0x00000000, 0x00000000, 0x00000000
Nov 23 10:06:39 ares kernel: [  148.340476] b43-phy0: Controller RESET (DMA error) ...
Nov 23 10:06:39 ares kernel: [  148.340484] b43-phy0 debug: Wireless interface started
Nov 23 10:06:39 ares kernel: [  148.340485] b43-phy0: Controller restarted
Nov 23 10:06:39 ares kernel: [  148.351874] b43-phy0 debug: Wireless interface stopped
...
I tried a couple of time (I often suspend to ram my laptop once a day : before going to bed) to remove the module : 
rmmod b43
But it finish like this :

[  259.944532] BUG: unable to handle kernel paging request at virtual address 3c4f38ff
[  259.944538] printing eip: c0138664 *pde = 00000000
[  259.944542] Oops: 0000 [#1] SMP
[  259.944545] Modules linked in: battery ac thermal fan button b43 ssb pcmcia mac80211 cfg80211 tg3 tun aes_i586 
aes_generic geode_aes af_packet nls_iso8859_1 nls_cp437 vfat fat ipv6 powernow_k8 cpufreq_stats cpufreq_powersave 
cpufreq_conservative sbs sbshc dock ext3 jbd mbcache sbp2 arc4 ecb blkcipher cryptomgr snd_hda_intel snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event yenta_socket hci_usb 
rsrc_nonstatic snd_seq snd_timer snd_seq_device bluetooth psmouse serio_raw k8temp pcspkr i2c_piix4 i2c_core snd 
soundcore snd_page_alloc pcmcia_core video output power_supply ati_agp agpgart evdev usb_storage xfs libusual ide_cd 
cdrom pata_atiixp sg ata_generic sd_mod generic ehci_hcd ohci1394 ahci ohci_hcd ieee1394 atiixp libata scsi_mod usbcore 
dm_mirror dm_snapshot dm_mod processor fuse
[  259.944585]
[  259.944587] Pid: 21473, comm: rmmod Not tainted (2.6.24-rc2 #1)
[  259.944590] EIP: 0060:[<c0138664>] EFLAGS: 00210297 CPU: 1
[  259.944597] EIP is at __cancel_work_timer+0xe4/0x140
[  259.944599] EAX: 3c4f38ff EBX: c3601000 ECX: c1f14788 EDX: c3b0c200
[  259.944601] ESI: 00000000 EDI: c3601228 EBP: c03d5f38 ESP: d189fea8
[  259.944604]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  259.944606] Process rmmod (pid: 21473, ti=d189e000 task=c46d25c0 task.ti=d189e000)
[  259.944608] Stack: c360122c 00000000 00000000 c3b0c200 00200282 c4783c00 c03d5390 c01e86bd
[  259.944613]        00200282 c01e86bd 00000000 c899f900 c3601000 d1a9dd80 d0429458 f8f63268
[  259.944618]        f8f43421 d1a9dd80 d0429458 c3601000 f8f439c6 f8f63268 00000004 c340cc00
[  259.944623] Call Trace:
[  259.944633]  [<c01e86bd>] crypto_free_tfm+0x2d/0x90
[  259.944639]  [<c01e86bd>] crypto_free_tfm+0x2d/0x90
[  259.944648]  [<f8f43421>] b43_one_core_detach+0x21/0x80 [b43]
[  259.944662]  [<f8f439c6>] b43_remove+0x26/0xa0 [b43]
[  259.944678]  [<f8ea40ed>] ssb_device_remove+0x1d/0x30 [ssb]
[  259.944686]  [<c025b194>] __device_release_driver+0x64/0xa0
[  259.944693]  [<c025b6e3>] driver_detach+0xc3/0xd0
[  259.944702]  [<c025ace3>] bus_remove_driver+0x73/0xa0
[  259.944708]  [<f8f5a240>] b43_exit+0x0/0x23 [b43]
[  259.944716]  [<f8f5a24a>] b43_exit+0xa/0x23 [b43]
[  259.944724]  [<c014cd6a>] sys_delete_module+0x11a/0x1a0
[  259.944733]  [<c011bf89>] do_page_fault+0xe9/0x600
[  259.944739]  [<c01705c6>] do_munmap+0x186/0x1e0
[  259.944756]  [<c010415e>] sysenter_past_esp+0x5f/0x85
[  259.944777]  =======================
[  259.944778] Code: 7e 21 e9 7c ff ff ff c6 03 01 fb 85 c0 75 41 89 f0 89 ea e8 5f fe 0b 00 83 f8 07 89 c6 0f 8f 60 ff 
ff ff 8b 54 24 0c 8b 02 f7 d0 <8b> 1c b0 89 d8 e8 d2 28 1b 00 31 c0 3b 7b 18 75 cb 89 d8 31 c9
[  259.944799] EIP: [<c0138664>] __cancel_work_timer+0xe4/0x140 SS:ESP 0068:d189fea8



Yesterday I fetched a more recent version of the everything branch and built a kernel with the latest patch from larry 
finger, I've planned to test it this afternoon, I'll publish then my results with this.

Matthieu.
