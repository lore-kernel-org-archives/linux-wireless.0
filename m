Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:45386 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3LRXhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:37:48 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
Date: Thu, 19 Dec 2013 00:26:02 +0100
Message-Id: <1387409165-28319-8-git-send-email-henrik@austad.us> (sfid-20131219_003805_192536_35A4FC0A)
In-Reply-To: <1387409165-28319-1-git-send-email-henrik@austad.us>
References: <1387409165-28319-1-git-send-email-henrik@austad.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These functions are meant to return an interrupt cause and
not an irqreturn_t.

The only drawback is that we will return IRQ_NONE instead
of IRQ_HANDLED when error occurs - but that shouldn't be
an issue.

Change-Id: I2de5c0d39fafb2a00429c314a2a5f0336347233d
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   33 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index aea6202..d395442 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -810,13 +810,11 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	local_bh_enable();
 }
 
-static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
+static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
 
-	irqreturn_t ret = IRQ_NONE;
-
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
 	trace_iwlwifi_dev_irq(trans->dev);
@@ -844,7 +842,7 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
 		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		return IRQ_HANDLED;
+		return trans_pcie->inta;
 	}
 
 	if (iwl_have_debug_level(IWL_DL_ISR))
@@ -856,9 +854,7 @@ static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
 	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
+		return trans_pcie->inta;
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
@@ -867,7 +863,7 @@ none:
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	return ret;
+	return trans_pcie->inta;
 }
 
 /* a device (PCI-E) page is 4096 bytes long */
@@ -883,10 +879,9 @@ none:
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
@@ -946,9 +941,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 
 	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
+		return trans_pcie->inta;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
@@ -958,7 +951,7 @@ static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	return ret;
+	return trans_pcie->inta;
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
@@ -969,7 +962,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	u32 inta = 0;
 	u32 handled = 0;
 	unsigned long flags;
-	irqreturn_t ret;
 	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
@@ -980,13 +972,13 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * use legacy interrupt.
 	 */
 	if (likely(trans_pcie->use_ict))
-		ret = iwl_pcie_int_cause_ict(trans);
+		inta = iwl_pcie_int_cause_ict(trans);
 	else
-		ret = iwl_pcie_int_cause_non_ict(trans);
+		inta = iwl_pcie_int_cause_non_ict(trans);
 
-	if (ret != IRQ_WAKE_THREAD) {
+	if (!inta) {
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-		return ret;
+		return IRQ_NONE;
 	}
 
 	/* Ack/clear/reset pending uCode interrupts.
@@ -1000,8 +992,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(trans, CSR_INT,
-		    trans_pcie->inta | ~trans_pcie->inta_mask);
+	iwl_write32(trans, CSR_INT, inta | ~trans_pcie->inta_mask);
 
 	inta = trans_pcie->inta;
 
-- 
1.7.10.4

