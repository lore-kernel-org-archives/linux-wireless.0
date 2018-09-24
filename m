Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C629C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5796121480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="qdfRi1g/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5796121480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbeIXLOQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:16 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727430AbeIXLOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1ch2s4I9wA1hsRp7VfuC16amzfY6jmzC4Mn9pIwhnE=;
 b=qdfRi1g/Yt5/J7YwEaOi8aXzUhUDW88O+9pmUrIYB1mn6UjTcm/L7ITfATFwJOwS/w5Xq0cKRo9xggZ3FhOCtTYU+5H0vZ5Wr8YhlC1pn76ekuMD3eJjHvdJKoRePDioXnwqevyJ/Fp18qiX3CXue6zFxG8IJvC8upZtrv8QxPY=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:33 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:33 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 11/11] qtnfmac_pcie: check for correct CHIP ID at pcie probe
Thread-Topic: [PATCH 11/11] qtnfmac_pcie: check for correct CHIP ID at pcie
 probe
Thread-Index: AQHUU8VWC1BUgNpS6EKBAyjm889hyw==
Date:   Mon, 24 Sep 2018 05:13:33 +0000
Message-ID: <20180924051246.13371-12-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:LzzZUgvwhpRZ0HnT9ufY7Bauac4H/AGzPZ8/JjBM56/xRw0FWI3Sshh9RyxumxtFVBTQKvsZfDtf3jROgj9zn2PlFzLmPv+aDlWx7i45LdYiLQbbCWBkzw5RyDwz+dFzLb9/PH4LDENsJIP/NyOmhEYaGHwet4A94WDMkdyMxlKOxDXMk/bA3CEbR8qkPt74t220ioispVUeKD4v0jl1rcLBk4y97eXi2Y8PCqZgzcSREj5FeYZ4XN9JGaDY8kTUNrlNRf3uWTV7BI8nECxKHAV5IDpbFhQLGqmXiW9SXVel7SvHFQOdaqpSKe/nTFUgDnwfYUBa78KxgfnMOJHsBWqZlnfn13EDnjEOWsY/5PBln26qPVtOpMq0HG8pQsriVYxoAz/vLFCokcyiTKLrr6UQcgKYir1qCLiN8xHqMF7yw1lDb+wV2a6PqwnZNzrXxl7Q2MDVUvRl5tvOrhEViA==;5:olgBYC5Um4GiouPtDvdbZaaVUuK9i/hzweeyERGaHy9tbpUd73r9eVPuW7pdmO+t9YDfhC/0qC+ZPwFyZZoG/zcMc73VoISg5PTR92C4xQB9bhuVuNRN45LNxHVLPj5io7lH6RY1HGIT9o/7LfUyvPCMXqlWcwxGOzRHmzyC71U=;7:B2mKTCxHmdbTi57wpd4QhYyfeTHBk+M060/LRlLcHAEHfTXYotwcqhk7RS6B1sbAY339L4Coahux2v0Rc7OupTyrvuSKvu5CQApgbbmAxEy50RdvfWbn3tlGFheEqWNMjz4DeEsGUYh+mfN55+1xiPt+A0zq+7ePVhQ7bh5CijTUQz9Fc2D80s7ua/2aH2L+Op6lFOUc1C8Eaif2/2OOBQrJa6yNWLMm5hwfNIF27YZr2aQiVIoJN9O0Ic8bX370
x-ms-office365-filtering-correlation-id: a76c5b71-6850-4933-9c8a-08d621dc793e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975383AC11C3B87C0385CA0B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(575784001)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: EZPJbbbHaYvjrez2VXUCKtoa4yW6StB2VIFtuBTQshlXPRKIIj3CnufPnsLobLkrPPwGTYtWOfA+3/MDG70CnK4qfVFvRHKzngIHu5keho1+SFEL+MUOlHKAMxLnNNvxl+entGUVkjFB1NR6P3lgMxBrYGZTBsAETjsNjw83m43btlo2jx5BT67dRyFl1Kt9eXWuepcfuKiWDjYyFaIS4wz3ZG1HL9X5I/w4Kz1Q42ZCOxeS5bgPEnP1qUEHHhWJglEYduItlaqsAoJxoUhcnl4gV2uQ+LwOIRlhXjJ9Ud/3nKCG9wa+XKPvL5pcHvpAE+pWROxD2qgH+XMPb3NYTAogGq+7KWpWpcjQrI0rsjc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76c5b71-6850-4933-9c8a-08d621dc793e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:33.3274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051333.DS3WowFtKOnLGn6ZB8D-lpCtPeSIoeq3J-DQRCGb9A8@z>

Make sure that wifi device is of supported variant by checking it's CHIP ID
before completing a probe sequence.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 24 ++++++++++++++++++=
++++
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    | 14 +++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 424e367..d7a8d20 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1090,6 +1090,26 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned l=
ong data)
 	qtnf_en_txdone_irq(ps);
 }
=20
+static int qtnf_pearl_check_chip_id(struct qtnf_pcie_pearl_state *ps)
+{
+	unsigned int chipid;
+
+	chipid =3D qtnf_chip_id_get(ps->base.sysctl_bar);
+
+	switch (chipid) {
+	case QTN_CHIP_ID_PEARL:
+	case QTN_CHIP_ID_PEARL_B:
+	case QTN_CHIP_ID_PEARL_C:
+		pr_info("chip ID is 0x%x\n", chipid);
+		break;
+	default:
+		pr_err("incorrect chip ID 0x%x\n", chipid);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int qtnf_pcie_pearl_probe(struct pci_dev *pdev, const struct pci_de=
vice_id *id)
 {
 	struct qtnf_shm_ipc_int ipc_int;
@@ -1129,6 +1149,10 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pde=
v, const struct pci_device_i
 	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
 			       &ps->bda->bda_shm_reg2, &ipc_int);
=20
+	ret =3D qtnf_pearl_check_chip_id(ps);
+	if (ret)
+		goto error;
+
 	ret =3D qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/=
net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
index c4ad40d..1fe798a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
@@ -25,8 +25,22 @@
=20
 #define	PCIE_DEVICE_ID_QTN_PEARL	(0x0008)
=20
+#define QTN_REG_SYS_CTRL_CSR		0x14
+#define QTN_CHIP_ID_MASK		0xF0
+#define QTN_CHIP_ID_TOPAZ		0x40
+#define QTN_CHIP_ID_PEARL		0x50
+#define QTN_CHIP_ID_PEARL_B		0x60
+#define QTN_CHIP_ID_PEARL_C		0x70
+
 /* FW names */
=20
 #define QTN_PCI_PEARL_FW_NAME		"qtn/fmac_qsr10g.img"
=20
+static inline unsigned int qtnf_chip_id_get(const void __iomem *regs_base)
+{
+	u32 board_rev =3D readl(regs_base + QTN_REG_SYS_CTRL_CSR);
+
+	return board_rev & QTN_CHIP_ID_MASK;
+}
+
 #endif	/* _QTN_HW_IDS_H_ */
--=20
2.9.5

