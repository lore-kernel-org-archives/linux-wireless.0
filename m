Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D505C43612
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE22E208E3
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfADMsz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:48:55 -0500
Received: from mail-oln040092068057.outbound.protection.outlook.com ([40.92.68.57]:23199
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727609AbfADMsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 07:48:54 -0500
Received: from HE1EUR02FT009.eop-EUR02.prod.protection.outlook.com
 (10.152.10.52) by HE1EUR02HT213.eop-EUR02.prod.protection.outlook.com
 (10.152.10.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Fri, 4 Jan
 2019 12:48:49 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.10.52) by
 HE1EUR02FT009.mail.protection.outlook.com (10.152.10.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Fri, 4 Jan 2019 12:48:49 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.000; Fri, 4 Jan 2019
 12:48:49 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] rtlwifi: rtl8723ae: Re-introduce
Thread-Topic: [PATCH 3/4] rtlwifi: rtl8723ae: Re-introduce
Thread-Index: AQHUpCvWT8DRnoOfM0CRszihJH29JQ==
Date:   Fri, 4 Jan 2019 12:48:49 +0000
Message-ID: <DB7PR07MB5353062DF0C20ED44D8456E9E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0013.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::23) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:9474B23F583E25E7959C1C8096CEEA2B412F78BA1A60E1FE9A4A3FBAB225220D;UpperCasedChecksum:3FF472842AE3ECDE5F7E2D003490E917DECE08477FE46DB17321900323BA6176;SizeAsReceived:8719;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [O7Cy9wEpT/elZd5WiDEL/Gp/jVUh1not]
x-microsoft-original-message-id: <13ef8d5e-cd1b-6c99-3314-61daf0b71c2b@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR02HT213;6:jaK26lQP/GpJq/ALVGZYCIJVqo4Oj2DNqWHpY2U1TDPlCkqvkUpxkXZn9SiLO7Dm46lFmRfCuDlVrKNPPwRC9o4NcpGhN2NRGjMy1MaCdBWBkOc4bdMYkV17nos2zfU8NAUKTpjMcuhy4wc+glaGwXvP2Hj3wly7VYf5sC1jb5Nbs62mOWRQYF9yDG4U0baTxctNdQuWYqEkx/8snG7asEMuxSzqRKDvxdY7xM0J+3iGklZMY8Ry351s9hVqq4MzuoGORHfwU9BW12aOu1ov7tyigjBl4p9UnqS6XX30o/2DBMmirZXn1RsE/E3bsYvuMuKe4Jtnv3HAnAGYCx4vHSlG52S+PCmostaqlILEzF/NGInB+MFwn71gyaSjzZ4ZFXtcSGVZ51T/gjWE1LzFtHGljcuVcPvht/PSg+IP9xNlp/Q4J4vfhfCmy9LgLVz/zv7aRVEL+wIIIoWPYI3S5A==;5:OgmgdKqu//BQ35Ekao7fQ04HwRNha6gqt6I/NaEGGEZ55VY59U/G/6UAY3BgY+JS9sNHVYPxpkdTsZf/rQYWHM/Jjf6vofT7f1p4GITxGluDxBuU1lS7JlD7pKkxiT4oMfbBK4fb8lxDg9P0rybya03bzMoBSExWXNp89WNqeCk=;7:1rf0n8BsC5s0oUDUCtYOj8J5nEMMyQZh++6hkFjhsjjyu5dfI2eyrp5Zgs9pQbHzWKrRIJhE+pr8YkC6IZyanQWIQcULbBpwWkGI5V9JPAmwrjoe3Rl59UFoiYfarTJ/E2Fei8Gl721ikK+eUkXB3A==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR02HT213;
x-ms-traffictypediagnostic: HE1EUR02HT213:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR02HT213;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR02HT213;
x-microsoft-antispam-message-info: OSg8NWfaut9OuyJusqKxGzzZrO1yEngao0QibDXJtnWrTQK3eN72gVHYPdsoSINM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDB2C611C5202A4A84E77826B9999503@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbd7e98-5679-4dc4-ca94-08d67242f8ea
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 12:48:48.4048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT213
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ICBydGw4NzIzZV9kbV9yZWZyZXNoX3JhdGVfYWRhcHRpdmVfbWFzaw0KDQpUaGlzIGZ1bmN0aW9u
IHdhcyBwcmVzZW50IGluIGEgcHJldmlvdXMgdmVyc2lvbiBvZiB0aGUgY29kZSBiYXNlLA0KaXQg
d29ya3MganVzdCBmaW5lIGZvciBtZSAtLSBhcyBsb25nIGFzIGl0IGlzIG5vdCB1c2luZyBzdGFs
ZSBkYXRhLg0KDQpGaXhlZCBhIHN0eWxlIG5pdCBpbiBydGw4NzIzZV9kbV9pbml0X3JhdGVfYWRh
cHRpdmVfbWFzay4NCg0KU2lnbmVkLW9mZi1ieTogQmVybmQgRWRsaW5nZXIgPGJlcm5kLmVkbGlu
Z2VyQGhvdG1haWwuZGU+DQotLS0NCiAgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkv
cnRsODcyM2FlL2RtLmMgICAgfCA4NyArKysrKysrKysrKysrKysrKysrKystDQogIDEgZmlsZSBj
aGFuZ2VkLCA4NSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQppbmRleCA5
MDJiOTQ0Li5hY2ZkNTRjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMNCkBAIC02NzMsNyArNjczLDcgQEAgdm9pZCBydGw4
NzIzZV9kbV9jaGVja190eHBvd2VyX3RyYWNraW5nKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0K
ICB2b2lkIHJ0bDg3MjNlX2RtX2luaXRfcmF0ZV9hZGFwdGl2ZV9tYXNrKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3KQ0KICB7DQogIAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBydGxfcHJpdiho
dyk7DQotCXN0cnVjdCByYXRlX2FkYXB0aXZlICpwX3JhID0gJihydGxwcml2LT5yYSk7DQorCXN0
cnVjdCByYXRlX2FkYXB0aXZlICpwX3JhID0gJnJ0bHByaXYtPnJhOw0KICANCiAgCXBfcmEtPnJh
dHJfc3RhdGUgPSBETV9SQVRSX1NUQV9JTklUOw0KICAJcF9yYS0+cHJlX3JhdHJfc3RhdGUgPSBE
TV9SQVRSX1NUQV9JTklUOw0KQEAgLTY4NSw2ICs2ODUsODkgQEAgdm9pZCBydGw4NzIzZV9kbV9p
bml0X3JhdGVfYWRhcHRpdmVfbWFzayhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAgDQogIH0N
CiAgDQordm9pZCBydGw4NzIzZV9kbV9yZWZyZXNoX3JhdGVfYWRhcHRpdmVfbWFzayhzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodykNCit7DQorCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9w
cml2KGh3KTsNCisJc3RydWN0IHJ0bF9oYWwgKnJ0bGhhbCA9IHJ0bF9oYWwocnRsX3ByaXYoaHcp
KTsNCisJc3RydWN0IHJ0bF9tYWMgKm1hYyA9IHJ0bF9tYWMocnRsX3ByaXYoaHcpKTsNCisJc3Ry
dWN0IHJhdGVfYWRhcHRpdmUgKnBfcmEgPSAmcnRscHJpdi0+cmE7DQorCXUzMiBsb3dfcnNzaXRo
cmVzaF9mb3JfcmEsIGhpZ2hfcnNzaXRocmVzaF9mb3JfcmE7DQorCXN0cnVjdCBpZWVlODAyMTFf
c3RhICpzdGEgPSBOVUxMOw0KKw0KKwlpZiAoaXNfaGFsX3N0b3AocnRsaGFsKSkgew0KKwkJUlRf
VFJBQ0UocnRscHJpdiwgQ09NUF9SQVRFLCBEQkdfTE9VRCwNCisJCQkgIiBkcml2ZXIgaXMgZ29p
bmcgdG8gdW5sb2FkXG4iKTsNCisJCXJldHVybjsNCisJfQ0KKw0KKwlpZiAoIXJ0bHByaXYtPmRt
LnVzZXJhbWFzaykgew0KKwkJUlRfVFJBQ0UocnRscHJpdiwgQ09NUF9SQVRFLCBEQkdfTE9VRCwN
CisJCQkgIiBkcml2ZXIgZG9lcyBub3QgY29udHJvbCByYXRlIGFkYXB0aXZlIG1hc2tcbiIpOw0K
KwkJcmV0dXJuOw0KKwl9DQorDQorCWlmIChtYWMtPmxpbmtfc3RhdGUgPT0gTUFDODAyMTFfTElO
S0VEICYmDQorCSAgICBtYWMtPm9wbW9kZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7DQor
CQlzd2l0Y2ggKHBfcmEtPnByZV9yYXRyX3N0YXRlKSB7DQorCQljYXNlIERNX1JBVFJfU1RBX0hJ
R0g6DQorCQkJaGlnaF9yc3NpdGhyZXNoX2Zvcl9yYSA9IDUwOw0KKwkJCWxvd19yc3NpdGhyZXNo
X2Zvcl9yYSA9IDIwOw0KKwkJCWJyZWFrOw0KKwkJY2FzZSBETV9SQVRSX1NUQV9NSURETEU6DQor
CQkJaGlnaF9yc3NpdGhyZXNoX2Zvcl9yYSA9IDU1Ow0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9y
YSA9IDIwOw0KKwkJCWJyZWFrOw0KKwkJY2FzZSBETV9SQVRSX1NUQV9MT1c6DQorCQkJaGlnaF9y
c3NpdGhyZXNoX2Zvcl9yYSA9IDYwOw0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9yYSA9IDI1Ow0K
KwkJCWJyZWFrOw0KKwkJZGVmYXVsdDoNCisJCQloaWdoX3Jzc2l0aHJlc2hfZm9yX3JhID0gNTA7
DQorCQkJbG93X3Jzc2l0aHJlc2hfZm9yX3JhID0gMjA7DQorCQkJYnJlYWs7DQorCQl9DQorDQor
CQlpZiAocnRscHJpdi0+bGlua19pbmZvLmJjbl9yeF9pbnBlcmlvZCA9PSAwKQ0KKwkJCXN3aXRj
aCAocF9yYS0+cHJlX3JhdHJfc3RhdGUpIHsNCisJCQljYXNlIERNX1JBVFJfU1RBX0hJR0g6DQor
CQkJZGVmYXVsdDoNCisJCQkJcF9yYS0+cmF0cl9zdGF0ZSA9IERNX1JBVFJfU1RBX01JRERMRTsN
CisJCQkJYnJlYWs7DQorCQkJY2FzZSBETV9SQVRSX1NUQV9NSURETEU6DQorCQkJY2FzZSBETV9S
QVRSX1NUQV9MT1c6DQorCQkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRSX1NUQV9MT1c7DQor
CQkJCWJyZWFrOw0KKwkJCX0NCisJCWVsc2UgaWYgKHJ0bHByaXYtPmRtLnVuZGVjX3NtX3B3ZGIg
PiBoaWdoX3Jzc2l0aHJlc2hfZm9yX3JhKQ0KKwkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRS
X1NUQV9ISUdIOw0KKwkJZWxzZSBpZiAocnRscHJpdi0+ZG0udW5kZWNfc21fcHdkYiA+IGxvd19y
c3NpdGhyZXNoX2Zvcl9yYSkNCisJCQlwX3JhLT5yYXRyX3N0YXRlID0gRE1fUkFUUl9TVEFfTUlE
RExFOw0KKwkJZWxzZQ0KKwkJCXBfcmEtPnJhdHJfc3RhdGUgPSBETV9SQVRSX1NUQV9MT1c7DQor
DQorCQlpZiAocF9yYS0+cHJlX3JhdHJfc3RhdGUgIT0gcF9yYS0+cmF0cl9zdGF0ZSkgew0KKwkJ
CVJUX1RSQUNFKHJ0bHByaXYsIENPTVBfUkFURSwgREJHX0xPVUQsDQorCQkJCSAiUlNTSSA9ICVs
ZFxuIiwNCisJCQkJIHJ0bHByaXYtPmRtLnVuZGVjX3NtX3B3ZGIpOw0KKwkJCVJUX1RSQUNFKHJ0
bHByaXYsIENPTVBfUkFURSwgREJHX0xPVUQsDQorCQkJCSAiUlNTSV9MRVZFTCA9ICVkXG4iLCBw
X3JhLT5yYXRyX3N0YXRlKTsNCisJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX1JBVEUsIERCR19M
T1VELA0KKwkJCQkgIlByZVN0YXRlID0gJWQsIEN1clN0YXRlID0gJWRcbiIsDQorCQkJCSBwX3Jh
LT5wcmVfcmF0cl9zdGF0ZSwgcF9yYS0+cmF0cl9zdGF0ZSk7DQorDQorCQkJcmN1X3JlYWRfbG9j
aygpOw0KKwkJCXN0YSA9IHJ0bF9maW5kX3N0YShodywgbWFjLT5ic3NpZCk7DQorCQkJaWYgKHN0
YSkNCisJCQkJcnRscHJpdi0+Y2ZnLT5vcHMtPnVwZGF0ZV9yYXRlX3RibChodywgc3RhLA0KKwkJ
CQkJCQkgICBwX3JhLT5yYXRyX3N0YXRlLA0KKwkJCQkJCQkJICAgICAgdHJ1ZSk7DQorCQkJcmN1
X3JlYWRfdW5sb2NrKCk7DQorDQorCQkJcF9yYS0+cHJlX3JhdHJfc3RhdGUgPSBwX3JhLT5yYXRy
X3N0YXRlOw0KKwkJfQ0KKwl9DQorfQ0KKw0KICB2b2lkIHJ0bDg3MjNlX2RtX3JmX3NhdmluZyhz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTggYmZvcmNlX2luX25vcm1hbCkNCiAgew0KICAJc3Ry
dWN0IHJ0bF9wcml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOw0KQEAgLTgzNCw3ICs5MTcsNyBA
QCB2b2lkIHJ0bDg3MjNlX2RtX3dhdGNoZG9nKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KICAJ
CXJ0bDg3MjNlX2RtX2R5bmFtaWNfYmJfcG93ZXJzYXZpbmcoaHcpOw0KICAJCXJ0bDg3MjNlX2Rt
X2R5bmFtaWNfdHhwb3dlcihodyk7DQogIAkJcnRsODcyM2VfZG1fY2hlY2tfdHhwb3dlcl90cmFj
a2luZyhodyk7DQotCQkvKiBydGw5MmNfZG1fcmVmcmVzaF9yYXRlX2FkYXB0aXZlX21hc2soaHcp
OyAqLw0KKwkJcnRsODcyM2VfZG1fcmVmcmVzaF9yYXRlX2FkYXB0aXZlX21hc2soaHcpOw0KICAJ
CXJ0bDg3MjNlX2RtX2J0X2NvZXhpc3QoaHcpOw0KICAJCXJ0bDg3MjNlX2RtX2NoZWNrX2VkY2Ff
dHVyYm8oaHcpOw0KICAJfQ0KLS0gDQoxLjkuMQ0K
