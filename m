Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7A6C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB6521722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="DsuDws2D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CB6521722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbeKLRVc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:32 -0500
Received: from mail-eopbgr760131.outbound.protection.outlook.com ([40.107.76.131]:21756
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRVb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c09pF5r/4wKcoBqQKDAcMAlaYqRQWLeMhoMTlccPudU=;
 b=DsuDws2Da2eYDkDDmYVhdDuKEOc3kl0G28K9o2GC3zfWWSjrbjvWtLgSn1g7Wdy6FAF42h/n6gVMtI1P2s0ubNndBNzW6GbSd6C7X3logynfiKKnCMomqyDsNAHSgsu85x1kHDKqHHeWGjKbkZBuO5rmGrd7ZVZVOJ+CxINj1ro=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:30 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:30 +0000
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
Subject: [PATCH V2 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Topic: [PATCH V2 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Index: AQHUelly4O8E7afA+E617igGp9CtlQ==
Date:   Mon, 12 Nov 2018 07:29:29 +0000
Message-ID: <1542007730-47284-3-git-send-email-chi-hsien.lin@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: HK0PR03CA0084.apcprd03.prod.outlook.com
 (2603:1096:203:72::24) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:i0rMTqXpe2zSEZXvnDkqcikhK8Glez65Bb8wSqN/ehVEAIThTvzBOBWIfwYDtROLkwCSfxBVmwQZM01YQ1Q7QzdxbeI9lGd/nayeTAuuYhDKUQaUjz/QOqsZQK6HJ0e8Bspj4tjhYnQNie99RmzsHhY+A6d7waAJPBUxCM16Pf558V7oU4v839fZ6UtbntzTggPwwhc2GCeOl5YuoplETsqM+2bskkKtalkVkVMnyVvFhmMnxkk+umcF0b5bwrmWHCT38tMY+lxRW49v5yjg8SufDJzCeYNqj9SjK4Zo1iNigXINC2UyfMhKv5jE8OKR3ipEZiHU7rgQo3Movbyxbc8DM9Kcq8zZo40JxD7vH4cyX4Ge3CLAYmFIomHWVAgsb5imuD1c1TWJL4QohZ6mQJvSzHn3PqpbgbO4cCnc2tTH3WjPndQu233nWz4cnkvrAF1h2SRq7xllpI1Qgn00ug==;5:XfTpaGN/5+3itNUh7jUdiqbmIYgxHAoo5bBeQwKubHRL49BVEc1ZKfQjJ0zY1yrxB9NxsfmMrTxagfY9ByuChrgn6lRBWRsptBJsfEQmF52F444zvOQ4zoUYqsOLcc2DS78vA+UcA+lgntTglznAW2QlB6AlXIhWZ5GNCLMsmgo=;7:6oM5sOqgMUIH5ZCNOm2txmHiOrVGYr31vJRqZGLFroZ0/tqSUvRC7e1US370xDznPf15ivt440QOgA0yABhH4SPyP3PZarww9UJjTFOtSGfVA4sz7TKma6m1KpH2Nq30gBKUNZCITb2Eu4+Feny9cw==
x-ms-office365-filtering-correlation-id: 5102c69c-a187-433d-46c0-08d648709509
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB11261076931261EAB0C5EA60BBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(575784001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: S+7Poh8Hv1bMeLCpPa+vpPrULTp/oQ8xjKRsrRrqalgGpsqqUwGdSXxUoOcX1FrDpvJLSZXbmm8U7rVmtDydcaYLOuF2fdhSMvroBHWpxwscXRrbzTEsG6/4t7TORZHrT8sStJYaJwpWYXrIF+ik2A7xM+itTCloEangRyekEqRQK6hO3XynPKx3UQENgX8/L+fwBK6ph9qIvrkWigZH5uIgmhJHQymkYJQl1fVEAAnZVWTlNCHO8skiWmjALiRqGo0tSERqx17kngA6cFm4YLXy1XVUxmrZyZpsa40Zt0XBEWwuYOytgx+7PkCX2aZzpOSIgrtZUvt7aXlhP6yNSEsonJEJ+CrshvIkkvyjs8s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5102c69c-a187-433d-46c0-08d648709509
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:29.9689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
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
index b2e1ab5adb64..05b8cfea5f9f 100644
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

