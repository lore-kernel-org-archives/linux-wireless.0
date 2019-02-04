Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D49C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 09:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084662147A
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 09:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Gtp4Okr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfBDJmk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 04:42:40 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:27803 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfBDJmj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 04:42:39 -0500
X-IronPort-AV: E=Sophos;i="5.56,559,1539673200"; 
   d="scan'208";a="27247288"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 04 Feb 2019 02:42:38 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 4 Feb 2019 02:42:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Jvq7ddCxdqNwr04ZXsjxvuhzRT/Q9/3n8o0R3dPbCk=;
 b=Gtp4Okr7SW6unsbm/8/53DfH8LbGowKzlbP/IMn1fJtIu0TEuze57G0Xco4d2u0hFOKhbRsbFdKfqD7vF1M2zDSj89OCpWuroJcd8EU8YYneTPAoHWMyfL+vudxstkwmwk9TgRVyqDSfzHWTRZowy3l56ZHBm7s+LwhIsWx1vhc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3558.namprd11.prod.outlook.com (20.178.206.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Mon, 4 Feb 2019 09:42:37 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Mon, 4 Feb 2019
 09:42:37 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <dan.carpenter@oracle.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <Adham.Abozaeid@microchip.com>
Subject: Re: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Thread-Topic: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Thread-Index: AQHUuyvnTipBfoysokuAty4Jr8EL5aXPTM6AgAAYtAA=
Date:   Mon, 4 Feb 2019 09:42:36 +0000
Message-ID: <fdcab6a0-cf91-dc85-d674-ce4a3c9bd54d@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
 <1549134974-5545-9-git-send-email-ajay.kathat@microchip.com>
 <20190204081357.GC2563@kadam>
In-Reply-To: <20190204081357.GC2563@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2401:4900:2747:e619:11f1:c80d:838e:a775]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3558;6:Es5rumruV+LKxFGN1IUdosAOupY7KmZ7g5QaF5ASXDfjmT7sXINetoqgREI7NFLbv2Dm9Lu4SXIzG3aUsf/dYK9Qv4J8h7tkyNjcxr4VPqKfZle3i3Sa+d2pVfXNj+n7sRS45tKE/oLStr/lHffITeVLc8ALXY+T6ZpM8A3FrPx3XYmmu9YE0STjSS/stq22+oOXZhCNDLmMsau1vEk+QZtajX4a2lBectp3xz1eeUs9HklT9iPYJ2kmxiT6UB4akKRV6AFVjzX4oEyxt0N9jGzGA4rzEuZ0BkyOzqTuKm6VO+5tqXEvZjEvlGeWq7cmnC7LGBdxkssbEgYI1o6lpo8QvV4DvydUNJ0y8mnlisOqOqRFWLv81YlmOOtn71esOAk/uIEJmP3MPgLWlJa7GNZ1cQdSuDZJaDAEqVkggg7x+NcMACIP3DkpVgkPJhXfKkHTQpuqM/LJPz2K6ddHgg==;5:VKfXpiOEQ1zkVF+uGo46K5mn//xrOG1wy3XKZ7/GO8WsFNGV0U/jkHdan4epXn5o92baOS4bVBh8Sy0GlNK9j8mdu2iCBYC9JVH/UR73GMcgDjboYj6FnNZW2yiXDO6Yjc7+XETtuXNgwgPbycFqY5tHCnNeh9d+3qA869w6oYrraGawnAEImZSKgfwKT+HXQs+HcgaUQdzO4P1L8BceSQ==;7:jU7WKF8Md2szg7FcMcsD4cWqYOZZxS2CXfsHMPq0nUE16NbfrfWmIvPu9crgzd+M9Zfz8oDKEiu9r0JKxbK82tLaEdL+OhQIK7MbApzINJ32B3GWLpr1vH5dBdmvm65kV42hoxpOT/c9DG9vB4QIvA==
x-ms-office365-filtering-correlation-id: b075d95b-90d4-4a43-84b7-08d68a851887
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3558;
x-ms-traffictypediagnostic: BYAPR11MB3558:
x-microsoft-antispam-prvs: <BYAPR11MB3558ADFF5A71DD134BC062F0E36D0@BYAPR11MB3558.namprd11.prod.outlook.com>
x-forefront-prvs: 0938781D02
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(366004)(396003)(376002)(39860400002)(189003)(199004)(486006)(316002)(54906003)(99286004)(97736004)(102836004)(68736007)(6916009)(305945005)(6512007)(4744005)(53546011)(7736002)(6116002)(6436002)(76176011)(71200400001)(52116002)(71190400001)(6486002)(53936002)(105586002)(86362001)(8936002)(25786009)(36756003)(31686004)(186003)(31696002)(6246003)(229853002)(106356001)(4326008)(81156014)(8676002)(81166006)(107886003)(476003)(386003)(6506007)(2906002)(2616005)(46003)(72206003)(446003)(11346002)(256004)(14454004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3558;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w7bDVde8U0s3GDPiKLi3IJD626QwXDyXCCrtkSu35d9ytkHMJy+IxvH9HOji5Ui4lgCTrycyfDuzzNVQ1MW6TISAf86a0BM8saeSd6C7XHNaRyluP88fpEholExP5zgHE2KaSKwfvwnLHp84vGaAzb3EA368zuNgYYQj8JVnJ7Iy2pBGuH0tOM0zaUqbcqTCuSgXhSi0kmH2NoT7Pu4PPRilIu8Y3j6dMGyBmYO6O0yqjQ3bl8u0JGk7/1xS2pNX2ciAK2rZhjPzpCRpwPsFthfzav0ZRSAlsgZwZB5DZ1Ny8Z6ua8ku4v9uWFrjelSVeC48LMyiCn+Aj6BKio+3oPUpyBw+Bzc0Lxwl5hxYidekiU4FAsKfqlIOKzhuDrQHU0T3OVoD8ZZBL9AoeIDCtNlOtSkE6s8vYmap3Mq1m9c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A735907C79A8084B99B46C6B633A1BCA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b075d95b-90d4-4a43-84b7-08d68a851887
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2019 09:42:33.9252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3558
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDIvNC8yMDE5IDE6NDMgUE0sIERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+IE9uIFNhdCwg
RmViIDAyLCAyMDE5IGF0IDA3OjE3OjEzUE0gKzAwMDAsIEFqYXkuS2F0aGF0QG1pY3JvY2hpcC5j
b20gd3JvdGU6DQo+PiBGcm9tOiBBamF5IFNpbmdoIDxhamF5LmthdGhhdEBtaWNyb2NoaXAuY29t
Pg0KPj4NCj4+IFRoZSB2YWx1ZSBvZiAndmlmX251bScoaW50ZXJmYWNlIGNvdW50KSBzdGFydHMg
d2l0aCAwLCBzbyBtb2RpZmllZCB0aGUNCj4+IGxvb3AgY29uZGl0aW9ucyB0byBleGVjdXRlIGZv
ciBhbGwgaW50ZXJmYWNlLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFqYXkgU2luZ2ggPGFqYXku
a2F0aGF0QG1pY3JvY2hpcC5jb20+DQo+IA0KPiBUaGUgcmlnaHQgdGhpbmcgdG8gZG8gaXMgdG8g
Y2hhbmdlIC0+dmlmX251bSA9IGkgKyAxIGluDQo+IHdpbGNfbmV0ZGV2X2luaXQoKS4gIFRoYXQn
cyBob3cgaXQgd2FzIG9yaWdpbmFsbHkuICBQbGVhc2UsIGFkZCBhDQo+IEZpeGVzIHRhZy4NCj4g
DQo+IEZpeGVzOiA3MzViYjM5Y2EzYmUgKCJzdGFnaW5nOiB3aWxjMTAwMDogc2ltcGxpZnkgdmlm
W2ldLT5uZGV2IGFjY2Vzc2VzIikNCj4gDQoNClRoYW5rcy4gU3VyZSwgSSB3aWxsIGFkZCBGaXhl
cyB0YWcgYW5kIHJlc3VibWl0IHRoZSBjaGFuZ2VzLg0KDQpDYW4gb3RoZXIgcGF0Y2hlcyBmcm9t
IHRoZSBzZXJpZXMgYmUgYXBwbGllZCBleGNsdWRpbmcgdGhpcyBvciBzaG91bGQgSQ0KcmVzdWJt
aXQgdGhlIGNvbXBsZXRlIHNlcmllcz8NClBsZWFzZSBzdWdnZXN0Lg0KDQpSZWdhcmRzLA0KQWph
eQ0K
