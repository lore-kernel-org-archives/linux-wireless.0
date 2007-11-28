Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:57936 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbXK1Qly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:41:54 -0500
Message-ID: <474D9A46.1020300@lwfinger.net> (sfid-20071128_164159_449158_E036DDB9)
Date: Wed, 28 Nov 2007 10:41:42 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711281511.22788.mb@bu3sch.de> <474D83BF.7000102@lwfinger.net> <200711281713.02919.mb@bu3sch.de>
In-Reply-To: <200711281713.02919.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> I think it's a different bug. The backtrace seems corrupted.
> 
> Can you try this patch? There is some circular locking in rfkill.

I still get circular locking. The dump is

b43-phy0: Radio hardware status changed to DISABLED
b43-phy0: Radio hardware status changed to ENABLED

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc3-L2.6-g65d438bf-dirty #25
-------------------------------------------------------
events/0/9 is trying to acquire lock:
 (&wl->mutex){--..}, at: [<ffffffff882081d9>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]

but task is already holding lock:
 (rfkill_mutex){--..}, at: [<ffffffff8040be7c>] rfkill_switch_all+0x1c/0x78

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rfkill_mutex){--..}:
       [<ffffffff8025951c>] __lock_acquire+0xb34/0xd47
       [<ffffffff8040bd58>] rfkill_register+0x87/0x107
       [<ffffffff802597b4>] lock_acquire+0x85/0xa9
       [<ffffffff8040bd58>] rfkill_register+0x87/0x107
       [<ffffffff8040bd58>] rfkill_register+0x87/0x107
       [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
       [<ffffffff8040bd58>] rfkill_register+0x87/0x107
       [<ffffffff88208043>] b43_rfkill_init+0x141/0x1a3 [b43]
       [<ffffffff881f8ac4>] b43_wireless_core_init+0x682/0x78c [b43]
       [<ffffffff881f989e>] b43_op_start+0x33/0x74 [b43]
       [<ffffffff881c7a76>] ieee80211_open+0x1c7/0x3dd [mac80211]
       [<ffffffff803b2fda>] dev_open+0x4e/0x88
       [<ffffffff803b18a2>] dev_change_flags+0xaf/0x16b
       [<ffffffff803b9f9d>] do_setlink+0x27a/0x346
       [<ffffffff8040fa9c>] _read_unlock+0x26/0x2b
       [<ffffffff803bb233>] rtnl_setlink+0xf9/0x11c
       [<ffffffff803bb0d3>] rtnetlink_rcv_msg+0x1b6/0x1d5
       [<ffffffff803baf1d>] rtnetlink_rcv_msg+0x0/0x1d5
       [<ffffffff803c36a5>] netlink_rcv_skb+0x3e/0xaa
       [<ffffffff803baf14>] rtnetlink_rcv+0x20/0x29
       [<ffffffff803c344c>] netlink_unicast+0x1d9/0x23a
       [<ffffffff803ac19e>] __alloc_skb+0x8a/0x138
       [<ffffffff803c3c79>] netlink_sendmsg+0x2aa/0x2bd
       [<ffffffff803a6249>] sock_sendmsg+0xdf/0xf8
       [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
       [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
       [<ffffffff8025970e>] __lock_acquire+0xd26/0xd47
       [<ffffffff803a6b7f>] move_addr_to_kernel+0x40/0x49
       [<ffffffff803ad5b9>] verify_iovec+0x4f/0x8e
       [<ffffffff803a6443>] sys_sendmsg+0x1e1/0x253
       [<ffffffff80250916>] up_read+0x26/0x2a
       [<ffffffff8022581f>] do_page_fault+0x3bf/0x764
       [<ffffffff803a72c4>] sys_getsockname+0x66/0x8c
       [<ffffffff80258540>] trace_hardirqs_on+0x11c/0x147
       [<ffffffff8040f5b8>] trace_hardirqs_on_thunk+0x35/0x3a
       [<ffffffff8020c0de>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&wl->mutex){--..}:
       [<ffffffff8025941e>] __lock_acquire+0xa36/0xd47
       [<ffffffff882081d9>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
       [<ffffffff802597b4>] lock_acquire+0x85/0xa9
       [<ffffffff882081d9>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
       [<ffffffff882081d9>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
       [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
       [<ffffffff80255dd2>] debug_mutex_free_waiter+0x5b/0x5f
       [<ffffffff8040bf77>] rfkill_task_handler+0x0/0x54
       [<ffffffff882081d9>] b43_rfkill_soft_toggle+0x33/0xb2 [b43]
       [<ffffffff8040b930>] rfkill_toggle_radio+0x28/0x60
       [<ffffffff8040be9e>] rfkill_switch_all+0x3e/0x78
       [<ffffffff8040bfb3>] rfkill_task_handler+0x3c/0x54
       [<ffffffff80249914>] run_workqueue+0xeb/0x200
       [<ffffffff8024a500>] worker_thread+0xed/0xfe
       [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
       [<ffffffff8024a413>] worker_thread+0x0/0xfe
       [<ffffffff8024da6e>] kthread+0x49/0x77
       [<ffffffff8020d018>] child_rip+0xa/0x12
       [<ffffffff8020c72f>] restore_args+0x0/0x30
       [<ffffffff8024da25>] kthread+0x0/0x77
       [<ffffffff8020d00e>] child_rip+0x0/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

4 locks held by events/0/9:
 #0:  (events){--..}, at: [<ffffffff802498c9>] run_workqueue+0xa0/0x200
 #1:  (rfkill_wlan.work){--..}, at: [<ffffffff802498c9>] run_workqueue+0xa0/0x200
 #2:  (rfkill_wlan.mutex){--..}, at: [<ffffffff8040bf95>] rfkill_task_handler+0x1e/0x54
 #3:  (rfkill_mutex){--..}, at: [<ffffffff8040be7c>] rfkill_switch_all+0x1c/0x78

stack backtrace:

Call Trace:
 [<ffffffff8025779c>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff8025941e>] __lock_acquire+0xa36/0xd47
 [<ffffffff882081d9>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
 [<ffffffff802597b4>] lock_acquire+0x85/0xa9
 [<ffffffff882081d9>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
 [<ffffffff882081d9>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
 [<ffffffff8040e78a>] mutex_lock_nested+0x10e/0x2b6
 [<ffffffff80255dd2>] debug_mutex_free_waiter+0x5b/0x5f
 [<ffffffff8040bf77>] rfkill_task_handler+0x0/0x54
 [<ffffffff882081d9>] :b43:b43_rfkill_soft_toggle+0x33/0xb2
 [<ffffffff8040b930>] rfkill_toggle_radio+0x28/0x60
 [<ffffffff8040be9e>] rfkill_switch_all+0x3e/0x78
 [<ffffffff8040bfb3>] rfkill_task_handler+0x3c/0x54
 [<ffffffff80249914>] run_workqueue+0xeb/0x200
 [<ffffffff8024a500>] worker_thread+0xed/0xfe
 [<ffffffff8024db89>] autoremove_wake_function+0x0/0x38
 [<ffffffff8024a413>] worker_thread+0x0/0xfe
 [<ffffffff8024da6e>] kthread+0x49/0x77
 [<ffffffff8020d018>] child_rip+0xa/0x12
 [<ffffffff8020c72f>] restore_args+0x0/0x30
 [<ffffffff8024da25>] kthread+0x0/0x77
 [<ffffffff8020d00e>] child_rip+0x0/0x12

b43-phy0: Radio hardware status changed to DISABLED
