Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63023 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3LQUpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:10 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so2676155eaj.14
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/36] iwlwifi: trans: use a unified transport status
Date: Tue, 17 Dec 2013 22:44:20 +0200
Message-Id: <1387313079-28123-17-git-send-email-egrumbach@gmail.com> (sfid-20131217_214632_839904_62ED0050)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The same bits are employed in all transport layers. Put the status
field in the common transport layer. This allows us to employ them
in common transport code.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   20 +++++++++++++
 drivers/net/wireless/iwlwifi/pcie/internal.h |   29 ++-----------------
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   27 ++++++++---------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   40 +++++++++++---------------
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   30 +++++++++----------
 5 files changed, 65 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 43ea124..6419603 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -317,6 +317,24 @@ enum iwl_d3_status {
 };
 
 /**
+ * enum iwl_trans_status: transport status flags
+ * @STATUS_SYNC_HCMD_ACTIVE: a SYNC command is being processed
+ * @STATUS_DEVICE_ENABLED: APM is enabled
+ * @STATUS_TPOWER_PMI: the device might be asleep (need to wake it up)
+ * @STATUS_INT_ENABLED: interrupts are enabled
+ * @STATUS_RFKILL: the HW RFkill switch is in KILL position
+ * @STATUS_FW_ERROR: the fw is in error state
+ */
+enum iwl_trans_status {
+	STATUS_SYNC_HCMD_ACTIVE,
+	STATUS_DEVICE_ENABLED,
+	STATUS_TPOWER_PMI,
+	STATUS_INT_ENABLED,
+	STATUS_RFKILL,
+	STATUS_FW_ERROR,
+};
+
+/**
  * struct iwl_trans_config - transport configuration
  *
  * @op_mode: pointer to the upper layer.
@@ -479,6 +497,7 @@ enum iwl_trans_state {
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
  * @cfg - pointer to the configuration
+ * @status: a bit-mask of transport status flags
  * @dev - pointer to struct device * that represents the device
  * @hw_id: a u32 with the ID of the device / subdevice.
  *	Set during transport allocation.
@@ -499,6 +518,7 @@ struct iwl_trans {
 	struct iwl_op_mode *op_mode;
 	const struct iwl_cfg *cfg;
 	enum iwl_trans_state state;
+	unsigned long status;
 
 	struct device *dev;
 	u32 hw_rev;
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 051268c..8a2de33 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -256,7 +256,6 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @hw_base: pci hardware address support
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_write_waitq: wait queue for uCode load
- * @status - transport specific status flags
  * @cmd_queue - command queue number
  * @rx_buf_size_8k: 8 kB RX buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
@@ -296,7 +295,6 @@ struct iwl_trans_pcie {
 	wait_queue_head_t ucode_write_waitq;
 	wait_queue_head_t wait_command_queue;
 
-	unsigned long status;
 	u8 cmd_queue;
 	u8 cmd_fifo;
 	u8 n_no_reclaim_cmds;
@@ -315,24 +313,6 @@ struct iwl_trans_pcie {
 	spinlock_t reg_lock;
 };
 
-/**
- * enum iwl_pcie_status: status of the PCIe transport
- * @STATUS_HCMD_ACTIVE: a SYNC command is being processed
- * @STATUS_DEVICE_ENABLED: APM is enabled
- * @STATUS_TPOWER_PMI: the device might be asleep (need to wake it up)
- * @STATUS_INT_ENABLED: interrupts are enabled
- * @STATUS_RFKILL: the HW RFkill switch is in KILL position
- * @STATUS_FW_ERROR: the fw is in error state
- */
-enum iwl_pcie_status {
-	STATUS_HCMD_ACTIVE,
-	STATUS_DEVICE_ENABLED,
-	STATUS_TPOWER_PMI,
-	STATUS_INT_ENABLED,
-	STATUS_RFKILL,
-	STATUS_FW_ERROR,
-};
-
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
 	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
 
@@ -399,8 +379,7 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans);
 ******************************************************/
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
+	clear_bit(STATUS_INT_ENABLED, &trans->status);
 
 	/* disable interrupts from uCode/NIC to host */
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
@@ -417,7 +396,7 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &trans_pcie->status);
+	set_bit(STATUS_INT_ENABLED, &trans->status);
 	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
@@ -479,9 +458,7 @@ static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 
 static inline void iwl_nic_error(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	set_bit(STATUS_FW_ERROR, &trans_pcie->status);
+	set_bit(STATUS_FW_ERROR, &trans->status);
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 1d6bf7b..bbbb3ca 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -162,11 +162,8 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 		rxq->write_actual = (rxq->write & ~0x7);
 		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 	} else {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(trans);
-
 		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_TPOWER_PMI, &trans_pcie->status)) {
+		if (test_bit(STATUS_TPOWER_PMI, &trans->status)) {
 			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
@@ -222,7 +219,7 @@ static void iwl_pcie_rxq_restock(struct iwl_trans *trans)
 	 * stopped, we cannot access the HW (in particular not prph).
 	 * So don't try to restock if the APM has been already stopped.
 	 */
-	if (!test_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status))
+	if (!test_bit(STATUS_DEVICE_ENABLED, &trans->status))
 		return;
 
 	spin_lock_irqsave(&rxq->lock, flags);
@@ -791,7 +788,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 			     APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
 			    APMG_PS_CTRL_VAL_RESET_REQ))) {
-		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		iwl_op_mode_wimax_active(trans->op_mode);
 		wake_up(&trans_pcie->wait_command_queue);
 		return;
@@ -801,8 +798,8 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	iwl_dump_fh(trans, NULL);
 
 	/* set the ERROR bit before we wake up the caller */
-	set_bit(STATUS_FW_ERROR, &trans_pcie->status);
-	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+	set_bit(STATUS_FW_ERROR, &trans->status);
+	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	wake_up(&trans_pcie->wait_command_queue);
 
 	local_bh_disable();
@@ -894,14 +891,14 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 		if (hw_rfkill) {
-			set_bit(STATUS_RFKILL, &trans_pcie->status);
-			if (test_and_clear_bit(STATUS_HCMD_ACTIVE,
-					       &trans_pcie->status))
+			set_bit(STATUS_RFKILL, &trans->status);
+			if (test_and_clear_bit(STATUS_SYNC_HCMD_ACTIVE,
+					       &trans->status))
 				IWL_DEBUG_RF_KILL(trans,
 						  "Rfkill while SYNC HCMD in flight\n");
 			wake_up(&trans_pcie->wait_command_queue);
 		} else {
-			clear_bit(STATUS_RFKILL, &trans_pcie->status);
+			clear_bit(STATUS_RFKILL, &trans->status);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -1005,7 +1002,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status))
+	if (test_bit(STATUS_INT_ENABLED, &trans->status))
 		iwl_enable_interrupts(trans);
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
@@ -1160,7 +1157,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 		 * the handler can be scheduled because of a previous
 		 * interrupt.
 		 */
-		if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
+		if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
 		    !trans_pcie->inta)
 			iwl_enable_interrupts(trans);
 		return IRQ_NONE;
@@ -1290,7 +1287,7 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
+	if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 43eed4d..28c62a5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -150,7 +150,6 @@ static void iwl_pcie_apm_config(struct iwl_trans *trans)
  */
 static int iwl_pcie_apm_init(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret = 0;
 	IWL_DEBUG_INFO(trans, "Init card's basic functions\n");
 
@@ -223,7 +222,7 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	/* Clear the interrupt in APMG if the NIC is in RFKILL */
 	iwl_write_prph(trans, APMG_RTC_INT_STT_REG, APMG_RTC_INT_STT_RFKILL);
 
-	set_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
+	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
 out:
 	return ret;
@@ -249,10 +248,9 @@ static int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 
 static void iwl_pcie_apm_stop(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	IWL_DEBUG_INFO(trans, "Stop card, put in low power state\n");
 
-	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
+	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
 	/* Stop device's DMA activity */
 	iwl_pcie_apm_stop_master(trans);
@@ -582,7 +580,6 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw, bool run_in_rfkill)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	bool hw_rfkill;
 
@@ -592,16 +589,16 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return -EIO;
 	}
 
-	clear_bit(STATUS_FW_ERROR, &trans_pcie->status);
+	clear_bit(STATUS_FW_ERROR, &trans->status);
 
 	iwl_enable_rfkill_int(trans);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans_pcie->status);
+		set_bit(STATUS_RFKILL, &trans->status);
 	else
-		clear_bit(STATUS_RFKILL, &trans_pcie->status);
+		clear_bit(STATUS_RFKILL, &trans->status);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 	if (hw_rfkill && !run_in_rfkill)
 		return -ERFKILL;
@@ -658,7 +655,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 * restart. So don't process again if the device is
 	 * already dead.
 	 */
-	if (test_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status)) {
+	if (test_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
 
@@ -686,11 +683,11 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* clear all status bits */
-	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
-	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
-	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
-	clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
-	clear_bit(STATUS_RFKILL, &trans_pcie->status);
+	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
+	clear_bit(STATUS_INT_ENABLED, &trans->status);
+	clear_bit(STATUS_DEVICE_ENABLED, &trans->status);
+	clear_bit(STATUS_TPOWER_PMI, &trans->status);
+	clear_bit(STATUS_RFKILL, &trans->status);
 
 	/*
 	 * Even if we stop the HW, we still want the RF kill
@@ -706,9 +703,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 */
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans_pcie->status);
+		set_bit(STATUS_RFKILL, &trans->status);
 	else
-		clear_bit(STATUS_RFKILL, &trans_pcie->status);
+		clear_bit(STATUS_RFKILL, &trans->status);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 }
 
@@ -794,7 +791,6 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 	int err;
 
@@ -816,9 +812,9 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	if (hw_rfkill)
-		set_bit(STATUS_RFKILL, &trans_pcie->status);
+		set_bit(STATUS_RFKILL, &trans->status);
 	else
-		clear_bit(STATUS_RFKILL, &trans_pcie->status);
+		clear_bit(STATUS_RFKILL, &trans->status);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
 	return 0;
@@ -924,12 +920,10 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 
 static void iwl_trans_pcie_set_pmi(struct iwl_trans *trans, bool state)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
 	if (state)
-		set_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
+		set_bit(STATUS_TPOWER_PMI, &trans->status);
 	else
-		clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
+		clear_bit(STATUS_TPOWER_PMI, &trans->status);
 }
 
 static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index a4ef5cc..a36884e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -300,10 +300,8 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(trans);
 		/* if we're trying to save power */
-		if (test_bit(STATUS_TPOWER_PMI, &trans_pcie->status)) {
+		if (test_bit(STATUS_TPOWER_PMI, &trans->status)) {
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
@@ -1449,12 +1447,12 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	iwl_pcie_cmdq_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
-		if (!test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
+		if (!test_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status)) {
 			IWL_WARN(trans,
 				 "HCMD_ACTIVE already clear for command %s\n",
 				 get_cmd_string(trans_pcie, cmd->hdr.cmd));
 		}
-		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(trans_pcie, cmd->hdr.cmd));
 		wake_up(&trans_pcie->wait_command_queue);
@@ -1499,8 +1497,8 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 		       get_cmd_string(trans_pcie, cmd->id));
 
-	if (WARN(test_and_set_bit(STATUS_HCMD_ACTIVE,
-				  &trans_pcie->status),
+	if (WARN(test_and_set_bit(STATUS_SYNC_HCMD_ACTIVE,
+				  &trans->status),
 		 "Command %s: a command is already active!\n",
 		 get_cmd_string(trans_pcie, cmd->id)))
 		return -EIO;
@@ -1511,7 +1509,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	cmd_idx = iwl_pcie_enqueue_hcmd(trans, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		IWL_ERR(trans,
 			"Error sending %s: enqueue_hcmd failed: %d\n",
 			get_cmd_string(trans_pcie, cmd->id), ret);
@@ -1523,8 +1521,8 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 
 		timeout -= COMMAND_POKE_TIMEOUT;
 		ret = wait_event_timeout(trans_pcie->wait_command_queue,
-					 !test_bit(STATUS_HCMD_ACTIVE,
-						   &trans_pcie->status),
+					 !test_bit(STATUS_SYNC_HCMD_ACTIVE,
+						   &trans->status),
 					 COMMAND_POKE_TIMEOUT);
 		if (ret)
 			break;
@@ -1552,7 +1550,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 		IWL_ERR(trans, "Current CMD queue read_ptr %d write_ptr %d\n",
 			q->read_ptr, q->write_ptr);
 
-		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+		clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(trans_pcie, cmd->id));
 		ret = -ETIMEDOUT;
@@ -1562,7 +1560,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 		goto cancel;
 	}
 
-	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status)) {
+	if (test_bit(STATUS_FW_ERROR, &trans->status)) {
 		IWL_ERR(trans, "FW error in SYNC CMD %s\n",
 			get_cmd_string(trans_pcie, cmd->id));
 		dump_stack();
@@ -1571,7 +1569,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	}
 
 	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
-	    test_bit(STATUS_RFKILL, &trans_pcie->status)) {
+	    test_bit(STATUS_RFKILL, &trans->status)) {
 		IWL_DEBUG_RF_KILL(trans, "RFKILL in SYNC CMD... no rsp\n");
 		ret = -ERFKILL;
 		goto cancel;
@@ -1608,13 +1606,11 @@ cancel:
 
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status))
+	if (test_bit(STATUS_FW_ERROR, &trans->status))
 		return -EIO;
 
 	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
-	    test_bit(STATUS_RFKILL, &trans_pcie->status)) {
+	    test_bit(STATUS_RFKILL, &trans->status)) {
 		IWL_DEBUG_RF_KILL(trans, "Dropping CMD 0x%x: RF KILL\n",
 				  cmd->id);
 		return -ERFKILL;
-- 
1.7.9.5

