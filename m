Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47532C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 12:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61FC20823
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 12:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="STiAt9YF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfBGMv6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:51:58 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:32548 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfBGMv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 07:51:57 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27385433"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 05:51:56 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 05:51:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOOqja1BmQ6+NEGK33V7eiuX84o6k/JnnWTkC16G+6M=;
 b=STiAt9YFO6l76UgaKAzdpj2L2aN4R4BxYldyrlc3/9CdexTQJbyOLj3yyz9gXCm+12AB3iD/NKd82Xc42oIk2+By2fp0jyUAbBtdT6Fa2557o3gyVBV/L7Gp5ejZd/Bi7e4pJKMI4rEX3GhQTXt/tPujlHjVW/l/bWb3mIg8P24=
Received: from MWHPR11MB1920.namprd11.prod.outlook.com (10.175.54.19) by
 MWHPR11MB0064.namprd11.prod.outlook.com (10.164.204.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Thu, 7 Feb 2019 12:51:54 +0000
Received: from MWHPR11MB1920.namprd11.prod.outlook.com
 ([fe80::d917:8496:9d53:1f55]) by MWHPR11MB1920.namprd11.prod.outlook.com
 ([fe80::d917:8496:9d53:1f55%9]) with mapi id 15.20.1580.016; Thu, 7 Feb 2019
 12:51:53 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 3/8] staging: wilc1000: move macro and function
 prototype from wilc_wlan_if.h file
Thread-Topic: [PATCH v2 3/8] staging: wilc1000: move macro and function
 prototype from wilc_wlan_if.h file
Thread-Index: AQHUvthstdZTmFS1o0WO+rVZ9mntIaXUShAA
Date:   Thu, 7 Feb 2019 12:51:53 +0000
Message-ID: <2a6391ac-f0c5-e971-39a0-269b5ff4bb34@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
 <1549538913-17463-4-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-4-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0701CA0059.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::21) To MWHPR11MB1920.namprd11.prod.outlook.com
 (2603:10b6:300:110::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Claudiu.Beznea@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190207145144075
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB0064;6:NTovlGniT3yzpl7NviVt+gABX1kVKDFf1NYSJ63t/DmQDn0Oj+hJJQutvnHZ6KGnOhvwfyKFLeZgBXyK+8btLt8pnEsQP/aNBsOzdBIUqceV2pZZEErsLxB9fnjoLTtWAKTh+UaNa0rm9+yO5LKFnkuLHRHA0MpjMvvkgyx9klI6N2RNPPs25OZCRvccGLV2CNDKZIXPQZ4OkRZwuVqkUTL7ld/dyaiLDhYaboJt+CdZKdrXett46sngYEv4IilH4Li3RNwm5lN7mKefP80tmiO+B5LUk/d0xdTiLRPfx95V9hg0TTploBAO0DNRSQKX+9+S51AzH37r1hD88OtlP0noNBz1kVUxyyEuTLDTtKK/wntECqOWNgaTFQWuWjlGl+A1rdiTPzTQ3/NwxFGwfNm9ima5loR4M5IWK4Wgg2iBCGHKeWx1JqcCwpXYi/ayofoAGCFjNuUN4WH7Xyu7XQ==;5:SVgHhpxEJuth9pHjndSlWeUvjIP+9IoOy1X+6adtKWHD2lDA4bscSTSGFLfY2aDG9ThiHnEP3nHQyelzcBTHrfqdGTuoHXXVUN1l0vEO8tO0pe+WemTUcG1ZlconLn1HU+TXIPsOOJatPRpg3hnMl00WU9Jh2IVHRw7zt8d29Zya2Csa9W/SkN5Lwrgw4+mTq5/ZR0C3IDSg8vCtQXbjpw==;7:0zzcPXw4vJvH08cTdtcS6jkihToD+qX/+VTE21hBIy0nM0DRB+DTHlwHkqMHb2N62o2UFmQOFg0hLoC4lWyQvLJMJKIWY7IyJhVVf5GY1Qu8zes5F0R0P2S9ALVIMw8EoKfMhGRvVwge2pWdaaNdhA==
x-ms-office365-filtering-correlation-id: f6fd40a3-cc7c-49d3-f370-08d68cfb08c0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB0064;
x-ms-traffictypediagnostic: MWHPR11MB0064:
x-microsoft-antispam-prvs: <MWHPR11MB0064F887DA3E5EF443C3DC8587680@MWHPR11MB0064.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39860400002)(366004)(136003)(199004)(189003)(2616005)(11346002)(6436002)(31686004)(229853002)(97736004)(68736007)(476003)(446003)(486006)(2906002)(4326008)(8676002)(81166006)(478600001)(81156014)(2501003)(6486002)(105586002)(6512007)(106356001)(71200400001)(71190400001)(53546011)(386003)(6506007)(186003)(31696002)(256004)(14444005)(3846002)(102836004)(86362001)(99286004)(36756003)(66066001)(6116002)(53936002)(14454004)(72206003)(305945005)(8936002)(25786009)(110136005)(316002)(54906003)(6246003)(76176011)(7736002)(52116002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB0064;H:MWHPR11MB1920.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8MXZvUzJzUWs87/DHk0tUOFgZ1quKNJW2reiCK4j9Wz++nVfOZTfebd8orEW6SOZkGjiIJNy7OxHyZjR4d5UHWknCs3iE/BYfTN4gwbD9EywcTuECw1sDqM1oRSypgC7sbkAGJOCcYFMD7+8LYuRcJUApqEI7Jnv9vlnbPJ1YsONNvj69Q//P5V3F2eizllhn1Qz+v4DVGFGdJr80H2Awbtq8CrCM8lBNz0LvJf4hBhr31DR5p4NZFoysDhy8WSJehOAq9zGKxA3xn2aVMMZtadahEIWHK97R2bZOsVqNP5X/kJNTeYaHT+96KqPy1FFCoRNPxVruTwhDiqSH4fo0e+uk5vcZUMsi+jlYNi4CkH2p+GWEWKT77u9345RlnvjqAjdg2x6feH942CDLKHg9vYGBHY/JggcajXhasI7v3I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE3B922D80EC2D4CACEDEAF47FA3A70C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fd40a3-cc7c-49d3-f370-08d68cfb08c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 12:51:50.6516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0064
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA3LjAyLjIwMTkgMTM6MjksIEFqYXkuS2F0aGF0QG1pY3JvY2hpcC5jb20gd3JvdGU6
DQo+IEZyb206IEFqYXkgU2luZ2ggPGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+DQo+IA0KPiBN
b3ZlIGRhdGEgc3RydWN0dXJlIGFuZCBmdW5jdGlvbiBwcm90b3R5cGUgZnJvbSAnd2lsY193bGFu
X2lmLmggZmlsZS4NCj4gTm93LCB0aGlzIGZpbGUgY29udGFpbnMgY29uc3RhbnQgc3BlY2lmaWMg
dG8gdGhlIGZpcm13YXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWpheSBTaW5naCA8YWpheS5r
YXRoYXRAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAv
aG9zdF9pbnRlcmZhY2UuYyB8ICAxICsNCj4gIGRyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0
X2ludGVyZmFjZS5oIHwgMTEgKysrKysrKysrKw0KPiAgZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAw
L2xpbnV4X3dsYW4uYyAgICAgfCAgMiArKw0KPiAgZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dp
bGNfd2xhbi5oICAgICAgfCAgOSArKysrKysrKw0KPiAgZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAw
L3dpbGNfd2xhbl9pZi5oICAgfCAzNiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ICA1IGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmMNCj4gaW5kZXggOWFi
ZTM0MS4uNTBkYzJkZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hv
c3RfaW50ZXJmYWNlLmMNCj4gKysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50
ZXJmYWNlLmMNCj4gQEAgLTEwLDYgKzEwLDcgQEANCj4gICNkZWZpbmUgV0lMQ19ISUZfQ09OTkVD
VF9USU1FT1VUX01TICAgICAgICAgICAgIDk1MDANCj4gIA0KPiAgI2RlZmluZSBXSUxDX0ZBTFNF
X0ZSTVdSX0NIQU5ORUwJCTEwMA0KPiArI2RlZmluZSBXSUxDX01BWF9SQVRFU19TVVBQT1JURUQJ
CTEyDQo+ICANCj4gIHN0cnVjdCB3aWxjX3JjdmRfbWFjX2luZm8gew0KPiAgCXU4IHN0YXR1czsN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5o
IGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmgNCj4gaW5kZXggYTAw
NzYyNS4uNjc4ZTYyMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hv
c3RfaW50ZXJmYWNlLmgNCj4gKysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50
ZXJmYWNlLmgNCj4gQEAgLTk3LDYgKzk3LDE3IEBAIGVudW0gY29ubl9ldmVudCB7DQo+ICAJQ09O
Tl9ESVNDT05OX0VWRU5UX0ZPUkNFXzMyQklUCQk9IDB4RkZGRkZGRkYNCj4gIH07DQo+ICANCj4g
K2VudW0gew0KPiArCVdJTENfSElGX1NESU8gPSAwLA0KPiArCVdJTENfSElGX1NQSSA9IEJJVCgw
KQ0KDQpCSVQoMCk9MSwgc28geW91IGNhbiByZW1vdmUgaXQgYW5kIHVzZSBzaW1wbHk6DQoNCmVu
dW0gew0KCVdJTENfSElGX1NESU8sDQoJV0lMQ19ISUZfU1BJLA0KfTsNCg0KDQo+ICt9Ow0KPiAr
DQo+ICtlbnVtIHsNCj4gKwlXSUxDX01BQ19TVEFUVVNfSU5JVCA9IC0xLA0KPiArCVdJTENfTUFD
X1NUQVRVU19ESVNDT05ORUNURUQgPSAwLA0KPiArCVdJTENfTUFDX1NUQVRVU19DT05ORUNURUQg
PSAxDQo+ICt9Ow0KPiArDQo+ICBzdHJ1Y3Qgd2lsY19yY3ZkX25ldF9pbmZvIHsNCj4gIAlzOCBy
c3NpOw0KPiAgCXU4IGNoOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAw
L2xpbnV4X3dsYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9saW51eF93bGFuLmMNCj4g
aW5kZXggZjNlNTJhZi4uMWViZjJiOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dp
bGMxMDAwL2xpbnV4X3dsYW4uYw0KPiArKysgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvbGlu
dXhfd2xhbi5jDQo+IEBAIC0xMiw2ICsxMiw4IEBADQo+ICANCj4gICNpbmNsdWRlICJ3aWxjX3dm
aV9jZmdvcGVyYXRpb25zLmgiDQo+ICANCj4gKyNkZWZpbmUgV0lMQ19NVUxUSUNBU1RfVEFCTEVf
U0laRQk4DQo+ICsNCj4gIHN0YXRpYyBpcnFyZXR1cm5fdCBpc3JfdWhfcm91dGluZShpbnQgaXJx
LCB2b2lkICp1c2VyX2RhdGEpDQo+ICB7DQo+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHVz
ZXJfZGF0YTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3ds
YW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW4uaA0KPiBpbmRleCBkOGZh
YmU4Li4xYTI3ZjYyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2ls
Y193bGFuLmgNCj4gKysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbi5oDQo+
IEBAIC0yNTAsNiArMjUwLDEzIEBAIHN0cnVjdCB3aWxjX2hpZl9mdW5jIHsNCj4gIA0KPiAgI2Rl
ZmluZSBXSUxDX01BWF9DRkdfRlJBTUVfU0laRQkJMTQ2OA0KPiAgDQo+ICtzdHJ1Y3QgdHhfY29t
cGxldGVfZGF0YSB7DQo+ICsJaW50IHNpemU7DQo+ICsJdm9pZCAqYnVmZjsNCj4gKwl1OCAqYnNz
aWQ7DQo+ICsJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCj4gK307DQo+ICsNCj4gIHN0cnVjdCB3aWxj
X2NmZ19jbWRfaGRyIHsNCj4gIAl1OCBjbWRfdHlwZTsNCj4gIAl1OCBzZXFfbm87DQo+IEBAIC0z
MDEsNCArMzA4LDYgQEAgdm9pZCBjaGlwX2FsbG93X3NsZWVwKHN0cnVjdCB3aWxjICp3aWxjKTsN
Cj4gIHZvaWQgY2hpcF93YWtldXAoc3RydWN0IHdpbGMgKndpbGMpOw0KPiAgaW50IHdpbGNfc2Vu
ZF9jb25maWdfcGt0KHN0cnVjdCB3aWxjX3ZpZiAqdmlmLCB1OCBtb2RlLCBzdHJ1Y3Qgd2lkICp3
aWRzLA0KPiAgCQkJIHUzMiBjb3VudCwgdTMyIGRydik7DQo+ICtpbnQgd2lsY193bGFuX2luaXQo
c3RydWN0IG5ldF9kZXZpY2UgKmRldik7DQo+ICt1MzIgd2lsY19nZXRfY2hpcGlkKHN0cnVjdCB3
aWxjICp3aWxjLCBib29sIHVwZGF0ZSk7DQo+ICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW5faWYuaCBiL2RyaXZlcnMvc3RhZ2luZy93aWxj
MTAwMC93aWxjX3dsYW5faWYuaA0KPiBpbmRleCA5YjhjY2U4Li5iMTVkZTM2IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuX2lmLmgNCj4gKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbl9pZi5oDQo+IEBAIC0xMSw0MSArMTEsOSBA
QA0KPiAgDQo+ICAvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioN
Cj4gICAqDQo+IC0gKiAgICAgIEhvc3QgSW50ZXJmYWNlIERlZmluZXMNCj4gLSAqDQo+IC0gKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovDQo+IC0NCj4gLWVudW0g
ew0KPiAtCVdJTENfSElGX1NESU8gPSAwLA0KPiAtCVdJTENfSElGX1NQSSA9IEJJVCgwKQ0KPiAt
fTsNCj4gLQ0KPiAtLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
DQo+IC0gKg0KPiAtICogICAgICBXbGFuIEludGVyZmFjZSBEZWZpbmVzDQo+IC0gKg0KPiAtICoq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLw0KPiAtDQo+IC1lbnVt
IHsNCj4gLQlXSUxDX01BQ19TVEFUVVNfSU5JVCA9IC0xLA0KPiAtCVdJTENfTUFDX1NUQVRVU19E
SVNDT05ORUNURUQgPSAwLA0KPiAtCVdJTENfTUFDX1NUQVRVU19DT05ORUNURUQgPSAxDQo+IC19
Ow0KPiAtDQo+IC1zdHJ1Y3QgdHhfY29tcGxldGVfZGF0YSB7DQo+IC0JaW50IHNpemU7DQo+IC0J
dm9pZCAqYnVmZjsNCj4gLQl1OCAqYnNzaWQ7DQo+IC0Jc3RydWN0IHNrX2J1ZmYgKnNrYjsNCj4g
LX07DQo+IC0NCj4gLS8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Kg0KPiAtICoNCj4gICAqICAgICAgV2xhbiBDb25maWd1cmF0aW9uIElEDQo+ICAgKg0KPiAgICoq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLw0KPiAtI2RlZmluZSBX
SUxDX01VTFRJQ0FTVF9UQUJMRV9TSVpFCTgNCj4gLSNkZWZpbmUgV0lMQ19NQVhfUkFURVNfU1VQ
UE9SVEVEICAgICAxMg0KPiAgDQo+ICBlbnVtIGJzc190eXBlcyB7DQo+ICAJV0lMQ19GV19CU1Nf
VFlQRV9JTkZSQSA9IDAsDQo+IEBAIC04MzIsOCArODAwLDQgQEAgZW51bSB7DQo+ICAJV0lEX01B
WAkJCQk9IDB4RkZGRg0KPiAgfTsNCj4gIA0KPiAtc3RydWN0IHdpbGM7DQo+IC1pbnQgd2lsY193
bGFuX2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldik7DQo+IC11MzIgd2lsY19nZXRfY2hpcGlk
KHN0cnVjdCB3aWxjICp3aWxjLCBib29sIHVwZGF0ZSk7DQo+IC0NCj4gICNlbmRpZg0KPiANCg==
