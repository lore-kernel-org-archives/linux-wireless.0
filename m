Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:45385 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3LRXhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 18:37:48 -0500
From: Henrik Austad <henrik@austad.us>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] iwlwifi: pcie: re-organize the PCIe ISR code
Date: Thu, 19 Dec 2013 00:25:58 +0100
Message-Id: <1387409165-28319-4-git-send-email-henrik@austad.us> (sfid-20131219_003808_979355_2429CAE6)
In-Reply-To: <1387409165-28319-1-git-send-email-henrik@austad.us>
References: <1387409165-28319-1-git-send-email-henrik@austad.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Separate the code that simply disables interrupt in the
hardware and the code that checks what interrupt fired.
This will be useful to move the second part in the threaded
handler which will be done in a future patch.

Change-Id: Iec42aa577c9de5c5a13a6030a1d8a69b4da37f43
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   50 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    2 +-
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index a216715..f4f587e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -363,7 +363,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans);
 /*****************************************************
 * ICT - interrupt handling
 ******************************************************/
-irqreturn_t iwl_pcie_isr_ict(int irq, void *data);
+irqreturn_t iwl_pcie_isr(int irq, void *data);
 int iwl_pcie_alloc_ict(struct iwl_trans *trans);
 void iwl_pcie_free_ict(struct iwl_trans *trans);
 void iwl_pcie_reset_ict(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index a6212d1..bbaea69 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1114,23 +1114,17 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans)
 }
 
 /* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
-static irqreturn_t iwl_pcie_isr(int irq, void *data)
+static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
+
 	irqreturn_t ret = IRQ_NONE;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the irq thread will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
-
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
@@ -1188,20 +1182,14 @@ none:
  * the interrupt we need to service, driver will set the entries back to 0 and
  * set index.
  */
-irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
+static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans *trans = data;
-	struct iwl_trans_pcie *trans_pcie;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+	irqreturn_t ret;
 	u32 inta;
 	u32 val = 0;
 	u32 read;
-	unsigned long flags;
-	irqreturn_t ret = IRQ_NONE;
-
-	if (!trans)
-		return IRQ_NONE;
-
-	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
@@ -1209,20 +1197,13 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	 * use legacy interrupt.
 	 */
 	if (unlikely(!trans_pcie->use_ict)) {
-		ret = iwl_pcie_isr(irq, data);
+		ret = iwl_pcie_isr_non_ict(trans);
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return ret;
 	}
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-	/* Disable (but don't clear!) interrupts here to avoid
-	 * back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here.
-	 */
-	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
-
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
@@ -1293,3 +1274,20 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 	return ret;
 }
+
+irqreturn_t iwl_pcie_isr(int irq, void *data)
+{
+	struct iwl_trans *trans = data;
+
+	if (!trans)
+		return IRQ_NONE;
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 * back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here.
+	 */
+	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
+
+	return iwl_pcie_isr_ict(trans);
+}
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index cde9c16..6d0c828 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1609,7 +1609,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
-	err = request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
+	err = request_threaded_irq(pdev->irq, iwl_pcie_isr,
 				   iwl_pcie_irq_handler,
 				   IRQF_SHARED, DRV_NAME, trans);
 	if (err) {
-- 
1.7.10.4

