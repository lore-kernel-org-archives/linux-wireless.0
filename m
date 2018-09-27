Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCF9C004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0205721582
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="K6hF77Um"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0205721582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbeI0VWt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:22:49 -0400
Received: from mail-eopbgr700126.outbound.protection.outlook.com ([40.107.70.126]:49887
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727270AbeI0VWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=836v3ORPSXNF1fNsL4yvvVYo1mupWObDY08qFjAXaC0=;
 b=K6hF77Uml1vb6bEbx7hvlW9BUySjf2SsSyKYx8BQgibt9Myr8afzED0feAEILZCF7v6geitrmn5+Is+YPHceANPOB9EKwxHvvJ5le4BjDr7MvwYRR5zfoEhdoslcj12cbJjLASwex8wNhkEJ9MtQjR9rL6Lj6k/7/IORjh40vcg=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1481.namprd06.prod.outlook.com (10.162.112.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.25; Thu, 27 Sep 2018 14:59:41 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 14:59:41 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH v2 0/2] brcmfmac: WFA p2p certification fixes
Thread-Topic: [PATCH v2 0/2] brcmfmac: WFA p2p certification fixes
Thread-Index: AQHUVnK3TggcNRQqj0S3SlxfROtZgQ==
Date:   Thu, 27 Sep 2018 14:59:41 +0000
Message-ID: <1538060351-12827-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR19CA0095.namprd19.prod.outlook.com
 (2603:10b6:320:1f::33) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1481;6:DFkp3sSx+O0biSc8X9wDHvvVERrO4ITE2EEJDAE1d9hGNSBKqzFV9IipfnpXnv16Gaff7ww2OL3LBU4zKrkOikXemm0mtlLFZc5ObAOwbtR47XfFp3Tchy/5kkv6PJT8R/7QRUp1+zxBqbBtnHnurmh7U29CTQqSq3JibPmgKNv6Zd99LFvF+79F1njVsN/mGa5o3ty0u2aVgefyNbAsMd5YJpsO95QVnOVxNkST3k0QfoGpJ/RusUBYLzrP9t0Vv4CnlrFkcTv3tFGsGgii66Tl1VQrZn2YSz/AOM8QEofWQJkfNixoZfmGnAbNP24rpOqfdEc0Hvl07MO7GcDLc23BtdyE6IBjp8xx7jtbf43H1+b2bO4eZD7qYUiSUHRzNTRQ0i/LWxTj3iLC7zdfm94nE8g4WRyysbRXt8ZBSYNsLKG/+kIVt5Sgq2LPwxce5kDvo2qovOn7535gfIFGEw==;5:XyCW8XXudOVbfwTUZ+KJjS7bf6UmFtLxKibgRis7nsPjXwiS2wPempICFDPmD/oUP+g3BiX2eHlgXGt/h866Ob80wMzlJnhz/Ku7RQFp98IwnIYUNcPzP0d1BgDe4gHvppGeoigTBTKk+W4m6u4pNHt4KoFDdapCkwc9iayUwKc=;7:Gwchqs9PPWHJLQ0nczetitqCWPe14bdWRRF9efdLrfViq+hWHt2B0nG+7EX1XN8zS3FKo8OYEfe0ddfV1cfdx8rqYGjiaBH6x3NU7WlDWB3LmbVT8es3pv8pNPR4KqgNwot/ONYlmPCZyH2lsr8qVGLrqOBYZ92bi4fR6ighSioI8rAvceeuCUH3HBeNW+qmVeb2UzEi5rcIBJX5uDwXGHYFWvAEo0J6l4LskcuS7qvPv9LbWuloqnAVZjlGTB9O
x-ms-office365-filtering-correlation-id: ab083bad-ffb6-4907-08d8-08d62489da19
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1481;
x-ms-traffictypediagnostic: BY1PR0601MB1481:
x-microsoft-antispam-prvs: <BY1PR0601MB14817C1F9A60E43FC9A53BE4BB140@BY1PR0601MB1481.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(6055026)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123564045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BY1PR0601MB1481;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1481;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(346002)(136003)(376002)(189003)(199004)(53936002)(99286004)(6116002)(5250100002)(3846002)(26005)(6512007)(2501003)(5640700003)(68736007)(6436002)(8936002)(8676002)(6486002)(186003)(316002)(6506007)(102836004)(6916009)(386003)(5660300001)(81156014)(105586002)(106356001)(2351001)(81166006)(2906002)(97736004)(54906003)(25786009)(72206003)(36756003)(486006)(2616005)(14454004)(4326008)(107886003)(478600001)(7736002)(71200400001)(52116002)(2900100001)(256004)(14444005)(476003)(34290500001)(71190400001)(86362001)(66066001)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1481;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CyqEWBvVERVPT8NdNNR/8Ae36889zh7bhx52OMB6LcEiPJgo4QfZ4Rg2QoQ92lmh5JgjNMuuaTsLccCPReghRfJkBR+sd9Y6hbyFsxBKRjqs9V4/usWr4MLn9GgqVXONzr08d7J2zBxnjGvwtaR9XT0JaNN7lDBcGEY4+wrm3Tj2DADVelRAMuNA7MT9aL/JIQ/3hvs7tL15dCt6MpGVy88bMSyWJos5/Yg9h0NB/+u0Ym0IJJQD5amfzmSPpeYjWkNIic2BOBDFofBljahHtZaxopzne9+i9XqiiIhOMp4sVzrjSysuwBEFNwaGnsOYh4XmV1kHd30BbaYu3C02lJx2E/4KddtVIxJfPa00IIk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab083bad-ffb6-4907-08d8-08d62489da19
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 14:59:41.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1481
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes for WFA p2p certification 5.1.19 and 5.1.20 failures.

Changes since v1:
   Update cover letter subject

Chung-Hsien Hsu (2):
  brcmfmac: reduce timeout for action frame scan
  brcmfmac: fix full timeout waiting for action frame on-channel tx

 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 26 ++++++++++++++++--=
----
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

--=20
2.1.0

