Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CBEC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D4DD218A1
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cIOYp78d";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="TKSQp6oG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCORov (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 13:44:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbfCORov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 13:44:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2FHQ2Ng022908;
        Fri, 15 Mar 2019 10:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=z7u38mkqXFGnWvEM3tXBA+7l3pisbXfepmjctj4pkSw=;
 b=cIOYp78dRSBFt2v2U9dSTp0BPkyBQz6DCG31Z75KaSLwjFLEVGEER7jxGhH6mALjQJp4
 Oa99jEbM+cMSwKgNKXlSo6g1VyQFP59C/noSSLwV31YMhhWxDzhH4pY7x1FKJvfjnyKs
 Y/8I2KKhnpYVhB3FGy6t7um/kivcnsQX0PGmLia/4t/mi3fBezXDf4HztlZXVWV5LSrL
 ReYdQBeNGzaHehxdOEGa+8sfiT9+sdmk0MhssiCZ9XZip+dU+/mFwkr1an+y+6Cx4BUl
 LsT8JidmzwHGnovfwcv8QNh9YRpCEbyWriCefEVF7d+D4+Y/KZ0rE5YbqAug1ObPxDt0 ew== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2r857wt06y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Mar 2019 10:44:48 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 15 Mar
 2019 10:44:47 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 15 Mar 2019 10:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7u38mkqXFGnWvEM3tXBA+7l3pisbXfepmjctj4pkSw=;
 b=TKSQp6oGxYnlBuvuV8ogwdepqDRq5Q8MRW+cFEHgpxeR3kBxaswZRwpq9038lHB9s1IYIESDiDkQb5aKkJwmgAp7gHUoY4QCN94wxb2ri6B5Y39f/doQ7YMDBW+C65NasRI8t3+7nzMBNovY/JM6VkawCtxj4PsyxO4YsbKR6Cc=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1655.namprd18.prod.outlook.com (10.173.60.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.13; Fri, 15 Mar 2019 17:44:42 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%11]) with mapi id 15.20.1709.011; Fri, 15 Mar
 2019 17:44:42 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Rakesh Parmar" <rakeshp@marvell.com>,
        Cathy Luo <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Mayur Arakere <mayur@marvell.com>
Subject: pull-request mwifiex-firmware 2019-03-15
Thread-Topic: pull-request mwifiex-firmware 2019-03-15
Thread-Index: AQHU21ams1xW0y8Y60qbHGtAOXgJCA==
Date:   Fri, 15 Mar 2019 17:44:42 +0000
Message-ID: <CY4PR18MB1237CD0037B7ED3C3C11A5B5A0440@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10c868d2-988f-4bce-f4c3-08d6a96de796
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1655;
x-ms-traffictypediagnostic: CY4PR18MB1655:
x-microsoft-antispam-prvs: <CY4PR18MB1655E6697563B34F57183A0BA0440@CY4PR18MB1655.namprd18.prod.outlook.com>
x-forefront-prvs: 09778E995A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(346002)(39860400002)(136003)(189003)(199004)(97736004)(2906002)(8936002)(68736007)(6436002)(102836004)(2501003)(3846002)(5660300002)(2351001)(66066001)(6116002)(486006)(6916009)(74316002)(4744005)(71190400001)(55236004)(78486014)(186003)(71200400001)(6506007)(26005)(476003)(7696005)(55016002)(25786009)(99286004)(305945005)(9686003)(53936002)(86362001)(105586002)(14444005)(5640700003)(106356001)(256004)(7736002)(52536014)(316002)(107886003)(14454004)(4326008)(54906003)(8676002)(81166006)(81156014)(33656002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1655;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /CjsOqT9ll9iDtc67hw45mKN6EWpx4PxC7MPTeAjOpFrjEoccbZDQUE4eZXvtS+KSfY+ZdToWSO1m6ytqIUJtSgWn9CnEo0HJd5vzuAjMv0mSryKI1FeesbSQo4BSYlqvxhfWpe3ROURvPjB6LKZ3sAF4Nc91v9KTVLXt3oU3GdAQ25YKw+uJ9jRuHN0ywkFrWHkrnrkx+E/pm1eRyavg6WScYV9j4M7YtMFEOVz0jsFlCYYS8B/2qTGRbEWpT62cvJ3zPEbGBUcEFvoojFti+uaeOoE52yxj6tenBu6lqBWGW+HZ+Qyiy3aK+fbhS5D55ymzCinVa+kZJIvJlz/fd6Hxakd9F6lSwo24KbSfkI8duLKl2IblMiUC3PXSKCD/FrogF5z3yhyeDqsRRBIP3DVnOsyfnvWyGPr4wKY+EQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c868d2-988f-4bce-f4c3-08d6a96de796
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2019 17:44:42.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1655
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-15_12:,,
 signatures=0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following changes since commit 78d2b16af093783d40f0b8990d5d9ede8c3281d3=
:

  linux-firmware: update Marvell 8787/8801/8887 firmware images (2019-02-28=
 23:35:32 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git

for you to fetch changes up to d71dee4e5a86075c0ba6f81f00660ff999f171bc:

  linux-firmware: update Marvell 8797/8997 firmware images (2019-03-15 21:0=
2:17 +0530)

----------------------------------------------------------------
Ganapathi Bhat (1):
      linux-firmware: update Marvell 8797/8997 firmware images

 WHENCE                         |   6 +++---
 mrvl/pcieuart8997_combo_v4.bin | Bin 583628 -> 632240 bytes
 mrvl/sd8797_uapsta.bin         | Bin 458108 -> 533976 bytes
 mrvl/usb8797_uapsta.bin        | Bin 553456 -> 553940 bytes
 4 files changed, 3 insertions(+), 3 deletions(-)=
