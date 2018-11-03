Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855ABC32789
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 01:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38688204FD
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 01:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="tCRaZ0pK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38688204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbeKCKqK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:46:10 -0400
Received: from mail-eopbgr810124.outbound.protection.outlook.com ([40.107.81.124]:34848
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbeKCKqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 06:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cVcXJaT4ZbOwEEEIElGk1LiviijcwD2J3nkGP98v/0=;
 b=tCRaZ0pKOUcz9SK0BrQyerdoNxhIGYfgycpT6um/VxbjP4i2kCb2xobx167OtfHwOaT1Z1IvKFExUOPXVnQ9cKqfSNquZ6dQUDLlwqurj6s2NMasthHGyL/WfBgGOs4OHv0KmNp6xxyNQPdbhH7NCTdDLaTYDXTZBtlZ+7ha1Ds=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4917.namprd06.prod.outlook.com (20.177.184.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.20; Sat, 3 Nov 2018 01:36:31 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Sat, 3 Nov 2018
 01:36:31 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Franky Lin <franky.lin@broadcom.com>
CC:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH 1/3] brcmfmac: calling skb_orphan before sending skb to
 SDIO bus
Thread-Topic: [PATCH 1/3] brcmfmac: calling skb_orphan before sending skb to
 SDIO bus
Thread-Index: AQHUb3H2+mORDXs3gE6Xp6/NyHTPOKU2kYWAgAVCQACAARhZAIAAYESA
Date:   Sat, 3 Nov 2018 01:36:31 +0000
Message-ID: <be063e69-1bbf-be13-5cee-9dcce4ef51de@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
 <CA+8PC_f-EMCWnn1oBorAZjNY2xJXcJbhbP+8fU9wYJXnnZto5w@mail.gmail.com>
 <55fc2684-bd07-95ae-9193-0d383787ebf8@cypress.com>
 <CA+8PC_fVWy=R1VPH4RVPgdTY6D0cA89B4L990F_Kt0Cevgt4+w@mail.gmail.com>
In-Reply-To: <CA+8PC_fVWy=R1VPH4RVPgdTY6D0cA89B4L990F_Kt0Cevgt4+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR02CA0140.apcprd02.prod.outlook.com
 (2603:1096:202:16::24) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [123.194.189.50]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4917;6:/+VUC7VKnL47MZfN8m+OyDuwauBEYVjuv+1x8lv+os5vONrn1OUzYPH9XGIHpJ6ur7akEEI0GONLJ4wSaRQblQUY9Fku9/54XgwuUUDzWR3SLePm8hd7d5bh4PWvILGcBt1zvVXzNlvLDSk6Ubg78c2lAXSSOFa3ffjOjir8cJ31ykvpXgJx25+sTMqWPCAL0tPiKJIqui4qbE6wUd/GREFx0DC9F0hDOkTQ6tHe0USUAzQgmQo5cz6nq0CSx+2qv44MgbXftMk5XfaaOvxC/4oCLBTZIV2e4HkxH0sWzntIHPDnUT4QK592kbE9GRQ2xz0fHukE0cIasXVGkNTLgI4N2cVdTmZJ0txtl36Xx7ceW8J+Dc8ikwOnjs1anfnWMaVvbbiOjMogBmAZBmz12vXCaOgf9iOwpyIfS64X5qfF2smay3uYy0rGgU86Zl6+tO/+myCMiaAuVMZ6B/CP2w==;5:HKNXhGU8qOlJv0mq7SFFW7pSaMGbX18D+EYFkpbc8JwA+FCTfCkDYcf+aRttz2Ap2mXNfNX0ONYiB2NlaX8Wt31ukLiyx0dMXJHz7xDACCzWOZTYUT/3mxelyIPvNsxHNbZRVrklkyg8sGDGn0jLSG201GwJIL6ooCvWWkoKKRo=;7:GZJOj9GCN1NuWn1+5u/dDYXZaiOGMIweJvFqVv3vNABL7SD6J4A2c4tf/N15BSK5b+gunfkotTaNabwUp4EJxiugfoKU1Gxji1sDSNY1/ArKj5rDXPDtPb2DvwdmasT0t5MvycasmGoHi8jR0umufQ==
x-ms-office365-filtering-correlation-id: 55218d90-125e-4612-1538-08d6412cc836
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4917;
x-ms-traffictypediagnostic: BYAPR06MB4917:
x-microsoft-antispam-prvs: <BYAPR06MB491727174AFA401F3A1ABB29FBC80@BYAPR06MB4917.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(60795455431006)(84791874153150)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4917;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4917;
x-forefront-prvs: 08457955C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(346002)(396003)(376002)(366004)(39860400002)(136003)(189003)(199004)(51914003)(86362001)(305945005)(66066001)(72206003)(99286004)(966005)(6116002)(186003)(36756003)(7736002)(3846002)(256004)(53936002)(6512007)(71190400001)(71200400001)(316002)(93886005)(6436002)(2906002)(6246003)(229853002)(31696002)(575784001)(14444005)(5660300001)(6916009)(6486002)(6306002)(54906003)(478600001)(446003)(105586002)(76176011)(476003)(11346002)(8676002)(486006)(81166006)(81156014)(8936002)(106356001)(97736004)(6506007)(102836004)(53546011)(386003)(2900100001)(52116002)(14454004)(31686004)(4326008)(68736007)(2616005)(26005)(25786009)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4917;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: wSfCu+nBm/vVg0I5qm+2NG2/24PreLR9ltqVEbCiiDjt3+autJo5jrJSjQiM/IiiPgBdQ5EMFERvZ6MLTvYynbG2srhII0HU9MtORoqxqQnNYp0Bgy0WtYLHltF2mX96t1zCe7exz3bpsW3m8754U1FisVvgimZYmuRwWPGSRwJvI3Yc8bXYa9MyM25RpLHS6GagaHQU3IMtdFcoBmsSWZ5brvIe8YsCR8qCR/IxmawEi33d42/XvYhSDzbELYWZwTZHFWPBFKTJxPZsMs8cMIGGCKUkJf4Urhc8Irp+WeewuaWnQUJZ/2SK20WOuB/lsnye7Wd1Y/kUm87uEIuOcy8vtrw0rGNRlM4Smf49jxU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB150B0FF1732A4B835853D8DC5015B3@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55218d90-125e-4612-1538-08d6412cc836
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2018 01:36:31.6764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4917
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCkZyYW5reSBMaW4g5pa8IDExLzMvMjAxOCAzOjUxIEFNIOWvq+mBkzoNCj4gT24gVGh1LCBO
b3YgMSwgMjAxOCBhdCA4OjA4IFBNIFdyaWdodCBGZW5nIDxXcmlnaHQuRmVuZ0BjeXByZXNzLmNv
bT4gd3JvdGU6DQo+Pg0KPj4NCj4+DQo+PiBPbiAyMDE4LzEwLzMwIOS4iuWNiCAwMjo1MCwgRnJh
bmt5IExpbiB3cm90ZToNCj4+PiBPbiBNb24sIE9jdCAyOSwgMjAxOCBhdCAzOjI3IEFNIFdyaWdo
dCBGZW5nIDxXcmlnaHQuRmVuZ0BjeXByZXNzLmNvbT4gd3JvdGU6DQo+Pj4+DQo+Pj4+IExpbnV4
IDMuNiBpbnRyb2R1Y2VzIFRTUSB3aGljaCBoYXMgYSBwZXIgc29ja2V0IHRocmVzaG9sZCBmb3Ig
VENQIFR4DQo+Pj4+IHBhY2tldHMgdG8gcmVkdWNlIGxhdGVuY3kuIEluIGZjbW9kZSAxIGFuZCBm
Y21vZGUgMiwgaG9zdCBkcml2ZXIgZW5xdWV1ZXMNCj4+Pj4gc2tiIGluIGhhbmdlciBhbmQgVENQ
IGRvZXNuJ3QgcHVzaCBuZXcgc2tiIHVudGlsIGhvc3QgZnJlZXMgdGhlIHNrYiB3aGVuDQo+Pj4+
IHJlY2VpdmluZyBmd3N0YXR1cyBldmVudC4gU28gdXNpbmcgc2tiX29ycGhhbiBiZWZvcmUgc2Vu
ZGluZyBza2IgdG8gYnVzDQo+Pj4+IHdpbGwgbWFrZSB0aGUgc2tiIHJlbW92aW5nIHRoZSBvd25l
cnNoaXAgb2Ygc29ja2V0LiBXaXRoIHRoaXMgcGF0Y2gsIHdlDQo+Pj4+IGFyZSBhYmxlIHRvIGdl
dCBiZXR0ZXIgdGhyb3VnaHB1dCBpbiBmY21vZGUgMSBhbmQgZmNtb2RlIDIuDQo+Pj4+DQo+Pj4+
IFRlc3RlZCA0MzQ1NSBUQ1AgdGhyb3VnaHB1dCBpbiAyMCBNSHogYmFuZHdpZHRoIHdpdGggLyB3
aXRob3V0IHRoaXMgcGF0Y2guDQo+Pj4+IGZjbW9kZSAwOiA1OS41IC8gNTkuNiAobWJwcykNCj4+
Pj4gZmNtb2RlIDE6IDU5LjMgLyAyMy40IChtYnBzKQ0KPj4+PiBmY21vZGUgMjogNTkuNiAvIDIx
LjUgKG1icHMpDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFdyaWdodCBGZW5nIDx3cmlnaHQu
ZmVuZ0BjeXByZXNzLmNvbT4NCj4+Pj4gLS0tDQo+Pj4+ICAgIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMgfCAxICsNCj4+Pj4gICAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYw0KPj4+PiBp
bmRleCBiMmUxYWI1Li41MTliMjVkIDEwMDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5jDQo+Pj4+ICsrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMNCj4+Pj4g
QEAgLTIyOTgsNiArMjI5OCw3IEBAIHN0YXRpYyB1aW50IGJyY21mX3NkaW9fc2VuZGZyb21xKHN0
cnVjdCBicmNtZl9zZGlvICpidXMsIHVpbnQgbWF4ZnJhbWVzKQ0KPj4+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmcHJlY19vdXQpOw0KPj4+PiAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChwa3QgPT0gTlVMTCkNCj4+Pj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+PiArICAgICAgICAgICAgICAgICAgICAg
ICBza2Jfb3JwaGFuKHBrdCk7DQo+Pj4NCj4+PiBUU1EgYWxsb3dzIGRldmljZSBkcml2ZXIgdG8g
dHdlYWsgZm9yIGEgZGVlcGVyIHF1ZXVlIG5vdy4gWzFdLiBXZQ0KPj4+IHNob3VsZCB1c2UgdGhh
dCBpbnN0ZWFkIG9mIG9ycGhhbmluZyB0aGUgcGFja2V0IGJlZm9yZSBoYW5kaW5nIG92ZXIgdG8N
Cj4+PiBmaXJtd2FyZSB3aGljaCB3b3VsZCByZW1vdmUgdGhlIGJ1ZmZlcmJsb2F0IHByb3RlY3Rp
b24gYnkgVFNRLg0KPj4+DQo+Pj4gVGhhbmtzLA0KPj4+IC1GcmFua3kNCj4+Pg0KPj4gU2luY2Ug
dGhlIGFnZ3JlZ2F0aW9uIHByb2JsZW0gaGFzIGJlZW4gZml4ZWQgYnkgc2V0dGluZyBza19wYWNp
bmdfc2hpZnQsDQo+PiBJIHdpbGwgc3VibWl0IHYyIHdpdGhvdXQgdGhpcyBvbmUuDQo+PiBUaGFu
a3MgZm9yIHRoZSBpbmZvcm1hdGlvbi4NCj4gDQo+IE5vIHRoZSBwcm9ibGVtIGlzIG5vdCBmaXhl
ZC4gVGhlIHBhdGNoIGp1c3QgcHJvdmlkZXMgYW4gaW50ZXJmYWNlDQo+IHNrX3BhY2luZ19zaGlm
dF91cGRhdGUgc28gdGhlIGRldmljZSBkcml2ZXIgY2FuIHR3ZWFrIHRoZSBzY2FsZSB0bw0KPiBh
bGxvdyBtb3JlIHBhY2tldHMgYmVpbmcgcXVldWVkLiBZb3UgbmVlZCB0byBjYWxsDQo+IHNrX3Bh
Y2luZ19zaGlmdF91cGRhdGUgc29tZXdoZXJlIGluIGJyY21mbWFjLg0KPiANCj4gVGhhbmtzLA0K
PiAtRnJhbmt5DQpXZSBhcmUgc3RpbGwgaW1wbGVtZW50aW5nIHRoZSBmdW5jdGlvbiBvZiBzZXR0
aW5nIHNrX3BhY2luZ19zaGlmdCBpbg0KYnJjbWZtYWMsIHNvIHRoZSBwYXRjaCB3aWxsIGJlIHN1
Ym1pdHRlZCBpbiBhbm90aGVyIHBhdGNoIHNlcmllcyBvbmNlDQp3ZSBoYXZlIGRvbmUgdGhlIGZ1
bGx5IHRlc3RzLg0KDQotV3JpZ2h0DQo+Pg0KPj4gLVdyaWdodA0KPj4+IFsxXSBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQv
Y29tbWl0Lz9pZD0zYTliNzZmZDBkYjlmDQo+Pj4NCj4+Pj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICBfX3NrYl9xdWV1ZV90YWlsKCZwa3RxLCBwa3QpOw0KPj4+PiAgICAgICAgICAgICAgICAg
ICB9DQo+Pj4+ICAgICAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2JoKCZidXMtPnR4cV9sb2Nr
KTsNCj4+Pj4gLS0NCj4+Pj4gMS45LjENCj4+Pj4NCg==
