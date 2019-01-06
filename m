Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996C6C43387
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6454F222B1
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfAFACc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 19:02:32 -0500
Received: from mail-oln040092064070.outbound.protection.outlook.com ([40.92.64.70]:51264
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfAFACc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 19:02:32 -0500
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (10.152.0.55) by HE1EUR01HT069.eop-EUR01.prod.protection.outlook.com
 (10.152.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sun, 6 Jan
 2019 00:02:28 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sun, 6 Jan 2019 00:02:28 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sun, 6 Jan 2019
 00:02:28 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 2/4] rtl8723ae: Dont use old data for input gain control
Thread-Topic: [PATCH v3 2/4] rtl8723ae: Dont use old data for input gain
 control
Thread-Index: AQHUpVMclX/eeo4ws0GaQg3rMsPG2Q==
Date:   Sun, 6 Jan 2019 00:02:28 +0000
Message-ID: <DB7PR07MB5353629B3B7253EE129A85DCE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0010.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::23) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:CDBF9722D95F050B2011D2967DF567538F39DEFFFBFAC8EA57C8213EF08C0CF6;UpperCasedChecksum:B9B519704729FC20E1866FF6FB9CC148C3957D79B1CE353D905C698774844B40;SizeAsReceived:8783;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [PWlwFVUiSpt8yOB4yHpdJuWceFOPGbXL]
x-microsoft-original-message-id: <37150adc-d0d4-d543-b949-07c9d42448d0@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT069;6:sEQR97FnzIIia+5mMH5pzrecS4QjLhtClsumgmqO6K7WEBcvELZNfb4uY71GCj8km014MHiEGSd3P6gMgHwcOnK5IAQNew2K5oE0ImSpcSIbHeO0BgYNdbfP0QdOxsbgQ9M5zaxskf1IXyjmnwuM2Br/8YWJDh+HTQuNlGgoFRfrtrWqpatARC8NH+1W+bGud9OFu8DDHz0fsv72fQ3tYrhoKKYvuVDNVxxzQJaIdRexy7gl/BEE8kJfp0B5kyMcI0MpQ4RCBodhrtNTnCCJ4KYxD5aUW3AThL0xXuULKKWsG5raUzgTPXDUL2oMF0om8oW7Jjtn0YnFobYiLdVQ+/4oQ5g6DdJNywyqM8eFgByWdg/LA/iIm3MjSS/DrEn5eaCq0Z16eCfsu25qXpmWnX7P2URchU5X3GFygia+iwBWCi9FDCSLAKD8k6IMFIDb69cBBClh1EbY7EcnNq2Q1Q==;5:h5OOEV4BXKy2zPGFh7/KzpGyma+YtfPROSqJkKrCUNQtLnWUoMwdajl7aqyOQo8mG/FjGpfSDcMB+ulqfbEUHJpB0tsbNikNotijssfH15a2DI+sbKFfpkCWckyd1lLZKDAWuoqqBoRfKdpW/BuUOzpswO2MKlY786cFo0rUSkw=;7:DBa/6Pw3YUI6stvP0sbJx7ns7C0pKkuG1PZ7HJEFjBuXI3HzSjRIh2deB4LQLvPR9mBiKCYpcr/dJd9ZFoAJ4moa4TDbKWljcpBqCA+c9SYWv7F3jZ9FRgPC5S6SGbBEYRCGV9zlrZ+Tuq4McYOFWw==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT069;
x-ms-traffictypediagnostic: HE1EUR01HT069:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT069;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT069;
x-microsoft-antispam-message-info: wvbHOGd/WCAUYDK9kxg+oh61DP6v7J/KTNiGtFCmJIcWBSzMBdV1iDU0B3Sjb9/J
Content-Type: text/plain; charset="utf-8"
Content-ID: <C11E2E6799ABBF4C9BB4629DDF272B71@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbd1aae-4ca3-43d4-32eb-08d6736a3f32
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2019 00:02:27.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT069
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

V2hlbiBubyBiZWFjb24gd2FzIHJlY2VpdmVkLCB0aGUgdmFsdWUgaW4gZG0udW5kZWNfc21fcHdk
YiBpcyBtb3N0DQpsaWtlbHkgb3V0IG9mIGRhdGUgYW5kIHNob3VsZCBub3QgYmUgdXNlZCB0byBh
ZGp1c3QgdGhlIGlucHV0IHBhdGguDQpBc3N1bWUgaW5zdGVhZCB0aGF0IHRoZSBzaWduYWwgbGV2
ZWwgaXMgbG93Lg0KDQpGaXggdGhlIHN0YXRlIG1hY2hpbmUgaW4gcnRsODcyM2VfZG1fY2NrX3Bh
Y2tldF9kZXRlY3Rpb25fdGhyZXNoDQp3aGljaCBkaWQgbm90IGNsZWFyIHByZV9jY2tfZmFfc3Rh
dGUgd2hlbiBjaGFuZ2luZyBjdXJfY2NrX3BkX3N0YXRlDQpmcm9tIENDS19QRF9TVEFHRV9MT1dS
U1NJL0NDS19GQV9TVEFHRV9MT1cgdG8gQ0NLX1BEX1NUQUdFX0hJR0hSU1NJDQphbmQgYmFjayBh
Z2FpbiB0byBDQ0tfUERfU1RBR0VfTE9XUlNTSS9DQ0tfRkFfU1RBR0VfTE9XLCB0aGUgcmVnaXN0
ZXINClJDQ0swX0NDQSBub3Qgd3JpdHRlbiB0byAweDgzIG9uIHRoZSBzZWNvbmQgY2hhbmdlLg0K
DQpFeHBsaWNpdGx5IGluaXRpYWxpemUgcHJlX2Nja19mYV9zdGF0ZS9jdXJfY2NrX2ZhX3N0YXRl
IGluDQpydGxfZG1fZGlnaW5pdC4NCg0KU2lnbmVkLW9mZi1ieTogQmVybmQgRWRsaW5nZXIgPGJl
cm5kLmVkbGluZ2VyQGhvdG1haWwuZGU+DQotLS0NCnYyOiBJbXByb3ZlZCBwYXRjaCBkZXNjcmlw
dGlvbi4NCg0KdjM6IE1ha2UgdGhlIHRpdGxlIGZpdCBpbiBvbmUgbGluZS4NCi0tLQ0KIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMgICAgICAgICB8IDIgKysNCiBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMgfCA4ICsr
KysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvY29yZS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KaW5kZXggNGJmNzk2Ny4uY2UyMzMz
OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3Jl
LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9jb3JlLmMNCkBA
IC0xOTU3LDUgKzE5NTcsNyBAQCB2b2lkIHJ0bF9kbV9kaWdpbml0KHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCB1MzIgY3VyX2lndmFsdWUpDQogCWRtX2RpZ3RhYmxlLT5idDMwX2N1cl9pZ2kgPSAw
eDMyOw0KIAlkbV9kaWd0YWJsZS0+cHJlX2Nja19wZF9zdGF0ZSA9IENDS19QRF9TVEFHRV9NQVg7
DQogCWRtX2RpZ3RhYmxlLT5jdXJfY2NrX3BkX3N0YXRlID0gQ0NLX1BEX1NUQUdFX0xPV1JTU0k7
DQorCWRtX2RpZ3RhYmxlLT5wcmVfY2NrX2ZhX3N0YXRlID0gMDsNCisJZG1fZGlndGFibGUtPmN1
cl9jY2tfZmFfc3RhdGUgPSAwOw0KIH0NCiBFWFBPUlRfU1lNQk9MKHJ0bF9kbV9kaWdpbml0KTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcy
M2FlL2RtLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2Fl
L2RtLmMNCmluZGV4IDQyYTZmYmEuLjkwMmI5NDQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2RtLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvZG0uYw0KQEAgLTE1MSw4ICsxNTEs
MTQgQEAgc3RhdGljIHU4IHJ0bDg3MjNlX2RtX2luaXRpYWxfZ2Fpbl9taW5fcHdkYihzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodykNCiB7DQogCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9w
cml2KGh3KTsNCiAJc3RydWN0IGRpZ190ICpkbV9kaWd0YWJsZSA9ICZydGxwcml2LT5kbV9kaWd0
YWJsZTsNCisJc3RydWN0IHJ0bF9tYWMgKm1hYyA9IHJ0bF9tYWMocnRscHJpdik7DQogCWxvbmcg
cnNzaV92YWxfbWluID0gMDsNCiANCisJaWYgKG1hYy0+bGlua19zdGF0ZSA9PSBNQUM4MDIxMV9M
SU5LRUQgJiYNCisJICAgIG1hYy0+b3Btb2RlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gJiYN
CisJICAgIHJ0bHByaXYtPmxpbmtfaW5mby5iY25fcnhfaW5wZXJpb2QgPT0gMCkNCisJCXJldHVy
biAwOw0KKw0KIAlpZiAoKGRtX2RpZ3RhYmxlLT5jdXJtdWx0aXN0YV9jc3RhdGUgPT0gRElHX01V
TFRJU1RBX0NPTk5FQ1QpICYmDQogCSAgICAoZG1fZGlndGFibGUtPmN1cnN0YV9jc3RhdGUgPT0g
RElHX1NUQV9DT05ORUNUKSkgew0KIAkJaWYgKHJ0bHByaXYtPmRtLmVudHJ5X21pbl91bmRlY19z
bV9wd2RiICE9IDApDQpAQCAtNDE3LDYgKzQyMyw4IEBAIHN0YXRpYyB2b2lkIHJ0bDg3MjNlX2Rt
X2Nja19wYWNrZXRfZGV0ZWN0aW9uX3RocmVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAJ
CX0gZWxzZSB7DQogCQkJcnRsX3NldF9iYnJlZyhodywgUkNDSzBfQ0NBLCBNQVNLQllURTIsIDB4
Y2QpOw0KIAkJCXJ0bF9zZXRfYmJyZWcoaHcsIFJDQ0swX1NZU1RFTSwgTUFTS0JZVEUxLCAweDQ3
KTsNCisJCQlkbV9kaWd0YWJsZS0+cHJlX2Nja19mYV9zdGF0ZSA9IDA7DQorCQkJZG1fZGlndGFi
bGUtPmN1cl9jY2tfZmFfc3RhdGUgPSAwOw0KIA0KIAkJfQ0KIAkJZG1fZGlndGFibGUtPnByZV9j
Y2tfcGRfc3RhdGUgPSBkbV9kaWd0YWJsZS0+Y3VyX2Nja19wZF9zdGF0ZTsNCi0tIA0KMS45LjEN
Cg==
