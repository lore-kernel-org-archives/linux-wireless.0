Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47EAC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 12:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B68920819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 12:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="kAsvp7qE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B68920819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbeKEVhf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:37:35 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:65386 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVhf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:37:35 -0500
X-IronPort-AV: E=Sophos;i="5.54,467,1534834800"; 
   d="scan'208";a="22826512"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 05:18:06 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 05:18:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgIRI1dB03urhEhcZbpdgccCiOS2ADI7FHTKU7V8W6M=;
 b=kAsvp7qEPKnpOUh5L9S2HOcZZIBiB3Sfx1zQQcJvDJXIqC5FlSRw3rtPJTtI25D4Ri/FDhmEzHsqO8eSjx9vxypxVtqQWCnmnQeFcvbu0lnUAesVkR8KRSGoLMHh2jstuyRm0LeatUAkgSfiSRx2se3ZLCyEOPFz5eVPiKjKbbU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 5 Nov 2018 12:18:04 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 12:18:04 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <joe@perches.com>, <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Topic: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Index: AQHUcgJD9vPPwH1+N0OaOZ3PcNN1IqVBCMkAgAAWV4A=
Date:   Mon, 5 Nov 2018 12:18:04 +0000
Message-ID: <fcd1665b-4e75-54f0-ff77-08807fa311f6@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
 <1541090691-31928-5-git-send-email-ajay.kathat@microchip.com>
 <0244e9225446db503360d9c024e0eb7e25c29944.camel@perches.com>
In-Reply-To: <0244e9225446db503360d9c024e0eb7e25c29944.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.216.87]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2567;6:egFBDDYdWOERykYa9X23Fj+d/X0ni1DrvKjUi399OOh3nG/F00sssr1KSdZCR6esGuXetIpOc9hAFc9OlkBxIVlU76gtUU7mtvlbvW3yc9T0zvFnQYB2cwNSmNk4PmS9FBHFfO76EwPiPljTaV0szB5o1RKvLV/hckr6WkQ4wDaB6R4+wh8JA8vamTLBS3F3hDxgw6AH6V+KFZKU7bXD5BucvlGnER/aZEDFqaG7ChaR/+sQNiCopesO+TH5KfTIC9Mu+wKwCkCxGmJUtGVqSeP/ibqKbzur2RxvTGHWDaa+QIcePKrj37acGdhmHspO8KUnxQlTiwoTXH4VY89Vad9ZHfWdQXEWOZFlPdxIp1TI4pyHIohzxQA2g4osEiB13m6PQg4ZEno6m5gDLunyp1oQQtb+bT5e+TYGA3CsqWZtF1BSPcHnqva1D0DUZ6IA+XHmeKo+8fWu6AiCA6AhEw==;5:W4AwJQzwyiMbLmw6LHb90ZCx4Yg5gm22bkZLzKWhYtN1F5BX5QQPdyn2MVinE+iQsapsG+fS1IRDq9DzQxeInGNOQrRE2hkNcKWUFfa4tAnUvgAKQDro1DnTDPwa7OaThsz3fXUC072GHH/jEzPuiFDE3Cf1i0ALzD7BaXil3bQ=;7:wXwO4EBQCLpQHfkL+Ja0/jy8MP+4IWybyelBJShpaxaWhiMvfwI3FzBVUL5eezZsRVqWdqWZNikq1ed0cdlyDHOAV5vpSTxP3h3icGyCyR6tUPZ8Aupi7fVg40eO7CgeTgj2wvgv/sZlNZiRqi0q9Q==
x-ms-office365-filtering-correlation-id: 7376c440-36c5-4f9a-0c3b-08d64318bc25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2567;
x-ms-traffictypediagnostic: BYAPR11MB2567:
x-microsoft-antispam-prvs: <BYAPR11MB256733CB3C3BC3CA4B03C826E3CA0@BYAPR11MB2567.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(10201501046)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2567;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2567;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(376002)(39860400002)(346002)(199004)(189003)(229853002)(2616005)(4326008)(6512007)(6246003)(25786009)(486006)(71190400001)(97736004)(71200400001)(476003)(6436002)(53936002)(446003)(11346002)(5660300001)(81166006)(86362001)(81156014)(68736007)(8676002)(6116002)(3846002)(72206003)(8936002)(110136005)(14454004)(54906003)(316002)(36756003)(478600001)(256004)(31696002)(305945005)(66066001)(78486014)(2501003)(106356001)(7736002)(53546011)(386003)(6506007)(102836004)(76176011)(52116002)(2906002)(186003)(26005)(31686004)(2900100001)(105586002)(99286004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2567;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: DgZ3siFNN6ssQyEPotxVrOzNcmUsJnqWv5H2vhPoTulJcmKsCAZzwT8VbIU/wwAmbECWm/zLjlalaOIpcLhJucEBNmF2kiIEuRP+JP/IMwDFmZtb+67G5A52kj3cY+CmU/Pg9mxwtOwft9VOJyPqAXO4xk5R/HLreOKgqiFR2f36eiqvE8GM0vroUrx+TSDTP3NWEGeB8STelXmGJgasCL8yKTX9T9+XF0afhACuY3wLIZVHg5HyDOpcVHBogRWUSDpa1sPuksHvbIwl0oi0I8Deqdiq+6rVnRHclCh5tPk5PjbXdMv/ue5VMWdoJUaH+H60y+XMF1WqcGT86clByoR3AT13Mc3/HVuTA3sdQn8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <C36332CDAEB95A499ED16EED2947943E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7376c440-36c5-4f9a-0c3b-08d64318bc25
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 12:18:04.1429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2567
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgSm9lLA0KDQpPbiAxMS81LzIwMTggNDoyNyBQTSwgSm9lIFBlcmNoZXMgd3JvdGU6DQo+IE9u
IFRodSwgMjAxOC0xMS0wMSBhdCAxNjo0NSArMDAwMCwgQWpheS5LYXRoYXRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+IEZyb206IEFqYXkgU2luZ2ggPGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+
DQo+Pg0KPj4gVXNlIHNob3J0ZXIgbmFtZSBmb3IgJ25ldHdvcmtfaW5mbycgdmFyaWFibGUgdG8g
YXZvaWQgbGluZSBvdmVyIDgwIGNoYXJzDQo+PiBpc3N1ZS4NCj4NCj4gSSBzdXBwb3NlIHRoaXMg
aXMgT0ssIHRob3VnaCBwZXJoYXBzIHVubmVjZXNzYXJ5Lg0KPg0KPiBBcyB3ZWxsLCBwZXJoYXBz
IHRoZXJlIGFyZSBkZWZlY3RzIGluIHRoZSBvcmlnaW5hbCBjb2RlDQo+IGluIGEgY291cGxlIHBs
YWNlcy4NCj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvY29yZWNv
bmZpZ3VyYXRvci5jIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2NvcmVjb25maWd1cmF0b3Iu
Yw0KPiBbXQ0KPj4gLQkJbmV0d29ya19pbmZvLT50c2ZfaGkgPSBsZTY0X3RvX2NwdShtZ3QtPnUu
YmVhY29uLnRpbWVzdGFtcCk7DQo+PiAtCQluZXR3b3JrX2luZm8tPnRzZl9sbyA9ICh1MzIpbmV0
d29ya19pbmZvLT50c2ZfaGk7DQo+IFBlcmhhcHMgdGhlcmUgaXMgYSBkZWZlY3QgZm9yIGJvdGgg
dHNmX2hpIGFzc2lnbm1lbnRzDQo+IGFzIGl0IGFwcGVhcnMgYXMgaWYgYm90aCBhcmUgbWlzc2lu
ZyAiPj4gMzIiDQoNCkFjdHVhbGx5LCAndHNmX2hpJyBpcyB1c2VkIHRvIHN0b3JlIHRoZSBjb21w
bGV0ZSB0c2YgdmFsdWUgYXMgaXRzIGRhdGENCnR5cGUgaXMgdTY0LsKgIFRoaXMgdmFsdWUgaXMg
cGFzcyB0byB0aGUgY2ZnODAyMTFfaW5mb3JtX2JzcygpIGFzIGl0IGlzLg0KU28gdGhlIGNvbnZl
cnNpb24gb2YgJ3RzZl9oaScgdG8gMzIgYml0wqAgaXMgbm90IHJlcXVpcmVkIGluIHRoaXMgY2Fz
ZS4NCg0KPj4gKwkJaW5mby0+Y2FwX2luZm8gPSBsZTE2X3RvX2NwdShtZ3QtPnUuYmVhY29uLmNh
cGFiX2luZm8pOw0KPj4gKwkJaW5mby0+YmVhY29uX3BlcmlvZCA9IGxlMTZfdG9fY3B1KG1ndC0+
dS5iZWFjb24uYmVhY29uX2ludCk7DQo+PiArCQlpbmZvLT50c2ZfaGkgPSBsZTY0X3RvX2NwdSht
Z3QtPnUuYmVhY29uLnRpbWVzdGFtcCk7DQo+PiArCQlpbmZvLT50c2ZfbG8gPSAodTMyKWluZm8t
PnRzZl9oaTsNCj4gUGVyaGFwcyB0aGlzIHNob3VsZCBiZSANCj4NCj4gCQluZXR3b3JrX2luZm8t
PnRzZl9oaSA9IGxlNjRfdG9fY3B1KG1ndC0+dS5iZWFjb24udGltZXN0YW1wKSA+PiAzMjsNCj4N
Cj4gb3INCj4NCj4gCQluZXR3b3JrX2luZm8tPnRzZl9oaSA9IHVwcGVyXzMyX2JpdHMobGU2NF90
b19jcHUoLi4uKSk7DQo+IAkJbmV0d29ya19pbmZvLT50c2ZfbG8gPSBsb3dlcl8zMl9iaXRzKGxl
NjRfdG9fY3B1KC4uLikpOw0KPg0KPg0K
