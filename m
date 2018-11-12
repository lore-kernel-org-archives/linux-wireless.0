Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C723C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2700621722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="mYzRXrwM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2700621722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbeKLRVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:38 -0500
Received: from mail-eopbgr760121.outbound.protection.outlook.com ([40.107.76.121]:15339
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbeKLRVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eslWfkP/XGHrcyLrCt/dZ0vzor0cYYZUmnyWf0Qg6ek=;
 b=mYzRXrwMz8F8dRQZUdmhAojqubYl9wM18qLS0URI7gpBIbumbsUut/+nezZrfUAnEgHJki/f+nbwsHjzLuFnmuPCCaJOOQPvkGC+gcceBgThc8TRc6rPRvvYUxPqMva4DeW7GFRivjy7XyIVXM8KSL7MEqTehkEyyIK4VfWdaUE=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:35 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:35 +0000
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
Subject: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH V2 3/8] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUell27YgOaOPIa02NnIpm+Ru2HQ==
Date:   Mon, 12 Nov 2018 07:29:35 +0000
Message-ID: <1542007730-47284-4-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:t110n/0rY4ot1s1Dkyht4gVWt5dz+VWrMZHG8nYNe47xtbnxmmiwhEbFReSu8Ej7/ekDaFG7HztOhERkpeJdQmrnbsTZ4SgtXoTdlnPPkKpJX7kpT58Nw8vGAmehNgczPqJ7N7V34LhqmPg+mR5w7oXpyqvs/h6pe2k2jpRP8gHfc0HESwgwsM9yNKtT8GyLw801Pstq00ObRcc+R4fo7hMCNuTHhz1kZba7HGh31D8p+RfVYL+BEGtppgHlvNbL17Wfkmq39syLcwt+dNQhqcQnMgWEaq4eHjWiDrzcMORIDzYOjY5rJwjOcDNAXwMQCsy/RRAcHB++dwC7lRErzTsIlVjjeb43+Pu7AUME1gm4UjS7sItQsJj/aCPLXoNOyT5lMGRUdSBQgSIhri1wzxaqa0mxtssl5wdGxrqndXc+jD4RHCDVW3RLpCREnCNAaDdS58sBTI+H+PBwyI9+Vw==;5:o3qZnI1HI3Q9/rNWmlFx56Wsai6amnIuGdndUl8JxHCTsyfsbWQxr6SQzbH31JgITDS8yADUcsVUisEG0tbX9wfXOvmesWCpKLeEFRb9QV0jFUpHQhry+iVM77lR7FkrgCk41g/e8XueXLnIOHZy9TkPPomOxwPNwHVLTsL+mvI=;7:wXPPJZPlThDRxioVaeH1qX8cOgSq7YZBR2nOve6H/+Vu3qapfevpT9pxoPLJFkwE57qcCw1+P3tz7y1uPxihLU14z9y7/3xRA3rsYk4H0JlQMKUfxlA/yarqMUkAmIhSnTEGsFu8A0pwg3u2Ge9BgQ==
x-ms-office365-filtering-correlation-id: 90cdfbc5-5750-40c4-0566-08d64870985e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB11269B06035EE376F23029EABBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(14444005)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(575784001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 14f7maXit2YQP/WnhBZV+wh1EPa6Av982K7AoRdn5JvC2HguQ4CHdlH09TtIXd4mn6uaXUjcgsC1FzCwgCnjazygVa3K26AfbN0NQ+hb906Y0XS9SS+ef49+48l1FEqByqP6jdnJjBKEuxNhY0Zgmqujke4tgAHaSAfKNG9KhLs6AOcanWredtQHdykTibZV2b7ZXHtoUhJDWUimgX/PeHDKBF/JvHRFDVVfbB/RAMWxtgyw6dXzRrzQZZbHWlGVGbq2fx1jOzJOIGlVPx6mQuIi33B1eYaEr6TYvsV8oJeLhltOyftGqeuWHobldDCXMCJ5nNShJAIIwOiw0N2C4cT2VMBHvybZbVIK3uJYAlU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cdfbc5-5750-40c4-0566-08d64870985e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:35.5774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
should be enabled & configured to avoid overflow errors.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 05b8cfea5f9f..b9ec40cc7d6b 100644
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

