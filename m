Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51519 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3LaRQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:08 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so5613325eek.39
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/28] iwlwifi: pcie: re-organize the PCIe ISR code
Date: Tue, 31 Dec 2013 19:15:32 +0200
Message-Id: <1388510157-23345-3-git-send-email-egrumbach@gmail.com> (sfid-20131231_181613_102908_7FC8560F)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Separate the code that simply disables interrupt in the
hardware and the code that checks what interrupt fired.
This will be useful to move the second part in the threaded
handler which will be done in a future patch.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   49 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    2 +-
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 53c5237..6a32ecc 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -343,7 +343,7 @@ void iwl_pcie_rx_free(struct iwl_trans *trans);
 /*****************************************************
 * ICT - interrupt handling
 ******************************************************/
-irqreturn_t iwl_pcie_isr_ict(int irq, void *data);
+irqreturn_t iwl_pcie_isr(int irq, void *data);
 int iwl_pcie_alloc_ict(struct iwl_trans *trans);
 void iwl_pcie_free_ict(struct iwl_trans *trans);
 void iwl_pcie_reset_ict(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7e4836f..54a2f4a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1111,9 +1111,8 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans)
 }
 
 /* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
-static irqreturn_t iwl_pcie_isr(int irq, void *data)
+static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
 
@@ -1121,12 +1120,6 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the irq thread will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
-
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
@@ -1181,20 +1174,14 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
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
 
@@ -1202,20 +1189,13 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
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
@@ -1286,3 +1266,20 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
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
index eecd38e..7210507 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1597,7 +1597,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
-	err = request_threaded_irq(pdev->irq, iwl_pcie_isr_ict,
+	err = request_threaded_irq(pdev->irq, iwl_pcie_isr,
 				   iwl_pcie_irq_handler,
 				   IRQF_SHARED, DRV_NAME, trans);
 	if (err) {
-- 
1.7.9.5

