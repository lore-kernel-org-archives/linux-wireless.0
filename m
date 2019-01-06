Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14787C43444
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D5B222B5
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfAFACV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 19:02:21 -0500
Received: from mail-oln040092065018.outbound.protection.outlook.com ([40.92.65.18]:6316
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfAFACV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 19:02:21 -0500
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (10.152.0.53) by HE1EUR01HT086.eop-EUR01.prod.protection.outlook.com
 (10.152.1.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sun, 6 Jan
 2019 00:02:18 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sun, 6 Jan 2019 00:02:18 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sun, 6 Jan 2019
 00:02:18 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Topic: [PATCH v3 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Index: AQHUpVMW1dQwmrtP7EOElJ7UgzyQKg==
Date:   Sun, 6 Jan 2019 00:02:18 +0000
Message-ID: <DB7PR07MB535316A20C8447096DBC822DE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::36) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:7434CD7A7CBDF37EA75775B21C64AF86C4E0027572DABBD425845E654302B87B;UpperCasedChecksum:E11E6CAA021AADF9EAE791181A4E67B86955EA041951C5B437D2941725462D94;SizeAsReceived:8745;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Jpt4U8OvZLIkbVR/1i9d496jGx1/qWYN]
x-microsoft-original-message-id: <aa0bddb3-99bb-b0cf-b79e-16eeef1395fa@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT086;6:fgy8urWg2oRDZfDbOKKTAZX91U0O351eY7iT1bZd7k4/Ki7L1cH4Yc7PB9ATVPx+CA66ZaBM5wa04mETF/cMvtrMeuKejEp+a0Fphnl0/ovZNKzsD3SHPOA1qAgTgp+AT+GzzlyfV6g7fG8mIDvh/+b0XztJL0S6oycu83eoJqUvounFwJS+LHwOFnoTfj8zN0KPk0QMeqQc4kLDXC7VZO8ul9gCY36X2JSIoncHdNIuI4vanHdQZWdohj5ZOBVXZZpAtxAeWwY+V/t6zLqEn6qHW6snbDczyQm6Ta+EqYMEjy5WMOuR0iXxY3GgyrGqW5JZuNXI9NM9W9wuP0B2yoptcyBMk4RGq3zW1i8VyDjjW7So+5FIP+kdYIvR/K9jGbKZ8/FbcXPCxxRVEQCH5H0/cwZvebukD5b7cp9Z/XsOrl7N1XVFrNXZ2jt9/zci9i57Ya7E86T+L1xTvX/SNA==;5:2vf/qXrW8VT8GKKAsFQcjYQP3c/Wg+SqQZTCJVxTpwch6733qdENDs/l1xM1G5gkfhNx3Bf7azBPtBfSNu1IdIKlP5PEMepsFANY5PGU1pBkAZEU/xH8fj4LVJSSR2JEzWbvcp8OR7u9qSxheM+QZ8MR36l6JLbIFeEX08D8Nx4=;7:KuJyP+OWmZUNehoSxBKOOOOKvTf+qpj4ipFSrP0aMDDBVCYvlMuPaSBAD+h/xoKFVWYnwCDBY0mC9GO2UrdGBlSB7mxzQUzcU0j0xy07fPNodHY4Ixln+jaR+LO9fxy+trhDAiqKCcrci1w2BMSUFg==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT086;
x-ms-traffictypediagnostic: HE1EUR01HT086:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT086;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT086;
x-microsoft-antispam-message-info: Zw6Flr9qXOa4V4bNDmNKavRpMS4+zcrVadlLyZTQ1GaY+QTXierz6/U3p6VZ4oAP
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DA994C4C2184140A706F188E9BA2980@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b478c00-df2e-490f-d7c1-08d6736a38e8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2019 00:02:17.4108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT086
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
LWJ5OiBCZXJuZCBFZGxpbmdlciA8YmVybmQuZWRsaW5nZXJAaG90bWFpbC5kZT4NCi0tLQ0KdjI6
IEFkanVzdCB0aGUgZGVmYXVsdHMgb2Ygc3dscHMgYW5kIGZ3bHBzIG1vZHVsZQ0KcGFyYW1ldGVy
cyB0byBtYXRjaCB0aGUgZmlybXdhcmUgY2FwYWJpbGl0aWVzIGluc3RlYWQgb2YgcmVtb3ZpbmcN
CnRoZSB3aG9sZSBjb2RlLCBzbyBpdCBjYW4gYmUgZWFzaWx5IHJlLWFjdGl2YXRlZCBvbmNlIGEg
ZmlybXdhcmUNCnVwZGF0ZSBpcyBhdmFpbGFibGUuDQoNCnYzOiBNYWtlIHRoZSB0aXRsZSBmaXQg
aW4gb25lIGxpbmUuDQotLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkv
cnRsODcyM2FlL3N3LmMgfCA4ICsrKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvc3cuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvc3cuYw0KaW5kZXggMDdiODI3MDBkMS4uMzEwMzE1MSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIz
YWUvc3cuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3
MjNhZS9zdy5jDQpAQCAtMjY2LDggKzI2Niw4IEBAIHN0YXRpYyBib29sIGlzX2Z3X2hlYWRlcihz
dHJ1Y3QgcnRsd2lmaV9maXJtd2FyZV9oZWFkZXIgKmhkcikNCiBzdGF0aWMgc3RydWN0IHJ0bF9t
b2RfcGFyYW1zIHJ0bDg3MjNlX21vZF9wYXJhbXMgPSB7DQogCS5zd19jcnlwdG8gPSBmYWxzZSwN
CiAJLmluYWN0aXZlcHMgPSB0cnVlLA0KLQkuc3djdHJsX2xwcyA9IGZhbHNlLA0KLQkuZndjdHJs
X2xwcyA9IHRydWUsDQorCS5zd2N0cmxfbHBzID0gdHJ1ZSwNCisJLmZ3Y3RybF9scHMgPSBmYWxz
ZSwNCiAJLmFzcG1fc3VwcG9ydCA9IDEsDQogCS5kZWJ1Z19sZXZlbCA9IDAsDQogCS5kZWJ1Z19t
YXNrID0gMCwNCkBAIC0zOTUsOCArMzk1LDggQEAgc3RhdGljIGJvb2wgaXNfZndfaGVhZGVyKHN0
cnVjdCBydGx3aWZpX2Zpcm13YXJlX2hlYWRlciAqaGRyKQ0KIAkJICAgYm9vbCwgMDQ0NCk7DQog
TU9EVUxFX1BBUk1fREVTQyhzd2VuYywgIlNldCB0byAxIGZvciBzb2Z0d2FyZSBjcnlwdG8gKGRl
ZmF1bHQgMClcbiIpOw0KIE1PRFVMRV9QQVJNX0RFU0MoaXBzLCAiU2V0IHRvIDAgdG8gbm90IHVz
ZSBsaW5rIHBvd2VyIHNhdmUgKGRlZmF1bHQgMSlcbiIpOw0KLU1PRFVMRV9QQVJNX0RFU0Moc3ds
cHMsICJTZXQgdG8gMSB0byB1c2UgU1cgY29udHJvbCBwb3dlciBzYXZlIChkZWZhdWx0IDApXG4i
KTsNCi1NT0RVTEVfUEFSTV9ERVNDKGZ3bHBzLCAiU2V0IHRvIDEgdG8gdXNlIEZXIGNvbnRyb2wg
cG93ZXIgc2F2ZSAoZGVmYXVsdCAxKVxuIik7DQorTU9EVUxFX1BBUk1fREVTQyhzd2xwcywgIlNl
dCB0byAxIHRvIHVzZSBTVyBjb250cm9sIHBvd2VyIHNhdmUgKGRlZmF1bHQgMSlcbiIpOw0KK01P
RFVMRV9QQVJNX0RFU0MoZndscHMsICJTZXQgdG8gMSB0byB1c2UgRlcgY29udHJvbCBwb3dlciBz
YXZlIChkZWZhdWx0IDApXG4iKTsNCiBNT0RVTEVfUEFSTV9ERVNDKG1zaSwgIlNldCB0byAxIHRv
IHVzZSBNU0kgaW50ZXJydXB0cyBtb2RlIChkZWZhdWx0IDApXG4iKTsNCiBNT0RVTEVfUEFSTV9E
RVNDKGFzcG0sICJTZXQgdG8gMSB0byBlbmFibGUgQVNQTSAoZGVmYXVsdCAxKVxuIik7DQogTU9E
VUxFX1BBUk1fREVTQyhkZWJ1Z19sZXZlbCwgIlNldCBkZWJ1ZyBsZXZlbCAoMC01KSAoZGVmYXVs
dCAwKSIpOw0KLS0gDQoxLjkuMQ0K
