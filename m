Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYGSApx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:45:53 -0400
Message-Id: <20080719004517.436644000@sipsolutions.net> (sfid-20080719_024556_447872_7D42A4A4)
References: <20080719004147.795661000@sipsolutions.net>
Date: Sat, 19 Jul 2008 02:41:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC 1/3] mac80211: sane arguments to ieee80211_ht_agg_queue_remove
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    8 +++++---
 net/mac80211/wme.c  |    7 +------
 net/mac80211/wme.h  |    3 +--
 3 files changed, 7 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-07-18 23:52:25.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-19 00:14:30.000000000 +0200
@@ -644,7 +644,8 @@ int ieee80211_start_tx_ba_session(struct
 		/* No need to requeue the packets in the agg queue, since we
 		 * held the tx lock: no packet could be enqueued to the newly
 		 * allocated queue */
-		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
+		ieee80211_ht_agg_queue_remove(local, sta->tid_to_tx_q[tid], false);
+		sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
@@ -740,7 +741,7 @@ int ieee80211_stop_tx_ba_session(struct 
 		goto stop_BA_exit;
 	}
 
-stop_BA_exit:
+ stop_BA_exit:
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 	return ret;
@@ -852,7 +853,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 
 	agg_queue = sta->tid_to_tx_q[tid];
 
-	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
+	ieee80211_ht_agg_queue_remove(local, agg_queue, true);
+	sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
 
 	/* We just requeued the all the frames that were in the
 	 * removed queue, and since we might miss a softirq we do
--- everything.orig/net/mac80211/wme.c	2008-07-19 00:07:24.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-07-19 00:14:57.000000000 +0200
@@ -223,15 +223,10 @@ int ieee80211_ht_agg_queue_add(struct ie
  * the caller needs to hold netdev_get_tx_queue(local->mdev, X)->lock
  */
 void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   struct sta_info *sta, u16 tid,
-				   u8 requeue)
+				   u16 agg_queue, bool requeue)
 {
-	int agg_queue = sta->tid_to_tx_q[tid];
-	struct ieee80211_hw *hw = &local->hw;
-
 	/* return the qdisc to the pool */
 	clear_bit(agg_queue, local->queue_pool);
-	sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
 
 	if (requeue) {
 		ieee80211_requeue(local, agg_queue);
--- everything.orig/net/mac80211/wme.h	2008-07-19 00:08:04.000000000 +0200
+++ everything/net/mac80211/wme.h	2008-07-19 00:08:28.000000000 +0200
@@ -27,8 +27,7 @@ u16 ieee80211_select_queue(struct net_de
 int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 			       struct sta_info *sta, u16 tid);
 void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   struct sta_info *sta, u16 tid,
-				   u8 requeue);
+				   u16 agg_queue, bool requeue);
 void ieee80211_requeue(struct ieee80211_local *local, int queue);
 
 #endif /* _WME_H */

-- 

