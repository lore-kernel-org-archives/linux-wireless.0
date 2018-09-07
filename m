Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:38587 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbeIHDF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 23:05:59 -0400
Subject: [PATCH RFC v3 3/4] cfg80211: Add airtime statistics and settings
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Sat, 08 Sep 2018 00:22:51 +0200
Message-ID: <153635897088.14170.10601367738164730253.stgit@alrua-x1> (sfid-20180908_002305_769585_4A855C77)
In-Reply-To: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime statistics to the cfg80211 station dump, and also adds a new
parameter to set the airtime weight of each station. The latter allows userspace
to implement policies for different stations by varying their weights.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/cfg80211.h       |   12 ++++++++++--
 include/uapi/linux/nl80211.h |   11 +++++++++++
 net/mac80211/cfg.c           |    3 +++
 net/mac80211/sta_info.c      |   15 +++++++++++++++
 net/mac80211/sta_info.h      |    3 ---
 net/wireless/nl80211.c       |   25 +++++++++++++++++++++++++
 6 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f3ed79c39d7..6fa4a97eefee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -990,6 +990,7 @@ enum station_parameters_apply_mask {
  * @support_p2p_ps: information if station supports P2P PS mechanism
  * @he_capa: HE capabilities of station
  * @he_capa_len: the length of the HE capabilities
+ * @airtime_weight: airtime scheduler weight for this station
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -1019,6 +1020,7 @@ struct station_parameters {
 	int support_p2p_ps;
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
+	u16 airtime_weight;
 };
 
 /**
@@ -1286,6 +1288,8 @@ struct cfg80211_tid_stats {
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  *	Note that this doesn't use the @filled bit, but is used if non-NULL.
@@ -1332,10 +1336,12 @@ struct station_info {
 
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
@@ -2349,7 +2355,7 @@ enum cfg80211_connect_params_changed {
  * @WIPHY_PARAM_DYN_ACK: dynack has been enabled
  * @WIPHY_PARAM_TXQ_LIMIT: TXQ packet limit has been changed
  * @WIPHY_PARAM_TXQ_MEMORY_LIMIT: TXQ memory limit has been changed
- * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum
+ * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum (bytes)
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -2363,6 +2369,8 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_TXQ_QUANTUM		= 1 << 8,
 };
 
+#define IEEE80211_DEFAULT_AIRTIME_WEIGHT	256
+
 /**
  * struct cfg80211_pmksa - PMK Security Association
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6b2b61646b6a..009c2e7b762f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2241,6 +2241,9 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
+ *      scheduler.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2685,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_AIRTIME_WEIGHT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3051,6 +3056,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
  * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of ACK frames (s8, dBm)
+ * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
+ *	sent to the station (u64, usec)
+ * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station
+ *      (u16, usec)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3091,6 +3100,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_PAD,
 	NL80211_STA_INFO_ACK_SIGNAL,
 	NL80211_STA_INFO_ACK_SIGNAL_AVG,
+	NL80211_STA_INFO_TX_DURATION,
+	NL80211_STA_INFO_AIRTIME_WEIGHT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 504627e2117f..8bd7c917a7b5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1388,6 +1388,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta_apply_mesh_params(local, sta, params);
 
+	if (params->airtime_weight)
+		sta->airtime.weight = params->airtime_weight;
+
 	/* set the STA state after all sta info from usermode has been set */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) ||
 	    set & BIT(NL80211_STA_FLAG_ASSOCIATED)) {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aba13f88bc86..b09d4f164797 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2220,6 +2220,21 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
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
index 97fff032eee5..d8210ebf0cdd 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -127,9 +127,6 @@ enum ieee80211_agg_stop_reason {
 	AGG_STOP_DESTROY_STA,
 };
 
-/* How much to increase airtime deficit on each scheduling round, by default
- * (userspace can change this per phy) */
-#define IEEE80211_DEFAULT_AIRTIME_WEIGHT        256
 /* Debugfs flags to enable/disable use of RX/TX airtime in scheduler */
 #define AIRTIME_USE_TX		BIT(0)
 #define AIRTIME_USE_RX		BIT(1)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d5f9b5235cdd..4402d6f0ba03 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -430,6 +430,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+
+	[NL80211_ATTR_AIRTIME_WEIGHT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -4656,6 +4658,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
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
@@ -5293,6 +5300,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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
@@ -5431,6 +5449,13 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
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
