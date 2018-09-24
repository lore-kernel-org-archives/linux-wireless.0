Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A0DECE561
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39EF121480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="NLpqYatT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39EF121480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbeIXLNw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:13:52 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeIXLNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhG98BPfuWGl9VzUhi/HRMw4tFdh/Om0YWL+WQ0IW24=;
 b=NLpqYatTUKbBK5fOAdrCrTRzKqr5QkIoTUy3mhmsiLC1zzEAZgENyPNdsB5durDKerynVm3RNkRjxDn+QAjhvSKYQyXzW27CNJ0wXS5f005J2/2fE0LfwvvLX7N4unsfBRAqU6L6lPLHX+CLECtDkamxRN5W3D8PmlFv4aoxt8g=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:26 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:26 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 03/11] qtnfmac_pcie: rename private Pearl PCIe state structure
Thread-Topic: [PATCH 03/11] qtnfmac_pcie: rename private Pearl PCIe state
 structure
Thread-Index: AQHUU8VSnDARYSr9s0GafMWkemnlxQ==
Date:   Mon, 24 Sep 2018 05:13:26 +0000
Message-ID: <20180924051246.13371-4-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:eNrz5RhyIqhCVRzJVrpU541rckbIxQxYcvvHV4lLT2fv9Bi3sAIJIZdL4HjMytcqri2YEf53vI7QbDlJypCdGHI45CziHGivtjxKxQ8faYUOCo7vfG7L7JVyUAWoUKlbi6my1P+/RCfBozw9plBGk8ATH5WAw1IIZwBXJEKiguSlGJIa4zIxsUuM1Evn+6GFufXTkKn+YhoykHeoruyMF9v8Dx4ZUMtej2enR3TutoKnoTsbo68loK/WzzRIxzMb+fILgFl8kpgub4Ad/fOcR4XYICa63cMhyrzYsh0Nqmi/fgz2gaY6ZeGYqBDgWLKNPWi2ZFTPKWupiH/twHRf/ijdlA0bw+EIhiz/2A9D+IrXV+C1rPHjlFJzOTS6BUlydr4Nd/D0sRbSnXGfVZWGJDwfzNmlzcZl0ewFb5e981wS6FxmlhlBX4wOq3GXGjHfqFPzc/tyt6ACXfe5Or45fw==;5:ROHLras4bYcB+6SLxriBWEHmvU+NHmgeU5Sn0hLSvgwvHH7dcdaf9rsV0XOgRlqLJ5iDMxMXBcOCI0jVW1JT2iKxMUB0BKBU8FRjosdkzRYjuZ/qudA+PoCayvDFMIeX/taexYLCy5aqX8gVoEj+gLLIVNW1bohQJSbtx+VMyJo=;7:L59wMF1JfnTME+5HOnvDdYS0jAWqR9cc1V51CqlyKFMa8SBgaBJdf6NK3sAFuJ4gVWBLbsPPreU5OyU81ykL6fTj4ltk7tpwxJnwYLZgoDBEDjg9fl3522IEaXnwUDfA+gHjaeDhQ5oSnImvhjYH7q1Pw2UGMYsuJYP2MrjYGBvbPQIDosVPfp2jY+eh2ayGEl9dOaE0+f9W7RF6jkk5ierW9XXEwfnS6G1yPoQxzY+ZPCrZdjG3R408kbsTW5H0
x-ms-office365-filtering-correlation-id: 8ce1f0e1-4ce3-4b3e-8ece-08d621dc74f6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB29751BF48BD2038693DF72A8B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(53946003)(3846002)(256004)(76176011)(5024004)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001)(2004002)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: k81WY1e57PcSYhkH4nIF9Kn/EeVXpVsUxYMjnb2sSEo6gBWTre365QFPN5Ju5qnYErvAsGcCaqOvgRJCflVj6XZwdjNUq0/MuThLK0zvRbqf7/0z2wA/+M7Krfv267Rff7kYncVWja5Y1JIht5RqkLmfbplklnJO+/554mk1ACLCpwQjNBSqWCxHY0t4PzPNwQ5AzToz3PuSou3xV3XopzTn60l3+sjuAsPHp35ijgvyJmqugX2dlL/qt3rx8XeNaSrTRW28e8J0IBQI8BiTiVDH8S5/MCp8f/Pfju73Rv5WmjeYfv70ryntbs2ZGMZC7elTOFdZuMW2VEVrkA3sgQ2p0U5sVcuEWAOtBKEQymA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce1f0e1-4ce3-4b3e-8ece-08d621dc74f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:26.3054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051326.icL-xby39D2XJRgIZXS7ZZ1rYva5qn0wf_pWY-LjOQU@z>

In preparation to extract common pcie driver state into a separate
structure, rename Pearl-specific state to qtnf_pcie_pearl_state and move
it directly to pearl-specific PCIe source file.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 158 +++++++++++++++--=
----
 .../quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h   |  91 ------------
 2 files changed, 111 insertions(+), 138 deletions(-)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_=
bus_priv.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 269a6e4..ab06eca 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -28,10 +28,12 @@
 #include <linux/circ_buf.h>
 #include <linux/log2.h>
=20
+#include "pearl_pcie_regs.h"
+#include "pearl_pcie_ipc.h"
 #include "qtn_hw_ids.h"
-#include "pearl_pcie_bus_priv.h"
 #include "core.h"
 #include "bus.h"
+#include "shm_ipc.h"
 #include "debug.h"
=20
 static bool use_msi =3D true;
@@ -52,6 +54,68 @@ MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary f=
ile on FS");
=20
 #define DRV_NAME	"qtnfmac_pearl_pcie"
=20
+struct qtnf_pcie_pearl_state {
+	struct pci_dev  *pdev;
+
+	/* lock for irq configuration changes */
+	spinlock_t irq_lock;
+
+	/* lock for tx reclaim operations */
+	spinlock_t tx_reclaim_lock;
+	/* lock for tx0 operations */
+	spinlock_t tx0_lock;
+	u8 msi_enabled;
+	u8 tx_stopped;
+	int mps;
+
+	struct workqueue_struct *workqueue;
+	struct tasklet_struct reclaim_tq;
+
+	void __iomem *sysctl_bar;
+	void __iomem *epmem_bar;
+	void __iomem *dmareg_bar;
+
+	struct qtnf_shm_ipc shm_ipc_ep_in;
+	struct qtnf_shm_ipc shm_ipc_ep_out;
+
+	struct qtnf_pcie_bda __iomem *bda;
+	void __iomem *pcie_reg_base;
+
+	u16 tx_bd_num;
+	u16 rx_bd_num;
+
+	struct sk_buff **tx_skb;
+	struct sk_buff **rx_skb;
+
+	struct qtnf_tx_bd *tx_bd_vbase;
+	dma_addr_t tx_bd_pbase;
+
+	struct qtnf_rx_bd *rx_bd_vbase;
+	dma_addr_t rx_bd_pbase;
+
+	dma_addr_t bd_table_paddr;
+	void *bd_table_vaddr;
+	u32 bd_table_len;
+
+	u32 rx_bd_w_index;
+	u32 rx_bd_r_index;
+
+	u32 tx_bd_w_index;
+	u32 tx_bd_r_index;
+
+	u32 pcie_irq_mask;
+
+	/* diagnostics stats */
+	u32 pcie_irq_count;
+	u32 pcie_irq_rx_count;
+	u32 pcie_irq_tx_count;
+	u32 pcie_irq_uf_count;
+	u32 tx_full_count;
+	u32 tx_done_count;
+	u32 tx_reclaim_done;
+	u32 tx_reclaim_req;
+};
+
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
 	writel(val, basereg);
@@ -60,7 +124,7 @@ static inline void qtnf_non_posted_write(u32 val, void _=
_iomem *basereg)
 	readl(basereg);
 }
=20
-static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
=20
@@ -69,7 +133,7 @@ static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_b=
us_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *priv=
)
 {
 	unsigned long flags;
=20
@@ -78,7 +142,7 @@ static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie=
_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *pri=
v)
 {
 	unsigned long flags;
=20
@@ -87,7 +151,7 @@ static inline void qtnf_disable_hdp_irqs(struct qtnf_pci=
e_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
=20
@@ -97,7 +161,7 @@ static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_b=
us_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
=20
@@ -107,7 +171,7 @@ static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie=
_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_en_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
=20
@@ -117,7 +181,7 @@ static inline void qtnf_en_txdone_irq(struct qtnf_pcie_=
bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_bus_priv *priv)
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	unsigned long flags;
=20
@@ -127,7 +191,7 @@ static inline void qtnf_dis_txdone_irq(struct qtnf_pcie=
_bus_priv *priv)
 	spin_unlock_irqrestore(&priv->irq_lock, flags);
 }
=20
-static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_state *priv)
 {
 	struct pci_dev *pdev =3D priv->pdev;
=20
@@ -150,7 +214,7 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_pri=
v *priv)
 	}
 }
=20
-static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *priv)
 {
 	void __iomem *reg =3D priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
 	u32 cfg;
@@ -160,7 +224,7 @@ static void qtnf_deassert_intx(struct qtnf_pcie_bus_pri=
v *priv)
 	qtnf_non_posted_write(cfg, reg);
 }
=20
-static void qtnf_reset_card(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_reset_card(struct qtnf_pcie_pearl_state *priv)
 {
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
 	void __iomem *reg =3D priv->sysctl_bar +
@@ -173,7 +237,7 @@ static void qtnf_reset_card(struct qtnf_pcie_bus_priv *=
priv)
=20
 static void qtnf_ipc_gen_ep_int(void *arg)
 {
-	const struct qtnf_pcie_bus_priv *priv =3D arg;
+	const struct qtnf_pcie_pearl_state *priv =3D arg;
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
 	void __iomem *reg =3D priv->sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
@@ -181,7 +245,7 @@ static void qtnf_ipc_gen_ep_int(void *arg)
 	qtnf_non_posted_write(data, reg);
 }
=20
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 inde=
x)
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_pearl_state *priv, u8 i=
ndex)
 {
 	void __iomem *vaddr;
 	dma_addr_t busaddr;
@@ -206,7 +270,7 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_=
priv *priv, u8 index)
=20
 static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t=
 len)
 {
-	struct qtnf_pcie_bus_priv *priv =3D arg;
+	struct qtnf_pcie_pearl_state *priv =3D arg;
 	struct qtnf_bus *bus =3D pci_get_drvdata(priv->pdev);
 	struct sk_buff *skb;
=20
@@ -227,7 +291,7 @@ static void qtnf_pcie_control_rx_callback(void *arg, co=
nst u8 *buf, size_t len)
 	qtnf_trans_handle_rx_ctl_packet(bus, skb);
 }
=20
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
@@ -248,13 +312,13 @@ static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bu=
s_priv *priv)
 	return 0;
 }
=20
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_pearl_state *priv)
 {
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
 }
=20
-static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *priv)
 {
 	int ret =3D -ENOMEM;
=20
@@ -283,7 +347,7 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_p=
riv *priv)
 	return 0;
 }
=20
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_pearl_state *priv)
 {
 	struct pci_dev *pdev =3D priv->pdev;
 	struct pci_dev *parent;
@@ -355,7 +419,7 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 sta=
te, u32 delay_in_ms)
 	return 0;
 }
=20
-static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+static int alloc_skb_array(struct qtnf_pcie_pearl_state *priv)
 {
 	struct sk_buff **vaddr;
 	int len;
@@ -375,7 +439,7 @@ static int alloc_skb_array(struct qtnf_pcie_bus_priv *p=
riv)
 	return 0;
 }
=20
-static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
+static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
 {
 	dma_addr_t paddr;
 	void *vaddr;
@@ -426,7 +490,7 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *pr=
iv)
 	return 0;
 }
=20
-static int skb2rbd_attach(struct qtnf_pcie_bus_priv *priv, u16 index)
+static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
 {
 	struct qtnf_rx_bd *rxbd;
 	struct sk_buff *skb;
@@ -469,7 +533,7 @@ static int skb2rbd_attach(struct qtnf_pcie_bus_priv *pr=
iv, u16 index)
 	return 0;
 }
=20
-static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *priv)
+static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 i;
 	int ret =3D 0;
@@ -487,7 +551,7 @@ static int alloc_rx_buffers(struct qtnf_pcie_bus_priv *=
priv)
 }
=20
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct qtnf_rx_bd *rxbd;
@@ -524,7 +588,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_bus=
_priv *priv)
 	}
 }
=20
-static int qtnf_hhbm_init(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *priv)
 {
 	u32 val;
=20
@@ -542,7 +606,7 @@ static int qtnf_hhbm_init(struct qtnf_pcie_bus_priv *pr=
iv)
 	return 0;
 }
=20
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
 {
 	int ret;
 	u32 val;
@@ -605,7 +669,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_pri=
v *priv)
 	return ret;
 }
=20
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
 {
 	struct qtnf_tx_bd *txbd;
 	struct sk_buff *skb;
@@ -656,7 +720,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_=
bus_priv *priv)
 	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
 }
=20
-static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
@@ -675,7 +739,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_pri=
v *priv)
=20
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_tx_bd *txbd;
 	unsigned long flags;
@@ -750,7 +814,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
=20
 static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	int ret;
=20
 	ret =3D qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
@@ -766,7 +830,7 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus, s=
truct sk_buff *skb)
 static irqreturn_t qtnf_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus =3D (struct qtnf_bus *)data;
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	u32 status;
=20
 	priv->pcie_irq_count++;
@@ -807,7 +871,7 @@ static irqreturn_t qtnf_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
=20
-static int qtnf_rx_data_ready(struct qtnf_pcie_bus_priv *priv)
+static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
 {
 	u16 index =3D priv->rx_bd_r_index;
 	struct qtnf_rx_bd *rxbd;
@@ -825,7 +889,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_bus_priv=
 *priv)
 static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus =3D container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	struct net_device *ndev =3D NULL;
 	struct sk_buff *skb =3D NULL;
 	int processed =3D 0;
@@ -930,14 +994,14 @@ static int qtnf_rx_poll(struct napi_struct *napi, int=
 budget)
 static void
 qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
=20
 	tasklet_hi_schedule(&priv->reclaim_tq);
 }
=20
 static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
=20
 	qtnf_enable_hdp_irqs(priv);
 	napi_enable(&bus->mux_napi);
@@ -945,7 +1009,7 @@ static void qtnf_pcie_data_rx_start(struct qtnf_bus *b=
us)
=20
 static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
=20
 	napi_disable(&bus->mux_napi);
 	qtnf_disable_hdp_irqs(priv);
@@ -965,7 +1029,7 @@ static const struct qtnf_bus_ops qtnf_pcie_bus_ops =3D=
 {
 static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "%d\n", priv->mps);
=20
@@ -975,7 +1039,7 @@ static int qtnf_dbg_mps_show(struct seq_file *s, void =
*data)
 static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "%u\n", priv->msi_enabled);
=20
@@ -985,7 +1049,7 @@ static int qtnf_dbg_msi_show(struct seq_file *s, void =
*data)
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
 	u32 reg =3D readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
 	u32 status;
=20
@@ -1009,7 +1073,7 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, voi=
d *data)
 static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
@@ -1040,7 +1104,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, voi=
d *data)
 static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
 		   priv->shm_ipc_ep_in.tx_packet_count);
@@ -1054,7 +1118,7 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, voi=
d *data)
 	return 0;
 }
=20
-static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv *priv, uint32_t size,
+static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t si=
ze,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
 	struct pci_dev *pdev =3D priv->pdev;
@@ -1103,7 +1167,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_bus_priv =
*priv, uint32_t size,
 }
=20
 static int
-qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, const u8 *fw, u32 fw_size=
)
+qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_s=
ize)
 {
 	int blk_size =3D QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pcie_fw_hdr);
 	int blk_count =3D fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
@@ -1172,7 +1236,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_bus_priv *priv, cons=
t u8 *fw, u32 fw_size)
 static void qtnf_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	struct pci_dev *pdev =3D priv->pdev;
 	const struct firmware *fw;
 	int ret;
@@ -1256,7 +1320,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
=20
 static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
 	struct pci_dev *pdev =3D priv->pdev;
=20
 	get_device(&pdev->dev);
@@ -1266,7 +1330,7 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *bu=
s)
=20
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
-	struct qtnf_pcie_bus_priv *priv =3D (void *)data;
+	struct qtnf_pcie_pearl_state *priv =3D (void *)data;
=20
 	qtnf_pcie_data_tx_reclaim(priv);
 	qtnf_en_txdone_irq(priv);
@@ -1274,7 +1338,7 @@ static void qtnf_reclaim_tasklet_fn(unsigned long dat=
a)
=20
 static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_i=
d *id)
 {
-	struct qtnf_pcie_bus_priv *pcie_priv;
+	struct qtnf_pcie_pearl_state *pcie_priv;
 	struct qtnf_bus *bus;
 	int ret;
=20
@@ -1407,7 +1471,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
=20
 static void qtnf_pcie_remove(struct pci_dev *pdev)
 {
-	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_pcie_pearl_state *priv;
 	struct qtnf_bus *bus;
=20
 	bus =3D pci_get_drvdata(pdev);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_pri=
v.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
deleted file mode 100644
index 986b957..0000000
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * Copyright (c) 2015-2016 Quantenna Communications, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef _QTN_FMAC_PCIE_H_
-#define _QTN_FMAC_PCIE_H_
-
-#include <linux/dma-mapping.h>
-#include <linux/io.h>
-
-#include "pearl_pcie_regs.h"
-#include "pearl_pcie_ipc.h"
-#include "shm_ipc.h"
-
-struct bus;
-
-struct qtnf_pcie_bus_priv {
-	struct pci_dev  *pdev;
-
-	/* lock for irq configuration changes */
-	spinlock_t irq_lock;
-
-	/* lock for tx reclaim operations */
-	spinlock_t tx_reclaim_lock;
-	/* lock for tx0 operations */
-	spinlock_t tx0_lock;
-	u8 msi_enabled;
-	u8 tx_stopped;
-	int mps;
-
-	struct workqueue_struct *workqueue;
-	struct tasklet_struct reclaim_tq;
-
-	void __iomem *sysctl_bar;
-	void __iomem *epmem_bar;
-	void __iomem *dmareg_bar;
-
-	struct qtnf_shm_ipc shm_ipc_ep_in;
-	struct qtnf_shm_ipc shm_ipc_ep_out;
-
-	struct qtnf_pcie_bda __iomem *bda;
-	void __iomem *pcie_reg_base;
-
-	u16 tx_bd_num;
-	u16 rx_bd_num;
-
-	struct sk_buff **tx_skb;
-	struct sk_buff **rx_skb;
-
-	struct qtnf_tx_bd *tx_bd_vbase;
-	dma_addr_t tx_bd_pbase;
-
-	struct qtnf_rx_bd *rx_bd_vbase;
-	dma_addr_t rx_bd_pbase;
-
-	dma_addr_t bd_table_paddr;
-	void *bd_table_vaddr;
-	u32 bd_table_len;
-
-	u32 rx_bd_w_index;
-	u32 rx_bd_r_index;
-
-	u32 tx_bd_w_index;
-	u32 tx_bd_r_index;
-
-	u32 pcie_irq_mask;
-
-	/* diagnostics stats */
-	u32 pcie_irq_count;
-	u32 pcie_irq_rx_count;
-	u32 pcie_irq_tx_count;
-	u32 pcie_irq_uf_count;
-	u32 tx_full_count;
-	u32 tx_done_count;
-	u32 tx_reclaim_done;
-	u32 tx_reclaim_req;
-};
-
-#endif /* _QTN_FMAC_PCIE_H_ */
--=20
2.9.5

