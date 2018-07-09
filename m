Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36093 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932845AbeGIQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 12:37:09 -0400
Subject: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to TXQs
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Mon, 09 Jul 2018 18:37:05 +0200
Message-ID: <153115422499.7447.2570671473822724496.stgit@alrua-x1> (sfid-20180709_183717_542396_91AD1C0D)
In-Reply-To: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime accounting and scheduling to the mac80211 TXQ
scheduler. A new callback, ieee80211_sta_register_airtime(), is added
that drivers can call to report airtime usage for stations, and an
extended feature flag is added that drivers can use to opt into airtime
fairness scheduling.

When the airtime fairness feature is enabled, mac80211 will schedule TXQs
(through ieee80211_next_txq()) in a way that enforces airtime fairness
between active stations. This scheduling works the same way as the ath9k
in-driver airtime fairness scheduling, but also adds weighted fairness
to support airtime policies.

If the extended feature is not set, the scheduler will default to
round-robin scheduling.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h       |   28 ++++++++++++++++++++
 include/uapi/linux/nl80211.h |    3 ++
 net/mac80211/debugfs.c       |    3 ++
 net/mac80211/debugfs_sta.c   |   35 +++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |    3 ++
 net/mac80211/main.c          |    2 +
 net/mac80211/sta_info.c      |   24 +++++++++++++++++
 net/mac80211/sta_info.h      |   17 ++++++++++++
 net/mac80211/tx.c            |   60 ++++++++++++++++++++++++++++++++----------
 9 files changed, 161 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 18e43193b614..17759d55b7d4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5291,6 +5291,34 @@ void ieee80211_sta_eosp(struct ieee80211_sta *pubsta);
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
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..28550d01948f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5223,6 +5223,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT: Driver/device can omit all data
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
+ * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports airtime fairness
+ *      scheduling.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5259,6 +5261,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_TXQS,
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
+	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b5adf3625d16..08d112dc8bd6 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -379,6 +379,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD_MODE(aqm, 0600);
 
+	debugfs_create_u16("airtime_flags", 0600,
+			   phyd, &local->airtime_flags);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4105081dc1df..de4067bc11cd 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -192,6 +192,37 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
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
+		"RX: %llu us\nTX: %llu us\n"
+		"Deficit: VO: %lld us VI: %lld us BE: %lld us BK: %lld us\n",
+		sta->airtime.rx_airtime,
+		sta->airtime.tx_airtime,
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
@@ -546,6 +577,10 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
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
index 6bd68639c699..c1f8b9f6128d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1133,6 +1133,9 @@ struct ieee80211_local {
 	struct list_head active_txqs;
 	u16 schedule_seqno;
 
+	u16 airtime_flags;
+	u16 airtime_quantum;
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index abaca5e1a59f..e597b22ce403 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -636,6 +636,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	INIT_LIST_HEAD(&local->active_txqs);
 	spin_lock_init(&local->active_txq_lock);
+	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
+	local->airtime_quantum = IEEE80211_AIRTIME_QUANTUM;
 
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index bb92bf516b6b..4e1e2628fe7d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -384,6 +384,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		skb_queue_head_init(&sta->ps_tx_buf[i]);
 		skb_queue_head_init(&sta->tx_filtered[i]);
+		sta->airtime.deficit[i] = local->airtime_quantum;
 	}
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
@@ -427,6 +428,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->cparams.interval = MS2TIME(100);
 	sta->cparams.ecn = true;
 
+	sta->airtime.weight = 1;
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
@@ -1824,6 +1827,27 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 
+void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
+				    u32 tx_airtime, u32 rx_airtime)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_local *local = sta->sdata->local;
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
+	spin_unlock_bh(&local->active_txq_lock);
+}
+EXPORT_SYMBOL(ieee80211_sta_register_airtime);
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..d87a6c31dcb6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -127,6 +127,21 @@ enum ieee80211_agg_stop_reason {
 	AGG_STOP_DESTROY_STA,
 };
 
+/* How much to increase airtime deficit on each scheduling round, by default
+ * (userspace can change this per phy)
+ */
+#define IEEE80211_AIRTIME_QUANTUM        300 /* usec */
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
@@ -563,6 +578,8 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	struct airtime_info airtime;
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 24766566a380..202717924ac3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3590,7 +3590,21 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock);
 
 	if (list_empty(&txqi->schedule_order)) {
-		list_add_tail(&txqi->schedule_order, &local->active_txqs);
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
+			list_add(&txqi->schedule_order, &local->active_txqs);
+		else
+			list_add_tail(&txqi->schedule_order,
+				      &local->active_txqs);
+
 		if (reset_seqno)
 			txqi->schedule_seqno = local->schedule_seqno - 1;
 		ret = true;
@@ -3602,6 +3616,17 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_schedule_txq);
 
+static inline struct txq_info *find_txqi(struct list_head *head, s8 ac)
+{
+	struct txq_info *txqi;
+
+	list_for_each_entry(txqi, head, schedule_order) {
+		if (ac < 0 || txqi->txq.ac == ac)
+			return txqi;
+	}
+	return NULL;
+}
+
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 					 bool inc_seqno)
 {
@@ -3613,24 +3638,31 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 	if (inc_seqno)
 		local->schedule_seqno++;
 
-	if (list_empty(&local->active_txqs))
+begin:
+	txqi = find_txqi(&local->active_txqs, ac);
+	if (!txqi)
 		goto out;
 
-	list_for_each_entry(txqi, &local->active_txqs, schedule_order) {
-		if (ac < 0 || txqi->txq.ac == ac) {
-			/* If seqnos are equal, we've seen this txqi before in
-			 * this scheduling round, so abort.
-			 */
-			if (txqi->schedule_seqno == local->schedule_seqno)
-				txqi = NULL;
-			else
-				list_del_init(&txqi->schedule_order);
-			goto out;
+	if (txqi->txq.sta) {
+		struct sta_info *sta = container_of(txqi->txq.sta,
+						struct sta_info, sta);
+
+		if (sta->airtime.deficit[txqi->txq.ac] < 0) {
+			sta->airtime.deficit[txqi->txq.ac] +=
+				local->airtime_quantum * sta->airtime.weight;
+			list_move_tail(&txqi->schedule_order,
+				       &local->active_txqs);
+			goto begin;
 		}
 	}
 
-	/* no txq with requested ac found */
-	txqi = NULL;
+	/* If seqnos are equal, we've seen this txqi before in this scheduling
+	 * round, so abort.
+	 */
+	if (txqi->schedule_seqno == local->schedule_seqno)
+		txqi = NULL;
+	else
+		list_del_init(&txqi->schedule_order);
 
 out:
 	spin_unlock_bh(&local->active_txq_lock);
