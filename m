Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C5FC10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D4C920863
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Gr/FHoUG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDHVBY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:01:24 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:46714 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfDHVBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 17:01:24 -0400
X-IronPort-AV: E=Sophos;i="5.60,326,1549954800"; 
   d="scan'208";a="27903569"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Apr 2019 14:01:23 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 8 Apr 2019 14:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v4v2Uk0mHA0FW29WFTQPEspn5zYB4WdFRgKqAzG/oI=;
 b=Gr/FHoUGlY4janyBCTJFicp3HwbJR1wIsOiF4MvC7JfL93wFE7jfjlAsme8yxBkZHJ98rnaXvserQIkz43poFch0y3pMKR4pfqRr+rvodQ+an27pt6zLfOsHLKcaNRMEOPb3e9oZZNvbv2ms+UEhMM+a9EcG0DzbuLxHoqEZbcI=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1344.namprd11.prod.outlook.com (10.169.232.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 21:01:21 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%5]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 21:01:21 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <adham.abozaeid@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Topic: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Index: AQHU7HE8koeh5e9EOkuq/fEUQd8KZ6Yyw4kA
Date:   Mon, 8 Apr 2019 21:01:21 +0000
Message-ID: <a50b3198-834d-acfb-0229-25c7993ffe84@microchip.com>
References: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-clientproxiedby: BY5PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:180::43) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 477acb70-3b91-4a3a-e5f1-08d6bc655a0b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1344;
x-ms-traffictypediagnostic: MWHPR11MB1344:
x-microsoft-antispam-prvs: <MWHPR11MB13443385BEE190A4C976D1668D2C0@MWHPR11MB1344.namprd11.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6916009)(53936002)(106356001)(53546011)(97736004)(229853002)(2351001)(58126008)(54906003)(72206003)(6506007)(3846002)(14454004)(6512007)(105586002)(1361003)(102836004)(2501003)(26005)(486006)(446003)(478600001)(7736002)(14444005)(256004)(11346002)(65826007)(31696002)(6436002)(5640700003)(2616005)(386003)(476003)(86362001)(186003)(36756003)(316002)(305945005)(25786009)(76176011)(2906002)(6246003)(64126003)(71190400001)(99286004)(31686004)(6116002)(6486002)(81156014)(8676002)(8936002)(4326008)(5660300002)(81166006)(52116002)(65806001)(65956001)(66066001)(68736007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1344;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K7qtwPYYhOQ6z3HE3WJ7gHIpwoj8497Xz8xnlhKn409xee8Gp0tW9wMFyyHC7FS21zRJkRPZq3QtYGTc2Zlt6sz5jd9InbUWDnjfORiUtaOh5+316TVwpISSAnSE8yW8OqZ7sqwNI2Wd3JUywbFO1rG2Ga4SRobOzEb6obc0tdXrSV7rYUNFALL8KekcsStF1DqWJ4tgDXLxbk/B7xjrv47Xc3d56SVSjYneMnIh4++RFIwcM50gYjVE1n+fiayjraivkcfNYujVqViyBahE010P8kJAnbPP0Rxzh2IKmAtUqJnSOz6ApUm0zBpn2HNkR/qSqkBppyLrH6JwhLzPdOUu8/gUVtC3zjaL3c65QiA+caV7B30B0Bk2sLLcG2zE/ZPifcmUFGU5fnXfVAWCXp03loujXTHGDuJTgTNPGQw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <531F91884E70DA4C994FA8632227F2A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 477acb70-3b91-4a3a-e5f1-08d6bc655a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 21:01:21.2205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1344
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgTmljaG9sYXMNCg0KT24gNC82LzE5IDU6MDEgQU0sIE5pY2hvbGFzIE1jIEd1aXJlIHdyb3Rl
Og0KPiBFeHRlcm5hbCBFLU1haWwNCj4NCj4NCj4gdXNsZWVwX3JhbmdlKCkgaXMgY2FsbGVkIGlu
IG5vbi1hdG9taWMgY29udGV4dCBzbyB0aGVyZSBpcyBsaXR0bGUgcG9pbnQNCj4gaW4gc2V0dGlu
ZyBtaW49PW1heCB0aGUgaml0dGVyIG9mIGhydGltZXIgaXMgZGV0ZXJtaW5lZCBieSBpbnRlcnJ1
cHRpb25zDQo+IGFueXdheS4gdXNsZWVwX3JhbmdlIGNhbiBvbmx5IHBlcmZvcm0gdGhlIGludGVu
ZGVkIGNvYWxlc2NlbmNlIGlmIHNvbWUNCj4gcm9vbSBmb3IgcGxhY2luZyB0aGUgaHJ0aW1lciBp
cyBwcm92aWRlZC4gR2l2ZW4gdGhlIHJhbmdlIG9mIG1pbGxpc2Vjb25kcw0KPiB0aGUgZGVsYXkg
d2lsbCBiZSBhbnl0aGluZyBmcm9tIDIgdG8gYSBmZXcgYW55d2F5IC0gc28gbWFrZSBpdCAyLTUg
bXMuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY2hvbGFzIE1jIEd1aXJlIDxob2ZyYXRAb3NhZGwu
b3JnPg0KPiAtLS0NCj4NCj4gUHJvYmxlbSBsb2NhdGVkIHdpdGggYW4gZXhwZXJpbWVudGFsIGNv
Y2NpbmVsbGUgc2NyaXB0DQo+IC4vZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbi5j
OjQxMTo0LTE2OiBXQVJOSU5HOiBpbmVmZmljaWVudCB1c2xlZXBfcmFuZ2Ugd2l0aCByYW5nZSAw
IChtaW49PW1heCkNCj4gLi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmM6NDI2
OjQtMTY6IFdBUk5JTkc6IGluZWZmaWNpZW50IHVzbGVlcF9yYW5nZSB3aXRoIHJhbmdlIDAgKG1p
bj09bWF4KQ0KPg0KPiBTb21lb25lIHRoYXQga25vd3MgdGhlIG1vdGl2YXRpb24gZm9yIHNldHRp
bmcgdGhlIHRpbWUgdG8gMiBtaWxsaXNlY29uZA0KPiBtaWdodCBuZWVkIHRvIGNoZWNrIGlmIHRo
ZSAyIG1pbGxpc2Vjb25kcyB3aGVyZSBzZWVuIGFzIHRvbGxlcmFibGUgbWF4IG9yDQo+IG1pbiAt
IEknbSBhc3N1bWluZyBpdCB3YXMgdGhlIG1pbiBzbyBleHRlbmRpbmcuDQo+DQo+IFBhdGNoIHdh
cyBjb21waWxlIHRlc3RlZCB3aXRoOiB4ODZfNjRfZGVmY29uZmlnICsgU3RhZ2luZz15LA0KPiBX
SUxDMTAwMF9TRElPPW0sIFdJTEMxMDAwX1NQST1tLCBXSUxDMTAwMD1tDQo+DQo+IFBhdGNoIGlz
IGFnYWluc3QgNS4xLXJjMyAobG9jYWx2ZXJzaW9uLW5leHQgaXMgLW5leHQtMjAxOTA0MDUpDQo+
DQo+ICBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMgfCA0ICsrLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCg0KVGhpcw0K
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMNCj4gaW5kZXggYzIzODk2OS4uNDJk
YTUzMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbi5j
DQo+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW4uYw0KPiBAQCAtNDA4
LDcgKzQwOCw3IEBAIHZvaWQgY2hpcF93YWtldXAoc3RydWN0IHdpbGMgKndpbGMpDQo+ICAJCQl3
aWxjLT5oaWZfZnVuYy0+aGlmX3dyaXRlX3JlZyh3aWxjLCAxLCByZWcgJiB+QklUKDEpKTsNCj4g
IA0KPiAgCQkJZG8gew0KPiAtCQkJCXVzbGVlcF9yYW5nZSgyICogMTAwMCwgMiAqIDEwMDApOw0K
PiArCQkJCXVzbGVlcF9yYW5nZSgyICogMTAwMCwgNSAqIDEwMDApOw0KPiAgCQkJCXdpbGNfZ2V0
X2NoaXBpZCh3aWxjLCB0cnVlKTsNCj4gIAkJCX0gd2hpbGUgKHdpbGNfZ2V0X2NoaXBpZCh3aWxj
LCB0cnVlKSA9PSAwKTsNCj4gIAkJfSB3aGlsZSAod2lsY19nZXRfY2hpcGlkKHdpbGMsIHRydWUp
ID09IDApOw0KPiBAQCAtNDIzLDcgKzQyMyw3IEBAIHZvaWQgY2hpcF93YWtldXAoc3RydWN0IHdp
bGMgKndpbGMpDQo+ICAJCQkJCQkgICAgICZjbGtfc3RhdHVzX3JlZyk7DQo+ICANCj4gIAkJCXdo
aWxlICgoY2xrX3N0YXR1c19yZWcgJiAweDEpID09IDApIHsNCj4gLQkJCQl1c2xlZXBfcmFuZ2Uo
MiAqIDEwMDAsIDIgKiAxMDAwKTsNCj4gKwkJCQl1c2xlZXBfcmFuZ2UoMiAqIDEwMDAsIDUgKiAx
MDAwKTsNCj4gIA0KPiAgCQkJCXdpbGMtPmhpZl9mdW5jLT5oaWZfcmVhZF9yZWcod2lsYywgMHhm
MSwNCj4gIAkJCQkJCQkgICAgICZjbGtfc3RhdHVzX3JlZyk7DQo=
