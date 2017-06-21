Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53054 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751999AbdFUXu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 6/6] mac80211: always go through txqs
Date: Thu, 22 Jun 2017 01:50:22 +0200
Message-Id: <20170621235022.25362-6-johannes@sipsolutions.net> (sfid-20170622_015034_824329_9B98B317)
In-Reply-To: <20170621235022.25362-1-johannes@sipsolutions.net>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  1 +
 include/net/mac80211.h                |  6 ++-
 net/mac80211/debugfs.c                |  2 +-
 net/mac80211/debugfs_netdev.c         |  2 +-
 net/mac80211/debugfs_sta.c            |  2 +-
 net/mac80211/ieee80211_i.h            |  2 +
 net/mac80211/iface.c                  | 17 +++----
 net/mac80211/main.c                   |  8 ++++
 net/mac80211/sta_info.c               |  3 --
 net/mac80211/tx.c                     | 83 +++++++++++++++++++----------------
 net/mac80211/util.c                   |  4 +-
 11 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c8852acc1462..1f11c5ccc880 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2299,6 +2299,7 @@ static void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
 
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
+	.wake_tx_queue = ieee80211_wake_tx_queue,		\
 	.start = mac80211_hwsim_start,				\
 	.stop = mac80211_hwsim_stop,				\
 	.add_interface = mac80211_hwsim_add_interface,		\
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f2c6f0e0f928..3fc92c0e8779 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -97,7 +97,8 @@
  * Other frames (e.g. control or management) are still pushed using drv_tx().
  *
  * Drivers indicate that they use this model by implementing the .wake_tx_queue
- * driver operation.
+ * driver operation; if they don't want to use this model they need to set the
+ * .wake_tx_queue operation to point to ieee80211_wake_tx_queue().
  *
  * Intermediate queues (struct ieee80211_txq) are kept per-sta per-tid, with
  * another per-sta for non-data/non-mgmt and bufferable management frames, and
@@ -5867,6 +5868,9 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
 
+void ieee80211_wake_tx_queue(struct ieee80211_hw *hw,
+			     struct ieee80211_txq *txq);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001f286c..9ab432bde8b4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -373,7 +373,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
-	if (local->ops->wake_tx_queue)
+	if (local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
 
 	statsd = debugfs_create_dir("statistics", phyd);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c813207bb123..2098767353ac 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -659,7 +659,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
 
-	if (sdata->local->ops->wake_tx_queue)
+	if (sdata->local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 }
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index d046c17ea48d..80194f82f6a9 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -539,7 +539,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_stats.fragments);
 	DEBUGFS_ADD_COUNTER(tx_filtered, status_stats.filtered);
 
-	if (local->ops->wake_tx_queue)
+	if (local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 011c18077e21..3413a1f6408e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -815,6 +815,8 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
+	IEEE80211_TXQ_PENDING,
+	IEEE80211_TXQ_RESULT,
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 492cc65b9871..b2545899bc6b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -729,7 +729,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-	    local->ops->wake_tx_queue) {
+	    local->ops->wake_tx_queue != ieee80211_wake_tx_queue) {
 		/* XXX: for AP_VLAN, actually track AP queues */
 		netif_tx_start_all_queues(dev);
 	} else if (dev) {
@@ -1756,13 +1756,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	} else {
 		int size = ALIGN(sizeof(*sdata) + local->hw.vif_data_size,
 				 sizeof(void *));
-		int txq_size = 0;
+		int txq_size = sizeof(struct txq_info) +
+			       local->hw.txq_data_size;
 
-		if (local->ops->wake_tx_queue)
-			txq_size += sizeof(struct txq_info) +
-				    local->hw.txq_data_size;
-
-		if (local->ops->wake_tx_queue)
+		if (local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 			if_setup = ieee80211_if_setup_no_queue;
 		else
 			if_setup = ieee80211_if_setup;
@@ -1812,10 +1809,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
 		memcpy(sdata->name, ndev->name, IFNAMSIZ);
 
-		if (txq_size) {
-			txqi = netdev_priv(ndev) + size;
-			ieee80211_txq_init(local, sdata, NULL, txqi, 0);
-		}
+		txqi = netdev_priv(ndev) + size;
+		ieee80211_txq_init(local, sdata, NULL, txqi, 0);
 
 		sdata->dev = ndev;
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8c33c07e47a5..8eaac8e29bb4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -508,6 +508,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		return NULL;
 	use_chanctx = i == 5;
 
+	if (WARN_ON(!ops->wake_tx_queue))
+		return NULL;
+
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
 	 * the driver's private data
@@ -849,6 +852,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		return -EINVAL;
 #endif
 
+	if (local->ops->wake_tx_queue == ieee80211_wake_tx_queue) {
+		if (WARN_ON(local->hw.txq_data_size))
+			return -EINVAL;
+	}
+
 	if (!local->use_chanctx) {
 		for (i = 0; i < local->hw.wiphy->n_iface_combinations; i++) {
 			const struct ieee80211_iface_combination *comb;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e99da54c2270..c1c73125bcd9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2319,9 +2319,6 @@ unsigned long ieee80211_sta_last_active(struct sta_info *sta)
 
 static void sta_update_codel_params(struct sta_info *sta, u32 thr)
 {
-	if (!sta->sdata->local->ops->wake_tx_queue)
-		return;
-
 	if (thr && thr < STA_SLOW_THRESHOLD * sta->local->num_sta) {
 		sta->cparams.target = MS2TIME(50);
 		sta->cparams.interval = MS2TIME(300);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ce78ac4d781e..7f8b8cb60109 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1248,7 +1248,8 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_txq *txq;
 
-	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
+	if (vif->type == NL80211_IFTYPE_MONITOR ||
+	    (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)) {
 		txq = NULL;
 	} else if (!ieee80211_is_data_present(hdr->frame_control)) {
@@ -1448,9 +1449,6 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	bool supp_vht = false;
 	enum nl80211_band band;
 
-	if (!local->ops->wake_tx_queue)
-		return 0;
-
 	ret = fq_init(fq, 4096);
 	if (ret)
 		return ret;
@@ -1496,9 +1494,6 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
 {
 	struct fq *fq = &local->fq;
 
-	if (!local->ops->wake_tx_queue)
-		return;
-
 	kfree(local->cvars);
 	local->cvars = NULL;
 
@@ -1509,17 +1504,13 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
 
 static bool ieee80211_queue_skb(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
-				struct sta_info *sta,
-				struct sk_buff *skb)
+				struct sta_info *sta, struct sk_buff *skb,
+				bool txpending)
 {
 	struct fq *fq = &local->fq;
 	struct ieee80211_vif *vif;
 	struct txq_info *txqi;
 
-	if (!local->ops->wake_tx_queue ||
-	    sdata->vif.type == NL80211_IFTYPE_MONITOR)
-		return false;
-
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
@@ -1527,16 +1518,23 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	vif = &sdata->vif;
 	txqi = ieee80211_get_txq(local, vif, sta, skb);
 
-	if (WARN_ON(!txqi))
-		return false;
+	if (WARN_ON(!txqi)) {
+		ieee80211_free_txskb(&local->hw, skb);
+		return true;
+	}
 
 	spin_lock_bh(&fq->lock);
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
 
+	if (txpending)
+		set_bit(IEEE80211_TXQ_PENDING, &txqi->flags);
+	else
+		clear_bit(IEEE80211_TXQ_PENDING, &txqi->flags);
+	set_bit(IEEE80211_TXQ_RESULT, &txqi->flags);
 	drv_wake_tx_queue(local, txqi);
-
-	return true;
+	clear_bit(IEEE80211_TXQ_PENDING, &txqi->flags);
+	return test_bit(IEEE80211_TXQ_RESULT, &txqi->flags);
 }
 
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
@@ -1820,8 +1818,6 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	bool result = true;
-	int led_len;
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
@@ -1829,7 +1825,6 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* initialises tx */
-	led_len = skb->len;
 	res_prepare = ieee80211_tx_prepare(sdata, &tx, sta, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
@@ -1848,14 +1843,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	if (invoke_tx_handlers_early(&tx))
 		return false;
 
-	if (ieee80211_queue_skb(local, sdata, tx.sta, tx.skb))
-		return true;
-
-	if (!invoke_tx_handlers_late(&tx))
-		result = __ieee80211_tx(local, &tx.skbs, led_len,
-					tx.sta, txpending);
-
-	return result;
+	return ieee80211_queue_skb(local, sdata, tx.sta, tx.skb, txpending);
 }
 
 /* device xmit handlers */
@@ -3300,6 +3288,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	struct tid_ampdu_tx *tid_tx = NULL;
 	u8 tid = IEEE80211_NUM_TIDS;
 
+	return false;
+
 	/* control port protocol needs a lot of special handling */
 	if (cpu_to_be16(ethertype) == sdata->control_port_protocol)
 		return false;
@@ -3392,18 +3382,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (ieee80211_queue_skb(local, sdata, sta, skb))
-		return true;
-
-	ieee80211_xmit_fast_finish(sdata, sta, fast_tx->pn_offs,
-				   fast_tx->key, skb);
-
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data, u.ap);
+	ieee80211_queue_skb(local, sdata, sta, skb, false);
 
-	__skb_queue_tail(&tx.skbs, skb);
-	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
 	return true;
 }
 
@@ -4704,3 +4684,28 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	ieee80211_xmit(sdata, NULL, skb);
 	local_bh_enable();
 }
+
+void ieee80211_wake_tx_queue(struct ieee80211_hw *hw,
+			     struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
+	struct sk_buff *skb;
+	struct sk_buff_head skbs;
+	struct sta_info *sta = NULL;
+
+	if (txq->sta)
+		sta = container_of(txq->sta, struct sta_info, sta);
+
+	while ((skb = ieee80211_tx_dequeue(hw, txq))) {
+		__skb_queue_head_init(&skbs);
+		__skb_queue_head(&skbs, skb);
+		skb_queue_splice_tail_init(&txqi->frags, &skbs);
+
+		/* use approximate length for fragmented frames for LED blinking */
+		if (!__ieee80211_tx(local, &skbs, skbs.qlen * skb->len, sta,
+				    test_bit(IEEE80211_TXQ_PENDING, &txqi->flags)))
+			clear_bit(IEEE80211_TXQ_RESULT, &txqi->flags);
+	}
+}
+EXPORT_SYMBOL_GPL(ieee80211_wake_tx_queue);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 259698de569f..ed2dba05f340 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -244,7 +244,7 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
 
-	if (local->ops->wake_tx_queue)
+	if (local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 		return;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
@@ -350,7 +350,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
-	if (local->ops->wake_tx_queue)
+	if (local->ops->wake_tx_queue != ieee80211_wake_tx_queue)
 		return;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
-- 
2.11.0
