Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab2KIUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/13] iwlwifi: handle RFKILL logic in the transport layer
Date: Fri,  9 Nov 2012 21:08:00 +0100
Message-Id: <1352491692-28994-2-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210744_997595_0AFFA284)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

No HCMD can be sent while RFKILL is asserted. If a SYNC
command is running while RFKILL is asserted the fw will
silently discard it. This means that the driver needs to
wake the process that sleeps on the CMD_SYNC.

Since the RFKILL interrupt is handled in the transport layer
and the code that sleeps in CMD_SYNC is also in the transport
layer, all this logic can be handled there.
This simplifies the work of the op_mode.

So the transport layer will now return -ERFKILL when a CMD
is sent and RFKILL is asserted. This will be the case even
when the CMD is SYNC. The transport layer will return
-ERFKILL straight away.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c      |  2 --
 drivers/net/wireless/iwlwifi/dvm/rx.c        |  2 --
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  7 +++----
 drivers/net/wireless/iwlwifi/pcie/internal.h | 13 +++++++++----
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 20 ++++++++++++++++----
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  3 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 16 ++++++++++++++--
 7 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 475df45..2b50d11 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1926,8 +1926,6 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->status);
 
-	wake_up(&priv->trans->wait_command_queue);
-
 	if (!ondemand) {
 		/*
 		 * If firmware keep reloading, then it indicate something
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 5a9c325..9a8d502 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -631,8 +631,6 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
-	else
-		wake_up(&priv->trans->wait_command_queue);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 47bbe39..b065d48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -362,7 +362,9 @@ struct iwl_trans;
  * @wowlan_suspend: put the device into the correct mode for WoWLAN during
  *	suspend. This is optional, if not implemented WoWLAN will not be
  *	supported. This callback may sleep.
- * @send_cmd:send a host command
+ * @send_cmd:send a host command. Must return -ERFKILL if RFkill is asserted.
+ *	If RFkill is asserted in the middle of a SYNC host command, it must
+ *	return -ERFKILL straight away.
  *	May sleep only if CMD_SYNC is set
  * @tx: send an skb
  *	Must be atomic
@@ -445,7 +447,6 @@ enum iwl_trans_state {
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
- * @wait_command_queue: the wait_queue for SYNC host commands
  * @dev_cmd_pool: pool for Tx cmd allocation - for internal use only.
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
  * @dev_cmd_headroom: room needed for the transport's private use before the
@@ -472,8 +473,6 @@ struct iwl_trans {
 
 	bool pm_support;
 
-	wait_queue_head_t wait_command_queue;
-
 	/* The following fields are internal only */
 	struct kmem_cache *dev_cmd_pool;
 	size_t dev_cmd_headroom;
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index ae0f87e..847ef1e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -270,6 +270,8 @@ struct iwl_trans_pcie {
 
 	bool ucode_write_complete;
 	wait_queue_head_t ucode_write_waitq;
+	wait_queue_head_t wait_command_queue;
+
 	unsigned long status;
 	u8 cmd_queue;
 	u8 cmd_fifo;
@@ -288,10 +290,13 @@ struct iwl_trans_pcie {
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
 ******************************************************/
-#define STATUS_HCMD_ACTIVE	0
-#define STATUS_DEVICE_ENABLED	1
-#define STATUS_TPOWER_PMI	2
-#define STATUS_INT_ENABLED	3
+enum {
+	STATUS_HCMD_ACTIVE,
+	STATUS_DEVICE_ENABLED,
+	STATUS_TPOWER_PMI,
+	STATUS_INT_ENABLED,
+	STATUS_RFKILL,
+};
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
 	((struct iwl_trans_pcie *) ((_iwl_trans)->trans_specific))
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 3f03f6e..50c9147 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -568,24 +568,26 @@ static void iwl_rx_handle(struct iwl_trans *trans)
  */
 static void iwl_irq_handle_error(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (trans->cfg->internal_wimax_coex &&
 	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
 			     APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
 			    APMG_PS_CTRL_VAL_RESET_REQ))) {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(trans);
-
 		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
 		iwl_op_mode_wimax_active(trans->op_mode);
-		wake_up(&trans->wait_command_queue);
+		wake_up(&trans_pcie->wait_command_queue);
 		return;
 	}
 
 	iwl_dump_csr(trans);
 	iwl_dump_fh(trans, NULL);
 
+	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+	wake_up(&trans_pcie->wait_command_queue);
+
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
@@ -679,6 +681,16 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		isr_stats->rfkill++;
 
 		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+		if (hw_rfkill) {
+			set_bit(STATUS_RFKILL, &trans_pcie->status);
+			if (test_and_clear_bit(STATUS_HCMD_ACTIVE,
+					       &trans_pcie->status))
+				IWL_DEBUG_RF_KILL(trans,
+						  "Rfkill while SYNC HCMD in flight\n");
+			wake_up(&trans_pcie->wait_command_queue);
+		} else {
+			clear_bit(STATUS_RFKILL, &trans_pcie->status);
+		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index b8a155a..288d229 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1246,6 +1246,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	clear_bit(STATUS_INT_ENABLED, &trans_pcie->status);
 	clear_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status);
 	clear_bit(STATUS_TPOWER_PMI, &trans_pcie->status);
+	clear_bit(STATUS_RFKILL, &trans_pcie->status);
 }
 
 static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
@@ -2206,7 +2207,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	}
 
 	/* Initialize the wait queue for commands */
-	init_waitqueue_head(&trans->wait_command_queue);
+	init_waitqueue_head(&trans_pcie->wait_command_queue);
 	spin_lock_init(&trans->reg_lock);
 
 	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 9cb30ae..ae73bd3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -827,7 +827,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       trans_pcie_get_cmd_string(trans_pcie,
 							 cmd->hdr.cmd));
-		wake_up(&trans->wait_command_queue);
+		wake_up(&trans_pcie->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -886,7 +886,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return ret;
 	}
 
-	ret = wait_event_timeout(trans->wait_command_queue,
+	ret = wait_event_timeout(trans_pcie->wait_command_queue,
 				 !test_bit(STATUS_HCMD_ACTIVE,
 					   &trans_pcie->status),
 				 HOST_COMPLETE_TIMEOUT);
@@ -915,6 +915,12 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		}
 	}
 
+	if (test_bit(STATUS_RFKILL, &trans_pcie->status)) {
+		IWL_DEBUG_RF_KILL(trans, "RFKILL in SYNC CMD... no rsp\n");
+		ret = -ERFKILL;
+		goto cancel;
+	}
+
 	if ((cmd->flags & CMD_WANT_SKB) && !cmd->resp_pkt) {
 		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
 			trans_pcie_get_cmd_string(trans_pcie, cmd->id));
@@ -946,9 +952,15 @@ cancel:
 
 int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (test_bit(STATUS_RFKILL, &trans_pcie->status))
+		return -ERFKILL;
+
 	if (cmd->flags & CMD_ASYNC)
 		return iwl_send_cmd_async(trans, cmd);
 
+	/* We still can fail on RFKILL that can be asserted while we wait */
 	return iwl_send_cmd_sync(trans, cmd);
 }
 
-- 
1.8.0

