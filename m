Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E83C43444
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA94E2070C
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ouZkzBf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfACHqo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:46:44 -0500
Received: from mail-eopbgr780125.outbound.protection.outlook.com ([40.107.78.125]:10254
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730219AbfACHqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 02:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxyvC1zhhpclEGLEkE8/vmfhIO2NYpFpWbMbqR/602M=;
 b=ouZkzBf1Su/gUCKjMux1skOsIWInPx4V8h6toKJ//pG32o4gCoNnFXug0W6bxEGpX1D2w6YJ+XjwjmWb7J8q9gb+g1XgTXhfpcjG6vu5GESDsanrXF8BIM8TDz/QW5iam1ISUtwouervOq2TyTirBT6SRLhAu7D4coIx9obsOGw=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5177.namprd06.prod.outlook.com (20.178.25.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Thu, 3 Jan 2019 07:46:38 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Thu, 3 Jan 2019
 07:46:38 +0000
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
Subject: [PATCH 0/2] brcmfmac: wake on wireless LAN changes
Thread-Topic: [PATCH 0/2] brcmfmac: wake on wireless LAN changes
Thread-Index: AQHUozh1G8F2eN0+UEa0Lr26Fkt/Vg==
Date:   Thu, 3 Jan 2019 07:46:38 +0000
Message-ID: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To DM6PR06MB5804.namprd06.prod.outlook.com (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5177;6:t9TOzYvTd+dnbVASLyWEh+aIDljqUnigkx9mg43yQjp8wv00ntsEJrqs9XozCDHdsqAVWVX11v4mqfq7+iIt1+thqqDGjEsao4MeXziN1l/mbMcZC2nCfWMghkRewwPH+xpRWGcgqthWs3kUdpODJn5KnAWSQjIbWApqZKpDAYNmDafgV4wR16iQ0O4Fi/8qbjNILBQmm0fGO5PL77bThiJg4MroSz3CmtfMjkqHHH9FBwHoJ4drBgPuhelpx2/QK62jBiGyfaMsbq3U+ktXf/KBL6yEBGZRfEQxL2snImYYRmBLO+LEBc5wZxca1AjjPKR9FQ5I9BAfqZMLuSHyVkT24dWH1LpYdOhefJWPoIJ3lGUMQAFJPPMSdnlzSP0gkHWc7ma2YXglyWZOR1Deaiq6zoTMy6LFw+RUX779YvVii8uqWDRsUcmeKHENtskdYPt3KciVXZ+xjhwkVHvrrQ==;5:g6pUopQkVmj3OC+Cdmtxrqbm6rNsLvzarKNFAZ9NXW4XchKBGnhDV0zdUcAYmebDSwf375XkGGDbmk0x55RASNk4yEfkrhvwZ9cddrxfRrdI4yIhj9btddyzNXZqfOkotA5sUHtUAxS/amDVDykdENlMklN/3oTTo50zp/G+vwG1Qr/LDX75yLumA+aORUMpUDMH3FZP94T0tHSci2vOyQ==;7:hXzzL1AL/3mSkEQ7XZrlCpS6J88OH3z6dQqzkbGHJDoMapm+Bs+sq9H23MFmPjGlzDPiT6hqp+WaxBhUDcxt4N3+PAJNcythQ/QYdWmaWelIqcsYOxK11bo6T4cFBjEJACXKmzpdexVzQJwih910/g==
x-ms-office365-filtering-correlation-id: 26f9e62a-9156-4b5a-d553-08d6714f9796
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5177;
x-ms-traffictypediagnostic: DM6PR06MB5177:
x-microsoft-antispam-prvs: <DM6PR06MB51779FD3E6D9795357D82A88BB8D0@DM6PR06MB5177.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5177;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5177;
x-forefront-prvs: 0906E83A25
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(71200400001)(71190400001)(256004)(26005)(186003)(6512007)(478600001)(53936002)(305945005)(105586002)(8936002)(106356001)(2906002)(102836004)(6486002)(8676002)(7736002)(72206003)(52116002)(14444005)(81166006)(81156014)(2501003)(99286004)(68736007)(86362001)(2351001)(6506007)(14454004)(386003)(3846002)(6116002)(486006)(107886003)(54906003)(97736004)(316002)(2616005)(476003)(6916009)(4326008)(5660300001)(6436002)(25786009)(5640700003)(36756003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5177;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5PISHyC/grYKLFjLgYiHoOu2zvm2p3l6OIHBMOQkcSbZXhP6cChUPW6ryVKBgYgo1LpBUF50wDjpXXiddnBMEpDVSEt6npojn8psZudLjBZOgYvY+6en1+8DzSgEZ4vuCb/mlH4hcgFb2UV12d06lxqRTiR0TuRWKPflrgmBxB21HWGSi5Wtq12aa5yesm/oNd/LwjwrjrRoTLtZuDgb+mvsTGLWaSDn7WwUQQ1kHhG4/AVZXWqTaGCmg6Y+TTRJ1O+KE6O19jTYo1sGjGZ0D6T2PHfUGrzuNGjrQ7Vm0vC9xfilBVKeHtYtgn8aJ/iv
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f9e62a-9156-4b5a-d553-08d6714f9796
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2019 07:46:38.3826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5177
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix a wowl supsend issue and add wake on ping support.

Lo-Hsiang Lo (2):
  brcmfmac: fix system warning message during wowl suspend
  brcmfmac: support wake on ping packet

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  36 ++++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 175 +++++++++++++++++=
++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   9 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  13 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |   5 +
 7 files changed, 252 insertions(+), 8 deletions(-)

--=20
2.1.0

