Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008B3C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 02:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A3F2085A
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 02:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="BsBQ4UzP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfAHCwu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 21:52:50 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:13933 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbfAHCwu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 21:52:50 -0500
X-IronPort-AV: E=Sophos;i="5.56,452,1539673200"; 
   d="scan'208";a="24763088"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Jan 2019 19:52:49 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 7 Jan 2019 19:52:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VxU1ZTb97AHaSJjQKzN14OU2U+JX0dyXq1tGSjfdP0=;
 b=BsBQ4UzP4n7370icCBlspO4duV3weRrLlmCBra/FWMS+HwBkIgMJFhq/dTbfqQRCJFybvTPYQFvkn/cIA3s0hXUEu5Kqxetu0/xE0QYGHfU5pcsJMEqIxzZOafqM43zU5o1SQgZgXcPCGx1joIcmn47ltbQBZbJFadUJ4IFs8Y0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2936.namprd11.prod.outlook.com (20.177.228.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Tue, 8 Jan 2019 02:52:47 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1495.011; Tue, 8 Jan 2019
 02:52:47 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <jmilan.dev@gmail.com>, <linux-kernel@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>
Subject: Re: [PATCH v4] staging: wilc1000: fix registration frame size
Thread-Topic: [PATCH v4] staging: wilc1000: fix registration frame size
Thread-Index: AQHUppda+eTz9y0zF0yPYg123AH38KWkrWaA
Date:   Tue, 8 Jan 2019 02:52:47 +0000
Message-ID: <5edec4b7-0a46-a509-c3b5-d3d915ff765f@microchip.com>
References: <20190107144305.GA14627@localhost.localdomain>
In-Reply-To: <20190107144305.GA14627@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To BYAPR11MB2567.namprd11.prod.outlook.com (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.219.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2936;6:746KmkoiUX/SSXe59azpxHm8mTSw4Asu0pqHykqHFZoK6LADlyLNJ2ioWmJt51pfD7DGceYTZeGDPszvKlvuxcW2QjlFqtDXdZk00rqP5yP0PLXHkJ28wL9Axah2ROoUQGjSy+YzU2QCF8vJ1ofrMcM6XcnXmhs8IAlZD4byUG4z+8YavQVA2BelCZG0+3qg8BW0Yz/ZvXLt5PTH6wlLpoLdt8uDzqzlXtjURpwRdquygrDvD1uuVIHoo5Tiszb1PJMjt+HAEPJybGVwst2+1vsGUog2y8UGrLC5sZ6YasjoAfkZo540A9s7RdensSOGCqziBDUrC/OySopUDdiEBAYKgpm3bMKZ2BwcqRDwLDVaDMSH/+h4V/vEn/BILwujS1b7iqQ5J6AWJpYvIKD/+YUfLFKJycbv7SKJr56BNv2KgfBrS510+cXdNJXz38wjcK14qSxF99dHUTAzjRbeeg==;5:5Emy7IuAyvWuqn2FWFgI4tI/lnzY7Ka3Tuk70dgUsFU7+SzwtFMrb2Uy565bRCeCvXbZWGI/zb9M4C6zO5rdyRZJOqRm2QWeFmn5cSphQecHRYfyBRUKQaHZBXpCOvBCz6uPtjTHO0x0Hd/veaRXD6zd17lX8e0sbLxDSb55aXp6kEF/Be/BM6cLyTZr75SEcsXm7bwYhsAJz2MVqtYMNw==;7:Va5hlcbLQYH6pGyP5dv/WUPGPXK9p2XLx2eVYIB7F3HF5qxnGQZdIFgV8JWfEwJtddk98cNAgPjV2V25tQg9tI22y/DdFZzjonZDpNyviHiOpZ03saZDyZXSFg7iuAzR4nY9RVHF2cSwSAR6zNV71A==
x-ms-office365-filtering-correlation-id: 6fefff1b-df7d-4725-e9f5-08d675145ea1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2936;
x-ms-traffictypediagnostic: BYAPR11MB2936:
x-microsoft-antispam-prvs: <BYAPR11MB293610C33EDA751E899BD614E38A0@BYAPR11MB2936.namprd11.prod.outlook.com>
x-forefront-prvs: 0911D5CE78
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(446003)(2616005)(11346002)(66066001)(53546011)(6116002)(2906002)(305945005)(3846002)(186003)(6506007)(386003)(102836004)(316002)(110136005)(486006)(54906003)(31686004)(97736004)(52116002)(36756003)(105586002)(26005)(99286004)(31696002)(68736007)(72206003)(2501003)(71200400001)(4326008)(71190400001)(478600001)(76176011)(476003)(106356001)(8676002)(6486002)(78486014)(8936002)(14454004)(6436002)(25786009)(107886003)(256004)(81166006)(81156014)(53936002)(6246003)(229853002)(14444005)(5660300001)(39060400002)(7736002)(66574012)(6512007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2936;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nDfThAJ+AEypmAhEkvWTfHSptYLXLasZ6fskoIZQM2hk1kzW40AQQePm7CTJgSiFOIKdkh9y7rf83x+HpZpDJ3QFtFKQLN2+FadIJXVqAJLQfdcEseutmgVAGj9gV3rFd0ySTGUroTrK+bU2t9n2sfoEsgNm8HCQlZb2/DdRvvBXLM6VKIIl+jJgWUKbWqExPD5fy/i/WWT3CAf+zwa3Mh6jsqE1wQZgPrXBtOuFmxFrige8kMC2H88E9X+A8j7uShT4Gayd2LitpzCZxspDImarmKTh672LZ7hPCST2Q4RWV/AS+QllJDwlgU4AVtqh
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE0C8267C3B526439692BF65E900E9E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fefff1b-df7d-4725-e9f5-08d675145ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 02:52:47.0250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2936
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDEvNy8yMDE5IDg6MTMgUE0sIErDumxpdXMgTWlsYW4gd3JvdGU6DQo+IEZpeGVzIHRo
ZSBmb2xsb3dpbmcgc3BhcnNlIHdhcm5pbmdzOg0KPiANCj4gZHJpdmVycy9zdGFnaW5nL3dpbGMx
MDAwL2hvc3RfaW50ZXJmYWNlLmM6MjM2MDozMDogd2FybmluZzoNCj4gIGluY29ycmVjdCB0eXBl
IGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQ0KPiAgICAgZXhwZWN0ZWQgcmVz
dHJpY3RlZCBfX2xlMzIgW2FkZHJlc3NhYmxlXSBbYXNzaWduZWRdIFt1c2VydHlwZV0gZnJhbWVf
dHlwZQ0KPiAgICAgZ290IHJlc3RyaWN0ZWQgX19sZTE2IFt1c2VydHlwZV0gPG5vaWRlbnQ+DQo+
IA0KPiBGaXhlczogMTQ3Y2NmZDQ1MTAyNCAoInN0YWdpbmc6IHdpbGMxMDAwOiBoYW5kbGUgbWdt
dF9mcmFtZV9yZWdpc3RlciBvcHMgZnJvbSBjZmc4MjAxMSBjb250ZXh0IikNCj4gU2lnbmVkLW9m
Zi1ieTogSsO6bGl1cyBNaWxhbiA8am1pbGFuLmRldkBnbWFpbC5jb20+DQoNClRoYW5rcywgdGhl
IGNoYW5nZSBsb29rcyBmaW5lIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTogQWpheSBTaW5naCA8YWph
eS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCg0KUmVnYXJkcywNCkFqYXkNCg==
