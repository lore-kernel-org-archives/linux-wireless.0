Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FADC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82EA22145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="TIDPqmC6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82EA22145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbeKUS1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:30 -0500
Received: from mail-eopbgr750121.outbound.protection.outlook.com ([40.107.75.121]:39472
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728351AbeKUS12 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4wbt8nBICgbIJl+8dzvXaFtziMJUVtADxNgY2mnx/0=;
 b=TIDPqmC6ABwZ5YF5N899J+CfugE7dq8Ex3zylRvRU9pS6o3uWVHxf3FSbhJsi05Z72i/+IxIlat8PgL6PUWN9apbDJ04Om4P78qbbhsRP2pW7UtiAjV4SDoxQyMyWtMXI3oXG3jERR00mKLA7Mhb7GhIwkS83dwXyLR2o+IPXS4=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:52 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:52 +0000
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
Subject: [PATCH V4 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Topic: [PATCH V4 8/8] brcmfmac: disable command decode in sdio_aos
Thread-Index: AQHUgW9Y/TqIgy+nL06omvN1haHkAw==
Date:   Wed, 21 Nov 2018 07:53:52 +0000
Message-ID: <1542786800-146083-9-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:7NAbfSqj7jl5aSKW00plkubX1mohxKWWJbv4qM/gLnaJwgV4+fe8yoLLG/EFhOHeM4jtZ28Rrthk38M/j9aBwiRGvOUCRTNb8c45DEUupHKdh5grh4NZO7N4zMtJiG3/8pKXK7X/85z4ochJuc/bYckG/uZvGBzRazs6WoDYm9V5a6lf6HrgZJXuPZIQ6wSLYOvg2fMcRkyvRPMbMHaUuB+ErpuWr/vzC9cv2LH3W7MyrWyYbjrCEzjq3uVW0sJAVFXKCsy1YyIDd+KvZLnn19CqCkscA/hc37j89RpwkJU89A1GaGAqj2+0gdjfrynfTBJYCTed8zDY/nV0N3IlyqybfvF53B3aoRZ3agX63MfSevD1gtwz7E65NZhwO8hBFCQl18RwMK1oO/7PxvwgMr679V9ac9Bg8xAk6KMo/ocdoMWA4vJ+FRk5MD05slZCCvVEh3uj3P4TuKJpw5ePCA==;5:HrUunOvDWjhcO3sXi5IuV0/zfcURODdsgYfysZGPJ7pqzpl6SmDSe/B1foF4OKMVYKCeFcNBsuyi+JlwSY+moHtCTzCHvbq4dUnsjr8EUgOp9JJbg/GqHFsbCqMsdtFpxNDiHDcP9WVcz4aoVzj+Rc2VYqEzxlvDL75ZqSgktlw=;7:v0hl7SjLlx4FGEpjB8/84+n8LRdYHA7ugqo4KjgLkzOzVlJ7/oPtnI2pJt9gvtL7mxjVgkMlcLIEc/Sp+gYQvuhW2AI5HPHFd0LdQpmPAMpMbqeRduDLOPkiLX7CQ7m/sIk3qv3sH6Hl23pdarGghw==
x-ms-office365-filtering-correlation-id: 2325c541-dd19-4591-4543-08d64f867a65
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11744E94EB50BC5982F002F7BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(551934003)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(14444005)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: pQBUnPyA7PZ/xFe3OPLs0/4R3DRdtkeHwOaFrrYbmurH4LqK7d2j1Mb+9QoPeBk+8Kvk6uUDbLZSDe/ry/guvn9eeWv5V/4UdOK/JK1tQg63t4ba9c0YPYvoyo1Md82G0J1M2/cVjA75zTWn1WZwYwlakA2cXg8J5HEyYPSwmHC9vylIDMNzQfJZKxoqdjowuc77gC17F/c+4smLHVoSvsxb+6dI9PMwpT78+AYrkYuCUZAFe4CnsAb85Vjd2JgcMGddC/6K/wHaTai6JHodjSoYjXhcrdm4yPrSVa+NO3QHqzBw+RSdqk2pbY3ReaX0M2qV/F/WvyqsxjkkDA0nIkjioDlg1m64RbIBeDmf9W4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2325c541-dd19-4591-4543-08d64f867a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:52.3110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
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

