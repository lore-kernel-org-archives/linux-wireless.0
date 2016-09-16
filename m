Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55088 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756351AbcIPIdl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 04:33:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 11:33:19 +0300
Message-Id: <20160916083321.5840-8-luca@coelho.fi> (sfid-20160916_103405_352489_9FC365D3)
In-Reply-To: <20160916083321.5840-1-luca@coelho.fi>
References: <20160916083321.5840-1-luca@coelho.fi>
Subject: [PATCH v2 7/9] mac80211: implement nan_change_conf
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Implement nan_change_conf callback which allows to change current
NAN configuration (master preference and dual band operation).
Store the current NAN configuration in sdata, so it can be used
both to provide the driver the updated configuration with changes
and also it will be used in hw reconfig flows in next patches.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h     |  9 +++++++++
 net/mac80211/cfg.c         | 31 +++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  | 21 +++++++++++++++++++++
 net/mac80211/ieee80211_i.h | 10 ++++++++++
 net/mac80211/trace.h       | 31 +++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index df9b5cf..ef8d02a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3423,6 +3423,12 @@ enum ieee80211_reconfig_type {
  *
  * @start_nan: join an existing NAN cluster, or create a new one.
  * @stop_nan: leave the NAN cluster.
+ * @nan_change_conf: change NAN configuration. The data in cfg80211_nan_conf
+ *	contains full new configuration and changes specify which parameters
+ *	are changed with respect to the last NAN config.
+ *	The driver gets both full configuration and the changed parameters since
+ *	some devices may need the full configuration while others need only the
+ *	changed parameters.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3664,6 +3670,9 @@ struct ieee80211_ops {
 			 struct cfg80211_nan_conf *conf);
 	int (*stop_nan)(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif);
+	int (*nan_change_conf)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_nan_conf *conf, u32 changes);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9aabb09..38fdb53 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -186,6 +186,36 @@ static void ieee80211_stop_nan(struct wiphy *wiphy,
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
+	new_conf = sdata->u.nan.conf;
+
+	if (changes & CFG80211_NAN_CONF_CHANGED_PREF)
+		new_conf.master_pref = conf->master_pref;
+
+	if (changes & CFG80211_NAN_CONF_CHANGED_DUAL)
+		new_conf.dual = conf->dual;
+
+	ret = drv_nan_change_conf(sdata->local, sdata, &new_conf, changes);
+	if (!ret)
+		sdata->u.nan.conf = new_conf;
+
+	return ret;
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3500,4 +3530,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.del_tx_ts = ieee80211_del_tx_ts,
 	.start_nan = ieee80211_start_nan,
 	.stop_nan = ieee80211_stop_nan,
+	.nan_change_conf = ieee80211_nan_change_conf,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 67b42c8..50aeb3a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1192,4 +1192,25 @@ static inline void drv_stop_nan(struct ieee80211_local *local,
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
index c71c735..712b20b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -830,6 +830,15 @@ struct ieee80211_if_mntr {
 	u8 mu_follow_addr[ETH_ALEN] __aligned(2);
 };
 
+/**
+ * struct ieee80211_if_nan - NAN state
+ *
+ * @conf: current NAN configuration
+ */
+struct ieee80211_if_nan {
+	struct cfg80211_nan_conf conf;
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -929,6 +938,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_mesh mesh;
 		struct ieee80211_if_ocb ocb;
 		struct ieee80211_if_mntr mntr;
+		struct ieee80211_if_nan nan;
 	} u;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index deefbfb..0bafe11 100644
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
2.9.3
