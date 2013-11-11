Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50625 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3KKSOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 13:14:10 -0500
Received: by mail-ea0-f181.google.com with SMTP id q10so519275ead.40
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 10:14:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: add min required channel definition field
Date: Mon, 11 Nov 2013 20:14:01 +0200
Message-Id: <1384193641-25813-2-git-send-email-egrumbach@gmail.com> (sfid-20131111_191416_105146_7519DD3F)
In-Reply-To: <1384193641-25813-1-git-send-email-egrumbach@gmail.com>
References: <1384193641-25813-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add a new field to ieee80211_chanctx_conf to indicate
the min required channel configuration.

Tuning to a narrower channel might help reducing
the noise level and saving some power.

The min required channel definition is the max of
all min required channel definitions of the interfaces
bound to this channel context.

In AP mode, use 20MHz when there are no connected station.
When a new station is added/removed, calculate the new max
bandwidth supported by any of the stations (e.g. 80MHz when
80MHz and 40MHz stations are connected).

In other cases, simply use bss_conf.chandef as the
min required chandef.

Notify drivers about changes to this field by calling
drv_change_chanctx with a new CHANGE_MIN_WIDTH notification.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     |    4 ++
 net/mac80211/chan.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +
 net/mac80211/sta_info.c    |    2 +
 net/mac80211/trace.h       |   21 ++++++-
 net/mac80211/util.c        |   20 +++++++
 6 files changed, 187 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ceed99..f6012c4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -154,12 +154,14 @@ struct ieee80211_low_level_stats {
  * @IEEE80211_CHANCTX_CHANGE_RADAR: radar detection flag changed
  * @IEEE80211_CHANCTX_CHANGE_CHANNEL: switched to another operating channel,
  *	this is used only with channel switching with CSA
+ * @IEEE80211_CHANCTX_CHANGE_MIN_WIDTH: The min required channel width changed
  */
 enum ieee80211_chanctx_change {
 	IEEE80211_CHANCTX_CHANGE_WIDTH		= BIT(0),
 	IEEE80211_CHANCTX_CHANGE_RX_CHAINS	= BIT(1),
 	IEEE80211_CHANCTX_CHANGE_RADAR		= BIT(2),
 	IEEE80211_CHANCTX_CHANGE_CHANNEL	= BIT(3),
+	IEEE80211_CHANCTX_CHANGE_MIN_WIDTH	= BIT(4),
 };
 
 /**
@@ -169,6 +171,7 @@ enum ieee80211_chanctx_change {
  * that contains it is visible in mac80211 only.
  *
  * @def: the channel definition
+ * @min_def: the minimum channel definition currently required.
  * @rx_chains_static: The number of RX chains that must always be
  *	active on the channel to receive MIMO transmissions
  * @rx_chains_dynamic: The number of RX chains that must be enabled
@@ -180,6 +183,7 @@ enum ieee80211_chanctx_change {
  */
 struct ieee80211_chanctx_conf {
 	struct cfg80211_chan_def def;
+	struct cfg80211_chan_def min_def;
 
 	u8 rx_chains_static, rx_chains_dynamic;
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 03ba6b5..d9d1181 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -9,6 +9,140 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
+static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
+{
+	switch (sta->bandwidth) {
+	case IEEE80211_STA_RX_BW_20:
+		if (sta->ht_cap.ht_supported)
+			return NL80211_CHAN_WIDTH_20;
+		else
+			return NL80211_CHAN_WIDTH_20_NOHT;
+	case IEEE80211_STA_RX_BW_40:
+		return NL80211_CHAN_WIDTH_40;
+	case IEEE80211_STA_RX_BW_80:
+		return NL80211_CHAN_WIDTH_80;
+	case IEEE80211_STA_RX_BW_160:
+		/*
+		 * This applied for both 160 and 80+80. since we use
+		 * the returned value to consider degradation of
+		 * ctx->conf.min_def, we have to make sure to take
+		 * the bigger one (NL80211_CHAN_WIDTH_160).
+		 * Otherwise we might try degrading even when not
+		 * needed, as the max required sta_bw returned (80+80)
+		 * might be smaller than the configured bw (160).
+		 */
+		return NL80211_CHAN_WIDTH_160;
+	default:
+		WARN_ON(1);
+		return NL80211_CHAN_WIDTH_20;
+	}
+}
+
+static enum nl80211_chan_width
+ieee80211_get_max_required_bw(struct ieee80211_sub_if_data *sdata)
+{
+	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (sdata != sta->sdata &&
+		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
+			continue;
+
+		if (!sta->uploaded)
+			continue;
+
+		max_bw = max(max_bw, ieee80211_get_sta_bw(&sta->sta));
+	}
+	rcu_read_unlock();
+
+	return max_bw;
+}
+
+static enum nl80211_chan_width
+ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
+				      struct ieee80211_chanctx_conf *conf)
+{
+	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		struct ieee80211_vif *vif = &sdata->vif;
+		enum nl80211_chan_width width = NL80211_CHAN_WIDTH_20_NOHT;
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
+			continue;
+
+		switch (vif->type) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_AP_VLAN:
+			width = ieee80211_get_max_required_bw(sdata);
+			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			continue;
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			width = vif->bss_conf.chandef.width;
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NUM_NL80211_IFTYPES:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			WARN_ON_ONCE(1);
+		}
+		max_bw = max(max_bw, width);
+	}
+	rcu_read_unlock();
+
+	return max_bw;
+}
+
+/*
+ * recalc the min required chan width of the channel context, which is
+ * the max of min required widths of all the interfaces bound to this
+ * channel context.
+ */
+void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx)
+{
+	enum nl80211_chan_width max_bw;
+	struct cfg80211_chan_def min_def;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	/* don't optimize 5MHz, 10MHz, and radar_enabled confs */
+	if (ctx->conf.def.width == NL80211_CHAN_WIDTH_5 ||
+	    ctx->conf.def.width == NL80211_CHAN_WIDTH_10 ||
+	    ctx->conf.radar_enabled) {
+		ctx->conf.min_def = ctx->conf.def;
+		return;
+	}
+
+	max_bw = ieee80211_get_chanctx_max_required_bw(local, &ctx->conf);
+
+	/* downgrade chandef up to max_bw */
+	min_def = ctx->conf.def;
+	while (min_def.width > max_bw)
+		ieee80211_chandef_downgrade(&min_def);
+
+	if (cfg80211_chandef_identical(&ctx->conf.min_def, &min_def))
+		return;
+
+	ctx->conf.min_def = min_def;
+	if (!ctx->driver_present)
+		return;
+
+	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_MIN_WIDTH);
+}
+
 static void ieee80211_change_chanctx(struct ieee80211_local *local,
 				     struct ieee80211_chanctx *ctx,
 				     const struct cfg80211_chan_def *chandef)
@@ -20,6 +154,7 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 
 	ctx->conf.def = *chandef;
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = *chandef;
@@ -93,6 +228,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
 	if (!local->use_chanctx)
 		local->hw.conf.radar_enabled = ctx->conf.radar_enabled;
 
@@ -179,6 +315,7 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount++;
 
 	ieee80211_recalc_txpower(sdata);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
 	sdata->vif.bss_conf.idle = false;
 
 	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
@@ -243,6 +380,7 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
 		ieee80211_recalc_smps_chanctx(local, ctx);
 		ieee80211_recalc_radar_chanctx(local, ctx);
+		ieee80211_recalc_chanctx_min_def(local, ctx);
 	}
 }
 
@@ -456,6 +594,7 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_chanctx_chantype(local, ctx);
 	ieee80211_recalc_smps_chanctx(local, ctx);
 	ieee80211_recalc_radar_chanctx(local, ctx);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	ret = 0;
  out:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..ca0fe3d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1692,6 +1692,7 @@ int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
 int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 				enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
+void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
@@ -1741,6 +1742,8 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
 void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 				    struct ieee80211_chanctx *chanctx);
+void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx);
 
 void ieee80211_dfs_cac_timer(unsigned long data);
 void ieee80211_dfs_cac_timer_work(struct work_struct *work);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1eb66e2..c2b188e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -507,6 +507,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
 	set_sta_flag(sta, WLAN_STA_INSERTED);
 
+	ieee80211_recalc_min_chandef(sdata);
 	ieee80211_sta_debugfs_add(sta);
 	rate_control_add_sta_debugfs(sta);
 
@@ -869,6 +870,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
+	ieee80211_recalc_min_chandef(sdata);
 
 	call_rcu(&sta->rcu_head, free_sta_rcu);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 5d62c58..8db5601 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -41,14 +41,31 @@
 #define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,			\
 			__entry->center_freq1, __entry->center_freq2
 
+#define MIN_CHANDEF_ENTRY								\
+			__field(u32, min_control_freq)					\
+			__field(u32, min_chan_width)					\
+			__field(u32, min_center_freq1)					\
+			__field(u32, min_center_freq2)
+
+#define MIN_CHANDEF_ASSIGN(c)								\
+			__entry->min_control_freq = (c)->chan ? (c)->chan->center_freq : 0;	\
+			__entry->min_chan_width = (c)->width;				\
+			__entry->min_center_freq1 = (c)->center_freq1;			\
+			__entry->min_center_freq2 = (c)->center_freq2;
+#define MIN_CHANDEF_PR_FMT	" min_control:%d MHz min_width:%d min_center: %d/%d MHz"
+#define MIN_CHANDEF_PR_ARG	__entry->min_control_freq, __entry->min_chan_width,	\
+			__entry->min_center_freq1, __entry->min_center_freq2
+
 #define CHANCTX_ENTRY	CHANDEF_ENTRY							\
+			MIN_CHANDEF_ENTRY						\
 			__field(u8, rx_chains_static)					\
 			__field(u8, rx_chains_dynamic)
 #define CHANCTX_ASSIGN	CHANDEF_ASSIGN(&ctx->conf.def)					\
+			MIN_CHANDEF_ASSIGN(&ctx->conf.min_def)				\
 			__entry->rx_chains_static = ctx->conf.rx_chains_static;		\
 			__entry->rx_chains_dynamic = ctx->conf.rx_chains_dynamic
-#define CHANCTX_PR_FMT	CHANDEF_PR_FMT " chains:%d/%d"
-#define CHANCTX_PR_ARG	CHANDEF_PR_ARG,							\
+#define CHANCTX_PR_FMT	CHANDEF_PR_FMT MIN_CHANDEF_PR_FMT " chains:%d/%d"
+#define CHANCTX_PR_ARG	CHANDEF_PR_ARG,	MIN_CHANDEF_PR_ARG,				\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 592a181..76a10a7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1804,6 +1804,26 @@ void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
+void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+
+	mutex_lock(&local->chanctx_mtx);
+
+	chanctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					lockdep_is_held(&local->chanctx_mtx));
+
+	if (WARN_ON_ONCE(!chanctx_conf))
+		goto unlock;
+
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	ieee80211_recalc_chanctx_min_def(local, chanctx);
+ unlock:
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
 {
 	int i;
-- 
1.7.9.5

