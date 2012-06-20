Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2FTHiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/12] iwlwifi: protect use_ict with irq_lock
Date: Wed, 20 Jun 2012 09:38:09 +0200
Message-Id: <1340177894-12992-8-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093837_729351_237F89BA)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This variable was accessed without taking the lock.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index d6860c0..be143eb 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -867,24 +867,23 @@ void iwl_disable_ict(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
+/* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
 static irqreturn_t iwl_isr(int irq, void *data)
 {
 	struct iwl_trans *trans = data;
-	struct iwl_trans_pcie *trans_pcie;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta, inta_mask;
-	unsigned long flags;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_fh;
 #endif
+
+	lockdep_assert_held(&trans_pcie->irq_lock);
+
 	if (!trans)
 		return IRQ_NONE;
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
@@ -907,7 +906,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		goto unplugged;
+		return IRQ_HANDLED;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -926,18 +925,13 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		 !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
- unplugged:
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-	return IRQ_HANDLED;
-
- none:
+none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
 	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return IRQ_NONE;
 }
 
@@ -963,15 +957,19 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
 	 */
-	if (!trans_pcie->use_ict)
-		return iwl_isr(irq, data);
+	if (unlikely(!trans_pcie->use_ict)) {
+		irqreturn_t ret = iwl_isr(irq, data);
+		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		return ret;
+	}
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 * back-to-back ISRs and sporadic interrupts from our NIC.
-- 
1.7.10

