Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7A5C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 22:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E66A420859
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 22:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wavesemi.onmicrosoft.com header.i=@wavesemi.onmicrosoft.com header.b="TE/ytqf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfAIWTS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 17:19:18 -0500
Received: from mail-eopbgr760101.outbound.protection.outlook.com ([40.107.76.101]:48974
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbfAIWTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 17:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavecomp-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPezSIEBus3c+GXaL0b0ixVd1P7wz/O0cFIJdFNKQkM=;
 b=TE/ytqf9SlYPiRecp3Ouqn0JmDpkZ9eOWgQkQI0hXK0I/8psGBQiH2YPauHwQnf8SMW3+E1OAXBdBtWv6OvvvoZJ7FHfy5CKzohkVpnhXDQZSklyQmRB+jWXMlEiuSzEGNbhgNn0oE81zy4UmaMexsaD7W/GZryD5BJmknmM/1E=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHSPR00MB2400.namprd22.prod.outlook.com (10.171.151.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.13; Wed, 9 Jan 2019 22:19:13 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::595e:ffcc:435b:9110]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::595e:ffcc:435b:9110%4]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 22:19:13 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC:     Paul Burton <pburton@wavecomp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH V2 mips-fixes] MIPS: BCM47XX: Setup struct device for the
 SoC
Thread-Topic: [PATCH V2 mips-fixes] MIPS: BCM47XX: Setup struct device for the
 SoC
Thread-Index: AQHUozbEHjvX8vfLkEO5krYUFUmf+qWnjEOA
Date:   Wed, 9 Jan 2019 22:19:12 +0000
Message-ID: <MWHPR2201MB1277BD8E73762956F2D100C4C18B0@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190103073417.24135-1-zajec5@gmail.com>
In-Reply-To: <20190103073417.24135-1-zajec5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.99.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHSPR00MB2400;6:/aYlYvAiYC1xfb8RB61+4DAEjyrFF0aBBM4d6exSFfpfqVEmohbcwCm/Cz7FdoaSJl5pqxYcmIxdpUPY0mY0FZlqoPRlZpL1SI9n0QdtMc5GjLKjbySVOc9niN6oKFlYOHTIJXfNRBjex0JmqAiekoIpW5GFHktyP9rpSaTuHTySLskVKU91dU0bKGRB0J2niwdzvdon/dODyThFksJkD3tj/XQW8q7BhxXoLA8r5kQ9cq6lCaBmhgLvJ0AYd127rXBkANlR8T4wgTt9uMIgqVra8Tp1cVzo0LbpjxskV0RDVBCrjeEZTFrfvyx5TEaDMQG5IsB5tGpf1UrlSlkaKIxnxXPi0SjlhuY+xXyH/+CarY643/galzFNW0oTithgflV8BAzctLSZcNljKIk8mvw3FnNCFkBOGn4kwObSzXTm420FUEfvh5L7T8ZCBeP5vTd8aSDEAPGkz8PBtLUmSg==;5:dNDC2lzEYMeKbwVB6X3xKNwYuZXmZGK6rVODJqrWd/r/37gcjnNtwY4QqyzyDgLR+n5E/ijtCHElco9VT3PtKpPYfpodsXbl2o5ur3c89b97wCxaAaLiHq0acST0D45GpYgmTaKEs6xFnkqWHMd6BShMPUA7KPi1MxkSgLX4BcB+bq6qDqptrdcL1Y8oI7OCMNwS9+oQQhXveg6Ooyy/BQ==;7:D7SJFg/rF3vUMazqf9Bd70Jj5xDkC2xsW81GhI7p36/tH4QyPlzmlmPLVmL4zzGfqifeNDFwYrEyUy6Fp+YuzLhFn8ZJWDYBxT5OnZSTiqi6++VLj6Bba/N3KO/xgi8aa5eYmurGkhxFnvQip+RURw==
x-ms-office365-filtering-correlation-id: 294a3c48-5777-421e-7c4f-08d676807be9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHSPR00MB2400;
x-ms-traffictypediagnostic: MWHSPR00MB2400:
x-microsoft-antispam-prvs: <MWHSPR00MB24007B0E489F8E1469B2494DC18B0@MWHSPR00MB2400.namprd22.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39840400004)(376002)(346002)(396003)(189003)(199004)(76176011)(54906003)(8936002)(7696005)(106356001)(3846002)(6116002)(97736004)(74316002)(14454004)(7416002)(52116002)(105586002)(316002)(26005)(6506007)(386003)(42882007)(186003)(476003)(102836004)(11346002)(446003)(99286004)(256004)(5024004)(14444005)(44832011)(25786009)(66066001)(486006)(478600001)(1411001)(4326008)(39060400002)(71200400001)(71190400001)(6436002)(6246003)(55016002)(305945005)(45080400002)(229853002)(7736002)(8676002)(6916009)(81166006)(81156014)(5660300001)(2906002)(66574012)(53936002)(9686003)(68736007)(33656002)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHSPR00MB2400;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Pv4pw5SHzRIbXgEhk7VEPVVsDebQuhab0NKbfXTFAgdLNSegTOrQmXqIz5zl61VedOFwnRiwWKSCnbpD7pd2mSYiNMi3ApQ6H5GyjwsCaempD8IPqxZzygmonK1ZS0mMbBMVsaxUJ+S7wLfk5vGqVm3pwh1imqQltooyHMxbqtzK/QfB3wkzZItWroC0cYvDxd4FGJnWt+4EL/Bdd7Xmlwr4pzcAEen42OARWzLcgpFFOgnvE22GWoPUe1ZChIK2JkBfVsILE00KRB8xgiE+7QHTOixPv+EAJymzKOwI+njNBE/16DNV4RRDDJhxQtDo
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294a3c48-5777-421e-7c4f-08d676807be9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 22:19:13.0347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB2400
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGVsbG8sDQoNClJhZmHFgiBNacWCZWNraSB3cm90ZToNCj4gRnJvbTogUmFmYcWCIE1pxYJlY2tp
IDxyYWZhbEBtaWxlY2tpLnBsPg0KPiANCj4gU28gZmFyIHdlIG5ldmVyIGhhZCBhbnkgZGV2aWNl
IHJlZ2lzdGVyZWQgZm9yIHRoZSBTb0MuIFRoaXMgcmVzdWx0ZWQgaW4NCj4gc29tZSBzbWFsbCBp
c3N1ZXMgdGhhdCB3ZSBrZXB0IGlnbm9yaW5nIGxpa2U6DQo+IDEpIE5vdCB3b3JraW5nIEdQSU9M
SUJfSVJRQ0hJUCAoZ3Bpb2NoaXBfaXJxY2hpcF9hZGRfa2V5KCkgZmFpbGluZykNCj4gMikgTGFj
ayBvZiBwcm9wZXIgdHJlZSBpbiB0aGUgL3N5cy9kZXZpY2VzLw0KPiAzKSBtaXBzX2RtYV9hbGxv
Y19jb2hlcmVudCgpIHNpbGVudGx5IGhhbmRsaW5nIGVtcHR5IGNvaGVyZW50X2RtYV9tYXNrDQo+
IA0KPiBLZXJuZWwgNC4xOSBjYW1lIHdpdGggYSBsb3Qgb2YgRE1BIGNoYW5nZXMgYW5kIGNhdXNl
ZCBhIHJlZ3Jlc3Npb24gb24NCj4gYmNtNDd4eC4gU3RhcnRpbmcgd2l0aCB0aGUgY29tbWl0IGY4
YzU1ZGM2ZTgyOCAoIk1JUFM6IHVzZSBnZW5lcmljIGRtYQ0KPiBub25jb2hlcmVudCBvcHMgZm9y
IHNpbXBsZSBub25jb2hlcmVudCBwbGF0Zm9ybXMiKSBETUEgY29oZXJlbnQNCj4gYWxsb2NhdGlv
bnMganVzdCBmYWlsLiBFeGFtcGxlOg0KPiBbICAgIDEuMTE0OTE0XSBiZ21hY19iY21hIGJjbWEw
OjI6IEFsbG9jYXRpb24gb2YgVFggcmluZyAweDIwMCBmYWlsZWQNCj4gWyAgICAxLjEyMTIxNV0g
YmdtYWNfYmNtYSBiY21hMDoyOiBVbmFibGUgdG8gYWxsb2MgbWVtb3J5IGZvciBETUENCj4gWyAg
ICAxLjEyNzYyNl0gYmdtYWNfYmNtYTogcHJvYmUgb2YgYmNtYTA6MiBmYWlsZWQgd2l0aCBlcnJv
ciAtMTINCj4gWyAgICAxLjEzMzgzOF0gYmdtYWNfYmNtYTogQnJvYWRjb20gNDd4eCBHQml0IE1B
QyBkcml2ZXIgbG9hZGVkDQo+IA0KPiBUaGUgYmdtYWMgZHJpdmVyIGFsc28gdHJpZ2dlcnMgYSBX
QVJOSU5HOg0KPiBbICAgIDAuOTU5NDg2XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0NCj4gWyAgICAwLjk2NDM4N10gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAuL2luY2x1
ZGUvbGludXgvZG1hLW1hcHBpbmcuaDo1MTYgYmdtYWNfZW5ldF9wcm9iZSsweDFiNC8weDVjNA0K
PiBbICAgIDAuOTczNzUxXSBNb2R1bGVzIGxpbmtlZCBpbjoNCj4gWyAgICAwLjk3NjkxM10gQ1BV
OiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDQuMTkuOSAjMA0KPiBbICAgIDAu
OTgyNzUwXSBTdGFjayA6IDgwNGEwMDAwIDgwNDU5N2M0IDAwMDAwMDAwIDAwMDAwMDAwIDgwNDU4
ZmQ4IDgzODFiYzJjIDgzODI4MmQ0IDgwNDgxYTQ3DQo+IFsgICAgMC45OTEzNjddICAgICAgICAg
ODA0MmUzZWMgMDAwMDAwMDEgODA0ZDM4ZjAgMDAwMDAyMDQgODM5ODAwMDAgMDAwMDAwNjUgODM4
MWJiZTAgNmY1NWIyNGYNCj4gWyAgICAwLjk5OTk3NV0gICAgICAgICAwMDAwMDAwMCAwMDAwMDAw
MCA4MDUyMDAwMCAwMDAwMjAxOCAwMDAwMDAwMCAwMDAwMDA3NSAwMDAwMDAwNyAwMDAwMDAwMA0K
PiBbICAgIDEuMDA4NTgzXSAgICAgICAgIDAwMDAwMDAwIDgwNDgwMDAwIDAwMGVlODExIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDgwNDMyYzAwIDgwMjQ4ZGI4DQo+IFsgICAgMS4wMTcxOTZd
ICAgICAgICAgMDAwMDAwMDkgMDAwMDAyMDQgODM5ODAwMDAgODAzYWQ3YjAgMDAwMDAwMDAgODAx
ZmVlZWMgMDAwMDAwMDAgODA0ZDAwMDANCj4gWyAgICAxLjAyNTgwNF0gICAgICAgICAuLi4NCj4g
WyAgICAxLjAyODMyNV0gQ2FsbCBUcmFjZToNCj4gWyAgICAxLjAzMDg3NV0gWzw4MDAwYWVmOD5d
IHNob3dfc3RhY2srMHg1OC8weDEwMA0KPiBbICAgIDEuMDM1NTEzXSBbPDgwMDFmOGI0Pl0gX193
YXJuKzB4ZTQvMHgxMTgNCj4gWyAgICAxLjAzOTcwOF0gWzw4MDAxZjlhND5dIHdhcm5fc2xvd3Bh
dGhfbnVsbCsweDQ4LzB4NjQNCj4gWyAgICAxLjA0NDkzNV0gWzw4MDI0OGRiOD5dIGJnbWFjX2Vu
ZXRfcHJvYmUrMHgxYjQvMHg1YzQNCj4gWyAgICAxLjA1MDEwMV0gWzw4MDI0OThlMD5dIGJnbWFj
X3Byb2JlKzB4NTU4LzB4NTkwDQo+IFsgICAgMS4wNTQ5MDZdIFs8ODAyNTJmZDA+XSBiY21hX2Rl
dmljZV9wcm9iZSsweDM4LzB4NzANCj4gWyAgICAxLjA2MDAxN10gWzw4MDIwZTFlOD5dIHJlYWxs
eV9wcm9iZSsweDE3MC8weDJlOA0KPiBbICAgIDEuMDY0ODkxXSBbPDgwMjBlNzE0Pl0gX19kcml2
ZXJfYXR0YWNoKzB4YTQvMHhlYw0KPiBbICAgIDEuMDY5Nzg0XSBbPDgwMjBjMWUwPl0gYnVzX2Zv
cl9lYWNoX2RldisweDU4LzB4YjANCj4gWyAgICAxLjA3NDgzM10gWzw4MDIwZDU5MD5dIGJ1c19h
ZGRfZHJpdmVyKzB4ZjgvMHgyMTgNCj4gWyAgICAxLjA3OTczMV0gWzw4MDIwZWYyND5dIGRyaXZl
cl9yZWdpc3RlcisweGNjLzB4MTFjDQo+IFsgICAgMS4wODQ4MDRdIFs8ODA0YjU0Y2M+XSBiZ21h
Y19pbml0KzB4MWMvMHg0NA0KPiBbICAgIDEuMDg5MjU4XSBbPDgwMDAxMjFjPl0gZG9fb25lX2lu
aXRjYWxsKzB4N2MvMHgxYTANCj4gWyAgICAxLjA5NDM0M10gWzw4MDRhMWQzND5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MTUwLzB4MjE4DQo+IFsgICAgMS4wOTk4ODZdIFs8ODAzYTA4MmM+XSBr
ZXJuZWxfaW5pdCsweDEwLzB4MTA0DQo+IFsgICAgMS4xMDQ1ODNdIFs8ODAwMDU4Nzg+XSByZXRf
ZnJvbV9rZXJuZWxfdGhyZWFkKzB4MTQvMHgxYw0KPiBbICAgIDEuMTEwMTA3XSAtLS1bIGVuZCB0
cmFjZSBmNDQxYzBkODczZDFmYjViIF0tLS0NCj4gDQo+IFRoaXMgcGF0Y2ggc2V0dXBzIGEgInN0
cnVjdCBkZXZpY2UiIChhbmQgcGFzc2VzIGl0IHRvIHRoZSBiY21hKSB3aGljaA0KPiBhbGxvd3Mg
Zml4aW5nIGFsbCB0aGUgbWVudGlvbmVkIHByb2JsZW1zLiBJdCdsbCBhbHNvIHJlcXVpcmUgYSB0
aW55IGJjbWENCj4gcGF0Y2ggd2hpY2ggd2lsbCBmb2xsb3cgdGhyb3VnaCB0aGUgd2lyZWxlc3Mg
dHJlZSAmIGl0cyBtYWludGFpbmVyLg0KPiANCj4gRml4ZXM6IGY4YzU1ZGM2ZTgyOCAoIk1JUFM6
IHVzZSBnZW5lcmljIGRtYSBub25jb2hlcmVudCBvcHMgZm9yIHNpbXBsZSBub25jb2hlcmVudCBw
bGF0Zm9ybXMiKQ0KPiBDYzogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IENjOiBM
aW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+DQo+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NC4x
OSsNCj4gU2lnbmVkLW9mZi1ieTogUmFmYcWCIE1pxYJlY2tpIDxyYWZhbEBtaWxlY2tpLnBsPg0K
PiBBY2tlZC1ieTogSGF1a2UgTWVocnRlbnMgPGhhdWtlQGhhdWtlLW0uZGU+DQoNCkFwcGxpZWQg
dG8gbWlwcy1maXhlcy4NCg0KVGhhbmtzLA0KICAgIFBhdWwNCg0KWyBUaGlzIG1lc3NhZ2Ugd2Fz
IGF1dG8tZ2VuZXJhdGVkOyBpZiB5b3UgYmVsaWV2ZSBhbnl0aGluZyBpcyBpbmNvcnJlY3QNCiAg
dGhlbiBwbGVhc2UgZW1haWwgcGF1bC5idXJ0b25AbWlwcy5jb20gdG8gcmVwb3J0IGl0LiBdDQo=
