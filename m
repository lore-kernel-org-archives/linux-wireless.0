Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0D8C43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA86E208D9
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA86E208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbeIYETt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:49 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46857 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728647AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOE012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 04/11] qtnfmac_pcie: indicate pearl-specific structures by their names
Date:   Mon, 24 Sep 2018 15:15:07 -0700
Message-Id: <20180924221514.4273-5-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to extract common PCIe driver state, indicate
PEARL-specific structures by their name and move them to pearl-specific
source file.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 89 +++++++++++++++++-----
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        | 47 ------------
 2 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index ab06eca..4e9eb46 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -54,6 +54,53 @@ MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
 
 #define DRV_NAME	"qtnfmac_pearl_pcie"
 
+struct qtnf_pearl_bda {
+	__le16 bda_len;
+	__le16 bda_version;
+	__le32 bda_pci_endian;
+	__le32 bda_ep_state;
+	__le32 bda_rc_state;
+	__le32 bda_dma_mask;
+	__le32 bda_msi_addr;
+	__le32 bda_flashsz;
+	u8 bda_boardname[PCIE_BDA_NAMELEN];
+	__le32 bda_rc_msi_enabled;
+	u8 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
+	__le32 bda_dsbw_start_index;
+	__le32 bda_dsbw_end_index;
+	__le32 bda_dsbw_total_bytes;
+	__le32 bda_rc_tx_bd_base;
+	__le32 bda_rc_tx_bd_num;
+	u8 bda_pcie_mac[QTN_ENET_ADDR_LENGTH];
+	struct qtnf_shm_ipc_region bda_shm_reg1 __aligned(4096); /* host TX */
+	struct qtnf_shm_ipc_region bda_shm_reg2 __aligned(4096); /* host RX */
+} __packed;
+
+struct qtnf_pearl_tx_bd {
+	__le32 addr;
+	__le32 addr_h;
+	__le32 info;
+	__le32 info_h;
+} __packed;
+
+struct qtnf_pearl_rx_bd {
+	__le32 addr;
+	__le32 addr_h;
+	__le32 info;
+	__le32 info_h;
+	__le32 next_ptr;
+	__le32 next_ptr_h;
+} __packed;
+
+struct qtnf_pearl_fw_hdr {
+	u8 boardflg[8];
+	__le32 fwsize;
+	__le32 seqnum;
+	__le32 type;
+	__le32 pktlen;
+	__le32 crc;
+} __packed;
+
 struct qtnf_pcie_pearl_state {
 	struct pci_dev  *pdev;
 
@@ -78,7 +125,7 @@ struct qtnf_pcie_pearl_state {
 	struct qtnf_shm_ipc shm_ipc_ep_in;
 	struct qtnf_shm_ipc shm_ipc_ep_out;
 
-	struct qtnf_pcie_bda __iomem *bda;
+	struct qtnf_pearl_bda __iomem *bda;
 	void __iomem *pcie_reg_base;
 
 	u16 tx_bd_num;
@@ -87,10 +134,10 @@ struct qtnf_pcie_pearl_state {
 	struct sk_buff **tx_skb;
 	struct sk_buff **rx_skb;
 
-	struct qtnf_tx_bd *tx_bd_vbase;
+	struct qtnf_pearl_tx_bd *tx_bd_vbase;
 	dma_addr_t tx_bd_pbase;
 
-	struct qtnf_rx_bd *rx_bd_vbase;
+	struct qtnf_pearl_rx_bd *rx_bd_vbase;
 	dma_addr_t rx_bd_pbase;
 
 	dma_addr_t bd_table_paddr;
@@ -445,8 +492,8 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 	void *vaddr;
 	int len;
 
-	len = priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
-		priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
+	len = priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd) +
+		priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd);
 
 	vaddr = dmam_alloc_coherent(&priv->pdev->dev, len, &paddr, GFP_KERNEL);
 	if (!vaddr)
@@ -470,8 +517,8 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 
 	/* rx bd */
 
-	vaddr = ((struct qtnf_tx_bd *)vaddr) + priv->tx_bd_num;
-	paddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+	vaddr = ((struct qtnf_pearl_tx_bd *)vaddr) + priv->tx_bd_num;
+	paddr += priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
 
 	priv->rx_bd_vbase = vaddr;
 	priv->rx_bd_pbase = paddr;
@@ -482,7 +529,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 #endif
 	writel(QTN_HOST_LO32(paddr),
 	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
-	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
+	writel(priv->rx_bd_num | (sizeof(struct qtnf_pearl_rx_bd)) << 16,
 	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
 
 	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n", vaddr, &paddr);
@@ -492,7 +539,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 
 static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 {
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
@@ -539,7 +586,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
 	int ret = 0;
 
 	memset(priv->rx_bd_vbase, 0x0,
-	       priv->rx_bd_num * sizeof(struct qtnf_rx_bd));
+	       priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
 
 	for (i = 0; i < priv->rx_bd_num; i++) {
 		ret = skb2rbd_attach(priv, i);
@@ -553,8 +600,8 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
 /* all rx/tx activity should have ceased before calling this function */
 static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 {
-	struct qtnf_tx_bd *txbd;
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_tx_bd *txbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 	int i;
@@ -622,7 +669,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 		return -EINVAL;
 	}
 
-	val = priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+	val = priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
 	if (val > PCIE_HHBM_MAX_SIZE) {
 		pr_err("tx_bd_size_param %u is too large\n",
 		       priv->tx_bd_num);
@@ -671,7 +718,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 
 static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 {
-	struct qtnf_tx_bd *txbd;
+	struct qtnf_pearl_tx_bd *txbd;
 	struct sk_buff *skb;
 	unsigned long flags;
 	dma_addr_t paddr;
@@ -741,7 +788,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
 	struct qtnf_pcie_pearl_state *priv = (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
-	struct qtnf_tx_bd *txbd;
+	struct qtnf_pearl_tx_bd *txbd;
 	unsigned long flags;
 	int len, i;
 	u32 info;
@@ -782,7 +829,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	dma_wmb();
 
 	/* write new TX descriptor to PCIE_RX_FIFO on EP */
-	txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_tx_bd);
+	txbd_paddr = priv->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(txbd_paddr),
@@ -874,7 +921,7 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 index = priv->rx_bd_r_index;
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	u32 descw;
 
 	rxbd = &priv->rx_bd_vbase[index];
@@ -893,7 +940,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = NULL;
 	struct sk_buff *skb = NULL;
 	int processed = 0;
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	dma_addr_t skb_paddr;
 	int consume;
 	u32 descw;
@@ -1124,7 +1171,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
 	struct pci_dev *pdev = priv->pdev;
 	struct qtnf_bus *bus = pci_get_drvdata(pdev);
 
-	struct qtnf_pcie_fw_hdr *hdr;
+	struct qtnf_pearl_fw_hdr *hdr;
 	u8 *pdata;
 
 	int hds = sizeof(*hdr);
@@ -1139,7 +1186,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
 	skb->len = QTN_PCIE_FW_BUFSZ;
 	skb->dev = NULL;
 
-	hdr = (struct qtnf_pcie_fw_hdr *)skb->data;
+	hdr = (struct qtnf_pearl_fw_hdr *)skb->data;
 	memcpy(hdr->boardflg, QTN_PCIE_BOARDFLG, strlen(QTN_PCIE_BOARDFLG));
 	hdr->fwsize = cpu_to_le32(size);
 	hdr->seqnum = cpu_to_le32(blk);
@@ -1169,7 +1216,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t size,
 static int
 qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_size)
 {
-	int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
+	int blk_size = QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pearl_fw_hdr);
 	int blk_count = fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
 	const u8 *pblk = fw;
 	int threshold = 0;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index 00bb21a..af528b8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -101,44 +101,6 @@ enum qtnf_pcie_bda_ipc_flags {
 	QTN_PCIE_IPC_FLAG_SHM_PIO	= BIT(1),
 };
 
-struct qtnf_pcie_bda {
-	__le16 bda_len;
-	__le16 bda_version;
-	__le32 bda_pci_endian;
-	__le32 bda_ep_state;
-	__le32 bda_rc_state;
-	__le32 bda_dma_mask;
-	__le32 bda_msi_addr;
-	__le32 bda_flashsz;
-	u8 bda_boardname[PCIE_BDA_NAMELEN];
-	__le32 bda_rc_msi_enabled;
-	u8 bda_hhbm_list[PCIE_HHBM_MAX_SIZE];
-	__le32 bda_dsbw_start_index;
-	__le32 bda_dsbw_end_index;
-	__le32 bda_dsbw_total_bytes;
-	__le32 bda_rc_tx_bd_base;
-	__le32 bda_rc_tx_bd_num;
-	u8 bda_pcie_mac[QTN_ENET_ADDR_LENGTH];
-	struct qtnf_shm_ipc_region bda_shm_reg1 __aligned(4096); /* host TX */
-	struct qtnf_shm_ipc_region bda_shm_reg2 __aligned(4096); /* host RX */
-} __packed;
-
-struct qtnf_tx_bd {
-	__le32 addr;
-	__le32 addr_h;
-	__le32 info;
-	__le32 info_h;
-} __packed;
-
-struct qtnf_rx_bd {
-	__le32 addr;
-	__le32 addr_h;
-	__le32 info;
-	__le32 info_h;
-	__le32 next_ptr;
-	__le32 next_ptr_h;
-} __packed;
-
 enum qtnf_fw_loadtype {
 	QTN_FW_DBEGIN,
 	QTN_FW_DSUB,
@@ -146,13 +108,4 @@ enum qtnf_fw_loadtype {
 	QTN_FW_CTRL
 };
 
-struct qtnf_pcie_fw_hdr {
-	u8 boardflg[8];
-	__le32 fwsize;
-	__le32 seqnum;
-	__le32 type;
-	__le32 pktlen;
-	__le32 crc;
-} __packed;
-
 #endif /* _QTN_FMAC_PCIE_IPC_H_ */
-- 
2.9.5

