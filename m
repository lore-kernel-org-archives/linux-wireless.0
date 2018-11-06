Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1763EC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9ABC20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="JPbJMnZ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9ABC20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbeKFNOC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:14:02 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387424AbeKFNOB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roAoqktUhhieQRak5XtvAeJL0PLeaCr4HYATWCPlm40=;
 b=JPbJMnZ9IFJqYhEgPKG3P5TwGiToHUzUCDHWpQT6Dv1YaxU9ukx6QV2zK5Crexv2h+p8BE6cp7IXQFaGqDq3osDw7lW+JYTQ4GOFi4VkRMXAb/Xkn/IrlKP8McVjlQ2hr3BXmMpBKRGPCLJwgat+ji5vOMQk7vwP1HXCL+6BCiE=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:29 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:29 +0000
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
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 10/11] brcmfmac: disable command decode in sdio_aos for 4354
Thread-Topic: [PATCH 10/11] brcmfmac: disable command decode in sdio_aos for
 4354
Thread-Index: AQHUdYPcfkO8Gpmxg0q2JuypnIiaGA==
Date:   Tue, 6 Nov 2018 03:50:29 +0000
Message-ID: <1541476188-75475-11-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:bB4XMQJFosToS/g9kuTl0lYKJgxhNSfJpOfYKxbVs6p8mPPHm1VQTskbd4lbFn6J/DFdMc5/W5zLPUzAfeWxm7BYCTVsNU4I0hPD3MjEJ++ziHIHlvzkcp7bGivvsBPgc7at5f7PLupofNX9vEGoezXKCPxUjgT90w+AIGxhkLX6qO0uTtiwqhKEmRujOVQWf3OLcPqGz7Emdn+g1/gj30lzbekZLIuMNgAt3Vm6MWa5UY5bpyhNXITGCWpCuOj8Rh/BXJ97rNqGGb/oyksAdB6H0dRWDi5T3fsUHZnCTV7fbGhOBZtQIUAJf6NewEVbu9mUCf8cHHrTPLDFV36CAOb5uKZmEEmgL03QkaK9rWHoHmm+ylyIsAmJITY2fhklNBBL+VLmO53KMDNYPs7xFZ8Y5o1CLbCGPs6vTx6nk9ZuoqpXsENab3gIl59TYc/Cdjr3g3KU+FHuJgVMZ3AFNw==;5:0qk2IZ4o/hWdURqcPFALyUVE9vYfmBoegqtewaG/H253Ydb0M/wdaGUH1H1A7vFcpbqurTXZMh2VxTDAA5ZVSzX9KaQ3k6TjiMInARAKHZV4BLP9YV1Vosk5mgWQ9KSSZUI7wNaQpHSlQ6ZHNXmgQU6EKq9yCqh9uS4f1SfSNbU=;7:m+N37t4K8sXK4YA4o4CyrnABVydxGaQQInzyF+alkYy5Fi2QNRFZLbv6u8vNv7CGfC3EjYh6a7+qcSfQDSklul+e7R+vd5CG65UVfaxQLs8DwCNCMrxDrLLsCVqtiw6sbiEl5aroADxd6pMK1bYlxA==
x-ms-office365-filtering-correlation-id: 4b8d0cbb-0b2f-48ae-95b6-08d6439afe3f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB11429F4D9536CC1FA5577C29BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(551934003)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(14444005)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: YZeqepXn04DIKMjS46hamahvNle1ElSsappHcVO7PXKz34xx5qco7n7nJ1uXssFqiEvOFXtJSI6PXt11kWTeA0mj3RMBip8B1rMt8U/67vjGYoRZDShlvs1pcRPmv+tq2ZOi+lbUilqpeTp13Y4ShNtu+b9mYbP9iW20QF/ZJqQAJb5tntf5kBe16blqFvLWbqE65gNqBBnVB19IxPf6jWApdF40LEezeAuscyZiSD7FKrDRBqvSfalEUyS0z3LCJmR1OKuJuPy0g+ucIagAkyHIEsg0l098YY668Dd9k7t4cblbhxTgBuJ+5XJWk1fQ+9XdxuzESZwHryc7wFEWcHfK6EdTfefudviKIXeol1w=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8d0cbb-0b2f-48ae-95b6-08d6439afe3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:29.4042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Double Lo <double.lo@cypress.com>

Transaction between AOS and SDIOD is not protected, and if cmd 52
received in AOS and in the middle of response state changed from AOS to
SDIOD, response is corrupted and it causes to SDIO Host controller to
hang.

Signed-off-by: Double Lo <double.lo@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index d507d8f15e48..337e72b7787c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3371,7 +3371,8 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
)
=20
 	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID ||
 	    bus->ci->chip =3D=3D BRCM_CC_4339_CHIP_ID ||
-	    bus->ci->chip =3D=3D BRCM_CC_4345_CHIP_ID) {
+	    bus->ci->chip =3D=3D BRCM_CC_4345_CHIP_ID ||
+	    bus->ci->chip =3D=3D BRCM_CC_4354_CHIP_ID) {
 		cardcap =3D SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
 	} else {
 		cardcap =3D (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
--=20
2.1.0

