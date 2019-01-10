Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FA5C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E5620657
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="kYdc03Ls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfAJISi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:18:38 -0500
Received: from mail-eopbgr710128.outbound.protection.outlook.com ([40.107.71.128]:61816
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727472AbfAJISi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABEHyEmcQM94N/2ud4Sqm3qwi1WfFsfJew1JnScIIQ4=;
 b=kYdc03LsrG71ANsreAOgCLppLfUZJOHMKJH84UOLpMoIu8SjBs2Jwb+TWayFY101Kz5jL6XwKGsBWX3CUccUIkwR85Cd9MZ0m5bhN/xMsQHe2prg5Vfj5jdJWYIseTz5HFNLJMI1hwAAnCERGu3gJ8WU9W/N7XoeHXB6x4AcS50=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5068.namprd06.prod.outlook.com (20.176.123.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.7; Thu, 10 Jan 2019 08:18:34 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%5]) with mapi id 15.20.1516.015; Thu, 10 Jan 2019
 08:18:34 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <Wright.Feng@cypress.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        John Van Boxtel <John.VanBoxtel@cypress.com>
Subject: Re: [PATCH v2] brcmfmac: Use firmware_request_nowarn for the clm_blob
Thread-Topic: [PATCH v2] brcmfmac: Use firmware_request_nowarn for the
 clm_blob
Thread-Index: AQHUpo2W08ZPFaMdE0SvdPw5g+skGaWoLQMA
Date:   Thu, 10 Jan 2019 08:18:34 +0000
Message-ID: <f2d8d0fc-a42a-b760-6361-5fd390f8eda5@cypress.com>
References: <20190107133327.9297-1-hdegoede@redhat.com>
In-Reply-To: <20190107133327.9297-1-hdegoede@redhat.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: HK2PR04CA0065.apcprd04.prod.outlook.com
 (2603:1096:202:14::33) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5068;6:ySUt9DC9m7EMrESKexdHXxjWBBD1ljpnSXQ4P2tAvs1H/jT8xAcmD4SYz/eWyVvnRqwJkGAv072kbTCCMcQpfacTm7cn0duhXNsACp/2LVwMPS73pDeGyHFj6MCOEje0j3zGEadjYJDflV9QuzpLKFXwuYlqaMjf/a90+KM5LVmW9ixayYiyWY4oe1PTww5rV1DkLnf7uqsx26DDtz8Qig7f5fw7bYMft1KBy9ks/drg56buik9jPzvttHfsCa7RmgYrczKWBHw0BCDtbbAluu6tnNWWXLs73lS5h/iWM0hxp7t+AHsbJ3uKRSOEFFIyKeBu23i8lmABv40yoaWROM8nCGrZH6MeTcKo4gzE2j2Qy4kSQElUnxN4ouIE9BSlCZelztKWO5XCIN7iutQsyOfTt7IHYKjLJwQlKqDgrq9yFIRiufSbGmAkCdsSziVa4m4Z81GHQlrBfaAt0bSDWg==;5:KY9gZDFGns2XhV+g/Gx8mDDRj3BtI3TFM6H2xTIiaR7TIZsZiHN6CBblzo7p9OwOogNyxFpViiTGg22QFLDWg+kJES7Fl//L2kVxY1IpaXGB+DBtGAKGcOD5C6pvW0WTXe7HR/osjWw2YYmPb3PmIVrKS9PnYOB7yzj0oIfsiTCgvOpKd982s4cQrbxnYTGzSCr3pshVDXahkJDOTJYJPw==;7:UXpNxg6SZyP/U2j20b32eb8x0IC78yqFqAXt8+VWIMVKiu3bTzgx9Mqd/CCA+0DesaURlIfyco6gOUb9QuqrRn5yxdsGt8F8Wx1h230yURftOUZ1uL1B0fHkMK780dckowxCIIaSfb6/ezkrg9Vrzw==
x-ms-office365-filtering-correlation-id: a5f11feb-8515-4a05-6bb6-08d676d436a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5068;
x-ms-traffictypediagnostic: DM6PR06MB5068:
x-microsoft-antispam-prvs: <DM6PR06MB5068689573AA785F51493D9CBB840@DM6PR06MB5068.namprd06.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(25786009)(68736007)(6636002)(65806001)(71190400001)(107886003)(66066001)(6246003)(65826007)(4326008)(43066004)(5660300001)(54906003)(305945005)(7736002)(58126008)(316002)(64126003)(65956001)(76176011)(8936002)(81156014)(8676002)(256004)(6512007)(186003)(31686004)(53936002)(81166006)(99286004)(486006)(102836004)(105586002)(53546011)(106356001)(386003)(6506007)(110136005)(31696002)(229853002)(72206003)(476003)(2616005)(478600001)(6116002)(3846002)(446003)(6436002)(52116002)(2906002)(11346002)(26005)(6486002)(3450700001)(97736004)(36756003)(71200400001)(14444005)(14454004)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5068;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QzLYdyJ4fA4qilxuO2fep6F6YGEqGoO6Vrvpz7oUOUWSJMxsvXP7EhBdkhuG6BCYUICI8rBKx8HwiNtU+wpU++9YWjdNHmn2CXLoAs2iQclpRgT6DCTqEGCmF24g7CQe13r12L0dTowk2pyMnjGqlRMfrfkkVU/4UakuJrXz6fAXrycl0X2dCcHCYbxoNhxviCF+VFmFJ64DgqStxO6NyzMiId4LKhgpP/WKCgllY8ei5Zu+VWg2nDb/2hhoOVheXASZWRmOY6EDKF7X9LUX4bK++et2V7s2uoLglw6XbES2qdubyTWsuNKc6UhCT9rO
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <66A1DE1B3993B942A17D2E0A2E81E1D2@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f11feb-8515-4a05-6bb6-08d676d436a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:18:34.5858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5068
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDAxLzA3LzIwMTkgOTozMywgSGFucyBkZSBHb2VkZSB3cm90ZToNCj4gVGhlIGxpbnV4
LWZpcm13YXJlIGJyY21mbWFjIGZpcm13YXJlIGZpbGVzIGNvbnRhaW4gYW4gZW1iZWRkZWQgdGFi
bGUgd2l0aA0KPiBwZXIgY291bnRyeSBhbGxvd2VkIGNoYW5uZWxzIGFuZCBzdHJlbmd0aCBpbmZv
Lg0KPiANCj4gRm9yIHJlY2VudCBoYXJkd2FyZSB0aGVzZSB2ZXJzaW9ucyBvZiB0aGUgZmlybXdh
cmUgYXJlIHNwZWNpYWxseSBidWlsZCBmb3INCj4gbGludXgtZmlybXdhcmUsIHRoZSBmaXJtd2Fy
ZSBmaWxlcyBkaXJlY3RseSBhdmFpbGFibGUgZnJvbSBDeXByZXNzIHJlbHkgb24NCj4gYSBzZXBh
cmF0ZSBjbG1fYmxvYiBmaWxlIGZvciB0aGlzIGluZm8uDQo+IA0KPiBGb3Igc29tZSB1bmtub3du
IHJlYXNvbiBDeXByZXNzIHJlZnVzZXMgdG8gcHJvdmlkZSB0aGUgc3RhbmRhcmQgZmlybXdhcmUN
Cj4gZmlsZXMgKyBjbG1fYmxvYiBmaWxlcyBpdCB1c2VzIGVsc2V3aGVyZSBmb3IgaW5jbHVzaW9u
IGludG8gbGludXgtZmlybXdhcmUsDQo+IGluc3RlYWQgcmVseWluZyBvbiB0aGVzZSBzcGVjaWFs
IGJ1aWxkcyB3aXRoIHRoZSBjbG1fYmxvYiBpbmZvIGVtYmVkZGVkLg0KPiBUaGlzIG1lYW5zIHRo
YXQgdGhlIGxpbnV4LWZpcm13YXJlIGZpcm13YXJlIHZlcnNpb25zIG9mdGVuIGxhZyBiZWhpbmQs
DQo+IGJ1dCBJIGRpZ3Jlc3MuDQoNCkhhbnMsDQoNCkhpc3RvcmljYWxseSB0aGUgd2lmaSBmaXJt
d2FyZSBiaW4gd291bGQgY29udGFpbiBhbGwgaW5kaXZpZHVhbCBjdXN0b21lciANCmJvYXJkIHJl
Z3VsYXRvcnkgZGF0YSB3aGljaCB3YXMgc2VsZWN0ZWQgdmlhIE9UUCAob3IgbnZyYW0pIGF0IGZp
cm13YXJlIA0KYm9vdC4gVGhpcyBldmVudHVhbGx5IGJlY2FtZSB1bnNjYWxhYmxlIGJlY2F1c2Ug
dGhlIEZXIHdvdWxkIG5lZWQgdG8gYmUgDQp1cGRhdGVkIGZvciBhbnkgbmV3IGN1c3RvbWVyIHBy
b2R1Y3QgYW5kL29yIGNoYW5nZS4gIEFsc28gdGhlIHRhYmxlIHVzZWQgDQptb3JlIGFuZCBtb3Jl
IGNyaXRpY2FsIG1lbW9yeSByZXNvdXJjZXMuIFRoZXJlZm9yZSwgdGhlIHJlZ3VsYXRvcnkgZGF0
YSANCndhcyBzZXBhcmF0ZWQgaW50byBhIGRvd25sb2FkYWJsZSB1bml0IHdoaWNoIGFsbG93ZWQg
dGhlIEZXIHRvIHJlbWFpbiANCmluZGVwZW5kZW50IGFuZCBzYXZlIG9uIGNyaXRpY2FsIChGVykg
bWVtb3J5IHJlc291cmNlcy4NCg0KVGhlIHRyaWNreSB0aGluZyBpcyB0aGF0IGNsbV9ibG9iIGNv
bnRhaW5zIHJlZ3VsYXRvcnkgZGF0YSB0aGF0IGlzIA0Kc3BlY2lmaWMgdG8gYSBib2FyZCwgbm90
IGp1c3QgdGhlIGNoaXAuIEFsc28gdGhlIHJlZ3VsYXRvcnkgcnVsZXMgb2Z0ZW4gDQpyZXF1aXJl
IHRoYXQgYSBwcm9kdWN0IG5vdCBiZSBhYmxlIHRvIGJlIG1pc2NvbmZpZ3VyZWQgKGludGVudGlv
bmFsbHkgb3IgDQphY2NpZGVudGFsbHkpLiBUbyBhdm9pZCByZWd1bGF0b3J5IHZpb2xhdGlvbnMg
Zm9yIG91ciBjdXN0b21lcnMgYW5kIA0KZ2VuZXJhbCBjb25mdXNpb24sIGNsbV9ibG9iIGZpbGVz
IHRoZSBtYXRjaGVzIHRoZSBoYXJkd2FyZSBzaG91bGQgYmUgDQpkZWxpdmVyZWQgYnkgaGFyZHdh
cmUgKGJvYXJkKSB2ZW5kb3JzLg0KDQpBcyB5b3UgbWVudGlvbmVkLCB0aGlzIHBhcmFncmFwaCBo
YXMgZGlzZ3Jlc3NlZC4gUGxlYXNlIHJlbW92ZSBpdCBmcm9tIA0KdGhlIGNvbW1pdCBtZXNzYWdl
Lg0KDQo+IA0KPiBUaGUgYnJjbWZtYWMgZHJpdmVyIGRvZXMgc3VwcG9ydCB0aGUgc2VwYXJhdGUg
Y2xtX2Jsb2IgZmlsZSBhbmQgYWx3YXlzDQo+IHRyaWVzIHRvIGxvYWQgdGhpcy4gQ3VycmVudGx5
IHdlIHVzZSByZXF1ZXN0X2Zpcm13YXJlIGZvciB0aGlzLiBUaGlzIG1lYW5zDQo+IHRoYXQgb24g
YW55IHN0YW5kYXJkIGluc3RhbGwsIHVzaW5nIHRoZSBzdGFuZGFyZCBjb21ibyBvZiBsaW51eC1r
ZXJuZWwgKw0KPiBsaW51eC1maXJtd2FyZSwgd2Ugd2lsbCBnZXQgYSB3YXJuaW5nOg0KPiAiRGly
ZWN0IGZpcm13YXJlIGxvYWQgZm9yIC4uLiBmYWlsZWQgd2l0aCBlcnJvciAtMiINCj4gDQo+IE9u
IHRvcCBvZiB0aGlzLCBicmNtZm1hYyBpdHNlbGYgcHJpbnRzOiAibm8gY2xtX2Jsb2IgYXZhaWxh
YmxlIChlcnI9LTIpLA0KPiBkZXZpY2UgbWF5IGhhdmUgbGltaXRlZCBjaGFubmVscyBhdmFpbGFi
bGUiLg0KPiANCj4gVGhpcyBjb21taXQgc3dpdGNoZXMgdG8gZmlybXdhcmVfcmVxdWVzdF9ub3dh
cm4sIGZpeGluZyBhbG1vc3QgYW55IGJyY21mbWFjDQo+IGRldmljZSBsb2dnaW5nIHRoZSB3YXJu
aW5nIChpdCBsZWF2ZXMgdGhlIGJyY21mbWFjIGluZm8gbWVzc2FnZSBpbiBwbGFjZSkuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPg0KPiAt
LS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLVVzZSBmaXJtd2FyZV9yZXF1ZXN0X25vd2FybiBpbnN0
ZWFkIG9mIHJlcXVlc3RfZmlybXdhcmVfZGlyZWN0DQo+IC1SZXdvcmQgY29tbWl0IG1lc3NhZ2Ug
YSBiaXQgdG8gbWF0Y2ggKGFuZCBmaXggYSB0eXBvKQ0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMgfCAyICstDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFj
L2NvbW1vbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL2NvbW1vbi5jDQo+IGluZGV4IDBiYjE2YmY1NzRlMy4uZTI5ZjU2ODg4NzYxIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y29tbW9uLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjEx
L2JyY21mbWFjL2NvbW1vbi5jDQo+IEBAIC0xNDksNyArMTQ5LDcgQEAgc3RhdGljIGludCBicmNt
Zl9jX3Byb2Nlc3NfY2xtX2Jsb2Ioc3RydWN0IGJyY21mX2lmICppZnApDQo+ICAgCQlyZXR1cm4g
ZXJyOw0KPiAgIAl9DQo+ICAgDQo+IC0JZXJyID0gcmVxdWVzdF9maXJtd2FyZSgmY2xtLCBjbG1f
bmFtZSwgYnVzLT5kZXYpOw0KPiArCWVyciA9IGZpcm13YXJlX3JlcXVlc3Rfbm93YXJuKCZjbG0s
IGNsbV9uYW1lLCBidXMtPmRldik7DQo+ICAgCWlmIChlcnIpIHsNCj4gICAJCWJyY21mX2luZm8o
Im5vIGNsbV9ibG9iIGF2YWlsYWJsZSAoZXJyPSVkKSwgZGV2aWNlIG1heSBoYXZlIGxpbWl0ZWQg
Y2hhbm5lbHMgYXZhaWxhYmxlXG4iLA0KPiAgIAkJCSAgIGVycik7DQo+IA0K
