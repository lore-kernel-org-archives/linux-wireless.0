Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59972 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948797AbdEZW13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 18:27:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix TX aggregation start/stop callback race
Date: Sat, 27 May 2017 00:27:25 +0200
Message-Id: <20170526222725.19921-1-johannes@sipsolutions.net> (sfid-20170527_034507_336544_071F85A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When starting or stopping an aggregation session, one of the steps
is that the driver calls back to mac80211 that the start/stop can
proceed. This is handled by queueing up a fake SKB and processing
it from the normal iface/sdata work. Since this isn't flushed when
disassociating, the following race is possible:

 * associate
 * start aggregation session
 * driver callback
 * disassociate
 * associate again to the same AP
 * callback processing runs, leading to a WARN_ON() that
   the TID hadn't requested aggregation

If the second association isn't to the same AP, there would only
be a message printed ("Could not find station: <addr>"), but the
same race could happen.

Fix this by not going the whole detour with a fake SKB etc. but
simply looking up the aggregation session in the driver callback,
marking it with a START_CB/STOP_CB bit and then scheduling the
regular aggregation work that will now process these bits as well.
This also simplifies the code and gets rid of the whole problem
with allocation failures of said skb, which could have left the
session in limbo.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      | 126 ++++++++++++++++++---------------------------
 net/mac80211/ht.c          |  15 ++++--
 net/mac80211/ieee80211_i.h |  14 ++---
 net/mac80211/iface.c       |  11 +---
 net/mac80211/sta_info.h    |   2 +
 5 files changed, 69 insertions(+), 99 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 60e2a62f7bef..160672ee1d42 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -741,46 +741,43 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 	ieee80211_agg_start_txq(sta, tid, true);
 }
 
-void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
+void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
+			      struct tid_ampdu_tx *tid_tx)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	struct tid_ampdu_tx *tid_tx;
 
-	trace_api_start_tx_ba_cb(sdata, ra, tid);
+	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
+		return;
+
+	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state))
+		ieee80211_agg_tx_operational(local, sta, tid);
+}
+
+static struct tid_ampdu_tx *
+ieee80211_lookup_tid_tx(struct ieee80211_sub_if_data *sdata,
+			const u8 *ra, u16 tid, struct sta_info **sta)
+{
+	struct tid_ampdu_tx *tid_tx;
 
 	if (tid >= IEEE80211_NUM_TIDS) {
 		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
 		       tid, IEEE80211_NUM_TIDS);
-		return;
+		return NULL;
 	}
 
-	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get_bss(sdata, ra);
-	if (!sta) {
-		mutex_unlock(&local->sta_mtx);
+	*sta = sta_info_get_bss(sdata, ra);
+	if (!*sta) {
 		ht_dbg(sdata, "Could not find station: %pM\n", ra);
-		return;
+		return NULL;
 	}
 
-	mutex_lock(&sta->ampdu_mlme.mtx);
-	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	tid_tx = rcu_dereference((*sta)->ampdu_mlme.tid_tx[tid]);
 
-	if (WARN_ON(!tid_tx)) {
+	if (WARN_ON(!tid_tx))
 		ht_dbg(sdata, "addBA was not requested!\n");
-		goto unlock;
-	}
 
-	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
-		goto unlock;
-
-	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state))
-		ieee80211_agg_tx_operational(local, sta, tid);
-
- unlock:
-	mutex_unlock(&sta->ampdu_mlme.mtx);
-	mutex_unlock(&local->sta_mtx);
+	return tid_tx;
 }
 
 void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
@@ -788,19 +785,20 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
+	struct sta_info *sta;
+	struct tid_ampdu_tx *tid_tx;
 
-	if (unlikely(!skb))
-		return;
+	trace_api_start_tx_ba_cb(sdata, ra, tid);
 
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
+	rcu_read_lock();
+	tid_tx = ieee80211_lookup_tid_tx(sdata, ra, tid, &sta);
+	if (!tid_tx)
+		goto out;
 
-	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_START;
-	skb_queue_tail(&sdata->skb_queue, skb);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	set_bit(HT_AGG_STATE_START_CB, &tid_tx->state);
+	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
+ out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
@@ -860,37 +858,18 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
-void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
+void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
+			     struct tid_ampdu_tx *tid_tx)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	struct tid_ampdu_tx *tid_tx;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	bool send_delba = false;
 
-	trace_api_stop_tx_ba_cb(sdata, ra, tid);
-
-	if (tid >= IEEE80211_NUM_TIDS) {
-		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
-		       tid, IEEE80211_NUM_TIDS);
-		return;
-	}
-
-	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n", ra, tid);
-
-	mutex_lock(&local->sta_mtx);
-
-	sta = sta_info_get_bss(sdata, ra);
-	if (!sta) {
-		ht_dbg(sdata, "Could not find station: %pM\n", ra);
-		goto unlock;
-	}
+	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
+	       sta->sta.addr, tid);
 
-	mutex_lock(&sta->ampdu_mlme.mtx);
 	spin_lock_bh(&sta->lock);
-	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
-	if (!tid_tx || !test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+	if (!test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 		ht_dbg(sdata,
 		       "unexpected callback to A-MPDU stop for %pM tid %d\n",
 		       sta->sta.addr, tid);
@@ -906,12 +885,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	spin_unlock_bh(&sta->lock);
 
 	if (send_delba)
-		ieee80211_send_delba(sdata, ra, tid,
+		ieee80211_send_delba(sdata, sta->sta.addr, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
-
-	mutex_unlock(&sta->ampdu_mlme.mtx);
- unlock:
-	mutex_unlock(&local->sta_mtx);
 }
 
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
@@ -919,19 +894,20 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
+	struct sta_info *sta;
+	struct tid_ampdu_tx *tid_tx;
 
-	if (unlikely(!skb))
-		return;
+	trace_api_stop_tx_ba_cb(sdata, ra, tid);
 
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
+	rcu_read_lock();
+	tid_tx = ieee80211_lookup_tid_tx(sdata, ra, tid, &sta);
+	if (!tid_tx)
+		goto out;
 
-	skb->pkt_type = IEEE80211_SDATA_QUEUE_AGG_STOP;
-	skb_queue_tail(&sdata->skb_queue, skb);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	set_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state);
+	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
+ out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f4a528773563..176f1dfd9eac 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -289,8 +289,6 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 {
 	int i;
 
-	cancel_work_sync(&sta->ampdu_mlme.work);
-
 	for (i = 0; i <  IEEE80211_NUM_TIDS; i++) {
 		__ieee80211_stop_tx_ba_session(sta, i, reason);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
@@ -298,6 +296,9 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 					       reason != AGG_STOP_DESTROY_STA &&
 					       reason != AGG_STOP_PEER_REQUEST);
 	}
+
+	/* stopping might queue the work again - so cancel only afterwards */
+	cancel_work_sync(&sta->ampdu_mlme.work);
 }
 
 void ieee80211_ba_session_work(struct work_struct *work)
@@ -352,10 +353,16 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		spin_unlock_bh(&sta->lock);
 
 		tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
-		if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
-						 &tid_tx->state))
+		if (!tid_tx)
+			continue;
+
+		if (test_and_clear_bit(HT_AGG_STATE_START_CB, &tid_tx->state))
+			ieee80211_start_tx_ba_cb(sta, tid, tid_tx);
+		if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
 							AGG_STOP_LOCAL_REQUEST);
+		if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
+			ieee80211_stop_tx_ba_cb(sta, tid, tid_tx);
 	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a34abd8784d3..f24f1d7b8937 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1038,8 +1038,6 @@ struct ieee80211_rx_agg {
 
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
-	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
-	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
 	IEEE80211_SDATA_QUEUE_RX_AGG_START	= 3,
 	IEEE80211_SDATA_QUEUE_RX_AGG_STOP	= 4,
 };
@@ -1429,12 +1427,6 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	return local->hw.wiphy->bands[band];
 }
 
-/* this struct represents 802.11n's RA/TID combination */
-struct ieee80211_ra_tid {
-	u8 ra[ETH_ALEN];
-	u16 tid;
-};
-
 /* this struct holds the value parsing from channel switch IE  */
 struct ieee80211_csa_ie {
 	struct cfg80211_chan_def chandef;
@@ -1797,8 +1789,10 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_agg_stop_reason reason);
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_agg_stop_reason reason);
-void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
-void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
+void ieee80211_start_tx_ba_cb(struct sta_info *sta, int tid,
+			      struct tid_ampdu_tx *tid_tx);
+void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
+			     struct tid_ampdu_tx *tid_tx);
 void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3bd5b81f5d81..8fae1a72e6a7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1237,7 +1237,6 @@ static void ieee80211_iface_work(struct work_struct *work)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
-	struct ieee80211_ra_tid *ra_tid;
 	struct ieee80211_rx_agg *rx_agg;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -1253,15 +1252,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
-		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
-			ra_tid = (void *)&skb->cb;
-			ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra,
-						 ra_tid->tid);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
-			ra_tid = (void *)&skb->cb;
-			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
-						ra_tid->tid);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
+		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
 			rx_agg = (void *)&skb->cb;
 			mutex_lock(&local->sta_mtx);
 			sta = sta_info_get_bss(sdata, rx_agg->addr);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b58c3b19ab78..cde89c6d0386 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -116,6 +116,8 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_STOPPING		3
 #define HT_AGG_STATE_WANT_START		4
 #define HT_AGG_STATE_WANT_STOP		5
+#define HT_AGG_STATE_START_CB		6
+#define HT_AGG_STATE_STOP_CB		7
 
 enum ieee80211_agg_stop_reason {
 	AGG_STOP_DECLINED,
-- 
2.11.0
