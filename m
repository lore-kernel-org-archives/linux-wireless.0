Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74732C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEDD62054F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ujHcwWxm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEDD62054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbeJ2TPQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:15:16 -0400
Received: from mail-cys01nam02on0090.outbound.protection.outlook.com ([104.47.37.90]:38592
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729343AbeJ2TPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgZguHHJVXq5jdekIdI7Bz0Ws3hVc883KiblLWRw99I=;
 b=ujHcwWxmqG/EWXsIvpknblLgjeWKKVBO6eTZ7oiV4F8DsPQtd+uRjoTx9fujMRgLEX7FLAGfajVODb5BI98pxD5klFA9AeInFeKFc2RRap0lH9UzgIfvpbw4bOUxpdzjypMHV4lE1wjLvcKVPeMkHu2N/pDp4JL+/4XSwWyP/w4=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5303.namprd06.prod.outlook.com (20.178.50.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Mon, 29 Oct 2018 10:27:08 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae%2]) with mapi id 15.20.1273.027; Mon, 29 Oct 2018
 10:27:08 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH 0/3] brcmfmac: throughput enhancement for SDIO and flow
 control mode
Thread-Topic: [PATCH 0/3] brcmfmac: throughput enhancement for SDIO and flow
 control mode
Thread-Index: AQHUb3HyXyrxb686QUajeJhcQVszyQ==
Date:   Mon, 29 Oct 2018 10:27:08 +0000
Message-ID: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TY1PR01CA0179.jpnprd01.prod.outlook.com (2603:1096:402::31)
 To BYAPR06MB3992.namprd06.prod.outlook.com (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5303;6:C3BTtLx0vnDRkRskEMPOieF5wOFMxB7Ovb9JOZLrJJVVKY1X93ueHkx3Tgk/Nm+5LNz/UFPrNbBIRAgW0A+EeieTeJ71hKfn7t7kAHe5LWelpq3skKFfpDCKI6bL++fMAfi1cz/MC0XzKkCfxfpuRcOI6i7BZVt62g+N5E0g1TExXuS3N2NIvFBm4Aol4ig7FFOTCabLpHHg30+7eVqbYIw+InBeSr4epTP/QafnFkyx25jOp0WtSS0PdTuH7ZdOUn6S/i+SGxY5XOQIIHiy2H1bOXLrLcqT2OjfxfK3GpzB05/fWSsgDQk0s3oUkms7jeh6mebbbF8lGxoWHltZJN9wWuq0+YuI6SHWdKrB0iT9AA+A2+MrRmRdJMY0SUxVXFBlVoYuGUM1lndT7TpkadCbmsXVo9kWNfDLsLKOKxPanSuZoLgABeW6QmXiHHFRPsZkyxZBbgAyb4j9j8Hdng==;5:vu86K9LCDhTZIjCNgmKbAUCA1Dlod5UjnUSQaDrZ2y5T3RqF6cAWDru6G0HAhzzEMkWPgQOFS+LN7KRG2KLwq0Gss/FKZwc06nv2ShNbRSRs0fgmcAmIUq+ZmSItlhVk8S9Oi6iQhvo0xm6YEwqMo/7UnBFVWNWYFpcbsZ68c9Y=;7:LDHYAglYOjQ/bGpIGqlXc4oFKP13bDxFpo+eZlixjzE4dVc1VgVsOhBsySn6M9D8u3MzL+tBFVdCKaW2rsM8jXYK/4tedteknLvZJL6Us5dlB0ixxJwkKaZJAnkMxizHN70SHhXNUSfgmJ6c9Vwzzg==
x-ms-office365-filtering-correlation-id: c9603f57-b730-4f16-ed4a-08d63d89149d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5303;
x-ms-traffictypediagnostic: BYAPR06MB5303:
x-microsoft-antispam-prvs: <BYAPR06MB53030C14450A6ED65B9E2670FBF30@BYAPR06MB5303.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5303;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5303;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(305945005)(71200400001)(26005)(71190400001)(2900100001)(2501003)(72206003)(6916009)(105586002)(5250100002)(7736002)(5660300001)(86362001)(2351001)(68736007)(106356001)(476003)(2616005)(486006)(6436002)(8936002)(99286004)(36756003)(2906002)(256004)(81166006)(81156014)(8676002)(316002)(5640700003)(6486002)(54906003)(4326008)(6506007)(44832011)(25786009)(386003)(478600001)(102836004)(14454004)(53936002)(186003)(6512007)(97736004)(3846002)(66066001)(52116002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5303;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: zaFfB/XNWBZZWVckPDZt3y4e/mssaOu6hPBMxv0akGOeRkBvNunt9xAZUKg4ydCxep4TacjI7G8mLsOLG5II6WmvuTkTK5yrEZt5HI3jeo0Gg+f44R2rTnvDM7gJS7AJEqDni+k2vj+4wBLNd+pT6HtVp+zVElIhVwBwuAaKsMmRV9fQFKDZJEuRXs9ogmnm8UuwlEKaE8n53XPbfKnEFSxL1PMdooSIEG+O+haRPF2lnX0y5aHKnk6NqEOmDMrd7F7LzonJC6Ch3/NgRvYl8ZpTev7PuLMB4zdcCZ+/2Q289Oad5TiSKf3WIVQ1atjDEoKIBX38vnOSjRHIEA25MgGtxtAB15GmGr576brVx+k=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9603f57-b730-4f16-ed4a-08d63d89149d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 10:27:08.8493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5303
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These are for throughput enhancement with SDIO bus or with flow control
mode enabled, and also introuce a new module parameter to enhance TX
throughput as well.

Wright Feng (3):
  brcmfmac: calling skb_orphan before sending skb to SDIO bus
  brcmfmac: add credit numbers updating support
  brcmfmac: make firmware frameburst mode a module parameter

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  7 +++++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  5 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  1 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 23 ++++++++++++++----=
----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  1 +
 6 files changed, 31 insertions(+), 8 deletions(-)

--=20
1.9.1

