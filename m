Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40131C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 13:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D16D206B7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 13:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="O8+zmoN6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfDDNdD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 09:33:03 -0400
Received: from mail-eopbgr740078.outbound.protection.outlook.com ([40.107.74.78]:23794
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726269AbfDDNdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 09:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krEZKDAnezyPjEgf3rWaGq6ir146IFxLTl46GJh79+k=;
 b=O8+zmoN6C3URrZms6wykcsRuQH7tN3kJpbUR6wXyNRVClu0mds4X5N/9hy3fWk0XnO5OydzTja/khhUtGhPcVEKlrNoNYM58ck6+6AtGs2+B7gH32Iptx/YVSb/zTIUWAUFqqC10aYfJB7CLhF2E2Ufl2/99Qy2YqlDzEyCSGvk=
Received: from DM6PR05MB6348.namprd05.prod.outlook.com (20.178.224.143) by
 DM6PR05MB4812.namprd05.prod.outlook.com (20.176.111.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.7; Thu, 4 Apr 2019 13:33:00 +0000
Received: from DM6PR05MB6348.namprd05.prod.outlook.com
 ([fe80::f485:e463:a00:e884]) by DM6PR05MB6348.namprd05.prod.outlook.com
 ([fe80::f485:e463:a00:e884%3]) with mapi id 15.20.1771.007; Thu, 4 Apr 2019
 13:33:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4814.namprd05.prod.outlook.com (52.135.116.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.6; Thu, 4 Apr 2019 13:32:42 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1771.007; Thu, 4 Apr 2019
 13:32:42 +0000
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
Subject: Re: [PATCH][next] qtnfmac: replace qtnf_cmd_acl_data_size() with
 struct_size()
Thread-Topic: [PATCH][next] qtnfmac: replace qtnf_cmd_acl_data_size() with
 struct_size()
Thread-Index: AQHU6kVbVDZ121t/CEKyy1UYmGUKFqYsAS+A
Date:   Thu, 4 Apr 2019 13:32:42 +0000
Message-ID: <20190404133234.2uatru2vlw3ntrmv@bars>
References: <20190403170236.GA31637@embeddedor>
In-Reply-To: <20190403170236.GA31637@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::42) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 311b6b1d-26d7-46ff-9b79-08d6b902036d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB4814;
x-ms-traffictypediagnostic: SN6PR05MB4814:|DM6PR05MB4812:
x-moderation-data: 4/4/2019 1:32:58 PM
x-microsoft-antispam-prvs: <DM6PR05MB4812748889CD56BFFE63B856A3500@DM6PR05MB4812.namprd05.prod.outlook.com>
x-forefront-prvs: 0997523C40
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(396003)(39850400004)(346002)(376002)(136003)(51914003)(189003)(199004)(66066001)(436003)(52116002)(2906002)(53936002)(54906003)(76176011)(11346002)(68736007)(446003)(6916009)(486006)(256004)(386003)(186003)(476003)(6506007)(102836004)(6246003)(316002)(6116002)(3846002)(26005)(33716001)(6512007)(99286004)(9686003)(6486002)(8936002)(305945005)(5660300002)(81166006)(71190400001)(229853002)(97736004)(71200400001)(7736002)(14454004)(105586002)(25786009)(81156014)(8676002)(86362001)(1076003)(4326008)(6436002)(478600001)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4812;H:DM6PR05MB6348.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2TMw65H55pyoLAu/8AT3RbjTfxtalgm++u2x4eOBn1HBvMG+6YY2iU64SrfGXUqGicMiXtmgKgsRHQD+n49ZoVrwEyiH6vigzdh7C6V9jC4jeGyKEYoSWm2pqnap8nyFM5SidE+CiOgY7AMDdNcftp9lNg2biYxReOpenJ7XcfoHrO3ZhO4+QDi++Vf/w9DsV8W5gtndBlDZf+Q4ggUXSSKGxPxIK9zHnV1pnj4mtB5/5pTtNhrP+oHIFroSn2uQaB+YwRjQAPOmmYFtixANV44NC9xKo4omZKGyuY+7VKPLGG+9xAH2Ysu35PDVEGeE4xY0mIvH1cPXe2OlBQB+NKf+z3OgvNYYODw6rkRgLzDJNwYZlyetKMhA6OMVdroSOskUQRWir03cmfL4xLnVF1CAVhTVIXkj/U0SPeCr2Fo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69A65985265894408D7C1D2371109492@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 311b6b1d-26d7-46ff-9b79-08d6b902036d
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2019 13:33:00.2196
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4812
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>=20
> struct foo {
>     int stuff;
>     struct boo entry[];
> };
>=20
> size =3D sizeof(struct foo) + count * sizeof(struct boo);
> instance =3D kzalloc(size, GFP_KERNEL)
>=20
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>=20
> size =3D struct_size(instance, entry, count);
>=20
> or
>=20
> instance =3D kzalloc(struct_size(instance, entry, count), GFP_KERNEL)
>=20
> Based on the above, replace qtnf_cmd_acl_data_size() with the
> new struct_size() helper.
>=20
> This code was detected with the help of Coccinelle.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/commands.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)

Hi Gustavo,

Thanks for the patch! By the way, it does not apply cleanly, so it needs
to be rebased on top of the up-to-date wireless-drivers-next tree. Let
me know if you would prefer me to care about rebase. Then I will
add this patch to the upcoming series of qtnfmac fixes.

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
