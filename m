Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0F7C64EB4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 20:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B933120863
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 20:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nio365.onmicrosoft.com header.i=@nio365.onmicrosoft.com header.b="TE5Pp9y/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B933120863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ni.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbeLAH1U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 02:27:20 -0500
Received: from mx0b-00010702.pphosted.com ([148.163.158.57]:36920 "EHLO
        mx0b-00010702.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbeLAH1U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 02:27:20 -0500
Received: from pps.filterd (m0098779.ppops.net [127.0.0.1])
        by mx0b-00010702.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAUKFrJk013023;
        Fri, 30 Nov 2018 14:16:50 -0600
Authentication-Results: ppops.net;
        dkim=pass header.d=nio365.onmicrosoft.com header.s=selector1-ni-com
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2051.outbound.protection.outlook.com [104.47.49.51])
        by mx0b-00010702.pphosted.com with ESMTP id 2p2q3dbqyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Nov 2018 14:16:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nio365.onmicrosoft.com; s=selector1-ni-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2NzQrtoxOiW1uAm5xnvy9nZA9ds2SmwUDBYSp0ceJk=;
 b=TE5Pp9y/8POTsj1D7LLBXXWjW0Wyy0HwQd1b0DtgUuXlPKlEeYgkhkHxpYCbYdwDZxArXRdf1aaaGcHKYZmoxdDAZLBo3WMhR/+ppTo08NyNHfTpBYUJcX7VVEQ5OjnV5RXTUZ9x7aBj1sS9W3JrBb6yncSO1paMATHBbrPoIKI=
Received: from SN6PR04MB5343.namprd04.prod.outlook.com (20.177.255.221) by
 SN6PR04MB5296.namprd04.prod.outlook.com (20.177.254.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Fri, 30 Nov 2018 20:16:48 +0000
Received: from SN6PR04MB5343.namprd04.prod.outlook.com
 ([fe80::909f:3f84:b758:c843]) by SN6PR04MB5343.namprd04.prod.outlook.com
 ([fe80::909f:3f84:b758:c843%2]) with mapi id 15.20.1382.020; Fri, 30 Nov 2018
 20:16:48 +0000
From:   Kyle Roeschley <kyle.roeschley@ni.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Only use match sets when firmware supports it
Thread-Topic: [PATCH 1/3] ath6kl: Only use match sets when firmware supports
 it
Thread-Index: AQHUd4FLMMXTWwhUh0Odo1dUEe1jaaVo5DkA
Date:   Fri, 30 Nov 2018 20:16:48 +0000
Message-ID: <20181130201646.GA16998@senary>
References: <20181108163659.19535-1-kyle.roeschley@ni.com>
In-Reply-To: <20181108163659.19535-1-kyle.roeschley@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:805:ca::37) To SN6PR04MB5343.namprd04.prod.outlook.com
 (2603:10b6:805:fd::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [130.164.62.249]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR04MB5296;6:VgodGTVCM64AT3isjNFTgARV2skFhMXSKpvnYLkZ6uvBVCUxxBo23qFrIbvAkMF6vPP+keavaZMT02wQHyYfg8E7mYL6N9sMOaKD6bZWeiWM1etl5bS1OKcjsy40iTcJPX4GMJj1DU8IHT75QF+LKQh+t9joyRU7JCCBrClzdYunBGR/C4TzFEWRoLorX3/xj2jMMzp7rH2GE1EJwVH7DxJuBkQJW0/DtYBDsl976SjeUjh0XkosFHG6MOtsBPo0E4fClc5xWBqmLC7c2eojFc5CGcYoqi9Ko2rkziUSXMmqIkpLnGu6dbNubvPk/iHx6hrJFhiE5+9iocEYIMtcyNiD8DO1ZP2GIUq4AupHdeTPiuZHO8/vOtwxgNtPu6+Nq9icjp3BloYSRH8MC57230iocC130NL71qDZTOP2B8pp2U6ArOoW5YwKUvZjC3LdCIr0M/D6/srLTLcr5j2pJQ==;5:F0c2kMb6cYeHu0Ueej1+PUTirVMpHw7gVc+dJ1xo6+4/bzknMjZhSc92d3ovv8A+u87iSRwzzCYIArK1PllfJh50NQt0zK0YppM0Jacra78KM10xGl9sryCa3yxWr2idtioB4UqLU17psSUqOkwTCiyDzO94M3dq1SF4M41ZB2M=;7:Vu9xhfNuRQI88yN9ah05qbBGaiK6+5BZXt9uBpWiaOk2VwHHPhVTN4BvhBFTNUfwAtAQCiPI7TiUhOWzbW+B67wZZZLuabiAOqlr6yv9pznmAyT7f0JQ16iEfN77Hfg8SgV/KGQCLp+qTnRzWz19Kg==
x-ms-office365-filtering-correlation-id: f7097d64-ebc3-44d0-ed87-08d65700c1e8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR04MB5296;
x-ms-traffictypediagnostic: SN6PR04MB5296:
x-microsoft-antispam-prvs: <SN6PR04MB5296DB24B44BE7E2BC47DAF2F7D30@SN6PR04MB5296.namprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231453)(999002)(944501410)(52105112)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:SN6PR04MB5296;BCL:0;PCL:0;RULEID:;SRVR:SN6PR04MB5296;
x-forefront-prvs: 087223B4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(39850400004)(396003)(376002)(346002)(366004)(189003)(199004)(558084003)(3846002)(6116002)(478600001)(386003)(33896004)(14454004)(486006)(476003)(6506007)(186003)(102836004)(11346002)(44832011)(446003)(33716001)(305945005)(66066001)(86362001)(6512007)(9686003)(25786009)(7736002)(2906002)(1076002)(99286004)(52116002)(53936002)(8936002)(81166006)(81156014)(4326008)(6246003)(5660300001)(8676002)(68736007)(33656002)(6436002)(316002)(54906003)(97736004)(106356001)(76176011)(105586002)(6916009)(71190400001)(71200400001)(229853002)(6486002)(256004)(26005)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB5296;H:SN6PR04MB5343.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ni.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 2chKSVtDRidmrh+s0j9vUPQLCmuUyk4FkdesRxeFG1thuDjD2ngSAkahqRNaI/skLz2HMpJs18spkHsdw4kzKBUMCpzzHT98KieP3FFFEez3l3Tf2wUzsc2dZL4/mJpP0uNozE4BplINr8R2eghWabGINZZFjYGFDks7eXRNNsQ7QinBpc4FYRU+wmvzDiJjcNzTWXV0TRA9Ws1I6GYVSoBJQfgrh9T1pr0vJuoSw5FHCfAG3knKzDCVe+NTPECDihCYadrtB5/ezFAPbOA7zFeyRsGz09kY1j6578ffBm8vughWszuskkT/nepcoV1lt/ytlPCjh8jwEPBqw7CaahO+PCdfPjaW7/AWfG7tzlE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <125A1693D3196441AB5FC3EFF6816373@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ni.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7097d64-ebc3-44d0-ed87-08d65700c1e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2018 20:16:48.7610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 87ba1f9a-44cd-43a6-b008-6fdb45a5204e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5296
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=inbound_policy_notspam policy=inbound_policy score=30
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=909 adultscore=0 classifier=spam adjust=30 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1811300172
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

Have you had a chance to check out these patches yet?

--=20
Kyle Roeschley
Software Engineer
National Instruments
