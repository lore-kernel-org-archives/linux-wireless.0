Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA2FC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6829321722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:30:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="IMzyJ3Mm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6829321722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeKLRWF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:22:05 -0500
Received: from mail-eopbgr720108.outbound.protection.outlook.com ([40.107.72.108]:21856
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727090AbeKLRWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODll1bNPEx6nnAWdPNxxeUfNx7WQz4dZMSIdzbpAaVM=;
 b=IMzyJ3MmxGu3mChLU+xggq/DG9B0YEmSiDRad9S62qaVwQJQ9RAgQNe+uYg6ukLkDBpMmRiiheSjxxF5KBYfoUuuHxrTIKl6nxEu5r/QFi4SztOyhuzUFk4Op3BRiZEgyxGNgfO8WL8u5pju3oVxXsFzjcB5czQYZAw7Hde1NYc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1269.namprd06.prod.outlook.com (10.161.205.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.32; Mon, 12 Nov 2018 07:30:01 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:30:01 +0000
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
Subject: [PATCH V2 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Topic: [PATCH V2 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Index: AQHUelmF2vP3kzbp0k6zZArwSuxTeQ==
Date:   Mon, 12 Nov 2018 07:30:01 +0000
Message-ID: <1542007730-47284-9-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1269;6:2uSZ+2iNcCXD326w6epPB3+uTCvQjPnb2JsLbslFid6q/SmxLrmelZ2e6WlcyV4WfgqJc9s6CbuI5z59LGrvsXTK/tWjaBFJue0GMy1eL4ABoAZRT4U45TSzPTiHOCpgr/87nSqBHmFMtOU+COq3qDjNJLOBF74bNSMvpEkWmbeM28MgF2LVh8lEZc2/Yp36Gs7EY5pdltWKPVIJ6cNrYh5fvpRCnuagwgDmuZDSmLDVY6iAl1spuRFTsLXYqGxgBCa0zVGqymed0ZqoIUL4w6UUUibscU9zxE6zi0WaQe5IoeJuZve/RFResJaICkZ5HznOhL0pte6CUu0I7Yfx47KnwhYMWhAqUq3a8dNJRwxuRP1Rh4v36XyVev5YYR2qRXQUyxSK3ZLohP93yPiuaWsFz0bqNaH2KlAUMPRHyrzna/JTpOTKWzDrHT5fKvi4wra9ocjL7CStIEBkUC1+Qg==;5:nxRlDtUOn2S1d5sWMRVj9dV2AbcVV3Ur+CsqlhEv0fANZkn8l7MbCTEzx5wRPTbJvXUwIf7hd8vPgxcy8kPbEARpCxY1KUbcr5nNQlpynyjcrg5clbnru2ofzd4GBa1O/1KvITVedLIz5aZfn7X/rzAGuBfJNNC1XntwymgQHS4=;7:jo8bgv2YUXxLeqGpWV5ECHO3C5ZjJ9NQFoYA/TlMiE85/2tV3L/WSRes/Qb9u7KmgkyhQWbmzqguhQ2H8e/DCCMMsogjncAMAHGHbB026jfTMzzM/Lz0Jxc7krEZxexm16YYwLBbCQ/IWuJtQfJrMg==
x-ms-office365-filtering-correlation-id: f40b6478-09e7-4164-019e-08d64870a7cb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1269;
x-ms-traffictypediagnostic: BY1PR0601MB1269:
x-microsoft-antispam-prvs: <BY1PR0601MB12690ECB3125F1E3E230DFB2BBC10@BY1PR0601MB1269.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105112)(10201501046)(3002001)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1269;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1269;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(346002)(39850400004)(136003)(396003)(376002)(189003)(199004)(72206003)(2906002)(76176011)(446003)(6916009)(6486002)(8936002)(478600001)(14454004)(11346002)(81156014)(66066001)(5660300001)(81166006)(7736002)(68736007)(2501003)(52116002)(86362001)(54906003)(305945005)(316002)(8676002)(2351001)(26005)(71200400001)(2616005)(186003)(6512007)(476003)(71190400001)(486006)(6436002)(106356001)(551934003)(25786009)(5640700003)(97736004)(4326008)(102836004)(386003)(105586002)(6506007)(256004)(14444005)(99286004)(107886003)(3846002)(6116002)(2900100001)(36756003)(53936002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1269;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ZkOowNcKrjGyswkWuBSpKr4pIfSA0LBwrEd83sccz8FSlyX2vSfgE55xEH+7cbNHIc4iENtZEHpaJwA+V1Qls0HLI+KJv2IHFyc4L2Ot8CnYrxXXj55BiBfJpvqW6gi56v/h1tQ6NsOK9UMfatgp+CVQobx1bPl5uegrEOD8YnBnExhdPQDakciGKgwgDKqkRBm6Z/pRLBvc9PErHg/clnF8RUfYIsCyapL0RydifrJKPE7b3dKSGEmqJ2sNpzBFkyA2+qLjn0lUfisGWaR5qlMlDt9kPsZImb9+ht0r4/rJ4dEtGdxtk1KhCZaRiVwabY2NgvAHIYaUwSL7JO0qkQGcjOXFxE5usdlXM1U0sPo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40b6478-09e7-4164-019e-08d64870a7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:30:01.6757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1269
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
index e1708e297d07..e5f487b37c5a 100644
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

