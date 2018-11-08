Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DD1ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ABC72081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="AmiaiTmX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ABC72081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbeKIH1w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:27:52 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:26825 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeKIH1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 02:27:51 -0500
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="20876579"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 Nov 2018 14:50:26 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 8 Nov 2018 14:50:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEauzqZZ9D+3NlusOVACq17G5BwgACz86vIQxKbS98E=;
 b=AmiaiTmX8Znz9lQMSSNW31tofv/2LfKCtMWVAxLA25AyMX0XE34S/ZydE7ZVE5yadnuEQzPLOqqb0jjudPzB3IaS9mdVAzH3vbvLZfc9r1kfwA+uMy5oRNF9PpLle/VNIc1txTIQU0GBH4mXIrjYW0K7qrQbelBqVjL7EkOdP50=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3488.namprd11.prod.outlook.com (52.135.112.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.30; Thu, 8 Nov 2018 21:50:24 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 21:50:24 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v4 0/3] staging: wilc1000: validate input to set_wiphy_param
 and return proper
Thread-Topic: [PATCH v4 0/3] staging: wilc1000: validate input to
 set_wiphy_param and return proper
Thread-Index: AQHUd60NA+QM2OL1dE2nv6U2m5bCtA==
Date:   Thu, 8 Nov 2018 21:50:24 +0000
Message-ID: <20181108214915.3733-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::26) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3488;6:rq4b/F+GpqDHXeOTMOzWeOY/HP6B6fej6qn/CWcqUKj11AqUOd9XoJJEdGoe6s5buLZoHrgkqhiSG4Vb7nGoqSVUEJRFeDxcUTMrk49eYnn8RafM+vyH5T0asi69mCnsaiWJT7yGK8/WaMhSylu3JPozEB6Qd/3Evy2bBoItmfmKPD1jqf3oY2VPELMVR5L9DXl2JNajOsP4mDnb9SoG9TSm4dwml6FHAhcPzKRHXuNR7hSX1JTIevDXndFeuAsYN9/SJXVI86lNEQc9K2q/nfcBAgyWsJlVZaKOFqq7qQApiBlWgu+kRxLTImKU2aKxjDC3Yl7npkyJahFduwEuvNZgndtnAwHt2uTVeSRsQxjNGJUF4zyveJjFO9DRWG1K11/ZrX5wz9onZR6WCSJgF1PjHQbWZAFRU6F2UIIPzzWaPXT7TgkS+akRTZEAwFFLoWQsa17RaBKzh16NANml+w==;5:pcsh4l01Iwol4jOZZZ1sl0cVAiBnbEsEUUj9Ydh0GiSVtpb+f3+x809Lssy+m/u15jhpQ3wuNHI5Oe2jgSiwh6k5BDut3QuSDNECbiC8tJNey3ZU448VZ7Y5OYvdJDzXZXl/xPB4M+UfMW0SEAo+PhZ7iJgTcpMYmOVkChWOb7w=;7:+TWOwQWZyxRW8YPgTgeZ4htTS99IvMHnrMMSTrWZHf/doBgC+V+rDBJlb7mQm/ldg0shfN38GuzjPc8ai1hlMK00HYWGNS4ZFWN74oStTgU+PWrIq4d6K8rvihig8iTVQZChipQVjzsDITJJRVa/ow==
x-ms-office365-filtering-correlation-id: 5f1e2abe-8d06-4828-fef8-08d645c42fed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3488;
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-microsoft-antispam-prvs: <SN6PR11MB3488B06D67E56990AD31A80A8DC50@SN6PR11MB3488.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3488;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3488;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(5640700003)(52116002)(386003)(6506007)(1076002)(6436002)(14454004)(6486002)(25786009)(7736002)(6916009)(99286004)(305945005)(6512007)(81156014)(81166006)(66066001)(8676002)(186003)(8936002)(478600001)(68736007)(97736004)(26005)(2501003)(5660300001)(53936002)(3846002)(6116002)(102836004)(15650500001)(4326008)(106356001)(71200400001)(71190400001)(476003)(105586002)(2351001)(2616005)(54906003)(316002)(14444005)(486006)(86362001)(256004)(2906002)(36756003)(72206003)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3488;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UeAmSx4bqIQpeUh8G+sHU6pPLO4jLFVmDfGpomlNHZcW0iD5PjHZ150g3a3ix4+BHppMZnVjhbHAKYELPUeatHtelpW5XcY4lPvleXHKbNTnUWylB8qodPiM2RfCAFx2XO3+0jPcUyBvZG6IdLLuF2UDK4MOnkaSOP45ntLUWVTRwif7LTBmAhTyLnQetLtYO8lTeUtjrrGD9OLySibtBaXUQAU/HtosEgGZkO2YrK5IlXphlWLK/j6F/89Qhm7o4GqIdQmv+CqeNwTJNTx/OMhAzOBK+tTNYYQlu/K2XGa2HETv6OFKHs2OtHQp6BcCr8uQ+SS9XgqDa/NABs2JHeBra0T/ERNl5NQ1RaNc+oI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1e2abe-8d06-4828-fef8-08d645c42fed
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 21:50:24.4537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
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

