Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6614DC10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FDBF20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 21:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="NTfvx4WF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfDHVOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:14:03 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:63889 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfDHVOD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 17:14:03 -0400
X-IronPort-AV: E=Sophos;i="5.60,326,1549954800"; 
   d="scan'208";a="29892175"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Apr 2019 14:14:02 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 8 Apr 2019 14:14:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yC4aWbO7humXGd/bDOcgAeJieUc+u3exb8FTmDYjH0=;
 b=NTfvx4WF7iC4Net7lSicF3LeBSq/SzExtFzoiLWrFubQ/SJw7gfgWRtvvGrqhkkkUcnuSmWC60JeOswKepdZjgsVmp+lYLXfwI4uzJ5RkKBtDzsoF0aH8WTcqfDyamhNRelLVjwBJJuyT+RjFqPYlZNpo+ki8YJItASsxSW6twM=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1647.namprd11.prod.outlook.com (10.172.55.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 21:13:59 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::583a:f4d8:147c:549%5]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 21:13:59 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <penguin-kernel@I-love.SAKURA.ne.jp>, <Ajay.Kathat@microchip.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Avoid GFP_KERNEL allocation from
 atomic context.
Thread-Topic: [PATCH] staging: wilc1000: Avoid GFP_KERNEL allocation from
 atomic context.
Thread-Index: AQHU7UGtXlXQNpbR7Ee0SeVomeGLnKYyxXGA
Date:   Mon, 8 Apr 2019 21:13:59 +0000
Message-ID: <847e1f3c-f54f-ff4d-fa2e-74518597ef5f@microchip.com>
References: <1554641923-11503-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <1554641923-11503-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-clientproxiedby: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f354a7ec-61d0-467f-01a0-08d6bc671de3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1647;
x-ms-traffictypediagnostic: MWHPR11MB1647:
x-microsoft-antispam-prvs: <MWHPR11MB16471F35A8B3473E725D950E8D2C0@MWHPR11MB1647.namprd11.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(478600001)(186003)(6436002)(36756003)(316002)(4326008)(52116002)(99286004)(25786009)(6512007)(11346002)(6486002)(72206003)(5660300002)(14454004)(4744005)(76176011)(31696002)(86362001)(97736004)(64126003)(58126008)(26005)(102836004)(53546011)(6506007)(386003)(486006)(110136005)(2906002)(2616005)(476003)(105586002)(31686004)(3846002)(6116002)(66066001)(65956001)(106356001)(65806001)(7736002)(53936002)(65826007)(71190400001)(305945005)(8936002)(229853002)(68736007)(6246003)(256004)(14444005)(71200400001)(81166006)(81156014)(8676002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1647;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 74t84cNveJ14OhsBYpjcXFUsy+nxKXlhAJYKahhyR0qETdQmVfPS2wKfWwDo72rXbYINy7W/h1+9WwKLcz+Cn4TEIAhXLgNKTbYFEF5c7D7wUSV+Lc+iHutxaOmJUo188igDzShzIUrWSCjvynsQV2MT+QhuO45/XdqTRUTBxXt4+Y28Rx1B4KcZ8dhsytu0IGLeUpsHKZj5+I2PvoyEHeZiVbDQLJNWIaOfBHVP+MHvv1mCI1T+dUk2Y2D3vr9NHPbqLgK4rS3nTPbqnjgcX9gkCeBYovV8fAK6sobsOllvg33FiwCP+mqOpyM3nsJqqEEy61D++5RlgSBj6i36eNsFngIHpn2dZwElhp7cKTbdRLxbWUIQNcGw6+dNk6QyGPON0zGL0pfAdMk3GB/Or5XEtcdM5v08QGUSCIhJr2I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <358BB301207E274CA36C5F90092C4826@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f354a7ec-61d0-467f-01a0-08d6bc671de3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 21:13:59.1736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1647
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQpPbiA0LzcvMTkgNTo1OCBBTSwgVGV0c3VvIEhhbmRhIHdyb3RlOg0KPiBTaW5jZSB3aWxjX3Nl
dF9tdWx0aWNhc3RfbGlzdCgpIGlzIGNhbGxlZCB3aXRoIGRldi0+YWRkcl9saXN0X2xvY2sNCj4g
c3BpbmxvY2sgaGVsZCwgd2UgY2FuJ3QgdXNlIEdGUF9LRVJORUwgbWVtb3J5IGFsbG9jYXRpb24u
DQo+DQo+IFNpZ25lZC1vZmYtYnk6IFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJuZWxASS1sb3Zl
LlNBS1VSQS5uZS5qcD4NCj4gRml4ZXM6IGU2MjRjNThjZjhlYjUxMTYgKCJzdGFnaW5nOiB3aWxj
MTAwMDogcmVmYWN0b3IgY29kZSB0byBhdm9pZCB1c2Ugb2Ygd2lsY19zZXRfbXVsdGljYXN0X2xp
c3QgZ2xvYmFsIikNCj4gQ2M6IEFqYXkgU2luZ2ggPGFqYXkua2F0aGF0QG1pY3JvY2hpcC5jb20+
DQpSZXZpZXdlZC1ieTogQWRoYW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5j
b20+DQoNClRoYW5rcywNCkFkaGFtDQoNCj4gLS0tDQo+ICBkcml2ZXJzL3N0YWdpbmcvd2lsYzEw
MDAvd2lsY19uZXRkZXYuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMx
MDAwL3dpbGNfbmV0ZGV2LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY19uZXRkZXYu
Yw0KPiBpbmRleCAxNzg3MTU0Li5iYTc4YzA4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2lsYzEwMDAvd2lsY19uZXRkZXYuYw0KPiArKysgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEw
MDAvd2lsY19uZXRkZXYuYw0KPiBAQCAtNzA4LDcgKzcwOCw3IEBAIHN0YXRpYyB2b2lkIHdpbGNf
c2V0X211bHRpY2FzdF9saXN0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICAJCXJldHVybjsN
Cj4gIAl9DQo+ICANCj4gLQltY19saXN0ID0ga21hbGxvY19hcnJheShkZXYtPm1jLmNvdW50LCBF
VEhfQUxFTiwgR0ZQX0tFUk5FTCk7DQo+ICsJbWNfbGlzdCA9IGttYWxsb2NfYXJyYXkoZGV2LT5t
Yy5jb3VudCwgRVRIX0FMRU4sIEdGUF9BVE9NSUMpOw0KPiAgCWlmICghbWNfbGlzdCkNCj4gIAkJ
cmV0dXJuOw0KPiAgDQo=
