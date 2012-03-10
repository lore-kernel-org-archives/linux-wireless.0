Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2CJU72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlwifi: move wait_command_queue from shared to trans
Date: Sat, 10 Mar 2012 13:00:09 -0800
Message-Id: <1331413215-10027-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220001_752106_51846384)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

This wait queue really belongs to the transport
layer, as it is used for sending synchronous
commands to the HW.

However, only op_mode knows about errors and
exceptional conditions, so make this queue
accessible by the op_mode.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    3 +++
 8 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index cc0227c..44c6f71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -671,7 +671,7 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
-		wake_up(&priv->shrd->wait_command_queue);
+		wake_up(&trans(priv)->wait_command_queue);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5ef1585..66d7446 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -962,8 +962,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
 
-	init_waitqueue_head(&priv->shrd->wait_command_queue);
-
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8b85940..e3eda50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -850,7 +850,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->status);
 
-	wake_up(&priv->shrd->wait_command_queue);
+	wake_up(&trans(priv)->wait_command_queue);
 
 	if (!ondemand) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index cf34087..29d2a85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -376,7 +376,6 @@ struct iwl_cfg {
  * @nic: pointer to the nic data
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
- * @wait_command_queue: the wait_queue for SYNC host commands
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
  * @device_pointers: pointers to ucode event tables
@@ -391,8 +390,6 @@ struct iwl_shared {
 	struct iwl_hw_params hw_params;
 	const struct iwl_fw *fw;
 
-	wait_queue_head_t wait_command_queue;
-
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 8bec0e1..8b1a798 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -684,7 +684,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		 */
 		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up(&trans->shrd->wait_command_queue);
+		wake_up(&trans->wait_command_queue);
 		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 565c664..a66ad9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -928,7 +928,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-		wake_up(&trans->shrd->wait_command_queue);
+		wake_up(&trans->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -992,7 +992,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return ret;
 	}
 
-	ret = wait_event_timeout(trans->shrd->wait_command_queue,
+	ret = wait_event_timeout(trans->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4900dfa..0e8e31a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2327,6 +2327,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 	}
 
+	/* Initialize the wait queue for commands */
+	init_waitqueue_head(&trans->wait_command_queue);
+
 	return trans;
 
 out_pci_release_regions:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 782cb0d..0c81cba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -413,6 +413,7 @@ enum iwl_trans_state {
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @nvm_device_type: indicates OTP or eeprom
  * @pm_support: set to true in start_hw if link pm is supported
+ * @wait_command_queue: the wait_queue for SYNC host commands
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -429,6 +430,8 @@ struct iwl_trans {
 	int    nvm_device_type;
 	bool pm_support;
 
+	wait_queue_head_t wait_command_queue;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
-- 
1.7.0.4

