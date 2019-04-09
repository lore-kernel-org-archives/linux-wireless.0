Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FABFC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7B812083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="OipIiMGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfDIHhZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:37:25 -0400
Received: from mail-eopbgr750077.outbound.protection.outlook.com ([40.107.75.77]:51321
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbfDIHhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EERBV6nb/dsmWXhPUw28pwhZUxjUbcj+IcQJNU+tCR0=;
 b=OipIiMGpJPBMuafZlYVcdGqgbV80R3fWeRNK1Mv3hzyI41zZFZsSyyhoUs+78UBuKj+vtPz37mGV+U8rUbEjGBDRtvUkBdyZVMBkDRPw1vNWENZhVEFK2H0cdNxjAcDRqhUsN7cysbp93BKyYY4Til+Ne0UNKUGRnllJOT7IGqc=
Received: from BL0PR05MB4722.namprd05.prod.outlook.com (20.177.145.27) by
 BL0PR05MB5361.namprd05.prod.outlook.com (10.167.233.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 07:36:42 +0000
Received: from BL0PR05MB4722.namprd05.prod.outlook.com
 ([fe80::7959:ceb:bcd4:3a4a]) by BL0PR05MB4722.namprd05.prod.outlook.com
 ([fe80::7959:ceb:bcd4:3a4a%6]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:36:42 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5103.namprd05.prod.outlook.com (20.177.250.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Tue, 9 Apr 2019 07:35:13 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 07:35:13 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/3] qtnfmac: modify debugfs to support multiple cards
Thread-Topic: [PATCH 3/3] qtnfmac: modify debugfs to support multiple cards
Thread-Index: AQHU7qbEKxJKXs9UZ0mNm7MOZX9zoA==
Date:   Tue, 9 Apr 2019 07:35:12 +0000
Message-ID: <20190409073500.16402-4-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: df2b83af-f897-4889-3b90-08d6bcbde65c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5103;
x-ms-traffictypediagnostic: SN6PR05MB5103:|BL0PR05MB5361:
x-moderation-data: 4/9/2019 7:36:40 AM
x-microsoft-antispam-prvs: <BL0PR05MB53610661AF25363EB31970CEA32D0@BL0PR05MB5361.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(346002)(136003)(366004)(189003)(199004)(81166006)(68736007)(14454004)(2616005)(436003)(71190400001)(71200400001)(11346002)(486006)(7736002)(5660300002)(66066001)(476003)(99286004)(386003)(6506007)(6436002)(305945005)(446003)(53936002)(186003)(106356001)(50226002)(8936002)(256004)(14444005)(81156014)(6512007)(52116002)(97736004)(6116002)(3846002)(478600001)(1076003)(107886003)(76176011)(54906003)(6916009)(316002)(2501003)(26005)(25786009)(2351001)(105586002)(2906002)(102836004)(4326008)(5640700003)(8676002)(6486002)(86362001)(36756003)(103116003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5361;H:BL0PR05MB4722.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dpFXfpTCWrXIGZWEkhHsfkQk/iZVdBH/lfiey3N6Z6je/Kt+ysoZ/96SjuM+y2/OshFewjD584ISMwulZ3dHuW7zkyOzu9wjs/xv0axdOLo8XlgwhZi/BeximSBWFZGAqRkZtSLyJuufCoknFTvKSBsq8Dz3VcdYHEiOTcvZn+ZJctbWg0vPFra1/OD+8hC2xv8h4ZTNievbEi+y7xkjz9LhYkud0RHNAx0RvFWy/3/7jYnsfmc89yAzJ8nzHDAwSF7n+BclFqENRjnn/ZzbcXPG004rL7LFPoLrMrh5/7I1NFAKxqvuWmV/cz6XeFaVLEuqel+/diA8gdADrfVGuodLNtmRsnnP0nVAxIH8ItKvhubboDpyX3roV41CcfIt4WKhMoHEFJMfXXrvA2sS0dXSnSYnKxBulRolzEflE0g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2b83af-f897-4889-3b90-08d6bcbde65c
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 07:36:42.6311
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5361
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhpcyBwYXRjaCBtb2RpZmllcyBsb2NhdGlvbiBvZiBkZWJ1Z2ZzIGVudHJpZXMgYW5kIHRoZWly
IG5hbWluZw0KY29udmVudGlvbnMgdG8gc3VwcG9ydCBtdWx0aXBsZSB3aXJlbGVzcyBjYXJkcyBv
biBwY2llIGhvc3QuDQpTZWxlY3RlZCBhcHByb2FjaCBpcyB0byB1c2Ugc2VwYXJhdGUgZGlyZWN0
b3JpZXMgZm9yIGRpZmZlcmVudA0Kd2lyZWxlc3MgY2FyZHMgaW4gdG9wLWxldmVsIHF0bmZtYWMg
ZGVidWdmcyBkaXJlY3RvcnkuDQoNCkhlcmUgaXMgYW4gZXhhbXBsZSB0aGF0IGNsYXJpZmllcyB0
aGUgY2hvc2VuIG5hbWluZyBjb252ZW50aW9uczoNCg0KICQgc3VkbyBscyAvc3lzL2tlcm5lbC9k
ZWJ1Zy9xdG5mbWFjLw0KICAgcXRuZm1hY19wY2llOjAwMDA6MDE6MDAuMA0KDQpTaWduZWQtb2Zm
LWJ5OiBTZXJnZXkgTWF0eXVrZXZpY2ggPHNlcmdleS5tYXR5dWtldmljaC5vc0BxdWFudGVubmEu
Y29tPg0KLS0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29yZS5j
ICB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrDQogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cXVhbnRlbm5hL3F0bmZtYWMvY29yZS5oICB8ICAxICsNCiBkcml2ZXJzL25ldC93aXJlbGVzcy9x
dWFudGVubmEvcXRuZm1hYy9kZWJ1Zy5jIHwgIDQgKysrLQ0KIDMgZmlsZXMgY2hhbmdlZCwgMzAg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29yZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cXVhbnRlbm5hL3F0bmZtYWMvY29yZS5jDQppbmRleCBhZDBjOWUwMTIwNTYuLjhkNjk5Y2MwM2Qy
NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2Nv
cmUuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29yZS5j
DQpAQCAtMjAsNiArMjAsOCBAQCBzdGF0aWMgYm9vbCBzbGF2ZV9yYWRhciA9IHRydWU7DQogbW9k
dWxlX3BhcmFtKHNsYXZlX3JhZGFyLCBib29sLCAwNjQ0KTsNCiBNT0RVTEVfUEFSTV9ERVNDKHNs
YXZlX3JhZGFyLCAic2V0IDAgdG8gZGlzYWJsZSByYWRhciBkZXRlY3Rpb24gaW4gc2xhdmUgbW9k
ZSIpOw0KIA0KK3N0YXRpYyBzdHJ1Y3QgZGVudHJ5ICpxdG5mX2RlYnVnZnNfZGlyOw0KKw0KIHN0
cnVjdCBxdG5mX2ZyYW1lX21ldGFfaW5mbyB7DQogCXU4IG1hZ2ljX3M7DQogCXU4IGlmaWR4Ow0K
QEAgLTg0OCw2ICs4NTAsMzAgQEAgdm9pZCBxdG5mX3BhY2tldF9zZW5kX2hpX3ByaShzdHJ1Y3Qg
c2tfYnVmZiAqc2tiKQ0KIH0NCiBFWFBPUlRfU1lNQk9MX0dQTChxdG5mX3BhY2tldF9zZW5kX2hp
X3ByaSk7DQogDQorc3RydWN0IGRlbnRyeSAqcXRuZl9nZXRfZGVidWdmc19kaXIodm9pZCkNCit7
DQorCXJldHVybiBxdG5mX2RlYnVnZnNfZGlyOw0KK30NCitFWFBPUlRfU1lNQk9MX0dQTChxdG5m
X2dldF9kZWJ1Z2ZzX2Rpcik7DQorDQorc3RhdGljIGludCBfX2luaXQgcXRuZl9jb3JlX3JlZ2lz
dGVyKHZvaWQpDQorew0KKwlxdG5mX2RlYnVnZnNfZGlyID0gZGVidWdmc19jcmVhdGVfZGlyKEtC
VUlMRF9NT0ROQU1FLCBOVUxMKTsNCisNCisJaWYgKElTX0VSUihxdG5mX2RlYnVnZnNfZGlyKSkN
CisJCXF0bmZfZGVidWdmc19kaXIgPSBOVUxMOw0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQorc3Rh
dGljIHZvaWQgX19leGl0IHF0bmZfY29yZV9leGl0KHZvaWQpDQorew0KKwlkZWJ1Z2ZzX3JlbW92
ZShxdG5mX2RlYnVnZnNfZGlyKTsNCit9DQorDQorbW9kdWxlX2luaXQocXRuZl9jb3JlX3JlZ2lz
dGVyKTsNCittb2R1bGVfZXhpdChxdG5mX2NvcmVfZXhpdCk7DQorDQogTU9EVUxFX0FVVEhPUigi
UXVhbnRlbm5hIENvbW11bmljYXRpb25zIik7DQogTU9EVUxFX0RFU0NSSVBUSU9OKCJRdWFudGVu
bmEgODAyLjExIHdpcmVsZXNzIExBTiBGdWxsTUFDIGRyaXZlci4iKTsNCiBNT0RVTEVfTElDRU5T
RSgiR1BMIik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0
bmZtYWMvY29yZS5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29y
ZS5oDQppbmRleCBkNWNhZmY0NWFjNDcuLjMyMjg1OGRmNjAwYyAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2NvcmUuaA0KKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcXVhbnRlbm5hL3F0bmZtYWMvY29yZS5oDQpAQCAtMTUzLDYgKzE1Myw3IEBA
IHZvaWQgcXRuZl92aXJ0dWFsX2ludGZfY2xlYW51cChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldik7
DQogdm9pZCBxdG5mX25ldGRldl91cGRvd24oc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGJvb2wg
dXApOw0KIHZvaWQgcXRuZl9zY2FuX2RvbmUoc3RydWN0IHF0bmZfd21hYyAqbWFjLCBib29sIGFi
b3J0ZWQpOw0KIHZvaWQgcXRuZl9wYWNrZXRfc2VuZF9oaV9wcmkoc3RydWN0IHNrX2J1ZmYgKnNr
Yik7DQorc3RydWN0IGRlbnRyeSAqcXRuZl9nZXRfZGVidWdmc19kaXIodm9pZCk7DQogDQogc3Rh
dGljIGlubGluZSBzdHJ1Y3QgcXRuZl92aWYgKnF0bmZfbmV0ZGV2X2dldF9wcml2KHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYpDQogew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1
YW50ZW5uYS9xdG5mbWFjL2RlYnVnLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9xdWFudGVubmEv
cXRuZm1hYy9kZWJ1Zy5jDQppbmRleCA1OThlY2U3NTNhNGIuLjJkMzU3NGMxZjEwZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2RlYnVnLmMNCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3F1YW50ZW5uYS9xdG5mbWFjL2RlYnVnLmMNCkBAIC01
LDcgKzUsOSBAQA0KIA0KIHZvaWQgcXRuZl9kZWJ1Z2ZzX2luaXQoc3RydWN0IHF0bmZfYnVzICpi
dXMsIGNvbnN0IGNoYXIgKm5hbWUpDQogew0KLQlidXMtPmRiZ19kaXIgPSBkZWJ1Z2ZzX2NyZWF0
ZV9kaXIobmFtZSwgTlVMTCk7DQorCXN0cnVjdCBkZW50cnkgKnBhcmVudCA9IHF0bmZfZ2V0X2Rl
YnVnZnNfZGlyKCk7DQorDQorCWJ1cy0+ZGJnX2RpciA9IGRlYnVnZnNfY3JlYXRlX2RpcihuYW1l
LCBwYXJlbnQpOw0KIH0NCiANCiB2b2lkIHF0bmZfZGVidWdmc19yZW1vdmUoc3RydWN0IHF0bmZf
YnVzICpidXMpDQotLSANCjIuMTEuMA0KDQo=
