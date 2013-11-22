Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46486 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KVNIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:08:43 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so613044eek.16
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:08:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/8] ath10k: split up pci irq code
Date: Fri, 22 Nov 2013 14:05:12 +0100
Message-Id: <1385125518-13461-3-git-send-email-michal.kazior@tieto.com> (sfid-20131122_140847_705484_53773604)
In-Reply-To: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware waits until host signals whether it has
chosen MSI(-X) or shared legacy interrupts. It is
not required for the driver to register interrupt
handlers immediately.

This patch prepares the pci irq code for more
changes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 225 ++++++++++++++++++++--------------
 1 file changed, 131 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ed752d6..d4536cb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -55,8 +55,10 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
 static void ath10k_pci_stop_ce(struct ath10k *ar);
 static int ath10k_pci_device_reset(struct ath10k *ar);
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
-static int ath10k_pci_start_intr(struct ath10k *ar);
-static void ath10k_pci_stop_intr(struct ath10k *ar);
+static int ath10k_pci_init_irq(struct ath10k *ar);
+static int ath10k_pci_deinit_irq(struct ath10k *ar);
+static int ath10k_pci_request_irq(struct ath10k *ar);
+static void ath10k_pci_free_irq(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -1341,7 +1343,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
 	/* Irqs are never explicitly re-enabled. They are implicitly re-enabled
-	 * by ath10k_pci_start_intr(). */
+	 * by upon power_up. */
 	ath10k_pci_disable_irqs(ar);
 
 	ath10k_pci_stop_ce(ar);
@@ -1887,34 +1889,40 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		goto err_ce;
 	}
 
-	ret = ath10k_pci_start_intr(ar);
+	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
-		ath10k_err("failed to start interrupt handling: %d\n", ret);
+		ath10k_err("failed to init irqs: %d\n", ret);
 		goto err_ce;
 	}
 
+	ret = ath10k_pci_request_irq(ar);
+	if (ret) {
+		ath10k_err("failed to request irqs: %d\n", ret);
+		goto err_deinit_irq;
+	}
+
 	ret = ath10k_pci_wait_for_target_init(ar);
 	if (ret) {
 		ath10k_err("failed to wait for target to init: %d\n", ret);
-		goto err_irq;
+		goto err_free_irq;
 	}
 
 	ret = ath10k_ce_enable_err_irq(ar);
 	if (ret) {
 		ath10k_err("failed to enable CE error irq: %d\n", ret);
-		goto err_irq;
+		goto err_free_irq;
 	}
 
 	ret = ath10k_pci_init_config(ar);
 	if (ret) {
 		ath10k_err("failed to setup init config: %d\n", ret);
-		goto err_irq;
+		goto err_free_irq;
 	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
 		ath10k_err("could not wake up target CPU: %d\n", ret);
-		goto err_irq;
+		goto err_free_irq;
 	}
 
 	ath10k_pci_start_bmi(ar);
@@ -1931,11 +1939,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	return 0;
 
-err_irq:
-	ath10k_ce_disable_interrupts(ar);
-	ath10k_pci_stop_intr(ar);
+err_free_irq:
+	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_device_reset(ar);
+err_deinit_irq:
+	ath10k_pci_deinit_irq(ar);
 err_ce:
 	ath10k_pci_ce_deinit(ar);
 err_ps:
@@ -1949,7 +1958,8 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
-	ath10k_pci_stop_intr(ar);
+	ath10k_pci_free_irq(ar);
+	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_device_reset(ar);
 
 	ath10k_pci_ce_deinit(ar);
@@ -2157,24 +2167,17 @@ static void ath10k_pci_tasklet(unsigned long data)
 	}
 }
 
-static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
+static int ath10k_pci_request_irq_msix(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret;
-	int i;
-
-	ret = pci_enable_msi_block(ar_pci->pdev, num);
-	if (ret)
-		return ret;
+	int ret, i;
 
 	ret = request_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW,
 			  ath10k_pci_msi_fw_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
 	if (ret) {
-		ath10k_warn("request_irq(%d) failed %d\n",
+		ath10k_warn("failed to request MSI-X fw irq %d: %d\n",
 			    ar_pci->pdev->irq + MSI_ASSIGN_FW, ret);
-
-		pci_disable_msi(ar_pci->pdev);
 		return ret;
 	}
 
@@ -2183,45 +2186,38 @@ static int ath10k_pci_start_intr_msix(struct ath10k *ar, int num)
 				  ath10k_pci_per_engine_handler,
 				  IRQF_SHARED, "ath10k_pci", ar);
 		if (ret) {
-			ath10k_warn("request_irq(%d) failed %d\n",
+			ath10k_warn("failed to request MSI-X ce irq %d: %d\n",
 				    ar_pci->pdev->irq + i, ret);
 
 			for (i--; i >= MSI_ASSIGN_CE_INITIAL; i--)
 				free_irq(ar_pci->pdev->irq + i, ar);
 
 			free_irq(ar_pci->pdev->irq + MSI_ASSIGN_FW, ar);
-			pci_disable_msi(ar_pci->pdev);
 			return ret;
 		}
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT,
-		   "MSI-X interrupt handling (%d intrs)\n", num);
 	return 0;
 }
 
-static int ath10k_pci_start_intr_msi(struct ath10k *ar)
+static int ath10k_pci_request_irq_msi(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ret = pci_enable_msi(ar_pci->pdev);
-	if (ret < 0)
-		return ret;
-
 	ret = request_irq(ar_pci->pdev->irq,
 			  ath10k_pci_interrupt_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
-	if (ret < 0) {
-		pci_disable_msi(ar_pci->pdev);
+	if (ret) {
+		ath10k_warn("failed to request MSI irq %d: %d\n",
+			    ar_pci->pdev->irq, ret);
 		return ret;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "MSI interrupt handling\n");
 	return 0;
 }
 
-static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
+static int ath10k_pci_request_irq_legacy(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
@@ -2229,99 +2225,140 @@ static int ath10k_pci_start_intr_legacy(struct ath10k *ar)
 	ret = request_irq(ar_pci->pdev->irq,
 			  ath10k_pci_interrupt_handler,
 			  IRQF_SHARED, "ath10k_pci", ar);
-	if (ret < 0)
-		return ret;
-
-	ret = ath10k_pci_wake(ar);
 	if (ret) {
-		free_irq(ar_pci->pdev->irq, ar);
-		ath10k_err("failed to wake up target: %d\n", ret);
+		ath10k_warn("failed to request legacy irq %d: %d\n",
+			    ar_pci->pdev->irq, ret);
 		return ret;
 	}
 
-	/*
-	 * A potential race occurs here: The CORE_BASE write
-	 * depends on target correctly decoding AXI address but
-	 * host won't know when target writes BAR to CORE_CTRL.
-	 * This write might get lost if target has NOT written BAR.
-	 * For now, fix the race by repeating the write in below
-	 * synchronization checking.
-	 */
-	iowrite32(PCIE_INTR_FIRMWARE_MASK |
-		  PCIE_INTR_CE_MASK_ALL,
-		  ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
-				 PCIE_INTR_ENABLE_ADDRESS));
-
-	ath10k_pci_sleep(ar);
-	ath10k_dbg(ATH10K_DBG_BOOT, "legacy interrupt handling\n");
 	return 0;
 }
 
-static int ath10k_pci_start_intr(struct ath10k *ar)
+static int ath10k_pci_request_irq(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	switch (ar_pci->num_msi_intrs) {
+	case 0:
+		return ath10k_pci_request_irq_legacy(ar);
+	case 1:
+		return ath10k_pci_request_irq_msi(ar);
+	case MSI_NUM_REQUEST:
+		return ath10k_pci_request_irq_msix(ar);
+	}
+
+	ath10k_warn("unknown irq configuration upon request\n");
+	return -EINVAL;
+}
+
+static void ath10k_pci_free_irq(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
+
+	/* There's at least one interrupt irregardless whether its legacy INTR
+	 * or MSI or MSI-X */
+	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
+		free_irq(ar_pci->pdev->irq + i, ar);
+}
+
+static void ath10k_pci_init_irq_tasklets(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int num = MSI_NUM_REQUEST;
-	int ret;
 	int i;
 
-	tasklet_init(&ar_pci->intr_tq, ath10k_pci_tasklet, (unsigned long) ar);
+	tasklet_init(&ar_pci->intr_tq, ath10k_pci_tasklet, (unsigned long)ar);
 	tasklet_init(&ar_pci->msi_fw_err, ath10k_msi_err_tasklet,
-		     (unsigned long) ar);
+		     (unsigned long)ar);
 
 	for (i = 0; i < CE_COUNT; i++) {
 		ar_pci->pipe_info[i].ar_pci = ar_pci;
-		tasklet_init(&ar_pci->pipe_info[i].intr,
-			     ath10k_pci_ce_tasklet,
+		tasklet_init(&ar_pci->pipe_info[i].intr, ath10k_pci_ce_tasklet,
 			     (unsigned long)&ar_pci->pipe_info[i]);
 	}
+}
+
+static int ath10k_pci_init_irq(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
+
+	ath10k_pci_init_irq_tasklets(ar);
 
 	if (!test_bit(ATH10K_PCI_FEATURE_MSI_X, ar_pci->features))
-		num = 1;
+		goto msi;
 
-	if (num > 1) {
-		ret = ath10k_pci_start_intr_msix(ar, num);
-		if (ret == 0)
-			goto exit;
+	/* Try MSI-X */
+	ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
+	ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
+	if (ret == 0)
+		return 0;
+	if (ret > 0)
+		pci_disable_msi(ar_pci->pdev);
 
-		ath10k_dbg(ATH10K_DBG_BOOT,
-			   "MSI-X didn't succeed (%d), trying MSI\n", ret);
-		num = 1;
-	}
+msi:
+	/* Try MSI */
+	ar_pci->num_msi_intrs = 1;
+	ret = pci_enable_msi(ar_pci->pdev);
+	if (ret == 0)
+		return 0;
 
-	if (num == 1) {
-		ret = ath10k_pci_start_intr_msi(ar);
-		if (ret == 0)
-			goto exit;
+	/* Try legacy irq
+	 *
+	 * A potential race occurs here: The CORE_BASE write
+	 * depends on target correctly decoding AXI address but
+	 * host won't know when target writes BAR to CORE_CTRL.
+	 * This write might get lost if target has NOT written BAR.
+	 * For now, fix the race by repeating the write in below
+	 * synchronization checking. */
+	ar_pci->num_msi_intrs = 0;
 
-		ath10k_dbg(ATH10K_DBG_BOOT,
-			   "MSI didn't succeed (%d), trying legacy INTR\n",
-			   ret);
-		num = 0;
+	ret = ath10k_pci_wake(ar);
+	if (ret) {
+		ath10k_warn("failed to wake target: %d\n", ret);
+		return ret;
 	}
 
-	ret = ath10k_pci_start_intr_legacy(ar);
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
+			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
+	ath10k_pci_sleep(ar);
+
+	return 0;
+}
+
+static int ath10k_pci_deinit_irq_legacy(struct ath10k *ar)
+{
+	int ret;
+
+	ret = ath10k_pci_wake(ar);
 	if (ret) {
-		ath10k_warn("Failed to start legacy interrupts: %d\n", ret);
+		ath10k_warn("failed to wake target: %d\n", ret);
 		return ret;
 	}
 
-exit:
-	ar_pci->num_msi_intrs = num;
-	return ret;
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
+			   0);
+	ath10k_pci_sleep(ar);
+
+	return 0;
 }
 
-static void ath10k_pci_stop_intr(struct ath10k *ar)
+static int ath10k_pci_deinit_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
 
-	/* There's at least one interrupt irregardless whether its legacy INTR
-	 * or MSI or MSI-X */
-	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
-		free_irq(ar_pci->pdev->irq + i, ar);
-
-	if (ar_pci->num_msi_intrs > 0)
+	switch (ar_pci->num_msi_intrs) {
+	case 0:
+		return ath10k_pci_deinit_irq_legacy(ar);
+	case 1:
+		/* fall-through */
+	case MSI_NUM_REQUEST:
 		pci_disable_msi(ar_pci->pdev);
+		return 0;
+	}
+
+	ath10k_warn("unknown irq configuration upon deinit\n");
+	return -EINVAL;
 }
 
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
-- 
1.8.4.rc3

