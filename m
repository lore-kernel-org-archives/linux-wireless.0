Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59490 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbeHUPXU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 11:23:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] workqueue lockdep limitations/bugs
Date: Tue, 21 Aug 2018 14:03:15 +0200
Message-Id: <20180821120317.4115-1-johannes@sipsolutions.net> (sfid-20180821_140331_335182_2E02FF79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Tejun, Lia, all,

While doing some unrelated testing earlier, I found a bug in workqueue
lockdep, and while looking into the code I found another bug, and another
limitation. I'll follow up with patches for the two bugs, and explain all
three issues here.


1)
Lockdep report is below - the problem is the following: cancel_work_sync()
calls flush_work(), which may or may not do something, depending on whether
or not it's running. This is reasonable for semantics of the workqueue, but
it's not fine for lockdep, and also the reason for issue 3 below.

The lockdep report I hit basically says:
 * you're flushing (but really I'm doing cancel_work_sync) the work
   item, so we take the workqueue lockdep map (it's an ordered
   workqueue)
 * the workqueue has other work items that can be on it, that take locks
   that we already hold (at least indirectly via a dependency chain)
 * thus a locking violation occurred - the other work might be pending
   or running, so you have to wait for it and get a deadlock

Note how this isn't true - we really call cancel_work_sync(), so we don't
need to wait for any other work to run. If this one's running, it must be
the first one running on the workqueue (otherwise we'd just have cancelled
it and it wouldn't be running). Thus, the code is fine, but because
cancel_work_sync() just uses flush_work(), the annotation isn't quite
right. I've fixed that in the follow-up patch by making the annotation
depend on where we came from, but I'm not entirely sure that's the right
thing to do.

2)
The second issue is that we never really use work->lockdep_map when we
flush the work, and thus if we have code like

work_function
{
	mutex_lock(&mutex);
}

other_function
{
	mutex_lock(&mutex);
	flush_work(&work);
}

we never actually get a lockdep report. I've fixed this by putting a lock
map acquire/release in the (hopefully) correct place.

3)
The third problem is more complicated, but it means that we likely miss a
lot of potential locking problems with ordered workqueues, and I think we
should really try to fix this somehow.

Let's say we again have an ordered workqueue, and the following:

work1_function
{
	mutex_lock(&mutex);
}

work2_function
{
	// empty
}

other_function
{
	queue_work_on(&ordered_wq, &work1);
	queue_work_on(&ordered_wq, &work2);
	flush_workqueue(&ordered_wq);
	mutex_lock(&mutex);
	flush_work(&work2);
}

As far as I can tell, this will not generate a lockdep report, because the
flush_work() will not find any pwq in start_flush_work(), and thus will do
"goto already_gone" without ever doing anything with lockdep. After my
second patch, at least it will still acquire and release the
work2.lockdep_map, but that doesn't create any dependency with the whole
workqueue.

I realize that this is difficult since the work struct isn't tied to the
workqueue while it's not running, and it could possibly be used with
different workqueues, but I think we need to solve this too, somehow.

Perhaps we can give each work struct *two* lockdep maps? One that includes
the workqueue dependency, and one that doesn't? Then we could create a
dependency when scheduling:

  schedule_work_on():
    lock_map_acquire(work->wq_lockdep_map);
    lock_map_acquire(wq->lockdep_map);

and then in flush we take both:
    lock_map_acquire(work->lockdep_map);
    lock_map_acquire(work->wq_lockdep_map);

(perhaps also when running the work).

Then, the above scenario should create the following relevant lockdep chain:

mutex			--> work2->wq_lockdep_map
work2->wq_lockdep_map	--> wq->lockdep_map
wq->lockdep_map		--> work->wq_lockdep_map
work->wq_lockdep_map	--> mutex

I think?

johannes


----
lockdep report for problem 1

======================================================
WARNING: possible circular locking dependency detected
4.18.0-rc8+ #1573 Not tainted
------------------------------------------------------
wpa_supplicant/708 is trying to acquire lock:
00000000a1e36a54 ((wq_completion)"%s"wiphy_name(local->hw.wiphy)){+.+.}, at: flush_work+0x175/0x280

but task is already holding lock:
00000000056b83e2 (&local->sta_mtx){+.+.}, at: __sta_info_flush+0x94/0x190

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&local->sta_mtx){+.+.}:
       __mutex_lock+0x8e/0x9c0
       ieee80211_del_key+0x40/0x1e0
       nl80211_del_key+0x126/0x450
       genl_family_rcv_msg+0x2aa/0x370
       genl_rcv_msg+0x47/0x90
       netlink_rcv_skb+0x4a/0x110
       genl_rcv+0x24/0x40
       netlink_unicast+0x186/0x230
       netlink_sendmsg+0x3b7/0x3e0
       sock_sendmsg+0x16/0x20
       ___sys_sendmsg+0x2d5/0x2f0
       __sys_sendmsg+0x51/0x90
       do_syscall_64+0x59/0x390
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #2 (&wdev->mtx){+.+.}:
       __mutex_lock+0x8e/0x9c0
       ieee80211_sta_rx_queued_mgmt+0x4b/0x3e0
       ieee80211_iface_work+0x21f/0x340
       process_one_work+0x28f/0x700
       worker_thread+0x39/0x3f0
       kthread+0x116/0x130
       ret_from_fork+0x3a/0x50

-> #1 ((work_completion)(&sdata->work)){+.+.}:
       process_one_work+0x262/0x700
       worker_thread+0x39/0x3f0
       kthread+0x116/0x130
       ret_from_fork+0x3a/0x50

-> #0 ((wq_completion)"%s"wiphy_name(local->hw.wiphy)){+.+.}:
       lock_acquire+0xa3/0x230
       flush_work+0x195/0x280
       __cancel_work_timer+0x137/0x1e0
       ieee80211_sta_tear_down_BA_sessions+0x8d/0x150
       __sta_info_destroy_part1+0x5d/0x9c0
       __sta_info_flush+0xd8/0x190
       ieee80211_set_disassoc+0xd2/0x7d0
       ieee80211_mgd_auth+0x200/0x340
       cfg80211_mlme_auth+0x152/0x440
       nl80211_authenticate+0x2fd/0x360
       genl_family_rcv_msg+0x2aa/0x370
       genl_rcv_msg+0x47/0x90
       netlink_rcv_skb+0x4a/0x110
       genl_rcv+0x24/0x40
       netlink_unicast+0x186/0x230
       netlink_sendmsg+0x3b7/0x3e0
       sock_sendmsg+0x16/0x20
       ___sys_sendmsg+0x2d5/0x2f0
       __sys_sendmsg+0x51/0x90
       do_syscall_64+0x59/0x390
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  (wq_completion)"%s"wiphy_name(local->hw.wiphy) --> &wdev->mtx --> &local->sta_mtx

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&local->sta_mtx);
                               lock(&wdev->mtx);
                               lock(&local->sta_mtx);
  lock((wq_completion)"%s"wiphy_name(local->hw.wiphy));

 *** DEADLOCK ***

5 locks held by wpa_supplicant/708:
 #0: 00000000a50eb6ff (cb_lock){++++}, at: genl_rcv+0x15/0x40
 #1: 000000008954a22a (genl_mutex){+.+.}, at: genl_rcv_msg+0x7a/0x90
 #2: 000000007622d582 (rtnl_mutex){+.+.}, at: nl80211_pre_doit+0xe1/0x190
 #3: 000000004cd75553 (&wdev->mtx){+.+.}, at: nl80211_authenticate+0x2b1/0x360
 #4: 00000000056b83e2 (&local->sta_mtx){+.+.}, at: __sta_info_flush+0x94/0x190

stack backtrace:
CPU: 3 PID: 708 Comm: wpa_supplicant Not tainted 4.18.0-rc8+ #1573
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
Call Trace:
 dump_stack+0x85/0xcb
 print_circular_bug.isra.19+0x1d1/0x2c0
 check_prev_add.constprop.27+0x542/0x7c0
 __lock_acquire+0x1107/0x11e0
 lock_acquire+0xa3/0x230
 flush_work+0x195/0x280
 __cancel_work_timer+0x137/0x1e0
 ieee80211_sta_tear_down_BA_sessions+0x8d/0x150
 __sta_info_destroy_part1+0x5d/0x9c0
 __sta_info_flush+0xd8/0x190
 ieee80211_set_disassoc+0xd2/0x7d0
 ieee80211_mgd_auth+0x200/0x340
 cfg80211_mlme_auth+0x152/0x440
 nl80211_authenticate+0x2fd/0x360
 genl_family_rcv_msg+0x2aa/0x370
 genl_rcv_msg+0x47/0x90
 netlink_rcv_skb+0x4a/0x110
 genl_rcv+0x24/0x40
 netlink_unicast+0x186/0x230
 netlink_sendmsg+0x3b7/0x3e0
 sock_sendmsg+0x16/0x20
 ___sys_sendmsg+0x2d5/0x2f0
 __sys_sendmsg+0x51/0x90
 do_syscall_64+0x59/0x390
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
