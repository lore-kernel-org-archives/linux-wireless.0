Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4ABC169D4
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123542083C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ElBsMDxt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 123542083C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbeJPSNo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:13:44 -0400
Received: from mail-sn1nam02on0067.outbound.protection.outlook.com ([104.47.36.67]:10160
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbeJPSNo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 14:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBhi/yAE+MQVdijwELKi5MFn9BNECG9j3Et0Bqtq3FE=;
 b=ElBsMDxt+zc8AjMGSr8GD8ZkWofqsyvhrXvoiX6Jm0GFyJazAqvhRnrXyuEnASz0iFwo7GrL+T4Rl0M8Ew3IslSweLnkWLgeP0WfLkQ+bCBFkbGbhJhJ+nxqbhpNaNTnrn5VvgxAaj7Tcj8E9meQkRBVd8MTVDdpQ2D6jd3xGao=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5379.namprd05.prod.outlook.com (10.167.233.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.18; Tue, 16 Oct 2018 10:23:56 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.020; Tue, 16 Oct 2018
 10:23:56 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH v2 1/2] qtnfmac_pcie: use single PCIe driver for all platforms
Thread-Topic: [PATCH v2 1/2] qtnfmac_pcie: use single PCIe driver for all
 platforms
Thread-Index: AQHUZTpYXfV+DyGIAEOmAzA3Iux74w==
Date:   Tue, 16 Oct 2018 10:23:56 +0000
Message-ID: <20181016102349.26544-2-sergey.matyukevich.os@quantenna.com>
References: <20181016102349.26544-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181016102349.26544-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0037.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::14) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5379;6:EnZ4pMjk3HYgL6FUNNbLSwZi2St9xveWBYS3bTnltuX4t9bTh6qror5dFCJztk2kNQdmbcHZXy3qs30Dlba2tO2eZ7b+1bj05mTx1c/AAQSH+cUsCApeBvuqf0tLgnKGxujEZ5qHB4dthSoLplUpuZDyAmLya2C+4FJI2YRQbq2XFLWhHoZHie1lWbMI5m2S2v5zz3CLrZ155GW8ZONphk6mhQxp7Vm5phqyZMZxA7123f/HXfBh1nXMr3EEmaQq+rh1VFmBNy19ivnPI2bVmB4B8YJzNTUe724OTTqJRcWllG1C143vjc8r478Vcg+ox+fI3/RlXy4s5OpuHQolDS91INrs98jnpI5O5H3gVjDYed2IBnBwpB6Cyh8cbBJaj9vc6Us99JTtXNCWa76vB2ppVLTs5/0ggD27TUmdVjeMCQ95MGRBMWfZKHlfDc/ApADmMxPxLklgjF1l8xHpkg==;5:FYP6FKfZlzFq0Uxn1KSGKpbHqlEAT8H2J4ClqwJWqBymsRHTMIz3Lq7Cmo1vIymrYQAGqI6qdlKgIDLBcHZ0F80UC6TJTuwgEVlGDVUPPqDHjiTKhYS1yGgok64PbOMGvJmiIKcsexkl8z2/Gfgx1uNeq4ip391ROxdsXhCMUaA=;7:yX4oIA8K8pcud2LBgIuyIOeRWO3JXXcBmWYrxrKcCGeWBdkeIdUGp/e5q3qT+zBZ0QYhi0czbqHqERyMxTSumZEEq0bk1oh2tM/3yw4HlDgBz9nyUCN5BArGAmB7+VcYp//24GLa9qoG2GLjdkq8CU1X/UcSBwfiWY1mKxLsjzjrzBd+TXQh4hlt8pf8157AkBh5G3bYR+Aej4rHn8qHl5/fVpyelvG2Tq/1xodPR3DXE+A6F7LumFa659+0+hbl
x-ms-office365-filtering-correlation-id: 45498049-9686-430b-d515-08d633517ab2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5379;
x-ms-traffictypediagnostic: BL0PR05MB5379:
x-microsoft-antispam-prvs: <BL0PR05MB5379696BA32750B149FE46A8A3FE0@BL0PR05MB5379.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5379;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5379;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39850400004)(396003)(189003)(199004)(53936002)(68736007)(1076002)(52116002)(3846002)(478600001)(6116002)(86362001)(53946003)(305945005)(107886003)(14444005)(25786009)(54906003)(36756003)(99286004)(4744004)(71190400001)(6486002)(71200400001)(6436002)(5640700003)(6512007)(575784001)(4326008)(7736002)(11346002)(81166006)(2900100001)(103116003)(26005)(8676002)(186003)(476003)(102836004)(81156014)(8936002)(2616005)(446003)(2906002)(386003)(486006)(14454004)(316002)(66066001)(76176011)(2501003)(6916009)(97736004)(105586002)(6506007)(106356001)(5660300001)(256004)(5250100002)(2351001)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5379;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vP1gGjGNIfguZKFYASQNmqPR/fO0dqifmmKHSEKWAM50lxVaN8J9ROQsxzKYOQybM0iL5N5431Z6+tA8NQwXkS0TbLq3FjIa8/bkEh1SVZ3+OMKSHAyZT+8/FtXgDDBYL2pPvKKqeqCaIWQfK2Yz3UDufaQ9lcMpdpX21sDpWdc9YDLJpL7CIcc8X7jJ5zMrGfcTKv/DxJ8HGj1r9/788tXJbX53Kl9nvRGBUqyQu0U8Dd3hNpdINPvfU0w5Miuq0oh0M6v294iW5JMDHPRrqgyXfWEHvlk/vPcQUjDZ9GgcfmYOiqIaBNNuNdqcSRmEwAggbHDzDeKAcxIJqn+buCULWw4KDayrCROLvyLpTCE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45498049-9686-430b-d515-08d633517ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 10:23:56.7474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5379
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Single PCIe driver can identify hardware type by reading CHIP ID at
probe time and invoking a correct initialization sequence.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Kconfig     |  10 +-
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 279 ++++++++++++++---=
----
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  19 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 211 +++++-----------
 drivers/net/wireless/quantenna/qtnfmac/util.c      |  16 ++
 drivers/net/wireless/quantenna/qtnfmac/util.h      |   2 +
 7 files changed, 292 insertions(+), 251 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Kconfig b/drivers/net/w=
ireless/quantenna/qtnfmac/Kconfig
index b8c12a5f16b4..696c50066b53 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Kconfig
+++ b/drivers/net/wireless/quantenna/qtnfmac/Kconfig
@@ -1,10 +1,10 @@
 config QTNFMAC
 	tristate
-	depends on QTNFMAC_PEARL_PCIE
-	default m if QTNFMAC_PEARL_PCIE=3Dm
-	default y if QTNFMAC_PEARL_PCIE=3Dy
+	depends on QTNFMAC_PCIE
+	default m if QTNFMAC_PCIE=3Dm
+	default y if QTNFMAC_PCIE=3Dy
=20
-config QTNFMAC_PEARL_PCIE
+config QTNFMAC_PCIE
 	tristate "Quantenna QSR10g PCIe support"
 	default n
 	depends on PCI && CFG80211
@@ -16,4 +16,4 @@ config QTNFMAC_PEARL_PCIE
 	  802.11ac QSR10g (aka Pearl) FullMAC chipset running over PCIe.
=20
 	  If you choose to build it as a module, two modules will be built:
-	  qtnfmac.ko and qtnfmac_pearl_pcie.ko.
+	  qtnfmac.ko and qtnfmac_pcie.ko.
diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/=
wireless/quantenna/qtnfmac/Makefile
index 17cd7adb4109..d7e8185fddab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -19,11 +19,11 @@ qtnfmac-objs +=3D \
=20
 #
=20
-obj-$(CONFIG_QTNFMAC_PEARL_PCIE) +=3D qtnfmac_pearl_pcie.o
+obj-$(CONFIG_QTNFMAC_PCIE) +=3D qtnfmac_pcie.o
=20
-qtnfmac_pearl_pcie-objs +=3D \
+qtnfmac_pcie-objs +=3D \
 	shm_ipc.o \
 	pcie/pcie.o \
 	pcie/pearl_pcie.o
=20
-qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
+qtnfmac_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index 16795dbe475b..70dd8da5b0dc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 /* Copyright (c) 2018 Quantenna Communications, Inc. All rights reserved. =
*/
=20
+#include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
@@ -15,14 +16,37 @@
 #include "shm_ipc.h"
 #include "core.h"
 #include "debug.h"
-
-#undef pr_fmt
-#define pr_fmt(fmt)	"qtnf_pcie: %s: " fmt, __func__
+#include "util.h"
+#include "qtn_hw_ids.h"
=20
 #define QTN_SYSCTL_BAR	0
 #define QTN_SHMEM_BAR	2
 #define QTN_DMA_BAR	3
=20
+#define QTN_PCIE_MAX_FW_BUFSZ		(1 * 1024 * 1024)
+
+static bool use_msi =3D true;
+module_param(use_msi, bool, 0644);
+MODULE_PARM_DESC(use_msi, "set 0 to use legacy interrupt");
+
+static unsigned int tx_bd_size_param;
+module_param(tx_bd_size_param, uint, 0644);
+MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size");
+
+static unsigned int rx_bd_size_param =3D 256;
+module_param(rx_bd_size_param, uint, 0644);
+MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size");
+
+static u8 flashboot =3D 1;
+module_param(flashboot, byte, 0644);
+MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
+
+static unsigned int fw_blksize_param =3D QTN_PCIE_MAX_FW_BUFSZ;
+module_param(fw_blksize_param, uint, 0644);
+MODULE_PARM_DESC(fw_blksize_param, "firmware loading block size in bytes")=
;
+
+#define DRV_NAME	"qtnfmac_pcie"
+
 int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
 	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
@@ -58,7 +82,7 @@ int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *=
priv)
 	return 0;
 }
=20
-void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus)
+static void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus)
 {
 	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
 	struct pci_dev *pdev =3D priv->pdev;
@@ -72,7 +96,7 @@ static int qtnf_dbg_mps_show(struct seq_file *s, void *da=
ta)
 	struct qtnf_bus *bus =3D dev_get_drvdata(s->private);
 	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
=20
-	seq_printf(s, "%d\n", priv->mps);
+	seq_printf(s, "%d\n", pcie_get_mps(priv->pdev));
=20
 	return 0;
 }
@@ -104,8 +128,7 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void =
*data)
 	return 0;
 }
=20
-void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
-			    const char *drv_name)
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success)
 {
 	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
 	struct pci_dev *pdev =3D priv->pdev;
@@ -122,7 +145,7 @@ void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool =
boot_success,
 	}
=20
 	if (boot_success) {
-		qtnf_debugfs_init(bus, drv_name);
+		qtnf_debugfs_init(bus, DRV_NAME);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
 		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
 		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
@@ -133,9 +156,8 @@ void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool =
boot_success,
 	put_device(&pdev->dev);
 }
=20
-static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_priv *priv)
+static void qtnf_tune_pcie_mps(struct pci_dev *pdev)
 {
-	struct pci_dev *pdev =3D priv->pdev;
 	struct pci_dev *parent;
 	int mps_p, mps_o, mps_m, mps;
 	int ret;
@@ -163,12 +185,10 @@ static void qtnf_tune_pcie_mps(struct qtnf_pcie_bus_p=
riv *priv)
 	if (ret) {
 		pr_err("failed to set mps to %d, keep using current %d\n",
 		       mps, mps_o);
-		priv->mps =3D mps_o;
 		return;
 	}
=20
 	pr_debug("set mps to %d (was %d, max %d)\n", mps, mps_o, mps_m);
-	priv->mps =3D mps;
 }
=20
 static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv, bool use_m=
si)
@@ -194,20 +214,20 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_p=
riv *priv, bool use_msi)
 	}
 }
=20
-static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus_priv *priv, u8 inde=
x)
+static void __iomem *qtnf_map_bar(struct pci_dev *pdev, u8 index)
 {
 	void __iomem *vaddr;
 	dma_addr_t busaddr;
 	size_t len;
 	int ret;
=20
-	ret =3D pcim_iomap_regions(priv->pdev, 1 << index, "qtnfmac_pcie");
+	ret =3D pcim_iomap_regions(pdev, 1 << index, "qtnfmac_pcie");
 	if (ret)
 		return IOMEM_ERR_PTR(ret);
=20
-	busaddr =3D pci_resource_start(priv->pdev, index);
-	len =3D pci_resource_len(priv->pdev, index);
-	vaddr =3D pcim_iomap_table(priv->pdev)[index];
+	busaddr =3D pci_resource_start(pdev, index);
+	len =3D pci_resource_len(pdev, index);
+	vaddr =3D pcim_iomap_table(pdev)[index];
 	if (!vaddr)
 		return IOMEM_ERR_PTR(-ENOMEM);
=20
@@ -217,31 +237,6 @@ static void __iomem *qtnf_map_bar(struct qtnf_pcie_bus=
_priv *priv, u8 index)
 	return vaddr;
 }
=20
-static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_priv *priv)
-{
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
-	return 0;
-}
-
 static void qtnf_pcie_control_rx_callback(void *arg, const u8 __iomem *buf=
,
 					  size_t len)
 {
@@ -282,27 +277,80 @@ void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv=
 *priv,
 			  ipc_int, &rx_callback);
 }
=20
-int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
-		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
-		    bool use_msi)
+static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_i=
d *id)
 {
 	struct qtnf_pcie_bus_priv *pcie_priv;
 	struct qtnf_bus *bus;
+	void __iomem *sysctl_bar;
+	void __iomem *epmem_bar;
+	void __iomem *dmareg_bar;
+	unsigned int chipid;
 	int ret;
=20
-	bus =3D devm_kzalloc(&pdev->dev,
-			   sizeof(*bus) + priv_size, GFP_KERNEL);
+	if (!pci_is_pcie(pdev)) {
+		pr_err("device %s is not PCI Express\n", pci_name(pdev));
+		return -EIO;
+	}
+
+	qtnf_tune_pcie_mps(pdev);
+
+	ret =3D pcim_enable_device(pdev);
+	if (ret) {
+		pr_err("failed to init PCI device %x\n", pdev->device);
+		return ret;
+	}
+
+	pci_set_master(pdev);
+
+	sysctl_bar =3D qtnf_map_bar(pdev, QTN_SYSCTL_BAR);
+	if (IS_ERR(sysctl_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
+		return ret;
+	}
+
+	dmareg_bar =3D qtnf_map_bar(pdev, QTN_DMA_BAR);
+	if (IS_ERR(dmareg_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
+		return ret;
+	}
+
+	epmem_bar =3D qtnf_map_bar(pdev, QTN_SHMEM_BAR);
+	if (IS_ERR(epmem_bar)) {
+		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
+		return ret;
+	}
+
+	chipid =3D qtnf_chip_id_get(sysctl_bar);
+
+	pr_info("identified device: %s\n", qtnf_chipid_to_string(chipid));
+
+	switch (chipid) {
+	case QTN_CHIP_ID_PEARL:
+	case QTN_CHIP_ID_PEARL_B:
+	case QTN_CHIP_ID_PEARL_C:
+		bus =3D qtnf_pcie_pearl_alloc(pdev);
+		break;
+	default:
+		pr_err("unsupported chip ID 0x%x\n", chipid);
+		return -ENOTSUPP;
+	}
+
 	if (!bus)
 		return -ENOMEM;
=20
 	pcie_priv =3D get_bus_priv(bus);
-
 	pci_set_drvdata(pdev, bus);
-	bus->bus_ops =3D bus_ops;
 	bus->dev =3D &pdev->dev;
 	bus->fw_state =3D QTNF_FW_STATE_RESET;
 	pcie_priv->pdev =3D pdev;
 	pcie_priv->tx_stopped =3D 0;
+	pcie_priv->rx_bd_num =3D rx_bd_size_param;
+	pcie_priv->flashboot =3D flashboot;
+
+	if (fw_blksize_param > QTN_PCIE_MAX_FW_BUFSZ)
+		pcie_priv->fw_blksize =3D  QTN_PCIE_MAX_FW_BUFSZ;
+	else
+		pcie_priv->fw_blksize =3D fw_blksize_param;
=20
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx_lock);
@@ -317,53 +365,35 @@ int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv=
_size,
 	pcie_priv->workqueue =3D create_singlethread_workqueue("QTNF_PCIE");
 	if (!pcie_priv->workqueue) {
 		pr_err("failed to alloc bus workqueue\n");
-		ret =3D -ENODEV;
-		goto err_init;
-	}
-
-	init_dummy_netdev(&bus->mux_dev);
-
-	if (!pci_is_pcie(pdev)) {
-		pr_err("device %s is not PCI Express\n", pci_name(pdev));
-		ret =3D -EIO;
-		goto err_base;
+		return -ENODEV;
 	}
=20
-	qtnf_tune_pcie_mps(pcie_priv);
-
-	ret =3D pcim_enable_device(pdev);
+	ret =3D dma_set_mask_and_coherent(&pdev->dev,
+					pcie_priv->dma_mask_get_cb());
 	if (ret) {
-		pr_err("failed to init PCI device %x\n", pdev->device);
-		goto err_base;
-	} else {
-		pr_debug("successful init of PCI device %x\n", pdev->device);
+		pr_err("PCIE DMA coherent mask init failed 0x%llx\n",
+		       pcie_priv->dma_mask_get_cb());
+		goto error;
 	}
=20
-	ret =3D dma_set_mask_and_coherent(&pdev->dev, dma_mask);
-	if (ret) {
-		pr_err("PCIE DMA coherent mask init failed\n");
-		goto err_base;
-	}
-
-	pci_set_master(pdev);
+	init_dummy_netdev(&bus->mux_dev);
 	qtnf_pcie_init_irq(pcie_priv, use_msi);
-
-	ret =3D qtnf_pcie_init_memory(pcie_priv);
-	if (ret < 0) {
-		pr_err("PCIE memory init failed\n");
-		goto err_base;
-	}
-
+	pcie_priv->sysctl_bar =3D sysctl_bar;
+	pcie_priv->dmareg_bar =3D dmareg_bar;
+	pcie_priv->epmem_bar =3D epmem_bar;
 	pci_save_state(pdev);
=20
+	ret =3D pcie_priv->probe_cb(bus, tx_bd_size_param);
+	if (ret)
+		goto error;
+
+	qtnf_pcie_bringup_fw_async(bus);
 	return 0;
=20
-err_base:
+error:
 	flush_workqueue(pcie_priv->workqueue);
 	destroy_workqueue(pcie_priv->workqueue);
-err_init:
 	pci_set_drvdata(pdev, NULL);
-
 	return ret;
 }
=20
@@ -373,8 +403,17 @@ static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bu=
s_priv *priv)
 	qtnf_shm_ipc_free(&priv->shm_ipc_ep_out);
 }
=20
-void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v)
+static void qtnf_pcie_remove(struct pci_dev *dev)
 {
+	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_bus *bus;
+
+	bus =3D pci_get_drvdata(dev);
+	if (!bus)
+		return;
+
+	priv =3D get_bus_priv(bus);
+
 	cancel_work_sync(&bus->fw_work);
=20
 	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
@@ -388,5 +427,77 @@ void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtn=
f_pcie_bus_priv *priv)
=20
 	qtnf_pcie_free_shm_ipc(priv);
 	qtnf_debugfs_remove(bus);
+	priv->remove_cb(bus);
 	pci_set_drvdata(priv->pdev, NULL);
 }
+
+#ifdef CONFIG_PM_SLEEP
+static int qtnf_pcie_suspend(struct device *dev)
+{
+	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_bus *bus;
+
+	bus =3D pci_get_drvdata(to_pci_dev(dev));
+	if (!bus)
+		return -EFAULT;
+
+	priv =3D get_bus_priv(bus);
+	return priv->suspend_cb(bus);
+}
+
+static int qtnf_pcie_resume(struct device *dev)
+{
+	struct qtnf_pcie_bus_priv *priv;
+	struct qtnf_bus *bus;
+
+	bus =3D pci_get_drvdata(to_pci_dev(dev));
+	if (!bus)
+		return -EFAULT;
+
+	priv =3D get_bus_priv(bus);
+	return priv->resume_cb(bus);
+}
+
+/* Power Management Hooks */
+static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
+			 qtnf_pcie_resume);
+#endif
+
+static const struct pci_device_id qtnf_pcie_devid_table[] =3D {
+	{
+		PCIE_VENDOR_ID_QUANTENNA, PCIE_DEVICE_ID_QTN_PEARL,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
+
+static struct pci_driver qtnf_pcie_drv_data =3D {
+	.name =3D DRV_NAME,
+	.id_table =3D qtnf_pcie_devid_table,
+	.probe =3D qtnf_pcie_probe,
+	.remove =3D qtnf_pcie_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver =3D {
+		.pm =3D &qtnf_pcie_pm_ops,
+	},
+#endif
+};
+
+static int __init qtnf_pcie_register(void)
+{
+	return pci_register_driver(&qtnf_pcie_drv_data);
+}
+
+static void __exit qtnf_pcie_exit(void)
+{
+	pci_unregister_driver(&qtnf_pcie_drv_data);
+}
+
+module_init(qtnf_pcie_register);
+module_exit(qtnf_pcie_exit);
+
+MODULE_AUTHOR("Quantenna Communications");
+MODULE_DESCRIPTION("Quantenna PCIe bus driver for 802.11 wireless LAN.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index 5c70fb4c0f92..7c742c56efaf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -23,9 +23,14 @@
 struct qtnf_pcie_bus_priv {
 	struct pci_dev *pdev;
=20
+	int (*probe_cb)(struct qtnf_bus *bus, unsigned int tx_bd_size);
+	void (*remove_cb)(struct qtnf_bus *bus);
+	int (*suspend_cb)(struct qtnf_bus *bus);
+	int (*resume_cb)(struct qtnf_bus *bus);
+	u64 (*dma_mask_get_cb)(void);
+
 	spinlock_t tx_reclaim_lock;
 	spinlock_t tx_lock;
-	int mps;
=20
 	struct workqueue_struct *workqueue;
 	struct tasklet_struct reclaim_tq;
@@ -43,6 +48,8 @@ struct qtnf_pcie_bus_priv {
 	struct sk_buff **tx_skb;
 	struct sk_buff **rx_skb;
=20
+	unsigned int fw_blksize;
+
 	u32 rx_bd_w_index;
 	u32 rx_bd_r_index;
=20
@@ -58,21 +65,17 @@ struct qtnf_pcie_bus_priv {
=20
 	u8 msi_enabled;
 	u8 tx_stopped;
+	bool flashboot;
 };
=20
 int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb);
 int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv);
-void qtnf_pcie_bringup_fw_async(struct qtnf_bus *bus);
-void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
-			    const char *drv_name);
+void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success);
 void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
 			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
 			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
 			    const struct qtnf_shm_ipc_int *ipc_int);
-int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
-		    const struct qtnf_bus_ops *bus_ops, u64 dma_mask,
-		    bool use_msi);
-void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v);
+struct qtnf_bus *qtnf_pcie_pearl_alloc(struct pci_dev *pdev);
=20
 static inline void qtnf_non_posted_write(u32 val, void __iomem *basereg)
 {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 95c7b95c6f8a..1f5facbb8905 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -2,7 +2,6 @@
 /* Copyright (c) 2018 Quantenna Communications */
=20
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
@@ -24,23 +23,7 @@
 #include "shm_ipc.h"
 #include "debug.h"
=20
-static bool use_msi =3D true;
-module_param(use_msi, bool, 0644);
-MODULE_PARM_DESC(use_msi, "set 0 to use legacy interrupt");
-
-static unsigned int tx_bd_size_param =3D 32;
-module_param(tx_bd_size_param, uint, 0644);
-MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size, power of tw=
o");
-
-static unsigned int rx_bd_size_param =3D 256;
-module_param(rx_bd_size_param, uint, 0644);
-MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size, power of tw=
o");
-
-static u8 flashboot =3D 1;
-module_param(flashboot, byte, 0644);
-MODULE_PARM_DESC(flashboot, "set to 0 to use FW binary file on FS");
-
-#define DRV_NAME	"qtnfmac_pearl_pcie"
+#define PEARL_TX_BD_SIZE_DEFAULT	32
=20
 struct qtnf_pearl_bda {
 	__le16 bda_len;
@@ -415,30 +398,28 @@ static int pearl_hhbm_init(struct qtnf_pcie_pearl_sta=
te *ps)
 	return 0;
 }
=20
-static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_pearl_state *ps)
+static int qtnf_pcie_pearl_init_xfer(struct qtnf_pcie_pearl_state *ps,
+				     unsigned int tx_bd_size)
 {
 	struct qtnf_pcie_bus_priv *priv =3D &ps->base;
 	int ret;
 	u32 val;
=20
-	priv->tx_bd_num =3D tx_bd_size_param;
-	priv->rx_bd_num =3D rx_bd_size_param;
-	priv->rx_bd_w_index =3D 0;
-	priv->rx_bd_r_index =3D 0;
+	if (tx_bd_size =3D=3D 0)
+		tx_bd_size =3D PEARL_TX_BD_SIZE_DEFAULT;
=20
-	if (!priv->tx_bd_num || !is_power_of_2(priv->tx_bd_num)) {
-		pr_err("tx_bd_size_param %u is not power of two\n",
-		       priv->tx_bd_num);
-		return -EINVAL;
-	}
+	val =3D tx_bd_size * sizeof(struct qtnf_pearl_tx_bd);
=20
-	val =3D priv->tx_bd_num * sizeof(struct qtnf_pearl_tx_bd);
-	if (val > PCIE_HHBM_MAX_SIZE) {
-		pr_err("tx_bd_size_param %u is too large\n",
-		       priv->tx_bd_num);
-		return -EINVAL;
+	if (!is_power_of_2(tx_bd_size) || val > PCIE_HHBM_MAX_SIZE) {
+		pr_warn("bad tx_bd_size value %u\n", tx_bd_size);
+		priv->tx_bd_num =3D PEARL_TX_BD_SIZE_DEFAULT;
+	} else {
+		priv->tx_bd_num =3D tx_bd_size;
 	}
=20
+	priv->rx_bd_w_index =3D 0;
+	priv->rx_bd_r_index =3D 0;
+
 	if (!priv->rx_bd_num || !is_power_of_2(priv->rx_bd_num)) {
 		pr_err("rx_bd_size_param %u is not power of two\n",
 		       priv->rx_bd_num);
@@ -1006,7 +987,7 @@ static void qtnf_pearl_fw_work_handler(struct work_str=
uct *work)
 	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
 	bool fw_boot_success =3D false;
=20
-	if (flashboot) {
+	if (ps->base.flashboot) {
 		state |=3D QTN_RC_FW_FLASHBOOT;
 	} else {
 		ret =3D request_firmware(&fw, fwname, &pdev->dev);
@@ -1022,7 +1003,7 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("card is not ready\n");
=20
-		if (!flashboot)
+		if (!ps->base.flashboot)
 			release_firmware(fw);
=20
 		goto fw_load_exit;
@@ -1030,7 +1011,7 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
=20
 	qtnf_clear_state(&ps->bda->bda_ep_state, QTN_EP_FW_LOADRDY);
=20
-	if (flashboot) {
+	if (ps->base.flashboot) {
 		pr_info("booting firmware from flash\n");
=20
 	} else {
@@ -1061,7 +1042,7 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
 	fw_boot_success =3D true;
=20
 fw_load_exit:
-	qtnf_pcie_fw_boot_done(bus, fw_boot_success, DRV_NAME);
+	qtnf_pcie_fw_boot_done(bus, fw_boot_success);
=20
 	if (fw_boot_success) {
 		qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
@@ -1077,74 +1058,34 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned =
long data)
 	qtnf_en_txdone_irq(ps);
 }
=20
-static int qtnf_pearl_check_chip_id(struct qtnf_pcie_pearl_state *ps)
+static u64 qtnf_pearl_dma_mask_get(void)
 {
-	unsigned int chipid;
-
-	chipid =3D qtnf_chip_id_get(ps->base.sysctl_bar);
-
-	switch (chipid) {
-	case QTN_CHIP_ID_PEARL:
-	case QTN_CHIP_ID_PEARL_B:
-	case QTN_CHIP_ID_PEARL_C:
-		pr_info("chip ID is 0x%x\n", chipid);
-		break;
-	default:
-		pr_err("incorrect chip ID 0x%x\n", chipid);
-		return -ENODEV;
-	}
-
-	return 0;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	return DMA_BIT_MASK(64);
+#else
+	return DMA_BIT_MASK(32);
+#endif
 }
=20
-static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
-				 const struct pci_device_id *id)
+static int qtnf_pcie_pearl_probe(struct qtnf_bus *bus, unsigned int tx_bd_=
size)
 {
 	struct qtnf_shm_ipc_int ipc_int;
-	struct qtnf_pcie_pearl_state *ps;
-	struct qtnf_bus *bus;
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
+	struct pci_dev *pdev =3D ps->base.pdev;
 	int ret;
-	u64 dma_mask;
-
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	dma_mask =3D DMA_BIT_MASK(64);
-#else
-	dma_mask =3D DMA_BIT_MASK(32);
-#endif
-
-	ret =3D qtnf_pcie_probe(pdev, sizeof(*ps), &qtnf_pcie_pearl_bus_ops,
-			      dma_mask, use_msi);
-	if (ret)
-		return ret;
-
-	bus =3D pci_get_drvdata(pdev);
-	ps =3D get_bus_priv(bus);
=20
+	bus->bus_ops =3D &qtnf_pcie_pearl_bus_ops;
 	spin_lock_init(&ps->irq_lock);
-
-	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
-		     (unsigned long)ps);
-	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
-		       qtnf_pcie_pearl_rx_poll, 10);
 	INIT_WORK(&bus->fw_work, qtnf_pearl_fw_work_handler);
=20
 	ps->pcie_reg_base =3D ps->base.dmareg_bar;
 	ps->bda =3D ps->base.epmem_bar;
 	writel(ps->base.msi_enabled, &ps->bda->bda_rc_msi_enabled);
=20
-	ipc_int.fn =3D qtnf_pcie_pearl_ipc_gen_ep_int;
-	ipc_int.arg =3D ps;
-	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
-			       &ps->bda->bda_shm_reg2, &ipc_int);
-
-	ret =3D qtnf_pearl_check_chip_id(ps);
-	if (ret)
-		goto error;
-
-	ret =3D qtnf_pcie_pearl_init_xfer(ps);
+	ret =3D qtnf_pcie_pearl_init_xfer(ps, tx_bd_size);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
-		goto error;
+		return ret;
 	}
=20
 	/* init default irq settings */
@@ -1155,95 +1096,63 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pd=
ev,
=20
 	ret =3D devm_request_irq(&pdev->dev, pdev->irq,
 			       &qtnf_pcie_pearl_interrupt, 0,
-			       "qtnf_pcie_irq", (void *)bus);
+			       "qtnf_pearl_irq", (void *)bus);
 	if (ret) {
 		pr_err("failed to request pcie irq %d\n", pdev->irq);
-		goto err_xfer;
+		qtnf_pearl_free_xfer_buffers(ps);
+		return ret;
 	}
=20
-	qtnf_pcie_bringup_fw_async(bus);
-
-	return 0;
+	tasklet_init(&ps->base.reclaim_tq, qtnf_pearl_reclaim_tasklet_fn,
+		     (unsigned long)ps);
+	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
+		       qtnf_pcie_pearl_rx_poll, 10);
=20
-err_xfer:
-	qtnf_pearl_free_xfer_buffers(ps);
-error:
-	qtnf_pcie_remove(bus, &ps->base);
+	ipc_int.fn =3D qtnf_pcie_pearl_ipc_gen_ep_int;
+	ipc_int.arg =3D ps;
+	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
+			       &ps->bda->bda_shm_reg2, &ipc_int);
=20
-	return ret;
+	return 0;
 }
=20
-static void qtnf_pcie_pearl_remove(struct pci_dev *pdev)
+static void qtnf_pcie_pearl_remove(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_pearl_state *ps;
-	struct qtnf_bus *bus;
-
-	bus =3D pci_get_drvdata(pdev);
-	if (!bus)
-		return;
-
-	ps =3D get_bus_priv(bus);
+	struct qtnf_pcie_pearl_state *ps =3D get_bus_priv(bus);
=20
-	qtnf_pcie_remove(bus, &ps->base);
 	qtnf_pearl_reset_ep(ps);
 	qtnf_pearl_free_xfer_buffers(ps);
 }
=20
 #ifdef CONFIG_PM_SLEEP
-static int qtnf_pcie_pearl_suspend(struct device *dev)
+static int qtnf_pcie_pearl_suspend(struct qtnf_bus *bus)
 {
 	return -EOPNOTSUPP;
 }
=20
-static int qtnf_pcie_pearl_resume(struct device *dev)
+static int qtnf_pcie_pearl_resume(struct qtnf_bus *bus)
 {
 	return 0;
 }
-#endif /* CONFIG_PM_SLEEP */
-
-#ifdef CONFIG_PM_SLEEP
-/* Power Management Hooks */
-static SIMPLE_DEV_PM_OPS(qtnf_pcie_pearl_pm_ops, qtnf_pcie_pearl_suspend,
-			 qtnf_pcie_pearl_resume);
 #endif
=20
-static const struct pci_device_id qtnf_pcie_devid_table[] =3D {
-	{
-		PCIE_VENDOR_ID_QUANTENNA, PCIE_DEVICE_ID_QTN_PEARL,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-	},
-	{ },
-};
+struct qtnf_bus *qtnf_pcie_pearl_alloc(struct pci_dev *pdev)
+{
+	struct qtnf_bus *bus;
+	struct qtnf_pcie_pearl_state *ps;
=20
-MODULE_DEVICE_TABLE(pci, qtnf_pcie_devid_table);
+	bus =3D devm_kzalloc(&pdev->dev, sizeof(*bus) + sizeof(*ps), GFP_KERNEL);
+	if (!bus)
+		return NULL;
=20
-static struct pci_driver qtnf_pcie_pearl_drv_data =3D {
-	.name =3D DRV_NAME,
-	.id_table =3D qtnf_pcie_devid_table,
-	.probe =3D qtnf_pcie_pearl_probe,
-	.remove =3D qtnf_pcie_pearl_remove,
+	ps =3D get_bus_priv(bus);
+	ps->base.probe_cb =3D qtnf_pcie_pearl_probe;
+	ps->base.remove_cb =3D qtnf_pcie_pearl_remove;
+	ps->base.dma_mask_get_cb =3D qtnf_pearl_dma_mask_get;
 #ifdef CONFIG_PM_SLEEP
-	.driver =3D {
-		.pm =3D &qtnf_pcie_pearl_pm_ops,
-	},
+	ps->base.resume_cb =3D qtnf_pcie_pearl_resume;
+	ps->base.suspend_cb =3D qtnf_pcie_pearl_suspend;
 #endif
-};
-
-static int __init qtnf_pcie_pearl_register(void)
-{
-	pr_info("register Quantenna QSR10g FullMAC PCIE driver\n");
-	return pci_register_driver(&qtnf_pcie_pearl_drv_data);
-}
=20
-static void __exit qtnf_pcie_pearl_exit(void)
-{
-	pr_info("unregister Quantenna QSR10g FullMAC PCIE driver\n");
-	pci_unregister_driver(&qtnf_pcie_pearl_drv_data);
+	return bus;
 }
-
-module_init(qtnf_pcie_pearl_register);
-module_exit(qtnf_pcie_pearl_exit);
-
-MODULE_AUTHOR("Quantenna Communications");
-MODULE_DESCRIPTION("Quantenna QSR10g PCIe bus driver for 802.11 wireless L=
AN.");
-MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.c b/drivers/net/wi=
reless/quantenna/qtnfmac/util.c
index e745733ba417..dfe3fe8a42c1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.c
@@ -15,6 +15,7 @@
  */
=20
 #include "util.h"
+#include "qtn_hw_ids.h"
=20
 void qtnf_sta_list_init(struct qtnf_sta_list *list)
 {
@@ -116,3 +117,18 @@ void qtnf_sta_list_free(struct qtnf_sta_list *list)
=20
 	INIT_LIST_HEAD(&list->head);
 }
+
+const char *qtnf_chipid_to_string(unsigned long chip_id)
+{
+	switch (chip_id) {
+	case QTN_CHIP_ID_PEARL:
+		return "Pearl revA";
+	case QTN_CHIP_ID_PEARL_B:
+		return "Pearl revB";
+	case QTN_CHIP_ID_PEARL_C:
+		return "Pearl revC";
+	default:
+		return "unknown";
+	}
+}
+EXPORT_SYMBOL_GPL(qtnf_chipid_to_string);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/util.h b/drivers/net/wi=
reless/quantenna/qtnfmac/util.h
index 0d4d92b11540..b8744baac332 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/util.h
@@ -20,6 +20,8 @@
 #include <linux/kernel.h>
 #include "core.h"
=20
+const char *qtnf_chipid_to_string(unsigned long chip_id);
+
 void qtnf_sta_list_init(struct qtnf_sta_list *list);
=20
 struct qtnf_sta_node *qtnf_sta_list_lookup(struct qtnf_sta_list *list,
--=20
2.11.0

