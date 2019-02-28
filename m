Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A05C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B75C218AE
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="yEq5ba+R";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="mcbWXBcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfB1Pz3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:55:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3897 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726986AbfB1Pz2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 10:55:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1SFt3VB014856;
        Thu, 28 Feb 2019 07:55:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=/bQeDrmz3EHPcsHCOf8kGVDLsAJfPYKMvndxr41JNJI=;
 b=yEq5ba+RGS0ey49bNTMXZ274vRk9q8euZCLj4rBriZbpHzKReE0MLtZTfRFQvju7+Beq
 bOU1FS8qsMF0XI5lKM9Exs5AsaWQZJTZqpFS7xMhgn2cRzGnRub+rjLUGx4Z/3wNe6w+
 Vwcz4aiw0OAiAl2ZjfDkFw5i/FQolvpjp/pwpLzlXdcIzEZgsnJ0OJ+NvODFLb/mvKOQ
 AcZ6p7dhZ1NQ2Tx0qXOO86dzPD8SK16XfEJ0XNi/7ayz4VsFM8uDa7koU3T6KJgrzPCD
 traY6hNUas5U7C1G2hoqqWjWYivLRsCZMEarTLpW9JIhk/f9T9NcoSxyUgoM8AExiv+D qg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2qx4kmt87a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Feb 2019 07:55:26 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Feb
 2019 07:55:25 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.54) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Feb 2019 07:55:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bQeDrmz3EHPcsHCOf8kGVDLsAJfPYKMvndxr41JNJI=;
 b=mcbWXBcbnD7FTQ9cAlCods5x5ZR0YKEONnq8OYBpEUgf+3jdegfVdGjTL0rl3IW04/VMRWvI93arVkmqdb1MccVMpjXTwkjwOWgoJO4oa/0xp6qeIC9IYON3HuQJsRAkUJfw7L04aif97Rs9oNpYx0CL3iysSZiKssRxKnDep/U=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1016.namprd18.prod.outlook.com (10.173.182.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Thu, 28 Feb 2019 15:55:24 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%10]) with mapi id 15.20.1643.022; Thu, 28 Feb
 2019 15:55:24 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Subject: pull-request mwifiex-firmware 2019-02-28
Thread-Topic: pull-request mwifiex-firmware 2019-02-28
Thread-Index: AQHUz3389IKQ5g790k2DU7NOO09Yug==
Date:   Thu, 28 Feb 2019 15:55:24 +0000
Message-ID: <CY4PR18MB1237089CC3822DBF13CDB86BA0750@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3abf541-31f1-4221-522c-08d69d95268f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1016;
x-ms-traffictypediagnostic: CY4PR18MB1016:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;CY4PR18MB1016;23:cL8PwGdHo7TBMam9pnc0oHx1FbbJ7GpKAAeK3D1?=
 =?iso-8859-1?Q?Pn7zq6dc4C+m7tp8eE/Pb+qAl2YWl/icrL1UAfnwIk73wF5i/4XZNMpVYC?=
 =?iso-8859-1?Q?UvLV6cc6YE1QZlqEUcp7y/GKvIKIFwEX23/yYPOm4NodaQ6IT+RwzuqGwz?=
 =?iso-8859-1?Q?s8U+GTfp1+oIskkrKcNkFDg5FB/ODOpAZdG3xMvGmfzgKjkf3CB/v7Ym6C?=
 =?iso-8859-1?Q?JRFoOzr4tOhObFE5urBFfH2gTJspx8yMcVsp4EVXERM1OVeHnyvKqCBTCh?=
 =?iso-8859-1?Q?BCDy8jzIJ6f+tCVHxyaVLWVZgV77cEVp56cji+izCK4O+xd7+T5mzf8PRq?=
 =?iso-8859-1?Q?ov1bArDYXwKNVeTpvZEKtXiOJllcO+cPSDb1+74CuAfIh1nj2ntH6rMF1G?=
 =?iso-8859-1?Q?HDPruDevF1Eo9hVYo+Rqc6aS4TjmB1OTqSNM+zTRo/EMMB9UDjco1WGlcq?=
 =?iso-8859-1?Q?OpoJbWopfOcyeSmsaPwcVvuERpCHjJ89+WYtOxna52iuHrh/CaIZehV8K3?=
 =?iso-8859-1?Q?VCqHoXbfjWd/rqN952pK2TfSxRcHY52h9eEZoJtL8PK2iMROYzWKJLfti6?=
 =?iso-8859-1?Q?5BhI2glfzzlJWt66bmK+m2Dmv+rEFwpCv3sCVqsuxpfAdd8bfm/Qswh7Oq?=
 =?iso-8859-1?Q?xy6mr76JHF5xRGBdBaaVQTeqTXIdGfSAQQPHyFPzuMgdsG9lUMmwVpK8L7?=
 =?iso-8859-1?Q?1I3IUPX3OH7q7pJ4AvPCd1+AIKlMh0/WzTrfY0Fkp/PIxMYRtMtjMYm4gr?=
 =?iso-8859-1?Q?Xop4b+HN0ki98qxVqtJu9wl7o5DBAJ7KamxLBNGlhrJKy0rsDkuKecIlfa?=
 =?iso-8859-1?Q?E+ENw2baY4FH3xVMuPKAImZkyxwgB52GmXgvsVRbh6kbITbcz4e8JdNJ6m?=
 =?iso-8859-1?Q?wdNk4kjyXQ+Yi4vDQohU+MRLCHWwcyyQ3/4d8NwBcarxkD9glqEaT4q+m6?=
 =?iso-8859-1?Q?POoZUGud4CvmeQQBqG7Tb04ocABYvsZRWrAHgoidhCGK9qFa2o/J44Mszd?=
 =?iso-8859-1?Q?3psmHKlh5XBDcbBDoCqoBMdDlUkVG+c6ws0ICOBygPeDmOrNTb0Nr1vESR?=
 =?iso-8859-1?Q?46h5GVRb3/H7zV2XUOMnuLrrkYLyjebhGjMzfnXZ15YnykBUGk8OAdNz+M?=
 =?iso-8859-1?Q?e0FzsJJFnUuGbcztR8wH0XACJxkslF4ZZwC5PkjmFC/W4vejnOsUj5ZQG9?=
 =?iso-8859-1?Q?CKMn6p43OZQ/DfTIcAmrg07203jGyWSGILbbRMDmeUoScY+uk29zsZgsEr?=
 =?iso-8859-1?Q?JSL4Op885Yluge6vgjhc46Af8KmlUpIc/4M9VqV29wNgYenDw9F+6gfCZD?=
 =?iso-8859-1?Q?e81ogxNlWVdHVSZqOZs02mAhnvKe2ilai/XO3Pe9vZuoA=3D=3D?=
x-microsoft-antispam-prvs: <CY4PR18MB10168DDDB6E1B319A6B1C27AA0750@CY4PR18MB1016.namprd18.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(5660300002)(81156014)(25786009)(107886003)(6436002)(8936002)(7736002)(81166006)(55016002)(9686003)(66066001)(78486014)(4744005)(5640700003)(2906002)(53936002)(256004)(54906003)(33656002)(316002)(71200400001)(71190400001)(6916009)(14444005)(8676002)(68736007)(4326008)(106356001)(7696005)(2501003)(486006)(14454004)(74316002)(97736004)(476003)(26005)(99286004)(52536013)(3846002)(6116002)(105586002)(186003)(86362001)(478600001)(2351001)(55236004)(6506007)(102836004)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1016;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4rI90cU3QsQtn9Tza97JJqVy+NLTRH049sf/v5+5VI4KJTxS/kIzTqnJWiZuiX5dGXdFsLAbPcA5QkVZ62QWdJtokWGipZYJv8WvVAUKzIFr3GzhT50uYtwkfjzsEeOjNqTENUhLiBjuaeRKfL8tvg139P29CW8+AOOp3PMDDS607uVDcIipofYUfz2n4ULQtEZbDQp4OQ+6cNuEw/PmGFb/X8PeXNWA8cO4tkySqiYmQiElYvCocn+ySO4o5NLbU5PFKV8jZ4VNP74QttQnnZp3SG5/bqwnYEAzW4I9vnHzhA+XdGtdvsVm/G0TvQ+KfWepDKg7zVoxnzebc7Wzj0RWqXFwFq8OLu1gQYWZmx3zy0/3mURBObz5Aw2adzwCJepd9Ysne+JiVK3C/HcGz5tP65u9d6MXoJNgLrQKLN0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b3abf541-31f1-4221-522c-08d69d95268f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 15:55:24.1408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1016
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-28_08:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=767 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902280108
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

for you to fetch changes up to 1a5773c0c89ee44cee51a285d5c7c1063cdb0891:

  linux-firmware: update Marvell 8897/8997 firmware images (2019-02-28 21:1=
1:26 +0530)

----------------------------------------------------------------
Ganapathi Bhat (1):
      linux-firmware: update Marvell 8897/8997 firmware images

 WHENCE                       |   6 +++---
 mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
 mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
 mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
 4 files changed, 3 insertions(+), 3 deletions(-)

