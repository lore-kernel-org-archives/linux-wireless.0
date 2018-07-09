Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:55299 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932928AbeGIQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 12:37:09 -0400
Subject: [RFC v2 3/4] cfg80211: Add airtime statistics and settings
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Mon, 09 Jul 2018 18:37:05 +0200
Message-ID: <153115422508.7447.11019058031741145222.stgit@alrua-x1> (sfid-20180709_183716_758954_77A16261)
In-Reply-To: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime statistics to the cfg80211 station dump, and also adds
a new parameter to set the airtime weight of each station. The latter
allows userspace to implement policies for different stations by varying
their weights.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/cfg80211.h       |   15 +++++++++++--
 include/uapi/linux/nl80211.h |   14 ++++++++++++
 net/mac80211/cfg.c           |    6 +++++
 net/mac80211/main.c          |    2 +-
 net/mac80211/sta_info.c      |   15 +++++++++++++
 net/mac80211/sta_info.h      |    4 ---
 net/wireless/core.c          |    2 ++
 net/wireless/nl80211.c       |   50 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9ba1f289c439..1480eccbffe9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -988,6 +988,7 @@ enum station_parameters_apply_mask {
  * @support_p2p_ps: information if station supports P2P PS mechanism
  * @he_capa: HE capabilities of station
  * @he_capa_len: the length of the HE capabilities
+ * @airtime_weight: airtime scheduler weight for this station
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -1017,6 +1018,7 @@ struct station_parameters {
 	int support_p2p_ps;
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
+	u16 airtime_weight;
 };
 
 /**
@@ -1284,6 +1286,8 @@ struct cfg80211_tid_stats {
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  *	Note that this doesn't use the @filled bit, but is used if non-NULL.
@@ -1330,10 +1334,12 @@ struct station_info {
 
 	u32 expected_throughput;
 
-	u64 rx_beacon;
+	u64 tx_duration;
 	u64 rx_duration;
+	u64 rx_beacon;
 	u8 rx_beacon_signal_avg;
 	struct cfg80211_tid_stats *pertid;
+	u16 airtime_weight;
 	s8 ack_signal;
 	s8 avg_ack_signal;
 };
@@ -2347,7 +2353,8 @@ enum cfg80211_connect_params_changed {
  * @WIPHY_PARAM_DYN_ACK: dynack has been enabled
  * @WIPHY_PARAM_TXQ_LIMIT: TXQ packet limit has been changed
  * @WIPHY_PARAM_TXQ_MEMORY_LIMIT: TXQ memory limit has been changed
- * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum
+ * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum (bytes)
+ * @WIPHY_PARAM_AIRTIME_QUANTUM: Airtime scheduler quantum (usec)
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -2359,8 +2366,11 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_TXQ_LIMIT		= 1 << 6,
 	WIPHY_PARAM_TXQ_MEMORY_LIMIT	= 1 << 7,
 	WIPHY_PARAM_TXQ_QUANTUM		= 1 << 8,
+	WIPHY_PARAM_AIRTIME_QUANTUM	= 1 << 9,
 };
 
+#define IEEE80211_DEFAULT_AIRTIME_QUANTUM	300 /* usec */
+
 /**
  * struct cfg80211_pmksa - PMK Security Association
  *
@@ -4104,6 +4114,7 @@ struct wiphy {
 	u32 txq_limit;
 	u32 txq_memory_limit;
 	u32 txq_quantum;
+	u16 airtime_quantum;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 28550d01948f..c3ac69640475 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2241,6 +2241,11 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
+ *      scheduler.
+ * @NL80211_ATTR_AIRTIME_QUANTUM: Airtime scheduler quantum (usec). Airtime
+ *      share given to each station on each round of the airtime scheduler.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2687,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_AIRTIME_WEIGHT,
+	NL80211_ATTR_AIRTIME_QUANTUM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3052,6 +3060,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG: avg signal strength of (data)
  *	ACK frame (s8, dBm)
+ * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
+ *	sent to the station (u64, usec)
+ * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station
+ *      (u16, usec)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3092,6 +3104,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_PAD,
 	NL80211_STA_INFO_ACK_SIGNAL,
 	NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG,
+	NL80211_STA_INFO_TX_DURATION,
+	NL80211_STA_INFO_AIRTIME_WEIGHT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 02f3672e7b5e..5467e17fb0b2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1431,6 +1431,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta_apply_mesh_params(local, sta, params);
 
+	if (params->airtime_weight)
+		sta->airtime.weight = params->airtime_weight;
+
 	/* set the STA state after all sta info from usermode has been set */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) ||
 	    set & BIT(NL80211_STA_FLAG_ASSOCIATED)) {
@@ -2386,6 +2389,9 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		       WIPHY_PARAM_TXQ_QUANTUM))
 		ieee80211_txq_set_params(local);
 
+	if (changed & WIPHY_PARAM_AIRTIME_QUANTUM)
+		local->airtime_quantum = wiphy->airtime_quantum;
+
 	return 0;
 }
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e597b22ce403..e65c2abb2a54 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -637,7 +637,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	INIT_LIST_HEAD(&local->active_txqs);
 	spin_lock_init(&local->active_txq_lock);
 	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
-	local->airtime_quantum = IEEE80211_AIRTIME_QUANTUM;
+	local->airtime_quantum = IEEE80211_DEFAULT_AIRTIME_QUANTUM;
 
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4e1e2628fe7d..f88f02df9e3a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2210,6 +2210,21 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_DURATION))) {
+		sinfo->rx_duration = sta->airtime.rx_airtime;
+		sinfo->filled |= BIT(NL80211_STA_INFO_RX_DURATION);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_DURATION))) {
+		sinfo->tx_duration = sta->airtime.tx_airtime;
+		sinfo->filled |= BIT(NL80211_STA_INFO_TX_DURATION);
+	}
+
+	if (!(sinfo->filled & BIT(NL80211_STA_INFO_AIRTIME_WEIGHT))) {
+		sinfo->airtime_weight = sta->airtime.weight;
+		sinfo->filled |= BIT(NL80211_STA_INFO_AIRTIME_WEIGHT);
+	}
+
 	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
 	if (sta->pcpu_rx_stats) {
 		for_each_possible_cpu(cpu) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d87a6c31dcb6..d8210ebf0cdd 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -127,10 +127,6 @@ enum ieee80211_agg_stop_reason {
 	AGG_STOP_DESTROY_STA,
 };
 
-/* How much to increase airtime deficit on each scheduling round, by default
- * (userspace can change this per phy)
- */
-#define IEEE80211_AIRTIME_QUANTUM        300 /* usec */
 /* Debugfs flags to enable/disable use of RX/TX airtime in scheduler */
 #define AIRTIME_USE_TX		BIT(0)
 #define AIRTIME_USE_RX		BIT(1)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a88551f3bc43..6896cb6a3dd2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -524,6 +524,8 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	rdev->wiphy.max_sched_scan_plans = 1;
 	rdev->wiphy.max_sched_scan_plan_interval = U32_MAX;
 
+	rdev->wiphy.airtime_quantum = IEEE80211_DEFAULT_AIRTIME_QUANTUM;
+
 	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new_nm);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8db59129c095..293bc183ae91 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -428,8 +428,12 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
+
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+
+	[NL80211_ATTR_AIRTIME_WEIGHT] = { .type = NLA_U16 },
+	[NL80211_ATTR_AIRTIME_QUANTUM] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -2088,6 +2092,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				goto nla_put_failure;
 		}
 
+		if (wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)
+		    && nla_put_u16(msg, NL80211_ATTR_AIRTIME_QUANTUM,
+			           rdev->wiphy.airtime_quantum))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -2466,6 +2476,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u32 frag_threshold = 0, rts_threshold = 0;
 	u8 coverage_class = 0;
 	u32 txq_limit = 0, txq_memory_limit = 0, txq_quantum = 0;
+	u16 airtime_quantum = 0;
 
 	ASSERT_RTNL();
 
@@ -2699,11 +2710,23 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		changed |= WIPHY_PARAM_TXQ_QUANTUM;
 	}
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_QUANTUM]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+			return -EOPNOTSUPP;
+		airtime_quantum = nla_get_u16(
+			info->attrs[NL80211_ATTR_AIRTIME_QUANTUM]);
+		if (!airtime_quantum)
+			return -EINVAL;
+		changed |= WIPHY_PARAM_AIRTIME_QUANTUM;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
 		u8 old_coverage_class;
 		u32 old_txq_limit, old_txq_memory_limit, old_txq_quantum;
+		u16 old_airtime_quantum;
 
 		if (!rdev->ops->set_wiphy_params)
 			return -EOPNOTSUPP;
@@ -2716,6 +2739,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		old_txq_limit = rdev->wiphy.txq_limit;
 		old_txq_memory_limit = rdev->wiphy.txq_memory_limit;
 		old_txq_quantum = rdev->wiphy.txq_quantum;
+		old_airtime_quantum = rdev->wiphy.airtime_quantum;
 
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
 			rdev->wiphy.retry_short = retry_short;
@@ -2733,6 +2757,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.txq_memory_limit = txq_memory_limit;
 		if (changed & WIPHY_PARAM_TXQ_QUANTUM)
 			rdev->wiphy.txq_quantum = txq_quantum;
+		if (changed & WIPHY_PARAM_AIRTIME_QUANTUM)
+			rdev->wiphy.airtime_quantum = airtime_quantum;
 
 		result = rdev_set_wiphy_params(rdev, changed);
 		if (result) {
@@ -2744,6 +2770,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.txq_limit = old_txq_limit;
 			rdev->wiphy.txq_memory_limit = old_txq_memory_limit;
 			rdev->wiphy.txq_quantum = old_txq_quantum;
+			rdev->wiphy.airtime_quantum = old_airtime_quantum;
 			return result;
 		}
 	}
@@ -4652,6 +4679,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(PLID, plid, u16);
 	PUT_SINFO(PLINK_STATE, plink_state, u8);
 	PUT_SINFO_U64(RX_DURATION, rx_duration);
+	PUT_SINFO_U64(TX_DURATION, tx_duration);
+
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		PUT_SINFO(AIRTIME_WEIGHT, airtime_weight, u16);
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
@@ -5288,6 +5320,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
 	}
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+			return -EOPNOTSUPP;
+
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -5426,6 +5469,13 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
