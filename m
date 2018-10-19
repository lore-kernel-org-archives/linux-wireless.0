Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A2BECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 20:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A350E21470
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 20:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="gEcsoXj+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A350E21470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbeJTFBd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 01:01:33 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:33649 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbeJTFBd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 01:01:33 -0400
X-IronPort-AV: E=Sophos;i="5.54,401,1534834800"; 
   d="scan'208";a="19102279"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 Oct 2018 13:53:49 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 19 Oct 2018 13:53:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohSqY5hYqCVg/gNp4cliFj5uJ2YJPZ4MAxIz5rC6DWM=;
 b=gEcsoXj+p6eNp8AJ1SVqUvrp9H0p0qNp+K4ihOunu+DDvErVj2usVd5KbuvaffiUstLIZz0z9lOj1S/JePvbl7UCqQZJsWcEIRFvUFNZmioA9ckIpUrv0AGoBp9FuJVNKBWQXEzJYnUguykejhzMCnT6jEG6bF/Ex5heUKYkKPI=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0206.namprd11.prod.outlook.com (10.160.132.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.32; Fri, 19 Oct 2018 20:53:47 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%9]) with mapi id 15.20.1228.032; Fri, 19 Oct 2018
 20:53:47 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
Thread-Topic: [PATCH 04/19] wilc: add host_interface.c
Thread-Index: AQHUVYNXfYsd0dU0yEWHmbOkbZ9wFqUVfI/RgAOB7ICAALcTAIACGiCAgAj9CACAADQ4AIABR3sAgADoMoA=
Date:   Fri, 19 Oct 2018 20:53:47 +0000
Message-ID: <5BCA4455.1020307@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122554_993494_C8703D81)
 <1539009076.3687.64.camel@sipsolutions.net>
         <5BBE5BCF.5020706@microchip.com>
         <1539241314.3687.190.camel@sipsolutions.net>
 <5BC11B3B.20901@microchip.com>
         <5c6c7a4d3471a2784d0b203beccd4de9c55b211e.camel@sipsolutions.net>
         <5BC8D148.7050804@microchip.com>
 <492fb11bbe66cdea676e126a70a1ba9e1af3c97b.camel@sipsolutions.net>
In-Reply-To: <492fb11bbe66cdea676e126a70a1ba9e1af3c97b.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: BN3PR03CA0051.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::11) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0206;6:gOlT8J0sCYsb4+gLdew/KHaCT64RbjVuHV+XARzRMqHImWOs4LxylsSzVsK74Pfq+qk6eGtYh77q3hI+t16or4mW5e0ifcCyp7LdPUu3TNG+GungcM03x2gB1wjeWxfndtJpZVBsmbuUPCGMLjNGA5oVURydrLdzbZNP37xIJCAro8P3lK/ZK7HncTYQHxAuXT+WJCNAis+/6/DdWYa5Q0OxEdWK8zGNxAcBgNjfd6ht44d0yRBvUJMQWwPvIkrh/gIXK3r6rCidKc66jYWIq8FooVjU/Wb91TSTkzL1ei+TqVAs/IyFcn2d5HCWP7E4xff4Xr9tq9ikBrt0K0pasnkZd9VaJxwEc3OvJksMR5z/2bYgVVBh56M6g8NOVIWtda+bQM8eaKJUQfB/ERoq9qrMiQ0KuM14xtlxbMJYzUUt4acuQFM8xpnXJ/KWlw+nII+80tKoIRAk7vDsH8wsMg==;5:IgmL95hZ8KhE/Y1mv169JMZKLNVFNOcPmBkoQg64OdgnaMJp1T1KXc7OQMriGE78UuVJ3KQyNohu9hpmK9XgDWl2wLfmgtfdcwjJdYKt837ZOuskh3vIvJUdUakDAvGXvv0VfrO240ciC7nPnh1Esfe2GyV4QpZ3vBFKou2RFgQ=;7:81p9D8KAJ5l3KmPFVRSiUwOJCdpODXZHOS99qQsLs7iZFr6/7YII7oO68juZ6g6r8hgBrWoAULIUs33wJaePTD3BpWbsv0JBj3c9Rz2C+5vZy4fvC4z/1yIIs5T1bKODduCc4dMspcifz9GJiPo2rXXUqr1ilyE/559TBWW/BDI6AUadXQdc9pt3b5Ywzk2et/3+babvJDkZqSRtqRKnTGNcLUj4d4nnV/VWCmcT6SdtpcCAoMFwvebH5eX25AJv
x-ms-office365-filtering-correlation-id: 62a33dbf-111d-498e-cd63-08d63604f666
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0206;
x-ms-traffictypediagnostic: DM2PR11MB0206:
x-microsoft-antispam-prvs: <DM2PR11MB0206F7E3BE9533F7038CE8098DF90@DM2PR11MB0206.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231355)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0206;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0206;
x-forefront-prvs: 0830866D19
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(39860400002)(396003)(346002)(189003)(199004)(446003)(102836004)(6486002)(6436002)(53546011)(386003)(4326008)(81166006)(71190400001)(71200400001)(476003)(2616005)(86362001)(97736004)(81156014)(68736007)(11346002)(256004)(8936002)(25786009)(72206003)(478600001)(316002)(93886005)(2501003)(54906003)(6246003)(186003)(53936002)(14454004)(80316001)(26005)(105586002)(6512007)(65806001)(65956001)(66066001)(36756003)(2900100001)(33656002)(59896002)(58126008)(106356001)(6506007)(5250100002)(52116002)(99286004)(110136005)(107886003)(229853002)(65816011)(7736002)(87266011)(305945005)(76176011)(8676002)(2906002)(3846002)(64126003)(486006)(6116002)(5660300001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0206;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: tPa0M/bRq5fnUad4GTr67NFpsJzXNk+1+aFM6+lHhN0zNMONEdTIXvZtjBSxASznz/+P70IeIT1fP9UCoqk5RHJhsgMoW+pzThM8UVmQQgyzxec7jP9lSO4HkynvZ+K8WwqBpyJYSiQJZUyY1ihpupA7UyvL9wUvc1MDY7V/C7bLyDUq5/rsxasRzA0I1sSwbyoMOnjo75H4AdqStFJO8zvYpVbGBXcVcJ+1FBpJ5+eVBOHwPaQjMty7faHIcpAFzaPMkiZbn0m1E33wg1IekLnAd5r1wGmm4j3ArpqFxPuHJqhG4Tpks8CgsSAkIlaPBRESHcYyHNV/rFpBZYLQuZ7Kl3RaAZqHtreQwv5EIWk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A0AA88723600E4881D1D28CF551D766@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a33dbf-111d-498e-cd63-08d63604f666
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2018 20:53:47.2455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0206
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzE5LzIwMTggMTI6MDIgQU0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IA0KPj4+
PiBEbyB5b3UgbWVhbiB3ZSBzaG91bGQgYmUgZG9pbmcgdGhlIHdvcmsgZnJvbSB0aGUgY2ZnIGNv
bnRleHQ/DQo+Pj4+IE5vdGUgdGhhdCB0aGlzIGlzIGNhbGxlZCBjZmc4MDIxMV9vcHMuc2V0X3dp
cGh5X3BhcmFtcygpLCBhbmQgaW52b2x2ZXMNCj4+Pj4gbG9ja2luZyBtdXRleGVzLCBwYWNraW5n
IHRoZSB3aWRzLCBidXMgb3BlcmF0aW9ucywgYW5kIHdhaXRpbmcgZm9yIHRoZQ0KPj4+PiBkZXZp
Y2UgdG8gcmVzcG9uZC4NCj4+Pg0KPj4+IFRoYXQgKnNob3VsZCogYmUgZmluZSAtIGhvdyBsb25n
IGRvIHlvdSBleHBlY3QgdGhhdCB0byB0YWtlPw0KPj4+DQo+Pg0KPj4gSXQgZGVwZW5kcyBvbiB0
aGUgSU8gYnVzIHVzZWQgKFNQSS9TRElPKSwgY2xvY2sgc3BlZWQuLiBldGMNCj4+IEl0IHdvdWxk
IGFsc28gdmFyeSBhY2NvcmRpbmcgdG8gdGhlIGRhdGEgcGFja2V0cyBiZWluZyB0cmFuc2ZlcnJl
ZA0KPj4gd2l0aCB0aGUgZGV2aWNlLg0KPj4gSWYgdGhlcmUncyBoZWF2eSBkYXRhIHRyYW5zZmVy
LCBjb25maWd1cmF0aW9uIHBhY2tldHMgd291bGQgdGFrZQ0KPj4gbG9uZ2VyIHRvIGJlIHNlbnQs
IGFuZCBmb3IgdGhlaXIgcmVzcG9uc2UgdG8gYmUgcmVjZWl2ZWQuDQo+IA0KPiBIb3cgbXVjaCB0
aW1lIGRvIHlvdSB0aGluayB5b3UncmUgbG9va2luZyBhdD8NCj4gDQo+IEknZCBhcmd1ZSBmb3Ig
dHJ5aW5nIGl0IHRob3VnaCBhcyBpdCBtYWtlcyB0aGUgY29kZSBNVUNIIHNpbXBsZXIuDQoNCkkg
dG90YWxseSBhZ3JlZSB0aGF0IGl0IHdpbGwgYmUgc2ltcGxlciB0byBkbyB0aGUgd29yayBkaXJl
Y3RseSBmcm9tIHRoZSBjZmcgY29udGV4dCByYXRoZXIgdGhhbiBzY2hlZHVsaW5nIGl0Lg0KT24g
YSBjb3J0ZXggQTUgTVBVIGFuZCBTUEkgYnVzIHJ1bm5pbmcgb24gNDhNaHosIHRoaXMgdGFrZXMg
MjBtcyBpbiB0aGUgaWRsZSBjYXNlLCBhbmQgMTAwIHRvIDMwMG1zIGluIGNhc2Ugb2YgZGF0YSBi
ZWluZyB0cmFuc2ZlcnJlZCBpbiBwYXJhbGxlbC4NCg0KVGhhbmtzLA0KQWRoYW0NCg==
