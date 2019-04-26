Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D6EC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7992D206C1
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 03:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="OfJRUctE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDZDlt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:41:49 -0400
Received: from mail-eopbgr740109.outbound.protection.outlook.com ([40.107.74.109]:6166
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726390AbfDZDlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 23:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3YYfimd75a8tzj6wjK0SQgPz5FklluwjWse0pghZLE=;
 b=OfJRUctEk5B7c+xtoz73vwDhwhqUSdEkh1WZrol/eMGfmAZXh54l18zREJYG4uYJwzN7jm/dReSKiHO45hms57EtRGffPWCPf1KlH6mQ/S6oO7tPrDVuHuEDfzllSbmmfKqYrZGsdIA7X7E11afCRWhz+I+4Llwmpga8S/zf8YU=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB5934.namprd06.prod.outlook.com (20.179.146.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Fri, 26 Apr 2019 03:41:47 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Fri, 26 Apr 2019
 03:41:47 +0000
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
Subject: [PATCH v2] brcmfmac: set txflow request id from 1 to pktids array
 size
Thread-Topic: [PATCH v2] brcmfmac: set txflow request id from 1 to pktids
 array size
Thread-Index: AQHU++H5OHsVuoN/lEy+93JWyOB45A==
Date:   Fri, 26 Apr 2019 03:41:46 +0000
Message-ID: <1556250092-3834-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::33) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.0
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db19aa3d-f50d-4584-4ae5-08d6c9f91b8e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB5934;
x-ms-traffictypediagnostic: MN2PR06MB5934:
x-microsoft-antispam-prvs: <MN2PR06MB5934463CB677F5FD8996B200FB3E0@MN2PR06MB5934.namprd06.prod.outlook.com>
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(376002)(366004)(346002)(189003)(199004)(26005)(68736007)(64756008)(8936002)(316002)(25786009)(6636002)(71190400001)(71200400001)(50226002)(5660300002)(81156014)(66066001)(52116002)(6116002)(99286004)(81166006)(3846002)(110136005)(2201001)(54906003)(86362001)(4326008)(476003)(386003)(73956011)(6512007)(6506007)(2616005)(8676002)(14454004)(44832011)(102836004)(256004)(66446008)(186003)(14444005)(486006)(6486002)(2906002)(478600001)(305945005)(6436002)(72206003)(97736004)(53936002)(66476007)(7736002)(2501003)(36756003)(66946007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB5934;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gnBTejQ6rRK0Z59FPZMfwN9pJioL36MH7QoPbkQomi9WnYjrhlpEB+yxiF16AJJxKsDBoP3HBzHEZXDKKkYiBEMCgkX9RARm5D7UxSzpfy2A4qXil4zXmpnkgtQKFIh5XKDlxg4EcXoaVMZneLRvC2Dn49yWmtTXnmXTN3UCiWUghYLLAyBwMKjkfUAElM/eMlHPLR6P20+TCrWTR6LM+gNq6kq5pa9Q8VP48xvkTjR/brbFcTYOQ+T7ZKHVw29ekqW/gxTGmxAUMYgGPnJzImabLRSz9G6+wQHBDxbjiZo26K1JVguFqmV36APc6neUGGQCeyO/33BiW55kZ3JCsHaOArk7eThyHei6oIhH82NbgNC2nSykwCOTvZGHHW4O3JYH3z0VtZJEO829g6ggTKzpCwfMoZ/boTneaig/N4g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db19aa3d-f50d-4584-4ae5-08d6c9f91b8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 03:41:46.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB5934
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

U29tZSBQQ0lFIGZpcm13YXJlcyBkcm9wIHR4c3RhdHVzIGlmIHBrdGlkIGlzIDAgYW5kIG1ha2Ug
cGFja2V0IGhlbGQgaW4NCmhvc3Qgc2lkZSBhbmQgbmV2ZXIgYmUgcmVsZWFzZWQuIElmIHRoYXQg
cGFja2V0IHR5cGUgaXMgODAyLjF4LCB0aGUNCnBlbmRfODAyMXhfY250IHZhbHVlIHdpbGwgYmUg
YWx3YXlzIGdyZWF0ZXIgdGhhbiAwIGFuZCBzaG93ICJUaW1lZCBvdXQNCndhaXRpbmcgZm9yIG5v
IHBlbmRpbmcgODAyLjF4IHBhY2tldHMiIGVycm9yIG1lc3NhZ2Ugd2hlbiBzZW5kaW5nIGtleSB0
bw0KZG9uZ2xlIGV2ZXJ5IHRpbWUuDQoNClRvIGJlIGNvbXBhdGlibGUgd2l0aCBhbGwgZmlybXdh
cmVzLCBob3N0IHNob3VsZCBzZXQgdHhmbG93IHJlcXVlc3QgaWQNCmZyb20gMSBpbnN0ZWFkIG9m
IGZyb20gMC4NCg0KU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJl
c3MuY29tPg0KLS0tDQp2MjogY2hhbmdlIGZvciBub3Qgd2FzdGluZyB0aGUgZmlyc3QgZW50cnkN
Ci0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9t
c2didWYuYyB8IDYgKysrLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29t
L2JyY204MDIxMS9icmNtZm1hYy9tc2didWYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2Fk
Y29tL2JyY204MDIxMS9icmNtZm1hYy9tc2didWYuYw0KaW5kZXggZDM3ODBlYS4uOWQxZjlmZiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9tc2didWYuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgw
MjExL2JyY21mbWFjL21zZ2J1Zi5jDQpAQCAtMzc1LDcgKzM3NSw3IEBAIGJyY21mX21zZ2J1Zl9n
ZXRfcGt0aWQoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgYnJjbWZfbXNnYnVmX3BrdGlkcyAq
cGt0aWRzLA0KIAlzdHJ1Y3QgYnJjbWZfbXNnYnVmX3BrdGlkICpwa3RpZDsNCiAJc3RydWN0IHNr
X2J1ZmYgKnNrYjsNCiANCi0JaWYgKGlkeCA+PSBwa3RpZHMtPmFycmF5X3NpemUpIHsNCisJaWYg
KGlkeCA8IDAgfHwgaWR4ID49IHBrdGlkcy0+YXJyYXlfc2l6ZSkgew0KIAkJYnJjbWZfZXJyKCJJ
bnZhbGlkIHBhY2tldCBpZCAlZCAobWF4ICVkKVxuIiwgaWR4LA0KIAkJCSAgcGt0aWRzLT5hcnJh
eV9zaXplKTsNCiAJCXJldHVybiBOVUxMOw0KQEAgLTc0Nyw3ICs3NDcsNyBAQCBzdGF0aWMgdm9p
ZCBicmNtZl9tc2didWZfdHhmbG93KHN0cnVjdCBicmNtZl9tc2didWYgKm1zZ2J1ZiwgdTE2IGZs
b3dpZCkNCiAJCXR4X21zZ2hkciA9IChzdHJ1Y3QgbXNnYnVmX3R4X21zZ2hkciAqKXJldF9wdHI7
DQogDQogCQl0eF9tc2doZHItPm1zZy5tc2d0eXBlID0gTVNHQlVGX1RZUEVfVFhfUE9TVDsNCi0J
CXR4X21zZ2hkci0+bXNnLnJlcXVlc3RfaWQgPSBjcHVfdG9fbGUzMihwa3RpZCk7DQorCQl0eF9t
c2doZHItPm1zZy5yZXF1ZXN0X2lkID0gY3B1X3RvX2xlMzIocGt0aWQgKyAxKTsNCiAJCXR4X21z
Z2hkci0+bXNnLmlmaWR4ID0gYnJjbWZfZmxvd3JpbmdfaWZpZHhfZ2V0KGZsb3csIGZsb3dpZCk7
DQogCQl0eF9tc2doZHItPmZsYWdzID0gQlJDTUZfTVNHQlVGX1BLVF9GTEFHU19GUkFNRV84MDJf
MzsNCiAJCXR4X21zZ2hkci0+ZmxhZ3MgfD0gKHNrYi0+cHJpb3JpdHkgJiAweDA3KSA8PA0KQEAg
LTg4NCw3ICs4ODQsNyBAQCBicmNtZl9tc2didWZfcHJvY2Vzc190eHN0YXR1cyhzdHJ1Y3QgYnJj
bWZfbXNnYnVmICptc2didWYsIHZvaWQgKmJ1ZikNCiAJdTE2IGZsb3dpZDsNCiANCiAJdHhfc3Rh
dHVzID0gKHN0cnVjdCBtc2didWZfdHhfc3RhdHVzICopYnVmOw0KLQlpZHggPSBsZTMyX3RvX2Nw
dSh0eF9zdGF0dXMtPm1zZy5yZXF1ZXN0X2lkKTsNCisJaWR4ID0gbGUzMl90b19jcHUodHhfc3Rh
dHVzLT5tc2cucmVxdWVzdF9pZCkgLSAxOw0KIAlmbG93aWQgPSBsZTE2X3RvX2NwdSh0eF9zdGF0
dXMtPmNvbXBsX2hkci5mbG93X3JpbmdfaWQpOw0KIAlmbG93aWQgLT0gQlJDTUZfSDJEX01TR1JJ
TkdfRkxPV1JJTkdfSURTVEFSVDsNCiAJc2tiID0gYnJjbWZfbXNnYnVmX2dldF9wa3RpZChtc2di
dWYtPmRydnItPmJ1c19pZi0+ZGV2LA0KLS0gDQoyLjEuMA0KDQo=
