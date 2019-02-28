Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50584C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D9C020863
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="F0lQbdYd";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="nWVmD+HC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbfB1SKr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:10:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49480 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbfB1SKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 13:10:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1SIAdlP032215;
        Thu, 28 Feb 2019 10:10:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=8mbhTQRNZbSedIQd49Bal6S48Ns+dbBFB5rap8s7XWw=;
 b=F0lQbdYdLuGDxqUOAI+muob1AxWBKTGntPPqGhOoYylXEB6A6L0DhO7mD/Qa9Qj7UVyA
 qKXdehQ3j9dvCQj6gEASF6wDmctB5QXnUKrvlgRb5pHIqqFEoORS+2dEbbceH3wGgOJC
 vrYpDEZUp1ZN4fKER2XVERvfNM9KzaFuUmBlYOGVbP08wLD4EraPnX3Blo4M0z3CP3c3
 80Qw0O1X8bymZLMOd8fAQB0WZGrPRPTUkWjSdf9BhvEhtn4/1RnSBMuFmko6g5UJ9CCu
 91gAdPE+CaOtEWKgznWSZvIxsedx7JdsApyikDEZ4pVllwyhnynumkRewitQi14TJHV0 uw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2qx4kmtkt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Feb 2019 10:10:44 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Feb
 2019 10:10:43 -0800
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.58) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Feb 2019 10:10:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mbhTQRNZbSedIQd49Bal6S48Ns+dbBFB5rap8s7XWw=;
 b=nWVmD+HCR/Y9vcP7YOdEP47rKHkLlZCb98XspBKhaA2niMpledO6/MQkIEe5JhgqmEtS5gy0I3DW7fbMGrkJ9NVjzlV6xgjlwLSLVRsEKXcAMdUlEs3J3pDShZY+Z8PN6CO7klDL7BeFG6DXb6FlLiR63f48QrwUjGR4V1Qk74Y=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1367.namprd18.prod.outlook.com (10.173.65.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Thu, 28 Feb 2019 18:10:42 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%10]) with mapi id 15.20.1643.022; Thu, 28 Feb
 2019 18:10:42 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "James Cao" <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Mayur Arakere <mayur@marvell.com>
Subject: pull-request mwifiex-firmware 2019-02-28
Thread-Topic: pull-request mwifiex-firmware 2019-02-28
Thread-Index: AQHUz5DQzTeNwn3CbkywGgTtusfsZQ==
Date:   Thu, 28 Feb 2019 18:10:42 +0000
Message-ID: <CY4PR18MB123768713184F5801D645001A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efa424b5-c468-4898-86d1-08d69da80d96
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1367;
x-ms-traffictypediagnostic: CY4PR18MB1367:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;CY4PR18MB1367;23:HKfKuj/Ll/Ok+WQgfhlTCXKOUFztWkTVzS5BVj+?=
 =?iso-8859-1?Q?TcxSmVbqfL2sfog5sNZSLvtIHv+49gnyod/mvXmBbyIMq158JmL/ef0smI?=
 =?iso-8859-1?Q?0Mtszpogira5P33VfQlOVhku+KKqISc83dAZ49fwyZqVNYiYb9doO8oLrE?=
 =?iso-8859-1?Q?jXvKdF2RPOTzFLdUIF6bw8zAFGlpTtoJYGvbuO68DMhA+KCFMNZqd4NSnl?=
 =?iso-8859-1?Q?UZ//bEuyn+TX2uqgUhabp4mF5xGEPIyO13i5koZAImb7YZ0SXC2/JQzTGM?=
 =?iso-8859-1?Q?DtzFOo6NGux+CRRlwe4iDuLyyOrmxoSv/fW2C1o4yxIBHZLwNbtTMypOtA?=
 =?iso-8859-1?Q?6+LmQwjg3jcCN+ao8+vTMvNmi0zMOG7qkbs/A27BX4BjYhtKV4tvPVORVX?=
 =?iso-8859-1?Q?JUYBu+2eByTfHvfj1EpdzEj2LCn4MPuzIztuqx4uX/0EQ6X3PsDnGuHcJO?=
 =?iso-8859-1?Q?b1WRnlKiCDaQtN2aRgG68Ji0Ygq3tnQ9R/Kujs3Ss/fKOxJGEoN98B+D5/?=
 =?iso-8859-1?Q?RhXtihLjlHoekrojyxQRTiOMe5oMMVYra8PiGTPzymDaRuUp9M0lFoG+fg?=
 =?iso-8859-1?Q?XBAkF6i3rBS0qUlOy5bpV9ozO3Np+Lp82+Zxy/nTlbKEdwqjcgnKWis+L6?=
 =?iso-8859-1?Q?Roj4otrhcVDp3xYRhxVHm8zm5MUHliWHgQKmJVcsOKCBhjNLfXZbmUWT8y?=
 =?iso-8859-1?Q?hsoFPO+7J/O5aA970ap8ZoC1c1WVQPz/QvygVfPoBF6mAWmNFZf1EbH47u?=
 =?iso-8859-1?Q?/3hewxyYCfwumD/wk7BwMZfN51RPPCQFKUr4p0jOrQGpinITEEHnwkBt3C?=
 =?iso-8859-1?Q?I+PURP5VaZuExM6Ggjgu0LdkI4udV+JrXXqbKezGnzcXaXQVleZvHsTDSj?=
 =?iso-8859-1?Q?S2yJehvhw/NNMmIwO7hDiDZ2bBrdYU3/2HypeoDPF8u28oyphABAPiWA3k?=
 =?iso-8859-1?Q?JDw7YTk5RahLDZRsrMEzgLpmPt/r4hjlmSVqOLeJqTDG+lN8RLcevpzu78?=
 =?iso-8859-1?Q?ARZZpwUkdZTDu9F91THkndWknQBdTgWG7VL3PSokkHTepNX0bwIxKhNffi?=
 =?iso-8859-1?Q?XmKRpgtzgDvWBUQWdDmhjkkQ1mEJd6FPDP4T8jNfz0dgfdx6WHZuCrsafN?=
 =?iso-8859-1?Q?n+5Fxhq691nLXV7BKrD35XsUR0shfxWLLS5TFVrrpUsFwhUsCo1gZjmmYS?=
 =?iso-8859-1?Q?hfhpsJANyL4gx7UNh5DwXxp8R0Ci1D6VJfGvppLoBYVf/YbZeLZlMm/lz3?=
 =?iso-8859-1?Q?mXfU1jbznhxSOc3AKShswzyg8Fj9mBOdT1tGlGXfUBYx405GAjCAq2I4k/?=
 =?iso-8859-1?Q?+SOa/jgYn01Id2FIf4mZz1o?=
x-microsoft-antispam-prvs: <CY4PR18MB1367E7544A0033B15663CBF7A0750@CY4PR18MB1367.namprd18.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(346002)(39860400002)(189003)(199004)(2501003)(2906002)(476003)(186003)(486006)(68736007)(52536013)(8936002)(5660300002)(6116002)(3846002)(6916009)(99286004)(53936002)(9686003)(86362001)(256004)(14444005)(5640700003)(55016002)(6436002)(71200400001)(71190400001)(78486014)(26005)(7736002)(305945005)(66066001)(105586002)(33656002)(81166006)(81156014)(478600001)(8676002)(107886003)(55236004)(54906003)(102836004)(316002)(97736004)(2351001)(6506007)(4326008)(106356001)(14454004)(7696005)(25786009)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1367;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OX6QhNQgkAHW4h5kPhWJhYaTqaJIWiFsyNyAEIjBd1/BxwS8mN2fQeKBC5IjBrj8Y/nxSP1r1yjWt0Sb+TOJnkxpcpjx1MXzNidL3KbK0JwoDIygAJ+vbpmU6I0CgE/z1asszSkkUmNT1UF2AQeou6yo6VxUjEFxf6VwwE4iWBvne6SdTjhVYCplkI29rdnYlq482yrLLQWXFlx7BjTbbW8GREgq/miPJoL/kvnNLIXxRZK7emKMUtdKP8Eqpd1JyWyjGWmIBWIxGW0saEX5NDoykuq7GkGIX2gi8YyA46djdxFjuIQfsejiZeuQlcqaLIdliQSSerPou32IMMStTVulYzYgf027+I+8g8YGDOlEtCfEpCPhGeSikMYkUxh2Vr7GAaUHZreAFub5dkEW+UKZIHuO+div4sF8kV24VyU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efa424b5-c468-4898-86d1-08d69da80d96
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 18:10:42.6568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1367
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-28_10:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=757 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902280123
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following changes since commit bd72387b8e49b1b7268ee60c97a131419284fb39=
:

  linux-firmware: update Marvell PCIe-USB8997 firmware image (2019-02-12 11=
:42:24 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git

for you to fetch changes up to 78d2b16af093783d40f0b8990d5d9ede8c3281d3:

  linux-firmware: update Marvell 8787/8801/8887 firmware images (2019-02-28=
 23:35:32 +0530)

----------------------------------------------------------------
Ganapathi Bhat (2):
      linux-firmware: update Marvell 8897/8997 firmware images
      linux-firmware: update Marvell 8787/8801/8887 firmware images

 WHENCE                       |  12 ++++++------
 mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
 mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
 mrvl/sd8787_uapsta.bin       | Bin 463240 -> 466592 bytes
 mrvl/sd8801_uapsta.bin       | Bin 258680 -> 255988 bytes
 mrvl/sd8887_uapsta.bin       | Bin 695532 -> 616840 bytes
 mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
 7 files changed, 6 insertions(+), 6 deletions(-)=
