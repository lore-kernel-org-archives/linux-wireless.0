Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE917C46464
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705222086A
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="0EH3Eh6b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 705222086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbeKHNVh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:37 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728621AbeKHNVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/vty2tKNBXQIa2L+O1+n5+MEgq75OQPKBoQDlZ/HW0=;
 b=0EH3Eh6b5xTcxX5WaeRw+3XN64TWyYW8ceIjL/nwOMIcdT6rcTW9+5/BUio3VF8lYJDvYlikhJOkOzF9pzX/8Z/eSyQCuK1e+B6oBc2FlBX0nU26+QC25XwUZjkzjWzP/IzG7o0HSkyTZPv6dP2KcpqWt39vUHfy6jTmPjUTz9Q=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:03 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:03 +0000
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
Subject: [PATCH 0/5] brcmfmac: p2p/miracast/apsta fixes
Thread-Topic: [PATCH 0/5] brcmfmac: p2p/miracast/apsta fixes
Thread-Index: AQHUdxXZwdHEHYUbS0qMrwbrxt5kLQ==
Date:   Thu, 8 Nov 2018 03:48:03 +0000
Message-ID: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:vKS/3iPolklX7sOsak0WRUeJ9/pE2S3MNC8kvQojAsZxOF2n60rB4C+kv6HB9cDYSDcdGuJl6HiiTKMpyhtXJU0yRyl38Is9cduLcUaT93svY5dRt4Zmd1yc4r7Yv4Z7TCkbU3F8cgY17ykXEjAYLTlXOoybARU2S5UoaSp/FGMCGJgHEfrrVv4rN0rjO3ml78WLClkdlW+Z08pkC0CqsIMD6b6VNSCvg64rQ2M+nEW7OCl1Y9Y2QybceUcEaJZMgmEOdH/lT4zbicQESJRfrTmA5LL2OYzlEY1z2jwvlEqrNdjFVHfmqSXZXFJSSpvR6m0SdqAdHoPMwvkc1wBBiLE3rnHa/LL/1mu1MDe3mMIqRLJY+YR7R5xhQLitHRaszaAXbnu5y9NfeTJJY2Gab3LvQOCzbRWGmIcX1KalY10/WeVTyHFFgepyOHBFqWzKJs6JysoWoYbI1mjaZAjYzg==;5:wCKx1ax9LzwE3Yy5Dp//RuI+av0daUK+rxD/7kqUokxPx1RiiDKZnbl3I2VYWAsTrzmgq+rFwRHCuMCFbhms+uR6G6le1+btts5i09kGNxC+OiWjKajCCiTHwm14qIdCy9MXV97uwPQZoN848cHjDA6iR3OKrZxvMABw/RRYOSU=;7:r2sNLtlsEo62ztuwusz+AXBXhFf2AO9KadESn2S9Qtlz5a0VC917swPzfNLh9c2qgJibl1uhZ/yojFCA5xHANOD/ZoiMxU0U+p4ryU7kmSLffnq95NyjCl5YbCUgMmcBzfz3D2Q+HUiQUlAmSC42/g==
x-ms-office365-filtering-correlation-id: e3ec6c26-3469-4fcb-34be-08d6452cfbdb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB138780240C6481EDEFF543B8BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(14444005)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: oZHBypPjBTCdjq4UZ/xigQAVURQqDGr7hMx7huc32Nw+CBT1hDjAqtIIsgvF3s/USe9UAxby8FTdqkuThxotbZTlk8rRYKh9lF4HCoF1BfUoxE8Wp2rI8tWGgjj3MzAh7ll/J606sBYL6YrVvtaPgjjx3XvJ8csMofS7jk6HhrreHyoMefE2FBCfkiUze63EvMwXHaHkOgUb65MuYlp+fF5FPEuNIymCmJQMg9FY6ObrQACc7mZkX+mqZzcoEAEqMwMuDS4DjPsy7zsFkSCs5Tf0YmEst0aRpdeFnY8KT67tlP4U8hmtcGoag78y6Ai1hy5sXvirsTC/BwmWnmiiYdcfEnhOH3cOLaNsxoo+jBY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ec6c26-3469-4fcb-34be-08d6452cfbdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:03.5556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series addresses failures seen during p2p/miracast/apsta testing=
.

Chi-Hsien Lin (1):
  brcmfmac: only generate random p2p address when needed

Madhan Mohan R (1):
  brcmfmac: p2p cert 6.1.9-support GOUT handling p2p presence request

Ryohei Kondo (1):
  brcmfmac: add vendor ie for association responses

Wright Feng (2):
  brcmfmac: set apsta to 1 when AP start on primary interface.
  brcmfmac: remove "arp_hostip_clear" from "brcmf_netdev_stop"

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 18 ++++++++++++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  4 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  2 --
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 27 ++++++++++++++++++=
+---
 4 files changed, 43 insertions(+), 8 deletions(-)

--=20
2.1.0

