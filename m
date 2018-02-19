Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36749 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753209AbeBSRCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 12:02:54 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to userspace
Date: Mon, 19 Feb 2018 18:02:22 +0100
Message-Id: <20180219170224.14816-2-toke@toke.dk> (sfid-20180219_180300_682375_800CE1A2)
In-Reply-To: <20180219170224.14816-1-toke@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for exporting the mac80211 TXQ stats via nl80211 by
way of a nested TXQ stats attribute, as well as for configuring the
quantum and limits that were previously only changeable through debugfs.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/cfg80211.h       |  50 +++++++++++++++++++
 include/uapi/linux/nl80211.h |  57 +++++++++++++++++++++
 net/mac80211/cfg.c           |  95 +++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |   3 ++
 net/mac80211/main.c          |   3 ++
 net/mac80211/sta_info.c      |  12 +++++
 net/mac80211/tx.c            |  20 ++++++++
 net/wireless/nl80211.c       | 115 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  12 +++++
 net/wireless/trace.h         |  14 ++++++
 10 files changed, 381 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 56e905cd4b07..9e8041f7cb37 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1075,6 +1075,37 @@ struct sta_bss_parameters {
 	u16 beacon_interval;
 };
 
+/**
+ * struct cfg80211_txq_stats - TXQ statistics for this TID
+ * @filled: bitmap of flags using the bits of &enum nl80211_txq_stats to
+ *	indicate the relevant values in this struct are filled
+ * @backlog_bytes: total number of bytes currently backlogged
+ * @backlog_packets: total number of packets currently backlogged
+ * @flows: number of new flows seen
+ * @drops: total number of packets dropped
+ * @ecn_marks: total number of packets marked with ECN CE
+ * @overlimit: number of drops due to queue space overflow
+ * @overmemory: number of drops due to memory limit overflow
+ * @collisions: number of hash collisions
+ * @tx_bytes: total number of bytes dequeued
+ * @tx_packets: total number of packets dequeued
+ * @max_flows: maximum number of flows supported
+ */
+struct cfg80211_txq_stats {
+	u32 filled;
+	u32 backlog_bytes;
+	u32 backlog_packets;
+	u32 flows;
+	u32 drops;
+	u32 ecn_marks;
+	u32 overlimit;
+	u32 overmemory;
+	u32 collisions;
+	u32 tx_bytes;
+	u32 tx_packets;
+	u32 max_flows;
+};
+
 /**
  * struct cfg80211_tid_stats - per-TID statistics
  * @filled: bitmap of flags using the bits of &enum nl80211_tid_stats to
@@ -1084,6 +1115,7 @@ struct sta_bss_parameters {
  * @tx_msdu_retries: number of retries (not counting the first) for
  *	transmitted MSDUs
  * @tx_msdu_failed: number of failed transmitted MSDUs
+ * @txq_stats: TXQ statistics
  */
 struct cfg80211_tid_stats {
 	u32 filled;
@@ -1091,6 +1123,7 @@ struct cfg80211_tid_stats {
 	u64 tx_msdu;
 	u64 tx_msdu_retries;
 	u64 tx_msdu_failed;
+	struct cfg80211_txq_stats txq_stats;
 };
 
 #define IEEE80211_MAX_CHAINS	4
@@ -2191,6 +2224,9 @@ enum cfg80211_connect_params_changed {
  * @WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
  * @WIPHY_PARAM_COVERAGE_CLASS: coverage class changed
  * @WIPHY_PARAM_DYN_ACK: dynack has been enabled
+ * @WIPHY_PARAM_TXQ_LIMIT: TXQ packet limit has been changed
+ * @WIPHY_PARAM_TXQ_MEMORY_LIMIT: TXQ memory limit has been changed
+ * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -2199,6 +2235,9 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_RTS_THRESHOLD	= 1 << 3,
 	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
 	WIPHY_PARAM_DYN_ACK		= 1 << 5,
+	WIPHY_PARAM_TXQ_LIMIT		= 1 << 6,
+	WIPHY_PARAM_TXQ_MEMORY_LIMIT	= 1 << 7,
+	WIPHY_PARAM_TXQ_QUANTUM		= 1 << 8,
 };
 
 /**
@@ -2951,6 +2990,9 @@ struct cfg80211_external_auth_params {
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
+ * @get_txq_stats: Get TXQ stats for interface or phy. If wdev is %NULL, this
+ *      function should return phy stats, and interface stats otherwise.
+ *
  * @set_pmk: configure the PMK to be used for offloaded 802.1X 4-Way handshake.
  *	If not deleted through @del_pmk the PMK remains valid until disconnect
  *	upon which the driver should clear it.
@@ -3249,6 +3291,10 @@ struct cfg80211_ops {
 					    struct net_device *dev,
 					    const bool enabled);
 
+	int	(*get_txq_stats)(struct wiphy *wiphy,
+			         struct wireless_dev *wdev,
+			         struct cfg80211_txq_stats *txqstats);
+
 	int	(*set_pmk)(struct wiphy *wiphy, struct net_device *dev,
 			   const struct cfg80211_pmk_conf *conf);
 	int	(*del_pmk)(struct wiphy *wiphy, struct net_device *dev,
@@ -3921,6 +3967,10 @@ struct wiphy {
 
 	u8 nan_supported_bands;
 
+	u32 txq_limit;
+	u32 txq_memory_limit;
+	u32 txq_quantum;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c13c84304be3..fc814037bb39 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2196,6 +2196,16 @@ enum nl80211_commands {
  * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
  *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
  *
+ * @NL80211_ATTR_TXQ_STATS: TXQ statistics (nested attribute, see enum
+ *      nl80211_txq_stats)
+ * @NL80211_ATTR_TXQ_LIMIT: Total packet limit for the TXQ queues for this phy.
+ *      The smaller of this and the memory limit is enforced.
+ * @NL80211_ATTR_TXQ_MEMORY_LIMIT: Total memory memory limit (in bytes) for the
+ *      TXQ queues for this phy. The smaller of this and the packet limit is
+ *      enforced.
+ * @NL80211_ATTR_TXQ_QUANTUM: TXQ scheduler quantum (bytes). Number of bytes
+ *      a flow is assigned on each round of the DRR scheduler.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2628,6 +2638,11 @@ enum nl80211_attrs {
 	NL80211_ATTR_NSS,
 	NL80211_ATTR_ACK_SIGNAL,
 
+	NL80211_ATTR_TXQ_STATS,
+	NL80211_ATTR_TXQ_LIMIT,
+	NL80211_ATTR_TXQ_MEMORY_LIMIT,
+	NL80211_ATTR_TXQ_QUANTUM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3005,6 +3020,7 @@ enum nl80211_sta_info {
  * @NL80211_TID_STATS_TX_MSDU_FAILED: number of failed transmitted
  *	MSDUs (u64)
  * @NL80211_TID_STATS_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_TID_STATS_TXQ_STATS: TXQ stats (nested attribute)
  * @NUM_NL80211_TID_STATS: number of attributes here
  * @NL80211_TID_STATS_MAX: highest numbered attribute here
  */
@@ -3015,12 +3031,51 @@ enum nl80211_tid_stats {
 	NL80211_TID_STATS_TX_MSDU_RETRIES,
 	NL80211_TID_STATS_TX_MSDU_FAILED,
 	NL80211_TID_STATS_PAD,
+	NL80211_TID_STATS_TXQ_STATS,
 
 	/* keep last */
 	NUM_NL80211_TID_STATS,
 	NL80211_TID_STATS_MAX = NUM_NL80211_TID_STATS - 1
 };
 
+/**
+ * enum nl80211_txq_stats - per TXQ statistics attributes
+ * @__NL80211_TXQ_STATS_INVALID: attribute number 0 is reserved
+ * @NUM_NL80211_TXQ_STATS: number of attributes here
+ * @NL80211_TXQ_STATS_BACKLOG_BYTES: number of bytes currently backlogged
+ * @NL80211_TXQ_STATS_BACKLOG_PACKETS: number of packets currently
+ *      backlogged
+ * @NL80211_TXQ_STATS_FLOWS: total number of new flows seen
+ * @NL80211_TXQ_STATS_DROPS: total number of packet drops
+ * @NL80211_TXQ_STATS_ECN_MARKS: total number of packet ECN marks
+ * @NL80211_TXQ_STATS_OVERLIMIT: number of drops due to queue space overflow
+ * @NL80211_TXQ_STATS_OVERMEMORY: number of drops due to memory limit overflow
+ *      (only for per-phy stats)
+ * @NL80211_TXQ_STATS_COLLISIONS: number of hash collisions
+ * @NL80211_TXQ_STATS_TX_BYTES: total number of bytes dequeued from TXQ
+ * @NL80211_TXQ_STATS_TX_PACKETS: total number of packets dequeued from TXQ
+ * @NL80211_TXQ_STATS_MAX_FLOWS: number of flow buckets for PHY
+ * @NL80211_TXQ_STATS_MAX: highest numbered attribute here
+ */
+enum nl80211_txq_stats {
+	__NL80211_TXQ_STATS_INVALID,
+	NL80211_TXQ_STATS_BACKLOG_BYTES,
+	NL80211_TXQ_STATS_BACKLOG_PACKETS,
+	NL80211_TXQ_STATS_FLOWS,
+	NL80211_TXQ_STATS_DROPS,
+	NL80211_TXQ_STATS_ECN_MARKS,
+	NL80211_TXQ_STATS_OVERLIMIT,
+	NL80211_TXQ_STATS_OVERMEMORY,
+	NL80211_TXQ_STATS_COLLISIONS,
+	NL80211_TXQ_STATS_TX_BYTES,
+	NL80211_TXQ_STATS_TX_PACKETS,
+	NL80211_TXQ_STATS_MAX_FLOWS,
+
+	/* keep last */
+	NUM_NL80211_TXQ_STATS,
+	NL80211_TXQ_STATS_MAX = NUM_NL80211_TXQ_STATS - 1
+};
+
 /**
  * enum nl80211_mpath_flags - nl80211 mesh path flags
  *
@@ -4999,6 +5054,7 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
  * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
  * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
+ * @NL80211_EXT_FEATURE_TXQS: Driver supports FQ-CoDel-enabled intermediate TXQs.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5029,6 +5085,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
 	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+	NL80211_EXT_FEATURE_TXQS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 46028e12e216..18418f88e383 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2365,6 +2365,11 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	    (WIPHY_PARAM_RETRY_SHORT | WIPHY_PARAM_RETRY_LONG))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_RETRY_LIMITS);
 
+	if (changed & (WIPHY_PARAM_TXQ_LIMIT |
+		       WIPHY_PARAM_TXQ_MEMORY_LIMIT |
+			WIPHY_PARAM_TXQ_QUANTUM))
+		ieee80211_txq_set_params(local);
+
 	return 0;
 }
 
@@ -3693,6 +3698,95 @@ static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
 	return 0;
 }
 
+void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
+			     struct txq_info *txqi)
+{
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_BACKLOG_BYTES))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_BACKLOG_BYTES);
+		txqstats->backlog_bytes = txqi->tin.backlog_bytes;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_BACKLOG_PACKETS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_BACKLOG_PACKETS);
+		txqstats->backlog_packets = txqi->tin.backlog_packets;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_FLOWS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_FLOWS);
+		txqstats->flows = txqi->tin.flows;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_DROPS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_DROPS);
+		txqstats->drops = txqi->cstats.drop_count;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_ECN_MARKS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_ECN_MARKS);
+		txqstats->ecn_marks = txqi->cstats.ecn_mark;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_OVERLIMIT))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_OVERLIMIT);
+		txqstats->overlimit = txqi->tin.overlimit;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_COLLISIONS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_COLLISIONS);
+		txqstats->collisions = txqi->tin.collisions;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_TX_BYTES))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_TX_BYTES);
+		txqstats->tx_bytes = txqi->tin.tx_bytes;
+	}
+
+	if (!(txqstats->filled & BIT(NL80211_TXQ_STATS_TX_PACKETS))) {
+		txqstats->filled |= BIT(NL80211_TXQ_STATS_TX_PACKETS);
+		txqstats->tx_packets = txqi->tin.tx_packets;
+	}
+}
+
+static int ieee80211_get_txq_stats(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_txq_stats *txqstats)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!local->ops->wake_tx_queue)
+		return 1;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	if (wdev) {
+		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+		if (!sdata->vif.txq)
+			return 1;
+		ieee80211_fill_txq_stats(txqstats, to_txq_info(sdata->vif.txq));
+	} else {
+		/* phy stats */
+		txqstats->filled |= (BIT(NL80211_TXQ_STATS_BACKLOG_PACKETS) |
+				     BIT(NL80211_TXQ_STATS_BACKLOG_BYTES) |
+				     BIT(NL80211_TXQ_STATS_OVERLIMIT) |
+				     BIT(NL80211_TXQ_STATS_OVERMEMORY) |
+				     BIT(NL80211_TXQ_STATS_COLLISIONS) |
+				     BIT(NL80211_TXQ_STATS_MAX_FLOWS));
+		txqstats->backlog_packets = local->fq.backlog;
+		txqstats->backlog_bytes = local->fq.memory_usage;
+		txqstats->overlimit = local->fq.overlimit;
+		txqstats->overmemory = local->fq.overmemory;
+		txqstats->collisions = local->fq.collisions;
+		txqstats->max_flows = local->fq.flows_cnt;
+	}
+
+	rcu_read_unlock();
+	spin_unlock_bh(&local->fq.lock);
+
+	return 0;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3785,4 +3879,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.add_nan_func = ieee80211_add_nan_func,
 	.del_nan_func = ieee80211_del_nan_func,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
+	.get_txq_stats = ieee80211_get_txq_stats,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..c2f3310c41e8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2000,6 +2000,7 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 }
 
 int ieee80211_txq_setup_flows(struct ieee80211_local *local);
+int ieee80211_txq_set_params(struct ieee80211_local *local);
 void ieee80211_txq_teardown_flows(struct ieee80211_local *local);
 void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta,
@@ -2008,6 +2009,8 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 			 struct txq_info *txqi);
 void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
+void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
+			      struct txq_info *txqi);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0785d04a80bc..e884f3b5064f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -563,6 +563,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	if (ops->wake_tx_queue)
+		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_TXQS);
+
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_RRM);
 
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0bc40c719a55..7f535452fcc4 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2050,6 +2050,18 @@ static void sta_set_tidstats(struct sta_info *sta,
 		tidstats->filled |= BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
 		tidstats->tx_msdu_failed = sta->status_stats.msdu_failed[tid];
 	}
+
+	if (local->ops->wake_tx_queue && tid < IEEE80211_NUM_TIDS) {
+		spin_lock_bh(&local->fq.lock);
+		rcu_read_lock();
+
+		tidstats->filled |= BIT(NL80211_TID_STATS_TXQ_STATS);
+		ieee80211_fill_txq_stats(&tidstats->txq_stats,
+					 to_txq_info(sta->sta.txq[tid]));
+
+		rcu_read_unlock();
+		spin_unlock_bh(&local->fq.lock);
+	}
 }
 
 static inline u64 sta_get_stats_bytes(struct ieee80211_sta_rx_stats *rxstats)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 933c67b5f845..6826d8d73eb3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1459,6 +1459,24 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
 }
 
+int ieee80211_txq_set_params(struct ieee80211_local *local)
+{
+	if (local->hw.wiphy->txq_limit)
+		local->fq.limit = local->hw.wiphy->txq_limit;
+	else
+		local->hw.wiphy->txq_limit = local->fq.limit;
+
+	if (local->hw.wiphy->txq_memory_limit)
+		local->fq.memory_limit = local->hw.wiphy->txq_memory_limit;
+	else
+		local->hw.wiphy->txq_memory_limit = local->fq.memory_limit;
+
+	if (local->hw.wiphy->txq_quantum)
+		local->fq.quantum = local->hw.wiphy->txq_quantum;
+	else
+		local->hw.wiphy->txq_quantum = local->fq.quantum;
+}
+
 int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 {
 	struct fq *fq = &local->fq;
@@ -1508,6 +1526,8 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	for (i = 0; i < fq->flows_cnt; i++)
 		codel_vars_init(&local->cvars[i]);
 
+	ieee80211_txq_set_params(local);
+
 	return 0;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 050ff61b06a3..9d2cc8e3afba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -421,6 +421,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 	[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT] = { .type = NLA_FLAG },
+
+	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
+	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
+	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -725,6 +729,39 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
+static bool nl80211_put_txq_stats(struct sk_buff *msg,
+				  struct cfg80211_txq_stats *txqstats,
+				  int attrtype)
+{
+	struct nlattr *txqattr;
+
+#define PUT_TXQVAL_U32(attr, memb) do {					  \
+	if (txqstats->filled & BIT(NL80211_TXQ_STATS_ ## attr) &&	  \
+	    nla_put_u32(msg, NL80211_TXQ_STATS_ ## attr, txqstats->memb)) \
+		return false;						  \
+	} while (0)
+
+	txqattr = nla_nest_start(msg, attrtype);
+	if (!txqattr)
+		return false;
+
+	PUT_TXQVAL_U32(BACKLOG_BYTES, backlog_bytes);
+	PUT_TXQVAL_U32(BACKLOG_PACKETS, backlog_packets);
+	PUT_TXQVAL_U32(FLOWS, flows);
+	PUT_TXQVAL_U32(DROPS, drops);
+	PUT_TXQVAL_U32(ECN_MARKS, ecn_marks);
+	PUT_TXQVAL_U32(OVERLIMIT, overlimit);
+	PUT_TXQVAL_U32(OVERMEMORY, overmemory);
+	PUT_TXQVAL_U32(COLLISIONS, collisions);
+	PUT_TXQVAL_U32(TX_BYTES, tx_bytes);
+	PUT_TXQVAL_U32(TX_PACKETS, tx_packets);
+	PUT_TXQVAL_U32(MAX_FLOWS, max_flows);
+	nla_nest_end(msg, txqattr);
+
+#undef PUT_TXQVAL_U32
+	return true;
+}
+
 /* netlink command implementations */
 
 struct key_parse {
@@ -1924,6 +1961,28 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				rdev->wiphy.nan_supported_bands))
 			goto nla_put_failure;
 
+		if (wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_TXQS)) {
+
+			struct cfg80211_txq_stats txqstats = {};
+			int res;
+
+			res = rdev_get_txq_stats(rdev, NULL, &txqstats);
+			if (!res && !nl80211_put_txq_stats(msg, &txqstats,
+							   NL80211_ATTR_TXQ_STATS))
+				goto nla_put_failure;
+
+			if (nla_put_u32(msg, NL80211_ATTR_TXQ_LIMIT,
+						rdev->wiphy.txq_limit))
+				goto nla_put_failure;
+			if (nla_put_u32(msg, NL80211_ATTR_TXQ_MEMORY_LIMIT,
+						rdev->wiphy.txq_memory_limit))
+				goto nla_put_failure;
+			if (nla_put_u32(msg, NL80211_ATTR_TXQ_QUANTUM,
+						rdev->wiphy.txq_quantum))
+				goto nla_put_failure;
+		}
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -2299,6 +2358,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u8 retry_short = 0, retry_long = 0;
 	u32 frag_threshold = 0, rts_threshold = 0;
 	u8 coverage_class = 0;
+	u32 txq_limit = 0, txq_memory_limit = 0, txq_quantum = 0;
 
 	ASSERT_RTNL();
 
@@ -2505,10 +2565,38 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		changed |= WIPHY_PARAM_DYN_ACK;
 	}
 
+	if (info->attrs[NL80211_ATTR_TXQ_LIMIT]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_TXQS))
+			return -EOPNOTSUPP;
+		txq_limit = nla_get_u32(
+			info->attrs[NL80211_ATTR_TXQ_LIMIT]);
+		changed |= WIPHY_PARAM_TXQ_LIMIT;
+	}
+
+	if (info->attrs[NL80211_ATTR_TXQ_MEMORY_LIMIT]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_TXQS))
+			return -EOPNOTSUPP;
+		txq_memory_limit = nla_get_u32(
+			info->attrs[NL80211_ATTR_TXQ_MEMORY_LIMIT]);
+		changed |= WIPHY_PARAM_TXQ_MEMORY_LIMIT;
+	}
+
+	if (info->attrs[NL80211_ATTR_TXQ_QUANTUM]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_TXQS))
+			return -EOPNOTSUPP;
+		txq_quantum = nla_get_u32(
+			info->attrs[NL80211_ATTR_TXQ_QUANTUM]);
+		changed |= WIPHY_PARAM_TXQ_QUANTUM;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
 		u8 old_coverage_class;
+		u32 old_txq_limit, old_txq_memory_limit, old_txq_quantum;
 
 		if (!rdev->ops->set_wiphy_params)
 			return -EOPNOTSUPP;
@@ -2518,6 +2606,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		old_frag_threshold = rdev->wiphy.frag_threshold;
 		old_rts_threshold = rdev->wiphy.rts_threshold;
 		old_coverage_class = rdev->wiphy.coverage_class;
+		old_txq_limit = rdev->wiphy.txq_limit;
+		old_txq_memory_limit = rdev->wiphy.txq_memory_limit;
+		old_txq_quantum = rdev->wiphy.txq_quantum;
 
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
 			rdev->wiphy.retry_short = retry_short;
@@ -2529,6 +2620,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.rts_threshold = rts_threshold;
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;
+		if (changed & WIPHY_PARAM_TXQ_LIMIT)
+			rdev->wiphy.txq_limit = txq_limit;
+		if (changed & WIPHY_PARAM_TXQ_MEMORY_LIMIT)
+			rdev->wiphy.txq_memory_limit = txq_memory_limit;
+		if (changed & WIPHY_PARAM_TXQ_QUANTUM)
+			rdev->wiphy.txq_quantum = txq_quantum;
 
 		result = rdev_set_wiphy_params(rdev, changed);
 		if (result) {
@@ -2537,6 +2634,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.frag_threshold = old_frag_threshold;
 			rdev->wiphy.rts_threshold = old_rts_threshold;
 			rdev->wiphy.coverage_class = old_coverage_class;
+			rdev->wiphy.txq_limit = old_txq_limit;
+			rdev->wiphy.txq_memory_limit = old_txq_memory_limit;
+			rdev->wiphy.txq_quantum = old_txq_quantum;
 			return result;
 		}
 	}
@@ -2658,6 +2758,16 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	}
 	wdev_unlock(wdev);
 
+	if (rdev->ops->get_txq_stats) {
+		struct cfg80211_txq_stats txqstats = {};
+		int ret = rdev_get_txq_stats(rdev, wdev, &txqstats);
+
+		if (ret == 0 &&
+			!nl80211_put_txq_stats(msg, &txqstats,
+					NL80211_ATTR_TXQ_STATS))
+			goto nla_put_failure;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -4525,6 +4635,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 			PUT_TIDVAL_U64(TX_MSDU_FAILED, tx_msdu_failed);
 
 #undef PUT_TIDVAL_U64
+			if ((tidstats->filled & BIT(NL80211_TID_STATS_TXQ_STATS)) &&
+				!nl80211_put_txq_stats(msg, &tidstats->txq_stats,
+						NL80211_TID_STATS_TXQ_STATS))
+				goto nla_put_failure;
+
 			nla_nest_end(msg, tidattr);
 		}
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 84f23ae015fc..37b6858437bd 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -586,6 +586,18 @@ rdev_set_multicast_to_unicast(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_get_txq_stats(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *wdev,
+		   struct cfg80211_txq_stats *txqstats)
+{
+	int ret;
+	trace_rdev_get_txq_stats(&rdev->wiphy, wdev);
+	ret = rdev->ops->get_txq_stats(&rdev->wiphy, wdev, txqstats);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
 {
 	trace_rdev_rfkill_poll(&rdev->wiphy);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5152938b358d..89140feb3f1b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3196,6 +3196,20 @@ TRACE_EVENT(rdev_set_multicast_to_unicast,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG,
 		  BOOL_TO_STR(__entry->enabled))
 );
+
+TRACE_EVENT(rdev_get_txq_stats,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.16.1
