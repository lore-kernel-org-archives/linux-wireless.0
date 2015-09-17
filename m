Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbbIQOdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:39 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 6/7] mac80211: Implement add_nan_func and rm_nan_func
Date: Thu, 17 Sep 2015 17:32:30 +0300
Message-Id: <1442500351-8780-7-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163346_516419_213AD51A)
In-Reply-To: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
References: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add a trivial implementation for  add/rm_nan_func functions.
Currently mac80211 just passes the configuration to the driver.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 include/net/mac80211.h    | 17 ++++++++++++++-
 net/mac80211/cfg.c        | 30 +++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 31 +++++++++++++++++++++++++++
 net/mac80211/trace.h      | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c4d8f4a..ebe0921 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3250,7 +3250,12 @@ enum ieee80211_reconfig_type {
  *
  * @start_nan: join an existing nan cluster, or create a new one.
  * @stop_nan: leave the nan cluster.
- */
+ * @add_nan_func: Add a nan function. Returns a stricly positive instance id
+ *	upon success. The data in cfg80211_nan_func must not be referenced
+ *	outside the scope of this call.
+ * @rm_nan_func: Remove a nan function.
+ * @nan_change_conf: changes NAN configuration.
+  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
 		   struct ieee80211_tx_control *control,
@@ -3495,6 +3500,16 @@ struct ieee80211_ops {
 			 struct cfg80211_nan_conf *conf);
 	int (*stop_nan)(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif);
+	int	(*add_nan_func)(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				const struct cfg80211_nan_func *nan_func);
+	void	(*rm_nan_func)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       u8 instance_id);
+	int	(*nan_change_conf)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct cfg80211_nan_conf *conf,
+				   u32 changes);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e36d542..8a504ae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -163,6 +163,34 @@ static void ieee80211_stop_nan(struct wiphy *wiphy,
 	ieee80211_sdata_stop(sdata);
 }
 
+static int ieee80211_add_nan_func(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  const struct cfg80211_nan_func *nan_func)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	return drv_add_nan_func(sdata->local, sdata, nan_func);
+}
+
+static void ieee80211_rm_nan_func(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  u8 instance_id)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN ||
+	    !ieee80211_sdata_running(sdata))
+		return;
+
+	drv_rm_nan_func(sdata->local, sdata, instance_id);
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3942,4 +3970,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.del_tx_ts = ieee80211_del_tx_ts,
 	.start_nan = ieee80211_start_nan,
 	.stop_nan = ieee80211_stop_nan,
+	.add_nan_func = ieee80211_add_nan_func,
+	.rm_nan_func = ieee80211_rm_nan_func,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2ef2997..0d6c622 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1399,4 +1399,35 @@ static inline void drv_stop_nan(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_add_nan_func(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   const struct cfg80211_nan_func *nan_func)
+{
+	int ret;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	if (!local->ops->add_nan_func)
+		return -EOPNOTSUPP;
+
+	trace_drv_add_nan_func(local, sdata, nan_func);
+	ret = local->ops->add_nan_func(&local->hw, &sdata->vif, nan_func);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_rm_nan_func(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   u8 instance_id)
+{
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_rm_nan_func(local, sdata, instance_id);
+	if (local->ops->rm_nan_func)
+		local->ops->rm_nan_func(&local->hw, &sdata->vif, instance_id);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a98c864..ca79e83 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1739,6 +1739,59 @@ TRACE_EVENT(drv_stop_nan,
 	)
 );
 
+/* TODO: record more fields */
+TRACE_EVENT(drv_add_nan_func,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const struct cfg80211_nan_func *func),
+
+	TP_ARGS(local, sdata, func),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->type = func->type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", type: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->type
+	)
+);
+
+
+TRACE_EVENT(drv_rm_nan_func,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u8 instance_id),
+
+	TP_ARGS(local, sdata, instance_id),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, instance_id)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->instance_id = instance_id;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", instance_id: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->instance_id
+	)
+);
+
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.8.3

