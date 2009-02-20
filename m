Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19171 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZBTCcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 21:32:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 18:32:31 -0800
Date: Thu, 19 Feb 2009 18:31:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: Lockdep rtnl_mutex and genl_mutex circular dependency
Message-ID: <20090220023144.GE4740@tesla> (sfid-20090220_033236_226088_BAC87115)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just running 'iw list' a few times I got this. I have a few patches on
top of wl, but this doesn't seem to be related to those.

[ 1210.318826] =======================================================
[ 1210.319991] [ INFO: possible circular locking dependency detected ]
[ 1210.319991] 2.6.29-rc5-wl #10
[ 1210.319991] -------------------------------------------------------
[ 1210.319991] iw/6553 is trying to acquire lock:
[ 1210.319991]  (genl_mutex){--..}, at: [<ffffffff804f6e42>] netlink_dump_start+0xf2/0x1b0
[ 1210.444143] 
[ 1210.444143] but task is already holding lock:
[ 1210.444143]  (rtnl_mutex){--..}, at: [<ffffffff804e5db2>] rtnl_lock+0x12/0x20
[ 1210.444143] 
[ 1210.444143] which lock already depends on the new lock.
[ 1210.444143] 
[ 1210.444143] 
[ 1210.444143] the existing dependency chain (in reverse order) is:
[ 1210.444143] 
[ 1210.444143] -> #1 (rtnl_mutex){--..}:
[ 1210.444143]        [<ffffffff8026ba09>] __lock_acquire+0xd99/0x12c0
[ 1210.444143]        [<ffffffff8026bf86>] lock_acquire+0x56/0x80
[ 1210.444143]        [<ffffffff805bb682>] mutex_lock_nested+0xa2/0x320
[ 1210.444143]        [<ffffffff804e5db2>] rtnl_lock+0x12/0x20
[ 1210.444143]        [<ffffffffa00bcf59>] 0xffffffffa00bcf59
[ 1210.444143]        [<ffffffff804f8450>] genl_rcv_msg+0x1d0/0x260
[ 1210.444143]        [<ffffffff804f66e9>] netlink_rcv_skb+0x89/0xb0
[ 1210.444143]        [<ffffffff804f8269>] genl_rcv+0x29/0x40
[ 1210.444143]        [<ffffffff804f6484>] netlink_unicast+0x2d4/0x2f0
[ 1210.444143]        [<ffffffff804f75a9>] netlink_sendmsg+0x1f9/0x2e0
[ 1210.444143]        [<ffffffff804ca43f>] sock_sendmsg+0xdf/0x110
[ 1210.444143]        [<ffffffff804ca5b5>] sys_sendmsg+0x145/0x280
[ 1210.444143]        [<ffffffff8020c6db>] system_call_fastpath+0x16/0x1b
[ 1210.444143]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1210.444143] 
[ 1210.444143] -> #0 (genl_mutex){--..}:
[ 1210.444143]        [<ffffffff8026bad2>] __lock_acquire+0xe62/0x12c0
[ 1210.444143]        [<ffffffff8026bf86>] lock_acquire+0x56/0x80
[ 1210.444143]        [<ffffffff805bb682>] mutex_lock_nested+0xa2/0x320
[ 1210.444143]        [<ffffffff804f6e42>] netlink_dump_start+0xf2/0x1b0
[ 1210.444143]        [<ffffffff804f848f>] genl_rcv_msg+0x20f/0x260
[ 1210.444143]        [<ffffffff804f66e9>] netlink_rcv_skb+0x89/0xb0
[ 1210.444143]        [<ffffffff804f8269>] genl_rcv+0x29/0x40
[ 1210.444143]        [<ffffffff804f6484>] netlink_unicast+0x2d4/0x2f0
[ 1210.444143]        [<ffffffff804f75a9>] netlink_sendmsg+0x1f9/0x2e0
[ 1210.444143]        [<ffffffff804ca43f>] sock_sendmsg+0xdf/0x110
[ 1210.444143]        [<ffffffff804ca5b5>] sys_sendmsg+0x145/0x280
[ 1210.444143]        [<ffffffff8020c6db>] system_call_fastpath+0x16/0x1b
[ 1210.444143]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1210.444143] other info that might help us debug this:
[ 1210.444143] 
[ 1210.444143] 1 lock held by iw/6553:
[ 1210.444143]  #0:  (rtnl_mutex){--..}, at: [<ffffffff804e5db2>] rtnl_lock+0x12/0x20
[ 1210.444143] 
[ 1210.444143] stack backtrace:
[ 1210.444143] Pid: 6553, comm: iw Not tainted 2.6.29-rc5-wl #10
[ 1210.444143] Call Trace:
[ 1210.444143]  [<ffffffff80269e5c>] print_circular_bug_tail+0xac/0x110
[ 1210.444143]  [<ffffffff8026bad2>] __lock_acquire+0xe62/0x12c0
[ 1210.444143]  [<ffffffff804f6e42>] ? netlink_dump_start+0xf2/0x1b0
[ 1210.444143]  [<ffffffff8026bf86>] lock_acquire+0x56/0x80
[ 1210.444143]  [<ffffffff804f6e42>] ? netlink_dump_start+0xf2/0x1b0
[ 1210.444143]  [<ffffffff805bb682>] mutex_lock_nested+0xa2/0x320
[ 1210.444143]  [<ffffffff804f6e42>] ? netlink_dump_start+0xf2/0x1b0
[ 1210.444143]  [<ffffffff804f6e42>] netlink_dump_start+0xf2/0x1b0
[ 1210.444143]  [<ffffffff804f848f>] genl_rcv_msg+0x20f/0x260
[ 1210.444143]  [<ffffffff805bb82c>] ? mutex_lock_nested+0x24c/0x320
[ 1210.444143]  [<ffffffff804f825a>] ? genl_rcv+0x1a/0x40
[ 1210.444143]  [<ffffffff804f8280>] ? genl_rcv_msg+0x0/0x260
[ 1210.444143]  [<ffffffff804f66e9>] netlink_rcv_skb+0x89/0xb0
[ 1210.444143]  [<ffffffff804f8269>] genl_rcv+0x29/0x40
[ 1210.444143]  [<ffffffff804f62d3>] ? netlink_unicast+0x123/0x2f0
[ 1210.444143]  [<ffffffff804f6484>] netlink_unicast+0x2d4/0x2f0
[ 1210.444143]  [<ffffffff804d17de>] ? __alloc_skb+0x6e/0x140
[ 1210.444143]  [<ffffffff804f75a9>] netlink_sendmsg+0x1f9/0x2e0
[ 1210.444143]  [<ffffffff804ca43f>] sock_sendmsg+0xdf/0x110
[ 1210.444143]  [<ffffffff80258700>] ? autoremove_wake_function+0x0/0x40
[ 1210.444143]  [<ffffffff804cb047>] ? move_addr_to_kernel+0x57/0x60
[ 1210.444143]  [<ffffffff804d424f>] ? verify_iovec+0x3f/0xe0
[ 1210.444143]  [<ffffffff804ca5b5>] sys_sendmsg+0x145/0x280
[ 1210.444143]  [<ffffffff805c04b6>] ? do_page_fault+0x316/0xa10
[ 1210.444143]  [<ffffffff804cb37d>] ? move_addr_to_user+0x9d/0xb0
[ 1210.444143]  [<ffffffff804cb809>] ? sys_getsockname+0x99/0xa0
[ 1210.444143]  [<ffffffff8026a9ba>] ? trace_hardirqs_on_caller+0x14a/0x1a0
[ 1210.444143]  [<ffffffff805bd1ef>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1210.444143]  [<ffffffff8020c6db>] system_call_fastpath+0x16/0x1b

