Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:55552
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750946AbeBJOEf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 09:04:35 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 1/4] qtnfmac: fix releasing Tx/Rx data buffers
Date: Sat, 10 Feb 2018 17:04:17 +0300
Message-Id: <20180210140420.17013-2-sergey.matyukevich.os@quantenna.com> (sfid-20180210_150444_245001_C82BDE8F)
In-Reply-To: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
References: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing PCI unmap for Tx buffers and release all buffers explicitly.
Managed release using devm_add_action is not suitable for qtnfmac Tx/Rx
data buffers. The reason is in ordering and dependencies: buffers
should be released after transmission is stopped but before PCI
device resources and DMA allocations are released.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 30 +++++++++++++---------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 6f6190964320..be5813aa1486 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -478,10 +478,11 @@ static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
 }
 
 /* all rx/tx activity should have ceased before calling this function */
-static void free_xfer_buffers(void *data)
+static void qtnf_free_xfer_buffers(struct qtnf_pcie_bus_priv *priv)
 {
-	struct qtnf_pcie_bus_priv *priv = (struct qtnf_pcie_bus_priv *)data;
+	struct qtnf_tx_bd *txbd;
 	struct qtnf_rx_bd *rxbd;
+	struct sk_buff *skb;
 	dma_addr_t paddr;
 	int i;
 
@@ -489,19 +490,26 @@ static void free_xfer_buffers(void *data)
 	for (i = 0; i < priv->rx_bd_num; i++) {
 		if (priv->rx_skb && priv->rx_skb[i]) {
 			rxbd = &priv->rx_bd_vbase[i];
+			skb = priv->rx_skb[i];
 			paddr = QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 					      le32_to_cpu(rxbd->addr));
 			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
 					 PCI_DMA_FROMDEVICE);
-
-			dev_kfree_skb_any(priv->rx_skb[i]);
+			dev_kfree_skb_any(skb);
+			priv->rx_skb[i] = NULL;
 		}
 	}
 
 	/* free tx buffers */
 	for (i = 0; i < priv->tx_bd_num; i++) {
 		if (priv->tx_skb && priv->tx_skb[i]) {
-			dev_kfree_skb_any(priv->tx_skb[i]);
+			txbd = &priv->tx_bd_vbase[i];
+			skb = priv->tx_skb[i];
+			paddr = QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
+					      le32_to_cpu(txbd->addr));
+			pci_unmap_single(priv->pdev, paddr, skb->len,
+					 PCI_DMA_TODEVICE);
+			dev_kfree_skb_any(skb);
 			priv->tx_skb[i] = NULL;
 		}
 	}
@@ -1321,12 +1329,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	ret = devm_add_action(&pdev->dev, free_xfer_buffers, (void *)pcie_priv);
-	if (ret) {
-		pr_err("custom release callback init failed\n");
-		goto err_base;
-	}
-
 	ret = qtnf_pcie_init_xfer(pcie_priv);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
@@ -1343,7 +1345,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			       "qtnf_pcie_irq", (void *)bus);
 	if (ret) {
 		pr_err("failed to request pcie irq %d\n", pdev->irq);
-		goto err_base;
+		goto err_xfer;
 	}
 
 	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
@@ -1387,6 +1389,9 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_bringup_fw:
 	netif_napi_del(&bus->mux_napi);
 
+err_xfer:
+	qtnf_free_xfer_buffers(pcie_priv);
+
 err_base:
 	flush_workqueue(pcie_priv->workqueue);
 	destroy_workqueue(pcie_priv->workqueue);
@@ -1416,6 +1421,7 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 	destroy_workqueue(priv->workqueue);
 	tasklet_kill(&priv->reclaim_tq);
 
+	qtnf_free_xfer_buffers(priv);
 	qtnf_debugfs_remove(bus);
 
 	qtnf_pcie_free_shm_ipc(priv);
-- 
2.11.0
