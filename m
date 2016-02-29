Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbcB2NZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/12] mac80211: add boilerplate code for start / stop NAN
Date: Mon, 29 Feb 2016 15:25:03 +0200
Message-Id: <1456752313-5792-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142528_788681_FA1B4E35)
In-Reply-To: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This codes doens't do much besides allowing to start and
stop the vif.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    |  9 +++++++++
 net/mac80211/cfg.c        | 35 +++++++++++++++++++++++++++++++++
 net/mac80211/chan.c       |  3 +++
 net/mac80211/driver-ops.h | 29 ++++++++++++++++++++++++++-
 net/mac80211/iface.c      |  8 ++++++--
 net/mac80211/main.c       |  5 +++++
 net/mac80211/offchannel.c |  3 ++-
 net/mac80211/trace.h      | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c       |  3 ++-
 9 files changed, 140 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0c09da3..157e342 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3348,6 +3348,9 @@ enum ieee80211_reconfig_type {
  *	the function call.
  *
  * @wake_tx_queue: Called when new packets have been added to the queue.
+ *
+ * @start_nan: join an existing nan cluster, or create a new one.
+ * @stop_nan: leave the nan cluster.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3585,6 +3588,12 @@ struct ieee80211_ops {
 
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
+
+	int (*start_nan)(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct cfg80211_nan_conf *conf);
+	int (*stop_nan)(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9b4b962..460ef76 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -129,6 +129,39 @@ static void ieee80211_stop_p2p_device(struct wiphy *wiphy,
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
@@ -3438,4 +3471,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.start_nan = ieee80211_start_nan,
+	.stop_nan = ieee80211_stop_nan,
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e5c1922..b07bdbf 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -645,6 +645,9 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *curr_ctx = NULL;
 	int ret = 0;
 
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_NAN))
+		return -ENOTSUPP;
+
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 18b0d65..c4fe13f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -147,7 +147,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 		return;
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
-			 sdata->vif.type == NL80211_IFTYPE_MONITOR))
+			 sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+			 sdata->vif.type == NL80211_IFTYPE_NAN))
 		return;
 
 	if (!check_sdata_in_driver(sdata))
@@ -1164,4 +1165,30 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
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
index d13f780..7887ed7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -325,6 +325,9 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 	int n_queues = sdata->local->hw.queues;
 	int i;
 
+	if (iftype == NL80211_IFTYPE_NAN)
+		return 0;
+
 	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
@@ -642,7 +645,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			local->fif_probe_req++;
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
+		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+		    sdata->vif.type != NL80211_IFTYPE_NAN)
 			changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
@@ -1716,7 +1720,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	ASSERT_RTNL();
 
-	if (type == NL80211_IFTYPE_P2P_DEVICE) {
+	if (type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN) {
 		struct wireless_dev *wdev;
 
 		sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6bcf0fa..a004eb2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -810,6 +810,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
index 0355cad..9a43507 100644
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
index 2b0a17e..121d7fe 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1688,6 +1688,56 @@ TRACE_EVENT(drv_get_expected_throughput,
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
index 99cf13d..c67df60 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1208,7 +1208,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_NAN) {
 		sdata->vif.bss_conf.qos = enable_qos;
 		if (bss_notify)
 			ieee80211_bss_info_change_notify(sdata,
-- 
2.5.0

