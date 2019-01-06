Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB52C43387
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A71222B1
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 00:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbfAFACr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 19:02:47 -0500
Received: from mail-oln040092066048.outbound.protection.outlook.com ([40.92.66.48]:6156
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfAFACr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 19:02:47 -0500
Received: from HE1EUR01FT038.eop-EUR01.prod.protection.outlook.com
 (10.152.0.60) by HE1EUR01HT108.eop-EUR01.prod.protection.outlook.com
 (10.152.1.2) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Sun, 6 Jan
 2019 00:02:41 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com (10.152.0.58) by
 HE1EUR01FT038.mail.protection.outlook.com (10.152.1.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Sun, 6 Jan 2019 00:02:41 +0000
Received: from DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e]) by DB7PR07MB5353.eurprd07.prod.outlook.com
 ([fe80::e1f9:8635:f629:eb8e%4]) with mapi id 15.20.1516.010; Sun, 6 Jan 2019
 00:02:41 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 3/4] rtl8723ae: Re-introduce the adaptive rate control
Thread-Topic: [PATCH v3 3/4] rtl8723ae: Re-introduce the adaptive rate control
Thread-Index: AQHUpVMkOop4N053Y0KcM2mzARMi+A==
Date:   Sun, 6 Jan 2019 00:02:41 +0000
Message-ID: <DB7PR07MB5353FBB8B989B17911140CD0E4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0035.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::48) To DB7PR07MB5353.eurprd07.prod.outlook.com
 (2603:10a6:10:6e::26)
x-incomingtopheadermarker: OriginalChecksum:8CF05EDDBD0C1EE442063221200C1639BD44ED8E995C1341267E962F1CD49C6B;UpperCasedChecksum:F68790972D8B6C8194D61C012225502E6AA665F2EAE43F54D55E4FDD20CE10B8;SizeAsReceived:8776;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [545jQbgqfr4MuyXXKI/0T6BGc6IqLYsc]
x-microsoft-original-message-id: <8071fa15-af2d-d470-894e-3fc99aa7a7d5@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR01HT108;6:xavsR/dMHuz7KdgXXiLb0OT03WeS9+SmbZelEFGzX/EH4f7giiuBdSt92cPU7RmXBlqg0wRkva14y60oCXah8hzOFxRFppYIl17C35Zz83E6oGNfRtDYyc9vy/3jq/ccPjyfZ1MuqscKIpMymXxc1Wqnq7vAwwV8IPS8qcGcTi0PqH68ItWy4HDPJUcN696yWy17+tIUdnzLDgLgWvZPupZXOKe1jUbJ3RafxjId7UjblVlktVWiSjvnBFXjQjmi4V2ojEqjDrxI6PHediKKFE0GVAPPkIISSZTkjeynRA1NAZr2CYwUhhAr4obmhY8Tprntj1cmToOXqPkt2HOsIIre5wIoUB4Wd/x4N/MpGxB4qeOrbSVUzFMDFq0KiX7kqVw7bH8ZQW+IfNDdke54pygHsUGsQFbsn5dCVYuecuBOD7JE5D9En2aKhGrtJBCaRVg2PqeECrAD/SQ6mPZcPA==;5:cv4KzH6zWIyiRk4+PeHkp/PABlfeWtf00wMXL0bdhljIj9tHGruDAme74MghLgAZBcxQnXRB1NBmk53vzRobhZJeBUQdXmakreSscl4x+2aFoB5HVx93KDRboNBPmEQEcttQVGE6pp/pmAmQrAPbJqMAf3d5GmNnmt+8sab789k=;7:URMymyyRzrApnOCdTKsfR/8CMqPt2BM3nnBlopTrMlem4XagSDc7lb4c5R/fewwwkxqQBUCsRhDNa5gQWzC0sVBfjUcouSkeKfYo5Mui524Ia+ZbxT0q5GZnGv0DLiu/+OauDZ4JplpqCd9QYNmZCg==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR01HT108;
x-ms-traffictypediagnostic: HE1EUR01HT108:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR01HT108;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR01HT108;
x-microsoft-antispam-message-info: o+d307yWn1CPVS+qZ3tdWLpgftdMRY6ogtBZtmPE25/xN+9tp5/VCZnaWTU0bqKS
Content-Type: text/plain; charset="utf-8"
Content-ID: <D076E40CD757324395A047C2DEDDBC89@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0226b5-2a34-46ab-f803-08d6736a46a7
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2019 00:02:40.3488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT108
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhpcyByZS1pbnRyb2R1Y2VzIHRoZSBmdW5jdGlvbiBydGw4NzIzZV9kbV9yZWZyZXNoX3JhdGVf
YWRhcHRpdmVfbWFzay4NCg0KVGhpcyBmdW5jdGlvbiB3YXMgcHJlc2VudCBpbiBhIHByZXZpb3Vz
IHZlcnNpb24gb2YgdGhlIGNvZGUgYmFzZSwNCml0IHdvcmtzIGp1c3QgZmluZSBmb3IgbWUgLS0g
YXMgbG9uZyBhcyBpdCBpcyBub3QgdXNpbmcgc3RhbGUgZGF0YS4NCg0KVW5saWtlIHRoZSBvcmln
aW5hbCB2ZXJzaW9uIG9mIHRoaXMgZnVuY3Rpb24gaXQgYXZvaWRzIHVzaW5nDQpkbS51bmRlY19z
bV9wd2RiIHdoZW4gbm8gYmVhY29uIHdhcyByZWNlaXZlZC4NCg0KRml4ZWQgYSBzdHlsZSBuaXQg
aW4gcnRsODcyM2VfZG1faW5pdF9yYXRlX2FkYXB0aXZlX21hc2suDQoNClNpZ25lZC1vZmYtYnk6
IEJlcm5kIEVkbGluZ2VyIDxiZXJuZC5lZGxpbmdlckBob3RtYWlsLmRlPg0KLS0tDQp2MjogSW1w
cm92ZSBwYXRjaCBkZXNjcmlwdGlvbi4NCg0KdjM6IEltcHJvdmUgcGF0Y2ggZGVzY3JpcHRpb24s
IG1lbnRpb24gdGhhdCBkbS51bmRlY19zbV9wd2RiDQppcyBub3QgdXNlZCB3aGVuIG5vIGJlYWNv
biByZWNlaXZlZC4gDQpNYWtlIHRoZSB0aXRsZSBmaXQgaW4gb25lIGxpbmUuDQotLS0NCiAuLi4v
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvZG0uYyAgICB8IDg3ICsrKysr
KysrKysrKysrKysrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgODUgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9ydGw4NzIzYWUvZG0uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9ydGw4NzIzYWUvZG0uYw0KaW5kZXggOTAyYjk0NC4uYWNmZDU0YyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvZG0uYw0KKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9kbS5jDQpA
QCAtNjczLDcgKzY3Myw3IEBAIHZvaWQgcnRsODcyM2VfZG1fY2hlY2tfdHhwb3dlcl90cmFja2lu
ZyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiB2b2lkIHJ0bDg3MjNlX2RtX2luaXRfcmF0ZV9h
ZGFwdGl2ZV9tYXNrKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIHsNCiAJc3RydWN0IHJ0bF9w
cml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOw0KLQlzdHJ1Y3QgcmF0ZV9hZGFwdGl2ZSAqcF9y
YSA9ICYocnRscHJpdi0+cmEpOw0KKwlzdHJ1Y3QgcmF0ZV9hZGFwdGl2ZSAqcF9yYSA9ICZydGxw
cml2LT5yYTsNCiANCiAJcF9yYS0+cmF0cl9zdGF0ZSA9IERNX1JBVFJfU1RBX0lOSVQ7DQogCXBf
cmEtPnByZV9yYXRyX3N0YXRlID0gRE1fUkFUUl9TVEFfSU5JVDsNCkBAIC02ODUsNiArNjg1LDg5
IEBAIHZvaWQgcnRsODcyM2VfZG1faW5pdF9yYXRlX2FkYXB0aXZlX21hc2soc3RydWN0IGllZWU4
MDIxMV9odyAqaHcpDQogDQogfQ0KIA0KK3ZvaWQgcnRsODcyM2VfZG1fcmVmcmVzaF9yYXRlX2Fk
YXB0aXZlX21hc2soc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQorew0KKwlzdHJ1Y3QgcnRsX3By
aXYgKnJ0bHByaXYgPSBydGxfcHJpdihodyk7DQorCXN0cnVjdCBydGxfaGFsICpydGxoYWwgPSBy
dGxfaGFsKHJ0bF9wcml2KGh3KSk7DQorCXN0cnVjdCBydGxfbWFjICptYWMgPSBydGxfbWFjKHJ0
bF9wcml2KGh3KSk7DQorCXN0cnVjdCByYXRlX2FkYXB0aXZlICpwX3JhID0gJnJ0bHByaXYtPnJh
Ow0KKwl1MzIgbG93X3Jzc2l0aHJlc2hfZm9yX3JhLCBoaWdoX3Jzc2l0aHJlc2hfZm9yX3JhOw0K
KwlzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhID0gTlVMTDsNCisNCisJaWYgKGlzX2hhbF9zdG9w
KHJ0bGhhbCkpIHsNCisJCVJUX1RSQUNFKHJ0bHByaXYsIENPTVBfUkFURSwgREJHX0xPVUQsDQor
CQkJICIgZHJpdmVyIGlzIGdvaW5nIHRvIHVubG9hZFxuIik7DQorCQlyZXR1cm47DQorCX0NCisN
CisJaWYgKCFydGxwcml2LT5kbS51c2VyYW1hc2spIHsNCisJCVJUX1RSQUNFKHJ0bHByaXYsIENP
TVBfUkFURSwgREJHX0xPVUQsDQorCQkJICIgZHJpdmVyIGRvZXMgbm90IGNvbnRyb2wgcmF0ZSBh
ZGFwdGl2ZSBtYXNrXG4iKTsNCisJCXJldHVybjsNCisJfQ0KKw0KKwlpZiAobWFjLT5saW5rX3N0
YXRlID09IE1BQzgwMjExX0xJTktFRCAmJg0KKwkgICAgbWFjLT5vcG1vZGUgPT0gTkw4MDIxMV9J
RlRZUEVfU1RBVElPTikgew0KKwkJc3dpdGNoIChwX3JhLT5wcmVfcmF0cl9zdGF0ZSkgew0KKwkJ
Y2FzZSBETV9SQVRSX1NUQV9ISUdIOg0KKwkJCWhpZ2hfcnNzaXRocmVzaF9mb3JfcmEgPSA1MDsN
CisJCQlsb3dfcnNzaXRocmVzaF9mb3JfcmEgPSAyMDsNCisJCQlicmVhazsNCisJCWNhc2UgRE1f
UkFUUl9TVEFfTUlERExFOg0KKwkJCWhpZ2hfcnNzaXRocmVzaF9mb3JfcmEgPSA1NTsNCisJCQls
b3dfcnNzaXRocmVzaF9mb3JfcmEgPSAyMDsNCisJCQlicmVhazsNCisJCWNhc2UgRE1fUkFUUl9T
VEFfTE9XOg0KKwkJCWhpZ2hfcnNzaXRocmVzaF9mb3JfcmEgPSA2MDsNCisJCQlsb3dfcnNzaXRo
cmVzaF9mb3JfcmEgPSAyNTsNCisJCQlicmVhazsNCisJCWRlZmF1bHQ6DQorCQkJaGlnaF9yc3Np
dGhyZXNoX2Zvcl9yYSA9IDUwOw0KKwkJCWxvd19yc3NpdGhyZXNoX2Zvcl9yYSA9IDIwOw0KKwkJ
CWJyZWFrOw0KKwkJfQ0KKw0KKwkJaWYgKHJ0bHByaXYtPmxpbmtfaW5mby5iY25fcnhfaW5wZXJp
b2QgPT0gMCkNCisJCQlzd2l0Y2ggKHBfcmEtPnByZV9yYXRyX3N0YXRlKSB7DQorCQkJY2FzZSBE
TV9SQVRSX1NUQV9ISUdIOg0KKwkJCWRlZmF1bHQ6DQorCQkJCXBfcmEtPnJhdHJfc3RhdGUgPSBE
TV9SQVRSX1NUQV9NSURETEU7DQorCQkJCWJyZWFrOw0KKwkJCWNhc2UgRE1fUkFUUl9TVEFfTUlE
RExFOg0KKwkJCWNhc2UgRE1fUkFUUl9TVEFfTE9XOg0KKwkJCQlwX3JhLT5yYXRyX3N0YXRlID0g
RE1fUkFUUl9TVEFfTE9XOw0KKwkJCQlicmVhazsNCisJCQl9DQorCQllbHNlIGlmIChydGxwcml2
LT5kbS51bmRlY19zbV9wd2RiID4gaGlnaF9yc3NpdGhyZXNoX2Zvcl9yYSkNCisJCQlwX3JhLT5y
YXRyX3N0YXRlID0gRE1fUkFUUl9TVEFfSElHSDsNCisJCWVsc2UgaWYgKHJ0bHByaXYtPmRtLnVu
ZGVjX3NtX3B3ZGIgPiBsb3dfcnNzaXRocmVzaF9mb3JfcmEpDQorCQkJcF9yYS0+cmF0cl9zdGF0
ZSA9IERNX1JBVFJfU1RBX01JRERMRTsNCisJCWVsc2UNCisJCQlwX3JhLT5yYXRyX3N0YXRlID0g
RE1fUkFUUl9TVEFfTE9XOw0KKw0KKwkJaWYgKHBfcmEtPnByZV9yYXRyX3N0YXRlICE9IHBfcmEt
PnJhdHJfc3RhdGUpIHsNCisJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX1JBVEUsIERCR19MT1VE
LA0KKwkJCQkgIlJTU0kgPSAlbGRcbiIsDQorCQkJCSBydGxwcml2LT5kbS51bmRlY19zbV9wd2Ri
KTsNCisJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX1JBVEUsIERCR19MT1VELA0KKwkJCQkgIlJT
U0lfTEVWRUwgPSAlZFxuIiwgcF9yYS0+cmF0cl9zdGF0ZSk7DQorCQkJUlRfVFJBQ0UocnRscHJp
diwgQ09NUF9SQVRFLCBEQkdfTE9VRCwNCisJCQkJICJQcmVTdGF0ZSA9ICVkLCBDdXJTdGF0ZSA9
ICVkXG4iLA0KKwkJCQkgcF9yYS0+cHJlX3JhdHJfc3RhdGUsIHBfcmEtPnJhdHJfc3RhdGUpOw0K
Kw0KKwkJCXJjdV9yZWFkX2xvY2soKTsNCisJCQlzdGEgPSBydGxfZmluZF9zdGEoaHcsIG1hYy0+
YnNzaWQpOw0KKwkJCWlmIChzdGEpDQorCQkJCXJ0bHByaXYtPmNmZy0+b3BzLT51cGRhdGVfcmF0
ZV90YmwoaHcsIHN0YSwNCisJCQkJCQkJICAgcF9yYS0+cmF0cl9zdGF0ZSwNCisJCQkJCQkJCSAg
ICAgIHRydWUpOw0KKwkJCXJjdV9yZWFkX3VubG9jaygpOw0KKw0KKwkJCXBfcmEtPnByZV9yYXRy
X3N0YXRlID0gcF9yYS0+cmF0cl9zdGF0ZTsNCisJCX0NCisJfQ0KK30NCisNCiB2b2lkIHJ0bDg3
MjNlX2RtX3JmX3NhdmluZyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTggYmZvcmNlX2luX25v
cm1hbCkNCiB7DQogCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsNCkBA
IC04MzQsNyArOTE3LDcgQEAgdm9pZCBydGw4NzIzZV9kbV93YXRjaGRvZyhzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodykNCiAJCXJ0bDg3MjNlX2RtX2R5bmFtaWNfYmJfcG93ZXJzYXZpbmcoaHcpOw0K
IAkJcnRsODcyM2VfZG1fZHluYW1pY190eHBvd2VyKGh3KTsNCiAJCXJ0bDg3MjNlX2RtX2NoZWNr
X3R4cG93ZXJfdHJhY2tpbmcoaHcpOw0KLQkJLyogcnRsOTJjX2RtX3JlZnJlc2hfcmF0ZV9hZGFw
dGl2ZV9tYXNrKGh3KTsgKi8NCisJCXJ0bDg3MjNlX2RtX3JlZnJlc2hfcmF0ZV9hZGFwdGl2ZV9t
YXNrKGh3KTsNCiAJCXJ0bDg3MjNlX2RtX2J0X2NvZXhpc3QoaHcpOw0KIAkJcnRsODcyM2VfZG1f
Y2hlY2tfZWRjYV90dXJibyhodyk7DQogCX0NCi0tIA0KMS45LjENCg==
