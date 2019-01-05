Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9061C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B9022300
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfAESi7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:38:59 -0500
Received: from mail-oln040092072022.outbound.protection.outlook.com ([40.92.72.22]:6172
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfAESi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 13:38:58 -0500
Received: from DB5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (10.152.20.55) by DB5EUR03HT167.eop-EUR03.prod.protection.outlook.com
 (10.152.20.253) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Sat, 5 Jan
 2019 18:38:55 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.20.60) by
 DB5EUR03FT031.mail.protection.outlook.com (10.152.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Sat, 5 Jan 2019 18:38:55 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sat, 5 Jan 2019
 18:38:55 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling out
Thread-Topic: [PATCH v2 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling
 out
Thread-Index: AQHUpSXpgIurv04PvE2G2aRal3jeVQ==
Date:   Sat, 5 Jan 2019 18:38:55 +0000
Message-ID: <DB7PR07MB5353AB33A4B6B65A8725483DE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0009.eurprd03.prod.outlook.com (2603:10a6:20b::22)
 To DB7PR07MB5353.eurprd07.prod.outlook.com (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:27A1F20B174706964B16A057673F59FE422724317CA015346B59EE03F89D4D31;UpperCasedChecksum:373907BA3566C3D6EFC021AC012BEF0272F19E278B0D3E311A93AF05524A8519;SizeAsReceived:8741;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [V1zTgZHRCRUga+9S0CZWcjkvSUFHwhW1]
x-microsoft-original-message-id: <356f41ab-f365-d893-47dd-e7f23ab133f4@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR03HT167;6:vJVR//eBNSFXylxXJe7g4YaJMvNvx/Bi7TvKYwMbyPwwtMoVknoWmgraibEGnht30aC2xQZUVcxFu25yaMWuei90nfbXaMcEl6u2W9sgE32b40NYJPbEGGz+an5BWdDHJDiAiXn/Qf/1pb3Ms9xc1g76QTSIbxwyUnUQQ53KNTnNZPKcSPmURUMzJUwizQRN90sMDmvWZB3lQFo1p7T+dOmxTE+pkcuWeopeFoSdtm5koHP707PGMqkMxNjR+KL0eNuzO9EzuUF3F1meRH8Bmcd4MYP8nzSgfjbWHNYPo8VDUEAGn/NRLSlvdup4oKuOnHXXU/tvNw+5FB5YFH18yUgWNBN8yYRbFqLOBgb0GhvWeBm+0REhaxAkTzTlPUZngvJ5KfhsiDQ1vyBglYyGwuOVYe+MVoPqSRdzK5jYkMoOgtf91yxQbWIi3zUHnbScUnbtVdy2hLUu4I6GksI8/A==;5:Kpozm7PsHdIYY/JDPYhB+BA2llPUFUlbXOmZtlwBP86lmo5eeGap3cqpAJLxlqKJDFaN45O36b8I/i4oOrHzGGJ+eexz0whN4Ia0aHtrIMYg92iDODGc+4tIDESZ/SqUNajs4hjXMM+jVjgRxRkZkLfxyNjbT6Z7WZRD/ISRoKg=;7:C36lZH1Yyo7LZlFJRdnvX+B/kP8BsAAIgR3wy2F0VcwS7yOVzCqOm6mUWPHJFP9L9oE1jBU2l3pzcf9ox2cyzj0DnI648ua6bQF8LlMGaOww7acJsEBecHBfJw7ihulFvdY/QegP0r7eIW+Wp/GiOA==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT167;
x-ms-traffictypediagnostic: DB5EUR03HT167:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR03HT167;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR03HT167;
x-microsoft-antispam-message-info: Ct5aASBJO8M1Uok1YqikS+0WKnOmfi6t04nTMHrlJ5grVRZ0WI8Tx4cwyRbNdfaU
Content-Type: text/plain; charset="utf-8"
Content-ID: <04BA43E551041E45BFAF5F5579BCD83D@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 295e6c9f-3272-400f-eb90-08d6733d0c3d
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 18:38:55.0712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT167
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhpcyBhcHBlYXJzIHRvIHRyaWdnZXIgYSBmaXJtd2FyZSBidWcgYW5kIGNhdXNlcyBzZXZlcmUN
CnByb2JsZW1zIHdpdGggcnRsODcyM2FlIFBDSSBkZXZpY2VzLg0KDQpXaGVuIHRoZSBwb3dlciBz
YXZlIG1vZGUgaXMgYWN0aXZhdGVkIGZvciBsb25nZXIgcGVyaW9kcw0Kb2YgdGltZSB0aGUgZmly
bXdhcmUgc3RvcHMgdG8gcmVjZWl2ZSBhbnkgcGFja2V0cy4NCg0KVGhpcyBwcm9ibGVtIHdhcyBl
eHBvc2VkIGJ5IGNvbW1pdCA4NzNmZmUxNTRhZTAgKCJydGx3aWZpOg0KRml4IGxvZ2ljIGVycm9y
IGluIGVudGVyL2V4aXQgcG93ZXItc2F2ZSBtb2RlIikuDQoNClByZXZpb3VzbHkgdGhlIHBvd2Vy
IHNhdmUgbW9kZSB3YXMgb25seSBhY3RpdmUgcmFyZWx5IGFuZA0Kb25seSBmb3IgYSBzaG9ydCB0
aW1lIHNvIHRoYXQgdGhlIHByb2JsZW0gd2FzIG5vdCBub3RpY2VhYmxlLg0KDQpTaWduZWQtb2Zm
LWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVybmQuZWRsaW5nZXJAaG90bWFpbC5kZT4NCi0tLQ0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvc3cuYyB8IDggKysr
Ky0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3
MjNhZS9zdy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNh
ZS9zdy5jDQppbmRleCAwN2I4MjcwMGQxLi4zMTAzMTUxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9zdy5jDQorKysgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL3N3LmMNCkBAIC0yNjYsOCAr
MjY2LDggQEAgc3RhdGljIGJvb2wgaXNfZndfaGVhZGVyKHN0cnVjdCBydGx3aWZpX2Zpcm13YXJl
X2hlYWRlciAqaGRyKQ0KIHN0YXRpYyBzdHJ1Y3QgcnRsX21vZF9wYXJhbXMgcnRsODcyM2VfbW9k
X3BhcmFtcyA9IHsNCiAJLnN3X2NyeXB0byA9IGZhbHNlLA0KIAkuaW5hY3RpdmVwcyA9IHRydWUs
DQotCS5zd2N0cmxfbHBzID0gZmFsc2UsDQotCS5md2N0cmxfbHBzID0gdHJ1ZSwNCisJLnN3Y3Ry
bF9scHMgPSB0cnVlLA0KKwkuZndjdHJsX2xwcyA9IGZhbHNlLA0KIAkuYXNwbV9zdXBwb3J0ID0g
MSwNCiAJLmRlYnVnX2xldmVsID0gMCwNCiAJLmRlYnVnX21hc2sgPSAwLA0KQEAgLTM5NSw4ICsz
OTUsOCBAQCBzdGF0aWMgYm9vbCBpc19md19oZWFkZXIoc3RydWN0IHJ0bHdpZmlfZmlybXdhcmVf
aGVhZGVyICpoZHIpDQogCQkgICBib29sLCAwNDQ0KTsNCiBNT0RVTEVfUEFSTV9ERVNDKHN3ZW5j
LCAiU2V0IHRvIDEgZm9yIHNvZnR3YXJlIGNyeXB0byAoZGVmYXVsdCAwKVxuIik7DQogTU9EVUxF
X1BBUk1fREVTQyhpcHMsICJTZXQgdG8gMCB0byBub3QgdXNlIGxpbmsgcG93ZXIgc2F2ZSAoZGVm
YXVsdCAxKVxuIik7DQotTU9EVUxFX1BBUk1fREVTQyhzd2xwcywgIlNldCB0byAxIHRvIHVzZSBT
VyBjb250cm9sIHBvd2VyIHNhdmUgKGRlZmF1bHQgMClcbiIpOw0KLU1PRFVMRV9QQVJNX0RFU0Mo
ZndscHMsICJTZXQgdG8gMSB0byB1c2UgRlcgY29udHJvbCBwb3dlciBzYXZlIChkZWZhdWx0IDEp
XG4iKTsNCitNT0RVTEVfUEFSTV9ERVNDKHN3bHBzLCAiU2V0IHRvIDEgdG8gdXNlIFNXIGNvbnRy
b2wgcG93ZXIgc2F2ZSAoZGVmYXVsdCAxKVxuIik7DQorTU9EVUxFX1BBUk1fREVTQyhmd2xwcywg
IlNldCB0byAxIHRvIHVzZSBGVyBjb250cm9sIHBvd2VyIHNhdmUgKGRlZmF1bHQgMClcbiIpOw0K
IE1PRFVMRV9QQVJNX0RFU0MobXNpLCAiU2V0IHRvIDEgdG8gdXNlIE1TSSBpbnRlcnJ1cHRzIG1v
ZGUgKGRlZmF1bHQgMClcbiIpOw0KIE1PRFVMRV9QQVJNX0RFU0MoYXNwbSwgIlNldCB0byAxIHRv
IGVuYWJsZSBBU1BNIChkZWZhdWx0IDEpXG4iKTsNCiBNT0RVTEVfUEFSTV9ERVNDKGRlYnVnX2xl
dmVsLCAiU2V0IGRlYnVnIGxldmVsICgwLTUpIChkZWZhdWx0IDApIik7DQotLSANCjEuOS4xDQo=
