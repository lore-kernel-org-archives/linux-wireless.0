Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7E3C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E662020834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nio365.onmicrosoft.com header.i=@nio365.onmicrosoft.com header.b="eUivNh5C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E662020834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ni.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeLCP1S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:27:18 -0500
Received: from mx0b-00010702.pphosted.com ([148.163.158.57]:48310 "EHLO
        mx0b-00010702.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbeLCP1S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 10:27:18 -0500
Received: from pps.filterd (m0098779.ppops.net [127.0.0.1])
        by mx0b-00010702.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wB3FQuvX015453;
        Mon, 3 Dec 2018 09:27:10 -0600
Authentication-Results: ppops.net;
        dkim=pass header.d=nio365.onmicrosoft.com header.s=selector1-ni-com
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2059.outbound.protection.outlook.com [104.47.34.59])
        by mx0b-00010702.pphosted.com with ESMTP id 2p3sgtfjpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Dec 2018 09:27:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nio365.onmicrosoft.com; s=selector1-ni-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kT0rqPhykjMir18dzEL4oIkYpoxqxNiH9FO3o/mE3MY=;
 b=eUivNh5CT0DS7BmfgAUK2xyV8mxl7uMTM6Oj5mLrd3fBQf0fxQwHVpkWmugVRNZ0jXPELp0OmFS2nYNQ/EAxZFYpLUbqxsVLz8Fo74JYleP4kc20+1NUc8KrNgd5Gfc3xJFPUqTFCFS6XEvION2z8oALNdJmLskbu4JlKsH9sVg=
Received: from SN6PR04MB5343.namprd04.prod.outlook.com (20.177.255.221) by
 SN6PR04MB4862.namprd04.prod.outlook.com (52.135.114.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Mon, 3 Dec 2018 15:27:08 +0000
Received: from SN6PR04MB5343.namprd04.prod.outlook.com
 ([fe80::909f:3f84:b758:c843]) by SN6PR04MB5343.namprd04.prod.outlook.com
 ([fe80::909f:3f84:b758:c843%2]) with mapi id 15.20.1382.020; Mon, 3 Dec 2018
 15:27:08 +0000
From:   Kyle Roeschley <kyle.roeschley@ni.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Only use match sets when firmware supports it
Thread-Topic: [PATCH 1/3] ath6kl: Only use match sets when firmware supports
 it
Thread-Index: AQHUd4FLMMXTWwhUh0Odo1dUEe1jaaVof6QAgARZRU+AAHFgAA==
Date:   Mon, 3 Dec 2018 15:27:08 +0000
Message-ID: <20181203152705.GA5671@senary>
References: <20181108163659.19535-1-kyle.roeschley@ni.com>
 <20181130201646.GA16998@senary> <87pnujf1ep.fsf@codeaurora.org>
In-Reply-To: <87pnujf1ep.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0019.namprd02.prod.outlook.com
 (2603:10b6:803:2b::29) To SN6PR04MB5343.namprd04.prod.outlook.com
 (2603:10b6:805:fd::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [130.164.62.249]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR04MB4862;6:SfNjlOAy4wL70Qv+pTPHXo3Os/GWvKHf2QzPHJ3/I0aRGSTVF/myu7u6ShV1t4dHIFNNj74Vz5tsUi3ZpFKa40j6kEX7jQcsfuqu+j6amLsLwgDB1iid76QOHcltqiLFHvnrqiXFwaGLopv3//aTBVPgHq7WdZKA0Cuvw5+2+hVvxf0lUQIXErF4sus8UkZ/P1fKUZgDKrt7NQII8QKIBcl24nbLiSnB9k0v87pTTezUb4+TooW2jgjHmaGYipXJx0diqFhVjXl5okcF4kmIKSKbpWcSydq6ifjpPqRzUqyrrk6WfPYamT48x6HiDYg2lwZFX6ycjvAMRAOjf8oBrJ/pz1FVkqwT9P5joH7niKQu4uaK1hMzZMNGAMi0013xWQnCFEdqtePKAx+xT2bz5Cwks3cEvlgikdua5ejH0kw/nFq1g/TCs8RvfTrM8Um7703J+zrHjCWgRJHNROyyUA==;5:6aPlvkKriYyCgash71r5g3AK5IWrmZiNvHxnyRLDtLubpopH0gI1EPKdXoTFRdVAyRMWGwwCsnEWBbtRLcBgl0CFW8t8r+oFZt+BQqQ+9Hw0LSxVxGDsNXcrKRsKG/lcdDXIEbnkGpcpRipFYIQJ1FIXeze2fK/jGBaOwAH+cXY=;7:FspKXpnSZw59/jC29JWxwM/vZzIDDCcmEyYsEuvncZib2ZYqe9riEMVgAF0v4YWNNIFijhP5kmXyCOdcI8yTRPxdxS7CKY6u5ujjlIbcu/KVAStiTxhbIoymUHHqIjAAOO2tCIpFfrZhfA4tSrM2/w==
x-ms-office365-filtering-correlation-id: b98a8470-304a-43fc-5914-08d65933c974
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR04MB4862;
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB4862DBD8173081C2B245EB5CF7AE0@SN6PR04MB4862.namprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3231455)(999002)(944501493)(52105112)(3002001)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:SN6PR04MB4862;BCL:0;PCL:0;RULEID:;SRVR:SN6PR04MB4862;
x-forefront-prvs: 08756AC3C8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39850400004)(346002)(376002)(396003)(366004)(136003)(51914003)(199004)(189003)(9686003)(11346002)(99286004)(6512007)(76176011)(86362001)(66066001)(316002)(33896004)(305945005)(54906003)(7736002)(256004)(6916009)(6506007)(68736007)(71200400001)(6246003)(8936002)(53936002)(4326008)(5660300001)(102836004)(105586002)(52116002)(106356001)(97736004)(44832011)(486006)(26005)(6436002)(6486002)(14454004)(71190400001)(1076002)(478600001)(81156014)(81166006)(25786009)(446003)(2906002)(33656002)(186003)(8676002)(6116002)(3846002)(33716001)(386003)(476003)(229853002)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4862;H:SN6PR04MB5343.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ni.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1zHgcAzJSRAqsrOjigYQsm0j84J6+oVCcesHRlkBHFwola6CNB59E19o/WAmPogeT86DfZkrzmDNdjUYFfztWr/zRqw6Hgw7bBUd84OxnSkE2qrnrdP979GxpdbFU4M10P68awmdhYEW4Aif69Ilqqd893BocEVxzb79BqkdMZB/h/KsKgSWJIZvqR5bq5KqPQdtM1VjJIiVJLoJWe8Aj9Ya6HXMrPbPjfkeSpGfsOf1Z7Z2tzruXhN9leXJqGgfl72bdrHvS2E395P/4eAHATKY+UV7k9c7yoGnm95xohVg1sAkAB13FeEzpN/RLXvB/OjPZJniUA8Q7VUyyyWp9mIMBR0UAPCSiaP63lha69c=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <905E6AFB84824F4A94A28C88AAB8451A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ni.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98a8470-304a-43fc-5914-08d65933c974
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2018 15:27:08.1035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 87ba1f9a-44cd-43a6-b008-6fdb45a5204e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4862
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-03_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=inbound_policy_notspam policy=inbound_policy score=30
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=30 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812030146
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 03, 2018 at 10:41:02AM +0200, Kalle Valo wrote:
> Kyle Roeschley <kyle.roeschley@ni.com> writes:
>=20
> > Have you had a chance to check out these patches yet?
>=20
> Not yet, I have been busy with something else. BTW, you can check the
> status from patchwork:

Whoops, I should have read the linux-wireless docs more carefully. Thanks f=
or
the clarification, and sorry for the noise.

--=20
Kyle Roeschley
