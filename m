Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab0FJI0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:24 -0400
Message-Id: <20100610082232.471932919@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/23] mac80211: change TX aggregation locking
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To prepare for allowing drivers to sleep in
ampdu_action, change the locking in the TX
aggregation code to use the mutex the RX part
already uses. The spinlock is still necessary
around some code to avoid races with TX, but
now we can also synchronize_net() to avoid
getting an inconsistent sequence number.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c     |   94 +++++++++++++++++++++++++---------------------
 net/mac80211/driver-ops.h |    3 +
 net/mac80211/ht.c         |    8 ---
 3 files changed, 58 insertions(+), 47 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-09 17:21:16.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-09 17:21:17.000000000 +0200
@@ -6,7 +6,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007-2009, Intel Corporation
+ * Copyright 2007-2010, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -140,18 +140,23 @@ int ___ieee80211_stop_tx_ba_session(stru
 	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	int ret;
 
-	lockdep_assert_held(&sta->lock);
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
-	if (WARN_ON(!tid_tx))
+	if (!tid_tx)
 		return -ENOENT;
 
+	spin_lock_bh(&sta->lock);
+
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/* not even started yet! */
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		spin_unlock_bh(&sta->lock);
 		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return 0;
 	}
 
+	spin_unlock_bh(&sta->lock);
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
 	       sta->sta.addr, tid);
@@ -269,6 +274,8 @@ void ieee80211_tx_ba_session_handle_star
 	u16 start_seq_num;
 	int ret;
 
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+
 	/*
 	 * While we're asking the driver about the aggregation,
 	 * stop the AC queue so that we don't have to worry
@@ -281,10 +288,11 @@ void ieee80211_tx_ba_session_handle_star
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
 	/*
-	 * This might be off by one due to a race that we can't
-	 * really prevent here without synchronize_net() which
-	 * can't be called now.
+	 * make sure no packets are being processed to get
+	 * valid starting sequence number
 	 */
+	synchronize_net();
+
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
@@ -294,7 +302,10 @@ void ieee80211_tx_ba_session_handle_star
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
 #endif
+		spin_lock_bh(&sta->lock);
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		spin_unlock_bh(&sta->lock);
+
 		ieee80211_wake_queue_agg(local, tid);
 		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return;
@@ -309,7 +320,9 @@ void ieee80211_tx_ba_session_handle_star
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
 #endif
 
+	spin_lock_bh(&sta->lock);
 	sta->ampdu_mlme.addba_req_num[tid]++;
+	spin_unlock_bh(&sta->lock);
 
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
@@ -445,16 +458,25 @@ ieee80211_agg_splice_finish(struct ieee8
 	ieee80211_wake_queue_agg(local, tid);
 }
 
-/* caller must hold sta->lock */
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
-	lockdep_assert_held(&sta->lock);
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Aggregation is on for tid %d\n", tid);
 #endif
 
+	drv_ampdu_action(local, sta->sdata,
+			 IEEE80211_AMPDU_TX_OPERATIONAL,
+			 &sta->sta, tid, NULL);
+
+	/*
+	 * synchronize with TX path, while splicing the TX path
+	 * should block so it won't put more packets onto pending.
+	 */
+	spin_lock_bh(&sta->lock);
+
 	ieee80211_agg_splice_packets(local, sta->ampdu_mlme.tid_tx[tid], tid);
 	/*
 	 * Now mark as operational. This will be visible
@@ -464,9 +486,7 @@ static void ieee80211_agg_tx_operational
 	set_bit(HT_AGG_STATE_OPERATIONAL, &sta->ampdu_mlme.tid_tx[tid]->state);
 	ieee80211_agg_splice_finish(local, tid);
 
-	drv_ampdu_action(local, sta->sdata,
-			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL);
+	spin_unlock_bh(&sta->lock);
 }
 
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
@@ -486,37 +506,35 @@ void ieee80211_start_tx_ba_cb(struct iee
 		return;
 	}
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, ra);
 	if (!sta) {
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %pM\n", ra);
 #endif
 		return;
 	}
 
-	spin_lock_bh(&sta->lock);
+	mutex_lock(&sta->ampdu_mlme.mtx);
 	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 
 	if (WARN_ON(!tid_tx)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "addBA was not requested!\n");
 #endif
-		spin_unlock_bh(&sta->lock);
-		rcu_read_unlock();
-		return;
+		goto unlock;
 	}
 
 	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
-		goto out;
+		goto unlock;
 
 	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state))
 		ieee80211_agg_tx_operational(local, sta, tid);
 
- out:
-	spin_unlock_bh(&sta->lock);
-	rcu_read_unlock();
+ unlock:
+	mutex_unlock(&sta->ampdu_mlme.mtx);
+	mutex_unlock(&local->sta_mtx);
 }
 
 void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
@@ -548,21 +566,14 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_i
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator)
 {
-	struct tid_ampdu_tx *tid_tx;
 	int ret;
 
-	spin_lock_bh(&sta->lock);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
-
-	if (!tid_tx) {
-		ret = -ENOENT;
-		goto unlock;
-	}
+	mutex_lock(&sta->ampdu_mlme.mtx);
 
 	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator);
 
- unlock:
-	spin_unlock_bh(&sta->lock);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
+
 	return ret;
 }
 
@@ -627,16 +638,17 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	       ra, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
+
 	sta = sta_info_get(sdata, ra);
 	if (!sta) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %pM\n", ra);
 #endif
-		rcu_read_unlock();
-		return;
+		goto unlock;
 	}
 
+	mutex_lock(&sta->ampdu_mlme.mtx);
 	spin_lock_bh(&sta->lock);
 	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 
@@ -644,9 +656,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
 #endif
-		spin_unlock_bh(&sta->lock);
-		rcu_read_unlock();
-		return;
+		goto unlock_sta;
 	}
 
 	if (tid_tx->stop_initiator == WLAN_BACK_INITIATOR)
@@ -672,8 +682,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 
 	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 
+ unlock_sta:
 	spin_unlock_bh(&sta->lock);
-	rcu_read_unlock();
+	mutex_unlock(&sta->ampdu_mlme.mtx);
+ unlock:
+	mutex_unlock(&local->sta_mtx);
 }
 
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
@@ -714,10 +727,9 @@ void ieee80211_process_addba_resp(struct
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 
-	spin_lock_bh(&sta->lock);
+	mutex_lock(&sta->ampdu_mlme.mtx);
 
 	tid_tx = sta->ampdu_mlme.tid_tx[tid];
-
 	if (!tid_tx)
 		goto out;
 
@@ -751,5 +763,5 @@ void ieee80211_process_addba_resp(struct
 	}
 
  out:
-	spin_unlock_bh(&sta->lock);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-09 17:21:16.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-09 17:21:17.000000000 +0200
@@ -6,7 +6,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007-2008, Intel Corporation
+ * Copyright 2007-2010, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -136,11 +136,7 @@ void ieee80211_ba_session_work(struct wo
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_QSTA_TIMEOUT);
-	}
-	mutex_unlock(&sta->ampdu_mlme.mtx);
 
-	spin_lock_bh(&sta->lock);
-	for (tid = 0; tid < STA_TID_NUM; tid++) {
 		tid_tx = sta->ampdu_mlme.tid_tx[tid];
 		if (!tid_tx)
 			continue;
@@ -152,7 +148,7 @@ void ieee80211_ba_session_work(struct wo
 			___ieee80211_stop_tx_ba_session(sta, tid,
 							WLAN_BACK_INITIATOR);
 	}
-	spin_unlock_bh(&sta->lock);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-06-09 17:21:16.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-06-09 17:21:17.000000000 +0200
@@ -349,6 +349,9 @@ static inline int drv_ampdu_action(struc
 				   u16 *ssn)
 {
 	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
 	local_bh_disable();
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,


