Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18D7C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 02:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD9820871
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 02:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="WLtbWJKM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DD9820871
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbeKLMBr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 07:01:47 -0500
Received: from mail-eopbgr690126.outbound.protection.outlook.com ([40.107.69.126]:38552
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbeKLMBr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 07:01:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLhf0IJon0MPtxX04UPqGublIxnhg79DBBh88U5GvxM=;
 b=WLtbWJKM8NTk/hgmIezsa3PzCbsu/vFqzNIBbXwppB4jTDuEQkJJVBrUALGYO8JWevUtyDnDyeShBGy+lzfTFpIpkFT+j+qfhSE8IHe8aaHC9h93ilk43xJDa4hI4lu0BSy4a++yJEgn7VnHt0QksLGD0IISCvUAq/+K2Vwg7f0=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4200.namprd06.prod.outlook.com (52.135.238.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.31; Mon, 12 Nov 2018 02:10:07 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 02:10:07 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
CC:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from
 "brcmf_netdev_stop"
Thread-Topic: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from
 "brcmf_netdev_stop"
Thread-Index: AQHUdxXd/1FJU+KxcUCC+9i3QchU16VGQbSAgAUpwIA=
Date:   Mon, 12 Nov 2018 02:10:07 +0000
Message-ID: <f2024bf8-5a1f-1f68-1f1a-aa300c8ce17f@cypress.com>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-3-git-send-email-chi-hsien.lin@cypress.com>
 <CA+8PC_fZ8u+ii_6vdvuLSqszzFcNzhd6dz-AHGR6tByfAgPgcg@mail.gmail.com>
In-Reply-To: <CA+8PC_fZ8u+ii_6vdvuLSqszzFcNzhd6dz-AHGR6tByfAgPgcg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TY2PR01CA0022.jpnprd01.prod.outlook.com
 (2603:1096:404:a::34) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4200;6:SGrpMTRoqjXr7wXrRvrH3rJ+A+5iOSDuLJX3+L4M/lOtM3/D0vjIVPAbhezxuoXS6/KmZTtLalECi0pgvUuFBsaOrZlAz8viXw6cZIc1hy6SfQaicW2hUDSbpOMkhxnBFsoduJSCcdf+7w629VN9YShFDflrA3cbw54JVqvAQonj8EkxfqSy/8EYh5ojEHVC8ATbfMI7AtT0OjvCYjVy/0Kmb8HXePTaPnMZ70A5P2hLNmxUHTsdwvm5xtWwIs5KaRKf97ody/i7DDx5QJAPivZEFWkIycr8eIIoOO+RY4PeaC+mufZ/zxVcdTC4MwRvrNBTeb0SCJ6paStwBWvnxGKeYMP6CZmsX5hhDHbEKLETwH+1ocxknSReB1xg0l8jxZSuJYZ8vevNJuZzWqAaySj7Fsn/wMTZDP74O7kurwFMXwjBDREbItQlGGDb+bRRocyuXBDHMHzwtWpuI/xfGQ==;5:I/HBhVKndPri8DV4wUP7hTXF/jVHPTZcgD59kxb3p71/+EPRl1eRiWCqYMPeg1GfqGiEYl+4hLM8LQGaFyzoLHvgWHNl6BJolW0ekqmk10mNyXKUMQ7FqOcOmjMx+rgD6kiMOyNPBC348D+rdWBjvyO2kfANEgQ1mFdhN2PRg+4=;7:aGy/aH94zr2rUR0ItoncWL3blo8QSEh2Thn3pIRPkSEOw49mLn10lfMwP+NNmoFclG/dybRzVWeo1xnN0raDTFJ7hrz6c5oycTWSw0eIoLMnJz6n7DPwpUBJrzK4Wpa4BwcOmJalWuIf6kTtMebeyg==
x-ms-office365-filtering-correlation-id: 67fbfb19-4df5-490c-de50-08d64843f779
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4200;
x-ms-traffictypediagnostic: BYAPR06MB4200:
x-microsoft-antispam-prvs: <BYAPR06MB4200EE46E4C81209E419D8DBFBC10@BYAPR06MB4200.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(3231382)(944501410)(52105112)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4200;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4200;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(5660300001)(54906003)(110136005)(66066001)(316002)(2906002)(8676002)(31696002)(14454004)(81156014)(81166006)(53936002)(86362001)(72206003)(36756003)(8936002)(3846002)(6116002)(6636002)(305945005)(68736007)(478600001)(6512007)(26005)(7736002)(11346002)(446003)(386003)(6506007)(53546011)(52116002)(76176011)(106356001)(102836004)(71200400001)(71190400001)(186003)(6436002)(105586002)(6246003)(229853002)(4326008)(6486002)(25786009)(99286004)(2616005)(97736004)(486006)(256004)(14444005)(31686004)(2900100001)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4200;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: LQZioFk199zIh3SXltqWgYkQSMjL6HgTzYhjLu9QnuNVQomksC1Qy1mtBTqY08ygRYL/a+Szz6dHaI/UgfqhGVYtY1fGJE/TMVWLk6y9JNnPOKUsEKZHIC7Ve8VNTNPe2maz6WttJ0fzL5XbrwOz66GTFgRiDlywn4TGSh56YjKVnFXFmgud+v+QkYy9lgpn6lFANpeMe4E1enMxgcUwLh8lRQNRAh9qBMX2S0Rth1pJaQLfsdrzXfrbirvyI/wyY0nm1+syKKG0dmdnUezUz7HTnSAIQWWojuNs/p1fu+bD/UF3OtHuWk0dkUzYJUpkpKqjCyZSLl1CHhmO7OKTBsuK7BrmBf4S586M1o7V2Wg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FDA1083DE18B74CA1F1405DFB2537AB@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67fbfb19-4df5-490c-de50-08d64843f779
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 02:10:07.3923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4200
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIwMTgvMTEvOSDkuIrljYggMDM6MTksIEZyYW5reSBMaW4gd3JvdGU6DQo+IE9uIFdl
ZCwgTm92IDcsIDIwMTggYXQgNzo0OCBQTSBDaGktSHNpZW4gTGluIDxDaGktSHNpZW4uTGluQGN5
cHJlc3MuY29tPiB3cm90ZToNCj4+DQo+PiBGcm9tOiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdA
Y3lwcmVzcy5jb20+DQo+Pg0KPj4gVGhlIGZpcm13YXJlIGRvZXMgbm90IHJlc3BvbmQgQVJQIHJl
cXVlc3QgYW5kIGNhdXNlcyBwaW5nIGZhaWx1cmUgd2l0aA0KPj4gZm9sbG93aW5nIHN0ZXBzOg0K
Pj4NCj4+IDEuIEJyaW5nIHVwIGludGVyZmFjZQ0KPj4gICAgIGlmY29uZmlnIHdsYW4wIHVwIG9y
IHN0YXJ0IHdwYV9zdXBwbGljYW50DQo+PiAyLiBTZXQgdGhlIElQIGFkZHJlc3MNCj4+ICAgICBp
ZmNvbmZpZyB3bGFuMCAxOTIuMTY4LjEwMC4xMA0KPj4gMy4gQnJpbmcgZG93biBpbnRlcmZhY2Ug
b3INCj4+ICAgICBpZmNvbmZpZyB3bGFuMCBkb3duIG9yIGtpbGwgd3BhX3N1cHBsaWNhbnQNCj4+
IDQuIEJyaW5nIHVwIGludGVyZmFjZSBhZ2FpbiBhbmQgc2V0IHRoZSBzYW1lIElQIGFkZHJlc3MN
Cj4+IDUuIENvbm5lY3QgdG8gQVAoMTkyLjE2OC4xMDAuMSkgYW5kIHBpbmcgdG8gQVAgd2lsbCBi
ZSBmYWlsZWQuDQo+Pg0KPj4gRk1BQyBjbGVhcnMgYXJwX2hvc3RpcCB3aGVuIGJyaW5naW5nIGRv
d24gdGhlIGludGVyZmFjZSwgYnV0IG5vdCBzZXQgaXQNCj4+IGJhY2sgaWYgc2V0dGluZyB0aGUg
c2FtZSBJUCBhZGRyZXNzLiBXZSBhcmUgYWJsZSB0byBzZWUgdGhlIElQIGFkZHJlc3MNCj4+IGlu
IGludGVyZmFjZSBpbmZvKGluY29uZmlnIHdsYW4wKSBidXQgdGhlIHBpbmcgc3RpbGwgY2Fubm90
IHdvcmsgYmVjYXVzZQ0KPj4gdGhlIGZpcm13YXJlIEFSUCBvZmZsb2FkIGRvZXMgbm90IHJlc3Bv
bmQgdGhlIEFSUCByZXF1ZXN0Lg0KPj4gQmVjYXVzZSBvZiB0aGF0LCB3ZSByZW1vdmUgImFycF9o
b3N0aXBfY2xlYXIiIGZyb20gZnVuY3Rpb24NCj4+ICJicmNtZl9uZXRkZXZfc3RvcCINCj4gDQo+
IFNob3VsZG4ndCBicmNtZl9pbmV0YWRkcl9jaGFuZ2VkIGdldCBjYWxsZWQgd2hlbiB0aGUgaW50
ZXJmYWNlIHVwIGFnYWluPw0KPiANCj4gVGhhbmtzLA0KPiAtIEZyYW5reQ0KPiANClRoZSBicmNt
Zl9pbmV0YWRkcl9jaGFuZ2VkIG9ubHkgYmUgY2FsbGVkIGluIGluZXRfZGVsX2lmYSBhbmQNCmlu
ZXRfaW5zZXJ0X2lmYS4gSWYgdGhlIElQIGFkZHJlc3MgaXMgbm90IGNoYW5nZWQgd2hlbiB0aGUg
aW50ZXJmYWNlIHVwDQphZ2FpbiwgdGhlIGJyY21mX2luZXRhZGRyX2NoYW5nZWQgd2lsbCBub3Qg
YmUgY2FsbGVkLg0KDQotV3JpZ2h0DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcg
PHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hpLUhzaWVuIExp
biA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29yZS5jIHwgMiAtLQ0KPj4gICAx
IGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NvcmUuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb3JlLmMNCj4+IGlu
ZGV4IGIxZjcwMmZhZmY0Zi4uZTE2NjZjZjM4MDFjIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NvcmUuYw0KPj4gKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NvcmUuYw0K
Pj4gQEAgLTUzMyw4ICs1MzMsNiBAQCBzdGF0aWMgaW50IGJyY21mX25ldGRldl9zdG9wKHN0cnVj
dCBuZXRfZGV2aWNlICpuZGV2KQ0KPj4NCj4+ICAgICAgICAgIGJyY21mX2NmZzgwMjExX2Rvd24o
bmRldik7DQo+Pg0KPj4gLSAgICAgICBicmNtZl9maWxfaW92YXJfZGF0YV9zZXQoaWZwLCAiYXJw
X2hvc3RpcF9jbGVhciIsIE5VTEwsIDApOw0KPj4gLQ0KPj4gICAgICAgICAgYnJjbWZfbmV0X3Nl
dGNhcnJpZXIoaWZwLCBmYWxzZSk7DQo+Pg0KPj4gICAgICAgICAgcmV0dXJuIDA7DQo+PiAtLQ0K
Pj4gMi4xLjANCj4+DQo+IA0KPiANCj4gLS0tLS0tLS0tLQ0KPiANCj4gWW91J3JlIHJlY2Vpdmlu
ZyB0aGlzIG1lc3NhZ2UgYmVjYXVzZSB5b3UncmUgYSBtZW1iZXIgb2YgdGhlIGJyY204MDIxMS1k
ZXYtbGlzdCBncm91cC4NCj4gDQo=
