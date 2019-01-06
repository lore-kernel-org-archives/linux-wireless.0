Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0B6C43387
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76560222B1
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfAFACz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 19:02:55 -0500
Received: from mail-oln040092066070.outbound.protection.outlook.com ([40.92.66.70]:28958
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfAFACz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 19:02:55 -0500
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (10.152.0.55) by HE1EUR01HT209.eop-EUR01.prod.protection.outlook.com
 (10.152.1.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sun, 6 Jan
 2019 00:02:51 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sun, 6 Jan 2019 00:02:51 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sun, 6 Jan 2019
 00:02:51 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 4/4] rtlwifi: Don't clear num_rx_inperiod too early
Thread-Topic: [PATCH v3 4/4] rtlwifi: Don't clear num_rx_inperiod too early
Thread-Index: AQHUpVMqbKQKwAnOjEmtsNGk5fiqeA==
Date:   Sun, 6 Jan 2019 00:02:51 +0000
Message-ID: <DB7PR07MB5353AB02E166DAF49D5E68FCE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0035.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::48) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:2378198F28BAB2A65EE50B50B44EC937AAD9A7F521B3F422C140E596023CDE17;UpperCasedChecksum:ABDB5120F5B50E2EA2483BFFBC0F3E29C95CAD2FE9FA7446C43744BA12E85C9C;SizeAsReceived:8771;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [+MX+zvCYfG3n1VEtwC1upCCI+G0CSXF3]
x-microsoft-original-message-id: <4565959f-d15e-500c-6f36-109b2aa29309@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT209;6:TTgMRVDapWAFqfaNlyqY+4wpnwRl39rdfdYVqmEhnZsrX/kcLcBxef1tOxD0iKqfNPrR3Y3VPmFkvGgRzxD7cnCh/Bx4EhtUOMaDf9atdXF6FKn2AjUgZn8cAcF7ReAfvCZTOSmB5OTolQMUKR60sPObk3db78BaYSA+WqS2JK2qeYSypSRqafcwaWUv9wZygmlUUq9zyY6sqWnGDpczmsefWL6NZt/fwnrFV4wKAex8n7q2IYj0m1Hgduh67NqUJcjCLvRrfI207Xq/Z6wHfqyg+LxYkuxVxlHce2El7NOBDp5feV8SqxhTcuWZiYzgTL6Ucva1VS34tvgwwkXItjE1jGEk+v3ZdcKySwosawTi4WakoxzaBSJK2jPgSo8yu/bxs+Ps246YbFBzjP0S+DTpKh0CphA6dM08IT8CehD0qHdajipZzFaBr/ZCe3MF3Pf9dovfRZLaTuMrztgy4A==;5:8qRzTjs+i/Nu1qf4x29655rDIQy8/hhzMEMv9g6AljC0XygGl9YNNsP8RgbgVe/hZd7ZAYpC2u/R1q+/q5G2+4cAYB9mzSa7Flugg6Y4q5X8/279TckiYgbDPS/0VqX75q8czGuKFda9R5sAzBoFhuAsK8OwrnTgehmkgcJVbb8=;7:MaAl4mdu18MXJcfbhsL9TZtTRJ7aIEf3xGceR76xD4UgbYFU3n9SQLxSvoUKdGVcKRtz2DxKNLPsGIY7mpavMTSMuLxQi1Ey9BCJ5DLG1oWNZWjUt+/LhD4+RtbnI2gwtlzjxrf7MaWZVl8XKrRU8Q==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT209;
x-ms-traffictypediagnostic: HE1EUR01HT209:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT209;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT209;
x-microsoft-antispam-message-info: gflcKgtxwmSv4689tBVnY6xeqHzlc81aYBEKr/8GP6A8S3amfo+m2YSa0aAi8Vev
Content-Type: text/plain; charset="utf-8"
Content-ID: <49DADF5C48296D4B979FDD8951861E51@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b28b9f-0f6b-4489-69f7-08d6736a4ca7
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2019 00:02:50.4896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT209
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhpcyBwYXRjaCBtb3ZlcyB0aGUgY2xlYXJpbmcgb2YgcnRscHJpdi0+bGlua19pbmZvLm51bV9y
eF9pbnBlcmlvZCBpbg0KcnRsX3dhdGNoZG9nX3dxX2NhbGxiYWNrIGEgZmV3IGxpbmVzIGRvd24u
DQoNClRoaXMgaXMgbmVjZXNzYXJ5IHNpbmNlIGl0IGlzIHN0aWxsIHVzZWQgaW4gdGhlICJBUCBv
ZmYiIGRldGVjdGlvbg0KY29kZSBibG9jay4gTW92ZWQgY2xlYXJpbmcgb2YgcnRscHJpdi0+bGlu
a19pbmZvLm51bV9yeF9pbnBlcmlvZA0KYXMgd2VsbCBmb3IgY29uc2lzdGVuY3kuDQoNClNpZ25l
ZC1vZmYtYnk6IEJlcm5kIEVkbGluZ2VyIDxiZXJuZC5lZGxpbmdlckBob3RtYWlsLmRlPg0KLS0t
DQp2MjogSW1wcm92ZWQgcGF0Y2ggZGVzY3JpcHRpb24uDQoNCnYzOiBNYWtlIHRoZSB0aXRsZSBm
aXQgaW4gb25lIGxpbmUuDQotLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvYmFzZS5jIHwgNCArKy0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9iYXNlLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFz
ZS5jDQppbmRleCBlZjliNTAyLi43YWE2OGZlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcmVhbHRlay9ydGx3aWZpL2Jhc2UuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydGx3aWZpL2Jhc2UuYw0KQEAgLTIxNzIsOCArMjE3Miw2IEBAIHZvaWQgcnRsX3dh
dGNoZG9nX3dxX2NhbGxiYWNrKHZvaWQgKmRhdGEpDQogCQk7DQogCX0NCiANCi0JcnRscHJpdi0+
bGlua19pbmZvLm51bV9yeF9pbnBlcmlvZCA9IDA7DQotCXJ0bHByaXYtPmxpbmtfaW5mby5udW1f
dHhfaW5wZXJpb2QgPSAwOw0KIAlmb3IgKHRpZCA9IDA7IHRpZCA8PSA3OyB0aWQrKykNCiAJCXJ0
bHByaXYtPmxpbmtfaW5mby50aWR0eF9pbnBlcmlvZFt0aWRdID0gMDsNCiANCkBAIC0yMjM2LDYg
KzIyMzQsOCBAQCB2b2lkIHJ0bF93YXRjaGRvZ193cV9jYWxsYmFjayh2b2lkICpkYXRhKQ0KIAkJ
CXJ0bHByaXYtPmJ0Y29leGlzdC5idGNfaW5mby5pbl80d2F5ID0gZmFsc2U7DQogCX0NCiANCisJ
cnRscHJpdi0+bGlua19pbmZvLm51bV9yeF9pbnBlcmlvZCA9IDA7DQorCXJ0bHByaXYtPmxpbmtf
aW5mby5udW1fdHhfaW5wZXJpb2QgPSAwOw0KIAlydGxwcml2LT5saW5rX2luZm8uYmNuX3J4X2lu
cGVyaW9kID0gMDsNCiANCiAJLyogPDY+IHNjYW4gbGlzdCAqLw0KLS0gDQoxLjkuMQ0K
