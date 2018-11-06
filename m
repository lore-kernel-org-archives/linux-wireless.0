Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F3C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB6320818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="XhPGSOf7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DB6320818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbeKFNNa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:30 -0500
Received: from mail-eopbgr810101.outbound.protection.outlook.com ([40.107.81.101]:25243
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728971AbeKFNNa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O83q3fIf8wMu6DnhP41y4MjXCw/+sG6AMYzp9U1fOvk=;
 b=XhPGSOf7b7CM6OrnAgpRsrK+PIcuH5i6UDTvBTdhsBpN77HrvuY7pCNTYC1Xin3B51tgNm6nDAiMM/BscFjVO84w6KaU4p1bUB8FpCFbeeBlzs+xaT6jKYFdHjVoYQBwdajPTvyMphLKbEAEPYU/QY8Ps5cQVpUJgeipe1RWzyY=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:17 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:17 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 02/11] brcmfmac: set F2 watermark to 256 for 4373
Thread-Topic: [PATCH 02/11] brcmfmac: set F2 watermark to 256 for 4373
Thread-Index: AQHUdYPUCQkY2O7PYEC9l/5qSczFkg==
Date:   Tue, 6 Nov 2018 03:50:16 +0000
Message-ID: <1541476188-75475-3-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:+UmR5w4aNikvyCE8zDgynlcptTA98cdEVNrWwLOR6LbTYntXjWItw7OVlKRYWez6awEGpayIKXzvzPq62Yafd3uy8rtw4jrFJQ+9HSl9dq1azLQtefadxYtHev561vVtsmb+PrmrEHwvEB5rG6r2VI3asmOH/xcl349siR42luuwqI1TRljmRMkNWQBEH3ErHSDclKMKccLJyv72us/yQVC8wyvScPuK5BSIjeS66IbBCUwYKSqelpokmlS/1ma/Datvy6cbMt/gXDmMjYN9DozJ268+SjGjoH18pzR9I+SWF6inF2jAr88nJHHrpwv+EKTzsRYDMppsRw82Sw34JC53fyjDS2GtCEPNbWvlqMTU5OpmxOa9B87gki4ya2I7WoTzyomKU/bEUPv51vEvMIyvF460FJwxGKZ6UjlXgcCTSqF926HWI9KNyTZ8h6ZAF7KDcEuoOjK/YDyVGneC/w==;5:zWNIqCldqGpacOFBF3VwILL/QPCLTK0tN+ZB+X0zC2f/TEfOu3FgMn3gWe7/fNEtixPOeXqFk1CVE/N5lLl+HqmfPlyNtSAiw8tJui+oDWn/1+Wrwi/MEZND1xZ2dXDIif6iesbE9ip3y7z1KYOsRrXchH1qxMVEeYuN/48ktl0=;7:kaCdrutwO9tyFMiPR48GW4Gu/E1hXrHEbq62NmgR7MKfA+dcAy7NQSXmXyk395WLcnatqRp3jyV4ArzShOAoebxfxMgnUddJMSDK1eOWkNtVlzRjTl/hlJzFNePOUd9Ric8DOL53zFniMXkFJ7AKpQ==
x-ms-office365-filtering-correlation-id: f9bd8b42-120c-4c9b-2cd8-08d6439af6c0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142E5D567DACB9CBEAA5EB7BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(575784001)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 84yCmz/tz3wOpJhaHzOKGYIygt3YzbVjQHjbipvCwc+PhsrpBodpZsWl6GIiAEg92xUqBhi56yCcN25jeboONr8dUL1CsTLfj1UVmQzf2ajBTxcBTg96Yy/WwtwgZSc+JeimmXxEy6wwkmCOrD/jCnDH0jGPMe0gOu1ErCpwLgYsVFSt5AH5SsHnrFRDVKHxLkGSQSm3Ja1s3AUALjrldCZV/Gl6fsYj9ZpX3Zax3cpt+WoOqCVuLKr75uAfTyev6tlyTvlRkNBAd5KdheQuEHuuYu5nklh/AZvShAneOj5oGgFOG+BwLgif6Mpinf9uWMm71ZLUXltTwCaroL5HSLk5pgmLlSoonXsXOD+ngAI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9bd8b42-120c-4c9b-2cd8-08d6439af6c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:16.9743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

We got SDIO_CRC_ERROR with 4373 on SDR104 when doing bi-directional
throughput test. Enable watermark to 256 to guarantee the operation
stability.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 25 ++++++++++++++++++=
++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b2e1ab5adb64..541d54661c9e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -49,6 +49,9 @@
 #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
 #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
=20
+#define DEFAULT_F2_WATERMARK    0x8
+#define CY_4373_F2_WATERMARK    0x40
+
 #ifdef DEBUG
=20
 #define BRCMF_TRAP_INFO_SIZE	80
@@ -138,6 +141,8 @@ struct rte_console {
 /* 1: isolate internal sdio signals, put external pads in tri-state; requi=
res
  * sdio bus power cycle to clear (rev 9) */
 #define SBSDIO_DEVCTL_PADS_ISO		0x08
+/* 1: enable F2 Watermark */
+#define SBSDIO_DEVCTL_F2WM_ENAB		0x10
 /* Force SD->SB reset mapping (rev 11) */
 #define SBSDIO_DEVCTL_SB_RST_CTL	0x30
 /*   Determined by CoreControl bit */
@@ -4046,6 +4051,7 @@ static void brcmf_sdio_firmware_callback(struct devic=
e *dev, int err,
 	void *nvram;
 	u32 nvram_len;
 	u8 saveclk;
+	u8 devctl;
=20
 	brcmf_dbg(TRACE, "Enter: dev=3D%s, err=3D%d\n", dev_name(dev), err);
=20
@@ -4101,8 +4107,23 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 		brcmf_sdiod_writel(sdiod, core->base + SD_REG(hostintmask),
 				   bus->hostintmask, NULL);
=20
-
-		brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK, 8, &err);
+		switch (sdiod->func1->device) {
+		case SDIO_DEVICE_ID_CYPRESS_4373:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_4373_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_4373_F2_WATERMARK, &err);
+			devctl =3D brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			break;
+		default:
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   DEFAULT_F2_WATERMARK, &err);
+			break;
+		}
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(sdiod->func2);
--=20
2.1.0

