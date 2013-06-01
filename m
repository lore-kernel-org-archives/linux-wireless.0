Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36558 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3FANUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 09:20:13 -0400
Received: by mail-ie0-f172.google.com with SMTP id 17so6665489iea.3
        for <linux-wireless@vger.kernel.org>; Sat, 01 Jun 2013 06:20:12 -0700 (PDT)
Date: Sat, 1 Jun 2013 09:19:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: [PATCH] cfg80211: fix deadlock in cfg80211_leave_mesh()
Message-ID: <20130601131916.GA2484@localhost> (sfid-20130601_152017_371934_0CE2FD30)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of "cfg80211/mac80211: use cfg80211 wdev mutex in mac80211",
mac80211 expects to be able to take the wdev mutex around sdata
accesses.  This causes a recursive deadlock since
__cfg80211_leave_mesh() already holds the wdev mutex.  Removing
the sdata_lock() calls in ieee80211_stop_mesh() alone won't fix
this, as the cancel_work_sync() in mesh runs the iface work,
and various work items also want to take the wdev lock (not
just in mesh, see e.g.  ieee80211_sta_rx_queued_mgmt().)

We don't seem to need the wdev lock held over rdev_leave_mesh()
anyway, so drop it before calling.

Fixes:
[   75.571222] =============================================
[   75.571222] [ INFO: possible recursive locking detected ]
[   75.571222] 3.10.0-rc1-a8cd57b+ #113 Not tainted
[   75.571222] ---------------------------------------------
[   75.571222] iw/2597 is trying to acquire lock:
[   75.571222]  (&wdev->mtx){+.+.+.}, at: [<ffffffffa0115180>] ieee80211_stop_mesh+0x60/0x160 [mac80211]
[   75.571222]
[   75.571222] but task is already holding lock:
[   75.571222]  (&wdev->mtx){+.+.+.}, at: [<ffffffffa0035fa5>] cfg80211_leave_mesh+0x35/0x370 [cfg80211]
[   75.571222]
[   75.571222] other info that might help us debug this:
[   75.571222]  Possible unsafe locking scenario:
[   75.571222]
[   75.571222]        CPU0
[   75.571222]        ----
[   75.571222]   lock(&wdev->mtx);
[   75.571222]   lock(&wdev->mtx);
[   75.571222]
[   75.571222]  *** DEADLOCK ***
[   75.571222]
[   75.571222]  May be due to missing lock nesting notation
[   75.571222]
[   75.571222] 4 locks held by iw/2597:
[   75.571222]  #0:  (cb_lock){++++++}, at: [<ffffffff8165a4cd>] genl_rcv+0x1d/0x40
[   75.571222]  #1:  (genl_mutex){+.+.+.}, at: [<ffffffff8165a997>] genl_lock+0x17/0x20
[   75.571222]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81638e47>] rtnl_lock+0x17/0x20
[   75.571222]  #3:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa0035fa5>] cfg80211_leave_mesh+0x35/0x370 [cfg80211]
[   75.571222]
[   75.571222] stack backtrace:
[   75.571222] CPU: 1 PID: 2597 Comm: iw Not tainted 3.10.0-rc1-a8cd57b+ #113
[   75.571222] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   75.571222]  ffffffff82155790 ffff8800035c5768 ffffffff817b8335 ffff8800035c5868
[   75.571222]  ffffffff810a3da2 0000000000000000 0000000000000000 0000000000000002
[   75.571222]  0000000000000046 00000000035c5818 ffffffff82155790 ffff8800057e2360
[   75.571222] Call Trace:
[   75.571222]  [<ffffffff817b8335>] dump_stack+0x19/0x1b
[   75.571222]  [<ffffffff810a3da2>] __lock_acquire+0xba2/0x1d30
[   75.571222]  [<ffffffff817c0bed>] ? _raw_spin_unlock_irqrestore+0x4d/0x70
[   75.571222]  [<ffffffff810a615d>] ? trace_hardirqs_on_caller+0x16d/0x200
[   75.571222]  [<ffffffff810a568a>] lock_acquire+0x17a/0x200
[   75.571222]  [<ffffffffa0115180>] ? ieee80211_stop_mesh+0x60/0x160 [mac80211]
[   75.571222]  [<ffffffff817bd4fe>] mutex_lock_nested+0x6e/0x380
[   75.571222]  [<ffffffffa0115180>] ? ieee80211_stop_mesh+0x60/0x160 [mac80211]
[   75.571222]  [<ffffffffa00b26b2>] ? ieee80211_bss_info_change_notify+0x202/0x3d0 [mac80211]
[   75.571222]  [<ffffffffa0115180>] ieee80211_stop_mesh+0x60/0x160 [mac80211]
[   75.571222]  [<ffffffffa00d195d>] ieee80211_leave_mesh+0x1d/0x30 [mac80211]
[   75.571222]  [<ffffffffa00360f8>] cfg80211_leave_mesh+0x188/0x370 [cfg80211]
[   75.571222]  [<ffffffffa000dfb9>] nl80211_leave_mesh+0x19/0x20 [cfg80211]
[   75.571222]  [<ffffffff8165a756>] genl_family_rcv_msg+0x266/0x2e0
[   75.571222]  [<ffffffff8165a9a0>] ? genl_lock+0x20/0x20
[   75.571222]  [<ffffffff8165aa2e>] genl_rcv_msg+0x8e/0xc0
[   75.571222]  [<ffffffff8165a1ce>] netlink_rcv_skb+0x6e/0xd0
[   75.571222]  [<ffffffff8165a4cd>] ? genl_rcv+0x1d/0x40
[   75.571222]  [<ffffffff8165a4dc>] genl_rcv+0x2c/0x40
[   75.571222]  [<ffffffff81659b6a>] netlink_unicast+0x11a/0x1f0
[   75.571222]  [<ffffffff812a11b5>] ? sock_has_perm+0x5/0x1f0
[   75.571222]  [<ffffffff81659f4d>] netlink_sendmsg+0x30d/0x360
[   75.571222]  [<ffffffff8160f196>] sock_sendmsg+0xa6/0xd0
[   75.571222]  [<ffffffff810a4fde>] ? lock_release_non_nested+0xae/0x2e0
[   75.571222]  [<ffffffff8160f529>] __sys_sendmsg+0x369/0x390
[   75.571222]  [<ffffffff81071723>] ? up_read+0x23/0x40
[   75.571222]  [<ffffffff817c4e64>] ? __do_page_fault+0x4b4/0x570
[   75.571222]  [<ffffffff8117d27d>] ? dput+0x13d/0x1d0
[   75.571222]  [<ffffffff81184c6c>] ? fget_light+0x12c/0x430
[   75.571222]  [<ffffffff8161084d>] SyS_sendmsg+0x4d/0x80
[   75.571222]  [<ffffffff817c9e02>] system_call_fastpath+0x16/0x1b

Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
I don't like dropping locks, but I can't see any races added by
this -- join/leave are already serialized by rtnl and I didn't see
leave_mesh using the wdev fields in a way that would matter -- but
let me know if I missed something.  We could also split out the
cancel_work_sync into a separate (unlocked) op but this approach
seems simpler.  Thoughts?

 net/wireless/mesh.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 5dfb289..6344a81 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -250,7 +250,9 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	if (!wdev->mesh_id_len)
 		return -ENOTCONN;
 
+	wdev_unlock(wdev);
 	err = rdev_leave_mesh(rdev, dev);
+	wdev_lock(wdev);
 	if (!err) {
 		wdev->mesh_id_len = 0;
 		wdev->channel = NULL;
-- 
1.7.10.4

-- 
Bob Copeland %% www.bobcopeland.com
