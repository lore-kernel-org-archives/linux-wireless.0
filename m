Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B987C04EBC
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5B820672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="IC8KJfaL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A5B820672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbeKURai (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:38 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728028AbeKURai (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z5VZ8Xr4BUy+e9vpXvu91P7emkl/xhcAUXTpfAK/nc=;
 b=IC8KJfaLwaDjF/OVRx4d/2Jj22uQO5zpPHZFeEBuyLN6Bj8AX9DNqTbZ9RrfLdRY/0s2iPkNqj8Ola8PFsKicHWYxjAn0J/AE2tWPXWrhmYg7ndOjlgqHRuRbYO8j2urDcHgvaCRDmeHOW4rPKXVTwSwrKYo6uesE6Sld1tCLIs=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:13 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:13 +0000
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
Subject: [PATCH 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUgWduAzegxe+BdUadd8FNenrb2w==
Date:   Wed, 21 Nov 2018 06:57:13 +0000
Message-ID: <1542783402-112482-4-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:Xl3nyYLP/T1CREcWDuN6ZP7F//lmHQNOKiwa3+olE9u+JwNMWIsMz+ZmnoXLAbTFh8wNpf+4oBJDLCim2wFWn/UACEmVT83HTbAsi9JjPugFAEKw20twvYhDWERGzZCI7wVxAwosUO6VzMiF4bL8xgcJIoqSSP4NA3waKIbGq13Y86mebG615uFuV76aOZuoJ/xKSX5T2TnT279eM/UidtTwwEH3SrcbHYpwJXjNHcK2x9tXCUshEgX12UPhMX/gFngyVH/XXe+giCSYpH7M6WmMOVpdVw68HBMUf9yZAldOh+SId+7YCaPSiKvNwfn3BuyaMUZ3gY5loEa9nE/+qwNBcVoBaIPT4zEti3ZaAKByAsuRyuVSO8nJlMi6HFgg2HM1qVzmqGRtiGUWjbVj6kwRJylJMsPmLHXg+HpzJFHthbq7xnS74spqYbm8KUJwYWfkKtVkwr/wNX46Yfuctw==;5:ZcetIMJucQ6RlLZCvrzcKjWjRT9KefzJzLHxZJ0ViTfs0aDXDCmW9J/OGDn8tf7BDx7rLyqtlA38YHXx/Qt31vpvAA+FmkkQkb2JOzeQnPLIorVyzS4+l6zNr/Xq/wgwpSEaVgf8rBFslQMFZWORwBKUUcKP2wSnT8Rt29OQySg=;7:4vnlKxqjNz8pnOKbpgSFD9lz4bqp2HI+FmQy709YZziOnk0FE1F/TiBUlCUW0N+U790WXlMyR6yJpICPpFRPYcePLb7skV77W/ntnoLKdzOzFjWiIcZGR7tLjjZ2GRva016M0bUcyCa1vJidi4qG4g==
x-ms-office365-filtering-correlation-id: d222c38f-7b14-4745-c0d2-08d64f7e90bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB1349BAF93492E7485A61B0C8BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(575784001)(6116002)(256004)(476003)(105586002)(14444005)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: E5g2zevdC0QVA/rozPNS8N/Vb4g0o8dUGTSapQjjCCy0VjAe/J270glvNp1wUbRRilIIoLLySUitkAldPyfKyQXgLtQHbq5zhCW8/Refm7exEU0NoODw54a1YhzspnMS6Ez9rdFF3ctC6Bc70/zQJ0SF0w5oEEnyolbk2P/1QL48ZfSVm2/Gm4uQqIG4Uk/o0p5zGU+K47diW7CoMTKk6kdbSG6WDocqsu+HTzR334SkjPqtjs4Ho/Sr64DA34zKUqiUH1KpjUkBE2x64EFVybl9dCZ3zGqH0ns514SS6bjGdlRjzxY08npvYX7+pitPpf5SXpPKaCi3snFdqqzHGzgcXVpk1q8+PYPjf5AAPsM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d222c38f-7b14-4745-c0d2-08d64f7e90bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:13.8244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
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

