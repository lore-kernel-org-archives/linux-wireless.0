Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A146C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 12:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21321218A1
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 12:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="j9dcKTfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfCUMt0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:49:26 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:4219 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfCUMt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 08:49:26 -0400
X-IronPort-AV: E=Sophos;i="5.60,252,1549954800"; 
   d="scan'208";a="28279472"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 Mar 2019 05:49:24 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 21 Mar 2019 05:49:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OxIig11/1nder5qe/GuIJWsi869Jy4ZrvO6fcBq1Kc=;
 b=j9dcKTfkdgGJD8JEMStHr479S5Gg5yRW3cURVXtIdHOtfU1LMeVCeV0+kXPRKsCKuZmuAm/tFet+9RZqdC7bqX9Sv5uYcZuy20bG0duZYIiOdSsRR9DZ/i+mM6wht6CKtw5zj/hAba7kadwR/GEBJw1TISrEWV0coI82TAgSUuo=
Received: from BN7PR11MB2562.namprd11.prod.outlook.com (52.135.244.32) by
 BN7PR11MB2866.namprd11.prod.outlook.com (52.135.246.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Thu, 21 Mar 2019 12:49:22 +0000
Received: from BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::d155:ce52:7744:6c34]) by BN7PR11MB2562.namprd11.prod.outlook.com
 ([fe80::d155:ce52:7744:6c34%5]) with mapi id 15.20.1730.013; Thu, 21 Mar 2019
 12:49:22 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>
CC:     <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 00/16] wilc1000: move out of staging
Thread-Topic: [PATCH 00/16] wilc1000: move out of staging
Thread-Index: AQHUwEbCCX3IcHjEkkah7YSVPvJ9TKYWSGkA
Date:   Thu, 21 Mar 2019 12:49:22 +0000
Message-ID: <5ac9d9bb-08e4-c46f-ce0a-40630e1d958e@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0140.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:40::34) To BN7PR11MB2562.namprd11.prod.outlook.com
 (2603:10b6:406:b0::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.217.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8967def-ca5b-445a-9fce-08d6adfba3e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BN7PR11MB2866;
x-ms-traffictypediagnostic: BN7PR11MB2866:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN7PR11MB286627A8D24485FBFA34020EE3420@BN7PR11MB2866.namprd11.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(376002)(396003)(136003)(199004)(189003)(25786009)(107886003)(99286004)(6246003)(76176011)(52116002)(53546011)(66066001)(6116002)(3846002)(186003)(26005)(53936002)(256004)(14444005)(6306002)(102836004)(71190400001)(71200400001)(386003)(4326008)(6506007)(78486014)(36756003)(2906002)(86362001)(72206003)(68736007)(106356001)(54906003)(229853002)(316002)(31686004)(478600001)(110136005)(105586002)(5660300002)(6436002)(31696002)(6512007)(2201001)(6486002)(8936002)(305945005)(81166006)(2616005)(476003)(446003)(81156014)(486006)(966005)(11346002)(14454004)(2501003)(8676002)(7736002)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR11MB2866;H:BN7PR11MB2562.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HqgShzniy23ayhYeNuxWeRNKLcNiLHTOJI4aRuFBxhslIwBpNOwgyWH8T/5JmAGYwFYZeRfLk8WDmM1lQNRtDfjBGZnbH4vKCpMhdQf6KJdF5d9TkGVZB0Oz5FAdmv3jyvEE6MHbUL2u3TRF1V2CiX97KkP+QRTFv61lgAwUfiZ2XFDm4aRKLhuqDEwL6ndkQoY7KR8W5RQugYGQvbpKG1XyeDhkhjQ/UYN2EyGEY36dO+Q/BwcYawhMCQCmpAXRLQxPLLBM5eo5Jk14ubQSlaYKHCJIlqkx3V9M9PBpnazGVy3pNfwCMskr6YG0vwtu7+2FTRcXHYHfJaOM2CLI9k8zjhYTDIbpPqot3LGkLh+GoxDbrGySiAwumy5y/Tl5okCkxttfGVl29zZYZ8WErr4ERMySFGu6cYMASCI6rGs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0315A9A12F2ED048873B0890E5FB2962@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d8967def-ca5b-445a-9fce-08d6adfba3e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 12:49:22.0791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2866
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgS2FsbGUvSm9oYW5uZXMsDQoNCk9uIDIvOS8yMDE5IDEyOjQyIFBNLCBBamF5IEthdGhhdCAt
IEkxNTQ4MSB3cm90ZToNCj4gRnJvbTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlw
LmNvbT4NCj4gDQo+IFRoaXMgcGF0Y2ggc2VyaWVzIGlzIHRvIHJldmlldyBhbmQgbW92ZSB3aWxj
MTAwMCBkcml2ZXIgb3V0IG9mIHN0YWdpbmcuDQo+IEltcGxlbWVudGVkIHRoZSBpbml0aWFsIHJl
Y2VpdmVkIHJldmlldyBjb21tZW50c1sxXSBhbmQgc3VibWl0dGluZyB0aGUNCj4gZHJpdmVyIGFn
YWluLiBEdXJpbmcgdGhpcyBjbGVhbnVwIGRlbGV0ZWQgYXJvdW5kIDMuM2sgbGluZXMgb2YgY29k
ZS4NCj4gDQo+IEJlbG93IGFyZSB0aGUgbWFqb3IgaXRlbXMgZml4ZWQgaW4gcmVjZW50IGNsZWFu
dXA6DQo+ICAtIHJlbW92ZSB1c2Ugb2Ygc2hhZG93IGJ1ZmZlciB0byBrZWVwIHNjYW4gcmVzdWx0
Lg0KPiAgLSByZW1vdmUgaW50ZXJuYWwgbWVzc2FnaW5nIGZsb3cgdG8gaGFuZGxlIGNmZzgwMjEx
X29wcy4NCj4gIC0gbWFrZSB1c2Ugb2YgY2ZnODAyMTEgcHJvdmlkZWQgQVBJLg0KPiAgLSB1c2Ug
c3RydWN0dXJlIGZvciBwYWNraW5nIGZpcm13YXJlIGNvbW1hbmRzLg0KPiAgLSBtYWtlIHVzZSBv
ZiBrZXJuZWwgcHJvdmlkZWQgQVBJIGFuZCBtYWNyb3MuDQo+ICAtIHJlbW92ZSB1bm5lY2Vzc2Fy
eSBsb2dzIG1lc3NhZ2VzLg0KPiANCj4gUGVuZGluZyBhY3Rpb24gaXRlbToNCj4gIC0gZHluYW1p
Y2FsbHkgYWRkL3JlbW92ZSBwMnAgaW50ZXJmYWNlLg0KPiANCj4gIFRoaXMgaXRlbSB3aWxsIHRh
a2Ugc29tZSB0aW1lLCB3ZSBhcmUgcGxhbm5pbmcgdG8gdGFrZSBpdCB1cCBhZnRlcg0KPiAgbWFp
bmxpbmUuDQo+IA0KPiAgV2UgaG9wZSBpdCBjYW4gYmUgbW92ZSBvdXQgc3RhZ2luZyBpbiB2NS4x
Lg0KPiAgUGxlYXNlIHJldmlldyBhbmQgY29uZmlybSBpZiBpdCBpcyBnb29kIHRvIG1vdmUgb3V0
Lg0KDQpEbyB5b3UgaGF2ZSBhbnkgdXBkYXRlIGZvciB0aGlzIHNlcmllcy4gUGxlYXNlIHByb3Zp
ZGUgeW91ciBpbnB1dHMgZm9yDQpuZXh0IHN0ZXAuDQoNClJlZ2FyZHMsDQpBamF5DQoNCj4gDQo+
IFsxXS4gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtd2lyZWxlc3MvbXNnMTc3
ODc3Lmh0bWwNCj4gDQo+IEFqYXkgU2luZ2ggKDE2KToNCj4gICB3aWxjMTAwMDogYWRkIGhvc3Rf
aW50ZXJmYWNlLmgNCj4gICB3aWxjMTAwMDogYWRkIGhvc3RfaW50ZXJmYWNlLmMNCj4gICB3aWxj
MTAwMDogYWRkIHdpbGNfd2xhbl9pZi5oDQo+ICAgd2lsYzEwMDA6IGFkZCB3aWxjX3dsYW5fY2Zn
LmgNCj4gICB3aWxjMTAwMDogYWRkIHdpbGNfd2xhbl9jZmcuYw0KPiAgIHdpbGMxMDAwOiBhZGQg
d2lsY193ZmlfbmV0ZGV2aWNlLmgNCj4gICB3aWxjMTAwMDogYWRkIHdpbGNfd2ZpX2NmZ29wZXJh
dGlvbnMuaA0KPiAgIHdpbGMxMDAwOiBhZGQgd2lsY193ZmlfY2Znb3BlcmF0aW9ucy5jDQo+ICAg
d2lsYzEwMDA6IGFkZCB3aWxjX25ldGRldi5jDQo+ICAgd2lsYzEwMDA6IGFkZCB3aWxjX21vbi5j
DQo+ICAgd2lsYzEwMDA6IGFkZCB3aWxjX3NwaS5jDQo+ICAgd2lsYzEwMDA6IGFkZCB3aWxjX3ds
YW4uYw0KPiAgIHdpbGMxMDAwOiBhZGQgd2lsY193bGFuLmgNCj4gICB3aWxjMTAwMDogYWRkIHdp
bGNfc2Rpby5jDQo+ICAgd2lsYzEwMDA6IHVwZGF0ZWQgRFQgZGV2aWNlIGJpbmRpbmcgZm9yIHdp
bGMxMDAwIGRldmljZQ0KPiAgIHdpbGMxMDAwOiBhZGQgTWFrZWZpbGUgYW5kIEtjb25maWcgZmls
ZXMgZm9yIHdpbGMxMDAwIGNvbXBpbGF0aW9uDQo+IA0KPiAgLi4uL25ldC93aXJlbGVzc30vbWlj
cm9jaGlwLHdpbGMxMDAwLHNkaW8udHh0ICAgICAgfCAgICAwDQo+ICAuLi4vbmV0L3dpcmVsZXNz
fS9taWNyb2NoaXAsd2lsYzEwMDAsc3BpLnR4dCAgICAgICB8ICAgIDANCj4gIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMSArDQo+ICBkcml2
ZXJzL25ldC93aXJlbGVzcy9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICB8ICAgIDEgKw0K
PiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL0tjb25maWcgICAgICAgICAgICAgfCAg
IDE0ICsNCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC9NYWtlZmlsZSAgICAgICAg
ICAgIHwgICAgMiArDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAv
S2NvbmZpZyAgICB8ICAgNDIgKw0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dp
bGMxMDAwL01ha2VmaWxlICAgfCAgIDE0ICsNCj4gIC4uLi93aXJlbGVzcy9taWNyb2NoaXAvd2ls
YzEwMDAvaG9zdF9pbnRlcmZhY2UuYyAgIHwgMjE1MiArKysrKysrKysrKysrKysrKysrKw0KPiAg
Li4uL3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5oICAgfCAgMjQ3
ICsrKw0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dpbGNfbW9u
LmMgfCAgMjU4ICsrKw0KPiAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2ls
Y19uZXRkZXYuYyAgfCAxMDc5ICsrKysrKysrKysNCj4gIC4uLi9uZXQvd2lyZWxlc3MvbWljcm9j
aGlwL3dpbGMxMDAwL3dpbGNfc2Rpby5jICAgIHwgMTE0MCArKysrKysrKysrKw0KPiAgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dpbGNfc3BpLmMgfCAxMTM2ICsrKysr
KysrKysrDQo+ICAuLi4vbWljcm9jaGlwL3dpbGMxMDAwL3dpbGNfd2ZpX2NmZ29wZXJhdGlvbnMu
YyAgICB8IDE4NzggKysrKysrKysrKysrKysrKysNCj4gIC4uLi9taWNyb2NoaXAvd2lsYzEwMDAv
d2lsY193ZmlfY2Znb3BlcmF0aW9ucy5oICAgIHwgICAyNCArDQo+ICAuLi4vbWljcm9jaGlwL3dp
bGMxMDAwL3dpbGNfd2ZpX25ldGRldmljZS5oICAgICAgICB8ICAyOTIgKysrDQo+ICAuLi4vbmV0
L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93aWxjX3dsYW4uYyAgICB8IDEzNDYgKysrKysr
KysrKysrDQo+ICAuLi4vbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93aWxjX3dsYW4u
aCAgICB8ICAzMTMgKysrDQo+ICAuLi4vd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dpbGNf
d2xhbl9jZmcuYyAgICB8ICA0OTUgKysrKysNCj4gIC4uLi93aXJlbGVzcy9taWNyb2NoaXAvd2ls
YzEwMDAvd2lsY193bGFuX2NmZy5oICAgIHwgICA1NCArDQo+ICAuLi4vbmV0L3dpcmVsZXNzL21p
Y3JvY2hpcC93aWxjMTAwMC93aWxjX3dsYW5faWYuaCB8ICA4MDMgKysrKysrKysNCj4gIGRyaXZl
cnMvc3RhZ2luZy9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiAtDQo+
ICBkcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAg
IDEgLQ0KPiAgMjQgZmlsZXMgY2hhbmdlZCwgMTEyOTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkNCj4gIHJlbmFtZSB7ZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwID0+IERvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3N9L21pY3JvY2hpcCx3aWxjMTAwMCxz
ZGlvLnR4dCAoMTAwJSkNCj4gIHJlbmFtZSB7ZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwID0+IERv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3N9L21pY3JvY2hpcCx3
aWxjMTAwMCxzcGkudHh0ICgxMDAlKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0
L3dpcmVsZXNzL21pY3JvY2hpcC9LY29uZmlnDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL01ha2VmaWxlDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL0tjb25maWcNCj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvTWFr
ZWZpbGUNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2No
aXAvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5oDQo+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAw
L3dpbGNfbW9uLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9t
aWNyb2NoaXAvd2lsYzEwMDAvd2lsY19uZXRkZXYuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRy
aXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93aWxjX3NkaW8uYw0KPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93
aWxjX3NwaS5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWlj
cm9jaGlwL3dpbGMxMDAwL3dpbGNfd2ZpX2NmZ29wZXJhdGlvbnMuYw0KPiAgY3JlYXRlIG1vZGUg
MTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93aWxjX3dmaV9j
ZmdvcGVyYXRpb25zLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVz
cy9taWNyb2NoaXAvd2lsYzEwMDAvd2lsY193ZmlfbmV0ZGV2aWNlLmgNCj4gIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2lsY193bGFu
LmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAv
d2lsYzEwMDAvd2lsY193bGFuLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93
aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2lsY193bGFuX2NmZy5jDQo+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dpbGNfd2xh
bl9jZmcuaA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC93aWxjX3dsYW5faWYuaA0KPiANCg==
