Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459F1C04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD32920881
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="cjOotjrE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD32920881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bowerswilkins.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbeJPBd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:33:57 -0400
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:64949
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726639AbeJPBd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9yEZSDEB98IkYgszixDzjWEhfLZka6ppj9hYOrfSFI=;
 b=cjOotjrEAYh7zCdHOJEq0JfZZ5hr0CnmAfvXv36duL3g3RONPkYVfkmtWrXvYBl0tiyEjmhCDLVvz89GIFmEAZ3n0sgZdzgdEeMyt0wUUwR4DAPKjB51ttUN1mnE7fNrToIp5Rvl4tXefs1chxnf3RWF1RF6IM6MLxTdKLex+Fs=
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com (52.135.130.151) by
 DB7PR04MB4795.eurprd04.prod.outlook.com (20.176.233.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.21; Mon, 15 Oct 2018 17:47:37 +0000
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::7cbe:f327:4f1c:dd56]) by DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::7cbe:f327:4f1c:dd56%4]) with mapi id 15.20.1228.027; Mon, 15 Oct 2018
 17:47:37 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: fix frequent flase radar detection
Thread-Topic: [PATCH] ath: fix frequent flase radar detection
Thread-Index: AQHUZEUUq14zlLHERkWqBORcZ4StNqUglb0A
Date:   Mon, 15 Oct 2018 17:47:36 +0000
Message-ID: <b0e823e3-275c-86ab-dce0-dd522ebd3711@bowerswilkins.com>
References: <1539580047-22512-1-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1539580047-22512-1-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::29) To DB7PR04MB4154.eurprd04.prod.outlook.com
 (2603:10a6:5:26::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2001:1900:2200:85:d6be:d9ff:fe0e:a5ac]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR04MB4795;6:3pDjicglMCf7uBa5aI15CHMdb5tzzB2O05QfcBnCuPv8NKpxMYhuoPYQC7hU/GSt/eZ9vFiUbpd0zCi88WMY9+16a2bB7OlyOMvGK+v8G3k0jverBTB4Hz4V4k+MQmS/cxD2+20fuR+CgkSvQrufh9z/yvf7xUExi80E9BMsZsERAaVHgdUhrMHHKqXWy/xKuUhM2BZ9AINA5oIhu6aU5GPCFcZT9g7Oz832zS89FBXxov2ee3+MilURRBF0Zcdst2A+jJJAqPjb9AxVtqprs/N1tPKphFyL/tr2e1S1qJMAsjY/NHv6CwlT52Qi3MTYrot2ktsN27nt3dab133t4qybPV94p7HYu25pNLZ4fqXfAzhb+Eg5LpuOJWPgSoMvfYpdsAid89eT6DZCJyZOwYvyz/bUMyhCdt1htdlJOLDbJj+vX1FzyL3Toe3uJDojSMhXFdFUUm5T1Wyu5Ot8fA==;5:Od0sgfVOX4iPJnkG0ISyfLj7BrMpQBxPYcgiQAVs3BULsf2Jusj14dXhMlxyAR1AUEH45Gzs4b8lnqsWpBVU9NgrbMBl4ElwXZ0Zkbs2bg32YXSOoNx/KmU7VDT0KfidONOAiioSX6PJ19KOTHmoGtAsqrK5fjWZ6YGS3lUUoGg=;7:L6Mpo5lR9RmiKe+mF0uV5R16GFMK8aL4LQ0TG1he4xmHX+cj7M/cyUnNGcaDEsBYJBzcc6Re61OrqMm8Qro/iEUcHEPB9vCdJFh+4VecVSH1vRP+vdJIhcBv6j02xvcKS1QBA6gflLmeJZ8+NVxfhOwLatBvKsnn4MA00kGZLnbpMlydRNFQxoS3l9t6bR1QBN68gMVZdZvAl0ivI1Mq2keksxQIXcoEwQATFz1tEyhgSkgKkX1JVbG/UlCN3UIj
x-ms-office365-filtering-correlation-id: 12e6a1d0-674e-45f3-7220-08d632c64b12
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4795;
x-ms-traffictypediagnostic: DB7PR04MB4795:
x-microsoft-antispam-prvs: <DB7PR04MB4795FDEE5194AD8523EAB5E799FD0@DB7PR04MB4795.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(143592264062825);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991067);SRVR:DB7PR04MB4795;BCL:0;PCL:0;RULEID:;SRVR:DB7PR04MB4795;
x-forefront-prvs: 0826B2F01B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(366004)(39850400004)(136003)(199004)(189003)(86362001)(575784001)(68736007)(53936002)(102836004)(6512007)(6306002)(305945005)(110136005)(2906002)(6486002)(8936002)(81156014)(52116002)(31686004)(316002)(76176011)(99286004)(7736002)(6506007)(31696002)(53546011)(386003)(36756003)(5660300001)(8676002)(81166006)(6436002)(6116002)(229853002)(71200400001)(71190400001)(6246003)(186003)(486006)(2900100001)(476003)(2501003)(44832011)(478600001)(11346002)(105586002)(106356001)(4326008)(256004)(97736004)(966005)(14454004)(2616005)(5250100002)(25786009)(446003)(46003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4795;H:DB7PR04MB4154.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: BIFlX1N4++7tZn+gEOCduzNtNAXDnHHHdoyL2gqcvCuyKblff7zes9Ext0uSVQyTZT0thc9iL4rvHnz7Mh6JOaV1kpGKXFUj3W6qguBiYCo6YE2VW0lCpS3BMWV7FQaVkWsH05YmTInbg0Gxe/UfciAqdXwLD7Kbg83tHY3StxXolKCnUORVAjMp3a7crDUHml4PRn9gsJXpB2rtUCAebUbDTFdDzptzblGUdVwPheD2ZXL/8av71Rj4cSyC0kS9RBaBkzj8SNJQGa+jCMc9UqMayN/+PsJin4T5tAX1pDiLlptkGeMFy0zm7Ux3mBEXn4MulHXFnU0tG5FZbRgR4OfMffC+KPAXY6s0ORyGPPs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4CED3A77DA9D4498185070E429BD565@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e6a1d0-674e-45f3-7220-08d632c64b12
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2018 17:47:37.0011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4795
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzE0LzIwMTggMTA6MDcgUE0sIFRhbWl6aCBjaGVsdmFtIHdyb3RlOg0KPiBNYW55
IG51bWJlciBvZiBmYWxzZSByYWRhciBkZXRlY3Rpb24gb2NjdXJyZWQgaW4gYSBub2lzeQ0KPiBl
bnZpcm9ubWVudCBpbiBRQ0E0MDE5LCBRQ0E5ODg4IGRldmljZXMuIEJ5IHJlZHVjaW5nDQo+IFBS
SV9UT0xFUkFOQ0UgdG8gNiBhbmQgZmx1c2hpbmcgb3V0IHB1bHNlIHF1ZXVlIGJ5IGRwZF9yZXNl
dA0KPiBpZiB0aW1lc3RhbXAgYmV0d2VlbiBjdXJyZW50IGFuZCBwcmV2aW91cyBwdWxzZSBpcyBs
ZXNzZXIgdGhhbg0KPiAxMDBtcyBoZWxwcyB0byBhdm9pZC9yZWR1Y2UgdGhpcyBmYWxzZSByYWRh
ciBkZXRlY3Rpb24NCj4gaW4gdGhlIG5vaXN5IGVudmlyb25tZW50Lg0KPg0KPiBUZXN0ZWQgYXRo
MTBrIGh3IGFuZCBmdzoNCj4gCSogUUNBOTg4OCgxMC40LTMuNS4xLTAwMDUyKQ0KPiAJKiBRQ0E0
MDE5KDEwLjQtMy4yLjEuMS0wMDAxNykNCj4gCSogUUNBOTk4NCgxMC40LTMuNi0wMDEwNCkNCj4g
CSogUUNBOTg4WCgxMC4yLjQtMS4wLTAwMDQxKQ0KPg0KPiBUZXN0ZWQgYXRoOWsgaHc6IEFSOTMw
MA0KUGxlYXNlIHBvc3QgdGhlIHJhZGFyIGRldGVjdGlvbiByYXRlIHJlc3VsdHMgYmVmb3JlIGFu
ZCBhZnRlciB0aGlzIGNoYW5nZS4NCkVzcGVjaWFsbHkgZm9yIEVUU0kgYXQgMzAlIGNoYW5uZWwg
bG9hZC4NCj4gU2lnbmVkLW9mZi1ieTogVGFtaXpoIGNoZWx2YW0gPHRhbWl6aHJAY29kZWF1cm9y
YS5vcmc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGguaCAgICAgICAg
ICAgICAgICAgIHwgMiArKw0KPiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvbWFj
LmMgICAgICAgICAgIHwgNCArKysrDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2luaXQuYyAgICAgICAgICAgfCAxICsNCj4gICBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvZGZz
X3BhdHRlcm5fZGV0ZWN0b3IuYyB8IDQgKysrLQ0KPiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0
aC9kZnNfcGF0dGVybl9kZXRlY3Rvci5oIHwgMiArLQ0KPiAgIDUgZmlsZXMgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGguaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGguaA0K
PiBpbmRleCA3YTM2NGVjLi4yYmYyZDBjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aC5oDQo+
IEBAIC0xODQsNiArMTg0LDggQEAgc3RydWN0IGF0aF9jb21tb24gew0KPiAgIA0KPiAgIAlpbnQg
bGFzdF9yc3NpOw0KPiAgIAlzdHJ1Y3QgaWVlZTgwMjExX3N1cHBvcnRlZF9iYW5kIHNiYW5kc1tO
VU1fTkw4MDIxMV9CQU5EU107DQo+ICsNCj4gKwlpbnQgZGZzX3B1bHNlX3ZhbGlkX2RpZmZfdHM7
DQo+ICAgfTsNCj4gICANCj4gICBzdGF0aWMgaW5saW5lIGNvbnN0IHN0cnVjdCBhdGhfcHNfb3Bz
ICphdGhfcHNfb3BzKHN0cnVjdCBhdGhfY29tbW9uICpjb21tb24pDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL21hYy5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDEway9tYWMuYw0KPiBpbmRleCBhMWMyODAxLi5jOTNiODFjIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL21hYy5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvbWFjLmMNCj4gQEAgLTgyNzUsNiArODI3NSw4IEBA
IHN0cnVjdCBhdGgxMGtfdmlmICphdGgxMGtfZ2V0X2FydmlmKHN0cnVjdCBhdGgxMGsgKmFyLCB1
MzIgdmRldl9pZCkNCj4gICAjZGVmaW5lIFdSRF9NRVRIT0QgIldSREQiDQo+ICAgI2RlZmluZSBX
UkREX1dJRkkgICgweDA3KQ0KPiAgIA0KPiArI2RlZmluZSBBVEgxMEtfREZTX1BVTFNFX1ZBTElE
X0RJRkZfVFMgMTAwDQo+ICsNCj4gICBzdGF0aWMgdTMyIGF0aDEwa19tYWNfd3JkZF9nZXRfbWNj
KHN0cnVjdCBhdGgxMGsgKmFyLCB1bmlvbiBhY3BpX29iamVjdCAqd3JkZCkNCj4gICB7DQo+ICAg
CXVuaW9uIGFjcGlfb2JqZWN0ICptY2NfcGtnOw0KPiBAQCAtODY0Miw2ICs4NjQ0LDggQEAgaW50
IGF0aDEwa19tYWNfcmVnaXN0ZXIoc3RydWN0IGF0aDEwayAqYXIpDQo+ICAgCWlmIChJU19FTkFC
TEVEKENPTkZJR19BVEgxMEtfREZTX0NFUlRJRklFRCkpIHsNCj4gICAJCS8qIEluaXQgYXRoIGRm
cyBwYXR0ZXJuIGRldGVjdG9yICovDQo+ICAgCQlhci0+YXRoX2NvbW1vbi5kZWJ1Z19tYXNrID0g
QVRIX0RCR19ERlM7DQo+ICsJCWFyLT5hdGhfY29tbW9uLmRmc19wdWxzZV92YWxpZF9kaWZmX3Rz
ID0NCj4gKwkJCQkJQVRIMTBLX0RGU19QVUxTRV9WQUxJRF9ESUZGX1RTOw0KPiAgIAkJYXItPmRm
c19kZXRlY3RvciA9IGRmc19wYXR0ZXJuX2RldGVjdG9yX2luaXQoJmFyLT5hdGhfY29tbW9uLA0K
PiAgIAkJCQkJCQkgICAgIE5MODAyMTFfREZTX1VOU0VUKTsNCj4gICANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9pbml0LmMgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoOWsvaW5pdC5jDQo+IGluZGV4IGMwNzBhOWUuLjdlYTQ0NjAgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9pbml0LmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2luaXQuYw0KPiBAQCAtNjk2LDYgKzY5Niw3IEBA
IHN0YXRpYyBpbnQgYXRoOWtfaW5pdF9zb2Z0Yyh1MTYgZGV2aWQsIHN0cnVjdCBhdGhfc29mdGMg
KnNjLA0KPiAgIAljb21tb24tPmRlYnVnX21hc2sgPSBhdGg5a19kZWJ1ZzsNCj4gICAJY29tbW9u
LT5idGNvZXhfZW5hYmxlZCA9IGF0aDlrX2J0Y29leF9lbmFibGUgPT0gMTsNCj4gICAJY29tbW9u
LT5kaXNhYmxlX2FuaSA9IGZhbHNlOw0KPiArCWNvbW1vbi0+ZGZzX3B1bHNlX3ZhbGlkX2RpZmZf
dHMgPSAwOw0KV2h5IGl0J3MgMCBoZXJlIHdoaWxlIGF0aDEwayBpcyB1c2luZyAxMDB1cz8NCj4g
ICANCj4gICAJLyoNCj4gICAJICogUGxhdGZvcm0gcXVpcmtzLg0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2Rmc19wYXR0ZXJuX2RldGVjdG9yLmMgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvZGZzX3BhdHRlcm5fZGV0ZWN0b3IuYw0KPiBpbmRleCBkNTJiMzFiLi4z
ZGJmMGFiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvZGZzX3BhdHRl
cm5fZGV0ZWN0b3IuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvZGZzX3BhdHRl
cm5fZGV0ZWN0b3IuYw0KPiBAQCAtMjczLDYgKzI3Myw3IEBAIHN0YXRpYyB2b2lkIGRwZF9leGl0
KHN0cnVjdCBkZnNfcGF0dGVybl9kZXRlY3RvciAqZHBkKQ0KPiAgIHsNCj4gICAJdTMyIGk7DQo+
ICAgCXN0cnVjdCBjaGFubmVsX2RldGVjdG9yICpjZDsNCj4gKwlpbnQgZGlmZl90czsNCj4gICAN
Cj4gICAJLyoNCj4gICAJICogcHVsc2VzIHJlY2VpdmVkIGZvciBhIG5vbi1zdXBwb3J0ZWQgb3Ig
dW4taW5pdGlhbGl6ZWQNCj4gQEAgLTI4NSw4ICsyODYsOSBAQCBzdGF0aWMgdm9pZCBkcGRfZXhp
dChzdHJ1Y3QgZGZzX3BhdHRlcm5fZGV0ZWN0b3IgKmRwZCkNCj4gICAJaWYgKGNkID09IE5VTEwp
DQo+ICAgCQlyZXR1cm4gZmFsc2U7DQo+ICAgDQo+ICsJZGlmZl90cyA9IGV2ZW50LT50cyAtIGRw
ZC0+bGFzdF9wdWxzZV90czsNCj4gICAJLyogcmVzZXQgZGV0ZWN0b3Igb24gdGltZSBzdGFtcCB3
cmFwYXJvdW5kLCBjYXVzZWQgYnkgVFNGIHJlc2V0ICovDQo+IC0JaWYgKGV2ZW50LT50cyA8IGRw
ZC0+bGFzdF9wdWxzZV90cykNCj4gKwlpZiAoZGlmZl90cyA8IGRwZC0+Y29tbW9uLT5kZnNfcHVs
c2VfdmFsaWRfZGlmZl90cykNClRoaXMgaXMgb25seSB2YWxpZCB3aGVuIDEgcmFkYXIgcGF0dGVy
biBkZXRlY3RlZCBhdCBhIHRpbWUuDQpCdXQgdGhlcmUgYXJlIG1hbnkgbG9jYXRpb25zIHRoYXQg
b3ZlcmxhcHBlZCB3aXRoIG11bHRpcGxlIHJhZGFyIGVxdWlwbWVudC4NCkhvdyB0aGlzIGNoYW5n
ZSBoYW5kbGVzIGlmIDIgZGlmZmVyZW50IHJhZGFycyBkZXRlY3RlZCBhdCB0aGUgc2FtZSB0aW1l
Pw0KQ2hlY2sgb3V0IHRoZSByYWRhciBvcGVyYXRpb24gY2VudGVyIGRlcGxveWVkLg0KaHR0cHM6
Ly93d3cucm9jLm5vYWEuZ292L1dTUjg4RC9NYXBzLmFzcHgNCj4gICAJCWRwZF9yZXNldChkcGQp
Ow0KPiAgIAlkcGQtPmxhc3RfcHVsc2VfdHMgPSBldmVudC0+dHM7DQo+ICAgDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvZGZzX3BhdHRlcm5fZGV0ZWN0b3IuaCBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9kZnNfcGF0dGVybl9kZXRlY3Rvci5oDQo+IGluZGV4IDE4
ZGI2ZjQuLjZmNDE5ZDQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9k
ZnNfcGF0dGVybl9kZXRlY3Rvci5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9k
ZnNfcGF0dGVybl9kZXRlY3Rvci5oDQo+IEBAIC0yNCw3ICsyNCw3IEBADQo+ICAgLyogdG9sZXJh
dGVkIGRldmlhdGlvbiBvZiByYWRhciB0aW1lIHN0YW1wIGluIHVzZWNzIG9uIGJvdGggc2lkZXMN
Cj4gICAgKiBUT0RPOiB0aGlzIG1pZ2h0IG5lZWQgdG8gYmUgSFctZGVwZW5kZW50DQo+ICAgICov
DQo+IC0jZGVmaW5lIFBSSV9UT0xFUkFOQ0UJMTYNCj4gKyNkZWZpbmUgUFJJX1RPTEVSQU5DRQk2
DQpXaGF0IGlzIHRoaXMgbnVtYmVyIDYgY29tZSBmcm9tPw0KDQpUaGFua3MsDQpQZXRlcg0K
