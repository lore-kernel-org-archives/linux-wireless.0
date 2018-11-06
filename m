Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74C2C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE29520818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="LoGBklry"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE29520818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387475AbeKFNOL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:14:11 -0500
Received: from mail-eopbgr810101.outbound.protection.outlook.com ([40.107.81.101]:25243
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729015AbeKFNOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MivY5zgnth8b3CYfw0QoV2pqByPmAWbyALebWkhVOoo=;
 b=LoGBklryAbyD9FCcg8AY8yZzuu9c7p9nC3vqDm27UhV0zQej1fB0y0rJo3nolkLtxC7Rya9PlbbfhkGrPKTY4BjIRlrhQEm2OCtGJ6T5bkvVaokwDC1rcyzY0jqluH1lYAqPf49Sp9/Q3zwuuK9MtpSqIETQwQPpo8e2uDvl+f8=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:18 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:18 +0000
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
Subject: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUdYPVn+i9i21xekCPH9fEAxhKOQ==
Date:   Tue, 6 Nov 2018 03:50:18 +0000
Message-ID: <1541476188-75475-4-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:+gXkxoJoidZEahBcQobN4vk+9WCApKJtYMZhlIQCdoA3fOFs1lkuPwIPWGRTA7//d4oB1I0PQ8B6s+Wl0hx9K62bEZcznZaunYdh08mf1AZMgwyQke8f+Ds0wHPet/trD2TMciAc2QZaaqtX942Nt0GsGCJoO/762B/LYCpcX8G5W5S14aJZr19EVaXEIApBIyTHSqEUBkOAgH6XFph7Xy1F4pC2GrcgnQfpeNxCDoKxAznOOnfa9K8P/Q1VsNIK8bMyDIrct0++wIeUj5UnC6GZiHuRxceUQrFZkWgkS2VCsu17L5CkPzxlb6jrKf9OJCj+S2zZbDisHMbkYV4JgHCaGduu62faqrLvQCsB+GsKLSYnr4aVOVrcMMrBGHCDbnbhSbNg8G/8kankAjEaiPYPAWy+/zJbxQMRJb2EZjA+0xE0X+Ng5ECZhqdiHhJOrpqmwmzwATk6mKLGhtODyg==;5:4qx0lk9V8dI4DPWm7NvZFtUdBdtWmI/TnpwcUN6bzf8O3j4a4gA+OHfmVacC13NdUfLBmy+OdH1uDMRwCJYP2gp/dDdbRFacgVHLY9hLQDt25UD6YEcSCtZWr9DiYRfHsyBDv3GmjuFZWN0eoGNHE8BJHUPFkjRuDISVskuE+GU=;7:LMxDMiHmvTD25r44rNJoAofCs/3KnELHiLL6WQ77BUdGCgeEhuo0t9Ag2ZCJZMRBA1xhJtPGEY9CsOXNUU5KScyFrHK3hlGnXPOWjUc/I9+YKZZuvGNOlvgFV5hZryZeBU9w7P53w8rdmtnHURJgtQ==
x-ms-office365-filtering-correlation-id: 998984a3-5485-405e-5bb0-08d6439af7d3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142CF93B2A9F58146462FCFBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(14444005)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(575784001)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: W7/sTsttCKX+FLXpOFxpekB0bzKESTQ4TfDw5Kk1grMWamnDQ4fUoZlPVtaIauDEhD2uPvXEnf30kjnGhmzo+cvZaMev4df1TLMtvlNzzBTc4O1Dk9Wqnf3S+wkvt8SQQj8CAEuz3X0i4PALcdVfVprUwrHABD0A0pBlM4QYq78mDfXM0YLREaWqyd3SDUCvrMnFq/GedD/rBRjhP35hiADuqtz/xrPayEGlZdaPkQAvkxM1leiR/jRZJhwoKy+2SFRQwBIzspfoW4YCbZFmEDHzmXEUVN3M7Yvu6zkjsIIWV26/78PsShJEvQRGEfy5IKuB+NGXhfn21EHTkeI8VpBBYlTTJR9B5Dg+gMN1OCM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998984a3-5485-405e-5bb0-08d6439af7d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:18.5996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
should be enabled & configured to avoid overflow errors.

Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 541d54661c9e..34a838fcc319 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -51,6 +51,7 @@
=20
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
+#define CY_4373_F1_MESBUSYCTRL  (CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL=
_ENAB)
=20
 #ifdef DEBUG
=20
@@ -4118,6 +4119,8 @@ static void brcmf_sdio_firmware_callback(struct devic=
e *dev, int err,
 			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
 			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
 					   &err);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
+					   CY_4373_F1_MESBUSYCTRL, &err);
 			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 7faed831f07d..8aaabca1eb0e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -104,6 +104,9 @@
 #define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
 /* MesBusyCtl (rev 11) */
 #define SBSDIO_FUNC1_MESBUSYCTRL	0x1001D
+/* Enable busy capability for MES access */
+#define SBSDIO_MESBUSYCTRL_ENAB         0x80
+
 /* Sdio Core Rev 12 */
 #define SBSDIO_FUNC1_WAKEUPCTRL		0x1001E
 #define SBSDIO_FUNC1_WCTRL_ALPWAIT_MASK		0x1
--=20
2.1.0

