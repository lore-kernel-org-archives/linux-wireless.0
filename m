Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbZBJUhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:37:17 -0500
Message-Id: <20090210202555.183721397@sipsolutions.net> (sfid-20090210_213720_730736_D5FF7C79)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/27] mac80211: fix race in TX aggregation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disabling TX aggregation because it was rejected or from
the timer (it was not accepted), there is a window where we
first set the state to operation, unlock, and then undo the
whole thing. Avoid that by splitting up the stop function.
Also get rid of the pointless sta_info indirection in the timer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |   95 +++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 47 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-10 20:59:33.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-10 20:59:34.000000000 +0100
@@ -123,6 +123,34 @@ void ieee80211_send_bar(struct ieee80211
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
+static int __ieee80211_stop_tx_ba_session(struct ieee80211_local *local,
+					  struct sta_info *sta, u16 tid,
+					  enum ieee80211_back_parties initiator)
+{
+	int ret;
+	u8 *state;
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+
+	if (local->hw.ampdu_queues)
+		ieee80211_stop_queue(&local->hw, sta->tid_to_tx_q[tid]);
+
+	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
+		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+
+	ret = local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_STOP,
+				       &sta->sta, tid, NULL);
+
+	/* HW shall not deny going back to legacy */
+	if (WARN_ON(ret)) {
+		*state = HT_AGG_STATE_OPERATIONAL;
+		if (local->hw.ampdu_queues)
+			ieee80211_wake_queue(&local->hw, sta->tid_to_tx_q[tid]);
+	}
+
+	return ret;
+}
+
 /*
  * After sending add Block Ack request we activated a timer until
  * add Block Ack response will arrive from the recipient.
@@ -135,23 +163,13 @@ static void sta_addba_resp_timer_expired
 	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u16 tid = *(u8 *)data;
-	struct sta_info *temp_sta = container_of((void *)data,
+	struct sta_info *sta = container_of((void *)data,
 		struct sta_info, timer_to_tid[tid]);
-
-	struct ieee80211_local *local = temp_sta->local;
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
+	struct ieee80211_local *local = sta->local;
 	u8 *state;
 
-	rcu_read_lock();
-
-	sta = sta_info_get(local, temp_sta->sta.addr);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
+
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->lock);
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
@@ -161,21 +179,15 @@ static void sta_addba_resp_timer_expired
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"expecting addBA response there", tid);
 #endif
-		goto timer_expired_exit;
+		return;
 	}
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
 #endif
 
-	/* go through the state check in stop_BA_session */
-	*state = HT_AGG_STATE_OPERATIONAL;
+	__ieee80211_stop_tx_ba_session(local, sta, tid, WLAN_BACK_INITIATOR);
 	spin_unlock_bh(&sta->lock);
-	ieee80211_stop_tx_ba_session(hw, temp_sta->sta.addr, tid,
-				     WLAN_BACK_INITIATOR);
-
-timer_expired_exit:
-	rcu_read_unlock();
 }
 
 int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
@@ -187,6 +199,9 @@ int ieee80211_start_tx_ba_session(struct
 	u8 *state;
 	int ret = 0;
 
+	if (WARN_ON(!local->ops->ampdu_action))
+		return -EINVAL;
+
 	if ((tid >= STA_TID_NUM) || !(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
 		return -EINVAL;
 
@@ -280,9 +295,8 @@ int ieee80211_start_tx_ba_session(struct
 	/* This is slightly racy because the queue isn't stopped */
 	start_seq_num = sta->tid_seq[tid];
 
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-					       &sta->sta, tid, &start_seq_num);
+	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
+				       &sta->sta, tid, &start_seq_num);
 
 	if (ret) {
 		/* No need to requeue the packets in the agg queue, since we
@@ -423,6 +437,9 @@ int ieee80211_stop_tx_ba_session(struct 
 	u8 *state;
 	int ret = 0;
 
+	if (WARN_ON(!local->ops->ampdu_action))
+		return -EINVAL;
+
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
@@ -439,7 +456,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 	if (*state != HT_AGG_STATE_OPERATIONAL) {
 		ret = -ENOENT;
-		goto stop_BA_exit;
+		goto unlock;
 	}
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -447,27 +464,13 @@ int ieee80211_stop_tx_ba_session(struct 
 	       ra, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (hw->ampdu_queues)
-		ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
-
-	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+	ret = __ieee80211_stop_tx_ba_session(local, sta, tid, initiator);
 
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
-					       &sta->sta, tid, NULL);
-
-	/* HW shall not deny going back to legacy */
-	if (WARN_ON(ret)) {
-		*state = HT_AGG_STATE_OPERATIONAL;
-		if (hw->ampdu_queues)
-			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-		goto stop_BA_exit;
-	}
-
-stop_BA_exit:
+ unlock:
 	spin_unlock_bh(&sta->lock);
+
 	rcu_read_unlock();
+
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
@@ -623,10 +626,8 @@ void ieee80211_process_addba_resp(struct
 		spin_unlock_bh(&sta->lock);
 	} else {
 		sta->ampdu_mlme.addba_req_num[tid]++;
-		/* this will allow the state check in stop_BA_session */
-		*state = HT_AGG_STATE_OPERATIONAL;
+		__ieee80211_stop_tx_ba_session(local, sta, tid,
+					       WLAN_BACK_INITIATOR);
 		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(hw, sta->sta.addr, tid,
-					     WLAN_BACK_INITIATOR);
 	}
 }

-- 

