Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1403EC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 09:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A96206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 09:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="PWYO1R06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfAIJJ1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 04:09:27 -0500
Received: from mail-eopbgr820082.outbound.protection.outlook.com ([40.107.82.82]:23616
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727828AbfAIJJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 04:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H616TwdzRq30XxQLNXiip4NQCpnxHdcp75KGE7mUC3w=;
 b=PWYO1R06et5TKPPAE8aWniaIArbgG3c3WHbmmAIRkfo/LfWs96KAXnby+enOaAxnzISZ8+Y3Ds0Q1l/2Lt7aHytCoKb/mrqFOcdR618PnmhZO0IBWhvNFu8PR1LMBe1Wh1HB0OTBdT2+ak8LJ7uU0Bf37jJimtXb1Mtro9CqPZk=
Received: from DM6PR05MB6425.namprd05.prod.outlook.com (20.178.225.82) by
 DM6PR05MB4316.namprd05.prod.outlook.com (20.176.78.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.3; Wed, 9 Jan 2019 09:09:17 +0000
Received: from DM6PR05MB6425.namprd05.prod.outlook.com
 ([fe80::384b:fa60:7e89:fef2]) by DM6PR05MB6425.namprd05.prod.outlook.com
 ([fe80::384b:fa60:7e89:fef2%5]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 09:09:17 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4000.namprd05.prod.outlook.com (52.135.66.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.3; Wed, 9 Jan 2019 09:08:57 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 09:08:57 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qtnfmac: use struct_size() in kzalloc()
Thread-Topic: [PATCH] qtnfmac: use struct_size() in kzalloc()
Thread-Index: AQHUp3dSinG4ayjrKEy6t2WoK7Pj3aWmpvGA
Date:   Wed, 9 Jan 2019 09:08:56 +0000
Message-ID: <20190109090850.2yvksr2y2tejizyl@bars>
References: <20190108172632.GA2918@embeddedor>
In-Reply-To: <20190108172632.GA2918@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::41) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB4316;6:RUzT9sE2tXCcKnOVS6iRCXireFcccptqa6HAKOF2nZfU3qosCtRhTo3Q2DJQ1cmfOUCnxKToXnIZfiucRuidDiXfHob6iDR91fpmT38cksqS57GBRe1DcT+wsP+46KgW939o3PGCtku/MuhUJYn1mQS126IW8aVHlHdwnakx2Q3VUptFlJFlXEbs5RNOW5Uc69DDMOhle948SNr1ItMWtUPE+dNNvQJU4yc3z3apl26b/gUnhZ8Y35Sk0Ys/Q/UHdLg3y/zVCLA+aD2XhHkfo5yVG+TAUTP44Bao36OtZiv56PGoSyq26ubcMBVQVyBFLLnbSBDPxbK1dmyqakby6wEZo9H3FXSQfKPcR92e1B4ZAsxTWX5NAi/zLFx0nKSzTEN9OK80IWS4se79a1COoIM/lpFDb4zrI6ERu42SscNiRI8c0feoVOM95EE3r92KQwt3hcAIR1Y7HNidcJANcw==;5:ATcGEhSY9a+7PNcu/seDvWAZSSIwMMTzGfS8IwjtZjgrSp943BTRDnLAzrrHRkysj46TBhvu8rvlg3oT9F3Y8Bcehw64Dg/MwpbHcjzkTbsAqznfaoJZutbxgCle3sTkmGjDxFHwmPMqwRtuE8VP79lcWlKv2TeC3L0swJDCybJ9C8ajMh3TlVSa5eCizQiefFFjSzvlZImheBjyypSAiA==;7:M02Y6zhyHXj3tUPaqFb9APQ18mmndMDGwTfReezQMacwnYeQj6ljc3ilUdQVswEexAYUIQoh16NAlCQo7zyFDfhARJqPdjtdl2pr2pfCeP519sfW0RNxMHfcSh5curZ4lQ1TLWHXr+5w1QiPkX0uOQ==
x-ms-office365-filtering-correlation-id: c6b46677-ba19-4274-c363-08d6761215b1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4000;
x-ms-traffictypediagnostic: SN6PR05MB4000:|DM6PR05MB4316:
x-moderation-data: 1/9/2019 9:09:13 AM
x-microsoft-antispam-prvs: <DM6PR05MB4316E7F0A67383333B8431BDA38B0@DM6PR05MB4316.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(346002)(366004)(376002)(39850400004)(396003)(199004)(189003)(102836004)(186003)(25786009)(486006)(68736007)(105586002)(106356001)(229853002)(2906002)(6246003)(14454004)(386003)(97736004)(53936002)(33896004)(6436002)(9686003)(6512007)(76176011)(26005)(6506007)(33716001)(478600001)(66066001)(256004)(4326008)(6486002)(81156014)(81166006)(8936002)(8676002)(99286004)(476003)(11346002)(52116002)(71190400001)(71200400001)(6916009)(7736002)(305945005)(316002)(54906003)(436003)(3846002)(6116002)(86362001)(446003)(5660300001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4316;H:DM6PR05MB6425.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EJD6K1ledXMJLSd8lK9sk5Jww7FzgxYh2foRZ2UkLpS67UoCER28HRMYOPlV9a1moYOZ5rwdwmiCv8P0NDqmSAQsMuGjLbg/Bs7Gyt9MLvCtcvQSpWP8Oiup8nJGHsv3LSY7OS9PCF5GKFAq81iQzsvaBtTMjmFdMnTQfmQNME47fisyUOXN3Rr6EdVbA+eMtPNMlSqyOge1kmjUcjsz8hOKdsC8cm+KVkxZkz48DlKDWK65ubfTGqyU9DblapHEB36it22xRwTTRqSD7MSvC2uc4UQF61uPGT2UvS5Gp8TYE75Ni5seLTnBZkqz+8qU
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C8E4821E6B4A14B9646A69BF1218532@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b46677-ba19-4274-c363-08d6761215b1
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 09:09:17.1076
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4316
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> One of the more common cases of allocation size calculations is finding t=
he
> size of a structure that has a zero-sized array at the end, along with me=
mory
> for some number of elements for that array. For example:
>=20
> struct foo {
>     int stuff;
>     void *entry[];
> };

...

> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/commands.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/=
net/wireless/quantenna/qtnfmac/commands.c
> index 659e7649fe22..cf386f579060 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
> @@ -914,9 +914,8 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
>         if (WARN_ON(resp->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
>                 return -E2BIG;
>=20
> -       hwinfo->rd =3D kzalloc(sizeof(*hwinfo->rd)
> -                            + sizeof(struct ieee80211_reg_rule)
> -                            * resp->n_reg_rules, GFP_KERNEL);
> +       hwinfo->rd =3D kzalloc(struct_size(hwinfo->rd, reg_rules,
> +                                        resp->n_reg_rules), GFP_KERNEL);
>=20
>         if (!hwinfo->rd)
>                 return -ENOMEM;

Thanks!

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
