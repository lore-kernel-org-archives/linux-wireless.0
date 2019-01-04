Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73239C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE5C208E3
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfADMs7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:48:59 -0500
Received: from mail-oln040092069093.outbound.protection.outlook.com ([40.92.69.93]:27370
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727866AbfADMs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 07:48:57 -0500
Received: from HE1EUR02FT009.eop-EUR02.prod.protection.outlook.com
 (10.152.10.57) by HE1EUR02HT232.eop-EUR02.prod.protection.outlook.com
 (10.152.11.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Fri, 4 Jan
 2019 12:48:54 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.10.52) by
 HE1EUR02FT009.mail.protection.outlook.com (10.152.10.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Fri, 4 Jan 2019 12:48:54 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.000; Fri, 4 Jan 2019
 12:48:54 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] rtlwifi: Move the clearing of
Thread-Topic: [PATCH 4/4] rtlwifi: Move the clearing of
Thread-Index: AQHUpCvZ4dH6TVfU7U+vmVR8cxtIDg==
Date:   Fri, 4 Jan 2019 12:48:54 +0000
Message-ID: <DB7PR07MB5353CEDC2BF6AAC1E95E4466E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0008.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::18) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:3C39BD1289A656C54944821A3136053D1A2C7ADDEC29E393109A665E07ACF9F6;UpperCasedChecksum:615E02205D2A157478AD46069295F34B15EA333074208519A4E25A1C1A7D4845;SizeAsReceived:8713;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [pO5RHo1UyCmnsio6C6oj8MCv4iRowUsf]
x-microsoft-original-message-id: <72b5e285-e32c-6cd3-12c8-cba92e84757f@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR02HT232;6:GXIfkTwBrG9PzVY+tgItMSvGDDcNsYXO1csfe7/u3QQNzFwovf4sbP6Mn53PMXVEeEpu4sF7UISaiuGk9gfy7WhOP7dSMDw7lJt3vzAMFTXSB5DFrpSbv9IdHGxl89ifTTYtGmP8B8vAY3GwUyvZxnzHr113TUS7z+pw9ODtKqubIr5m+xOS/hIrPSOcvzFlD5559cbOKdnk7Er9EybSSPVb7IDXi+dwGdwRFaM3qPpSLqztrW68kS0E8QNeZTCp+uRJZWk3nMHmBCLRNq5y0Vou2r5zbiFs4NEN9SXwlySuHd8kUeZ/E2+dt8t/Su2uOqrn8qUhzjlfH90I5HFsk4TNH4DVbeGKiYl5w4LwQZbNhl6mHKWTbDjz4/PqnWR+J6ZYZaut2WS8w+70cqzpoQNtugzsIzNb7RWAzxgA8Pzj5iEjdsGzCJ6mLnR9cz8P+roFAUJE1T+I/zmgtgBtWg==;5:ke9WjBB4xbHQ3qNf8myKygEY351MwMFIhOvAO8cAGao5DHKnbUD3wAiP/lG6rfiM19GdEm5tn2Ihov2VYkwzhOUaxXhisKDXDRpbNUcXGjIPh8apti6Fepldkzzsk4/smMbXu92TlRid866SuzxTaZMAWFyKjJymvh+KYX+O33U=;7:SXguYxpsipqzcgJ06zrYT9kiWEZ9o1E20L7grDNimO9Jt9qKW2LQrKYDgag09w0Xarlk53ZAxvQ3tr5ELMtyu6apQ0RIbD7KoTPJZRsdCwveYF88/6/zFTHBnge0d9sVaTLc6TswmFYTUOYccj/KMA==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR02HT232;
x-ms-traffictypediagnostic: HE1EUR02HT232:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR02HT232;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR02HT232;
x-microsoft-antispam-message-info: hd4FBW53lJRWHo+4t0ZLGj4eCieIkpz+L47CFljiiHAeXJSRTM5za/xxf4cilFXY
Content-Type: text/plain; charset="utf-8"
Content-ID: <170368D54D74E343BC086CD382054187@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: c033053e-2962-455d-307a-08d67242fc39
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 12:48:53.9674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT232
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ICBydGxwcml2LT5saW5rX2luZm8ubnVtX3J4X2lucGVyaW9kIGluIHJ0bF93YXRjaGRvZ193cV9j
YWxsYmFjayBhIGZldyBsaW5lcw0KICBkb3duLg0KDQpUaGlzIGlzIG5lY2Vzc2FyeSBzaW5jZSBp
dCBpcyBzdGlsbCB1c2VkIGluIHRoZSAiQVAgb2ZmIiBkZXRlY3Rpb24NCmNvZGUgYmxvY2suIE1v
dmVkIGNsZWFyaW5nIG9mIHJ0bHByaXYtPmxpbmtfaW5mby5udW1fcnhfaW5wZXJpb2QNCmFzIHdl
bGwgZm9yIGNvbnNpc3RlbmN5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVy
bmQuZWRsaW5nZXJAaG90bWFpbC5kZT4NCi0tLQ0KICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvYmFzZS5jIHwgNCArKy0tDQogIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL2Jhc2UuYw0KaW5kZXggZWY5YjUwMi4uN2FhNjhmZSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9iYXNlLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9iYXNlLmMNCkBAIC0yMTcyLDggKzIxNzIsNiBAQCB2
b2lkIHJ0bF93YXRjaGRvZ193cV9jYWxsYmFjayh2b2lkICpkYXRhKQ0KICAJCTsNCiAgCX0NCiAg
DQotCXJ0bHByaXYtPmxpbmtfaW5mby5udW1fcnhfaW5wZXJpb2QgPSAwOw0KLQlydGxwcml2LT5s
aW5rX2luZm8ubnVtX3R4X2lucGVyaW9kID0gMDsNCiAgCWZvciAodGlkID0gMDsgdGlkIDw9IDc7
IHRpZCsrKQ0KICAJCXJ0bHByaXYtPmxpbmtfaW5mby50aWR0eF9pbnBlcmlvZFt0aWRdID0gMDsN
CiAgDQpAQCAtMjIzNiw2ICsyMjM0LDggQEAgdm9pZCBydGxfd2F0Y2hkb2dfd3FfY2FsbGJhY2so
dm9pZCAqZGF0YSkNCiAgCQkJcnRscHJpdi0+YnRjb2V4aXN0LmJ0Y19pbmZvLmluXzR3YXkgPSBm
YWxzZTsNCiAgCX0NCiAgDQorCXJ0bHByaXYtPmxpbmtfaW5mby5udW1fcnhfaW5wZXJpb2QgPSAw
Ow0KKwlydGxwcml2LT5saW5rX2luZm8ubnVtX3R4X2lucGVyaW9kID0gMDsNCiAgCXJ0bHByaXYt
PmxpbmtfaW5mby5iY25fcnhfaW5wZXJpb2QgPSAwOw0KICANCiAgCS8qIDw2PiBzY2FuIGxpc3Qg
Ki8NCi0tIA0KMS45LjENCg==
