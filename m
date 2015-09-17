Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbIQOdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:42 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 7/7] mac80211: implement nan_change_conf
Date: Thu, 17 Sep 2015 17:32:31 +0300
Message-Id: <1442500351-8780-8-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163351_590963_45C28667)
In-Reply-To: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
References: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add a trivial implementation for nan_change_conf by simply passing
everything directly to the driver.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 net/mac80211/cfg.c        | 18 ++++++++++++++++++
 net/mac80211/driver-ops.h | 21 +++++++++++++++++++++
 net/mac80211/trace.h      | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8a504ae..d2726f1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -191,6 +191,23 @@ static void ieee80211_rm_nan_func(struct wiphy *wiphy,
 	drv_rm_nan_func(sdata->local, sdata, instance_id);
 }
 
+static int ieee80211_nan_change_conf(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     struct cfg80211_nan_conf *conf,
+				     u32 changes)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	return drv_nan_change_conf(sdata->local, sdata, conf, changes);
+}
+
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3972,4 +3989,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.stop_nan = ieee80211_stop_nan,
 	.add_nan_func = ieee80211_add_nan_func,
 	.rm_nan_func = ieee80211_rm_nan_func,
+	.nan_change_conf = ieee80211_nan_change_conf,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0d6c622..8d5349c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1430,4 +1430,25 @@ static inline void drv_rm_nan_func(struct ieee80211_local *local,
 		local->ops->rm_nan_func(&local->hw, &sdata->vif, instance_id);
 	trace_drv_return_void(local);
 }
+
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
+	if (!local->ops->add_nan_func)
+		return -EOPNOTSUPP;
+
+	trace_drv_nan_change_conf(local, sdata, conf, changes);
+	ret = local->ops->nan_change_conf(&local->hw, &sdata->vif, conf, changes);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ca79e83..7871d99 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1791,6 +1791,38 @@ TRACE_EVENT(drv_rm_nan_func,
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
+		__field(u16, cluster_id)
+		__field(u8, dual)
+		__field(u32, changes)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->cluster_id = conf->cluster_id;
+		__entry->dual = conf->dual;
+		__entry->changes = changes;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", master preference: %u, cluster_id: %04x, dual: %d, changes: 0x%x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->master_pref,
+		 __entry->cluster_id, __entry->dual, __entry->changes
+	)
+);
 
 /*
  * Tracing for API calls that drivers call.
-- 
1.8.3

