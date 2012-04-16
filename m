Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2DPWB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/16] iwlwifi: complete STATUS_READY refactoring
Date: Mon, 16 Apr 2012 14:56:58 -0700
Message-Id: <1334613430-30720-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000249_228946_BA3F34AA)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

When WiMax takes over the RF, inform the op_mode.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    7 +------
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 427f63c..a88130f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2250,6 +2250,14 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 	priv->lib->nic_config(priv);
 }
 
+static void iwl_wimax_active(struct iwl_op_mode *op_mode)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	clear_bit(STATUS_READY, &priv->status);
+	IWL_ERR(priv, "RF is used by WiMAX\n");
+}
+
 static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
@@ -2341,6 +2349,7 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.nic_error = iwl_nic_error,
 	.cmd_queue_full = iwl_cmd_queue_full,
 	.nic_config = iwl_nic_config,
+	.wimax_active = iwl_wimax_active,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index b1fd251..ca947ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -125,6 +125,7 @@ struct iwl_fw;
  * @cmd_queue_full: Called when the command queue gets full. Must be atomic.
  * @nic_config: configure NIC, called before firmware is started.
  *	May sleep
+ * @wimax_active: invoked when WiMax becomes active.  Must be atomic.
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
@@ -139,6 +140,7 @@ struct iwl_op_mode_ops {
 	void (*nic_error)(struct iwl_op_mode *op_mode);
 	void (*cmd_queue_full)(struct iwl_op_mode *op_mode);
 	void (*nic_config)(struct iwl_op_mode *op_mode);
+	void (*wimax_active)(struct iwl_op_mode *op_mode);
 };
 
 /**
@@ -209,6 +211,11 @@ static inline void iwl_op_mode_nic_config(struct iwl_op_mode *op_mode)
 	op_mode->ops->nic_config(op_mode);
 }
 
+static inline void iwl_op_mode_wimax_active(struct iwl_op_mode *op_mode)
+{
+	op_mode->ops->wimax_active(op_mode);
+}
+
 /*****************************************************
 * Op mode layers implementations
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index b35f120..e1af031 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -547,14 +547,9 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
 			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		/*
-		 * Keep the restart process from trying to send host
-		 * commands by clearing the ready bit.
-		 */
-		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
+		iwl_op_mode_wimax_active(trans->op_mode);
 		wake_up(&trans->wait_command_queue);
-		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
 
-- 
1.7.0.4

