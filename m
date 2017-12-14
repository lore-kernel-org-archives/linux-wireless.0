Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17927 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbdLNQxV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:53:21 -0500
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 2/9] wil6210: support 40bit DMA addresses
Date: Thu, 14 Dec 2017 18:53:06 +0200
Message-Id: <1513270393-919-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171214_175407_693705_D4C1CB75)
In-Reply-To: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

Add the option to support 40bit addresses since some platforms
may not support 48bits but support 40bits

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 26 +++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/pmc.c      | 11 ++++++-----
 drivers/net/wireless/ath/wil6210/txrx.c     | 11 ++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +-
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 42a5480..d4bb0bd 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -206,6 +206,8 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		.fw_recovery = wil_platform_rop_fw_recovery,
 	};
 	u32 bar_size = pci_resource_len(pdev, 0);
+	int dma_addr_size[] = {48, 40, 32}; /* keep descending order */
+	int i;
 
 	/* check HW */
 	dev_info(&pdev->dev, WIL_NAME
@@ -241,21 +243,23 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	/* rollback to err_plat */
 
-	/* device supports 48bit addresses */
-	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
-	if (rc) {
-		dev_err(dev, "dma_set_mask_and_coherent(48) failed: %d\n", rc);
-		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	/* device supports >32bit addresses */
+	for (i = 0; i < ARRAY_SIZE(dma_addr_size); i++) {
+		rc = dma_set_mask_and_coherent(dev,
+					       DMA_BIT_MASK(dma_addr_size[i]));
 		if (rc) {
-			dev_err(dev,
-				"dma_set_mask_and_coherent(32) failed: %d\n",
-				rc);
-			goto err_plat;
+			dev_err(dev, "dma_set_mask_and_coherent(%d) failed: %d\n",
+				dma_addr_size[i], rc);
+			continue;
 		}
-	} else {
-		wil->use_extended_dma_addr = 1;
+		dev_info(dev, "using dma mask %d", dma_addr_size[i]);
+		wil->dma_addr_size = dma_addr_size[i];
+		break;
 	}
 
+	if (wil->dma_addr_size == 0)
+		goto err_plat;
+
 	rc = pci_enable_device(pdev);
 	if (rc && pdev->msi_enabled == 0) {
 		wil_err(wil,
diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index 2e301b6..4ea27b0 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -111,14 +111,14 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 	 *
 	 * HW has limitation that all vrings addresses must share the same
 	 * upper 16 msb bits part of 48 bits address. To workaround that,
-	 * if we are using 48 bit addresses switch to 32 bit allocation
-	 * before allocating vring memory.
+	 * if we are using more than 32 bit addresses switch to 32 bit
+	 * allocation before allocating vring memory.
 	 *
 	 * There's no check for the return value of dma_set_mask_and_coherent,
 	 * since we assume if we were able to set the mask during
 	 * initialization in this system it will not fail if we set it again
 	 */
-	if (wil->use_extended_dma_addr)
+	if (wil->dma_addr_size > 32)
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 
 	pmc->pring_va = dma_alloc_coherent(dev,
@@ -126,8 +126,9 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 			&pmc->pring_pa,
 			GFP_KERNEL);
 
-	if (wil->use_extended_dma_addr)
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (wil->dma_addr_size > 32)
+		dma_set_mask_and_coherent(dev,
+					  DMA_BIT_MASK(wil->dma_addr_size));
 
 	wil_dbg_misc(wil,
 		     "pmc_alloc: allocated pring %p => %pad. %zd x %d = total %zd bytes\n",
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 389c718..62c04f0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -178,14 +178,14 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 	 *
 	 * HW has limitation that all vrings addresses must share the same
 	 * upper 16 msb bits part of 48 bits address. To workaround that,
-	 * if we are using 48 bit addresses switch to 32 bit allocation
-	 * before allocating vring memory.
+	 * if we are using more than 32 bit addresses switch to 32 bit
+	 * allocation before allocating vring memory.
 	 *
 	 * There's no check for the return value of dma_set_mask_and_coherent,
 	 * since we assume if we were able to set the mask during
 	 * initialization in this system it will not fail if we set it again
 	 */
-	if (wil->use_extended_dma_addr)
+	if (wil->dma_addr_size > 32)
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 
 	vring->va = dma_alloc_coherent(dev, sz, &vring->pa, GFP_KERNEL);
@@ -195,8 +195,9 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 		return -ENOMEM;
 	}
 
-	if (wil->use_extended_dma_addr)
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (wil->dma_addr_size > 32)
+		dma_set_mask_and_coherent(dev,
+					  DMA_BIT_MASK(wil->dma_addr_size));
 
 	/* initially, all descriptors are SW owned
 	 * For Tx and Rx, ownership bit is at the same location, thus
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index aa85e9c..db68209 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -704,7 +704,7 @@ struct wil6210_priv {
 	struct wil_sta_info sta[WIL6210_MAX_CID];
 	int bcast_vring;
 	u32 vring_idle_trsh; /* HW fetches up to 16 descriptors at once  */
-	bool use_extended_dma_addr; /* indicates whether we are using 48 bits */
+	u32 dma_addr_size; /* indicates dma addr size */
 	/* scan */
 	struct cfg80211_scan_request *scan_request;
 
-- 
1.9.1
