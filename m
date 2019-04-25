Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F07C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 490FD217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="P4risVl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbfDYIE7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:04:59 -0400
Received: from mail-eopbgr820091.outbound.protection.outlook.com ([40.107.82.91]:8683
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbfDYIE7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6ANJAAhGGm9GsoHzZJbB5gF9waVsTI6VPt6VpTJih4=;
 b=P4risVl/3jYHleB0m8Z2MckL7Ku8P7rlaYsqHNk4LVDrwoA6d4K+SbwBcIp/v0MtQ2c/hCwikJq/vPHO//IYHXoSB9vrbN5DMSxhPrTo4Ye8ACyhnkK1vkezwB5TQy44hgsWx+wonNoKoXsfxD54fYsfz8XyFFt4G9qtmlsLbIA=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB6016.namprd06.prod.outlook.com (20.179.145.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Thu, 25 Apr 2019 08:04:56 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Thu, 25 Apr 2019
 08:04:56 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH] brcmfmac: allocate msgbuf pktid from 1 to pktids array size
Thread-Topic: [PATCH] brcmfmac: allocate msgbuf pktid from 1 to pktids array
 size
Thread-Index: AQHU+z2RzToH3FeQwUSmmepORWhyJQ==
Date:   Thu, 25 Apr 2019 08:04:56 +0000
Message-ID: <1556179487-147593-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0148.namprd05.prod.outlook.com
 (2603:10b6:803:2c::26) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.0
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7221a00d-15f0-47f1-2825-08d6c954b434
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB6016;
x-ms-traffictypediagnostic: MN2PR06MB6016:
x-microsoft-antispam-prvs: <MN2PR06MB601690A18BE4682AD594419FFB3D0@MN2PR06MB6016.namprd06.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(376002)(39860400002)(366004)(199004)(189003)(14454004)(486006)(6512007)(2906002)(2501003)(476003)(6486002)(44832011)(4326008)(14444005)(478600001)(66946007)(6116002)(256004)(71190400001)(71200400001)(72206003)(6506007)(6636002)(2616005)(3846002)(66556008)(386003)(66446008)(64756008)(66476007)(66066001)(68736007)(54906003)(52116002)(2201001)(110136005)(36756003)(86362001)(99286004)(7736002)(305945005)(5660300002)(97736004)(50226002)(102836004)(81156014)(53936002)(8676002)(25786009)(26005)(6436002)(8936002)(186003)(73956011)(316002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB6016;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3iGMcjIp/Fl9Vw6z4Cp8k3FEYJa9Prhs+mm5TXxeEK6qNWngxBMiVgZxBnxCy3BvcOGwYLFrabprI0uwb2ctkzaN+u1O4QTLaVhVX8nORXHia9fJvblMjSoy0hT3cElGnqrxlPgM1Xj1huHh3mgvRQA4eXgOPFWe/0xiHEAP9C1L2LcG1vPTtCWDh8xurjxNHGk/GLzEqs8xi2GZuW3CGyYUstIyXUSAWqmX8D6Vp0b5lkvUYGnRdM5azqIGjOF58LS0oQOBEOSGWQBjpCnHJVzdM099xb2Y8BS2JDAbsx2bAGlZ8JCBf8Cxd2R+BfnyPFkCROJIP3NHaE17PVNlSY15mP4yCY1JK3FaJqSEEo9A6L22+LOKwfwJ1zPcM4wktDGu2vox2DNTrMSB0pADE/+6wmgvqDPaJ/rhnlNti04=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7221a00d-15f0-47f1-2825-08d6c954b434
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 08:04:56.1209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6016
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

U29tZSBQQ0lFIGZpcm13YXJlcyBkcm9wIHR4c3RhdHVzIGlmIHBrdGlkIGlzIDAgYW5kIG1ha2Ug
cGFja2V0IGhlbGQgaW4NCmhvc3Qgc2lkZSBhbmQgbm90IGJlIHJlbGVhc2VkLiBJZiB0aGF0IHBh
Y2tldCB0eXBlIGlzIDgwMi4xeCwgdGhlDQpwZW5kXzgwMjF4X2NudCB2YWx1ZSB3aWxsIGJlIGFs
d2F5cyBncmVhdGVyIHRoYW4gMCBhbmQgc2hvdyAiVGltZWQgb3V0DQp3YWl0aW5nIGZvciBubyBw
ZW5kaW5nIDgwMi4xeCBwYWNrZXRzIiBlcnJvciBtZXNzYWdlIHdoZW4gc2VuZGluZyBrZXkgdG8N
CmRvbmdsZS4NCg0KVG8gYmUgY29tcGF0aWJsZSB3aXRoIGFsbCBmaXJtd2FyZXMsIGhvc3Qgc2hv
dWxkIGFsbG9jYXRlIG1zZ2J1ZiBwa3RpZA0KZnJvbSAxIGluc3RlYWQgb2YgZnJvbSAwLg0KDQpT
aWduZWQtb2ZmLWJ5OiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQotLS0N
CiBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvbXNnYnVm
LmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEv
YnJjbWZtYWMvbXNnYnVmLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAy
MTEvYnJjbWZtYWMvbXNnYnVmLmMNCmluZGV4IGQzNzgwZWEuLmIyZmFiM2MgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvbXNnYnVm
LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1h
Yy9tc2didWYuYw0KQEAgLTM0OCw3ICszNDgsNyBAQCBicmNtZl9tc2didWZfYWxsb2NfcGt0aWQo
c3RydWN0IGRldmljZSAqZGV2LA0KIAlkbyB7DQogCQkoKmlkeCkrKzsNCiAJCWlmICgqaWR4ID09
IHBrdGlkcy0+YXJyYXlfc2l6ZSkNCi0JCQkqaWR4ID0gMDsNCisJCQkqaWR4ID0gMTsNCiAJCWlm
IChhcnJheVsqaWR4XS5hbGxvY2F0ZWQuY291bnRlciA9PSAwKQ0KIAkJCWlmIChhdG9taWNfY21w
eGNoZygmYXJyYXlbKmlkeF0uYWxsb2NhdGVkLCAwLCAxKSA9PSAwKQ0KIAkJCQlicmVhazsNCi0t
IA0KMi4xLjANCg0K
