Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863A7C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 15:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54791206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 15:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="N29dcct1";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="f7mY/5mG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbfAIPBq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 10:01:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54074 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731686AbfAIPBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 10:01:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x09EkOxq025698;
        Wed, 9 Jan 2019 07:01:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ovhVcSAXLGEkO/6mDpIQWf11DVxLXK03iS4BcZCdlhQ=;
 b=N29dcct167QBzVZtB9ARTDu/0YUy/DBflJmPVTE0gtghyUJgHZjBCQiGFwiGNK014zq+
 tR+KbdCxJhfLDODbdwEjs9LkmAc+hnFotQbvD7ckXwgsTkbmVxRDsnPrpFe05/SPC91l
 Z/h5igCRsVakTuZu4Ip1cHqQyt9fS5HRaqwYhmk7XD+MkEwCRyONB877hLAiEowUD7ih
 3mVsVt/7b5vPTuoSyMK3J9OrlXnZVbPE2N5Au8Cye6zqyU5+BQpxpfnb23/IjsxipC0R
 RY+gHKNcOhyIQ+efpqU8oC1gqxgDmZjzuP0UR6N+qwy5mniepouUKLfxiCC4hlFe0xJl Sg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2pvwjq5kwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Jan 2019 07:01:43 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 9 Jan
 2019 07:01:42 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 9 Jan 2019 07:01:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovhVcSAXLGEkO/6mDpIQWf11DVxLXK03iS4BcZCdlhQ=;
 b=f7mY/5mGHeub3ATvKdtfbGzc8Gh/MXxIjoDH77FIPKsaXyl50A0AFA873XxrVMduPZEuH1pGTph23cki6OXZBcKyC4Cx4g+Dinb/cZ8BLBFfa/8jwys0sa7TPUT8/qd2IVwheF2iDDU8Jmsr2IIqy6teAJi2Y9CRyfWgdrqxSBU=
Received: from CY4PR18MB1237.namprd18.prod.outlook.com (10.172.176.7) by
 CY4PR18MB1543.namprd18.prod.outlook.com (10.173.62.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Wed, 9 Jan 2019 15:01:40 +0000
Received: from CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5]) by CY4PR18MB1237.namprd18.prod.outlook.com
 ([fe80::95d4:8a68:81d7:87c5%8]) with mapi id 15.20.1495.011; Wed, 9 Jan 2019
 15:01:39 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Rakesh Parmar <rakeshp@marvell.com>, James Cao <jcao@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Not able to see patches in patchwork
Thread-Topic: Not able to see patches in patchwork
Thread-Index: AQHUpzb9XornoqOgnkaUNaBcO8DKuKWlnR2pgAFoyXA=
Date:   Wed, 9 Jan 2019 15:01:39 +0000
Message-ID: <CY4PR18MB1237311E8A5B1D719BB48EB5A08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
References: <CY4PR18MB12372AF071013F01A0DE6A32A08A0@CY4PR18MB1237.namprd18.prod.outlook.com>
 <87ef9nqdea.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87ef9nqdea.fsf@kamboji.qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR18MB1543;20:aKDgJVzexfjq4gqRi/vOR1QLHXf1uJU6NJP3MMS07j1HMpUnLaki+WrP6bauwjV5o3jw4hFVD6QuvYprSDh6b+GrRaMbuwSwiFnXNMnf9raBrBYcam/Q9hEgNmVZDD1AdbWYwWfhmgqoBJunZJRUeKZgbtuvl28YPIroOokLgFs=
x-ms-exchange-antispam-srfa-diagnostics: SOS;SOR;
x-forefront-antispam-report: SFV:SKI;SCL:-1;SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(346002)(396003)(376002)(199004)(189003)(106356001)(78486014)(305945005)(105586002)(25786009)(11346002)(3846002)(6116002)(476003)(446003)(2906002)(256004)(4326008)(53936002)(6246003)(186003)(55236004)(26005)(102836004)(6306002)(6506007)(76176011)(7696005)(55016002)(7736002)(478600001)(966005)(86362001)(54906003)(8936002)(97736004)(68736007)(9686003)(99286004)(316002)(66066001)(33656002)(6436002)(486006)(8676002)(74316002)(81156014)(229853002)(5660300001)(71190400001)(71200400001)(6916009)(14454004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR18MB1543;H:CY4PR18MB1237.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-office365-filtering-correlation-id: 222cf224-1e48-4707-7636-08d676435bfb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:CY4PR18MB1543;
x-ms-traffictypediagnostic: CY4PR18MB1543:
x-microsoft-antispam-prvs: <CY4PR18MB15433046713A36EA77CBE082A08B0@CY4PR18MB1543.namprd18.prod.outlook.com>
x-forefront-prvs: 0912297777
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +hKVDCugW8zCT13t26cdBj1cMEs+BABeFOiPPwElveb1AHqXWNjGK5Uf5naObJ2fMs08r1TG3ZFCgxS7Dax1kh9r6+zmG6G5+xxfajYN14HGKB7pV+niJdN70dnM+6SKx5QKWzAJl2Mhptm5CTow3fR8m+7XeeGNqFLZ2tIMGll8uJGLCzqTdQBTFDTqXVk92aFBZQ/Rxq/YRIBcNB9zMymT1Evvf2z/uOQqk2t3y/OXqOO06y0tLdr0n1PVbw/iG2UsArrKrxkPWzFSRwNNJZhqe5Z2PhTqJasv0G0VRE5IBmdD9vF1Tpe++rrv9nkQ
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 222cf224-1e48-4707-7636-08d676435bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 15:01:39.6502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1543
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-09_07:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=821 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1901090125
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

> Hi Ganapathi,
>=20
> please do not email me privately. If you have questions send them to the =
list,
> you get answers faster and I get less email :)
Ok, sure.
>=20
> Ganapathi Bhat <gbhat@marvell.com> writes:
>=20
> > I am not able to see the patch sent to
> > 'linux-wireless.vger.kernel.org', in
> > https://patchwork.kernel.org/project/linux-wireless/list/
> >
> > Let me know if you received my patch, named "mwifiex: add support for
> > sd8977 chipset"
>=20
> When did you submit it?
I did submit it couple of weeks before, using 'git send-mail' utility.=20
> I don't see such email on linux-wireless list.=20
> I  recommend resubmitting the patch as v2.
Ok. I have sent v2 using my GUI mail client. Now we could see in the linux-=
wireless list.
Sorry for the trouble(could have tried this first).

Thanks,
Ganapathi
