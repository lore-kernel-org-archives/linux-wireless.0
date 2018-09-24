Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeIXLNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:55 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 04/11] qtnfmac_pcie: indicate pearl-specific structures by
 their names
Date: Mon, 24 Sep 2018 05:13:27 +0000
Message-ID: <20180924051246.13371-5-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071405_667453_24C43FE0)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to extract common PCIe driver state, indicate
PEARL-specific structures by their name and move them to pearl-specific
source file.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 89 +++++++++++++++++-=
----
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        | 47 ------------
 2 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index ab06eca..4e9eb46 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -54,6 +54,53 @@ MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary f=
ile on FS");
=20
 #define DRV_NAME	"qtnfmac_pearl_pcie"
=20
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
=20
@@ -78,7 +125,7 @@ struct qtnf_pcie_pearl_state {
 	struct qtnf_shm_ipc shm_ipc_ep_in;
 	struct qtnf_shm_ipc shm_ipc_ep_out;
=20
-	struct qtnf_pcie_bda __iomem *bda;
+	struct qtnf_pearl_bda __iomem *bda;
 	void __iomem *pcie_reg_base;
=20
 	u16 tx_bd_num;
@@ -87,10 +134,10 @@ struct qtnf_pcie_pearl_state {
 	struct sk_buff **tx_skb;
 	struct sk_buff **rx_skb;
=20
-	struct qtnf_tx_bd *tx_bd_vbase;
+	struct qtnf_pearl_tx_bd *tx_bd_vbase;
 	dma_addr_t tx_bd_pbase;
=20
-	struct qtnf_rx_bd *rx_bd_vbase;
+	struct qtnf_pearl_rx_bd *rx_bd_vbase;
 	dma_addr_t rx_bd_pbase;
=20
 	dma_addr_t bd_table_paddr;
@@ -445,8 +492,8 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state =
*priv)
 	void *vaddr;
 	int len;
=20
-	len =3D priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
-		priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
+	len =3D priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd) +
+		priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd);
=20
 	vaddr =3D dmam_alloc_coherent(&priv->pdev->dev, len, &paddr, GFP_KERNEL);
 	if (!vaddr)
@@ -470,8 +517,8 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state =
*priv)
=20
 	/* rx bd */
=20
-	vaddr =3D ((struct qtnf_tx_bd *)vaddr) + priv->tx_bd_num;
-	paddr +=3D priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+	vaddr =3D ((struct qtnf_pearl_tx_bd *)vaddr) + priv->tx_bd_num;
+	paddr +=3D priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
=20
 	priv->rx_bd_vbase =3D vaddr;
 	priv->rx_bd_pbase =3D paddr;
@@ -482,7 +529,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state =
*priv)
 #endif
 	writel(QTN_HOST_LO32(paddr),
 	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
-	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
+	writel(priv->rx_bd_num | (sizeof(struct qtnf_pearl_rx_bd)) << 16,
 	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
=20
 	pr_debug("RX descriptor table: vaddr=3D0x%p paddr=3D%pad\n", vaddr, &padd=
r);
@@ -492,7 +539,7 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_state =
*priv)
=20
 static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 {
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
=20
@@ -539,7 +586,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_stat=
e *priv)
 	int ret =3D 0;
=20
 	memset(priv->rx_bd_vbase, 0x0,
-	       priv->rx_bd_num * sizeof(struct qtnf_rx_bd));
+	       priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
=20
 	for (i =3D 0; i < priv->rx_bd_num; i++) {
 		ret =3D skb2rbd_attach(priv, i);
@@ -553,8 +600,8 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_stat=
e *priv)
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
@@ -622,7 +669,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *priv)
 		return -EINVAL;
 	}
=20
-	val =3D priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
+	val =3D priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
 	if (val > PCIE_HHBM_MAX_SIZE) {
 		pr_err("tx_bd_size_param %u is too large\n",
 		       priv->tx_bd_num);
@@ -671,7 +718,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *priv)
=20
 static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 {
-	struct qtnf_tx_bd *txbd;
+	struct qtnf_pearl_tx_bd *txbd;
 	struct sk_buff *skb;
 	unsigned long flags;
 	dma_addr_t paddr;
@@ -741,7 +788,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 {
 	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
-	struct qtnf_tx_bd *txbd;
+	struct qtnf_pearl_tx_bd *txbd;
 	unsigned long flags;
 	int len, i;
 	u32 info;
@@ -782,7 +829,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	dma_wmb();
=20
 	/* write new TX descriptor to PCIE_RX_FIFO on EP */
-	txbd_paddr =3D priv->tx_bd_pbase + i * sizeof(struct qtnf_tx_bd);
+	txbd_paddr =3D priv->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
=20
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(txbd_paddr),
@@ -874,7 +921,7 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 index =3D priv->rx_bd_r_index;
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	u32 descw;
=20
 	rxbd =3D &priv->rx_bd_vbase[index];
@@ -893,7 +940,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int b=
udget)
 	struct net_device *ndev =3D NULL;
 	struct sk_buff *skb =3D NULL;
 	int processed =3D 0;
-	struct qtnf_rx_bd *rxbd;
+	struct qtnf_pearl_rx_bd *rxbd;
 	dma_addr_t skb_paddr;
 	int consume;
 	u32 descw;
@@ -1124,7 +1171,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_sta=
te *priv, uint32_t size,
 	struct pci_dev *pdev =3D priv->pdev;
 	struct qtnf_bus *bus =3D pci_get_drvdata(pdev);
=20
-	struct qtnf_pcie_fw_hdr *hdr;
+	struct qtnf_pearl_fw_hdr *hdr;
 	u8 *pdata;
=20
 	int hds =3D sizeof(*hdr);
@@ -1139,7 +1186,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_sta=
te *priv, uint32_t size,
 	skb->len =3D QTN_PCIE_FW_BUFSZ;
 	skb->dev =3D NULL;
=20
-	hdr =3D (struct qtnf_pcie_fw_hdr *)skb->data;
+	hdr =3D (struct qtnf_pearl_fw_hdr *)skb->data;
 	memcpy(hdr->boardflg, QTN_PCIE_BOARDFLG, strlen(QTN_PCIE_BOARDFLG));
 	hdr->fwsize =3D cpu_to_le32(size);
 	hdr->seqnum =3D cpu_to_le32(blk);
@@ -1169,7 +1216,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_sta=
te *priv, uint32_t size,
 static int
 qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_s=
ize)
 {
-	int blk_size =3D QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
+	int blk_size =3D QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pearl_fw_hdr);
 	int blk_count =3D fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
 	const u8 *pblk =3D fw;
 	int threshold =3D 0;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index 00bb21a..af528b8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -101,44 +101,6 @@ enum qtnf_pcie_bda_ipc_flags {
 	QTN_PCIE_IPC_FLAG_SHM_PIO	=3D BIT(1),
 };
=20
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
=20
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
--=20
2.9.5
