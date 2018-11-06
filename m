Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEB4C0044C
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46642083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qUU/HUFQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D46642083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbeKFJXg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 04:23:36 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41791 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbeKFJXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 04:23:35 -0500
X-IronPort-AV: E=Sophos;i="5.54,469,1534834800"; 
   d="scan'208";a="22705221"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 17:01:18 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 17:01:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WBSDvgE2oa7XuYWsrmt3J1XgFcSaVj9jXrhpNlb8Oc=;
 b=qUU/HUFQ530A0Kf5yL1aa5JCPaTNkZGTTJRGyRiIIlGO8m1a7celYYb09lehMnmpqzAQ51ACFFiJ9p2nNfG/GpY9KHTgOTkkbES5cEGsG9XhRIL1a/shCWv7qaWIT6PTwWsxw7bqpy4/uaKaAPFCqOt0XLKkueQUN4lWz/GV+aY=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB2639.namprd11.prod.outlook.com (52.135.91.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 00:01:16 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb%2]) with mapi id 15.20.1250.028; Tue, 6 Nov 2018
 00:01:16 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v3 0/4] staging: wilc1000: validate input to set_wiphy_param
 and return proper errors
Thread-Topic: [PATCH v3 0/4] staging: wilc1000: validate input to
 set_wiphy_param and return proper errors
Thread-Index: AQHUdWPWfjQTvqdDxkKvVEe6kj2wzg==
Date:   Tue, 6 Nov 2018 00:01:16 +0000
Message-ID: <20181106000109.6178-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::25) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2639;6:96bqTCaWMHPmu5Enu1lcLDxraxcDAQ2wOzDAzFqBLQYb/W0xtPXfTrQJCQ0FPZ+n32dVlx0s9HwyYTUEbE9J/CRhUvacNrN2N5I0yZqgWIS+PRRe/BRLDzZR9zPYA2z6UIHkrYHrhyghN1B72lupfid88V6FGfVMcUZ86mjdm+jKlHwhNUhaEQmNW1JxMWJapa0KU+9xVaUf52S2GS3fHCdNz2Bl1m0AzQdnqG4O9HigjGOYLQc6ck1+XcMvPpz+vSPZH/AjeVE/7EvG6gqwkLA7XI8b5Wamc8s4w6LCfwy4F757/guQ3lW8nbTnZn6bOi1jxvEMPalxnPvuD9vVG3NWc+oO40+JWJ/o9XQflc7NNabC1MUpcYmSBwXLmL3jph70LDcanoYyCtKQDOvspnUaFf150V0dTGFhTOxztg4EVNIgIW7OnIqqy0UuaZDL7Y5iONTEAlidr3I7QxA7Yg==;5:+EMZGOJlQFQMBoSILPAaihmVRTdqTxIDUuzUvYLCHM8SvD0WQNZJrUqOObMTldukNezExpT+zoDkcTnfMH/+w+z7lLWMhVnOOBszmfpWyq5f/urVn44khJ4hykqBHj0d1WslyxtiZDJpfNxW0o3oa0YCSsOb73TmmqxS3DFbioA=;7:Br0o3dS9o5CSjyg4qO2bqXbgqQeEQoOr5A28myR1FB7F7XZKegG11RFepo2t5d5apuadO6l0z4PjCanUSS4CNdABntU77rmqxNUzQQq0mX4x1Bs7eL89MryVl+RdfS2ca1njJo8ylhKjGaa4BINFyA==
x-ms-office365-filtering-correlation-id: f1bcf862-1583-4248-8d9d-08d6437af8cf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2639;
x-ms-traffictypediagnostic: SN6PR11MB2639:
x-microsoft-antispam-prvs: <SN6PR11MB2639B10A9F65B5CCD7C66DCC8DCB0@SN6PR11MB2639.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2639;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2639;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(99286004)(1076002)(3846002)(6116002)(8676002)(6486002)(6436002)(36756003)(86362001)(5640700003)(316002)(54906003)(6506007)(5660300001)(72206003)(71190400001)(6916009)(52116002)(386003)(71200400001)(15650500001)(53936002)(6512007)(81156014)(81166006)(8936002)(14454004)(2906002)(256004)(68736007)(66066001)(14444005)(486006)(4326008)(478600001)(102836004)(2501003)(186003)(26005)(305945005)(2351001)(7736002)(2616005)(106356001)(105586002)(2900100001)(25786009)(97736004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2639;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: I91Jwr+YGPwePr5GJp+JLGtB5CcFOuMA9xocNoDBBNP3uGW6nj269uGeBbjjP6OTFeGsd2FyZt65a9/9jV/B9ajHyZTBVljZ5bu5w4mEFeFlHrYh0oaCVc/xwuCt9VRQm+W/fAON0uq/ILnCDFM7gzJZUBs0K2/gMMeHvAc/kxqIr4WS8z591uXYQ7K3ORrO5TalCiQ7N3zbIu79Oj/nMfCbsPVmjAgfbcq5cppxN5wJIdzNtUcXLnXOwbVJpcuUIM350j5Hmf9QzadlIzQV+pNm/OYYOwsPW0V7p20FEjfj4SVDKJvZOgzv5543L8/xYNhkcF6twFMYR+pQaNhOAqbCfUkpL9leW2xFo3olLYg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bcf862-1583-4248-8d9d-08d6437af8cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 00:01:16.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2639
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

Validate input parameters to set_wiphy_param before scheduling
handle_cfg_param() to validate them.
This way proper errors can be returned to caller.
Also cleaned up unused code in handle_cfg_param.

Changes since v1:
- Correction spelling in subject of patch#2
- Added From: tag to have correct email from value

Changes since v2:
- Reverted unnecessary file permission changes

Adham Abozaeid (4):
  staging: wilc1000: remove unused flags in handle_cfg_param()
  staging: wilc1000: validate cfg parameters before scheduling the work
  staging: wilc1000: Don't keep a copy of wiphy parameters in the driver
  staging: wilc1000: Remove unused mutex cfg_values_lock

 drivers/staging/wilc1000/host_interface.c     | 291 +-----------------
 drivers/staging/wilc1000/host_interface.h     |  32 --
 .../staging/wilc1000/wilc_wfi_cfgoperations.c |  50 ++-
 drivers/staging/wilc1000/wilc_wlan_if.h       |   9 -
 4 files changed, 58 insertions(+), 324 deletions(-)

--=20
2.17.1

