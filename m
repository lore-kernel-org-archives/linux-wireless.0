Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9DAC0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 03:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9105420666
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 03:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="IGfCj81q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9105420666
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbeKBMOP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 08:14:15 -0400
Received: from mail-eopbgr810119.outbound.protection.outlook.com ([40.107.81.119]:6211
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbeKBMOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 08:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP+0RXIQAOtXs6nv29BCexVJrNg245v0PdSnb+9Pq2s=;
 b=IGfCj81q/w5h+Hg6O0PZcZld208Sw+IgqmKVSeZTUHedMaZ5VvvVeHK5SyNbCpFd1N/Gjr3aNEzvE16hOLJAd9v2C2Z8m1w1meP0uj5UR8/2/wVSvcFUAPS4SG0xaR0Y9Bmxt4fnb0IS3YJLvQ3e4BKuhQA/QD17Ndh5wUr+WyQ=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB3895.namprd06.prod.outlook.com (52.135.197.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Fri, 2 Nov 2018 03:08:39 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 03:08:39 +0000
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
Thread-Index: AQHUb3H2+mORDXs3gE6Xp6/NyHTPOKU2kYWAgAVCQAA=
Date:   Fri, 2 Nov 2018 03:08:38 +0000
Message-ID: <55fc2684-bd07-95ae-9193-0d383787ebf8@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
 <CA+8PC_f-EMCWnn1oBorAZjNY2xJXcJbhbP+8fU9wYJXnnZto5w@mail.gmail.com>
In-Reply-To: <CA+8PC_f-EMCWnn1oBorAZjNY2xJXcJbhbP+8fU9wYJXnnZto5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYXPR01CA0065.jpnprd01.prod.outlook.com
 (2603:1096:403:a::35) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB3895;6:iAh/0k/DR+kCc+++Pf6oZv6gSR9xkzZkCSAl/U8rsBqS/72h80RO8c+XVxqPzkZtZPe+EgCw1H0p22Z4lPoW1xtxvvwNrtarVIQxphz5aXHNNBvg5QPrPosbUKvgNWub6STeEXHV2VE/RzOdIxO2AkqIz4B/PrcTE0To/wz+LiO0b9AobMmg8peXsp5CRPvJ/hzoEtO9yVis0bNB+AslcMPEF4NMHTLU29DTvfQq0IZU5FJhH1AGqrl89ry47Ylto3HNOnBI599Yahkw7tkArVh0I4ekJ1+8+d56VJiSLW/BREjsMeP4L1gEfvPUM0wbx26iVn6urEgMRraDS82tr0+yYxbpKnMzjFRKg20yKl8YJzuembSvV5bhKoNvnfW8icGV9SPY+MBdenjM77puIgiwTudXDoZc9Xltwyou0Wlo/A6qvAZYuNlnPtDAMM3mINl06+Z6txj9xfQxVpzY3A==;5:V0s2I5vniWe7O+TF1zjnMPbCJmOjC+adOQ9Zl1k0ikHA6hyr9EA01cZqukxEn2ICzXXt3gScuk5KuAG+/E4EYFuOT5Hyz45rQwSDQwGzkscJ52xCwBkmLgO2CAMSUf/0cLmqXh237PLkZTrtHyo0n/+D/TxYxzGUzMbyUmcpbts=;7:soosfvEMrO3CsvEPk6/ogGH4fGXbT7QYzM5cA8H/dgS82THwpyW4ZL386BSSM1hUtc19A64G9QX+9j6ki/xBDxekzMEjrcl0H01kQwbe5ohfI40yBVSR3BewE9HW4Mg8SQYh13l8O1ADbRT65HZxkw==
x-ms-office365-filtering-correlation-id: f138cded-18a4-43c7-acad-08d640707c57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB3895;
x-ms-traffictypediagnostic: BYAPR06MB3895:
x-microsoft-antispam-prvs: <BYAPR06MB3895F9454CE873C3E987102BFBCF0@BYAPR06MB3895.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(60795455431006)(84791874153150)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB3895;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB3895;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(51914003)(71200400001)(446003)(71190400001)(6116002)(3846002)(6246003)(105586002)(6916009)(7736002)(52116002)(106356001)(186003)(14444005)(476003)(486006)(256004)(11346002)(478600001)(2616005)(6506007)(575784001)(6436002)(6486002)(86362001)(36756003)(966005)(14454004)(229853002)(6512007)(2900100001)(316002)(76176011)(386003)(53546011)(31696002)(4326008)(72206003)(25786009)(31686004)(81166006)(26005)(53936002)(8936002)(102836004)(99286004)(81156014)(54906003)(5660300001)(305945005)(6306002)(66066001)(97736004)(8676002)(2906002)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB3895;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: odLhzSCkUUfrt91mwpbksZvlrArAZ40sD0DSPIJ2QcAYVu1yYgyRKtslGGwIkrTpvWKwYge1jQMZq9BaVDyrA2ZFvCX17zqLRy9kkHOolqPlTrqEB9IqfwdQHh4BcXmlorAmZ1z0XSRO8lLOEARK2FpFGjshwmZ+/WP++7Oy2Dhj8fJ1QOmByUzuTZYgYqvGnXC2JCnbLG1RmSj/K/j4G5P9dlk+JMID6EF61NBUgFo/KYm+PQAwEm3Ytmse+/1bVdGGjbamIStE9I5ujb6BH7KCrYFKsAkt0wACzaDlUHv433n2YDFMIryUWNuzz1t2l9XfBGU3FeyASEaWLwJsb8CMsOR1R52JD7nWaoq4Rsg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <84ED087D7E066147B08955834959F0C2@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f138cded-18a4-43c7-acad-08d640707c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 03:08:38.9264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB3895
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTAvMzAg5LiK5Y2IIDAyOjUwLCBGcmFua3kgTGluIHdyb3RlOg0KPiBPbiBN
b24sIE9jdCAyOSwgMjAxOCBhdCAzOjI3IEFNIFdyaWdodCBGZW5nIDxXcmlnaHQuRmVuZ0BjeXBy
ZXNzLmNvbT4gd3JvdGU6DQo+Pg0KPj4gTGludXggMy42IGludHJvZHVjZXMgVFNRIHdoaWNoIGhh
cyBhIHBlciBzb2NrZXQgdGhyZXNob2xkIGZvciBUQ1AgVHgNCj4+IHBhY2tldHMgdG8gcmVkdWNl
IGxhdGVuY3kuIEluIGZjbW9kZSAxIGFuZCBmY21vZGUgMiwgaG9zdCBkcml2ZXIgZW5xdWV1ZXMN
Cj4+IHNrYiBpbiBoYW5nZXIgYW5kIFRDUCBkb2Vzbid0IHB1c2ggbmV3IHNrYiB1bnRpbCBob3N0
IGZyZWVzIHRoZSBza2Igd2hlbg0KPj4gcmVjZWl2aW5nIGZ3c3RhdHVzIGV2ZW50LiBTbyB1c2lu
ZyBza2Jfb3JwaGFuIGJlZm9yZSBzZW5kaW5nIHNrYiB0byBidXMNCj4+IHdpbGwgbWFrZSB0aGUg
c2tiIHJlbW92aW5nIHRoZSBvd25lcnNoaXAgb2Ygc29ja2V0LiBXaXRoIHRoaXMgcGF0Y2gsIHdl
DQo+PiBhcmUgYWJsZSB0byBnZXQgYmV0dGVyIHRocm91Z2hwdXQgaW4gZmNtb2RlIDEgYW5kIGZj
bW9kZSAyLg0KPj4NCj4+IFRlc3RlZCA0MzQ1NSBUQ1AgdGhyb3VnaHB1dCBpbiAyMCBNSHogYmFu
ZHdpZHRoIHdpdGggLyB3aXRob3V0IHRoaXMgcGF0Y2guDQo+PiBmY21vZGUgMDogNTkuNSAvIDU5
LjYgKG1icHMpDQo+PiBmY21vZGUgMTogNTkuMyAvIDIzLjQgKG1icHMpDQo+PiBmY21vZGUgMjog
NTkuNiAvIDIxLjUgKG1icHMpDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcgPHdy
aWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMgfCAxICsNCj4+ICAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5jDQo+PiBpbmRleCBiMmUx
YWI1Li41MTliMjVkIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYw0KPj4gQEAgLTIyOTgsNiArMjI5
OCw3IEBAIHN0YXRpYyB1aW50IGJyY21mX3NkaW9fc2VuZGZyb21xKHN0cnVjdCBicmNtZl9zZGlv
ICpidXMsIHVpbnQgbWF4ZnJhbWVzKQ0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAmcHJlY19vdXQpOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAg
IGlmIChwa3QgPT0gTlVMTCkNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgc2tiX29ycGhhbihwa3QpOw0KPiANCj4g
VFNRIGFsbG93cyBkZXZpY2UgZHJpdmVyIHRvIHR3ZWFrIGZvciBhIGRlZXBlciBxdWV1ZSBub3cu
IFsxXS4gV2UNCj4gc2hvdWxkIHVzZSB0aGF0IGluc3RlYWQgb2Ygb3JwaGFuaW5nIHRoZSBwYWNr
ZXQgYmVmb3JlIGhhbmRpbmcgb3ZlciB0bw0KPiBmaXJtd2FyZSB3aGljaCB3b3VsZCByZW1vdmUg
dGhlIGJ1ZmZlcmJsb2F0IHByb3RlY3Rpb24gYnkgVFNRLg0KPiANCj4gVGhhbmtzLA0KPiAtRnJh
bmt5DQo+IA0KU2luY2UgdGhlIGFnZ3JlZ2F0aW9uIHByb2JsZW0gaGFzIGJlZW4gZml4ZWQgYnkg
c2V0dGluZyBza19wYWNpbmdfc2hpZnQsDQpJIHdpbGwgc3VibWl0IHYyIHdpdGhvdXQgdGhpcyBv
bmUuDQpUaGFua3MgZm9yIHRoZSBpbmZvcm1hdGlvbi4NCg0KLVdyaWdodA0KPiBbMV0gaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXgu
Z2l0L2NvbW1pdC8/aWQ9M2E5Yjc2ZmQwZGI5Zg0KPiANCj4+ICAgICAgICAgICAgICAgICAgICAg
ICAgICBfX3NrYl9xdWV1ZV90YWlsKCZwa3RxLCBwa3QpOw0KPj4gICAgICAgICAgICAgICAgICB9
DQo+PiAgICAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2JoKCZidXMtPnR4cV9sb2NrKTsNCj4+
IC0tDQo+PiAxLjkuMQ0KPj4NCg==
