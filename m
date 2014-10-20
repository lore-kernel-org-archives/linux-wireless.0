Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40267 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJTM2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:32 -0400
Received: by mail-lb0-f180.google.com with SMTP id n15so3721671lbi.39
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/6] ath10k: mask/unmask msi fw irq
Date: Mon, 20 Oct 2014 14:14:38 +0200
Message-Id: <1413807282-27951-3-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142836_689385_7CAB088D)
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was the final missing bit to making sure the
device doesn't assert interrupts to host.

This should fix possible race when target crashes
during driver teardown.

This also removes an early warm reset workaround
during pci probing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * remove workaround from pci probe that used warm reset

 drivers/net/wireless/ath/ath10k/hw.h  |  1 +
 drivers/net/wireless/ath/ath10k/pci.c | 53 ++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5dd6551..6242319 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -289,6 +289,7 @@ struct ath10k_pktlog_hdr {
 #define SI_RX_DATA1_OFFSET			0x00000014
 
 #define CORE_CTRL_CPU_INTR_MASK			0x00002000
+#define CORE_CTRL_PCIE_REG_31_MASK		0x00000800
 #define CORE_CTRL_ADDRESS			0x0000
 #define PCIE_INTR_ENABLE_ADDRESS		0x0008
 #define PCIE_INTR_CAUSE_ADDRESS			0x000c
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6077095..5c5a9e7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1143,14 +1143,37 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 						 &dl_is_polled);
 }
 
-static void ath10k_pci_irq_disable(struct ath10k *ar)
+static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int i;
+	u32 val;
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS);
+	val &= ~CORE_CTRL_PCIE_REG_31_MASK;
+
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS, val);
+}
+
+static void ath10k_pci_irq_msi_fw_unmask(struct ath10k *ar)
+{
+	u32 val;
+
+	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS);
+	val |= CORE_CTRL_PCIE_REG_31_MASK;
+
+	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + CORE_CTRL_ADDRESS, val);
+}
 
+static void ath10k_pci_irq_disable(struct ath10k *ar)
+{
 	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_disable_and_clear_legacy_irq(ar);
-	/* FIXME: How to mask all MSI interrupts? */
+	ath10k_pci_irq_msi_fw_mask(ar);
+}
+
+static void ath10k_pci_irq_sync(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
 
 	for (i = 0; i < max(1, ar_pci->num_msi_intrs); i++)
 		synchronize_irq(ar_pci->pdev->irq + i);
@@ -1160,7 +1183,7 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 {
 	ath10k_ce_enable_interrupts(ar);
 	ath10k_pci_enable_legacy_irq(ar);
-	/* FIXME: How to unmask all MSI interrupts? */
+	ath10k_pci_irq_msi_fw_unmask(ar);
 }
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
@@ -1288,6 +1311,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_warm_reset(ar);
 
 	ath10k_pci_irq_disable(ar);
+	ath10k_pci_irq_sync(ar);
 	ath10k_pci_flush(ar);
 }
 
@@ -2285,6 +2309,7 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 	} while (time_before(jiffies, timeout));
 
 	ath10k_pci_disable_and_clear_legacy_irq(ar);
+	ath10k_pci_irq_msi_fw_mask(ar);
 
 	if (val == 0xffffffff) {
 		ath10k_err(ar, "failed to read device register, device is gone\n");
@@ -2477,20 +2502,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	ath10k_pci_ce_deinit(ar);
-
-	ret = ath10k_ce_disable_interrupts(ar);
-	if (ret) {
-		ath10k_err(ar, "failed to disable copy engine interrupts: %d\n",
-			   ret);
-		goto err_free_ce;
-	}
-
-	/* Workaround: There's no known way to mask all possible interrupts via
-	 * device CSR. The only way to make sure device doesn't assert
-	 * interrupts is to reset it. Interrupts are then disabled on host
-	 * after handlers are registered.
-	 */
-	ath10k_pci_warm_reset(ar);
+	ath10k_pci_irq_disable(ar);
 
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
@@ -2508,9 +2520,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_deinit_irq;
 	}
 
-	/* This shouldn't race as the device has been reset above. */
-	ath10k_pci_irq_disable(ar);
-
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
-- 
1.8.5.3

