Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3LKIfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 05/10] iwlwifi: pcie: read the interrupt cause from the handler
Date: Wed, 11 Dec 2013 10:33:40 +0200
Message-Id: <1386750826-25219-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093538_105766_B1566CB8)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We know disable the interrupts in the hardware from the
upper half and all the rest (including reading the interrupt
cause) is done in the handler.

Change-Id: Ib319a81a6ba124c1e1d22c115ed6f865b678d672
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 18 +++++++++---------
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
1.8.3.2

