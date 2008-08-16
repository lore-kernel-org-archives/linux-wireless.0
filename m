Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbYHPV5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 17:57:06 -0400
Date: Sat, 16 Aug 2008 14:55:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, kender@freenet.de,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bugme-new] [Bug 11357] New: Can not boot up with zd1211rw
 USB-Wlan Stick
Message-Id: <20080816145548.82ec9db7.akpm@linux-foundation.org> (sfid-20080816_235722_371208_05D5BCE4)
In-Reply-To: <bug-11357-10286@http.bugzilla.kernel.org/>
References: <bug-11357-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 16 Aug 2008 14:17:50 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11357
> 
>            Summary: Can not boot up with zd1211rw USB-Wlan Stick
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: network-wireless
>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>         ReportedBy: kender@freenet.de
> 
> 
> Latest working kernel version:2.6.26
> Earliest failing kernel version:2.6.27
> Distribution: Kanotix /debian
> Hardware Environment: zd1211rw USB-Wlan, CPU Intel P Dual-Core E2200, MB MSI
> G31M, RAM 2x 1024 MB A-Data Vitesta Kit Cl5 PC2-6400U
> Software Environment: Debian // Kanotix in current Version
> Problem Description:
> I can't boot up with a plugged WLAN - Usb Device. There are no important
> errormessages while booting up. I tried to connect while Kanotix were running
> and dmesg gave the following output:
> 
>  [  654.887294] usb 1-3: new high speed USB device using ehci_hcd and address 5
> [  655.020004] usb 1-3: configuration #1 chosen from 1 choice
> [  655.286158] usb 1-3: reset high speed USB device using ehci_hcd and address
> 5
> [  655.420503] phy0: Selected rate control algorithm 'pid'
> [  655.577168] zd1211rw 1-3:1.0: phy0
> [  655.577168] usbcore: registered new interface driver zd1211rw
> [  655.588508] ------------[ cut here ]------------
> [  655.588508] kernel BUG at
> /usr/src/linux-2.6.27-1-generic/ubuntu-2.6/net/mac80211/ieee
> 80211_i.h:756!
> [  655.588508] invalid opcode: 0000 [#1] SMP
> [  655.588508] Modules linked in: arc4 ecb crypto_blkcipher zd1211rw mac80211
> cfg80211 af
> _packet nvidia(P) rfcomm l2cap bluetooth nfs lockd nfs_acl sunrpc vboxdrv ppdev
> parport_p
> c lp parport video output sbs sbshc container battery ac capifs rsrc_nonstatic
> pcmcia_cor
> e nls_iso8859_1 nls_cp437 vfat fat coretemp w83627ehf hwmon_vid fuse
> speedstep_lib cpufre
> q_userspace cpufreq_powersave cpufreq_ondemand acpi_cpufreq freq_table psmouse
> snd_pcsp s
> nd_hda_intel serio_raw snd_pcm_oss snd_mixer_oss iTCO_wdt dvb_usb_dtt200u
> snd_pcm dvb_usb
>  iTCO_vendor_support dvb_core snd_timer i2c_core snd ndiswrapper soundcore
> snd_page_alloc
>  button intel_agp agpgart evdev sg sr_mod cdrom ext3 jbd mbcache dm_snapshot
> raid10 raid4
> 56 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod
> dm_raid4_5 dm_
> region_hash dm_mem_cache dm_message dm_mirror dm_log dm_mod sd_mod crc_t10dif
> pata_acpi a
> ta_generic ata_piix libata uhci_hcd scsi_mod dock ehci_hcd r8169 usbcore
> thermal processo
> r fan
> [  655.588508]
> [  655.588508] Pid: 6890, comm: udevd Tainted: P          (2.6.27-1-generic #1)
> [  655.588508] EIP: 0060:[<f8f7e8a8>] EFLAGS: 00010246 CPU: 1
> [  655.588508] EIP is at netdev_notify+0x88/0x90 [mac80211]
> [  655.588508] EAX: f8f98ab8 EBX: dc09c800 ECX: dc09c800 EDX: f7918040
> [  655.588508] ESI: fffffff2 EDI: 00000000 EBP: f78abe54 ESP: f78abe24
> [  655.588508]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  655.588508] Process udevd (pid: 6890, ti=f78aa000 task=f609e480
> task.ti=f78aa000)
> [  655.588508] Stack: fffffff3 00000000 f78abe54 c0104ad7 0000000a dc09c800
> f8eb3998 f8ea
> e78e
> [  655.588508]        dc09c800 f8eb3998 f8f98b00 fffffff2 f78abe74 c039512c
> dc09c800 0000
> 000a
> [  655.588508]        00000000 ffffffff 59fa070f 0000000f f78abe88 c014b38e
> ffffffff 0000
> 0000
> [  655.588508] Call Trace:
> [  655.588508]  [<c0104ad7>] ? mcount_call+0x5/0xa
> [  655.588508]  [<f8eae78e>] ? cfg80211_netdev_notifier_call+0xe/0xf0
> [cfg80211]
> [  655.588508]  [<c039512c>] ? notifier_call_chain+0x3c/0x80
> [  655.588508]  [<c014b38e>] ? __raw_notifier_call_chain+0x1e/0x30
> [  655.588508]  [<c014b3bf>] ? raw_notifier_call_chain+0x1f/0x30
> [  655.588508]  [<c03093e6>] ? call_netdevice_notifiers+0x16/0x20
> [  655.588508]  [<c030adda>] ? dev_change_name+0x17a/0x210
> [  655.588508]  [<c030c67b>] ? dev_ifsioc+0x10b/0x2a0
> [  655.588508]  [<c0391973>] ? mutex_lock+0x13/0x30
> [  655.588508]  [<c013a5c0>] ? __capable+0x10/0x30
> [  655.588508]  [<c030c9a9>] ? dev_ioctl+0x199/0x230
> [  655.588508]  [<c02fc73c>] ? sock_ioctl+0xec/0x220
> [  655.588508]  [<c02fc650>] ? sock_ioctl+0x0/0x220
> [  655.588508]  [<c01bd48d>] ? vfs_ioctl+0x2d/0x90
> [  655.588508]  [<c01bd696>] ? do_vfs_ioctl+0x56/0x120
> [  655.588508]  [<c0210315>] ? security_file_ioctl+0x15/0x20
> [  655.588508]  [<c01bd7c3>] ? sys_ioctl+0x63/0x80
> [  655.588508]  [<c0103ec6>] ? syscall_call+0x7/0xb
> [  655.588508]  =======================
> [  655.588508] Code: 2d c7 8b 93 7c 07 00 00 8b 42 18 89 34 24 89 c1 e8 1e 3d
> 28 c7 85 c0
> 75 a2 89 74 24 04 c7 04 24 08 ac f8 f8 e8 fa 42 1b c7 eb 90 <0f> 0b eb fe 8d 74
> 26 00 55 
> 89 e5 83 ec 04 e8 0d 62 18 c7 b8 00
> [  655.588508] EIP: [<f8f7e8a8>] netdev_notify+0x88/0x90 [mac80211] SS:ESP
> 0068:f78abe24
> [  655.588508] ---[ end trace e04f468023f0c671 ]---
> 
> 
> 
> Steps to reproduce: Everytime i boot up with the plugged wlan device and also
> if i try to connect the device while kanotix is running.
> 

Wireless core crashed in netdev_notify().

It might help if you could identify more precisely which kernel version
you're running there.  2.6.27-rc3-git2, for example?

I assume it also crashes when the nvidia driver has never been loaded?


