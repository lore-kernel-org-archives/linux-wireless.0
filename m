Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34572 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754445AbaJHGtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Wed,  8 Oct 2014 09:48:37 +0300
Message-Id: <1412750920-15392-5-git-send-email-luca@coelho.fi> (sfid-20141008_084926_379963_15FA486B)
In-Reply-To: <1412750920-15392-1-git-send-email-luca@coelho.fi>
References: <1412750920-15392-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 4/7] mac80211: add pre_channel_switch driver operation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Some drivers may need to prepare for a channel switch also when it is
initiated from the remote side (eg. station, P2P client).  To make
this possible, add a generic callback that can be called for all
interface types.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/cfg.c        | 11 +++++++++++
 net/mac80211/driver-ops.h | 18 ++++++++++++++++++
 net/mac80211/mlme.c       | 25 +++++++++++++++++--------
 net/mac80211/trace.h      | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ec0a5b0..19e4159 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2832,6 +2832,10 @@ enum ieee80211_roc_type {
  *	transmitted and then call ieee80211_csa_finish().
  *	If the CSA count starts as zero or 1, this function will not be called,
  *	since there won't be any time to beacon before the switch anyway.
+ * @pre_channel_switch: This is an optional callback that is called
+ *	before a channel switch procedure is started (ie. when a STA
+ *	gets a CSA or an userspace initiated channel-switch), allowing
+ *	the driver to prepare for the channel switch.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
@@ -3038,6 +3042,9 @@ struct ieee80211_ops {
 	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct cfg80211_chan_def *chandef);
+	int (*pre_channel_switch)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_channel_switch *ch_switch);
 
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb6a150..2caa7f0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3053,6 +3053,7 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_switch ch_switch;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	int err, changed = 0;
@@ -3088,6 +3089,10 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
+	err = drv_pre_channel_switch(sdata, &ch_switch);
+	if (err)
+		goto out;
+
 	err = ieee80211_vif_reserve_chanctx(sdata, &params->chandef,
 					    chanctx->mode,
 					    params->radar_required);
@@ -3101,6 +3106,12 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
+	ch_switch.timestamp = 0;
+	ch_switch.device_timestamp = 0;
+	ch_switch.block_tx = params->block_tx;
+	ch_switch.chandef = params->chandef;
+	ch_switch.count = params->count;
+
 	err = ieee80211_set_csa_beacon(sdata, params, &changed);
 	if (err) {
 		ieee80211_vif_unreserve_chanctx(sdata);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 196d48c..5522672 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1196,6 +1196,24 @@ drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+static inline int
+drv_pre_channel_switch(struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_channel_switch *ch_switch)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret = 0;
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_pre_channel_switch(local, sdata, ch_switch);
+	if (local->ops->pre_channel_switch)
+		ret = local->ops->pre_channel_switch(&local->hw, &sdata->vif,
+						     ch_switch);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_join_ibss(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cb4d074..c5fa20f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1057,6 +1057,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
+	struct ieee80211_channel_switch ch_switch;
 	int res;
 
 	sdata_assert_lock(sdata);
@@ -1128,6 +1129,22 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	ch_switch.timestamp = timestamp;
+	ch_switch.device_timestamp = device_timestamp;
+	ch_switch.block_tx = csa_ie.mode;
+	ch_switch.chandef = csa_ie.chandef;
+	ch_switch.count = csa_ie.count;
+
+	if (drv_pre_channel_switch(sdata, &ch_switch)) {
+		sdata_info(sdata,
+			   "preparing for channel switch failed, disconnecting\n");
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		mutex_unlock(&local->chanctx_mtx);
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
 	res = ieee80211_vif_reserve_chanctx(sdata, &csa_ie.chandef,
 					    chanctx->mode, false);
 	if (res) {
@@ -1153,14 +1170,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
-		struct ieee80211_channel_switch ch_switch = {
-			.timestamp = timestamp,
-			.device_timestamp = device_timestamp,
-			.block_tx = csa_ie.mode,
-			.chandef = csa_ie.chandef,
-			.count = csa_ie.count,
-		};
-
 		drv_channel_switch(local, &ch_switch);
 		return;
 	}
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 853c440..30476d2 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2108,6 +2108,39 @@ TRACE_EVENT(drv_channel_switch_beacon,
 	)
 );
 
+TRACE_EVENT(drv_pre_channel_switch,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_channel_switch *ch_switch),
+
+	TP_ARGS(local, sdata, ch_switch),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		CHANDEF_ENTRY
+		__field(u64, timestamp)
+		__field(bool, block_tx)
+		__field(u8, count)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		CHANDEF_ASSIGN(&ch_switch->chandef)
+		__entry->timestamp = ch_switch->timestamp;
+		__entry->block_tx = ch_switch->block_tx;
+		__entry->count = ch_switch->count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " prepare channel switch to "
+		CHANDEF_PR_FMT  " count:%d block_tx:%d timestamp:%llu",
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG, __entry->count,
+		__entry->block_tx, __entry->timestamp
+	)
+);
+
 
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
-- 
2.1.1

