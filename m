Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0FCC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DE4D20883
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="oenJmHPC";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="AOWn7/zI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfAIGB0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 01:01:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39682 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbfAIGBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 01:01:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x095tJfd029641;
        Tue, 8 Jan 2019 22:01:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=hnjY9TI7DhHn6Ml8aNQh2j3FZ5ADwdLrIhRkycJFaNY=;
 b=oenJmHPCDno6h6c9VjrAqpxRtAyMXsTefB8I3Mx/sf3NrFbs8o/s3mP2jEN2G4T+VX3E
 LlZrPavNC5/2QYCZE2c30hdXWM/u945zprTFqyqZ+uCz0Df8XhbH+SJh1VwcPYUtbldK
 x1ZFDHl98lq8/DSSbRmQw4bO/kkMvfkXwA7l1GnJWfL8G2OzBQ78i2rRLue724Bwh8Bk
 TCIbd1c72j6qrgln7gr/PU52y1fCERqnRf5P7fWpeFB0lKSIIJRTctuh8/efF9GNWdZ2
 81pz/WIbBcTjnMDVroiSwE0nzL9K0vfp/YJlon7AEtppi8KYF2mOM6tTMQ4RydbaNXFk RQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2pw18faaq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Jan 2019 22:01:23 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 8 Jan
 2019 22:01:21 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 8 Jan 2019 22:01:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnjY9TI7DhHn6Ml8aNQh2j3FZ5ADwdLrIhRkycJFaNY=;
 b=AOWn7/zIAmu6SQdHVVYLQDWtM/gszAhrmU8NcfVJEtmoMGOtivy8UpIOn1L/0grSGb4wDaG1l6Kjd+8uPXMyNAcoOR7RlmBjrLQVF0YXVbmtLEZ9HpgYITkngCbh9dPQ878HWpbChG+r9hao4QWv5xSPHk7Br0wAjTZbFVJu4mU=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1079.namprd18.prod.outlook.com (10.173.183.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Wed, 9 Jan 2019 06:01:19 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 06:01:19 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        "Prashanth Ranganathan" <rprashk@marvell.com>
Subject: pull-request mwifiex-firmware 2019-01-09
Thread-Topic: pull-request mwifiex-firmware 2019-01-09
Thread-Index: AQHUp+CHiD53/295pky40UO21SCJRQ==
Date:   Wed, 9 Jan 2019 06:01:18 +0000
Message-ID: <CY4PR18MB1237DC08CFA9B2B0A0368AEAA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1079;20:wNWxUFxKt7aUsUXvJWGIYz0wxKyhOyLKMFTWZYmG0Q52caA3YtZF6zq3qho4sDV2ZqqkiIfID6HhgqU7Gcj5H33YEI7MfTtkSJzl/2Z8krAnmZeHNxwo+egXskkkAlB+S5Hoor8gQ6Z4sgwkC/BLQVTHs8UL49Xb7y2ww45d0BE=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(396003)(39850400004)(346002)(136003)(376002)(366004)(199004)(189003)(14444005)(256004)(68736007)(106356001)(66066001)(478600001)(86362001)(33656002)(486006)(25786009)(3846002)(4326008)(14454004)(6116002)(105586002)(78486014)(71190400001)(71200400001)(107886003)(53936002)(7696005)(6916009)(5660300001)(305945005)(7736002)(99286004)(102836004)(81166006)(8936002)(81156014)(6506007)(8676002)(55236004)(316002)(26005)(2501003)(54906003)(5640700003)(2351001)(186003)(6436002)(476003)(74316002)(2906002)(55016002)(9686003)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1079;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: c8efb040-8792-4074-c681-08d675f7dfb4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1079;
x-ms-traffictypediagnostic: CY4PR18MB1079:
x-microsoft-antispam-prvs: <CY4PR18MB1079C0361853E5DBBA2AB6AEA08B0@CY4PR18MB1079.namprd18.prod.outlook.com>
x-forefront-prvs: 0912297777
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AC/YJ+js08o6e+A4+KkQd8urEgnSb0o4Tjr/MUrEa1jDVFEMhDqHFHoXKcqYaaCU0xEJGaMU7XVtKQKIcQ1m+3ma172e9LMlKw8srnUaVkUrLd/GnGSlb+7xwQmXkzAEWBgAwH6Y5ndLykshD2h8K1kvqri9bBvbI3DDW4Qs2ju70iAK9RbQ6TCEJzzYYxtsvI41/Rz7GDSYA4KPAK6cSUW7vJXCGyRP6ZbXpY0oZqzFLYXshmumGLuTpjUWM5Yc28PqckYzw8AL1lOZtZn3YwYiCkUCz1MhEiNuoKGnYIDpaULW1hoUIgwcnnCNqN5U
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c8efb040-8792-4074-c681-08d675f7dfb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 06:01:18.9461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1079
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-09_03:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=740 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901090050
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following changes since commit 52b23a9326fd8bb468b1b9e4c1816bf08bc2bc3c=
:

=A0 linux-firmware: add Marvell SD8997 firmware image (2018-09-26 21:25:40 =
+0530)

are available in the git repository at:

=A0 git://git.marvell.com/mwifiex-firmware.git

for you to fetch changes up to 63ca64a73c05fa5bcceb687422cbc28185bb6355:

=A0 linux-firmware: update Marvell USB8801 B0 firmware image (2019-01-09 11=
:24:42 +0530)

----------------------------------------------------------------
Ganapathi Bhat (1):
=A0=A0=A0=A0=A0 linux-firmware: update Marvell USB8801 B0 firmware image

=A0WHENCE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
=A0mrvl/usb8801_uapsta.bin | Bin 250940 -> 252260 bytes
=A02 files changed, 1 insertion(+), 1 deletion(-)=
