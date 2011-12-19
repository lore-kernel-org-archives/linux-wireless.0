Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58934 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1LSWne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/6] iwlagn: add IRQ tracing
Date: Mon, 19 Dec 2011 13:43:08 -0800
Message-Id: <1324330993-24476-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234347_690367_6DAC628B)
In-Reply-To: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The legacy IRQs could be read from a trace by their
IO accesses, but reading the ICT doesn't leave any
trace (pun intended ;-) ) so in order to see what
input they get we need to add specific tracepoints.

While at it, fix whitespace in two related places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h      |   29 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   32 ++++++++++++++-------
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index f9d3319..9b212a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -90,6 +90,35 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
 );
 
+TRACE_EVENT(iwlwifi_dev_irq,
+	TP_PROTO(void *priv),
+	TP_ARGS(priv),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+	),
+	/* TP_printk("") doesn't compile */
+	TP_printk("%d", 0)
+);
+
+TRACE_EVENT(iwlwifi_dev_ict_read,
+	TP_PROTO(void *priv, u32 index, u32 value),
+	TP_ARGS(priv, index, value),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(u32, index)
+		__field(u32, value)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->index = index;
+		__entry->value = value;
+	),
+	TP_printk("read ict[%d] = %#.8x", __entry->index, __entry->value)
+);
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_ucode
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 791005d..06d5698 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1281,6 +1281,8 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	if (!trans)
 		return IRQ_NONE;
 
+	trace_iwlwifi_dev_irq(priv(trans));
+
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	spin_lock_irqsave(&trans->shrd->lock, flags);
@@ -1355,6 +1357,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	struct iwl_trans_pcie *trans_pcie;
 	u32 inta, inta_mask;
 	u32 val = 0;
+	u32 read;
 	unsigned long flags;
 
 	if (!trans)
@@ -1368,6 +1371,8 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (!trans_pcie->use_ict)
 		return iwl_isr(irq, data);
 
+	trace_iwlwifi_dev_irq(priv(trans));
+
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
@@ -1382,24 +1387,29 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!trans_pcie->ict_tbl[trans_pcie->ict_index]) {
+	read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+	trace_iwlwifi_dev_ict_read(priv(trans), trans_pcie->ict_index, read);
+	if (!read) {
 		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
 		goto none;
 	}
 
-	/* read all entries that not 0 start with ict_index */
-	while (trans_pcie->ict_tbl[trans_pcie->ict_index]) {
-
-		val |= le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+	/*
+	 * Collect all entries up to the first 0, starting from ict_index;
+	 * note we already read at ict_index.
+	 */
+	do {
+		val |= read;
 		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
-				trans_pcie->ict_index,
-				le32_to_cpu(
-				  trans_pcie->ict_tbl[trans_pcie->ict_index]));
+				trans_pcie->ict_index, read);
 		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
 		trans_pcie->ict_index =
 			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
 
-	}
+		read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+		trace_iwlwifi_dev_ict_read(priv(trans), trans_pcie->ict_index,
+					   read);
+	} while (read);
 
 	/* We should not get this value, just ignore it. */
 	if (val == 0xffffffff)
@@ -1426,7 +1436,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	if (likely(inta))
 		tasklet_schedule(&trans_pcie->irq_tasklet);
 	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-			!trans_pcie->inta) {
+		 !trans_pcie->inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
 		 * tasklet will enable it.
@@ -1442,7 +1452,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * only Re-enable if disabled by irq.
 	 */
 	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
-		!trans_pcie->inta)
+	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-- 
1.7.0.4

