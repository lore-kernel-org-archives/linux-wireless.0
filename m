Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D343CC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 06:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910AE2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 06:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="DvmLiGZI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 910AE2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbeKFPZD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 10:25:03 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:60425 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbeKFPZD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 10:25:03 -0500
X-IronPort-AV: E=Sophos;i="5.54,470,1534834800"; 
   d="scan'208";a="22871471"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 23:01:30 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 23:01:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47rnpp1CmXvk2Fe7ZC/E4f/F5ChKmKe878K5LHSzjuc=;
 b=DvmLiGZIfl0SGuSEjxTZkrysIbH6K9tTz+YSLT7pxdbHY+tOy0gixN7wHFGPtjYWhh4KRvdahtEILbsUSn3Go6dRU9xU7+et0fKWQsN7nPnNsVQl7c1f6zwpkzFjYOug1uzIx1DinZE/9bRTznZojvjft3k3fjELl14aq9G7jpg=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3319.namprd11.prod.outlook.com (20.177.185.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Tue, 6 Nov 2018 06:01:28 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 06:01:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <joe@perches.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Adham.Abozaeid@microchip.com>,
        <Aditya.Shankar@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Topic: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Index: AQHUcgJD9vPPwH1+N0OaOZ3PcNN1IqVBCMkAgAAWV4CAAD1rgIAA67OA
Date:   Tue, 6 Nov 2018 06:01:28 +0000
Message-ID: <4e8e5660-832f-3921-41bb-d667bca9b1ab@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
 <1541090691-31928-5-git-send-email-ajay.kathat@microchip.com>
 <0244e9225446db503360d9c024e0eb7e25c29944.camel@perches.com>
 <fcd1665b-4e75-54f0-ff77-08807fa311f6@microchip.com>
 <0bbb80aef8f5d133335787c08c46a7a104072f81.camel@perches.com>
In-Reply-To: <0bbb80aef8f5d133335787c08c46a7a104072f81.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0010.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::20) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.216.87]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3319;6:2FXjYmifIcMa0hBfPBgS7i9DDlkSf3eYz9uwhfeCYwxxWNkiR7rX0WMK3H/AED+iHpA5CJjfkevdnh3SO4Ff1lZxfidnmLhRc1hXzFOSKaG5zPPcq8d5oUd0HyQgb9onHdP0M3otrFvUah+A5sklCyJ7vr4iZnA5I0jtucE7tuG26kUn7sueOAMf2WzEy3neN6ql3M0X/yh2gYil9IIPL4e/HMtkMW4OVMVXwj0CV/ApkwfH4gUwxWxvNqk7s0b4IdhdndIeJvB1Er1UjakAUhAJnSOPU28kur0TJd4iGUxQiXv7ocze0DsURG51Nol1htFoooCWh2PV7ywjTgVTJE2rDCutWUA+IgFXgo9ThgzXaP5Te/OZaNl7BDRnBsphrqMsYEC1frdO12zcrG7NhH+mEaPVL6L1Yi4zKoR4d3cLb8CbPxKDVuIg1gNymlbJYdvti/+txxo/NAhuL+FasQ==;5:22sSZFLY+EnNqxbRMbiVXCM1JOVozlD9WMQG35XmZuhXoBV4Y5BW1mgkTDc24Ho6/tAlSLZLaRfcCSqTzNq2eYuIN2rsdz6k4g/lqB7YWBzvYsvuwr3GBA5lCSPwHnpopO0ZsH0yOk/pTBeVs0x84REw0HGXkSnojLRgE2AEN5Q=;7:Xp23+WqdwcwxDCkZABMwjgLmJU3mVzH8uE97PbdlYPCJ8QNoOmX9m/XnsdjA9per2fzRKqd1YdCeE5Y+96Ce+DaAUd6BILOoByEE5eb+7Tcr5syNM9y31QQq7XLKmcjus6U8IzuX5EpW4plDBpEFWQ==
x-ms-office365-filtering-correlation-id: bf0bb1e3-163a-445d-3452-08d643ad4a9c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3319;
x-ms-traffictypediagnostic: BYAPR11MB3319:
x-microsoft-antispam-prvs: <BYAPR11MB33194936383DCDB8A4D3FE0CE3CB0@BYAPR11MB3319.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3319;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3319;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(396003)(39860400002)(366004)(189003)(199004)(105586002)(97736004)(31686004)(106356001)(256004)(186003)(3846002)(2900100001)(6116002)(5660300001)(52116002)(99286004)(26005)(478600001)(102836004)(386003)(6506007)(76176011)(36756003)(305945005)(7736002)(2501003)(110136005)(54906003)(316002)(66066001)(14454004)(72206003)(93886005)(6246003)(53546011)(81166006)(81156014)(6436002)(8936002)(446003)(11346002)(8676002)(6512007)(86362001)(2616005)(486006)(229853002)(68736007)(2906002)(476003)(25786009)(31696002)(78486014)(4326008)(71190400001)(71200400001)(53936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3319;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UzpVoTT5SE7P8a8D6euYV25Qp2kInDVJYtwT+pk2/HomgxsVUp75EcnoQkMaYEcTXqJSFonM35g/s55NpQ1BnT4vnMvsPr40z/gIVhwDHvYe2FBiJ+97/WfVreepK1Uint4gxhJA4HdbxEqA2e0AIUM+eWgcT5QreBEKiCCZo6oDPtuT6rBf86W2JKrCMHBs96N2xsYs1+KMv8UUQIoL+deWwI7ZV1GBbp9YStxV6oxT/2FtUFLDHDMT+EwLWmqJQfu6DOhcKYq4+bxhN52qnDSFpM8Ohf4nVks8T1Dji2IAfmwdl4d+0mhVqEShgjQB3Qgt1qHzTgJIduJz8NmOg4yeiAmWzWtWy4nu9lGdX8Y=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ECC894A3ADAD4408F816A3CC9EFFEBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0bb1e3-163a-445d-3452-08d643ad4a9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 06:01:28.3750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3319
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQpPbiAxMS81LzIwMTggOToyNyBQTSwgSm9lIFBlcmNoZXMgd3JvdGU6DQo+IE9uIE1vbiwgMjAx
OC0xMS0wNSBhdCAxMjoxOCArMDAwMCwgQWpheS5LYXRoYXRAbWljcm9jaGlwLmNvbSB3cm90ZToN
Cj4+IEhpIEpvZSwNCj4+DQo+PiBPbiAxMS81LzIwMTggNDoyNyBQTSwgSm9lIFBlcmNoZXMgd3Jv
dGU6DQo+Pj4gT24gVGh1LCAyMDE4LTExLTAxIGF0IDE2OjQ1ICswMDAwLCBBamF5LkthdGhhdEBt
aWNyb2NoaXAuY29tIHdyb3RlOg0KPj4+PiBGcm9tOiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBt
aWNyb2NoaXAuY29tPg0KPj4+Pg0KPj4+PiBVc2Ugc2hvcnRlciBuYW1lIGZvciAnbmV0d29ya19p
bmZvJyB2YXJpYWJsZSB0byBhdm9pZCBsaW5lIG92ZXIgODAgY2hhcnMNCj4+Pj4gaXNzdWUuDQo+
Pj4gSSBzdXBwb3NlIHRoaXMgaXMgT0ssIHRob3VnaCBwZXJoYXBzIHVubmVjZXNzYXJ5Lg0KPj4+
DQo+Pj4gQXMgd2VsbCwgcGVyaGFwcyB0aGVyZSBhcmUgZGVmZWN0cyBpbiB0aGUgb3JpZ2luYWwg
Y29kZQ0KPj4+IGluIGEgY291cGxlIHBsYWNlcy4NCj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dpbGMxMDAwL2NvcmVjb25maWd1cmF0b3IuYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93aWxjMTAwMC9jb3JlY29uZmlndXJhdG9yLmMNCj4+PiBbXQ0KPj4+PiAtCQluZXR3b3JrX2lu
Zm8tPnRzZl9oaSA9IGxlNjRfdG9fY3B1KG1ndC0+dS5iZWFjb24udGltZXN0YW1wKTsNCj4+Pj4g
LQkJbmV0d29ya19pbmZvLT50c2ZfbG8gPSAodTMyKW5ldHdvcmtfaW5mby0+dHNmX2hpOw0KPj4+
IFBlcmhhcHMgdGhlcmUgaXMgYSBkZWZlY3QgZm9yIGJvdGggdHNmX2hpIGFzc2lnbm1lbnRzDQo+
Pj4gYXMgaXQgYXBwZWFycyBhcyBpZiBib3RoIGFyZSBtaXNzaW5nICI+PiAzMiINCj4+IEFjdHVh
bGx5LCAndHNmX2hpJyBpcyB1c2VkIHRvIHN0b3JlIHRoZSBjb21wbGV0ZSB0c2YgdmFsdWUgYXMg
aXRzIGRhdGENCj4+IHR5cGUgaXMgdTY0LiAgVGhpcyB2YWx1ZSBpcyBwYXNzIHRvIHRoZSBjZmc4
MDIxMV9pbmZvcm1fYnNzKCkgYXMgaXQgaXMuDQo+PiBTbyB0aGUgY29udmVyc2lvbiBvZiAndHNm
X2hpJyB0byAzMiBiaXQgIGlzIG5vdCByZXF1aXJlZCBpbiB0aGlzIGNhc2UuDQo+IEFudGlwYXR0
ZXJuIG5hbWluZyBnZW5lcmFsbHkgd2FycmFudHMgYSByZW5hbWUuDQo+DQpUaGFua3MgSm9lLg0K
U3VyZSwgSSB3aWxsIHJlbmFtZSB0c2ZfaGkgaW4gZnV0dXJlIHBhdGNoIHRvIGhhdmUgY2xlYXIg
bWVhbmluZy4NCg0KUmVnYXJkcywNCkFqYXkNCg==
