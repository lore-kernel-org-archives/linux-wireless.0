Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3AXMBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 07:01:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: provide the vif in rssi_callback
Date: Thu, 24 Jan 2013 13:02:12 +0100
Message-Id: <1359028932-14244-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_130152_059598_45E65AE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since drivers can support several BSS / P2P Client
interfaces, the rssi callback needs to inform the driver
about the interface teh rssi event relates to.

Change-Id: I41c3037174fca6a0ba44024b4887b7f13832e93f
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-on: http://musxgits01.imu.intel.com:8080/9194
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c           | 1 +
 drivers/net/wireless/iwlwifi/dvm16/agn.h              | 1 +
 drivers/net/wireless/iwlwifi/dvm16/iwl-mvm-mac80211.c | 3 ++-
 drivers/net/wireless/iwlwifi/dvm16/mac80211.c         | 1 +
 include/net/mac80211.h                                | 1 +
 net/mac80211/driver-ops.h                             | 5 +++--
 net/mac80211/mlme.c                                   | 4 ++--
 net/mac80211/trace.h                                  | 9 ++++++---
 8 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 668b304..39dfa99 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1162,6 +1162,7 @@ static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 }
 
 static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
 				     enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
diff --git a/drivers/net/wireless/iwlwifi/dvm16/agn.h b/drivers/net/wireless/iwlwifi/dvm16/agn.h
index 0444f4c..8f69f54 100644
--- a/drivers/net/wireless/iwlwifi/dvm16/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm16/agn.h
@@ -589,6 +589,7 @@ void iwl_nic_config(struct iwl_op_mode *op_mode);
 int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 		       struct ieee80211_sta *sta, bool set);
 void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
 			      enum ieee80211_rssi_event rssi_event);
 int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw);
 int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/iwlwifi/dvm16/iwl-mvm-mac80211.c b/drivers/net/wireless/iwlwifi/dvm16/iwl-mvm-mac80211.c
index 2f3f70b..4b221d9 100644
--- a/drivers/net/wireless/iwlwifi/dvm16/iwl-mvm-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm16/iwl-mvm-mac80211.c
@@ -917,9 +917,10 @@ static int iwl_mvm_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 }
 
 static void iwl_mvm_mac_rssi_callback(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
 				      enum ieee80211_rssi_event rssi_event)
 {
-	return iwlagn_mac_rssi_callback(hw, rssi_event);
+	return iwlagn_mac_rssi_callback(hw, vif, rssi_event);
 }
 
 static inline int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/dvm16/mac80211.c b/drivers/net/wireless/iwlwifi/dvm16/mac80211.c
index 628b40c..4f7a99f 100644
--- a/drivers/net/wireless/iwlwifi/dvm16/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm16/mac80211.c
@@ -1169,6 +1169,7 @@ int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 }
 
 void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
 			      enum ieee80211_rssi_event rssi_event)
 {
 	struct iwl_mvm_priv *priv = IWL_MAC80211_GET_PRIV(hw);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4273e83..c5b2915 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2649,6 +2649,7 @@ struct ieee80211_ops {
 	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				const struct cfg80211_bitrate_mask *mask);
 	void (*rssi_callback)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
 			      enum ieee80211_rssi_event rssi_event);
 
 	void (*allow_buffered_frames)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c6eef63..9cf31be 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -896,11 +896,12 @@ static inline void drv_set_rekey_data(struct ieee80211_local *local,
 }
 
 static inline void drv_rssi_callback(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
 				     const enum ieee80211_rssi_event event)
 {
-	trace_drv_rssi_callback(local, event);
+	trace_drv_rssi_callback(local, sdata, event);
 	if (local->ops->rssi_callback)
-		local->ops->rssi_callback(&local->hw, event);
+		local->ops->rssi_callback(&local->hw, &sdata->vif, event);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0159acb..b1ae4e8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2604,12 +2604,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		if (sig > ifmgd->rssi_max_thold &&
 		    (last_sig <= ifmgd->rssi_min_thold || last_sig == 0)) {
 			ifmgd->last_ave_beacon_signal = sig;
-			drv_rssi_callback(local, RSSI_EVENT_HIGH);
+			drv_rssi_callback(local, sdata, RSSI_EVENT_HIGH);
 		} else if (sig < ifmgd->rssi_min_thold &&
 			   (last_sig >= ifmgd->rssi_max_thold ||
 			   last_sig == 0)) {
 			ifmgd->last_ave_beacon_signal = sig;
-			drv_rssi_callback(local, RSSI_EVENT_LOW);
+			drv_rssi_callback(local, sdata, RSSI_EVENT_LOW);
 		}
 	}
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 788bf21..7e080d0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1183,23 +1183,26 @@ TRACE_EVENT(drv_set_rekey_data,
 
 TRACE_EVENT(drv_rssi_callback,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_rssi_event rssi_event),
 
-	TP_ARGS(local, rssi_event),
+	TP_ARGS(local, sdata, rssi_event),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(u32, rssi_event)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->rssi_event = rssi_event;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " rssi_event:%d",
-		LOCAL_PR_ARG, __entry->rssi_event
+		LOCAL_PR_FMT VIF_PR_FMT " rssi_event:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->rssi_event
 	)
 );
 
-- 
1.8.0

