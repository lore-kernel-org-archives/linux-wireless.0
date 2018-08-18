Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42208 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbeHRLfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:35:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:49 +0300
Message-Id: <20180818082750.28717-16-luca@coelho.fi> (sfid-20180818_102838_949285_F9A28A09)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 15/16] iwlwifi: pcie: allow using tx init for other queues but the command queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

We would like to allow using tx init code for other queues but
the command queue - for newer devices.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  3 ++-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 23 ++++++++++---------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 0127386de6c6..da6d367de76e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -640,7 +640,8 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans);
 * TX / HCMD
 ******************************************************/
 int iwl_pcie_tx_init(struct iwl_trans *trans);
-int iwl_pcie_gen2_tx_init(struct iwl_trans *trans);
+int iwl_pcie_gen2_tx_init(struct iwl_trans *trans, int txq_id,
+			  int queue_size);
 void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr);
 int iwl_pcie_tx_stop(struct iwl_trans *trans);
 void iwl_pcie_tx_free(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 2bc67219ed3e..3e5c732a89db 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -265,7 +265,7 @@ static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 		return -ENOMEM;
 
 	/* Allocate or reset and init all Tx and Command queues */
-	if (iwl_pcie_gen2_tx_init(trans))
+	if (iwl_pcie_gen2_tx_init(trans, trans_pcie->cmd_queue, TFD_CMD_SLOTS))
 		return -ENOMEM;
 
 	/* enable shadow regs in HW */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b99f33ff9123..9ce7b2072613 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1251,30 +1251,31 @@ void iwl_pcie_gen2_tx_free(struct iwl_trans *trans)
 	}
 }
 
-int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
+int iwl_pcie_gen2_tx_init(struct iwl_trans *trans, int txq_id, int queue_size)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *cmd_queue;
-	int txq_id = trans_pcie->cmd_queue, ret;
+	struct iwl_txq *queue;
+	int ret;
 
-	/* alloc and init the command queue */
+	/* alloc and init the tx queue */
 	if (!trans_pcie->txq[txq_id]) {
-		cmd_queue = kzalloc(sizeof(*cmd_queue), GFP_KERNEL);
-		if (!cmd_queue) {
-			IWL_ERR(trans, "Not enough memory for command queue\n");
+		queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+		if (!queue) {
+			IWL_ERR(trans, "Not enough memory for tx queue\n");
 			return -ENOMEM;
 		}
-		trans_pcie->txq[txq_id] = cmd_queue;
-		ret = iwl_pcie_txq_alloc(trans, cmd_queue, TFD_CMD_SLOTS, true);
+		trans_pcie->txq[txq_id] = queue;
+		ret = iwl_pcie_txq_alloc(trans, queue, queue_size, true);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	} else {
-		cmd_queue = trans_pcie->txq[txq_id];
+		queue = trans_pcie->txq[txq_id];
 	}
 
-	ret = iwl_pcie_txq_init(trans, cmd_queue, TFD_CMD_SLOTS, true);
+	ret = iwl_pcie_txq_init(trans, queue, queue_size,
+				(txq_id == trans_pcie->cmd_queue));
 	if (ret) {
 		IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 		goto error;
-- 
2.18.0
