Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FA1C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49DD02054F
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="SneVuOxz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49DD02054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbeJZFpS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 01:45:18 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:49536 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbeJZFpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 01:45:18 -0400
X-IronPort-AV: E=Sophos;i="5.54,425,1534834800"; 
   d="scan'208";a="22149262"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Oct 2018 14:11:00 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 25 Oct 2018 14:11:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIbcJKCC6PDiA5AnDr4sGLGoMLYPjdwBOsoHuHyP+DQ=;
 b=SneVuOxzt2mNoZNn55YIMsCBHHXj9WzmM0zpyIXYCIHy+/SGVZgv0+RACEjB3PR7HIb1JZFSdKMoD7GIJXvOU03hBqyqZ61I+hjY8Z6OsyXlHcX5VuE+D/3Pp9rDhTxfOKHtoG3AY2dn9CmVIkiEHiTtHG2xaolAXMdQq1FglN8=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0350.namprd11.prod.outlook.com (10.160.136.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.18; Thu, 25 Oct 2018 21:10:57 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.028; Thu, 25 Oct
 2018 21:10:57 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH 0/4] staging: wilc1000: validate input to set_wiphy_param and
 return proper errors
Thread-Topic: [PATCH 0/4] staging: wilc1000: validate input to set_wiphy_param
 and return proper errors
Thread-Index: AQHUbKc5/8hxfWQ340+wikkjpuETEQ==
Date:   Thu, 25 Oct 2018 21:10:57 +0000
Message-ID: <20181025210849.20006-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::43) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0350;6:nfLrXRzAjAYseUbzAISsIwLSu4fqRxbT3LsmtLgZRdBXX67qLYBUwXba+MEBD2cgvDXjhvdesqaXLB9ozyTvrffXBsus0fF02MkpNpIMIKIQF1d46UOvEyCILzpU1NVISr1IJpl7ikpo82caCGYHW8+TAVRObeQs9p+ZsAY6oJpqYmV2rM75/GLSoInGfHJaGFWbe8nONx1v/Wh8wWM4sScSC1UL+jzohv9H2Gu4mSxQ3ep6D8yuW0nUQsykrJWIHOMrhKj27SQCkiLjfNHaaWRfpigBRBm+FcCkMupO6Dh42FVL243o87anOyrF+lfRjpBtmlM1onMeDl1oDE/Fd5/Yj/Kk2miBy7jdR7rsi0OsdMmsWbsS4mH7tG4pAB9WDVA4BpwnBMrZSBjdi6JMZ6U1xk9AKfyXkrKSg+yVrVmgB2XQSQyVDXpRX17oW+Adm2VLVqYhlYYJIx6sJFQrOg==;5:i1pUB05ViFMrcFRKYEnx4qnpM1itWeIeiJnQeOyxEXZKeRhsKiizClo1Ow3qvi+TRYw5jFBSGSyJSNbzYcC7y8maKCg52UBPAYx+HazwH4K0Q2tAxDadtcOyN0j0IrGUzGOC+h1B1J2T9ytA7+NUR6n2rwjmppa2jt87U1sc620=;7:nfOy8p8+c7iB7VmEu6pyLXZhlauPyN1HPN3joQxvLtdIY4+vfjMOQCX0l22k06mvC+3tM/903Qaxg6AJwtHVPjpzmP0P/2ga9Wr7H/1q4T/lGJhg9SZ2YDByrPGTi8kTj85aMjEN6ifiJoD2YqmEsA==
x-ms-office365-filtering-correlation-id: 46b506a8-9ae7-4c2c-f209-08d63abe5b74
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0350;
x-ms-traffictypediagnostic: DM2PR11MB0350:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0350D94E8BFEE135196BC9E88DF70@DM2PR11MB0350.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0350;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0350;
x-forefront-prvs: 083691450C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(386003)(6506007)(2900100001)(14444005)(3846002)(6116002)(71200400001)(68736007)(36756003)(81166006)(5250100002)(81156014)(2906002)(2616005)(476003)(4326008)(71190400001)(1076002)(5660300001)(52116002)(105586002)(86362001)(8676002)(15650500001)(256004)(478600001)(66066001)(99286004)(26005)(53936002)(102836004)(6512007)(54906003)(2351001)(2501003)(316002)(25786009)(97736004)(106356001)(72206003)(6436002)(5640700003)(6916009)(14454004)(305945005)(186003)(107886003)(8936002)(6486002)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0350;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ErVdbq2mqnuUlKaajP50Vb3zPKreUJncfZRLtLNwpsKDx/LqyzIK/zKFvVM587OZdAGdyKOIRGJHGoqpxUXg01GAD4tN8wikPupHZxkfXDL1pVJNZNKQ4u+ZEmv0JzpW01mIUqtmqjTP/AO9vNfZ7+Iz36cS/7j2Y+zuJZH39IH5NR7gsb9mjpmWvPciVcLDW5t9opBOcv7AjwIRf5nPmS+thDrtNxrI2it2besVlWTGJl1wlbyOcSk4yrOd15T7uig0igwwHTq0MjqXctKF+5J2Vr6Rj+MCIPQPqyvwatfx0do6Dn4PxJnyFsAsAdI3UVyqtL687CxDxGKaRLMxbwo5Pr5R1p95UGjvC0n8ExQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b506a8-9ae7-4c2c-f209-08d63abe5b74
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2018 21:10:57.7275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0350
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Validate input parameters to set_wiphy_param before scheduling
handle_cfg_param() to validate them.
This way proper errors can be returned to caller.
Also cleaned up unused code in handle_cfg_param.

Adham Abozaeid (4):
  staging: wilc1000: remove unused flags in handle_cfg_param()
  stagign: wilc1000: validate cfg parameters before scheduling the work
  staging: wilc1000: Don't keep a copy of wiphy parameters in the driver
  staging: wilc1000: Remove unused mutex cfg_values_lock

 drivers/staging/wilc1000/host_interface.c     | 291 +-----------------
 drivers/staging/wilc1000/host_interface.h     |  32 --
 .../staging/wilc1000/wilc_wfi_cfgoperations.c |  50 ++-
 drivers/staging/wilc1000/wilc_wlan_if.h       |   9 -
 4 files changed, 58 insertions(+), 324 deletions(-)
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.c
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.h
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wfi_cfgoperat=
ions.c
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wlan_if.h

--=20
2.17.1

