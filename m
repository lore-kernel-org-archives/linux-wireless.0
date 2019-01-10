Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF15C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE52B214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bDy/ZJ8Z";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="gjaN8NxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbfAJJLv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:11:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60502 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbfAJJLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 04:11:50 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0A90iYh024720;
        Thu, 10 Jan 2019 01:11:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=DnU3kr5tu6Hp6M5SMdW1tbjwN8pFwD1oGQVpfnk1Wqs=;
 b=bDy/ZJ8Z+927IoJBVINO6dsHn/ID5uzxnF3FebPTMSPNh1r95VOn8dN4CN5jR+iB60Js
 8vAaoq6MTQ5pj2jjW4jByP3TmL4XlXJjHgIKHRr6m5UoGh8v0kZT9XLfwqcNbPP4+lFc
 YLAsrw81+Wvng+BTxUZIBE8N5IUVJPe7Gitw+bfGUIWPQP7RhGXvGWEHTF7zf2XAtocI
 Gp0chU2subzZEY2RAzqdKDJU1Ss/Z/DurWUhbuJY5WKPR3z0zjbU6UGowPkjY0UgLZK3
 GUorn1d0qhkJ9VVpTYuVziRCbw8hbbFd61eBjLjwsZAyGUz8XqzGJegoR0x1Vznypwm8 zQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2pwthrtbps-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Jan 2019 01:11:48 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 10 Jan
 2019 01:11:47 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 10 Jan 2019 01:11:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnU3kr5tu6Hp6M5SMdW1tbjwN8pFwD1oGQVpfnk1Wqs=;
 b=gjaN8NxWcS104B1iReQ6oau2m1hvqTUso0Tf+RIriqRQSIxryiP19JZDoeWmU8218Gra3Nr6JkRJZ7X6bsVAPglo1ypzjZNbCKCAhygO0t3SoIb/MkWyhMN7NvVcrOwdEUjs3iYTyFMdSFMEE3Eq6+G3EH4D033J5LG0YA0y/xM=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1079.namprd18.prod.outlook.com (10.173.183.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Thu, 10 Jan 2019 09:11:46 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Thu, 10 Jan 2019
 09:11:45 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>
Subject: RE: [PATCH v3] mwifiex: add support for sd8977 chipset
Thread-Topic: [PATCH v3] mwifiex: add support for sd8977 chipset
Thread-Index: AdSowMeaJvLZaZpMTJCHp8p+7nhmQwAAlJ3JAABK5AA=
Date:   Thu, 10 Jan 2019 09:11:45 +0000
Message-ID: <CY4PR18MB1237E6B9605D4BC3A4E8BEC1A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB1237E51E20E86ED04AF401D0A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
 <87wonc6g4q.fsf@purkki.adurom.net>
In-Reply-To: <87wonc6g4q.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1079;20:FYi3NR4YCC7I3lGPMh/Mvv0PO5QOJLQ2VJ2XKmllQazeXURD5kVqkrn0Oe5te1SQbs9ljJejKGkRqom10FajVsALuzsZAknfjenT28ug350rTJ1DXXzPD9Bbs0YGQXFhFIv1wDEAvKtW8aJSJbo+EUgm6NHe+5xbQtY+RKShJkc=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(136003)(366004)(376002)(54534003)(199004)(189003)(68736007)(106356001)(256004)(478600001)(66066001)(575784001)(86362001)(105586002)(33656002)(25786009)(6116002)(14454004)(4326008)(486006)(966005)(6246003)(6916009)(99286004)(305945005)(4744005)(78486014)(71190400001)(107886003)(71200400001)(7696005)(53936002)(5660300001)(3846002)(7736002)(102836004)(8936002)(81166006)(81156014)(76176011)(316002)(55236004)(26005)(6436002)(54906003)(11346002)(476003)(6306002)(8676002)(74316002)(6506007)(446003)(9686003)(229853002)(97736004)(186003)(55016002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1079;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: 75a1aaea-287d-4d8b-0ca3-08d676dba4e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1079;
x-ms-traffictypediagnostic: CY4PR18MB1079:
x-microsoft-antispam-prvs: <CY4PR18MB1079FC48B9C867A73687279EA0840@CY4PR18MB1079.namprd18.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T82P6NrgIg/F5CobMLLEL3JTHpDJb/sxvwcMhjhcVnssA260bEK1htmdYxwjMRRvQEFdYRYFRRsRWrDkxZ98EFAFBcwkkCo6xduoCsq/NAi41OWPIWL6mdcvrM/wENCgZr7sbMk6DEqTrMvAVBzAUkpB8slfc4hKLADYlARhRtkYqpsvnpa49RCkdTLBN9MZAyPAoaImFMU0oEvYmSJF4QtttmNSAJ2kixuDkcOVBSn19p195VmznemCQN0PNPVgRnJ46hfHElMD9fsyV6x+AEyTDgP2TRqPtdDABtBbDy0GaqJ+/jb/zl2bkk8oCwym
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a1aaea-287d-4d8b-0ca3-08d676dba4e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 09:11:45.5243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1079
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-10_04:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=543 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901100075
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
> Subject: Re: [PATCH v3] mwifiex: add support for sd8977 chipset
>=20
> Ganapathi Bhat <gbhat@marvell.com> writes:
>=20
> > From: Hemantkumar Suthar <shemant@marvell.com>
> >
> > This patch adds support for 8977 chipset to mwifiex with SDIO
> > interface. Register offsets and supported feature flags are updated.
> > Firmware image used will be mrvl/sd8977_uapsta.bin.
> >
> > Signed-off-by: Hemantkumar Suthar <shemant@marvell.com>
> > Signed-off-by: Rakesh Parmar <rakeshp@marvell.com>
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>=20
> Changelog missing:
>=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingp
> atches#changelog_missing
>=20
> But no need to resend, just reply to this mail and explain what changed f=
rom
> v2.

v3: Remove commit ID('From  a0f96e63...') in v2

>=20
Regards,
Ganapathi
