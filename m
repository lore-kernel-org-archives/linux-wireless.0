Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2FFNXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/29] iwlwifi: first config the SCD queues, then activate them
Date: Wed,  6 Jun 2012 15:21:57 +0200
Message-Id: <1338988930-11561-16-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152328_850822_92E684B8)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The DMA channels of the FH should be activated after the
configuration of the SCD queues too.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   36 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a267fda..2d33015 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1030,6 +1030,10 @@ static void iwl_tx_start(struct iwl_trans *trans)
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
+	/* make sure all queue are not stopped/used */
+	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
 	trans_pcie->scd_base_addr =
 		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
 	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
@@ -1050,17 +1054,6 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
-	/* Enable DMA channel */
-	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
-
-	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
-
 	iwl_write_prph(trans, SCD_QUEUECHAIN_SEL,
 		       SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie));
 	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
@@ -1082,15 +1075,8 @@ static void iwl_tx_start(struct iwl_trans *trans)
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	/* Activate all Tx DMA/FIFO channels */
-	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
-
 	iwl_trans_set_wr_ptrs(trans, trans_pcie->cmd_queue, 0);
 
-	/* make sure all queue are not stopped/used */
-	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
-	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
-
 	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
 		int fifo = trans_pcie->setup_q_to_fifo[i];
 
@@ -1100,6 +1086,20 @@ static void iwl_tx_start(struct iwl_trans *trans)
 					      fifo, true);
 	}
 
+	/* Activate all Tx DMA/FIFO channels */
+	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
+
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Enable L1-Active */
-- 
1.7.10

