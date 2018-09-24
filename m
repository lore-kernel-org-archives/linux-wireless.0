Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB24CC46470
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8715921486
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="W31+DRmy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8715921486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbeIXLN4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:13:56 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeIXLNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=215rNUGCl+OauXBev/5Ce2gKmd7cuOfU1OughQN6AeY=;
 b=W31+DRmyDr9Kfik/rEBHB+vSvr/yTi+6BXxOzh/XU4BiQ5PAiHITwZHaFi2LJuO7aUMSUAUeKsPegVqfrK/7STYGgc68cURBp29uqXv1Fqqk+29EPeNlxvxxqrtRU1GnwAnW7GpTgKCdLWR1befNG8R+dKVHfqSUQyJHkf8qQoQ=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:27 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:27 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 04/11] qtnfmac_pcie: indicate pearl-specific structures by
 their names
Thread-Topic: [PATCH 04/11] qtnfmac_pcie: indicate pearl-specific structures
 by their names
Thread-Index: AQHUU8VTyQQKatFa2k+TrvEe7L5l0A==
Date:   Mon, 24 Sep 2018 05:13:27 +0000
Message-ID: <20180924051246.13371-5-igor.mitsyanko.os@quantenna.com>
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:yGDjJAAFn999bY07UULQ3zF6sMRFOb4v8ul6x8fKX0HeoTEnANrC7SSpkVCjuGjCyrzfjdWLxFIsJCnzRAp6sswGkASv43wl5Fg0HTqiOAbU2AhrcWfYNeBX6evYG1bWmDJiOQhEAdtFwmsWYUin/9MpxgXEUfw5AsP8MXBl9PQanA1P0GBGdCl35qpxjOHTP8xC2k31i2UNBpzkfooUJIqKOqFTcNs9Na2TNmBk/a/+lT6E+u2tSr9vtkAIz0PGMar08E8WGCc2CiPzR607Ka14ZSmitGnwlT82ec1tjqB9E2cekEFfAopxDJ9mbbS2TYbt9MiqO11Y0ukDRcu2UIgvJvfzdxfFySaFDFi+/GVmm+nH2aylQzm3nbidYwwtD58dzsceJxrADLMevz6/+HZ3PqdkgZuzTHZg1Q0KwlhedGP3coVYPzlCzzNVX89uUdsQ9w8PKfqyMH3zukNi2Q==;5:JppLHXDujKOwZpR0+NH+1raNOC+8tgsuebueRw3GpCy0IEZvC/zmv8Nd0crWc1Jug+izcG/knZwMCE3o+qc23NvYMmGiOmOyP9BMFT2b0i1NNhCyR0eoP5KgGKvViPUqA23DfnlaZB1jipnZ8ZBzLxRhS6CGJQrBFM9JMozgqQo=;7:KXcxraeQeOPFo/TIn5rh4iMQofwsQvHQSFKifZYFR4QHvTYaIKoMOZTmWbjksFc5sMJJcBIieDTQYQEZ1p45UVAXEjeIl21Y939AZSojXIZT+rXmRUiIQwonfEg1xw9WTjqBvyBzq5CE+u3eF73yKrO/BCie8FY2M89tL6d6jOZwcKCJyN6NTnYA7Uv+DwkZJyvIkilDfAc/O9jNMaR/phduwM/wuQT9Ldk9zK8BtaYqaLYcp+d8z6fRR9bRYG0q
x-ms-office365-filtering-correlation-id: 1f2751e1-838a-491f-b3dc-08d621dc7586
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB297512CCF3A0660AD4776CE7B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(5024004)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: RTUthq6RhZJOGQw2Y+pMubQjDp6nTtXOyU4sXycOHwtEM2erk6UZYv+Oulcp0cczncBRjZe6DP/nUj4HAs+4UsRF11Sf/Bnf/XHEZiW/uBlCVMwIF9cUWqT1RXeVZ1nyvKOFsaJYfDY2or/sXmah25jNgVivZYOGyXP9AlZlGc2hEXZUYhsKHUzQAyQ/ACdeuAFShbS5Hwxqj/ZJ9+knefSie41rK6yAvM6wbeUJGXDM5byLNYwdTtclXNiMjB+snvKgRDd2bgKH0SzA+IpwukQtNd/u00/EUiqBj0Mnfuv1bCnnwe83xLtHEoGDZOfK1v/0aGDy7OH9TEyrBNnH8G+rwPC1TH/XomeGVPURHbo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2751e1-838a-491f-b3dc-08d621dc7586
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:27.1450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051327.sqPykAca6QORvkzxBYUfUB9kmhu2zxk6SYGb9TjRqrM@z>

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

