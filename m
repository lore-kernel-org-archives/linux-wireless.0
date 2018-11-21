Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB08C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058AE21479
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="eQ7fub3c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 058AE21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbeKURao (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:44 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbeKURao (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be11iNvYxsStvcW9ocCJyVZPVwaCjiR0/zdsd2Gd0E4=;
 b=eQ7fub3cML26ILButkBE7QVSUQ5q52EN5tjCE3tOU0QsVEpZz85tE6mhEY1HSNq5dvExUlooGdTaUMsgDljUwCeXyyB9a4snMtftPAXpr4NrgS5Y+YL+SYJaFkwLkZdCNejs/J8vCvbaUU+I6e7ePJrN61/HXWFJ6M4ougR7K5c=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:17 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:17 +0000
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
Subject: [PATCH 6/8] brcmfmac: update 43012 F2 watermark setting to fix DMA
 Error during UDP RX Traffic
Thread-Topic: [PATCH 6/8] brcmfmac: update 43012 F2 watermark setting to fix
 DMA Error during UDP RX Traffic
Thread-Index: AQHUgWdwe2yhsmset0ib9RfGNrn9wQ==
Date:   Wed, 21 Nov 2018 06:57:17 +0000
Message-ID: <1542783402-112482-7-git-send-email-chi-hsien.lin@cypress.com>
References: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:a03:54::46) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:YQkIvWGx9Gj9eMSLydDhtXhEWyjFMQSJ8mGttEh1htaV26FNacA6GgobzjiC5ggh5uZBfVbS7OO3zCc+Cqld3fDhNUVNWeTFkdoRCTPMRTI534ANg/qzcbA0/j3JJ/9MrpfTD0+/VOTw8xCZuBFVowyGzGlQqiKn1+RWPck7/gyV/ami0lWuqtDwvTv9sh1vUjShdVxHkNyjcDgrHuamJ1k/1MvUQmuVPMm4Ma14Tjeq+q3OGaonO66rBgihKs/fl0waiA3OGeDCg4r/vLzIYbCRvN1GhfaN1SJCOCa9iYt2SyWvaPeCByHIZgjWwQlgEhSkotCgkfziWvxpFWsCBBXX2LGxHyMeY7KT91WrxGuflRA8rn/XyvLhEeXKGzU26wE1/U/Kdieyi8tSKI0tqp53DN/YTzm5H0RjzukCVPwXBQo4HdxR8TpPzQHIIxBANghWh0vScChnvpjy9phMYw==;5:apcwMIDug2CKofgErwg3A9JeJ8ViABUdFv03ADQISAfBSxc9+4yxkmPd/nC9igv5HPCYgDIo7GsbJIefjBAuYmnk1yPZNMqSKc+0rwmQC5P4+cvfOb+QIRDUv/Y6I0meJGytr+viJM7D0jsv43rUPszGDxGfkddzCqQ0aQzFGTw=;7:2juCJh7qwd+uENcbySbcXtxFOipXt9lTz/4WOJ5MMU0zxltHnd2hkZVyyQVK2/bLnouExqBUQEKVsBpnGqNpIM5T3bG75qnyTVwPNJMXr1Xrq8jGRBVOviADdsh76DA1+HFefjVmGT5KLpkk6qcnEQ==
x-ms-office365-filtering-correlation-id: 36619185-f51a-4658-0c7b-08d64f7e932e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB1349195BF7D781000C4BF705BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(575784001)(6116002)(256004)(476003)(105586002)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: adc/2qLU0NhdctK8Q8/UIkthvxj6lsIL8G6yCjx0nkH6PBoJMg3c9OaE0VffL50AD9LG6JpmOfwHmjb+z8DX00PVi9LvMXuGUgMtPzLlpLvIpKEBdg4Bo2iDFfjleLNi7P0txsizIauDkAgmoHxfQzKouAK8Vn5Q17WMb7RfRI++DNnVUviKSKzP6CynFQCRWq2PwuGEYPaKYBiHobiddje6a6xtjEBGOzYdrw8XfZ6d2GX3Xsuk3XFp6BRQArnotfoBwggRuPBtMtslmcnsBwX+cBtxkPN6NQqdBZGBtsrvowFNgLmcLseTPaENv/3iDv8n9k3HVD5z9fmEZqx54+/eAAIgUpWKE4uupZCA3wc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36619185-f51a-4658-0c7b-08d64f7e932e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:17.8246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
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

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 73a034172c4c..fe0cb398ab44 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -52,6 +52,7 @@
 /* watermark expressed in number of words */
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
+#define CY_43012_F2_WATERMARK    0x60
=20
 #ifdef DEBUG
=20
@@ -4173,6 +4174,17 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 					   CY_4373_F2_WATERMARK |
 					   SBSDIO_MESBUSYCTRL_ENAB, &err);
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

