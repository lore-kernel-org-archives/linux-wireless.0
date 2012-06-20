Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2FTHiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/12] iwlwifi: don't disable interrupt while starting tx
Date: Wed, 20 Jun 2012 09:38:08 +0200
Message-Id: <1340177894-12992-7-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093834_593376_61C3A36C)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is really not needed, we already have a lock inside
the accesses to the prph.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index e20880a..42f369d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1046,15 +1046,12 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 
 /*
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under the irq lock and with MAC access
  */
 static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 {
 	struct iwl_trans_pcie __maybe_unused *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	lockdep_assert_held(&trans_pcie->irq_lock);
-
 	iwl_write_prph(trans, SCD_TXFACT, mask);
 }
 
@@ -1062,12 +1059,9 @@ static void iwl_tx_start(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
-	unsigned long flags;
 	int i, chan;
 	u32 reg_val;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
 	/* make sure all queue are not stopped/used */
 	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
 	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
@@ -1118,8 +1112,6 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-
 	/* Enable L1-Active */
 	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
 			    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-- 
1.7.10

