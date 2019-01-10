Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACEB2C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A285206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 08:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="uQJ2VFvU";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="YENR35KD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfAJIiK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 03:38:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59180 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727342AbfAJIiK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 03:38:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x0A8TuuD022944;
        Thu, 10 Jan 2019 00:38:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=bQ54W37ZizkWh4ysSnLprzV85arxnoIzs6DcKFsrxRU=;
 b=uQJ2VFvUKb7QrNMHa4yX82qbsr6Zxtc9R3C/1rDLddfObjU1g/Im/elsWJ1oQ/tdaWIE
 ungo8CvZVM9U1EjXbqCTuZyOTkmuz/hREDte65cuwdCbafhp86qXamyB0OCe1Hwc8gEm
 UzNXIt6Loygl/Jvuu8Q6kfu49pke5RENf+RKSzad03RX762yBlOtJledgcB7LDrM0c2x
 Odx39US1RuICb/p0Zo/EmOUvCKQjHZyVMKrUhd8nwTUfX+KxEz3qz4NyJ833+beO58Nl
 0fIXpN2NO3Jjbp4G7pEygsvVXP5U0asYjBxUBvCRcTrFOZDbIVdD5rnVv8odfEWzGScQ +w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2pwrc5tsfq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Jan 2019 00:38:07 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 10 Jan
 2019 00:38:05 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 10 Jan 2019 00:38:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQ54W37ZizkWh4ysSnLprzV85arxnoIzs6DcKFsrxRU=;
 b=YENR35KDHEljAsZXsEI/WxLjQvNzQOYLZqrw2zObPb0JliSrmnnwsL7RK8XmqJ9eS+TeHuu4RiXW/jZsyUOLOTuFHBynUSwTLhxd5xhRVFEo1XDrGXOJ6fuDqIEjtQhW8SdW+67zu1vS91CHaOzgwfjZel153POdvJzaWxLGn+c=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1255.namprd18.prod.outlook.com (10.172.176.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.11; Thu, 10 Jan 2019 08:38:01 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Thu, 10 Jan 2019
 08:38:01 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Rakesh Parmar <rakeshp@marvell.com>, James Cao <jcao@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Not able to see patches in patchwork
Thread-Topic: Not able to see patches in patchwork
Thread-Index: AQHUpzb9XornoqOgnkaUNaBcO8DKuKWlnR2pgAFoyXCAAA2wh4ABHQpw
Date:   Thu, 10 Jan 2019 08:38:01 +0000
Message-ID: <CY4PR18MB1237C3F9DEF490F1904FFE5AA0840@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB12372AF071013F01A0DE6A32A08A0@CY4PR18MB1237.namprd18.prod.outlook.com>
        <87ef9nqdea.fsf@kamboji.qca.qualcomm.com>
        <CY4PR18MB1237311E8A5B1D719BB48EB5A08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
 <87imyxdesw.fsf@codeaurora.org>
In-Reply-To: <87imyxdesw.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1255;20:GAa/pbHjTLQWfZixMfGoOiWuNZCFuYzhM06Vftbcngr/vUuyeZTkOSv47aPohaL+O7A/JLkw527bbPqE8c152jQn7bKgGeujnP5NuYH6RPBLHCCAMSEYgWgwwU2uRwy+RdB2JiXiyZl+vofB/YrOdQ/7dIsnI13B3Wy//wdwly8=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(979002)(136003)(376002)(396003)(366004)(346002)(39860400002)(199004)(189003)(71190400001)(55016002)(71200400001)(93886005)(5660300001)(478600001)(66066001)(9686003)(6306002)(25786009)(53936002)(6246003)(966005)(4326008)(97736004)(6436002)(486006)(558084003)(256004)(14444005)(105586002)(3846002)(6116002)(14454004)(55236004)(102836004)(106356001)(6506007)(7696005)(76176011)(186003)(74316002)(86362001)(305945005)(7736002)(476003)(2906002)(68736007)(8936002)(26005)(11346002)(446003)(229853002)(8676002)(81156014)(6916009)(81166006)(78486014)(54906003)(33656002)(316002)(99286004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1255;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: b4364961-b4f4-4e9d-235d-08d676d6ee65
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1255;
x-ms-traffictypediagnostic: CY4PR18MB1255:
x-microsoft-antispam-prvs: <CY4PR18MB1255C765F10217EF7C679169A0840@CY4PR18MB1255.namprd18.prod.outlook.com>
x-forefront-prvs: 0913EA1D60
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KZRUUOHm4W3oQ7B4kbtKE3scIwchXBWpW7OWRUmzrdfs7Xp3t67j+QKxSAFpIMDgitJSppDPjt+Y5idlryy+okRfe2htq/2QrHJz+wOKw0WoAF+Wb8ZydJyFte7r8H9d57PT43+FDTdPCMVQKxXu2Zr/pi01Et57e0IDahkJYZ23IPCWsyUjdTRF/FQiOrFbulBY3UE/n/3NU3WgySSnMprLk2ZA/BIUWvnXgeIT7XVhmXzuACiNH2x1ZKhdwkYkPr9wGwLNxb5nBIcxH5DJja1ZGhISIn4a2w02ivOUUVxa5Ky9IGYmPMt9KdqFXyC9
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b4364961-b4f4-4e9d-235d-08d676d6ee65
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2019 08:38:01.3563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1255
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-10_04:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=558 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901100071
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
>=20
> I can confirm, I also see the patch now:
>=20
> https://patchwork.kernel.org/patch/10754283/
Thank you
>=20
Regards,
Ganapathi
