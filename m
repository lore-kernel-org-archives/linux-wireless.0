Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58556 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3KYNK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 08:10:26 -0500
Received: by mail-ea0-f173.google.com with SMTP id g15so2361382eak.32
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 05:10:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 6/8] ath10k: extract functions for legacy irq handling
Date: Mon, 25 Nov 2013 14:06:25 +0100
Message-Id: <1385384787-12470-7-git-send-email-michal.kazior@tieto.com> (sfid-20131125_141044_465615_0219199C)
In-Reply-To: <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
 <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for code re-use. Also use ioread/write
wrappers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * move function definitions up to avoid forward
   declarations in subsequent patches

 drivers/net/wireless/ath/ath10k/pci.c | 65 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bd67311..1d2939c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -220,6 +220,34 @@ static bool ath10k_pci_irq_pending(struct ath10k *ar)
 	return false;
 }
 
+static void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
+{
+	/* IMPORTANT: INTR_CLR register has to be set after
+	 * INTR_ENABLE is set to 0, otherwise interrupt can not be
+	 * really cleared. */
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_ADDRESS,
+			   0);
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_CLR_ADDRESS,
+			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
+
+	/* IMPORTANT: this extra read transaction is required to
+	 * flush the posted write buffer. */
+	(void) ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				 PCIE_INTR_ENABLE_ADDRESS);
+}
+
+static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
+{
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
+			   PCIE_INTR_ENABLE_ADDRESS,
+			   PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_ALL);
+
+	/* IMPORTANT: this extra read transaction is required to
+	 * flush the posted write buffer. */
+	(void) ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				 PCIE_INTR_ENABLE_ADDRESS);
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -2128,25 +2156,7 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 		if (!ath10k_pci_irq_pending(ar))
 			return IRQ_NONE;
 
-		/*
-		 * IMPORTANT: INTR_CLR regiser has to be set after
-		 * INTR_ENABLE is set to 0, otherwise interrupt can not be
-		 * really cleared.
-		 */
-		iowrite32(0, ar_pci->mem +
-			  (SOC_CORE_BASE_ADDRESS |
-			   PCIE_INTR_ENABLE_ADDRESS));
-		iowrite32(PCIE_INTR_FIRMWARE_MASK |
-			  PCIE_INTR_CE_MASK_ALL,
-			  ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
-					 PCIE_INTR_CLR_ADDRESS));
-		/*
-		 * IMPORTANT: this extra read transaction is required to
-		 * flush the posted write buffer.
-		 */
-		(void) ioread32(ar_pci->mem +
-				(SOC_CORE_BASE_ADDRESS |
-				 PCIE_INTR_ENABLE_ADDRESS));
+		ath10k_pci_disable_and_clear_legacy_irq(ar);
 	}
 
 	tasklet_schedule(&ar_pci->intr_tq);
@@ -2162,20 +2172,9 @@ static void ath10k_pci_tasklet(unsigned long data)
 	ath10k_pci_fw_interrupt_handler(ar); /* FIXME: Handle FW error */
 	ath10k_ce_per_engine_service_any(ar);
 
-	if (ar_pci->num_msi_intrs == 0) {
-		/* Enable Legacy PCI line interrupts */
-		iowrite32(PCIE_INTR_FIRMWARE_MASK |
-			  PCIE_INTR_CE_MASK_ALL,
-			  ar_pci->mem + (SOC_CORE_BASE_ADDRESS |
-					 PCIE_INTR_ENABLE_ADDRESS));
-		/*
-		 * IMPORTANT: this extra read transaction is required to
-		 * flush the posted write buffer
-		 */
-		(void) ioread32(ar_pci->mem +
-				(SOC_CORE_BASE_ADDRESS |
-				 PCIE_INTR_ENABLE_ADDRESS));
-	}
+	/* Re-enable legacy irq that was disabled in the irq handler */
+	if (ar_pci->num_msi_intrs == 0)
+		ath10k_pci_enable_legacy_irq(ar);
 }
 
 static int ath10k_pci_request_irq_msix(struct ath10k *ar)
-- 
1.8.4.rc3

