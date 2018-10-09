Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D93C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA182214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="WuwxL63f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA182214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbeJJDZc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:25:32 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:48458 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbeJJDZc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 23:25:32 -0400
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="20975984"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 13:06:55 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 13:06:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48MYB2wbPqmVNTJJEkDxI0Tal9zt2992ZoRShdabjj4=;
 b=WuwxL63fhKR3KJb/Gl+vCqwq4LWi7MHF7I5axs1x0b0mv1tsY5BdT5Z1SUb53AaMUimqaYEJKc9XPYn0uTzpbghgAChpOy6nGzw6MocaRCxK/EVARgOGtnQ9Kt1AgrCCwF/exqrE/Qo10dER3XAYzqSc+L9CN6OWTNNQ1+qGrD4=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0122.namprd11.prod.outlook.com (10.160.27.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Tue, 9 Oct 2018 20:06:52 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 20:06:51 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
Thread-Topic: [PATCH 03/19] wilc: add host_interface.h
Thread-Index: AQHUVYNW5Jjc14XuakSmFsQd9VDf/qUVeVQWgAFTAACAAAB5gIAAEwSAgAAAf4CAAAkMAP//9CoAgACABoD//5esgIAAddWAgAABJAA=
Date:   Tue, 9 Oct 2018 20:06:51 +0000
Message-ID: <5BBD0A58.4080700@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
         <1539008417.3687.57.camel@sipsolutions.net>
         <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
         <1539081379.3687.112.camel@sipsolutions.net>
         <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
         <1539085569.3687.115.camel@sipsolutions.net>
         <092b38f4-8153-9abd-890a-a42454f22154@microchip.com>
         <5BBCF51A.2060806@microchip.com>
         <1539112463.3687.131.camel@sipsolutions.net>
         <5BBD08FB.1070302@microchip.com>
 <1539115363.3687.138.camel@sipsolutions.net>
In-Reply-To: <1539115363.3687.138.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: DM5PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:3:93::22) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0122;6:Vq3xWI3atjkq8iycTcm3JR2/15Fpcf1mI/dOdnCgiiAGGAuzKihEyPbz8rdAYPEmJEd/caNNV607YMWE4FZzQHCZ7CzVYFJRSElPYn8o2gLQfjN53OnkT8ltxX/u2qN78NVg/ANPox3+Or83KECjnnYVOPis5DFFsea+4lM7bsVc+3lG4QnO4aamjHzsEWxVsE9mtmKFK9bZZWx9l8poSDPEvzf1pp9E3bfv8Minv4zf/kIcNrJtaijIZfu33uezKtta10F1vG2bt9dQIm//w4FwVmqQgyl2yY9Q46BwIyNbXIfo5OxLHENvPCYRP2bT33uQHK2CMbyGexdM7UtUhOg99WUW2102hS/Ji8nnl3RnYRnzle7aZq30GDRojxPooxHrTF8RYMs1kL+fPf+y+sgAeQ/oXEZPf68HGHtUJltjhpMDR3QkFNCE9YBDYFGmEoXzttQz49/oaPjr8Pp3tQ==;5:WuIByao/Epcux58lsG8iP1QaK9I70j+foQDYH/4taD1bzH/DPHdw+ml50+yuhCr4MaLzwA3ZpgdS0MlcK7r6aMTctqp4wVN87aZ9RHF/3+Vd7WpZX3RVaN++GSHuSeuFZkMQRhK7Ug3XFhXw/eF1X4acyFq1n3FfK9RRfeAfjxs=;7:Ab6dFy3rvsqFXagO34S0rVSna/cJUTem7J+lUcs02b3eMYtV245VB3MaWtLHiFkhEMF+4FpQyFxqcfTcEmThIrdnQVRBjAfjocbkxh56UW0MqsDbfGnvwFAgwywJKaH936x/zLdXFeVHFkt3Hx7PcsPRQybdPPnEenHk/lJFoKwIi5Vq3FkOigV/NEYELoT9noiKp2VjoN3qXWo59Ks9kGDNj4q8+sc6PnvrwCU6HVMcgZxtJzxtPUpylqBTXT3W
x-ms-office365-filtering-correlation-id: 671adf77-2478-4df9-0b43-08d62e22c01f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0122;
x-ms-traffictypediagnostic: DM2PR11MB0122:
x-microsoft-antispam-prvs: <DM2PR11MB0122CADF04FF561049AB9E838DE70@DM2PR11MB0122.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:DM2PR11MB0122;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0122;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(396003)(136003)(366004)(43544003)(189003)(199004)(102836004)(7736002)(59896002)(476003)(256004)(6116002)(68736007)(4326008)(14444005)(2616005)(6486002)(229853002)(316002)(25786009)(53936002)(446003)(6436002)(186003)(3846002)(107886003)(81166006)(105586002)(11346002)(6512007)(486006)(26005)(8676002)(106356001)(5660300001)(81156014)(8936002)(72206003)(2900100001)(386003)(6246003)(2906002)(52116002)(478600001)(6506007)(5250100002)(53546011)(66066001)(65956001)(65806001)(64126003)(36756003)(76176011)(86362001)(58126008)(97736004)(305945005)(87266011)(71190400001)(71200400001)(33656002)(110136005)(99286004)(80316001)(93886005)(2501003)(65816011)(54906003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0122;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: p3CSoeas08P4UnjMiNIM8MXQWeYj/vm1Q3UHw5hdFHBVGTVncwY+cEuHSSa5nA+gP42PNNZehzMxSKNzgPvgMnLOzLxdpDpXfm/1ycXpPkZycftUH7iG+KctlpZfMan7C1ZC8ppPo7QXw8OK9V/4YCPXuLUpaUQfCHVRzvCuDC9Oj5JhLifW5YrDB+drQ7XPBKPcwjeBeQDKo4aA0VIZANJG2aTC+4DqOV4NsUdWHnvn7++rXGf+DISixvxpGfrfklEgh5jP6yc1tPXQ8PlpywTSI+kVkdmLbWuYtJ1WahfQzKYyBAd6LGqBsFEmRoYdGs5cE1xqvRI/slyAUkIFp6oude89wwbME9iY7IhK2oA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <39AE3293C6223D459E0D12490D484F60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 671adf77-2478-4df9-0b43-08d62e22c01f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 20:06:51.1003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0122
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA5LzIwMTggMDE6MDIgUE0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIFR1
ZSwgMjAxOC0xMC0wOSBhdCAyMDowMSArMDAwMCwgQWRoYW0uQWJvemFlaWRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+DQo+PiBEbyB5b3UgbWVhbiB0aGF0IGl0IGNhbiBhbHNvIGJlIHVzZWQgZm9y
IHByb2Jpbmcgc3BlY2lmaWMgbmV0d29ya3MgZXZlbiBpZiB0aGV5IGFyZSBicm9hZGNhc3Rpbmcg
dGhlaXIgU1NJRD8NCj4gDQo+IFllcy4NCj4gDQo+PiBJIHRoaW5rIHRoaXMgbWlnaHQgYmUgYSBw
b3NzaWJsZSBjYXNlIGlmIHRoZSB1c2VyIGlzIHRyeWluZyB0byBsaW1pdCB0aGUgc2NhbiByZXN1
bHRzIHRvIGEgc3BlY2lmaWMgbmV0d29yay4NCj4gDQo+IE5vLiBEb24ndCBkbyBhbnkgZmlsdGVy
aW5nIGJhc2VkIG9uIHRoaXMuDQo+IA0KPiBCYXNpY2FsbHkgdGhlIG9ubHkgdGhpbmcgeW91IHNo
b3VsZCBkbyB3aXRoIHRoZSAobGlzdCBvZikgU1NJRHMgaXMgdG8NCj4gc2VuZCBhIHByb2JlIHJl
cXVlc3QgY29udGFpbmluZyBlYWNoIG9mIHRoZW0uIFVzZXJzcGFjZS9jZmc4MDIxMSB3aWxsDQo+
IHRha2UgY2FyZSB0aGF0IHRoZSB1c3VhbCBlbXB0eSAod2lsZGNhcmQpIFNTSUQgaXMgaW5jbHVk
ZWQgaW4gdGhlIGxpc3QsDQo+IHNvIGRvbid0IHNlbmQgb25lIHdpdGggdGhhdCBieSB5b3Vyc2Vs
ZiwganVzdCBpdGVyYXRlIHRoZSBsaXN0Lg0KPiANCj4gSWYgeW91IG9ubHkgc3VwcG9ydCBzZW5k
aW5nIG9uZSBwcm9iZSByZXF1ZXN0IGluIGVhY2ggc2NhbiByZXF1ZXN0LCB0aGVuDQo+IHNldCB0
aGUgbWF4ICMgb2YgU1NJRHMgc3VwcG9ydGVkIHRvIDEsIG90aGVyd2lzZSBzZXQgaXQgdG8gdGhl
IG1heGltdW0NCj4gKG9yIGEgcmVhc29uYWJsZSBsaW1pdCBsaWtlIDIwIGlmIGl0J3MgaW4gc29m
dHdhcmUpLg0KPiANCj4gam9oYW5uZXMNCj4gDQpUaGFua3MgSm9oYW5uZXMuIEl0J3MgY2xlYXIg
bm93Lg0K
