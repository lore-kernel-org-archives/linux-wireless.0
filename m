Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:57275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0JOPff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 11:35:35 -0400
Message-ID: <4CB874C0.8090003@kernel.org>
Date: Fri, 15 Oct 2010 17:35:28 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly instead
 of depending on flush_scheduled_work()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iee80211_hw->restart_work is the only work which uses the system
workqueue.  Instead of calling flush_scheduled_work() during
iee80211_exit(), cancel the work during unregistration.

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/mac80211/main.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: work/net/mac80211/main.c
===================================================================
--- work.orig/net/mac80211/main.c
+++ work/net/mac80211/main.c
@@ -606,7 +606,7 @@ int ieee80211_register_hw(struct ieee802
 		hw->queues = IEEE80211_MAX_QUEUES;

 	local->workqueue =
-		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
+		alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
 	if (!local->workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
@@ -739,6 +739,7 @@ void ieee80211_unregister_hw(struct ieee
 	del_timer_sync(&local->work_timer);

 	cancel_work_sync(&local->reconfig_filter);
+	cancel_work_sync(&local->restart_work);

 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
@@ -812,12 +813,6 @@ static void __exit ieee80211_exit(void)
 	rc80211_minstrel_ht_exit();
 	rc80211_minstrel_exit();

-	/*
-	 * For key todo, it'll be empty by now but the work
-	 * might still be scheduled.
-	 */
-	flush_scheduled_work();
-
 	if (mesh_allocated)
 		ieee80211s_stop();

