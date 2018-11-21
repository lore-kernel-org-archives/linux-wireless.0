Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6A9C43610
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028F221479
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="SrqBkkAT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 028F221479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbeKURag (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:36 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbeKURaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qay0aFW/E2FYhElg8U8JOaHkpaO+VZRJJs5m0wcZq7Y=;
 b=SrqBkkATrhZrWuj4BM4dtMfbUTzJ3y3WRu5wV9oeTlPhgi3ABRpI6VbNo87YX5Iouj4eXFkVpJeX2pChYBubJLKWHw3F1B9d3Y8RjgGfqwp9PYEQt1NMabxQtCnGLcPBlar0Yg1XWiPUZNtu1hq2o42t75t7Hr2F5C27N7wGwRE=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:12 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:12 +0000
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
Subject: [PATCH 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Topic: [PATCH 2/8] brcmfmac: set F2 watermark to 256 for 4373
Thread-Index: AQHUgWdtX+mmoAMk2ECKmfTuPtgzMg==
Date:   Wed, 21 Nov 2018 06:57:12 +0000
Message-ID: <1542783402-112482-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:+AOvCjvYNqO2T+ECjaCa0wB/K44sefbC/9z8fPX5WMtfgHuFeolWkGkl+BkzBX2XvIyldwWkj81fOmaH9JbxdNI7klczUVX13k71k6lGrD2oQAdRSSI7zgF4OzvkchFHGBx9gQ7MClRbpyo77eX5yaAi6CeiLEFbzGYpkTwIHVcMVE80NKoIYUdvO2uYdtug5A98Ss/qWEuWx+7lMy1fVYnvJfi68e/OguwheZdcMpby0ymQF59yWYE46T5ONg+KD8+EuEnPt1dz//GfkxJINxXtAaGBBORf1ftE96P4HCAVVLT+BdRmaLZ5FlVchWA7xrp+BoYUEC4ybczqF+RhnOf5WuAXFa2T5v5koS8Pd9cEc+cLxCHC9UFEE19CsNWX0AqhCHn3w8dK9n5+cEdVHQ5KEjAlG++R7Kue5F58v5scQ+I3edwK9BiCsb4DhfudDnM/Dd5mdxyjY7WFfuREsQ==;5:O8v9haddgyrlaRx3x0dcsUZ850yxC/whGm4NZuRFIwy6ArmIWF1vHDsaXaBg9c4LmRImlCPVHnNw5LDYPbpOD6ZSB8QjldoynFW31yx8h8WvPy/mi/NwGrSTLFLb9NrMrAsVQdspKwlaNXtzGcBzc/xMfhbyUHaQaJ1fs5prvEI=;7:rbxOrdXklpZ/yUXeG6v7x9aFqHwIFntb7RE6JK16xO++RYDkSqah6IQVPNl0ufN0miLymW+4fpZ9eSQxGUtYEm2FcznFZGm0wVTnwwXRmmsb8WV4TU4aYP8G3tMO2SzlHulcHpCovJ8XvZeww3qRcw==
x-ms-office365-filtering-correlation-id: 5511a944-e308-49f8-efdb-08d64f7e8fed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB13492A92262A45F5B665E4DCBBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(575784001)(6116002)(256004)(476003)(105586002)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: /LTT7Ionr95HCif0HpVEtO1ipkUTvkufiRBPNN3869xhhM3ZMOVehtt5DgghcL0fXDOuY3qK7XrSbin8Dxvgo19tgm9n5tVlZIDQSFKMDYdyZ7J06oANU/PtIhKZjD6H4MLsZlKzh1q8gqY+/jLNgRxkzikIOer4dJK09f8YqlaXTQAUtDIqnScQVeXRtQgZj1yQFFQA5qyaRDmzlCkn2UtBV8oFHJ9+reeqt8PvjsIBgB0ReO1fELWm7UzUgfmolmgsZWnTd8Na8EtavuJ8AVmo4KHp7/4FPw9Cw5D0f+EJhEK6luCnAawbPga4yGgRqp7z0ByTuiNXKk6eyWvbGNPr4JKgUywcb4V3uAERZQs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5511a944-e308-49f8-efdb-08d64f7e8fed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:12.5275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
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

