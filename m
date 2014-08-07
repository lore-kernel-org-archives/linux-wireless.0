Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63739 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbaHGJNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:11 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so3828900wgh.18
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/6] ath10k: group some pci probing helpers
Date: Thu,  7 Aug 2014 11:03:30 +0200
Message-Id: <1407402212-29809-5-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111333_047862_CE7911D7)
In-Reply-To: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make probe/remove functions shorter and easier to
understand.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 134 +++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c31edb6..cfc1da2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2483,86 +2483,116 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_probe(struct pci_dev *pdev,
-			    const struct pci_device_id *pci_dev)
+static int ath10k_pci_claim(struct ath10k *ar)
 {
-	void __iomem *mem;
-	int ret = 0;
-	struct ath10k *ar;
-	struct ath10k_pci *ar_pci;
-	u32 lcr_val, chip_id;
-
-	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
-
-	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev,
-				&ath10k_pci_hif_ops);
-	if (!ar) {
-		ath10k_err("failed to allocate core\n");
-		return -ENOMEM;
-	}
-
-	ar_pci = ath10k_pci_priv(ar);
-	ar_pci->pdev = pdev;
-	ar_pci->dev = &pdev->dev;
-	ar_pci->ar = ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct pci_dev *pdev = ar_pci->pdev;
+	u32 lcr_val;
+	int ret;
 
 	pci_set_drvdata(pdev, ar);
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
-		ath10k_err("failed to enable PCI device: %d\n", ret);
-		goto err_core_destroy;
+		ath10k_err("failed to enable pci device: %d\n", ret);
+		return ret;
 	}
 
-	/* Request MMIO resources */
 	ret = pci_request_region(pdev, BAR_NUM, "ath");
 	if (ret) {
-		ath10k_err("failed to request MMIO region: %d\n", ret);
+		ath10k_err("failed to request region BAR%d: %d\n", BAR_NUM,
+			   ret);
 		goto err_device;
 	}
 
-	/*
-	 * Target structures have a limit of 32 bit DMA pointers.
-	 * DMA pointers can be wider than 32 bits by default on some systems.
-	 */
+	/* Target expects 32 bit DMA. Enforce it. */
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("failed to set DMA mask to 32-bit: %d\n", ret);
+		ath10k_err("failed to set dma mask to 32-bit: %d\n", ret);
 		goto err_region;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("failed to set consistent DMA mask to 32-bit\n");
+		ath10k_err("failed to set consistent dma mask to 32-bit: %d\n",
+			   ret);
 		goto err_region;
 	}
 
-	/* Set bus master bit in PCI_COMMAND to enable DMA */
 	pci_set_master(pdev);
 
-	/*
-	 * Temporary FIX: disable ASPM
-	 * Will be removed after the OTP is programmed
-	 */
+	/* Workaround: Disable ASPM */
 	pci_read_config_dword(pdev, 0x80, &lcr_val);
 	pci_write_config_dword(pdev, 0x80, (lcr_val & 0xffffff00));
 
 	/* Arrange for access to Target SoC registers. */
-	mem = pci_iomap(pdev, BAR_NUM, 0);
-	if (!mem) {
-		ath10k_err("failed to perform IOMAP for BAR%d\n", BAR_NUM);
+	ar_pci->mem = pci_iomap(pdev, BAR_NUM, 0);
+	if (!ar_pci->mem) {
+		ath10k_err("failed to iomap BAR%d\n", BAR_NUM);
 		ret = -EIO;
 		goto err_master;
 	}
 
-	ar_pci->mem = mem;
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
+	return 0;
+
+err_master:
+	pci_clear_master(pdev);
+
+err_region:
+	pci_release_region(pdev, BAR_NUM);
+
+err_device:
+	pci_disable_device(pdev);
+
+	return ret;
+}
+
+static void ath10k_pci_release(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct pci_dev *pdev = ar_pci->pdev;
+
+	pci_iounmap(pdev, ar_pci->mem);
+	pci_release_region(pdev, BAR_NUM);
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+}
+
+static int ath10k_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *pci_dev)
+{
+	int ret = 0;
+	struct ath10k *ar;
+	struct ath10k_pci *ar_pci;
+	u32 chip_id;
+
+	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
+
+	ar = ath10k_core_create(sizeof(*ar_pci), &pdev->dev,
+				&ath10k_pci_hif_ops);
+	if (!ar) {
+		ath10k_err("failed to allocate core\n");
+		return -ENOMEM;
+	}
+
+	ar_pci = ath10k_pci_priv(ar);
+	ar_pci->pdev = pdev;
+	ar_pci->dev = &pdev->dev;
+	ar_pci->ar = ar;
 
 	spin_lock_init(&ar_pci->ce_lock);
 
+	ret = ath10k_pci_claim(ar);
+	if (ret) {
+		ath10k_err("failed to claim device: %d\n", ret);
+		goto err_core_destroy;
+	}
+
 	ret = ath10k_pci_wake(ar);
 	if (ret) {
 		ath10k_err("failed to wake up: %d\n", ret);
-		goto err_iomap;
+		goto err_release;
 	}
 
 	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
@@ -2577,8 +2607,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
-
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("failed to register driver core: %d\n", ret);
@@ -2589,16 +2617,13 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 err_free_ce:
 	ath10k_pci_free_ce(ar);
+
 err_sleep:
 	ath10k_pci_sleep(ar);
-err_iomap:
-	pci_iounmap(pdev, mem);
-err_master:
-	pci_clear_master(pdev);
-err_region:
-	pci_release_region(pdev, BAR_NUM);
-err_device:
-	pci_disable_device(pdev);
+
+err_release:
+	ath10k_pci_release(ar);
+
 err_core_destroy:
 	ath10k_core_destroy(ar);
 
@@ -2623,12 +2648,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_ce(ar);
 	ath10k_pci_sleep(ar);
-
-	pci_iounmap(pdev, ar_pci->mem);
-	pci_release_region(pdev, BAR_NUM);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
-
+	ath10k_pci_release(ar);
 	ath10k_core_destroy(ar);
 }
 
-- 
1.8.5.3

