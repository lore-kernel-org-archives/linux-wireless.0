Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8780BC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F81020818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="QpW7hOqE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F81020818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbeKFNOA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:14:00 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387399AbeKFNN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eepCyueO8pUDUBiCrq8oJDtlrs5aZj1eP4psI20Kl2Y=;
 b=QpW7hOqEoII9dRWTZ8gANLMXOkIDfIzfFUlA+OfiSnysO3hH4SPKCB06AKGaTjcAeTi+0c4AK1BpKN2Yt9Kwi1Sfhl0TrjCRj1CEcVs8aJtKRiWf3SHwfARKQNTPazWxv8k8mLcSx13mON1k7BxSyzyr7iPzEoOgCSkdQROk+uc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:28 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:27 +0000
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
Subject: [PATCH 09/11] brcmfmac: disable command decode in sdio_aos for
 43012/4339/4345
Thread-Topic: [PATCH 09/11] brcmfmac: disable command decode in sdio_aos for
 43012/4339/4345
Thread-Index: AQHUdYPbfs+uENghqUGMJLzsV/mFyQ==
Date:   Tue, 6 Nov 2018 03:50:27 +0000
Message-ID: <1541476188-75475-10-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:sPheQMNPshBz/Z/hIdh6QMAFIe/NeRzH62HAlpooq/Vd7zspCtHhX27MUfJqA0Wmh46y3+NkTe7esfktjU17rIFCvVzPinFb4fI1N9MWl0KKqX84scStigrE9nzyWEA6ovrWWSXJOJ6goDmyKwweAMrBoGZuOKX7ygi5VLcwskWB0npK9wlEUxR5MRLHKk+G3k/euP48VW7MpjvgLLvk58jK4fiHrDrRSnf4hABQ8rvvabueRzgxQP3t5AzVw71fvGg1OVjTHFSk+Av5ORIMtxM4TUdblNpxsXG+fk9fdjLppcgTtz6EacnzJPhkJX2igINhU3uOTHCYTOSM8Nl0m10bpwfPp/ZGscgvLy3swbewgZjXC/kecWIAyGQMOsL+DyFoWAMDIwuRWkcgl/kS7rHwfJTcRaulE/OENmeOiRiqM+WE56I+l+nfQfjU5hcT9BelwFRZHTy0SDk5Yia8lg==;5:MQoIdrh6A2VWpPt6lAW8eSlr6tpmK9Q7+Mk6IZKJelEYzwmJGWnCUxUwNdoz1LObVLVR2RG8z2gZ7bJVCPhbbg58XPNs0p/iY3Fu6Hm/+SlsVSAWQgoF063lHXPg7+B9XOocp17ezq50Cp7KbgwoNjhlLR/4NGrC0NeBOoalgR4=;7:cc+4qHKwTV4zMcwxZ0/8ZSwUiz2tkVSMtwhB18+MFyE3QYzrU7S9WwaVFkT0mL7gB6P8FnFOU7jIAMXopRSCAtTeDPQ7orxOiFlKlykxo1TwNfGH6vKZ4LoHEPVsKExfMPmsS24Fb2y6E/CNB8r0Fg==
x-ms-office365-filtering-correlation-id: 2735d3bd-089d-4b32-9bd1-08d6439afd4e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB11420BF103D9ECE0714F551CBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(551934003)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 2V9f94mjmPEw4qMnR5vOHD2LcoLgD8oaBx6qtOWxD7eKEsYDQhBHGMPk9FyZo3j9A+YOtAu7V3pPsXEQehgtqPeQpmTkN02bTugocHqLlOFp2oGd1OjYx3ytHL/Wn1Y1hPKdpdhRqh5OBEN9i0Z5IMJnuO2FhApIY1IM0MOK4jCpNDs6wKXFyQ+H0+DUsvMqpIH7BBCpLET6pdN0EyMfwMnw/LrF+8hIRtmfteS2x8G6HsnqmZRXxqE3NAHB7wLXyyQLGcFFdkt0vyaacPL0hdFG/AxlzmEDcSXWkhl9Mr5Imi9CjOpTWj+JjqdF4R8aXRBElDDynxmcivrxdfuLBNVcmXIxipv+uk6SpueuE4w=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2735d3bd-089d-4b32-9bd1-08d6439afd4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:27.8249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

Transaction between AOS and SDIOD is not protected, and if cmd 52
received in AOS and in the middle of response state changed from AOS to
SDIOD, response is corrupted and it causes to SDIO Host controller to
hang.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e7ee144dc5dd..d507d8f15e48 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3363,15 +3363,21 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *b=
us)
=20
 	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID) {
 		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT;
-		cardcap =3D SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
 		chipclkcsr =3D SBSDIO_HT_AVAIL_REQ;
 	} else {
 		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
-		cardcap =3D (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
-				   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
 		chipclkcsr =3D SBSDIO_FORCE_HT;
 	}
=20
+	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4339_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4345_CHIP_ID) {
+		cardcap =3D SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
+	} else {
+		cardcap =3D (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
+			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
+	}
+
 	val =3D brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
--=20
2.1.0

