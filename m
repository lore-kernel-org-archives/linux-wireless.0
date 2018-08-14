Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36446 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731429AbeHNMx4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 08:53:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 2/2] mac80211: support FTM responder setup/statistics
Date: Tue, 14 Aug 2018 12:06:23 +0200
Message-Id: <20180814100623.28976-2-johannes@sipsolutions.net> (sfid-20180814_120730_056716_605316A1)
In-Reply-To: <20180814100623.28976-1-johannes@sipsolutions.net>
References: <20180814100623.28976-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Plumb the new cfg80211 API for FTM responders through to
the driver API in mac80211.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  9 +++++++++
 net/mac80211/cfg.c        | 23 +++++++++++++++++++++++
 net/mac80211/driver-ops.h | 32 ++++++++++++++++++++++++++++++++
 net/mac80211/trace.h      | 29 +++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..096f51c9e131 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3542,6 +3542,9 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @start_ftm_responder: configure and start FTM responder activity on an AP
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3824,6 +3827,12 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*start_ftm_responder)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct cfg80211_ftm_responder_params *params);
+	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d25da0e66da1..349cf866c0e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3808,6 +3808,27 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_start_ftm_responder(struct wiphy *wiphy,
+					 struct net_device *dev,
+			       struct cfg80211_ftm_responder_params *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return drv_start_ftm_responder(local, sdata, params);
+}
+
+static int
+ieee80211_get_ftm_responder_stats(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3902,4 +3923,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
+	.start_ftm_responder = ieee80211_start_ftm_responder,
+	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 8f6998091d26..d4022e67341b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1173,6 +1173,22 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int
+drv_get_ftm_responder_stats(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	u32 ret = -EOPNOTSUPP;
+
+	if (local->ops->get_ftm_responder_stats)
+		ret = local->ops->get_ftm_responder_stats(&local->hw,
+							 &sdata->vif,
+							 ftm_stats);
+	trace_drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+
+	return ret;
+}
+
 static inline int drv_start_nan(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				struct cfg80211_nan_conf *conf)
@@ -1252,4 +1268,20 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_start_ftm_responder(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata,
+			struct cfg80211_ftm_responder_params *params)
+{
+	u32 ret = -EOPNOTSUPP;
+
+	trace_drv_start_ftm_responder(local, sdata);
+	if (local->ops->start_ftm_responder)
+		ret = local->ops->start_ftm_responder(&local->hw, &sdata->vif,
+						      params);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0ab69a1964f8..ed91b7afcd31 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2600,6 +2600,35 @@ TRACE_EVENT(drv_wake_tx_queue,
 	)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_start_ftm_responder,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
+TRACE_EVENT(drv_get_ftm_responder_stats,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_ftm_responder_stats *ftm_stats),
+
+	TP_ARGS(local, sdata, ftm_stats),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.14.4
