Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51523 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756029AbXK1PFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:05:35 -0500
Message-ID: <474D83BF.7000102@lwfinger.net> (sfid-20071128_150540_477524_244EF702)
Date: Wed, 28 Nov 2007 09:05:35 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711272120.44575.mb@bu3sch.de> <474C8A8E.6070404@lwfinger.net> <200711281511.22788.mb@bu3sch.de>
In-Reply-To: <200711281511.22788.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> So it's a lock dependency between rfkill->mutex and wl->mutex?
> So, now comes the question that really matters. Who is the caller
> of rfkill_toggle_radio, in the case where it crashes?
>

Here is the full dump. It looks to me as if b43_rfkill_soft_toggle() calls rfkill_handler(), which
calls rfkill_toggle_radio() and it is calling b43_rfkill_soft_toggle(). I'd call that a loop.

kernel:
kernel: =======================================================
kernel: [ INFO: possible circular locking dependency detected ]
kernel: 2.6.24-rc3-L2.6-g65d438bf-dirty #24
kernel: -------------------------------------------------------
kernel: events/0/9 is trying to acquire lock:
kernel:  (&wl->mutex){--..}, at: [<ffffffff882a31e1>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
kernel:
kernel: but task is already holding lock:
kernel:  (&rfkill->mutex){--..}, at: [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:
kernel: which lock already depends on the new lock.
kernel:
kernel:
kernel: the existing dependency chain (in reverse order) is:
kernel:
kernel: -> #2 (&rfkill->mutex){--..}:
kernel:        [<ffffffff8025951c>] __lock_acquire+0xb34/0xd47
kernel:        [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:        [<ffffffff802597b4>] lock_acquire+0x85/0xa9
kernel:        [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:        [<ffffffff8040e32e>] mutex_lock_interruptible_nested+0x113/0x31e
kernel:        [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:        [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:        [<ffffffff8040bd64>] rfkill_register+0x9b/0x107
kernel:        [<ffffffff882a3040>] b43_rfkill_init+0x15e/0x1cb [b43]
kernel:        [<ffffffff88293ad4>] b43_wireless_core_init+0x682/0x784 [b43]
kernel:        [<ffffffff882948a6>] b43_op_start+0x33/0x74 [b43]
kernel:        [<ffffffff881f2a76>] ieee80211_open+0x1c7/0x3dd [mac80211]
kernel:        [<ffffffff803b2fda>] dev_open+0x4e/0x88
kernel:        [<ffffffff803b18a2>] dev_change_flags+0xaf/0x16b
kernel:        [<ffffffff803b9f9d>] do_setlink+0x27a/0x346
kernel:        [<ffffffff8040fa9c>] _read_unlock+0x26/0x2b
kernel:        [<ffffffff803bb233>] rtnl_setlink+0xf9/0x11c
kernel:        [<ffffffff803bb0d3>] rtnetlink_rcv_msg+0x1b6/0x1d5
kernel:        [<ffffffff803baf1d>] rtnetlink_rcv_msg+0x0/0x1d5
kernel:        [<ffffffff803c36a5>] netlink_rcv_skb+0x3e/0xaa
kernel:        [<ffffffff803baf14>] rtnetlink_rcv+0x20/0x29
kernel:        [<ffffffff803c344c>] netlink_unicast+0x1d9/0x23a
kernel:        [<ffffffff803ac19e>] __alloc_skb+0x8a/0x138
kernel:        [<ffffffff803c3c79>] netlink_sendmsg+0x2aa/0x2bd
kernel:        [<ffffffff803a6249>] sock_sendmsg+0xdf/0xf8
kernel:        [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:        [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:        [<ffffffff8025970e>] __lock_acquire+0xd26/0xd47
kernel:        [<ffffffff803a6b7f>] move_addr_to_kernel+0x40/0x49
kernel:        [<ffffffff803ad5b9>] verify_iovec+0x4f/0x8e
kernel:        [<ffffffff803a6443>] sys_sendmsg+0x1e1/0x253
kernel:        [<ffffffff80250916>] up_read+0x26/0x2a
kernel:        [<ffffffff8022581f>] do_page_fault+0x3bf/0x764
kernel:        [<ffffffff803a72c4>] sys_getsockname+0x66/0x8c
kernel:        [<ffffffff80258540>] trace_hardirqs_on+0x11c/0x147
kernel:        [<ffffffff8040f5b8>] trace_hardirqs_on_thunk+0x35/0x3a
kernel:        [<ffffffff8020c0de>] system_call+0x7e/0x83
kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
kernel:
kernel: -> #1 (rfkill_mutex){--..}:
kernel:        [<ffffffff8025951c>] __lock_acquire+0xb34/0xd47
kernel:        [<ffffffff8040bd50>] rfkill_register+0x87/0x107
kernel:        [<ffffffff802597b4>] lock_acquire+0x85/0xa9
kernel:        [<ffffffff8040bd50>] rfkill_register+0x87/0x107
kernel:        [<ffffffff8040bd50>] rfkill_register+0x87/0x107
kernel:        [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
kernel:        [<ffffffff8040bd50>] rfkill_register+0x87/0x107
kernel:        [<ffffffff882a3040>] b43_rfkill_init+0x15e/0x1cb [b43]
kernel:        [<ffffffff88293ad4>] b43_wireless_core_init+0x682/0x784 [b43]
kernel:        [<ffffffff882948a6>] b43_op_start+0x33/0x74 [b43]
kernel:        [<ffffffff881f2a76>] ieee80211_open+0x1c7/0x3dd [mac80211]
kernel:        [<ffffffff803b2fda>] dev_open+0x4e/0x88
kernel:        [<ffffffff803b18a2>] dev_change_flags+0xaf/0x16b
kernel:        [<ffffffff803b9f9d>] do_setlink+0x27a/0x346
kernel:        [<ffffffff8040fa9c>] _read_unlock+0x26/0x2b
kernel:        [<ffffffff803bb233>] rtnl_setlink+0xf9/0x11c
kernel:        [<ffffffff803bb0d3>] rtnetlink_rcv_msg+0x1b6/0x1d5
kernel:        [<ffffffff803baf1d>] rtnetlink_rcv_msg+0x0/0x1d5
kernel:        [<ffffffff803c36a5>] netlink_rcv_skb+0x3e/0xaa
kernel:        [<ffffffff803baf14>] rtnetlink_rcv+0x20/0x29
kernel:        [<ffffffff803c344c>] netlink_unicast+0x1d9/0x23a
kernel:        [<ffffffff803ac19e>] __alloc_skb+0x8a/0x138
kernel:        [<ffffffff803c3c79>] netlink_sendmsg+0x2aa/0x2bd
kernel:        [<ffffffff803a6249>] sock_sendmsg+0xdf/0xf8
kernel:        [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:        [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:        [<ffffffff8025970e>] __lock_acquire+0xd26/0xd47
kernel:        [<ffffffff803a6b7f>] move_addr_to_kernel+0x40/0x49
kernel:        [<ffffffff803ad5b9>] verify_iovec+0x4f/0x8e
kernel:        [<ffffffff803a6443>] sys_sendmsg+0x1e1/0x253
kernel:        [<ffffffff80250916>] up_read+0x26/0x2a
kernel:        [<ffffffff8022581f>] do_page_fault+0x3bf/0x764
kernel:        [<ffffffff803a72c4>] sys_getsockname+0x66/0x8c
kernel:        [<ffffffff80258540>] trace_hardirqs_on+0x11c/0x147
kernel:        [<ffffffff8040f5b8>] trace_hardirqs_on_thunk+0x35/0x3a
kernel:        [<ffffffff8020c0de>] system_call+0x7e/0x83
kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
kernel:
kernel: -> #0 (&wl->mutex){--..}:
kernel:        [<ffffffff80256dd7>] print_circular_bug_entry+0x48/0x4f
kernel:        [<ffffffff8025941e>] __lock_acquire+0xa36/0xd47
kernel:        [<ffffffff882a31e1>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
kernel:        [<ffffffff802597b4>] lock_acquire+0x85/0xa9
kernel:        [<ffffffff882a31e1>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
kernel:        [<ffffffff882a31e1>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
kernel:        [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
kernel:        [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:        [<ffffffff8040bf6f>] rfkill_task_handler+0x0/0x54
kernel:        [<ffffffff882a31e1>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
kernel:        [<ffffffff8040b944>] rfkill_toggle_radio+0x3c/0x7d
kernel:        [<ffffffff8040be96>] rfkill_switch_all+0x3e/0x78
kernel:        [<ffffffff8040bfab>] rfkill_task_handler+0x3c/0x54
kernel:        [<ffffffff80249914>] run_workqueue+0xeb/0x200
kernel:        [<ffffffff8024a500>] worker_thread+0xed/0xfe
kernel:        [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:        [<ffffffff8024a413>] worker_thread+0x0/0xfe
kernel:        [<ffffffff8024da6e>] kthread+0x49/0x77
kernel:        [<ffffffff8020d018>] child_rip+0xa/0x12
kernel:        [<ffffffff8020c72f>] restore_args+0x0/0x30
kernel:        [<ffffffff8024da25>] kthread+0x0/0x77
kernel:        [<ffffffff8020d00e>] child_rip+0x0/0x12
kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
kernel:
kernel: other info that might help us debug this:
kernel:
kernel: 5 locks held by events/0/9:
kernel:  #0:  (events){--..}, at: [<ffffffff802498c9>] run_workqueue+0xa0/0x200
kernel:  #1:  (rfkill_wlan.work){--..}, at: [<ffffffff802498c9>] run_workqueue+0xa0/0x200
kernel:  #2:  (rfkill_wlan.mutex){--..}, at: [<ffffffff8040bf8d>] rfkill_task_handler+0x1e/0x54
kernel:  #3:  (rfkill_mutex){--..}, at: [<ffffffff8040be74>] rfkill_switch_all+0x1c/0x78
kernel:  #4:  (&rfkill->mutex){--..}, at: [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:
kernel: stack backtrace:
kernel:
kernel: Call Trace:
kernel:  [<ffffffff8025779c>] print_circular_bug_tail+0x70/0x7b
kernel:  [<ffffffff80256dd7>] print_circular_bug_entry+0x48/0x4f
kernel:  [<ffffffff8025941e>] __lock_acquire+0xa36/0xd47
kernel:  [<ffffffff882a31e1>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
kernel:  [<ffffffff802597b4>] lock_acquire+0x85/0xa9
kernel:  [<ffffffff882a31e1>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
kernel:  [<ffffffff882a31e1>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
kernel:  [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
kernel:  [<ffffffff8040b927>] rfkill_toggle_radio+0x1f/0x7d
kernel:  [<ffffffff8040bf6f>] rfkill_task_handler+0x0/0x54
kernel:  [<ffffffff882a31e1>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
kernel:  [<ffffffff8040b944>] rfkill_toggle_radio+0x3c/0x7d
kernel:  [<ffffffff8040be96>] rfkill_switch_all+0x3e/0x78
kernel:  [<ffffffff8040bfab>] rfkill_task_handler+0x3c/0x54
kernel:  [<ffffffff80249914>] run_workqueue+0xeb/0x200
kernel:  [<ffffffff8024a500>] worker_thread+0xed/0xfe
kernel:  [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
kernel:  [<ffffffff8024a413>] worker_thread+0x0/0xfe
kernel:  [<ffffffff8024da6e>] kthread+0x49/0x77
kernel:  [<ffffffff8020d018>] child_rip+0xa/0x12
kernel:  [<ffffffff8020c72f>] restore_args+0x0/0x30
kernel:  [<ffffffff8024da25>] kthread+0x0/0x77
kernel:  [<ffffffff8020d00e>] child_rip+0x0/0x12

