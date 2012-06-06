Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFNX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/29] iwlwifi: SCD_INT_MSK is obsolete - don't update it
Date: Wed,  6 Jun 2012 15:21:56 +0200
Message-Id: <1338988930-11561-15-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152332_742065_2CC62854)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The scheduler can issue an interrupt when moving the read
pointer. To get this interrupt, the driver needs to
configure what queue can issue an interrupt when its read
pointer moves in the scheduler: this is the SCD_INT_MSK.
The driver also needs to enable the interrupt in
CSR_INT_MASK (bit CSR_INT_BIT_SCD).

Since we don't enable the scheduler interrupt in
CSR_INT_MASK, there is no point in requesting an interrupt
from the scheduler: it will be masked anyway. So don't
configure the scheduler to issue interrupts at all.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    3 ---
 drivers/net/wireless/iwlwifi/pcie/tx.c    |    4 ----
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a19ce40..a267fda 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1082,9 +1082,6 @@ static void iwl_tx_start(struct iwl_trans *trans)
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	iwl_write_prph(trans, SCD_INTERRUPT_MASK,
-		       IWL_MASK(0, trans->cfg->base_params->num_of_queues));
-
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 583451c..8a331a9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -480,8 +480,6 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
 			((frame_limit << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(trans, SCD_INTERRUPT_MASK, (1 << txq_id));
-
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
 				      fifo, true);
@@ -506,8 +504,6 @@ void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int txq_id)
 	trans_pcie->txq[txq_id].q.write_ptr = 0;
 	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
-	iwl_clear_bits_prph(trans, SCD_INTERRUPT_MASK, BIT(txq_id));
-
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
 				      0, false);
 }
-- 
1.7.10

