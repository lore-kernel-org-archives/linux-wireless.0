Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C4AC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BDC22300
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfAESjR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:39:17 -0500
Received: from mail-oln040092071076.outbound.protection.outlook.com ([40.92.71.76]:4272
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbfAESjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 13:39:16 -0500
Received: from DB5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (10.152.20.56) by DB5EUR03HT051.eop-EUR03.prod.protection.outlook.com
 (10.152.21.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Sat, 5 Jan
 2019 18:39:13 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.20.60) by
 DB5EUR03FT031.mail.protection.outlook.com (10.152.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Sat, 5 Jan 2019 18:39:13 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sat, 5 Jan 2019
 18:39:13 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] rtlwifi: Move the clearing of
Thread-Topic: [PATCH v2 4/4] rtlwifi: Move the clearing of
Thread-Index: AQHUpSX0RodfXaIwKEq/N5uCNJLVdQ==
Date:   Sat, 5 Jan 2019 18:39:13 +0000
Message-ID: <DB7PR07MB53536D1078CD129E03B30A35E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0009.eurprd03.prod.outlook.com (2603:10a6:20b::22)
 To DB7PR07MB5353.eurprd07.prod.outlook.com (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:090A82C17E26A6D897C006561CED22CA66ACE93483F6E2E7EE6D8C730044CE54;UpperCasedChecksum:CE12346D27DB8BE5C4139591D9A9F184114F666CCE1759271BFB10BD66EEC96F;SizeAsReceived:8691;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [hObIGLOXRf8iggZZK5Gqb1eyufWxwzdN]
x-microsoft-original-message-id: <2be8fc73-51c2-48b7-1659-1de30b284563@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR03HT051;6:gJgCd4IRrl6wy2w4LB23u2vsDxIc0zIK8rgj3EYVqrsdsazr7LbVOh293ArFCjVi4+yjdjinvz8tUNjkxjD8U5BYubujgjZ9YyXCjPgnqxConEv/UqKHFjOU6FBUnf6wj2iE7JSZt56jeFJkm9zALFKWckuQnV5kNdozv+FlDDvK7R/fNhIk8dHPAquchQiIlwR4MmsBEGv+Tx8GtCPE2QFGHRILau+ewGDEMpkShG5hEmmSTVjMrf3B1H1vfvTue+l9ekYGAhM+9a60Ivrz7czkCQ9N1jwidqLIg73CkVsCfINrysyc8tk0mUbVwyF6+vVKBJs7oIRSGDniVcDCpHWaEieODPQYtXGjGtp/lTvYKf4gMd4AjgyboL8/YG0Pb9XI9G0ZRXFDfw9Sqn65gZv7Nv8H3o0nhqze52qABDtKZLAnia4l4UwzNvCCN2iHnL+s2ghdp+QjHsYIeSwg1Q==;5:IeoQONhN7iPPEeBfVvlgrrDFRV93cAUJhFJihDMi9clfWwgAemqE3YfzQ+OQQlfNdsmDTQ7oUMw8i/JoCRtUwegMhC2YX/6qCsk/wD4IggDfrn9guPYKcapNE0l05UO22eSyI5cYZ7kllXHhsTv7Q7GSV16eE/gqltCfO7GhnTI=;7:b8VJuTd2PmQu8KOykcglyoX+ua9neo0FbidJJig8wzmdwwjejwXfp4lgGdy/BkGnN6BxAOnisT0e3R1afOHY2kVtAHk4Q6hrSU4ClPtYB46Dzq/+QfS5z1qBJQZejuupvVADhyRB4YfdHaXPmEKQaA==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT051;
x-ms-traffictypediagnostic: DB5EUR03HT051:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR03HT051;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR03HT051;
x-microsoft-antispam-message-info: VU36SfuMqNEldXtCPjgvoLFDZvBZX8NrE+QFeH3kyzs8ZJoYazBcMF2Dn2iOImZu
Content-Type: text/plain; charset="utf-8"
Content-ID: <266879AB98A84A41A65057C017D205D9@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: d549f8df-c99b-4f9c-5c2d-08d6733d16d2
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 18:39:12.7900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT051
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IHJ0bHByaXYtPmxpbmtfaW5mby5udW1fcnhfaW5wZXJpb2QgaW4gcnRsX3dhdGNoZG9nX3dxX2Nh
bGxiYWNrIGEgZmV3IGxpbmVzDQogZG93bg0KDQpUaGlzIGlzIG5lY2Vzc2FyeSBzaW5jZSBpdCBp
cyBzdGlsbCB1c2VkIGluIHRoZSAiQVAgb2ZmIiBkZXRlY3Rpb24NCmNvZGUgYmxvY2suIE1vdmVk
IGNsZWFyaW5nIG9mIHJ0bHByaXYtPmxpbmtfaW5mby5udW1fcnhfaW5wZXJpb2QNCmFzIHdlbGwg
Zm9yIGNvbnNpc3RlbmN5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVybmQu
ZWRsaW5nZXJAaG90bWFpbC5kZT4NCi0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9iYXNlLmMgfCA0ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL2Jhc2UuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9iYXNlLmMNCmluZGV4IGVmOWI1MDIuLjdhYTY4ZmUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jDQpAQCAtMjE3Miw4ICsyMTcyLDYgQEAgdm9pZCBy
dGxfd2F0Y2hkb2dfd3FfY2FsbGJhY2sodm9pZCAqZGF0YSkNCiAJCTsNCiAJfQ0KIA0KLQlydGxw
cml2LT5saW5rX2luZm8ubnVtX3J4X2lucGVyaW9kID0gMDsNCi0JcnRscHJpdi0+bGlua19pbmZv
Lm51bV90eF9pbnBlcmlvZCA9IDA7DQogCWZvciAodGlkID0gMDsgdGlkIDw9IDc7IHRpZCsrKQ0K
IAkJcnRscHJpdi0+bGlua19pbmZvLnRpZHR4X2lucGVyaW9kW3RpZF0gPSAwOw0KIA0KQEAgLTIy
MzYsNiArMjIzNCw4IEBAIHZvaWQgcnRsX3dhdGNoZG9nX3dxX2NhbGxiYWNrKHZvaWQgKmRhdGEp
DQogCQkJcnRscHJpdi0+YnRjb2V4aXN0LmJ0Y19pbmZvLmluXzR3YXkgPSBmYWxzZTsNCiAJfQ0K
IA0KKwlydGxwcml2LT5saW5rX2luZm8ubnVtX3J4X2lucGVyaW9kID0gMDsNCisJcnRscHJpdi0+
bGlua19pbmZvLm51bV90eF9pbnBlcmlvZCA9IDA7DQogCXJ0bHByaXYtPmxpbmtfaW5mby5iY25f
cnhfaW5wZXJpb2QgPSAwOw0KIA0KIAkvKiA8Nj4gc2NhbiBsaXN0ICovDQotLSANCjEuOS4xDQo=
