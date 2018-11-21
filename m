Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B6DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895FD2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="fIZdKCCP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 895FD2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbeKUS11 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:27 -0500
Received: from mail-eopbgr750121.outbound.protection.outlook.com ([40.107.75.121]:39472
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728322AbeKUS10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z5VZ8Xr4BUy+e9vpXvu91P7emkl/xhcAUXTpfAK/nc=;
 b=fIZdKCCP287BiAzBIpBqcBrkYs1EjVxNXiitYudMjPwGd0h3w8c02zm6/kkR4/rwYZ4UA9CrumS0au05z6yx/724WzdvEI4MzSF9fLhNRqxSamm1DKGvbwFeEz1T/E2z1zR+4o32Lx45wm9lDaDDiEPWRIjTHIvO/WO/Hv1e31Q=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:45 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:45 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V4 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH V4 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUgW9UYqk/6BYCE0mOJfK/GneMnw==
Date:   Wed, 21 Nov 2018 07:53:45 +0000
Message-ID: <1542786800-146083-4-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:Rvw2rIZSa6UR3u+HXYMsqH6md/1SF/OH1Rycg2yABdjb+iy8Uua6o8ZdrDZH9gDAjhGZWefz37HzhVTKerJftn+kcFhQw2OY4AVIS5kivxgUi90UuSiYDODlL5+QW42IesEdUdfP4udw8GuGB45Gq2Wr6zJ4pMBoLY+NNtvyu4n4oyzZ6I+0dV7Z7EBbsLpmOLzdBE1fi1Itb+JN/Uyhbek+7wbW5px77r2IMmSK6KoxpXFXdIQfwphsBjJJ5ZsrvsKTMCWupBsYcgdq4HPR8lNaZW8K+hKiAr7QtYFNO2Q3vVAN1f3a7q+t4xeXrsOADnHq1UwHG4MEACQqEHrzn9znShVUJVPMMvc1U+OK54U8ulmcO4n1Dc6FbY4M2PTh1/oB4bP8aab1zhzrbh/NfkjCxQLTLZ2XVt9ozqljduybo9pCCHVtiu0uhJv9DaJHM1x39q7YpwYgQd+EZEfKTQ==;5:N0yTAueRpmmGhrAs4v0+myIkzsq153R/pUUCXgNa/vvS8Uws8Ip4/y55wEsMHYf1wQw0g5pE7M80Oy6VOIRzMomPbBocbMYpI03d9Q0pbLpD8BgSsTMfXdnYgcK/8yR9EJcDqfaZHZGS7KC2RvL6uPHkKmf4Q3BkselH3eUpHyU=;7:NYwLGgbuZV33fxJ5cLyH1Tb6TPd+M0Oiks5i2AjvkBxSyWvzMPBdJt1IGBm8VSkTQ/VU+eJUCgmhdQGmBHapQc0FU54rWocVKf9Ml7ToDxvg4vu3LjAFiFbtsALCS/IGVdIXY61lqlv/Z0DfwMhVLg==
x-ms-office365-filtering-correlation-id: b639ed1a-5f01-4601-57c5-08d64f867653
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB1174CBADA9BA6E6E58F16404BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(14444005)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5bStXyk0K0fTDXH0n09/iKyIXvVECvrfQbqM7I1bgVA16u/Rxo99c9VGMaIktxd320xDmoHu1yXI/sn8ZB0sYuebYCUctYpuRVgKg86aho3zbQq/W515HRoREstYiZqM1Q4v6OQ7FXOHUxOILOU7i4KqIsEC6z7e5aqz4sXHnQVbgUQegbw+iFEKPiBPZq7p6696Y6gD8sIQp5CmpD2a3AAPvwKFYXFWFyDhVYzS7fckkbg9gXQ6r359vEdHb7MCKmpUMxQd0v3iJFF7Csw3MKNWR+m04Y/sd25HgGSx3zl1CH86R98g1ruyNlTteVhEW3I8fNX47mjWDRGlcTyJ87EUaoiIRRChr3udOoar0xM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b639ed1a-5f01-4601-57c5-08d64f867653
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:45.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
should be enabled & sdio device RX FIFO watermark should be
configured to avoid overflow errors.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c833e24c751c..7a0601543dff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4119,6 +4119,9 @@ static void brcmf_sdio_firmware_callback(struct devic=
e *dev, int err,
 			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
 			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
 					   &err);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
+					   CY_4373_F2_WATERMARK |
+					   SBSDIO_MESBUSYCTRL_ENAB, &err);
 			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 7faed831f07d..34b031154da9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -77,7 +77,7 @@
 #define SBSDIO_GPIO_OUT			0x10006
 /* gpio enable */
 #define SBSDIO_GPIO_EN			0x10007
-/* rev < 7, watermark for sdio device */
+/* rev < 7, watermark for sdio device TX path */
 #define SBSDIO_WATERMARK		0x10008
 /* control busy signal generation */
 #define SBSDIO_DEVICE_CTL		0x10009
@@ -104,6 +104,13 @@
 #define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
 /* MesBusyCtl (rev 11) */
 #define SBSDIO_FUNC1_MESBUSYCTRL	0x1001D
+/* Watermark for sdio device RX path */
+#define SBSDIO_MESBUSY_RXFIFO_WM_MASK	0x7F
+#define SBSDIO_MESBUSY_RXFIFO_WM_SHIFT	0
+/* Enable busy capability for MES access */
+#define SBSDIO_MESBUSYCTRL_ENAB		0x80
+#define SBSDIO_MESBUSYCTRL_ENAB_SHIFT	7
+
 /* Sdio Core Rev 12 */
 #define SBSDIO_FUNC1_WAKEUPCTRL		0x1001E
 #define SBSDIO_FUNC1_WCTRL_ALPWAIT_MASK		0x1
--=20
2.1.0

