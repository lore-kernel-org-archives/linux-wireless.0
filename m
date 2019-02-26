Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7329EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 06:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AAEC2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 06:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="aRNnb32h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfBZGjc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 01:39:32 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:29426 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfBZGjb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 01:39:31 -0500
X-IronPort-AV: E=Sophos;i="5.58,414,1544511600"; 
   d="scan'208";a="27278771"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Feb 2019 23:39:30 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 25 Feb 2019 23:39:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTt1BgCr1kZJt1HkJCQlaXP2fhTTZSk84R5g8W9kdnw=;
 b=aRNnb32ho2dE+kgTj/aKpyk580xx+Gb72VK0I3fCdXXXxsAKwOYsqlmzn1xTjgBSENRRGy0AkBP6iV1Lgzf9e/Roc+DMgnXxdiSN0StZm1P8s6zyPB1e5UcpLlLHpaSyyFnRAbeTKXt5rfIN93MbGBXZdPxrAr8ZhTxubkyHJfU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2581.namprd11.prod.outlook.com (52.135.227.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Tue, 26 Feb 2019 06:39:28 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1643.019; Tue, 26 Feb 2019
 06:39:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <tsu.yubo@gmail.com>, <Adham.Abozaeid@microchip.com>,
        <gregkh@linuxfoundation.org>
CC:     <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yuzibode@126.com>
Subject: Re: [PATCH] staging: wilc1000: Fix incorrent type in assignment
Thread-Topic: [PATCH] staging: wilc1000: Fix incorrent type in assignment
Thread-Index: AQHUzYNhxuZNtLoEl0iAYkzgOqOuoKXxoKsA
Date:   Tue, 26 Feb 2019 06:39:28 +0000
Message-ID: <d71296ff-1de3-3af7-7ade-02e4ced08e7e@microchip.com>
References: <20190226032825.26171-1-tsu.yubo@gmail.com>
In-Reply-To: <20190226032825.26171-1-tsu.yubo@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::11) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [223.237.216.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74a2ec93-b040-4089-fb80-08d69bb52824
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2581;
x-ms-traffictypediagnostic: BYAPR11MB2581:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtCWUFQUjExTUIyNTgxOzIzOkpMclJiaFlDMkRZSzNXQno5a3I1SWVRdHBh?=
 =?utf-8?B?dlpHdWtvQXVqNjRlaU1CSkpPVm5lYWRmQ2dGTWxDL0xySnRPWlc0RHBVbnRx?=
 =?utf-8?B?eDlIaFA0N0ZKU2tzMW4yYjBwS1BMYnRBUnlIM0pGVGZaMVhoRWtDU3IwVTYw?=
 =?utf-8?B?NHRsVU5qWStPTS9MWDVlN2lKYnlMMjYxTmJGVHhrWkNiYUkzRENNUngwYWtW?=
 =?utf-8?B?TlZXQi9oRVZoZU5xWHNXVEFiUjdRWjNQdUgwY0lnc1luSHFNNzBMYlZieEwr?=
 =?utf-8?B?T3JBdWRTQ25DYVczS0RPeWp6UlZ2emExakVKa21XZmpJbGs3d0dRb0c5MU1E?=
 =?utf-8?B?Zm81Z0JCcVBBK1J3eUptK20vRkhRZHhrRGV6a1ZpS3RBZ1BGZVNGRzBDSjZw?=
 =?utf-8?B?ZVYwS2lYTGc0VklPakRNbGxUSW1xRVpSSjZzZ3FlMCtCMGUyTkVrVit0WlI5?=
 =?utf-8?B?K0RxNFFueUtQTlFybHlHSEw0cnlzS0F0cFNzVHpxQWtUNjNoV3IyOGFaYjY0?=
 =?utf-8?B?Vk50ZHhnUjN0SmlLcVowRWF0RS9lTURSMnFmUUhkclZTS1g0cXprU3prWWU0?=
 =?utf-8?B?dEVkVkxrN2ZiZWczZmVPNXZJMXZZZndWcjR4Qlp3aTVGQ2JRSUtPYlZXc1VC?=
 =?utf-8?B?Q2g3Vi8yY0pBYmpGeUNXQ2xSY2Fob2tidDRTYWVZTjZsYmlDd0xqNWVqOVBB?=
 =?utf-8?B?T3g3YmoxZlo1MzZPZHNsNGwvTXZvS3Nwb3ViQlRSLzVxeHlqTGt5bnkybVVh?=
 =?utf-8?B?NG1MdFU5blovQ0lrNTJhMWpWSW5KRkFHeHA5ZVFaWk8vc0tEQi9KVTJXMHkw?=
 =?utf-8?B?QnlhMk9JeFZFL2pjSmlDd2Y1bkQrSUJrTDMxK28yeXBGUnVWVjN5aEJnK0NO?=
 =?utf-8?B?Rml6UVk1ZWVyUG16QW00aDYyUXVHd29DcFpsZjdhVnlKL2N2My9kZHFuWWRh?=
 =?utf-8?B?dXRjK3pScGNVYXBkTjFtQnF2MEJ6eTZxL2FCYlN2ZWVNQ2lMWHNreXBRUSs4?=
 =?utf-8?B?dEdPWWZSTk1MNENDN1RXL0dvV0NMS2hnS2ZKVTFoM1VyaGQ5VFdBQ3BVTldm?=
 =?utf-8?B?TXlKRG1GY3N2WndZVVAxRitnQmhBemw5dnllR05DWURGUWQ2ZjltZ1RyKzFn?=
 =?utf-8?B?QWVLdkJWdG1nQU9qSU9TalRQU3NtcmNDNWk0R2FvcFRFVWJqekpEMnRBZjFp?=
 =?utf-8?B?anhkaEE0b3JyQ09BZElkQ1hLQk10Q2x2UnI0THArTnBRbHpPdzFHamhBSVQv?=
 =?utf-8?B?OWhmRmJmVExFSFF6OXgzRmQvWTR3Zmx5K3F6cWUvVFJ2ZXdqSWJCencvMzkr?=
 =?utf-8?B?UWRlQ292Y1ZlYi9ENExMTXBqNDRPaGM5cnFmM3lEWWRhZjBPYzZSSkJnYXVi?=
 =?utf-8?B?ODVZbENrSXdGMEV2T0xuaTEvdUN4MERWZmRob1Q4RUk2UFZWMEQrdUpZY1Iv?=
 =?utf-8?B?TXMvVXdvd05MTnRWMjFQN0QwS01QcXZGNWhBR0RBMHFEQTc3S2liVTRwMU1U?=
 =?utf-8?B?bE9OVlY2R051eUZpbC9QSkVZeHNVYmZWV2tOQ3RGMTkwZlgyNUJKWHgwc2Fh?=
 =?utf-8?B?aHVvblpZTFBKQVNyblI1M2t2aFVIZ09HQlBQS2dHbHZYVzltN2xFVW1vSjhD?=
 =?utf-8?B?TWRwSmVMQWVSVTdMUXN2Vk5HM2RHOTNLd1d6RzYzNHRhQkpxajhNWWtTMG1i?=
 =?utf-8?B?cEpXQnplTllSODVRcWkrdDVXaVVOZDNBeFRSekhDcUs5UGEycloxN3gvTnA2?=
 =?utf-8?B?VXpYVnE5VE9PNUFFekdQd01LbGpNWnd0QzNIYnREZFRtT0RHUWJZMVE2N2hG?=
 =?utf-8?Q?OY1d+Ky0lQ1UO?=
x-microsoft-antispam-prvs: <BYAPR11MB25814D36383DDEF5E76E96F8E37B0@BYAPR11MB2581.namprd11.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(81156014)(97736004)(4326008)(5660300002)(186003)(486006)(2616005)(476003)(446003)(11346002)(81166006)(71200400001)(71190400001)(105586002)(31686004)(106356001)(68736007)(66066001)(2501003)(2906002)(25786009)(8676002)(14444005)(256004)(52116002)(53546011)(6506007)(386003)(99286004)(8936002)(14454004)(7736002)(36756003)(305945005)(6512007)(102836004)(26005)(53936002)(6436002)(86362001)(6486002)(478600001)(54906003)(110136005)(31696002)(72206003)(6116002)(76176011)(3846002)(316002)(6246003)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2581;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: was1W0aee+Rl0ZcwJaH9l1Sg8Zu3tbJDGS4+ahGRPHjN43emjCATG6A7BEuTBznyJ9D/qQ8ZPWp0UEKZK6DbHea7cqb9fiNGCOr/jcaiMoY/obSYL9X52wmBq8DRmUFjpdhVw9JLRN+LJIHF+j2DNRSXhUOMUKRYKDzTROYUnUgSs8Fe3w7OGO3S3x/Qr5YBL4Qz6b7duTR8+cI8guL2SrGkjPL8Equt106cQTvf8YOgbMhhNTfse5aRH2yCGxpIQX5wiwgd8onIvkQFrz+VhqOPxMQKQwh/1w6jyeAdc7ZL/GUSxpFMQydIybm/fcKjUNNNBN4vsCXGrQSwUoSqoWSlc/Z3uC51dCMi1GFntFE2hW6XHfN9qHFW+KL8Aasg7qVRUErvZc1XG0P6Laz90k+SBJb7EC7S+NHJ72ouNRA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E01B827023D35841B48C132FDEA8416D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a2ec93-b040-4089-fb80-08d69bb52824
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 06:39:25.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2581
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIvMjYvMjAxOSA4OjU4IEFNLCBCbyBZVSB3cm90ZToNCj4gVGhlIHBhdGNoIGZpeGVz
IGZvbGxvd2luZyBzcGFyc2Ugd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvc3RhZ2luZy93aWxjMTAw
MC9ob3N0X2ludGVyZmFjZS5jOjQ1MDozMDogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNz
aWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpDQo+IGRyaXZlcnMvc3RhZ2luZy93aWxjMTAw
MC9ob3N0X2ludGVyZmFjZS5jOjQ1MDozMDogICAgZXhwZWN0ZWQgcmVzdHJpY3RlZCBfX2xlMTYg
W3VzZXJ0eXBlXSBiZWFjb25fcGVyaW9kDQo+IGRyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0
X2ludGVyZmFjZS5jOjQ1MDozMDogICAgZ290IHVuc2lnbmVkIHNob3J0IFt1c2VydHlwZV0gYmVh
Y29uX2ludGVydmFsDQo+IGRyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5j
OjQ1MToyNTogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50
IGJhc2UgdHlwZXMpDQo+IGRyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5j
OjQ1MToyNTogICAgZXhwZWN0ZWQgcmVzdHJpY3RlZCBfX2xlMTYgW3VzZXJ0eXBlXSBjYXBfaW5m
bw0KPiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYzo0NTE6MjU6ICAg
IGdvdCB1bnNpZ25lZCBzaG9ydCBbdXNlcnR5cGVdIGNhcGFiaWxpdHkNCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEJvIFlVIDx0c3UueXVib0BnbWFpbC5jb20+DQo+IC0tLQ0KPiBJIGhhdmUgbm8gaGFy
ZHdhcmUgdG8gdGVzdCBpdCBhbmQganVzdCB0byBjb21waWxlIGl0DQoNClRoYW5rcyBmb3Igc3Vi
bWl0dGluZyB0aGUgcGF0Y2guDQoNClRoZSBjb3JyZWN0IHdheSB0byBmaXggYWJvdmUgc3BhcmUg
d2FybmluZyBpcyBieSB1c2luZyBjcHVfdG9fbGUxNigpDQp3aGlsZSBmaWxpbmcgdGhlIGluZm9y
bWF0aW9uIGluIC0+YmVhY29uX3BlcmlvZCBhbmQgLT5jYXBfaW5mbyBiZWNhdXNlDQp3aWxjMTAw
MCBtb2R1bGUgZXhwZWN0cyB0aGUgZGF0YSBpbiBfbGVfIGJ5dGUgb3JkZXIuDQoNClBsZWFzZSBj
aGFuZ2VzIHRoZSBiZWxvdyBsaW5lcyBpbiBob3N0X2ludGVyZmFjZS5jIGFuZCByZXN1Ym1pdCB0
aGUgcGF0Y2guDQoJcGFyYW0tPmJlYWNvbl9wZXJpb2QgPSBic3MtPmJlYWNvbl9pbnRlcnZhbDsN
CglwYXJhbS0+Y2FwX2luZm8gPSBic3MtPmNhcGFiaWxpdHk7DQp0bw0KCXBhcmFtLT5iZWFjb25f
cGVyaW9kID0gY3B1X3RvX2xlMTYoYnNzLT5iZWFjb25faW50ZXJ2YWwpOw0KCXBhcmFtLT5jYXBf
aW5mbyA9IGNwdV90b19sZTE2KGJzcy0+Y2FwYWJpbGl0eSk7DQoNCj4gLS0tDQo+ICBkcml2ZXJz
L3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYyBiL2RyaXZlcnMvc3Rh
Z2luZy93aWxjMTAwMC9ob3N0X2ludGVyZmFjZS5jDQo+IGluZGV4IDUwZGMyZGQ5NDJmNS4uY2Rj
YjUyYWVjNzc5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9p
bnRlcmZhY2UuYw0KPiArKysgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZh
Y2UuYw0KPiBAQCAtMTA2LDEwICsxMDYsMTAgQEAgc3RydWN0IHdpbGNfam9pbl9ic3NfcGFyYW0g
ew0KPiAgCXU4IHNzaWRfdGVybWluYXRvcjsNCj4gIAl1OCBic3NfdHlwZTsNCj4gIAl1OCBjaDsN
Cj4gLQlfX2xlMTYgY2FwX2luZm87DQo+ICsJdTE2IGNhcF9pbmZvOw0KPiAgCXU4IHNhW0VUSF9B
TEVOXTsNCj4gIAl1OCBic3NpZFtFVEhfQUxFTl07DQo+IC0JX19sZTE2IGJlYWNvbl9wZXJpb2Q7
DQo+ICsJdTE2IGJlYWNvbl9wZXJpb2Q7DQo+ICAJdTggZHRpbV9wZXJpb2Q7DQo+ICAJdTggc3Vw
cF9yYXRlc1tXSUxDX01BWF9SQVRFU19TVVBQT1JURUQgKyAxXTsNCj4gIAl1OCB3bW1fY2FwOw0K
PiANCg0KUmVnYXJkcywNCkFqYXkNCg==
