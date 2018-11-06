Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BCC46464
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D109720818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="PIySf8TQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D109720818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387439AbeKFNNp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:45 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387399AbeKFNNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG8GXk1ojICSUNbxz8B5PVaj87oNeqBNR4QhZ3PMUwY=;
 b=PIySf8TQM2gBCxnawV/LD+cgqok49uPTJHRQqG5Z+Ei67XVQw0BREofnT48mx7XdqKIhdLt1Y4ziBIJNrglRAjdGOy+IbvNd2atdMXWSW7Gm3UPjcfcA9q704gE1nQ2NX/De80ZRmTEiUHpYhx1NBfg+BYl/rqYEQj3n1HWK19I=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:25 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:25 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 07/11] brcmfmac: update 43012 F2 watermark setting to fix DMA
 Error during UDP RX Traffic
Thread-Topic: [PATCH 07/11] brcmfmac: update 43012 F2 watermark setting to fix
 DMA Error during UDP RX Traffic
Thread-Index: AQHUdYPZzStu3GHwkEOrMvogUZIZtA==
Date:   Tue, 6 Nov 2018 03:50:24 +0000
Message-ID: <1541476188-75475-8-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:YvispQlkHdw2q/noO0hg8Ys58P8MsO0ZSWf1C3GNGqpGs1iKngG+eT99i4+uAROGEpTYnGeGQXH9oSFM+l11IyHN8qcLnb5nqGE4vaK1sMZso7uBzYc9grvpnxYejUBtOeJQ6RsFSuQ1T8DXNINFYPPj4h9x2SzxWpwGER9AvhYquYI33ckbbJDFSSW2V4lXB2NrmLuqcuHymO2k2ymxxjyj71FNL78eaB+4HzP52k0lEN8gydpYCw8qeSkfZ+ISMRazNoy1DGrKzPcwcbkpJlXKk6CP8xFkt5vCQR/BRq6kojqIIaipXQBLsE4R3UWYkqgWlJutVWxJERj83tqj5rK1Od232wZEBXs/+2tcgFxxtCQffmaQPLgd36t0/P7AgsG3Mq9TF7AT3hbCvrHbknLSXJdABIqFavxf+sC2ucXp7lUaMdkghtd+EHK+2cTxyI0XTJ0XAvERhDH2tFaxMw==;5:x/ddJ6l5Zs5ee9quE6zfdZ0XyOUcz0gNQ0oEmxJ0lydqNvoVZB1eOyL45NTMb7EmowRrpabO4MWWF/AJzkeDaDmqaoXja/RWb+LWu0kRfooGtNqB6KY30VICdTxujwZGazbRin4Av/QfNUY9mPrDAYM8ygATgXU063gvkmdi2ic=;7:kkJZzep5aVEIIq50EuynDqQuUWVsrYxIVNd1B/fSyH/QOGI/wzNqsJ5vMu/bUFeaVLI4c1/a0ff0n7DogyHPr3/QO8PjhOqQdQSHEi++fgk47MrjpMjaIIzRChVau4rXPoewnSzyQxI1qeNeiXmhNQ==
x-ms-office365-filtering-correlation-id: 48d49869-0a2a-4248-5765-08d6439afb82
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB11421469DFFD54244BBE1DCCBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kl5Sv76Bsn4+aEgNIJLPliMwnSAghGRHm+wpjIo7Ve6JoCMv17Z+iC4/hqZ2isVUvPgD8OJDFhvGn+iqh1/pHbWMog/VPhmTlG/UsvNxWlDzytSP1KoSfirwAHtvbuuXsGoW4IZIf0tqI4RwwX+A1Cv/zOYYLj+zwhxZIt8VCI/8r13nRT1jTh60BIKGWssXApyGbLYObkObU1Dq1+97UXnHGbRYBXOBpmHXerosaEm0BAiTrUDZUvy/VTWOgZG2gIMJzlcbB/SlrLHnzJHfcGslp31wy11OCnEfaXuC2E2a0rVZC3xFZoibowk+I8jP1pHdvNhsDUiS7QXWt+5/wQXx+/OVmQ5MRXjLUrcYrIQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d49869-0a2a-4248-5765-08d6439afb82
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:24.8265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naveen Gupta <naveen.gupta@cypress.com>

The number of words that the read FIFO has to contain except
the end of frame before sends data back to the host.
Max watermark =3D (512B - 2* (BurstLength))/4 =3D
(512 - 128)/4 =3D 384/4 =3D 0x60
so if burst length (i.e. BurstLength =3D 64) is increased,
watermark has to be reduced. This is the optimal setting for this chip.

Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a32eb5f868b5..e7ee144dc5dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -52,6 +52,7 @@
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
 #define CY_4373_F1_MESBUSYCTRL  (CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL=
_ENAB)
+#define CY_43012_F2_WATERMARK    0x60
=20
 #ifdef DEBUG
=20
@@ -4162,6 +4163,17 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
 					   CY_4373_F1_MESBUSYCTRL, &err);
 			break;
+		case SDIO_DEVICE_ID_CYPRESS_43012:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_43012_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_43012_F2_WATERMARK, &err);
+			devctl =3D brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   DEFAULT_F2_WATERMARK, &err);
--=20
2.1.0

