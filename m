Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56627 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbeIHDF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 23:05:58 -0400
Subject: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and scheduling
 to TXQs
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Sat, 08 Sep 2018 00:22:50 +0200
Message-ID: <153635897061.14170.17999956909203163571.stgit@alrua-x1> (sfid-20180908_002305_131598_05A63919)
In-Reply-To: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime accounting and scheduling to the mac80211 TXQ
scheduler. A new callback, ieee80211_sta_register_airtime(), is added
that drivers can call to report airtime usage for stations.

When airtime information is present, mac80211 will schedule TXQs
(through ieee80211_next_txq()) in a way that enforces airtime fairness
between active stations. This scheduling works the same way as the ath9k
in-driver airtime fairness scheduling. If no airtime usage is reported
by the driver, the scheduler will default to round-robin scheduling.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h       |   52 ++++++++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |    4 ++
 net/mac80211/debugfs.c       |    3 ++
 net/mac80211/debugfs_sta.c   |   42 ++++++++++++++++++++++++--
 net/mac80211/ieee80211_i.h   |    2 +
 net/mac80211/main.c          |    1 +
 net/mac80211/sta_info.c      |   32 +++++++++++++++++++
 net/mac80211/sta_info.h      |   16 ++++++++++
 net/mac80211/tx.c            |   69 +++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 216 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff413d9caa50..a744ad4f4f59 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5350,6 +5350,34 @@ void ieee80211_sta_eosp(struct ieee80211_sta *pubsta);
  */
 void ieee80211_send_eosp_nullfunc(struct ieee80211_sta *pubsta, int tid);
 
+/**
+ * ieee80211_sta_register_airtime - register airtime usage for a sta/tid
+ *
+ * Register airtime usage for a given sta on a given tid. The driver can call
+ * this function to notify mac80211 that a station used a certain amount of
+ * airtime. This information will be used by the TXQ scheduler to schedule
+ * stations in a way that ensures airtime fairness.
+ *
+ * The reported airtime should as a minimum include all time that is spent
+ * transmitting to the remote station, including overhead and padding, but not
+ * including time spent waiting for a TXOP. If the time is not reported by the
+ * hardware it can in some cases be calculated from the rate and known frame
+ * composition. When possible, the time should include any failed transmission
+ * attempts.
+ *
+ * The driver can either call this function synchronously for every packet or
+ * aggregate, or asynchronously as airtime usage information becomes available.
+ * TX and RX airtime can be reported together, or separately by setting one of
+ * them to 0.
+ *
+ * @pubsta: the station
+ * @tid: the TID to register airtime for
+ * @tx_airtime: airtime used during TX (in usec)
+ * @rx_airtime: airtime used during RX (in usec)
+ */
+void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
+				    u32 tx_airtime, u32 rx_airtime);
+
 /**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
@@ -6089,6 +6117,30 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 					 bool first);
 
+/**
+ * ieee80211_airtime_may_transmit - check whether TXQ is allowed to transmit
+ *
+ * This function is used to check whether given txq is allowed to transmit by
+ * the airtime scheduler, and can be used by drivers to access the airtime
+ * fairness accounting without going using the scheduling order enfored by
+ * next_txq().
+ *
+ * Returns %true if the airtime scheduler does not think the TXQ should be
+ * throttled. This function can also have the side effect of rotating the TXQ in
+ * the scheduler rotation, which will eventually bring the deficit to positive
+ * and allow the station to transmit again.
+ *
+ * If this function returns %true, the TXQ will have been removed from the
+ * scheduling. It is the driver's responsibility to add it back (by calling
+ * ieee80211_schedule_txq()) if needed.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ */
+bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc94178d608..6b2b61646b6a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5231,6 +5231,9 @@ enum nl80211_feature_flags {
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
  *
+ * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports airtime fairness
+ *      scheduling.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5269,6 +5272,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
+	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3fe541e358f3..81c5fec2eae7 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -383,6 +383,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
 
+	debugfs_create_u16("airtime_flags", 0600,
+			   phyd, &local->airtime_flags);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index af5185a836e5..b6950d883a3a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -181,9 +181,9 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			       txqi->tin.tx_bytes,
 			       txqi->tin.tx_packets,
 			       txqi->flags,
-			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
-			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
-			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
+			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
+			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
+			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
 	}
 
 	rcu_read_unlock();
@@ -195,6 +195,38 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(aqm);
 
+static ssize_t sta_airtime_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->sdata->local;
+	size_t bufsz = 200;
+	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
+	ssize_t rv;
+
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	p += scnprintf(p, bufsz + buf - p,
+		"RX: %llu us\nTX: %llu us\nWeight: %u\n"
+		"Deficit: VO: %lld us VI: %lld us BE: %lld us BK: %lld us\n",
+		sta->airtime.rx_airtime,
+		sta->airtime.tx_airtime,
+		sta->airtime.weight,
+		sta->airtime.deficit[0],
+		sta->airtime.deficit[1],
+		sta->airtime.deficit[2],
+		sta->airtime.deficit[3]);
+
+	spin_unlock_bh(&local->active_txq_lock);
+	rv = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return rv;
+}
+STA_OPS(airtime);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -906,6 +938,10 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 
+	if (wiphy_ext_feature_isset(local->hw.wiphy,
+				    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		DEBUGFS_ADD(airtime);
+
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs_dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 75f9c9ab364f..838542b4f583 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1136,6 +1136,8 @@ struct ieee80211_local {
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
 
+	u16 airtime_flags;
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c6d88758cbb7..9e7b33a0d0a6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -666,6 +666,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	for (i = 0; i < IEEE80211_NUM_ACS; i++)
 		INIT_LIST_HEAD(&local->active_txqs[i]);
 	spin_lock_init(&local->active_txq_lock);
+	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
 
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c2f5cb7df54f..aba13f88bc86 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -387,9 +387,12 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	if (sta_prepare_rate_control(local, sta, gfp))
 		goto free_txq;
 
+	sta->airtime.weight = IEEE80211_DEFAULT_AIRTIME_WEIGHT;
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		skb_queue_head_init(&sta->ps_tx_buf[i]);
 		skb_queue_head_init(&sta->tx_filtered[i]);
+		sta->airtime.deficit[i] = sta->airtime.weight;
 	}
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
@@ -1826,6 +1829,35 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 
+void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
+				    u32 tx_airtime, u32 rx_airtime)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_local *local = sta->sdata->local;
+	struct txq_info *txqi;
+	u8 ac = ieee80211_ac_from_tid(tid);
+	u32 airtime = 0;
+
+	if (sta->local->airtime_flags & AIRTIME_USE_TX)
+		airtime += tx_airtime;
+	if (sta->local->airtime_flags & AIRTIME_USE_RX)
+		airtime += rx_airtime;
+
+	spin_lock_bh(&local->active_txq_lock);
+	sta->airtime.tx_airtime += tx_airtime;
+	sta->airtime.rx_airtime += rx_airtime;
+	sta->airtime.deficit[ac] -= airtime;
+
+	if (sta->airtime.deficit[ac] < 0) {
+		txqi = to_txq_info(pubsta->txq[tid]);
+		if (list_empty(&txqi->schedule_order))
+			list_add_tail(&txqi->schedule_order,
+				      &local->active_txqs[ac]);
+	}
+	spin_unlock_bh(&local->active_txq_lock);
+}
+EXPORT_SYMBOL(ieee80211_sta_register_airtime);
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..97fff032eee5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -127,6 +127,20 @@ enum ieee80211_agg_stop_reason {
 	AGG_STOP_DESTROY_STA,
 };
 
+/* How much to increase airtime deficit on each scheduling round, by default
+ * (userspace can change this per phy) */
+#define IEEE80211_DEFAULT_AIRTIME_WEIGHT        256
+/* Debugfs flags to enable/disable use of RX/TX airtime in scheduler */
+#define AIRTIME_USE_TX		BIT(0)
+#define AIRTIME_USE_RX		BIT(1)
+
+struct airtime_info {
+	u64 rx_airtime;
+	u64 tx_airtime;
+	s64 deficit[IEEE80211_NUM_ACS];
+	u16 weight;
+};
+
 struct sta_info;
 
 /**
@@ -563,6 +577,8 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	struct airtime_info airtime;
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8bcc447e2cbc..758368d6106e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1446,6 +1446,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
 	INIT_LIST_HEAD(&txqi->schedule_order);
+	txqi->flags = 0;
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1486,6 +1487,7 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	txqi->flags = 0;
 	spin_lock_bh(&local->active_txq_lock);
 	list_del_init(&txqi->schedule_order);
 	spin_unlock_bh(&local->active_txq_lock);
@@ -3637,8 +3639,22 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock);
 
 	if (list_empty(&txqi->schedule_order)) {
-		list_add_tail(&txqi->schedule_order,
-			      &local->active_txqs[txq->ac]);
+		/* If airtime accounting is active, always enqueue STAs at the
+		 * head of the list to ensure that they only get moved to the
+		 * back by the airtime DRR scheduler once they have a negative
+		 * deficit. A station that already has a negative deficit will
+		 * get immediately moved to the back of the list on the next
+		 * call to ieee80211_next_txq().
+		 */
+		if (wiphy_ext_feature_isset(local->hw.wiphy,
+					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)
+		    && txqi->txq.sta)
+			list_add(&txqi->schedule_order,
+				 &local->active_txqs[txq->ac]);
+		else
+			list_add_tail(&txqi->schedule_order,
+				      &local->active_txqs[txq->ac]);
+
 		ret = true;
 	}
 
@@ -3648,6 +3664,32 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_schedule_txq);
 
+static bool ieee80211_txq_check_deficit(struct ieee80211_local *local,
+					struct txq_info *txqi)
+{
+	struct sta_info *sta;
+
+	lockdep_assert_held(&local->active_txq_lock);
+
+	if (!txqi->txq.sta)
+		return true;
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+	if (sta->airtime.deficit[txqi->txq.ac] > 0)
+		return true;
+
+	if (txqi == list_first_entry_or_null(&local->active_txqs[txqi->txq.ac],
+					     struct txq_info,
+					     schedule_order)) {
+		sta->airtime.deficit[txqi->txq.ac] += sta->airtime.weight;
+		list_move_tail(&txqi->schedule_order,
+			       &local->active_txqs[txqi->txq.ac]);
+	}
+
+	return false;
+}
+
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 					 bool first)
 {
@@ -3659,6 +3701,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 	if (first)
 		local->schedule_round[ac]++;
 
+ begin:
 	if (list_empty(&local->active_txqs[ac]))
 		goto out;
 
@@ -3666,6 +3709,9 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 				struct txq_info,
 				schedule_order);
 
+	if (!ieee80211_txq_check_deficit(local, txqi))
+		goto begin;
+
 	if (txqi->schedule_round == local->schedule_round[ac])
 		txqi = NULL;
 	else
@@ -3681,6 +3727,25 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 }
 EXPORT_SYMBOL(ieee80211_next_txq);
 
+bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+	bool may_tx = false;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (ieee80211_txq_check_deficit(local, txqi)) {
+		may_tx = true;
+		list_del_init(&txqi->schedule_order);
+	}
+
+	spin_unlock_bh(&local->active_txq_lock);
+	return may_tx;
+}
+EXPORT_SYMBOL(ieee80211_txq_may_transmit);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
