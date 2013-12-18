Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:42757 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3LRXgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:36:32 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/10] iwlwifi: pcie: read the interrupt cause from the handler
Date: Thu, 19 Dec 2013 00:26:00 +0100
Message-Id: <1387409165-28319-6-git-send-email-henrik@austad.us> (sfid-20131219_003641_716446_9E6D7C4F)
In-Reply-To: <1387409165-28319-1-git-send-email-henrik@austad.us>
References: <1387409165-28319-1-git-send-email-henrik@austad.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We now disable the interrupts in the hardware from the
upper half and all the rest (including reading the interrupt
cause) is done in the handler.

Change-Id: Ib319a81a6ba124c1e1d22c115ed6f865b678d672
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 42fd96d..cd96eb2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -887,20 +887,16 @@ none:
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
 
@@ -958,10 +954,8 @@ static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 	trans_pcie->inta |= inta;
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
-	if (likely(inta)) {
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	if (likely(inta))
 		return IRQ_WAKE_THREAD;
-	}
 
 	ret = IRQ_HANDLED;
 
@@ -973,7 +967,6 @@ static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return ret;
 }
 
@@ -985,12 +978,19 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
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
@@ -1289,5 +1289,5 @@ irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 */
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
-	return iwl_pcie_isr_ict(trans);
+	return IRQ_WAKE_THREAD;
 }
-- 
1.7.10.4

