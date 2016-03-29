Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4114 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbcC2JfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 05:35:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCHv3 RESEND 08/11] mac80211: implement nan_change_conf
Date: Tue, 29 Mar 2016 12:35:06 +0300
Message-Id: <1459244109-16038-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160329_113534_135464_87657035)
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Implement nan_change_conf callback which allows to change current
nan configuration (master preference and dual band operation).
Store the current nan configuration in sdata, so it can be used
both to provide the driver the updated configuration with changes
and also it will be used in hw reconfig flows in next patches.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     |  6 ++++++
 net/mac80211/cfg.c         | 33 +++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  | 21 +++++++++++++++++++++
 net/mac80211/ieee80211_i.h | 10 ++++++++++
 net/mac80211/trace.h       | 31 +++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12860de..011f979 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3361,6 +3361,9 @@ enum ieee80211_reconfig_type {
  *
  * @start_nan: join an existing nan cluster, or create a new one.
  * @stop_nan: leave the nan cluster.
+ * @nan_change_conf: change nan configuration. The data in cfg80211_nan_conf
+ *	contains full new configuration and changes specify which parameters
+ *	are changed with respect to the last nan config.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3605,6 +3608,9 @@ struct ieee80211_ops {
 			 struct cfg80211_nan_conf *conf);
 	int (*stop_nan)(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif);
+	int (*nan_change_conf)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_nan_conf *conf, u8 changes);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9d66b4..9215232 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -150,6 +150,8 @@ static int ieee80211_start_nan(struct wiphy *wiphy,
 	if (ret)
 		ieee80211_sdata_stop(sdata);
 
+	memcpy(&sdata->u.nan.nan_conf, conf, sizeof(sdata->u.nan.nan_conf));
+
 	return ret;
 }
 
@@ -162,6 +164,36 @@ static void ieee80211_stop_nan(struct wiphy *wiphy,
 	ieee80211_sdata_stop(sdata);
 }
 
+static int ieee80211_nan_change_conf(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     struct cfg80211_nan_conf *conf,
+				     u32 changes)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct cfg80211_nan_conf new_conf;
+	int ret = 0;
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	memcpy(&new_conf, &sdata->u.nan.nan_conf, sizeof(new_conf));
+	if (changes & CFG80211_NAN_CONF_CHANGED_PREF)
+		new_conf.master_pref = conf->master_pref;
+
+	if (changes & CFG80211_NAN_CONF_CHANGED_DUAL)
+		new_conf.dual = conf->dual;
+
+	ret = drv_nan_change_conf(sdata->local, sdata, &new_conf, changes);
+	if (!ret)
+		memcpy(&sdata->u.nan.nan_conf, &new_conf,
+		       sizeof(sdata->u.nan.nan_conf));
+
+	return ret;
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3473,4 +3505,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.del_tx_ts = ieee80211_del_tx_ts,
 	.start_nan = ieee80211_start_nan,
 	.stop_nan = ieee80211_stop_nan,
+	.nan_change_conf = ieee80211_nan_change_conf,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3352ce2..3c84fbd 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1206,4 +1206,25 @@ static inline void drv_stop_nan(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_nan_change_conf(struct ieee80211_local *local,
+				       struct ieee80211_sub_if_data *sdata,
+				       struct cfg80211_nan_conf *conf,
+				       u32 changes)
+{
+	int ret;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	if (!local->ops->nan_change_conf)
+		return -EOPNOTSUPP;
+
+	trace_drv_nan_change_conf(local, sdata, conf, changes);
+	ret = local->ops->nan_change_conf(&local->hw, &sdata->vif, conf,
+					  changes);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c6830fb..f985ed2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -813,6 +813,15 @@ struct txq_info {
 	struct ieee80211_txq txq;
 };
 
+/**
+ * struct ieee80211_if_nan - NAN state
+ *
+ * @nan_conf: current nan configuration
+ */
+struct ieee80211_if_nan {
+	struct cfg80211_nan_conf nan_conf;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -912,6 +921,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_mesh mesh;
 		struct ieee80211_if_ocb ocb;
 		u32 mntr_flags;
+		struct ieee80211_if_nan nan;
 	} u;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 9b23627..4f17ad1 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1750,6 +1750,37 @@ TRACE_EVENT(drv_stop_nan,
 	)
 );
 
+TRACE_EVENT(drv_nan_change_conf,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_nan_conf *conf,
+		 u32 changes),
+
+	TP_ARGS(local, sdata, conf, changes),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, master_pref)
+		__field(u8, dual)
+		__field(u32, changes)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->dual = conf->dual;
+		__entry->changes = changes;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", master preference: %u, dual: %d, changes: 0x%x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->master_pref,
+		__entry->dual, __entry->changes
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
2.5.0

