Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFA1C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F24722300
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 18:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfAESjI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:39:08 -0500
Received: from mail-oln040092072053.outbound.protection.outlook.com ([40.92.72.53]:6315
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfAESjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 13:39:07 -0500
Received: from DB5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (10.152.20.54) by DB5EUR03HT112.eop-EUR03.prod.protection.outlook.com
 (10.152.21.11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Sat, 5 Jan
 2019 18:39:02 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.20.60) by
 DB5EUR03FT031.mail.protection.outlook.com (10.152.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Sat, 5 Jan 2019 18:39:02 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sat, 5 Jan 2019
 18:39:02 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb for
 input
Thread-Topic: [PATCH v2 2/4] rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb
 for input
Thread-Index: AQHUpSXugKolGutiDEibxUg5fF7dbw==
Date:   Sat, 5 Jan 2019 18:39:02 +0000
Message-ID: <DB7PR07MB5353A56F7F5BD0EEC355346FE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0025.eurprd03.prod.outlook.com (2603:10a6:20b::38)
 To DB7PR07MB5353.eurprd07.prod.outlook.com (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:8DCC18BBB01028A8C8DB887D3815187C8CA74CFE7E7DB92D287B056F2382039F;UpperCasedChecksum:5655DB5B178821A1C2D5AD2527D69720EA654A048E78C7F915ECA2381F5419A5;SizeAsReceived:8750;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [4ogDYkyruHjgs9cmE5KcQiDbBfq8YlXe]
x-microsoft-original-message-id: <fe46c710-9843-5107-ba63-810c487d40b4@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR03HT112;6:/1kvWIH4zhpm2Lg3N8b7k2ZrnJpI3kjKpHloRktgKQ2IOx3zzDZnD1sdDgzuhvBcmVD0lVLZAkvgO3MAjIZxBvbv12vyS1UFryCd8MZgGwRMQfJF+LzJABQ/NT7aB4rQlyapdG0ALJigZJGbbeyNpbrPtADBfPrgs8q3DKXktRgqBU94ug5oS1u/j7km9lY/azhp3/ckzxgx2NybmvmS/iY8NMHJqUuH7gdMiflpi1637anLq1awNBcL/kw/ZKFHTc0D99AN/9OUbN+wqwJJJMk5BHLNSve1ZogEhRiZaWwf9Ip5wn8Y3OsiKvevIMkWgqBJgmBlWmHVGeiVPm3RGX5jnsyqep+9hX60YzwxXhkBLRz1iVIVCHvTSzKIImiKzQnOUtfRlUjpGWebAIXDQ5sN3JhMNySgr84C6nW67pEXc71Bm+YlWxT9CBCMuwJF9PR2T0fO/mlUqrfFy7dp1A==;5:koTx9zvscEWr5NFJ4FX2U5AV5GOfOyXCyNKUnq1CEfpKpZ45tKnN7dVME+c8MHjr6llKwVQRqsAqVV+GBfzs+HCHxQCM3U+WjFBkkIRp7/iFM8jabjiHgzeVnXEVmA4M3Uow/UkJWuXUAcGHQlNqHmww5a2j9xCv7Pei3wyKCYU=;7:Kg/n8TjgQwfselYo+nQXYORegmU96BRE1cb+2pbD0e5+F4ZvHo4yg7R4sVJXKW2GDASbAwOcWaD+S1NcfjYdhdFls3tpRN+UHepPWGJCzQ7nnwT/yBSXoapQrJ6tSXj8FNX3i7xRKSDwVGB+N+nREg==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:DB5EUR03HT112;
x-ms-traffictypediagnostic: DB5EUR03HT112:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR03HT112;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR03HT112;
x-microsoft-antispam-message-info: yktzmq+m/mXsGhK7iwaJIx3Lx0P5vGih5JqzKBY172Qrmfe9WA8dqpcQ98AaAl0A
Content-Type: text/plain; charset="utf-8"
Content-ID: <4808AEE77A57DF41B9D9766567FE9B1D@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5d2588-40ac-46c7-9305-08d6733d1073
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 18:39:02.0087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT112
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IGdhaW4gY29udHJvbCB3aGVuIG5vIGJlYWNvbiB3YXMgcmVjZWl2ZWQgaW4gdGhlIGNvbm5lY3Rl
ZCBzdGF0ZQ0KDQpXaGVuIG5vIGJlYWNvbiB3YXMgcmVjZWl2ZWQsIHRoZSB2YWx1ZSBpbiBkbS51
bmRlY19zbV9wd2RiIGlzIG1vc3QNCmxpa2VseSBvdXQgb2YgZGF0ZSBhbmQgc2hvdWxkIG5vdCBi
ZSB1c2VkIHRvIGFkanVzdCB0aGUgaW5wdXQgcGF0aC4NCkFzc3VtZSBpbnN0ZWFkIHRoYXQgdGhl
IHNpZ25hbCBsZXZlbCBpcyBsb3cuDQoNCkZpeCB0aGUgc3RhdGUgbWFjaGluZSBpbiBydGw4NzIz
ZV9kbV9jY2tfcGFja2V0X2RldGVjdGlvbl90aHJlc2gNCndoaWNoIGRpZCBub3QgY2xlYXIgcHJl
X2Nja19mYV9zdGF0ZSB3aGVuIGNoYW5naW5nIGN1cl9jY2tfcGRfc3RhdGUNCmZyb20gQ0NLX1BE
X1NUQUdFX0xPV1JTU0kvQ0NLX0ZBX1NUQUdFX0xPVyB0byBDQ0tfUERfU1RBR0VfSElHSFJTU0kN
CmFuZCBiYWNrIGFnYWluIHRvIENDS19QRF9TVEFHRV9MT1dSU1NJL0NDS19GQV9TVEFHRV9MT1cs
IHRoZSByZWdpc3Rlcg0KUkNDSzBfQ0NBIG5vdCB3cml0dGVuIHRvIDB4ODMgb24gdGhlIHNlY29u
ZCBjaGFuZ2UuDQoNCkV4cGxpY2l0bHkgaW5pdGlhbGl6ZSBwcmVfY2NrX2ZhX3N0YXRlL2N1cl9j
Y2tfZmFfc3RhdGUgaW4NCnJ0bF9kbV9kaWdpbml0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCZXJuZCBF
ZGxpbmdlciA8YmVybmQuZWRsaW5nZXJAaG90bWFpbC5kZT4NCi0tLQ0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMgICAgICAgICB8IDIgKysNCiBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMgfCA4ICsrKysrKysrDQog
MiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KaW5kZXggNGJmNzk2Ny4uY2UyMzMzOSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCisrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCkBAIC0xOTU3LDUg
KzE5NTcsNyBAQCB2b2lkIHJ0bF9kbV9kaWdpbml0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1
MzIgY3VyX2lndmFsdWUpDQogCWRtX2RpZ3RhYmxlLT5idDMwX2N1cl9pZ2kgPSAweDMyOw0KIAlk
bV9kaWd0YWJsZS0+cHJlX2Nja19wZF9zdGF0ZSA9IENDS19QRF9TVEFHRV9NQVg7DQogCWRtX2Rp
Z3RhYmxlLT5jdXJfY2NrX3BkX3N0YXRlID0gQ0NLX1BEX1NUQUdFX0xPV1JTU0k7DQorCWRtX2Rp
Z3RhYmxlLT5wcmVfY2NrX2ZhX3N0YXRlID0gMDsNCisJZG1fZGlndGFibGUtPmN1cl9jY2tfZmFf
c3RhdGUgPSAwOw0KIH0NCiBFWFBPUlRfU1lNQk9MKHJ0bF9kbV9kaWdpbml0KTsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMNCmlu
ZGV4IDQyYTZmYmEuLjkwMmI5NDQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvZG0uYw0KQEAgLTE1MSw4ICsxNTEsMTQgQEAgc3Rh
dGljIHU4IHJ0bDg3MjNlX2RtX2luaXRpYWxfZ2Fpbl9taW5fcHdkYihzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodykNCiB7DQogCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsN
CiAJc3RydWN0IGRpZ190ICpkbV9kaWd0YWJsZSA9ICZydGxwcml2LT5kbV9kaWd0YWJsZTsNCisJ
c3RydWN0IHJ0bF9tYWMgKm1hYyA9IHJ0bF9tYWMocnRscHJpdik7DQogCWxvbmcgcnNzaV92YWxf
bWluID0gMDsNCiANCisJaWYgKG1hYy0+bGlua19zdGF0ZSA9PSBNQUM4MDIxMV9MSU5LRUQgJiYN
CisJICAgIG1hYy0+b3Btb2RlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gJiYNCisJICAgIHJ0
bHByaXYtPmxpbmtfaW5mby5iY25fcnhfaW5wZXJpb2QgPT0gMCkNCisJCXJldHVybiAwOw0KKw0K
IAlpZiAoKGRtX2RpZ3RhYmxlLT5jdXJtdWx0aXN0YV9jc3RhdGUgPT0gRElHX01VTFRJU1RBX0NP
Tk5FQ1QpICYmDQogCSAgICAoZG1fZGlndGFibGUtPmN1cnN0YV9jc3RhdGUgPT0gRElHX1NUQV9D
T05ORUNUKSkgew0KIAkJaWYgKHJ0bHByaXYtPmRtLmVudHJ5X21pbl91bmRlY19zbV9wd2RiICE9
IDApDQpAQCAtNDE3LDYgKzQyMyw4IEBAIHN0YXRpYyB2b2lkIHJ0bDg3MjNlX2RtX2Nja19wYWNr
ZXRfZGV0ZWN0aW9uX3RocmVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAJCX0gZWxzZSB7
DQogCQkJcnRsX3NldF9iYnJlZyhodywgUkNDSzBfQ0NBLCBNQVNLQllURTIsIDB4Y2QpOw0KIAkJ
CXJ0bF9zZXRfYmJyZWcoaHcsIFJDQ0swX1NZU1RFTSwgTUFTS0JZVEUxLCAweDQ3KTsNCisJCQlk
bV9kaWd0YWJsZS0+cHJlX2Nja19mYV9zdGF0ZSA9IDA7DQorCQkJZG1fZGlndGFibGUtPmN1cl9j
Y2tfZmFfc3RhdGUgPSAwOw0KIA0KIAkJfQ0KIAkJZG1fZGlndGFibGUtPnByZV9jY2tfcGRfc3Rh
dGUgPSBkbV9kaWd0YWJsZS0+Y3VyX2Nja19wZF9zdGF0ZTsNCi0tIA0KMS45LjENCg==
