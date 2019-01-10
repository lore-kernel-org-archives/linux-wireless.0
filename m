Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB103C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF4420879
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="zG3ZmNmS";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="reNlh8OO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfAJIqX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:46:23 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727262AbfAJIqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:46:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0A8ixmn006579;
        Thu, 10 Jan 2019 00:46:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=XHrVWt86TFUkwnbX/p1HZeK2P+T+v+Yy7uscX2OZeaU=;
 b=zG3ZmNmSArYGUVThTMGoua/2JhaLYASMe6EYw0bwzZDb2CeOlK1ovnL262HsrL7Apuy7
 j/dKn8HloNcNGl8MPAwdGGC5kfq1UQ3Nsaz8DCHKNH0s6EPIO5A+PzlIEBG/0w3I2Pwg
 yoDiXM6VIhlnYmYFZMkhx82EKzDDQ/7H9tWyeG8gTICi41o9HcgMUDUcbLOrc6DxmM01
 oqb/7UMYVhbvLK4XphTw7jxeWMpEm7wT1toXRWqPCaL2iMxrzBWSOcGWRnuijicCD15J
 CnglvO8hjbgTH3kzjRhHKVtkfU8S0ajF6tNzHyccc2yAacc4vog8MRu8OxsOG200/Wst kg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2pwrc5ttr9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Jan 2019 00:46:20 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 10 Jan
 2019 00:46:19 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 10 Jan 2019 00:46:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHrVWt86TFUkwnbX/p1HZeK2P+T+v+Yy7uscX2OZeaU=;
 b=reNlh8OOJXb5m/tzauBgHMEXCGKtLrRtbfM9Hco8DerZAUTcCYK1Mu5Kp+r6vGa7HVTlIsVbDfYtFGIAd4OBQV/MH3eesXHQQnxuziuAMuyUf3ktULwvkZ9nEWJLR0fCv2C5J/ObzWKrQEsYTCW/uWxLK4hoKvhvJ1M5e7wqaaI=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1541.namprd18.prod.outlook.com (10.173.62.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Thu, 10 Jan 2019 08:46:18 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Thu, 10 Jan 2019
 08:46:17 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>
Subject: RE: [PATCH v2] mwifiex: add support for sd8977 chipset
Thread-Topic: [PATCH v2] mwifiex: add support for sd8977 chipset
Thread-Index: AdSoKeBMXl0ndSmBTC+txF8evGoR5gAjeUOdAAID8UA=
Date:   Thu, 10 Jan 2019 08:46:17 +0000
Message-ID: <CY4PR18MB12377DAC56F16A71636460E4A0840@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB1237AEF3375B348254E0298FA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
 <871s5l6jvf.fsf@purkki.adurom.net>
In-Reply-To: <871s5l6jvf.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1541;20:bEceaV7RRSjUhYA4Gce6SdOH+jkCMyI1TdtezFvG7b+dz6dyAohzcycI3FOoTkhke4bJwLmTZFqw1sOL0Vx5Q79s0pv1J73DPAkxVX5lgFrsfnFTstkGuFHsANTpdtTxfmdmGOELhhBNk7Tlqrapw58AtNnj5jdGab5i2zucHD0=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(39860400002)(376002)(396003)(199004)(189003)(105586002)(6436002)(66066001)(8676002)(256004)(4326008)(99286004)(316002)(74316002)(575784001)(86362001)(486006)(55016002)(11346002)(229853002)(446003)(78486014)(81166006)(305945005)(81156014)(7736002)(476003)(8936002)(6916009)(186003)(33656002)(71190400001)(7696005)(68736007)(76176011)(478600001)(3846002)(5660300001)(9686003)(6246003)(25786009)(107886003)(97736004)(6116002)(71200400001)(53936002)(54906003)(14454004)(2906002)(55236004)(6506007)(26005)(106356001)(102836004)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1541;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: 0fb76abf-d4b1-4497-f5a9-08d676d8163c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1541;
x-ms-traffictypediagnostic: CY4PR18MB1541:
x-microsoft-antispam-prvs: <CY4PR18MB15418F87E389623BCA65C3D5A0840@CY4PR18MB1541.namprd18.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ahRLmLHul8g/MECm+R205hWcjNpHJTfqp3B0FCI4u412zONJYKqd2xHl51UXbxvXykQ0oFf5WmjX9jeS5Xf9YR9ThIr88kH43wCqOhTCBRnn1YCJ7baH/lcAeLKvsGQpfOaliQSAwHXylMTya2OzYhN2hMMnlE6SbHAqS2ba3Suuw+e3h77bXcZ+RZ8a4Qg9xBkRREip1ekIZfUhRurjNiRWmvDCAocRUo50GdSmBlzaGO30KdIpyaklIOFF2lyisU0dSjtBR5yapZ9D6hw3Ufp0lBSVEy5PGDraJeU7U5viODVcpn4gu5PSyltY77L0
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb76abf-d4b1-4497-f5a9-08d676d8163c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:46:17.7142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1541
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-10_04:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=735 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901100073
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

> Subject: Re: [PATCH v2] mwifiex: add support for sd8977 chipset
>=20
> Ganapathi Bhat <gbhat@marvell.com> writes:
>=20
> >>From a0f96e630eb5b74b047149e23c161a9f06fb2cc5 Mon Sep 17 00:00:00
> 2001
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
> I'm not sure if git automatically removes '>From ' (never seen it
> before) so I'll remove it manually if needed.

I have sent v3, removing 'From a0f9...'

Regards,
Ganapathi
