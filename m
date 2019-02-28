Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496B6C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDAD204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eeQ/EF3y";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="KrCQwoJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbfB1SNM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:13:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50790 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbfB1SNL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 13:13:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1SIBWdR000772;
        Thu, 28 Feb 2019 10:13:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rwBgQy9Zs0w2kOQ5KmlTJAa9aLiv/EFpiuwMK7t+C2w=;
 b=eeQ/EF3yPnZzNU5aBCAgLA6i1gypnnT08fFQeJfSFZgUlWI2VwmT99BmqvPLbwhQRYtY
 FiyTXtxRvt8BlOPlavFkFbj2/egFFSV7aEsyzRhoCYW6oaEVwsm7vkr9dpJO8DdylJit
 BYn+qziutPE7wfdrWhghRBzlcFuE0SwwsvoskljnsrYfyTOcenqD0PL771brlPhxRrvg
 +VV9TG4IZMLu1Kttj3RFLWjbRVZEmP5olHs7RUvZh/YGFbgDX2ZwGATTw0kJaND/Hiz/
 H1LuLaqonX1cnacKQ9OYcFJoHY9j3GnYp5zPrhmmvZha/Ll6Phh9T8EJVEDgoDDdm87q 7Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2qxce61c58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Feb 2019 10:13:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Feb
 2019 10:13:07 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Feb 2019 10:13:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwBgQy9Zs0w2kOQ5KmlTJAa9aLiv/EFpiuwMK7t+C2w=;
 b=KrCQwoJg0ejdBU1HUPvUmAu/McZlAgk/6RjlIqw8kFJtQ1vmB5DvDJgZs66MCTz2SlvKpPc+NCDuKVs4AvJoj17FXtX4AipcIsL+sBGwEvpkJyJaLjiuO9u1J74q57yRlTphDeLf/LqGLqpbuXzpZJKJsSZfR4vEhUfQFJtK2JM=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.177.140) by
 CY4PR18MB1125.namprd18.prod.outlook.com (10.173.184.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.16; Thu, 28 Feb 2019 18:13:06 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::a11f:1535:50c1:a310%10]) with mapi id 15.20.1643.022; Thu, 28 Feb
 2019 18:13:06 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "James Cao" <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Subject: RE: pull-request mwifiex-firmware 2019-02-28
Thread-Topic: pull-request mwifiex-firmware 2019-02-28
Thread-Index: AQHUz4wxEhF42vNC0k6HTcJC2uOREqX1g0Iw
Date:   Thu, 28 Feb 2019 18:13:06 +0000
Message-ID: <CY4PR18MB12370DB22630E10334A5601AA0750@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB1237F8ABB98E9DACA5C5EE97A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
In-Reply-To: <CY4PR18MB1237F8ABB98E9DACA5C5EE97A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09d657b6-5954-45a0-0e48-08d69da8631d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1125;
x-ms-traffictypediagnostic: CY4PR18MB1125:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;CY4PR18MB1125;23:i2ErOflUGeQbIHP28haY2vBGBUXLIV7DQdpQGTaNb?=
 =?us-ascii?Q?KrAlnYQPm2TV3Yv3ClCd09FqiHK8cBm/HXz3phhSW3usqj2URJ0UPQng7/tq?=
 =?us-ascii?Q?c8KVsxvn8LUYP9EYLO9Qlk9M4fqqptrBlY7SYPXv4Eg3ij+Sy9OYpr3aMtuU?=
 =?us-ascii?Q?9OQ4ILuOvp3khnZDWaAmbcx2dKAfnwjoaCqbXfcA3qz11+7660el+8yRbH1W?=
 =?us-ascii?Q?GwO6115NYD0LnR+d0oVucKYJijpuTDF1+aQlF1ml/TeWwX9krJFQOW1j+u+O?=
 =?us-ascii?Q?JxazX5SIjryLCCzlUbN68wMbsUQgr6gBVJ4P/20Wgh7+3KG1/dbvM1O2Jocm?=
 =?us-ascii?Q?2CDMrSFDlxw/ujF8hfipjSaXkSz8hYvTTsCZ91eYnpROw7mcTo4HYx7z73c6?=
 =?us-ascii?Q?XIkSQZiodB9KMTdq/UFeFAQQaSAz8IpS6h9Yi+sv0N6trrgWq6MsmpVW9MUX?=
 =?us-ascii?Q?d/mJI0wJejxWO4sv+LeNxh/cMOoEMnwBw2pByVR427APOvZ8TXmA73tZOViy?=
 =?us-ascii?Q?7+FB4aLbqhAeseLYupLQlahWxr3R9B9GTf9T6Cu9vEGo0YNtg1rejvL+KcpR?=
 =?us-ascii?Q?FRdvGnFM8fG5uyhEco5bUQgTQHp4421LWFJ/v7li8a671+v2BhX8wZjORDrk?=
 =?us-ascii?Q?ihGIg5YTTlg2yqdQvt7S8zHOLnalogTmOIyU96c3sEQRclfw3yKiIU0LOep8?=
 =?us-ascii?Q?3bu62hHi/ErXwBRWmckuAAdBma20eXgwaYCuyHNIxtQrWO16AzXTKn34pfY0?=
 =?us-ascii?Q?LyURErSI8goC3n7u6kGPzuyvcUZT9YILoZu1GN7ZJw80b14tssrfvi8rn8ip?=
 =?us-ascii?Q?6ynX1eOHDjlTaKhevaA4Z8wmqbah/EuPQ6aLqwYpSlc4EuQkNsRnjF1uS/sJ?=
 =?us-ascii?Q?djMxpZa6S14Lscl2+HNkJuH902QyaK+hUUnivvjO5/heCBdsLR3HsF6RFH9A?=
 =?us-ascii?Q?HOl+DheYhFkorWdnFsvUuO7IO04NuDHze5aCAyVI+WCzWSF0LBx2W2End7Ou?=
 =?us-ascii?Q?1JZTajpXhIW6STLfiMUGoPR2mzB7VrAoYIkCgX7PQJYgDC1CJeP5MecU7Ojd?=
 =?us-ascii?Q?8DI/S1Dws0O0TMqAqauL11LEVoLEHPyc1N8rWPSUVYOZbRBcoBVBB84KZGfT?=
 =?us-ascii?Q?BxWUKvYPMTdjph47gM1XnJkaYQwPIY1tgEcHj2F/UNrqw7lQLWvMxuPw4b16?=
 =?us-ascii?Q?ucsHshWNpl2ohFWUA4sCgQGpvYgA0OhdF328BLZWQvTikzykR4o2QkM6sYd+?=
 =?us-ascii?Q?9u8sIEHWF+wVrMQZl2M2eRnRZa5YJDQ7g4P0ZoYk1fmrdhzsMdne7qy2XMXl?=
 =?us-ascii?Q?PT54cUIHFzML248ASryQxMkfUyEnOmxj6j+piT8MHpuqEuN80BihAP1JNYkt?=
 =?us-ascii?Q?f/Wf06kv5WgkygSFE4+NK+fx97hXYKgzpCKc2LrpBFz0T2Wxy8fDIVh6gSoy?=
 =?us-ascii?Q?eGkJLEBZRjWyNdDYBJOkEKJNzq2Vzd/8g+mSyOA0DgsmupNx361?=
x-microsoft-antispam-prvs: <CY4PR18MB1125E5ECD5F3A7001B7BC866A0750@CY4PR18MB1125.namprd18.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(13464003)(186003)(8676002)(74316002)(99286004)(26005)(81166006)(81156014)(8936002)(2906002)(5660300002)(14444005)(256004)(305945005)(55236004)(6436002)(102836004)(7736002)(316002)(7696005)(6916009)(2940100002)(86362001)(97736004)(78486014)(569044001)(71200400001)(3846002)(52536013)(71190400001)(6116002)(2501003)(93156006)(33656002)(25786009)(4326008)(14454004)(107886003)(6246003)(478600001)(55016002)(53546011)(6506007)(76176011)(5640700003)(54906003)(9686003)(229853002)(476003)(11346002)(486006)(446003)(53936002)(68736007)(66066001)(106356001)(105586002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1125;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eEJLFTRJPDluhMsZevwlPj3UIwES4ViIhurJnmSCQ9s3XobIJUhUkI0GAC4VpQo4tzDUV4sVOaI0X4mDjadNS2873olMQEHDi5UnzDeWV/9mX7mN88kVThNugChnw8Ofqn37vYskTfUWnPd4HiB4yRrQCMDFYQAKjG8ZMR2Pm+GCezbHGhGKQJXLz1R7c8j5c3mSyt8k/Z7/m/nXLUurqvDjg35e5iLpsrJuJFs7BhK4R80yV6BCaHSgezxPFWBnKQw4k8DqkmFm6SYXx5tbfM2zPwjyq6PTZXnRZuk9ljSdOSke2xepg93MqupIcAo8gcrdkcrapJcBX00M7g+HfH0+eLb23BWoxqZ2AT67sBoJMjm0apCS605YgnZI1B1CswhkTAsHwrLI1fM6hJE9BhzQ62nWCtEEROZFL86noTk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d657b6-5954-45a0-0e48-08d69da8631d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 18:13:06.1518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1125
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-28_10:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=863 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902280123
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kindly ignore this; I have sent a new request(and it is final)

Regards,
Ganapathi

> -----Original Message-----
> From: Ganapathi Bhat
> Sent: Thursday, February 28, 2019 11:07 PM
> To: linux-firmware@kernel.org
> Cc: linux-wireless@vger.kernel.org; James Cao <jcao@marvell.com>; Cathy
> Luo <cluo@marvell.com>; Rakesh Parmar <rakeshp@marvell.com>; Zhiyuan
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
> f0f63ed58fd49c42d06e05d1a6a8a1bd8e8b861c:
>=20
>   linux-firmware: update Marvell 8801/8887 firmware images (2019-02-28
> 23:02:36 +0530)
>=20
> ----------------------------------------------------------------
> Ganapathi Bhat (2):
>       linux-firmware: update Marvell 8897/8997 firmware images
>       linux-firmware: update Marvell 8801/8887 firmware images
>=20
>  WHENCE                       |  10 +++++-----
>  mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
>  mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
>  mrvl/sd8801_uapsta.bin       | Bin 258680 -> 255988 bytes
>  mrvl/sd8887_uapsta.bin       | Bin 695532 -> 616840 bytes
>  mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
>  6 files changed, 5 insertions(+), 5 deletions(-)

