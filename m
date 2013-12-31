Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35111 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3LaRQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:16 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so5546066eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/28] iwlwifi: pcie: use don't disable interrupt when irq_lock is taken
Date: Tue, 31 Dec 2013 19:15:39 +0200
Message-Id: <1388510157-23345-10-git-send-email-egrumbach@gmail.com> (sfid-20131231_181626_194503_3DF53185)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since we don't take this lock in the primary interrupt
handler, there is no pointin disabling the interrupt
in the critical section protected by trans_pcie->irq_lock.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c    |   28 ++++++++++++----------------
 drivers/net/wireless/iwlwifi/pcie/trans.c |   23 ++++++++++-------------
 drivers/net/wireless/iwlwifi/pcie/tx.c    |   10 ++++------
 3 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 2e11512..7ab510e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -379,13 +379,12 @@ static void iwl_pcie_rxq_free_rbs(struct iwl_trans *trans)
 static void iwl_pcie_rx_replenish(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_pcie_rxq_restock(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 static void iwl_pcie_rx_replenish_now(struct iwl_trans *trans)
@@ -541,10 +540,10 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 	iwl_pcie_rx_hw_init(trans, rxq);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	rxq->need_update = 1;
 	iwl_pcie_rxq_inc_wr_ptr(trans, rxq);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	return 0;
 }
@@ -895,12 +894,11 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta = 0;
 	u32 handled = 0;
-	unsigned long flags;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
@@ -937,7 +935,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		 */
 		if (test_bit(STATUS_INT_ENABLED, &trans->status))
 			iwl_enable_interrupts(trans);
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		spin_unlock(&trans_pcie->irq_lock);
 		lock_map_release(&trans->sync_cmd_lockdep_map);
 		return IRQ_NONE;
 	}
@@ -948,7 +946,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		 * already raised an interrupt.
 		 */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		spin_unlock(&trans_pcie->irq_lock);
 		goto out;
 	}
 
@@ -969,7 +967,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 			      inta, iwl_read32(trans, CSR_INT_MASK));
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
@@ -1194,12 +1192,11 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 val;
-	unsigned long flags;
 
 	if (!trans_pcie->ict_tbl)
 		return;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
 
 	memset(trans_pcie->ict_tbl, 0, ICT_SIZE);
@@ -1216,18 +1213,17 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 	trans_pcie->ict_index = 0;
 	iwl_write32(trans, CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 /* Device is going down disable ict interrupt usage */
 void iwl_pcie_disable_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	trans_pcie->use_ict = false;
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 }
 
 irqreturn_t iwl_pcie_isr(int irq, void *data)
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 7210507..9a07cf3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -271,13 +271,12 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans)
 static int iwl_pcie_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	/* nic_init */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_pcie_apm_init(trans);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_set_pwr(trans, false);
 
@@ -635,13 +634,12 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 	bool hw_rfkill;
 
 	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* device going down, Stop using ICT table */
 	iwl_pcie_disable_ict(trans);
@@ -673,9 +671,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * Clean again the interrupt here
 	 */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
@@ -821,18 +819,17 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 static void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 
 	/* disable interrupts - don't enable HW RF kill interrupt */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_apm_stop(trans);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	iwl_pcie_disable_ict(trans);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8df2478..b49a1853 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -737,10 +737,9 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ch, txq_id, ret;
-	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	iwl_pcie_txq_set_sched(trans, 0);
 
@@ -757,7 +756,7 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 				iwl_read_direct32(trans,
 						  FH_TSSR_TX_STATUS_REG));
 	}
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	if (!trans_pcie->txq) {
 		IWL_WARN(trans,
@@ -865,7 +864,6 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	int txq_id, slots_num;
-	unsigned long flags;
 	bool alloc = false;
 
 	if (!trans_pcie->txq) {
@@ -875,7 +873,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		alloc = true;
 	}
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+	spin_lock(&trans_pcie->irq_lock);
 
 	/* Turn off all Tx DMA fifos */
 	iwl_write_prph(trans, SCD_TXFACT, 0);
@@ -884,7 +882,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
 			   trans_pcie->kw.dma >> 4);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	spin_unlock(&trans_pcie->irq_lock);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
-- 
1.7.9.5

