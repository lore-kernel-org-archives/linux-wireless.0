Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999A8C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B76A20855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="s85paprp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B76A20855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbeKJECC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:02:02 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:23471 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbeKJECC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 23:02:02 -0500
X-IronPort-AV: E=Sophos;i="5.54,484,1534834800"; 
   d="scan'208";a="20184473"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Nov 2018 11:20:17 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 9 Nov 2018 11:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmv34gVxDQpqGEUnvlzxZpmduqWrMn4ennRuizkRvSg=;
 b=s85paprpouu2FcYsc2UNVcv+yxZ/pstihzrHEuLyjcnZcnA+YbpWKA0cYOlWaclQhH1kvd9+kJi4v5WnUTjvKBEf5uOwu+rNQD3sMmgdhXyyQ+1PAKKmxe9iH+pt3Sh3rB7ug+43WefJWsjIDWl0tOZY3wlkOHMUrMcV/0YgfRc=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3055.namprd11.prod.outlook.com (52.135.126.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.22; Fri, 9 Nov 2018 18:20:15 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 18:20:15 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v5 0/3] staging: wilc1000: validate input to set_wiphy_param
 and return proper
Thread-Topic: [PATCH v5 0/3] staging: wilc1000: validate input to
 set_wiphy_param and return proper
Thread-Index: AQHUeFjcVojKii+LiEGxqD0MQgrkPQ==
Date:   Fri, 9 Nov 2018 18:20:15 +0000
Message-ID: <20181109182008.4328-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3055;6:HhoziPY4T6nYhipVoNFQaa7pSrlIwvcMv/ST8Oc9W7zGVikSdGk+e+QlAgrEScQhGJVZcD8EhRVEhHWPnK8M7aYxk1k799qaRzX8YR4VeYVkif70+Z4XwpnO93XnsrfBqxvq/HGr2wZcxVCLFkbshGalQ7DrgEiBaFhIhPQu00kpTcb34cDSZNPMRFd5W++ceImBWHPgy5lvA+YGbjcOOwtTKHzFHkLZIn4ng9jhwrGeO+NHGVFF/y8LRlmYs5X1NKu9xRAi2FJ5IBRn562F46iftbx8LyuKNyHVlhyThD9kv6LtJrGrBjx/PukPn5Y/FZ6ZjBemmNmBzwGs7a0bmJVk3p/b2UKADUIrUq7VneDJlbw21LAw1q2FngJNCMtWLN+1y1zmSSy01dul/GhUJASFDGN6Yhu/mJZRASWZOnWAGmJXEv6hE3AdoaZTehAePYl+BMTtmX96U2w7EiwMyQ==;5:AJojyVqNpsqe2ni31LxcyOlfJIScdA9yUNmphx5Bisa/7BGw7XYDjAPhZJxfXxOlER1uSDMmHd4dudI8PzhXEbCWV2a/KoeIcpYriOefRubH/xvBH8bdORc94QA/4cJkY8d5S++JXCEdFiFxLuZgNwmVFMhK5g7Ga1+tvFltrlM=;7:oHMnJKxe+lS8ehTmKs0/w2fbpBPiOZayn2F4r9AacOyqYfpwfo9/hoDRTRaw4AKdJ1yzGR01TJ1rAaq8e6vbN0cLH+BNwrCOEyF3nMEQ/v3gIwY4YoHZ1iY9mRNPOD5nQ7FOHhgC7mCUY4UfTmJH6g==
x-ms-office365-filtering-correlation-id: 68654d68-8946-4475-6a5c-08d6466ffebc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3055;
x-ms-traffictypediagnostic: SN6PR11MB3055:
x-microsoft-antispam-prvs: <SN6PR11MB3055D6CEB4144A15974BB0328DC60@SN6PR11MB3055.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3055;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3055;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(6512007)(8676002)(54906003)(305945005)(66066001)(478600001)(2501003)(2900100001)(81166006)(72206003)(105586002)(476003)(81156014)(106356001)(316002)(68736007)(7736002)(486006)(97736004)(6486002)(2616005)(14444005)(256004)(6436002)(86362001)(5660300001)(6506007)(386003)(53936002)(52116002)(26005)(6916009)(15650500001)(71190400001)(5640700003)(102836004)(71200400001)(14454004)(99286004)(2351001)(36756003)(2906002)(4326008)(3846002)(6116002)(8936002)(1076002)(25786009)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3055;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: bWTCVmCjJ0yw9xPHq2hPnPpi2bXGmQtNZADAv1HC3HOlvqVhhzJ6Jjkd+DCLksr8AdZ9tAfZguOsm4tUh+DbKraLSCqCvK6/XH8V/WBI+qTs0YYqqtm3xTN9CYOjwneIhinZx+yAgieCyvonZrZdAWewLQ79SD4lxMGxEp0pPwq8+fXXfRZJkx0MY0hHw4ndesc5iXnP5sTaa9DXuZP6D6pj50pAtMqHH18V80Imrmpr364bXqSjhSIrqzqzDAH1AVKgkB076SA4uNtXvb5lGbcPtN12NhnZG4HZ/uy8aDlNjRr9CbDNtkSYchvLb3PqH4oPmkXUiWwPGAmlPwX1SpZTk4INBwe+XbOLRHPM6No=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68654d68-8946-4475-6a5c-08d6466ffebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 18:20:15.0922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3055
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

Validate input parameters to set_wiphy_param before scheduling
handle_cfg_param() to validate them.
This way proper errors can be returned to caller.
Also cleaned up unused code in handle_cfg_param.

Changes since v1:
- Correction spelling in subject of patch#2
- Added From: tag to have correct email from value

Changes since v2:
- Reverted unnecessary file permission changes

Changes since v3:
- Fixed 0-day bot warnings for always true conditions for retry_short and
retry_long
- Fixed typo in From: tag

Changes since v4:
- Fixed duplicate From: tag

Adham Abozaeid (3):
  staging: wilc1000: validate cfg parameters before scheduling the work
  staging: wilc1000: Don't keep a copy of wiphy parameters in the driver
  staging: wilc1000: Remove unused mutex cfg_values_lock

 drivers/staging/wilc1000/host_interface.c     | 75 ++++---------------
 drivers/staging/wilc1000/host_interface.h     |  3 -
 .../staging/wilc1000/wilc_wfi_cfgoperations.c | 32 +++++++-
 3 files changed, 44 insertions(+), 66 deletions(-)

--=20
2.17.1

