Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29588C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC41217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Ler6CjQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbfDYHFu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:05:50 -0400
Received: from mail-eopbgr700097.outbound.protection.outlook.com ([40.107.70.97]:3937
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387520AbfDYHFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9m3AOJLwpvxLfCxQqt86Ujv4p80fTUqawglJ9fa3dOc=;
 b=Ler6CjQUpoQcS/AaIBj1eXEdkd9q31DjWQ3ICFhEFLyzEgI1S3lt1hU2/DEJVFQbrRYD8UxZOX0w5iLHDyDvGrceYAuiTfQIsAi1di9JLkZwqU12ioSkzbS2tjebCWDTTYOibBdHvQruTdvGF3wgVhIpC8WAe7OyA28JcsL2kMc=
Received: from MN2PR06MB5806.namprd06.prod.outlook.com (20.179.145.207) by
 MN2PR06MB5854.namprd06.prod.outlook.com (20.179.145.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Thu, 25 Apr 2019 07:05:47 +0000
Received: from MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb]) by MN2PR06MB5806.namprd06.prod.outlook.com
 ([fe80::1ca6:d3b:6b7a:65cb%5]) with mapi id 15.20.1813.017; Thu, 25 Apr 2019
 07:05:47 +0000
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
Subject: [PATCH v2] brcmfmac: send mailbox interrupt twice for specific
 hardware device
Thread-Topic: [PATCH v2] brcmfmac: send mailbox interrupt twice for specific
 hardware device
Thread-Index: AQHU+zVOwI/gZmAwDkeXkV8XDkqnKA==
Date:   Thu, 25 Apr 2019 07:05:46 +0000
Message-ID: <1556175939-174559-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:805:de::37) To MN2PR06MB5806.namprd06.prod.outlook.com
 (2603:10b6:208:127::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.0
x-originating-ip: [12.110.209.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f0aa4d-de17-4cfd-7dba-08d6c94c70b8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:MN2PR06MB5854;
x-ms-traffictypediagnostic: MN2PR06MB5854:
x-microsoft-antispam-prvs: <MN2PR06MB58548A50429873A871A4D575FB3D0@MN2PR06MB5854.namprd06.prod.outlook.com>
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(71190400001)(2616005)(6512007)(52116002)(97736004)(486006)(8936002)(2501003)(26005)(99286004)(186003)(54906003)(6636002)(81156014)(8676002)(316002)(4326008)(14454004)(476003)(478600001)(110136005)(50226002)(81166006)(53936002)(72206003)(2201001)(66946007)(71200400001)(386003)(66066001)(86362001)(5660300002)(14444005)(2906002)(6506007)(256004)(102836004)(64756008)(15650500001)(66446008)(6436002)(73956011)(66556008)(6116002)(36756003)(25786009)(3846002)(7736002)(44832011)(305945005)(68736007)(66476007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR06MB5854;H:MN2PR06MB5806.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b1JJiay6M6FcLfYFS7Xnz+tw6GHUBrZM8YB0Sj9uCXK4Mm0ZoVJKTV1R2pum56K914lycp5iwqMrO7JUT6FliTk5Fz78F0oamARY0MUwvHXkk/rBWAtbf5GF4nA3twm/R7+hQ9h3Ydm+PCU35PiynJ5R2PLHNg1piHL0qOgZI4Qal31fvvJj28Lskdk+s7zm8H4cx3gzVuiiULoPIFHcIXoPReFxoKIGYBH5vwh4HrZPUqpp7o88ai9TxaMW3Kt4+CwUb6dQTzogO7RPlbNj1nRqqmizHdePszY0lYER+xCmVaFx4HpThfCqbGb1pWtaWG8qwjWmZEIdlvGdHvtBos8NYDWWkRgeFR6CLNDxJF/dGj2fD4fv9yl9II21U9y70kdtj11wHJNJfm+yK/tyZcKzaGvhqM80BXm/5haip1I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f0aa4d-de17-4cfd-7dba-08d6c94c70b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 07:05:46.9143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB5854
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rm9yIFBDSUUgd2lyZWxlc3MgZGV2aWNlIHdpdGggY29yZSByZXZpc2lvbiBsZXNzIHRoYW4gMTQs
IGRldmljZSBtYXkgbWlzcw0KUENJRSB0byBTeXN0ZW0gQmFja3BsYW5lIEludGVycnVwdCB2aWEg
UENJRXRvU0JNYWlsYm94LiBTbyBhZGQgc2VuZGluZw0KbWFpbCBib3ggaW50ZXJydXB0IHR3aWNl
IGFzIGEgaGFyZHdhcmUgd29ya2Fyb3VuZC4NCg0KU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcg
PHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyB8IDYgKysrKystDQogMSBmaWxlIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9wY2llLmMNCmluZGV4
IGZkMzk2OGYuLjY2ZWU5MmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9h
ZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQpAQCAtNjk4LDcgKzY5OCwxMSBA
QCBicmNtZl9wY2llX3NlbmRfbWJfZGF0YShzdHJ1Y3QgYnJjbWZfcGNpZWRldl9pbmZvICpkZXZp
bmZvLCB1MzIgaHRvZF9tYl9kYXRhKQ0KIA0KIAlicmNtZl9wY2llX3dyaXRlX3RjbTMyKGRldmlu
Zm8sIGFkZHIsIGh0b2RfbWJfZGF0YSk7DQogCXBjaV93cml0ZV9jb25maWdfZHdvcmQoZGV2aW5m
by0+cGRldiwgQlJDTUZfUENJRV9SRUdfU0JNQlgsIDEpOw0KLQlwY2lfd3JpdGVfY29uZmlnX2R3
b3JkKGRldmluZm8tPnBkZXYsIEJSQ01GX1BDSUVfUkVHX1NCTUJYLCAxKTsNCisNCisJLyogU2Vu
ZCBtYWlsYm94IGludGVycnVwdCB0d2ljZSBhcyBhIGhhcmR3YXJlIHdvcmthcm91bmQgKi8NCisJ
Y29yZSA9IGJyY21mX2NoaXBfZ2V0X2NvcmUoZGV2aW5mby0+Y2ksIEJDTUFfQ09SRV9QQ0lFMik7
DQorCWlmIChjb3JlLT5yZXYgPD0gMTMpDQorCQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKGRldmlu
Zm8tPnBkZXYsIEJSQ01GX1BDSUVfUkVHX1NCTUJYLCAxKTsNCiANCiAJcmV0dXJuIDA7DQogfQ0K
LS0gDQoyLjEuMA0KDQo=
