Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751468AbdHONG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:06:59 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 4/9] qtnfmac: skb2rbd_attach cleanup
Date: Tue, 15 Aug 2017 16:06:34 +0300
Message-Id: <20170815130638.31718-5-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150709_301835_63881E02)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update PCIE_HDP_TX_HOST_Q_WR_PTR register in skb2rbd_attach as a part of
procedure of passing new Rx buffer to hardware. Sync up all the the
qtnf_rx_bd descriptor updates before passing Rx buffer to hardware.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 31 +++++++++-------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 079aa1693ff5..a0b65d487ddb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -411,11 +411,6 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
 	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
 
-	priv->hw_txproc_wr_ptr = priv->rx_bd_num - rx_bd_reserved_param;
-
-	writel(priv->hw_txproc_wr_ptr,
-	       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
-
 	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
 
 	priv->rx_bd_index = 0;
@@ -423,7 +418,7 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 	return 0;
 }
 
-static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
+static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
 {
 	struct qtnf_rx_bd *rxbd;
 	struct sk_buff *skb;
@@ -431,13 +426,12 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
 
 	skb = __netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE, GFP_ATOMIC);
 	if (!skb) {
-		priv->rx_skb[rx_bd_index] = NULL;
+		priv->rx_skb[index] = NULL;
 		return -ENOMEM;
 	}
 
-	priv->rx_skb[rx_bd_index] = skb;
-
-	rxbd = &priv->rx_bd_vbase[rx_bd_index];
+	priv->rx_skb[index] = skb;
+	rxbd = &priv->rx_bd_vbase[index];
 
 	paddr = pci_map_single(priv->pdev, skb->data,
 			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
@@ -446,17 +440,20 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 rx_bd_index)
 		return -ENOMEM;
 	}
 
-	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
-	writel(QTN_HOST_HI32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
-
 	/* keep rx skb paddrs in rx buffer descriptors for cleanup purposes */
 	rxbd->addr = cpu_to_le32(QTN_HOST_LO32(paddr));
 	rxbd->addr_h = cpu_to_le32(QTN_HOST_HI32(paddr));
-
 	rxbd->info = 0x0;
 
+	/* sync up all descriptor updates */
+	wmb();
+
+	writel(QTN_HOST_HI32(paddr),
+	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+	writel(QTN_HOST_LO32(paddr),
+	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
+
+	writel(index, PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
 	return 0;
 }
 
@@ -787,8 +784,6 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 			break;
 		}
 
-		writel(priv->hw_txproc_wr_ptr,
-		       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
 	}
 
 	if (processed < budget) {
-- 
2.11.0
