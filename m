Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:38296 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZCQQQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 12:16:53 -0400
Message-ID: <49BFCCC5.9080500@lwfinger.net> (sfid-20090317_171658_112665_EE683184)
Date: Tue, 17 Mar 2009 11:16:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Possible circular locking problem
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing usage of b43legacy as an AP, I got the following in my logs. My
kernel is the latest wireless-testing that was pulled about 2 hours ago -
hostapd is 0.6.8.

Larry

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc8-wl #89
-------------------------------------------------------
hostapd/6686 is trying to acquire lock:
 (rtnl_mutex){--..}, at: [<ffffffff803e45b8>] rtnl_lock+0x12/0x14

but task is already holding lock:
 (&drv->mtx){--..}, at: [<ffffffffa01e2a60>]
cfg80211_get_dev_from_info+0x101/0x115 [cfg80211]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&drv->mtx){--..}:
       [<ffffffff8025ed1f>] __lock_acquire+0x12b4/0x161e
       [<ffffffff8025f0de>] lock_acquire+0x55/0x71
       [<ffffffff804490d2>] mutex_lock_nested+0x111/0x2ae
       [<ffffffffa01e293a>] cfg80211_get_dev_from_ifindex+0x65/0x8a [cfg80211]
       [<ffffffffa01e4ef5>] cfg80211_wext_giwscan+0x40/0xe8a [cfg80211]
       [<ffffffff804382bd>] ioctl_standard_iw_point+0x16d/0x1fc
       [<ffffffff804383e1>] ioctl_standard_call+0x95/0xb4
       [<ffffffff8043852b>] wext_ioctl_dispatch+0x9a/0x172
       [<ffffffff804386ee>] wext_handle_ioctl+0x39/0x6f
       [<ffffffff803dd0a8>] dev_ioctl+0x611/0x63a
       [<ffffffff803cc9df>] sock_ioctl+0x20e/0x21d
       [<ffffffff802bc050>] vfs_ioctl+0x2a/0x78
       [<ffffffff802bc509>] do_vfs_ioctl+0x46b/0x4ab
       [<ffffffff802bc58b>] sys_ioctl+0x42/0x65
       [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (cfg80211_mutex){--..}:
       [<ffffffff8025ed1f>] __lock_acquire+0x12b4/0x161e
       [<ffffffff8025f0de>] lock_acquire+0x55/0x71
       [<ffffffff804490d2>] mutex_lock_nested+0x111/0x2ae
       [<ffffffffa01e28ec>] cfg80211_get_dev_from_ifindex+0x17/0x8a [cfg80211]
       [<ffffffffa01e4ef5>] cfg80211_wext_giwscan+0x40/0xe8a [cfg80211]
       [<ffffffff804382bd>] ioctl_standard_iw_point+0x16d/0x1fc
       [<ffffffff804383e1>] ioctl_standard_call+0x95/0xb4
       [<ffffffff8043852b>] wext_ioctl_dispatch+0x9a/0x172
       [<ffffffff804386ee>] wext_handle_ioctl+0x39/0x6f
       [<ffffffff803dd0a8>] dev_ioctl+0x611/0x63a
       [<ffffffff803cc9df>] sock_ioctl+0x20e/0x21d
       [<ffffffff802bc050>] vfs_ioctl+0x2a/0x78
       [<ffffffff802bc509>] do_vfs_ioctl+0x46b/0x4ab
       [<ffffffff802bc58b>] sys_ioctl+0x42/0x65
       [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (rtnl_mutex){--..}:
       [<ffffffff8025e9ee>] __lock_acquire+0xf83/0x161e
       [<ffffffff8025f0de>] lock_acquire+0x55/0x71
       [<ffffffff804490d2>] mutex_lock_nested+0x111/0x2ae
       [<ffffffff803e45b8>] rtnl_lock+0x12/0x14
       [<ffffffffa01eac78>] nl80211_new_interface+0xb8/0x18d [cfg80211]
       [<ffffffff803ef5be>] genl_rcv_msg+0x19a/0x1bb
       [<ffffffff803ee7a2>] netlink_rcv_skb+0x3e/0x90
       [<ffffffff803ef414>] genl_rcv+0x29/0x39
       [<ffffffff803ee282>] netlink_unicast+0x1fe/0x274
       [<ffffffff803ee575>] netlink_sendmsg+0x27d/0x290
       [<ffffffff803cd17d>] sock_sendmsg+0xdf/0xf8
       [<ffffffff803cd368>] sys_sendmsg+0x1d2/0x23c
       [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by hostapd/6686:
 #0:  (genl_mutex){--..}, at: [<ffffffff803ef405>] genl_rcv+0x1a/0x39
 #1:  (&drv->mtx){--..}, at: [<ffffffffa01e2a60>]
cfg80211_get_dev_from_info+0x101/0x115 [cfg80211]

stack backtrace:
Pid: 6686, comm: hostapd Not tainted 2.6.29-rc8-wl #89
Call Trace:
 [<ffffffff8025d685>] print_circular_bug_tail+0xc5/0xd0
 [<ffffffff8025e9ee>] __lock_acquire+0xf83/0x161e
 [<ffffffffa01e2a60>] ? cfg80211_get_dev_from_info+0x101/0x115 [cfg80211]
 [<ffffffff8025f0de>] lock_acquire+0x55/0x71
 [<ffffffff803e45b8>] ? rtnl_lock+0x12/0x14
 [<ffffffff804490d2>] mutex_lock_nested+0x111/0x2ae
 [<ffffffff803e45b8>] ? rtnl_lock+0x12/0x14
 [<ffffffff803e45b8>] ? rtnl_lock+0x12/0x14
 [<ffffffff803e45b8>] rtnl_lock+0x12/0x14
 [<ffffffffa01eac78>] nl80211_new_interface+0xb8/0x18d [cfg80211]
 [<ffffffff803eeb6b>] ? validate_nla+0x96/0x141
 [<ffffffff803ef5be>] genl_rcv_msg+0x19a/0x1bb
 [<ffffffff803ef424>] ? genl_rcv_msg+0x0/0x1bb
 [<ffffffff803ee7a2>] netlink_rcv_skb+0x3e/0x90
 [<ffffffff803ef414>] genl_rcv+0x29/0x39
 [<ffffffff803ee180>] ? netlink_unicast+0xfc/0x274
 [<ffffffff803ee282>] netlink_unicast+0x1fe/0x274
 [<ffffffff803d4310>] ? __alloc_skb+0x6f/0x131
 [<ffffffff803ee575>] netlink_sendmsg+0x27d/0x290
 [<ffffffff803cd17d>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024f1c4>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8044acf0>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff803cdb68>] ? move_addr_to_kernel+0x40/0x49
 [<ffffffff803d5502>] ? verify_iovec+0x4f/0x91
 [<ffffffff803cd368>] sys_sendmsg+0x1d2/0x23c
 [<ffffffff802be90d>] ? __d_free+0x55/0x59
 [<ffffffff802be943>] ? d_free+0x32/0x4c
 [<ffffffff802c5577>] ? mntput_no_expire+0x2a/0x13d
 [<ffffffff802b1012>] ? __fput+0x19c/0x1a9
 [<ffffffff8025d14b>] ? trace_hardirqs_on_caller+0x114/0x138
 [<ffffffff8044a8cc>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8032ac62>] ? __up_read+0x1c/0x9a
 [<ffffffff8020c0db>] system_call_fastpath+0x16/0x1b
