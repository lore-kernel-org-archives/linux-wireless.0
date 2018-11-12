Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C2CC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7A721722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Ahp4mv9z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D7A721722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbeKLRVY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:24 -0500
Received: from mail-eopbgr760101.outbound.protection.outlook.com ([40.107.76.101]:14119
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vDHBPvZzJ246celr17NhBuL/x+6t0UEFU0yhVBwguw=;
 b=Ahp4mv9zlD3QyBvETrCoq/iIt+weSlw3Gmk8M7wv8Km1idZIm0UuoRrWGFXLO/1KT0C7cXJ+UFQiqZPlxweIee9hYhZa82sw0+qCB/DzUvx6TJwQzpvp0jd2mSVDlM3J/LBfaGAUOg8cUc5REYES1F2J1VOnxFRNRL+uYTsRCCk=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:20 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:20 +0000
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
Subject: [PATCH V2 0/8] brcmfmac: chip related changes
Thread-Topic: [PATCH V2 0/8] brcmfmac: chip related changes
Thread-Index: AQHUellsRLJNfPzxwkaFe1xe76lSbQ==
Date:   Mon, 12 Nov 2018 07:29:19 +0000
Message-ID: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:jQzRVbbJ3V3Zlpp3Y/Yvg+eOVojq0UD9I9ddbcmoDj4WNlP8yOSS7qHxg1bCg6E97MWyW9zrp67mVdkEbFBPOdb0OnEiYoOgpOaJ7t+hR0qE2XKPm2JcgQywG6Kc4QmoJTECzKI1upiHkAGN7SyVGImcUHV8rbMRsWC04JZ0scERXU6FYUCBOaRotbZOwmgdlQqb8bLsazXf9Mbn2mdcryfQpaHJEi8e4ceR4GndK+zPfnPAhrU106uJSuJiP3Jyvb9ESDHkvhWy6kBiIZeTMSD1uz4kMHD1kMFY2n/fu40jJl8jd7LdFDlPYhbLuG5MpZODbkM2y+V8f5s0W/zr9E/lP8HDqXxuSYiruBpRYYTfKPzc3BYT0OAhCPabEOfDrnD4wWtQhCC46UCi/Gco7H7IlM+2zWriWlMulhX427xv+zbtONg66kUjMnpaN2o+WuCxa/vTtbmSoM952EsvxA==;5:qZv5QBZskNhO+nrw9wb6jDY9ESYPsJokC3scTskBRUo3i+k59+XmQ1+aFydhgOUF8N3iYvYkfhOz0/GPMpoH9OYy9bGXxRpJZtWY/P5LEBtzWi+BxhUcSD9DB1Au+JIKyrIJN9BQ40NhHbw/KmCH8Vs15ChTZs5kpa96sOHBsiY=;7:QGiH2fyRh48nOspgsyVw9L3x9tCJ74Xa34iQ/tsD/RBAyVmkaPo8ouOI4oa3jH7krCF4TXNWO/FlPLQI6BincPDlr4dAeRHe0HhpVgBVXLKR5rH93Empgo7CivuDcfr3hllGPIfUGKPW9ixV0IIuvg==
x-ms-office365-filtering-correlation-id: 4b6fa366-6164-43b8-6f2d-08d648708f16
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB11262599B01299E7385AF1B9BBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(54534003)(189003)(199004)(25786009)(4326008)(2906002)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(14444005)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: b3OsuI5+5Dr4Bs/2k9v7XmwGFj+2X+qC/J9vcG8xflnc2S+wcW0RJG1lv6CRRuvvonfeTl6SWf05x7n9b6atDPUNnPdhwinBpw6ZcCBKxE1PHn6JpNgsgaAQqWDeRhPhT16SGStzLyK45rcjcnIcFfzYtxQa/+ufoAQFjyp4dnejB4j0ObDPLPqi4RvJfdeMjHVqnAPTfQNod3lVzDZRnoIqhe+r8llC/6DseU6oAK6dao5eOJ+mkUZ1EUnWQlKlr4c4ZOfzXukOdIbrdgNXbfvUsKG92l+gPq7pY0olhs3ySWs9UPuyyOVhY5S7IXy5CjDWbVYYVbLxnps1QymP/yLFxVmjLh95vj/+fCzL/lk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6fa366-6164-43b8-6f2d-08d648708f16
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:20.0008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
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
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   3 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 include/linux/mmc/sdio_ids.h                       |   1 +
 7 files changed, 139 insertions(+), 21 deletions(-)

--=20
2.1.0

