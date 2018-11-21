Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFA6C43610
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA96920672
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="yI7OJ8su"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA96920672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbeKURas (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:48 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbeKURas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4wbt8nBICgbIJl+8dzvXaFtziMJUVtADxNgY2mnx/0=;
 b=yI7OJ8suHqI6PfNG2QtrImA9vyHtVrrjkOtOP0GQfkESwe2F0H/Th1Ek3VOouFdgTXJvgfiSyzPzNyc2dPS8MuZMilXrqfkr3Iz6Q65q1J6Tgfhj9r/o3ds36wXadVr9OECz3A5FO/7QTI5j6Gxbalkmg/TzdbrX9X51aVIchGc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:20 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:20 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Topic: [PATCH 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Index: AQHUgWdyJ4Ei3/WUTEGUmo+sob9JZg==
Date:   Wed, 21 Nov 2018 06:57:20 +0000
Message-ID: <1542783402-112482-9-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:ZFZECARA8mQuCFs9KhpztO6UnpC8S1yuqBm55asZyQuhiXK744p48yQWIV3I9HbJoIGVMGf1OOpzWFWpCLrsIl77uf85XHG+7LpxJSLhA0bFhOJmiwMo2xxdZteLSbZUkGEjWDF8XghdIuiKYcXAmQOjFIt4DsEPC6sFvDvv7Xjz1ESI8vl59PKL+XeKCnzAibUXWeuxpUoRH5VI+zd8W1q8KZWDX2PF4BP7559ZQXtGjwziIuoGv32D0YFmrlONvgLQp0DL9r14tIeetKFfbUsKE4LOm33eP52CD2lYjPkWQ8/kXimyGWGmv9ItHERHeV/gbGu18Sl/Vk+YX5zh74TtNpfXVwtXFsGF8KjY+X2aFuCDqeEMuLC/R19vHtYR33mw8MweyRGmDTlT8cdMNVt5ufMm/OE5n2NygMkwHOTJFbeMunHoJY/wmNqJVdMSog1zyyc1cAbV9bmdIhqZhg==;5:AQ9r14jt2aPS5QbOVm3h2vQd2LYXbOVyj0mf/ms5ztLBzrzRTglzU0bgTxiYp6bXTZepVlRk+UerZtarlqt2EwFqiTJsaHRPFr5f7wcwm8H8yF8g3SGFlsphO8u5YNxgjSFoWs4qHcYxMImhlTPLhCR867A/AcWsUKl6b0mC/z8=;7:hYWFNwg2nHyrog2DwxIBKdaOnNhnzhZ2sMhPE7gfnCK5DxWG1MNM7JUETCRwk6DWXF2G1BGBHgut43E3sNNqPH4IwW/L/hUm3LNjQ5YXloV2Z0Vd+wtV22kg/scf+APObDeWNExPDNN5q5pT4BMj5g==
x-ms-office365-filtering-correlation-id: 958d6b5e-d6b0-4c50-fed8-08d64f7e94a1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB1349EFE4653C0C50A8326BA8BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(5640700003)(446003)(478600001)(316002)(54906003)(97736004)(6486002)(2351001)(6436002)(6512007)(486006)(5660300001)(86362001)(575784001)(6116002)(256004)(476003)(105586002)(14444005)(3846002)(72206003)(2906002)(11346002)(106356001)(2616005)(25786009)(305945005)(7736002)(66066001)(2900100001)(76176011)(6916009)(68736007)(107886003)(26005)(36756003)(6506007)(8676002)(186003)(8936002)(2501003)(386003)(4326008)(14454004)(102836004)(81166006)(81156014)(71190400001)(71200400001)(99286004)(551934003)(53936002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: jRG8CXws0ZvJa9y+uu6oSUDBOs/hm1HUSs/acb4u/EeUYPMudeuDP1DpjVHDOrvdiZXTkIWtUJ01bjnBZlkce7E70XzHUIT6Hg8QJjqWhS83p5CIuSAk8Z2LyymTb4d1RjxRNmJf7h63Ym0BKlZ5Z1Vch248os4VgMZIYkwgjF5NlCOQnvcSYnj1VabQ0/ilTdSriIOkSczXp4jo0I/Ka8/3QlPwuJK0fXpI6zZBWX5EPMNV6qiwBD4bDzBu2mhPKys6FRwoGyZR+LXXOEfrfnYxYNJ7SGfA93GBjXmyobtNQC2JY2hMZ2TEjSiXeO1gc/y8dS42FKDOCU4kwSmWUqA9hdAIbJ6z8rFhW9/z/zk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958d6b5e-d6b0-4c50-fed8-08d64f7e94a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:20.2778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

AOS is a part of the SDIOD core that becomes active when the rest of
SDIOD is sleeping to keep SDIO bus alive responding to reduced set of
commands.

Transaction between AOS and SDIOD is not protected, and if cmd 52 is
received in AOS and in the middle of response state changed from AOS to
SDIOD, response is corrupted and it causes to SDIO Host controller to
hang.

Command decode for below chips are disabled in this commit:
 - 4339
 - 4345
 - 4354
 - 4373

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Double Lo <double.lo@cypress.com>
Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fe0cb398ab44..0cd5b8d970d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3354,7 +3354,11 @@ static int brcmf_sdio_download_firmware(struct brcmf=
_sdio *bus,
=20
 static bool brcmf_sdio_aos_no_decode(struct brcmf_sdio *bus)
 {
-	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID)
+	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID ||
+	    bus->ci->chip =3D=3D CY_CC_4373_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4339_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4345_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4354_CHIP_ID)
 		return true;
 	else
 		return false;
--=20
2.1.0

