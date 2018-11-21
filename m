Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF70C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4476D2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="MqxSjm3F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4476D2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbeKUS1L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:11 -0500
Received: from mail-eopbgr730138.outbound.protection.outlook.com ([40.107.73.138]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbeKUS1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K92KhtDH1z+jhAyQT27upWCeiXzy9wZ21r0u6FJJvs=;
 b=MqxSjm3FpiJSNYg/RTy/+ijGhghlcuzECvXT6sZ5wnDS6X8TkhLI5NECTBzlIidML8h8ON+83HeCbuXGIHqeZpROdSTolZtAt8ivOgjFYPsg01yKT43M8kdgMW3XRvVA35XllUpnu8vfaT7jdPhe6Uu87MeezkgF7zAZDaSHg9M=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:41 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:41 +0000
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
Subject: [PATCH V4 0/8] brcmfmac: chip related changes
Thread-Topic: [PATCH V4 0/8] brcmfmac: chip related changes
Thread-Index: AQHUgW9RRcJlPKFLbEG/q2MzxEUBuw==
Date:   Wed, 21 Nov 2018 07:53:41 +0000
Message-ID: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:PrhCIuq3esXH6KGiTD1fjijc5BgwzUrwE53aky64+qyu8U3vyZJAxsYNrMMRuTsyzdi/3GAqg0P4sLVKDA1oRLGN5R8mCq7f7lfT37hUcSK1GgB+5JjQrSZnb8r7T1RyN9m9fq+92ou5sMhzyPkHp9QQr1ZZ9cxqq86zu9HVtBsQsIseVyltD24xj6gruvDSxsxhFESqjbTmxYRdatBhKtWODCndH86Q3+2d65dNdTwTQ/8hpHmoZBlCRIP+uqGG5rMjqwLc2T5z5mRiPT7Uox1mRCiBflMUWSY0I1exBBcZ+K9U/uM93YK1uANoW619i1o32w4XzJB/az0Xi94rBERxEOeIH/YsDJRKsNXwLRPRQXnJmOA4YtfGwhumb20iwNaxOoLHMETy56ZjAt5aWzHZUU28zR4q/p0TUA8PT8sHMnXIdSsVmDyFoTBxEMwuMbzmbZQE+IRcvmjL3+UxmQ==;5:4WTcl+ZGr6hfRzhfypX6L8QwrWIZD0rZT3z8qwtoMW/hGVUcO9Gu7dgTqqkcikujVkJ1t1fv9+592s8iEUyojrqlpr4P/LjsecXsBxa9cRixS1FiJ2aEyBZlpBL78+v/iUxhWJylzzkKg44ixjBU1PEvfH52P3HZTee/fwLsCQo=;7:IjxzraabpVp7+ng+ODDVdfGPYJtgxIBqosXWsxe3ncHwmFYl/N6dNvoTklRWl8fwDeBBVUPmW3p6oF6BikOBhxQ4SJFDTPDtzH1fWjjs/bZ7XTwJkUwVh13GKQKOFPKMLfe+Zh8sPCrG+urTkCBmeQ==
x-ms-office365-filtering-correlation-id: 1e6fc584-2fda-4748-f6c8-08d64f86740f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB117414DE1097DED716A4A964BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(54534003)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(14444005)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(86362001)(53936002)(2900100001)(6512007)(5660300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ++DimqGbrwwVEkdVARiiyEI5tl6sjMGE6dfK61isgxDHXplAjkBxkzf7AeUDSz/WdLZnShtPyr6+FNCsLCyMTC1VANda5ZV7wSEleBfhpm2Aj9WaWr1oFtHphnv01UBdEmW9FJIMz/cJ3R84gbPEANhJabVs5EgYV4Z2VTQdEYGMneLEIzcHad5N2dzrGLh8FPVWRE/QLnY5ODkQudrj8UFQmHSo04bZvsGHxzxMikcQQ4B3ejUf4j35qRzBJredqt4bDZIzaiBuoou/cXl4DjFQNm2ipUkmgagCF9/d5efeLVIo9M+7p9a3nFfZ2GLyR/jvxa88OVN2y3NcMMqWI1DMMAMIIdXI38V0+zI+UhI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6fc584-2fda-4748-f6c8-08d64f86740f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:41.5763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
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
V4:
 - Removed bit defines for irrelevant registers from patch 7.
 - Correct patch 0 subject (missing V3).
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
 .../broadcom/brcm80211/include/chipcommon.h        |  19 ++++
 include/linux/mmc/sdio_ids.h                       |   1 +
 8 files changed, 163 insertions(+), 22 deletions(-)

--=20
2.1.0

