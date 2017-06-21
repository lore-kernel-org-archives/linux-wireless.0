Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53040 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751988AbdFUXu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 5/6] mac80211: add a general fallback TXQ
Date: Thu, 22 Jun 2017 01:50:21 +0200
Message-Id: <20170621235022.25362-5-johannes@sipsolutions.net> (sfid-20170622_015033_568541_05A27CAD)
In-Reply-To: <20170621235022.25362-1-johannes@sipsolutions.net>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In a number of cases, like management frames, mac80211 will not
put the frame on any TXQ but immediately TX it to the driver.
It'd be nicer to be able to use TXQs for all frames, so add a
"fallback" TXQ. This will serve as a container to be able to
remove all the non-TXQ queueing in mac80211.

For ath9k/ath10k, extend the code that already handles the STA
mgmt TXQ by code to handle the per-HW fallback queue. Since that
may now carry fragmented frames, extend the logic a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++---
 drivers/net/wireless/ath/ath9k/xmit.c | 10 +++---
 include/net/mac80211.h                | 15 +++++++--
 net/mac80211/driver-ops.h             |  7 ++--
 net/mac80211/ieee80211_i.h            |  3 +-
 net/mac80211/iface.c                  |  2 +-
 net/mac80211/main.c                   | 18 +++++++++++
 net/mac80211/sta_info.c               |  2 +-
 net/mac80211/tx.c                     | 60 +++++++++++++++++++----------------
 9 files changed, 79 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ee11a01e4f61..437906c6df77 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4236,16 +4236,14 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	int ret = 0;
 	int max = 16;
 
-	if (unlikely(txq->tid == IEEE80211_NUM_TIDS)) {
-		struct sk_buff *skb = ieee80211_tx_dequeue(hw, txq);
+	if (unlikely(txq == hw->txq || txq->tid == IEEE80211_NUM_TIDS)) {
 		struct ieee80211_tx_control control = {
 			.sta = txq->sta,
 		};
+		struct sk_buff *skb;
 
-		if (WARN_ON(!skb))
-			return;
-
-		ath10k_mac_op_tx(hw, &control, skb);
+		while ((skb = ieee80211_tx_dequeue(hw, txq)))
+			ath10k_mac_op_tx(hw, &control, skb);
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8ff00ebff261..5dbf4fcd66c3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -157,16 +157,14 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
 
-	if (unlikely(queue->tid == IEEE80211_NUM_TIDS)) {
-		struct sk_buff *skb = ieee80211_tx_dequeue(hw, queue);
+	if (unlikely(queue == hw->txq || queue->tid == IEEE80211_NUM_TIDS)) {
 		struct ieee80211_tx_control control = {
 			.sta = queue->sta,
 		};
+		struct sk_buff *skb;
 
-		if (WARN_ON(!skb))
-			return;
-
-		ath9k_tx(hw, &control, skb);
+		while ((skb = ieee80211_tx_dequeue(hw, queue)))
+			ath9k_tx(hw, &control, skb);
 		return;
 	}
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 871e4399a999..f2c6f0e0f928 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -101,10 +101,12 @@
  *
  * Intermediate queues (struct ieee80211_txq) are kept per-sta per-tid, with
  * another per-sta for non-data/non-mgmt and bufferable management frames, and
- * a single per-vif queue for multicast data frames.
+ * a single per-vif queue for multicast data frames and one additional queue
+ * for the HW for all other frames.
  *
  * The driver is expected to initialize its private per-queue data for stations
- * and interfaces in the .add_interface and .sta_add ops.
+ * and interfaces in the .add_interface and .sta_add ops or before calling
+ * ieee80211_register_hw() (for the general HW queue).
  *
  * The driver can't access the queue directly. To dequeue a frame, it calls
  * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, it
@@ -1857,7 +1859,9 @@ struct ieee80211_tx_control {
 /**
  * struct ieee80211_txq - Software intermediate tx queue
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @hw: &struct ieee80211_hw pointer for the device this is used on
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback,
+ *	%NULL for the "fallback" TXQ (in &struct ieee80211_hw)
  * @sta: station table entry, %NULL for per-vif queue
  * @tid: the TID for this queue (unused for per-vif queue),
  *	%IEEE80211_NUM_TIDS for non-data (if enabled)
@@ -1868,6 +1872,7 @@ struct ieee80211_tx_control {
  * ieee80211_tx_dequeue().
  */
 struct ieee80211_txq {
+	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 	u8 tid;
@@ -2216,6 +2221,8 @@ enum ieee80211_hw_flags {
  *	supported by HW.
  * @max_nan_de_entries: maximum number of NAN DE functions supported by the
  *	device.
+ *
+ * @txq: TXQ for (management) frames not otherwise handled on station/vif TXQs
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2251,6 +2258,8 @@ struct ieee80211_hw {
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
 	u8 max_nan_de_entries;
+
+	struct ieee80211_txq *txq;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 09f77e4a8a79..0299f73d5122 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1160,9 +1160,12 @@ drv_tdls_recv_channel_switch(struct ieee80211_local *local,
 static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 				     struct txq_info *txq)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
+	struct ieee80211_sub_if_data *sdata = NULL;
 
-	if (!check_sdata_in_driver(sdata))
+	if (txq->txq.vif)
+		sdata = vif_to_sdata(txq->txq.vif);
+
+	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
 	trace_drv_wake_tx_queue(local, sdata, txq);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2197c62a0a6e..011c18077e21 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2000,7 +2000,8 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 
 int ieee80211_txq_setup_flows(struct ieee80211_local *local);
 void ieee80211_txq_teardown_flows(struct ieee80211_local *local);
-void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
+void ieee80211_txq_init(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta,
 			struct txq_info *txq, int tid);
 void ieee80211_txq_purge(struct ieee80211_local *local,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9228ac73c429..492cc65b9871 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1814,7 +1814,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		if (txq_size) {
 			txqi = netdev_priv(ndev) + size;
-			ieee80211_txq_init(sdata, NULL, txqi, 0);
+			ieee80211_txq_init(local, sdata, NULL, txqi, 0);
 		}
 
 		sdata->dev = ndev;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8aa1f5b6a051..8c33c07e47a5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -666,6 +666,17 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	local->hw.radiotap_timestamp.units_pos = -1;
 	local->hw.radiotap_timestamp.accuracy = -1;
 
+	if (ops->wake_tx_queue) {
+		int txq_size = sizeof(struct txq_info) +
+			       local->hw.txq_data_size;
+		struct txq_info *txqi;
+
+		txqi = kzalloc(txq_size, GFP_KERNEL);
+		if (!txqi)
+			goto err_free;
+		ieee80211_txq_init(local, NULL, NULL, txqi, 0);
+	}
+
 	return &local->hw;
  err_free:
 	wiphy_free(wiphy);
@@ -1234,6 +1245,13 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 
 	ieee80211_free_led_names(local);
 
+	if (local->hw.txq) {
+		struct txq_info *txqi = to_txq_info(local->hw.txq);
+
+		ieee80211_txq_purge(local, txqi);
+		kfree(txqi);
+	}
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 69615016d5bf..e99da54c2270 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -370,7 +370,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txq = txq_data + i * size;
 
-			ieee80211_txq_init(sdata, sta, txq, i);
+			ieee80211_txq_init(local, sdata, sta, txq, i);
 		}
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d2a91594312d..ce78ac4d781e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1246,29 +1246,35 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_txq *txq = NULL;
+	struct ieee80211_txq *txq;
 
 	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
-	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
-		return NULL;
-
-	if (!ieee80211_is_data_present(hdr->frame_control)) {
+	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)) {
+		txq = NULL;
+	} else if (!ieee80211_is_data_present(hdr->frame_control)) {
 		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
 		     ieee80211_is_bufferable_mmpdu(hdr->frame_control)) &&
 		    sta && sta->uploaded)
 			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
+		else
+			txq = NULL;
 	} else if (sta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
-		if (!sta->uploaded)
-			return NULL;
-
-		txq = sta->sta.txq[tid];
+		if (sta->uploaded)
+			txq = sta->sta.txq[tid];
+		else
+			txq = NULL;
 	} else if (vif) {
 		txq = vif->txq;
+	} else {
+		txq = NULL;
 	}
 
 	if (!txq)
+		txq = local->hw.txq;
+
+	if (!txq)
 		return NULL;
 
 	return to_txq_info(txq);
@@ -1295,15 +1301,11 @@ static codel_time_t codel_skb_time_func(const struct sk_buff *skb)
 static struct sk_buff *codel_dequeue_func(struct codel_vars *cvars,
 					  void *ctx)
 {
-	struct ieee80211_local *local;
-	struct txq_info *txqi;
-	struct fq *fq;
+	struct txq_info *txqi = ctx;
+	struct ieee80211_local *local = hw_to_local(txqi->txq.hw);
+	struct fq *fq = &local->fq;
 	struct fq_flow *flow;
 
-	txqi = ctx;
-	local = vif_to_sdata(txqi->txq.vif)->local;
-	fq = &local->fq;
-
 	if (cvars == &txqi->def_cvars)
 		flow = &txqi->def_flow;
 	else
@@ -1315,15 +1317,9 @@ static struct sk_buff *codel_dequeue_func(struct codel_vars *cvars,
 static void codel_drop_func(struct sk_buff *skb,
 			    void *ctx)
 {
-	struct ieee80211_local *local;
-	struct ieee80211_hw *hw;
-	struct txq_info *txqi;
-
-	txqi = ctx;
-	local = vif_to_sdata(txqi->txq.vif)->local;
-	hw = &local->hw;
+	struct txq_info *txqi = ctx;
 
-	ieee80211_free_txskb(hw, skb);
+	ieee80211_free_txskb(txqi->txq.hw, skb);
 }
 
 static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
@@ -1399,7 +1395,8 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 		       fq_flow_get_default_func);
 }
 
-void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
+void ieee80211_txq_init(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta,
 			struct txq_info *txqi, int tid)
 {
@@ -1409,7 +1406,10 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
 
-	txqi->txq.vif = &sdata->vif;
+	txqi->txq.hw = &local->hw;
+
+	if (sdata)
+		txqi->txq.vif = &sdata->vif;
 
 	if (sta) {
 		txqi->txq.sta = &sta->sta;
@@ -1419,10 +1419,14 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 			txqi->txq.ac = IEEE80211_AC_VO;
 		else
 			txqi->txq.ac = ieee80211_ac_from_tid(tid);
-	} else {
+	} else if (sdata) {
 		sdata->vif.txq = &txqi->txq;
 		txqi->txq.tid = 0;
 		txqi->txq.ac = IEEE80211_AC_BE;
+	} else {
+		local->hw.txq = &txqi->txq;
+		txqi->txq.tid = 0;
+		txqi->txq.ac = IEEE80211_AC_BE;
 	}
 }
 
@@ -1523,7 +1527,7 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	vif = &sdata->vif;
 	txqi = ieee80211_get_txq(local, vif, sta, skb);
 
-	if (!txqi)
+	if (WARN_ON(!txqi))
 		return false;
 
 	spin_lock_bh(&fq->lock);
-- 
2.11.0
