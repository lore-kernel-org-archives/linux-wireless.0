Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9621C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DF3020859
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:46:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="wRx9NKox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfAGIql (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 03:46:41 -0500
Received: from mail-eopbgr730130.outbound.protection.outlook.com ([40.107.73.130]:40704
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbfAGIql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 03:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqmlmzEs6AIq5EmAwdd1onKljtG77/ADegyJhV4Y/HM=;
 b=wRx9NKoxyM2wXdDtOAXOOyNobAFbhHH49LlmYTCDp86jFYr3BsabTAKv+AIZE0criVZ/ZQBVtHtp5kNkWMNzfUpvBxbD7Vvt8u+E0JVB5haRZfIOgfjtc3Hl0pdjzc26nLHvoDQyhHod7YZT2JZYrOGLeg18GaWdZJYRluqUHMQ=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB4747.namprd06.prod.outlook.com (20.176.112.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.7; Mon, 7 Jan 2019 08:46:38 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 08:46:38 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>
Subject: Re: [PATCH 2/2] brcmfmac: support wake on ping packet
Thread-Topic: [PATCH 2/2] brcmfmac: support wake on ping packet
Thread-Index: AQHUozh3M9VFXGrUaUCguvwg62VMEqWfCHkAgAR8DIA=
Date:   Mon, 7 Jan 2019 08:46:38 +0000
Message-ID: <3c6b9618-32e1-3c6f-4111-964f966e6f2c@cypress.com>
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
 <1546501565-40752-3-git-send-email-chi-hsien.lin@cypress.com>
 <cad34d20-efd1-63c5-6981-cd87794259a4@broadcom.com>
In-Reply-To: <cad34d20-efd1-63c5-6981-cd87794259a4@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: TYAPR01CA0165.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::33) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB4747;6:aN9dzBxwpOCOJK57fJFqpRRvPGgHaZofR8UL+HN13OWHMH2Ut6dlJlWWjxAuUqYJkFp5gJr3/O5nY/PXW64IYLVHktSQD+cE1g20GK2DWqoxmHanwMhuoFLUIWANZe1dUwXbaq/n2HM3hnETWQsev4nW1+THpBqfi4rHO6S+gvPNgKIQSjS4K8HVWgKyRmgt9Cbrr5w6io35q5XwSRJP/VuDAHFtHXPNRuLklEkFqxM4EnQX5Ndo00NdCvHaLrg7RHQ7x9AlFIuWI77qdZoepaZF0J0NB+MNgoV4oFLVWcnNW/IpNDK3OaV595hW4Vny2m8JdTQ4yP3kKnwZ7eGr4L61tEs4gKIy/wv3Lj7FU4QoBBKyXccUdL2iC8kbLnu2i+ZlkUTb2fc4BmiVF1GNJCT4VhSkqrI5F0WuWBo4RhLJ3RGrfJug/hDhrd/DcuU4aG+KQw6MtQOU6TcWfkqa6g==;5:QyoQiwZQv7g46UfYrpsfQMNF0L+DPITjWQxaVRAng/3phaPWKP9o16QPgexhrZLXkYg/U5pTaO8RJQZ0/2ByU5c/6l0hU2BxsJsSLvVpfdOU2igXLoIzZd4Jvrn2qFvJunyvrOI8qeo8Em9ZVhjNhCPiwG22cfIDmAEWZoqZmByRYeoeZPQv15P5EjBtKwbtEGEC6WBECkg+SMkDhPVtZQ==;7:zsNNGMQdewnTL71OlXNrrCat/fqKg0bNE4X1bOgnI5lQfGhkbQyqhh5j0ubPgTRa+mwaGr+8NWFlTAmQiaZxcnQDVmRzepK93sJ4XXeFMCDT4udRv0Ik6sCenkWqswtNbjrUZ7SA3n5VkQfpKqmBtw==
x-ms-office365-filtering-correlation-id: 6a8f93c0-9394-480b-573a-08d6747ca34b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB4747;
x-ms-traffictypediagnostic: DM6PR06MB4747:
x-microsoft-antispam-prvs: <DM6PR06MB4747F4A1AD7554D709BAFDE7BB890@DM6PR06MB4747.namprd06.prod.outlook.com>
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(366004)(39850400004)(189003)(199004)(65826007)(110136005)(81156014)(81166006)(476003)(2906002)(72206003)(14454004)(478600001)(5660300001)(76176011)(43066004)(97736004)(36756003)(6486002)(86362001)(31696002)(64126003)(3450700001)(2501003)(229853002)(25786009)(31686004)(53936002)(6246003)(68736007)(105586002)(107886003)(106356001)(6436002)(305945005)(6512007)(7736002)(71200400001)(486006)(71190400001)(4326008)(6116002)(99286004)(58126008)(66066001)(65806001)(3846002)(186003)(6506007)(26005)(102836004)(14444005)(2616005)(316002)(446003)(11346002)(54906003)(256004)(65956001)(8676002)(386003)(52116002)(53546011)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB4747;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SrHVgmpk2nzWcWw+b9tRA5lR+9Vew+UpSZwjQTL+M5ukpIRQYerOjEI/ja8asWqFDYircTzWNzkIFtecJrnnkuhhTNoaVxkyP3Mr31+0S39U9eV7AAS931mtzm9UBG02AYH1vkEB+iahlrvGGz99d2BaM80SnG70BJrpxkfCa7suJSZOwq5S4aTGgWnGHT7dcPd/N905xg/BGhvR7Kprky9qmDiPDCRyiD59hIiqa3fzEYT5l9WZXKRXV278CJ7fn4+W1Uo4rhLth2bqzfd3BLypJNL2zT9gZSdj5pRCrnCfKpvCSpucd16fq90n6zVE
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2374A9F74D8D141BEB3BE54D337416F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8f93c0-9394-480b-573a-08d6747ca34b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 08:46:38.7331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB4747
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDAxLzA0LzIwMTkgODoxNywgQXJlbmQgVmFuIFNwcmllbCB3cm90ZToNCj4gT24gMS8z
LzIwMTkgODo0NiBBTSwgQ2hpLUhzaWVuIExpbiB3cm90ZToNCj4+IEZyb206IExvLUhzaWFuZyBM
byA8ZG91YmxlLmxvQGN5cHJlc3MuY29tPg0KPj4NCj4+IFNldCB1cCB3aXBoeS0+d293bGFuX2Nv
bmZpZyBhbmQgYSBkdW1teSB3b3dsYW4gZmlsdGVyIHNvIGJyY21mbWFjIGNhbg0KPj4gcmVtYWlu
IGNvbm5lY3RlZCBkdXJpbmcgc3VzcGVuZC4gRW5hYmxlIGFuIHVuaWNhc3QgcGFja2V0IGZpbHRl
ciBkdXJpbmcNCj4+IHN1c3BlbmQgc28gcGluZyBwYWNrZXRzIGNhbiB3YWtlIHVwIHRoZSBzeXN0
ZW0uDQo+IA0KPiBUaGlzIGJhc2ljYWxseSBlbmFibGVzIGEgZGVmYXVsdCB3b3dsYW4gY29uZmln
dXJhdGlvbiwgYnV0IHdoeSBkbyB3ZSANCj4gd2FudCB0aGlzIGluIHRoZSBkcml2ZXIuIFRoZSBz
dHJ1Y3Qgd2lwaHk6Ondvd2xhbl9jb25maWcgbWVtYmVyIGlzIA0KPiBwcmltYXJpbHkgbWFuYWdl
ZCBieSBjZmc4MDIxMSAoc2VlIG5sODAyMTFfc2V0X3dvd2xhbigpKSB1cG9uIHVzZXItc3BhY2Ug
DQo+IHJlcXVlc3QuDQo+IA0KPiBJZiB1c2VyLXNwYWNlIHJlY29uZmlndXJlcyB3aXRoIG5vIHdv
d2xhbiB0cmlnZ2VycyB0aGUgZGVmYXVsdCANCj4gY29uZmlndXJhdGlvbiBpcyBmcmVlZCwgYnV0
IGFzIHdlIGhhdmUgbm8gLnNldF93YWtldXAoKSBjYWxsYmFjayB0aGUgDQo+IGNvbmZpZ3VyYXRp
b24gaW4gZmlybXdhcmUgcmVtYWlucyB1bmNoYW5nZWQgc28gdGhpbmdzIGFyZSBvdXQgb2Ygc3lu
Yy4gDQo+IFNvIEkgd291bGQgZGlzY291cmFnZSB0aGlzIGRlZmF1bHQgYXBwcm9hY2ggYW5kIGp1
c3QgbGV0IHVzZXItc3BhY2UgZGVhbCANCj4gd2l0aCB3b3dsYW4gY29uZmlndXJhdGlvbi4NCg0K
QXJlbmQsDQoNClRoYW5rcyBhIGxvdCBmb3IgdGhlIGZlZWRiYWNrLiBMZXQncyBkcm9wIHRoaXMg
Mi8yIHBhdGNoLiBJJ2xsIHN1Ym1pdCBWMiANCmZvciAxLzIgdG8gZml4IHRoZSB0eXBvcyBKYW1l
cyBwb2ludGVkIG91dC4NCg0KQ2hpLWhzaWVuIExpbg0KDQo+IA0KPiBSZWdhcmRzLA0KPiBBcmVu
ZA0KPiAuDQo+IA0K
