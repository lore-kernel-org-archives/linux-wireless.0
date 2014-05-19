Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:42386 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaESTye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:54:34 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv4 2/3] mac80211: export the expected throughput
Date: Mon, 19 May 2014 21:53:20 +0200
Message-Id: <1400529201-31500-3-git-send-email-antonio@meshcoding.com> (sfid-20140519_215512_422395_1B2AAA2D)
In-Reply-To: <1400529201-31500-1-git-send-email-antonio@meshcoding.com>
References: <1400529201-31500-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Add get_expected_throughput() API to mac80211 so that each
driver can implement its own version based on the RC
algorithm they are using (might be using an HW RC algo).
The API returns a value expressed in Kbps.

Also, add the new get_expected_throughput() member
to the rate_control_ops structure in order to be
able to query the RC algorithm (this patch provides an
implementation of this API for both minstrel and
minstrel_ht).

The related member in the station_info object is now
filled accordingly when dumping a station.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/mac80211.h             |  7 +++++++
 net/mac80211/cfg.c                 | 19 +++++++++++++++++++
 net/mac80211/driver-ops.h          | 13 +++++++++++++
 net/mac80211/rc80211_minstrel.c    | 12 ++++++++++++
 net/mac80211/rc80211_minstrel_ht.c | 17 +++++++++++++++++
 net/mac80211/trace.h               | 32 ++++++++++++++++++++++++++++++++
 6 files changed, 100 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a34f26a..2c78997 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2769,6 +2769,10 @@ enum ieee80211_roc_type {
  *	information in bss_conf is set up and the beacon can be retrieved. A
  *	channel context is bound before this is called.
  * @leave_ibss: Leave the IBSS again.
+ *
+ * @get_expected_throughput: extract the expected throughput towards the
+ *	specified station. The returned value is expressed in Kbps. It returns 0
+ *	if the RC algorithm does not have proper data to provide.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2962,6 +2966,7 @@ struct ieee80211_ops {
 
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
 };
 
 /**
@@ -4535,6 +4540,8 @@ struct rate_control_ops {
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
+
+	u32 (*get_expected_throughput)(void *priv_sta);
 };
 
 static inline int rate_supported(struct ieee80211_sta *sta,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac45304..9e86dd5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -472,8 +472,12 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
 	struct timespec uptime;
 	u64 packets = 0;
+	u32 thr = 0;
 	int i, ac;
 
 	sinfo->generation = sdata->local->sta_generation;
@@ -587,6 +591,21 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+	/* check if the driver has a SW RC implementation */
+	if (ref && ref->ops->get_expected_throughput) {
+		band = ieee80211_get_sdata_band(sta->sdata);
+		sband = sta->local->hw.wiphy->bands[band];
+
+		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
+	} else {
+		thr = drv_get_expected_throughput(local, &sta->sta);
+	}
+
+	if (thr != 0) {
+		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
+		sinfo->expected_throughput = thr;
+	}
 }
 
 static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df1d502..696ef78 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1156,4 +1156,17 @@ static inline void drv_leave_ibss(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
+					      struct ieee80211_sta *sta)
+{
+	u32 ret = 0;
+
+	trace_drv_get_expected_throughput(sta);
+	if (local->ops->get_expected_throughput)
+		ret = local->ops->get_expected_throughput(sta);
+	trace_drv_return_u32(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 26fd94f..1c1469c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -657,6 +657,17 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
+static u32 minstrel_get_expected_throughput(void *priv_sta)
+{
+	struct minstrel_sta_info *mi = priv_sta;
+	int idx = mi->max_tp_rate[0];
+
+	/* convert pkt per sec in kbps (1200 is the average pkt size used for
+	 * computing cur_tp
+	 */
+	return MINSTREL_TRUNC(mi->r[idx].cur_tp) * 1200 * 8 / 1024;
+}
+
 const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
@@ -670,6 +681,7 @@ const struct rate_control_ops mac80211_minstrel = {
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
+	.get_expected_throughput = minstrel_get_expected_throughput,
 };
 
 int __init
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 4e916ad..85c1e74 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1032,6 +1032,22 @@ minstrel_ht_free(void *priv)
 	mac80211_minstrel.free(priv);
 }
 
+static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
+{
+	struct minstrel_ht_sta_priv *msp = priv_sta;
+	struct minstrel_ht_sta *mi = &msp->ht;
+	int i, j;
+
+	if (!msp->is_ht)
+		return mac80211_minstrel.get_expected_throughput(priv_sta);
+
+	i = mi->max_tp_rate / MCS_GROUP_RATES;
+	j = mi->max_tp_rate % MCS_GROUP_RATES;
+
+	/* convert cur_tp from pkt per second in kbps */
+	return mi->groups[i].rates[j].cur_tp * AVG_PKT_SIZE * 8 / 1024;
+}
+
 static const struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
 	.tx_status = minstrel_ht_tx_status,
@@ -1046,6 +1062,7 @@ static const struct rate_control_ops mac80211_minstrel_ht = {
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_ht_remove_sta_debugfs,
 #endif
+	.get_expected_throughput = minstrel_ht_get_expected_throughput,
 };
 
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a0b0aea..942f64b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -184,6 +184,20 @@ TRACE_EVENT(drv_return_bool,
 		  "true" : "false")
 );
 
+TRACE_EVENT(drv_return_u32,
+	TP_PROTO(struct ieee80211_local *local, u32 ret),
+	TP_ARGS(local, ret),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, ret)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+	TP_printk(LOCAL_PR_FMT " - %u", LOCAL_PR_ARG, __entry->ret)
+);
+
 TRACE_EVENT(drv_return_u64,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
 	TP_ARGS(local, ret),
@@ -1499,6 +1513,24 @@ DEFINE_EVENT(local_sdata_evt, drv_leave_ibss,
 	TP_ARGS(local, sdata)
 );
 
+TRACE_EVENT(drv_get_expected_throughput,
+	TP_PROTO(struct ieee80211_sta *sta),
+
+	TP_ARGS(sta),
+
+	TP_STRUCT__entry(
+		STA_ENTRY
+	),
+
+	TP_fast_assign(
+		STA_ASSIGN;
+	),
+
+	TP_printk(
+		STA_PR_FMT, STA_PR_ARG
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.8.5.5

