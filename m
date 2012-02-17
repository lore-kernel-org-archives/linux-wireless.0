Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2BQUXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/26] iwlwifi: give PCIe its own lock
Date: Fri, 17 Feb 2012 11:13:34 -0800
Message-Id: <1329506034-1394-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212447_836667_EF686885)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using a global lock, the PCIe transport
can use an own lock for its IRQ. This will make it
possible to not disable IRQs for the shared lock.
The lock is currently used throughout the code but
this can be improved even further by splitting up
the locking for the queues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   29 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   37 ++++++++++++--------
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 561865f..8c30fea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -230,6 +230,7 @@ struct iwl_trans_pcie {
 	struct tasklet_struct irq_tasklet;
 	struct isr_statistics isr_stats;
 
+	spinlock_t irq_lock;
 	u32 inta_mask;
 	u32 scd_base_addr;
 	struct iwl_dma_ptr scd_bc_tbls;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 1b11cfe..e063426 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -331,13 +331,14 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 
 void iwlagn_rx_replenish(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 
 	iwlagn_rx_allocate(trans, GFP_KERNEL);
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwlagn_rx_queue_restock(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
 static void iwlagn_rx_replenish_now(struct iwl_trans *trans)
@@ -943,7 +944,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
@@ -973,7 +974,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
 	trans_pcie->inta = 0;
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
@@ -1226,7 +1227,7 @@ void iwl_reset_ict(struct iwl_trans *trans)
 	if (!trans_pcie->ict_tbl)
 		return;
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_disable_interrupts(trans);
 
 	memset(trans_pcie->ict_tbl, 0, ICT_SIZE);
@@ -1243,7 +1244,7 @@ void iwl_reset_ict(struct iwl_trans *trans)
 	trans_pcie->ict_index = 0;
 	iwl_write32(trans, CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
 /* Device is going down disable ict interrupt usage */
@@ -1254,9 +1255,9 @@ void iwl_disable_ict(struct iwl_trans *trans)
 
 	unsigned long flags;
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	trans_pcie->use_ict = false;
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
 static irqreturn_t iwl_isr(int irq, void *data)
@@ -1275,7 +1276,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
@@ -1319,7 +1320,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		iwl_enable_interrupts(trans);
 
  unplugged:
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -1329,7 +1330,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		!trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return IRQ_NONE;
 }
 
@@ -1363,7 +1364,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 
 	trace_iwlwifi_dev_irq(priv(trans));
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 * back-to-back ISRs and sporadic interrupts from our NIC.
@@ -1434,7 +1435,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 		iwl_enable_interrupts(trans);
 	}
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return IRQ_HANDLED;
 
  none:
@@ -1445,6 +1446,6 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return IRQ_NONE;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 08e0a7d..a3cebd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -492,7 +492,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Stop this Tx queue before configuring it */
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
@@ -532,7 +532,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 	trans_pcie->txq[txq_id].sta_id = sta_id;
 	trans_pcie->txq[txq_id].tid = tid;
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index e8d1dbf..176063c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -219,10 +219,10 @@ static int iwl_rx_init(struct iwl_trans *trans)
 
 	iwl_trans_rx_hw_init(trans, rxq);
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	rxq->need_update = 1;
 	iwl_rx_queue_update_write_ptr(trans, rxq);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	return 0;
 }
@@ -585,7 +585,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 		alloc = true;
 	}
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Turn off all Tx DMA fifos */
 	iwl_write_prph(trans, SCD_TXFACT, 0);
@@ -594,7 +594,7 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
 			   trans_pcie->kw.dma >> 4);
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
@@ -803,17 +803,18 @@ static void iwl_apm_stop(struct iwl_trans *trans)
 
 static int iwl_nic_init(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
 
 	/* nic_init */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_apm_init(trans);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING,
 		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	iwl_set_pwr_vmain(trans);
 
@@ -1078,10 +1079,15 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans, struct fw_img *fw)
 
 /*
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under priv->shrd->lock and mac access
+ * must be called under the irq lock and with MAC access
  */
 static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 {
+	struct iwl_trans_pcie __maybe_unused *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	lockdep_assert_held(&trans_pcie->irq_lock);
+
 	iwl_write_prph(trans, SCD_TXFACT, mask);
 }
 
@@ -1095,7 +1101,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	int i, chan;
 	u32 reg_val;
 
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	trans_pcie->scd_base_addr =
 		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
@@ -1191,7 +1197,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 					      fifo, 0);
 	}
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Enable L1-Active */
 	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
@@ -1214,7 +1220,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	iwl_trans_txq_set_sched(trans, 0);
 
@@ -1230,7 +1236,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 			    iwl_read_direct32(trans,
 					      FH_TSSR_TX_STATUS_REG));
 	}
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	if (!trans_pcie->txq) {
 		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
@@ -1250,9 +1256,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(trans);
@@ -1285,9 +1291,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * Clean again the interrupt here
 	 */
-	spin_lock_irqsave(&trans->shrd->lock, flags);
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 	iwl_disable_interrupts(trans);
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* wait to make sure we flush pending tasklet*/
 	synchronize_irq(trans->irq);
@@ -2261,6 +2267,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->shrd = shrd;
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans->hcmd_lock);
+	spin_lock_init(&trans_pcie->irq_lock);
 
 	/* W/A - seems to solve weird behavior. We need to remove this if we
 	 * don't want to stay in L1 all the time. This wastes a lot of power */
-- 
1.7.0.4

