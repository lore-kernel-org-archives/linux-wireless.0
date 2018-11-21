Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFD3C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA392145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="yyF7qdsl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAA392145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbeKUS1Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:25 -0500
Received: from mail-eopbgr750121.outbound.protection.outlook.com ([40.107.75.121]:39472
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbeKUS1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qay0aFW/E2FYhElg8U8JOaHkpaO+VZRJJs5m0wcZq7Y=;
 b=yyF7qdslToDFthx3uWPE9nwGOjBljz1Hd4+9QpSchnRIslKjl4sNY4EH5GUgvS2wPwNoB/ePzzVPtvTK2Gd0A8pbBdsbYaTYjdZ1RK7xEP7AEW/rtC52RW6MHOlK2hpDITfqTJvZBb0qwFsEnghm0YjnvoRNFpehE5Huf7iIBUQ=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:44 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:44 +0000
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
Subject: [PATCH V4 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Topic: [PATCH V4 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Index: AQHUgW9TcRwOLz1cHU2PRs7Wd0tBtw==
Date:   Wed, 21 Nov 2018 07:53:44 +0000
Message-ID: <1542786800-146083-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:hOyvtVmzL74HZmqBOFaDd9TKIGGfXeSHu4w4hXS4pkNVh3rsg277wCHiYCFJoz8R3ISFFra6wJDLBKrgFXGm1+xjrs/aRFZNX0ujomsSfa30wVekfwdcAzfH0/NwMu0m/2Xzr3uwr3HUEdXPAfG+3G/5YTHvSBhbgClCP6xtqm9/VjUhJZqC+6XUh3Hb0hg6gTKw5OmawANJYAxwvPSA+/VC2qJx14nIX4zdohefLY9XjEYyobo9mny+PcUgrqj8ZjiBVCL1F8QNjjPhAO8zl0kI52szc2/bAqs5RdRajfQ0IdyBjIdkIVuj2eVOyEog8Jy7glYdAMAjCuzHfmNUho0fy1SX7e7G53pMujf2kbFxbh2aTcJ6tQFjleAZwH7He3eRWaaBCqjKs9u0sx4YLMgowolWKdYelKPwDnfKCCdgLXSGMPzrib4BiIwyzT5knuSZLz2M3OX7YNHqaGZJLQ==;5:Jyqle+m1eS2g/CPKfTXHckhLdW7m36JygNwgKTt1f9AAxNF5hXP4JMPTyXQAraztkyH/TIVMC8YXJzUVwnGjolfneGgvTu3EFGDIQuXaTvAwr8fF/ttrh9FhQtKPvHl31U/y7F6M3g2m6ubCOtfZHyV9sjp9kNNudGAu+mXHnuI=;7:oTdDv67dTyshDtRggztUdrMQiJty/RUbZWpIVgA24soX5w4+mj31JGrHYgW+mkl0YErgEnqUqFLv437wxERy95jxs5qrlUn1WjxRtvITZ/jollbYga4lBdNEiULOBmJSaHZlR7ZnjRv/v0Lgyzz32g==
x-ms-office365-filtering-correlation-id: 3859e94f-5b4f-404c-d505-08d64f86758f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11748B2B9F356CC1C369C615BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Dnj30mwUUiaOMSG5WcUPw3L5xLvTdXnPO6Rd6p3hGBLcd4FMC3H6gayPizIJOgie3EulXEoSuIeIRBihxRAkPAgOwniAfiyDan8O4Ko6CVMvbwmPesW2Ubkw7zZ6WkuVU5XRgKT05RXcAZiKWZ3ofY8mfKW0XWcrEMJLzUiWAPgTpudUynal/uhmg9gPfo/vpWNjHkedvhscQbxrfaGqP+RZVl787PEzkvkfSvNdr5ZKldol/TEApjmrZWBKeZKrho18CyM0VDqj4MFiR7rD+s8SP+hVDVlnJzXZve5APE8YKW5V60PaaGLlqD+cIf3ZJvdhoUQ7aGdq5PAWRBzk9zCNgrExc/+2fIy6InJBuI4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3859e94f-5b4f-404c-d505-08d64f86758f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:44.1076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

We got SDIO_CRC_ERROR with 4373 on SDR104 when doing bi-directional
throughput test. Enable watermark to 256 to guarantee the operation
stability.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 26 ++++++++++++++++++=
++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 22646a3b911e..c833e24c751c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -49,6 +49,10 @@
 #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
 #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
=20
+/* watermark expressed in number of words */
+#define DEFAULT_F2_WATERMARK    0x8
+#define CY_4373_F2_WATERMARK    0x40
+
 #ifdef DEBUG
=20
 #define BRCMF_TRAP_INFO_SIZE	80
@@ -138,6 +142,8 @@ struct rte_console {
 /* 1: isolate internal sdio signals, put external pads in tri-state; requi=
res
  * sdio bus power cycle to clear (rev 9) */
 #define SBSDIO_DEVCTL_PADS_ISO		0x08
+/* 1: enable F2 Watermark */
+#define SBSDIO_DEVCTL_F2WM_ENAB		0x10
 /* Force SD->SB reset mapping (rev 11) */
 #define SBSDIO_DEVCTL_SB_RST_CTL	0x30
 /*   Determined by CoreControl bit */
@@ -4046,6 +4052,7 @@ static void brcmf_sdio_firmware_callback(struct devic=
e *dev, int err,
 	void *nvram;
 	u32 nvram_len;
 	u8 saveclk;
+	u8 devctl;
=20
 	brcmf_dbg(TRACE, "Enter: dev=3D%s, err=3D%d\n", dev_name(dev), err);
=20
@@ -4101,8 +4108,23 @@ static void brcmf_sdio_firmware_callback(struct devi=
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

