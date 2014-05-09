Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51354 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaEIJH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 05:07:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: handle failed restart/resume better
Date: Fri,  9 May 2014 11:07:48 +0200
Message-Id: <1399626468-27066-1-git-send-email-johannes@sipsolutions.net> (sfid-20140509_110803_216043_3C4E18F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver fails during HW restart or resume, the whole
stack goes into a very confused state with interfaces being
up while the hardware is down etc.

Address this by shutting down everything; we'll run into a
lot of warnings in the process but that's better than having
the whole stack get messed up.

Reviewed-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |  14 ++++++
 net/mac80211/driver-ops.h  | 108 +++++++++++++++++++++++++++++----------------
 net/mac80211/ieee80211_i.h |   1 +
 net/mac80211/scan.c        |  15 ++++---
 net/mac80211/util.c        |  46 +++++++++++++++++--
 net/wireless/core.c        |  20 ++++++---
 6 files changed, 153 insertions(+), 51 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 28f6f1a5b445..5c7169b0ac57 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4771,6 +4771,20 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 gfp_t gfp);
 
+/**
+ * cfg80211_shutdown_all_interfaces - shut down all interfaces for a wiphy
+ * @wiphy: the wiphy to shut down
+ *
+ * This function shuts down all interfaces belonging to this wiphy by
+ * calling dev_close() (and treating non-netdev interfaces as needed).
+ * It shouldn't really be used unless there are some fatal device errors
+ * that really can't be recovered in any other way.
+ *
+ * Callers must hold the RTNL and be able to deal with callbacks into
+ * the driver while the function is running.
+ */
+void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5331582a2c81..df1d50291344 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -5,11 +5,11 @@
 #include "ieee80211_i.h"
 #include "trace.h"
 
-static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
+static inline bool check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 {
-	WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
-	     "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
-	     sdata->dev ? sdata->dev->name : sdata->name, sdata->flags);
+	return !WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
+		     "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
+		     sdata->dev ? sdata->dev->name : sdata->name, sdata->flags);
 }
 
 static inline struct ieee80211_sub_if_data *
@@ -168,7 +168,8 @@ static inline int drv_change_interface(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_change_interface(local, sdata, type, p2p);
 	ret = local->ops->change_interface(&local->hw, &sdata->vif, type, p2p);
@@ -181,7 +182,8 @@ static inline void drv_remove_interface(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_remove_interface(local, sdata);
 	local->ops->remove_interface(&local->hw, &sdata->vif);
@@ -219,7 +221,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 			 sdata->vif.type == NL80211_IFTYPE_MONITOR))
 		return;
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_bss_info_changed(local, sdata, info, changed);
 	if (local->ops->bss_info_changed)
@@ -278,7 +281,8 @@ static inline int drv_set_key(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_set_key(local, cmd, sdata, sta, key);
 	ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
@@ -298,7 +302,8 @@ static inline void drv_update_tkip_key(struct ieee80211_local *local,
 		ista = &sta->sta;
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
 	if (local->ops->update_tkip_key)
@@ -315,7 +320,8 @@ static inline int drv_hw_scan(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_hw_scan(local, sdata);
 	ret = local->ops->hw_scan(&local->hw, &sdata->vif, req);
@@ -328,7 +334,8 @@ static inline void drv_cancel_hw_scan(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_cancel_hw_scan(local, sdata);
 	local->ops->cancel_hw_scan(&local->hw, &sdata->vif);
@@ -345,7 +352,8 @@ drv_sched_scan_start(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_sched_scan_start(local, sdata);
 	ret = local->ops->sched_scan_start(&local->hw, &sdata->vif,
@@ -361,7 +369,8 @@ static inline int drv_sched_scan_stop(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_sched_scan_stop(local, sdata);
 	ret = local->ops->sched_scan_stop(&local->hw, &sdata->vif);
@@ -462,7 +471,8 @@ static inline void drv_sta_notify(struct ieee80211_local *local,
 				  struct ieee80211_sta *sta)
 {
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_sta_notify(local, sdata, cmd, sta);
 	if (local->ops->sta_notify)
@@ -479,7 +489,8 @@ static inline int drv_sta_add(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_sta_add(local, sdata, sta);
 	if (local->ops->sta_add)
@@ -497,7 +508,8 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_sta_remove(local, sdata, sta);
 	if (local->ops->sta_remove)
@@ -515,7 +527,8 @@ static inline void drv_sta_add_debugfs(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	if (local->ops->sta_add_debugfs)
 		local->ops->sta_add_debugfs(&local->hw, &sdata->vif,
@@ -545,7 +558,8 @@ static inline void drv_sta_pre_rcu_remove(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_sta_pre_rcu_remove(local, sdata, &sta->sta);
 	if (local->ops->sta_pre_rcu_remove)
@@ -566,7 +580,8 @@ int drv_sta_state(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_sta_state(local, sdata, &sta->sta, old_state, new_state);
 	if (local->ops->sta_state) {
@@ -590,7 +605,8 @@ static inline void drv_sta_rc_update(struct ieee80211_local *local,
 				     struct ieee80211_sta *sta, u32 changed)
 {
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	WARN_ON(changed & IEEE80211_RC_SUPP_RATES_CHANGED &&
 		(sdata->vif.type != NL80211_IFTYPE_ADHOC &&
@@ -612,7 +628,8 @@ static inline int drv_conf_tx(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_conf_tx(local, sdata, ac, params);
 	if (local->ops->conf_tx)
@@ -629,7 +646,8 @@ static inline u64 drv_get_tsf(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return ret;
 
 	trace_drv_get_tsf(local, sdata);
 	if (local->ops->get_tsf)
@@ -644,7 +662,8 @@ static inline void drv_set_tsf(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_set_tsf(local, sdata, tsf);
 	if (local->ops->set_tsf)
@@ -657,7 +676,8 @@ static inline void drv_reset_tsf(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_reset_tsf(local, sdata);
 	if (local->ops->reset_tsf)
@@ -689,7 +709,8 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 	might_sleep();
 
 	sdata = get_bss_sdata(sdata);
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
 
@@ -733,8 +754,8 @@ static inline void drv_flush(struct ieee80211_local *local,
 
 	might_sleep();
 
-	if (sdata)
-		check_sdata_in_driver(sdata);
+	if (sdata && !check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_flush(local, queues, drop);
 	if (local->ops->flush)
@@ -854,7 +875,8 @@ static inline int drv_set_bitrate_mask(struct ieee80211_local *local,
 
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_set_bitrate_mask(local, sdata, mask);
 	if (local->ops->set_bitrate_mask)
@@ -869,7 +891,8 @@ static inline void drv_set_rekey_data(struct ieee80211_local *local,
 				      struct ieee80211_sub_if_data *sdata,
 				      struct cfg80211_gtk_rekey_data *data)
 {
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_set_rekey_data(local, sdata, data);
 	if (local->ops->set_rekey_data)
@@ -937,7 +960,8 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
 {
 	might_sleep();
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 	WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
 
 	trace_drv_mgd_prepare_tx(local, sdata);
@@ -964,6 +988,9 @@ static inline int drv_add_chanctx(struct ieee80211_local *local,
 static inline void drv_remove_chanctx(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx)
 {
+	if (WARN_ON(!ctx->driver_present))
+		return;
+
 	trace_drv_remove_chanctx(local, ctx);
 	if (local->ops->remove_chanctx)
 		local->ops->remove_chanctx(&local->hw, &ctx->conf);
@@ -989,7 +1016,8 @@ static inline int drv_assign_vif_chanctx(struct ieee80211_local *local,
 {
 	int ret = 0;
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_assign_vif_chanctx(local, sdata, ctx);
 	if (local->ops->assign_vif_chanctx) {
@@ -1007,7 +1035,8 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 					    struct ieee80211_sub_if_data *sdata,
 					    struct ieee80211_chanctx *ctx)
 {
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_unassign_vif_chanctx(local, sdata, ctx);
 	if (local->ops->unassign_vif_chanctx) {
@@ -1024,7 +1053,8 @@ static inline int drv_start_ap(struct ieee80211_local *local,
 {
 	int ret = 0;
 
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_start_ap(local, sdata, &sdata->vif.bss_conf);
 	if (local->ops->start_ap)
@@ -1036,7 +1066,8 @@ static inline int drv_start_ap(struct ieee80211_local *local,
 static inline void drv_stop_ap(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_stop_ap(local, sdata);
 	if (local->ops->stop_ap)
@@ -1059,7 +1090,8 @@ drv_set_default_unicast_key(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    int key_idx)
 {
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	WARN_ON_ONCE(key_idx < -1 || key_idx > 3);
 
@@ -1101,7 +1133,8 @@ static inline int drv_join_ibss(struct ieee80211_local *local,
 	int ret = 0;
 
 	might_sleep();
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
 
 	trace_drv_join_ibss(local, sdata, &sdata->vif.bss_conf);
 	if (local->ops->join_ibss)
@@ -1114,7 +1147,8 @@ static inline void drv_leave_ibss(struct ieee80211_local *local,
 				  struct ieee80211_sub_if_data *sdata)
 {
 	might_sleep();
-	check_sdata_in_driver(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
 
 	trace_drv_leave_ibss(local, sdata);
 	if (local->ops->leave_ibss)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f4ba0c4a4314..4668ce9a1d3f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1459,6 +1459,7 @@ __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req);
 int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sched_scan_end(struct ieee80211_local *local);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 28185c8dc19a..f40661eb75b5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1076,12 +1076,8 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_results);
 
-void ieee80211_sched_scan_stopped_work(struct work_struct *work)
+void ieee80211_sched_scan_end(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
-			     sched_scan_stopped_work);
-
 	mutex_lock(&local->mtx);
 
 	if (!rcu_access_pointer(local->sched_scan_sdata)) {
@@ -1099,6 +1095,15 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 	cfg80211_sched_scan_stopped(local->hw.wiphy);
 }
 
+void ieee80211_sched_scan_stopped_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     sched_scan_stopped_work);
+
+	ieee80211_sched_scan_end(local);
+}
+
 void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ad058759e85e..7e0dd4be8097 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1457,6 +1457,44 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	drv_stop(local);
 }
 
+static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_chanctx *ctx;
+
+	/*
+	 * We get here if during resume the device can't be restarted properly.
+	 * We might also get here if this happens during HW reset, which is a
+	 * slightly different situation and we need to drop all connections in
+	 * the latter case.
+	 *
+	 * Ask cfg80211 to turn off all interfaces, this will result in more
+	 * warnings but at least we'll then get into a clean stopped state.
+	 */
+
+	local->resuming = false;
+	local->suspended = false;
+	local->started = false;
+
+	/* scheduled scan clearly can't be running any more, but tell
+	 * cfg80211 and clear local state
+	 */
+	ieee80211_sched_scan_end(local);
+
+	list_for_each_entry(sdata, &local->interfaces, list)
+		sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
+
+	/* Mark channel contexts as not being in the driver any more to avoid
+	 * removing them from the driver during the shutdown process...
+	 */
+	mutex_lock(&local->chanctx_mtx);
+	list_for_each_entry(ctx, &local->chanctx_list, list)
+		ctx->driver_present = false;
+	mutex_unlock(&local->chanctx_mtx);
+
+	cfg80211_shutdown_all_interfaces(local->hw.wiphy);
+}
+
 static void ieee80211_assign_chanctx(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata)
 {
@@ -1520,9 +1558,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 */
 	res = drv_start(local);
 	if (res) {
-		WARN(local->suspended, "Hardware became unavailable "
-		     "upon resume. This could be a software issue "
-		     "prior to suspend or a hardware issue.\n");
+		if (local->suspended)
+			WARN(1, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
+		else
+			WARN(1, "Hardware became unavailable during restart.\n");
+		ieee80211_handle_reconfig_failure(local);
 		return res;
 	}
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7e023b74f009..c95fddf3fb52 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -210,15 +210,12 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	}
 }
 
-static int cfg80211_rfkill_set_block(void *data, bool blocked)
+void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = data;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct wireless_dev *wdev;
 
-	if (!blocked)
-		return 0;
-
-	rtnl_lock();
+	ASSERT_RTNL();
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (wdev->netdev) {
@@ -234,7 +231,18 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 			break;
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(cfg80211_shutdown_all_interfaces);
 
+static int cfg80211_rfkill_set_block(void *data, bool blocked)
+{
+	struct cfg80211_registered_device *rdev = data;
+
+	if (!blocked)
+		return 0;
+
+	rtnl_lock();
+	cfg80211_shutdown_all_interfaces(&rdev->wiphy);
 	rtnl_unlock();
 
 	return 0;
-- 
2.0.0.rc0

