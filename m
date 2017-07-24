Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753506AbdGXRlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 13:41:35 -0400
From: Robin Murphy <robin.murphy@arm.com>
To: imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qtfnmac: Tidy up DMA mask setting
Date: Mon, 24 Jul 2017 18:41:30 +0100
Message-Id: <2c3f47792b2e38d5584d641d98e82f8318fefc72.1500917445.git.robin.murphy@arm.com> (sfid-20170724_194209_308488_AEBE9868)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the only caller of dma_supported() outside of DMA API internals, the
qtfnmac driver stands out and invites scrutiny. Thankfully, it's not
being used for evil, but it is entirely redundant, since it open-codes a
check that the DMA mask setting functions are going to perform anyway.
In fact, the whole qtnf_pcie_init_dma_mask() function is nothing more
than a rather long-winded implementation of dma_set_mask_and_coherent(),
so let's just use that directly.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 28 +---------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 7fc4f0d6a9ad..2c065ffda070 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -274,32 +274,6 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int
-qtnf_pcie_init_dma_mask(struct qtnf_pcie_bus_priv *priv, u64 dma_mask)
-{
-	int ret;
-
-	ret = dma_supported(&priv->pdev->dev, dma_mask);
-	if (!ret) {
-		pr_err("DMA mask %llu not supported\n", dma_mask);
-		return ret;
-	}
-
-	ret = pci_set_dma_mask(priv->pdev, dma_mask);
-	if (ret) {
-		pr_err("failed to set DMA mask %llu\n", dma_mask);
-		return ret;
-	}
-
-	ret = pci_set_consistent_dma_mask(priv->pdev, dma_mask);
-	if (ret) {
-		pr_err("failed to set consistent DMA mask %llu\n", dma_mask);
-		return ret;
-	}
-
-	return ret;
-}
-
 static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
@@ -1212,7 +1186,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	ret = qtnf_pcie_init_dma_mask(pcie_priv, DMA_BIT_MASK(32));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
 		pr_err("PCIE DMA mask init failed\n");
 		goto err_base;
-- 
2.12.2.dirty
