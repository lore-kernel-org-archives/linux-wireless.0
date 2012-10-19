Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030359Ab2JSNqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:46:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: ilan.peer@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: add explicit AP/GO driver operations
Date: Fri, 19 Oct 2012 15:47:21 +0200
Message-Id: <1350654441-6761-1-git-send-email-johannes@sipsolutions.net> (sfid-20121019_154652_603802_3665631A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on the driver, a lot of setup may be
necessary to start operating as an AP, some of
which may fail. To make it easier to handle,
add explicit AP start/stop operations.

...

This would make the code in iwlwifi a lot simpler
as having bss_info_change do everything depending
on whether the beacon was enabled/disabled etc.
is tricky to get right, the explicit operations
make it easier.

Any objections to this approach? We can also think
about extending it to other modes of operation?

I still need to do the code for suspend/resume,
of course.
---
 include/net/mac80211.h    |    7 +++++++
 net/mac80211/cfg.c        |   12 ++++++++++++
 net/mac80211/driver-ops.h |   25 +++++++++++++++++++++++++
 net/mac80211/trace.h      |   12 ++++++++++++
 4 files changed, 56 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71c2f9c..f52a5f1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2381,6 +2381,10 @@ enum ieee80211_rate_control_changed {
  *	to vif. Possible use is for hw queue remapping.
  * @unassign_vif_chanctx: Notifies device driver about channel context being
  *	unbound from vif.
+ * @start_ap: Start operation on the AP interface, this is called after all the
+ *	information in bss_conf is set and beacon can be retrieved.  A channel
+ *	context is bound before this is called.
+ * @stop_ap: Stop operation on the AP interface.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2406,6 +2410,9 @@ struct ieee80211_ops {
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
 
+	int (*start_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5eab132..1785f21 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -924,6 +924,15 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	err = drv_start_ap(sdata->local, sdata);
+	if (err) {
+		old = rtnl_dereference(sdata->u.ap.beacon);
+		if (old)
+			kfree_rcu(old, rcu_head);
+		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		return err;
+	}
+
 	netif_carrier_on(dev);
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_on(vlan->dev);
@@ -971,6 +980,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	kfree_rcu(old, rcu_head);
 
 	sta_info_flush(sdata->local, sdata);
+
+	drv_stop_ap(sdata->local, sdata);
+
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	ieee80211_vif_release_channel(sdata);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 77407b3..ba3c911 100644
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
+	trace_drv_start_ap(local, sdata);
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
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6293647..1400e45 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1368,6 +1368,18 @@ DEFINE_EVENT(local_sdata_chanctx, drv_unassign_vif_chanctx,
 	TP_ARGS(local, sdata, ctx)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_start_ap,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
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
-- 
1.7.10.4

