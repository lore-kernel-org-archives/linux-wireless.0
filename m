Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CE5C32789
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 01:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EAF220831
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 01:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="gqHV4PNC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EAF220831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbeKCKyP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:54:15 -0400
Received: from mail-dm3nam03on0121.outbound.protection.outlook.com ([104.47.41.121]:21632
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726729AbeKCKyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 06:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHbs2I1DunMQEFeN9GhswRKnpiXyahT9Gk19gbqNCUE=;
 b=gqHV4PNC3E67uRYIjBt8pzzQVaNYlIg9OPV8MNiHKsOBLQPZEgdlrs6B8fxPEfUHVcX/5qw4cm0hUFW385wZwGBDGTJNFwRNJj0yi14JsaR0Xr7wX7XdZ45iA165ODMNxCq0JJp7p+gutheFPhM6JcmxdhtZcW4q7n7qROxn1m4=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4246.namprd06.prod.outlook.com (52.135.238.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Sat, 3 Nov 2018 01:44:24 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Sat, 3 Nov 2018
 01:44:24 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH v2 2/2] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Topic: [PATCH v2 2/2] brcmfmac: make firmware frameburst mode a module
 parameter
Thread-Index: AQHUcoV/WIxtZ0hPo0CVXdK0lG3H5qU8as2AgADdoYA=
Date:   Sat, 3 Nov 2018 01:44:23 +0000
Message-ID: <65433bdb-7d12-4f62-7825-db10064dc5e8@cypress.com>
References: <20181102082403.11676-1-wright.feng@cypress.com>
 <20181102082403.11676-3-wright.feng@cypress.com>
 <e280f751-6ec7-02fb-34af-92e3779d933a@broadcom.com>
In-Reply-To: <e280f751-6ec7-02fb-34af-92e3779d933a@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:202:16::13) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [123.194.189.50]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4246;6:MovQ4KI/Ca1Bsjwaau7kq3aPh5WDtehxNugkuvy7LZnmBBwl/7MB1xk7yGNgY8+3nVgR+ztMf7EtOAE0vnJoKWgLH70jOSlGoyrKKorXkCRzM++vgU3Y8HJL/9ltclItilK146bwk0HWcyUL387bm6eX4DvvluD01jUAdbOxltuvZD6nPH9k94a/KHIe2UBHoolpmHpJdJigP+5Dn2hcS1dhtp1AATGPmIatHSGka+KfV4YNyLTDd42LK87g0/CG8UKC4xCBbRJcAbH49wVboFMabDkEBxXlevjI2lcOaj3xZkFWEsoEYrEqnpr8oo/wHAzXhOyLIrZsBXvS8Zr0OL0f7v9c2ZbGkI7Ef8xJW6NHnzXdbwmQjK0Lp/XnVm7EMLbHchwzQO+fhC3eRcRtYIV11oc5DB5KodVpvja5wb3b+HhRWvtUy6afzwi+B3Zh7sLllAA5lUhqR/M12qq4Zw==;5:dVy528Gr5H3XLA0XwpGlNaaitJqf3loM28XPrvhiKKK5R0gusOV3460Jcvrxiw27fdzbrMm30Z3qNOoKowWWoQkUINTJyTA6awAVxsYPvj9HmXVblKcxlHoKkh5r8ig3uap91nRaRDbvtwyFpSc3cFtBnJHNSTX13F4d4gxljeA=;7:Cr4s8r6oZD6MJQn6b/3w4vYYklWmKoB+xVvaDoPkUrW75t+Hui4PK7vlgYoyfxsPOjEKhdZ3xblDKnvS6RpWK9+/cSqhLA8L/P/AMAIUqsvqeJO9J6UzicUzgQpXjsWyZVyIlr5V7XsFlFDWX9b1aQ==
x-ms-office365-filtering-correlation-id: e241afc2-1670-4a16-be12-08d6412de1ba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4246;
x-ms-traffictypediagnostic: BYAPR06MB4246:
x-microsoft-antispam-prvs: <BYAPR06MB42462825F8CD6DE30DC1F366FBC80@BYAPR06MB4246.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4246;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4246;
x-forefront-prvs: 08457955C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(346002)(366004)(376002)(189003)(199004)(72206003)(76176011)(52116002)(6506007)(386003)(305945005)(99286004)(5660300001)(316002)(31686004)(110136005)(54906003)(66066001)(6436002)(6246003)(102836004)(71200400001)(6512007)(25786009)(14454004)(2900100001)(478600001)(229853002)(4326008)(53936002)(53546011)(81156014)(8936002)(81166006)(68736007)(8676002)(105586002)(7736002)(106356001)(6486002)(3846002)(2906002)(6116002)(97736004)(71190400001)(2501003)(446003)(11346002)(31696002)(14444005)(186003)(256004)(486006)(26005)(36756003)(476003)(2616005)(86362001)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4246;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1bSUOoIex1T3Q+wxzO+VvlfmxJox80GJ9ZMhjP3kP303PRvNNeFVuiNeJHChyOSE/E+TOvG6+B7M34PqRxCIZv4OFgISs6faz7+Kx7QGCVCQsf4MuRaSW++GTqMPTZoeckUe1YhX3dWuV2tapAZcLjn4NyUROgXzfDjuhBaS2KJnAqxjfvuSmoPiGyftI+n7LtyMteoFPOkJyoqHBBmAr7zTc2yMeBNzv8yrBpxSOrhMGySnjH2VSYgQGZOmzNHnqQNbxfxqAvGqhqy9nyBGcGMIN5uxhXcU1rRwqO+2xCTCsKAwBprpmbWdNjD/pUyJHIpFFdYIxTXRaP/8O5JHkEUbgK2HODFczTuw/Ep44S4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <6504A8810051B14E94F63D112FF9C9F6@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e241afc2-1670-4a16-be12-08d6412de1ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2018 01:44:23.9855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4246
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCkFyZW5kIHZhbiBTcHJpZWwg5pa8IDExLzIvMjAxOCA4OjMxIFBNIOWvq+mBkzoNCj4gT24g
MTEvMi8yMDE4IDk6MjQgQU0sIFdyaWdodCBGZW5nIHdyb3RlOg0KPj4gVGhpcyBwYXRjaCBpcyBm
b3IgYWRkaW5nIGEgbmV3IG1vZHVsZSBwYXJhbWV0ZXIgImZyYW1lYnVyc3QiLg0KPj4gV2l0aCBz
ZXR0aW5nICJmcmFtZWJ1cnN0PTEiIGluIG1vZHVsZSBwYXJhbWV0ZXJzLCBmaXJtd2FyZSBmcmFt
ZWJ1cnN0IA0KPj4gbW9kZQ0KPj4gd2lsbCBiZSBlbmFibGVkLiBUaGUgZmVhdHVyZSBjYW4gZW5h
YmxlIHBlci1wYWNrZXQgZnJhbWVidXJzdGluZyBpbg0KPj4gZmlybXdhcmUgc2lkZSBhbmQgZ2V0
IGhpZ2hlciBUWCB0aHJvdWdocHV0IGluIEhpZ2ggVGhyb3VnaHB1dChIVCkgbW9kZS4NCj4gDQo+
IFNvIHdoeSBub3QgYWx3YXlzIGVuYWJsZSBpdCBpbiBmaXJtd2FyZSBhcyBpdCBzZWVtcyB0byBi
ZSB0aGUgZGVmYXVsdCBpbiANCj4gcmVjZW50IGZpcm13YXJlIGFueXdheS4NCj4gDQo+IFJlZ2Fy
ZHMsDQo+IEFyZW5kDQpXZSBkb24ndCBoYXZlIGFsbCB0aGUgY2hpcHMoc29tZSBhcmUgbm90IGJl
bG9uZyB0byBDeXByZXNzKSB0byBkbw0KbW9kaWZpY2F0aW9uIGFuZCB2ZXJpZnkgdGhlbSBpbiBv
dXIgaW50ZXJuYWwgdGVzdCwgc28gdGhlIGZyYW1lYnVyc3QNCmZlYXR1cmUgd2lsbCBub3QgYmVu
ZWZpdCB0byBhbGwgZmlybXdhcmVzLg0KSG93IGFib3V0IHJlbW92aW5nIG1vZHVsZSBwYXJhbWV0
ZXIgYW5kIHNldHRpbmcgZnJhbWVidXJzdCB0byBiZSBkZWZhdWx0DQppbiBob3N0IGRyaXZlciBz
aWRlPyBJdCB3aWxsIGJlIGdvb2QgdG8gYWxsIExpbnV4IHN1cHBvcnRlZCBjaGlwcyBhbmQNCnVz
ZXJzLg0KDQotV3JpZ2h0DQo+IA0KPj4gU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcgPHdyaWdo
dC5mZW5nQGN5cHJlc3MuY29tPg0KPj4gLS0tDQo+PiDCoC4uLi9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmPCoMKgwqAgfCA3ICsrKysrKysNCj4+IMKg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NvbW1vbi5j
wqAgfCA1ICsrKysrDQo+PiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIx
MS9icmNtZm1hYy9jb21tb24uaMKgIHwgMiArKw0KPj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndpbC5owqDCoMKgIHwgMSArDQo+PiDCoDQgZmls
ZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgDQo+PiBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5j
IA0KPj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2ZnODAyMTEuYw0KPj4gaW5kZXggMjMwYTM3OGMyNmZjLi40YTA1ZDNmNTBjZmYgMTAwNjQ0DQo+
PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2ZnODAyMTEuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgw
MjExL2JyY21mbWFjL2NmZzgwMjExLmMNCj4+IEBAIC02NjM4LDYgKzY2MzgsMTMgQEAgc3RhdGlj
IHMzMiBicmNtZl9jb25maWdfZG9uZ2xlKHN0cnVjdCANCj4+IGJyY21mX2NmZzgwMjExX2luZm8g
KmNmZykNCj4+DQo+PiDCoMKgwqDCoCBicmNtZl9jb25maWd1cmVfYXJwX25kX29mZmxvYWQoaWZw
LCB0cnVlKTsNCj4+DQo+PiArwqDCoMKgIGlmIChpZnAtPmRydnItPnNldHRpbmdzLT5mcmFtZWJ1
cnN0KSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgZXJyID0gYnJjbWZfZmlsX2NtZF9pbnRfc2V0KGlm
cCwgQlJDTUZfQ19TRVRfRkFLRUZSQUcsIDEpOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKGVycikNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJjbWZfaW5mbygi
c2V0dGluZyBmcmFtZWJ1cnN0IG1vZGUgZmFpbGVkXG4iKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBi
cmNtZl9kYmcoSU5GTywgImZyYW1lYnVyc3QgbW9kZSBlbmFibGVkXG4iKTsNCj4+ICvCoMKgwqAg
fQ0KPj4gKw0KPj4gwqDCoMKgwqAgY2ZnLT5kb25nbGVfdXAgPSB0cnVlOw0KPj4gwqBkZWZhdWx0
X2NvbmZfb3V0Og0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9h
ZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMgDQo+PiBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb21tb24uYw0KPj4gaW5kZXggOTQwNDRh
N2E2MDIxLi4wYWQ0YzMxOTZlNWQgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMNCj4+ICsrKyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb21tb24uYw0KPj4gQEAg
LTc4LDYgKzc4LDEwIEBAIHN0YXRpYyBpbnQgYnJjbWZfaWFwcF9lbmFibGU7DQo+PiDCoG1vZHVs
ZV9wYXJhbV9uYW1lZChpYXBwLCBicmNtZl9pYXBwX2VuYWJsZSwgaW50LCAwKTsNCj4+IMKgTU9E
VUxFX1BBUk1fREVTQyhpYXBwLCAiRW5hYmxlIHBhcnRpYWwgc3VwcG9ydCBmb3IgdGhlIG9ic29s
ZXRlZCANCj4+IEludGVyLUFjY2VzcyBQb2ludCBQcm90b2NvbCIpOw0KPj4NCj4+ICtzdGF0aWMg
aW50IGJyY21mX2ZyYW1lYnVyc3Q7DQo+PiArbW9kdWxlX3BhcmFtX25hbWVkKGZyYW1lYnVyc3Qs
IGJyY21mX2ZyYW1lYnVyc3QsIGludCwgMCk7DQo+PiArTU9EVUxFX1BBUk1fREVTQyhmcmFtZWJ1
cnN0LCAiRW5hYmxlIGZpcm13YXJlIGZyYW1lYnVyc3QgZmVhdHVyZSIpOw0KPj4gKw0KPj4gwqAj
aWZkZWYgREVCVUcNCj4+IMKgLyogYWx3YXlzIHN1Y2NlZWQgYnJjbWZfYnVzX3N0YXJ0ZWQoKSAq
Lw0KPj4gwqBzdGF0aWMgaW50IGJyY21mX2lnbm9yZV9wcm9iZV9mYWlsOw0KPj4gQEAgLTQxOSw2
ICs0MjMsNyBAQCBzdHJ1Y3QgYnJjbWZfbXBfZGV2aWNlIA0KPj4gKmJyY21mX2dldF9tb2R1bGVf
cGFyYW0oc3RydWN0IGRldmljZSAqZGV2LA0KPj4gwqDCoMKgwqAgc2V0dGluZ3MtPmZjbW9kZSA9
IGJyY21mX2ZjbW9kZTsNCj4+IMKgwqDCoMKgIHNldHRpbmdzLT5yb2Ftb2ZmID0gISFicmNtZl9y
b2Ftb2ZmOw0KPj4gwqDCoMKgwqAgc2V0dGluZ3MtPmlhcHAgPSAhIWJyY21mX2lhcHBfZW5hYmxl
Ow0KPj4gK8KgwqDCoCBzZXR0aW5ncy0+ZnJhbWVidXJzdCA9ICEhYnJjbWZfZnJhbWVidXJzdDsN
Cj4+IMKgI2lmZGVmIERFQlVHDQo+PiDCoMKgwqDCoCBzZXR0aW5ncy0+aWdub3JlX3Byb2JlX2Zh
aWwgPSAhIWJyY21mX2lnbm9yZV9wcm9iZV9mYWlsOw0KPj4gwqAjZW5kaWYNCj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29t
bW9uLmggDQo+PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9jb21tb24uaA0KPj4gaW5kZXggYTM0NjQyY2I0ZDJmLi5iOTE5NzUyNThhNjggMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZt
YWMvY29tbW9uLmgNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204
MDIxMS9icmNtZm1hYy9jb21tb24uaA0KPj4gQEAgLTQ3LDYgKzQ3LDcgQEAgZXh0ZXJuIHN0cnVj
dCBicmNtZl9tcF9nbG9iYWxfdCBicmNtZl9tcF9nbG9iYWw7DQo+PiDCoCAqIEBmZWF0dXJlX2Rp
c2FibGU6IEZlYXR1cmVfZGlzYWJsZSBiaXRtYXNrLg0KPj4gwqAgKiBAZmNtb2RlOiBGV1MgZmxv
dyBjb250cm9sLg0KPj4gwqAgKiBAcm9hbW9mZjogRmlybXdhcmUgcm9hbWluZyBvZmY/DQo+PiAr
ICogQGZyYW1lYnVyc3Q6IEZpcm13YXJlIGZyYW1lIGJ1cnN0IG1vZGUuDQo+PiDCoCAqIEBpZ25v
cmVfcHJvYmVfZmFpbDogSWdub3JlIHByb2JlIGZhaWx1cmUuDQo+PiDCoCAqIEBjb3VudHJ5X2Nv
ZGVzOiBJZiBhdmFpbGFibGUsIHBvaW50ZXIgdG8gc3RydWN0IGZvciB0cmFuc2xhdGluZyANCj4+
IGNvdW50cnkgY29kZXMNCj4+IMKgICogQGJ1czogQnVzIHNwZWNpZmljIHBsYXRmb3JtIGRhdGEu
IE9ubHkgU0RJTyBhdCB0aGUgbW1vbWVudC4NCj4+IEBAIC01Nyw2ICs1OCw3IEBAIHN0cnVjdCBi
cmNtZl9tcF9kZXZpY2Ugew0KPj4gwqDCoMKgwqAgaW50wqDCoMKgwqDCoMKgwqAgZmNtb2RlOw0K
Pj4gwqDCoMKgwqAgYm9vbMKgwqDCoMKgwqDCoMKgIHJvYW1vZmY7DQo+PiDCoMKgwqDCoCBib29s
wqDCoMKgwqDCoMKgwqAgaWFwcDsNCj4+ICvCoMKgwqAgYm9vbMKgwqDCoMKgwqDCoMKgIGZyYW1l
YnVyc3Q7DQo+PiDCoMKgwqDCoCBib29swqDCoMKgwqDCoMKgwqAgaWdub3JlX3Byb2JlX2ZhaWw7
DQo+PiDCoMKgwqDCoCBzdHJ1Y3QgYnJjbWZtYWNfcGRfY2MgKmNvdW50cnlfY29kZXM7DQo+PiDC
oMKgwqDCoCB1bmlvbiB7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Z3aWwuaCANCj4+IGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Z3aWwuaA0KPj4gaW5kZXggNjNiMTI4N2Uy
ZTZkLi5iNmIxODNiMTg0MTMgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndpbC5oDQo+PiArKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndpbC5oDQo+PiBAQCAtODAsNiAr
ODAsNyBAQA0KPj4gwqAjZGVmaW5lIEJSQ01GX0NfU0NCX0RFQVVUSEVOVElDQVRFX0ZPUl9SRUFT
T07CoMKgwqAgMjAxDQo+PiDCoCNkZWZpbmUgQlJDTUZfQ19TRVRfQVNTT0NfUFJFRkVSwqDCoMKg
wqDCoMKgwqAgMjA1DQo+PiDCoCNkZWZpbmUgQlJDTUZfQ19HRVRfVkFMSURfQ0hBTk5FTFPCoMKg
wqDCoMKgwqDCoCAyMTcNCj4+ICsjZGVmaW5lIEJSQ01GX0NfU0VUX0ZBS0VGUkFHwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAyMTkNCj4+IMKgI2RlZmluZSBCUkNNRl9DX0dFVF9LRVlfUFJJTUFSWcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgMjM1DQo+PiDCoCNkZWZpbmUgQlJDTUZfQ19TRVRfS0VZX1BS
SU1BUlnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDIzNg0KPj4gwqAjZGVmaW5lIEJSQ01GX0NfU0VU
X1NDQU5fUEFTU0lWRV9USU1FwqDCoMKgwqDCoMKgwqAgMjU4DQo+Pg0KPiANCg==
