Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:61199 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbZGMTrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 15:47:20 -0400
Message-ID: <4A5B8F57.5020601@lwfinger.net>
Date: Mon, 13 Jul 2009 14:47:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
References: <4a5b563e.AuhPXmHA0dUFYtzx%Larry.Finger@lwfinger.net> <1247501812.4166.24.camel@johannes.local>
In-Reply-To: <1247501812.4166.24.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-07-13 at 10:43 -0500, Larry Finger wrote:
>> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
>> may oops when the module is unloaded as the workqueue for led_on was
>> not being cancelled. To prevent interference between cfg80211 and rtl8187,
>> a separate workqueue has also been established.
> 
> It doesn't seem like a separate workqueue should be necessary -- why is
> it? Might make more sense to fix cfg80211 or mac80211 instead.

Probably.

Attached is the dump for the locking error when b43 is unloaded.


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc2-wl #178
-------------------------------------------------------
modprobe/14721 is trying to acquire lock:
 (&rdev->conn_work){+.+.+.}, at: [<ffffffff810510c0>]
__cancel_work_timer+0xd9/0x222

but task is already holding lock:
 (cfg80211_mutex){+.+.+.}, at: [<ffffffffa0220524>]
wiphy_unregister+0x3a/0xf8 [cfg80211]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (cfg80211_mutex){+.+.+.}:
       [<ffffffff8106577b>] __lock_acquire+0x12d3/0x1621
       [<ffffffff81065b82>] lock_acquire+0xb9/0xdd
       [<ffffffff8127b28f>] mutex_lock_nested+0x56/0x2a8
       [<ffffffffa02210c0>] cfg80211_get_dev_from_ifindex+0x17/0x8a
[cfg80211]
       [<ffffffffa0224117>] cfg80211_wext_giwscan+0x40/0xf22 [cfg80211]
       [<ffffffff81269c5a>] ioctl_standard_iw_point+0x198/0x227
       [<ffffffff81269d7e>] ioctl_standard_call+0x95/0xb4
       [<ffffffff81269ed3>] wext_ioctl_dispatch+0x9a/0x172
       [<ffffffff8126a096>] wext_handle_ioctl+0x39/0x6f
       [<ffffffff8120d6ea>] dev_ioctl+0x61e/0x647
       [<ffffffff811fbcaf>] sock_ioctl+0x21d/0x22c
       [<ffffffff810db01c>] vfs_ioctl+0x2a/0x78
       [<ffffffff810db58f>] do_vfs_ioctl+0x4aa/0x4e7
       [<ffffffff810db60e>] sys_ioctl+0x42/0x65
       [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (rtnl_mutex){+.+.+.}:
       [<ffffffff8106577b>] __lock_acquire+0x12d3/0x1621
       [<ffffffff81065b82>] lock_acquire+0xb9/0xdd
       [<ffffffff8127b28f>] mutex_lock_nested+0x56/0x2a8
       [<ffffffff81214e70>] rtnl_lock+0x12/0x14
       [<ffffffffa0230429>] cfg80211_conn_work+0x2b/0x106 [cfg80211]
       [<ffffffff81050618>] worker_thread+0x1fa/0x30a
       [<ffffffff81054b2e>] kthread+0x88/0x90
       [<ffffffff8100cb7a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&rdev->conn_work){+.+.+.}:
       [<ffffffff810654b0>] __lock_acquire+0x1008/0x1621
       [<ffffffff81065b82>] lock_acquire+0xb9/0xdd
       [<ffffffff810510f9>] __cancel_work_timer+0x112/0x222
       [<ffffffff81051223>] cancel_work_sync+0xb/0xd
       [<ffffffffa022055b>] wiphy_unregister+0x71/0xf8 [cfg80211]
       [<ffffffffa026010a>] ieee80211_unregister_hw+0xb9/0xd9 [mac80211]
       [<ffffffffa0296aee>] b43_remove+0x53/0x8a [b43]
       [<ffffffffa01a2201>] ssb_device_remove+0x2b/0x3f [ssb]
       [<ffffffff811d82d2>] __device_release_driver+0x80/0xc9
       [<ffffffff811d83a2>] driver_detach+0x87/0xad
       [<ffffffff811d75ab>] bus_remove_driver+0x89/0xb9
       [<ffffffff811d88ab>] driver_unregister+0x66/0x6e
       [<ffffffffa01a32eb>] ssb_driver_unregister+0xd/0xf [ssb]
       [<ffffffffa02ab794>] b43_exit+0x10/0x17 [b43]
       [<ffffffff8106dfd0>] sys_delete_module+0x1d3/0x249
       [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by modprobe/14721:
 #0:  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa0220524>]
wiphy_unregister+0x3a/0xf8 [cfg80211]

stack backtrace:
Pid: 14721, comm: modprobe Not tainted 2.6.31-rc2-wl #178
Call Trace:
 [<ffffffff8106400d>] print_circular_bug_tail+0xc1/0xcc
 [<ffffffff810654b0>] __lock_acquire+0x1008/0x1621
 [<ffffffff81063f18>] ? check_noncircular+0xe4/0x118
 [<ffffffff81064496>] ? check_irq_usage+0xb3/0xc5
 [<ffffffff81065b82>] lock_acquire+0xb9/0xdd
 [<ffffffff810510c0>] ? __cancel_work_timer+0xd9/0x222
 [<ffffffff810510f9>] __cancel_work_timer+0x112/0x222
 [<ffffffff810510c0>] ? __cancel_work_timer+0xd9/0x222
 [<ffffffff810635b2>] ? mark_held_locks+0x4d/0x6b
 [<ffffffff810635b2>] ? mark_held_locks+0x4d/0x6b
 [<ffffffff8127b0d7>] ? __mutex_unlock_slowpath+0x10d/0x119
 [<ffffffff81063825>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff81063856>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81051223>] cancel_work_sync+0xb/0xd
 [<ffffffffa022055b>] wiphy_unregister+0x71/0xf8 [cfg80211]
 [<ffffffffa026010a>] ieee80211_unregister_hw+0xb9/0xd9 [mac80211]
 [<ffffffffa0296aee>] b43_remove+0x53/0x8a [b43]
 [<ffffffffa01a2201>] ssb_device_remove+0x2b/0x3f [ssb]
 [<ffffffff811d82d2>] __device_release_driver+0x80/0xc9
 [<ffffffff811d83a2>] driver_detach+0x87/0xad
 [<ffffffff811d75ab>] bus_remove_driver+0x89/0xb9
 [<ffffffff811d88ab>] driver_unregister+0x66/0x6e
 [<ffffffffa01a32eb>] ssb_driver_unregister+0xd/0xf [ssb]
 [<ffffffffa02ab794>] b43_exit+0x10/0x17 [b43]
 [<ffffffff8106dfd0>] sys_delete_module+0x1d3/0x249
 [<ffffffff81063825>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff8127c726>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
b43-pci-bridge 0000:04:00.0: PCI INT A disabled
