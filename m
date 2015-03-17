Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55594
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbbCQQV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 12:21:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v4] mac80211: add an intermediate software queue implementation
Date: Tue, 17 Mar 2015 17:21:23 +0100
Message-Id: <1426609283-83954-1-git-send-email-nbd@openwrt.org> (sfid-20150317_172131_549741_B7A8FF20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to request per-vif and per-sta-tid queues from which
they can pull frames. This makes it easier to keep the hardware queues
short, and to improve fairness between clients and vifs.

The task of scheduling packet transmission is left up to the driver -
queueing is controlled by mac80211. Drivers can only dequeue packets by
calling ieee80211_tx_dequeue. This makes it possible to add active queue
management later without changing drivers using this code.

This can also be used as a starting point to implement A-MSDU
aggregation in a way that does not add artificially induced latency.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |  78 ++++++++++++++++++++++++++++++
 net/mac80211/agg-tx.c      |  42 +++++++++++++++++
 net/mac80211/driver-ops.h  |  12 +++++
 net/mac80211/ieee80211_i.h |  24 ++++++++++
 net/mac80211/iface.c       |  19 ++++++++
 net/mac80211/main.c        |   3 ++
 net/mac80211/rx.c          |  13 +++++
 net/mac80211/sta_info.c    |  78 ++++++++++++++++++++++++++----
 net/mac80211/sta_info.h    |   2 +
 net/mac80211/trace.h       |  28 +++++++++++
 net/mac80211/tx.c          | 115 +++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/util.c        |  38 +++++++++++++++
 12 files changed, 433 insertions(+), 19 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1db2ea..aafa5eb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -84,6 +84,34 @@
  *
  */
 
+/**
+ * DOC: mac80211 software tx queueing
+ *
+ * mac80211 provides an optional intermediate queueing implementation designed
+ * to allow the driver to keep hardware queues short and provide some fairness
+ * between different stations/interfaces.
+ * In this model, the driver pulls data frames from the mac80211 queue instead
+ * of letting mac80211 push them via drv_tx().
+ * Other frames (e.g. control or management) are still pushed using drv_tx().
+ *
+ * Intermediate queues (struct ieee80211_txq) are kept per-sta per-tid, with a
+ * single per-vif queue for multicast data frames.
+ *
+ * The driver is expected to initialize its private per-queue data for stations
+ * and interfaces in the .add_interface and .sta_add ops.
+ *
+ * The driver can not access the queue directly. To dequeue a frame, it calls
+ * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, it
+ * calls the .wake_tx_queue driver op.
+ *
+ * For AP powersave TIM handling, the driver only needs to indicate if it has
+ * buffered packets in the driver specific data structures by calling
+ * ieee80211_sta_set_buffered(). For frames buffered in the ieee80211_txq
+ * struct, mac80211 sets TIM and calls .release_buffered_frames().
+ * The driver is expected to release its own buffered frames and also call
+ * ieee80211_tx_dequeue() within that callback.
+ */
+
 struct device;
 
 /**
@@ -1257,6 +1285,8 @@ struct ieee80211_vif {
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
 
+	struct ieee80211_txq *txq;
+
 	struct ieee80211_chanctx_conf __rcu *chanctx_conf;
 
 	u32 driver_flags;
@@ -1519,6 +1549,8 @@ struct ieee80211_sta {
 	bool tdls_initiator;
 	bool mfp;
 
+	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -1547,6 +1579,27 @@ struct ieee80211_tx_control {
 };
 
 /**
+ * struct ieee80211_txq - Software intermediate tx queue
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @sta: station table entry, may be NULL for per-vif queue
+ * @tid: the TID for this queue (unused for per-vif queue)
+ * @ac: the AC for this queue
+ *
+ * The driver can obtain packets from this queue by calling
+ * ieee80211_tx_dequeue().
+ */
+struct ieee80211_txq {
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+	u8 tid;
+	u8 ac;
+
+	/* must be last */
+	u8 drv_priv[0] __aligned(sizeof(void *));
+};
+
+/**
  * enum ieee80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
@@ -1770,6 +1823,8 @@ enum ieee80211_hw_flags {
  *	within &struct ieee80211_sta.
  * @chanctx_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_chanctx_conf.
+ * @txq_data_size: size (in bytes) of the drv_priv data area
+ *	within @struct ieee80211_txq.
  *
  * @max_rates: maximum number of alternate rate retry stages the hw
  *	can handle.
@@ -1818,6 +1873,9 @@ enum ieee80211_hw_flags {
  * @n_cipher_schemes: a size of an array of cipher schemes definitions.
  * @cipher_schemes: a pointer to an array of cipher scheme definitions
  *	supported by HW.
+ *
+ * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
+ *	entries for a vif.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1830,6 +1888,7 @@ struct ieee80211_hw {
 	int vif_data_size;
 	int sta_data_size;
 	int chanctx_data_size;
+	int txq_data_size;
 	u16 queues;
 	u16 max_listen_interval;
 	s8 max_signal;
@@ -1846,6 +1905,7 @@ struct ieee80211_hw {
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
+	int txq_ac_max_pending;
 };
 
 /**
@@ -3007,6 +3067,8 @@ enum ieee80211_reconfig_type {
  *	response template is provided, together with the location of the
  *	switch-timing IE within the template. The skb can only be used within
  *	the function call.
+ *
+ * @wake_tx_queue: Called when new packets have been added to the queue.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3238,6 +3300,9 @@ struct ieee80211_ops {
 	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 struct ieee80211_tdls_ch_sw_params *params);
+
+	void (*wake_tx_queue)(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq);
 };
 
 /**
@@ -5259,4 +5324,17 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
  */
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
+
+/**
+ * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from .add_tx_queue() call
+ *
+ * Returns the skb if successful, NULL if no frame was available.
+ */
+struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
+				     struct ieee80211_txq *txq);
+
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index a360c15..06f66e5 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -188,6 +188,41 @@ ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
 	__release(agg_queue);
 }
 
+static void
+ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
+{
+	struct ieee80211_txq *txq = sta->sta.txq[tid];
+	struct txq_info *txqi;
+
+	if (!txq)
+		return;
+
+	txqi = to_txq_info(txq);
+	spin_lock_bh(&txqi->queue.lock);
+	set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+	spin_unlock_bh(&txqi->queue.lock);
+}
+
+static void
+ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
+{
+	struct ieee80211_txq *txq = sta->sta.txq[tid];
+	struct txq_info *txqi;
+
+	if (!txq)
+		return;
+
+	txqi = to_txq_info(txq);
+
+	if (enable)
+		set_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
+	else
+		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
+
+	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+	drv_wake_tx_queue(sta->sdata->local, txqi);
+}
+
 /*
  * splice packets from the STA's pending to the local pending,
  * requires a call to ieee80211_agg_splice_finish later
@@ -247,6 +282,7 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 	ieee80211_assign_tid_tx(sta, tid, NULL);
 
 	ieee80211_agg_splice_finish(sta->sdata, tid);
+	ieee80211_agg_start_txq(sta, tid, false);
 
 	kfree_rcu(tid_tx, rcu_head);
 }
@@ -418,6 +454,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
+	ieee80211_agg_stop_txq(sta, tid);
+
 	/*
 	 * Make sure no packets are being processed. This ensures that
 	 * we have a valid starting sequence number and that in-flight
@@ -440,6 +478,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		ieee80211_agg_splice_finish(sdata, tid);
 		spin_unlock_bh(&sta->lock);
 
+		ieee80211_agg_start_txq(sta, tid, false);
+
 		kfree_rcu(tid_tx, rcu_head);
 		return;
 	}
@@ -666,6 +706,8 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 	ieee80211_agg_splice_finish(sta->sdata, tid);
 
 	spin_unlock_bh(&sta->lock);
+
+	ieee80211_agg_start_txq(sta, tid, true);
 }
 
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fdeda17..4ac861d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1367,4 +1367,16 @@ drv_tdls_recv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_wake_tx_queue(struct ieee80211_local *local,
+				     struct txq_info *txq)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
+
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_wake_tx_queue(local, sdata, txq->txq.sta, txq->txq.tid);
+	local->ops->wake_tx_queue(&local->hw, &txq->txq);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 486a790..eb607fe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -809,6 +809,19 @@ struct mac80211_qos_map {
 	struct rcu_head rcu_head;
 };
 
+enum txq_info_flags {
+	IEEE80211_TXQ_STOP,
+	IEEE80211_TXQ_AMPDU,
+};
+
+struct txq_info {
+	struct sk_buff_head queue;
+	unsigned long flags;
+
+	/* keep last! */
+	struct ieee80211_txq txq;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -853,6 +866,7 @@ struct ieee80211_sub_if_data {
 	bool control_port_no_encrypt;
 	int encrypt_headroom;
 
+	atomic_t txqs_len[IEEE80211_NUM_ACS];
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 	struct mac80211_qos_map __rcu *qos_map;
 
@@ -1450,6 +1464,10 @@ static inline struct ieee80211_local *hw_to_local(
 	return container_of(hw, struct ieee80211_local, hw);
 }
 
+static inline struct txq_info *to_txq_info(struct ieee80211_txq *txq)
+{
+	return container_of(txq, struct txq_info, txq);
+}
 
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
@@ -1902,6 +1920,12 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 	return true;
 }
 
+void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta,
+			     struct txq_info *txq, int tid);
+void ieee80211_flush_tx_queue(struct ieee80211_local *local,
+			      struct ieee80211_txq *txq);
+
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b49812f..684ba85 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -969,6 +969,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
+	if (sdata->vif.txq)
+		ieee80211_flush_tx_queue(local, sdata->vif.txq);
+
 	if (local->open_count == 0)
 		ieee80211_clear_tx_pending(local);
 
@@ -1753,6 +1756,15 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
+		struct txq_info *txqi = NULL;
+
+		if (local->ops->wake_tx_queue) {
+			txqi = kzalloc(sizeof(*txqi) +
+				      local->hw.txq_data_size, GFP_KERNEL);
+			if (txqi)
+				ieee80211_init_tx_queue(sdata, NULL, txqi, 0);
+		}
+
 		if (params) {
 			ndev->ieee80211_ptr->use_4addr = params->use_4addr;
 			if (type == NL80211_IFTYPE_STATION)
@@ -1765,6 +1777,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = register_netdevice(ndev);
 		if (ret) {
+			kfree(txqi);
 			free_netdev(ndev);
 			return ret;
 		}
@@ -1790,6 +1803,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 
 	synchronize_rcu();
 
+	if (sdata->vif.txq)
+		kfree(to_txq_info(sdata->vif.txq));
+
 	if (sdata->dev) {
 		unregister_netdevice(sdata->dev);
 	} else {
@@ -1831,6 +1847,9 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 
+		if (sdata->vif.txq)
+			kfree(to_txq_info(sdata->vif.txq));
+
 		if (sdata->dev)
 			unregister_netdevice_queue(sdata->dev, &unreg_list);
 		else
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2f51e6d..df94567 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1035,6 +1035,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->dynamic_ps_forced_timeout = -1;
 
+	if (!local->hw.txq_ac_max_pending)
+		local->hw.txq_ac_max_pending = 64;
+
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 944bdc0..addca48 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1184,6 +1184,7 @@ static void sta_ps_start(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
+	int tid;
 
 	if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1197,6 +1198,18 @@ static void sta_ps_start(struct sta_info *sta)
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
+
+	if (!sta->sta.txq[0])
+		return;
+
+	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
+		struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
+
+		if (!skb_queue_len(&txqi->queue))
+			set_bit(tid, &sta->txq_buffered_tids);
+		else
+			clear_bit(tid, &sta->txq_buffered_tids);
+	}
 }
 
 static void sta_ps_end(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d94004e..688884e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -118,6 +118,11 @@ static void __cleanup_single_sta(struct sta_info *sta)
 		atomic_dec(&ps->num_sta_ps);
 	}
 
+	if (sta->sta.txq[0]) {
+		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++)
+			ieee80211_flush_tx_queue(local, sta->sta.txq[i]);
+	}
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
 		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
@@ -234,6 +239,8 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
+	if (sta->sta.txq[0])
+		kfree(to_txq_info(sta->sta.txq[0]));
 	kfree(rcu_dereference_raw(sta->sta.rates));
 	kfree(sta);
 }
@@ -285,11 +292,12 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				const u8 *addr, gfp_t gfp)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
 	struct timespec uptime;
 	int i;
 
-	sta = kzalloc(sizeof(*sta) + local->hw.sta_data_size, gfp);
+	sta = kzalloc(sizeof(*sta) + hw->sta_data_size, gfp);
 	if (!sta)
 		return NULL;
 
@@ -321,11 +329,24 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)
 		ewma_init(&sta->chain_signal_avg[i], 1024, 8);
 
-	if (sta_prepare_rate_control(local, sta, gfp)) {
-		kfree(sta);
-		return NULL;
+	if (local->ops->wake_tx_queue) {
+		void *txq_data;
+		int size = sizeof(struct txq_info) +
+			   ALIGN(hw->txq_data_size, sizeof(void *));
+
+		txq_data = kcalloc(ARRAY_SIZE(sta->sta.txq), size, gfp);
+		if (!txq_data)
+			goto free;
+
+		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+			struct txq_info *txq = txq_data + i * size;
+			ieee80211_init_tx_queue(sdata, sta, txq, i);
+		}
 	}
 
+	if (sta_prepare_rate_control(local, sta, gfp))
+		goto free_txq;
+
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		/*
 		 * timer_to_tid must be initialized with identity mapping
@@ -346,7 +367,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		struct ieee80211_supported_band *sband =
-			local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
+			hw->wiphy->bands[ieee80211_get_sdata_band(sdata)];
 		u8 smps = (sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >>
 				IEEE80211_HT_CAP_SM_PS_SHIFT;
 		/*
@@ -371,6 +392,13 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
+
+free_txq:
+	if (sta->sta.txq[0])
+		kfree(to_txq_info(sta->sta.txq[0]));
+free:
+	kfree(sta);
+	return NULL;
 }
 
 static int sta_info_insert_check(struct sta_info *sta)
@@ -640,6 +668,8 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 
 		indicate_tim |=
 			sta->driver_buffered_tids & tids;
+		indicate_tim |=
+			sta->txq_buffered_tids & tids;
 	}
 
  done:
@@ -1071,7 +1101,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff_head pending;
-	int filtered = 0, buffered = 0, ac;
+	int filtered = 0, buffered = 0, ac, i;
 	unsigned long flags;
 	struct ps_data *ps;
 
@@ -1090,10 +1120,22 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
+	sta->txq_buffered_tids = 0;
 
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
+	if (sta->sta.txq[0]) {
+		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
+
+			if (!skb_queue_len(&txqi->queue))
+				continue;
+
+			drv_wake_tx_queue(local, txqi);
+		}
+	}
+
 	skb_queue_head_init(&pending);
 
 	/* sync with ieee80211_tx_h_unicast_ps_buf */
@@ -1254,7 +1296,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	bool more_data = false;
-	int ac;
+	int ac, tid;
 	unsigned long driver_release_tids = 0;
 	struct sk_buff_head frames;
 
@@ -1275,8 +1317,10 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/* if we already have frames from software, then we can't also
 		 * release from hardware queues
 		 */
-		if (skb_queue_empty(&frames))
+		if (skb_queue_empty(&frames)) {
 			driver_release_tids |= sta->driver_buffered_tids & tids;
+			driver_release_tids |= sta->txq_buffered_tids & tids;
+		}
 
 		if (driver_release_tids) {
 			/* If the driver has data on more than one TID then
@@ -1447,6 +1491,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		sta_info_recalc_tim(sta);
 	} else {
+		unsigned long tids = sta->txq_buffered_tids & driver_release_tids;
+
 		/*
 		 * We need to release a frame that is buffered somewhere in the
 		 * driver ... it'll have to handle that.
@@ -1466,8 +1512,22 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		 * that the TID(s) became empty before returning here from the
 		 * release function.
 		 * Either way, however, when the driver tells us that the TID(s)
-		 * became empty we'll do the TIM recalculation.
+		 * became empty or we find that a txq became empty, we'll do the
+		 * TIM recalculation.
 		 */
+
+		if (!sta->sta.txq[0])
+			return;
+
+		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
+			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
+
+			if (!(tids & BIT(tid)) || skb_queue_len(&txqi->queue))
+				continue;
+
+			sta_info_recalc_tim(sta);
+			break;
+		}
 	}
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 248f56e..67482e3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -274,6 +274,7 @@ struct sta_ampdu_mlme {
  *	entered power saving state, these are also delivered to
  *	the station when it leaves powersave or polls for frames
  * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
+ * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
  * @rx_packets: Number of MSDUs received from this STA
  * @rx_bytes: Number of bytes received from this STA
  * @last_rx: time (in jiffies) when last frame was received from this STA
@@ -368,6 +369,7 @@ struct sta_info {
 	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
+	unsigned long txq_buffered_tids;
 
 	/* Updated from RX path only, no locking requirements */
 	unsigned long rx_packets;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 263a956..87f4691 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2312,6 +2312,34 @@ TRACE_EVENT(drv_tdls_recv_channel_switch,
 	)
 );
 
+TRACE_EVENT(drv_wake_tx_queue,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 u8 tid),
+
+	TP_ARGS(local, sdata, sta, tid),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, tid)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " tid: 0x%x",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->tid
+	)
+);
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 65cb4bb..0ab9151 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -782,12 +782,23 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static u16
+ieee80211_tx_next_seq(struct sta_info *sta, int tid)
+{
+	u16 *seq = &sta->tid_seq[tid];
+	u16 ret = cpu_to_le16(*seq);
+
+	/* Increase the sequence number. */
+	*seq = (*seq + 0x10) & IEEE80211_SCTL_SEQ;
+
+	return ret;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-	u16 *seq;
 	u8 *qc;
 	int tid;
 
@@ -838,13 +849,10 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 
 	qc = ieee80211_get_qos_ctl(hdr);
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-	seq = &tx->sta->tid_seq[tid];
 	tx->sta->tx_msdu[tid]++;
 
-	hdr->seq_ctrl = cpu_to_le16(*seq);
-
-	/* Increase the sequence number. */
-	*seq = (*seq + 0x10) & IEEE80211_SCTL_SEQ;
+	if (!tx->sta->sta.txq[0])
+		hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);
 
 	return TX_CONTINUE;
 }
@@ -1085,7 +1093,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		 * nothing -- this aggregation session is being started
 		 * but that might still fail with the driver
 		 */
-	} else {
+	} else if (!tx->sta->sta.txq[tid]) {
 		spin_lock(&tx->sta->lock);
 		/*
 		 * Need to re-check now, because we may get here
@@ -1219,13 +1227,101 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
+static void ieee80211_drv_tx(struct ieee80211_local *local,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *pubsta,
+			     struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_control control = {
+		.sta = pubsta
+	};
+	struct ieee80211_txq *txq = NULL;
+	struct txq_info *txqi;
+	u8 ac;
+
+	if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
+		goto tx_normal;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		goto tx_normal;
+
+	if (pubsta) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+		txq = pubsta->txq[tid];
+	} else if (vif) {
+		txq = vif->txq;
+	}
+
+	if (!txq)
+		goto tx_normal;
+
+	ac = txq->ac;
+	txqi = container_of(txq, struct txq_info, txq);
+	atomic_inc(&sdata->txqs_len[ac]);
+	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
+		netif_stop_subqueue(sdata->dev, ac);
+
+	skb_queue_tail(&txqi->queue, skb);
+	drv_wake_tx_queue(local, txqi);
+
+	return;
+
+tx_normal:
+	drv_tx(local, &control, skb);
+}
+
+struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
+				     struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
+	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb = NULL;
+	u8 ac = txq->ac;
+
+	spin_lock_bh(&txqi->queue.lock);
+
+	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
+		goto out;
+
+	skb = __skb_dequeue(&txqi->queue);
+	if (!skb)
+		goto out;
+
+	atomic_dec(&sdata->txqs_len[ac]);
+	if (__netif_subqueue_stopped(sdata->dev, ac))
+		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		struct sta_info *sta = container_of(txq->sta, struct sta_info,
+						    sta);
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, txq->tid);
+		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
+		else
+			info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+	}
+
+out:
+	spin_unlock_bh(&txqi->queue.lock);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_tx_dequeue);
+
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct sk_buff_head *skbs,
 			       bool txpending)
 {
-	struct ieee80211_tx_control control;
 	struct sk_buff *skb, *tmp;
 	unsigned long flags;
 
@@ -1283,10 +1379,9 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
-		control.sta = sta;
 
 		__skb_unlink(skb, skbs);
-		drv_tx(local, &control, skb);
+		ieee80211_drv_tx(local, vif, sta, skb);
 	}
 
 	return true;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 37d85d3..45cb02e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -308,6 +308,11 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 		for (ac = 0; ac < n_acs; ac++) {
 			int ac_queue = sdata->vif.hw_queue[ac];
 
+			if (local->ops->wake_tx_queue &&
+			    (atomic_read(&sdata->txqs_len[ac]) >
+			     local->hw.txq_ac_max_pending))
+				continue;
+
 			if (ac_queue == queue ||
 			    (sdata->vif.cab_queue == queue &&
 			     local->queue_stop_reasons[ac_queue] == 0 &&
@@ -3307,3 +3312,36 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo)
 
 	return buf;
 }
+
+void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta,
+			     struct txq_info *txqi, int tid)
+{
+	skb_queue_head_init(&txqi->queue);
+	txqi->txq.vif = &sdata->vif;
+
+	if (sta) {
+		txqi->txq.sta = &sta->sta;
+		sta->sta.txq[tid] = &txqi->txq;
+		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];
+	} else {
+		sdata->vif.txq = &txqi->txq;
+		txqi->txq.ac = IEEE80211_AC_BE;
+	}
+}
+
+void ieee80211_flush_tx_queue(struct ieee80211_local *local,
+			      struct ieee80211_txq *txq)
+{
+	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
+	struct sk_buff *skb;
+	int n = 0;
+
+	while ((skb = skb_dequeue(&txqi->queue)) != NULL) {
+		n++;
+		ieee80211_free_txskb(&local->hw, skb);
+	}
+
+	atomic_sub(n, &sdata->txqs_len[txq->ac]);
+}
-- 
2.2.2

