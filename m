Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAZSwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:52:25 -0500
Message-Id: <20090126184925.500822996@sipsolutions.net> (sfid-20090126_195229_608528_A11909E9)
References: <20090126184740.036240879@sipsolutions.net>
Date: Mon, 26 Jan 2009 19:47:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
Subject: [RFC/RFT 5/7] mac80211: fix race in TX aggregation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disabling TX aggregation because it was rejected, there
is a window where we first set the state to operation. unlock,
and then undo the whole thing. Avoid that by splitting up the
stop function.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |   69 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-01-26 12:37:13.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-01-26 12:45:13.000000000 +0100
@@ -186,6 +186,9 @@ int ieee80211_start_tx_ba_session(struct
 	u8 *state;
 	int ret = 0;
 
+	if (WARN_ON(!local->ops->ampdu_action))
+		return -EINVAL;
+
 	if ((tid >= STA_TID_NUM) || !(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
 		return -EINVAL;
 
@@ -266,9 +269,8 @@ int ieee80211_start_tx_ba_session(struct
 	/* This is slightly racy because the queue isn't stopped */
 	start_seq_num = sta->tid_seq[tid];
 
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-					       &sta->sta, tid, &start_seq_num);
+	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
+				       &sta->sta, tid, &start_seq_num);
 
 	if (ret) {
 		/* No need to requeue the packets in the agg queue, since we
@@ -400,6 +402,34 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 
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
 int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				 u8 *ra, u16 tid,
 				 enum ieee80211_back_parties initiator)
@@ -409,6 +439,9 @@ int ieee80211_stop_tx_ba_session(struct 
 	u8 *state;
 	int ret = 0;
 
+	if (WARN_ON(!local->ops->ampdu_action))
+		return -EINVAL;
+
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
@@ -425,7 +458,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 	if (*state != HT_AGG_STATE_OPERATIONAL) {
 		ret = -ENOENT;
-		goto stop_BA_exit;
+		goto unlock;
 	}
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -433,27 +466,13 @@ int ieee80211_stop_tx_ba_session(struct 
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
@@ -609,10 +628,8 @@ void ieee80211_process_addba_resp(struct
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

