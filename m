Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FABC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E3E2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="x2ousaEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfCTKFW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:22 -0400
Received: from mail-eopbgr760055.outbound.protection.outlook.com ([40.107.76.55]:21558
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727586AbfCTKFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJrA++2sFn1kEH519/CIP66EFi9IlVMPY6RpsyZ0L9M=;
 b=x2ousaEQdOarxEnYfIXTDYn3D8IRvATxnP1OD9KJ4+qWXs8bpeWUvHqGcZSBjyU5BJdswASFhd4qjgKqFGQKgK/gTZmPDvXaZBrA8+V/fTOq/kw+ktShAzwZ6p53U8PNhPox1IXpv4KszaEi8mL46kPt1kMunRkUHBHT8iKYGL4=
Received: from DM6PR05MB5771.namprd05.prod.outlook.com (20.178.25.76) by
 DM6PR05MB4761.namprd05.prod.outlook.com (20.176.110.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.12; Wed, 20 Mar 2019 10:05:18 +0000
Received: from DM6PR05MB5771.namprd05.prod.outlook.com
 ([fe80::6510:9cdb:117a:98d2]) by DM6PR05MB5771.namprd05.prod.outlook.com
 ([fe80::6510:9cdb:117a:98d2%6]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:05:18 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:04 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:04 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 09/14] qtnfmac: fix core attach error path in pcie backend
Thread-Topic: [PATCH 09/14] qtnfmac: fix core attach error path in pcie
 backend
Thread-Index: AQHU3wQ+/vmwbWJC3EmhBLHPgyInTg==
Date:   Wed, 20 Mar 2019 10:04:02 +0000
Message-ID: <20190320100340.14168-10-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 943366ed-290b-4142-7e9e-08d6ad1b60d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|DM6PR05MB4761:
x-moderation-data: 3/20/2019 10:05:10 AM
x-microsoft-antispam-prvs: <DM6PR05MB4761B2BFB089132AD82B387CA3410@DM6PR05MB4761.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39850400004)(366004)(376002)(189003)(199004)(316002)(5640700003)(305945005)(7736002)(105586002)(8676002)(6916009)(68736007)(6512007)(6436002)(86362001)(81156014)(97736004)(6506007)(186003)(81166006)(102836004)(386003)(54906003)(106356001)(52116002)(8936002)(26005)(14454004)(2351001)(99286004)(478600001)(76176011)(2906002)(256004)(4326008)(5024004)(6486002)(14444005)(36756003)(103116003)(446003)(25786009)(2501003)(50226002)(11346002)(5660300002)(53936002)(107886003)(2616005)(6116002)(436003)(3846002)(66066001)(1076003)(71200400001)(71190400001)(476003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4761;H:DM6PR05MB5771.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L3+1YqpceS5EhklgBeTLw/9dSYOThDZGazxoQ5zCBEkQLZTuVQVMqPT5qi7O76bO/aN4iizSiy4mLUF/DNBOtM3X+aETuI03gT7tF6hBOhDk2RRTTzFMqJiAUGy+3V11STEf7G3HkJD0QsG+SbrP3XFdlA8kZBFU06O1jm4J5IY0xXm9IQTVtwZuu+vMxpQRNv8QKNPkTHSWmYHDT06XfRg+mG/wozQfBESDtHk95hxX6rRpY8hy8pADVNdAxme7Glv66w5B6A84bqn3111i6DCz42bbcTPO5E7GWoLBDFO9Ipom9X7/LFHav8yzxgR2K3Wf7f9wlUYz8R7Qq/EG9MQIOIC3RHjd/bb76dhJ4J/mWzXp4usjGsHFXLpXGzs34SAwIzjk/I+LvL+fI5ruHFfAbjo4OIK2iH/dYo/pwq0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943366ed-290b-4142-7e9e-08d6ad1b60d1
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:18.5383
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4761
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Report that firmware is up and running only for successful firmware
download. Simplify qtnf_pcie_fw_boot_done: modify error path so that
no need to pass firmware dowload result to this function. Finally,
do not create debugfs entries if firmware download succeeded,
but core attach failed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 25 +++++++-----------=
----
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  2 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 23 ++++++++++--------=
--
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   | 23 ++++++++++++------=
--
 4 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index c3a32effa6f0..a693667a83d7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -128,32 +128,23 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, voi=
d *data)
 	return 0;
 }
=20
-void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success)
+int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 {
-	struct qtnf_pcie_bus_priv *priv =3D get_bus_priv(bus);
-	struct pci_dev *pdev =3D priv->pdev;
 	int ret;
=20
-	if (boot_success) {
-		bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
-
-		ret =3D qtnf_core_attach(bus);
-		if (ret) {
-			pr_err("failed to attach core\n");
-			boot_success =3D false;
-		}
-	}
-
-	if (boot_success) {
+	bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
+	ret =3D qtnf_core_attach(bus);
+	if (ret) {
+		pr_err("failed to attach core\n");
+		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
+	} else {
 		qtnf_debugfs_init(bus, DRV_NAME);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
 		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
 		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
-	} else {
-		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
 	}
=20
-	put_device(&pdev->dev);
+	return ret;
 }
=20
 static void qtnf_tune_pcie_mps(struct pci_dev *pdev)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index bbc074e1f34d..b21de4f52a9d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -70,7 +70,7 @@ struct qtnf_pcie_bus_priv {
=20
 int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb);
 int qtnf_pcie_alloc_skb_array(struct qtnf_pcie_bus_priv *priv);
-void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success);
+int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus);
 void qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv,
 			    struct qtnf_shm_ipc_region __iomem *ipc_tx_reg,
 			    struct qtnf_shm_ipc_region __iomem *ipc_rx_reg,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 1f5facbb8905..3aa3714d4dfd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -980,12 +980,11 @@ static void qtnf_pearl_fw_work_handler(struct work_st=
ruct *work)
 {
 	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
 	struct qtnf_pcie_pearl_state *ps =3D (void *)get_bus_priv(bus);
+	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
+	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
 	struct pci_dev *pdev =3D ps->base.pdev;
 	const struct firmware *fw;
 	int ret;
-	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
-	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
-	bool fw_boot_success =3D false;
=20
 	if (ps->base.flashboot) {
 		state |=3D QTN_RC_FW_FLASHBOOT;
@@ -1031,23 +1030,23 @@ static void qtnf_pearl_fw_work_handler(struct work_=
struct *work)
 		goto fw_load_exit;
 	}
=20
-	pr_info("firmware is up and running\n");
-
 	if (qtnf_poll_state(&ps->bda->bda_ep_state,
 			    QTN_EP_FW_QLINK_DONE, QTN_FW_QLINK_TIMEOUT_MS)) {
 		pr_err("firmware runtime failure\n");
 		goto fw_load_exit;
 	}
=20
-	fw_boot_success =3D true;
+	pr_info("firmware is up and running\n");
=20
-fw_load_exit:
-	qtnf_pcie_fw_boot_done(bus, fw_boot_success);
+	ret =3D qtnf_pcie_fw_boot_done(bus);
+	if (ret)
+		goto fw_load_exit;
=20
-	if (fw_boot_success) {
-		qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
-		qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
-	}
+	qtnf_debugfs_add_entry(bus, "hdp_stats", qtnf_dbg_hdp_stats);
+	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
+
+fw_load_exit:
+	put_device(&pdev->dev);
 }
=20
 static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index cbcda57105f3..d9b83ea6281c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -1023,8 +1023,9 @@ static void qtnf_topaz_fw_work_handler(struct work_st=
ruct *work)
 {
 	struct qtnf_bus *bus =3D container_of(work, struct qtnf_bus, fw_work);
 	struct qtnf_pcie_topaz_state *ts =3D (void *)get_bus_priv(bus);
-	int ret;
 	int bootloader_needed =3D readl(&ts->bda->bda_flags) & QTN_BDA_XMIT_UBOOT=
;
+	struct pci_dev *pdev =3D ts->base.pdev;
+	int ret;
=20
 	qtnf_set_state(&ts->bda->bda_bootstate, QTN_BDA_FW_TARGET_BOOT);
=20
@@ -1073,19 +1074,23 @@ static void qtnf_topaz_fw_work_handler(struct work_=
struct *work)
 		}
 	}
=20
+	ret =3D qtnf_post_init_ep(ts);
+	if (ret) {
+		pr_err("FW runtime failure\n");
+		goto fw_load_exit;
+	}
+
 	pr_info("firmware is up and running\n");
=20
-	ret =3D qtnf_post_init_ep(ts);
+	ret =3D qtnf_pcie_fw_boot_done(bus);
 	if (ret)
-		pr_err("FW runtime failure\n");
+		goto fw_load_exit;
=20
-fw_load_exit:
-	qtnf_pcie_fw_boot_done(bus, ret ? false : true);
+	qtnf_debugfs_add_entry(bus, "pkt_stats", qtnf_dbg_pkt_stats);
+	qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
=20
-	if (ret =3D=3D 0) {
-		qtnf_debugfs_add_entry(bus, "pkt_stats", qtnf_dbg_pkt_stats);
-		qtnf_debugfs_add_entry(bus, "irq_stats", qtnf_dbg_irq_stats);
-	}
+fw_load_exit:
+	put_device(&pdev->dev);
 }
=20
 static void qtnf_reclaim_tasklet_fn(unsigned long data)
--=20
2.11.0

