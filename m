Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DA6C282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 23:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CCE20868
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 23:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="dROkxDV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfDPXRL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 19:17:11 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12998 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbfDPXRL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 19:17:11 -0400
X-IronPort-AV: E=Sophos;i="5.60,359,1549954800"; 
   d="scan'208";a="30455192"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 Apr 2019 16:17:09 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 16 Apr 2019 16:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8qKSYUMQ8MhdDgbOkuqXRM0OP+kLQJZ3mI/o055sFs=;
 b=dROkxDV1g/Y3bCBaWvuTBoMqbQiai6TGbVvhmvEo32Pk72V+ot0GHjW8NUvUgnFvdhU6sN8EGZIa2BuHs8LjbCQY0rSyfKYBLCoYtkahdXTkaWLvQVOupkGlTmT3j7/2b5f3E8gVrpPKFY2CZOf7FQeoHllvNcJJB31NL3DFkSQ=
Received: from CY4PR11MB1366.namprd11.prod.outlook.com (10.169.255.11) by
 CY4PR11MB1990.namprd11.prod.outlook.com (10.169.252.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Tue, 16 Apr 2019 23:17:07 +0000
Received: from CY4PR11MB1366.namprd11.prod.outlook.com
 ([fe80::1876:f8de:e151:a674]) by CY4PR11MB1366.namprd11.prod.outlook.com
 ([fe80::1876:f8de:e151:a674%3]) with mapi id 15.20.1792.018; Tue, 16 Apr 2019
 23:17:07 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH] staging: wilc1000: Avoid GFP_KERNEL allocation from atomic
 context
Thread-Topic: [PATCH] staging: wilc1000: Avoid GFP_KERNEL allocation from
 atomic context
Thread-Index: AQHU9KqCo1GsnQS7DESi0k8GgOnP7w==
Date:   Tue, 16 Apr 2019 23:17:07 +0000
Message-ID: <20190416231701.24626-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::29) To CY4PR11MB1366.namprd11.prod.outlook.com
 (2603:10b6:903:2b::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86691826-1fb0-4ee8-a8e3-08d6c2c1a4e5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR11MB1990;
x-ms-traffictypediagnostic: CY4PR11MB1990:
x-microsoft-antispam-prvs: <CY4PR11MB1990F4E796F292B0F66846298D240@CY4PR11MB1990.namprd11.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(396003)(366004)(376002)(136003)(189003)(199004)(4326008)(25786009)(36756003)(6506007)(99286004)(107886003)(81156014)(476003)(5640700003)(386003)(52116002)(66066001)(6486002)(3846002)(26005)(6436002)(8676002)(2616005)(81166006)(2501003)(50226002)(486006)(5660300002)(8936002)(186003)(105586002)(6916009)(2351001)(53936002)(106356001)(14444005)(2906002)(256004)(7736002)(102836004)(6116002)(4744005)(305945005)(316002)(97736004)(6512007)(72206003)(14454004)(86362001)(54906003)(478600001)(71190400001)(1076003)(71200400001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR11MB1990;H:CY4PR11MB1366.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IQxPqrmiR1rhQ8EBRDaWV2GarDJLVop4ow/Yc/C4ZtIY+8MbRDE4LwU0XXg4VFm9uJ2l5rNSk5Ule5iXKgmumy4wXJmHd9ZnPFGtkAhDt/jOdZThrIxUl18DHcAdHIT1DaC5/dhPxeT29jA8Mc5S4yNnloqF5IsvrK5OYUxbSUWVNrxqDNMgLb3G05iWAifltnONu2ZE7Uc9kCJko623BmmSDyO3AtUmBLACouMIRZmOveM9XkI5kMfKZHrJk8m0HnbidTb5AfWYU/FQFCIXWRU0GDq0hVVxUpOU7XhnVfdF12wJYu40VqJh498oERuXEqGthI6p+jlxfU0uYivhSQ9J8/GMEe+qgsQmXIbbH/EpfDaWqPiPtqk6RGEgtQHJmztdpmYI0dgcT2f39ilrgLAxvJRUsDynUQZs+wZnls4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 86691826-1fb0-4ee8-a8e3-08d6c2c1a4e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 23:17:07.3817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1990
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogQWRoYW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5jb20+DQoNCnR4
cV9hZGRfbWdtdF9wa3QgYWxsb2NhdGVzIG1lbW9yeSB3aGlsZSBiZWluZyBjYWxsZWQgZnJvbSBh
dG9taWMgY29udGV4dA0Kc28gbmVlZHMgdG8gdXNlIEdGUF9BVE9NSUMNCg0KU2lnbmVkLW9mZi1i
eTogQWRoYW0gQWJvemFlaWQgPGFkaGFtLmFib3phZWlkQG1pY3JvY2hpcC5jb20+DQotLS0NCiBk
cml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMgfCAyICstDQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAv
d2lsY193bGFuLmMNCmluZGV4IDJiMzA5YzhhOGZiMi4uMGE3MTM0MDllYTk4IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfd2xhbi5jDQorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2lsYzEwMDAvd2lsY193bGFuLmMNCkBAIC0zMTYsNyArMzE2LDcgQEAgaW50IHdpbGNf
d2xhbl90eHFfYWRkX21nbXRfcGt0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHZvaWQgKnByaXYs
IHU4ICpidWZmZXIsDQogCWlmICh3aWxjLT5xdWl0KQ0KIAkJcmV0dXJuIDA7DQogDQotCXRxZSA9
IGttYWxsb2Moc2l6ZW9mKCp0cWUpLCBHRlBfS0VSTkVMKTsNCisJdHFlID0ga21hbGxvYyhzaXpl
b2YoKnRxZSksIEdGUF9BVE9NSUMpOw0KIA0KIAlpZiAoIXRxZSkNCiAJCXJldHVybiAwOw0KLS0g
DQoyLjE3LjENCg0K
