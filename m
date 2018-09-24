Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12856C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFAD21480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="dmyFhVhk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEFAD21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbeIXLN6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:13:58 -0400
Received: from mail-eopbgr700049.outbound.protection.outlook.com ([40.107.70.49]:61600
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbeIXLN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw4HNQl96Hqi6lDAgGeJdtcoA4m2piLH1ATFqJ7CvIQ=;
 b=dmyFhVhk1U5MOXtUNmg0+7H46nPuA53y7scIhrGm40zGnCzYD6uhbZukrld+3lLxjdT+wWJodMJ6N6lodPpjaI6GJCRQtzzJtDj9TESuXmmtoTCusGKBXa2ssGMW3kHRUI/YMlY13adgkeiu+QOTTzKc9VIqJX6XjQInLZRh1pw=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:24 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:24 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 01/11] qtnfmac_pcie: do not store FW name in driver state
 structure
Thread-Topic: [PATCH 01/11] qtnfmac_pcie: do not store FW name in driver state
 structure
Thread-Index: AQHUU8VR4mBYujICX0y3CU/tJjH+wA==
Date:   Mon, 24 Sep 2018 05:13:24 +0000
Message-ID: <20180924051246.13371-2-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:DFm2OrcQZQnY4f9JYfmI1zOz7evVGuKus3oO1Z+FsQiV3t2NsMPWA9y+CGfXr8XG4Dl14hIQ0jiAkrIxc5rtlDoIfb9f9KJDnA75CLAg/5dKAAzyTfLcElS6tVVqXDMEVDOfx+Cw1IZm+zRPsY8Tx9mzZPorsxoT/RaG4wGvtKmbc5aABFjchZwKqk6keIyDmPE8G7BSzNh0EMGymdO53R1riEQXpjoA456mUy0RTpYZRqNsibc3eMvTH80FdmZLtMImFJPZpdTjCWZM69xUdeDQHcCB5FKkENhrZlYZd/BU/H4+7Pcnu9s4ni/lAEEj1A2yaF0J9h0BAtI1WlqS21dAv4BiuHegcR3MsM6v6aVwZq3BC6DteqmM9onXJOW+anIU7oNKSiJx4I4CV2ofig2/oRjEaB8XQAgGxok64B4K+Dr7EUq9O/56L0vyDJnC8VSxYjRFs1oOGLdmRH1stg==;5:OdFuCbeEayy8vrpzXfxSH4xKHzOa6jR2ENKEr2jy2EoMzxTdocR/DBaz3K9gj3O2HKAeQUEm53tBM8HlbE6RzltgwmYbnwIqJgJBfSntEHMvTQBGFYyu0vSAMYdfnRWdptnvI8tbZdlMdxQ6+MXcdkCTCad/Nx9v5mGDydQU3ys=;7:stgCwFV7WrQslclnk2cJ9A3xnK1neDMLCmkW1RpbY57AYyTOjiNikk73ygwGsuSQWOOAFoN6B9ErrOt5KUs9W34TCvN+PY3ov2lwgrjFe+P3LFsxhNXfahb4maFh8j1qk3BuLlQvTiUbA2zDn6/P8m7nnA6GiOrSenLqIiEsyu2XikJUUe1yeO+S6VV3ePMllesa+pwMgwc6J2sJn8XX5IgVm4DH21ceITRghe9/tZN15hN2KHT15TlpkzeINuIN
x-ms-office365-filtering-correlation-id: a5f8496d-7e91-40b5-d4b8-08d621dc742e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975E94347B29890EC4B34E9B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: uYVFeHWNU/AVZg4sNGcbC9/UgmxFXc2ODCw9VXKYl1GXyBdWhOu36ia2n0c/V4HRY+volYWZiPCWnqhQvv/OXZ7cnZGpCLFWKDIU3b5WR2paNJPsM/hLbW9lzX4x+N15oWvMUXxbvlDRO1JKGzGJVzBSU+OYOknvoV8xLRE3ckaLx9OyjtzsyOlnyREODDLrdtIqc/zBFsrE/temRpXv9gblIjDjVt9zIhan0Ls1bQE9+bdnqOm4pcxZC23kvdYJg/45I/9ileg5UVGkqEoYo5iNnYXS1w+PT28vCK63jXjSmaek7Dw92eZsyxue2f3tzmIBAcFzHJoZwGXWXjsOw9V2VAfCEsVsGMcfZdS3bFk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f8496d-7e91-40b5-d4b8-08d621dc742e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:24.8464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051324.S3ln8leqDG1X00hTPQ2AHAerGRfB8PFxC9AuRUcNx08@z>

Firmware name is only needed at probe stage, no point in keeping it in
driver state structure.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h        | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 323e47c..2beca5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -57,7 +57,6 @@ struct qtnf_bus {
 	struct qtnf_wmac *mac[QTNF_MAX_MAC];
 	struct qtnf_qlink_transport trans;
 	struct qtnf_hw_info hw_info;
-	char fwname[32];
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
 	struct completion firmware_init_complete;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/=
net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 3120d49..97cc7f2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1177,13 +1177,14 @@ static void qtnf_fw_work_handler(struct work_struct=
 *work)
 	const struct firmware *fw;
 	int ret;
 	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
+	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
=20
 	if (flashboot) {
 		state |=3D QTN_RC_FW_FLASHBOOT;
 	} else {
-		ret =3D request_firmware(&fw, bus->fwname, &pdev->dev);
+		ret =3D request_firmware(&fw, fwname, &pdev->dev);
 		if (ret < 0) {
-			pr_err("failed to get firmware %s\n", bus->fwname);
+			pr_err("failed to get firmware %s\n", fwname);
 			goto fw_load_fail;
 		}
 	}
@@ -1205,7 +1206,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
 	} else {
-		pr_info("starting firmware upload: %s\n", bus->fwname);
+		pr_info("starting firmware upload: %s\n", fwname);
=20
 		ret =3D qtnf_ep_fw_load(priv, fw->data, fw->size);
 		release_firmware(fw);
@@ -1290,7 +1291,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	bus->fw_state =3D QTNF_FW_STATE_RESET;
 	pcie_priv->pdev =3D pdev;
=20
-	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx0_lock);
--=20
2.9.5

