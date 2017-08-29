Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:63111
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753616AbdH2MRO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:14 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 5/5] qtnfmac: implement 64-bit dma support
Date: Tue, 29 Aug 2017 15:16:23 +0300
Message-Id: <20170829121623.24761-6-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141722_634242_C4A5AE97)
In-Reply-To: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 64-bit dma for hosts with CONFIG_ARCH_DMA_ADDR_T_64BIT enabled.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 70 ++++++++++++++++++----
 .../wireless/quantenna/qtnfmac/pearl/pcie_ipc.h    | 10 ++--
 .../quantenna/qtnfmac/pearl/pcie_regs_pearl.h      |  1 +
 3 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 2921d8069bf2..502e72b7cdcc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -403,10 +403,12 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
 	priv->rx_bd_vbase = vaddr;
 	priv->rx_bd_pbase = paddr;
 
-	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
 	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
+#endif
+	writel(QTN_HOST_LO32(paddr),
+	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
 	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
 	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
 
@@ -447,8 +449,10 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
 	/* sync up all descriptor updates */
 	wmb();
 
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
 	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+#endif
 	writel(QTN_HOST_LO32(paddr),
 	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
 
@@ -503,9 +507,28 @@ static void free_xfer_buffers(void *data)
 	}
 }
 
+static int qtnf_hhbm_init(struct qtnf_pcie_bus_priv *priv)
+{
+	u32 val;
+
+	val = readl(PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	val |= HHBM_CONFIG_SOFT_RESET;
+	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	usleep_range(50, 100);
+	val &= ~HHBM_CONFIG_SOFT_RESET;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	val |= HHBM_64BIT;
+#endif
+	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	writel(priv->rx_bd_num, PCIE_HHBM_Q_LIMIT_REG(priv->pcie_reg_base));
+
+	return 0;
+}
+
 static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 {
 	int ret;
+	u32 val;
 
 	priv->tx_bd_num = tx_bd_size_param;
 	priv->rx_bd_num = rx_bd_size_param;
@@ -518,12 +541,32 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 		return -EINVAL;
 	}
 
+	val = priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+	if (val > PCIE_HHBM_MAX_SIZE) {
+		pr_err("tx_bd_size_param %u is too large\n",
+		       priv->tx_bd_num);
+		return -EINVAL;
+	}
+
 	if (!priv->rx_bd_num || !is_power_of_2(priv->rx_bd_num)) {
 		pr_err("rx_bd_size_param %u is not power of two\n",
 		       priv->rx_bd_num);
 		return -EINVAL;
 	}
 
+	val = priv->rx_bd_num * sizeof(dma_addr_t);
+	if (val > PCIE_HHBM_MAX_SIZE) {
+		pr_err("rx_bd_size_param %u is too large\n",
+		       priv->rx_bd_num);
+		return -EINVAL;
+	}
+
+	ret = qtnf_hhbm_init(priv);
+	if (ret) {
+		pr_err("failed to init h/w queues\n");
+		return ret;
+	}
+
 	ret = alloc_skb_array(priv);
 	if (ret) {
 		pr_err("failed to allocate skb array\n");
@@ -653,10 +696,13 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 
 	/* write new TX descriptor to PCIE_RX_FIFO on EP */
 	txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_tx_bd);
-	writel(QTN_HOST_LO32(txbd_paddr),
-	       PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
+
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(txbd_paddr),
 	       PCIE_HDP_HOST_WR_DESC0_H(priv->pcie_reg_base));
+#endif
+	writel(QTN_HOST_LO32(txbd_paddr),
+	       PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
 
 	if (++i >= priv->tx_bd_num)
 		i = 0;
@@ -1237,6 +1283,16 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pr_debug("successful init of PCI device %x\n", pdev->device);
 	}
 
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+#else
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+#endif
+	if (ret) {
+		pr_err("PCIE DMA coherent mask init failed\n");
+		goto err_base;
+	}
+
 	pcim_pin_device(pdev);
 	pci_set_master(pdev);
 
@@ -1258,12 +1314,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-	if (ret) {
-		pr_err("PCIE DMA mask init failed\n");
-		goto err_base;
-	}
-
 	ret = devm_add_action(&pdev->dev, free_xfer_buffers, (void *)pcie_priv);
 	if (ret) {
 		pr_err("custom release callback init failed\n");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
index 667f5ec457e3..c5a4e46d26ef 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
@@ -57,16 +57,14 @@
 	| PCIE_HDP_INT_EP_RXDMA		\
 	)
 
-#if BITS_PER_LONG == 64
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 #define QTN_HOST_HI32(a)	((u32)(((u64)a) >> 32))
 #define QTN_HOST_LO32(a)	((u32)(((u64)a) & 0xffffffffUL))
 #define QTN_HOST_ADDR(h, l)	((((u64)h) << 32) | ((u64)l))
-#elif BITS_PER_LONG == 32
+#else
 #define QTN_HOST_HI32(a)	0
 #define QTN_HOST_LO32(a)	((u32)(((u32)a) & 0xffffffffUL))
 #define QTN_HOST_ADDR(h, l)	((u32)l)
-#else
-#error Unexpected BITS_PER_LONG value
 #endif
 
 #define QTN_SYSCTL_BAR	0
@@ -76,7 +74,7 @@
 #define QTN_PCIE_BDA_VERSION		0x1002
 
 #define PCIE_BDA_NAMELEN		32
-#define PCIE_HHBM_MAX_SIZE		512
+#define PCIE_HHBM_MAX_SIZE		2048
 
 #define SKB_BUF_SIZE		2048
 
@@ -113,7 +111,7 @@ struct qtnf_pcie_bda {
 	__le32 bda_flashsz;
 	u8 bda_boardname[PCIE_BDA_NAMELEN];
 	__le32 bda_rc_msi_enabled;
-	__le32 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
+	u8 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
 	__le32 bda_dsbw_start_index;
 	__le32 bda_dsbw_end_index;
 	__le32 bda_dsbw_total_bytes;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
index 69696f118769..5b48b425fa7f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
@@ -109,6 +109,7 @@
 #define HHBM_WR_REQ				(BIT(0))
 #define HHBM_RD_REQ				(BIT(1))
 #define HHBM_DONE				(BIT(31))
+#define HHBM_64BIT				(BIT(10))
 
 /* offsets for dual PCIE */
 #define PCIE_PORT_LINK_CTL(base)		((base) + 0x0710)
-- 
2.11.0
