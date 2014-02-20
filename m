Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaBTPOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 10:14:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: allow driver to return error from sched_scan_stop
Date: Thu, 20 Feb 2014 16:14:11 +0100
Message-Id: <1392909251-5557-2-git-send-email-johannes@sipsolutions.net> (sfid-20140220_161423_693380_5ACB4780)
In-Reply-To: <1392909251-5557-1-git-send-email-johannes@sipsolutions.net>
References: <1392909251-5557-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to solve races with sched_scan_stop, it is necessary
for the driver to be able to return an error to propagate that
to cfg80211 so it doesn't send an event.

Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 ++++--
 drivers/net/wireless/ti/wlcore/main.c       |  6 ++++--
 include/net/mac80211.h                      |  3 ++-
 net/mac80211/driver-ops.h                   | 12 ++++++++----
 net/mac80211/scan.c                         |  2 +-
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index beaf8140abbf..7492fc0f2766 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1746,14 +1746,16 @@ out:
 	return ret;
 }
 
-static void iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif)
+static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_sched_scan_stop(mvm);
 	mutex_unlock(&mvm->mutex);
+
+	return 0;
 }
 
 static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7aae5b3a0c2c..4175a57ac9f5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3668,8 +3668,8 @@ out:
 	return ret;
 }
 
-static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif)
+static int wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
@@ -3691,6 +3691,8 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 	wl1271_ps_elp_sleep(wl);
 out:
 	mutex_unlock(&wl->mutex);
+
+	return 0;
 }
 
 static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a6bcc39e146e..86faa413b37d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2460,6 +2460,7 @@ enum ieee80211_roc_type {
  *	This process will continue until sched_scan_stop is called.
  *
  * @sched_scan_stop: Tell the hardware to stop an ongoing scheduled scan.
+ *	In this case, ieee80211_sched_scan_stopped() must not be called.
  *
  * @sw_scan_start: Notifier function that is called just before a software scan
  *	is started. Can be NULL, if the driver doesn't need this notification.
@@ -2807,7 +2808,7 @@ struct ieee80211_ops {
 				struct ieee80211_vif *vif,
 				struct cfg80211_sched_scan_request *req,
 				struct ieee80211_sched_scan_ies *ies);
-	void (*sched_scan_stop)(struct ieee80211_hw *hw,
+	int (*sched_scan_stop)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
 	void (*sw_scan_complete)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ef8b385eff04..fc689f5d971e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -354,16 +354,20 @@ drv_sched_scan_start(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_sched_scan_stop(struct ieee80211_local *local,
-				       struct ieee80211_sub_if_data *sdata)
+static inline int drv_sched_scan_stop(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata)
 {
+	int ret;
+
 	might_sleep();
 
 	check_sdata_in_driver(sdata);
 
 	trace_drv_sched_scan_stop(local, sdata);
-	local->ops->sched_scan_stop(&local->hw, &sdata->vif);
-	trace_drv_return_void(local);
+	ret = local->ops->sched_scan_stop(&local->hw, &sdata->vif);
+	trace_drv_return_int(local, ret);
+
+	return ret;
 }
 
 static inline void drv_sw_scan_start(struct ieee80211_local *local)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b211e412511f..836f500dfbf3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1056,7 +1056,7 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	local->sched_scan_req = NULL;
 
 	if (rcu_access_pointer(local->sched_scan_sdata))
-		drv_sched_scan_stop(local, sdata);
+		ret = drv_sched_scan_stop(local, sdata);
 
 out:
 	mutex_unlock(&local->mtx);
-- 
1.8.5.3

