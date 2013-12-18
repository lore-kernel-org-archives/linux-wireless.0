Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:45350 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3LRXhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:37:47 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/10] iwlwifi: pcie: no need to save inta in trans_pcie
Date: Thu, 19 Dec 2013 00:26:03 +0100
Message-Id: <1387409165-28319-9-git-send-email-henrik@austad.us> (sfid-20131219_003759_081764_E4E53E59)
In-Reply-To: <1387409165-28319-1-git-send-email-henrik@austad.us>
References: <1387409165-28319-1-git-send-email-henrik@austad.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This was useful when the handling was not in the same
context as the interrupt cause retrieval: we could have
several hard interrupts until the handler gets called.
Since we retrieve the interrupt cause in the handler itself,
there is no need to OR the interrupt causes.

Change-Id: I043ea25c4ba1add17d20d26da23148437114981c
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   23 +++++++----------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index f4f587e..f9deaea 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -274,7 +274,6 @@ struct iwl_trans_pcie {
 	__le32 *ict_tbl;
 	dma_addr_t ict_tbl_dma;
 	int ict_index;
-	u32 inta;
 	bool use_ict;
 	struct isr_statistics isr_stats;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index d395442..4678957 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -842,7 +842,7 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		return trans_pcie->inta;
+		return inta;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -851,19 +851,17 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 			      inta, trans_pcie->inta_mask,
 			      iwl_read32(trans, CSR_FH_INT_STATUS));
 
-	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
 	if (likely(inta))
-		return trans_pcie->inta;
+		return inta;
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-	    !trans_pcie->inta)
+	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) && !inta)
 		iwl_enable_interrupts(trans);
 
-	return trans_pcie->inta;
+	return inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -937,21 +935,19 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
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
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-	    !trans_pcie->inta)
+	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) && !inta)
 		iwl_enable_interrupts(trans);
 
-	return trans_pcie->inta;
+	return inta;
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
@@ -994,15 +990,10 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 */
 	iwl_write32(trans, CSR_INT, inta | ~trans_pcie->inta_mask);
 
-	inta = trans_pcie->inta;
-
 	if (iwl_have_debug_level(IWL_DL_ISR))
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 			      inta, iwl_read32(trans, CSR_INT_MASK));
 
-	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
-	trans_pcie->inta = 0;
-
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Now service all interrupt bits discovered above. */
-- 
1.7.10.4

