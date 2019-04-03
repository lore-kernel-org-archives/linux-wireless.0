Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F60C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 16:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3844620663
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 16:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="CrviYLz5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfDCQ64 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:58:56 -0400
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:47746
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfDCQ64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 12:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rdBZjMstCsChuGq/9gYnN0str6pkZ7AeCjG/EU0bFQ=;
 b=CrviYLz5cvaGWd5MWh21JGgp/ns+TGWki6HKThABGPaMjxAUyEkZ2uIkt5vUstVrPD0gDOEa9p2l++fWflFcFiQGuvOtReoMbNVy3xnqrb9GUnm9c6FcNJyo+dBdXf88auc8563Sw2tfTrbTSl8aI/XWcAmvAQsiHts0tYnMB34=
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com (20.179.32.150) by
 AM0PR04MB6306.eurprd04.prod.outlook.com (20.179.33.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Wed, 3 Apr 2019 16:58:52 +0000
Received: from AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::1599:23e7:e53e:fe32]) by AM0PR04MB6065.eurprd04.prod.outlook.com
 ([fe80::1599:23e7:e53e:fe32%2]) with mapi id 15.20.1750.017; Wed, 3 Apr 2019
 16:58:52 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Rakesh Pillai <pillair@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Report low ack rssi based on the reason code
Thread-Topic: [PATCH v2] ath10k: Report low ack rssi based on the reason code
Thread-Index: AQHU6e4ZcPuuwxpGbECaIXzPtbBfUqYqqSEA
Date:   Wed, 3 Apr 2019 16:58:51 +0000
Message-ID: <5f25f471-5753-7d4a-91f8-9a3986117580@bowerswilkins.com>
References: <1554276181-7879-1-git-send-email-pillair@codeaurora.org>
In-Reply-To: <1554276181-7879-1-git-send-email-pillair@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To AM0PR04MB6065.eurprd04.prod.outlook.com
 (2603:10a6:208:139::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.244.182.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76fc5adb-2481-49a5-110a-08d6b855a5f1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR04MB6306;
x-ms-traffictypediagnostic: AM0PR04MB6306:
x-microsoft-antispam-prvs: <AM0PR04MB6306ED637E73CE6240E388F199570@AM0PR04MB6306.eurprd04.prod.outlook.com>
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(136003)(396003)(189003)(199004)(6116002)(106356001)(229853002)(110136005)(66066001)(8676002)(105586002)(81166006)(25786009)(31696002)(486006)(99286004)(97736004)(68736007)(81156014)(31686004)(446003)(86362001)(316002)(52116002)(6512007)(3846002)(6486002)(14454004)(44832011)(36756003)(2616005)(53936002)(8936002)(256004)(71190400001)(5660300002)(6436002)(26005)(71200400001)(2906002)(186003)(102836004)(53546011)(76176011)(4326008)(2501003)(476003)(7736002)(11346002)(6246003)(386003)(305945005)(14444005)(6506007)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6306;H:AM0PR04MB6065.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dwF8hwP9al/8BR+jTP9+t/NHyGstL3KW7kC/KnOS6xjqP05CH79+X7ictzMWsBnztIXYOW6ZL2GCwDbEg3HBUY4J1mjwpmYAUxyi7xH+GeIVs9BuiQMhsmy44x15CaIlzO9K/CMWYniRHBKYTHQ5J8YPe233WU23k6890iXHnsSP9o6YNwLb9U9gYo6/LwMrDIjArz3a0BswE/ihrq0GHlwYo3B2S3BVKAktUF4NCoCfjRGF3ZL/soj5bdB8XiE++mPGfUtaoFu6EsDccoxw9oh34LqkaUX3HQa/uY4VwcPpQuiXiEnLB2ZBRXJOeBTnIRNjASTBhGVhrSA+xJKjGk7x78whmu6zWihG/NqMdo+1OvjMJKZjNou1JkKOf1YzIcOQiVV0hWfduzR42QZTVORflW4Y4EMmnjo9OJBI/uM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09CD9F4CAD7635458D2FEE72AF918BFE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fc5adb-2481-49a5-110a-08d6b855a5f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2019 16:58:51.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6306
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA0LzAzLzIwMTkgMTI6MjMgQU0sIFJha2VzaCBQaWxsYWkgd3JvdGU6DQo+IEZpcm13
YXJlIHNlbmRzIHBlZXIgc3RhIGtpY2tvdXQgZXZlbnQgdG8gdGhlIGRyaXZlcg0KPiBhbG9uZyB3
aXRoIHRoZSByZWFzb24gY29kZSBmb3IgYSBwYXJ0aWN1bGFyIHBlZXIuDQo+DQo+IEN1cnJlbnRs
eSB0aGUgc3RhIGtpY2tvdXQgZXZlbnQgaXMgZGVsaXZlcmVkIHRvIHRoZQ0KPiB1cHBlciBsYXll
ciB3aXRob3V0IGNoZWNraW5nIGlmIHRoZSByZWFzb24gY29kZSBpcw0KPiB2YWxpZCBvciBub3Qu
IFRoaXMgY2F1c2VzIGZyZXF1ZW50IGRpc2Nvbm5lY3Rpb24gb2YNCj4gdGhlIFNUQS4NCj4NCj4g
UmVwb3J0IGxvdyBhY2sgcnNzaSBldmVudCB0byBtYWM4MDIxMSBvbmx5IGlmIHRoZSByZWFzb24N
Cj4gY29kZSBpcyB2YWxpZC4NCj4NCj4gVGVzdGVkIEhXOiBXQ04zOTkwDQo+IFRlc3RlZCBGVzog
V0xBTi5ITC4yLjAtMDExODgtUUNBSExTV01UUExaLTENCj4NCj4gU2lnbmVkLW9mZi1ieTogUmFr
ZXNoIFBpbGxhaSA8cGlsbGFpckBjb2RlYXVyb3JhLm9yZz4NCj4gLS0tDQo+IENoYW5nZXMgZnJv
bSB2MToNCj4gLSBBZGRlZCByZWFzb24gY29kZSBpbiB0bHYgc3RydWN0dXJlLCBzbyB0aGF0IGl0
IGRvZXMgbm90IGJyZWFrIG5vbi10bHYgd21pIGV2ZW50IHBhcnNpbmcuDQo+IC0tLQ0KPiAgIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLXRsdi5jIHwgIDQgKysrLQ0KPiAgIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLXRsdi5oIHwgIDUgKysrKysNCj4gICBk
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5jICAgICB8ICA5ICsrKysrKy0tLQ0K
PiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmggICAgIHwgMTEgKysrKysr
KysrKysNCj4gICA0IGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dt
aS10bHYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLXRsdi5jDQo+IGlu
ZGV4IDU4MmZiMTEuLjlkNmVlOTIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGgxMGsvd21pLXRsdi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGgxMGsvd21pLXRsdi5jDQo+IEBAIC04NzYsNyArODc2LDcgQEAgc3RhdGljIGludCBhdGgxMGtf
d21pX3Rsdl9vcF9wdWxsX3BlZXJfa2lja19ldihzdHJ1Y3QgYXRoMTBrICphciwNCj4gICAJCQkJ
CSAgICAgICBzdHJ1Y3Qgd21pX3BlZXJfa2lja19ldl9hcmcgKmFyZykNCj4gICB7DQo+ICAgCWNv
bnN0IHZvaWQgKip0YjsNCj4gLQljb25zdCBzdHJ1Y3Qgd21pX3BlZXJfc3RhX2tpY2tvdXRfZXZl
bnQgKmV2Ow0KPiArCWNvbnN0IHN0cnVjdCB3bWlfdGx2X3BlZXJfc3RhX2tpY2tvdXRfZXZlbnQg
KmV2Ow0KPiAgIAlpbnQgcmV0Ow0KPiAgIA0KPiAgIAl0YiA9IGF0aDEwa193bWlfdGx2X3BhcnNl
X2FsbG9jKGFyLCBza2ItPmRhdGEsIHNrYi0+bGVuLCBHRlBfQVRPTUlDKTsNCj4gQEAgLTg5Myw2
ICs4OTMsOCBAQCBzdGF0aWMgaW50IGF0aDEwa193bWlfdGx2X29wX3B1bGxfcGVlcl9raWNrX2V2
KHN0cnVjdCBhdGgxMGsgKmFyLA0KPiAgIAl9DQo+ICAgDQo+ICAgCWFyZy0+bWFjX2FkZHIgPSBl
di0+cGVlcl9tYWNhZGRyLmFkZHI7DQo+ICsJYXJnLT5yZWFzb24gPSBfX2xlMzJfdG9fY3B1KGV2
LT5yZWFzb24pOw0KPiArCWFyZy0+cmVhc29uX2NvZGVfdmFsaWQgPSB0cnVlOw0KPiAgIA0KPiAg
IAlrZnJlZSh0Yik7DQo+ICAgCXJldHVybiAwOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDEway93bWktdGx2LmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoMTBrL3dtaS10bHYuaA0KPiBpbmRleCA2NWU2YWE1Li5iZTY4YWM2IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS10bHYuaA0KPiArKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS10bHYuaA0KPiBAQCAtMTk4NCw2ICsxOTg0
LDExIEBAIHN0cnVjdCB3bWlfdGx2X2RpYWdfZGF0YV9ldiB7DQo+ICAgCV9fbGUzMiBudW1faXRl
bXM7DQo+ICAgfSBfX3BhY2tlZDsNCj4gICANCj4gK3N0cnVjdCB3bWlfdGx2X3BlZXJfc3RhX2tp
Y2tvdXRfZXZlbnQgew0KPiArCXN0cnVjdCB3bWlfbWFjX2FkZHIgcGVlcl9tYWNhZGRyOw0KPiAr
CV9fbGUzMiByZWFzb247DQo+ICt9IF9fcGFja2VkOw0KPiArDQo+ICAgc3RydWN0IHdtaV90bHZf
c3RhX2tlZXBhbGl2ZV9jbWQgew0KPiAgIAlfX2xlMzIgdmRldl9pZDsNCj4gICAJX19sZTMyIGVu
YWJsZWQ7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dt
aS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway93bWkuYw0KPiBpbmRleCA5OGE5
MGU0Li42NjAzYzMxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
MTBrL3dtaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmMN
Cj4gQEAgLTM0MjgsOSArMzQyOCw2IEBAIHZvaWQgYXRoMTBrX3dtaV9ldmVudF9wZWVyX3N0YV9r
aWNrb3V0KHN0cnVjdCBhdGgxMGsgKmFyLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAgIAkJcmV0
dXJuOw0KPiAgIAl9DQo+ICAgDQo+IC0JYXRoMTBrX2RiZyhhciwgQVRIMTBLX0RCR19XTUksICJ3
bWkgZXZlbnQgcGVlciBzdGEga2lja291dCAlcE1cbiIsDQo+IC0JCSAgIGFyZy5tYWNfYWRkcik7
DQo+IC0NCj4gICAJcmN1X3JlYWRfbG9jaygpOw0KPiAgIA0KPiAgIAlzdGEgPSBpZWVlODAyMTFf
ZmluZF9zdGFfYnlfaWZhZGRyKGFyLT5odywgYXJnLm1hY19hZGRyLCBOVUxMKTsNCj4gQEAgLTM0
NDAsNiArMzQzNywxMiBAQCB2b2lkIGF0aDEwa193bWlfZXZlbnRfcGVlcl9zdGFfa2lja291dChz
dHJ1Y3QgYXRoMTBrICphciwgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gICAJCWdvdG8gZXhpdDsN
Cj4gICAJfQ0KPiAgIA0KPiArCWlmIChhcmcucmVhc29uX2NvZGVfdmFsaWQgJiYNCj4gKwkgICAg
YXJnLnJlYXNvbiA9PSBXTUlfUEVFUl9TVEFfS0lDS09VVF9SRUFTT05fVU5TUEVDSUZJRUQpDQo+
ICsJCWdvdG8gZXhpdDsNCj4gKw0KV2h5IGRvIHdlIHdhbnQgdGhpcyBldmVudCBub3QgdG8gYmUg
ZGVsaXZlcmVkIHRvIHVzZXIgc3BhY2U/DQo+ICsJYXRoMTBrX2RiZyhhciwgQVRIMTBLX0RCR19X
TUksICJ3bWkgZXZlbnQgcGVlciBzdGEga2lja291dCAlcE0gcmVhc29uIGNvZGUgJWRcbiIsDQo+
ICsJCSAgIGFyZy5tYWNfYWRkciwgYXJnLnJlYXNvbik7DQo+ICAgCWllZWU4MDIxMV9yZXBvcnRf
bG93X2FjayhzdGEsIDEwKTsNCj4gICANCj4gICBleGl0Og0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway93bWkuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0
aC9hdGgxMGsvd21pLmgNCj4gaW5kZXggZTFjNDBiYi4uM2NjZDc5ZSAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway93bWkuaA0KPiArKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5oDQo+IEBAIC02Nzk3LDYgKzY3OTcsOCBAQCBzdHJ1
Y3Qgd21pX3ZkZXZfc3RhcnRfZXZfYXJnIHsNCj4gICANCj4gICBzdHJ1Y3Qgd21pX3BlZXJfa2lj
a19ldl9hcmcgew0KPiAgIAljb25zdCB1OCAqbWFjX2FkZHI7DQo+ICsJdTMyIHJlYXNvbjsNCj4g
Kwlib29sIHJlYXNvbl9jb2RlX3ZhbGlkOw0KPiAgIH07DQo+ICAgDQpBZGRpbmcgZXh0cmEgbWVt
YmVycyB0byB0aGlzIHN0cnVjdHVyZSBicmVha3Mgc3RydWN0dXJlIGNvbnNpc3RlbmN5IA0KYmV0
d2VlbiBGVyBhbmQgaG9zdCBkcml2ZXIgc2luY2UgRlcgZG9lc24ndCBoYXZlIHN1Y2ggbWVtYmVy
cy4NCg0KUGV0ZXINCg==
