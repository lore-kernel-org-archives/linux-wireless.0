Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:53391 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbbAPLVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:21:05 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so19696720wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:21:04 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: reset chip before reading chip_id in probe
Date: Fri, 16 Jan 2015 12:20:35 +0100
Message-Id: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com> (sfid-20150116_122110_692009_02BC9D73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some very rare cases with some hardware
configuration that the device doesn't init quickly
enough in which case reading chip_id yielded 0.
This caused driver to subsequently fail to setup
the device.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3b40a86..6a512fb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2544,18 +2544,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_release;
 	}
 
-	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (chip_id == 0xffffffff) {
-		ath10k_err(ar, "failed to get chip id\n");
-		goto err_sleep;
-	}
-
-	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
-		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
-			   pdev->device, chip_id);
-		goto err_sleep;
-	}
-
 	ret = ath10k_pci_alloc_pipes(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to allocate copy engine pipes: %d\n",
@@ -2582,6 +2570,24 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_deinit_irq;
 	}
 
+	ret = ath10k_pci_chip_reset(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to reset chip: %d\n", ret);
+		goto err_free_irq;
+	}
+
+	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+	if (chip_id == 0xffffffff) {
+		ath10k_err(ar, "failed to get chip id\n");
+		goto err_free_irq;
+	}
+
+	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
+		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+			   pdev->device, chip_id);
+		goto err_sleep;
+	}
+
 	ath10k_pci_sleep(ar);
 
 	ret = ath10k_core_register(ar, chip_id);
-- 
1.8.5.3

