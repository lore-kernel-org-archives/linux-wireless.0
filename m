Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD40C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704A6208E3
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 12:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfADMst (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 07:48:49 -0500
Received: from mail-oln040092068015.outbound.protection.outlook.com ([40.92.68.15]:55616
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727419AbfADMsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 07:48:47 -0500
Received: from HE1EUR02FT009.eop-EUR02.prod.protection.outlook.com
 (10.152.10.58) by HE1EUR02HT037.eop-EUR02.prod.protection.outlook.com
 (10.152.11.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Fri, 4 Jan
 2019 12:48:43 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.10.52) by
 HE1EUR02FT009.mail.protection.outlook.com (10.152.10.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Fri, 4 Jan 2019 12:48:43 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.000; Fri, 4 Jan 2019
 12:48:43 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb for input
Thread-Topic: [PATCH 2/4] rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb for
 input
Thread-Index: AQHUpCvT1+c+2uBxmka7DY/xDmReoQ==
Date:   Fri, 4 Jan 2019 12:48:43 +0000
Message-ID: <DB7PR07MB5353656A6EDA15D210CE098FE48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0007.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::17) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:7FF6F95BF8F43FB88B0EE06F1F23CD96DE8568F90E766D091FAEE74595D553FE;UpperCasedChecksum:36EE204A8243400F94EDB64C8B3FE5235AD3139CAC65F09185BE5E1C9B00B346;SizeAsReceived:8760;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [8YhwiYg1Y1WTAJcZkKkGWKarkZ0Anyp7]
x-microsoft-original-message-id: <40ae95c0-f706-c32f-9790-7014302ac62c@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR02HT037;6:ytd0B6lm5dM99ou53zQ27eJiS95ab+FHFylIeleJ4HDI83l+Fthtun3b+U8xRMnuybkEdKkU1ln1Hw04I9QQOZsVrZXGdN0HQXIqO8natblsk+cRvc7AZ76CswbMgaPchjzzE0V6Pah1vN2UqT+1zhMPuD8kDjFHak+i1Ynx6m5JlSx1gJG2beZnMUOXEMnsWzj1Q7eND82R5OSENdLS6nB3w2s3hRRidBu+EBKg1DYJoSY72MU7wyt3fP+FQuSCn9iBmGQVzGE83rGe+bGKlwok2t73WIYu6XNtPsRfgzqSkIDVVcba6hYJeKUKgTxU92UxUN+err+C7A9IJ+3Q6cDF1Dt4pLnsQbgFE9nChscw9TFAJZ8pBv+u0t9ktX7PPJHkfkoIQdp0NA5tEoD82QgK+DzgdhmdDzhBWxb2zwt6yAHW1gR8ww6r6ew4GSKWpNez9JdiARHoNoh581w4Cg==;5:PoJ/Sm7dT53OhjbWteHTorlCUkmbiz2qsYu1fZ9TPmmIk2i06pdyLCr/s9oQNw6rlt5sutw24P2ZJ7qgWnH/pDvPx9HxN0kY/vDQKjBFsYjKyvLUZEqXsz68zaDf+xDcFtf316lPONnzekXj+GSeQtEmmqe44snBuo52++Egy+4=;7:3L0Ec6JBEQOEP5FgTCILX66b9pCS9kIwjJHmsZjeJaOWZ2JNup7IwRoXGnbE03GJfYuT17l/zU5m1B4byEkIpyOxKPiY2VRdUtkVNGLcQJ/cTufsepxSotmm13sy4xZI+YVdZYZSfXWuWvAh4TqQdw==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR02HT037;
x-ms-traffictypediagnostic: HE1EUR02HT037:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR02HT037;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR02HT037;
x-microsoft-antispam-message-info: gOq9NOHygEDB5ZIaEATJOFuxOQEdSyFyYsJ8I6VMAsLem0xKswXfhLGE3DMlJe/5
Content-Type: text/plain; charset="utf-8"
Content-ID: <4092DC23D88AEB4E9DEDD6032D2DE2FC@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: e949bbd2-4586-4505-8bc2-08d67242f5a3
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 12:48:42.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT037
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ICBnYWluIGNvbnRyb2wgd2hlbiBubyBiZWFjb24gd2FzIHJlY2VpdmVkIGluIHRoZSBjb25uZWN0
ZWQgc3RhdGUuDQoNClRoaXMgYXZvaWRzIHNwb3JhZGljICJDb25uZWN0aW9uIHRvIEFQIC4uLiBs
b3N0IiBlcnJvcnMuDQoNClNpZ25lZC1vZmYtYnk6IEJlcm5kIEVkbGluZ2VyIDxiZXJuZC5lZGxp
bmdlckBob3RtYWlsLmRlPg0KLS0tDQogIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9jb3JlLmMgICAgICAgICB8IDIgKysNCiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jIHwgOCArKysrKysrKw0KICAyIGZpbGVzIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9jb3JlLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvY29yZS5jDQppbmRleCA0YmY3OTY3Li5jZTIzMzM5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYw0KQEAgLTE5NTcsNSArMTk1Nyw3IEBAIHZvaWQg
cnRsX2RtX2RpZ2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjdXJfaWd2YWx1ZSkN
CiAgCWRtX2RpZ3RhYmxlLT5idDMwX2N1cl9pZ2kgPSAweDMyOw0KICAJZG1fZGlndGFibGUtPnBy
ZV9jY2tfcGRfc3RhdGUgPSBDQ0tfUERfU1RBR0VfTUFYOw0KICAJZG1fZGlndGFibGUtPmN1cl9j
Y2tfcGRfc3RhdGUgPSBDQ0tfUERfU1RBR0VfTE9XUlNTSTsNCisJZG1fZGlndGFibGUtPnByZV9j
Y2tfZmFfc3RhdGUgPSAwOw0KKwlkbV9kaWd0YWJsZS0+Y3VyX2Nja19mYV9zdGF0ZSA9IDA7DQog
IH0NCiAgRVhQT1JUX1NZTUJPTChydGxfZG1fZGlnaW5pdCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQppbmRleCA0MmE2ZmJh
Li45MDJiOTQ0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3J0bDg3MjNhZS9kbS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
bHdpZmkvcnRsODcyM2FlL2RtLmMNCkBAIC0xNTEsOCArMTUxLDE0IEBAIHN0YXRpYyB1OCBydGw4
NzIzZV9kbV9pbml0aWFsX2dhaW5fbWluX3B3ZGIoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQog
IHsNCiAgCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsNCiAgCXN0cnVj
dCBkaWdfdCAqZG1fZGlndGFibGUgPSAmcnRscHJpdi0+ZG1fZGlndGFibGU7DQorCXN0cnVjdCBy
dGxfbWFjICptYWMgPSBydGxfbWFjKHJ0bHByaXYpOw0KICAJbG9uZyByc3NpX3ZhbF9taW4gPSAw
Ow0KICANCisJaWYgKG1hYy0+bGlua19zdGF0ZSA9PSBNQUM4MDIxMV9MSU5LRUQgJiYNCisJICAg
IG1hYy0+b3Btb2RlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gJiYNCisJICAgIHJ0bHByaXYt
PmxpbmtfaW5mby5iY25fcnhfaW5wZXJpb2QgPT0gMCkNCisJCXJldHVybiAwOw0KKw0KICAJaWYg
KChkbV9kaWd0YWJsZS0+Y3VybXVsdGlzdGFfY3N0YXRlID09IERJR19NVUxUSVNUQV9DT05ORUNU
KSAmJg0KICAJICAgIChkbV9kaWd0YWJsZS0+Y3Vyc3RhX2NzdGF0ZSA9PSBESUdfU1RBX0NPTk5F
Q1QpKSB7DQogIAkJaWYgKHJ0bHByaXYtPmRtLmVudHJ5X21pbl91bmRlY19zbV9wd2RiICE9IDAp
DQpAQCAtNDE3LDYgKzQyMyw4IEBAIHN0YXRpYyB2b2lkIHJ0bDg3MjNlX2RtX2Nja19wYWNrZXRf
ZGV0ZWN0aW9uX3RocmVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAgCQl9IGVsc2Ugew0K
ICAJCQlydGxfc2V0X2JicmVnKGh3LCBSQ0NLMF9DQ0EsIE1BU0tCWVRFMiwgMHhjZCk7DQogIAkJ
CXJ0bF9zZXRfYmJyZWcoaHcsIFJDQ0swX1NZU1RFTSwgTUFTS0JZVEUxLCAweDQ3KTsNCisJCQlk
bV9kaWd0YWJsZS0+cHJlX2Nja19mYV9zdGF0ZSA9IDA7DQorCQkJZG1fZGlndGFibGUtPmN1cl9j
Y2tfZmFfc3RhdGUgPSAwOw0KICANCiAgCQl9DQogIAkJZG1fZGlndGFibGUtPnByZV9jY2tfcGRf
c3RhdGUgPSBkbV9kaWd0YWJsZS0+Y3VyX2Nja19wZF9zdGF0ZTsNCi0tIA0KMS45LjENCg==
