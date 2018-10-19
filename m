Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF016ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 21:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBAB20843
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 21:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="AnxrGYdk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DBAB20843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbeJTF4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 01:56:03 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:9331 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeJTF4C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 01:56:02 -0400
X-IronPort-AV: E=Sophos;i="5.54,401,1534834800"; 
   d="scan'208";a="22738964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 Oct 2018 14:47:45 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 19 Oct 2018 14:47:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKaRBJVL2iBqP8tnxbpjfCHGGropWsLhQGYleFS1d0w=;
 b=AnxrGYdkyI648Y4dLy55iGhheb/HLlv8wRNyQ5rD5rdt8UHd13HmcVYkQ8lf8BhvTZJ/i8WpeTjxPi7v04eJQHtRDbHgbAksq3BvmiRM9TyDCzJp5f69PzOk0Fq7BLwWISalb7fbgKf528S/OUm2DTOa38IEcvQsLp1fYBJsIFw=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0336.namprd11.prod.outlook.com (10.160.136.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Fri, 19 Oct 2018 21:47:39 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%9]) with mapi id 15.20.1228.032; Fri, 19 Oct 2018
 21:47:39 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Topic: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Index: AQHUVYNjmo/tPFE0lEmad1H8ViJjG6UVg8bJgADg4gCAADsvAIAAJzCAgBB4o4A=
Date:   Fri, 19 Oct 2018 21:47:39 +0000
Message-ID: <5BCA50F7.3080809@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2)
 <1539010630.3687.86.camel@sipsolutions.net>
         <5BBC2D46.1060903@microchip.com>
 <1539071724.3687.87.camel@sipsolutions.net> <5BBCE23B.6050003@microchip.com>
In-Reply-To: <5BBCE23B.6050003@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0083.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::43) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0336;6:Lej1dp1hyLAsmdxM/k/5tGj6/8qslVQL4Yp8l24wVMDmaEBsUYpfynujCHfudmxOuluiIM3vatZHdroxQYNhPvYOaAtLOTEKxSzRjh5iKT/DIfO2GDGhG24tY7rHW8NHFtJQEY58BfijC9NW2l+0Mr8OnhktnxVHNMUdwCvoAN2tbv5TFJr1kJy2RvlNf6oBneTGw37NJPHeOXPQ0F3GpCgRqdn80rLBKW5TxU9WMOX+Ts3OcO0o1XySzwEkn/yoWIT6HahTZtWrqxEvCTC582UUUsEYfsR5j2F+7Z/hdxrofiabwmUyD3jvc2aVbgvqSTQb4wL/N1r134A2KQXIjxz3XxsDkvACJb9aXZxe7juZLZ/CJAyDOl+3IREviNS+Fs4Mx7t98ECzhijIdCm1jecXnqgJFtoDhvdzgFBx9dWuHVxPkYNDk7bS39oHh/8sQH55fbBOL63DXx256HN6Ew==;5:cQAnut3Ut/WswV0CxByy/gACtkt2L4RUlgMfnpEg+WNAWCV7fikT6/cMbykSJdqg+qbPWKjLCxhrNKfJrFKSl7V3zEn2xv+1UtlM98TnrZz3TFPz8JoIL4+rn1dvGGzwNwR6XoxD9CRBcGoaYo02tAahwOYwx1q5xVIhmlzYqbM=;7:8J4xnhsFezJURXfjJc2kijwaKPox1cqPLdwKdjy/GS7ymTTcB0VQz0D+ICJqFfs6Fe9k0qtJ4O9k6jmIznydoTvz6/2AclbJWKsbnlKtoATgACQf+4wKJ5UHkx3l29l5hGNd5RWulnqsvh+XHDPNSEZSY5LXGpBOL7LfYol0Do4XHM4sM76niiv8Jvo5Ll63cVaE8GGltENFMvKKofw3tvDIkI7MUDuR6AnEhkw+VbbUkfPdEHsaqmO+oYNGvYjs
x-ms-office365-filtering-correlation-id: e8f8e959-048c-41a5-3ad7-08d6360c7ce5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0336;
x-ms-traffictypediagnostic: DM2PR11MB0336:
x-microsoft-antispam-prvs: <DM2PR11MB033699A0B34DEFC2885D04128DF90@DM2PR11MB0336.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(93006095)(93001095)(3231355)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0336;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0336;
x-forefront-prvs: 0830866D19
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(136003)(396003)(39860400002)(199004)(189003)(52314003)(43544003)(102836004)(110136005)(6486002)(2616005)(106356001)(68736007)(2900100001)(5660300001)(486006)(6436002)(2501003)(4326008)(105586002)(229853002)(93886005)(446003)(71190400001)(58126008)(71200400001)(5250100002)(7736002)(87266011)(86362001)(53936002)(478600001)(316002)(2906002)(8936002)(81166006)(8676002)(97736004)(54906003)(6246003)(80316001)(81156014)(25786009)(53546011)(26005)(305945005)(107886003)(14444005)(65816011)(6116002)(6512007)(186003)(256004)(36756003)(65806001)(52116002)(3846002)(59896002)(76176011)(14454004)(11346002)(33656002)(6506007)(72206003)(386003)(99286004)(66066001)(64126003)(476003)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0336;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: c8IejQKIHGe5U6GJKzo6LqN6fWnPvQXZosLHKBL8zEX3q9NTKckn1vRr5Jle5t60K3VpGdx/u9guXhKaRXI3C0AyDRHX0D7Pqx1rotEEkSDOE4HaKnu5eIsfwb9FRRf/6uaVjjCBJdRhxlx6MxZfQpHKurA0yeReGeEUGovSAhSSXeflkWobFHw0HRhsPTv9F7vhHrHHcSwTUT2irmFgsZlkEIX6MZu/qIDyjwr4jk0JP1UaE3ZlhwOZsbCU8x2a5Bq1q9doIa1tdrGTbVk2P/Rc4U84yZSPDqB9u9xRDT5ESqUWBk0PSmdVgHqv1H7no2rLumKsTl5/CGGdRx5PPJn7Iv1Q3I9w1gb0LbLSuow=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <5241CE33D3AA07468C6C3729C0977C11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f8e959-048c-41a5-3ad7-08d6360c7ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2018 21:47:39.3502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0336
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA5LzIwMTggMTA6MTUgQU0sIEFkaGFtIEFib3phZWlkIHdyb3RlOg0KPiANCj4g
DQo+IE9uIDEwLzA5LzIwMTggMTI6NTUgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+PiBPbiBU
dWUsIDIwMTgtMTAtMDkgYXQgMDQ6MjMgKzAwMDAsIEFkaGFtLkFib3phZWlkQG1pY3JvY2hpcC5j
b20gd3JvdGU6DQo+Pj4NCj4+Pj4gSSBkb24ndCBrbm93IHdoYXQgeW91IG5lZWQgdGhlIHNoYWRv
dyBzdHVmZiBmb3IsIGJ1dCB5b3Ugc2hvdWxkIHJlbW92ZQ0KPj4+PiBpdCBhbnl3YXksIGFuZCB1
c2UgdGhlIGNmZzgwMjExIGZ1bmN0aW9uYWxpdHkgaW5zdGVhZC4gSWYgbm90DQo+Pj4+IHN1ZmZp
Y2llbnQsIHByb3Bvc2UgcGF0Y2hlcyB0byBpbXByb3ZlIGl0Pw0KPj4+DQo+Pj4gVGhlIHBvaW50
IGJlaGluZCB1c2luZyBhIHNoYWRvdyBidWZmZXIgd2FzIHRvIGtlZXAgdGhlIHNjYW4gcmVzdWx0
cw0KPj4+IGNvbnNpc3RlbnQgYmV0d2VlbiBjb25zZWN1dGl2ZSBzY2FucywgYW5kIHNtb290aCBv
dXQgdGhlIGNhc2VzIHdoZXJlDQo+Pj4gYW4gQVAgaXNuJ3QgZm91bmQgbW9tZW50YXJpbHkgZHVy
aW5nIHNjYW5uaW5nLg0KPj4+IEluIHRoaXMgaW1wbGVtZW50YXRpb24sIEFQcyBmb3VuZCBkdXJp
bmcgc2Nhbm5pbmcgYXJlIGFkZGVkIHRvIHRoZQ0KPj4+IHNoYWRvdyBsaXN0LCBhbmQgcmVtb3Zl
ZCBpZiBub3QgZm91bmQgYWdhaW4gZm9yIGEgcGVyaW9kIG9mIHRpbWUuDQo+Pj4NCj4+PiBJJ20g
bm90IG11Y2ggaW4gZmF2b3VyIG9mIHRoaXMgaW1wbGVtZW50YXRpb24gbmVpdGhlciBzaW5jZSBp
dA0KPj4+IGNvbXBsaWNhdGVzIHRoZSBkcml2ZXIncyBsb2dpYywgYnV0IGl0IHdhcyBzZXJ2aW5n
IHRoZSBwdXJwb3NlLg0KPj4NCj4+IFlvdSByZWFsbHkgc2hvdWxkIHJlbW92ZSBpdCAtIGNmZzgw
MjExICphbmQqIHdwYV9zIGFscmVhZHkgZG8gdGhpcyBpZg0KPj4gcmVxdWlyZWQuDQo+Pg0KPj4g
am9oYW5uZXMNCj4+DQo+IA0KPiBUaGFua3MgSm9oYW5uZXMgZm9yIHRoZSB0aXAuIEkgZGlkIHNv
bWUgcmVzZWFyY2gsIGFuZCBJIGJlbGlldmUgeW91IGFyZQ0KPiByZWZlcnJpbmcgdG8gdXNpbmcg
YnNzX2V4cGlyZV9hZ2UgYW5kIGJzc19leHBpcmVfY291bnQuDQo+IFdlJ2xsIGdvIGFoZWFkIGFu
ZCByZW1vdmUgdGhhdC4NCg0KDQpKb2hhbm5lcywgc2hhZG93IGJ1ZmZlciBoYXMgMiBtb3JlIHVz
YWdlIHRoYXQgSSBtaXNzZWQgaW4gbXkgZmlyc3QgZW1haWw6DQoxLSBJdCBrZWVwcyBhIGNvcHkg
b2Ygc2NhbiByZXN1bHRzIHRvIGJlIGFibGUgdG8gYXV0by1zZWxlY3QgZnJvbSBpZiB0aGUgY2Zn
ODAyMTEgZGlkbid0IHN1cHBseSBhIHNwZWNpZmljIGJzc2lkIGluIGNmZydzIGNvbm5lY3QgcmVx
dWVzdCAoc3RydWN0IGNmZzgwMjExX2Nvbm5lY3RfcGFyYW1zKS4NCkluIHRoaXMgY2FzZSB0aGUg
ZHJpdmVyIHdpbGwgc2VsZWN0IGEgbmV0d29yayB0aGF0IG1hdGNoZXMgdGhlIHNzaWQsIHdoaWxl
IGhhdmluZyB0aGUgaGlnaGVzdCByc3NpLg0KMi0gSXQga2VlcHMgbmV0d29yayBwYXJhbWV0ZXJz
IHRoYXQgdGhlIGRldmljZSB3aWxsIG5lZWQgdG8gY29ubmVjdCB0byBhIG5ldHdvcmssIHNpbmNl
IHRoZSBkZXZpY2UgZG9lc24ndCBrZWVwIHRoZSBzY2FuIHJlc3VsdHMgaW50ZXJuYWxseS4NClRo
ZXNlIHBhcmFtZXRlcnMgYXJlIHN0b3JlZCBpbiBzdHJ1Y3Qgam9pbl9ic3NfcGFyYW0sIGFuZCBw
YXNzZWQgdG8gdGhlIGRldmljZSAgd2hlbiBhIGNvbm5lY3QgcmVxdWVzdCBpcyByZWNlaXZlZC4N
ClNvbWUgb2YgdGhlc2UgcGFyYW1ldGVycyBjYW4gYmUgZXh0cmFjdGVkIGZyb20gY2ZnJ3MgY2Zn
ODAyMTFfY29ubmVjdF9wYXJhbXMgKGxpa2UgY2FwX2luZm8uLiBldGMpLCBidXQgb3RoZXJzIChs
aWtlIGJzc2lkLCBiZWFjb24gcGVyaW9kLi4gZXRjKSBhcmUgc3RpbGwgcmVxdWlyZWQuDQoNCkkg
dGhpbmsgSSBjYW4gcmVtb3ZlIHRoZSBmdW5jdGlvbmFsaXR5IHdoZXJlIGl0IGtlZXBzIG9sZGVy
IG5ldHdvcmtzIHRoYXQgZGlkbid0IGFwcGVhciBpbiB0aGUgbGF0ZXN0IHNjYW4gcmVzdWx0cywg
YW5kIGxldCBjZmcgdGFrZSBjYXJlIG9mIHRoYXQsIGJ1dCB3aWxsIHN0aWxsIG5lZWQgaXQgdG8g
a2VlcCBhIGNvcHkgb2YgdGhlIGxhdGVzdCBzY2FuIHJlc3VsdHMuDQpMZXQgbWUga25vdyB3aGF0
IHlvdSB0aGluay4NCg0KDQpUaGFua3MsDQpBZGhhbQ0K
