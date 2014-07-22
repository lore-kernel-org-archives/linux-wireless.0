Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43314 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaGVT11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:27 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so107473wgg.28
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:26 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ariej Marjieh <ariej.marjieh@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/20] iwlwifi: mvm: add Aux ROC request/response flow
Date: Tue, 22 Jul 2014 22:26:40 +0300
Message-Id: <1406057211-31752-9-git-send-email-egrumbach@gmail.com> (sfid-20140722_212736_423749_82D9BECA)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ariej Marjieh <ariej.marjieh@intel.com>

The Remain On Channel framework added to the firmare is
a bit like time events. It allows the driver to request
the firmware to be on a certain channel for a certain time.
Unlike the time events, the ROC infrastructure doesn't need
a MAC context in the firmware - it uses a generic context
called "auxiliary framework".

This is useful for any offchannel activity that is not bound
to a specific MAC.
The flow is synchronized much like with time events:
1) The driver receives an action frame from the wpa_supplicant
   via nl80211 that requests to be sent offchannel.
2) The driver sends an Aux ROC command (0x53) to the firmware.
3) The firmware responds with the unique id of the time event.
4) When time event starts, the driver puts the frame in the
   Aux queue.

Special care needs to be taken when the time events ends:
the queue needs to be cleaned-up.

Signed-off-by: Ariej Marjieh <ariej.marjieh@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 126 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |   7 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c        |   2 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  89 +++++++++++++++---
 4 files changed, 208 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 12a9aed..5219b3a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2310,6 +2310,119 @@ static void iwl_mvm_mac_update_tkip_key(struct ieee80211_hw *hw,
 }
 
 
+static bool iwl_mvm_rx_aux_roc(struct iwl_notif_wait_data *notif_wait,
+			       struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	struct iwl_hs20_roc_res *resp;
+	int resp_len = iwl_rx_packet_payload_len(pkt);
+	struct iwl_mvm_time_event_data *te_data = data;
+
+	if (WARN_ON(pkt->hdr.cmd != HOT_SPOT_CMD))
+		return true;
+
+	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
+		IWL_ERR(mvm, "Invalid HOT_SPOT_CMD response\n");
+		return true;
+	}
+
+	resp = (void *)pkt->data;
+
+	IWL_DEBUG_TE(mvm,
+		     "Aux ROC: Recieved response from ucode: status=%d uid=%d\n",
+		     resp->status, resp->event_unique_id);
+
+	te_data->uid = le32_to_cpu(resp->event_unique_id);
+	IWL_DEBUG_TE(mvm, "TIME_EVENT_CMD response - UID = 0x%x\n",
+		     te_data->uid);
+
+	spin_lock_bh(&mvm->time_event_lock);
+	list_add_tail(&te_data->list, &mvm->aux_roc_te_list);
+	spin_unlock_bh(&mvm->time_event_lock);
+
+	return true;
+}
+
+#define AUX_ROC_MAX_DELAY_ON_CHANNEL 5000
+static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
+				    struct ieee80211_channel *channel,
+				    struct ieee80211_vif *vif,
+				    int duration)
+{
+	int res, time_reg = DEVICE_SYSTEM_TIME_REG;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_time_event_data *te_data = &mvmvif->hs_time_event_data;
+	static const u8 time_event_response[] = { HOT_SPOT_CMD };
+	struct iwl_notification_wait wait_time_event;
+	struct iwl_hs20_roc_req aux_roc_req = {
+		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
+		.id_and_color =
+			cpu_to_le32(FW_CMD_ID_AND_COLOR(MAC_INDEX_AUX, 0)),
+		.sta_id_and_color = cpu_to_le32(mvm->aux_sta.sta_id),
+		/* Set the channel info data */
+		.channel_info.band = (channel->band == IEEE80211_BAND_2GHZ) ?
+			PHY_BAND_24 : PHY_BAND_5,
+		.channel_info.channel = channel->hw_value,
+		.channel_info.width = PHY_VHT_CHANNEL_MODE20,
+		/* Set the time and duration */
+		.apply_time = cpu_to_le32(iwl_read_prph(mvm->trans, time_reg)),
+		.apply_time_max_delay =
+			cpu_to_le32(MSEC_TO_TU(AUX_ROC_MAX_DELAY_ON_CHANNEL)),
+		.duration = cpu_to_le32(MSEC_TO_TU(duration)),
+	 };
+
+	/* Set the node address */
+	memcpy(aux_roc_req.node_addr, vif->addr, ETH_ALEN);
+
+	te_data->vif = vif;
+	te_data->duration = duration;
+	te_data->id = HOT_SPOT_CMD;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->time_event_lock);
+	list_add_tail(&te_data->list, &mvm->time_event_list);
+	spin_unlock_bh(&mvm->time_event_lock);
+
+	/*
+	 * Use a notification wait, which really just processes the
+	 * command response and doesn't wait for anything, in order
+	 * to be able to process the response and get the UID inside
+	 * the RX path. Using CMD_WANT_SKB doesn't work because it
+	 * stores the buffer and then wakes up this thread, by which
+	 * time another notification (that the time event started)
+	 * might already be processed unsuccessfully.
+	 */
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_time_event,
+				   time_event_response,
+				   ARRAY_SIZE(time_event_response),
+				   iwl_mvm_rx_aux_roc, te_data);
+
+	res = iwl_mvm_send_cmd_pdu(mvm, HOT_SPOT_CMD, 0, sizeof(aux_roc_req),
+				   &aux_roc_req);
+
+	if (res) {
+		IWL_ERR(mvm, "Couldn't send HOT_SPOT_CMD: %d\n", res);
+		iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
+		goto out_clear_te;
+	}
+
+	/* No need to wait for anything, so just pass 1 (0 isn't valid) */
+	res = iwl_wait_notification(&mvm->notif_wait, &wait_time_event, 1);
+	/* should never fail */
+	WARN_ON_ONCE(res);
+
+	if (res) {
+ out_clear_te:
+		spin_lock_bh(&mvm->time_event_lock);
+		iwl_mvm_te_clear_data(mvm, te_data);
+		spin_unlock_bh(&mvm->time_event_lock);
+	}
+
+	return res;
+}
+
 static int iwl_mvm_roc(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_channel *channel,
@@ -2325,8 +2438,17 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
 			   duration, type);
 
-	if (vif->type != NL80211_IFTYPE_P2P_DEVICE) {
-		IWL_ERR(mvm, "vif isn't a P2P_DEVICE: %d\n", vif->type);
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		/* Use aux roc framework (HS20) */
+		ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
+					       vif, duration);
+		return ret;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		/* handle below */
+		break;
+	default:
+		IWL_ERR(mvm, "vif isn't P2P_DEVICE: %d\n", vif->type);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 24c12c7..2cead5d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -82,6 +82,8 @@
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
 #define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
+/* A TimeUnit is 1024 microsecond */
+#define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
 /*
  * The CSA NoA is scheduled IWL_MVM_CHANNEL_SWITCH_TIME TUs before "beacon 0"
@@ -336,6 +338,7 @@ struct iwl_mvm_vif {
 	 */
 	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
 	struct iwl_mvm_time_event_data time_event_data;
+	struct iwl_mvm_time_event_data hs_time_event_data;
 
 	struct iwl_mvm_int_sta bcast_sta;
 
@@ -669,6 +672,9 @@ struct iwl_mvm {
 	u8 bt_tx_prio;
 	enum iwl_bt_force_ant_mode bt_force_ant_mode;
 
+	/* Aux ROC */
+	struct list_head aux_roc_te_list;
+
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
 	s32 temperature;	/* Celsius */
@@ -707,6 +713,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_ROC_RUNNING,
 	IWL_MVM_STATUS_IN_HW_RESTART,
 	IWL_MVM_STATUS_IN_D0I3,
+	IWL_MVM_STATUS_ROC_AUX_RUNNING,
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 19a66b5..904228a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -289,6 +289,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(MATCH_FOUND_NOTIFICATION),
 	CMD(SCAN_OFFLOAD_REQUEST_CMD),
 	CMD(SCAN_OFFLOAD_ABORT_CMD),
+	CMD(HOT_SPOT_CMD),
 	CMD(SCAN_OFFLOAD_COMPLETE),
 	CMD(SCAN_OFFLOAD_UPDATE_PROFILES_CMD),
 	CMD(SCAN_ITERATION_COMPLETE),
@@ -419,6 +420,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_init(&mvm->d0i3_suspend_mutex);
 	spin_lock_init(&mvm->async_handlers_lock);
 	INIT_LIST_HEAD(&mvm->time_event_list);
+	INIT_LIST_HEAD(&mvm->aux_roc_te_list);
 	INIT_LIST_HEAD(&mvm->async_handlers_list);
 	spin_lock_init(&mvm->time_event_lock);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index ae52613..33e5041 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -72,9 +72,6 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 
-/* A TimeUnit is 1024 microsecond */
-#define MSEC_TO_TU(_msec)	(_msec*1000/1024)
-
 /*
  * For the high priority TE use a time event type that has similar priority to
  * the FW's action scan priority.
@@ -100,6 +97,21 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 void iwl_mvm_roc_done_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, roc_done_wk);
+	u32 queues = 0;
+
+	/*
+	 * Clear the ROC_RUNNING /ROC_AUX_RUNNING status bit.
+	 * This will cause the TX path to drop offchannel transmissions.
+	 * That would also be done by mac80211, but it is racy, in particular
+	 * in the case that the time event actually completed in the firmware
+	 * (which is handled in iwl_mvm_te_handle_notif).
+	 */
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status))
+		queues |= BIT(IWL_MVM_OFFCHANNEL_QUEUE);
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
+		queues |= BIT(mvm->aux_queue);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
 
 	synchronize_net();
 
@@ -113,22 +125,12 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	 * issue as it will have to complete before the next command is
 	 * executed, and a new time event means a new command.
 	 */
-	iwl_mvm_flush_tx_path(mvm, BIT(IWL_MVM_OFFCHANNEL_QUEUE), false);
+	iwl_mvm_flush_tx_path(mvm, queues, false);
 }
 
 static void iwl_mvm_roc_finished(struct iwl_mvm *mvm)
 {
 	/*
-	 * First, clear the ROC_RUNNING status bit. This will cause the TX
-	 * path to drop offchannel transmissions. That would also be done
-	 * by mac80211, but it is racy, in particular in the case that the
-	 * time event actually completed in the firmware (which is handled
-	 * in iwl_mvm_te_handle_notif).
-	 */
-	clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
-	iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
-
-	/*
 	 * Of course, our status bit is just as racy as mac80211, so in
 	 * addition, fire off the work struct which will drop all frames
 	 * from the hardware queues that made it through the race. First
@@ -263,6 +265,60 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 }
 
 /*
+ * Handle A Aux ROC time event
+ */
+static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
+					   struct iwl_time_event_notif *notif)
+{
+	struct iwl_mvm_time_event_data *te_data, *tmp;
+	bool aux_roc_te = false;
+
+	list_for_each_entry_safe(te_data, tmp, &mvm->aux_roc_te_list, list) {
+		if (le32_to_cpu(notif->unique_id) == te_data->uid) {
+			aux_roc_te = true;
+			break;
+		}
+	}
+	if (!aux_roc_te) /* Not a Aux ROC time event */
+		return -EINVAL;
+
+	if (!le32_to_cpu(notif->status)) {
+		IWL_DEBUG_TE(mvm,
+			     "ERROR: Aux ROC Time Event %s notification failure\n",
+			     (le32_to_cpu(notif->action) &
+			      TE_V2_NOTIF_HOST_EVENT_START) ? "start" : "end");
+		return -EINVAL;
+	}
+
+	IWL_DEBUG_TE(mvm,
+		     "Aux ROC time event notification  - UID = 0x%x action %d\n",
+		     le32_to_cpu(notif->unique_id),
+		     le32_to_cpu(notif->action));
+
+	if (le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_END) {
+		/* End TE, notify mac80211 */
+		ieee80211_remain_on_channel_expired(mvm->hw);
+		iwl_mvm_roc_finished(mvm); /* flush aux queue */
+		list_del(&te_data->list); /* remove from list */
+		te_data->running = false;
+		te_data->vif = NULL;
+		te_data->uid = 0;
+	} else if (le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_START) {
+		set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
+		set_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status);
+		te_data->running = true;
+		ieee80211_ready_on_channel(mvm->hw); /* Start TE */
+	} else {
+		IWL_DEBUG_TE(mvm,
+			     "ERROR: Unknown Aux ROC Time Event (action = %d)\n",
+			     le32_to_cpu(notif->action));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
  * The Rx handler for time event notifications
  */
 int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
@@ -278,10 +334,15 @@ int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
 		     le32_to_cpu(notif->action));
 
 	spin_lock_bh(&mvm->time_event_lock);
+	/* This time event is triggered for Aux ROC request */
+	if (!iwl_mvm_aux_roc_te_handle_notif(mvm, notif))
+		goto unlock;
+
 	list_for_each_entry_safe(te_data, tmp, &mvm->time_event_list, list) {
 		if (le32_to_cpu(notif->unique_id) == te_data->uid)
 			iwl_mvm_te_handle_notif(mvm, te_data, notif);
 	}
+unlock:
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	return 0;
-- 
1.8.3.2

