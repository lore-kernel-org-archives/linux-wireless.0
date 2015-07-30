Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbbG3Kys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:48 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 14/19] wil6210: remove 3-MSI support
Date: Thu, 30 Jul 2015 13:52:02 +0300
Message-Id: <1438253527-3372-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125456_116511_D6511A10)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the recent kernel versions, multiple MSI is not well supported.
In particular, it is not supported on x86 and ARM architectures.
Also, internal interrupt handling logic is simpler and
more effective when using single interrupt.

Remove support for 3 MSI, convert module parameter
"use_msi" from int with range [0,1,3] to boolean.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 55 +++------------------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  | 56 ++++++----------------------
 drivers/net/wireless/ath/wil6210/wil6210.h   |  3 +-
 3 files changed, 18 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 28ffc18..596d09b 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -541,42 +541,6 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	return rc;
 }
 
-static int wil6210_request_3msi(struct wil6210_priv *wil, int irq)
-{
-	int rc;
-	/*
-	 * IRQ's are in the following order:
-	 * - Tx
-	 * - Rx
-	 * - Misc
-	 */
-
-	rc = request_irq(irq, wil6210_irq_tx, IRQF_SHARED,
-			 WIL_NAME"_tx", wil);
-	if (rc)
-		return rc;
-
-	rc = request_irq(irq + 1, wil6210_irq_rx, IRQF_SHARED,
-			 WIL_NAME"_rx", wil);
-	if (rc)
-		goto free0;
-
-	rc = request_threaded_irq(irq + 2, wil6210_irq_misc,
-				  wil6210_irq_misc_thread,
-				  IRQF_SHARED, WIL_NAME"_misc", wil);
-	if (rc)
-		goto free1;
-
-	return 0;
-	/* error branch */
-free1:
-	free_irq(irq + 1, wil);
-free0:
-	free_irq(irq, wil);
-
-	return rc;
-}
-
 /* can't use wil_ioread32_and_clear because ICC value is not set yet */
 static inline void wil_clear32(void __iomem *addr)
 {
@@ -596,19 +560,16 @@ void wil6210_clear_irq(struct wil6210_priv *wil)
 	wmb(); /* make sure write completed */
 }
 
-int wil6210_init_irq(struct wil6210_priv *wil, int irq)
+int wil6210_init_irq(struct wil6210_priv *wil, int irq, bool use_msi)
 {
 	int rc;
 
-	wil_dbg_misc(wil, "%s() n_msi=%d\n", __func__, wil->n_msi);
+	wil_dbg_misc(wil, "%s(%s)\n", __func__, use_msi ? "MSI" : "INTx");
 
-	if (wil->n_msi == 3)
-		rc = wil6210_request_3msi(wil, irq);
-	else
-		rc = request_threaded_irq(irq, wil6210_hardirq,
-					  wil6210_thread_irq,
-					  wil->n_msi ? 0 : IRQF_SHARED,
-					  WIL_NAME, wil);
+	rc = request_threaded_irq(irq, wil6210_hardirq,
+				  wil6210_thread_irq,
+				  use_msi ? 0 : IRQF_SHARED,
+				  WIL_NAME, wil);
 	return rc;
 }
 
@@ -618,8 +579,4 @@ void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
 
 	wil_mask_irq(wil);
 	free_irq(irq, wil);
-	if (wil->n_msi == 3) {
-		free_irq(irq + 1, wil);
-		free_irq(irq + 2, wil);
-	}
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index aa3ecc6..d065b79 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -21,11 +21,9 @@
 
 #include "wil6210.h"
 
-static int use_msi = 1;
-module_param(use_msi, int, S_IRUGO);
-MODULE_PARM_DESC(use_msi,
-		 " Use MSI interrupt: "
-		 "0 - don't, 1 - (default) - single, or 3");
+static bool use_msi = true;
+module_param(use_msi, bool, S_IRUGO);
+MODULE_PARM_DESC(use_msi, " Use MSI interrupt, default - true");
 
 static
 void wil_set_capabilities(struct wil6210_priv *wil)
@@ -50,24 +48,12 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 
 void wil_disable_irq(struct wil6210_priv *wil)
 {
-	int irq = wil->pdev->irq;
-
-	disable_irq(irq);
-	if (wil->n_msi == 3) {
-		disable_irq(irq + 1);
-		disable_irq(irq + 2);
-	}
+	disable_irq(wil->pdev->irq);
 }
 
 void wil_enable_irq(struct wil6210_priv *wil)
 {
-	int irq = wil->pdev->irq;
-
-	enable_irq(irq);
-	if (wil->n_msi == 3) {
-		enable_irq(irq + 1);
-		enable_irq(irq + 2);
-	}
+	enable_irq(wil->pdev->irq);
 }
 
 /* Bus ops */
@@ -80,6 +66,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	 * and only MSI should be used
 	 */
 	int msi_only = pdev->msi_enabled;
+	bool _use_msi = use_msi;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
@@ -87,41 +74,20 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 
 	pci_set_master(pdev);
 
-	/*
-	 * how many MSI interrupts to request?
-	 */
-	switch (use_msi) {
-	case 3:
-	case 1:
-		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
-		break;
-	case 0:
-		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
-		break;
-	default:
-		wil_err(wil, "Invalid use_msi=%d, default to 1\n", use_msi);
-		use_msi = 1;
-	}
-
-	if (use_msi == 3 && pci_enable_msi_range(pdev, 3, 3) < 0) {
-		wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
-		use_msi = 1;
-	}
+	wil_dbg_misc(wil, "Setup %s interrupt\n", use_msi ? "MSI" : "INTx");
 
-	if (use_msi == 1 && pci_enable_msi(pdev)) {
+	if (use_msi && pci_enable_msi(pdev)) {
 		wil_err(wil, "pci_enable_msi failed, use INTx\n");
-		use_msi = 0;
+		_use_msi = false;
 	}
 
-	wil->n_msi = use_msi;
-
-	if ((wil->n_msi == 0) && msi_only) {
+	if (!_use_msi && msi_only) {
 		wil_err(wil, "Interrupt pin not routed, unable to use INTx\n");
 		rc = -ENODEV;
 		goto stop_master;
 	}
 
-	rc = wil6210_init_irq(wil, pdev->irq);
+	rc = wil6210_init_irq(wil, pdev->irq, _use_msi);
 	if (rc)
 		goto stop_master;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c722724..3c22178 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -536,7 +536,6 @@ struct pmc_ctx {
 
 struct wil6210_priv {
 	struct pci_dev *pdev;
-	int n_msi;
 	struct wireless_dev *wdev;
 	void __iomem *csr;
 	DECLARE_BITMAP(status, wil_status_last);
@@ -739,7 +738,7 @@ void wil_back_tx_worker(struct work_struct *work);
 void wil_back_tx_flush(struct wil6210_priv *wil);
 
 void wil6210_clear_irq(struct wil6210_priv *wil);
-int wil6210_init_irq(struct wil6210_priv *wil, int irq);
+int wil6210_init_irq(struct wil6210_priv *wil, int irq, bool use_msi);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
 void wil_mask_irq(struct wil6210_priv *wil);
 void wil_unmask_irq(struct wil6210_priv *wil);
-- 
2.1.4

