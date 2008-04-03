Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYDCMb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 08:31:59 -0400
Subject: [PATCH] mac80211: fix possible sta-debugfs work lockup
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1207223373.3636.48.camel@johannes.berg> (sfid-20080403_124940_803408_642A0255)
References: <D936D925018D154694D8A362EEB0892004194DDE@orsmsx416.amr.corp.intel.com>
	 <1207218482.3636.19.camel@johannes.berg>
	 (sfid-20080403_112812_982366_CC856F98)  <1207223373.3636.48.camel@johannes.berg>
	 (sfid-20080403_124940_803408_642A0255)
Content-Type: text/plain
Date: Thu, 03 Apr 2008 14:31:05 +0200
Message-Id: <1207225865.3636.58.camel@johannes.berg> (sfid-20080403_135447_070039_4F06167A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because we queue the sta-debugfs-adding work on our mac80211
workqueue (which needs to be flushed under RTNL) and that work
needs the RTNL, it can currently deadlock, thanks to Reinette
Chatre for pointing out the lockdep warning about this.

This patch fixes it by moving this work to the common kernel
workqueue (using schedule_work) and canceling it as appropriate.

It also fixes a related problem: When a STA is pinned by the
debugfs adding work and sta_info_flush() runs concurrently
it is not guaranteed that all STAs are removed from the driver
before the corresponding interface is removed which may lead
to bugs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>
---
This should fix the problem.

 net/mac80211/sta_info.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-04-03 14:11:51.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-03 14:29:04.000000000 +0200
@@ -351,7 +351,7 @@ int sta_info_insert(struct sta_info *sta
 	 * NOTE: due to auto-freeing semantics this may only be done
 	 *       if the insertion is successful!
 	 */
-	queue_work(local->hw.workqueue, &local->sta_debugfs_add);
+	schedule_work(&local->sta_debugfs_add);
 #endif
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
@@ -476,16 +476,23 @@ void __sta_info_unlink(struct sta_info *
 	 *
 	 * The rules are not trivial, but not too complex either:
 	 *  (1) pin_status is only modified under the sta_lock
-	 *  (2) sta_info_debugfs_add_work() will set the status
+	 *  (2) STAs may only be pinned under the RTNL so that
+	 *	sta_info_flush() is guaranteed to actually destroy
+	 *	all STAs that are active for a given interface, this
+	 *	is required for correctness because otherwise we
+	 *	could notify a driver that an interface is going
+	 *	away and only after that (!) notify it about a STA
+	 *	on that interface going away.
+	 *  (3) sta_info_debugfs_add_work() will set the status
 	 *	to PINNED when it found an item that needs a new
 	 *	debugfs directory created. In that case, that item
 	 *	must not be freed although all *RCU* users are done
 	 *	with it. Hence, we tell the caller of _unlink()
 	 *	that the item is already gone (as can happen when
 	 *	two tasks try to unlink/destroy at the same time)
-	 *  (3) We set the pin_status to DESTROY here when we
+	 *  (4) We set the pin_status to DESTROY here when we
 	 *	find such an item.
-	 *  (4) sta_info_debugfs_add_work() will reset the pin_status
+	 *  (5) sta_info_debugfs_add_work() will reset the pin_status
 	 *	from PINNED to NORMAL when it is done with the item,
 	 *	but will check for DESTROY before resetting it in
 	 *	which case it will free the item.
@@ -617,6 +624,8 @@ static void sta_info_debugfs_add_work(st
 	struct sta_info *sta, *tmp;
 	unsigned long flags;
 
+	/* We need to keep the RTNL across the whole pinned status. */
+	rtnl_lock();
 	while (1) {
 		sta = NULL;
 
@@ -637,10 +646,9 @@ static void sta_info_debugfs_add_work(st
 		rate_control_add_sta_debugfs(sta);
 
 		sta = __sta_info_unpin(sta);
-		rtnl_lock();
 		sta_info_destroy(sta);
-		rtnl_unlock();
 	}
+	rtnl_unlock();
 }
 #endif
 
@@ -700,6 +708,15 @@ void sta_info_stop(struct ieee80211_loca
 {
 	del_timer(&local->sta_cleanup);
 	cancel_work_sync(&local->sta_flush_work);
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/*
+	 * Make sure the debugfs adding work isn't pending after this
+	 * because we're about to be destroyed. It doesn't matter
+	 * whether it ran or not since we're going to flush all STAs
+	 * anyway.
+	 */
+	cancel_work_sync(&local->sta_debugfs_add);
+#endif
 
 	rtnl_lock();
 	sta_info_flush(local, NULL);


