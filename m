Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34407 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3GAGzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 02:55:37 -0400
Received: by mail-pd0-f180.google.com with SMTP id 10so2342321pdi.39
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jun 2013 23:55:37 -0700 (PDT)
Received: from [10.33.2.158] (a82-1.nat.uq.edu.au. [130.102.82.1])
        by mx.google.com with ESMTPSA id fr1sm20755279pbb.26.2013.06.30.23.55.34
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 30 Jun 2013 23:55:36 -0700 (PDT)
Message-ID: <51D127E4.2080803@gmail.com> (sfid-20130701_085544_134059_F37F321A)
Date: Mon, 01 Jul 2013 16:55:32 +1000
From: Peizhao Hu <peizhao.research@gmail.com>
Reply-To: peizhao.research@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: kernel panic on 3.10.0-rc7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is there anyone has the same problem with me? I have a cm9 radio card 
with the node.

The kernel compiled and booted alright, but crashed short after I set it 
up in the ad hoc mode. From the debug message output, it looks like 
something wrong with the rate control mechanism when it is trying to the 
rate (minstreal_get_rate function in this case).

Is this a bug?

Kernel version
3.10.0-rc7

root@alix-router:~# i[  250.809354] BUG: unable to handle kernel NULL 
pointe8
[  250.812875] IP: [<d0952afa>] minstrel_get_rate+0x1a/0x220 [mac80211]
[  250.812875] *pde = 00000000
[  250.812875] Oops: 0000 [#1] SMP
[  250.812875] Modules linked in: ath5k ath mac80211 cfg80211 arc4 
gpio_cs55]
[  250.812875] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 
3.10.0-rc7-cca+ 1
[  250.812875] Workqueue: phy0 ieee80211_iface_work [mac80211]
[  250.812875] task: c002bfc0 ti: c0076000 task.ti: c0076000
[  250.812875] EIP: 0060:[<d0952afa>] EFLAGS: 00010292 CPU: 0
[  250.812875] EIP is at minstrel_get_rate+0x1a/0x220 [mac80211]
[  250.812875] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: cc2bf1c0
[  250.812875] ESI: ce6cf900 EDI: c0077d00 EBP: c0077cac ESP: c0077c94
[  250.812875]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  250.812875] CR0: 8005003b CR2: 00000038 CR3: 0c245000 CR4: 00000090
[  250.812875] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  250.812875] DR6: ffff0ff0 DR7: 00000400
[  250.812875] Stack:
[  250.812875]  00017901 cc101500 00000180 cc133500 d0967920 cc2bf1e1 
c0077cd
[  250.812875]  c0077d00 00000180 ce525170 00000000 cc2bf1e0 c0077d00 
cc2bf10
[  250.812875]  c0077d24 c0077d30 d0927651 c02c5550 c0077cec d092001c 
cc1335c
[  250.812875] Call Trace:
[  250.812875]  [<d091a8dd>] rate_control_get_rate+0x9d/0xe0 [mac80211]
[  250.812875]  [<d0927651>] ieee80211_beacon_get_tim+0x1a1/0x330 [mac80211]
[  250.812875]  [<d092001c>] ? ieee80211_assign_beacon+0x1bc/0x1c0 
[mac80211]
[  250.812875]  [<d0da3fb9>] ath5k_beacon_update+0x29/0x340 [ath5k]
[  250.812875]  [<d0d99366>] ? ath5k_hw_get_frame_duration+0xa6/0xc0 [ath5k]
[  250.812875]  [<d0d99140>] ? ath5k_hw_set_ifs_intervals+0x110/0x1b0 
[ath5k]
[  250.812875]  [<d0da92d3>] ath5k_bss_info_changed+0x113/0x1f0 [ath5k]
[  250.812875]  [<d0da91c0>] ? ath5k_configure_filter+0x1c0/0x1c0 [ath5k]
[  250.812875]  [<d0908903>] ieee80211_bss_info_change_notify+0xc3/0x1c0 
[ma]
[  250.812875]  [<d09141db>] ? __ieee80211_sta_join_ibss+0x19b/0x660 
[mac802]
[  250.812875]  [<d091442c>] __ieee80211_sta_join_ibss+0x3ec/0x660 
[mac80211]
[  250.812875]  [<c157be33>] ? printk+0x4d/0x4f
[  250.812875]  [<d0915b4d>] ieee80211_ibss_work+0x31d/0x3d0 [mac80211]
[  250.812875]  [<d0916d2d>] ieee80211_iface_work+0x18d/0x310 [mac80211]
[  250.812875]  [<c105025f>] process_one_work+0x10f/0x380
[  250.812875]  [<c104e485>] ? start_worker+0x25/0x30
[  250.812875]  [<c1051000>] ? manage_workers.isra.24+0x180/0x290
[  250.812875]  [<c105120a>] worker_thread+0xfa/0x310
[  250.812875]  [<c1051110>] ? manage_workers.isra.24+0x290/0x290
[  250.812875]  [<c1056674>] kthread+0x94/0xa0
[  250.812875]  [<c158b1f7>] ret_from_kernel_thread+0x1b/0x28
[  250.812875]  [<c10565e0>] ? flush_kthread_worker+0x90/0x90
[  250.812875] Code: 3d fe 93 f0 5d c3 90 90 90 90 90 90 90 90 90 90 90 
55 88
[  250.812875] EIP: [<d0952afa>] minstrel_get_rate+0x1a/0x220 [mac80211] 
SS:4
[  250.812875] CR2: 0000000000000038
[  250.815950] ---[ end trace 87b8337e77cb6664 ]---
[  250.817834] Kernel panic - not syncing: Fatal exception in interrupt



--
Regards;

Peizhao

