Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E36C65BD1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6782087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="pidVupgu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C6782087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbeJHRHG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:07:06 -0400
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:36736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbeJHRHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:07:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYTvlLTNzBZQ383A0wc8jzvE+ZBQowRqHAF3DFfYwqo=;
 b=pidVupguRslHWH31JPe2iz3jykUu0tVmnxbs7fiFtnyPBJdZMbvOL1Dsybww9chuRM/b240yh4QlBDGoijcM4GMa4KFCaV6cP1frohvFu++Q22zSayOOlcExScNYuux/cunLPcCTMR0HH9r/oD39Meu7ooAIdzJXEl3+Sd/6swQ=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4642.namprd05.prod.outlook.com (20.177.144.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.16; Mon, 8 Oct 2018 09:56:06 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 09:56:06 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Topic: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Index: AQHUXu0hlRwXnCwvVUWmMHb83zLAMQ==
Date:   Mon, 8 Oct 2018 09:56:05 +0000
Message-ID: <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4642;6:fJScH/Qc4oPQa9j+epa8WRXag4MPnyGbeUttVTKfV+9MHq1BKGcKXbc8yhveDvqxoZpsaYE5h9ZkkXk0RLd1D51I1cZh7AycQlfQ41lBRduNoNXrmkWfL38jHBVMbpshmggxBSG9hVDYooFM7vGxif8vI/PCs1s81SEjppE2nOfDvC8aLy+bQousVatuGHgF39geX4eICSa7GEgppQeXhMwJBmM3oH28+rHomuGkXeB7O3fopjMEe+xXPAgf4Q1lFRm5b9UmeIjdGsR54u5gHz4SjgtJO4GCYOyGKCKBqSsV4dFoOakPOW+62Xd1sYdzE3nzFTRe/YCWhBiGfAI7HTw2xtMM5pq/m1xOCx47/yt74htCMsCMKnmH9SdLJUXqIj341TLpnJiRbfWF4ECeCWHV3yUyk4bInZuV/tfc4tTSNw6X3/4wnpQ3H6D3m9aimeP5dA6dw0B/L/ejTKkMkQ==;5:g8M+2z8iscuDkccr8VYxAhom0CoN4d05hRfODA59e83BH5bW96pSmVBEVDQy3nddaoNB0SVt0txX6+BGsy7dnCdlroWk6DAx8kNZlH4grQiUm6z+Q9jSLPRmygaobhXsH1krqBhrHuz2eOR63qsOaO2cL5UIztg7vUwhjedkvwU=;7:Pt03JUzvL5VTxP4JiTPXiyH2vV30AxKP5aUdJjgCixmD89OObbdiOqQHdUKV9SIziD+WU6VQhIT//lffqPMuxUzy1aOLNZUHvB1hDvJht9VcETg0OjZ1s4pfYx/D2e1alDCAp8BWgFOjShQS7LbNN5LcHOfXlFFGBF4o1ZwQ9xi6VHxx1MoausOL8GfRx4RtN1KdByR9OHeVLvIFg/uQnVI9PmHA7zA1/tKjxw3HimiPLNlK68q2yRSgt2TVQIF/
x-ms-office365-filtering-correlation-id: fec46506-6a10-4b30-5f32-08d62d044391
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4642;
x-ms-traffictypediagnostic: BL0PR05MB4642:
x-microsoft-antispam-prvs: <BL0PR05MB464286B404725CFBDFA755D0A3E60@BL0PR05MB4642.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BL0PR05MB4642;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4642;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(346002)(366004)(376002)(189003)(199004)(105586002)(5024004)(486006)(68736007)(2351001)(5250100002)(386003)(316002)(2501003)(446003)(2616005)(5660300001)(6916009)(103116003)(186003)(14454004)(14444005)(53936002)(575784001)(102836004)(11346002)(3846002)(256004)(305945005)(7736002)(2900100001)(8936002)(106356001)(107886003)(26005)(1076002)(6436002)(54906003)(76176011)(53946003)(478600001)(6116002)(6486002)(81156014)(25786009)(99286004)(8676002)(81166006)(476003)(52116002)(5640700003)(6506007)(71200400001)(6512007)(16200700003)(71190400001)(2906002)(4744004)(66066001)(4326008)(86362001)(36756003)(97736004)(579004)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4642;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: mCtN8GZwAw+vlnvaZKM3rekAxRKwsVloYhWdLvtQQ8KnYyIz/t1JfqyNGMLFP2EUlxUw4m2MRk4ALEUfvUrF6z2pU7WYLKRj5rniSJb37wfFkGwiJvTt+mgJn5vxGKqepp7Rl6LozxteYzbqTLpJ9K6Oi+gsQv4xGDdwGfLTrSCfkXhiezCXdEHaUYCfNsrKim2MkR54STS7iFaY2sUfFegMwM4ih+n8tkgcI7RhvXeiM7ag6wAMys6vG4vpPblrC7y4FsdZqdZu3q6CkyxjUaIsnY7aD46ShQMA/mG9wBUd1X30G5e3BS91sIlqjWXYAkIlrRFtMM2o6YQhOOcjfV05PAZ6ErQECKfdbI1FlTU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec46506-6a10-4b30-5f32-08d62d044391
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 09:56:05.9973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4642
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds support for QSR1000/QSR2000 family of chipsets
to qtnfmac_pcie platform driver.

QSR1000/QSR2000 (aka Topaz) is a family of 80MHz, 11ac Wave2,
4x4/2x4/2x2 chips, including single and dual band devices.
Depending on specific chip model and firmware in use, either
STA or both STA and AP modes are supported.

Patch adds Topaz support to qtnfmac_pcie driver. It is possible
to enable both Topaz and Pearl support in kernel configuration.
In that case proper platform bus will be selected on probing
based on chip ID.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |   27 +-
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |    1 +
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |    5 +
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |    1 +
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   | 1219 ++++++++++++++++=
++++
 .../quantenna/qtnfmac/pcie/topaz_pcie_ipc.h        |   94 ++
 .../quantenna/qtnfmac/pcie/topaz_pcie_regs.h       |   45 +
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |    3 +
 drivers/net/wireless/quantenna/qtnfmac/util.c      |    2 +
 9 files changed, 1391 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.=
c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_=
ipc.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_=
regs.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/w=
ireless/quantenna/qtnfmac/Kconfig
index f43b236b7c0b..df2fd0a1ab5c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -1,14 +1,14 @@
 config QTNFMAC
 	tristate
-	depends on QTNFMAC_PEARL_PCIE
-	default m if QTNFMAC_PEARL_PCIE=3Dm
-	default y if QTNFMAC_PEARL_PCIE=3Dy
+	depends on QTNFMAC_PEARL_PCIE || QTNFMAC_TOPAZ_PCIE
+	default m if QTNFMAC_PEARL_PCIE=3Dm || QTNFMAC_TOPAZ_PCIE=3Dm
+	default y if QTNFMAC_PEARL_PCIE=3Dy || QTNFMAC_TOPAZ_PCIE=3Dy
=20
 config QTNFMAC_PCIE
 	tristate
-	depends on QTNFMAC_PEARL_PCIE
-	default m if QTNFMAC_PEARL_PCIE=3Dm
-	default y if QTNFMAC_PEARL_PCIE=3Dy
+	depends on QTNFMAC_PEARL_PCIE || QTNFMAC_TOPAZ_PCIE
+	default m if QTNFMAC_PEARL_PCIE=3Dm || QTNFMAC_TOPAZ_PCIE=3Dm
+	default y if QTNFMAC_PEARL_PCIE=3Dy || QTNFMAC_TOPAZ_PCIE=3Dy
=20
 config QTNFMAC_PEARL_PCIE
 	tristate "Quantenna QSR10g PCIe support"
@@ -23,3 +23,18 @@ config QTNFMAC_PEARL_PCIE
=20
 	  If you choose to build it as a module, two modules will be built:
 	  qtnfmac.ko and qtnfmac_pcie.ko.
+
+config QTNFMAC_TOPAZ_PCIE
+	tristate "Quantenna QSR1000/QSR2000 PCIe support"
+	default n
+	depends on PCI && CFG80211
+	select QTNFMAC
+	select FW_LOADER
+	select CRC32
+	help
+	  This option adds support for wireless adapters based on Quantenna
+	  802.11ac QSR1000/QSR2000 (aka Topaz) FullMAC chipset
+	  running over PCIe.
+
+	  If you choose to build it as a module, two modules will be built:
+	  qtnfmac.ko and qtnfmac_pcie.ko.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/=
wireless/quantenna/qtnfmac/Makefile
index e295aa55619f..4de95330e793 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -27,3 +27,4 @@ qtnfmac_pcie-objs +=3D \
=20
 qtnfmac_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
 qtnfmac_pcie-$(CONFIG_QTNFMAC_PEARL_PCIE) +=3D pcie/pearl_pcie.o
+qtnfmac_pcie-$(CONFIG_QTNFMAC_TOPAZ_PCIE) +=3D pcie/topaz_pcie.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index b589c01d9bbe..a139db398fd4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -332,6 +332,11 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
 		bus =3D qtnf_pcie_pearl_alloc(pdev);
 		break;
 #endif
+#if IS_ENABLED(CONFIG_QTNFMAC_TOPAZ_PCIE)
+	case QTN_CHIP_ID_TOPAZ:
+		bus =3D qtnf_pcie_topaz_alloc(pdev);
+		break;
+#endif
 	default:
 		pr_err("unsupported chip ID 0x%x\n", chipid);
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index 7c742c56efaf..bbc074e1f34d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -76,6 +76,7 @@ void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *pr=
iv,
 			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
 			    const struct qtnf_shm_ipc_int *ipc_int);
 struct qtnf_bus *qtnf_pcie_pearl_alloc(struct pci_dev *pdev);
+struct qtnf_bus *qtnf_pcie_topaz_alloc(struct pci_dev *pdev);
=20
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
new file mode 100644
index 000000000000..598edb814421
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -0,0 +1,1219 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2018 Quantenna Communications */
+
+#include <linux/kernel.h>
+#include <linux/firmware.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/crc32.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+#include <linux/circ_buf.h>
+
+#include "pcie_priv.h"
+#include "topaz_pcie_regs.h"
+#include "topaz_pcie_ipc.h"
+#include "qtn_hw_ids.h"
+#include "core.h"
+#include "bus.h"
+#include "shm_ipc.h"
+#include "debug.h"
+
+#define TOPAZ_TX_BD_SIZE_DEFAULT	128
+
+struct qtnf_topaz_tx_bd {
+	__le32 addr;
+	__le32 info;
+} __packed;
+
+struct qtnf_topaz_rx_bd {
+	__le32 addr;
+	__le32 info;
+} __packed;
+
+struct qtnf_extra_bd_params {
+	__le32 param1;
+	__le32 param2;
+	__le32 param3;
+	__le32 param4;
+} __packed;
+
+#define QTNF_BD_PARAM_OFFSET(n)	offsetof(struct qtnf_extra_bd_params, para=
m##n)
+
+struct vmac_pkt_info {
+	__le32 addr;
+	__le32 info;
+};
+
+struct qtnf_topaz_bda {
+	__le16	bda_len;
+	__le16	bda_version;
+	__le32	bda_bootstate;
+	__le32	bda_dma_mask;
+	__le32	bda_dma_offset;
+	__le32	bda_flags;
+	__le32	bda_img;
+	__le32	bda_img_size;
+	__le32	bda_ep2h_irqstatus;
+	__le32	bda_h2ep_irqstatus;
+	__le32	bda_msi_addr;
+	u8	reserved1[56];
+	__le32	bda_flashsz;
+	u8	bda_boardname[PCIE_BDA_NAMELEN];
+	__le32	bda_pci_pre_status;
+	__le32	bda_pci_endian;
+	__le32	bda_pci_post_status;
+	__le32	bda_h2ep_txd_budget;
+	__le32	bda_ep2h_txd_budget;
+	__le32	bda_rc_rx_bd_base;
+	__le32	bda_rc_rx_bd_num;
+	__le32	bda_rc_tx_bd_base;
+	__le32	bda_rc_tx_bd_num;
+	u8	bda_ep_link_state;
+	u8	bda_rc_link_state;
+	u8	bda_rc_msi_enabled;
+	u8	reserved2;
+	__le32	bda_ep_next_pkt;
+	struct vmac_pkt_info request[QTN_PCIE_RC_TX_QUEUE_LEN];
+	struct qtnf_shm_ipc_region bda_shm_reg1 __aligned(4096);
+	struct qtnf_shm_ipc_region bda_shm_reg2 __aligned(4096);
+} __packed;
+
+struct qtnf_pcie_topaz_state {
+	struct qtnf_pcie_bus_priv base;
+	struct qtnf_topaz_bda __iomem *bda;
+
+	dma_addr_t dma_msi_dummy;
+	u32 dma_msi_imwr;
+
+	struct qtnf_topaz_tx_bd *tx_bd_vbase;
+	struct qtnf_topaz_rx_bd *rx_bd_vbase;
+
+	__le32 __iomem *ep_next_rx_pkt;
+	__le32 __iomem *txqueue_wake;
+	__le32 __iomem *ep_pmstate;
+
+	unsigned long rx_pkt_count;
+};
+
+static void qtnf_deassert_intx(struct qtnf_pcie_topaz_state *ts)
+{
+	void __iomem *reg =3D ts->base.sysctl_bar + TOPAZ_PCIE_CFG0_OFFSET;
+	u32 cfg;
+
+	cfg =3D readl(reg);
+	cfg &=3D ~TOPAZ_ASSERT_INTX;
+	qtnf_non_posted_write(cfg, reg);
+}
+
+static inline int qtnf_topaz_intx_asserted(struct qtnf_pcie_topaz_state *t=
s)
+{
+	void __iomem *reg =3D ts->base.sysctl_bar + TOPAZ_PCIE_CFG0_OFFSET;
+	u32 cfg =3D readl(reg);
+
+	return !!(cfg & TOPAZ_ASSERT_INTX);
+}
+
+static void qtnf_topaz_reset_ep(struct qtnf_pcie_topaz_state *ts)
+{
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_RST_EP_IRQ),
+	       TOPAZ_LH_IPC4_INT(ts->base.sysctl_bar));
+	msleep(QTN_EP_RESET_WAIT_MS);
+	pci_restore_state(ts->base.pdev);
+}
+
+static void setup_rx_irqs(struct qtnf_pcie_topaz_state *ts)
+{
+	void __iomem *reg =3D PCIE_DMA_WR_DONE_IMWR_ADDR_LOW(ts->base.dmareg_bar)=
;
+
+	ts->dma_msi_imwr =3D readl(reg);
+}
+
+static void enable_rx_irqs(struct qtnf_pcie_topaz_state *ts)
+{
+	void __iomem *reg =3D PCIE_DMA_WR_DONE_IMWR_ADDR_LOW(ts->base.dmareg_bar)=
;
+
+	qtnf_non_posted_write(ts->dma_msi_imwr, reg);
+}
+
+static void disable_rx_irqs(struct qtnf_pcie_topaz_state *ts)
+{
+	void __iomem *reg =3D PCIE_DMA_WR_DONE_IMWR_ADDR_LOW(ts->base.dmareg_bar)=
;
+
+	qtnf_non_posted_write(QTN_HOST_LO32(ts->dma_msi_dummy), reg);
+}
+
+static void qtnf_topaz_ipc_gen_ep_int(void *arg)
+{
+	struct qtnf_pcie_topaz_state *ts =3D arg;
+
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_CTRL_IRQ),
+	       TOPAZ_CTL_M2L_INT(ts->base.sysctl_bar));
+}
+
+static int qtnf_is_state(__le32 __iomem *reg, u32 state)
+{
+	u32 s =3D readl(reg);
+
+	return (s =3D=3D state);
+}
+
+static void qtnf_set_state(__le32 __iomem *reg, u32 state)
+{
+	qtnf_non_posted_write(state, reg);
+}
+
+static int qtnf_poll_state(__le32 __iomem *reg, u32 state, u32 delay_in_ms=
)
+{
+	u32 timeout =3D 0;
+
+	while ((qtnf_is_state(reg, state) =3D=3D 0)) {
+		usleep_range(1000, 1200);
+		if (++timeout > delay_in_ms)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int topaz_alloc_bd_table(struct qtnf_pcie_topaz_state *ts,
+				struct qtnf_topaz_bda __iomem *bda)
+{
+	struct qtnf_extra_bd_params __iomem *extra_params;
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	dma_addr_t paddr;
+	void *vaddr;
+	int len;
+	int i;
+
+	/* bd table */
+
+	len =3D priv->tx_bd_num * sizeof(struct qtnf_topaz_tx_bd) +
+		priv->rx_bd_num * sizeof(struct qtnf_topaz_rx_bd) +
+			sizeof(struct qtnf_extra_bd_params);
+
+	vaddr =3D dmam_alloc_coherent(&priv->pdev->dev, len, &paddr, GFP_KERNEL);
+	if (!vaddr)
+		return -ENOMEM;
+
+	memset(vaddr, 0, len);
+
+	/* tx bd */
+
+	ts->tx_bd_vbase =3D vaddr;
+	qtnf_non_posted_write(paddr, &bda->bda_rc_tx_bd_base);
+
+	for (i =3D 0; i < priv->tx_bd_num; i++)
+		ts->tx_bd_vbase[i].info |=3D cpu_to_le32(QTN_BD_EMPTY);
+
+	pr_debug("TX descriptor table: vaddr=3D0x%p paddr=3D%pad\n", vaddr, &padd=
r);
+
+	priv->tx_bd_r_index =3D 0;
+	priv->tx_bd_w_index =3D 0;
+
+	/* rx bd */
+
+	vaddr =3D ((struct qtnf_topaz_tx_bd *)vaddr) + priv->tx_bd_num;
+	paddr +=3D priv->tx_bd_num * sizeof(struct qtnf_topaz_tx_bd);
+
+	ts->rx_bd_vbase =3D vaddr;
+	qtnf_non_posted_write(paddr, &bda->bda_rc_rx_bd_base);
+
+	pr_debug("RX descriptor table: vaddr=3D0x%p paddr=3D%pad\n", vaddr, &padd=
r);
+
+	/* extra shared params */
+
+	vaddr =3D ((struct qtnf_topaz_rx_bd *)vaddr) + priv->rx_bd_num;
+	paddr +=3D priv->rx_bd_num * sizeof(struct qtnf_topaz_rx_bd);
+
+	extra_params =3D (struct qtnf_extra_bd_params __iomem *)vaddr;
+
+	ts->ep_next_rx_pkt =3D &extra_params->param1;
+	qtnf_non_posted_write(paddr + QTNF_BD_PARAM_OFFSET(1),
+			      &bda->bda_ep_next_pkt);
+	ts->txqueue_wake =3D &extra_params->param2;
+	ts->ep_pmstate =3D &extra_params->param3;
+	ts->dma_msi_dummy =3D paddr + QTNF_BD_PARAM_OFFSET(4);
+
+	return 0;
+}
+
+static int
+topaz_skb2rbd_attach(struct qtnf_pcie_topaz_state *ts, u16 index, u32 wrap=
)
+{
+	struct qtnf_topaz_rx_bd *rxbd =3D &ts->rx_bd_vbase[index];
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+
+	skb =3D __netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		ts->base.rx_skb[index] =3D NULL;
+		return -ENOMEM;
+	}
+
+	ts->base.rx_skb[index] =3D skb;
+
+	paddr =3D pci_map_single(ts->base.pdev, skb->data,
+			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(ts->base.pdev, paddr)) {
+		pr_err("skb mapping error: %pad\n", &paddr);
+		return -ENOMEM;
+	}
+
+	rxbd->addr =3D cpu_to_le32(QTN_HOST_LO32(paddr));
+	rxbd->info =3D cpu_to_le32(QTN_BD_EMPTY | wrap);
+
+	ts->base.rx_bd_w_index =3D index;
+
+	return 0;
+}
+
+static int topaz_alloc_rx_buffers(struct qtnf_pcie_topaz_state *ts)
+{
+	u16 i;
+	int ret =3D 0;
+
+	memset(ts->rx_bd_vbase, 0x0,
+	       ts->base.rx_bd_num * sizeof(struct qtnf_topaz_rx_bd));
+
+	for (i =3D 0; i < ts->base.rx_bd_num; i++) {
+		ret =3D topaz_skb2rbd_attach(ts, i, 0);
+		if (ret)
+			break;
+	}
+
+	ts->rx_bd_vbase[ts->base.rx_bd_num - 1].info |=3D
+						cpu_to_le32(QTN_BD_WRAP);
+
+	return ret;
+}
+
+/* all rx/tx activity should have ceased before calling this function */
+static void qtnf_topaz_free_xfer_buffers(struct qtnf_pcie_topaz_state *ts)
+{
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	struct qtnf_topaz_rx_bd *rxbd;
+	struct qtnf_topaz_tx_bd *txbd;
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+	int i;
+
+	/* free rx buffers */
+	for (i =3D 0; i < priv->rx_bd_num; i++) {
+		if (priv->rx_skb && priv->rx_skb[i]) {
+			rxbd =3D &ts->rx_bd_vbase[i];
+			skb =3D priv->rx_skb[i];
+			paddr =3D QTN_HOST_ADDR(0x0, le32_to_cpu(rxbd->addr));
+			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any(skb);
+			priv->rx_skb[i] =3D NULL;
+			rxbd->addr =3D 0;
+			rxbd->info =3D 0;
+		}
+	}
+
+	/* free tx buffers */
+	for (i =3D 0; i < priv->tx_bd_num; i++) {
+		if (priv->tx_skb && priv->tx_skb[i]) {
+			txbd =3D &ts->tx_bd_vbase[i];
+			skb =3D priv->tx_skb[i];
+			paddr =3D QTN_HOST_ADDR(0x0, le32_to_cpu(txbd->addr));
+			pci_unmap_single(priv->pdev, paddr, SKB_BUF_SIZE,
+					 PCI_DMA_TODEVICE);
+			dev_kfree_skb_any(skb);
+			priv->tx_skb[i] =3D NULL;
+			txbd->addr =3D 0;
+			txbd->info =3D 0;
+		}
+	}
+}
+
+static int qtnf_pcie_topaz_init_xfer(struct qtnf_pcie_topaz_state *ts,
+				     unsigned int tx_bd_size)
+{
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	int ret;
+
+	if (tx_bd_size =3D=3D 0)
+		tx_bd_size =3D TOPAZ_TX_BD_SIZE_DEFAULT;
+
+	/* check TX BD queue max length according to struct qtnf_topaz_bda */
+	if (tx_bd_size > QTN_PCIE_RC_TX_QUEUE_LEN) {
+		pr_warn("TX BD queue cannot exceed %d\n",
+			QTN_PCIE_RC_TX_QUEUE_LEN);
+		tx_bd_size =3D QTN_PCIE_RC_TX_QUEUE_LEN;
+	}
+
+	priv->tx_bd_num =3D tx_bd_size;
+	qtnf_non_posted_write(priv->tx_bd_num, &bda->bda_rc_tx_bd_num);
+	qtnf_non_posted_write(priv->rx_bd_num, &bda->bda_rc_rx_bd_num);
+
+	priv->rx_bd_w_index =3D 0;
+	priv->rx_bd_r_index =3D 0;
+
+	ret =3D qtnf_pcie_alloc_skb_array(priv);
+	if (ret) {
+		pr_err("failed to allocate skb array\n");
+		return ret;
+	}
+
+	ret =3D topaz_alloc_bd_table(ts, bda);
+	if (ret) {
+		pr_err("failed to allocate bd table\n");
+		return ret;
+	}
+
+	ret =3D topaz_alloc_rx_buffers(ts);
+	if (ret) {
+		pr_err("failed to allocate rx buffers\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void qtnf_topaz_data_tx_reclaim(struct qtnf_pcie_topaz_state *ts)
+{
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	struct qtnf_topaz_tx_bd *txbd;
+	struct sk_buff *skb;
+	unsigned long flags;
+	dma_addr_t paddr;
+	u32 tx_done_index;
+	int count =3D 0;
+	int i;
+
+	spin_lock_irqsave(&priv->tx_reclaim_lock, flags);
+
+	tx_done_index =3D readl(ts->ep_next_rx_pkt);
+	i =3D priv->tx_bd_r_index;
+
+	if (CIRC_CNT(priv->tx_bd_w_index, tx_done_index, priv->tx_bd_num))
+		writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_TX_DONE_IRQ),
+		       TOPAZ_LH_IPC4_INT(priv->sysctl_bar));
+
+	while (CIRC_CNT(tx_done_index, i, priv->tx_bd_num)) {
+		skb =3D priv->tx_skb[i];
+
+		if (likely(skb)) {
+			txbd =3D &ts->tx_bd_vbase[i];
+			paddr =3D QTN_HOST_ADDR(0x0, le32_to_cpu(txbd->addr));
+			pci_unmap_single(priv->pdev, paddr, skb->len,
+					 PCI_DMA_TODEVICE);
+
+			if (skb->dev) {
+				qtnf_update_tx_stats(skb->dev, skb);
+				if (unlikely(priv->tx_stopped)) {
+					qtnf_wake_all_queues(skb->dev);
+					priv->tx_stopped =3D 0;
+				}
+			}
+
+			dev_kfree_skb_any(skb);
+		}
+
+		priv->tx_skb[i] =3D NULL;
+		count++;
+
+		if (++i >=3D priv->tx_bd_num)
+			i =3D 0;
+	}
+
+	priv->tx_reclaim_done +=3D count;
+	priv->tx_reclaim_req++;
+	priv->tx_bd_r_index =3D i;
+
+	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
+}
+
+static void qtnf_try_stop_xmit(struct qtnf_bus *bus, struct net_device *nd=
ev)
+{
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+
+	if (ndev) {
+		netif_tx_stop_all_queues(ndev);
+		ts->base.tx_stopped =3D 1;
+	}
+
+	writel(0x0, ts->txqueue_wake);
+
+	/* sync up tx queue status before generating interrupt */
+	dma_wmb();
+
+	/* send irq to card: tx stopped */
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_TX_STOP_IRQ),
+	       TOPAZ_LH_IPC4_INT(ts->base.sysctl_bar));
+
+	/* schedule reclaim attempt */
+	tasklet_hi_schedule(&ts->base.reclaim_tq);
+}
+
+static void qtnf_try_wake_xmit(struct qtnf_bus *bus, struct net_device *nd=
ev)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+	int ready;
+
+	ready =3D readl(ts->txqueue_wake);
+	if (ready) {
+		netif_wake_queue(ndev);
+	} else {
+		/* re-send irq to card: tx stopped */
+		writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_TX_STOP_IRQ),
+		       TOPAZ_LH_IPC4_INT(ts->base.sysctl_bar));
+	}
+}
+
+static int qtnf_tx_queue_ready(struct qtnf_pcie_topaz_state *ts)
+{
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+
+	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
+			priv->tx_bd_num)) {
+		qtnf_topaz_data_tx_reclaim(ts);
+
+		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
+				priv->tx_bd_num)) {
+			priv->tx_full_count++;
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	struct qtnf_topaz_tx_bd *txbd;
+	dma_addr_t skb_paddr;
+	unsigned long flags;
+	int ret =3D 0;
+	int len;
+	int i;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	if (!qtnf_tx_queue_ready(ts)) {
+		qtnf_try_stop_xmit(bus, skb->dev);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		return NETDEV_TX_BUSY;
+	}
+
+	i =3D priv->tx_bd_w_index;
+	priv->tx_skb[i] =3D skb;
+	len =3D skb->len;
+
+	skb_paddr =3D pci_map_single(priv->pdev, skb->data,
+				   skb->len, PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(priv->pdev, skb_paddr)) {
+		ret =3D -ENOMEM;
+		goto tx_done;
+	}
+
+	txbd =3D &ts->tx_bd_vbase[i];
+	txbd->addr =3D cpu_to_le32(QTN_HOST_LO32(skb_paddr));
+
+	writel(QTN_HOST_LO32(skb_paddr), &bda->request[i].addr);
+	writel(len | QTN_PCIE_TX_VALID_PKT, &bda->request[i].info);
+
+	/* sync up descriptor updates before generating interrupt */
+	dma_wmb();
+
+	/* generate irq to card: tx done */
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_TX_DONE_IRQ),
+	       TOPAZ_LH_IPC4_INT(priv->sysctl_bar));
+
+	if (++i >=3D priv->tx_bd_num)
+		i =3D 0;
+
+	priv->tx_bd_w_index =3D i;
+
+tx_done:
+	if (ret) {
+		if (skb->dev)
+			skb->dev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+
+	priv->tx_done_count++;
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	qtnf_topaz_data_tx_reclaim(ts);
+
+	return NETDEV_TX_OK;
+}
+
+static irqreturn_t qtnf_pcie_topaz_interrupt(int irq, void *data)
+{
+	struct qtnf_bus *bus =3D (struct qtnf_bus *)data;
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+
+	if (!priv->msi_enabled && !qtnf_topaz_intx_asserted(ts))
+		return IRQ_NONE;
+
+	priv->pcie_irq_count++;
+
+	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
+	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_out);
+
+	if (napi_schedule_prep(&bus->mux_napi)) {
+		disable_rx_irqs(ts);
+		__napi_schedule(&bus->mux_napi);
+	}
+
+	tasklet_hi_schedule(&priv->reclaim_tq);
+
+	if (!priv->msi_enabled)
+		qtnf_deassert_intx(ts);
+
+	return IRQ_HANDLED;
+}
+
+static int qtnf_rx_data_ready(struct qtnf_pcie_topaz_state *ts)
+{
+	u16 index =3D ts->base.rx_bd_r_index;
+	struct qtnf_topaz_rx_bd *rxbd;
+	u32 descw;
+
+	rxbd =3D &ts->rx_bd_vbase[index];
+	descw =3D le32_to_cpu(rxbd->info);
+
+	if (descw & QTN_BD_EMPTY)
+		return 0;
+
+	return 1;
+}
+
+static int qtnf_topaz_rx_poll(struct napi_struct *napi, int budget)
+{
+	struct qtnf_bus *bus =3D container_of(napi, struct qtnf_bus, mux_napi);
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	struct net_device *ndev =3D NULL;
+	struct sk_buff *skb =3D NULL;
+	int processed =3D 0;
+	struct qtnf_topaz_rx_bd *rxbd;
+	dma_addr_t skb_paddr;
+	int consume;
+	u32 descw;
+	u32 poffset;
+	u32 psize;
+	u16 r_idx;
+	u16 w_idx;
+	int ret;
+
+	while (processed < budget) {
+		if (!qtnf_rx_data_ready(ts))
+			goto rx_out;
+
+		r_idx =3D priv->rx_bd_r_index;
+		rxbd =3D &ts->rx_bd_vbase[r_idx];
+		descw =3D le32_to_cpu(rxbd->info);
+
+		skb =3D priv->rx_skb[r_idx];
+		poffset =3D QTN_GET_OFFSET(descw);
+		psize =3D QTN_GET_LEN(descw);
+		consume =3D 1;
+
+		if (descw & QTN_BD_EMPTY) {
+			pr_warn("skip invalid rxbd[%d]\n", r_idx);
+			consume =3D 0;
+		}
+
+		if (!skb) {
+			pr_warn("skip missing rx_skb[%d]\n", r_idx);
+			consume =3D 0;
+		}
+
+		if (skb && (skb_tailroom(skb) <  psize)) {
+			pr_err("skip packet with invalid length: %u > %u\n",
+			       psize, skb_tailroom(skb));
+			consume =3D 0;
+		}
+
+		if (skb) {
+			skb_paddr =3D QTN_HOST_ADDR(0x0, le32_to_cpu(rxbd->addr));
+			pci_unmap_single(priv->pdev, skb_paddr, SKB_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+		}
+
+		if (consume) {
+			skb_reserve(skb, poffset);
+			skb_put(skb, psize);
+			ndev =3D qtnf_classify_skb(bus, skb);
+			if (likely(ndev)) {
+				qtnf_update_rx_stats(ndev, skb);
+				skb->protocol =3D eth_type_trans(skb, ndev);
+				netif_receive_skb(skb);
+			} else {
+				pr_debug("drop untagged skb\n");
+				bus->mux_dev.stats.rx_dropped++;
+				dev_kfree_skb_any(skb);
+			}
+		} else {
+			if (skb) {
+				bus->mux_dev.stats.rx_dropped++;
+				dev_kfree_skb_any(skb);
+			}
+		}
+
+		/* notify card about recv packets once per several packets */
+		if (((++ts->rx_pkt_count) & RX_DONE_INTR_MSK) =3D=3D 0)
+			writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_RX_DONE_IRQ),
+			       TOPAZ_LH_IPC4_INT(priv->sysctl_bar));
+
+		priv->rx_skb[r_idx] =3D NULL;
+		if (++r_idx >=3D priv->rx_bd_num)
+			r_idx =3D 0;
+
+		priv->rx_bd_r_index =3D r_idx;
+
+		/* repalce processed buffer by a new one */
+		w_idx =3D priv->rx_bd_w_index;
+		while (CIRC_SPACE(priv->rx_bd_w_index, priv->rx_bd_r_index,
+				  priv->rx_bd_num) > 0) {
+			if (++w_idx >=3D priv->rx_bd_num)
+				w_idx =3D 0;
+
+			ret =3D topaz_skb2rbd_attach(ts, w_idx,
+						   descw & QTN_BD_WRAP);
+			if (ret) {
+				pr_err("failed to allocate new rx_skb[%d]\n",
+				       w_idx);
+				break;
+			}
+		}
+
+		processed++;
+	}
+
+rx_out:
+	if (processed < budget) {
+		napi_complete(napi);
+		enable_rx_irqs(ts);
+	}
+
+	return processed;
+}
+
+static void
+qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+
+	qtnf_try_wake_xmit(bus, ndev);
+	tasklet_hi_schedule(&ts->base.reclaim_tq);
+}
+
+static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+
+	napi_enable(&bus->mux_napi);
+	enable_rx_irqs(ts);
+}
+
+static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+
+	disable_rx_irqs(ts);
+	napi_disable(&bus->mux_napi);
+}
+
+static const struct qtnf_bus_ops qtnf_pcie_topaz_bus_ops =3D {
+	/* control path methods */
+	.control_tx	=3D qtnf_pcie_control_tx,
+
+	/* data path methods */
+	.data_tx		=3D qtnf_pcie_data_tx,
+	.data_tx_timeout	=3D qtnf_pcie_data_tx_timeout,
+	.data_rx_start		=3D qtnf_pcie_data_rx_start,
+	.data_rx_stop		=3D qtnf_pcie_data_rx_stop,
+};
+
+static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+
+	seq_printf(s, "pcie_irq_count(%u)\n", ts->base.pcie_irq_count);
+
+	return 0;
+}
+
+static int qtnf_dbg_pkt_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ts->base;
+	u32 tx_done_index =3D readl(ts->ep_next_rx_pkt);
+
+	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
+	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
+	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
+	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
+
+	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
+	seq_printf(s, "tx_done_index(%u)\n", tx_done_index);
+	seq_printf(s, "tx_bd_w_index(%u)\n", priv->tx_bd_w_index);
+
+	seq_printf(s, "tx host queue len(%u)\n",
+		   CIRC_CNT(priv->tx_bd_w_index, priv->tx_bd_r_index,
+			    priv->tx_bd_num));
+	seq_printf(s, "tx reclaim queue len(%u)\n",
+		   CIRC_CNT(tx_done_index, priv->tx_bd_r_index,
+			    priv->tx_bd_num));
+	seq_printf(s, "tx card queue len(%u)\n",
+		   CIRC_CNT(priv->tx_bd_w_index, tx_done_index,
+			    priv->tx_bd_num));
+
+	seq_printf(s, "rx_bd_r_index(%u)\n", priv->rx_bd_r_index);
+	seq_printf(s, "rx_bd_w_index(%u)\n", priv->rx_bd_w_index);
+	seq_printf(s, "rx alloc queue len(%u)\n",
+		   CIRC_SPACE(priv->rx_bd_w_index, priv->rx_bd_r_index,
+			      priv->rx_bd_num));
+
+	return 0;
+}
+
+static void qtnf_reset_dma_offset(struct qtnf_pcie_topaz_state *ts)
+{
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	u32 offset =3D readl(&bda->bda_dma_offset);
+
+	if ((offset & PCIE_DMA_OFFSET_ERROR_MASK) !=3D PCIE_DMA_OFFSET_ERROR)
+		return;
+
+	writel(0x0, &bda->bda_dma_offset);
+}
+
+static int qtnf_pcie_endian_detect(struct qtnf_pcie_topaz_state *ts)
+{
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	u32 timeout =3D 0;
+	u32 endian;
+	int ret =3D 0;
+
+	writel(QTN_PCI_ENDIAN_DETECT_DATA, &bda->bda_pci_endian);
+
+	/* flush endian modifications before status update */
+	dma_wmb();
+
+	writel(QTN_PCI_ENDIAN_VALID_STATUS, &bda->bda_pci_pre_status);
+
+	while (readl(&bda->bda_pci_post_status) !=3D
+	       QTN_PCI_ENDIAN_VALID_STATUS) {
+		usleep_range(1000, 1200);
+		if (++timeout > QTN_FW_DL_TIMEOUT_MS) {
+			pr_err("card endianness detection timed out\n");
+			ret =3D -ETIMEDOUT;
+			goto endian_out;
+		}
+	}
+
+	/* do not read before status is updated */
+	dma_rmb();
+
+	endian =3D readl(&bda->bda_pci_endian);
+	WARN(endian !=3D QTN_PCI_LITTLE_ENDIAN,
+	     "%s: unexpected card endianness", __func__);
+
+endian_out:
+	writel(0, &bda->bda_pci_pre_status);
+	writel(0, &bda->bda_pci_post_status);
+	writel(0, &bda->bda_pci_endian);
+
+	return ret;
+}
+
+static int qtnf_pre_init_ep(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	u32 flags;
+	int ret;
+
+	ret =3D qtnf_pcie_endian_detect(ts);
+	if (ret < 0) {
+		pr_err("failed to detect card endianness\n");
+		return ret;
+	}
+
+	writeb(ts->base.msi_enabled, &ts->bda->bda_rc_msi_enabled);
+	qtnf_reset_dma_offset(ts);
+
+	/* notify card about driver type and boot mode */
+	flags =3D readl(&bda->bda_flags) | QTN_BDA_HOST_QLINK_DRV;
+
+	if (ts->base.flashboot)
+		flags |=3D QTN_BDA_FLASH_BOOT;
+	else
+		flags &=3D ~QTN_BDA_FLASH_BOOT;
+
+	writel(flags, &bda->bda_flags);
+
+	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_HOST_RDY);
+	if (qtnf_poll_state(&ts->bda->bda_bootstate, QTN_BDA_FW_TARGET_RDY,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("card is not ready to boot...\n");
+		return -ETIMEDOUT;
+	}
+
+	return ret;
+}
+
+static int qtnf_post_init_ep(struct qtnf_pcie_topaz_state *ts)
+{
+	struct pci_dev *pdev =3D ts->base.pdev;
+
+	setup_rx_irqs(ts);
+	disable_rx_irqs(ts);
+
+	if (qtnf_poll_state(&ts->bda->bda_bootstate, QTN_BDA_FW_QLINK_DONE,
+			    QTN_FW_QLINK_TIMEOUT_MS))
+		return -ETIMEDOUT;
+
+	enable_irq(pdev->irq);
+	return 0;
+}
+
+static int
+qtnf_ep_fw_load(struct qtnf_pcie_topaz_state *ts, const u8 *fw, u32 fw_siz=
e)
+{
+	struct qtnf_topaz_bda __iomem *bda =3D ts->bda;
+	struct pci_dev *pdev =3D ts->base.pdev;
+	u32 remaining =3D fw_size;
+	u8 *curr =3D (u8 *)fw;
+	u32 blksize;
+	u32 nblocks;
+	u32 offset;
+	u32 count;
+	u32 size;
+	dma_addr_t paddr;
+	void *data;
+	int ret =3D 0;
+
+	pr_debug("FW upload started: fw_addr =3D 0x%p, size=3D%d\n", fw, fw_size)=
;
+
+	blksize =3D ts->base.fw_blksize;
+
+	if (blksize < PAGE_SIZE)
+		blksize =3D PAGE_SIZE;
+
+	while (blksize >=3D PAGE_SIZE) {
+		pr_debug("allocating %u bytes to upload FW\n", blksize);
+		data =3D dma_alloc_coherent(&pdev->dev, blksize,
+					  &paddr, GFP_KERNEL);
+		if (data)
+			break;
+		blksize /=3D 2;
+	}
+
+	if (!data) {
+		pr_err("failed to allocate DMA buffer for FW upload\n");
+		ret =3D -ENOMEM;
+		goto fw_load_out;
+	}
+
+	nblocks =3D NBLOCKS(fw_size, blksize);
+	offset =3D readl(&bda->bda_dma_offset);
+
+	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_HOST_LOAD);
+	if (qtnf_poll_state(&ts->bda->bda_bootstate, QTN_BDA_FW_EP_RDY,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("card is not ready to download FW\n");
+		ret =3D -ETIMEDOUT;
+		goto fw_load_map;
+	}
+
+	for (count =3D 0 ; count < nblocks; count++) {
+		size =3D (remaining > blksize) ? blksize : remaining;
+
+		memcpy(data, curr, size);
+		qtnf_non_posted_write(paddr + offset, &bda->bda_img);
+		qtnf_non_posted_write(size, &bda->bda_img_size);
+
+		pr_debug("chunk[%u] VA[0x%p] PA[%pad] sz[%u]\n",
+			 count, (void *)curr, &paddr, size);
+
+		qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_BLOCK_RDY);
+		if (qtnf_poll_state(&ts->bda->bda_bootstate,
+				    QTN_BDA_FW_BLOCK_DONE,
+				    QTN_FW_DL_TIMEOUT_MS)) {
+			pr_err("confirmation for block #%d timed out\n", count);
+			ret =3D -ETIMEDOUT;
+			goto fw_load_map;
+		}
+
+		remaining =3D (remaining < size) ? remaining : (remaining - size);
+		curr +=3D size;
+	}
+
+	/* upload completion mark: zero-sized block */
+	qtnf_non_posted_write(0, &bda->bda_img);
+	qtnf_non_posted_write(0, &bda->bda_img_size);
+
+	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_BLOCK_RDY);
+	if (qtnf_poll_state(&ts->bda->bda_bootstate, QTN_BDA_FW_BLOCK_DONE,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("confirmation for the last block timed out\n");
+		ret =3D -ETIMEDOUT;
+		goto fw_load_map;
+	}
+
+	/* RC is done */
+	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_BLOCK_END);
+	if (qtnf_poll_state(&ts->bda->bda_bootstate, QTN_BDA_FW_LOAD_DONE,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("confirmation for FW upload completion timed out\n");
+		ret =3D -ETIMEDOUT;
+		goto fw_load_map;
+	}
+
+	pr_debug("FW upload completed: totally sent %d blocks\n", count);
+
+fw_load_map:
+	dma_free_coherent(&pdev->dev, blksize, data, paddr);
+
+fw_load_out:
+	return ret;
+}
+
+static int qtnf_topaz_fw_upload(struct qtnf_pcie_topaz_state *ts,
+				const char *fwname)
+{
+	const struct firmware *fw;
+	struct pci_dev *pdev =3D ts->base.pdev;
+	int ret;
+
+	if (qtnf_poll_state(&ts->bda->bda_bootstate,
+			    QTN_BDA_FW_LOAD_RDY,
+			    QTN_FW_DL_TIMEOUT_MS)) {
+		pr_err("%s: card is not ready\n", fwname);
+		return -1;
+	}
+
+	pr_info("starting firmware upload: %s\n", fwname);
+
+	ret =3D request_firmware(&fw, fwname, &pdev->dev);
+	if (ret < 0) {
+		pr_err("%s: request_firmware error %d\n", fwname, ret);
+		return -1;
+	}
+
+	ret =3D qtnf_ep_fw_load(ts, fw->data, fw->size);
+	release_firmware(fw);
+
+	if (ret)
+		pr_err("%s: FW upload error\n", fwname);
+
+	return ret;
+}
+
+static void qtnf_topaz_fw_work_handler(struct work_struct *work)
+{
+	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
+	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
+	int ret;
+	int bootloader_needed =3D readl(&ts->bda->bda_flags) & QTN_BDA_XMIT_UBOOT=
;
+
+	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_TARGET_BOOT);
+
+	if (bootloader_needed) {
+		ret =3D qtnf_topaz_fw_upload(ts, QTN_PCI_TOPAZ_BOOTLD_NAME);
+		if (ret)
+			goto fw_load_exit;
+
+		ret =3D qtnf_pre_init_ep(bus);
+		if (ret)
+			goto fw_load_exit;
+
+		qtnf_set_state(&ts->bda->bda_bootstate,
+			       QTN_BDA_FW_TARGET_BOOT);
+	}
+
+	if (ts->base.flashboot) {
+		pr_info("booting firmware from flash\n");
+
+		ret =3D qtnf_poll_state(&ts->bda->bda_bootstate,
+				      QTN_BDA_FW_FLASH_BOOT,
+				      QTN_FW_DL_TIMEOUT_MS);
+		if (ret)
+			goto fw_load_exit;
+	} else {
+		ret =3D qtnf_topaz_fw_upload(ts, QTN_PCI_TOPAZ_FW_NAME);
+		if (ret)
+			goto fw_load_exit;
+
+		qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_START);
+		ret =3D qtnf_poll_state(&ts->bda->bda_bootstate,
+				      QTN_BDA_FW_CONFIG,
+				      QTN_FW_QLINK_TIMEOUT_MS);
+		if (ret) {
+			pr_err("FW bringup timed out\n");
+			goto fw_load_exit;
+		}
+
+		qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_RUN);
+		ret =3D qtnf_poll_state(&ts->bda->bda_bootstate,
+				      QTN_BDA_FW_RUNNING,
+				      QTN_FW_QLINK_TIMEOUT_MS);
+		if (ret) {
+			pr_err("card bringup timed out\n");
+			goto fw_load_exit;
+		}
+	}
+
+	pr_info("firmware is up and running\n");
+
+	ret =3D qtnf_post_init_ep(ts);
+	if (ret)
+		pr_err("FW runtime failure\n");
+
+fw_load_exit:
+	qtnf_pcie_fw_boot_done(bus, ret ? false : true);
+
+	if (ret =3D=3D 0) {
+		qtnf_debugfs_add_entry(bus, "pkt_stats", qtnf_dbg_pkt_stats);
+		qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+	}
+}
+
+static void qtnf_reclaim_tasklet_fn(unsigned long data)
+{
+	struct qtnf_pcie_topaz_state *ts =3D (void *)data;
+
+	qtnf_topaz_data_tx_reclaim(ts);
+}
+
+static u64 qtnf_topaz_dma_mask_get(void)
+{
+	return DMA_BIT_MASK(32);
+}
+
+static int qtnf_pcie_topaz_probe(struct qtnf_bus *bus, unsigned int tx_bd_=
num)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D ts->base.pdev;
+	struct qtnf_shm_ipc_int ipc_int;
+	unsigned long irqflags;
+	int ret;
+
+	bus->bus_ops =3D &qtnf_pcie_topaz_bus_ops;
+	INIT_WORK(&bus->fw_work, qtnf_topaz_fw_work_handler);
+	ts->bda =3D ts->base.epmem_bar;
+
+	/* assign host msi irq before card init */
+	if (ts->base.msi_enabled)
+		irqflags =3D IRQF_NOBALANCING;
+	else
+		irqflags =3D IRQF_NOBALANCING | IRQF_SHARED;
+
+	ret =3D devm_request_irq(&pdev->dev, pdev->irq,
+			       &qtnf_pcie_topaz_interrupt,
+			       irqflags, "qtnf_topaz_irq", (void *)bus);
+	if (ret) {
+		pr_err("failed to request pcie irq %d\n", pdev->irq);
+		return ret;
+	}
+
+	disable_irq(pdev->irq);
+
+	ret =3D qtnf_pre_init_ep(bus);
+	if (ret) {
+		pr_err("failed to init card\n");
+		return ret;
+	}
+
+	ret =3D qtnf_pcie_topaz_init_xfer(ts, tx_bd_num);
+	if (ret) {
+		pr_err("PCIE xfer init failed\n");
+		return ret;
+	}
+
+	tasklet_init(&ts->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)ts);
+	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
+		       qtnf_topaz_rx_poll, 10);
+
+	ipc_int.fn =3D qtnf_topaz_ipc_gen_ep_int;
+	ipc_int.arg =3D ts;
+	qtnf_pcie_init_shm_ipc(&ts->base, &ts->bda->bda_shm_reg1,
+			       &ts->bda->bda_shm_reg2, &ipc_int);
+
+	return 0;
+}
+
+static void qtnf_pcie_topaz_remove(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+
+	qtnf_topaz_reset_ep(ts);
+	qtnf_topaz_free_xfer_buffers(ts);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int qtnf_pcie_topaz_suspend(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D ts->base.pdev;
+
+	writel((u32 __force)PCI_D3hot, ts->ep_pmstate);
+	dma_wmb();
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_PM_EP_IRQ),
+	       TOPAZ_LH_IPC4_INT(ts->base.sysctl_bar));
+
+	pci_save_state(pdev);
+	pci_enable_wake(pdev, PCI_D3hot, 1);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+static int qtnf_pcie_topaz_resume(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_topaz_state *ts =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D ts->base.pdev;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	pci_enable_wake(pdev, PCI_D0, 0);
+
+	writel((u32 __force)PCI_D0, ts->ep_pmstate);
+	dma_wmb();
+	writel(TOPAZ_IPC_IRQ_WORD(TOPAZ_RC_PM_EP_IRQ),
+	       TOPAZ_LH_IPC4_INT(ts->base.sysctl_bar));
+
+	return 0;
+}
+#endif
+
+struct qtnf_bus *qtnf_pcie_topaz_alloc(struct pci_dev *pdev)
+{
+	struct qtnf_bus *bus;
+	struct qtnf_pcie_topaz_state *ts;
+
+	bus =3D devm_kzalloc(&pdev->dev, sizeof(*bus) + sizeof(*ts), GFP_KERNEL);
+	if (!bus)
+		return NULL;
+
+	ts =3D get_bus_priv(bus);
+	ts->base.probe_cb =3D qtnf_pcie_topaz_probe;
+	ts->base.remove_cb =3D qtnf_pcie_topaz_remove;
+	ts->base.dma_mask_get_cb =3D qtnf_topaz_dma_mask_get;
+#ifdef CONFIG_PM_SLEEP
+	ts->base.resume_cb =3D qtnf_pcie_topaz_resume;
+	ts->base.suspend_cb =3D qtnf_pcie_topaz_suspend;
+#endif
+
+	return bus;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_ipc.h
new file mode 100644
index 000000000000..eb30e9d08de2
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_ipc.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018 Quantenna Communications */
+
+#ifndef _QTN_FMAC_PCIE_IPC_H_
+#define _QTN_FMAC_PCIE_IPC_H_
+
+#include <linux/types.h>
+
+#include "shm_ipc_defs.h"
+
+/* EP/RC status and flags */
+#define QTN_BDA_PCIE_INIT		0x01
+#define QTN_BDA_PCIE_RDY		0x02
+#define QTN_BDA_FW_LOAD_RDY		0x03
+#define QTN_BDA_FW_LOAD_DONE		0x04
+#define QTN_BDA_FW_START		0x05
+#define QTN_BDA_FW_RUN			0x06
+#define QTN_BDA_FW_HOST_RDY		0x07
+#define QTN_BDA_FW_TARGET_RDY		0x11
+#define QTN_BDA_FW_TARGET_BOOT		0x12
+#define QTN_BDA_FW_FLASH_BOOT		0x13
+#define QTN_BDA_FW_QLINK_DONE		0x14
+#define QTN_BDA_FW_HOST_LOAD		0x08
+#define QTN_BDA_FW_BLOCK_DONE		0x09
+#define QTN_BDA_FW_BLOCK_RDY		0x0A
+#define QTN_BDA_FW_EP_RDY		0x0B
+#define QTN_BDA_FW_BLOCK_END		0x0C
+#define QTN_BDA_FW_CONFIG		0x0D
+#define QTN_BDA_FW_RUNNING		0x0E
+#define QTN_BDA_PCIE_FAIL		0x82
+#define QTN_BDA_FW_LOAD_FAIL		0x85
+
+#define QTN_BDA_RCMODE			BIT(1)
+#define QTN_BDA_MSI			BIT(2)
+#define QTN_BDA_HOST_CALCMD		BIT(3)
+#define QTN_BDA_FLASH_PRESENT		BIT(4)
+#define QTN_BDA_FLASH_BOOT		BIT(5)
+#define QTN_BDA_XMIT_UBOOT		BIT(6)
+#define QTN_BDA_HOST_QLINK_DRV		BIT(7)
+#define QTN_BDA_TARGET_FBOOT_ERR	BIT(8)
+#define QTN_BDA_TARGET_FWLOAD_ERR	BIT(9)
+#define QTN_BDA_HOST_NOFW_ERR		BIT(12)
+#define QTN_BDA_HOST_MEMALLOC_ERR	BIT(13)
+#define QTN_BDA_HOST_MEMMAP_ERR		BIT(14)
+#define QTN_BDA_VER(x)			(((x) >> 4) & 0xFF)
+#define QTN_BDA_ERROR_MASK		0xFF00
+
+/* registers and shmem address macros */
+#if BITS_PER_LONG =3D=3D 64
+#define QTN_HOST_HI32(a)	((u32)(((u64)a) >> 32))
+#define QTN_HOST_LO32(a)	((u32)(((u64)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)	((((u64)h) << 32) | ((u64)l))
+#elif BITS_PER_LONG =3D=3D 32
+#define QTN_HOST_HI32(a)	0
+#define QTN_HOST_LO32(a)	((u32)(((u32)a) & 0xffffffffUL))
+#define QTN_HOST_ADDR(h, l)	((u32)l)
+#else
+#error Unexpected BITS_PER_LONG value
+#endif
+
+#define QTN_PCIE_BDA_VERSION		0x1001
+
+#define PCIE_BDA_NAMELEN		32
+
+#define QTN_PCIE_RC_TX_QUEUE_LEN	256
+#define QTN_PCIE_TX_VALID_PKT		0x80000000
+#define QTN_PCIE_PKT_LEN_MASK		0xffff
+
+#define QTN_BD_EMPTY		((uint32_t)0x00000001)
+#define QTN_BD_WRAP		((uint32_t)0x00000002)
+#define QTN_BD_MASK_LEN		((uint32_t)0xFFFF0000)
+#define QTN_BD_MASK_OFFSET	((uint32_t)0x0000FF00)
+
+#define QTN_GET_LEN(x)		(((x) >> 16) & 0xFFFF)
+#define QTN_GET_OFFSET(x)	(((x) >> 8) & 0xFF)
+#define QTN_SET_LEN(len)	(((len) & 0xFFFF) << 16)
+#define QTN_SET_OFFSET(of)	(((of) & 0xFF) << 8)
+
+#define RX_DONE_INTR_MSK	((0x1 << 6) - 1)
+
+#define PCIE_DMA_OFFSET_ERROR		0xFFFF
+#define PCIE_DMA_OFFSET_ERROR_MASK	0xFFFF
+
+#define QTN_PCI_ENDIAN_DETECT_DATA	0x12345678
+#define QTN_PCI_ENDIAN_REVERSE_DATA	0x78563412
+#define QTN_PCI_ENDIAN_VALID_STATUS	0x3c3c3c3c
+#define QTN_PCI_ENDIAN_INVALID_STATUS	0
+#define QTN_PCI_LITTLE_ENDIAN		0
+#define QTN_PCI_BIG_ENDIAN		0xffffffff
+
+#define NBLOCKS(size, blksize)		\
+	((size) / (blksize) + (((size) % (blksize) > 0) ? 1 : 0))
+
+#endif /* _QTN_FMAC_PCIE_IPC_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_regs.h =
b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_regs.h
new file mode 100644
index 000000000000..4782e1ed3c2c
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie_regs.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018 Quantenna Communications */
+
+#ifndef __TOPAZ_PCIE_H
+#define __TOPAZ_PCIE_H
+
+/* Topaz PCIe DMA registers */
+#define PCIE_DMA_WR_INTR_STATUS(base)		((base) + 0x9bc)
+#define PCIE_DMA_WR_INTR_MASK(base)		((base) + 0x9c4)
+#define PCIE_DMA_WR_INTR_CLR(base)		((base) + 0x9c8)
+#define PCIE_DMA_WR_ERR_STATUS(base)		((base) + 0x9cc)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_LOW(base)	((base) + 0x9D0)
+#define PCIE_DMA_WR_DONE_IMWR_ADDR_HIGH(base)	((base) + 0x9d4)
+
+#define PCIE_DMA_RD_INTR_STATUS(base)		((base) + 0x310)
+#define PCIE_DMA_RD_INTR_MASK(base)		((base) + 0x319)
+#define PCIE_DMA_RD_INTR_CLR(base)		((base) + 0x31c)
+#define PCIE_DMA_RD_ERR_STATUS_LOW(base)	((base) + 0x324)
+#define PCIE_DMA_RD_ERR_STATUS_HIGH(base)	((base) + 0x328)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_LOW(base)	((base) + 0x33c)
+#define PCIE_DMA_RD_DONE_IMWR_ADDR_HIGH(base)	((base) + 0x340)
+
+/* Topaz LHost IPC4 interrupt */
+#define TOPAZ_LH_IPC4_INT(base)			((base) + 0x13C)
+#define TOPAZ_LH_IPC4_INT_MASK(base)		((base) + 0x140)
+
+#define TOPAZ_RC_TX_DONE_IRQ			(0)
+#define TOPAZ_RC_RST_EP_IRQ			(1)
+#define TOPAZ_RC_TX_STOP_IRQ			(2)
+#define TOPAZ_RC_RX_DONE_IRQ			(3)
+#define TOPAZ_RC_PM_EP_IRQ			(4)
+
+/* Topaz LHost M2L interrupt */
+#define TOPAZ_CTL_M2L_INT(base)			((base) + 0x2C)
+#define TOPAZ_CTL_M2L_INT_MASK(base)		((base) + 0x30)
+
+#define TOPAZ_RC_CTRL_IRQ			(6)
+
+#define TOPAZ_IPC_IRQ_WORD(irq)			(BIT(irq) | BIT(irq + 16))
+
+/* PCIe legacy INTx */
+#define TOPAZ_PCIE_CFG0_OFFSET	(0x6C)
+#define TOPAZ_ASSERT_INTX	BIT(9)
+
+#endif /* __TOPAZ_PCIE_H */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/=
net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
index 1fe798a9a667..165fcbb41255 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
@@ -24,6 +24,7 @@
 /* PCIE Device IDs */
=20
 #define	PCIE_DEVICE_ID_QTN_PEARL	(0x0008)
+#define	PCIE_DEVICE_ID_QTN_TOPAZ	(0x0008)
=20
 #define QTN_REG_SYS_CTRL_CSR		0x14
 #define QTN_CHIP_ID_MASK		0xF0
@@ -35,6 +36,8 @@
 /* FW names */
=20
 #define QTN_PCI_PEARL_FW_NAME		"qtn/fmac_qsr10g.img"
+#define QTN_PCI_TOPAZ_FW_NAME		"qtn/fmac_qsr1000.img"
+#define QTN_PCI_TOPAZ_BOOTLD_NAME	"qtn/uboot_qsr1000.img"
=20
 static inline unsigned int qtnf_chip_id_get(const void __iomem *regs_base)
 {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wi=
reless/quantenna/qtnfmac/util.c
index dfe3fe8a42c1..3bc96b264769 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -121,6 +121,8 @@ void qtnf_sta_list_free(struct qtnf_sta_list *list)
 const char *qtnf_chipid_to_string(unsigned long chip_id)
 {
 	switch (chip_id) {
+	case QTN_CHIP_ID_TOPAZ:
+		return "Topaz";
 	case QTN_CHIP_ID_PEARL:
 		return "Pearl revA";
 	case QTN_CHIP_ID_PEARL_B:
--=20
2.11.0

