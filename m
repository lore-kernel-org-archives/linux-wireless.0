Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKIfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 09/10] iwlwifi: pcie: move interrupt prints to the common handler
Date: Wed, 11 Dec 2013 10:33:45 +0200
Message-Id: <1386750826-25219-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093522_949909_7184D2EE)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handling interrupt with no cause and printing logs doesn't
need to be ICT / non-ICT specific move this to the common
code.

Change-Id: I741894a8079faf0bf192a63ea5f40de5d08c433c
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 90 ++++++++++++----------------------
 1 file changed, 30 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 3f247da..f25e6bb 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -819,43 +819,6 @@ static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
-	if (inta & (~trans_pcie->inta_mask)) {
-		IWL_DEBUG_ISR(trans,
-			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
-			      inta & (~trans_pcie->inta_mask));
-		iwl_write32(trans, CSR_INT, inta & (~trans_pcie->inta_mask));
-		inta &= trans_pcie->inta_mask;
-	}
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!inta) {
-		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		/*
-		 * Re-enable interrupts here since we don't have anything to
-		 * service, but only in case the handler won't run. Note that
-		 * the handler can be scheduled because of a previous
-		 * interrupt.
-		 */
-		if (test_bit(STATUS_INT_ENABLED, &trans->status) && !inta)
-			iwl_enable_interrupts(trans);
-		return inta;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared. It might have already raised
-		 * an interrupt */
-		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		return inta;
-	}
-
-	if (iwl_have_debug_level(IWL_DL_ISR))
-		IWL_DEBUG_ISR(trans,
-			      "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-			      inta, trans_pcie->inta_mask,
-			      iwl_read32(trans, CSR_FH_INT_STATUS));
-
 	/* the thread will service interrupts and re-enable them */
 	return inta;
 }
@@ -887,10 +850,8 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 	 * or due to sporadic interrupts thrown from our NIC. */
 	read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
 	trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index, read);
-	if (!read) {
-		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
+	if (!read)
+		return 0;
 
 	/*
 	 * Collect all entries up to the first 0, starting from ict_index;
@@ -924,25 +885,6 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 		val |= 0x8000;
 
 	inta = (0xff & val) | ((0xff00 & val) << 16);
-	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled(sw) 0x%08x ict 0x%08x\n",
-		      inta, trans_pcie->inta_mask, val);
-	if (iwl_have_debug_level(IWL_DL_ISR))
-		IWL_DEBUG_ISR(trans, "enabled(hw) 0x%08x\n",
-			      iwl_read32(trans, CSR_INT_MASK));
-
-	inta &= trans_pcie->inta_mask;
-
-	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
-	if (likely(inta))
-		return inta;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service.
-	 * only Re-enable if disabled by irq.
-	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans->status) && !inta)
-		iwl_enable_interrupts(trans);
-
 	return inta;
 }
 
@@ -968,11 +910,39 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	else
 		inta = iwl_pcie_int_cause_non_ict(trans);
 
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
+		IWL_DEBUG_ISR(trans,
+			      "ISR inta 0x%08x, enabled 0x%08x(sw), enabled(hw) 0x%08x, fh 0x%08x\n",
+			      inta, trans_pcie->inta_mask,
+			      iwl_read32(trans, CSR_INT_MASK),
+			      iwl_read32(trans, CSR_FH_INT_STATUS));
+		if (inta & (~trans_pcie->inta_mask))
+			IWL_DEBUG_ISR(trans,
+				      "We got a masked interrupt (0x%08x)\n",
+				      inta & (~trans_pcie->inta_mask));
+	}
+
+	inta &= trans_pcie->inta_mask;
+
+	/*
+	 * Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC.\
+	 */
 	if (!inta) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
+		/* Re-enable interrupts here since we don't have anything to service */
+		if (test_bit(STATUS_INT_ENABLED, &trans->status))
+			iwl_enable_interrupts(trans);
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return IRQ_NONE;
 	}
 
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised an interrupt */
+		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+	}
+
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 */
-- 
1.8.3.2

