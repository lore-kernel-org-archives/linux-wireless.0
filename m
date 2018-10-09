Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55CDECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7BD20644
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bC5/QbnH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A7BD20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbeJJBye (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 21:54:34 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:24186 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbeJJBye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 21:54:34 -0400
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="21283083"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 11:36:16 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 11:36:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5/8pymqndfzf9yqhhonSR0edb9TDxCKHvMzJhHx9as=;
 b=bC5/QbnHrpQrbkdM20Lcy/2/9SaJdVvoHu8wEFLCmYmp+mLTHF8OExdvBD74JyZcRCfZctvMcnQV3xI8He6stAWWPt5e1IrRUiNdQdYMrZV0M5oXPXmb+dpOINif2knRNUPZtcChn+Z/CNuiNPIGBvDdV6FKQmI/km4vdoy/Grc=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0173.namprd11.prod.outlook.com (10.160.132.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.26; Tue, 9 Oct 2018 18:36:14 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 18:36:14 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <Ajay.Kathat@microchip.com>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
Thread-Topic: [PATCH 03/19] wilc: add host_interface.h
Thread-Index: AQHUVYNW5Jjc14XuakSmFsQd9VDf/qUVeVQWgAFTAACAAAB5gIAAEwSAgAAAf4CAAAkMAIAAaYIA
Date:   Tue, 9 Oct 2018 18:36:14 +0000
Message-ID: <5BBCF51A.2060806@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
 <1539008417.3687.57.camel@sipsolutions.net>
 <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
 <1539081379.3687.112.camel@sipsolutions.net>
 <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
 <1539085569.3687.115.camel@sipsolutions.net>
 <092b38f4-8153-9abd-890a-a42454f22154@microchip.com>
In-Reply-To: <092b38f4-8153-9abd-890a-a42454f22154@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: DM5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:3:93::11) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0173;6:CfZ6sw1wv/1Wnc1b/JJON8aFpn8vc5teILwAJShu6K+K7BaAE1b8+ns8TA+u8CAxMr9r1ub0yT/EaFS5MRNSrD4GArp2PpUqZuHQch7xC1PUaFMF2ci7SsmsOLSUfx1Gx0DYUdmFFtAYfHb8VgTnuFrzZW7uRecM2+BMM97ySYRg/iAgs/GXCjGu1auFyPLwTVpuNCrSIrw5e2tfW9O8RRshsaw6we6S4LW/PPRClyEReHv0N+EP40MQipl/5/Q9za6CoZklrE9aVSbkK0ccqx8o44mkpYivOy0JwdeLCsdlAiMRNoqDlailRRKK0rN6eHFd8yd3U+siXkphvLHpwqm6Qv3Vh7cM56I2DvMMuzdsNOGUY9FYWgSYSM6YBdDmDXUkIyfcJobwksFcNlGkrs7sRwgQ58LRotTA8hiuEQEm++SfiqMcngJf5SGE9B7Vn4Gmx+zx1OHXXEk1cSVz+g==;5:phA/2wUauQ7GuEXKpMdnqPC71t+z5HLXhIgO6TV5wtSEkv2oqO2XXULrf+k8QKgXWpYqldGoDZcuETbuAaRav/7tyfncDn22f+RnKh0fDLAaQs7ccV/M53qzHBX35szInSCO8W9cFUdQlNgytk/ziHAR/uZ81G65NTGN7gjgmMM=;7:GzUP/+JWX7sLqhknyUK12RNYZ/9J6+qjzlmsvYqxnluMTDxhTHyMHyUTy3PcLfgA+FgqCF63RBbJBDSJHILjOHIzDcB0fKaN3TcXBx5cC5mK/tE1jMsQ4JAuG+HsJFQHU+WVzpONibg/Kj+C51fncAPiu5qP1H3kUrnRSt2LPrcRfXqaRVDTBVfMyn4csS3Z06gyNG2y2MUuYdR6HQy2YPVMz/eT9tgDRFYrZ4j1L56bV//+70fUi1r8TOSnS0Ie
x-ms-office365-filtering-correlation-id: 37c60274-47e5-4978-8d16-08d62e161726
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0173;
x-ms-traffictypediagnostic: DM2PR11MB0173:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-microsoft-antispam-prvs: <DM2PR11MB0173797C147BAA03D1690A4B8DE70@DM2PR11MB0173.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(163750095850)(17755550239193);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991055);SRVR:DM2PR11MB0173;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0173;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(366004)(376002)(39860400002)(189003)(199004)(229853002)(2501003)(25786009)(71200400001)(33656002)(26005)(65806001)(93886005)(97736004)(5660300001)(54906003)(66066001)(65956001)(186003)(6512007)(2616005)(64126003)(4326008)(71190400001)(53936002)(6436002)(446003)(59896002)(110136005)(58126008)(5250100002)(476003)(486006)(76176011)(65816011)(478600001)(11346002)(52116002)(6506007)(386003)(53546011)(14454004)(6486002)(99286004)(72206003)(256004)(14444005)(81166006)(8676002)(81156014)(68736007)(87266011)(6246003)(86362001)(2900100001)(305945005)(6116002)(7736002)(8936002)(3846002)(80316001)(106356001)(316002)(2906002)(107886003)(36756003)(105586002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0173;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aYYopexSGBKWHvI2ClD0D4VCDlIC4ruWCy63r4TrUiORKGsD0+7RSQXOrvYzTkYh6KimtNC24hLjqWN3i6O5hAxHU8JYUG6GuRMOVQyafq+KlhiMHMSQKTkBFOAtHzLr1gv9Ik71TOYJdANAwpJkRE0fo+StmfU6pcwoYhe6QLIsVX3BqPUZjKrlgaW/uIBElzyT8XR8uqeMf6lSu5I20RAE5XclFVkh2pSzsjJrnl5P0NI6a9Q1BYDgWn1en2nf+y3JwwbyZC8G0UJ0EqNwpC8cTz+Xxxy8MzS6hJuYCjrCfXrNeiIsNT8u49UYLfI75pfrw/vH4jY9ral5T6Ak0jwzExlHyXL182DOIX98YLc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E2F15700A637A45A30C81CEC84676FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c60274-47e5-4978-8d16-08d62e161726
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 18:36:14.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0173
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA5LzIwMTggMDU6MTggQU0sIEFqYXkgU2luZ2ggd3JvdGU6DQo+IA0KPiBPbiAx
MC85LzIwMTggNToxNiBQTSwgSm9oYW5uZXMgQmVyZyB3cm90ZToNCj4+IE9uIFR1ZSwgMjAxOC0x
MC0wOSBhdCAxNzoxNCArMDUzMCwgQWpheSBTaW5naCB3cm90ZToNCj4+PiBPbiAxMC85LzIwMTgg
NDowNiBQTSwgSm9oYW5uZXMgQmVyZyB3cm90ZToNCj4+Pj4gT24gVHVlLCAyMDE4LTEwLTA5IGF0
IDE2OjA0ICswNTMwLCBBamF5IFNpbmdoIHdyb3RlOg0KPj4+Pg0KPj4+Pj4+PiArdHlwZWRlZiB2
b2lkICgqd2lsY19yZW1haW5fb25fY2hhbl9leHBpcmVkKSh2b2lkICosIHUzMik7DQo+Pj4+Pj4+
ICt0eXBlZGVmIHZvaWQgKCp3aWxjX3JlbWFpbl9vbl9jaGFuX3JlYWR5KSh2b2lkICopOw0KPj4+
Pj4gSSB0aGluayBhcyBwZXIgY29kaW5nIHN0eWxlIHRoZSB0eXBlZGVmIGZvciBmdW5jdGlvbiBw
b2ludGVyIGFyZSBhbGxvd2VkLg0KPj4+PiBUcnVlLCBJIGd1ZXNzLCBidXQgd2h5IGRvIHlvdSBu
ZWVkIHRoZW0/DQo+Pj4gQWN0dWFsbHkgdGhlc2UgZnVuY3Rpb24gcG9pbnRlciBhcmUgdXNlZCBp
biBtdWx0aXBsZSBwbGFjZXMgaS5lIGluc2lkZQ0KPj4+IHRoZSBzdHJ1Y3QgYW5kIGFsc28gZm9y
IHBhc3NpbmcgYXMgdGhlIGFyZ3VtZW50IGZvciB0aGUgZnVuY3Rpb24uIFNvIGkNCj4+PiB0aGlu
ayBpdHMgYmV0dGVyIHRvIGtlZXAgdGhlbSBhcyB0eXBlZGVmIHRvIHNpbXBsaWZ5IGFuZCBhdm9p
ZCBhbnkgJ2xpbmUNCj4+PiBvdmVyIDgwIGNoYXJzJyBjaGVja3BhdGNoIGlzc3VlLiBCdXQgYW55
d2F5IGlmIHlvdSBzdWdnZXN0IHdlIGNhbiBtb2RpZnkNCj4+PiB0byByZW1vdmUgdGhlc2UgdHlw
ZWRlZnMgLg0KPj4gSSBndWVzcyB0aGF0IG11c3QgYmUgcGFydCBvZiB0aGUgaW50ZXJuYWwgYm91
bmNlIGJ1ZmZlciBtZWNoYW5pc20/IEkNCj4+IGd1ZXNzIGxlYXZlIHRoZW0gZm9yIG5vdyBhbmQg
c2VlIHdoYXQgZmFsbHMgb3V0Lg0KPj4NCj4+Pj4+Pj4gK3N0cnVjdCBoaWRkZW5fbmV0d29yayB7
DQo+Pj4+Pj4+DQo+Pj4gWWVzLCBpdHMgbm90IHJlbGF0ZWQgdG8gaGlkZGVuIFNTSUQuIFN1cHBv
c2UgY2ZnODAyMTEgc2NhbiBpcyBjYWxsZWQNCj4+PiB3aXRoIFNTSUQgaW5mb3JtYXRpb24oYWN0
aXZlIHNjYW4pIHRoZW4gU1NJRCBpbmZvIHdpbGwgYmUgbWFpbnRhaW5lZCBpbg0KPj4+IHRoaXMg
c3RydWN0dXJlLg0KPj4gc28gbWF5YmUgcmVuYW1lIHRoaXM/DQo+Pg0KPiBZZXMsIHN1cmUgSSB3
aWxsIHJlbmFtZSB0aGlzIHN0cnVjdC4NCj4gDQo+IFJlZ2FyZHMsDQo+IEFqYXkNCj4gDQoNCkpv
aGFubmVzLCBpcyB0aGUgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0LnNzaWQgdXNlZCBmb3Igc29tZXRo
aW5nIGVsc2Ugb3RoZXIgdGhhbiBzcGVjaWZ5aW5nIHRoZSBoaWRkZW4gbmV0d29ya3MgdGhhdCB0
aGUgY29udHJvbGxlciBzaG91bGQgc2NhbiBmb3I/DQo=
