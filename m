Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0BBECDE46
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16647205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="cduqc8IP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16647205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbeKBBss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:48:48 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19758 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbeKBBss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:48:48 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="22208910"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:03 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TsmLm7pN+6H7d/a5zWM4JWAf+sJHA90UruD9u2f0GE=;
 b=cduqc8IP0DiPHjUR9Q3Rgs+KdLpU/WVOuPHXLutrclFHueh6LdrLGny9tjOHTXZaerySvmw8fyfFGslKHju/bnKLg+gtK73uBFtVa0zd1YXjbsROKijv9JymJk6uoM6xkUhtqQmx1tJvrFb6MX4yv5SR87QtkRQi40epDJumwg4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Thu, 1 Nov 2018 16:45:01 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:01 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 0/8] staging: wilc1000: make use of cfg80211 provided API's
Thread-Topic: [PATCH 0/8] staging: wilc1000: make use of cfg80211 provided
 API's
Thread-Index: AQHUcgI7p3roGSKHIkuLU/49l1L9CA==
Date:   Thu, 1 Nov 2018 16:45:01 +0000
Message-ID: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0138.apcprd06.prod.outlook.com
 (2603:1096:1:1f::16) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.219.12]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:0WvjFv6kyuDRjc3sqWM+Ro0xgsiqIuV/0xQ6bvd7C1IPMZ4rdE8OTaAx4awA7mz3nVZoy6GBngfULM08L6pjF6J4QkBaX4SI8dOxfoDXtGiXZNTVco4XUP72R/32uE64nDdz4po8on++qzLhqazZbrjCDM9r5iZEPSCWkv7u6gUrkfBELbFcOCvSVstgjlT7iVRFlGXqaw1wlxEJ5kPAaEaTnDkZGUjjeYKuZEo3jNMiqjWEx4hBfWSiTJY39HQ3ARHNWqHS5g1SQH+7w4J5JkWyNm1OD9j59H6vxO+WhOGA01i7QUuE0jwkenqFXGgRiVdT0Pl5ASxuyzCepGFwJwXTXaHawTs4lkpTP2Lkrwl9OpmH0oUIlt2b0pDk8dnd3xN2vHcjcVUf/8ZFslCLFV4pGUAuE879qoBYrqat+xTp2ZVjfwX3noxi4fO4dZclmAkeDVyfhj8VPTEDiEoWwA==;5:wl/1b0cWBaMhMRl9AnLmlOIYu0QJO1BWmIXNatziYkwaLJBjXOJtd7/PTh1YWPqz6GuLpFypqplODjJ0R6zLc6HYQHriIexovuEQBe39wQHQIT0BksXjIayO4OdIhkuwUTSDhwpZ8gDDok35aNInNE16cHHUE9w1yCG5TYCE2xE=;7:LIWjacuudcTAo/E/GErRoZ9kDXl0o37M4AFdqzX4AHD0nklsC01pxHUGkmobSI9ZtntSokDKhzIgFAtBAR/+POHydDcQWzpN8M65IeCaazQMbpVELEeXC7l8tAfeLoVddKLoz5zfWl+1o5fbUQJeLw==
x-ms-office365-filtering-correlation-id: 9251537d-9b13-4627-bc64-08d640195df6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB307737AF8D21BCECE35781EEE3CE0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(20161123558120)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3077;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3077;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(376002)(366004)(39860400002)(346002)(396003)(189003)(199004)(26005)(486006)(6486002)(86362001)(2906002)(71190400001)(2351001)(14444005)(53936002)(71200400001)(256004)(6512007)(14454004)(66066001)(106356001)(6116002)(105586002)(3846002)(6436002)(107886003)(2900100001)(68736007)(81166006)(8676002)(5640700003)(6506007)(36756003)(72206003)(7736002)(54906003)(316002)(8936002)(4326008)(5660300001)(52116002)(81156014)(25786009)(102836004)(2616005)(186003)(476003)(6916009)(386003)(305945005)(5250100002)(478600001)(97736004)(99286004)(2501003)(78486014)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ERjjspzXiMLpej8l+GLb9t8BId1rdqWpYx+MVt5Bw7WQMgXKFp68OMkliV9E/vtpbnmwmsx/vawLpZ1sOb2WJ8GBZ/f9pmZanXCIHyk/d/853lqjW1Gz8a7iEXWIkE+bcwcq64NnXsvsATh57RgDrQm2gHMGHrg6805aiNCLS/Cv6GoZ120z9GS3WlD9UuQaK45IM0dZ0vDiRvzskTORyy96i5VuaIXLKUFCEC5btAPm+29m14WrDekBi/FRd4/4SfwqlTNrM5w6+Y0YY1+lDOjtsoI2eQZjAiYRQaCq+VdojY0yxx5fd8LsoLLmAWR5YCxNiAnSnhdLttZjPTUgidy2CilNMrO7aVxvqIdh1HU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9251537d-9b13-4627-bc64-08d640195df6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:01.8627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3077
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This series mainly contains the changes to make use of cfg80211 and
framework provided API's instead of having own implementation.
After refactoring of coreconfigurator functions, most of the redundant code
is removed, hence deleted the extra file.

Ajay Singh (8):
  staging: wilc1000: refactor wilc_parse_network_info() using kernel
    framework api's
  staging: wilc1000: remove unused code in coreconfigurator
  staging: wilc1000: refactor get_bssid() function
  staging: wilc1000: avoid line over 80 chars in
    wilc_parse_network_info()
  staging: wilc1000: refactor wilc_parse_assoc_resp_info()
  staging: wilc1000: remove unnecessary MAX_STRING_LEN macro
  staging: wilc1000: remove coreconfigurator.c file
  staging: wilc1000: remove coreconfigurator.h file

 drivers/staging/wilc1000/Makefile           |   3 +-
 drivers/staging/wilc1000/coreconfigurator.c | 287 ------------------------=
----
 drivers/staging/wilc1000/coreconfigurator.h |  81 --------
 drivers/staging/wilc1000/host_interface.c   | 117 ++++++++++++
 drivers/staging/wilc1000/host_interface.h   |  61 +++++-
 drivers/staging/wilc1000/wilc_wlan_cfg.c    |   1 -
 6 files changed, 177 insertions(+), 373 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/coreconfigurator.c
 delete mode 100644 drivers/staging/wilc1000/coreconfigurator.h

--=20
2.7.4

