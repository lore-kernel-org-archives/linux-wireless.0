Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BBCECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4AC20827
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 16:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="xNKlsxfE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD4AC20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbeKICEL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 21:04:11 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:18404 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeKICEL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 21:04:11 -0500
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="23017623"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Nov 2018 09:27:55 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 8 Nov 2018 09:27:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a/w/CrM6Aiw8Ts5CeNV4ursrE1YinKONLRYAhgpBow=;
 b=xNKlsxfEIX1W91I9MvfHog1ywjdEcw3bJsSZkEiNLfzTpxNPjnFCKNetrYRmMJj7UMjj6EsyyrHuNWOQxEDueTU8mq+mUDKaKiCm5PvyqsfZyg6Xaf1f9ipUNuKkPL389l6MJKX3uTdV0IXPR37AAdDRg1yQ/sykXOO0h7OoaVs=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB2814.namprd11.prod.outlook.com (52.135.93.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Thu, 8 Nov 2018 16:27:52 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 16:27:52 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <johannes@sipsolutions.net>, <Aditya.Shankar@microchip.com>,
        <Ganesh.Krishna@microchip.com>
Subject: Re: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUdWPXxcun4ZLEiEWHqfumlI+XRaVFv+IAgABVUIA=
Date:   Thu, 8 Nov 2018 16:27:52 +0000
Message-ID: <6463e809-bb0f-60cb-56b9-fc9b0c0cc203@microchip.com>
References: <20181106000109.6178-1-adham.abozaeid@microchip.com>
 <20181106000109.6178-3-adham.abozaeid@microchip.com>
 <20181108112228.GA9001@kroah.com>
In-Reply-To: <20181108112228.GA9001@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101
 Thunderbird/58.0
x-clientproxiedby: BYAPR07CA0094.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::35) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2814;6:74FXSDrfK009gFX3mB0fSIgn10Ackm86hCRvLuNRlLLVH+pTWXWdnXw/U1S+4yetY1TfL6+mZ3AuIvbqECKwLfMQNkDO56vtobRV6KBAjaBd1iUEAVQFv8O6IRCbNqLjTf0Sx1RnrStFCqmr6a9FEfVZQIAWyuUT83+hHP0x5mT8DWYg4j/NVuxcIh2seYwtJiSI0lY3mLG3sceQGy1kkxH3RMpHwby0m9u7Tfx25BsixYbXOHD1DYVLb+Pv9PqYXk6eM1Vz8uukZV73ICqBvUSo/MExIzvDdMjsXDXisGmkae+S/8f/FG9INvxPan96mM4cdtJ1Km0QDBxsRGN2uWQZ9qnVYiohg3C6H49i8NG1UplWS9Ve1aPz/SAHejr/GlDhXPiz3ycV32DXl1HbDuHnkFm096tPKb2Wfkeb2I7AyDGdYWcdS1dFdZO+DenN6opjgpujH9uFtMutuk9IUA==;5:o9BOwwm7jIXrouDGpCMJ1sCHY3Jl/KEdttPAsbHMtWL3631c2UvZ9wwtz5Q9ZGuZBgET8pYtJWaGq5Jh4GJzyP1U7rOEXpmNhGLRe7IdggY4OtTjNl2un++3jyDNIl1SXGBt3YiLv7arO+IsqNxrxhXKfyl1tT00GZHAquLpuEU=;7:tw5rTHZ32VxfAsYq7AZWVcnhoJOjwHlFP/7ZkP1aXl2SSLhUeP7L6ZvnxcJ4/fezffCSNCLU6jmIlDUZ6yHY4G1lv7sG/5gMYwULMYWrxdPTAA7r58yGKDbfhdq4h3P3u179uZVNf0S/ZU0B86hddg==
x-ms-office365-filtering-correlation-id: ad842049-2b10-41d7-dd41-08d645972135
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2814;
x-ms-traffictypediagnostic: SN6PR11MB2814:
x-microsoft-antispam-prvs: <SN6PR11MB2814AC9A86E7F929C66C4C6E8DC50@SN6PR11MB2814.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2814;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2814;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(376002)(346002)(136003)(199004)(189003)(4326008)(99286004)(76176011)(25786009)(65826007)(52116002)(86362001)(229853002)(31696002)(305945005)(7736002)(6916009)(8936002)(6436002)(6116002)(3846002)(478600001)(81156014)(5660300001)(6486002)(6512007)(36756003)(8676002)(81166006)(31686004)(68736007)(106356001)(105586002)(107886003)(386003)(6246003)(53546011)(6506007)(2906002)(26005)(15650500001)(53936002)(97736004)(256004)(186003)(486006)(2616005)(476003)(11346002)(65806001)(446003)(14454004)(64126003)(66066001)(65956001)(58126008)(54906003)(316002)(14444005)(71190400001)(2900100001)(71200400001)(102836004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2814;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: /kIpzDcF7Mc6360j7p1LiV6DhLQVFTKUz1U4g8cSaEx3ccNom+gIvNzMUKSBTYwMAlxVD5r6Gg90QwGvLPUf90uyPmz65g1E0lPgbGr45H6ooskSrvtIq92ykHoLQGttxO/JfHZv10yRWw5mdhMwklBAB2LEOVLkKNgHem3QHK9WtY7KEJBQzkdB5NAkTdreq7LpXt92AS46+vwpKaGV+eTUACd97El6skRGHG2CxJlK8opvZcyxPcIOW/sMPp3RIXF+ZP2yMHDKPdXLefmKWwrss9FUHVh5nKeITzveUXhtU+Qg34zrgC1GDrjobT0eR5MRjA+F2XwXiiF6R63L9HcukONywvOHvZPTkqS3SNA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D755B600EEFB946A36256654985589D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad842049-2b10-41d7-dd41-08d645972135
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 16:27:52.3279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2814
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQpPbiAxMS84LzE4IDQ6MjIgQU0sIEdyZWcgS0ggd3JvdGU6DQo+IE9uIFR1ZSwgTm92IDA2LCAy
MDE4IGF0IDEyOjAxOjE4QU0gKzAwMDAsIEFkaGFtLkFib3phZWlkQG1pY3JvY2hpcC5jb20gd3Jv
dGU6DQo+PiBGcm9tOiBBZGhhbSBBYm96YWVpZCA8YWRoYW0uYWJvemFlaWRAbWljb2NoaXAuY29t
Pg0KPj4NCj4+IFZhbGlkYXRlIGNmZyBwYXJhbWV0ZXJzIGFmdGVyIGJlaW5nIGNhbGxlZCBieSBj
Zmc4MDIxMSBpbiBzZXRfd2lwaHlfcGFyYW1zDQo+PiBiZWZvcmUgc2NoZWR1bGluZyB0aGUgd29y
ayBleGVjdXRlZCBpbiBoYW5kbGVfY2ZnX3BhcmFtDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWRo
YW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5jb20+DQo+PiAtLS0NCj4+ICBk
cml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYyAgICAgfCA2MSArKysrKyst
LS0tLS0tLS0tLS0tDQo+PiAgLi4uL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193ZmlfY2Znb3BlcmF0
aW9ucy5jIHwgNTAgKysrKysrKysrKysrLS0tDQo+PiAgMiBmaWxlcyBjaGFuZ2VkLCA2MiBpbnNl
cnRpb25zKCspLCA0OSBkZWxldGlvbnMoLSkNCj4gUGxlYXNlIGZpeCB0aGlzIHVwIHNvIHRoYXQg
dGhlIDAtZGF5IGJvdCBkb2VzIG5vdCBjb21wbGFpbiBhYm91dCBpdC4NCg0KU3VyZSBHcmVnLiBJ
J2xsIHN1Ym1pdCB2NCB3aXRoIHRoZSBmaXggZm9yIHRoZSBib3Qgd2FybmluZy4NCkkgYXNzdW1l
IEkgc2hvdWxkbid0IGluY2x1ZGUgcGF0Y2ggMS80IGluIHRoZSBuZXcgdmVyc2lvbiBvZiB0aGUg
c2VyaWVzIHNpbmNlIEkgc2VlIGl0IHdhcyBhcHBsaWVkIGFscmVhZHksIHNvIEknbGwgb25seSBy
ZXNlbmQgdGhlIG90aGVyIDMgcGF0Y2hlcw0KDQpUaGFua3MsDQpBZGhhbQ0KDQo=
