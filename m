Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:47467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYI0TwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 15:52:18 -0400
Received: by fg-out-1718.google.com with SMTP id 19so989896fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 12:52:00 -0700 (PDT)
Message-ID: <48DE8EC9.80306@gmail.com> (sfid-20080927_215234_259559_23C8C954)
Date: Sat, 27 Sep 2008 21:51:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: scheduling while atomic: iwl3945 in mmotm 2008-09-23-11-27
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got this through suspend/resume cycle on mmotm 2008-09-23-11-27:

BUG: scheduling while atomic: iwl3945/0/1154/0x00000002
Modules linked in: rfcomm bnep l2cap snd_seq snd_seq_device
cpufreq_userspace acpi_cpufreq fuse loop stkwebcam compat_ioctl32 iwl3945
videodev rfkill v4l1_compat usbhid battery usb_storage asus_laptop
Pid: 1154, comm: iwl3945/0 Tainted: G       AW 2.6.27-rc7-mm1 #57
Call Trace:
 [<ffffffff80235b57>] __schedule_bug+0x67/0x70
 [<ffffffff8057f955>] thread_return+0x117/0x5c2
 [<ffffffff8058231f>] ? _read_unlock+0x2f/0x40
 [<ffffffff8035a9b9>] ? rb_insert_color+0x109/0x140
 [<ffffffff8025ca9a>] ? enqueue_hrtimer+0x8a/0x140
 [<ffffffff805802f5>] schedule_timeout+0x95/0xd0
 [<ffffffff802b3365>] ? __slab_free+0x115/0x3f0
 [<ffffffff8025d5f9>] ? ktime_get_ts+0x59/0x60
 [<ffffffff805800c1>] wait_for_common+0xc1/0x1a0
 [<ffffffff8023e940>] ? default_wake_function+0x0/0x10
 [<ffffffff802cf60a>] ? generic_delete_inode+0xea/0x110
 [<ffffffff80580238>] wait_for_completion+0x18/0x20
 [<ffffffff80257315>] synchronize_rcu+0x35/0x40
 [<ffffffff802573d0>] ? wakeme_after_rcu+0x0/0x10
 [<ffffffff80564e96>] __ieee80211_key_todo+0x16/0x2f0
 [<ffffffff805652b5>] ieee80211_key_todo+0x15/0x30
 [<ffffffff80551d17>] sta_info_destroy+0x47/0x110
 [<ffffffff80559156>] ieee80211_set_disassoc+0x146/0x250
 [<ffffffff805593d5>] ieee80211_sta_req_auth+0x85/0x90
 [<ffffffff8055b156>] ieee80211_notify_mac+0x56/0xa0
 [<ffffffffa0054663>] iwl3945_bg_alive_start+0x2f3/0x360 [iwl3945]
 [<ffffffffa0054370>] ? iwl3945_bg_alive_start+0x0/0x360 [iwl3945]
 [<ffffffff80255599>] run_workqueue+0x99/0x170
 [<ffffffff80255877>] worker_thread+0xa7/0x120
 [<ffffffff80259c50>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802557d0>] ? worker_thread+0x0/0x120
 [<ffffffff80259889>] kthread+0x49/0x90
 [<ffffffff8020d5c9>] child_rip+0xa/0x11
 [<ffffffff80259840>] ? kthread+0x0/0x90
 [<ffffffff8020d5bf>] ? child_rip+0x0/0x11


I don't know who is responsible here. Maybe ieee80211_notify_mac? Citing:
"It is illegal to block while in an RCU read-side critical section." from
rcu_read_lock comments, but synchronize_rcu() in __ieee80211_key_todo()
sleeps and few mutexes are locked and might_sleep() invoked on the path too.
