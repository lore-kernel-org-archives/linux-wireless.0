Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB8EC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 07:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0A372081B
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 07:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="M6OvK93f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0A372081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbeKBRAY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 13:00:24 -0400
Received: from mail-eopbgr810090.outbound.protection.outlook.com ([40.107.81.90]:34741
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727876AbeKBRAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 13:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLbW7wfd1OqGLI9mKBT5X5/QwsFCvHT1fpJTzIBA9xo=;
 b=M6OvK93fz4d0FqePa3szjRcTFlpmLG4BsiRhqlxKLaX2PXFAVrr60AXm+IbZQOSeLeZqNmVRDUwCbZQWYEt/UU8Q6jxLyzfcTjoOr3rWH1I+eQ7QHBX9Mw2Xhmrgg/92cHwzBbDF+8eWDgtkho9OSPJJhe5DbS1v4ti6FL6786c=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4023.namprd06.prod.outlook.com (52.135.192.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.25; Fri, 2 Nov 2018 07:54:03 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 07:54:03 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH 2/3] brcmfmac: add credit numbers updating support
Thread-Topic: [PATCH 2/3] brcmfmac: add credit numbers updating support
Thread-Index: AQHUb3H6UjCqWYxoE0WZE4qJFjplhqU3oc4AgASBs4A=
Date:   Fri, 2 Nov 2018 07:54:03 +0000
Message-ID: <ed8d5509-5486-5638-9175-7f3297b78b63@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-3-git-send-email-wright.feng@cypress.com>
 <aa65d65d-f610-3136-2e7d-45d150ec183d@broadcom.com>
In-Reply-To: <aa65d65d-f610-3136-2e7d-45d150ec183d@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0138.jpnprd01.prod.outlook.com
 (2603:1096:604:f::30) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4023;6:3EKKBmiilwwveiRnfptvVTSYi0MRXUDx7K3hQteE3woGc+bdJpYzdNVhs+RhSgbGGS+Y1omJlLGLaAOnSrQoRwg/GB+E9URJTTgZwQBxjAZ162rQXrFL4qDcLM46BcG0dNAEZOmk4E+4JiJtBuc47Xd29+bjStB4CoNFQ+yfdQonmcPjIXjjHLv20mJfIdjp6EKOscOMOkRzkrHTHjNG4+yBcb/oNZfMoq5i+ipXXY1iC/GTB55g7PP+xZ989FmbBzIjOQMUunA6JUZHP8sbapZzJT1038Vfcry4lQ0F56R7XXL5rQCHP0I2QzpzFATIwW1FBtObXr1yzlMipOPx13SAHP7oLjJwrbd9FcvqPbI0AvNEaVkv88xs1xIIUMoodjSLLE65JmfDKR3lmesTZkDsXXGKHwuEp2uHGZyKV9yHOGHNiM7CaJSv0jPhaw90ZMy7yu769v43kyVtmbVzgg==;5:WMSiWwzk2ae6QCT0AhJmc8KIlHBdkpIqV1uo0Ehr0IPxPLAceM8BrFfeSSMmBCSGZq4l35MX5oWZLATBVB4epCND78n5ca4raVpyFLdqKsP7ZC94svfBpcFZkPAAfX50fSBlZu+8u1OQRaFZKAOA9WuI9mis5Ppj6wfpEk4hU6Y=;7:BN/3TLt803itj94nvIB1RBc8bRBP10C0r0M726TkxjRzh2AUlE9shLu7rXP1mWZrUEc4zTxeEJXhvzYwraHD4dSADpNUBrsjFgh3hyCoP5a9M90WNF8QVOFpfDCZF9tqow0FPKzGSFGjZ/Z/vr/dsQ==
x-ms-office365-filtering-correlation-id: 7ce06346-acce-4f84-7e25-08d640985b47
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4023;
x-ms-traffictypediagnostic: BYAPR06MB4023:
x-microsoft-antispam-prvs: <BYAPR06MB40233407E14AAA308B6327BFFBCF0@BYAPR06MB4023.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(788757137089)(208715162771679)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4023;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4023;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(396003)(346002)(376002)(199004)(189003)(51914003)(66066001)(54906003)(3846002)(6116002)(76176011)(25786009)(6436002)(6486002)(110136005)(105586002)(316002)(386003)(6506007)(4326008)(31686004)(478600001)(81166006)(81156014)(8936002)(486006)(7736002)(71200400001)(305945005)(31696002)(8676002)(2906002)(52116002)(446003)(11346002)(68736007)(99286004)(2616005)(476003)(106356001)(71190400001)(186003)(2900100001)(6246003)(53546011)(86362001)(97736004)(229853002)(36756003)(53936002)(26005)(14454004)(72206003)(102836004)(6512007)(5660300001)(256004)(14444005)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4023;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kCDT5ItcjkTWKVMxxk52Zo15+1EkWfK1ATnzmNtE959Ng6hS7e17PHaOUJrSD2kT8V1kgKaxvYF5dn1QpkWBmQue9AH/5rbwPwIYodo+SfCbtu0bhAVvnU1uzkZ0cWEkpPJJ56lBGI5PZtGNm1rdzRKPaHkq6yiV7zwOhoKKyHsHRa6ndTs8B3/UCbsbLpn0dMbt/ion34PyOIpCnEv/QYuU1fIGkM8cav5HPAI98h/yJ8eXdJSdP9XlXHnLqSMLATmPPhgynxmStXKyormae9NY+lwcvrB3GUos2cnJTGSyZOwR1iBzQn0HuxxoB3/RqsICeW0wB+/aNoyUnz2OlUO3S8kRSeL5gQsmBFR/JDk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D91A4D00A8714468652442BF635006F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce06346-acce-4f84-7e25-08d640985b47
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 07:54:03.5278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4023
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTAvMzAg5LiL5Y2IIDA3OjA0LCBBcmVuZCB2YW4gU3ByaWVsIHdyb3RlOg0K
PiBPbiAxMC8yOS8yMDE4IDExOjI3IEFNLCBXcmlnaHQgRmVuZyB3cm90ZToNCj4+IFRoZSBjcmVk
aXQgbnVtYmVycyBhcmUgc3RhdGljIGFuZCB0dW5hYmxlIHBlciBjaGlwIGluIGZpcm13YXJlIHNp
ZGUuDQo+PiBIb3dldmVyIHRoZSBjcmVkaXQgbnVtYmVyIG1heSBiZSBjaGFuZ2VkIHRoYXQgaXMg
YmFzZWQgb24gcGFja2V0IHBvb2wNCj4+IGxlbmd0aCBhbmQgd2lsbCBzZW5kIEJSQ01GX0VfRklG
T19DUkVESVRfTUFQIGV2ZW50IHRvIG5vdGlmeSBob3N0IGRyaXZlcg0KPj4gdXBkYXRlcyB0aGUg
Y3JlZGl0IG51bWJlcnMgZHVyaW5nIGludGVyZmFjZSB1cC4NCj4+IFRoZSBwdXJwb3NlIG9mIHRo
aXMgcGF0Y2ggaXMgbWFraW5nIGhvc3QgZHJpdmVyIGhhcyBhYmlsaXR5IG9mIHVwZGF0aW5nDQo+
PiB0aGUgY3JlZGl0IG51bWJlcnMgd2hlbiByZWNlaXZpbmcgdGhlIEJSQ01GX0VfRklGT19DUkVE
SVRfTUFQIGV2ZW50Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFyZW5kIHZhbiBTcHJpZWwgPGFyZW5k
LnZhbnNwcmllbEBicm9hZGNvbS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBXcmlnaHQgRmVuZyA8
d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+PiAtLS0NCj4+IMKgLi4uL2Jyb2FkY29tL2JyY204
MDIxMS9icmNtZm1hYy9md3NpZ25hbC5jwqDCoMKgwqDCoMKgwqDCoCB8IDIzIA0KPj4gKysrKysr
KysrKysrKystLS0tLS0tLQ0KPj4gwqAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwg
OCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IA0KPj4gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndzaWduYWwuYyANCj4+IGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Z3c2lnbmFsLmMNCj4+
IGluZGV4IGYzY2JmNzguLmUwOTEwYzUgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndzaWduYWwuYw0KPj4gKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2Z3c2lnbmFsLmMN
Cj4gDQo+IFsuLi5dDQo+IA0KPj4gQEAgLTE1OTUsMTkgKzE1OTksMjEgQEAgc3RhdGljIGludCBi
cmNtZl9md3Nfbm90aWZ5X2NyZWRpdF9tYXAoc3RydWN0IA0KPj4gYnJjbWZfaWYgKmlmcCwNCj4+
IMKgwqDCoMKgwqDCoMKgwqAgYnJjbWZfZXJyKCJldmVudCBwYXlsb2FkIHRvbyBzbWFsbCAoJWQp
XG4iLCBlLT5kYXRhbGVuKTsNCj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7DQo+
PiDCoMKgwqDCoCB9DQo+PiAtwqDCoMKgIGlmIChmd3MtPmNyZWRpdG1hcF9yZWNlaXZlZCkNCj4+
IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsNCj4+DQo+PiDCoMKgwqDCoCBmd3MtPmNyZWRpdG1h
cF9yZWNlaXZlZCA9IHRydWU7DQo+IA0KPiBJIHRoaW5rIHRoZSBjcmVkaXRtYXBfcmVjZWl2ZWQg
c3RydWN0IG1lbWJlciBpcyBubyBsb25nZXIgbmVlZGVkLg0KSSB3aWxsIGtlZXAgdGhpcyBiZWNh
dXNlIHdlIHN0aWxsIG5lZWQgaXQgZm9yIGNoZWNraW5nIHdoZXRoZXIgZmxvdw0KY29udHJvbCBp
cyBhY3RpdmUgb3Igbm90Lg0KPiANCj4+IMKgwqDCoMKgIGJyY21mX2RiZyhUUkFDRSwgImVudGVy
OiBjcmVkaXRzICVwTVxuIiwgY3JlZGl0cyk7DQo+PiDCoMKgwqDCoCBicmNtZl9md3NfbG9jayhm
d3MpOw0KPj4gwqDCoMKgwqAgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoZndzLT5maWZvX2Ny
ZWRpdCk7IGkrKykgew0KPj4gLcKgwqDCoMKgwqDCoMKgIGlmICgqY3JlZGl0cykNCj4+ICvCoMKg
wqDCoMKgwqDCoCBmd3MtPmZpZm9fY3JlZGl0W2ldICs9IGNyZWRpdHNbaV0gLSBmd3MtPmluaXRf
Zmlmb19jcmVkaXRbaV07DQo+PiArwqDCoMKgwqDCoMKgwqAgZndzLT5pbml0X2ZpZm9fY3JlZGl0
W2ldID0gY3JlZGl0c1tpXTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoZndzLT5maWZvX2NyZWRp
dFtpXSA+IDApDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZndzLT5maWZvX2NyZWRpdF9t
YXAgfD0gMSA8PCBpOw0KPj4gwqDCoMKgwqDCoMKgwqDCoCBlbHNlDQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZndzLT5maWZvX2NyZWRpdF9tYXAgJj0gfigxIDw8IGkpOw0KPj4gLcKgwqDC
oMKgwqDCoMKgIGZ3cy0+Zmlmb19jcmVkaXRbaV0gPSAqY3JlZGl0cysrOw0KPj4gK8KgwqDCoMKg
wqDCoMKgIGlmIChmd3MtPmZpZm9fY3JlZGl0W2ldIDwgMCkNCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGJyY21mX2VycigiZmlmb19jcmVkaXRbJWRdIHZhbHVlIGlzIG5lZ2F0aXZlKCVkKVxu
IiwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGksIGZ3cy0+Zmlmb19j
cmVkaXRbaV0pOw0KPiANCj4gVGhpcyBsb29rcyBsaWtlIGl0IHNob3VsZCBub3QgaGFwcGVuIHNv
IG1heWJlIHdhcnJhbnRzIGEgV0FSTiBvciBXQVJOX09OQ0U/DQpJIHdpbGwgcmVwbGFjZSB0aG9z
ZSAyIGxpbmVzIHdpdGggV0FSTl9PTkNFLg0KVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4NCg0K
LVdyaWdodA0KPiANCj4+IMKgwqDCoMKgIH0NCj4+IMKgwqDCoMKgIGJyY21mX2Z3c19zY2hlZHVs
ZV9kZXEoZndzKTsNCj4+IMKgwqDCoMKgIGJyY21mX2Z3c191bmxvY2soZndzKTsNCj4gDQo=
