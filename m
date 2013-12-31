Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50747 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3LaRQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:13 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so5651219ead.36
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/28] iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
Date: Tue, 31 Dec 2013 19:15:36 +0200
Message-Id: <1388510157-23345-7-git-send-email-egrumbach@gmail.com> (sfid-20131231_181621_197989_525D8914)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These functions are meant to return an interrupt cause and
not an irqreturn_t.
We still return IRQ_HANDLED if we had an error and IRQ_NONE
if our device hasn't fired any interrupt.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 58d3f64..a042c4a 100644
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
@@ -841,14 +841,15 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
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
+		trans_pcie->inta = 0xFFFFFFFF;
+		return trans_pcie->inta;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -859,7 +860,7 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 
 	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	return IRQ_WAKE_THREAD;
+	return trans_pcie->inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -875,10 +876,9 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
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
@@ -938,9 +938,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
+		return trans_pcie->inta;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
@@ -950,7 +948,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	return ret;
+	return trans_pcie->inta;
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
@@ -961,7 +959,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
-	irqreturn_t ret;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
@@ -972,13 +969,19 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * use legacy interrupt.
 	 */
 	if (likely(trans_pcie->use_ict))
-		ret = iwl_pcie_int_cause_ict(trans);
+		inta = iwl_pcie_int_cause_ict(trans);
 	else
-		ret = iwl_pcie_int_cause_non_ict(trans);
+		inta = iwl_pcie_int_cause_non_ict(trans);
 
-	if (ret != IRQ_WAKE_THREAD) {
+	if (unlikely(!inta)) {
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-		return ret;
+		lock_map_release(&trans->sync_cmd_lockdep_map);
+		return IRQ_NONE;
+	}
+
+	if (unlikely(inta == 0xFFFFFFFF)) {
+		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		goto out;
 	}
 
 	/* Ack/clear/reset pending uCode interrupts.
@@ -992,10 +995,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
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
1.7.9.5

