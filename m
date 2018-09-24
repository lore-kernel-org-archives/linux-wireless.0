Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13641C46470
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEDB821480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Zfeeag1R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEDB821480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbeIXLOO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:14 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727430AbeIXLON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMHeLQJDeDZ2ObAlgBxaGqK7v2ybTDSAkT2yhtwlSyw=;
 b=Zfeeag1R/LF/hL3pQ7kGfli8BZnUFCT6v6mF1P2kqx42SPMmDA84l8I453D7JIglnNlgn91BNKoDUSHfFt8SmtucdtZAq9jwalUD3MRmFuzVNh7tQNoSgSC9giugci9Yiwfi30FaQD08DRAwXjdQ5sVRGYUcrsJqZY+uQRKAhaA=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:32 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:32 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 09/11] qtnfmac_pcie: extract platform-independent PCIe code
Thread-Topic: [PATCH 09/11] qtnfmac_pcie: extract platform-independent PCIe
 code
Thread-Index: AQHUU8VWxhWuaR0KGkeAJBG98M2EcQ==
Date:   Mon, 24 Sep 2018 05:13:31 +0000
Message-ID: <20180924051246.13371-10-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:2y+8vFTy5UGXyaY/hHrKGWOW3Uc+PiTOZ69MJqCWVJ6o0HQQgyQOTOL/zDulnDBea0PNfqEM/EJ+95Lw7A1vrCACWncFoYbK6r6LeNvpYW1tg7uEocQ4+z3ls1kHZqfzejy9CeQV8hlvgNj+PYyVDBtK0tQohwH3MnLD2ssbWhQb8/jETDSjnRoGEl3Iw+aYk6LvI7ygFvoPWLuFARd0zn8MYmEl1P9Uomqbj9xMDYFBkCh90mEiYThcmZvFqP+LSdpCfr1FCtmjusBVLmVpncQNmnT4QCsL5ztuHmSM/cZ3+dyvwKL25q+AVx5jTGQ3OiOAXKJSqN0ABs/bmfuSKlV91RwroOO+ZWdhP+fK5VVMaM6fx11cEn5TGMjnaroNAxZIjZil6m0XgakIrdG6cRIj2A9lEDednnXbNFUYdcJCX6VCVOyD05ZM8G9l0jOGUWgnoDrNwHZhzjuSfJuRBw==;5:G6rOvzEzf2nYKQukc4VZwJIpTcm1peY3fA8CBnq22DhiuDk1vPeogAks30C6vIzwRqz3vTjqmYtJjOnQOaV4LnWUPQQIogpHst+/5gpxJJq4KQF8bB5WUanKQkvbE8mNyEkbyRdGUmWVyPCUIznGINFo7lRqxUFvK+NGfHctngw=;7:owqZSPhBV0D8yXAjd9oE31PyzE+rL8QwwKrmB3mZ2ubS/71w9cIna9ly1xOpe631pIytyo7XOvaCnpTLTit19VaHrIhz9JPfQEqrU4dJl5wx8luaSh6oOWWGGgMdVEp+I6kMf0//h8cZa14cYQl+jEqtA2ydZCS44m36KPUYvnnqEtAzZ9gAe37kXAN2P6hAi7rzgi0whafSvfunMsvpHdcZGTUGGkK4CHby2m6d0cUF/6C9OK0errPHQrAne/iF
x-ms-office365-filtering-correlation-id: 0751d90b-64fb-4e4a-3518-08d621dc7856
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB29755AED6CC88D91308AA526B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(1496009)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(575784001)(81166006)(52116002)(16200700003)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(53946003)(3846002)(256004)(76176011)(5024004)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001)(2004002)(959014)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: wx2PgF5S8TMdM+9j8WDOi6K3o+CxwPUEVbuYk+2+y/iqj1x4neqXTnl4O7lE9je40WL77+O2lhQ9o0ZSyayDozEdF6xJTf94q0zdIbKKzub1+UVPqbgluOK8vGILMVGF8fYhF6W7byzebj816J7ehx37F+UqsXUtl3EbaC8UrFGwqk/QBzk49jHH9ybq/OZAsuVcZ+7Hu1jY5jzB+Nol2vaym9a3IdZxZwlnSaThBjRzbhnf2Yu77KrCUQ7+QxAUZILcTZtSk0TVDYD00uWD5afDDus5QibMp15bX8B7nCPnEnLsbYgg6R9rudaFwltiwsJzcqqwhcaLYdwmM643CWhkGPMM6l+Uu3ipGCIk0ig=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0751d90b-64fb-4e4a-3518-08d621dc7856
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:31.9254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051331.dowvPIzDjHbZ6C9k1bCjG3wRkXOnOwRCFYSt463Effc@z>

Extract platform-independent PCIe driver code into a separate file, and
use it from platform-specific modules.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |   1 +
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 406 +++++++++++++++++=
+++
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  15 +
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 425 +++--------------=
----
 .../quantenna/qtnfmac/pcie/pearl_pcie_ipc.h        |   4 -
 5 files changed, 468 insertions(+), 383 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/=
wireless/quantenna/qtnfmac/Makefile
index 9eeddea..17cd7ad 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_QTNFMAC_PEARL_PCIE) +=3D qtnfmac_pearl_pcie.=
o
=20
 qtnfmac_pearl_pcie-objs +=3D \
 	shm_ipc.o \
+	pcie/pcie.o \
 	pcie/pearl_pcie.o
=20
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
new file mode 100644
index 0000000..ab42d11
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -0,0 +1,406 @@
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
+#include <linux/printk.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/seq_file.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+
+#include "pcie_priv.h"
+#include "bus.h"
+#include "shm_ipc.h"
+#include "core.h"
+#include "debug.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"qtnf_pcie: %s: " fmt, __func__
+
+#define QTN_SYSCTL_BAR	0
+#define QTN_SHMEM_BAR	2
+#define QTN_DMA_BAR	3
+
+int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
+{
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	int ret;
+
+	ret =3D qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
+
+	if (ret =3D=3D -ETIMEDOUT) {
+		pr_err("EP firmware is dead\n");
+		bus->fw_state =3D QTNF_FW_STATE_EP_DEAD;
+	}
+
+	return ret;
+}
+
+int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
+{
+	struct sk_buff **vaddr;
+	int len;
+
+	len =3D priv->tx_bd_num * sizeof(*priv->tx_skb) +
+		priv->rx_bd_num * sizeof(*priv->rx_skb);
+	vaddr =3D devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
+
+	if (!vaddr)
+		return -ENOMEM;
+
+	priv->tx_skb =3D vaddr;
+
+	vaddr +=3D priv->tx_bd_num;
+	priv->rx_skb =3D vaddr;
+
+	return 0;
+}
+
+void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D priv->pdev;
+
+	get_device(&pdev->dev);
+	schedule_work(&bus->fw_work);
+}
+
+static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+
+	seq_printf(s, "%d\n", priv->mps);
+
+	return 0;
+}
+
+static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+
+	seq_printf(s, "%u\n", priv->msi_enabled);
+
+	return 0;
+}
+
+static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
+{
+	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+
+	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.tx_packet_count);
+	seq_printf(s, "shm_ipc_ep_in.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_in.rx_packet_count);
+	seq_printf(s, "shm_ipc_ep_out.tx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.tx_timeout_count);
+	seq_printf(s, "shm_ipc_ep_out.rx_packet_count(%zu)\n",
+		   priv->shm_ipc_ep_out.rx_packet_count);
+
+	return 0;
+}
+
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
+			    const char *drv_name)
+{
+	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D priv->pdev;
+	int ret;
+
+	if (boot_success) {
+		bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
+
+		ret =3D qtnf_core_attach(bus);
+		if (ret) {
+			pr_err("failed to attach core\n");
+			boot_success =3D false;
+		}
+	}
+
+	if (boot_success) {
+		qtnf_debugfs_init(bus, drv_name);
+		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
+		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
+		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
+	} else {
+		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
+	}
+
+	complete(&bus->firmware_init_complete);
+	put_device(&pdev->dev);
+}
+
+static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+{
+	struct pci_dev *pdev =3D priv->pdev;
+	struct pci_dev *parent;
+	int mps_p, mps_o, mps_m, mps;
+	int ret;
+
+	/* current mps */
+	mps_o =3D pcie_get_mps(pdev);
+
+	/* maximum supported mps */
+	mps_m =3D 128 << pdev->pcie_mpss;
+
+	/* suggested new mps value */
+	mps =3D mps_m;
+
+	if (pdev->bus && pdev->bus->self) {
+		/* parent (bus) mps */
+		parent =3D pdev->bus->self;
+
+		if (pci_is_pcie(parent)) {
+			mps_p =3D pcie_get_mps(parent);
+			mps =3D min(mps_m, mps_p);
+		}
+	}
+
+	ret =3D pcie_set_mps(pdev, mps);
+	if (ret) {
+		pr_err("failed to set mps to %d, keep using current %d\n",
+		       mps, mps_o);
+		priv->mps =3D mps_o;
+		return;
+	}
+
+	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
+	priv->mps =3D mps;
+}
+
+static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv, bool use_m=
si)
+{
+	struct pci_dev *pdev =3D priv->pdev;
+
+	/* fall back to legacy INTx interrupts by default */
+	priv->msi_enabled =3D 0;
+
+	/* check if MSI capability is available */
+	if (use_msi) {
+		if (!pci_enable_msi(pdev)) {
+			pr_debug("enabled MSI interrupt\n");
+			priv->msi_enabled =3D 1;
+		} else {
+			pr_warn("failed to enable MSI interrupts");
+		}
+	}
+
+	if (!priv->msi_enabled) {
+		pr_warn("legacy PCIE interrupts enabled\n");
+		pci_intx(pdev, 1);
+	}
+}
+
+static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 inde=
x)
+{
+	void __iomem *vaddr;
+	dma_addr_t busaddr;
+	size_t len;
+	int ret;
+
+	ret =3D pcim_iomap_regions(priv->pdev, 1 << index, "qtnfmac_pcie");
+	if (ret)
+		return IOMEM_ERR_PTR(ret);
+
+	busaddr =3D pci_resource_start(priv->pdev, index);
+	len =3D pci_resource_len(priv->pdev, index);
+	vaddr =3D pcim_iomap_table(priv->pdev)[index];
+	if (!vaddr)
+		return IOMEM_ERR_PTR(-ENOMEM);
+
+	pr_debug("BAR%u vaddr=3D0x%p busaddr=3D%pad len=3D%u\n",
+		 index, vaddr, &busaddr, (int)len);
+
+	return vaddr;
+}
+
+static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
+{
+	int ret =3D -ENOMEM;
+
+	priv->sysctl_bar =3D qtnf_map_bar(priv, QTN_SYSCTL_BAR);
+	if (IS_ERR(priv->sysctl_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
+		return ret;
+	}
+
+	priv->dmareg_bar =3D qtnf_map_bar(priv, QTN_DMA_BAR);
+	if (IS_ERR(priv->dmareg_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
+		return ret;
+	}
+
+	priv->epmem_bar =3D qtnf_map_bar(priv, QTN_SHMEM_BAR);
+	if (IS_ERR(priv->epmem_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t=
 len)
+{
+	struct qtnf_pcie_bus_priv *priv =3D arg;
+	struct qtnf_bus *bus =3D pci_get_drvdata(priv->pdev);
+	struct sk_buff *skb;
+
+	if (unlikely(len =3D=3D 0)) {
+		pr_warn("zero length packet received\n");
+		return;
+	}
+
+	skb =3D __dev_alloc_skb(len, GFP_KERNEL);
+
+	if (unlikely(!skb)) {
+		pr_err("failed to allocate skb\n");
+		return;
+	}
+
+	skb_put_data(skb, buf, len);
+
+	qtnf_trans_handle_rx_ctl_packet(bus, skb);
+}
+
+void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
+			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
+			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
+			    const struct qtnf_shm_ipc_int *ipc_int)
+{
+	const struct qtnf_shm_ipc_rx_callback rx_callback =3D {
+					qtnf_pcie_control_rx_callback, priv };
+
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
+			  ipc_tx_reg, priv->workqueue,
+			  ipc_int, &rx_callback);
+	qtnf_shm_ipc_init(&priv->shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
+			  ipc_rx_reg, priv->workqueue,
+			  ipc_int, &rx_callback);
+}
+
+int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
+		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
+		    bool use_msi)
+{
+	struct qtnf_pcie_bus_priv *pcie_priv;
+	struct qtnf_bus *bus;
+	int ret;
+
+	bus =3D devm_kzalloc(&pdev->dev,
+			   sizeof(*bus) + priv_size, GFP_KERNEL);
+	if (!bus)
+		return -ENOMEM;
+
+	pcie_priv =3D get_bus_priv(bus);
+
+	pci_set_drvdata(pdev, bus);
+	bus->bus_ops =3D bus_ops;
+	bus->dev =3D &pdev->dev;
+	bus->fw_state =3D QTNF_FW_STATE_RESET;
+	pcie_priv->pdev =3D pdev;
+	pcie_priv->tx_stopped =3D 0;
+
+	init_completion(&bus->firmware_init_complete);
+	mutex_init(&bus->bus_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
+	spin_lock_init(&pcie_priv->tx_reclaim_lock);
+
+	pcie_priv->tx_full_count =3D 0;
+	pcie_priv->tx_done_count =3D 0;
+	pcie_priv->pcie_irq_count =3D 0;
+	pcie_priv->tx_reclaim_done =3D 0;
+	pcie_priv->tx_reclaim_req =3D 0;
+
+	pcie_priv->workqueue =3D create_singlethread_workqueue("QTNF_PCIE");
+	if (!pcie_priv->workqueue) {
+		pr_err("failed to alloc bus workqueue\n");
+		ret =3D -ENODEV;
+		goto err_init;
+	}
+
+	init_dummy_netdev(&bus->mux_dev);
+
+	if (!pci_is_pcie(pdev)) {
+		pr_err("device %s is not PCI Express\n", pci_name(pdev));
+		ret =3D -EIO;
+		goto err_base;
+	}
+
+	qtnf_tune_pcie_mps(pcie_priv);
+
+	ret =3D pcim_enable_device(pdev);
+	if (ret) {
+		pr_err("failed to init PCI device %x\n", pdev->device);
+		goto err_base;
+	} else {
+		pr_debug("successful init of PCI device %x\n", pdev->device);
+	}
+
+	ret =3D dma_set_mask_and_coherent(&pdev->dev, dma_mask);
+	if (ret) {
+		pr_err("PCIE DMA coherent mask init failed\n");
+		goto err_base;
+	}
+
+	pci_set_master(pdev);
+	qtnf_pcie_init_irq(pcie_priv, use_msi);
+
+	ret =3D qtnf_pcie_init_memory(pcie_priv);
+	if (ret < 0) {
+		pr_err("PCIE memory init failed\n");
+		goto err_base;
+	}
+
+	pci_save_state(pdev);
+
+	return 0;
+
+err_base:
+	flush_workqueue(pcie_priv->workqueue);
+	destroy_workqueue(pcie_priv->workqueue);
+err_init:
+	pci_set_drvdata(pdev, NULL);
+
+	return ret;
+}
+
+static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
+{
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
+	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
+}
+
+void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v)
+{
+	wait_for_completion(&bus->firmware_init_complete);
+
+	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
+	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
+		qtnf_core_detach(bus);
+
+	netif_napi_del(&bus->mux_napi);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+	tasklet_kill(&priv->reclaim_tq);
+
+	qtnf_pcie_free_shm_ipc(priv);
+	qtnf_debugfs_remove(bus);
+	pci_set_drvdata(priv->pdev, NULL);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index 1ad5eb8..d3b52f0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
=20
 #include "shm_ipc.h"
+#include "bus.h"
=20
 #define SKB_BUF_SIZE		2048
=20
@@ -72,6 +73,20 @@ struct qtnf_pcie_bus_priv {
 	u8 tx_stopped;
 };
=20
+int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb);
+int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv);
+void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus);
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
+			    const char *drv_name);
+void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
+			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
+			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
+			    const struct qtnf_shm_ipc_int *ipc_int);
+int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
+		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
+		    bool use_msi);
+void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v);
+
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
 	writel(val, basereg);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index f3655de..424e367 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -193,29 +193,6 @@ static inline void qtnf_dis_txdone_irq(struct qtnf_pci=
e_pearl_state *ps)
 	spin_unlock_irqrestore(&ps->irq_lock, flags);
 }
=20
-static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv)
-{
-	struct pci_dev *pdev =3D priv->pdev;
-
-	/* fall back to legacy INTx interrupts by default */
-	priv->msi_enabled =3D 0;
-
-	/* check if MSI capability is available */
-	if (use_msi) {
-		if (!pci_enable_msi(pdev)) {
-			pr_debug("MSI interrupt enabled\n");
-			priv->msi_enabled =3D 1;
-		} else {
-			pr_warn("failed to enable MSI interrupts");
-		}
-	}
-
-	if (!priv->msi_enabled) {
-		pr_warn("legacy PCIE interrupts enabled\n");
-		pci_intx(pdev, 1);
-	}
-}
-
 static void qtnf_deassert_intx(struct qtnf_pcie_pearl_state *ps)
 {
 	void __iomem *reg =3D ps->base.sysctl_bar + PEARL_PCIE_CFG0_OFFSET;
@@ -247,148 +224,6 @@ static void qtnf_pcie_pearl_ipc_gen_ep_int(void *arg)
 	qtnf_non_posted_write(data, reg);
 }
=20
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 inde=
x)
-{
-	void __iomem *vaddr;
-	dma_addr_t busaddr;
-	size_t len;
-	int ret;
-
-	ret =3D pcim_iomap_regions(priv->pdev, 1 << index, DRV_NAME);
-	if (ret)
-		return IOMEM_ERR_PTR(ret);
-
-	busaddr =3D pci_resource_start(priv->pdev, index);
-	len =3D pci_resource_len(priv->pdev, index);
-	vaddr =3D pcim_iomap_table(priv->pdev)[index];
-	if (!vaddr)
-		return IOMEM_ERR_PTR(-ENOMEM);
-
-	pr_debug("BAR%u vaddr=3D0x%p busaddr=3D%pad len=3D%u\n",
-		 index, vaddr, &busaddr, (int)len);
-
-	return vaddr;
-}
-
-static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t=
 len)
-{
-	struct qtnf_pcie_bus_priv *priv =3D arg;
-	struct qtnf_bus *bus =3D pci_get_drvdata(priv->pdev);
-	struct sk_buff *skb;
-
-	if (unlikely(len =3D=3D 0)) {
-		pr_warn("zero length packet received\n");
-		return;
-	}
-
-	skb =3D __dev_alloc_skb(len, GFP_KERNEL);
-
-	if (unlikely(!skb)) {
-		pr_err("failed to allocate skb\n");
-		return;
-	}
-
-	skb_put_data(skb, buf, len);
-
-	qtnf_trans_handle_rx_ctl_packet(bus, skb);
-}
-
-static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_pearl_state *ps)
-{
-	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
-	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
-	const struct qtnf_shm_ipc_int ipc_int =3D
-					{ qtnf_pcie_pearl_ipc_gen_ep_int, ps };
-	const struct qtnf_shm_ipc_rx_callback rx_callback =3D {
-					qtnf_pcie_control_rx_callback, ps };
-
-	ipc_tx_reg =3D &ps->bda->bda_shm_reg1;
-	ipc_rx_reg =3D &ps->bda->bda_shm_reg2;
-
-	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_in, QTNF_SHM_IPC_OUTBOUND,
-			  ipc_tx_reg, ps->base.workqueue,
-			  &ipc_int, &rx_callback);
-	qtnf_shm_ipc_init(&ps->base.shm_ipc_ep_out, QTNF_SHM_IPC_INBOUND,
-			  ipc_rx_reg, ps->base.workqueue,
-			  &ipc_int, &rx_callback);
-
-	return 0;
-}
-
-static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
-{
-	qtnf_shm_ipc_free(&priv->shm_ipc_ep_in);
-	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
-}
-
-static int qtnf_pcie_init_memory(struct qtnf_pcie_pearl_state *ps)
-{
-	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
-	int ret =3D -ENOMEM;
-
-	priv->sysctl_bar =3D qtnf_map_bar(priv, QTN_SYSCTL_BAR);
-	if (IS_ERR(priv->sysctl_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
-		return ret;
-	}
-
-	priv->dmareg_bar =3D qtnf_map_bar(priv, QTN_DMA_BAR);
-	if (IS_ERR(priv->dmareg_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
-		return ret;
-	}
-
-	priv->epmem_bar =3D qtnf_map_bar(priv, QTN_SHMEM_BAR);
-	if (IS_ERR(priv->epmem_bar)) {
-		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
-		return ret;
-	}
-
-	ps->pcie_reg_base =3D priv->dmareg_bar;
-	ps->bda =3D priv->epmem_bar;
-	writel(priv->msi_enabled, &ps->bda->bda_rc_msi_enabled);
-
-	return 0;
-}
-
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
-{
-	struct pci_dev *pdev =3D priv->pdev;
-	struct pci_dev *parent;
-	int mps_p, mps_o, mps_m, mps;
-	int ret;
-
-	/* current mps */
-	mps_o =3D pcie_get_mps(pdev);
-
-	/* maximum supported mps */
-	mps_m =3D 128 << pdev->pcie_mpss;
-
-	/* suggested new mps value */
-	mps =3D mps_m;
-
-	if (pdev->bus && pdev->bus->self) {
-		/* parent (bus) mps */
-		parent =3D pdev->bus->self;
-
-		if (pci_is_pcie(parent)) {
-			mps_p =3D pcie_get_mps(parent);
-			mps =3D min(mps_m, mps_p);
-		}
-	}
-
-	ret =3D pcie_set_mps(pdev, mps);
-	if (ret) {
-		pr_err("failed to set mps to %d, keep using current %d\n",
-		       mps, mps_o);
-		priv->mps =3D mps_o;
-		return;
-	}
-
-	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
-	priv->mps =3D mps;
-}
-
 static int qtnf_is_state(__le32 __iomem *reg, u32 state)
 {
 	u32 s =3D readl(reg);
@@ -423,26 +258,6 @@ static int qtnf_poll_state(__le32 __iomem *reg, u32 st=
ate, u32 delay_in_ms)
 	return 0;
 }
=20
-static int alloc_skb_array(struct qtnf_pcie_bus_priv *priv)
-{
-	struct sk_buff **vaddr;
-	int len;
-
-	len =3D priv->tx_bd_num * sizeof(*priv->tx_skb) +
-		priv->rx_bd_num * sizeof(*priv->rx_skb);
-	vaddr =3D devm_kzalloc(&priv->pdev->dev, len, GFP_KERNEL);
-
-	if (!vaddr)
-		return -ENOMEM;
-
-	priv->tx_skb =3D vaddr;
-
-	vaddr +=3D priv->tx_bd_num;
-	priv->rx_skb =3D vaddr;
-
-	return 0;
-}
-
 static int pearl_alloc_bd_table(struct qtnf_pcie_pearl_state *ps)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
@@ -656,7 +471,7 @@ static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_p=
earl_state *ps)
 		return ret;
 	}
=20
-	ret =3D alloc_skb_array(priv);
+	ret =3D qtnf_pcie_alloc_skb_array(priv);
 	if (ret) {
 		pr_err("failed to allocate skb array\n");
 		return ret;
@@ -750,7 +565,7 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_pearl_s=
tate *ps)
=20
 static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
-	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	dma_addr_t txbd_paddr, skb_paddr;
 	struct qtnf_pearl_tx_bd *txbd;
@@ -824,25 +639,10 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, st=
ruct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
=20
-static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
-{
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
-	int ret;
-
-	ret =3D qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
-
-	if (ret =3D=3D -ETIMEDOUT) {
-		pr_err("EP firmware is dead\n");
-		bus->fw_state =3D QTNF_FW_STATE_EP_DEAD;
-	}
-
-	return ret;
-}
-
 static irqreturn_t qtnf_pcie_pearl_interrupt(int irq, void *data)
 {
 	struct qtnf_bus *bus =3D (struct qtnf_bus *)data;
-	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	u32 status;
=20
@@ -902,7 +702,7 @@ static int qtnf_rx_data_ready(struct qtnf_pcie_pearl_st=
ate *ps)
 static int qtnf_pcie_pearl_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct qtnf_bus *bus =3D container_of(napi, struct qtnf_bus, mux_napi);
-	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	struct net_device *ndev =3D NULL;
 	struct sk_buff *skb =3D NULL;
@@ -1038,26 +838,6 @@ static const struct qtnf_bus_ops qtnf_pcie_pearl_bus_=
ops =3D {
 	.data_rx_stop		=3D qtnf_pcie_data_rx_stop,
 };
=20
-static int qtnf_dbg_mps_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
-
-	seq_printf(s, "%d\n", priv->mps);
-
-	return 0;
-}
-
-static int qtnf_dbg_msi_show(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
-
-	seq_printf(s, "%u\n", priv->msi_enabled);
-
-	return 0;
-}
-
 static int qtnf_dbg_irq_stats(struct seq_file *s, void *data)
 {
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
@@ -1114,27 +894,9 @@ static int qtnf_dbg_hdp_stats(struct seq_file *s, voi=
d *data)
 	return 0;
 }
=20
-static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
-{
-	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
-
-	seq_printf(s, "shm_ipc_ep_in.tx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_in.tx_packet_count);
-	seq_printf(s, "shm_ipc_ep_in.rx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_in.rx_packet_count);
-	seq_printf(s, "shm_ipc_ep_out.tx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_out.tx_timeout_count);
-	seq_printf(s, "shm_ipc_ep_out.rx_packet_count(%zu)\n",
-		   priv->shm_ipc_ep_out.rx_packet_count);
-
-	return 0;
-}
-
-static int qtnf_ep_fw_send(struct qtnf_pcie_pearl_state *ps, uint32_t size=
,
+static int qtnf_ep_fw_send(struct pci_dev *pdev, uint32_t size,
 			   int blk, const u8 *pblk, const u8 *fw)
 {
-	struct pci_dev *pdev =3D ps->base.pdev;
 	struct qtnf_bus *bus =3D pci_get_drvdata(pdev);
=20
 	struct qtnf_pearl_fw_hdr *hdr;
@@ -1197,7 +959,7 @@ qtnf_ep_fw_load(struct qtnf_pcie_pearl_state *ps, cons=
t u8 *fw, u32 fw_size)
 			return -ETIMEDOUT;
 		}
=20
-		len =3D qtnf_ep_fw_send(ps, fw_size, blk, pblk, fw);
+		len =3D qtnf_ep_fw_send(ps->base.pdev, fw_size, blk, pblk, fw);
 		if (len <=3D 0)
 			continue;
=20
@@ -1255,6 +1017,7 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
 	int ret;
 	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
 	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
+	bool fw_boot_success =3D false;
=20
 	if (flashboot) {
 		state |=3D QTN_RC_FW_FLASHBOOT;
@@ -1262,7 +1025,7 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
 		ret =3D request_firmware(&fw, fwname, &pdev->dev);
 		if (ret < 0) {
 			pr_err("failed to get firmware %s\n", fwname);
-			goto fw_load_fail;
+			goto fw_load_exit;
 		}
 	}
=20
@@ -1275,13 +1038,14 @@ static void qtnf_pearl_fw_work_handler(struct work_=
struct *work)
 		if (!flashboot)
 			release_firmware(fw);
=20
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
=20
 	qtnf_clear_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
=20
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
+
 	} else {
 		pr_info("starting firmware upload: %s\n", fwname);
=20
@@ -1289,56 +1053,33 @@ static void qtnf_pearl_fw_work_handler(struct work_=
struct *work)
 		release_firmware(fw);
 		if (ret) {
 			pr_err("firmware upload error\n");
-			goto fw_load_fail;
+			goto fw_load_exit;
 		}
 	}
=20
 	if (qtnf_poll_state(&ps->bda->bda_ep_state, QTN_EP_FW_DONE,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("firmware bringup timed out\n");
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
=20
-	bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
 	pr_info("firmware is up and running\n");
=20
 	if (qtnf_poll_state(&ps->bda->bda_ep_state,
 			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("firmware runtime failure\n");
-		goto fw_load_fail;
-	}
-
-	ret =3D qtnf_core_attach(bus);
-	if (ret) {
-		pr_err("failed to attach core\n");
-		goto fw_load_fail;
+		goto fw_load_exit;
 	}
=20
-	qtnf_debugfs_init(bus, DRV_NAME);
-	qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
-	qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
-	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
-	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
-	qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
-
-	goto fw_load_exit;
-
-fw_load_fail:
-	bus->fw_state =3D QTNF_FW_STATE_DETACHED;
+	fw_boot_success =3D true;
=20
 fw_load_exit:
-	complete(&bus->firmware_init_complete);
-	put_device(&pdev->dev);
-}
+	qtnf_pcie_fw_boot_done(bus, fw_boot_success, DRV_NAME);
=20
-static void qtnf_bringup_fw_async(struct qtnf_bus *bus)
-{
-	struct qtnf_pcie_bus_priv *priv =3D (void *)get_bus_priv(bus);
-	struct pci_dev *pdev =3D priv->pdev;
-
-	get_device(&pdev->dev);
-	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
-	schedule_work(&bus->fw_work);
+	if (fw_boot_success) {
+		qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
+		qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+	}
 }
=20
 static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
@@ -1351,100 +1092,47 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned=
 long data)
=20
 static int qtnf_pcie_pearl_probe(struct pci_dev *pdev, const struct pci_de=
vice_id *id)
 {
+	struct qtnf_shm_ipc_int ipc_int;
 	struct qtnf_pcie_pearl_state *ps;
 	struct qtnf_bus *bus;
 	int ret;
+	u64 dma_mask;
=20
-	bus =3D devm_kzalloc(&pdev->dev,
-			   sizeof(*bus) + sizeof(*ps), GFP_KERNEL);
-	if (!bus)
-		return -ENOMEM;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	dma_mask =3D DMA_BIT_MASK(64);
+#else
+	dma_mask =3D DMA_BIT_MASK(32);
+#endif
=20
-	ps =3D get_bus_priv(bus);
+	ret =3D qtnf_pcie_probe(pdev, sizeof(*ps), &qtnf_pcie_pearl_bus_ops,
+			      dma_mask, use_msi);
+	if (ret)
+		return ret;
=20
-	pci_set_drvdata(pdev, bus);
-	bus->bus_ops =3D &qtnf_pcie_pearl_bus_ops;
-	bus->dev =3D &pdev->dev;
-	bus->fw_state =3D QTNF_FW_STATE_RESET;
-	ps->base.pdev =3D pdev;
+	bus =3D pci_get_drvdata(pdev);
+	ps =3D get_bus_priv(bus);
=20
-	init_completion(&bus->firmware_init_complete);
-	mutex_init(&bus->bus_lock);
-	spin_lock_init(&ps->base.tx_lock);
 	spin_lock_init(&ps->irq_lock);
-	spin_lock_init(&ps->base.tx_reclaim_lock);
-
-	/* init stats */
-	ps->base.tx_full_count =3D 0;
-	ps->base.tx_done_count =3D 0;
-	ps->base.pcie_irq_count =3D 0;
-	ps->pcie_irq_rx_count =3D 0;
-	ps->pcie_irq_tx_count =3D 0;
-	ps->pcie_irq_uf_count =3D 0;
-	ps->base.tx_reclaim_done =3D 0;
-	ps->base.tx_reclaim_req =3D 0;
=20
 	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
 		     (unsigned long)ps);
-
-	init_dummy_netdev(&bus->mux_dev);
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_pcie_pearl_rx_poll, 10);
+	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
=20
-	ps->base.workqueue =3D create_singlethread_workqueue("QTNF_PEARL_PCIE");
-	if (!ps->base.workqueue) {
-		pr_err("failed to alloc bus workqueue\n");
-		ret =3D -ENODEV;
-		goto err_init;
-	}
-
-	if (!pci_is_pcie(pdev)) {
-		pr_err("device %s is not PCI Express\n", pci_name(pdev));
-		ret =3D -EIO;
-		goto err_base;
-	}
-
-	qtnf_tune_pcie_mps(&ps->base);
-
-	ret =3D pcim_enable_device(pdev);
-	if (ret) {
-		pr_err("failed to init PCI device %x\n", pdev->device);
-		goto err_base;
-	} else {
-		pr_debug("successful init of PCI device %x\n", pdev->device);
-	}
-
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-#else
-	ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-#endif
-	if (ret) {
-		pr_err("PCIE DMA coherent mask init failed\n");
-		goto err_base;
-	}
-
-	pci_set_master(pdev);
-	qtnf_pcie_init_irq(&ps->base);
-
-	ret =3D qtnf_pcie_init_memory(ps);
-	if (ret < 0) {
-		pr_err("PCIE memory init failed\n");
-		goto err_base;
-	}
-
-	pci_save_state(pdev);
+	ps->pcie_reg_base =3D ps->base.dmareg_bar;
+	ps->bda =3D ps->base.epmem_bar;
+	writel(ps->base.msi_enabled, &ps->bda->bda_rc_msi_enabled);
=20
-	ret =3D qtnf_pcie_init_shm_ipc(ps);
-	if (ret < 0) {
-		pr_err("PCIE SHM IPC init failed\n");
-		goto err_base;
-	}
+	ipc_int.fn =3D qtnf_pcie_pearl_ipc_gen_ep_int;
+	ipc_int.arg =3D ps;
+	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
+			       &ps->bda->bda_shm_reg2, &ipc_int);
=20
 	ret =3D qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
-		goto err_ipc;
+		goto error;
 	}
=20
 	/* init default irq settings */
@@ -1461,24 +1149,14 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pd=
ev, const struct pci_device_i
 		goto err_xfer;
 	}
=20
-	qtnf_bringup_fw_async(bus);
+	qtnf_pcie_bringup_fw_async(bus);
=20
 	return 0;
=20
 err_xfer:
 	qtnf_pearl_free_xfer_buffers(ps);
-
-err_ipc:
-	qtnf_pcie_free_shm_ipc(&ps->base);
-
-err_base:
-	flush_workqueue(ps->base.workqueue);
-	destroy_workqueue(ps->base.workqueue);
-
-err_init:
-	tasklet_kill(&ps->base.reclaim_tq);
-	netif_napi_del(&bus->mux_napi);
-	pci_set_drvdata(pdev, NULL);
+error:
+	qtnf_pcie_remove(bus, &ps->base);
=20
 	return ret;
 }
@@ -1492,22 +1170,11 @@ static void qtnf_pcie_pearl_remove(struct pci_dev *=
pdev)
 	if (!bus)
 		return;
=20
-	wait_for_completion(&bus->firmware_init_complete);
-
-	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
-	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
-		qtnf_core_detach(bus);
-
 	ps =3D get_bus_priv(bus);
-	qtnf_pearl_reset_ep(ps);
-	netif_napi_del(&bus->mux_napi);
-	flush_workqueue(ps->base.workqueue);
-	destroy_workqueue(ps->base.workqueue);
-	tasklet_kill(&ps->base.reclaim_tq);
=20
+	qtnf_pcie_remove(bus, &ps->base);
+	qtnf_pearl_reset_ep(ps);
 	qtnf_pearl_free_xfer_buffers(ps);
-	qtnf_pcie_free_shm_ipc(&ps->base);
-	qtnf_debugfs_remove(bus);
 }
=20
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
index b87505d..f21e97e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
@@ -63,10 +63,6 @@
 #define QTN_HOST_ADDR(h, l)	((u32)l)
 #endif
=20
-#define QTN_SYSCTL_BAR	0
-#define QTN_SHMEM_BAR	2
-#define QTN_DMA_BAR	3
-
 #define QTN_PCIE_BDA_VERSION		0x1002
=20
 #define PCIE_BDA_NAMELEN		32
--=20
2.9.5

