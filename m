Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594AbcCIRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:18 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/21] iwlwifi: mvm: add support for async rx handler without hold the mutex
Date: Wed,  9 Mar 2016 19:45:41 +0200
Message-Id: <1457545550-30677-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185951_092253_50A64FC4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

When running async rx handler the framework holds the mvm->mutex
before starting the async handler, that might cause a deadlock in case
the handler calls to ops that lock the mutex as well.
Add support for running async rx handler without hold the mutex before
activating the handler.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 114 +++++++++++++++++----------
 1 file changed, 73 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4322e8e..5e8ab79 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -205,79 +205,107 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 				       ~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 }
 
+/**
+ * enum iwl_rx_handler_context context for Rx handler
+ * @RX_HANDLER_SYNC : this means that it will be called in the Rx path
+ *	which can't acquire mvm->mutex.
+ * @RX_HANDLER_ASYNC_LOCKED : If the handler needs to hold mvm->mutex
+ *	(and only in this case!), it should be set as ASYNC. In that case,
+ *	it will be called from a worker with mvm->mutex held.
+ * @RX_HANDLER_ASYNC_UNLOCKED : in case the handler needs to lock the
+ *	mutex itself, it will be called from a worker without mvm->mutex held.
+ */
+enum iwl_rx_handler_context {
+	RX_HANDLER_SYNC,
+	RX_HANDLER_ASYNC_LOCKED,
+	RX_HANDLER_ASYNC_UNLOCKED,
+};
+
+/**
+ * struct iwl_rx_handlers handler for FW notification
+ * @cmd_id: command id
+ * @context: see &iwl_rx_handler_context
+ * @fn: the function is called when notification is received
+ */
 struct iwl_rx_handlers {
 	u16 cmd_id;
-	bool async;
+	enum iwl_rx_handler_context context;
 	void (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 };
 
-#define RX_HANDLER(_cmd_id, _fn, _async)	\
-	{ .cmd_id = _cmd_id , .fn = _fn , .async = _async }
-#define RX_HANDLER_GRP(_grp, _cmd, _fn, _async)	\
-	{ .cmd_id = WIDE_ID(_grp, _cmd), .fn = _fn, .async = _async }
+#define RX_HANDLER(_cmd_id, _fn, _context)	\
+	{ .cmd_id = _cmd_id, .fn = _fn, .context = _context }
+#define RX_HANDLER_GRP(_grp, _cmd, _fn, _context)	\
+	{ .cmd_id = WIDE_ID(_grp, _cmd), .fn = _fn, .context = _context }
 
 /*
  * Handlers for fw notifications
  * Convention: RX_HANDLER(CMD_NAME, iwl_mvm_rx_CMD_NAME
  * This list should be in order of frequency for performance purposes.
  *
- * The handler can be SYNC - this means that it will be called in the Rx path
- * which can't acquire mvm->mutex. If the handler needs to hold mvm->mutex (and
- * only in this case!), it should be set as ASYNC. In that case, it will be
- * called from a worker with mvm->mutex held.
+ * The handler can be one from three contexts, see &iwl_rx_handler_context
  */
 static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
-	RX_HANDLER(TX_CMD, iwl_mvm_rx_tx_cmd, false),
-	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, false),
-
-	RX_HANDLER(BT_PROFILE_NOTIFICATION, iwl_mvm_rx_bt_coex_notif, true),
-	RX_HANDLER(BEACON_NOTIFICATION, iwl_mvm_rx_beacon_notif, true),
-	RX_HANDLER(STATISTICS_NOTIFICATION, iwl_mvm_rx_statistics, true),
+	RX_HANDLER(TX_CMD, iwl_mvm_rx_tx_cmd, RX_HANDLER_SYNC),
+	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, RX_HANDLER_SYNC),
+
+	RX_HANDLER(BT_PROFILE_NOTIFICATION, iwl_mvm_rx_bt_coex_notif,
+		   RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER(BEACON_NOTIFICATION, iwl_mvm_rx_beacon_notif,
+		   RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER(STATISTICS_NOTIFICATION, iwl_mvm_rx_statistics,
+		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER(ANTENNA_COUPLING_NOTIFICATION,
-		   iwl_mvm_rx_ant_coupling_notif, true),
+		   iwl_mvm_rx_ant_coupling_notif, RX_HANDLER_ASYNC_LOCKED),
 
 	RX_HANDLER(BA_WINDOW_STATUS_NOTIFICATION_ID,
-		   iwl_mvm_window_status_notif, false),
+		   iwl_mvm_window_status_notif, RX_HANDLER_SYNC),
 
-	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
-	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc, true),
+	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif,
+		   RX_HANDLER_SYNC),
+	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc,
+		   RX_HANDLER_ASYNC_LOCKED),
 
-	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
+	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, RX_HANDLER_SYNC),
 
 	RX_HANDLER(SCAN_ITERATION_COMPLETE,
-		   iwl_mvm_rx_lmac_scan_iter_complete_notif, false),
+		   iwl_mvm_rx_lmac_scan_iter_complete_notif, RX_HANDLER_SYNC),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
-		   iwl_mvm_rx_lmac_scan_complete_notif, true),
+		   iwl_mvm_rx_lmac_scan_complete_notif,
+		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_scan_match_found,
-		   false),
+		   RX_HANDLER_SYNC),
 	RX_HANDLER(SCAN_COMPLETE_UMAC, iwl_mvm_rx_umac_scan_complete_notif,
-		   true),
+		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER(SCAN_ITERATION_COMPLETE_UMAC,
-		   iwl_mvm_rx_umac_scan_iter_complete_notif, false),
+		   iwl_mvm_rx_umac_scan_iter_complete_notif, RX_HANDLER_SYNC),
 
-	RX_HANDLER(CARD_STATE_NOTIFICATION, iwl_mvm_rx_card_state_notif, false),
+	RX_HANDLER(CARD_STATE_NOTIFICATION, iwl_mvm_rx_card_state_notif,
+		   RX_HANDLER_SYNC),
 
 	RX_HANDLER(MISSED_BEACONS_NOTIFICATION, iwl_mvm_rx_missed_beacons_notif,
-		   false),
+		   RX_HANDLER_SYNC),
 
-	RX_HANDLER(REPLY_ERROR, iwl_mvm_rx_fw_error, false),
+	RX_HANDLER(REPLY_ERROR, iwl_mvm_rx_fw_error, RX_HANDLER_SYNC),
 	RX_HANDLER(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION,
-		   iwl_mvm_power_uapsd_misbehaving_ap_notif, false),
-	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif, true),
+		   iwl_mvm_power_uapsd_misbehaving_ap_notif, RX_HANDLER_SYNC),
+	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif,
+		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(PHY_OPS_GROUP, DTS_MEASUREMENT_NOTIF_WIDE,
-		       iwl_mvm_temp_notif, true),
+		       iwl_mvm_temp_notif, RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(PHY_OPS_GROUP, CT_KILL_NOTIFICATION,
-		       iwl_mvm_ct_kill_notif, false),
+		       iwl_mvm_ct_kill_notif, RX_HANDLER_SYNC),
 
 	RX_HANDLER(TDLS_CHANNEL_SWITCH_NOTIFICATION, iwl_mvm_rx_tdls_notif,
-		   true),
-	RX_HANDLER(MFUART_LOAD_NOTIFICATION, iwl_mvm_rx_mfuart_notif, false),
-	RX_HANDLER(TOF_NOTIFICATION, iwl_mvm_tof_resp_handler, true),
+		   RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER(MFUART_LOAD_NOTIFICATION, iwl_mvm_rx_mfuart_notif,
+		   RX_HANDLER_SYNC),
+	RX_HANDLER(TOF_NOTIFICATION, iwl_mvm_tof_resp_handler,
+		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
-		       iwl_mvm_rx_stored_beacon_notif, false),
+		       iwl_mvm_rx_stored_beacon_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(DATA_PATH_GROUP, MU_GROUP_MGMT_NOTIF,
-		       iwl_mvm_mu_mimo_grp_notif, false),
-
+		       iwl_mvm_mu_mimo_grp_notif, RX_HANDLER_SYNC),
 };
 #undef RX_HANDLER
 #undef RX_HANDLER_GRP
@@ -743,6 +771,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 struct iwl_async_handler_entry {
 	struct list_head list;
 	struct iwl_rx_cmd_buffer rxb;
+	enum iwl_rx_handler_context context;
 	void (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 };
 
@@ -769,7 +798,6 @@ static void iwl_mvm_async_handlers_wk(struct work_struct *wk)
 	INIT_LIST_HEAD(&local_list);
 
 	/* Ensure that we are not in stop flow (check iwl_mvm_mac_stop) */
-	mutex_lock(&mvm->mutex);
 
 	/*
 	 * Sync with Rx path with a lock. Remove all the entries from this list,
@@ -780,12 +808,15 @@ static void iwl_mvm_async_handlers_wk(struct work_struct *wk)
 	spin_unlock_bh(&mvm->async_handlers_lock);
 
 	list_for_each_entry_safe(entry, tmp, &local_list, list) {
+		if (entry->context == RX_HANDLER_ASYNC_LOCKED)
+			mutex_lock(&mvm->mutex);
 		entry->fn(mvm, &entry->rxb);
 		iwl_free_rxb(&entry->rxb);
 		list_del(&entry->list);
+		if (entry->context == RX_HANDLER_ASYNC_LOCKED)
+			mutex_unlock(&mvm->mutex);
 		kfree(entry);
 	}
-	mutex_unlock(&mvm->mutex);
 }
 
 static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
@@ -842,7 +873,7 @@ static void iwl_mvm_rx_common(struct iwl_mvm *mvm,
 		if (rx_h->cmd_id != WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd))
 			continue;
 
-		if (!rx_h->async) {
+		if (rx_h->context == RX_HANDLER_SYNC) {
 			rx_h->fn(mvm, rxb);
 			return;
 		}
@@ -856,6 +887,7 @@ static void iwl_mvm_rx_common(struct iwl_mvm *mvm,
 		entry->rxb._offset = rxb->_offset;
 		entry->rxb._rx_page_order = rxb->_rx_page_order;
 		entry->fn = rx_h->fn;
+		entry->context = rx_h->context;
 		spin_lock(&mvm->async_handlers_lock);
 		list_add_tail(&entry->list, &mvm->async_handlers_list);
 		spin_unlock(&mvm->async_handlers_lock);
-- 
2.5.0

