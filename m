Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37324 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcDGGlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 02:41:40 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: remove MSI range support
Date: Thu, 7 Apr 2016 12:10:58 +0530
Message-ID: <1460011258-15893-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160407_084144_123704_00EBB3CE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MSI-X is never well-tested, might contain bugs and generally isn't
really all that useful to maintain. Also ath10k is mainly used with
shared/singly-MSI interrupt systems. Hence removing MSI range support.
This change will be useful for further cleanup in copy engine lock
and to add NAPI support.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: enum ath10k_pci_irq_mode is used for oper_irq_mode

 drivers/net/wireless/ath/ath10k/pci.c | 164 ++++------------------------------
 drivers/net/wireless/ath/ath10k/pci.h |  17 ++--
 2 files changed, 24 insertions(+), 157 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0b305efe6c94..cdd8a307c55b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -33,12 +33,6 @@
 #include "ce.h"
 #include "pci.h"
 
-enum ath10k_pci_irq_mode {
-	ATH10K_PCI_IRQ_AUTO = 0,
-	ATH10K_PCI_IRQ_LEGACY = 1,
-	ATH10K_PCI_IRQ_MSI = 2,
-};
-
 enum ath10k_pci_reset_mode {
 	ATH10K_PCI_RESET_AUTO = 0,
 	ATH10K_PCI_RESET_WARM_ONLY = 1,
@@ -745,10 +739,7 @@ static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	if (ar_pci->num_msi_intrs > 1)
-		return "msi-x";
-
-	if (ar_pci->num_msi_intrs == 1)
+	if (ar_pci->oper_irq_mode == ATH10K_PCI_IRQ_MSI)
 		return "msi";
 
 	return "legacy";
@@ -1502,13 +1493,8 @@ void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
 
 	tasklet_kill(&ar_pci->intr_tq);
-	tasklet_kill(&ar_pci->msi_fw_err);
-
-	for (i = 0; i < CE_COUNT; i++)
-		tasklet_kill(&ar_pci->pipe_info[i].intr);
 
 	del_timer_sync(&ar_pci->rx_post_retry);
 }
@@ -1624,10 +1610,8 @@ static void ath10k_pci_irq_disable(struct ath10k *ar)
 static void ath10k_pci_irq_sync(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
 
-	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
-		synchronize_irq(ar_pci->pdev->irq + i);
+	synchronize_irq(ar_pci->pdev->irq);
 }
 
 static void ath10k_pci_irq_enable(struct ath10k *ar)
@@ -2596,65 +2580,6 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 #endif
 };
 
-static void ath10k_pci_ce_tasklet(unsigned long ptr)
-{
-	struct ath10k_pci_pipe *pipe = (struct ath10k_pci_pipe *)ptr;
-	struct ath10k_pci *ar_pci = pipe->ar_pci;
-
-	ath10k_ce_per_engine_service(ar_pci->ar, pipe->pipe_num);
-}
-
-static void ath10k_msi_err_tasklet(unsigned long data)
-{
-	struct ath10k *ar = (struct ath10k *)data;
-
-	if (!ath10k_pci_has_fw_crashed(ar)) {
-		ath10k_warn(ar, "received unsolicited fw crash interrupt\n");
-		return;
-	}
-
-	ath10k_pci_irq_disable(ar);
-	ath10k_pci_fw_crashed_clear(ar);
-	ath10k_pci_fw_crashed_dump(ar);
-}
-
-/*
- * Handler for a per-engine interrupt on a PARTICULAR CE.
- * This is used in cases where each CE has a private MSI interrupt.
- */
-static irqreturn_t ath10k_pci_per_engine_handler(int irq, void *arg)
-{
-	struct ath10k *ar = arg;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ce_id = irq - ar_pci->pdev->irq - MSI_ASSIGN_CE_INITIAL;
-
-	if (ce_id < 0 || ce_id >= ARRAY_SIZE(ar_pci->pipe_info)) {
-		ath10k_warn(ar, "unexpected/invalid irq %d ce_id %d\n", irq,
-			    ce_id);
-		return IRQ_HANDLED;
-	}
-
-	/*
-	 * NOTE: We are able to derive ce_id from irq because we
-	 * use a one-to-one mapping for CE's 0..5.
-	 * CE's 6 & 7 do not use interrupts at all.
-	 *
-	 * This mapping must be kept in sync with the mapping
-	 * used by firmware.
-	 */
-	tasklet_schedule(&ar_pci->pipe_info[ce_id].intr);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t ath10k_pci_msi_fw_handler(int irq, void *arg)
-{
-	struct ath10k *ar = arg;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	tasklet_schedule(&ar_pci->msi_fw_err);
-	return IRQ_HANDLED;
-}
-
 /*
  * Top-level interrupt handler for all PCI interrupts from a Target.
  * When a block of MSI interrupts is allocated, this top-level handler
@@ -2672,7 +2597,7 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 		return IRQ_NONE;
 	}
 
-	if (ar_pci->num_msi_intrs == 0) {
+	if (ar_pci->oper_irq_mode == ATH10K_PCI_IRQ_LEGACY) {
 		if (!ath10k_pci_irq_pending(ar))
 			return IRQ_NONE;
 
@@ -2699,43 +2624,10 @@ static void ath10k_pci_tasklet(unsigned long data)
 	ath10k_ce_per_engine_service_any(ar);
 
 	/* Re-enable legacy irq that was disabled in the irq handler */
-	if (ar_pci->num_msi_intrs == 0)
+	if (ar_pci->oper_irq_mode == ATH10K_PCI_IRQ_LEGACY)
 		ath10k_pci_enable_legacy_irq(ar);
 }
 
-static int ath10k_pci_request_irq_msix(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret, i;
-
-	ret = request_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW,
-			  ath10k_pci_msi_fw_handler,
-			  IRQF_SHARED, "ath10k_pci", ar);
-	if (ret) {
-		ath10k_warn(ar, "failed to request MSI-X fw irq %d: %d\n",
-			    ar_pci->pdev->irq + MSI_ASSIGN_FW, ret);
-		return ret;
-	}
-
-	for (i = MSI_ASSIGN_CE_INITIAL; i <= MSI_ASSIGN_CE_MAX; i++) {
-		ret = request_irq(ar_pci->pdev->irq + i,
-				  ath10k_pci_per_engine_handler,
-				  IRQF_SHARED, "ath10k_pci", ar);
-		if (ret) {
-			ath10k_warn(ar, "failed to request MSI-X ce irq %d: %d\n",
-				    ar_pci->pdev->irq + i, ret);
-
-			for (i--; i >= MSI_ASSIGN_CE_INITIAL; i--)
-				free_irq(ar_pci->pdev->irq + i, ar);
-
-			free_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW, ar);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static int ath10k_pci_request_irq_msi(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -2774,41 +2666,28 @@ static int ath10k_pci_request_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	switch (ar_pci->num_msi_intrs) {
-	case 0:
+	switch (ar_pci->oper_irq_mode) {
+	case ATH10K_PCI_IRQ_LEGACY:
 		return ath10k_pci_request_irq_legacy(ar);
-	case 1:
+	case ATH10K_PCI_IRQ_MSI:
 		return ath10k_pci_request_irq_msi(ar);
 	default:
-		return ath10k_pci_request_irq_msix(ar);
+		return -EINVAL;
 	}
 }
 
 static void ath10k_pci_free_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
 
-	/* There's at least one interrupt irregardless whether its legacy INTR
-	 * or MSI or MSI-X */
-	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
-		free_irq(ar_pci->pdev->irq + i, ar);
+	free_irq(ar_pci->pdev->irq, ar);
 }
 
 void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
 
 	tasklet_init(&ar_pci->intr_tq, ath10k_pci_tasklet, (unsigned long)ar);
-	tasklet_init(&ar_pci->msi_fw_err, ath10k_msi_err_tasklet,
-		     (unsigned long)ar);
-
-	for (i = 0; i < CE_COUNT; i++) {
-		ar_pci->pipe_info[i].ar_pci = ar_pci;
-		tasklet_init(&ar_pci->pipe_info[i].intr, ath10k_pci_ce_tasklet,
-			     (unsigned long)&ar_pci->pipe_info[i]);
-	}
 }
 
 static int ath10k_pci_init_irq(struct ath10k *ar)
@@ -2822,20 +2701,9 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 		ath10k_info(ar, "limiting irq mode to: %d\n",
 			    ath10k_pci_irq_mode);
 
-	/* Try MSI-X */
-	if (ath10k_pci_irq_mode == ATH10K_PCI_IRQ_AUTO) {
-		ar_pci->num_msi_intrs = MSI_ASSIGN_CE_MAX + 1;
-		ret = pci_enable_msi_range(ar_pci->pdev, ar_pci->num_msi_intrs,
-					   ar_pci->num_msi_intrs);
-		if (ret > 0)
-			return 0;
-
-		/* fall-through */
-	}
-
 	/* Try MSI */
 	if (ath10k_pci_irq_mode != ATH10K_PCI_IRQ_LEGACY) {
-		ar_pci->num_msi_intrs = 1;
+		ar_pci->oper_irq_mode = ATH10K_PCI_IRQ_MSI;
 		ret = pci_enable_msi(ar_pci->pdev);
 		if (ret == 0)
 			return 0;
@@ -2851,7 +2719,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
 	 * This write might get lost if target has NOT written BAR.
 	 * For now, fix the race by repeating the write in below
 	 * synchronization checking. */
-	ar_pci->num_msi_intrs = 0;
+	ar_pci->oper_irq_mode = ATH10K_PCI_IRQ_LEGACY;
 
 	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
 			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
@@ -2869,8 +2737,8 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	switch (ar_pci->num_msi_intrs) {
-	case 0:
+	switch (ar_pci->oper_irq_mode) {
+	case ATH10K_PCI_IRQ_LEGACY:
 		ath10k_pci_deinit_irq_legacy(ar);
 		break;
 	default:
@@ -2908,7 +2776,7 @@ int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		if (val & FW_IND_INITIALIZED)
 			break;
 
-		if (ar_pci->num_msi_intrs == 0)
+		if (ar_pci->oper_irq_mode == ATH10K_PCI_IRQ_LEGACY)
 			/* Fix potential race by repeating CORE_BASE writes */
 			ath10k_pci_enable_legacy_irq(ar);
 
@@ -3186,8 +3054,8 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	ath10k_info(ar, "pci irq %s interrupts %d irq_mode %d reset_mode %d\n",
-		    ath10k_pci_get_irq_method(ar), ar_pci->num_msi_intrs,
+	ath10k_info(ar, "pci irq %s oper_irq_mode %d irq_mode %d reset_mode %d\n",
+		    ath10k_pci_get_irq_method(ar), ar_pci->oper_irq_mode,
 		    ath10k_pci_irq_mode, ath10k_pci_reset_mode);
 
 	ret = ath10k_pci_request_irq(ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 249c73a69800..959dc321b75e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -148,9 +148,6 @@ struct ath10k_pci_pipe {
 
 	/* protects compl_free and num_send_allowed */
 	spinlock_t pipe_lock;
-
-	struct ath10k_pci *ar_pci;
-	struct tasklet_struct intr;
 };
 
 struct ath10k_pci_supp_chip {
@@ -164,6 +161,12 @@ struct ath10k_bus_ops {
 	int (*get_num_banks)(struct ath10k *ar);
 };
 
+enum ath10k_pci_irq_mode {
+	ATH10K_PCI_IRQ_AUTO = 0,
+	ATH10K_PCI_IRQ_LEGACY = 1,
+	ATH10K_PCI_IRQ_MSI = 2,
+};
+
 struct ath10k_pci {
 	struct pci_dev *pdev;
 	struct device *dev;
@@ -171,14 +174,10 @@ struct ath10k_pci {
 	void __iomem *mem;
 	size_t mem_len;
 
-	/*
-	 * Number of MSI interrupts granted, 0 --> using legacy PCI line
-	 * interrupts.
-	 */
-	int num_msi_intrs;
+	/* Operating interrupt mode */
+	enum ath10k_pci_irq_mode oper_irq_mode;
 
 	struct tasklet_struct intr_tq;
-	struct tasklet_struct msi_fw_err;
 
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
-- 
2.7.4

