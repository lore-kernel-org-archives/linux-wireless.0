Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25786C43612
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54FD222B1
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfAFACK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 19:02:10 -0500
Received: from mail-oln040092066017.outbound.protection.outlook.com ([40.92.66.17]:60642
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfAFACK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 19:02:10 -0500
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (10.152.0.54) by HE1EUR01HT212.eop-EUR01.prod.protection.outlook.com
 (10.152.1.166) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sun, 6 Jan
 2019 00:02:05 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sun, 6 Jan 2019 00:02:05 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sun, 6 Jan 2019
 00:02:05 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Topic: [PATCH v3 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Index: AQHUpVMOhOTwyJzVpEik1aol4KfSfQ==
Date:   Sun, 6 Jan 2019 00:02:05 +0000
Message-ID: <DB7PR07MB535370C263EDDF8112ED81E8E4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0011.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::24) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:2B2A6F999BEE0A08169ED0A838DDCCEA68908974C2733684B562936B6FBD6D9B;UpperCasedChecksum:26984F858AAD8479CB098F2F0C8C14C33561753E9AF35DC047542832AA799895;SizeAsReceived:8761;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [NFImcgpbZSiC6tZdNMtNUWnYTS+9UHrF]
x-microsoft-original-message-id: <f3655c8f-7ac7-275a-e974-48a56463ba4d@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT212;6:AcVB3CzA0c38ydNE2r8DlU+1jWOyXirVjZ2vDi16T880HgOnHgLU1HX2aeg0XCAOt/V1FXwz2LUDIiUGjOCJJS4ZpZj4wcBi0uURfWZMD/j+LAMmdp+ccCwdx4kUmEtZt7nyaDIpKwFp6xA0BDVzJj03CKfeWDNm8v1xYJFCC2n13bHSgifgnXhisMpjNUYJ1P7WKeeaK28XLA6Ks4fXs/qyZACMbgJ5xTSFu1iOnEVzJP8mvhmei+4r1RIxhgyGm2c+vwGRMBXubUczLrqOzRsqtUytSdnSVjoBNkkU0DlJlz7MQsOzLt+ocbTDzwUesRqiHXAjRxfIZhSftfHaN9kXJR13WAP+q/UGQji8Vg/DYR8YbNDi791XKTQbwAME0F1g5H3MiMCowjGep/S+fWV1yd8jRVqR1YsW2bmXTce5vlnmYhEkiAcWLabfbcKae4R6Wwfq/X8hi3ps5oMAYA==;5:qisw0UCSd+Wi8V+O6SbFjxgNtHYK2+ruFprVSBe1lpYDTPKD8zdLOfkiKs5Y5GcFODgQGUGJ9TwJ4pxJy+6nXbh0MLd/uCZYt9BjUvu6bI5gojgfLWdX5Hkxu63UenYOC1PPF3M78JcJS9lvdfDToJBRXSfuR3oJDUFHgJ2/uZc=;7:tqBbIvvg297Fjn3/0LVoZP+Cl+g/5QSVwl8/IyPcmDClTbIBFIIA/rbZLRRNcqFYP3varbdYLXQAy01UFgXLphkWOzDcCmjYjqiKAsLthBCXWGhKseuMCVu/YGbyFCOW6ajQ6LNtPuiKOLcwGv8eGw==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031324274)(2017031323274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT212;
x-ms-traffictypediagnostic: HE1EUR01HT212:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT212;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT212;
x-microsoft-antispam-message-info: QRXXc88hs7A2YnAXfQQQjK8pgYShx3ZmjytubL3e1TJ758L/x4+2mJwRAHyTMcsp
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3F36AC084F87D4DA7F1489AAF178201@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 1affd2c0-22f0-4517-9eb6-08d6736a313e
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2019 00:02:04.5043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT212
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Q3VycmVudGx5IHRoZSBydGw4NzIzYWUgZHJpdmVyIGlzIGJyb2tlbiAoc2luY2UgdjQuNykuDQoN
CkNvbm5lY3Rpb24gdG8gQVAgaXMgbG9zdCB2ZXJ5IG9mdGVuLCBlc3BlY2lhbGx5IHdoZW4NCnRo
ZSBzaWduYWwgbGV2ZWwgaXMgbm90IHZlcnkgZ29vZC4NCg0KVGhlIG1haW4gaXNzdWUgaXMgdGhl
IHBvd2VyIHNhdmUgbW9kZSBpcyBiYXNpY2FsbHkNCm5vdCB3b3JraW5nLCBhbmQgc2VlbXMgdG8g
dHJpZ2dlciBhIGZpcm13YXJlIGJ1Zy4NClNvIEkgaGFkIHRvIHRha2Ugb3V0IHRoZSBGVyBMUFMg
bW9kZSBoYW5kbGluZy4NCg0KV2hpbGUgZGVidWdnaW5nIHRoZSBkcml2ZXIgSSBmb3VuZCBhIGNv
dXBsZSByZWxhdGVkIGlzc3VlcywNCmZvciBpbnN0YW5jZSB0aGF0IHRoZSBzaWduYWwgbGV2ZWwg
aW4gZG0udW5kZWNfc21fcHdkYg0KaXMgbm8gbG9uZ2VyIGFjY3VyYXRlIChtYXkgYmUgZXZlbiBt
dWNoIHRvbyBoaWdoKSB3aGVuIG5vIG1vcmUNCnBhY2tldHMgYXJlIHJlY2VpdmVkLCBhbmQgaXQg
aW5jcmVhc2VzIHRoZSBsaWtlbGlob29kIHRvIHJlY2VpdmUNCnNvbWV0aGluZyBpZiB0aGUgaW5w
dXQgZ2FpbiBpcyBzZXQgdG8gbWF4aW11bS4NCg0KVGhlIHBhdGNoIHdhcyB0ZXN0ZWQgd2l0aCB0
aGUgcnRsODcyM2FlIFBDSSBjYXJkIGluIG15IGxhcHRvcA0KYWdhaW5zdCBhIEZSSVRaIUJveCA3
NTkwIEFQIC0tIHRoZSBXaUZpIGNvbm5lY3Rpb24gd29ya3Mgbm93DQp2ZXJ5IHJlbGlhYmxlIGZv
ciBtZS4NCg0KQ2hhbmdlTG9nOg0KDQp2MjogQWRqdXN0cyB0aGUgZGVmYXVsdHMgb2Ygc3dscHMg
YW5kIGZ3bHBzIG1vZHVsZQ0KcGFyYW1ldGVycyB0byBtYXRjaCB0aGUgZmlybXdhcmUgY2FwYWJp
bGl0aWVzIGluc3RlYWQgb2YgcmVtb3ZpbmcNCnRoZSB3aG9sZSBjb2RlLCBzbyBpdCBjYW4gYmUg
ZWFzaWx5IHJlLWFjdGl2YXRlZCBvbmNlIGEgZmlybXdhcmUNCnVwZGF0ZSBpcyBhdmFpbGFibGUu
DQoNCnYzOiBNYWtlIHRoZSB0aXRsZSBvZiBlYWNoIHBhdGNoIGZpdCBpbiBvbmUgbGluZS4NCg0K
DQpCZXJuZCBFZGxpbmdlciAoNCk6DQogIHJ0bDg3MjNhZTogVGFrZSB0aGUgRlcgTFBTIG1vZGUg
aGFuZGxpbmcgb3V0DQogIHJ0bDg3MjNhZTogRG9udCB1c2Ugb2xkIGRhdGEgZm9yIGlucHV0IGdh
aW4gY29udHJvbA0KICBydGw4NzIzYWU6IFJlLWludHJvZHVjZSB0aGUgYWRhcHRpdmUgcmF0ZSBj
b250cm9sDQogIHJ0bHdpZmk6IERvbid0IGNsZWFyIG51bV9yeF9pbnBlcmlvZCB0b28gZWFybHkg
DQoNCiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jICAgICAgICB8
ICA0ICstDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYyAgICAg
ICAgfCAgMiArDQogLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2Rt
LmMgICAgfCA5NSArKysrKysrKysrKysrKysrKysrKystDQogLi4uL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvcnRsODcyM2FlL3N3LmMgICAgfCAgOCArLQ0KIDQgZmlsZXMgY2hhbmdlZCwg
MTAxIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQoNCi0tIA0KMS45LjENCg==
