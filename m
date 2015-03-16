Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbbCPVXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:23:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] mac80211: convert rssi_callback() to event_callback()
Date: Mon, 16 Mar 2015 23:23:34 +0200
Message-Id: <1426541017-10516-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150316_222349_181730_2B68929D)
In-Reply-To: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will be able to add more events, such as MLME events and
others. The low level driver may be interested in knowing
about these events to dump firmware data upon failures, or
to change parameters in case connection attempts fail etc...

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c    | 15 ++++----
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  4 +--
 include/net/mac80211.h                         | 48 ++++++++++++++++++++------
 net/mac80211/driver-ops.h                      | 12 +++----
 net/mac80211/mlme.c                            |  9 +++--
 net/mac80211/trace.h                           | 14 ++++----
 8 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 47e64e8..5707ba5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1129,20 +1129,23 @@ done:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     enum ieee80211_rssi_event rssi_event)
+static void iwlagn_mac_event_callback(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      const struct ieee80211_event *event)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
+	if (event->type != RSSI_EVENT)
+		return;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
 
 	if (priv->lib->bt_params &&
 	    priv->lib->bt_params->advanced_bt_coexist) {
-		if (rssi_event == RSSI_EVENT_LOW)
+		if (event->u.rssi.data == RSSI_EVENT_LOW)
 			priv->bt_enable_pspoll = true;
-		else if (rssi_event == RSSI_EVENT_HIGH)
+		else if (event->u.rssi.data == RSSI_EVENT_HIGH)
 			priv->bt_enable_pspoll = false;
 
 		iwlagn_send_advance_bt_config(priv);
@@ -1613,7 +1616,7 @@ const struct ieee80211_ops iwlagn_hw_ops = {
 	.channel_switch = iwlagn_mac_channel_switch,
 	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwlagn_mac_tx_last_beacon,
-	.rssi_callback = iwlagn_mac_rssi_callback,
+	.event_callback = iwlagn_mac_event_callback,
 	.set_tim = iwlagn_mac_set_tim,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 1ec4d55..ba0a596 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1023,7 +1023,7 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 }
 
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   enum ieee80211_rssi_event rssi_event)
+			   enum ieee80211_rssi_event_data rssi_event)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data data = {
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index d530ef3..92c3072 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1068,7 +1068,7 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 }
 
 void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			       enum ieee80211_rssi_event rssi_event)
+			       enum ieee80211_rssi_event_data rssi_event)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_bt_iterator_data data = {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6c69d05..646ef92 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1225,7 +1225,7 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 			     struct iwl_rx_cmd_buffer *rxb,
 			     struct iwl_device_cmd *cmd);
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   enum ieee80211_rssi_event rssi_event);
+			   enum ieee80211_rssi_event_data);
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm);
 u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
@@ -1246,7 +1246,7 @@ int iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
 				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
 void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			       enum ieee80211_rssi_event rssi_event);
+			       enum ieee80211_rssi_event_data);
 u16 iwl_mvm_coex_agg_time_limit_old(struct iwl_mvm *mvm,
 				    struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed_old(struct iwl_mvm *mvm,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 157c0f1..7a966f3e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -301,17 +301,44 @@ enum ieee80211_bss_change {
 #define IEEE80211_BSS_ARP_ADDR_LIST_LEN 4
 
 /**
- * enum ieee80211_rssi_event - RSSI threshold event
- * An indicator for when RSSI goes below/above a certain threshold.
- * @RSSI_EVENT_HIGH: AP's rssi crossed the high threshold set by the driver.
- * @RSSI_EVENT_LOW: AP's rssi crossed the low threshold set by the driver.
+ * enum ieee80211_event_type - event to be notified to the low level driver
+ * @RSSI_EVENT: AP's rssi crossed the a threshold set by the driver.
  */
-enum ieee80211_rssi_event {
+enum ieee80211_event_type {
+	RSSI_EVENT,
+};
+
+/**
+ * enum ieee80211_rssi_event_data - relevant when event type is %RSSI_EVENT
+ * @RSSI_EVENT_HIGH: AP's rssi went below the threshold set by the driver.
+ * @RSSI_EVENT_LOW: AP's rssi went above the threshold set by the driver.
+ */
+enum ieee80211_rssi_event_data {
 	RSSI_EVENT_HIGH,
 	RSSI_EVENT_LOW,
 };
 
 /**
+ * enum ieee80211_rssi_event - data attached to an %RSSI_EVENT
+ * @data: See &enum ieee80211_rssi_event_data
+ */
+struct ieee80211_rssi_event {
+	enum ieee80211_rssi_event_data data;
+};
+
+/**
+ * struct ieee80211_event - event to be sent to the driver
+ * @type The event itself. See &enum ieee80211_event_type.
+ * @rssi: relevant if &type is %RSSI_EVENT
+ */
+struct ieee80211_event {
+	enum ieee80211_event_type type;
+	union {
+		struct ieee80211_rssi_event rssi;
+	} u;
+};
+
+/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -2862,8 +2889,9 @@ enum ieee80211_reconfig_type {
  * @set_bitrate_mask: Set a mask of rates to be used for rate control selection
  *	when transmitting a frame. Currently only legacy rates are handled.
  *	The callback can sleep.
- * @rssi_callback: Notify driver when the average RSSI goes above/below
- *	thresholds that were registered previously. The callback can sleep.
+ * @event_callback: Notify driver about any event in mac80211. See
+ *	&enum ieee80211_event_type for the different types.
+ *	The callback can sleep.
  *
  * @release_buffered_frames: Release buffered frames according to the given
  *	parameters. In the case where the driver buffers some frames for
@@ -3159,9 +3187,9 @@ struct ieee80211_ops {
 	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
 	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				const struct cfg80211_bitrate_mask *mask);
-	void (*rssi_callback)(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      enum ieee80211_rssi_event rssi_event);
+	void (*event_callback)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       const struct ieee80211_event *event);
 
 	void (*allow_buffered_frames)(struct ieee80211_hw *hw,
 				      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fdeda17..0a39d3d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -941,13 +941,13 @@ static inline void drv_set_rekey_data(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_rssi_callback(struct ieee80211_local *local,
-				     struct ieee80211_sub_if_data *sdata,
-				     const enum ieee80211_rssi_event event)
+static inline void drv_event_callback(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata,
+				      const struct ieee80211_event *event)
 {
-	trace_drv_rssi_callback(local, sdata, event);
-	if (local->ops->rssi_callback)
-		local->ops->rssi_callback(&local->hw, &sdata->vif, event);
+	trace_drv_event_callback(local, sdata, event);
+	if (local->ops->event_callback)
+		local->ops->event_callback(&local->hw, &sdata->vif, event);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1999bc0..a8c8fe4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3291,6 +3291,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
 		int sig = ifmgd->ave_beacon_signal;
 		int last_sig = ifmgd->last_ave_beacon_signal;
+		struct ieee80211_event event = {
+			.type = RSSI_EVENT,
+		};
 
 		/*
 		 * if signal crosses either of the boundaries, invoke callback
@@ -3299,12 +3302,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		if (sig > ifmgd->rssi_max_thold &&
 		    (last_sig <= ifmgd->rssi_min_thold || last_sig == 0)) {
 			ifmgd->last_ave_beacon_signal = sig;
-			drv_rssi_callback(local, sdata, RSSI_EVENT_HIGH);
+			event.u.rssi.data = RSSI_EVENT_HIGH;
+			drv_event_callback(local, sdata, &event);
 		} else if (sig < ifmgd->rssi_min_thold &&
 			   (last_sig >= ifmgd->rssi_max_thold ||
 			   last_sig == 0)) {
 			ifmgd->last_ave_beacon_signal = sig;
-			drv_rssi_callback(local, sdata, RSSI_EVENT_LOW);
+			event.u.rssi.data = RSSI_EVENT_LOW;
+			drv_event_callback(local, sdata, &event);
 		}
 	}
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 263a956..e9e462b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1256,28 +1256,28 @@ TRACE_EVENT(drv_set_rekey_data,
 		  LOCAL_PR_ARG, VIF_PR_ARG)
 );
 
-TRACE_EVENT(drv_rssi_callback,
+TRACE_EVENT(drv_event_callback,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 enum ieee80211_rssi_event rssi_event),
+		 const struct ieee80211_event *_event),
 
-	TP_ARGS(local, sdata, rssi_event),
+	TP_ARGS(local, sdata, _event),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
-		__field(u32, rssi_event)
+		__field(u32, type)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		__entry->rssi_event = rssi_event;
+		__entry->type = _event->type;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT " rssi_event:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->rssi_event
+		LOCAL_PR_FMT VIF_PR_FMT " event:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->type
 	)
 );
 
-- 
1.9.1

