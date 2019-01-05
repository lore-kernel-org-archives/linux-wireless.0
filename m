Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A27C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D2C22300
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfAESjN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:39:13 -0500
Received: from mail-oln040092072058.outbound.protection.outlook.com ([40.92.72.58]:42976
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbfAESjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 13:39:11 -0500
Received: from DB5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (10.152.20.60) by DB5EUR03HT095.eop-EUR03.prod.protection.outlook.com
 (10.152.21.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Sat, 5 Jan
 2019 18:39:08 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.20.60) by
 DB5EUR03FT031.mail.protection.outlook.com (10.152.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Sat, 5 Jan 2019 18:39:08 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sat, 5 Jan 2019
 18:39:08 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] rtlwifi: rtl8723ae: Re-introduce
Thread-Topic: [PATCH v2 3/4] rtlwifi: rtl8723ae: Re-introduce
Thread-Index: AQHUpSXx1u4Unkx78EyFWoocfFUG9A==
Date:   Sat, 5 Jan 2019 18:39:08 +0000
Message-ID: <DB7PR07MB5353D0020ED1570F6E3FD957E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0007.eurprd03.prod.outlook.com (2603:10a6:20b::20)
 To DB7PR07MB5353.eurprd07.prod.outlook.com (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:C2D183642B7F702CDED4AB6AEE5275700AB74163CC56E03C6618B4A7974AAB63;UpperCasedChecksum:FBA69186EE839C9AC540186E7AC42364D9FE3473ABEF95C270822CCFDB4F0F4B;SizeAsReceived:8689;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Z9RHEA6ZkjcYruUzczWJ84Pgv1kK6z7v]
x-microsoft-original-message-id: <1d19b8cb-101d-f890-5d11-4366db570bdd@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR03HT095;6:lsKquh1MAC/UDRkp3E++Ei7/fmuNbiDMbfWMkUL3uH7fEdZ5DKtWXEGUy2ZRjsQSL2An+YEqT28w+L/50TD6QFumDZNMgdNOz2XqDdhetvI2P7MWjAMaTM3y/duEaH+ukjHzoslcHYF0SUfAUM3rHH9zF8AG8NHjI9o0ibOnkqSkzCrAfRRrQ5ZjPtH8wD3eB8s5qI/N7t1xwzcXaoVQPnsUzDEYVU61o0Cvoh7o9CSmVS8KEkMkpkV3N9uM05JOvqq4CmFS1eDzUCPpSUji8eUCEofLw3QaOlgObAc8sWyS4EUfeNj5QcoTQ38kijwiN4BtgKTmj+s3hEbyfbWVx9BdkVvvSBUWDZdeWKP5h2e3uS5EdpygwKd6zg9JYavkwGYXKzjpMG0+WI9MV4WIGJDk8aXUuNSNs/wQNP3mSZ1jY1o8foK2V+Iy397/ZaBjxrcBqBNvmvUeuOwjpRG/Cg==;5:StrJeGxXNwZeicsv1FI0XRTRNfssmG4nE0VFD2NvKf4XNKFUnS3mUR8H09DmkLidx2wgzeVRV8g6YB8AjI5sz/CK2hQsKn1n4kgC+Llm3CgjHR9u/rpm2WrSIGChdiIzImU5q40H5r+BET9jo/+L1TayQxd6ZRjvUigxKYcXCOA=;7:/hK/78UMAy33PNqxxpuh1cnqX8dnze7NVjVQSkiSsDrgg/XS3UDMSmHr4K/LTj9Ycv10S04DG4EKjX+NIgmaDnL84ogT+HYTvlEpgQe1MpkaSp9CbMSr28R6S8UOM2bZMCjkvTRmZOnTQlaVBhy1Iw==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT095;
x-ms-traffictypediagnostic: DB5EUR03HT095:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR03HT095;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR03HT095;
x-microsoft-antispam-message-info: luh7Ff3gQArb0LvVmGFd4T+T2jxKMRG+0NnjxAcZ8XyUus6SBTAGLc0/gsgsRFXi
Content-Type: text/plain; charset="utf-8"
Content-ID: <29264DE8DCCEBE4DB08B2C0FFB457276@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc55aa2-202e-4531-471a-08d6733d1392
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 18:39:07.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT095
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IHJ0bDg3MjNlX2RtX3JlZnJlc2hfcmF0ZV9hZGFwdGl2ZV9tYXNrDQoNClRoaXMgZnVuY3Rpb24g
d2FzIHByZXNlbnQgaW4gYSBwcmV2aW91cyB2ZXJzaW9uIG9mIHRoZSBjb2RlIGJhc2UsDQppdCB3
b3JrcyBqdXN0IGZpbmUgZm9yIG1lIC0tIGFzIGxvbmcgYXMgaXQgaXMgbm90IHVzaW5nIHN0YWxl
IGRhdGEuDQoNCkZpeGVkIGEgc3R5bGUgbml0IGluIHJ0bDg3MjNlX2RtX2luaXRfcmF0ZV9hZGFw
dGl2ZV9tYXNrLg0KDQpTaWduZWQtb2ZmLWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVybmQuZWRsaW5n
ZXJAaG90bWFpbC5kZT4NCi0tLQ0KIC4uLi9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0
bDg3MjNhZS9kbS5jICAgIHwgODcgKysrKysrKysrKysrKysrKysrKysrLQ0KIDEgZmlsZSBjaGFu
Z2VkLCA4NSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQppbmRleCA5MDJi
OTQ0Li5hY2ZkNTRjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL3J0bDg3MjNhZS9kbS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvcnRsODcyM2FlL2RtLmMNCkBAIC02NzMsNyArNjczLDcgQEAgdm9pZCBydGw4NzIz
ZV9kbV9jaGVja190eHBvd2VyX3RyYWNraW5nKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIHZv
aWQgcnRsODcyM2VfZG1faW5pdF9yYXRlX2FkYXB0aXZlX21hc2soc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcpDQogew0KIAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBydGxfcHJpdihodyk7DQot
CXN0cnVjdCByYXRlX2FkYXB0aXZlICpwX3JhID0gJihydGxwcml2LT5yYSk7DQorCXN0cnVjdCBy
YXRlX2FkYXB0aXZlICpwX3JhID0gJnJ0bHByaXYtPnJhOw0KIA0KIAlwX3JhLT5yYXRyX3N0YXRl
ID0gRE1fUkFUUl9TVEFfSU5JVDsNCiAJcF9yYS0+cHJlX3JhdHJfc3RhdGUgPSBETV9SQVRSX1NU
QV9JTklUOw0KQEAgLTY4NSw2ICs2ODUsODkgQEAgdm9pZCBydGw4NzIzZV9kbV9pbml0X3JhdGVf
YWRhcHRpdmVfbWFzayhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiANCiB9DQogDQordm9pZCBy
dGw4NzIzZV9kbV9yZWZyZXNoX3JhdGVfYWRhcHRpdmVfbWFzayhzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodykNCit7DQorCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsNCisJ
c3RydWN0IHJ0bF9oYWwgKnJ0bGhhbCA9IHJ0bF9oYWwocnRsX3ByaXYoaHcpKTsNCisJc3RydWN0
IHJ0bF9tYWMgKm1hYyA9IHJ0bF9tYWMocnRsX3ByaXYoaHcpKTsNCisJc3RydWN0IHJhdGVfYWRh
cHRpdmUgKnBfcmEgPSAmcnRscHJpdi0+cmE7DQorCXUzMiBsb3dfcnNzaXRocmVzaF9mb3JfcmEs
IGhpZ2hfcnNzaXRocmVzaF9mb3JfcmE7DQorCXN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEgPSBO
VUxMOw0KKw0KKwlpZiAoaXNfaGFsX3N0b3AocnRsaGFsKSkgew0KKwkJUlRfVFJBQ0UocnRscHJp
diwgQ09NUF9SQVRFLCBEQkdfTE9VRCwNCisJCQkgIiBkcml2ZXIgaXMgZ29pbmcgdG8gdW5sb2Fk
XG4iKTsNCisJCXJldHVybjsNCisJfQ0KKw0KKwlpZiAoIXJ0bHByaXYtPmRtLnVzZXJhbWFzaykg
ew0KKwkJUlRfVFJBQ0UocnRscHJpdiwgQ09NUF9SQVRFLCBEQkdfTE9VRCwNCisJCQkgIiBkcml2
ZXIgZG9lcyBub3QgY29udHJvbCByYXRlIGFkYXB0aXZlIG1hc2tcbiIpOw0KKwkJcmV0dXJuOw0K
Kwl9DQorDQorCWlmIChtYWMtPmxpbmtfc3RhdGUgPT0gTUFDODAyMTFfTElOS0VEICYmDQorCSAg
ICBtYWMtPm9wbW9kZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7DQorCQlzd2l0Y2ggKHBf
cmEtPnByZV9yYXRyX3N0YXRlKSB7DQorCQljYXNlIERNX1JBVFJfU1RBX0hJR0g6DQorCQkJaGln
aF9yc3NpdGhyZXNoX2Zvcl9yYSA9IDUwOw0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9yYSA9IDIw
Ow0KKwkJCWJyZWFrOw0KKwkJY2FzZSBETV9SQVRSX1NUQV9NSURETEU6DQorCQkJaGlnaF9yc3Np
dGhyZXNoX2Zvcl9yYSA9IDU1Ow0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9yYSA9IDIwOw0KKwkJ
CWJyZWFrOw0KKwkJY2FzZSBETV9SQVRSX1NUQV9MT1c6DQorCQkJaGlnaF9yc3NpdGhyZXNoX2Zv
cl9yYSA9IDYwOw0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9yYSA9IDI1Ow0KKwkJCWJyZWFrOw0K
KwkJZGVmYXVsdDoNCisJCQloaWdoX3Jzc2l0aHJlc2hfZm9yX3JhID0gNTA7DQorCQkJbG93X3Jz
c2l0aHJlc2hfZm9yX3JhID0gMjA7DQorCQkJYnJlYWs7DQorCQl9DQorDQorCQlpZiAocnRscHJp
di0+bGlua19pbmZvLmJjbl9yeF9pbnBlcmlvZCA9PSAwKQ0KKwkJCXN3aXRjaCAocF9yYS0+cHJl
X3JhdHJfc3RhdGUpIHsNCisJCQljYXNlIERNX1JBVFJfU1RBX0hJR0g6DQorCQkJZGVmYXVsdDoN
CisJCQkJcF9yYS0+cmF0cl9zdGF0ZSA9IERNX1JBVFJfU1RBX01JRERMRTsNCisJCQkJYnJlYWs7
DQorCQkJY2FzZSBETV9SQVRSX1NUQV9NSURETEU6DQorCQkJY2FzZSBETV9SQVRSX1NUQV9MT1c6
DQorCQkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRSX1NUQV9MT1c7DQorCQkJCWJyZWFrOw0K
KwkJCX0NCisJCWVsc2UgaWYgKHJ0bHByaXYtPmRtLnVuZGVjX3NtX3B3ZGIgPiBoaWdoX3Jzc2l0
aHJlc2hfZm9yX3JhKQ0KKwkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRSX1NUQV9ISUdIOw0K
KwkJZWxzZSBpZiAocnRscHJpdi0+ZG0udW5kZWNfc21fcHdkYiA+IGxvd19yc3NpdGhyZXNoX2Zv
cl9yYSkNCisJCQlwX3JhLT5yYXRyX3N0YXRlID0gRE1fUkFUUl9TVEFfTUlERExFOw0KKwkJZWxz
ZQ0KKwkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRSX1NUQV9MT1c7DQorDQorCQlpZiAocF9y
YS0+cHJlX3JhdHJfc3RhdGUgIT0gcF9yYS0+cmF0cl9zdGF0ZSkgew0KKwkJCVJUX1RSQUNFKHJ0
bHByaXYsIENPTVBfUkFURSwgREJHX0xPVUQsDQorCQkJCSAiUlNTSSA9ICVsZFxuIiwNCisJCQkJ
IHJ0bHByaXYtPmRtLnVuZGVjX3NtX3B3ZGIpOw0KKwkJCVJUX1RSQUNFKHJ0bHByaXYsIENPTVBf
UkFURSwgREJHX0xPVUQsDQorCQkJCSAiUlNTSV9MRVZFTCA9ICVkXG4iLCBwX3JhLT5yYXRyX3N0
YXRlKTsNCisJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX1JBVEUsIERCR19MT1VELA0KKwkJCQkg
IlByZVN0YXRlID0gJWQsIEN1clN0YXRlID0gJWRcbiIsDQorCQkJCSBwX3JhLT5wcmVfcmF0cl9z
dGF0ZSwgcF9yYS0+cmF0cl9zdGF0ZSk7DQorDQorCQkJcmN1X3JlYWRfbG9jaygpOw0KKwkJCXN0
YSA9IHJ0bF9maW5kX3N0YShodywgbWFjLT5ic3NpZCk7DQorCQkJaWYgKHN0YSkNCisJCQkJcnRs
cHJpdi0+Y2ZnLT5vcHMtPnVwZGF0ZV9yYXRlX3RibChodywgc3RhLA0KKwkJCQkJCQkgICBwX3Jh
LT5yYXRyX3N0YXRlLA0KKwkJCQkJCQkJICAgICAgdHJ1ZSk7DQorCQkJcmN1X3JlYWRfdW5sb2Nr
KCk7DQorDQorCQkJcF9yYS0+cHJlX3JhdHJfc3RhdGUgPSBwX3JhLT5yYXRyX3N0YXRlOw0KKwkJ
fQ0KKwl9DQorfQ0KKw0KIHZvaWQgcnRsODcyM2VfZG1fcmZfc2F2aW5nKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCB1OCBiZm9yY2VfaW5fbm9ybWFsKQ0KIHsNCiAJc3RydWN0IHJ0bF9wcml2ICpy
dGxwcml2ID0gcnRsX3ByaXYoaHcpOw0KQEAgLTgzNCw3ICs5MTcsNyBAQCB2b2lkIHJ0bDg3MjNl
X2RtX3dhdGNoZG9nKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIAkJcnRsODcyM2VfZG1fZHlu
YW1pY19iYl9wb3dlcnNhdmluZyhodyk7DQogCQlydGw4NzIzZV9kbV9keW5hbWljX3R4cG93ZXIo
aHcpOw0KIAkJcnRsODcyM2VfZG1fY2hlY2tfdHhwb3dlcl90cmFja2luZyhodyk7DQotCQkvKiBy
dGw5MmNfZG1fcmVmcmVzaF9yYXRlX2FkYXB0aXZlX21hc2soaHcpOyAqLw0KKwkJcnRsODcyM2Vf
ZG1fcmVmcmVzaF9yYXRlX2FkYXB0aXZlX21hc2soaHcpOw0KIAkJcnRsODcyM2VfZG1fYnRfY29l
eGlzdChodyk7DQogCQlydGw4NzIzZV9kbV9jaGVja19lZGNhX3R1cmJvKGh3KTsNCiAJfQ0KLS0g
DQoxLjkuMQ0K
