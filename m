Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B2AC10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACDC20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="CxRgh2PJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfDHVKF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:10:05 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5262 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfDHVKF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 17:10:05 -0400
X-IronPort-AV: E=Sophos;i="5.60,326,1549954800"; 
   d="scan'208";a="31064773"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Apr 2019 14:10:04 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 8 Apr 2019 14:10:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMnXaO79Wm2nA4VJfkULzZngG7rPbDIzRah2uVI7Iuk=;
 b=CxRgh2PJhQfqbVf8GMTzxOZfb3FV70uT8JKSEoYC4WtoafNFEFEOmlKV0Zl6lkr82+Yfgw631UbvmEgRKOH2hus9AxDG4+yW1JqtQjdXzFKj+IjYJf8iPvrzMn0xwlDCMk0L+oa806KuldGz+ea+6WLl+o2QlwYjkpwI/GMl4s8=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1983.namprd11.prod.outlook.com (10.175.54.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 21:10:01 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%5]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 21:10:01 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <hofrat@osadl.org>
CC:     <Ajay.Kathat@microchip.com>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Topic: [PATCH RFC] staging: wilc1000: give usleep_range a range
Thread-Index: AQHU7HE8koeh5e9EOkuq/fEUQd8KZ6YyxfUA
Date:   Mon, 8 Apr 2019 21:10:00 +0000
Message-ID: <d38b17d8-5b0f-5b5e-2933-0626700e8546@microchip.com>
References: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-clientproxiedby: BYAPR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::21) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6144131b-7c8d-4c12-06fa-08d6bc668fd7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1983;
x-ms-traffictypediagnostic: MWHPR11MB1983:
x-microsoft-antispam-prvs: <MWHPR11MB198355FBDC37E9F10713E1578D2C0@MWHPR11MB1983.namprd11.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(366004)(346002)(136003)(189003)(199004)(36756003)(4326008)(26005)(8676002)(446003)(53546011)(6506007)(386003)(64126003)(5660300002)(305945005)(97736004)(3846002)(106356001)(71190400001)(31686004)(6116002)(11346002)(71200400001)(68736007)(102836004)(25786009)(486006)(99286004)(52116002)(476003)(105586002)(86362001)(31696002)(6436002)(7736002)(53936002)(6512007)(186003)(65806001)(229853002)(14444005)(6246003)(316002)(478600001)(72206003)(81166006)(65956001)(14454004)(66066001)(2616005)(6916009)(6486002)(256004)(65826007)(76176011)(2906002)(58126008)(54906003)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1983;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: onpMLBL4CIVLTMQjHLK2EiEkN7Svb7G6WsCM5eoCM99ds7Fjk5O69EfuqpkDgHxcRyIKrhxS99uV2exmVzm75IJHUQSbVxAqmSnVixtu+VWbphTLRYEOyyaAOJ8C8pKta7DGYWMWZOoxbiqrIWdn3mGZU/fcq22wMjSBcKW9CQA0yHtDbNlBovwduid2dwDHWc1mNhmRnaZiU9hYx3Lr8g8qHW8epyzXLwYuqB1yCuJmyHvys6dcw/ObpiX4WE94tQemPMhtry9rmi8/+pN+SqP7pFj9l//wNZwg7omf83kb4DBv4Uc87Ad6phhFLxOI+azVYMv29Q+A928jNT5BBcMN++kU5SaBgIK5I/ROx2BfeZfHhYBT6oXmb+Bc3vQFnM+TkIXAOPuAckY6qJErUeUFsZA23Wr8aIJg3KrqCtQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BFE0523E5B1E14398BFCE5E7F576BFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6144131b-7c8d-4c12-06fa-08d6bc668fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 21:10:00.9116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1983
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgTmljaG9sYXMNCg0KT24gNC82LzE5IDU6MDEgQU0sIE5pY2hvbGFzIE1jIEd1aXJlIHdyb3Rl
Og0KPiBFeHRlcm5hbCBFLU1haWwNCj4NCj4NCj4gU29tZW9uZSB0aGF0IGtub3dzIHRoZSBtb3Rp
dmF0aW9uIGZvciBzZXR0aW5nIHRoZSB0aW1lIHRvIDIgbWlsbGlzZWNvbmQNCj4gbWlnaHQgbmVl
ZCB0byBjaGVjayBpZiB0aGUgMiBtaWxsaXNlY29uZHMgd2hlcmUgc2VlbiBhcyB0b2xsZXJhYmxl
IG1heCBvcg0KPiBtaW4gLSBJJ20gYXNzdW1pbmcgaXQgd2FzIHRoZSBtaW4gc28gZXh0ZW5kaW5n
Lg0KDQoyIG1zZWMgaXMgdGhlIHRpbWUgdGhlIGNoaXAgdGFrZXMgdG8gd2FrZSB1cCBmcm9tIHNs
ZWVwLg0KDQpJbmNyZWFzaW5nIHRoZSBtYXhpbXVtIHRvIDUgbXNlYyB3aWxsIGltcGFjdCB0aGUg
dGhyb3VnaHB1dCBzaW5jZSB0aGlzIGNhbGwgaXMgb24gdGhlIHRyYW5zbWl0IHBhdGguDQoNCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW4uYyBiL2RyaXZl
cnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX3dsYW4uYw0KPiBpbmRleCBjMjM4OTY5Li40MmRhNTMz
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMNCj4g
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbi5jDQo+IEBAIC00MDgsNyAr
NDA4LDcgQEAgdm9pZCBjaGlwX3dha2V1cChzdHJ1Y3Qgd2lsYyAqd2lsYykNCj4gIAkJCXdpbGMt
PmhpZl9mdW5jLT5oaWZfd3JpdGVfcmVnKHdpbGMsIDEsIHJlZyAmIH5CSVQoMSkpOw0KPiAgDQo+
ICAJCQlkbyB7DQo+IC0JCQkJdXNsZWVwX3JhbmdlKDIgKiAxMDAwLCAyICogMTAwMCk7DQo+ICsJ
CQkJdXNsZWVwX3JhbmdlKDIgKiAxMDAwLCA1ICogMTAwMCk7DQo+ICAJCQkJd2lsY19nZXRfY2hp
cGlkKHdpbGMsIHRydWUpOw0KPiAgCQkJfSB3aGlsZSAod2lsY19nZXRfY2hpcGlkKHdpbGMsIHRy
dWUpID09IDApOw0KPiAgCQl9IHdoaWxlICh3aWxjX2dldF9jaGlwaWQod2lsYywgdHJ1ZSkgPT0g
MCk7DQo+IEBAIC00MjMsNyArNDIzLDcgQEAgdm9pZCBjaGlwX3dha2V1cChzdHJ1Y3Qgd2lsYyAq
d2lsYykNCj4gIAkJCQkJCSAgICAgJmNsa19zdGF0dXNfcmVnKTsNCj4gIA0KPiAgCQkJd2hpbGUg
KChjbGtfc3RhdHVzX3JlZyAmIDB4MSkgPT0gMCkgew0KPiAtCQkJCXVzbGVlcF9yYW5nZSgyICog
MTAwMCwgMiAqIDEwMDApOw0KPiArCQkJCXVzbGVlcF9yYW5nZSgyICogMTAwMCwgNSAqIDEwMDAp
Ow0KPiAgDQo+ICAJCQkJd2lsYy0+aGlmX2Z1bmMtPmhpZl9yZWFkX3JlZyh3aWxjLCAweGYxLA0K
PiAgCQkJCQkJCSAgICAgJmNsa19zdGF0dXNfcmVnKTsNCg0KDQpUaGFua3MsDQoNCkFkaGFtDQoN
Cg==
