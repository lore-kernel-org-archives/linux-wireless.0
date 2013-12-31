Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54208 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3LaRQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:09 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so5569681eaj.23
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:08 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/28] iwlwifi: pcie: move the ICT / non-ICT handling functions
Date: Tue, 31 Dec 2013 19:15:33 +0200
Message-Id: <1388510157-23345-4-git-send-email-egrumbach@gmail.com> (sfid-20131231_181616_012413_6D53F0C3)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The purpose of this is to be able to call these functions
from the interrupt handler and not from the primary
interrupt handler.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |  324 ++++++++++++++++----------------
 1 file changed, 162 insertions(+), 162 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 54a2f4a..7085cda 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -807,6 +807,168 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	wake_up(&trans_pcie->wait_command_queue);
 }
 
+/* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
+static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 inta;
+
+	lockdep_assert_held(&trans_pcie->irq_lock);
+
+	trace_iwlwifi_dev_irq(trans->dev);
+
+	/* Discover which interrupts are active/pending */
+	inta = iwl_read32(trans, CSR_INT);
+
+	if (inta & (~trans_pcie->inta_mask)) {
+		IWL_DEBUG_ISR(trans,
+			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
+			      inta & (~trans_pcie->inta_mask));
+		iwl_write32(trans, CSR_INT, inta & (~trans_pcie->inta_mask));
+		inta &= trans_pcie->inta_mask;
+	}
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!inta) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
+		/*
+		 * Re-enable interrupts here since we don't have anything to
+		 * service, but only in case the handler won't run. Note that
+		 * the handler can be scheduled because of a previous
+		 * interrupt.
+		 */
+		if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
+		    !trans_pcie->inta)
+			iwl_enable_interrupts(trans);
+		return IRQ_NONE;
+	}
+
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised
+		 * an interrupt */
+		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		return IRQ_HANDLED;
+	}
+
+	if (iwl_have_debug_level(IWL_DL_ISR))
+		IWL_DEBUG_ISR(trans,
+			      "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+			      inta, trans_pcie->inta_mask,
+			      iwl_read32(trans, CSR_FH_INT_STATUS));
+
+	trans_pcie->inta |= inta;
+	/* the thread will service interrupts and re-enable them */
+	return IRQ_WAKE_THREAD;
+}
+
+/* a device (PCI-E) page is 4096 bytes long */
+#define ICT_SHIFT	12
+#define ICT_SIZE	(1 << ICT_SHIFT)
+#define ICT_COUNT	(ICT_SIZE / sizeof(u32))
+
+/* interrupt handler using ict table, with this interrupt driver will
+ * stop using INTA register to get device's interrupt, reading this register
+ * is expensive, device will write interrupts in ICT dram table, increment
+ * index then will fire interrupt to driver, driver will OR all ICT table
+ * entries from current index up to table entry with 0 value. the result is
+ * the interrupt we need to service, driver will set the entries back to 0 and
+ * set index.
+ */
+static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+	irqreturn_t ret;
+	u32 inta;
+	u32 val = 0;
+	u32 read;
+
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+
+	/* dram interrupt table not set yet,
+	 * use legacy interrupt.
+	 */
+	if (unlikely(!trans_pcie->use_ict)) {
+		ret = iwl_pcie_isr_non_ict(trans);
+		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		return ret;
+	}
+
+	trace_iwlwifi_dev_irq(trans->dev);
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+	trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index, read);
+	if (!read) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	/*
+	 * Collect all entries up to the first 0, starting from ict_index;
+	 * note we already read at ict_index.
+	 */
+	do {
+		val |= read;
+		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
+				trans_pcie->ict_index, read);
+		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
+		trans_pcie->ict_index =
+			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
+
+		read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+		trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index,
+					   read);
+	} while (read);
+
+	/* We should not get this value, just ignore it. */
+	if (val == 0xffffffff)
+		val = 0;
+
+	/*
+	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
+	 * (bit 15 before shifting it to 31) to clear when using interrupt
+	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
+	 * so we use them to decide on the real state of the Rx bit.
+	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
+	 */
+	if (val & 0xC0000)
+		val |= 0x8000;
+
+	inta = (0xff & val) | ((0xff00 & val) << 16);
+	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled(sw) 0x%08x ict 0x%08x\n",
+		      inta, trans_pcie->inta_mask, val);
+	if (iwl_have_debug_level(IWL_DL_ISR))
+		IWL_DEBUG_ISR(trans, "enabled(hw) 0x%08x\n",
+			      iwl_read32(trans, CSR_INT_MASK));
+
+	inta &= trans_pcie->inta_mask;
+	trans_pcie->inta |= inta;
+
+	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
+	if (likely(inta)) {
+		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+		return IRQ_WAKE_THREAD;
+	}
+
+	ret = IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service.
+	 * only Re-enable if disabled by irq.
+	 */
+	if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
+	    !trans_pcie->inta)
+		iwl_enable_interrupts(trans);
+
+	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
+	return ret;
+}
+
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 {
 	struct iwl_trans *trans = dev_id;
@@ -1019,11 +1181,6 @@ out:
  *
  ******************************************************************************/
 
-/* a device (PCI-E) page is 4096 bytes long */
-#define ICT_SHIFT	12
-#define ICT_SIZE	(1 << ICT_SHIFT)
-#define ICT_COUNT	(ICT_SIZE / sizeof(u32))
-
 /* Free dram table */
 void iwl_pcie_free_ict(struct iwl_trans *trans)
 {
@@ -1110,163 +1267,6 @@ void iwl_pcie_disable_ict(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
-/* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
-static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 inta;
-
-	lockdep_assert_held(&trans_pcie->irq_lock);
-
-	trace_iwlwifi_dev_irq(trans->dev);
-
-	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(trans, CSR_INT);
-
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
-		if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
-		    !trans_pcie->inta)
-			iwl_enable_interrupts(trans);
-		return IRQ_NONE;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared. It might have already raised
-		 * an interrupt */
-		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		return IRQ_HANDLED;
-	}
-
-	if (iwl_have_debug_level(IWL_DL_ISR))
-		IWL_DEBUG_ISR(trans,
-			      "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-			      inta, trans_pcie->inta_mask,
-			      iwl_read32(trans, CSR_FH_INT_STATUS));
-
-	trans_pcie->inta |= inta;
-	/* the thread will service interrupts and re-enable them */
-	return IRQ_WAKE_THREAD;
-}
-
-/* interrupt handler using ict table, with this interrupt driver will
- * stop using INTA register to get device's interrupt, reading this register
- * is expensive, device will write interrupts in ICT dram table, increment
- * index then will fire interrupt to driver, driver will OR all ICT table
- * entries from current index up to table entry with 0 value. the result is
- * the interrupt we need to service, driver will set the entries back to 0 and
- * set index.
- */
-static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-	irqreturn_t ret;
-	u32 inta;
-	u32 val = 0;
-	u32 read;
-
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
-	/* dram interrupt table not set yet,
-	 * use legacy interrupt.
-	 */
-	if (unlikely(!trans_pcie->use_ict)) {
-		ret = iwl_pcie_isr_non_ict(trans);
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-		return ret;
-	}
-
-	trace_iwlwifi_dev_irq(trans->dev);
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
-	trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index, read);
-	if (!read) {
-		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
-
-	/*
-	 * Collect all entries up to the first 0, starting from ict_index;
-	 * note we already read at ict_index.
-	 */
-	do {
-		val |= read;
-		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
-				trans_pcie->ict_index, read);
-		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
-		trans_pcie->ict_index =
-			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
-
-		read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
-		trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index,
-					   read);
-	} while (read);
-
-	/* We should not get this value, just ignore it. */
-	if (val == 0xffffffff)
-		val = 0;
-
-	/*
-	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
-	 * (bit 15 before shifting it to 31) to clear when using interrupt
-	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
-	 * so we use them to decide on the real state of the Rx bit.
-	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
-	 */
-	if (val & 0xC0000)
-		val |= 0x8000;
-
-	inta = (0xff & val) | ((0xff00 & val) << 16);
-	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled(sw) 0x%08x ict 0x%08x\n",
-		      inta, trans_pcie->inta_mask, val);
-	if (iwl_have_debug_level(IWL_DL_ISR))
-		IWL_DEBUG_ISR(trans, "enabled(hw) 0x%08x\n",
-			      iwl_read32(trans, CSR_INT_MASK));
-
-	inta &= trans_pcie->inta_mask;
-	trans_pcie->inta |= inta;
-
-	/* iwl_pcie_tasklet() will service interrupts and re-enable them */
-	if (likely(inta)) {
-		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-		return IRQ_WAKE_THREAD;
-	}
-
-	ret = IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service.
-	 * only Re-enable if disabled by irq.
-	 */
-	if (test_bit(STATUS_INT_ENABLED, &trans->status) &&
-	    !trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-	return ret;
-}
-
 irqreturn_t iwl_pcie_isr(int irq, void *data)
 {
 	struct iwl_trans *trans = data;
-- 
1.7.9.5

