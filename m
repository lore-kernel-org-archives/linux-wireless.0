Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A9BC64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20162213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="aIc3slxH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20162213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbeJJDT6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:19:58 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26396 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbeJJDT6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 23:19:58 -0400
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="21287181"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 13:01:05 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 13:01:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a1B7QWTV+G82rRYhAWForH0xP+ly5i8fcUJ/WmKwmA=;
 b=aIc3slxHdEXHAU0CECHih7WHIsTLElDJcAi9H3iJd5tJ/+KaCkjp7uBasL3yGwrcTxYxc7Vl3reErYFVPPPlWvYmuSByeXGyIyrgW6KaO7Yz0fOyjS+YwPBPmv6k5os8cgNk99Dq/AGMN49HWBE1qtccZJ0L25lQzUFyBXaZ8ak=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0121.namprd11.prod.outlook.com (10.160.25.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Tue, 9 Oct 2018 20:01:03 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::c495:fe35:c61f:f850%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 20:01:03 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
Thread-Topic: [PATCH 03/19] wilc: add host_interface.h
Thread-Index: AQHUVYNW5Jjc14XuakSmFsQd9VDf/qUVeVQWgAFTAACAAAB5gIAAEwSAgAAAf4CAAAkMAP//9CoAgACABoCAAA0FgA==
Date:   Tue, 9 Oct 2018 20:01:03 +0000
Message-ID: <5BBD08FB.1070302@microchip.com>
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
In-Reply-To: <1539112463.3687.131.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
x-clientproxiedby: DM5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:3:93::28) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0121;6:kkfDwnErQE9VpxaDt0KDVNIRfGdRTk2lcWJvR7tgjFglGioVVVtLK+7f0Bnco6S5bVZQdIwR5cVgCNA1xhcSwDOdq1J/FQ7G3cyT5DY9wm0MWBrgpsbsVbY4MJY8rJ24TVM2tROT8VcUqp4gSQqcCogfVpACQR2j/zgZTdIBog3zeH7AaHaOPU1y8R231QWTuxJ1psZGnaCcA1oJnwYRIqFLyWiVOjj50EsRFTgcxuEZ/1s+wrd10DSs6oFQTAEZzSKgHZy4O/8XkvRhdR4HDGP/0/nnMlp591+3+2o5P+eWTB7VT7LQZSrDzD1Lq/E0Uue3/dDMuRx+Hdz0g3UglJDb4vzoantUZ11OHZsm138S/Ar5awFSjRIqhTXQSuM7UftrNr1SI5OzYn5YTufM6tfA5u4gD/032wwehvmvHvmlpp6foPhJwPwFKwBdhlH2RBKCXMOuHwHh8+RfmKlYdw==;5:ztiIeImLrSyAW/O8zB1jyYD4uXyxNFQcTtnFf+Dug9idPTCF1X2tUQwe21QHgPBlJeI26fismUttzeHUirB0VIf16LgfK98xQz8ytaDZioUgy9dmqPyMT/BzWsXkKqvnKf6L4mbc9o6RkODA9uCjL1EvjzDCQRQk9OA9if3ODfw=;7:ZOXTDcbF3yhemEu4nUODB8SV7SDw+MXq2sI+1KXg0KAd3XA58vqom+l0IIqwHFJPJfq0H1jbNx4RlRq2Sw8JOP2EQ1OA3Rlkyp8Nd/VXxNPptDQTBZ/lhP/FgHEHUKgcqgYOPyJefC1olNj8CfH2NGh0euXw2DLYkoAFU/MvdhmX1ijyMhoZOtyxL/E5kik7ci++2xf/o8QrPno3dQGYe1bbvaKvMaypxTjVr8gE8i3GeopnYNEAc9akPgh9mqnW
x-ms-office365-filtering-correlation-id: 05c77460-093b-4ae9-59b4-08d62e21f098
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0121;
x-ms-traffictypediagnostic: DM2PR11MB0121:
x-microsoft-antispam-prvs: <DM2PR11MB0121D089F94A57424CE9DFED8DE70@DM2PR11MB0121.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051);SRVR:DM2PR11MB0121;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0121;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(366004)(39860400002)(136003)(189003)(199004)(64126003)(87266011)(66066001)(65956001)(5250100002)(80316001)(36756003)(5660300001)(33656002)(99286004)(52116002)(65806001)(6116002)(65816011)(3846002)(2900100001)(102836004)(6512007)(106356001)(53936002)(68736007)(4326008)(14444005)(256004)(59896002)(76176011)(93886005)(105586002)(107886003)(71200400001)(71190400001)(2501003)(25786009)(97736004)(8676002)(81166006)(81156014)(6486002)(110136005)(58126008)(54906003)(229853002)(316002)(7736002)(2906002)(305945005)(446003)(2616005)(476003)(11346002)(53546011)(478600001)(6436002)(386003)(186003)(6506007)(72206003)(8936002)(6246003)(26005)(14454004)(86362001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0121;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: jdDG+kg0qJ7tr+XhsDD0UsvWChZczV/0pZAdOeBQQ7Y/noJ4uD2OQbFM6knO29ZwU+YOkXYrwmimOFec+PAJpkKoZ0S7452yP6/sOu7U7VOsQAG1LAtQ297bByKkZ3iy2OQf4UUPLIPgRAM9EXZbPqWwWWsCaNQXC3MP5DFUgQpakII2Hp/xwyDFsFnGZ3LaZ+oeYNWQZ78+4DJwXv5HUElMy05jO6Vu2H2VfsfSEt2/qOl2h8k0K6KqO+8tb1uy+2riGnZSTvRifLjjXZr8ZjBGDu3/TsQHsdm4e4G2t/bidWt92jS6BJuiq2qDZjTx3cbxQpm+bORdHQHwk820NuzFoCRXx2ZSukTw41Ob0AI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <91D69A526E8AAE4C9C59C9C1F1ACF90B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c77460-093b-4ae9-59b4-08d62e21f098
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 20:01:03.3795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0121
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEwLzA5LzIwMTggMTI6MTQgUE0sIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+IE9uIFR1
ZSwgMjAxOC0xMC0wOSBhdCAxODozNiArMDAwMCwgQWRoYW0uQWJvemFlaWRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+DQo+PiBKb2hhbm5lcywgaXMgdGhlIGNmZzgwMjExX3NjYW5fcmVxdWVzdC5z
c2lkIHVzZWQgZm9yIHNvbWV0aGluZyBlbHNlDQo+PiBvdGhlciB0aGFuIHNwZWNpZnlpbmcgdGhl
IGhpZGRlbiBuZXR3b3JrcyB0aGF0IHRoZSBjb250cm9sbGVyIHNob3VsZA0KPj4gc2NhbiBmb3I/
DQo+IA0KPiBBaGgsIG5vdyBJIHVuZGVyc3RhbmQgd2hlcmUgeW91J3JlIGNvbWluZyBmcm9tLg0K
PiANCj4gV2VsbCwgaXQncyB0aGUgU1NJRCB0byBpbmNsdWRlIGluIHRoZSBwcm9iZSByZXF1ZXN0
KHMpLCB0aGUgbW9zdCBjb21tb24NCj4gdGhpbmcgdGhlcmUgaXMgdGhlIDAtbGVuZ3RoIHdpbGRj
YXJkLCBvZiBjb3Vyc2UuDQo+IA0KPiBTbyB3aGlsZSBpdCBtYXkgYmUgcmVxdWlyZWQgZm9yIGhp
ZGRlbiBuZXR3b3JrcywgaXQncyBub3Qgc3RyaWN0bHkNCj4gcmVsYXRlZCB0byB0aGF0Lg0KRG8g
eW91IG1lYW4gdGhhdCBpdCBjYW4gYWxzbyBiZSB1c2VkIGZvciBwcm9iaW5nIHNwZWNpZmljIG5l
dHdvcmtzIGV2ZW4gaWYgdGhleSBhcmUgYnJvYWRjYXN0aW5nIHRoZWlyIFNTSUQ/DQpJIHRoaW5r
IHRoaXMgbWlnaHQgYmUgYSBwb3NzaWJsZSBjYXNlIGlmIHRoZSB1c2VyIGlzIHRyeWluZyB0byBs
aW1pdCB0aGUgc2NhbiByZXN1bHRzIHRvIGEgc3BlY2lmaWMgbmV0d29yay4NCg0KPiANCj4gam9o
YW5uZXMNCj4gDQo=
