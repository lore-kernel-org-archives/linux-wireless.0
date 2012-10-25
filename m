Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935930Ab2JYRG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 13:06:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 2/2] mac80211: add explicit AP/GO driver operations
Date: Thu, 25 Oct 2012 19:07:01 +0200
Message-Id: <1351184821-23315-3-git-send-email-johannes@sipsolutions.net> (sfid-20121025_190634_711190_3D8DC80A)
In-Reply-To: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net>
References: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the driver, a lot of setup may be
necessary to start operating as an AP, some of
which may fail. Add an explicit AP start driver
method to make such failures easier to handle,
and add an AP stop driver method for symmetry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |   10 ++++++++++
 net/mac80211/cfg.c        |   11 +++++++++++
 net/mac80211/driver-ops.h |   25 +++++++++++++++++++++++++
 net/mac80211/pm.c         |    4 ++++
 net/mac80211/trace.h      |   37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c       |    6 +++++-
 6 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9318c66..dfa589b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2386,6 +2386,13 @@ enum ieee80211_rate_control_changed {
  *	to vif. Possible use is for hw queue remapping.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
+ * @start_ap: Start operation on the AP interface, this is called after all the
+ *	information in bss_conf is set and beacon can be retrieved. A channel
+ *	context is bound before this is called. Note that if the driver uses
+ *	software scan or ROC, this (and @stop_ap) isn't called when the AP is
+ *	just "paused" for scanning/ROC, which is indicated by the beacon being
+ *	disabled/enabled via @bss_info_changed.
+ * @stop_ap: Stop operation on the AP interface.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2411,6 +2418,9 @@ struct ieee80211_ops {
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
 
+	int (*start_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aeb18d7..d38d31f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -922,6 +922,15 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 	changed |= err;
 
+	err = drv_start_ap(sdata->local, sdata);
+	if (err) {
+		old = rtnl_dereference(sdata->u.ap.beacon);
+		if (old)
+			kfree_rcu(old, rcu_head);
+		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		return err;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(dev);
@@ -978,6 +987,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	sta_info_flush(local, sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	drv_stop_ap(sdata->local, sdata);
+
 	/* free all potentially still buffered bcast frames */
 	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 77407b3..1701ad7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -936,4 +936,29 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_start_ap(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata)
+{
+	int ret = 0;
+
+	check_sdata_in_driver(sdata);
+
+	trace_drv_start_ap(local, sdata, &sdata->vif.bss_conf);
+	if (local->ops->start_ap)
+		ret = local->ops->start_ap(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void drv_stop_ap(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata)
+{
+	check_sdata_in_driver(sdata);
+
+	trace_drv_stop_ap(local, sdata);
+	if (local->ops->stop_ap)
+		local->ops->stop_ap(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 9f404ac..0f1c434 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -135,6 +135,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		ieee80211_bss_info_change_notify(sdata,
 			BSS_CHANGED_BEACON_ENABLED);
 
+		if (sdata->vif.type == NL80211_IFTYPE_AP &&
+		    rcu_access_pointer(sdata->u.ap.beacon))
+			drv_stop_ap(local, sdata);
+
 		/* the interface is leaving the channel and is removed */
 		ieee80211_vif_release_channel(sdata);
 		drv_remove_interface(local, sdata);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index cba4b12..eeebbd9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1398,6 +1398,43 @@ DEFINE_EVENT(local_sdata_chanctx, drv_unassign_vif_chanctx,
 	TP_ARGS(local, sdata, ctx)
 );
 
+TRACE_EVENT(drv_start_ap,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_bss_conf *info),
+
+	TP_ARGS(local, sdata, info),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, dtimper)
+		__field(u16, bcnint)
+		__dynamic_array(u8, ssid, info->ssid_len);
+		__field(bool, hidden_ssid);
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->dtimper = info->dtim_period;
+		__entry->bcnint = info->beacon_int;
+		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
+		__entry->hidden_ssid = info->hidden_ssid;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
+DEFINE_EVENT(local_sdata_evt, drv_stop_ap,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 690a17d..fc82f7e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1475,9 +1475,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID;
 
-			if (sdata->vif.type == NL80211_IFTYPE_AP)
+			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
 
+				if (rcu_access_pointer(sdata->u.ap.beacon))
+					drv_start_ap(local, sdata);
+			}
+
 			/* fall through */
 		case NL80211_IFTYPE_MESH_POINT:
 			changed |= BSS_CHANGED_BEACON |
-- 
1.7.10.4

