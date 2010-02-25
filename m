Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525Ab0BYULk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 15:11:40 -0500
Date: Thu, 25 Feb 2010 20:11:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Josh Triplett <josh@joshtriplett.org>, 571465@bugs.debian.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bug#571465: linux-image-2.6.32-2-amd64: Kernel WARNING from
	wdev_cleanup_work when hibernating
Message-ID: <20100225201129.GC21665@decadent.org.uk>
References: <20100225155700.6147.86873.reportbug@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100225155700.6147.86873.reportbug@feather>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 07:57:00AM -0800, Josh Triplett wrote:
> Package: linux-2.6
> Version: 2.6.32-8
> Severity: normal
> 
> My laptop hibernated due to low battery last night, and this morning after
> un-hibernating it I noticed the signs of an oops mentioned in my terminal
> window.  Digging through the kernel log, I found these, one during hibernate
> and the other during un-hibernate:

Let's see if linux-wireless can make anything of this.

Ben.

> Feb 25 05:02:10 feather kernel: [42744.419370] ------------[ cut here ]------------
> Feb 25 05:02:10 feather kernel: [42744.419393] WARNING: at /build/buildd-linux-2.6_2.6.32-8-amd64-DCxXqz/linux-2.6-2.6.32/debian/build/source_amd64_none/net/wi
> reless/core.c:614 wdev_cleanup_work+0x49/0xb3 [cfg80211]()
> Feb 25 05:02:10 feather kernel: [42744.419401] Hardware name: 7454CTO
> Feb 25 05:02:10 feather kernel: [42744.419404] Modules linked in: iwlagn iwlcore mac80211 cfg80211 ppdev lp parport sco bridge stp btusb bnep rfcomm l2cap crc1
> 6 bluetooth acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_stats kvm_intel cpufreq_conservative kvm fuse loop snd_hda_codec_conexant arc4 ecb uvcvide
> o snd_hda_intel snd_hda_codec snd_hwdep snd_pcm videodev snd_seq v4l1_compat snd_timer snd_seq_device v4l2_compat_ioctl32 snd thinkpad_acpi ac led_class batter
> y nvram psmouse serio_raw rfkill i2c_i801 wmi soundcore evdev snd_page_alloc processor ext3 jbd mbcache sd_mod crc_t10dif ahci uhci_hcd i915 drm_kms_helper ehc
> i_hcd drm i2c_algo_bit e1000e libata scsi_mod button i2c_core video output usbcore nls_base intel_agp thermal fan thermal_sys [last unloaded: cfg80211]
> Feb 25 05:02:10 feather kernel: [42744.419547] Pid: 10, comm: events/1 Not tainted 2.6.32-2-amd64 #1
> Feb 25 05:02:10 feather kernel: [42744.419552] Call Trace:
> Feb 25 05:02:10 feather kernel: [42744.419566]  [<ffffffffa03e24f7>] ? wdev_cleanup_work+0x49/0xb3 [cfg80211]
> Feb 25 05:02:10 feather kernel: [42744.419579]  [<ffffffffa03e24f7>] ? wdev_cleanup_work+0x49/0xb3 [cfg80211]
> Feb 25 05:02:10 feather kernel: [42744.419590]  [<ffffffff8104dbe8>] ? warn_slowpath_common+0x77/0xa3
> Feb 25 05:02:10 feather kernel: [42744.419603]  [<ffffffffa03e24f7>] ? wdev_cleanup_work+0x49/0xb3 [cfg80211]
> Feb 25 05:02:10 feather kernel: [42744.419613]  [<ffffffff81061473>] ? worker_thread+0x188/0x21d
> Feb 25 05:02:10 feather kernel: [42744.419625]  [<ffffffffa03e24ae>] ? wdev_cleanup_work+0x0/0xb3 [cfg80211]
> Feb 25 05:02:10 feather kernel: [42744.419635]  [<ffffffff81064a5e>] ? autoremove_wake_function+0x0/0x2e
> Feb 25 05:02:10 feather kernel: [42744.419643]  [<ffffffff810612eb>] ? worker_thread+0x0/0x21d
> Feb 25 05:02:10 feather kernel: [42744.419650]  [<ffffffff81064791>] ? kthread+0x79/0x81
> Feb 25 05:02:10 feather kernel: [42744.419660]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
> Feb 25 05:02:10 feather kernel: [42744.419667]  [<ffffffff81064718>] ? kthread+0x0/0x81
> Feb 25 05:02:10 feather kernel: [42744.419674]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
> Feb 25 05:02:10 feather kernel: [42744.419679] ---[ end trace 240fa69dfbf9d219 ]---
> 
> Feb 25 07:22:39 feather kernel: [42747.551961] Restarting tasks ... done.
> Feb 25 07:22:39 feather kernel: [42747.588358] PM: Basic memory bitmaps freed
> Feb 25 07:22:40 feather kernel: [42747.627928] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> Feb 25 07:22:40 feather kernel: [42747.627935] IP: [<ffffffff8113d11e>] sysfs_open_file+0x33/0x2aa
> Feb 25 07:22:40 feather kernel: [42747.627945] PGD 123283067 PUD 123282067 PMD 0 
> Feb 25 07:22:40 feather kernel: [42747.627950] Oops: 0000 [#1] SMP 
> Feb 25 07:22:40 feather kernel: [42747.627954] last sysfs file: /sys/devices/virtual/bdi/7:6/uevent
> Feb 25 07:22:40 feather kernel: [42747.627957] CPU 0 
> Feb 25 07:22:40 feather kernel: [42747.627959] Modules linked in: iwlagn iwlcore mac80211 cfg80211 ppdev lp parport sco bridge stp btusb bnep rfcomm l2cap crc16 bluetooth acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_stats kvm_intel cpufreq_conservative kvm fuse loop snd_hda_codec_conexant arc4 ecb uvcvideo snd_hda_intel snd_hda_codec snd_hwdep snd_pcm videodev snd_seq v4l1_compat snd_timer snd_seq_device v4l2_compat_ioctl32 snd thinkpad_acpi ac led_class battery nvram psmouse serio_raw rfkill i2c_i801 wmi soundcore evdev snd_page_alloc processor ext3 jbd mbcache sd_mod crc_t10dif ahci uhci_hcd i915 drm_kms_helper ehci_hcd drm i2c_algo_bit e1000e libata scsi_mod button i2c_core video output usbcore nls_base intel_agp thermal fan thermal_sys [last unloaded: cfg80211]
> Feb 25 07:22:40 feather kernel: [42747.628006] Pid: 5535, comm: udev-acl.ck Tainted: G        W  2.6.32-2-amd64 #1 7454CTO
> Feb 25 07:22:40 feather kernel: [42747.628006] RIP: 0010:[<ffffffff8113d11e>]  [<ffffffff8113d11e>] sysfs_open_file+0x33/0x2aa
> Feb 25 07:22:40 feather kernel: [42747.628006] RSP: 0018:ffff880139cadd78  EFLAGS: 00010296
> Feb 25 07:22:40 feather kernel: [42747.628006] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88013abe79c0
> Feb 25 07:22:40 feather kernel: [42747.628006] RDX: 0000000000001000 RSI: ffffffff816410d0 RDI: ffff88013abe79d0
> Feb 25 07:22:40 feather kernel: [42747.628006] RBP: ffff88013abe79c0 R08: 0000000000000000 R09: ffff880123189000
> Feb 25 07:22:40 feather kernel: [42747.628006] R10: ffff880139cade48 R11: ffffffff81150cb5 R12: 0000000000000000
> Feb 25 07:22:40 feather kernel: [42747.628006] R13: ffff880138280410 R14: ffff88013a62c250 R15: ffff88013abe79c0
> Feb 25 07:22:40 feather kernel: [42747.628006] FS:  00007f9d3bc586f0(0000) GS:ffff880005200000(0000) knlGS:0000000000000000
> Feb 25 07:22:40 feather kernel: [42747.628006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 25 07:22:40 feather kernel: [42747.628006] CR2: 0000000000000020 CR3: 000000013854a000 CR4: 00000000000026f0
> Feb 25 07:22:40 feather kernel: [42747.628006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Feb 25 07:22:40 feather kernel: [42747.628006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Feb 25 07:22:40 feather kernel: [42747.628006] Process udev-acl.ck (pid: 5535, threadinfo ffff880139cac000, task ffff88012b5cd4c0)
> Feb 25 07:22:40 feather kernel: [42747.628006] Stack:
> Feb 25 07:22:40 feather kernel: [42747.628006]  0000000000000024 0000000000000000 ffff88013abe79c0 0000000000000000
> Feb 25 07:22:40 feather kernel: [42747.628006] <0> ffff88013a62c250 0000000000000024 ffffffff8113d0eb ffffffff810ebcc2
> Feb 25 07:22:40 feather kernel: [42747.628006] <0> ffff880123189000 ffff880138dff200 ffff88013a573c00 0000000000000000
> Feb 25 07:22:40 feather kernel: [42747.628006] Call Trace:
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff8113d0eb>] ? sysfs_open_file+0x0/0x2aa
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff810ebcc2>] ? __dentry_open+0x19d/0x2bf
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff810f732a>] ? do_filp_open+0x4c4/0x92b
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff8113ed09>] ? sysfs_follow_link+0x140/0x172
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff810f06d7>] ? cp_new_stat+0xe9/0xfc
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff81100211>] ? alloc_fd+0x67/0x10c
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff810eba53>] ? do_sys_open+0x55/0xfc
> Feb 25 07:22:40 feather kernel: [42747.628006]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
> Feb 25 07:22:40 feather kernel: [42747.628006] Code: 89 f7 41 56 49 89 fe 48 8d 7e 10 41 55 41 54 55 53 48 83 ec 08 48 8b 46 18 48 c7 c6 d0 10 64 81 4c 8b a8 98 00 00 00 49 8b 45 08 <4c> 8b 60 20 e8 b0 f1 fb ff 48 85 c0 48 89 c6 74 1d 48 89 f7 31 
> Feb 25 07:22:40 feather kernel: [42747.628006] RIP  [<ffffffff8113d11e>] sysfs_open_file+0x33/0x2aa
> Feb 25 07:22:40 feather kernel: [42747.628006]  RSP <ffff880139cadd78>
> Feb 25 07:22:40 feather kernel: [42747.628006] CR2: 0000000000000020
> Feb 25 07:22:40 feather kernel: [42747.628216] ---[ end trace 240fa69dfbf9d21a ]---
> 
> 
> As always, I'd consider the subsequent oops suspect due to the previous
> WARNING.
> 
> Digging through the source turned up:
> 
> static void wdev_cleanup_work(struct work_struct *work)
> {
>         struct wireless_dev *wdev;
>         struct cfg80211_registered_device *rdev;
> 
>         wdev = container_of(work, struct wireless_dev, cleanup_work);
>         rdev = wiphy_to_dev(wdev->wiphy);
> 
>         cfg80211_lock_rdev(rdev);
> 
>         if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
>                 rdev->scan_req->aborted = true;
>                 ___cfg80211_scan_done(rdev, true);
>         }
> 
>         cfg80211_unlock_rdev(rdev);
> 
>         mutex_lock(&rdev->devlist_mtx);
>         rdev->opencount--;
>         mutex_unlock(&rdev->devlist_mtx);
>         wake_up(&rdev->dev_wait);
> 
>         dev_put(wdev->netdev);
> }
> 
> 
> That WARN_ON corresponds to the line given for the initial WARNING.
> 
> - Josh Triplett
> 
> -- Package-specific info:
> ** Version:
> Linux version 2.6.32-2-amd64 (Debian 2.6.32-8) (ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Fri Feb 12 00:01:47 UTC 2010
> 
> ** Command line:
> BOOT_IMAGE=/boot/vmlinuz-2.6.32-2-amd64 root=UUID=a8fb9a37-fac7-4a3e-8081-fc7b347bd0b2 ro quiet
> 
> ** Tainted: DW (640)
>  * Kernel has oopsed before.
>  * Taint on warning.
> 
> ** Kernel log:
> [snipped, more useful log data above]
> 
> ** Model information
> sys_vendor: LENOVO
> product_name: 7454CTO
> product_version: ThinkPad X200
> chassis_vendor: LENOVO
> chassis_version: Not Available
> bios_vendor: LENOVO
> bios_version: 6DET28WW (1.05 )
> board_vendor: LENOVO
> board_name: 7454CTO
> board_version: Not Available
> 
> ** Loaded modules:
> Module                  Size  Used by
> iwlagn                 71772  0 
> iwlcore                77830  1 iwlagn
> mac80211              136124  2 iwlagn,iwlcore
> cfg80211              101269  3 iwlagn,iwlcore,mac80211
> ppdev                   5030  0 
> lp                      7478  0 
> parport                27938  2 ppdev,lp
> sco                     7193  2 
> bridge                 39582  0 
> stp                     1440  1 bridge
> btusb                   9785  2 
> bnep                    9395  2 
> rfcomm                 29501  4 
> l2cap                  24656  14 bnep,rfcomm
> crc16                   1319  1 l2cap
> bluetooth              41795  9 sco,btusb,bnep,rfcomm,l2cap
> acpi_cpufreq            5555  0 
> cpufreq_userspace       1992  0 
> cpufreq_powersave        902  0 
> cpufreq_stats           2659  0 
> kvm_intel              37632  0 
> cpufreq_conservative     5162  0 
> kvm                   213676  1 kvm_intel
> fuse                   50078  1 
> loop                   11767  0 
> snd_hda_codec_conexant    21789  1 
> arc4                    1274  2 
> ecb                     1841  2 
> uvcvideo               51663  0 
> snd_hda_intel          19411  1 
> snd_hda_codec          54212  2 snd_hda_codec_conexant,snd_hda_intel
> snd_hwdep               5364  1 snd_hda_codec
> snd_pcm                60615  2 snd_hda_intel,snd_hda_codec
> videodev               29977  1 uvcvideo
> snd_seq                42801  0 
> v4l1_compat            11442  2 uvcvideo,videodev
> snd_timer              15502  2 snd_pcm,snd_seq
> snd_seq_device          4477  1 snd_seq
> v4l2_compat_ioctl32     8538  1 videodev
> snd                    46350  10 snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device
> thinkpad_acpi          50043  0 
> ac                      2192  0 
> led_class               2401  2 iwlcore,thinkpad_acpi
> battery                 4998  0 
> nvram                   5061  1 thinkpad_acpi
> psmouse                49505  0 
> serio_raw               3752  0 
> rfkill                 12996  5 cfg80211,bluetooth,thinkpad_acpi
> i2c_i801                7798  0 
> wmi                     4307  0 
> soundcore               4598  1 snd
> evdev                   7336  9 
> snd_page_alloc          6217  2 snd_hda_intel,snd_pcm
> processor              29495  3 acpi_cpufreq
> ext3                  106470  1 
> jbd                    37037  1 ext3
> mbcache                 4970  1 ext3
> sd_mod                 29673  3 
> crc_t10dif              1276  1 sd_mod
> ahci                   31686  2 
> uhci_hcd               18489  0 
> i915                  247194  2 
> drm_kms_helper         18883  1 i915
> ehci_hcd               30674  0 
> drm                   137174  3 i915,drm_kms_helper
> i2c_algo_bit            4225  1 i915
> e1000e                109903  0 
> libata                132167  1 ahci
> scsi_mod              121893  2 sd_mod,libata
> button                  4634  1 i915
> i2c_core               15584  5 videodev,i2c_i801,i915,drm,i2c_algo_bit
> video                  17445  1 i915
> output                  1692  1 video
> usbcore               121751  5 btusb,uvcvideo,uhci_hcd,ehci_hcd
> nls_base                6377  1 usbcore
> intel_agp              25593  1 
> thermal                11674  0 
> fan                     3346  0 
> thermal_sys            11878  4 processor,video,thermal,fan
> 
> ** PCI devices:
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub [8086:2a40] (rev 07)
> 	Subsystem: Lenovo Device [17aa:20e0]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 	Kernel driver in use: agpgart-intel
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a42] (rev 07) (prog-if 00 [VGA controller])
> 	Subsystem: Lenovo Device [17aa:20e4]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 28
> 	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
> 	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
> 	Region 4: I/O ports at 1800 [size=8]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: <access denied>
> 	Kernel driver in use: i915
> 
> 00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43] (rev 07)
> 	Subsystem: Lenovo Device [17aa:20e4]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=1M]
> 	Capabilities: <access denied>
> 
> 00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series Chipset MEI Controller [8086:2a44] (rev 07)
> 	Subsystem: Lenovo Device [17aa:20e6]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at f2826800 (64-bit, non-prefetchable) [size=16]
> 	Capabilities: <access denied>
> 
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit Network Connection [8086:10f5] (rev 03)
> 	Subsystem: Lenovo Device [17aa:20ee]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 27
> 	Region 0: Memory at f2600000 (32-bit, non-prefetchable) [size=128K]
> 	Region 1: Memory at f2625000 (32-bit, non-prefetchable) [size=4K]
> 	Region 2: I/O ports at 1840 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: e1000e
> 
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 20
> 	Region 4: I/O ports at 1860 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 21
> 	Region 4: I/O ports at 1880 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 22
> 	Region 4: I/O ports at 18a0 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Lenovo Device [17aa:20f1]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 23
> 	Region 0: Memory at f2826c00 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 03)
> 	Subsystem: Lenovo Device [17aa:20f2]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin B routed to IRQ 17
> 	Region 0: Memory at f2620000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: HDA Intel
> 
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: c0000000-c01fffff
> 	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
> 
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 [8086:2942] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> 	I/O behind bridge: 00004000-00004fff
> 	Memory behind bridge: f2500000-f25fffff
> 	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
> 
> 00:1c.3 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 [8086:2946] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: f0000000-f1ffffff
> 	Prefetchable memory behind bridge: 00000000f2900000-00000000f29fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
> 
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 4: I/O ports at 18c0 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 17
> 	Region 4: I/O ports at 18e0 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo Device [17aa:20f0]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at 1c00 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
> 
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Lenovo Device [17aa:20f1]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 19
> 	Region 0: Memory at f2827000 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93) (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 
> 00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M-E LPC Interface Controller [8086:2917] (rev 03)
> 	Subsystem: Lenovo Device [17aa:20f5]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 
> 00:1f.2 SATA controller [0106]: Intel Corporation ICH9M/M-E SATA AHCI Controller [8086:2929] (rev 03) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Lenovo Device [17aa:20f8]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 29
> 	Region 0: I/O ports at 1c48 [size=8]
> 	Region 1: I/O ports at 183c [size=4]
> 	Region 2: I/O ports at 1c40 [size=8]
> 	Region 3: I/O ports at 1838 [size=4]
> 	Region 4: I/O ports at 1c20 [size=32]
> 	Region 5: Memory at f2826000 (32-bit, non-prefetchable) [size=2K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ahci
> 
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 03)
> 	Subsystem: Lenovo Device [17aa:20f9]
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: Memory at f2827400 (64-bit, non-prefetchable) [size=256]
> 	Region 4: I/O ports at 1c60 [size=32]
> 	Kernel driver in use: i801_smbus
> 
> 03:00.0 Network controller [0280]: Intel Corporation Wireless WiFi Link 5300 [8086:4236]
> 	Subsystem: Intel Corporation Device [8086:1011]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 30
> 	Region 0: Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: iwlagn
> 
> 
> ** USB devices:
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 002: ID 17ef:480c Lenovo 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 003: ID 0a5c:2145 Broadcom Corp. Bluetooth with Enhanced Data Rate II
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> 
> -- System Information:
> Debian Release: squeeze/sid
>   APT prefers unstable
>   APT policy: (500, 'unstable'), (1, 'experimental')
> Architecture: amd64 (x86_64)
> 
> Kernel: Linux 2.6.32-2-amd64 (SMP w/2 CPU cores)
> Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
> Shell: /bin/sh linked to /bin/dash
> 
> Versions of packages linux-image-2.6.32-2-amd64 depends on:
> ii  debconf [debconf-2.0]        1.5.28      Debian configuration management sy
> ii  initramfs-tools [linux-initr 0.93.4      tools for generating an initramfs
> ii  module-init-tools            3.12~pre1-1 tools for managing Linux kernel mo
> 
> Versions of packages linux-image-2.6.32-2-amd64 recommends:
> pn  firmware-linux-free           <none>     (no description available)
> 
> Versions of packages linux-image-2.6.32-2-amd64 suggests:
> pn  grub | lilo                   <none>     (no description available)
> pn  linux-doc-2.6.32              <none>     (no description available)
> 
> Versions of packages linux-image-2.6.32-2-amd64 is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> pn  firmware-iwlwifi              <none>     (no description available)
> pn  firmware-linux                <none>     (no description available)
> pn  firmware-linux-nonfree        <none>     (no description available)
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
> 
> -- debconf information excluded

-- 
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett
