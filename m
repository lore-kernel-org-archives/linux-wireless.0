Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50388 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIAS21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 14:28:27 -0400
Received: by mail-ie0-f177.google.com with SMTP id tp5so6136926ieb.8
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 11:28:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Sep 2014 23:58:26 +0530
Message-ID: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com> (sfid-20140901_202830_749680_0B16CBFA)
Subject: Help needed to interpret kernel warning and call trace
From: Amitav Mohanty <amitavmohanty01@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey

How do I interpret the following kernel warning?

Sep 01 17:13:30 TSS-ARCH kernel: ------------[ cut here ]------------
Sep 01 17:13:30 TSS-ARCH kernel: WARNING: CPU: 0 PID: 4 at
net/wireless/reg.c:1806 reg_process_hint+0x2d1/0x460 [cfg80211]()
Sep 01 17:13:30 TSS-ARCH kernel: Modules linked in: ctr ccm fuse arc4
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common
videodev iwldvm dell_wmi nvidia
Sep 01 17:13:30 TSS-ARCH kernel:  mei_me mei tpm_tis tpm battery video
ac button processor cpufreq_userspace cpufreq_powersave ext4 crc16
mbcache jbd2 sd_mod sr_mod cdrom c
Sep 01 17:13:30 TSS-ARCH kernel: CPU: 0 PID: 4 Comm: kworker/0:0
Tainted: P           O  3.16.1-1-ARCH #1
Sep 01 17:13:30 TSS-ARCH kernel: Hardware name: Dell Inc. Latitude
E6520/0J4TFW, BIOS A06 07/11/2011
Sep 01 17:13:30 TSS-ARCH kernel: Workqueue: events reg_todo [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  0000000000000000 00000000a89ed9aa
ffff88022216fd50 ffffffff8152ae6c
Sep 01 17:13:30 TSS-ARCH kernel:  0000000000000000 ffff88022216fd88
ffffffff8106e45d ffff8800c547a300
Sep 01 17:13:30 TSS-ARCH kernel:  ffff8800c7e18260 ffff8800c547a31c
ffff88022dc18000 0ffff88022dc1800
Sep 01 17:13:30 TSS-ARCH kernel: Call Trace:
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8152ae6c>] dump_stack+0x4d/0x6f
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8106e45d>]
warn_slowpath_common+0x7d/0xa0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8106e58a>]
warn_slowpath_null+0x1a/0x20
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffffa048e3c1>]
reg_process_hint+0x2d1/0x460 [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffffa048e5c9>]
reg_todo+0x79/0x1a0 [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108afa8>]
process_one_work+0x168/0x450
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108b5db>] worker_thread+0x6b/0x550
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108b570>] ?
init_pwq.part.22+0x10/0x10
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091cea>] kthread+0xea/0x100
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091c00>] ?
kthread_create_on_node+0x1b0/0x1b0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81530b3c>] ret_from_fork+0x7c/0xb0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091c00>] ?
kthread_create_on_node+0x1b0/0x1b0
Sep 01 17:13:30 TSS-ARCH kernel: ---[ end trace ffb56350dc197a6a ]---
Sep 01 17:13:30 TSS-ARCH kernel: cfg80211: Calling CRDA for country: US
Sep 01 17:13:30 TSS-ARCH kernel: ------------[ cut here ]------------
Sep 01 17:13:30 TSS-ARCH kernel: WARNING: CPU: 0 PID: 4 at
net/wireless/reg.c:1806 reg_process_hint+0x2d1/0x460 [cfg80211]()
Sep 01 17:13:30 TSS-ARCH kernel: Modules linked in: ctr ccm fuse arc4
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common
videodev iwldvm dell_wmi nvidia
Sep 01 17:13:30 TSS-ARCH kernel:  mei_me mei tpm_tis tpm battery video
ac button processor cpufreq_userspace cpufreq_powersave ext4 crc16
mbcache jbd2 sd_mod sr_mod cdrom c
Sep 01 17:13:30 TSS-ARCH kernel: CPU: 0 PID: 4 Comm: kworker/0:0
Tainted: P        W  O  3.16.1-1-ARCH #1
Sep 01 17:13:30 TSS-ARCH kernel: Hardware name: Dell Inc. Latitude
E6520/0J4TFW, BIOS A06 07/11/2011
Sep 01 17:13:30 TSS-ARCH kernel: Workqueue: events reg_todo [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  0000000000000000 00000000a89ed9aa
ffff88022216fd50 ffffffff8152ae6c
Sep 01 17:13:30 TSS-ARCH kernel:  0000000000000000 ffff88022216fd88
ffffffff8106e45d ffff8800c547a300
Sep 01 17:13:30 TSS-ARCH kernel:  ffff8800c7e18260 ffff8800c547a31c
ffff88022dc18000 0ffff88022dc1800
Sep 01 17:13:30 TSS-ARCH kernel: Call Trace:
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8152ae6c>] dump_stack+0x4d/0x6f
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8106e45d>]
warn_slowpath_common+0x7d/0xa0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8106e58a>]
warn_slowpath_null+0x1a/0x20
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffffa048e3c1>]
reg_process_hint+0x2d1/0x460 [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffffa048e5c9>]
reg_todo+0x79/0x1a0 [cfg80211]
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108afa8>]
process_one_work+0x168/0x450
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108b5db>] worker_thread+0x6b/0x550
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff8108b570>] ?
init_pwq.part.22+0x10/0x10
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091cea>] kthread+0xea/0x100
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091c00>] ?
kthread_create_on_node+0x1b0/0x1b0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81530b3c>] ret_from_fork+0x7c/0xb0
Sep 01 17:13:30 TSS-ARCH kernel:  [<ffffffff81091c00>] ?
kthread_create_on_node+0x1b0/0x1b0
Sep 01 17:13:30 TSS-ARCH kernel: ---[ end trace ffb56350dc197a6b ]---
Sep 01 17:13:30 TSS-ARCH kernel: cfg80211: Calling CRDA for country: US

Please suggest.

Thanks and regards,
Amitav
