Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58681 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3LaRQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:07 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so5600274eek.24
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/28] iwlwifi: pcie: track interrupt mask in SW
Date: Tue, 31 Dec 2013 19:15:31 +0200
Message-Id: <1388510157-23345-2-git-send-email-egrumbach@gmail.com> (sfid-20131231_183435_816930_9AE8C14A)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Track the interrupt mask in software, making it exactly
what is configured in the interrupt mask register in the
hardware.
This allows not to access the register from the interrupt
handler. This was the case for ICT interrupt already, but
not for non-ICT interrupt.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    6 +++++-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   13 ++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 674c75b..53c5237 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -397,13 +397,17 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 
 	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &trans->status);
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
 	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
 static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	IWL_DEBUG_ISR(trans, "Enabling rfkill interrupt\n");
-	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	trans_pcie->inta_mask = CSR_INT_BIT_RF_KILL;
+	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
 static inline void iwl_wake_queue(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index b3e6564..7e4836f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1115,7 +1115,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 {
 	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 inta, inta_mask;
+	u32 inta;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
@@ -1125,18 +1125,17 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the irq thread will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
-	if (inta & (~inta_mask)) {
+	if (inta & (~trans_pcie->inta_mask)) {
 		IWL_DEBUG_ISR(trans,
 			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
-			      inta & (~inta_mask));
-		iwl_write32(trans, CSR_INT, inta & (~inta_mask));
-		inta &= inta_mask;
+			      inta & (~trans_pcie->inta_mask));
+		iwl_write32(trans, CSR_INT, inta & (~trans_pcie->inta_mask));
+		inta &= trans_pcie->inta_mask;
 	}
 
 	/* Ignore interrupt if there's nothing in NIC to service.
@@ -1166,7 +1165,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	if (iwl_have_debug_level(IWL_DL_ISR))
 		IWL_DEBUG_ISR(trans,
 			      "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-			      inta, inta_mask,
+			      inta, trans_pcie->inta_mask,
 			      iwl_read32(trans, CSR_FH_INT_STATUS));
 
 	trans_pcie->inta |= inta;
-- 
1.7.9.5

