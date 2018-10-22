Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBACEC67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 07:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FF4F20779
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 07:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ACKSYS.onmicrosoft.com header.i=@ACKSYS.onmicrosoft.com header.b="1Edy9EoV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FF4F20779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acksys.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbeJVQF5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 12:05:57 -0400
Received: from mail-ve1eur01on0121.outbound.protection.outlook.com ([104.47.1.121]:4408
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbeJVQF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 12:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ACKSYS.onmicrosoft.com; s=selector1-acksys-fr;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJudsj2795j5Wv2OvfGR7ZuUg0sC7vCN+IqcYGCDFFk=;
 b=1Edy9EoVdUMNttAIBm2KOZ8npjraPPLAd2eSF8BF/qtl4+YfptAZaWqsJE2f3NRAy4nI8haT1WyLXOfgFYZXdJALd9Y65rCw97nC+4yclrlBTB8m+bBo040JxasKygzQbdkJuKZLOwyYqOJ+ulpTNVVGa+c5sjKbUzg2BQYgd04=
Received: from AM4PR0101MB2305.eurprd01.prod.exchangelabs.com (10.165.38.134)
 by AM4PR0101MB2308.eurprd01.prod.exchangelabs.com (10.165.38.137) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1250.30; Mon, 22 Oct
 2018 07:48:28 +0000
Received: from AM4PR0101MB2305.eurprd01.prod.exchangelabs.com
 ([fe80::8506:d3a9:7eb0:7874]) by
 AM4PR0101MB2305.eurprd01.prod.exchangelabs.com
 ([fe80::8506:d3a9:7eb0:7874%2]) with mapi id 15.20.1250.028; Mon, 22 Oct 2018
 07:48:28 +0000
From:   Jean-Pierre TOSONI <jp.tosoni@acksys.fr>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Rate-ctrl experience gained with ath10k
Thread-Topic: Rate-ctrl experience gained with ath10k
Thread-Index: AQHUaKaRx7WuUkQz/0iFKSqLYSDmTqUq5LyA
Date:   Mon, 22 Oct 2018 07:48:28 +0000
Message-ID: <AM4PR0101MB23058D19AE9E95EE33F6FB72E4F40@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <c707767c-8349-6148-d401-c12d30190dec@candelatech.com>
 <5BCB7A83.3050907@candelatech.com>
In-Reply-To: <5BCB7A83.3050907@candelatech.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jp.tosoni@acksys.fr; 
x-originating-ip: [195.6.104.67]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM4PR0101MB2308;6:is1ps/eiuH1yKEahOdh/ccaF0CZbq6B2yp+rlcq4p2wNSeTZWTLwiQl7vECB/qKh5jA522+0ne4l2hlD+ijdUOnjjoUttORjKtVC7DbAG54ABL7/oW+jIxL1//8Kc4v6iBxtFVFy2rhSZd00lhDGLLaqfQu+CWw9ws2rvYgdcEtA7c/wFkObjzDwlaEbA9c/wpWSE7eciTsEVaUgQGyRo3fHDkTExxXbaIWOHiYvVggAYhHZXsGA6+Qu1fXkNIEGj+Zfxc+ANu0oETMoA3+L0En0KM0KaWdoRGH34XZHsqjsDFG3R3bpsOGHaF9FSl1VSnc8mZ/LetSJoNduvJXMn5lNUjZWeveyJRmQLD5nlbDKrhJv5AoU6BdOSUrjOgyBdPnTH4yyjg/BOCAc9VH3Jo5vR3RPsPPgCjcm3gyngHKB59QRZaO2YvQ10D+Bd+mw8uC0bU83Yr9slayOZOFxoQ==;5:Efcj6H3TsMERdZvIGGbtl+ueCod4c2MVufzg3I620BOUuyoN5LpCm9h/qZMDWao977MNFUWJvF8MedIqhZYGHuBHE0IC1TpD/vKx5LrOILYFyQLmCtQ/ewtqCzHjYj9oOObdW0NkXD8RCjqOzErf3ZYiLB1bUbXe0e4Uw8YLmYA=;7:A+gdNGl1ptIuNW8Bj5NGoh2/BYCyT+cCxfQLskV3n/us1nP1B3jQU+NuapiBL2I2iXykQwj1HzGecT2QPigKu5dQOhCRVqlEkjXPpubvtlsmC1e0cfqrC5ZEL+oXnxWT53yW6cQXF99pDsMJuDiOunDEVDV+LIn5rWu4hDkFVb+GDtZMQBrmRrg7iPy8YgpB1tKPQ/LWPWTlctkJ2GpXXHXVaQkqvla4+g6/6zJr29ehBUHlBcFq2xKMo6rqAG+C
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 77b5d016-7897-41a2-6a6b-08d637f2c14a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(7193020);SRVR:AM4PR0101MB2308;
x-ms-traffictypediagnostic: AM4PR0101MB2308:
x-microsoft-antispam-prvs: <AM4PR0101MB23085DE94F84A58A5353CE8FE4F40@AM4PR0101MB2308.eurprd01.prod.exchangelabs.com>
x-exchange-antispam-report-test: UriScan:(9452136761055);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(10201501046)(3231355)(944501410)(4982022)(52105095)(3002001)(93006095)(93001095)(148016)(149066)(150057)(6041310)(2016111802025)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(6043046)(201708071742011)(7699051)(76991095);SRVR:AM4PR0101MB2308;BCL:0;PCL:0;RULEID:;SRVR:AM4PR0101MB2308;
x-forefront-prvs: 08331F819E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39830400003)(376002)(396003)(136003)(189003)(199004)(55784004)(446003)(966005)(110136005)(486006)(476003)(8936002)(11346002)(256004)(14444005)(14454004)(7736002)(81156014)(305945005)(81166006)(8676002)(74316002)(25786009)(86362001)(102836004)(53936002)(26005)(55016002)(6246003)(9686003)(6306002)(6506007)(5660300001)(99286004)(7696005)(71190400001)(71200400001)(3846002)(33656002)(5250100002)(76176011)(53546011)(186003)(316002)(6436002)(66066001)(97736004)(2501003)(2900100001)(508600001)(6116002)(2906002)(106356001)(74482002)(105586002)(229853002)(68736007)(18886065003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0101MB2308;H:AM4PR0101MB2305.eurprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: acksys.fr does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: gnIcC7+JjQlWq8HUcLIRWc4nn/a231X3jWKDZpJEFqSx1C93CFH/sNpGI5Qns/5R3/6ieK2yKGgZFOIZux4Pbuha7c/eSZ/Msngk5bJY0xoP91hAUSxy7F04BpqJAEDIjV/ZOhVq/QDPN/VMW+oBJNoDX1KMWk/+tUh8mCOJpVe1+OV7bA2O0+l/aDUy5g6VRZ+BGhcHMT8llQLofU6Mc1ggdebmrqoMvE0NabChSZ6RsBtf24XirxKMUo7jyJM6Cyst8md9qTha2eQy9PEcBknl+SibPLWM2SuzomDOWDAyOPtx4poQOHuD2Kq4QQLc5Tda+hEeIBnSTcIbtDB7K4uu5RWXiWugr2T/dhmyHHU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: acksys.fr
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b5d016-7897-41a2-6a6b-08d637f2c14a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2018 07:48:28.2515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f18a6414-d5f3-4b5c-9345-f30c01d87e32
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0101MB2308
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgQmVuLA0KDQpKdXN0IGEgcXVpY2sgcmVhY3Rpb246DQoNCkkgZ3Vlc3MgdGhlIGNob2ljZSBz
aG91bGQgbWFpbmx5IGRlcGVuZCBvbiB0aGUgbWVhbiBhaXJ0aW1lIHRvIHRyYW5zbWl0IGEgZnJh
bWUsIG5vdCBvbiB0aGUgZmluYWwgdGhyb3VnaHB1dCwgc2luY2UgaXQgaXMgYSBzaGFyZWQgaGFs
Zi1kdXBsZXggbWVkaWE/DQoNClJldHJhbnNtaXNzaW9uIGlzIGZpbmUgdXAgdG8gdGhlIHBvaW50
IGl0IGRvZXMgbm90IHRha2UgbW9yZSBhaXJ0aW1lIHRoYW4gYSBsb3dlciBNQ1M/DQoNCkplYW4t
UGllcnJlDQoNCj4gLS0tLS1NZXNzYWdlIGQnb3JpZ2luZS0tLS0tDQo+IERlwqA6IGxpbnV4LXdp
cmVsZXNzLW93bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXdpcmVsZXNzLW93bmVy
QHZnZXIua2VybmVsLm9yZ10gRGUgbGEgcGFydCBkZQ0KPiBCZW4gR3JlZWFyDQo+IEVudm95w6nC
oDogc2FtZWRpIDIwIG9jdG9icmUgMjAxOCAyMDo1Nw0KPiDDgMKgOiBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmcNCj4gT2JqZXTCoDogUmU6IFJhdGUtY3RybCBleHBlcmllbmNlIGdhaW5l
ZCB3aXRoIGF0aDEwaw0KPiANCj4gSSBub3cgaGF2ZSB0aGUgOTk4NCBhdGgxMGsgd29ya2luZyBw
cmV0dHkgZ29vZCBJIHRoaW5rLCBhdCBsZWFzdCBhcyBmYXIgYXMNCj4gcmF0ZS1jdHJsIGlzIGdv
aW5nLiAgSXQgdHJpZXMgdG8ga2VlcCByZXRyYW5zbWl0IDwgMTAlIGFuZCB0aHJvdWdocHV0IGlz
DQo+IGZpbmUgY29tcGFyZWQgdG8gdXNpbmcgTUNTIHdpdGggaGlnaGVyIHJldHJhbnNtaXQgKGFu
ZCBoaWdoZXIgZW5jb2RpbmcgcmF0ZXMpLg0KPiANCj4gQnV0LCBJIHRyaWVkIHRvIHB1dCBzaW1p
bGFyIGNoYW5nZXMgKGRvZGdlIGhpZ2ggcmV0cmFuc21pdCBNQ1MgaWYgcG9zc2libGUpLA0KPiBh
bmQgZm9yIHRoZSB3YXZlLTEgOTg4MCBjaGlwLCB0aGlzIGRlY3JlYXNlZCB0aHJvdWdocHV0Lg0K
PiANCj4gRm9yIGluc3RhbmNlLCBjdXJyZW50IHJhdGUtY3RybCB3YXMgcmV0cmFuc21pdHRpbmcg
YWJvdXQgMzAlIG9mIHRoZSBmcmFtZXMNCj4gd2hlbiBhbGxvd2VkIHRvIGNob29zZSBpdHMgTUNT
LiAgSW4gdGhpcyBjYXNlLCBJIHNhdyBhcm91bmQgMjI1LTIzME1icHMgdGhyb3VnaHB1dC4NCj4g
DQo+IEJ1dCwgaWYgSSBmb3JjZWQgaXQgZG93biB0byBNQ1MtNSwgM3gzLCB0aGVuIHRocm91Z2hw
dXQgd2FzIGFib3V0IDIyME1icHMsIGFuZA0KPiByZXRyeSBwZXJjZW50IHdhcyBjbG9zZXIgdG8g
MiUuDQo+IA0KPiBTbywgcXVlc3Rpb24gaXMuLi5zaG91bGQgSSBzdGlsbCB0d2VhayBpdHMgcmF0
ZWN0cmwgdG8gY2hvb3NlIGxvd2VyIE1DUyB3aGVuDQo+IHJldHJhbnNtaXQgJSBpcyBoaWdoLCBv
ciBzaG91bGQgSSBqdXN0IGxldCBpdCByZXRyYW5zbWl0LiAgTWF5YmUgbG93ZXIgTUNTIGFuZCBs
b3dlcg0KPiByZXRyYW5zbWl0IHdvdWxkIGJlIGJldHRlciBvdmVyLWFsbCBpZiB0aGVyZSBhcmUg
bG90cyBvZiBkZXZpY2VzIG9uIHRoZSBuZXR3b3JrPw0KPiANCj4gSSdsbCBydW4gc29tZSB0ZXN0
cyB0byBleHBlcmltZW50IHdpdGggdGhhdCB3aGVuIEkgaGF2ZSB0aW1lLCBidXQgY3VyaW91cyBp
ZiBvdGhlcnMNCj4gaGF2ZSBhbHJlYWR5IGRvbmUgc2ltaWxhci4uLg0KPiANCj4gVGhhbmtzLA0K
PiBCZW4NCj4gDQo+IA0KPiBPbiAxMC8xNi8yMDE4IDA0OjMxIFBNLCBCZW4gR3JlZWFyIHdyb3Rl
Og0KPiA+IFNvLCBJJ3ZlIGJlZW4gdHJ5aW5nIHRvIHVuZGVyc3RhbmQgd2h5IHRoZSBhdGgxMGst
cmF0ZSBjdHJsIHdhcyBhY3RpbmcNCj4gPiBzbyBwb29ybHkgaW4gbXkgMjAtc3RhdGlvbiBVRFAg
dHggY2FzZS4gIEkgd3JvdGUgdGhhdCB3aWZpLWRpYWcgdG9vbCwNCj4gPiBhbmQgaXQgZ2F2ZSBz
b21lIGNsdWVzLCBidXQgb25seSBpbiByZXRyb3NwZWN0IHdlcmUgdGhleSBvYnZpb3VzIDopDQo+
ID4NCj4gPiBUaGUgcHJvYmxlbSBpbiBnZW5lcmFsIHdhcyB0aGF0IGEgc2luZ2xlIHN0YXRpb24g
Y291bGQgdXBsb2FkLCBhdCBzYXkgNTAwTWJwcywNCj4gPiBidXQgMjAgc3RhdGlvbnMgY291bGQg
b25seSBkbyBhYm91dCAzMjVNYnBzLiAgSWYgd2UgZml4ZWQgdGhlIE1DUyBhdCAzeDMgTUNTNywN
Cj4gPiB0aGVuIHRoZSAyMCBzdGF0aW9uIHVwbG9hZCB0ZXN0IHJhbiBhYm91dCA0OTBNYnBzLg0K
PiA+DQo+ID4gVGhlcmUgd2VyZSBzZXZlcmFsIG9wdGltaXphdGlvbnMgSSBtYWRlIGluIHRoZSBh
dGgxMGsgZmlybXdhcmUgcmF0ZS1jdHJsLiAgT25lDQo+ID4gd2FzIHRvIHBlbmFsaXplIHJhdGVz
IHdpdGggaGlnaGVyIFBFUiAocGFja2V0IGVycm9yIHJhdGUpIG1vcmUgdGhhbiB0aGUgb2xkIGFs
Z29yaXRobSBkaWQuICBUaGlzDQo+IGhlbHBlZA0KPiA+IGEgc21hbGwgYml0LCBidXQgbm90IGVu
b3VnaCAoYXJvdW5kIDM1MC0zNzBNYnBzIHRvdGFsIHRocm91Z2hwdXQpLg0KPiA+DQo+ID4gVGhl
biwgYWZ0ZXIgYWRkaW5nIGxvZ3MgSSBub3RpY2VkIHRoYXQgZWFjaCBzdGF0aW9uIHdhcyBwcm9i
aW5nIG9uY2UgYWJvdXQgZXZlcnkgNSBhbXBkdQ0KPiA+IGNoYWlucywgb3IgYWxtb3N0IDIwJSBv
ZiB0aGUgdGltZSEgIFRoZXNlIHByb2JlIEFNUERVcyBhcmUgbGltaXRlZCB0byBhIG1heCBvZiA0
IEFNU0RVcywNCj4gPiBhbmQgdGhhdCBleHBsYWlucyB3aHkgbXkgJ2JhZCcgY2FzZSBzaG93ZWQg
MTclIG9mIHRoZSBBTVBEVSBjaGFpbnMgd2VyZSA0IGluIGxlbmd0aCBpbg0KPiA+IG15IHdpZmkt
ZGlhZyBvdXRwdXQuDQo+ID4NCj4gPiBJIGNoYW5nZWQgdGhlIGZpcm13YXJlIHRvIHRha2UgbnVt
YmVyIG9mIGFjdGl2ZSBzdGF0aW9ucyBpbnRvIGFjY291bnQsIGFuZCBpbmNyZWFzZSB0aGUNCj4g
PiA3NW1zIHByb2JlIGludGVydmFsIGJ5IHVwIHRvIGEgZmFjdG9yIG9mIDUuICBJIGFsc28gcHJv
YmUgbGVzcyBvZnRlbiB3aGVuIHRoZSBwcm9iZWQNCj4gPiByYXRlIGhhcyBQRVIgPiA1IG9yIHRo
ZSBsYXN0IHByb2JlIGhhZCBhIGRyb3BwZWQgZnJhbWUuDQo+ID4NCj4gPiBBbmQsIEkgYWxsb3cg
cHJvYmluZyB3aXRoIEFNUERVIGNoYWlucyBvZiB1cCB0byAxNiBBTVNEVSBpbnN0ZWFkIG9mIGp1
c3QgNC4NCj4gPg0KPiA+IFRvZ2V0aGVyIHRoaXMgZ2V0cyBtZSB1cCB0byBhYm91dCA0NjBNYnBz
IGluIHRoaXMgdGVzdCBjYXNlLiAgIFN0aWxsIG5vdCBxdWl0ZSBhcyBnb29kDQo+ID4gYXMgZml4
aW5nIHRoZSBNQ1MgYXQgNywgYnV0IGdvb2QgZW5vdWdoIEkgdGhpbmsuDQo+ID4NCj4gPiBIZXJl
J3MgaG9waW5nIHRoaXMgZW1haWwgd2lsbCBsZXQgb3RoZXIgZm9sa3MgcG9raW5nIGF0IHJhdGUt
Y3RybCBoYXZlIGEgZmFzdGVyDQo+ID4gdGltZSBhdCBmaXhpbmcgdGhpbmdzIHRoYW4gSSBkaWQu
DQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gQmVuDQo+ID4NCj4gDQo+IA0KPiAtLQ0KPiBCZW4gR3Jl
ZWFyIDxncmVlYXJiQGNhbmRlbGF0ZWNoLmNvbT4NCj4gQ2FuZGVsYSBUZWNobm9sb2dpZXMgSW5j
ICBodHRwOi8vd3d3LmNhbmRlbGF0ZWNoLmNvbQ0KDQo=
