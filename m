Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64134 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3LaRQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:13 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so5679473eek.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:12 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/28] iwlwifi: pcie: no need to save inta in trans_pcie
Date: Tue, 31 Dec 2013 19:15:37 +0200
Message-Id: <1388510157-23345-8-git-send-email-egrumbach@gmail.com> (sfid-20131231_181624_052179_8C60B293)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This was useful when the handling was not in the same
context as the interrupt cause retrieval: we could have
several hard interrupts until the handler gets called.
Since we retrieve the interrupt cause in the handler itself,
there is no need to OR the interrupt causes.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   22 +++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 6a32ecc..9dfee7e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -273,7 +273,6 @@ struct iwl_trans_pcie {
 	__le32 *ict_tbl;
 	dma_addr_t ict_tbl_dma;
 	int ict_index;
-	u32 inta;
 	bool use_ict;
 	struct isr_statistics isr_stats;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index a042c4a..9e019e5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -838,18 +838,16 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 		 * the handler can be scheduled because of a previous
 		 * interrupt.
 		 */
-		if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
-		    !trans_pcie->inta)
+		if (test_bit(STATUS_INT_ENABLED, &trans->status) && !inta)
 			iwl_enable_interrupts(trans);
-		return trans_pcie->inta;
+		return inta;
 	}
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		trans_pcie->inta = 0xFFFFFFFF;
-		return trans_pcie->inta;
+		return 0xFFFFFFFF;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -858,9 +856,8 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 			      inta, trans_pcie->inta_mask,
 			      iwl_read32(trans, CSR_FH_INT_STATUS));
 
-	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	return trans_pcie->inta;
+	return inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -934,21 +931,19 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 			      iwl_read32(trans, CSR_INT_MASK));
 
 	inta &= trans_pcie->inta_mask;
-	trans_pcie->inta |= inta;
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		return trans_pcie->inta;
+		return inta;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
-	    !trans_pcie->inta)
+	if (test_bit(STATUS_INT_ENABLED, &trans->status) && !inta)
 		iwl_enable_interrupts(trans);
 
-	return trans_pcie->inta;
+	return inta;
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
@@ -1001,9 +996,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 			      inta, iwl_read32(trans, CSR_INT_MASK));
 
-	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
-	trans_pcie->inta = 0;
-
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Now service all interrupt bits discovered above. */
-- 
1.7.9.5

