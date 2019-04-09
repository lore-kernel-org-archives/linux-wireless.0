Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B221CC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC5B2083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="RcF4tcIh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfDIHg7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:36:59 -0400
Received: from mail-eopbgr760049.outbound.protection.outlook.com ([40.107.76.49]:41382
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbfDIHg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irAXeeXbwENGIl6DiAFAHNx3X0FXoLq6YEflbjpvFbw=;
 b=RcF4tcIhUG5+9By7Ex4Xz5DYDV5Mj8FBhhfp+la3WGQtGNXl4ia0TNLzkRwOYuBDrsIGw2UulRj64wQ8V4peDSt5hYCfw1K0LgdMRYV7DCFRIm+bULSqaw2lCHXn7tcSg7dzC8fv+OEdzlgkqux2P9Qm4kqIfHsw05qoMOrVr+A=
Received: from DM6PR05MB5883.namprd05.prod.outlook.com (20.178.26.204) by
 DM6PR05MB4475.namprd05.prod.outlook.com (20.176.79.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.9; Tue, 9 Apr 2019 07:36:36 +0000
Received: from DM6PR05MB5883.namprd05.prod.outlook.com
 ([fe80::d5d5:7b9f:869e:9c43]) by DM6PR05MB5883.namprd05.prod.outlook.com
 ([fe80::d5d5:7b9f:869e:9c43%5]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:36:36 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5103.namprd05.prod.outlook.com (20.177.250.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 07:35:10 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:35:10 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/3] qtnfmac: allow to control DFS slave radar detection
Thread-Topic: [PATCH 2/3] qtnfmac: allow to control DFS slave radar detection
Thread-Index: AQHU7qbDxK8saf+Zg0+BlKCDHeW1Xg==
Date:   Tue, 9 Apr 2019 07:35:10 +0000
Message-ID: <20190409073500.16402-3-sergey.matyukevich.os@quantenna.com>
References: <20190409073500.16402-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190409073500.16402-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:a03:100::29) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93d54d7e-70bf-4d72-0fcf-08d6bcbde55f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5103;
x-ms-traffictypediagnostic: SN6PR05MB5103:|DM6PR05MB4475:
x-moderation-data: 4/9/2019 7:36:35 AM
x-microsoft-antispam-prvs: <DM6PR05MB447520446990D03936D2B911A32D0@DM6PR05MB4475.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(366004)(376002)(39850400004)(189003)(199004)(99286004)(76176011)(25786009)(8936002)(97736004)(26005)(386003)(2906002)(102836004)(6506007)(54906003)(316002)(6486002)(105586002)(106356001)(103116003)(68736007)(71190400001)(6916009)(2501003)(14454004)(1076003)(36756003)(6436002)(81166006)(71200400001)(50226002)(81156014)(478600001)(7736002)(8676002)(86362001)(486006)(2616005)(436003)(2351001)(6512007)(446003)(11346002)(5640700003)(53936002)(186003)(4326008)(107886003)(5660300002)(14444005)(5024004)(256004)(305945005)(52116002)(66066001)(3846002)(6116002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4475;H:DM6PR05MB5883.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XCvB0P/ZUt5jNebv6IXmLUisxfEWVw01nRLSnVmXc481Ay3AnqJtZT1/z9t9Elj8Mz9gc5X+Wwe39UUxRHRhEsTNe8IGRa3LKh1JJXfrA8kLuJAVgTgOHCccyHlZStqcuISOu+KV+d6Ncg7Z2viBlO5PlgrZQclVbEc3FtfGRUvMQhpwJ+UG6GGOEP7z9IJuZfq8PjmysxeUjaCHQQaGarKMLzqScN+B+vC0Ti9jJteIhh4AmnZ5yX7cNK7FlUXMNI61p1YCnpxyZTZTkhd/El7qvenW8UiC6LU8ZvoQ9JBXzhZ02Ss3+9NOlc+jsHECPb4Tekyk1eYVuAvCGOlcZ4KMlNZ8i1dXe+imIfmbb6LM30gscP4rjGwy0xZPD/AvhrI6zX77UNcOADWkhhCOF5lrrx3PlehZ8DbBkc/3CBM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d54d7e-70bf-4d72-0fcf-08d6bcbde55f
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 07:36:36.8999
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4475
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogSWdvciBNaXRzeWFua28gPGlnb3IubWl0c3lhbmtvLm9zQHF1YW50ZW5uYS5jb20+DQoN
CkluIEVUU0kgcmVnaW9uIERGUyBzbGF2ZSBkZXZpY2UgY2FuIG9wZXJhdGUgaW4gdHdvIG1vZGVz
IG9uIERGUyBjaGFubmVsczoNCiAtIGRvIG9uLWNoYW5uZWwgcmFkYXIgZGV0ZWN0aW9uIGFuZCB1
c2UgaGlnaGVyIFR4IHBvd2VyDQogLSBkb24ndCBkbyByYWRhciBkZXRlY3Rpb24gYW5kIHVzZSBs
b3dlciBUeCBwb3dlciBhcyBhIGNvbnNlcXVlbmNlDQoNCkFsbG93IHVzZXIgdG8gY29udHJvbCB0
aGF0IGJlaGF2aW9yIHRocm91Z2ggcXRuZm1hYyBtb2R1bGUgcGFyYW1ldGVyLg0KDQpTaWduZWQt
b2ZmLWJ5OiBJZ29yIE1pdHN5YW5rbyA8aWdvci5taXRzeWFua28ub3NAcXVhbnRlbm5hLmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NmZzgwMjExLmMg
fCAyICstDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29tbWFuZHMu
YyB8IDQgKysrLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvbW1h
bmRzLmggfCAzICsrLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2Nv
cmUuYyAgICAgfCA5ICsrKysrKysrKw0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9x
dG5mbWFjL2NvcmUuaCAgICAgfCAxICsNCiBkcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEv
cXRuZm1hYy9xbGluay5oICAgIHwgNCArKystDQogNiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRp
b25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcXVhbnRlbm5hL3F0bmZtYWMvY2ZnODAyMTEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1
YW50ZW5uYS9xdG5mbWFjL2NmZzgwMjExLmMNCmluZGV4IGM3ODUwMGJjYWEyZC4uZDkwMDE2MTI1
ZGZjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMv
Y2ZnODAyMTEuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMv
Y2ZnODAyMTEuYw0KQEAgLTEwMDgsNyArMTAwOCw3IEBAIHN0YXRpYyB2b2lkIHF0bmZfY2ZnODAy
MTFfcmVnX25vdGlmaWVyKHN0cnVjdCB3aXBoeSAqd2lwaHksDQogCXByX2RlYnVnKCJNQUMldTog
aW5pdGlhdG9yPSVkIGFscGhhPSVjJWNcbiIsIG1hYy0+bWFjaWQsIHJlcS0+aW5pdGlhdG9yLA0K
IAkJIHJlcS0+YWxwaGEyWzBdLCByZXEtPmFscGhhMlsxXSk7DQogDQotCXJldCA9IHF0bmZfY21k
X3JlZ19ub3RpZnkobWFjLCByZXEpOw0KKwlyZXQgPSBxdG5mX2NtZF9yZWdfbm90aWZ5KG1hYywg
cmVxLCBxdG5mX21hY19zbGF2ZV9yYWRhcl9nZXQod2lwaHkpKTsNCiAJaWYgKHJldCkgew0KIAkJ
cHJfZXJyKCJNQUMldTogZmFpbGVkIHRvIHVwZGF0ZSByZWdpb24gdG8gJWMlYzogJWRcbiIsDQog
CQkgICAgICAgbWFjLT5tYWNpZCwgcmVxLT5hbHBoYTJbMF0sIHJlcS0+YWxwaGEyWzFdLCByZXQp
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2Nv
bW1hbmRzLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1hYy9jb21tYW5k
cy5jDQppbmRleCAyMjMxM2E0NmMzYWUuLjQ1OWY2YjgxZDJlYiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvbW1hbmRzLmMNCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvbW1hbmRzLmMNCkBAIC0yMzY3LDcg
KzIzNjcsOCBAQCBpbnQgcXRuZl9jbWRfc2VuZF91cGRvd25faW50ZihzdHJ1Y3QgcXRuZl92aWYg
KnZpZiwgYm9vbCB1cCkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQotaW50IHF0bmZfY21kX3JlZ19u
b3RpZnkoc3RydWN0IHF0bmZfd21hYyAqbWFjLCBzdHJ1Y3QgcmVndWxhdG9yeV9yZXF1ZXN0ICpy
ZXEpDQoraW50IHF0bmZfY21kX3JlZ19ub3RpZnkoc3RydWN0IHF0bmZfd21hYyAqbWFjLCBzdHJ1
Y3QgcmVndWxhdG9yeV9yZXF1ZXN0ICpyZXEsDQorCQkJYm9vbCBzbGF2ZV9yYWRhcikNCiB7DQog
CXN0cnVjdCB3aXBoeSAqd2lwaHkgPSBwcml2X3RvX3dpcGh5KG1hYyk7DQogCXN0cnVjdCBxdG5m
X2J1cyAqYnVzID0gbWFjLT5idXM7DQpAQCAtMjQyOSw2ICsyNDMwLDcgQEAgaW50IHF0bmZfY21k
X3JlZ19ub3RpZnkoc3RydWN0IHF0bmZfd21hYyAqbWFjLCBzdHJ1Y3QgcmVndWxhdG9yeV9yZXF1
ZXN0ICpyZXEpDQogCQlicmVhazsNCiAJfQ0KIA0KKwljbWQtPnNsYXZlX3JhZGFyID0gc2xhdmVf
cmFkYXI7DQogCWNtZC0+bnVtX2NoYW5uZWxzID0gMDsNCiANCiAJZm9yIChiYW5kID0gMDsgYmFu
ZCA8IE5VTV9OTDgwMjExX0JBTkRTOyBiYW5kKyspIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1hYy9jb21tYW5kcy5oIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29tbWFuZHMuaA0KaW5kZXggNjQwNjM2NTI4N2ZjLi44
OGQ3YTNjZDkwZDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEv
cXRuZm1hYy9jb21tYW5kcy5oDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEv
cXRuZm1hYy9jb21tYW5kcy5oDQpAQCAtNTcsNyArNTcsOCBAQCBpbnQgcXRuZl9jbWRfc2VuZF9k
aXNjb25uZWN0KHN0cnVjdCBxdG5mX3ZpZiAqdmlmLA0KIAkJCSAgICAgdTE2IHJlYXNvbl9jb2Rl
KTsNCiBpbnQgcXRuZl9jbWRfc2VuZF91cGRvd25faW50ZihzdHJ1Y3QgcXRuZl92aWYgKnZpZiwN
CiAJCQkgICAgICBib29sIHVwKTsNCi1pbnQgcXRuZl9jbWRfcmVnX25vdGlmeShzdHJ1Y3QgcXRu
Zl93bWFjICptYWMsIHN0cnVjdCByZWd1bGF0b3J5X3JlcXVlc3QgKnJlcSk7DQoraW50IHF0bmZf
Y21kX3JlZ19ub3RpZnkoc3RydWN0IHF0bmZfd21hYyAqbWFjLCBzdHJ1Y3QgcmVndWxhdG9yeV9y
ZXF1ZXN0ICpyZXEsDQorCQkJYm9vbCBzbGF2ZV9yYWRhcik7DQogaW50IHF0bmZfY21kX2dldF9j
aGFuX3N0YXRzKHN0cnVjdCBxdG5mX3dtYWMgKm1hYywgdTE2IGNoYW5uZWwsDQogCQkJICAgIHN0
cnVjdCBxdG5mX2NoYW5fc3RhdHMgKnN0YXRzKTsNCiBpbnQgcXRuZl9jbWRfc2VuZF9jaGFuX3N3
aXRjaChzdHJ1Y3QgcXRuZl92aWYgKnZpZiwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9xdWFudGVubmEvcXRuZm1hYy9jb3JlLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFu
dGVubmEvcXRuZm1hYy9jb3JlLmMNCmluZGV4IDU0ZWE4NmFlNDk1OS4uYWQwYzllMDEyMDU2IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29yZS5j
DQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1hYy9jb3JlLmMNCkBA
IC0xNiw2ICsxNiwxMCBAQA0KICNkZWZpbmUgUVRORl9ETVBfTUFYX0xFTiA0OA0KICNkZWZpbmUg
UVRORl9QUklNQVJZX1ZJRl9JRFgJMA0KIA0KK3N0YXRpYyBib29sIHNsYXZlX3JhZGFyID0gdHJ1
ZTsNCittb2R1bGVfcGFyYW0oc2xhdmVfcmFkYXIsIGJvb2wsIDA2NDQpOw0KK01PRFVMRV9QQVJN
X0RFU0Moc2xhdmVfcmFkYXIsICJzZXQgMCB0byBkaXNhYmxlIHJhZGFyIGRldGVjdGlvbiBpbiBz
bGF2ZSBtb2RlIik7DQorDQogc3RydWN0IHF0bmZfZnJhbWVfbWV0YV9pbmZvIHsNCiAJdTggbWFn
aWNfczsNCiAJdTggaWZpZHg7DQpAQCAtNDI2LDYgKzQzMCwxMSBAQCBzdGF0aWMgc3RydWN0IHF0
bmZfd21hYyAqcXRuZl9jb3JlX21hY19hbGxvYyhzdHJ1Y3QgcXRuZl9idXMgKmJ1cywNCiAJcmV0
dXJuIG1hYzsNCiB9DQogDQorYm9vbCBxdG5mX21hY19zbGF2ZV9yYWRhcl9nZXQoc3RydWN0IHdp
cGh5ICp3aXBoeSkNCit7DQorCXJldHVybiBzbGF2ZV9yYWRhcjsNCit9DQorDQogc3RhdGljIGNv
bnN0IHN0cnVjdCBldGh0b29sX29wcyBxdG5mX2V0aHRvb2xfb3BzID0gew0KIAkuZ2V0X2Rydmlu
Zm8gPSBjZmc4MDIxMV9nZXRfZHJ2aW5mbywNCiB9Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUuaA0KaW5kZXggYWY4MzcyZGZiOTI3Li5kNWNhZmY0NWFj
NDcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1hYy9j
b3JlLmgNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUu
aA0KQEAgLTEzNCw2ICsxMzQsNyBAQCBzdHJ1Y3QgcXRuZl92aWYgKnF0bmZfbWFjX2dldF9mcmVl
X3ZpZihzdHJ1Y3QgcXRuZl93bWFjICptYWMpOw0KIHN0cnVjdCBxdG5mX3ZpZiAqcXRuZl9tYWNf
Z2V0X2Jhc2VfdmlmKHN0cnVjdCBxdG5mX3dtYWMgKm1hYyk7DQogdm9pZCBxdG5mX21hY19pZmFj
ZV9jb21iX2ZyZWUoc3RydWN0IHF0bmZfd21hYyAqbWFjKTsNCiB2b2lkIHF0bmZfbWFjX2V4dF9j
YXBzX2ZyZWUoc3RydWN0IHF0bmZfd21hYyAqbWFjKTsNCitib29sIHF0bmZfbWFjX3NsYXZlX3Jh
ZGFyX2dldChzdHJ1Y3Qgd2lwaHkgKndpcGh5KTsNCiBzdHJ1Y3Qgd2lwaHkgKnF0bmZfd2lwaHlf
YWxsb2NhdGUoc3RydWN0IHF0bmZfYnVzICpidXMpOw0KIGludCBxdG5mX2NvcmVfbmV0X2F0dGFj
aChzdHJ1Y3QgcXRuZl93bWFjICptYWMsIHN0cnVjdCBxdG5mX3ZpZiAqcHJpdiwNCiAJCQkgY29u
c3QgY2hhciAqbmFtZSwgdW5zaWduZWQgY2hhciBuYW1lX2Fzc2lnbl90eXBlKTsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEvcXRuZm1hYy9xbGluay5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvcWxpbmsuaA0KaW5kZXggMTU4Yzll
YmEyMGVmLi44YTNjNjM0NGZhOGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9x
dWFudGVubmEvcXRuZm1hYy9xbGluay5oDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFu
dGVubmEvcXRuZm1hYy9xbGluay5oDQpAQCAtNTg4LDYgKzU4OCw3IEBAIGVudW0gcWxpbmtfdXNl
cl9yZWdfaGludF90eXBlIHsNCiAgKglvZiAmZW51bSBxbGlua191c2VyX3JlZ19oaW50X3R5cGUu
DQogICogQG51bV9jaGFubmVsczogbnVtYmVyIG9mICZzdHJ1Y3QgcWxpbmtfdGx2X2NoYW5uZWwg
aW4gYSB2YXJpYWJsZSBwb3J0aW9uIG9mIGENCiAgKglwYXlsb2FkLg0KKyAqIEBzbGF2ZV9yYWRh
cjogd2hldGhlciBzbGF2ZSBkZXZpY2Ugc2hvdWxkIGVuYWJsZSByYWRhciBkZXRlY3Rpb24uDQog
ICogQGRmc19yZWdpb246IG9uZSBvZiAmZW51bSBxbGlua19kZnNfcmVnaW9ucy4NCiAgKiBAaW5m
bzogdmFyaWFibGUgcG9ydGlvbiBvZiByZWd1bGF0b3J5IG5vdGlmaWVyIGNhbGxiYWNrLg0KICAq
Lw0KQEAgLTU5OCw3ICs1OTksOCBAQCBzdHJ1Y3QgcWxpbmtfY21kX3JlZ19ub3RpZnkgew0KIAl1
OCB1c2VyX3JlZ19oaW50X3R5cGU7DQogCXU4IG51bV9jaGFubmVsczsNCiAJdTggZGZzX3JlZ2lv
bjsNCi0JdTggcnN2ZFsyXTsNCisJdTggc2xhdmVfcmFkYXI7DQorCXU4IHJzdmRbMV07DQogCXU4
IGluZm9bMF07DQogfSBfX3BhY2tlZDsNCiANCi0tIA0KMi4xMS4wDQoNCg==
