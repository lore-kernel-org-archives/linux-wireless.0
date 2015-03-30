Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbbC3OO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:14:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 2/5] mac80211: add boilerplate code for start / stop NAN
Date: Mon, 30 Mar 2015 17:14:17 +0300
Message-Id: <1427724860-1992-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_161434_762973_8A94291C)
In-Reply-To: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This codes doens't do much besides allowing to start and
stop the vif.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/cfg.c        | 35 ++++++++++++++++++++++++++++++++++
 net/mac80211/chan.c       |  3 +++
 net/mac80211/driver-ops.h | 29 +++++++++++++++++++++++++++-
 net/mac80211/iface.c      |  8 ++++++--
 net/mac80211/main.c       |  4 ++++
 net/mac80211/offchannel.c |  3 ++-
 net/mac80211/trace.h      | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c       |  3 ++-
 9 files changed, 134 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cfbee18..8cd030f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3053,6 +3053,8 @@ enum ieee80211_reconfig_type {
  *	response template is provided, together with the location of the
  *	switch-timing IE within the template. The skb can only be used within
  *	the function call.
+ * @start_nan: join an existing nan cluster, or create a new one.
+ * @stop_nan: leave the nan cluster.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3285,6 +3287,10 @@ struct ieee80211_ops {
 	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 struct ieee80211_tdls_ch_sw_params *params);
+	int (*start_nan)(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u8 master_pref);
+	int (*stop_nan)(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b37092f..c95488d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -129,6 +129,39 @@ static void ieee80211_stop_p2p_device(struct wiphy *wiphy,
 	ieee80211_sdata_stop(IEEE80211_WDEV_TO_SUB_IF(wdev));
 }
 
+static int ieee80211_start_nan(struct wiphy *wiphy,
+			       struct wireless_dev *wdev,
+			       u8 master_pref)
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
+	ret = drv_start_nan(sdata->local, sdata, master_pref);
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
@@ -3854,4 +3887,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.start_nan = ieee80211_start_nan,
+	.stop_nan = ieee80211_stop_nan,
 };
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 794ccc6..29da2d5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -622,6 +622,9 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *curr_ctx = NULL;
 	int ret = 0;
 
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_NAN))
+		return 0;
+
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ab720f2..d58458f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -219,7 +219,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 		return;
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
-			 sdata->vif.type == NL80211_IFTYPE_MONITOR))
+			 sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+			 sdata->vif.type == NL80211_IFTYPE_NAN))
 		return;
 
 	if (!check_sdata_in_driver(sdata))
@@ -1366,4 +1367,30 @@ drv_tdls_recv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_start_nan(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				u8 master_pref)
+{
+	int ret;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_start_nan(local, sdata, master_pref);
+	ret = local->ops->start_nan(&local->hw, &sdata->vif, master_pref);
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
index e033af0..ac7c119 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -324,6 +324,9 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 	int n_queues = sdata->local->hw.queues;
 	int i;
 
+	if (iftype == NL80211_IFTYPE_NAN)
+		return 0;
+
 	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
@@ -635,7 +638,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			local->fif_probe_req++;
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
+		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+		    sdata->vif.type != NL80211_IFTYPE_NAN)
 			changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
@@ -1683,7 +1687,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	ASSERT_RTNL();
 
-	if (type == NL80211_IFTYPE_P2P_DEVICE) {
+	if (type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN) {
 		struct wireless_dev *wdev;
 
 		sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 35c0ad6..1763646 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -821,6 +821,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     !local->ops->tdls_recv_channel_switch))
 		return -EOPNOTSUPP;
 
+	if (WARN_ON(local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN) &&
+		    (!local->ops->start_nan || !local->ops->stop_nan)))
+		return -EINVAL;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 683f0e3..4f17b1e 100644
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
index 838bd92..a97ac97 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1656,6 +1656,54 @@ TRACE_EVENT(drv_get_expected_throughput,
 	)
 );
 
+TRACE_EVENT(drv_start_nan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u8 master_pref),
+
+	TP_ARGS(local, sdata, master_pref),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, master_pref)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->master_pref = master_pref;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", master_pref: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG,
+		__entry->master_pref
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
index 11d515f..c3726c4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1235,7 +1235,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_NAN) {
 		sdata->vif.bss_conf.qos = enable_qos;
 		if (bss_notify)
 			ieee80211_bss_info_change_notify(sdata,
-- 
1.9.1

