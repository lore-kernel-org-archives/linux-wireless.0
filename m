Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE64BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D85720645
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 06:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="mbnX4jGO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D85720645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbeKURad (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 12:30:33 -0500
Received: from mail-eopbgr680102.outbound.protection.outlook.com ([40.107.68.102]:59472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbeKURad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 12:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZB5+HKjpd7ENpeLO9xO5P3K+IGlNSIjtHY9Nyf5/sI=;
 b=mbnX4jGOSXUEzAGd461J+l6TXSUohctyOlhIv25bu2CIfgAk6oCKUswnD5ZZZl6ESokgrksdAT0WoGZbXNQIO+a4YWX9OSEJaItki7BChlac5jJVhHFPF8QtwNZuX/tVCcXIj8tvoiFkoEQikkPLA0DCmGRr9QXG6cqu2pOaofo=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1349.namprd06.prod.outlook.com (10.161.206.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.15; Wed, 21 Nov 2018 06:57:10 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 06:57:10 +0000
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
Subject: [PATCH 0/8] brcmfmac: chip related changes
Thread-Topic: [PATCH 0/8] brcmfmac: chip related changes
Thread-Index: AQHUgWdsCKxqRYAzHkSyCSO6j1Jarg==
Date:   Wed, 21 Nov 2018 06:57:09 +0000
Message-ID: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1349;6:3ajegesqB8r4UocCYvdX0aUBDxyfwqf3jqqvnmI7ErH9GpuasueyMKe30KWudOQc2740CEGIYcbiZ7a9rewjMOjhKBccnYVQwkhZ709LwYUkJd29+wqyNk52i9tnILghhDhl1vcQJRRFjigyAwZmcpeD52Z4IpkKZe3HSLmBteMGkpOZ0M93lmqxWMSzsWauny+sKvX5sp9fWysfoga/gE2ZspujDdNoce5w0SBGAh2Ur8tAoM7/9bwpIEaSlBaJ4zzAVUCBlRzn1iUYh5s2WCcu9AuhiBWsyI2Yji6VSvgnH/1ZCORtaTprFCamzpqv1qEj+tOmv0hpHnt1dxkZZpcGeHsoCHDwMAvUlYG1sRUQjzuWXZyfTKpqiCVxWUCqHzyhSkIpGz4sECXqYeuJnEo98L/OFVB27iSn08W2al+eUERR5zNbVszLIpjR8ncOp3tC0mUg8ieGfb0KAIGseQ==;5:iY/rU82WB0aPo28/2/reEP8GEYoU7eJeQ/mP2ZYRJ4wU/3Pbrz1Q5QNgwHK/Lg6KFBLMSXS5wb0ul0f0U3Irspd9o/c86tSxwXOE8QH+7XqGO5FN7t0R5UFNB5Hc2er2scgun+uX95ONPYK0grgPgzJUTSYCIIC3H41PsspY4jY=;7:5VxBMrdQq/7ptlddMOZmEB3OWYBSX3HjnY81VbXIVGh6YRnSkyW7mAyIIadoI3/r9aI75Invm67Q+h6Syf6AbWRtiywvtf96rbDHCtEHcgJvWDlfhYfXi9VlFGXTKkEcCsp3mvGCTEiZHnpdboh0yw==
x-ms-office365-filtering-correlation-id: 833be401-6355-469d-c363-08d64f7e8e5f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1349;
x-ms-traffictypediagnostic: BY1PR0601MB1349:
x-microsoft-antispam-prvs: <BY1PR0601MB1349D602259A436A922AF8A8BBDA0@BY1PR0601MB1349.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1349;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1349;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(376002)(346002)(136003)(54534003)(199004)(189003)(26005)(36756003)(107886003)(6506007)(8676002)(386003)(2501003)(4326008)(186003)(8936002)(2900100001)(68736007)(6916009)(71190400001)(71200400001)(99286004)(53936002)(52116002)(81156014)(81166006)(14454004)(102836004)(6512007)(6436002)(5660300001)(486006)(5640700003)(316002)(478600001)(6486002)(2351001)(54906003)(97736004)(86362001)(2616005)(106356001)(66066001)(25786009)(7736002)(305945005)(14444005)(105586002)(2906002)(3846002)(72206003)(256004)(476003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1349;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 6Ac6BiZKz486vWQMDi6Qez7mC5icSqrG9a0C0UlMp2HtR9HJsurlIQY91OFUL4UR0ENOCEnYfZ4RCx/1tf2012bscQ6g1iEQPfEgbw32vbqiineY/1yFP0VTVq/oA2yxl7pTxHfieCAPliXaOd5GpDliQpSO6Kt6WgdNlOIsQs8Abrdr80q5qSnbh/g1SPQIIsePCNCrzJJiwSrfD/cUsxeMq6Qsx6BEbxqG4mqFmvpJGY27dHD+mWksBMXcD26bRe1PwRtGbt5XL4CIQkvHQX+tIGFXU9MXjYXsw6WvFpINglfztp6wVff5pBTJwcvXwgQV6lzU0k7Z55Jp3crvvqbvsgH9SvYK6Ktk2rvC5wo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833be401-6355-469d-c363-08d64f7e8e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 06:57:09.9649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1349
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series includes various chip-related changes:
* 43012 support
* 4373 saverestore support
* SDIO bus settings
* 4354 raw chipid

Changelog:
V3:
 - Update comments for patch 3.
 - Add defines for sr_control0 register bits in patch 7.
V2:
 - Update commit message for patch 1.
 - Update comments for patch 2.
 - Remove CY_4373_F1_MESBUSYCTRL from patch 3.
 - Collapse patch 6 (43102 sr support) in 4 (43012 support). Add helper fun=
ctions.
 - Remove sr_eng_en variable from patch 8.
 - Collapse patch 10 and 11 in 9 (sdio_aos disable).

Chi-Hsien Lin (3):
  brcmfmac: add support for CYW43012 SDIO chipset
  brcmfmac: allow GCI core enumuration
  brcmfmac: 4373 save-restore support

Madhan Mohan R (1):
  brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373

Naveen Gupta (1):
  brcmfmac: update 43012 F2 watermark setting to fix DMA Error during
    UDP RX Traffic

Winnie Chang (1):
  brcmfmac: add 4354 raw pcie device id

Wright Feng (2):
  brcmfmac: set F2 watermark to 256 for 4373
  brcmfmac: disable command decode in sdio_aos

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  33 ++++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 119 +++++++++++++++++=
+---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   9 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 .../broadcom/brcm80211/include/chipcommon.h        |  25 +++++
 include/linux/mmc/sdio_ids.h                       |   1 +
 8 files changed, 169 insertions(+), 22 deletions(-)

--=20
2.1.0

