Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452A2C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BFA2086E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="c4W2TKln"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8BFA2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbeJKDaf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:30:35 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:64038 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbeJKDae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 23:30:34 -0400
X-IronPort-AV: E=Sophos;i="5.54,365,1534834800"; 
   d="scan'208";a="21351314"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 10 Oct 2018 13:06:51 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 10 Oct 2018 13:06:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rP7ZIzYVludAYQx0jDzEHF7sFBglbuJxghT1cd797ms=;
 b=c4W2TKlnWI2rdhV4EwVEL/OSQ88tUwxyVmMdPeUmTUv5mRTNCVW4Jrx81XUCMmSjVF23aS9MwHAgDO9DUtvNsKEN70rHa5gmE9bx/9i9GiJ5UtUHU/RzG6O41VWvKCTSnA4GjJPFcGfAHk1lO529V4Y4XRQFwTEaOO8szHI/LC0=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0090.namprd11.prod.outlook.com (10.160.28.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.25; Wed, 10 Oct 2018 20:06:45 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Wed, 10 Oct 2018
 20:06:45 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUVfI/RgAOB7IA=
Date:   Wed, 10 Oct 2018 20:06:45 +0000
Message-ID: <5BBE5BCF.5020706@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
 <1539009076.3687.64.camel@sipsolutions.net>
In-Reply-To: <1539009076.3687.64.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0086.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::46) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0090;6:utFZbBPMovxQfhFtXtBw6/Uqi1pC7JYpEXGoSeHiRGITqR5VeoEyh24gMIRcUwAnDXJnYsVOnSJJIj1W978095TGzFkT/3ygq1pIaqKLWGDfpMkBX0qJpb1SE9AD6iUgm3Lemv6fxDaC1qzJRuKgYH+2nvcr6vHbUmPfBkzfDgGc9bQymcck+3RHaTCaZBv0fq3tCi/7e2PAcFx0TPmB/T7K2KM5PrILLOcI/eNZXBh4cy6Se/baSY8GzGgcVngWl+1dc58Ze6hyVByUzF3q0yM6Q07fMQ0sKhIh2fWQAYTkoyBThSugHaPy8euxkYCw0QdYWwABrVTqgWOj7BoYVzS52SBtp25jS4udvHZAzMm4uhx0geDiSDtp+HfGU3ZKn6RgtrPUVaqT+oKto2XVSKIawPMUIYQYDRloMqCzutE4A/QcTNGlHIFwTkKYaxXaGScjgaal6aAc5VGPYQ5FkA==;5:IzXf571xaPO/ajkIjxtAmddRI0ivPqBZL4G0ppVk9kuAYMxyIpyZZ72oPn9Ev1FM2j4ZziCQQirDoo51xDtpGv8iUKwILrFVHC7Zp3c0X0UvobQlwWOPUPtZ2FRmBlq6wPYw1ub9w27aOYlBeZ/QovEhrOed5Xv/XMSndEceCDI=;7:3382BOy6aGqtIoBzSWFxtVhP2Ci6cre2fkLM9tBfXuZIJO4CCOzQ1SuRYAV9cCgH4OXldqCUIgsPcDhtCoC79gAnx2JNBrhx57hjD/9iQ934bQie3OUFlUfP9BbbHfGPeXnKDqscaw2rjy41DrcXANxdxmd5jmy80G7A+z7V26wn3L1HD3rsYRaeDXZRNX0cdl/vHpRgp2hwqWkTyE3icGbBWYRSGSemQNeK2TIy5qyosfJRMMQLvaHqZSMtETwN
x-ms-office365-filtering-correlation-id: 8168e81d-482a-40e7-9e32-08d62eebe6bf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0090;
x-ms-traffictypediagnostic: DM2PR11MB0090:
x-microsoft-antispam-prvs: <DM2PR11MB0090E041D51BD6C1EE397A1B8DE00@DM2PR11MB0090.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(201708071742011)(7699051);SRVR:DM2PR11MB0090;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0090;
x-forefront-prvs: 08213D42D3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(64126003)(58126008)(107886003)(86362001)(5250100002)(6506007)(6246003)(2906002)(71190400001)(53546011)(486006)(7736002)(68736007)(110136005)(575784001)(229853002)(54906003)(186003)(386003)(53936002)(3846002)(25786009)(6116002)(65956001)(102836004)(478600001)(2501003)(2900100001)(33656002)(80316001)(71200400001)(26005)(97736004)(87266011)(52116002)(106356001)(36756003)(8676002)(65816011)(76176011)(81156014)(81166006)(4326008)(72206003)(59896002)(2616005)(99286004)(8936002)(316002)(476003)(105586002)(14444005)(65806001)(256004)(6436002)(66066001)(5660300001)(446003)(305945005)(6512007)(11346002)(14454004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0090;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: rdtuPnkUsAzGopceAWwKFisNelTLceuIcOspdM/kgNqfBnDgmmOP816DI3NWET369YVd3T6oaT8kM9SL7bUXEERMEGKg+DVDFthfavKCR5RV5OoUwvmTkdIVZTFACmDZfTCiT3V/HqIEwZPnRIVyeOYpspLQz8BvyHey4wHAKpj3LRspvgdQ3cHcmYyD+U70Iv+2nF2D/tzeovh/zXi/MbkLUBeVMwvZkDrY4F9P2blI1B9/BYdLn9cNS39Dj1n8yJ3IWiB7iN4pv26yPrfctkD243RZqxzmaqwLxYQ7jmFc0IIuixvxjh4XH0vZim3vE98fr1h4YIuPBpuaY4L7SwK+YwOCCtuYgEE8r6JjvOI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F9101DBFA249D4FB186F450D05D38C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8168e81d-482a-40e7-9e32-08d62eebe6bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2018 20:06:45.1400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0090
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA4LzIwMTggMDc6MzEgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IA0KPj4g
KwkqY3VycmJ5dGUgPSAodTMyKTAgJiBEUlZfSEFORExFUl9NQVNLOw0KPiANCj4gWW91IGRvIHRo
aXMgYSBmZXcgdGltZXMsIG5vdCBzdXJlIHdoYXQgaXQncyBzdXBwb3NlZCB0byBhY2hpZXZlPw0K
PiANCj4+ICsJaWYgKHBhcmFtLT5mbGFnICYgUkVUUllfTE9ORykgew0KPj4gKwkJdTE2IGxpbWl0
ID0gcGFyYW0tPmxvbmdfcmV0cnlfbGltaXQ7DQo+PiArDQo+PiArCQlpZiAobGltaXQgPiAwICYm
IGxpbWl0IDwgMjU2KSB7DQo+PiArCQkJd2lkX2xpc3RbaV0uaWQgPSBXSURfTE9OR19SRVRSWV9M
SU1JVDsNCj4+ICsJCQl3aWRfbGlzdFtpXS52YWwgPSAoczggKikmcGFyYW0tPmxvbmdfcmV0cnlf
bGltaXQ7DQo+PiArCQkJd2lkX2xpc3RbaV0udHlwZSA9IFdJRF9TSE9SVDsNCj4+ICsJCQl3aWRf
bGlzdFtpXS5zaXplID0gc2l6ZW9mKHUxNik7DQo+PiArCQkJaGlmX2Rydi0+Y2ZnX3ZhbHVlcy5s
b25nX3JldHJ5X2xpbWl0ID0gbGltaXQ7DQo+PiArCQl9IGVsc2Ugew0KPj4gKwkJCW5ldGRldl9l
cnIodmlmLT5uZGV2LCAiUmFuZ2UoMX4yNTYpIG92ZXJcbiIpOw0KPj4gKwkJCWdvdG8gdW5sb2Nr
Ow0KPj4gKwkJfQ0KPj4gKwkJaSsrOw0KPj4gKwl9DQo+IA0KPiBTbyAuLi4gY2FuIGFueW9uZSB0
ZWxsIG1lIHdoeSB0aGVyZSdzIGEgY29tcGxldGUgZHJpdmVyLWludGVybmFsDQo+IG1lc3NhZ2lu
ZyBpbmZyYXN0cnVjdHVyZSBpbiB0aGlzLCB0aGF0IGV2ZW4gc3VwcHJlc3NlcyBlcnJvcnMgbGlr
ZSBoZXJlDQo+IChvdXQgb2YgcmFuZ2UganVzdCByZXN1bHRzIGluIGEgbWVzc2FnZSByYXRoZXIg
dGhhbiByZXR1cm5pbmcgYW4gZXJyb3INCj4gdG8gd2hlcmV2ZXIgaXQgb3JpZ2luYXRlZCk/DQo+
IA0KQWdyZWUuIHBhcmFtZXRlciB2YWxpZGF0aW9uIGNhbiBiZSBkb25lIGJlZm9yZSBzY2hlZHVs
aW5nIHRoZSB3b3JrLCBhbmQgaGVuY2UgYXBwcm9wcmlhdGUgZXJyb3IgY2FuIGJlIHJldHVybmVk
IHRvIGNhbGxlciAuDQoNCj4gSXQgYWxtb3N0ICpzZWVtcyogbGlrZSBpdCdzIGEgdG8tZGV2aWNl
IGluZnJhc3RydWN0dXJlLCBidXQgaXQgY2FuJ3QgYmUNCj4gc2luY2UgaXQgdXNlcyBob3N0IHBv
aW50ZXJzIGV2ZXJ5d2hlcmU/DQo+IA0KPiBJIHRoaW5rIHRoaXMgY29kZSB3b3VsZCBiZSBmYXIg
YmV0dGVyIG9mZiB3aXRob3V0IHRoZSAiYm91bmNlIGluIGRyaXZlcg0KPiB0byByZXNvbHZlIGhv
c3QgcG9pbnRlcnMiIHN0ZXAuDQpJZiBJIGdvdCB5b3VyIHBvaW50IGNvcnJlY3RseSwgeW91IGFy
ZSByZWZlcnJpbmcgdG8gdGhlIGxpbmVzIHRoYXQgc3RvcmVzIHRoZSBwYXJhbWV0ZXJzIGludG8g
dGhlIGhpZl9kcnYtPmNmZ192YWx1ZXMuDQpJIGFncmVlLCB0aGUgY2ZnX3ZhbHVlcyBpc24ndCBy
ZWFkIGZyb20gYW55d2hlcmUgaW4gdGhlIGRyaXZlciwgc28gY2FuIGJlIHJlbW92ZWQNCg0KPj4g
KwlpZiAoY29ubl9hdHRyLT5zc2lkKSB7DQo+PiArCQltZW1jcHkoY3VyX2J5dGUsIGNvbm5fYXR0
ci0+c3NpZCwgY29ubl9hdHRyLT5zc2lkX2xlbik7DQo+PiArCQljdXJfYnl0ZVtjb25uX2F0dHIt
PnNzaWRfbGVuXSA9ICdcMCc7DQo+PiArCX0NCj4+ICsJY3VyX2J5dGUgKz0gTUFYX1NTSURfTEVO
Ow0KPiANCj4gYWdhaW4sIFNTSURzIGFyZSBub3QgMC10ZXJtaW5hdGVkIHN0cmluZ3MNCkZvciB0
aGlzIHNwZWNpZmljIGNvZGUsIHRoZSBkZXZpY2UgcmVxdWlyZXMgdGhlIHNzaWQgdG8gYmUgbnVs
bCB0ZXJtaW5hdGVkLCBzaW5jZSBpdCBkb2Vzbid0IHJlY2VpdmUgdGhlIHNzaWRfbGVuIHBhcmFt
ZXRlci4NCkZvciBvdGhlciBzc2lkIHJlZmVyZW5jZXMgaW4gdGhlIGRyaXZlciwgdGhlIG51bGwg
dGVybWluYXRpb24gY2FuIGJlIHJlbW92ZWQuDQo+IA0KPj4gK3N0YXRpYyB2b2lkIGhvc3RfaW50
X2ZpbGxfam9pbl9ic3NfcGFyYW0oc3RydWN0IGpvaW5fYnNzX3BhcmFtICpwYXJhbSwgdTggKmll
cywNCj4+ICsJCQkJCSB1MTYgKm91dF9pbmRleCwgdTggKnBjaXBoZXJfdGMsDQo+PiArCQkJCQkg
dTggKmF1dGhfdG90YWxfY250LCB1MzIgdHNmX2xvLA0KPj4gKwkJCQkJIHU4ICpyYXRlc19ubykN
Cj4+ICt7DQo+PiArCXU4IGV4dF9yYXRlc19ubzsNCj4+ICsJdTE2IG9mZnNldDsNCj4+ICsJdTgg
cGNpcGhlcl9jbnQ7DQo+PiArCXU4IGF1dGhfY250Ow0KPj4gKwl1OCBpLCBqOw0KPj4gKwl1MTYg
aW5kZXggPSAqb3V0X2luZGV4Ow0KPj4gKw0KPj4gKwlpZiAoaWVzW2luZGV4XSA9PSBXTEFOX0VJ
RF9TVVBQX1JBVEVTKSB7DQo+PiArCQkqcmF0ZXNfbm8gPSBpZXNbaW5kZXggKyAxXTsNCj4+ICsJ
CXBhcmFtLT5zdXBwX3JhdGVzWzBdID0gKnJhdGVzX25vOw0KPj4gKwkJaW5kZXggKz0gMjsNCj4+
ICsNCj4+ICsJCWZvciAoaSA9IDA7IGkgPCAqcmF0ZXNfbm87IGkrKykNCj4+ICsJCQlwYXJhbS0+
c3VwcF9yYXRlc1tpICsgMV0gPSBpZXNbaW5kZXggKyBpXTsNCj4+ICsNCj4+ICsJCWluZGV4ICs9
ICpyYXRlc19ubzsNCj4+ICsJfSBlbHNlIGlmIChpZXNbaW5kZXhdID09IFdMQU5fRUlEX0VYVF9T
VVBQX1JBVEVTKSB7DQo+PiArCQlleHRfcmF0ZXNfbm8gPSBpZXNbaW5kZXggKyAxXTsNCj4+ICsJ
CWlmIChleHRfcmF0ZXNfbm8gPiAoTUFYX1JBVEVTX1NVUFBPUlRFRCAtICpyYXRlc19ubykpDQo+
PiArCQkJcGFyYW0tPnN1cHBfcmF0ZXNbMF0gPSBNQVhfUkFURVNfU1VQUE9SVEVEOw0KPj4gKwkJ
ZWxzZQ0KPj4gKwkJCXBhcmFtLT5zdXBwX3JhdGVzWzBdICs9IGV4dF9yYXRlc19ubzsNCj4+ICsJ
CWluZGV4ICs9IDI7DQo+PiArCQlmb3IgKGkgPSAwOyBpIDwgKHBhcmFtLT5zdXBwX3JhdGVzWzBd
IC0gKnJhdGVzX25vKTsgaSsrKQ0KPj4gKwkJCXBhcmFtLT5zdXBwX3JhdGVzWypyYXRlc19ubyAr
IGkgKyAxXSA9IGllc1tpbmRleCArIGldOw0KPj4gKw0KPj4gKwkJaW5kZXggKz0gZXh0X3JhdGVz
X25vOw0KPj4gKwl9IGVsc2UgaWYgKGllc1tpbmRleF0gPT0gV0xBTl9FSURfSFRfQ0FQQUJJTElU
WSkgew0KPj4gKwkJcGFyYW0tPmh0X2NhcGFibGUgPSB0cnVlOw0KPj4gKwkJaW5kZXggKz0gaWVz
W2luZGV4ICsgMV0gKyAyOw0KPj4gKwl9IGVsc2UgaWYgKChpZXNbaW5kZXhdID09IFdMQU5fRUlE
X1ZFTkRPUl9TUEVDSUZJQykgJiYNCj4+ICsJCSAgIChpZXNbaW5kZXggKyAyXSA9PSAweDAwKSAm
JiAoaWVzW2luZGV4ICsgM10gPT0gMHg1MCkgJiYNCj4+ICsJCSAgIChpZXNbaW5kZXggKyA0XSA9
PSAweEYyKSAmJiAoaWVzW2luZGV4ICsgNV0gPT0gMHgwMikgJiYNCj4+ICsJCSAgICgoaWVzW2lu
ZGV4ICsgNl0gPT0gMHgwMCkgfHwgKGllc1tpbmRleCArIDZdID09IDB4MDEpKSAmJg0KPj4gKwkJ
ICAgKGllc1tpbmRleCArIDddID09IDB4MDEpKSB7DQo+PiArCQlwYXJhbS0+d21tX2NhcCA9IHRy
dWU7DQo+PiArDQo+PiArCQlpZiAoaWVzW2luZGV4ICsgOF0gJiBCSVQoNykpDQo+PiArCQkJcGFy
YW0tPnVhcHNkX2NhcCA9IHRydWU7DQo+PiArCQlpbmRleCArPSBpZXNbaW5kZXggKyAxXSArIDI7
DQo+PiArCX0gZWxzZSBpZiAoKGllc1tpbmRleF0gPT0gV0xBTl9FSURfVkVORE9SX1NQRUNJRklD
KSAmJg0KPj4gKwkJIChpZXNbaW5kZXggKyAyXSA9PSAweDUwKSAmJiAoaWVzW2luZGV4ICsgM10g
PT0gMHg2ZikgJiYNCj4+ICsJCSAoaWVzW2luZGV4ICsgNF0gPT0gMHg5YSkgJiYNCj4+ICsJCSAo
aWVzW2luZGV4ICsgNV0gPT0gMHgwOSkgJiYgKGllc1tpbmRleCArIDZdID09IDB4MGMpKSB7DQo+
PiArCQl1MTYgcDJwX2NudDsNCj4+ICsNCj4+ICsJCXBhcmFtLT50c2YgPSB0c2ZfbG87DQo+PiAr
CQlwYXJhbS0+bm9hX2VuYWJsZWQgPSAxOw0KPj4gKwkJcGFyYW0tPmlkeCA9IGllc1tpbmRleCAr
IDldOw0KPj4gKw0KPj4gKwkJaWYgKGllc1tpbmRleCArIDEwXSAmIEJJVCg3KSkgew0KPj4gKwkJ
CXBhcmFtLT5vcHBfZW5hYmxlZCA9IDE7DQo+PiArCQkJcGFyYW0tPmN0X3dpbmRvdyA9IGllc1tp
bmRleCArIDEwXTsNCj4+ICsJCX0gZWxzZSB7DQo+PiArCQkJcGFyYW0tPm9wcF9lbmFibGVkID0g
MDsNCj4+ICsJCX0NCj4+ICsNCj4+ICsJCXBhcmFtLT5jbnQgPSBpZXNbaW5kZXggKyAxMV07DQo+
PiArCQlwMnBfY250ID0gaW5kZXggKyAxMjsNCj4+ICsNCj4+ICsJCW1lbWNweShwYXJhbS0+ZHVy
YXRpb24sIGllcyArIHAycF9jbnQsIDQpOw0KPj4gKwkJcDJwX2NudCArPSA0Ow0KPj4gKw0KPj4g
KwkJbWVtY3B5KHBhcmFtLT5pbnRlcnZhbCwgaWVzICsgcDJwX2NudCwgNCk7DQo+PiArCQlwMnBf
Y250ICs9IDQ7DQo+PiArDQo+PiArCQltZW1jcHkocGFyYW0tPnN0YXJ0X3RpbWUsIGllcyArIHAy
cF9jbnQsIDQpOw0KPj4gKw0KPj4gKwkJaW5kZXggKz0gaWVzW2luZGV4ICsgMV0gKyAyOw0KPj4g
Kwl9IGVsc2UgaWYgKChpZXNbaW5kZXhdID09IFdMQU5fRUlEX1JTTikgfHwNCj4+ICsJCSAoKGll
c1tpbmRleF0gPT0gV0xBTl9FSURfVkVORE9SX1NQRUNJRklDKSAmJg0KPj4gKwkJICAoaWVzW2lu
ZGV4ICsgMl0gPT0gMHgwMCkgJiYNCj4+ICsJCSAgKGllc1tpbmRleCArIDNdID09IDB4NTApICYm
IChpZXNbaW5kZXggKyA0XSA9PSAweEYyKSAmJg0KPj4gKwkJICAoaWVzW2luZGV4ICsgNV0gPT0g
MHgwMSkpKSB7DQo+PiArCQl1MTYgcnNuX2lkeCA9IGluZGV4Ow0KPj4gKw0KPj4gKwkJaWYgKGll
c1tyc25faWR4XSA9PSBXTEFOX0VJRF9SU04pIHsNCj4+ICsJCQlwYXJhbS0+bW9kZV84MDJfMTFp
ID0gMjsNCj4+ICsJCX0gZWxzZSB7DQo+PiArCQkJaWYgKHBhcmFtLT5tb2RlXzgwMl8xMWkgPT0g
MCkNCj4+ICsJCQkJcGFyYW0tPm1vZGVfODAyXzExaSA9IDE7DQo+PiArCQkJcnNuX2lkeCArPSA0
Ow0KPj4gKwkJfQ0KPj4gKw0KPj4gKwkJcnNuX2lkeCArPSA3Ow0KPj4gKwkJcGFyYW0tPnJzbl9n
cnBfcG9saWN5ID0gaWVzW3Jzbl9pZHhdOw0KPj4gKwkJcnNuX2lkeCsrOw0KPj4gKwkJb2Zmc2V0
ID0gaWVzW3Jzbl9pZHhdICogNDsNCj4+ICsJCXBjaXBoZXJfY250ID0gKGllc1tyc25faWR4XSA+
IDMpID8gMyA6IGllc1tyc25faWR4XTsNCj4+ICsJCXJzbl9pZHggKz0gMjsNCj4+ICsNCj4+ICsJ
CWkgPSAqcGNpcGhlcl90YzsNCj4+ICsJCWogPSAwOw0KPj4gKwkJZm9yICg7IGkgPCAocGNpcGhl
cl9jbnQgKyAqcGNpcGhlcl90YykgJiYgaSA8IDM7IGkrKywgaisrKSB7DQo+PiArCQkJdTggKnBv
bGljeSA9ICAmcGFyYW0tPnJzbl9wY2lwX3BvbGljeVtpXTsNCj4+ICsNCj4+ICsJCQkqcG9saWN5
ID0gaWVzW3Jzbl9pZHggKyAoKGogKyAxKSAqIDQpIC0gMV07DQo+PiArCQl9DQo+PiArDQo+PiAr
CQkqcGNpcGhlcl90YyArPSBwY2lwaGVyX2NudDsNCj4+ICsJCXJzbl9pZHggKz0gb2Zmc2V0Ow0K
Pj4gKw0KPj4gKwkJb2Zmc2V0ID0gaWVzW3Jzbl9pZHhdICogNDsNCj4+ICsNCj4+ICsJCWF1dGhf
Y250ID0gKGllc1tyc25faWR4XSA+IDMpID8gMyA6IGllc1tyc25faWR4XTsNCj4+ICsJCXJzbl9p
ZHggKz0gMjsNCj4+ICsJCWkgPSAqYXV0aF90b3RhbF9jbnQ7DQo+PiArCQlqID0gMDsNCj4+ICsJ
CWZvciAoOyBpIDwgKCphdXRoX3RvdGFsX2NudCArIGF1dGhfY250KTsgaSsrLCBqKyspIHsNCj4+
ICsJCQl1OCAqcG9saWN5ID0gICZwYXJhbS0+cnNuX2F1dGhfcG9saWN5W2ldOw0KPj4gKw0KPj4g
KwkJCSpwb2xpY3kgPSBpZXNbcnNuX2lkeCArICgoaiArIDEpICogNCkgLSAxXTsNCj4+ICsJCX0N
Cj4+ICsNCj4+ICsJCSphdXRoX3RvdGFsX2NudCArPSBhdXRoX2NudDsNCj4+ICsJCXJzbl9pZHgg
Kz0gb2Zmc2V0Ow0KPj4gKw0KPj4gKwkJaWYgKGllc1tpbmRleF0gPT0gV0xBTl9FSURfUlNOKSB7
DQo+PiArCQkJcGFyYW0tPnJzbl9jYXBbMF0gPSBpZXNbcnNuX2lkeF07DQo+PiArCQkJcGFyYW0t
PnJzbl9jYXBbMV0gPSBpZXNbcnNuX2lkeCArIDFdOw0KPj4gKwkJCXJzbl9pZHggKz0gMjsNCj4+
ICsJCX0NCj4+ICsJCXBhcmFtLT5yc25fZm91bmQgPSB0cnVlOw0KPj4gKwkJaW5kZXggKz0gaWVz
W2luZGV4ICsgMV0gKyAyOw0KPj4gKwl9IGVsc2Ugew0KPj4gKwkJaW5kZXggKz0gaWVzW2luZGV4
ICsgMV0gKyAyOw0KPj4gKwl9DQo+PiArDQo+PiArCSpvdXRfaW5kZXggPSBpbmRleDsNCj4+ICt9
DQo+IA0KPiBBZ2FpbiwgdXNlIGFjdHVhbCBrZXJuZWwgaW5mcmFzdHJ1Y3R1cmUgZm9yIG11Y2gg
b2YgdGhpcy4NCj4gDQo+PiArCWN1cl9ieXRlID0gd2lkLnZhbDsNCj4+ICsJKmN1cl9ieXRlKysg
PSAocGFyYW0tPmludGVydmFsICYgMHhGRik7DQo+PiArCSpjdXJfYnl0ZSsrID0gKChwYXJhbS0+
aW50ZXJ2YWwgPj4gOCkgJiAweEZGKTsNCj4+ICsJKmN1cl9ieXRlKysgPSAoKHBhcmFtLT5pbnRl
cnZhbCA+PiAxNikgJiAweEZGKTsNCj4+ICsJKmN1cl9ieXRlKysgPSAoKHBhcmFtLT5pbnRlcnZh
bCA+PiAyNCkgJiAweEZGKTsNCj4gDQo+IHB1dF91bmFsaWduZWRfbGUzMigpLg0KPiANCg0KQWdy
ZWUNCg0KPj4gKwkqY3VyX2J5dGUrKyA9IHBhcmFtLT5haWQgJiAweEZGOw0KPj4gKwkqY3VyX2J5
dGUrKyA9IChwYXJhbS0+YWlkID4+IDgpICYgMHhGRjsNCj4gDQo+IGFuZCBzbyBvbg0KPiANCj4g
YnV0IHRoZW4gYWdhaW4sIEkganVzdCBzdWdnZXN0ZWQgdG8gbm90IGhhdmUgdGhlc2UgInBhY2si
IGZ1bmN0aW9ucyB0bw0KPiBzdGFydCB3aXRoLCBvciBhdCBsZWFzdCBub3QgaW4gdGhpcyB3YXks
IHNpbmNlIGl0IGp1c3QgbWVhbnMgeW91IGZpcnN0DQo+IHBhY2sgZXZlcnl0aGluZyBpbnRvIGhv
c3Qgc3RydWN0cywgYW5kIHRoZW4gcmVwYWNrIGV2ZXJ5dGhpbmcgYWdhaW4gaW50bw0KPiBmaXJt
d2FyZSBmb3JtYXQgLi4uDQo+IA0KDQpBZ3JlZS4NCkluc3RlYWQgb2YgcGFja2luZyB0aGUgcGFy
YW1ldGVycyBpbiBob3N0IHN0cnVjdHVyZXMgbGlrZSBzdHJ1Y3QgYWRkX3N0YV9wYXJhbSwgdGhl
biByZXBhY2tpbmcgaXQgaW4gdGhlIGRldmljZSBmb3JtYXQsIGl0IGNhbiB1c2Ugc3RydWN0IHN0
YXRpb25fcGFyYW1ldGVycyBhbmQgcGFjayB0aGVtIGRpcmVjdGx5IGludG8gdGhlIGRldmljZSBm
b3JtYXQNCj4gDQo+IFNvIGZhciBJIGd1ZXNzIEknZCBzYXk6DQo+ICAqIHVzZSBtb3JlIGtlcm5l
bCBpbmZyYSwgaW4gcGFydGljdWxhciB7Z2V0LHB1dH1fdW5hbGlnbmVkX2xlezE2LDMyfQ0KPiAg
KiBuYW1lIHlvdXIgZGV2aWNlL2RyaXZlci1zcGVjaWZpYyBjb25zdGFudHMgYmV0dGVyLCByYXRo
ZXIgdGhhbiB0aGluZ3MNCj4gICAgbGlrZSAiU0VUX0NGRyIgd2hpY2ggbGVhdmUgZXZlcnlvbmUg
d29uZGVyaW5nIGlmIGl0J3Mgc3BlY2lmaWMgdG8NCj4gICAgdGhpcyBkcml2ZXIgb3Igc29tZXRo
aW5nIGZyb20gZWxzZXdoZXJlDQo+IA0KPiBqb2hhbm5lcw0KPiANCg==
