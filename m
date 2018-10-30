Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAA5C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFA320823
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="LhugOkW3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEFA320823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbeJ3NOr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 09:14:47 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:45172 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeJ3NOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 09:14:46 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="22350497"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 21:22:58 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 21:22:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFVnjSXoSiri3fEjx1JKKdKkOMVgpMieSlOBdeMYJ1c=;
 b=LhugOkW3P/P5LsbOjkS2+GUMaws5+pviDuSv8xBi8Lfp8tU30sAMNqw811oQy5mGb9aCJRldFCioFUc/B6/Nlr4qC0BbYqvzUibwx7x1jEbZylgRRUyc6STWiSIdtrcf2H894Ra7vKSlDhmv0sz0fP/COvrQIhWPVRLTE/BN0+w=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0256.namprd11.prod.outlook.com (10.160.136.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Tue, 30 Oct 2018 04:22:54 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.034; Tue, 30 Oct
 2018 04:22:54 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>
Subject: [PATCH v2 0/4] staging: wilc1000: validate input to set_wiphy_param
 and return proper errors
Thread-Topic: [PATCH v2 0/4] staging: wilc1000: validate input to
 set_wiphy_param and return proper errors
Thread-Index: AQHUcAg6GrXq+Jtu0U+aZSGqrrixnw==
Date:   Tue, 30 Oct 2018 04:22:54 +0000
Message-ID: <20181030042243.2153-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::38) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0256;6:AudISlwKMhGp+BwOL9Gzn83SLXt6yxEyzN7pLTFuv0p/abNo3T+oBZBdvxR6IQkXOuk0QQMRh8CGIOPtqJ6KLKWDvnUdFM+b/Re0nWUUoJgWfzcGIqlFiHJqXg2MDL2qW2FWkBZ9/aVrAxsyFyhqjXOVNScvjij5NdrEe98ja4E7HTVYA6En8puMhjy4wT8ms6+CZMe7bKQpKtlvvSW5JacYZ2VYBJus3axdaXCNfBrVUS2QqqKzEjn9YzcwcnkCLQTX51kmMsKeX5xVNAiaqp0dxZwIwO4mUwT6GDNyKNHjWowHJAPn7GdXI2cC1UEue9eUlb+GrWp8ouuuGrxPm5HNV0m4ChZ+sjQBxgmBFH+7N4z3oUzxahW/mbGo1SDWq5/gWHCPIn851aarUh01oMwfGEUJpHysjz7mJtbe/UQHFEX7HHFrQi1lua6hcerz2EtLKt7BuxowDWJEhnb5dQ==;5:6iCiX7el6tnv1UIWaKQx68HO/0BUbuxzJzUuQiOGSarPm0Go/mM1eGEHmv4S0n0NnK+HlFWIwSOU2/xekt1ZX0D4mpikUllqHroO1xnnQLgEHJjeHbxodnxMoLL92ihuDE7+hpcRMhHkCM/RdJKY1NcXBP49X+6ynwdutKNry6I=;7:88IlgwhR9NacE8+5pJ7jqgSmXkn9djFoabbev0qHK0e9qTXJiMCcQDQouPx/8xCZ4OcLPc5JXYy9J2gvyBwsFSbMFN1cW0HE0ZD07/0Uw2NRe5g1WgNQFrWn73geVwnBqEHkcCKwOb2XCC7mKmst3FpHvdQm0Wm78OeX9tQSrdbgDfSFSNBHQ4HqIHxWJK/IO9hERwC2MHw5d4QJJGNgTeI7k2O+gub5Sd/n+VoHWbIAGmP2NgHJL6LufKhCEXH/
x-ms-office365-filtering-correlation-id: 9a96cabc-f428-468a-4c77-08d63e1f5c95
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0256;
x-ms-traffictypediagnostic: DM2PR11MB0256:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0256646714D83119CD8F52C48DCC0@DM2PR11MB0256.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0256;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0256;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(5660300001)(36756003)(106356001)(14454004)(6486002)(105586002)(72206003)(71200400001)(2351001)(71190400001)(186003)(66066001)(6916009)(15650500001)(3846002)(81156014)(8676002)(6116002)(1076002)(6512007)(81166006)(99286004)(5640700003)(26005)(97736004)(386003)(476003)(6506007)(2900100001)(5250100002)(8936002)(25786009)(53936002)(486006)(102836004)(4326008)(54906003)(478600001)(86362001)(305945005)(68736007)(6436002)(316002)(52116002)(256004)(14444005)(7736002)(2906002)(2501003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0256;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: iOQwtvzQhbgYwb8anW/+f8cqeQCygAlNmd+7UJoAoYiGyKhnj1K9fXYmHZlNrUXnSgDV5ftElpJDQss4lUuOhLe4A5yWNFAckLhgYOJEjmHDcme06KB4U7+oyYtYjivUu9PaQosBELiV2vcEjAObKG3vYtpDgx/VlTVtgBTnzOqlQGbC9pBFCWBW/ZgdM4d+igfLtZzZMYt3p7WgZwv/AxqsOcFjjvw2l/HAk3P9m9ChO/atEMmzfscRXz1GtSSNjsAx4BDGAThRG1ATjGOIQwuefR+XVK0ttNlt1hVQu4b7AXH1OtjrFlb1SW+5Rnz3+S+GCwYJBsUCqLeRK4JvsCHN12ymXWPfyDQnOKg/l4Q=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a96cabc-f428-468a-4c77-08d63e1f5c95
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 04:22:54.4705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0256
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
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.c
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/host_interface.h
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wfi_cfgoperat=
ions.c
 mode change 100644 =3D> 100755 drivers/staging/wilc1000/wilc_wlan_if.h

--=20
2.17.1

