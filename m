Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D7AC2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE4020824
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="NpLewlVU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DE4020824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbeJ3GeV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:34:21 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2783 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeJ3GeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:34:20 -0400
X-IronPort-AV: E=Sophos;i="5.54,441,1534834800"; 
   d="scan'208";a="22335898"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 29 Oct 2018 14:43:48 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 14:43:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVG++i5vuAhjGrJ9g10gPMo24kfrSvGUdFNjYtgOEL4=;
 b=NpLewlVUosSQg0UeiQShYMNEj2O+qI5tqQwsp5j77lCPBtzkbDkBJ3/4APwsNSttxVGDF7v92OjO28Q3A5mpUlBYeax4xOxNLdCktBPPR6IGGpkwkM2J/lzhkxQlAbbol0c88Yj4JOT6cln4e7rS7HgI0fok7qdLi3Y1vT529xM=
Received: from BY1PR11MB0246.namprd11.prod.outlook.com (10.160.205.26) by
 BY1PR11MB0487.namprd11.prod.outlook.com (10.162.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Mon, 29 Oct 2018 21:43:44 +0000
Received: from BY1PR11MB0246.namprd11.prod.outlook.com
 ([fe80::55ee:9e5e:5291:a83]) by BY1PR11MB0246.namprd11.prod.outlook.com
 ([fe80::55ee:9e5e:5291:a83%4]) with mapi id 15.20.1250.034; Mon, 29 Oct 2018
 21:43:43 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Topic: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
Thread-Index: AQHUVYNjmo/tPFE0lEmad1H8ViJjG6UVg8bJgADg4gCAADsvAIAAJzCAgBB4o4CAD5yGAIAAGbOA
Date:   Mon, 29 Oct 2018 21:43:43 +0000
Message-ID: <8195c431-9f35-2563-de50-2c446e655577@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
 <1539010630.3687.86.camel@sipsolutions.net> <5BBC2D46.1060903@microchip.com>
 <1539071724.3687.87.camel@sipsolutions.net> <5BBCE23B.6050003@microchip.com>
 <5BCA50F7.3080809@microchip.com>
 <8d6f1b65622f3602ac37c8ae6256930226520c0a.camel@sipsolutions.net>
In-Reply-To: <8d6f1b65622f3602ac37c8ae6256930226520c0a.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101
 Thunderbird/58.0
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To BY1PR11MB0246.namprd11.prod.outlook.com
 (2a01:111:e400:5010::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR11MB0487;6:FL2qg/P5yc3ZmDIOPgSVOUmJSzZxtyh7ZtvuzzdQjEJlVGIq1kKzYgfUFJyiryy+QVoyOBjFpk2qTa+g2KqwUkoWeP50toBqIEdz330A9Uzyiyy7KGoISOFtBzP3YG4k3qKWzVKkgeZDyy1FXmJT2PtdIjplH54qh0j4SkdR6Q2lWijFihrkA5DLSdux306xmNOnW0nzl0uvEg1IuS2aMB7j/kgj/FWR/yWfe/Ivv/SKSIz+A511pr8bqCsQMg+i6WZaknERDEOTQqGr25didqTm2X9TRfyfiF/wSFrPS8qsYAg4cKLa2jmDnlBeKhFmRkMWzGU0wA08UzXBbCNgraF2bcJ02KVjG5OMsvsDyIuF0DHmET4zuOFO1Xj25uxEs9v4107Hh+CL7sLVKg/9Det789MIqxMpscLAjPn9XT8fn1BLkYsIaW1XZ6otQEciq3hhnbdB3BvAoiX7IXYCnw==;5:7Q++oVGeOeg6BPb3qpqFq/60ZvmLNq4pAE9mRjK4WUqA69H2P/gs4gxfTslB1CxrVU2M98Ci/yTESfS1t95ELvCxBNBWf5yauL08PxeLBxutverSaxbXKOGxzgdX1u4D2MB2JIIoxfUVKliXnl+S6/O7K2GJJDvAhDMEi4fp0Jg=;7:e3vjGR9GO79tgxc1UFP9unTPM6KHYGQvAAJzw2r2Fw6REvOhSH1wvmlXLpQTV8djG/jEV/UBrbfDw6d+926aSzIId+X5k1cJgv2YYXKYOwuessh3WgU4qooLDKKjQLdSTiw8qoAb3OPPeJPi/DbshQ==
x-ms-office365-filtering-correlation-id: a1fa8b04-f72c-49b6-eda2-08d63de798d8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BY1PR11MB0487;
x-ms-traffictypediagnostic: BY1PR11MB0487:
x-microsoft-antispam-prvs: <BY1PR11MB048763A8B2AE79BD7CB7CBDA8DF30@BY1PR11MB0487.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR11MB0487;BCL:0;PCL:0;RULEID:;SRVR:BY1PR11MB0487;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(396003)(366004)(376002)(199004)(189003)(14454004)(58126008)(68736007)(11346002)(66066001)(64126003)(110136005)(5660300001)(476003)(31696002)(106356001)(6116002)(65956001)(65806001)(54906003)(3846002)(8936002)(446003)(478600001)(86362001)(2616005)(72206003)(2900100001)(2501003)(93886005)(105586002)(25786009)(316002)(486006)(65826007)(71190400001)(6246003)(305945005)(31686004)(36756003)(76176011)(6486002)(256004)(14444005)(4326008)(186003)(52116002)(229853002)(53936002)(5250100002)(71200400001)(97736004)(81156014)(107886003)(2906002)(6436002)(7736002)(8676002)(81166006)(102836004)(53546011)(4001150100001)(26005)(386003)(6506007)(99286004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR11MB0487;H:BY1PR11MB0246.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: atFcye/hx82qJYpngXG+8WZrVJgajwShxpftC0Ba6VUnWaqjN+dz7NehY67WWn8sWEYy5nDsjLyvoNjuwqJEY0g5P6xseDK+sGJxp7skZdjdQaJxVZotcLlSbThDwzSYoyXnx2FIazB7ClqwL3vuVmMh/tH8alqgzOnKCcXiM3Mg4Ka9l4MZFVnYHvis4ZuYqCyqqDMRNK0XZiXIg2Y5igtjzneTrCPtwmMa+RslgVrITF5vtLFj4O+eTktjosJLATNUG+kCDAGmRbeRTho0kCSk3PWwZSsqzSJopRmcFGM1aRE1Oi/IHRjNoiyxRLujK87srzwPb80KHBXGo5XeJh8PvO+hgUkCoky57AZoApk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <23F68BF92371784E931697C46948EBD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fa8b04-f72c-49b6-eda2-08d63de798d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 21:43:43.7940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB0487
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTAvMjkvMTggMToxMSBQTSwgSm9oYW5uZXMgQmVyZyB3cm90ZToNCj4gSGksDQo+DQo+IFNv
cnJ5IGZvciB0aGUgbGF0ZSByZXBseS4NCk5vIHdvcnJpZXMhIFRoYW5rcyBmb3IgdGFraW5nIHRo
ZSB0aW1lIHRvIHJldmlldyB0aGUgZHJpdmVyLg0KPg0KPiBPbiBGcmksIDIwMTgtMTAtMTkgYXQg
MjE6NDcgKzAwMDAsIEFkaGFtLkFib3phZWlkQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+PiBKb2hh
bm5lcywgc2hhZG93IGJ1ZmZlciBoYXMgMiBtb3JlIHVzYWdlIHRoYXQgSSBtaXNzZWQgaW4gbXkg
Zmlyc3QgZW1haWw6DQo+PiAxLSBJdCBrZWVwcyBhIGNvcHkgb2Ygc2NhbiByZXN1bHRzIHRvIGJl
IGFibGUgdG8gYXV0by1zZWxlY3QgZnJvbSBpZg0KPj4gdGhlIGNmZzgwMjExIGRpZG4ndCBzdXBw
bHkgYSBzcGVjaWZpYyBic3NpZCBpbiBjZmcncyBjb25uZWN0IHJlcXVlc3QNCj4+IChzdHJ1Y3Qg
Y2ZnODAyMTFfY29ubmVjdF9wYXJhbXMpLg0KPj4gSW4gdGhpcyBjYXNlIHRoZSBkcml2ZXIgd2ls
bCBzZWxlY3QgYSBuZXR3b3JrIHRoYXQgbWF0Y2hlcyB0aGUgc3NpZCwNCj4+IHdoaWxlIGhhdmlu
ZyB0aGUgaGlnaGVzdCByc3NpLg0KPiBZb3Ugc2hvdWxkIGJlIGFibGUgdG8gZmluZCB0aGlzIGZy
b20gY2ZnODAyMTEncyBCU1MgbGlzdCBhcyB3ZWxsLg0KPg0KPiBJZiB3ZSBsYWNrIHNvbWUgQVBJ
IGluIHRoaXMgYXJlYSwgd2hpY2ggaXMgcG9zc2libGUsIHRoZW4gd2UgY2FuIGFkZCBpdC4NCkZy
YW5rbHksIEkgd2Fzbid0IGF3YXJlIHRoYXQgdGhlIGNmZzgwMjExJ3MgQlNTIGxpc3QgaXMgYWNj
ZXNzaWJsZSBmcm9tIHRoZSBkcml2ZXIhDQpJJ2xsIGRvIHNvbWUgcmVzZWFyY2ggb24gdGhhdCBh
bmQgbGV0IHlvdSBrbm93IGlmIHRoZXNlIEFQSXMgZGlkbid0IHNlcnZlIG91ciBwdXJwb3NlIGNv
bXBsZXRlbHkuDQo+PiAyLSBJdCBrZWVwcyBuZXR3b3JrIHBhcmFtZXRlcnMgdGhhdCB0aGUgZGV2
aWNlIHdpbGwgbmVlZCB0byBjb25uZWN0DQo+PiB0byBhIG5ldHdvcmssIHNpbmNlIHRoZSBkZXZp
Y2UgZG9lc24ndCBrZWVwIHRoZSBzY2FuIHJlc3VsdHMNCj4+IGludGVybmFsbHkuDQo+PiBUaGVz
ZSBwYXJhbWV0ZXJzIGFyZSBzdG9yZWQgaW4gc3RydWN0IGpvaW5fYnNzX3BhcmFtLCBhbmQgcGFz
c2VkIHRvDQo+PiB0aGUgZGV2aWNlICB3aGVuIGEgY29ubmVjdCByZXF1ZXN0IGlzIHJlY2VpdmVk
Lg0KPj4gU29tZSBvZiB0aGVzZSBwYXJhbWV0ZXJzIGNhbiBiZSBleHRyYWN0ZWQgZnJvbSBjZmcn
cw0KPj4gY2ZnODAyMTFfY29ubmVjdF9wYXJhbXMgKGxpa2UgY2FwX2luZm8uLiBldGMpLCBidXQg
b3RoZXJzIChsaWtlIGJzc2lkLA0KPj4gYmVhY29uIHBlcmlvZC4uIGV0YykgYXJlIHN0aWxsIHJl
cXVpcmVkLg0KPiBBZ2FpbiB0aG91Z2gsIHlvdSBzaG91bGQgYmUgYWJsZSB0byBleHRyYWN0IHRo
ZXNlIGZyb20gc3RydWN0DQo+IGNmZzgwMjExX2JzcywgSSdkIGFyZ3VlPw0KPg0KPiBqb2hhbm5l
cw0KPg0KDQo=
