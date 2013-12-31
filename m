Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:59102 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3LaRQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:10 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so5664669eaj.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/28] iwlwifi: pcie: read the interrupt cause from the handler
Date: Tue, 31 Dec 2013 19:15:34 +0200
Message-Id: <1388510157-23345-5-git-send-email-egrumbach@gmail.com> (sfid-20131231_181712_727541_CDDA69F7)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We now disable the interrupts in the hardware from the
upper half and all the rest (including reading the interrupt
cause) is done in the handler.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7085cda..5044fbd 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -879,20 +879,16 @@ static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
 static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
 	irqreturn_t ret;
 	u32 inta;
 	u32 val = 0;
 	u32 read;
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
 	 */
 	if (unlikely(!trans_pcie->use_ict)) {
 		ret = iwl_pcie_isr_non_ict(trans);
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return ret;
 	}
 
@@ -950,10 +946,8 @@ static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 	trans_pcie->inta |= inta;
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
-	if (likely(inta)) {
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	if (likely(inta))
 		return IRQ_WAKE_THREAD;
-	}
 
 	ret = IRQ_HANDLED;
 
@@ -965,7 +959,6 @@ static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return ret;
 }
 
@@ -977,12 +970,19 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
+	irqreturn_t ret;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
+	ret = iwl_pcie_isr_ict(trans);
+	if (ret != IRQ_WAKE_THREAD) {
+		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		return ret;
+	}
+
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 */
@@ -1281,5 +1281,5 @@ irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 */
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
-	return iwl_pcie_isr_ict(trans);
+	return IRQ_WAKE_THREAD;
 }
-- 
1.7.9.5

