Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC93C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 17:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD5B218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 17:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SCbAjSVu";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="fmufzmEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbfB1Rg7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 12:36:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732689AbfB1Rg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 12:36:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1SHYn5G001201;
        Thu, 28 Feb 2019 09:36:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=mQswMLYyv2+9q479Lo+L3/dDI3DqEDvWycFuSXg7blY=;
 b=SCbAjSVuNKoyleP3q0f/orw6NttOPfzv0b/C/5PoIXLg9SW9m6Um6eiSmSKXKUkcbbgu
 PphheKiv1QoEcrvx0tfdiq+RXfMXfKh0kp5qb6cynDnn0t0Jrsp37uG3Wo2eyA1/Pkna
 w8LEwrxFncFrlplOoSJ+ZUWq2fZ63SKAXr2bqwKXyEaf+DEpaPjGQx9Q6JhdUYNKR04c
 AoxVEz7xDGRYr+kj6dH87zUXFwoFdbdHt8AKK7X26FK9PQLBMpUxKYXG3CzMWXo2fgML
 kZUxfAB+X08UCUe0IM0IcJ9KMLl/A4p4txsquUeLuV8sivt4Y90q9BJZJodRlWTkcJWe WA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2qxce618yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Feb 2019 09:36:56 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Feb
 2019 09:36:54 -0800
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Feb 2019 09:36:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQswMLYyv2+9q479Lo+L3/dDI3DqEDvWycFuSXg7blY=;
 b=fmufzmEUW58dOJ8ZEZJdJyEOsIHC0zVAXlHMalPSnobWdcvKCNxTkhqhRjvPtHmKqCKcBaOs5s2+9rpuSm8Ccil4H+RcXwfkshw1cZav0vpgMoPq6cD8MBn0f6igl2qRYyNKUaKQL1uvVV7ac0lyNEZ7R5/XAP+M/CfJIJxYQCI=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1223.namprd18.prod.outlook.com (10.172.181.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Thu, 28 Feb 2019 17:36:53 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%10]) with mapi id 15.20.1643.022; Thu, 28 Feb
 2019 17:36:53 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "James Cao" <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Subject: pull-request mwifiex-firmware 2019-02-28
Thread-Topic: pull-request mwifiex-firmware 2019-02-28
Thread-Index: AQHUz4wxEhF42vNC0k6HTcJC2uOREg==
Date:   Thu, 28 Feb 2019 17:36:53 +0000
Message-ID: <CY4PR18MB1237F8ABB98E9DACA5C5EE97A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa0a5eac-ecbd-4bfc-f5bc-08d69da35408
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1223;
x-ms-traffictypediagnostic: CY4PR18MB1223:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;CY4PR18MB1223;23:qfDFWZbSS1dwk764QqDe64azo5rPaMMSO8mFFaK?=
 =?iso-8859-1?Q?erOblVzog8sDGoXX+UAZAZegV7NyvPt5bOJTtAQsuqc2abyN5vwCNCsYkl?=
 =?iso-8859-1?Q?Ai6hwofVD/ydDpw4Gl+1FZ0zlTQUSjK1++RbyqxVPqvflrvV5EFSc7lKEG?=
 =?iso-8859-1?Q?mL7iuEDSGy2zrIyV2f2LLzzxND49wlIocPuMYubb6FZc3/zONCBOb6CgLb?=
 =?iso-8859-1?Q?TByfjHSfaWP1H4gqNQ1dxlHxxsCEo4WD88oAe6HB6gFEFKDzm5ygU8Wfu4?=
 =?iso-8859-1?Q?r9bDKv2M1eTZqt3ym/hzTJYim9MJuXPJoc1QaVikD+bYaBHy5U97r2fXTM?=
 =?iso-8859-1?Q?09ChmAIRLu7I/OeA89t9ClOFqwb9NSaNC/qB0XBSTK+p3y4V3VCUHirYQ6?=
 =?iso-8859-1?Q?7+WmFfb+mzeg4cDZz91XzuW1yeGjaMcdF+Bn4ja4u2nPVBZ6FyddBKw0aN?=
 =?iso-8859-1?Q?b4UUiCn3ikTX4dOB+dPQ0ONCRDvxsjv+DJElJwPw2WYhEx8s9R9NBA8/pT?=
 =?iso-8859-1?Q?uGz0GxPekc9C0VZ/cfcTZvkYF5nHTfF4okpGKvt1qn1DtnJymhS1W3Tri6?=
 =?iso-8859-1?Q?pOtoPcE9I73JjfTaeXkO3jDm0aHknKJPdgjqRDhdjCZAgu4lhN9OE7/c0H?=
 =?iso-8859-1?Q?nYzEwv0zZ1cGvIeqs6seWg2IP6ZvV3J99H22cRoXqXQ5X88/AYMF7PBOVk?=
 =?iso-8859-1?Q?0FQQQivO+kA0lrKYCEozR+B6LOJqlogbjA8kl5mMSRkI0nyub4bqI3nH8x?=
 =?iso-8859-1?Q?CO+v+R4akla0dcfZyL3ZRycXaAQaJaC+ET8AC8dbkPjcMGQIzBGuXSQ93o?=
 =?iso-8859-1?Q?W2skSVuNGJKorJHZTcH0kgNu4AU+s1rT32N1FmGQppkZ8YMLMylqXGYq+O?=
 =?iso-8859-1?Q?Xco2Gid96/F32G1jKML9lD7YY9PX+yxNpSsKAoaYp055xeS2ybhKT0ePey?=
 =?iso-8859-1?Q?/mmR1jrwVVoZu9tZDqkgTiAIOj5xpbBVlBIr3RiYOYaBk8ey1RvYaIrFxm?=
 =?iso-8859-1?Q?w6MIDEqVoOhVEg129fn6r+qiIwePdo5sIvxn0wGnFZ60FMrUn3g0a9EFtW?=
 =?iso-8859-1?Q?7J1GT/13mvjKetMdYe/nJu7A1XDSG40oata4eo1+/9UPw84038jh5rE+KV?=
 =?iso-8859-1?Q?AST/11C2+bOayo0vqSmlV6egKlROXjmQ82Bv35UrVvvYoiLBm2j4D+rLZR?=
 =?iso-8859-1?Q?gqye+D2zg/dfoag870oIWc4F/2aHcB4jvfp2f7zjhxjiY/mxy/PvdgWZBb?=
 =?iso-8859-1?Q?Kmv8E57v72x0peblzBf70AjISyhARP6Gw4mmvQMTrwurac59wZT1ejzrFV?=
 =?iso-8859-1?Q?pZAD7ohT9MWWK4j4q4DxxqLDhdgQ/+9hMQVdjL75BZMqA=3D=3D?=
x-microsoft-antispam-prvs: <CY4PR18MB12237C7801CEDF62383B894FA0750@CY4PR18MB1223.namprd18.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(376002)(346002)(396003)(199004)(189003)(81166006)(6116002)(3846002)(25786009)(86362001)(6506007)(54906003)(316002)(81156014)(55236004)(102836004)(8676002)(99286004)(7696005)(106356001)(2351001)(105586002)(33656002)(74316002)(66066001)(4326008)(7736002)(305945005)(107886003)(478600001)(14454004)(6916009)(4744005)(55016002)(71190400001)(9686003)(52536013)(97736004)(71200400001)(186003)(5660300002)(6436002)(53936002)(78486014)(2906002)(14444005)(256004)(26005)(8936002)(68736007)(5640700003)(476003)(2501003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1223;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xe7okUu5v967FE3xOXzkAyDYZfWmKMJrsK4fHiVNN8oe3o1+e1Ky0PdPtAT2z2tozUrymm6Iyqps/vyUhEjtGyr7pt/qhSlRqSkVQeC33cH+qGNCP3yStXWF1cdwMv6JUP8rkL/n47D48/cJev/zcPI1jDWEkPF4c5tmlHp+CBrfQ+CExZ5Q190dSyvDNxvvZHYPAjKB7OuAXsRdNGXMaGZBFilDl9dObgcRV+qu7U8EPv0HJRLVFUBMy6I0JZ3APdhldUESdKTl1bqhxQk8Eo/NJXP1DEtf19jgEE71OdqJukkvtunPFCBpC9aKb87t/KYoNSdwVK/qkm+s/yrtbRB6A12352z7s7GvVmFLg3Bl3LGYjHBI1WN97E9yvJjgqsk6PtXG9gRvXKlKMETACNlW6IcHkW8nOyFuDgtSDkA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0a5eac-ecbd-4bfc-f5bc-08d69da35408
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 17:36:53.2975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1223
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-28_09:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=757 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902280120
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

for you to fetch changes up to f0f63ed58fd49c42d06e05d1a6a8a1bd8e8b861c:

  linux-firmware: update Marvell 8801/8887 firmware images (2019-02-28 23:0=
2:36 +0530)

----------------------------------------------------------------
Ganapathi Bhat (2):
      linux-firmware: update Marvell 8897/8997 firmware images
      linux-firmware: update Marvell 8801/8887 firmware images

 WHENCE                       |  10 +++++-----
 mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
 mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
 mrvl/sd8801_uapsta.bin       | Bin 258680 -> 255988 bytes
 mrvl/sd8887_uapsta.bin       | Bin 695532 -> 616840 bytes
 mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
 6 files changed, 5 insertions(+), 5 deletions(-)

