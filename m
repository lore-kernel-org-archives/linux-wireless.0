Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6567EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 08:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28CF1213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 08:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="heOqkYJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfBZIYl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 03:24:41 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:26089 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfBZIYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 03:24:41 -0500
X-IronPort-AV: E=Sophos;i="5.58,414,1544511600"; 
   d="scan'208";a="25234448"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 26 Feb 2019 01:24:41 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 26 Feb 2019 01:24:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YLcTTTB84UH3hFeBkARUYs9t9wEWOk3HavJwS2aRTc=;
 b=heOqkYJHeHilgW8Pu5vAtYwFbrHMSBo7s14sDU5tykoHYVqnMIuM4cqtTXKPPVcsBMfrbZgs5VPmXfghmlC6qvn8vQZHIHBR+/9dl9b2BaYPHj7DvBFcrdz/TGh8Wq5LK/H88ixYeSvLR+SkI1pnQb0dx+GKh7NSL5sVqD0FQYs=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3576.namprd11.prod.outlook.com (20.178.206.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Tue, 26 Feb 2019 08:24:37 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1643.019; Tue, 26 Feb 2019
 08:24:37 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <tsu.yubo@gmail.com>, <Adham.Abozaeid@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <yuzibode@126.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH V2] staging: wilc1000: fix incorrent type assignment
Thread-Topic: [PATCH V2] staging: wilc1000: fix incorrent type assignment
Thread-Index: AQHUzaTE3NAeHTeRO0Ci952y/7ZrI6XxvhGA
Date:   Tue, 26 Feb 2019 08:24:37 +0000
Message-ID: <8bc95d6e-3350-a6a3-fb63-f9da9e0b8c0b@microchip.com>
References: <20190226072556.26745-1-tsu.yubo@gmail.com>
In-Reply-To: <20190226072556.26745-1-tsu.yubo@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.24.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f05395e5-9065-4cbe-2cf2-08d69bc3d884
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3576;
x-ms-traffictypediagnostic: BYAPR11MB3576:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtCWUFQUjExTUIzNTc2OzIzOjN3RFBmWDBFZmptRmp2YWhielZQUUpMd3lu?=
 =?utf-8?B?U0VjbTI5Ym5XZlY2b3pKUU90WXdTbDBnd0pqTzN2M2pFbXVYcnhlY2pDSmZ6?=
 =?utf-8?B?Tmd0bWRGUTY2TlVub2NNSStrdkloZ3R3dTBDckhJcHM0NUlaVmJiaitmNndP?=
 =?utf-8?B?dkNUZDFreDkyS2NtazZBUDEvcE5DbHNwNm5YSlFLZFd2cTNxelRVZnovTFVH?=
 =?utf-8?B?RXVEdlB4c0JYMlNpb3lsVnV4L3V4ZEZibkl6c3lWenRpaWVrT0FibjNYMXBH?=
 =?utf-8?B?clNvUXZ2OGovSVVaR1dOR2d0dVJ5dE12Z0hhTk0zMHRIS1RwNW1XMlgybHYz?=
 =?utf-8?B?VmFXbU5KMGRSaFFzOElKa0l2RnllcSsyNFVOLzY0Y1BQa0dpWXpyUXRRa2pu?=
 =?utf-8?B?aG45NmQwOGxJNkIzQWl4TGVpbDZrOEpZeE8zclo0QTB1N1libUZ6OEEyVEpo?=
 =?utf-8?B?dnFTYzdQUFpvb2dxZmQ5am5Ed1Y0NTIrQ01HcTB6c1dXUEhrV2VsR2tjU3NI?=
 =?utf-8?B?U0hwZEg0cDF1czBTWkZPcE9SWmZsL1pjaHc5Z3NIcGVMOWttSEZUMHVOcUIz?=
 =?utf-8?B?T3F4RTJaZkJ4b0p4RHpHb1ZudWFPZzlhTWo0VWlSS2p5LzhkdVp2REk5aHNu?=
 =?utf-8?B?aU1EbjRlSWRsWHZSOFJWYVdzckJEVHdZUHYvQWhzaW9IVUcrajVJUEwyalBk?=
 =?utf-8?B?N1hmWnMxdE9IRzlxZW9VRmQ2UllyS3ljeEtrT0ZmYnFFTjFDb0p3Sm5GYjR4?=
 =?utf-8?B?YjR0WnZJYlp1SzZiT2dXSDYvbDc3VVpSWllnNS9pYTUraWFLUXJtRTY1RlM3?=
 =?utf-8?B?YkxkN09Bb2MvemZ6MXYwanRLeUc4OUsyaCtCd0plLzVjV3ptWkgzRjgxMWY0?=
 =?utf-8?B?UEprYit6UU12VlJ3SmY0dlIvTmxiSnRaT2pZcnNyZis5MjcrVmtybGZDVkVW?=
 =?utf-8?B?L05zU3phWDZQdzVxQUpkRDRERkZWTWVVdTdpVWo4YUpEYlUrSXpvNkVvRHZl?=
 =?utf-8?B?WXoyRDZVSFh3eDlSSEx4bE42YXVzTHhibXNiVXFKZTdSVjlvWm1YUG5nd1l4?=
 =?utf-8?B?MU84Mlc4YzgxNjdpTEFhNDRHa3g5T2tHRERERzJCaVVXblQzNW95c0R1c0JF?=
 =?utf-8?B?akZGSk83OVBnMGl3MWhoSmlvelZ4cFBVVzBpSE5zU3FreFRwaCtOeGoxcG1a?=
 =?utf-8?B?MXRGa1VCbjdWa0UyRHBZc3RBRjhQdVNzM0FZVVZtdXNPdDBhdG8wUmVzbkFr?=
 =?utf-8?B?K3k3dDFHd0ZQbXR4c2xZVWw3MDkrVFZrQ0s5NVh2ZVdtN3ArZlpTb3dYTXUz?=
 =?utf-8?B?MTdKTmFiZXpGODEwTFhXYkJEQlZabnNYcUtOUklSQ1dlKzV6TTZvOW15NDZO?=
 =?utf-8?B?M2cvK2c4SkJTb3U2dU9TZmtQOWlCcjNqZ3Qyc3JKOGFZWkZremxtOWg5U2V5?=
 =?utf-8?B?QnZqd0djVytWQ2pPL0NlakRaNCtUY2dXclVHb2dlS1B4eExmaXpzczYvMWNC?=
 =?utf-8?B?Nm44NnppUEhIVXJPT0NDcFRocnAxZ1YwK0xicDE1aGdZNzRGK25pb1RFZ0Fz?=
 =?utf-8?B?NFRHMjNrQVVqaWpkUHBwbkFZQ21Gd1JEOGcrYWo1TkpZeURwanFBajFOaDZU?=
 =?utf-8?B?a0RRUnNteWtYOEFabWFrQ2tRQ0tCaVN6NFhtUGlLREhwODN0b3BnMzd1SVFW?=
 =?utf-8?B?ZFovU0VOdGJiNUkvNGpISmpKLzZaeEpySWhIUXphYzNDSXhHZnpzekZaUm9x?=
 =?utf-8?B?Q1d4ZkRTY0xZbDR2S1lid0hBZnpZL1BBK2lzei9GTmhHT0xOR1ovdkNKbDUz?=
 =?utf-8?B?Q3lYSWQwUUwvN0ZHWCtiUDFlSXhyUmRPMm9NY3RpSXdXYlE9PQ==?=
x-microsoft-antispam-prvs: <BYAPR11MB3576AAFC1F7268B771729BB2E37B0@BYAPR11MB3576.namprd11.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(31696002)(14444005)(110136005)(54906003)(2501003)(14454004)(256004)(6246003)(316002)(3846002)(31686004)(106356001)(6116002)(105586002)(53936002)(305945005)(81166006)(81156014)(5660300002)(66066001)(476003)(8936002)(486006)(8676002)(2616005)(97736004)(446003)(11346002)(7736002)(6512007)(26005)(6486002)(478600001)(72206003)(2906002)(25786009)(36756003)(71200400001)(71190400001)(53546011)(4326008)(6436002)(6506007)(386003)(68736007)(186003)(2201001)(76176011)(99286004)(52116002)(229853002)(102836004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3576;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3fQ7hYieEyRV3TPyDoYI12F4hnZnoZo8tLLKsF8tlkCqSbAv0sDshseBj2tSXBzEBFpUlJOIfN4Mu0IAPxGYzaCDb10d6DYsGiogLzfvn7F7ikmr7epxOxB/1jlH8uZvkiFzWRlu4ZG2fFQzaY1c4o/NizBu8M6LbuOjmRT14EPJaFwz34r+LNEij4ZKACM/MlnsklII+SysKRYYN5VPhfLGRCCqDYFX5uVsjZyHaHB+iiucnw+t1EmiaouN8MVNIANK1PUNh57z3/iCr/fP/JtyVTz5dVRNKB0Hr1tSI6hATJCylificcyQt/jkTcTXnNHOzjLa7K0FyY/AbiGVxQNfqSoNKrE7DsccgzwvwjOwpEShD05iX3o5tFWOoAQYicssrZS9lW+/X+af/Zwq1sCNq24r4QAUGDqE2JS5Bck=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A4AD31E4EBB174482AC931CC38B5D62@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f05395e5-9065-4cbe-2cf2-08d69bc3d884
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 08:24:32.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3576
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

VGhhbmtzLg0KDQpPbiAyLzI2LzIwMTkgMTI6NTUgUE0sIEJvIFlVIHdyb3RlOg0KPiBGaXggc3Bh
cnNlIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZh
Y2UuYzo0NTA6MzA6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZl
cmVudCBiYXNlIHR5cGVzKQ0KPiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZh
Y2UuYzo0NTA6MzA6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTE2IFt1c2VydHlwZV0gYmVh
Y29uX3BlcmlvZA0KPiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYzo0
NTA6MzA6ICAgIGdvdCB1bnNpZ25lZCBzaG9ydCBbdXNlcnR5cGVdIGJlYWNvbl9pbnRlcnZhbA0K
PiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYzo0NTE6MjU6IHdhcm5p
bmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQ0K
PiBkcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYzo0NTE6MjU6ICAgIGV4
cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTE2IFt1c2VydHlwZV0gY2FwX2luZm8NCj4gZHJpdmVycy9z
dGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmM6NDUxOjI1OiAgICBnb3QgdW5zaWduZWQg
c2hvcnQgW3VzZXJ0eXBlXSBjYXBhYmlsaXR5DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCbyBZVSA8
dHN1Lnl1Ym9AZ21haWwuY29tPg0KDQpSZXZpZXdlZC1ieTogQWpheSBTaW5naCA8YWpheS5rYXRo
YXRAbWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gVjI6IHVzZSBjcHVfdG9fbGUxNiBhc3NpZ24g
dmFsaWQgdHlwZSBhY2NvcmRpbmcgdG8gQWpheSdzIHN1Z2dlc3Rpb25zDQo+IC0tLQ0KPiAgZHJp
dmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmMgfCA0ICsrLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50ZXJmYWNlLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2lsYzEwMDAvaG9zdF9pbnRlcmZhY2UuYw0KPiBpbmRleCA1MGRjMmRkOTQyZjUu
LjIwMzQ5YWYyZWQzMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hv
c3RfaW50ZXJmYWNlLmMNCj4gKysrIGIvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL2hvc3RfaW50
ZXJmYWNlLmMNCj4gQEAgLTQ0Nyw4ICs0NDcsOCBAQCB2b2lkICp3aWxjX3BhcnNlX2pvaW5fYnNz
X3BhcmFtKHN0cnVjdCBjZmc4MDIxMV9ic3MgKmJzcywNCj4gIAlpZiAoIXBhcmFtKQ0KPiAgCQly
ZXR1cm4gTlVMTDsNCj4gIA0KPiAtCXBhcmFtLT5iZWFjb25fcGVyaW9kID0gYnNzLT5iZWFjb25f
aW50ZXJ2YWw7DQo+IC0JcGFyYW0tPmNhcF9pbmZvID0gYnNzLT5jYXBhYmlsaXR5Ow0KPiArCXBh
cmFtLT5iZWFjb25fcGVyaW9kID0gY3B1X3RvX2xlMTYoYnNzLT5iZWFjb25faW50ZXJ2YWwpOw0K
PiArCXBhcmFtLT5jYXBfaW5mbyA9IGNwdV90b19sZTE2KGJzcy0+Y2FwYWJpbGl0eSk7DQo+ICAJ
cGFyYW0tPmJzc190eXBlID0gV0lMQ19GV19CU1NfVFlQRV9JTkZSQTsNCj4gIAlwYXJhbS0+Y2gg
PSBpZWVlODAyMTFfZnJlcXVlbmN5X3RvX2NoYW5uZWwoYnNzLT5jaGFubmVsLT5jZW50ZXJfZnJl
cSk7DQo+ICAJZXRoZXJfYWRkcl9jb3B5KHBhcmFtLT5ic3NpZCwgYnNzLT5ic3NpZCk7DQo+IA0K
