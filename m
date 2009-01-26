Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZAZSwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:52:02 -0500
Message-Id: <20090126184925.913285565@sipsolutions.net> (sfid-20090126_195210_632069_4B727768)
References: <20090126184740.036240879@sipsolutions.net>
Date: Mon, 26 Jan 2009 19:47:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
Subject: [RFC/RFT 7/7] mac80211: fix aggregation timer lockups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I can tell, there are possible lockups because both the RX
session_timer and TX addba_resp_timer are del_timer_sync'ed under
the sta spinlock which both timer functions take. Additionally, the
TX agg code seems to leak memory when TX aggregation is not disabled
before the sta_info is freed.

Fix this by making the free code a little smarter in the RX agg case,
and actually make the sta_info_destroy code free the TX agg info in
the TX agg case. We won't notify the peer, but it'll notice something
is wrong anyway, and normally this only happens after we've told it
in some other way we will no longer talk to it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c   |   11 +++++-
 net/mac80211/agg-tx.c   |   77 +++++++++++++++++++-----------------------------
 net/mac80211/sta_info.c |   29 +++++++++++++++---
 net/mac80211/sta_info.h |    1 
 4 files changed, 67 insertions(+), 51 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-01-26 16:55:48.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-01-26 17:09:17.000000000 +0100
@@ -78,11 +78,18 @@ void ieee80211_sta_stop_rx_ba_session(st
 			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
 		}
 	}
+
+	spin_lock_bh(&sta->lock);
 	/* free resources */
 	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
-	kfree(sta->ampdu_mlme.tid_rx[tid]);
-	sta->ampdu_mlme.tid_rx[tid] = NULL;
+
+	if (!sta->ampdu_mlme.tid_rx[tid]->shutdown) {
+		kfree(sta->ampdu_mlme.tid_rx[tid]);
+		sta->ampdu_mlme.tid_rx[tid] = NULL;
+	}
+
 	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
+	spin_unlock_bh(&sta->lock);
 
 	rcu_read_unlock();
 }
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-01-26 16:55:48.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-01-26 17:13:06.000000000 +0100
@@ -194,12 +194,33 @@ void sta_info_destroy(struct sta_info *s
 		dev_kfree_skb_any(skb);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
+		struct tid_ampdu_rx *tid_rx;
+		struct tid_ampdu_tx *tid_tx;
+
 		spin_lock_bh(&sta->lock);
-		if (sta->ampdu_mlme.tid_rx[i])
-		  del_timer_sync(&sta->ampdu_mlme.tid_rx[i]->session_timer);
-		if (sta->ampdu_mlme.tid_tx[i])
-		  del_timer_sync(&sta->ampdu_mlme.tid_tx[i]->addba_resp_timer);
+		tid_rx = sta->ampdu_mlme.tid_rx[i];
+		if (tid_rx)
+			tid_rx->shutdown = true;
+		tid_tx = sta->ampdu_mlme.tid_tx[i];
+		if (tid_tx) {
+			/*
+			 * XXX: in this case, ieee80211_stop_tx_ba_session
+			 *	cannot do anything since the sta_info won't
+			 *	be found... free the aggregation info here.
+			 */
+			del_timer(&tid_tx->addba_resp_timer);
+			kfree(tid_tx);
+		}
 		spin_unlock_bh(&sta->lock);
+
+		/*
+		 * outside spinlock - shutdown is true now so
+		 * that the timer won't free tid_rx.
+		 */
+		if (tid_rx) {
+			del_timer_sync(&tid_rx->session_timer);
+			kfree(tid_rx);
+		}
 	}
 
 	__sta_info_free(local, sta);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-01-26 16:56:10.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-26 17:07:16.000000000 +0100
@@ -100,6 +100,7 @@ struct tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u8 dialog_token;
+	bool shutdown;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-01-26 16:55:48.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-01-26 17:07:16.000000000 +0100
@@ -122,6 +122,34 @@ void ieee80211_send_bar(struct ieee80211
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
@@ -134,23 +162,13 @@ static void sta_addba_resp_timer_expired
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
@@ -167,11 +185,8 @@ static void sta_addba_resp_timer_expired
 	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
 #endif
 
-	/* go through the state check in stop_BA_session */
-	*state = HT_AGG_STATE_OPERATIONAL;
+	__ieee80211_stop_tx_ba_session(local, sta, tid, WLAN_BACK_INITIATOR);
 	spin_unlock_bh(&sta->lock);
-	ieee80211_stop_tx_ba_session(hw, temp_sta->sta.addr, tid,
-				     WLAN_BACK_INITIATOR);
 
 timer_expired_exit:
 	rcu_read_unlock();
@@ -402,34 +417,6 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 
-static int __ieee80211_stop_tx_ba_session(struct ieee80211_local *local,
-					  struct sta_info *sta, u16 tid,
-					  enum ieee80211_back_parties initiator)
-{
-	int ret;
-	u8 *state;
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-
-	if (local->hw.ampdu_queues)
-		ieee80211_stop_queue(&local->hw, sta->tid_to_tx_q[tid]);
-
-	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-
-	ret = local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_STOP,
-				       &sta->sta, tid, NULL);
-
-	/* HW shall not deny going back to legacy */
-	if (WARN_ON(ret)) {
-		*state = HT_AGG_STATE_OPERATIONAL;
-		if (local->hw.ampdu_queues)
-			ieee80211_wake_queue(&local->hw, sta->tid_to_tx_q[tid]);
-	}
-
-	return ret;
-}
-
 int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 				 u8 *ra, u16 tid,
 				 enum ieee80211_back_parties initiator)

-- 

