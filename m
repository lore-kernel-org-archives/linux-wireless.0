Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64971 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZKWJ2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 04:28:18 -0500
Received: by bwz27 with SMTP id 27so4782679bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 01:28:23 -0800 (PST)
Subject: RFKILL related oops on iwl3945 reload
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 11:28:19 +0200
Message-ID: <1258968499.3271.5.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed pretty wierd oops message, but found that it is always
reproduciable.

Just have any program listen to rfkill events, and reload the wireless
module (this also reloads all wireless modules)
I use small script that does modprobe -r $1  && modprobe $1

Below, backtrace that triggered by running 'rfkill event' and reloading
the module.
NM+wpa_supplicant(nl80211) did run, and began association process before
the oops.

This is usually triggered by bluetooth-applet that now listens to rfkill
events as well.


<1>[  254.182693] BUG: unable to handle kernel paging request at ffffffffa0b8c058
<1>[  254.182722] IP: [<ffffffff810e2fc3>] do_sys_poll+0x223/0x530
<4>[  254.182750] PGD 1003067 PUD 1007063 PMD 68ac5067 PTE 0
<0>[  254.182774] Oops: 0000 [#1] PREEMPT SMP 
<0>[  254.182792] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
<4>[  254.182813] CPU 1 
<4>[  254.182822] Modules linked in: iwl3945 iwlcore mac80211 cfg80211 rfkill af_packet nfsd exportfs usb_storage usb_libusual nfs cpufreq_powersave cpufreq_conservative cpufreq_userspace snd_hda_codec_realtek uvcvideo lockd snd_hda_intel nfs_acl videodev snd_hda_codec acpi_cpufreq v4l1_compat joydev snd_hwdep v4l2_compat_ioctl32 tg3 coretemp ohci1394 uhci_hcd auth_rpcgss psmouse sbp2 video snd_pcm ehci_hcd serio_raw libphy nvidia(P) output ieee1394 snd_page_alloc usbcore battery ac lirc_ene0100 evdev sunrpc fuse lzo lzo_decompress lzo_compress [last unloaded: rfkill]
<6>[  254.183040] Pid: 4107, comm: rfkill Tainted: P           2.6.32-rc8-wl #211 Aspire 5720     
<6>[  254.183063] RIP: 0010:[<ffffffff810e2fc3>]  [<ffffffff810e2fc3>] do_sys_poll+0x223/0x530
<6>[  254.183091] RSP: 0018:ffff88006bae1b28  EFLAGS: 00010282
<6>[  254.183108] RAX: ffffffffa0b8c020 RBX: ffff88006bae1f04 RCX: ffff88006bae1df8
<6>[  254.183128] RDX: ffff88006bae1df8 RSI: ffff88006bae1f04 RDI: 0000000000000003
<6>[  254.183149] RBP: ffff88006bae1f38 R08: 0000000000000002 R09: 0000000000000001
<6>[  254.183170] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88006bae1e0c
<6>[  254.183190] R13: ffff88006bae1e04 R14: ffff88004239ec80 R15: 0000000000000000
<6>[  254.183212] FS:  00007f6fae1cb6f0(0000) GS:ffff880002300000(0000) knlGS:0000000000000000
<6>[  254.183235] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<6>[  254.183252] CR2: ffffffffa0b8c058 CR3: 0000000054eee000 CR4: 00000000000006e0
<6>[  254.183273] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<6>[  254.183294] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[  254.183315] Process rfkill (pid: 4107, threadinfo ffff88006bae0000, task ffff8800421a8fb0)
<0>[  254.183337] Stack:
<4>[  254.183345]  ffff880002313c40 ffff88006e9f9980 00ff88006bae1b48 ffff8800421a8fb0
<4>[  254.183371] <0> 00007fff03e9fbb0 0000000000000000 ffff88006bae1b88 0000000002313c40
<4>[  254.183399] <0> 0000000000000000 0000000000000000 ffff88006bae1df8 00000000421a8fb0
<0>[  254.183429] Call Trace:
<4>[  254.183444]  [<ffffffff810e4330>] ? __pollwait+0x0/0xf0
<4>[  254.183464]  [<ffffffff810e4420>] ? pollwake+0x0/0x60
<4>[  254.183484]  [<ffffffff810371dd>] ? task_rq_lock+0x4d/0x90
<4>[  254.183505]  [<ffffffff8106bbfd>] ? trace_hardirqs_off+0xd/0x10
<4>[  254.183528]  [<ffffffff8138ff7d>] ? _spin_unlock_irqrestore+0x3d/0x80
<4>[  254.183551]  [<ffffffff8103ef03>] ? try_to_wake_up+0x1d3/0x240
<4>[  254.183571]  [<ffffffff8106cf3d>] ? trace_hardirqs_on+0xd/0x10
<4>[  254.183592]  [<ffffffff8138ff7d>] ? _spin_unlock_irqrestore+0x3d/0x80
<4>[  254.183614]  [<ffffffff81036f0e>] ? __wake_up+0x4e/0x70
<4>[  254.183634]  [<ffffffff8106cf3d>] ? trace_hardirqs_on+0xd/0x10
<4>[  254.183655]  [<ffffffff81036f0e>] ? __wake_up+0x4e/0x70
<4>[  254.183673]  [<ffffffff8106cf3d>] ? trace_hardirqs_on+0xd/0x10
<4>[  254.183694]  [<ffffffff81248c79>] ? tty_ldisc_deref+0x9/0x10
<4>[  254.183716]  [<ffffffff81241dc2>] ? tty_write+0x242/0x2b0
<4>[  254.183737]  [<ffffffff810d2e82>] ? vfs_write+0x132/0x1a0
<4>[  254.183757]  [<ffffffff810e34b7>] sys_poll+0x77/0x110
<4>[  254.183778]  [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
<0>[  254.183796] Code: 00 0f 1f 80 00 00 00 00 48 89 de e8 08 08 ff ff 49 89 c6 48 85 c0 66 90 0f 84 9a 01 00 00 48 8b 40 20 48 85 c0 0f 84 7d 01 00 00 <48> 8b 40 38 48 85 c0 0f 84 70 01 00 00 4d 85 ff 74 18 41 0f b7 
<1>[  254.183946] RIP  [<ffffffff810e2fc3>] do_sys_poll+0x223/0x530
<4>[  254.183967]  RSP <ffff88006bae1b28>
<0>[  254.183979] CR2: ffffffffa0b8c058
<4>[  254.183994] ---[ end trace 9f0741bcb03a2591 ]---


