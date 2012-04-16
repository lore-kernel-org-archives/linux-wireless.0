Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab2DPWB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/16] iwlwifi: move HCMD_ACTIVE to trans
Date: Mon, 16 Apr 2012 14:56:59 -0700
Message-Id: <1334613430-30720-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000248_202800_71925493)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The HCMD_ACTIVE bit is only used in trans.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    5 +----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    2 --
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    6 ++++++
 6 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a88130f..6b1a039 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1887,7 +1887,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
 		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
-			priv->shrd->status, table.valid);
+			priv->status, table.valid);
 	}
 
 	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
@@ -2177,9 +2177,6 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
 
-	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-
 	iwl_abort_notification_waits(&priv->notif_wait);
 
 	/* Keep the restart process from trying to send host
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 29a4ccf..a77f457 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -526,8 +526,6 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
-		test_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
 		test_bit(STATUS_RF_KILL_HW, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 428883b..2fe3145 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -150,7 +150,6 @@ struct iwl_mod_params {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
- * @status: STATUS_*
  * @wowlan: are we running wowlan uCode
  * @bus: pointer to the bus layer data
  * @cfg: see struct iwl_cfg
@@ -161,8 +160,6 @@ struct iwl_mod_params {
  * @eeprom: pointer to the eeprom/OTP image
  */
 struct iwl_shared {
-	unsigned long status;
-
 	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
 	void *drv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index e1af031..96ca5ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -547,7 +547,10 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
 			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		struct iwl_trans_pcie *trans_pcie;
+
+		trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		iwl_op_mode_wimax_active(trans->op_mode);
 		wake_up(&trans->wait_command_queue);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index c34eac0..2bc2670 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -792,12 +792,12 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 	iwl_hcmd_queue_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-		if (!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+		if (!test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
 			IWL_WARN(trans,
 				 "HCMD_ACTIVE already clear for command %s\n",
 				 get_cmd_string(cmd->hdr.cmd));
 		}
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
 		wake_up(&trans->wait_command_queue);
@@ -839,7 +839,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			get_cmd_string(cmd->id));
 
 	if (WARN_ON(test_and_set_bit(STATUS_HCMD_ACTIVE,
-				     &trans->shrd->status))) {
+				     &trans_pcie->status))) {
 		IWL_ERR(trans, "Command %s: a command is already active!\n",
 			get_cmd_string(cmd->id));
 		return -EIO;
@@ -851,7 +851,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	cmd_idx = iwl_enqueue_hcmd(trans, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
@@ -859,10 +859,10 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	}
 
 	ret = wait_event_timeout(trans->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
+			!test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+		if (test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
 			struct iwl_tx_queue *txq =
 				&trans_pcie->txq[trans_pcie->cmd_queue];
 			struct iwl_queue *q = &txq->q;
@@ -876,7 +876,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 				"Current CMD queue read_ptr %d write_ptr %d\n",
 				q->read_ptr, q->write_ptr);
 
-			clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+			clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
 				 "%s\n", get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 914b6d5..1b7c846 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1248,6 +1248,12 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
+	/* clear all status bits */
+	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
+	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
+	clear_bit(STATUS_POWER_PMI, &trans_pcie->status);
 }
 
 static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
-- 
1.7.0.4

