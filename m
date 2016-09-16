Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754368AbcIPIdg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 04:33:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 11:33:14 +0300
Message-Id: <20160916083321.5840-3-luca@coelho.fi> (sfid-20160916_103404_840383_E691707D)
In-Reply-To: <20160916083321.5840-1-luca@coelho.fi>
References: <20160916083321.5840-1-luca@coelho.fi>
Subject: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop NAN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

This code doesn't do much besides allowing to start and
stop the vif.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  9 +++++++++
 net/mac80211/cfg.c        | 36 ++++++++++++++++++++++++++++++++++
 net/mac80211/chan.c       |  3 +++
 net/mac80211/driver-ops.h | 29 ++++++++++++++++++++++++++-
 net/mac80211/iface.c      |  8 ++++++--
 net/mac80211/main.c       |  5 +++++
 net/mac80211/offchannel.c |  3 ++-
 net/mac80211/trace.h      | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c       |  3 ++-
 9 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5296100..df9b5cf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3420,6 +3420,9 @@ enum ieee80211_reconfig_type {
  *	synchronization which is needed in case driver has in its RSS queues
  *	pending frames that were received prior to the control path action
  *	currently taken (e.g. disassociation) but are not processed yet.
+ *
+ * @start_nan: join an existing NAN cluster, or create a new one.
+ * @stop_nan: leave the NAN cluster.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3655,6 +3658,12 @@ struct ieee80211_ops {
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
 	void (*sync_rx_queues)(struct ieee80211_hw *hw);
+
+	int (*start_nan)(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct cfg80211_nan_conf *conf);
+	int (*stop_nan)(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a74027f..9aabb09 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
+ * Copyright (C) 2015-2016 Intel Deutschland GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -152,6 +153,39 @@ static void ieee80211_stop_p2p_device(struct wiphy *wiphy,
 	ieee80211_sdata_stop(IEEE80211_WDEV_TO_SUB_IF(wdev));
 }
 
+static int ieee80211_start_nan(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       struct cfg80211_nan_conf *conf)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	int ret;
+
+	mutex_lock(&sdata->local->chanctx_mtx);
+	ret = ieee80211_check_combinations(sdata, NULL, 0, 0);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+	if (ret < 0)
+		return ret;
+
+	ret = ieee80211_do_open(wdev, true);
+	if (ret)
+		return ret;
+
+	ret = drv_start_nan(sdata->local, sdata, conf);
+	if (ret)
+		ieee80211_sdata_stop(sdata);
+
+	return ret;
+}
+
+static void ieee80211_stop_nan(struct wiphy *wiphy,
+			       struct wireless_dev *wdev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	drv_stop_nan(sdata->local, sdata);
+	ieee80211_sdata_stop(sdata);
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3464,4 +3498,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.start_nan = ieee80211_start_nan,
+	.stop_nan = ieee80211_stop_nan,
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index acb50f8..e4d147e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -647,6 +647,9 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *curr_ctx = NULL;
 	int ret = 0;
 
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_NAN))
+		return -ENOTSUPP;
+
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fe35a1c..67b42c8 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -163,7 +163,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
 			 (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-			  !sdata->vif.mu_mimo_owner)))
+			  !sdata->vif.mu_mimo_owner) ||
+			 sdata->vif.type == NL80211_IFTYPE_NAN))
 		return;
 
 	if (!check_sdata_in_driver(sdata))
@@ -1165,4 +1166,30 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int drv_start_nan(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct cfg80211_nan_conf *conf)
+{
+	int ret;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_start_nan(local, sdata, conf);
+	ret = local->ops->start_nan(&local->hw, &sdata->vif, conf);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void drv_stop_nan(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_stop_nan(local, sdata);
+	local->ops->stop_nan(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e694ca2..507f46a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -327,6 +327,9 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 	int n_queues = sdata->local->hw.queues;
 	int i;
 
+	if (iftype == NL80211_IFTYPE_NAN)
+		return 0;
+
 	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
@@ -647,7 +650,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			local->fif_probe_req++;
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
+		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+		    sdata->vif.type != NL80211_IFTYPE_NAN)
 			changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
@@ -1726,7 +1730,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	ASSERT_RTNL();
 
-	if (type == NL80211_IFTYPE_P2P_DEVICE) {
+	if (type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN) {
 		struct wireless_dev *wdev;
 
 		sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ac053a9..b5cf2c5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -821,6 +821,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     !local->ops->tdls_recv_channel_switch))
 		return -EOPNOTSUPP;
 
+	if (WARN_ON(local->hw.wiphy->interface_modes &
+			BIT(NL80211_IFTYPE_NAN) &&
+		    (!local->ops->start_nan || !local->ops->stop_nan)))
+		return -EINVAL;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 75d5c96..c3f610b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -128,7 +128,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
+		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
+		    sdata->vif.type == NL80211_IFTYPE_NAN)
 			continue;
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 77e4c53..deefbfb 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1700,6 +1700,56 @@ TRACE_EVENT(drv_get_expected_throughput,
 	)
 );
 
+TRACE_EVENT(drv_start_nan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_nan_conf *conf),
+
+	TP_ARGS(local, sdata, conf),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, master_pref)
+		__field(u8, dual)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->master_pref = conf->master_pref;
+		__entry->dual = conf->dual;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", master preference: %u, dual: %d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->master_pref,
+		__entry->dual
+	)
+);
+
+TRACE_EVENT(drv_stop_nan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata),
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
+		LOCAL_PR_FMT  VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2c78541..5b57fca 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1209,7 +1209,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_NAN) {
 		sdata->vif.bss_conf.qos = enable_qos;
 		if (bss_notify)
 			ieee80211_bss_info_change_notify(sdata,
-- 
2.9.3
