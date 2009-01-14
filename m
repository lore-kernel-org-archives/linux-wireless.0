Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:65408 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZANWvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 17:51:22 -0500
Received: by wf-out-1314.google.com with SMTP id 27so893994wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 14:51:21 -0800 (PST)
Subject: Lots of minstrel WARN_ONS with current -git
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 14:51:20 -0800
Message-Id: <1231973480.5147.2.camel@brick> (sfid-20090114_235126_970511_33D14CEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seeing lots of these WARN_ONS with current -git.  Known issue?

b43 hardware.

[41850.615621] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0x92/0x3c0()
[41850.615624] Hardware name: TravelMate 2480 
[41850.615626] Modules linked in: uhci_hcd ehci_hcd usbcore ipv6 binfmt_misc rfcomm bnep sco l2cap bluetooth ppdev lp joydev psmouse serio_raw tifm_7xx1 tifm_core video output evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod crc_t10dif fuse [last unloaded: usbcore]
[41850.615652] Pid: 1024, comm: phy0 Tainted: G        W  2.6.29-rc1 #11
[41850.615654] Call Trace:
[41850.615660]  [<c0487935>] ? printk+0x18/0x1b
[41850.615665]  [<c012ee43>] warn_slowpath+0x73/0xd0
[41850.615671]  [<c0148cc5>] ? sched_clock_cpu+0x135/0x190
[41850.615674]  [<c0147b5b>] ? up+0x2b/0x40
[41850.615677]  [<c012f631>] ? release_console_sem+0x191/0x1d0
[41850.615681]  [<c046f522>] minstrel_rate_init+0x92/0x3c0
[41850.615686]  [<c0454708>] ? ieee80211_rx_bss_get+0x98/0xb0
[41850.615689]  [<c0458ddb>] ? set_sta_flags+0x2b/0x40
[41850.615693]  [<c0459955>] ieee80211_rx_mgmt_assoc_resp+0x565/0xd60
[41850.615699]  [<c03b2ba4>] ? dev_queue_xmit+0xe4/0x5a0
[41850.615705]  [<c03a85e8>] ? __kfree_skb+0x38/0x90
[41850.615708]  [<c045ab50>] ? ieee80211_sta_work+0x0/0x760
[41850.615712]  [<c045a7c3>] ieee80211_sta_rx_queued_mgmt+0x673/0xa00
[41850.615715]  [<c03b1cfb>] ? dev_hard_start_xmit+0x25b/0x2f0
[41850.615719]  [<c0148cc5>] ? sched_clock_cpu+0x135/0x190
[41850.615723]  [<c011d0a9>] ? update_curr+0x99/0x200
[41850.615726]  [<c0120426>] ? dequeue_entity+0x16/0x2a0
[41850.615730]  [<c0121088>] ? dequeue_task_fair+0x68/0x70
[41850.615733]  [<c011ddef>] ? dequeue_task+0xcf/0x130
[41850.615736]  [<c03a81cd>] ? skb_dequeue+0x4d/0x70
[41850.615739]  [<c045ab50>] ? ieee80211_sta_work+0x0/0x760
[41850.615743]  [<c045abc1>] ieee80211_sta_work+0x71/0x760
[41850.615746]  [<c0487e47>] ? schedule+0x3b7/0x9f0
[41850.615749]  [<c045ab50>] ? ieee80211_sta_work+0x0/0x760
[41850.615754]  [<c013fa4d>] run_workqueue+0x5d/0x110
[41850.615757]  [<c013fb88>] worker_thread+0x88/0xf0
[41850.615760]  [<c0143660>] ? autoremove_wake_function+0x0/0x50
[41850.615764]  [<c013fb00>] ? worker_thread+0x0/0xf0
[41850.615767]  [<c01432ec>] kthread+0x3c/0x70
[41850.615769]  [<c01432b0>] ? kthread+0x0/0x70
[41850.615773]  [<c0103e87>] kernel_thread_helper+0x7/0x10
[41850.615776] ---[ end trace 8289e1ba6ce8ea7b ]---

