Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3LKIfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:08 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 08/10] iwlwifi: pcie: no need to save inta in trans_pcie
Date: Wed, 11 Dec 2013 10:33:44 +0200
Message-Id: <1386750826-25219-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093533_702112_C8BA734D)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was useful when the handling was not in the same
context as the interrupt cause retrieval: we could have
several hard interrupts until the handler gets called.
Since we retrieve the interrupt cause in the handler itself,
there is no need to OR the interrupt causes.

Change-Id: I043ea25c4ba1add17d20d26da23148437114981c
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 21 +++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index c790df6..f959308 100644
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
index 3ddf012..3f247da 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -838,17 +838,16 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
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
-		return trans_pcie->inta;
+		return inta;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -857,9 +856,8 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 			      inta, trans_pcie->inta_mask,
 			      iwl_read32(trans, CSR_FH_INT_STATUS));
 
-	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	return trans_pcie->inta;
+	return inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -933,21 +931,19 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
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
@@ -994,9 +990,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 			      inta, iwl_read32(trans, CSR_INT_MASK));
 
-	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
-	trans_pcie->inta = 0;
-
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Now service all interrupt bits discovered above. */
-- 
1.8.3.2

