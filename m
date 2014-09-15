Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38399 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:22 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so3285467wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/28] iwlwifi: trans: don't configure the set_active in SCD for dvm
Date: Mon, 15 Sep 2014 08:12:43 +0300
Message-Id: <1410757980-2138-11-git-send-email-egrumbach@gmail.com> (sfid-20140915_071326_648687_01AF1836)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This configuration is not needed for dvm, and it actually
broke it.

Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 1 +
 drivers/net/wireless/iwlwifi/pcie/internal.h | 2 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 6 ++++--
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c89985a..eb31648 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -377,6 +377,7 @@ enum iwl_trans_status {
  *	if unset 4k will be the RX buffer size
  * @bc_table_dword: set to true if the BC table expects the byte count to be
  *	in DWORD (as opposed to bytes)
+ * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @queue_watchdog_timeout: time (in ms) after which queues
  *	are considered stuck and will trigger device restart
  * @command_names: array of command names, must be 256 entries
@@ -392,6 +393,7 @@ struct iwl_trans_config {
 
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
+	bool scd_set_active;
 	unsigned int queue_watchdog_timeout;
 	const char *const *command_names;
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 87f278c..5d8c562 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -460,6 +460,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	trans_cfg.cmd_queue = IWL_MVM_CMD_QUEUE;
 	trans_cfg.cmd_fifo = IWL_MVM_TX_FIFO_CMD;
+	trans_cfg.scd_set_active = true;
 
 	snprintf(mvm->hw->wiphy->fw_version,
 		 sizeof(mvm->hw->wiphy->fw_version),
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index a4fedc4..1aea6b6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -257,6 +257,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @cmd_queue - command queue number
  * @rx_buf_size_8k: 8 kB RX buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
+ * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @rx_page_order: page order for receive buffer size
  * @wd_timeout: queue watchdog timeout (jiffies)
  * @reg_lock: protect hw register access
@@ -306,6 +307,7 @@ struct iwl_trans_pcie {
 
 	bool rx_buf_size_8k;
 	bool bc_table_dword;
+	bool scd_set_active;
 	u32 rx_page_order;
 
 	const char *const *command_names;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 3076e0e..4add964 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1171,6 +1171,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 	trans_pcie->command_names = trans_cfg->command_names;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
+	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
 
 	/* Initialize NAPI here - it should be before registering to mac80211
 	 * in the opmode but after the HW struct is allocated.
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index a6336b4..35fe38e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1080,7 +1080,8 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 		fifo = cfg->fifo;
 
 		/* Disable the scheduler prior configuring the cmd queue */
-		if (txq_id == trans_pcie->cmd_queue)
+		if (txq_id == trans_pcie->cmd_queue &&
+		    trans_pcie->scd_set_active)
 			iwl_scd_enable_set_active(trans, 0);
 
 		/* Stop this Tx queue before configuring it */
@@ -1142,7 +1143,8 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			       SCD_QUEUE_STTS_REG_MSK);
 
 		/* enable the scheduler for this queue (only) */
-		if (txq_id == trans_pcie->cmd_queue)
+		if (txq_id == trans_pcie->cmd_queue &&
+		    trans_pcie->scd_set_active)
 			iwl_scd_enable_set_active(trans, BIT(txq_id));
 	}
 
-- 
1.9.1

