Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbbDBGmc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/31] iwlwifi: mvm: add trigger for time events
Date: Thu,  2 Apr 2015 09:41:18 +0300
Message-Id: <1427956879-11725-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090420_491500_F902FDA1)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow to collect data when a time event
notifcation with a certain id and action is coming from
the firmware. This can be very useful to debug various
flows.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 16 +++++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c    | 42 ++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 7783ac8..e747562 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1237,6 +1237,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		sizeof(struct iwl_fw_dbg_trigger_low_rssi);
 	trigger_tlv_sz[FW_DBG_TRIGGER_TXQ_TIMERS] =
 		sizeof(struct iwl_fw_dbg_trigger_txq_timer);
+	trigger_tlv_sz[FW_DBG_TRIGGER_TIME_EVENT] =
+		sizeof(struct iwl_fw_dbg_trigger_time_event);
 
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 3765285..251bf8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -252,6 +252,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  *	goes below a threshold.
  * @FW_DBG_TRIGGER_TXQ_TIMERS: configures the timers for the Tx queue hang
  *	detection.
+ * @FW_DBG_TRIGGER_TIME_EVENT: trigger log collection upon time events related
+ *	events.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -264,6 +266,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_STATS,
 	FW_DBG_TRIGGER_RSSI,
 	FW_DBG_TRIGGER_TXQ_TIMERS,
+	FW_DBG_TRIGGER_TIME_EVENT,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index cc789cb..ee14948 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -637,6 +637,22 @@ struct iwl_fw_dbg_trigger_txq_timer {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_time_event - configures a time event trigger
+ * time_Events: a list of tuples <id, action_bitmap>. The driver will issue a
+ *	trigger each time a time event notification that relates to time event
+ *	id with one of the actions in the bitmap is received and
+ *	BIT(notif->status) is set in status_bitmap.
+ *
+ */
+struct iwl_fw_dbg_trigger_time_event {
+	struct {
+		__le32 id;
+		__le32 action_bitmap;
+		__le32 status_bitmap;
+	} __packed time_events[16];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index bd51959..6478223 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -226,6 +226,44 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 	iwl_mvm_te_clear_data(mvm, te_data);
 }
 
+static void iwl_mvm_te_check_trigger(struct iwl_mvm *mvm,
+				     struct iwl_time_event_notif *notif,
+				     struct iwl_mvm_time_event_data *te_data)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_time_event *te_trig;
+	int i;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TIME_EVENT))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TIME_EVENT);
+	te_trig = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, te_data->vif, trig))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(te_trig->time_events); i++) {
+		u32 trig_te_id = le32_to_cpu(te_trig->time_events[i].id);
+		u32 trig_action_bitmap =
+			le32_to_cpu(te_trig->time_events[i].action_bitmap);
+		u32 trig_status_bitmap =
+			le32_to_cpu(te_trig->time_events[i].status_bitmap);
+
+		if (trig_te_id != te_data->id ||
+		    !(trig_action_bitmap & le32_to_cpu(notif->action)) ||
+		    !(trig_status_bitmap & BIT(le32_to_cpu(notif->status))))
+			continue;
+
+		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+					    "Time event %d Action 0x%x received status: %d",
+					    te_data->id,
+					    le32_to_cpu(notif->action),
+					    le32_to_cpu(notif->status));
+		break;
+	}
+}
+
 /*
  * Handles a FW notification for an event that is known to the driver.
  *
@@ -243,6 +281,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		     le32_to_cpu(notif->unique_id),
 		     le32_to_cpu(notif->action));
 
+	iwl_mvm_te_check_trigger(mvm, notif, te_data);
+
 	/*
 	 * The FW sends the start/end time event notifications even for events
 	 * that it fails to schedule. This is indicated in the status field of
@@ -324,6 +364,8 @@ static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 	if (!aux_roc_te) /* Not a Aux ROC time event */
 		return -EINVAL;
 
+	iwl_mvm_te_check_trigger(mvm, notif, te_data);
+
 	if (!le32_to_cpu(notif->status)) {
 		IWL_DEBUG_TE(mvm,
 			     "ERROR: Aux ROC Time Event %s notification failure\n",
-- 
1.9.1

