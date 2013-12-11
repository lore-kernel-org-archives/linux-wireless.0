Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab3LKIfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 07/10] iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
Date: Wed, 11 Dec 2013 10:33:43 +0200
Message-Id: <1386750826-25219-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093514_337175_0D784696)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are meant to return an interrupt cause and
not an irqreturn_t.

The only drawback is that we will return IRQ_NONE instead
of IRQ_HANDLED when error occurs - but that shouldn't be
an issue.

Change-Id: I2de5c0d39fafb2a00429c314a2a5f0336347233d
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 58d3f64..3ddf012 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -807,7 +807,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	wake_up(&trans_pcie->wait_command_queue);
 }
 
-static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
+static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
@@ -841,14 +841,14 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 		if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
 		    !trans_pcie->inta)
 			iwl_enable_interrupts(trans);
-		return IRQ_NONE;
+		return trans_pcie->inta;
 	}
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		return IRQ_HANDLED;
+		return trans_pcie->inta;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -859,7 +859,7 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 
 	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	return IRQ_WAKE_THREAD;
+	return trans_pcie->inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -875,10 +875,9 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
  * the interrupt we need to service, driver will set the entries back to 0 and
  * set index.
  */
-static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
+static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	irqreturn_t ret;
 	u32 inta;
 	u32 val = 0;
 	u32 read;
@@ -938,9 +937,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
+		return trans_pcie->inta;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
@@ -950,7 +947,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	return ret;
+	return trans_pcie->inta;
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
@@ -961,7 +958,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
-	irqreturn_t ret;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
@@ -972,13 +968,13 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * use legacy interrupt.
 	 */
 	if (likely(trans_pcie->use_ict))
-		ret = iwl_pcie_int_cause_ict(trans);
+		inta = iwl_pcie_int_cause_ict(trans);
 	else
-		ret = iwl_pcie_int_cause_non_ict(trans);
+		inta = iwl_pcie_int_cause_non_ict(trans);
 
-	if (ret != IRQ_WAKE_THREAD) {
+	if (!inta) {
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-		return ret;
+		return IRQ_NONE;
 	}
 
 	/* Ack/clear/reset pending uCode interrupts.
@@ -992,10 +988,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(trans, CSR_INT,
-		    trans_pcie->inta | ~trans_pcie->inta_mask);
-
-	inta = trans_pcie->inta;
+	iwl_write32(trans, CSR_INT, inta | ~trans_pcie->inta_mask);
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
-- 
1.8.3.2

