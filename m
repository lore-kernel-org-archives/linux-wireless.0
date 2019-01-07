Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8127DC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 06:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E7D2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 06:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="AVJES/WT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfAGGG7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 01:06:59 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54657 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbfAGGG7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 01:06:59 -0500
X-IronPort-AV: E=Sophos;i="5.56,449,1539673200"; 
   d="scan'208";a="23063032"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 06 Jan 2019 23:06:59 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 6 Jan 2019 23:07:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkBKnysmNIP0GUJCnSKwTacQRggJxHfHayourui/SkA=;
 b=AVJES/WTvoZwTrannoBclwThMB8gK2bHQq/PkVCPxvguMydjVVrubTl7popiwloPVcwSALeGtYtfrosfuDIweof8Ih+nXOLtpmnlOgrMsXd+z92aKq3jdFRElDSUb01SwL/pNI7Uggs4a+0Un5+f4TWuoFQh5g/FqmLifmaHt+U=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2613.namprd11.prod.outlook.com (52.135.227.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Mon, 7 Jan 2019 06:06:55 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 06:06:55 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <jmilan.dev@gmail.com>, <Larry.Finger@lwfinger.net>
CC:     <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>
Subject: Re: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
Thread-Topic: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
Thread-Index: AQHUpNaGjTDjnzVNXEuAySONhC/eQ6Wg1mmAgAEAEYCAAX5UgA==
Date:   Mon, 7 Jan 2019 06:06:55 +0000
Message-ID: <1c5c8efb-055f-31b2-b25f-18d3f6e64226@microchip.com>
References: <20190105091025.GA28917@localhost.localdomain>
 <61a272a5-3c6f-4e69-2ce9-b7c58b427750@lwfinger.net>
 <CAP=P++DRiM8Rb8vg9hBJ-N2uhfL0Rrj+njYwgZW80yQZ4jQH4g@mail.gmail.com>
In-Reply-To: <CAP=P++DRiM8Rb8vg9hBJ-N2uhfL0Rrj+njYwgZW80yQZ4jQH4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::18) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.65.197]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2613;6:p/PBrWn/ABsSMvZBB7kR7Iy7UgQo4vJT9WC1jShmzHJ4ol6oUMjMD6cPzbqLhAZYHFmNnvl1bA4kgUXdZCobAF0dXXpWyZYfL/5U1l70t0ZMRrKk/sxA1XMlFvmp7v/4c6gK81zRL6PryGxiM2gfrR1f9ZpEaMVfh5KkW7fduufLeObwSfwC82mZmWppkMgTJfdex1mjI4m3QCn8JEZBaXPNz1f2rLxue3WeVDFQuHn5o7ZstmgXSGFTpYksarOMIMIqZN3UgiUMeNkPfXxhD/Y3IjhiZUlbWzB3cnXe1GMdR9ZPC5jQ9krLC6eECkz8PgUBWP9q8fl6jJe6hzx/8Pwdc942J1Bn3B0gVhyg9I/FbKeYfyYFfh8u1BjLHENpRdrMQgmAEE7vQ1uo2homCUcNUXJ5NzyKlTEaZ9rlxVQ659LQhfu4Br8jbP2cFT9G1Izmqu41ST/bo/3cWh7RoQ==;5:8LyGK+8R/wk9vyd92splX8fZ2VFPY2GAB7szatf84dlOQZvw5IuHD6G4ubQggfcEbOs8NtyIwKeK9WtRdKSeJcv4AZ2ob4kFeSComqSItFMEXj2Y5xTIhW85LpbVqrgdZmMfTWEDe5l8vgSf9E/Vutov/lj8U9K/1484kxaiKvy23yYLKAW70iNpxioEyx5soj0/P0YXKprloXnlLhm6QA==;7:woVsyUMOPVvwtb0toe59r/dxRC7jHuzOLJaWUNgw0fv3ZHvl2y3lss0rRaM5dYCpEk14ExNhZX/OARtvuXy4TvFib8QX5piDEE4eLwvs5IiLHZCxHJ4BuMFcRJ/ik8gVmWfBz26z87kuYzzrB+elLg==
x-ms-office365-filtering-correlation-id: 342c3b4d-957a-4c93-7d04-08d674665318
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2613;
x-ms-traffictypediagnostic: BYAPR11MB2613:
x-microsoft-antispam-prvs: <BYAPR11MB2613C3A24BC2D23F03D5AC39E3890@BYAPR11MB2613.namprd11.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(3002001)(10201501046)(3231475)(944501520)(52105112)(6041310)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2613;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2613;
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(478600001)(105586002)(81166006)(54906003)(316002)(52116002)(11346002)(72206003)(25786009)(102836004)(386003)(6506007)(476003)(53546011)(2616005)(99286004)(106356001)(53936002)(39060400002)(256004)(97736004)(14444005)(6246003)(446003)(71190400001)(4326008)(107886003)(3846002)(486006)(6116002)(14454004)(36756003)(6512007)(575784001)(6486002)(66574012)(6436002)(26005)(71200400001)(66066001)(31686004)(31696002)(229853002)(86362001)(7736002)(2906002)(305945005)(76176011)(186003)(5660300001)(8676002)(8936002)(68736007)(81156014)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2613;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QiImWDMKB/qmM8kbWHFxZVEUUBChE7diVzzPBRxTtwSvgKwfAMBzpHDihCpt9raLMd9DLLjznQCHimtwg/BiFw/n9SBwIQciZv63sbvFVbJwV+q5GHCtQdmm+fCX42hGDuR8s7O+ofyUiwTgcxS/aZi8zN1ajvaWZZPyrGFpQniVnZCnLA3XN4MHyOqsLAJdLJRB7ia1BRRIl+GQv4fkZfdE8lu1NbZ6KlD35pUqZDttTAreqZoAZ0U8tfs3oWJLCteeZSRoXzY1Tbbk44E9jMibxguzMOtcphHrMbB+bDSw71mqOe6hJeHBOFIIgZ0h
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <33D40D1071AE03448CCDEBBA8E29352A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 342c3b4d-957a-4c93-7d04-08d674665318
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 06:06:55.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2613
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgSnVsaXVzLA0KDQpPbiAxLzYvMjAxOSAxMjo0OCBQTSwgSsO6bGl1cyBNaWxhbiB3cm90ZToN
Cj4+IEJlZm9yZSB5b3Ugc2VuZCBWMywgYXJlIHlvdSBzdXJlIHRoaXMgaXMgdGhlIGNvcnJlY3Qg
Zml4PyBBcyAiZnJhbWVfdHlwZSIgaXMNCj4+IGlucHV0IGFzIHUxNiwgaXQgc2VlbXMgdG8gbWUg
dGhhdCB0aGUgZnJhbWVfdHlwZSBtZW1iZXIgb2Ygc3RydWN0IHdpbGNfcmVnX2ZyYW1lDQo+PiBz
aG91bGQgYmUgX19sZTE2LCBub3QgX19sZTMyLg0KPiANCj4gWWVzLCBJIGFtIGNvbmZpZGVudCBh
Ym91dCBpdC4NCj4gVGhlIGZyYW1lX3R5cGUgbWVtYmVyIG9mIHN0cnVjdCB3aWxjX3JlZ19mcmFt
ZSBjb250YWlucyBpbiBzb21lIGNhc2VzDQo+IDMyIGJpdCB2YWx1ZQ0KPiBhcyB5b3UgY2FuIHNl
ZSBpbiBmdW5jdGlvbiB3aWxjX3dsYW5fY2ZnX3NldF93aWQuDQo+IENhc3QgdG8gMzIgYml0cyBp
cyBhbHNvIHNhZmUsIGR1ZSB0byByZXN1bHRhbnQgZW5kaWFubmVzcy4NCg0KVGhhbmtzIGZvciBz
dWJtaXR0aW5nIHlvdXIgcGF0Y2guDQoNCkJ1dCBhcyBMYXJyeSBwb2ludGVkIHdlIG5lZWQgdG8g
Y2hhbmdlIHRoZSAnZnJhbWVfdHlwZScgdHlwZSB0byAnX19sZTE2Jw0KaW4gJ3dpbGNfcmVnX2Zy
YW1lJyBzdHJ1Y3QuDQpUaGUgY29ycmVjdCBmaXggZm9yIHRoaXMgaXNzdWUgaXMgdG8gY2hhbmdl
IHRoZSBkYXRhdHlwZSBmcm9tIOKAmF9fbGUzMuKAmQ0KdG8g4oCYX19sZTE24oCZLCBhcyB0aGUg
ZmlybXdhcmUgZXhwZWN0cyBpdCB0byBiZSBhIDE2Yml0IHZhbHVlLg0KDQpBcyB3aWxjX3dsYW5f
Y2ZnX3NldF93aWQoKSwgaXMgYSBnZW5lcmljIGZ1bmN0aW9uIHRvIHBhY2sgZGlmZmVyZW50DQp0
eXBlcyBvZiBXSUQncyBlLmcgY2hhciB1OCAoMHgweHh4KSwgc2hvcnQgKHUxNikgKDB4MXh4eCks
IGludCAodTMyKQ0KKDB4Mnh4eCksIGJ5dGUtc3RyaW5nICgweDN4eHgpIGFuZCBiaW5hcnkgZGF0
YSgweDR4eHgpLiBBbmQgYmFzZWQgb24gdGhlDQpXSUQgdHlwZSB0aGUgc3BlY2lmaWMgcGFjayBm
b3JtYXQgaXMgdXNlZC4NClRvIGZyYW1lIHJlZ2lzdGVyLCBXSURfUkVHSVNURVJfRlJBTUUoMHgz
MDg1KSBXSUQgdmFsdWUgaXMgdXNlZCBhbmQgaXQncw0Kb2YgYnl0ZS1zdHJpbmcgdHlwZS4gU28g
dGhlIHBhY2tlZCBzdHJ1Y3QgdmFsdWUgaXMgdHJhbnNtaXR0ZWQgYXMgYW4NCmFycmF5IG9mIHU4
IGRhdGEuIElNTyB0aGVyZSBpcyBubyBlbmRpYW5uZXNzIGlzc3VlIHByb3ZpZGVkIGZpcm13YXJl
DQpleHRyYWN0cyBtZW1iZXJzIGluZm9ybWF0aW9uIGluIHRoZSBjb3JyZWN0IHN0cnVjdHVyZSBv
cmRlci4NCg0KUGxlYXNlIHJlc3VibWl0IHRoZSBwYXRjaCBieSBjaGFuZ2luZyAnZnJhbWVfdHlw
ZScgdHlwZSB0byAnX19sZTE2JyBpbg0KJ3dpbGNfcmVnX2ZyYW1lJyBzdHJ1Y3QuDQoNClJlZ2Fy
ZHMsDQpBamF5DQo=
