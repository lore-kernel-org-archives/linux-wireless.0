Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CC7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF80204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EqENqtlC";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="LoULs7Ix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbfB1SMS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:12:18 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49690 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbfB1SMR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 13:12:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1SIASxF032155;
        Thu, 28 Feb 2019 10:12:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=gXrIbrz3Y6JUSTz51OFOMzVUKO4ph/5G7ZUKaAqDlT4=;
 b=EqENqtlCHihbmLIFrkJ3z4Wcdq30oY3SeSUICe93OAGFJtkN3MNh/AtUhTCzBNd534yX
 0MTLK9ctyHLTN4QRchI8XpBjYSxx3ZyDhnyMNXx5aJI3TzmW8zAx65bFkMyrv9xvXdro
 jpqDJzpFCc9Tj9Md3sTzLs4/nNrpwDO1MOrJWFAHAJQURCah03vopfjbRSY/UWsGnZPO
 +BjuuhLXMJkpoh3gEwSop2KFppiUVF/yqpvhTqW/UmVnA5B80XZDvfHvLKvGfsvmpRUB
 TFY5XbRn+hmUoCi0OD9EFZBUsajjb5mznFcMN+EC05oI7twJkwGzsbIVlJPXGTM0g2lj zg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2qx4kmtm06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Feb 2019 10:12:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Feb
 2019 10:12:14 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.52) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Feb 2019 10:12:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXrIbrz3Y6JUSTz51OFOMzVUKO4ph/5G7ZUKaAqDlT4=;
 b=LoULs7IxHA8n+JHFFhBYYuZ7/82d5Q412aVWbOzs7hPs9804fXqiN7+4AKghoFFMrli/5UHbQtvVSITPLNF2x0rGe8aGr58Ebg4hhjUffbCEvgW4bVh9i/gkarkYy0TWNtWDvnJu2YRmgQ+nlLvHsmnIYZQP2Iy8/Aikt0wmTJg=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1367.namprd18.prod.outlook.com (10.173.65.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Thu, 28 Feb 2019 18:12:13 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%10]) with mapi id 15.20.1643.022; Thu, 28 Feb
 2019 18:12:13 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Subject: RE: pull-request mwifiex-firmware 2019-02-28
Thread-Topic: pull-request mwifiex-firmware 2019-02-28
Thread-Index: AQHUz3389IKQ5g790k2DU7NOO09YuqX1gv2Q
Date:   Thu, 28 Feb 2019 18:12:13 +0000
Message-ID: <CY4PR18MB1237103789F83029584A937FA0750@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB1237089CC3822DBF13CDB86BA0750@CY4PR18MB1237.namprd18.prod.outlook.com>
In-Reply-To: <CY4PR18MB1237089CC3822DBF13CDB86BA0750@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f0e66c4-a14b-44e7-39b7-08d69da843d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1367;
x-ms-traffictypediagnostic: CY4PR18MB1367:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;CY4PR18MB1367;23:aqNS5X4TWXVc0wXioOQF5yMrK72OjctcWiQfQ4Ajd?=
 =?us-ascii?Q?1Lns0SE/XXXXdD0BvOT76GJlj1S+KiHVJSmv5+wgQpuECgk2HvzsuQff0ZBL?=
 =?us-ascii?Q?3uq58PqYhqzG3ApeT6i5wyqNzif6oOfbGp73vg8TNQRl4JuzxiF2HpL5MvuN?=
 =?us-ascii?Q?LGIrlbZL1wvwfjuCs35Nymku7sBix9n4CYe467Vi7mbFz7/UjGjkI1TDwuL6?=
 =?us-ascii?Q?xlqOapHG+AaeChrtOcDwYB6T9g3O+FBlixa9s9dLEFPSO78q8L2cHBPrgs/y?=
 =?us-ascii?Q?SBQfHpqvP264lKV1Q94zht7bBjTX/UxM7QIH5Cs2slQJURbxw/d/br301GUF?=
 =?us-ascii?Q?AqiGnXEwgC+qaKO59kevJeXp6sJ1eMRRz3SAoWhZNjzvlRNC90RArwt5gVSq?=
 =?us-ascii?Q?jVKQmRssIJRi+A88miy71tP8U38gMVX4kyRQM7ums8DxlGtp1HE7vt0Bvc5d?=
 =?us-ascii?Q?JtNnguodNDoquwOHfyvA2PdPJT2+r1lQVDFXdPZwA9rjC/UpssZqDrVwJiK7?=
 =?us-ascii?Q?xNMsuwCjhJ6bz5yzcFdrV1QkrHzv/AdRSH5h/ZyFg61cWdr9oZxI7glUruKT?=
 =?us-ascii?Q?apdxJPL9oQtunTpW+Eqc27TOh9MDA8Ztn7VEDW/KtRphd8UYmQ4bDOyF/LK2?=
 =?us-ascii?Q?xueGRXuZ9QojoT+W/hwbZK+FRQx9X7kzvlZYwi4GqpyaRQY93CqOuTc/lGqn?=
 =?us-ascii?Q?kTt2Str3tcYNuq6KN6pUD8moxNeYn195+ihhiYuEr8znH5PwZKC5JXfRR0SL?=
 =?us-ascii?Q?l+rzlntNGs6Z1uWl7yUUZX4W7fK8l99qtWzIGeA5AzhxLVGK+q6tADeLL9GN?=
 =?us-ascii?Q?mwNgYEupeIkhZYIOW68JT95fKGBe9hMS81Oy9kZ0VbA7STkKWt0ptAaO8FXV?=
 =?us-ascii?Q?BKs4Eiko9aqXalErZVpCaveAEQAqhKAahJT0iopExGLzTs/T8nHU6XnZLbIk?=
 =?us-ascii?Q?aVvYAKw8717ms/jJ2hOHihgoF4uA69tVjRfTPF4ZSztV5ApYwP7El5FMhv4m?=
 =?us-ascii?Q?frzCGRzDRV4Q9R+vSFGS+qWq4E2wjnEkgdRNSNzpOkR920QotWcdkjPxG4RQ?=
 =?us-ascii?Q?v0jcOopcaUlct907ysCknqJJt3eQ/vIUcl173AXl4rH4Gu7aPIdISgy5YUOG?=
 =?us-ascii?Q?rnXb+dvswrl6repl5ScIrd6PZx8owoweF3SEL4/mmA3MB1JnsOaqjJhL08u8?=
 =?us-ascii?Q?gIDqq/+9XnJcNJAJ7G4sQcPzDsrqr5yW2S3WZM0zyQFqNJ7IYmZZ5P+FQh74?=
 =?us-ascii?Q?pcCz209WJ8TjS45ygIhoRPQl1/z311Sl2KiaVRd0lmIzmzaA42gWPX9T+Okv?=
 =?us-ascii?Q?LCaDo5G8KRbT1d484fBOV3qQktPgAQ+A74Teyx45nXRZs4dc2aVUkK9va4aH?=
 =?us-ascii?Q?fSrH3djxmzPXZoO2M5hjfXlP8wOL6+DAxwFBgzjWXI289VvOpe05A70avY78?=
 =?us-ascii?Q?CmjSMnDt+66pTWJSBjGDuMiCWv+xEJ4rrdB7YAENv9+tlAEE2cr?=
x-microsoft-antispam-prvs: <CY4PR18MB136728289DB70A5BCE0261C3A0750@CY4PR18MB1367.namprd18.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(346002)(39860400002)(189003)(199004)(13464003)(2501003)(2906002)(476003)(186003)(446003)(11346002)(486006)(68736007)(52536013)(8936002)(5660300002)(6116002)(3846002)(93156006)(6916009)(99286004)(53936002)(9686003)(229853002)(86362001)(256004)(14444005)(5640700003)(55016002)(6436002)(71200400001)(569044001)(71190400001)(78486014)(26005)(7736002)(305945005)(66066001)(105586002)(33656002)(81166006)(81156014)(2940100002)(478600001)(8676002)(107886003)(55236004)(54906003)(102836004)(6246003)(76176011)(316002)(97736004)(53546011)(2351001)(6506007)(4326008)(106356001)(14454004)(7696005)(25786009)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1367;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ctdnGnFHxnnrlhCNJDE4US/Q8/wulf9lmy4IJ4eN+8wEgAfHgyzEsd1BRQ+A0Iq3qZNTe2jPSeNbSSHwvXlUsXMAAfDYnJuFQxs1KrRbFbrhT9kkzMRD7f2p4Bhcvl+vNEZ2Cj09rX/icwrJXKSCWfRctdLOI2X6ft+WGG0j2yH3VGe3NfEdLUVWkT/S82DjO6Txw7q0k8Faqniq17StH1GqWK0XTMimQfP7pScMIhNON2pCsItjCqSK0MilqbJC8TA887yIb/y+FTMy1tMn7/sZPLxMTO48hQxbJcTYbAtZFa7zgst2J4mYjKaFxmhan1I0bMScUxkM6OotRES0HelYxi6geNj7VzRJbdOYAzszifcgZKHtnKhPO8cxX2MVbSYTyPgoJ3IgRXIoNJvV7yl2WT6MlPGHkJninWsSOHU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0e66c4-a14b-44e7-39b7-08d69da843d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 18:12:13.6349
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
 mlxlogscore=873 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902280123
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kindly ignore this; I have sent a new request.

Regards,
Ganapathi

> -----Original Message-----
> From: Ganapathi Bhat
> Sent: Thursday, February 28, 2019 9:25 PM
> To: linux-firmware@kernel.org
> Cc: linux-wireless@vger.kernel.org; Cathy Luo <cluo@marvell.com>; James
> Cao <jcao@marvell.com>; Rakesh Parmar <rakeshp@marvell.com>; Zhiyuan
> Yang <yangzy@marvell.com>
> Subject: pull-request mwifiex-firmware 2019-02-28
>=20
> The following changes since commit
> bd72387b8e49b1b7268ee60c97a131419284fb39:
>=20
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2019-02-12
> 11:42:24 +0530)
>=20
> are available in the git repository at:
>=20
>   git://git.marvell.com/mwifiex-firmware.git
>=20
> for you to fetch changes up to
> 1a5773c0c89ee44cee51a285d5c7c1063cdb0891:
>=20
>   linux-firmware: update Marvell 8897/8997 firmware images (2019-02-28
> 21:11:26 +0530)
>=20
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell 8897/8997 firmware images
>=20
>  WHENCE                       |   6 +++---
>  mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
>  mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
>  mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
>  4 files changed, 3 insertions(+), 3 deletions(-)

