Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFC9C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0192B21486
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="p+xzyRpu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0192B21486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbeIXLOB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:01 -0400
Received: from mail-eopbgr700049.outbound.protection.outlook.com ([40.107.70.49]:61600
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbeIXLOA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxcCJwPQhdkljxcmb0aDgu9GHtsnfA4YGeKKPSlF6mA=;
 b=p+xzyRpuf7NxMhLMeyW15xgURlzTZdFgPNYOUZO+h7IqvISmvoj4EYczSI8gpiV8gELF5/yibiuWy+ZinO4RYev0UdVZ+pMurYC5VpZjnNht2/bPCv8BNUvXWiWqOE8jLAc+0CALHSOgV//EAVeD6wFG0j3D5LPuTfh41va9yqU=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:28 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:28 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 06/11] qtnfmac_pcie: separate platform-independent PCIe
 structure
Thread-Topic: [PATCH 06/11] qtnfmac_pcie: separate platform-independent PCIe
 structure
Thread-Index: AQHUU8VUJLCN6o0aLUq7QQLzwXPgnA==
Date:   Mon, 24 Sep 2018 05:13:28 +0000
Message-ID: <20180924051246.13371-7-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:OPGAiJKq0WOwRb+fOleJ8bsP0tZgHpIb91JdipGGB500wn2q+7hJNzt0xkHuAAMxHAsClEPUR5VuQWstEzsU16a8vxMeRWLwvE4nTigvYxTp23brJD7U2dsOmdRkn3j4pFtnr/oEtM9C0VStGrL5poofnK9+xvX2vmgXpg8OhARYKk9Q8wDrCBNqgeVWwNxVcUY4faqC1LNhg58VHhZIgbrgax4iDWWXWLYNCNKm2XQKw/75jseCOZMdlfG1u+i/3NOb4gM7eBilDH6x+iMhSsnibqRht0I0JCNr0JKBV7eUnpGqRU1GK2wFb97C5hYlB4zKL2gYrGn10VasWvmiKX2Y4NOX4nSOUuAYGfHhS7v+Rw2diy/dPdgancbX5OdAg1/noaYQEZLp5DsX5rFR7mrqd8c6b7EB7J77WAsFjXzf8FQX+ruLwWY/slutVAGv88KEEjudeViHXZE97/BjrA==;5:zbYvSGsgjkN2URTK5jXiLAgxpiHBZkZvb0jX/3Vsmty8tTmMqd4l2AKPv+ItiwWhbcTNbb1cBa/RYhYm/qVt+cNoHwTDCQcP+XjePUDcvyJbvwtW3YOYfx95nBKnzqbIglWGibqdz8B2OuMS7aC2fj6+lg9e0rosEGxIbMsRJao=;7:fG22jWTHZ6/hdjjrKFeFNiYlp+3cff/UdeTr+Gk0Rm9BSmvWV+d0SHzXe5DCRk9yT5zwXuXzNrH/GeTEFoVvomBqgYzU50ARbAtW7kW+wWHQkyRA7wli4JEc2+SRp8y7hLYKyfxYN10QEbjbwdlVOdBcuOBG+HNYxeE/Wh5CUpLB8MzyNaUXyWlg5X3kpB8N4pPggZtMkQjr5GKdQw93ADrM/fVeDBnD7VWJQwO5HBpt/qNArVHL19LZI26WyZMw
x-ms-office365-filtering-correlation-id: 7c0b0ccc-7daa-432a-95f2-08d621dc7662
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975CDF382DDC7E1864E789BB0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(575784001)(81166006)(52116002)(16200700003)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(53946003)(3846002)(256004)(76176011)(5024004)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001)(2004002)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: 1NV9K2vz6JxkJqvvfkLICgBTh9cajUs6uh2Of7HQ7o2LoP67WzqnTiRwriC7eoQaalH2W6uyvRgu+bEYvHtwel5RfQI9229wkKXhN/jmFlBOKsHEW06KIhGm46TNLuhPR0glSeMsV0//CsbalQph+BrzBtMERlC/q+AlYf8MWUgKxMf5oHVdnMRVyV8rSEGXH2HW/oBbokG0YcUPiSJiYExL5kLzTwkDXB22RQc8nxFiy9zwHyzPNHQbaqrFSfE95XRw8DxybUQbwVAkxY66s72vi1LPHttl7W1tJYxNBxuJOCh5+qguozc77P31cBdJNfHO0enwayl9uyZeB80p5Gv6pFnG9SzQb+3bhE/gWQ8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0b0ccc-7daa-432a-95f2-08d621dc7662
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:28.7601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051328.algW2Af9SF3zWI3ITVHTZ6OuHwT_SKi_iIgH0h20Io0@z>

Move platform-independent PCIe data structure to a separate header file
so it can be reused by different devices.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  83 ++++
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 471 ++++++++++-------=
----
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   7 -
 3 files changed, 300 insertions(+), 261 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
new file mode 100644
index 0000000..1ad5eb8
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2018 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _QTN_FMAC_PCIE_H_
+#define _QTN_FMAC_PCIE_H_
+
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+
+#include "shm_ipc.h"
+
+#define SKB_BUF_SIZE		2048
+
+#define QTN_FW_DL_TIMEOUT_MS	3000
+#define QTN_FW_QLINK_TIMEOUT_MS	30000
+#define QTN_EP_RESET_WAIT_MS	1000
+
+struct qtnf_pcie_bus_priv {
+	struct pci_dev *pdev;
+
+	spinlock_t tx_reclaim_lock;
+	spinlock_t tx_lock;
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
+	u16 tx_bd_num;
+	u16 rx_bd_num;
+
+	struct sk_buff **tx_skb;
+	struct sk_buff **rx_skb;
+
+	u32 rx_bd_w_index;
+	u32 rx_bd_r_index;
+
+	u32 tx_bd_w_index;
+	u32 tx_bd_r_index;
+
+	/* diagnostics stats */
+	u32 pcie_irq_count;
+	u32 tx_full_count;
+	u32 tx_done_count;
+	u32 tx_reclaim_done;
+	u32 tx_reclaim_req;
+
+	u8 msi_enabled;
+	u8 tx_stopped;
+};
+
+static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
+{
+	writel(val, basereg);
+
+	/* flush posted write */
+	readl(basereg);
+}
+
+#endif /* _QTN_FMAC_PCIE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 791a1e3..97f3001 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -28,6 +28,7 @@
 #include <linux/circ_buf.h>
 #include <linux/log2.h>
=20
+#include "pcie_priv.h"
 #include "pearl_pcie_regs.h"
 #include "pearl_pcie_ipc.h"
 #include "qtn_hw_ids.h"
@@ -102,38 +103,14 @@ struct qtnf_pearl_fw_hdr {
 } __packed;
=20
 struct qtnf_pcie_pearl_state {
-	struct pci_dev  *pdev;
+	struct qtnf_pcie_bus_priv base;
=20
 	/* lock for irq configuration changes */
 	spinlock_t irq_lock;
=20
-	/* lock for tx reclaim operations */
-	spinlock_t tx_reclaim_lock;
-	/* lock for tx0 operations */
-	spinlock_t tx_lock;
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
 	struct qtnf_pearl_bda __iomem *bda;
 	void __iomem *pcie_reg_base;
=20
-	u16 tx_bd_num;
-	u16 rx_bd_num;
-
-	struct sk_buff **tx_skb;
-	struct sk_buff **rx_skb;
-
 	struct qtnf_pearl_tx_bd *tx_bd_vbase;
 	dma_addr_t tx_bd_pbase;
=20
@@ -143,102 +120,80 @@ struct qtnf_pcie_pearl_state {
 	dma_addr_t bd_table_paddr;
 	void *bd_table_vaddr;
 	u32 bd_table_len;
-
-	u32 rx_bd_w_index;
-	u32 rx_bd_r_index;
-
-	u32 tx_bd_w_index;
-	u32 tx_bd_r_index;
-
 	u32 pcie_irq_mask;
-
-	/* diagnostics stats */
-	u32 pcie_irq_count;
 	u32 pcie_irq_rx_count;
 	u32 pcie_irq_tx_count;
 	u32 pcie_irq_uf_count;
-	u32 tx_full_count;
-	u32 tx_done_count;
-	u32 tx_reclaim_done;
-	u32 tx_reclaim_req;
 };
=20
-static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
-{
-	writel(val, basereg);
-
-	/* flush posted write */
-	readl(basereg);
-}
-
-static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_init_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask =3D (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask =3D (PCIE_HDP_INT_RX_BITS | PCIE_HDP_INT_TX_BITS);
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *priv=
)
+static inline void qtnf_enable_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *pri=
v)
+static inline void qtnf_disable_hdp_irqs(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	writel(0x0, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	writel(0x0, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_en_rxdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask |=3D PCIE_HDP_INT_RX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask |=3D PCIE_HDP_INT_RX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_dis_rxdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask &=3D ~PCIE_HDP_INT_RX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask &=3D ~PCIE_HDP_INT_RX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_en_txdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask |=3D PCIE_HDP_INT_TX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask |=3D PCIE_HDP_INT_TX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *priv)
+static inline void qtnf_dis_txdone_irq(struct qtnf_pcie_pearl_state *ps)
 {
 	unsigned long flags;
=20
-	spin_lock_irqsave(&priv->irq_lock, flags);
-	priv->pcie_irq_mask &=3D ~PCIE_HDP_INT_TX_BITS;
-	writel(priv->pcie_irq_mask, PCIE_HDP_INT_EN(priv->pcie_reg_base));
-	spin_unlock_irqrestore(&priv->irq_lock, flags);
+	spin_lock_irqsave(&ps->irq_lock, flags);
+	ps->pcie_irq_mask &=3D ~PCIE_HDP_INT_TX_BITS;
+	writel(ps->pcie_irq_mask, PCIE_HDP_INT_EN(ps->pcie_reg_base));
+	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev =3D priv->pdev;
=20
@@ -261,9 +216,9 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_pearl_s=
tate *priv)
 	}
 }
=20
-static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *ps)
 {
-	void __iomem *reg =3D priv->sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
+	void __iomem *reg =3D ps->base.sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
 	u32 cfg;
=20
 	cfg =3D readl(reg);
@@ -271,28 +226,28 @@ static void qtnf_deassert_intx(struct qtnf_pcie_pearl=
_state *priv)
 	qtnf_non_posted_write(cfg, reg);
 }
=20
-static void qtnf_reset_card(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_reset_card(struct qtnf_pcie_pearl_state *ps)
 {
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
-	void __iomem *reg =3D priv->sysctl_bar +
+	void __iomem *reg =3D ps->base.sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
=20
 	qtnf_non_posted_write(data, reg);
 	msleep(QTN_EP_RESET_WAIT_MS);
-	pci_restore_state(priv->pdev);
+	pci_restore_state(ps->base.pdev);
 }
=20
 static void qtnf_ipc_gen_ep_int(void *arg)
 {
-	const struct qtnf_pcie_pearl_state *priv =3D arg;
+	const struct qtnf_pcie_pearl_state *ps =3D arg;
 	const u32 data =3D QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_IPC_IRQ);
-	void __iomem *reg =3D priv->sysctl_bar +
+	void __iomem *reg =3D ps->base.sysctl_bar +
 			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
=20
 	qtnf_non_posted_write(data, reg);
 }
=20
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_pearl_state *priv, u8 i=
ndex)
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 inde=
x)
 {
 	void __iomem *vaddr;
 	dma_addr_t busaddr;
@@ -317,7 +272,7 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_pear=
l_state *priv, u8 index)
=20
 static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t=
 len)
 {
-	struct qtnf_pcie_pearl_state *priv =3D arg;
+	struct qtnf_pcie_bus_priv *priv =3D arg;
 	struct qtnf_bus *bus =3D pci_get_drvdata(priv->pdev);
 	struct sk_buff *skb;
=20
@@ -338,35 +293,36 @@ static void qtnf_pcie_control_rx_callback(void *arg, =
const u8 *buf, size_t len)
 	qtnf_trans_handle_rx_ctl_packet(bus, skb);
 }
=20
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
 	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int =3D { qtnf_ipc_gen_ep_int, priv };
+	const struct qtnf_shm_ipc_int ipc_int =3D { qtnf_ipc_gen_ep_int, ps };
 	const struct qtnf_shm_ipc_rx_callback rx_callback =3D {
-					qtnf_pcie_control_rx_callback, priv };
+					qtnf_pcie_control_rx_callback, ps };
=20
-	ipc_tx_reg =3D &priv->bda->bda_shm_reg1;
-	ipc_rx_reg =3D &priv->bda->bda_shm_reg2;
+	ipc_tx_reg =3D &ps->bda->bda_shm_reg1;
+	ipc_rx_reg =3D &ps->bda->bda_shm_reg2;
=20
-	qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
-			  ipc_tx_reg, priv->workqueue,
+	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+			  ipc_tx_reg, ps->base.workqueue,
 			  &ipc_int, &rx_callback);
-	qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
-			  ipc_rx_reg, priv->workqueue,
+	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+			  ipc_rx_reg, ps->base.workqueue,
 			  &ipc_int, &rx_callback);
=20
 	return 0;
 }
=20
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
 {
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
 }
=20
-static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	int ret =3D -ENOMEM;
=20
 	priv->sysctl_bar =3D qtnf_map_bar(priv, QTN_SYSCTL_BAR);
@@ -387,14 +343,14 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_pea=
rl_state *priv)
 		return ret;
 	}
=20
-	priv->pcie_reg_base =3D priv->dmareg_bar;
-	priv->bda =3D priv->epmem_bar;
-	writel(priv->msi_enabled, &priv->bda->bda_rc_msi_enabled);
+	ps->pcie_reg_base =3D priv->dmareg_bar;
+	ps->bda =3D priv->epmem_bar;
+	writel(priv->msi_enabled, &ps->bda->bda_rc_msi_enabled);
=20
 	return 0;
 }
=20
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
 {
 	struct pci_dev *pdev =3D priv->pdev;
 	struct pci_dev *parent;
@@ -466,7 +422,7 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 sta=
te, u32 delay_in_ms)
 	return 0;
 }
=20
-static int alloc_skb_array(struct qtnf_pcie_pearl_state *priv)
+static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
 {
 	struct sk_buff **vaddr;
 	int len;
@@ -486,8 +442,9 @@ static int alloc_skb_array(struct qtnf_pcie_pearl_state=
 *priv)
 	return 0;
 }
=20
-static int alloc_bd_table(struct qtnf_pcie_pearl_state *priv)
+static int alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	dma_addr_t paddr;
 	void *vaddr;
 	int len;
@@ -503,12 +460,12 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_stat=
e *priv)
=20
 	memset(vaddr, 0, len);
=20
-	priv->bd_table_vaddr =3D vaddr;
-	priv->bd_table_paddr =3D paddr;
-	priv->bd_table_len =3D len;
+	ps->bd_table_vaddr =3D vaddr;
+	ps->bd_table_paddr =3D paddr;
+	ps->bd_table_len =3D len;
=20
-	priv->tx_bd_vbase =3D vaddr;
-	priv->tx_bd_pbase =3D paddr;
+	ps->tx_bd_vbase =3D vaddr;
+	ps->tx_bd_pbase =3D paddr;
=20
 	pr_debug("TX descriptor table: vaddr=3D0x%p paddr=3D%pad\n", vaddr, &padd=
r);
=20
@@ -520,25 +477,26 @@ static int alloc_bd_table(struct qtnf_pcie_pearl_stat=
e *priv)
 	vaddr =3D ((struct qtnf_pearl_tx_bd *)vaddr) + priv->tx_bd_num;
 	paddr +=3D priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
=20
-	priv->rx_bd_vbase =3D vaddr;
-	priv->rx_bd_pbase =3D paddr;
+	ps->rx_bd_vbase =3D vaddr;
+	ps->rx_bd_pbase =3D paddr;
=20
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
-	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_BASE_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_BASE_L(ps->pcie_reg_base));
 	writel(priv->rx_bd_num | (sizeof(struct qtnf_pearl_rx_bd)) << 16,
-	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
+	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(ps->pcie_reg_base));
=20
 	pr_debug("RX descriptor table: vaddr=3D0x%p paddr=3D%pad\n", vaddr, &padd=
r);
=20
 	return 0;
 }
=20
-static int skb2rbd_attach(struct qtnf_pcie_pearl_state *priv, u16 index)
+static int skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
@@ -550,7 +508,7 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_state =
*priv, u16 index)
 	}
=20
 	priv->rx_skb[index] =3D skb;
-	rxbd =3D &priv->rx_bd_vbase[index];
+	rxbd =3D &ps->rx_bd_vbase[index];
=20
 	paddr =3D pci_map_single(priv->pdev, skb->data,
 			       SKB_BUF_SIZE, PCI_DMA_FROMDEVICE);
@@ -571,25 +529,25 @@ static int skb2rbd_attach(struct qtnf_pcie_pearl_stat=
e *priv, u16 index)
=20
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR_H(priv->pcie_reg_base));
+	       PCIE_HDP_HHBM_BUF_PTR_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(paddr),
-	       PCIE_HDP_HHBM_BUF_PTR(priv->pcie_reg_base));
+	       PCIE_HDP_HHBM_BUF_PTR(ps->pcie_reg_base));
=20
-	writel(index, PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
+	writel(index, PCIE_HDP_TX_HOST_Q_WR_PTR(ps->pcie_reg_base));
 	return 0;
 }
=20
-static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *priv)
+static int alloc_rx_buffers(struct qtnf_pcie_pearl_state *ps)
 {
 	u16 i;
 	int ret =3D 0;
=20
-	memset(priv->rx_bd_vbase, 0x0,
-	       priv->rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
+	memset(ps->rx_bd_vbase, 0x0,
+	       ps->base.rx_bd_num * sizeof(struct qtnf_pearl_rx_bd));
=20
-	for (i =3D 0; i < priv->rx_bd_num; i++) {
-		ret =3D skb2rbd_attach(priv, i);
+	for (i =3D 0; i < ps->base.rx_bd_num; i++) {
+		ret =3D skb2rbd_attach(ps, i);
 		if (ret)
 			break;
 	}
@@ -598,8 +556,9 @@ static int alloc_rx_buffers(struct qtnf_pcie_pearl_stat=
e *priv)
 }
=20
 /* all rx/tx activity should have ceased before calling this function */
-static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_free_xfer_buffers(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
 	struct qtnf_pearl_rx_bd *rxbd;
 	struct sk_buff *skb;
@@ -609,7 +568,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pea=
rl_state *priv)
 	/* free rx buffers */
 	for (i =3D 0; i < priv->rx_bd_num; i++) {
 		if (priv->rx_skb && priv->rx_skb[i]) {
-			rxbd =3D &priv->rx_bd_vbase[i];
+			rxbd =3D &ps->rx_bd_vbase[i];
 			skb =3D priv->rx_skb[i];
 			paddr =3D QTN_HOST_ADDR(le32_to_cpu(rxbd->addr_h),
 					      le32_to_cpu(rxbd->addr));
@@ -623,7 +582,7 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_pea=
rl_state *priv)
 	/* free tx buffers */
 	for (i =3D 0; i < priv->tx_bd_num; i++) {
 		if (priv->tx_skb && priv->tx_skb[i]) {
-			txbd =3D &priv->tx_bd_vbase[i];
+			txbd =3D &ps->tx_bd_vbase[i];
 			skb =3D priv->tx_skb[i];
 			paddr =3D QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
@@ -635,26 +594,27 @@ static void qtnf_free_xfer_buffers(struct qtnf_pcie_p=
earl_state *priv)
 	}
 }
=20
-static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_hhbm_init(struct qtnf_pcie_pearl_state *ps)
 {
 	u32 val;
=20
-	val =3D readl(PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	val =3D readl(PCIE_HHBM_CONFIG(ps->pcie_reg_base));
 	val |=3D HHBM_CONFIG_SOFT_RESET;
-	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
+	writel(val, PCIE_HHBM_CONFIG(ps->pcie_reg_base));
 	usleep_range(50, 100);
 	val &=3D ~HHBM_CONFIG_SOFT_RESET;
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	val |=3D HHBM_64BIT;
 #endif
-	writel(val, PCIE_HHBM_CONFIG(priv->pcie_reg_base));
-	writel(priv->rx_bd_num, PCIE_HHBM_Q_LIMIT_REG(priv->pcie_reg_base));
+	writel(val, PCIE_HHBM_CONFIG(ps->pcie_reg_base));
+	writel(ps->base.rx_bd_num, PCIE_HHBM_Q_LIMIT_REG(ps->pcie_reg_base));
=20
 	return 0;
 }
=20
-static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	int ret;
 	u32 val;
=20
@@ -689,7 +649,7 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *priv)
 		return -EINVAL;
 	}
=20
-	ret =3D qtnf_hhbm_init(priv);
+	ret =3D qtnf_hhbm_init(ps);
 	if (ret) {
 		pr_err("failed to init h/w queues\n");
 		return ret;
@@ -701,13 +661,13 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl=
_state *priv)
 		return ret;
 	}
=20
-	ret =3D alloc_bd_table(priv);
+	ret =3D alloc_bd_table(ps);
 	if (ret) {
 		pr_err("failed to allocate bd table\n");
 		return ret;
 	}
=20
-	ret =3D alloc_rx_buffers(priv);
+	ret =3D alloc_rx_buffers(ps);
 	if (ret) {
 		pr_err("failed to allocate rx buffers\n");
 		return ret;
@@ -716,8 +676,9 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_pearl_s=
tate *priv)
 	return ret;
 }
=20
-static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *priv)
+static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct qtnf_pearl_tx_bd *txbd;
 	struct sk_buff *skb;
 	unsigned long flags;
@@ -728,7 +689,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_=
pearl_state *priv)
=20
 	spin_lock_irqsave(&priv->tx_reclaim_lock, flags);
=20
-	tx_done_index =3D readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+	tx_done_index =3D readl(PCIE_HDP_RX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->tx_bd_num - 1);
=20
 	i =3D priv->tx_bd_r_index;
@@ -736,7 +697,7 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pcie_=
pearl_state *priv)
 	while (CIRC_CNT(tx_done_index, i, priv->tx_bd_num)) {
 		skb =3D priv->tx_skb[i];
 		if (likely(skb)) {
-			txbd =3D &priv->tx_bd_vbase[i];
+			txbd =3D &ps->tx_bd_vbase[i];
 			paddr =3D QTN_HOST_ADDR(le32_to_cpu(txbd->addr_h),
 					      le32_to_cpu(txbd->addr));
 			pci_unmap_single(priv->pdev, paddr, skb->len,
@@ -767,11 +728,13 @@ static void qtnf_pcie_data_tx_reclaim(struct qtnf_pci=
e_pearl_state *priv)
 	spin_unlock_irqrestore(&priv->tx_reclaim_lock, flags);
 }
=20
-static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_state *ps)
 {
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
+
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
-		qtnf_pcie_data_tx_reclaim(priv);
+		qtnf_pcie_data_tx_reclaim(ps);
=20
 		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 				priv->tx_bd_num)) {
@@ -786,7 +749,8 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_s=
tate *priv)
=20
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_pearl_tx_bd *txbd;
 	unsigned long flags;
@@ -796,7 +760,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
=20
 	spin_lock_irqsave(&priv->tx_lock, flags);
=20
-	if (!qtnf_tx_queue_ready(priv)) {
+	if (!qtnf_tx_queue_ready(ps)) {
 		if (skb->dev) {
 			netif_tx_stop_all_queues(skb->dev);
 			priv->tx_stopped =3D 1;
@@ -818,7 +782,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 		goto tx_done;
 	}
=20
-	txbd =3D &priv->tx_bd_vbase[i];
+	txbd =3D &ps->tx_bd_vbase[i];
 	txbd->addr =3D cpu_to_le32(QTN_HOST_LO32(skb_paddr));
 	txbd->addr_h =3D cpu_to_le32(QTN_HOST_HI32(skb_paddr));
=20
@@ -829,14 +793,14 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, st=
ruct sk_buff *skb)
 	dma_wmb();
=20
 	/* write new TX descriptor to PCIE_RX_FIFO on EP */
-	txbd_paddr =3D priv->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
+	txbd_paddr =3D ps->tx_bd_pbase + i * sizeof(struct qtnf_pearl_tx_bd);
=20
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	writel(QTN_HOST_HI32(txbd_paddr),
-	       PCIE_HDP_HOST_WR_DESC0_H(priv->pcie_reg_base));
+	       PCIE_HDP_HOST_WR_DESC0_H(ps->pcie_reg_base));
 #endif
 	writel(QTN_HOST_LO32(txbd_paddr),
-	       PCIE_HDP_HOST_WR_DESC0(priv->pcie_reg_base));
+	       PCIE_HDP_HOST_WR_DESC0(ps->pcie_reg_base));
=20
 	if (++i >=3D priv->tx_bd_num)
 		i =3D 0;
@@ -854,14 +818,14 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, st=
ruct sk_buff *skb)
 	priv->tx_done_count++;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
=20
-	qtnf_pcie_data_tx_reclaim(priv);
+	qtnf_pcie_data_tx_reclaim(ps);
=20
 	return NETDEV_TX_OK;
 }
=20
 static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
 	int ret;
=20
 	ret =3D qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
@@ -877,54 +841,55 @@ static int qtnf_pcie_control_tx(struct qtnf_bus *bus,=
 struct sk_buff *skb)
 static irqreturn_t qtnf_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus =3D (struct qtnf_bus *)data;
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	u32 status;
=20
 	priv->pcie_irq_count++;
-	status =3D readl(PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+	status =3D readl(PCIE_HDP_INT_STATUS(ps->pcie_reg_base));
=20
 	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
 	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_out);
=20
-	if (!(status & priv->pcie_irq_mask))
+	if (!(status & ps->pcie_irq_mask))
 		goto irq_done;
=20
 	if (status & PCIE_HDP_INT_RX_BITS)
-		priv->pcie_irq_rx_count++;
+		ps->pcie_irq_rx_count++;
=20
 	if (status & PCIE_HDP_INT_TX_BITS)
-		priv->pcie_irq_tx_count++;
+		ps->pcie_irq_tx_count++;
=20
 	if (status & PCIE_HDP_INT_HHBM_UF)
-		priv->pcie_irq_uf_count++;
+		ps->pcie_irq_uf_count++;
=20
 	if (status & PCIE_HDP_INT_RX_BITS) {
-		qtnf_dis_rxdone_irq(priv);
+		qtnf_dis_rxdone_irq(ps);
 		napi_schedule(&bus->mux_napi);
 	}
=20
 	if (status & PCIE_HDP_INT_TX_BITS) {
-		qtnf_dis_txdone_irq(priv);
+		qtnf_dis_txdone_irq(ps);
 		tasklet_hi_schedule(&priv->reclaim_tq);
 	}
=20
 irq_done:
 	/* H/W workaround: clean all bits, not only enabled */
-	qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(priv->pcie_reg_base));
+	qtnf_non_posted_write(~0U, PCIE_HDP_INT_STATUS(ps->pcie_reg_base));
=20
 	if (!priv->msi_enabled)
-		qtnf_deassert_intx(priv);
+		qtnf_deassert_intx(ps);
=20
 	return IRQ_HANDLED;
 }
=20
-static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *priv)
+static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_state *ps)
 {
-	u16 index =3D priv->rx_bd_r_index;
+	u16 index =3D ps->base.rx_bd_r_index;
 	struct qtnf_pearl_rx_bd *rxbd;
 	u32 descw;
=20
-	rxbd =3D &priv->rx_bd_vbase[index];
+	rxbd =3D &ps->rx_bd_vbase[index];
 	descw =3D le32_to_cpu(rxbd->info);
=20
 	if (descw & QTN_TXDONE_MASK)
@@ -936,7 +901,8 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_st=
ate *priv)
 static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus =3D container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct net_device *ndev =3D NULL;
 	struct sk_buff *skb =3D NULL;
 	int processed =3D 0;
@@ -950,13 +916,11 @@ static int qtnf_rx_poll(struct napi_struct *napi, int=
 budget)
 	int ret;
=20
 	while (processed < budget) {
-
-
-		if (!qtnf_rx_data_ready(priv))
+		if (!qtnf_rx_data_ready(ps))
 			goto rx_out;
=20
 		r_idx =3D priv->rx_bd_r_index;
-		rxbd =3D &priv->rx_bd_vbase[r_idx];
+		rxbd =3D &ps->rx_bd_vbase[r_idx];
 		descw =3D le32_to_cpu(rxbd->info);
=20
 		skb =3D priv->rx_skb[r_idx];
@@ -1018,7 +982,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int =
budget)
 			if (++w_idx >=3D priv->rx_bd_num)
 				w_idx =3D 0;
=20
-			ret =3D skb2rbd_attach(priv, w_idx);
+			ret =3D skb2rbd_attach(ps, w_idx);
 			if (ret) {
 				pr_err("failed to allocate new rx_skb[%d]\n",
 				       w_idx);
@@ -1032,7 +996,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int =
budget)
 rx_out:
 	if (processed < budget) {
 		napi_complete(napi);
-		qtnf_en_rxdone_irq(priv);
+		qtnf_en_rxdone_irq(ps);
 	}
=20
 	return processed;
@@ -1041,25 +1005,25 @@ static int qtnf_rx_poll(struct napi_struct *napi, i=
nt budget)
 static void
 qtnf_pcie_data_tx_timeout(struct qtnf_bus *bus, struct net_device *ndev)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
=20
-	tasklet_hi_schedule(&priv->reclaim_tq);
+	tasklet_hi_schedule(&ps->base.reclaim_tq);
 }
=20
 static void qtnf_pcie_data_rx_start(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
=20
-	qtnf_enable_hdp_irqs(priv);
+	qtnf_enable_hdp_irqs(ps);
 	napi_enable(&bus->mux_napi);
 }
=20
 static void qtnf_pcie_data_rx_stop(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
=20
 	napi_disable(&bus->mux_napi);
-	qtnf_disable_hdp_irqs(priv);
+	qtnf_disable_hdp_irqs(ps);
 }
=20
 static const struct qtnf_bus_ops qtnf_pcie_bus_ops =3D {
@@ -1076,7 +1040,7 @@ static const struct qtnf_bus_ops qtnf_pcie_bus_ops =
=3D {
 static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "%d\n", priv->mps);
=20
@@ -1086,7 +1050,7 @@ static int qtnf_dbg_mps_show(struct seq_file *s, void=
 *data)
 static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "%u\n", priv->msi_enabled);
=20
@@ -1096,20 +1060,20 @@ static int qtnf_dbg_msi_show(struct seq_file *s, vo=
id *data)
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
-	u32 reg =3D readl(PCIE_HDP_INT_EN(priv->pcie_reg_base));
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
+	u32 reg =3D readl(PCIE_HDP_INT_EN(ps->pcie_reg_base));
 	u32 status;
=20
-	seq_printf(s, "pcie_irq_count(%u)\n", priv->pcie_irq_count);
-	seq_printf(s, "pcie_irq_tx_count(%u)\n", priv->pcie_irq_tx_count);
+	seq_printf(s, "pcie_irq_count(%u)\n", ps->base.pcie_irq_count);
+	seq_printf(s, "pcie_irq_tx_count(%u)\n", ps->pcie_irq_tx_count);
 	status =3D reg &  PCIE_HDP_INT_TX_BITS;
 	seq_printf(s, "pcie_irq_tx_status(%s)\n",
 		   (status =3D=3D PCIE_HDP_INT_TX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_rx_count(%u)\n", priv->pcie_irq_rx_count);
+	seq_printf(s, "pcie_irq_rx_count(%u)\n", ps->pcie_irq_rx_count);
 	status =3D reg &  PCIE_HDP_INT_RX_BITS;
 	seq_printf(s, "pcie_irq_rx_status(%s)\n",
 		   (status =3D=3D PCIE_HDP_INT_RX_BITS) ? "EN" : "DIS");
-	seq_printf(s, "pcie_irq_uf_count(%u)\n", priv->pcie_irq_uf_count);
+	seq_printf(s, "pcie_irq_uf_count(%u)\n", ps->pcie_irq_uf_count);
 	status =3D reg &  PCIE_HDP_INT_HHBM_UF;
 	seq_printf(s, "pcie_irq_hhbm_uf_status(%s)\n",
 		   (status =3D=3D PCIE_HDP_INT_HHBM_UF) ? "EN" : "DIS");
@@ -1120,7 +1084,8 @@ static int qtnf_dbg_irq_stats(struct seq_file *s, voi=
d *data)
 static int qtnf_dbg_hdp_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
=20
 	seq_printf(s, "tx_full_count(%u)\n", priv->tx_full_count);
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
@@ -1129,7 +1094,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, voi=
d *data)
=20
 	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
 	seq_printf(s, "tx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_RX0DMA_CNT(priv->pcie_reg_base))
+		   readl(PCIE_HDP_RX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->tx_bd_num - 1));
 	seq_printf(s, "tx_bd_w_index(%u)\n", priv->tx_bd_w_index);
 	seq_printf(s, "tx queue len(%u)\n",
@@ -1138,7 +1103,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, voi=
d *data)
=20
 	seq_printf(s, "rx_bd_r_index(%u)\n", priv->rx_bd_r_index);
 	seq_printf(s, "rx_bd_p_index(%u)\n",
-		   readl(PCIE_HDP_TX0DMA_CNT(priv->pcie_reg_base))
+		   readl(PCIE_HDP_TX0DMA_CNT(ps->pcie_reg_base))
 			& (priv->rx_bd_num - 1));
 	seq_printf(s, "rx_bd_w_index(%u)\n", priv->rx_bd_w_index);
 	seq_printf(s, "rx alloc queue len(%u)\n",
@@ -1151,7 +1116,7 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, voi=
d *data)
 static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_pearl_state *priv =3D get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
=20
 	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
 		   priv->shm_ipc_ep_in.tx_packet_count);
@@ -1165,10 +1130,10 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, v=
oid *data)
 	return 0;
 }
=20
-static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *priv, uint32_t si=
ze,
+static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *ps, uint32_t size=
,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
-	struct pci_dev *pdev =3D priv->pdev;
+	struct pci_dev *pdev =3D ps->base.pdev;
 	struct qtnf_bus *bus =3D pci_get_drvdata(pdev);
=20
 	struct qtnf_pearl_fw_hdr *hdr;
@@ -1214,7 +1179,7 @@ static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_sta=
te *priv, uint32_t size,
 }
=20
 static int
-qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, const u8 *fw, u32 fw_s=
ize)
+qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, const u8 *fw, u32 fw_siz=
e)
 {
 	int blk_size =3D QTN_PCIE_FW_BUFSZ - sizeof(struct qtnf_pearl_fw_hdr);
 	int blk_count =3D fw_size / blk_size + ((fw_size % blk_size) ? 1 : 0);
@@ -1231,25 +1196,25 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv,=
 const u8 *fw, u32 fw_size)
 			return -ETIMEDOUT;
 		}
=20
-		len =3D qtnf_ep_fw_send(priv, fw_size, blk, pblk, fw);
+		len =3D qtnf_ep_fw_send(ps, fw_size, blk, pblk, fw);
 		if (len <=3D 0)
 			continue;
=20
 		if (!((blk + 1) & QTN_PCIE_FW_DLMASK) ||
 		    (blk =3D=3D (blk_count - 1))) {
-			qtnf_set_state(&priv->bda->bda_rc_state,
+			qtnf_set_state(&ps->bda->bda_rc_state,
 				       QTN_RC_FW_SYNC);
-			if (qtnf_poll_state(&priv->bda->bda_ep_state,
+			if (qtnf_poll_state(&ps->bda->bda_ep_state,
 					    QTN_EP_FW_SYNC,
 					    QTN_FW_DL_TIMEOUT_MS)) {
 				pr_err("FW upload failed: SYNC timed out\n");
 				return -ETIMEDOUT;
 			}
=20
-			qtnf_clear_state(&priv->bda->bda_ep_state,
+			qtnf_clear_state(&ps->bda->bda_ep_state,
 					 QTN_EP_FW_SYNC);
=20
-			if (qtnf_is_state(&priv->bda->bda_ep_state,
+			if (qtnf_is_state(&ps->bda->bda_ep_state,
 					  QTN_EP_FW_RETRY)) {
 				if (blk =3D=3D (blk_count - 1)) {
 					int last_round =3D
@@ -1262,14 +1227,14 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv,=
 const u8 *fw, u32 fw_size)
 					pblk -=3D QTN_PCIE_FW_DLMASK * blk_size;
 				}
=20
-				qtnf_clear_state(&priv->bda->bda_ep_state,
+				qtnf_clear_state(&ps->bda->bda_ep_state,
 						 QTN_EP_FW_RETRY);
=20
 				pr_warn("FW upload retry: block #%d\n", blk);
 				continue;
 			}
=20
-			qtnf_pcie_data_tx_reclaim(priv);
+			qtnf_pcie_data_tx_reclaim(ps);
 		}
=20
 		pblk +=3D len;
@@ -1283,8 +1248,8 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *priv, c=
onst u8 *fw, u32 fw_size)
 static void qtnf_fw_work_handler(struct work_struct *work)
 {
 	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
-	struct pci_dev *pdev =3D priv->pdev;
+	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct pci_dev *pdev =3D ps->base.pdev;
 	const struct firmware *fw;
 	int ret;
 	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
@@ -1300,9 +1265,9 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
 		}
 	}
=20
-	qtnf_set_state(&priv->bda->bda_rc_state, state);
+	qtnf_set_state(&ps->bda->bda_rc_state, state);
=20
-	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("card is not ready\n");
=20
@@ -1312,14 +1277,14 @@ static void qtnf_fw_work_handler(struct work_struct=
 *work)
 		goto fw_load_fail;
 	}
=20
-	qtnf_clear_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
+	qtnf_clear_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
=20
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
 	} else {
 		pr_info("starting firmware upload: %s\n", fwname);
=20
-		ret =3D qtnf_ep_fw_load(priv, fw->data, fw->size);
+		ret =3D qtnf_ep_fw_load(ps, fw->data, fw->size);
 		release_firmware(fw);
 		if (ret) {
 			pr_err("firmware upload error\n");
@@ -1327,7 +1292,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
 		}
 	}
=20
-	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_DONE,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_DONE,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("firmware bringup timed out\n");
 		goto fw_load_fail;
@@ -1336,7 +1301,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
 	bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
 	pr_info("firmware is up and running\n");
=20
-	if (qtnf_poll_state(&priv->bda->bda_ep_state,
+	if (qtnf_poll_state(&ps->bda->bda_ep_state,
 			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("firmware runtime failure\n");
 		goto fw_load_fail;
@@ -1367,7 +1332,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
=20
 static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
 	struct pci_dev *pdev =3D priv->pdev;
=20
 	get_device(&pdev->dev);
@@ -1377,56 +1342,56 @@ static void qtnf_bringup_fw_async(struct qtnf_bus *=
bus)
=20
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
 {
-	struct qtnf_pcie_pearl_state *priv =3D (void *)data;
+	struct qtnf_pcie_pearl_state *ps =3D (void *)data;
=20
-	qtnf_pcie_data_tx_reclaim(priv);
-	qtnf_en_txdone_irq(priv);
+	qtnf_pcie_data_tx_reclaim(ps);
+	qtnf_en_txdone_irq(ps);
 }
=20
 static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_i=
d *id)
 {
-	struct qtnf_pcie_pearl_state *pcie_priv;
+	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
 	int ret;
=20
 	bus =3D devm_kzalloc(&pdev->dev,
-			   sizeof(*bus) + sizeof(*pcie_priv), GFP_KERNEL);
+			   sizeof(*bus) + sizeof(*ps), GFP_KERNEL);
 	if (!bus)
 		return -ENOMEM;
=20
-	pcie_priv =3D get_bus_priv(bus);
+	ps =3D get_bus_priv(bus);
=20
 	pci_set_drvdata(pdev, bus);
 	bus->bus_ops =3D &qtnf_pcie_bus_ops;
 	bus->dev =3D &pdev->dev;
 	bus->fw_state =3D QTNF_FW_STATE_RESET;
-	pcie_priv->pdev =3D pdev;
+	ps->base.pdev =3D pdev;
=20
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
-	spin_lock_init(&pcie_priv->tx_lock);
-	spin_lock_init(&pcie_priv->irq_lock);
-	spin_lock_init(&pcie_priv->tx_reclaim_lock);
+	spin_lock_init(&ps->base.tx_lock);
+	spin_lock_init(&ps->irq_lock);
+	spin_lock_init(&ps->base.tx_reclaim_lock);
=20
 	/* init stats */
-	pcie_priv->tx_full_count =3D 0;
-	pcie_priv->tx_done_count =3D 0;
-	pcie_priv->pcie_irq_count =3D 0;
-	pcie_priv->pcie_irq_rx_count =3D 0;
-	pcie_priv->pcie_irq_tx_count =3D 0;
-	pcie_priv->pcie_irq_uf_count =3D 0;
-	pcie_priv->tx_reclaim_done =3D 0;
-	pcie_priv->tx_reclaim_req =3D 0;
-
-	tasklet_init(&pcie_priv->reclaim_tq, qtnf_reclaim_tasklet_fn,
-		     (unsigned long)pcie_priv);
+	ps->base.tx_full_count =3D 0;
+	ps->base.tx_done_count =3D 0;
+	ps->base.pcie_irq_count =3D 0;
+	ps->pcie_irq_rx_count =3D 0;
+	ps->pcie_irq_tx_count =3D 0;
+	ps->pcie_irq_uf_count =3D 0;
+	ps->base.tx_reclaim_done =3D 0;
+	ps->base.tx_reclaim_req =3D 0;
+
+	tasklet_init(&ps->base.reclaim_tq, qtnf_reclaim_tasklet_fn,
+		     (unsigned long)ps);
=20
 	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_rx_poll, 10);
=20
-	pcie_priv->workqueue =3D create_singlethread_workqueue("QTNF_PEARL_PCIE")=
;
-	if (!pcie_priv->workqueue) {
+	ps->base.workqueue =3D create_singlethread_workqueue("QTNF_PEARL_PCIE");
+	if (!ps->base.workqueue) {
 		pr_err("failed to alloc bus workqueue\n");
 		ret =3D -ENODEV;
 		goto err_init;
@@ -1438,7 +1403,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 		goto err_base;
 	}
=20
-	qtnf_tune_pcie_mps(pcie_priv);
+	qtnf_tune_pcie_mps(&ps->base);
=20
 	ret =3D pcim_enable_device(pdev);
 	if (ret) {
@@ -1459,9 +1424,9 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	}
=20
 	pci_set_master(pdev);
-	qtnf_pcie_init_irq(pcie_priv);
+	qtnf_pcie_init_irq(&ps->base);
=20
-	ret =3D qtnf_pcie_init_memory(pcie_priv);
+	ret =3D qtnf_pcie_init_memory(ps);
 	if (ret < 0) {
 		pr_err("PCIE memory init failed\n");
 		goto err_base;
@@ -1469,23 +1434,23 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *id)
=20
 	pci_save_state(pdev);
=20
-	ret =3D qtnf_pcie_init_shm_ipc(pcie_priv);
+	ret =3D qtnf_pcie_init_shm_ipc(ps);
 	if (ret < 0) {
 		pr_err("PCIE SHM IPC init failed\n");
 		goto err_base;
 	}
=20
-	ret =3D qtnf_pcie_init_xfer(pcie_priv);
+	ret =3D qtnf_pcie_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
 		goto err_ipc;
 	}
=20
 	/* init default irq settings */
-	qtnf_init_hdp_irqs(pcie_priv);
+	qtnf_init_hdp_irqs(ps);
=20
 	/* start with disabled irqs */
-	qtnf_disable_hdp_irqs(pcie_priv);
+	qtnf_disable_hdp_irqs(ps);
=20
 	ret =3D devm_request_irq(&pdev->dev, pdev->irq, &qtnf_interrupt, 0,
 			       "qtnf_pcie_irq", (void *)bus);
@@ -1499,18 +1464,18 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *id)
 	return 0;
=20
 err_xfer:
-	qtnf_free_xfer_buffers(pcie_priv);
+	qtnf_free_xfer_buffers(ps);
=20
 err_ipc:
-	qtnf_pcie_free_shm_ipc(pcie_priv);
+	qtnf_pcie_free_shm_ipc(&ps->base);
=20
 err_base:
-	flush_workqueue(pcie_priv->workqueue);
-	destroy_workqueue(pcie_priv->workqueue);
-	netif_napi_del(&bus->mux_napi);
+	flush_workqueue(ps->base.workqueue);
+	destroy_workqueue(ps->base.workqueue);
=20
 err_init:
-	tasklet_kill(&pcie_priv->reclaim_tq);
+	tasklet_kill(&ps->base.reclaim_tq);
+	netif_napi_del(&bus->mux_napi);
 	pci_set_drvdata(pdev, NULL);
=20
 	return ret;
@@ -1518,7 +1483,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
=20
 static void qtnf_pcie_remove(struct pci_dev *pdev)
 {
-	struct qtnf_pcie_pearl_state *priv;
+	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
=20
 	bus =3D pci_get_drvdata(pdev);
@@ -1531,18 +1496,16 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
 		qtnf_core_detach(bus);
=20
-	priv =3D get_bus_priv(bus);
-
+	ps =3D get_bus_priv(bus);
+	qtnf_reset_card(ps);
 	netif_napi_del(&bus->mux_napi);
-	flush_workqueue(priv->workqueue);
-	destroy_workqueue(priv->workqueue);
-	tasklet_kill(&priv->reclaim_tq);
+	flush_workqueue(ps->base.workqueue);
+	destroy_workqueue(ps->base.workqueue);
+	tasklet_kill(&ps->base.reclaim_tq);
=20
-	qtnf_free_xfer_buffers(priv);
+	qtnf_free_xfer_buffers(ps);
+	qtnf_pcie_free_shm_ipc(&ps->base);
 	qtnf_debugfs_remove(bus);
-
-	qtnf_pcie_free_shm_ipc(priv);
-	qtnf_reset_card(priv);
 }
=20
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index af528b8..b87505d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -43,11 +43,6 @@
 #define QTN_RC_FW_LOADRDY	BIT(8)
 #define QTN_RC_FW_SYNC		BIT(9)
=20
-/* state transition timeouts */
-#define QTN_FW_DL_TIMEOUT_MS	3000
-#define QTN_FW_QLINK_TIMEOUT_MS	30000
-#define QTN_EP_RESET_WAIT_MS	1000
-
 #define PCIE_HDP_INT_RX_BITS (0		\
 	| PCIE_HDP_INT_EP_TXDMA		\
 	| PCIE_HDP_INT_EP_TXEMPTY	\
@@ -77,8 +72,6 @@
 #define PCIE_BDA_NAMELEN		32
 #define PCIE_HHBM_MAX_SIZE		2048
=20
-#define SKB_BUF_SIZE		2048
-
 #define QTN_PCIE_BOARDFLG	"PCIEQTN"
 #define QTN_PCIE_FW_DLMASK	0xF
 #define QTN_PCIE_FW_BUFSZ	2048
--=20
2.9.5

