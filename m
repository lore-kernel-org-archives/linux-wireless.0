Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF0BC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 14:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7716520674
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 14:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="fLWF7c+C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfDIO4L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:56:11 -0400
Received: from mail-eopbgr770057.outbound.protection.outlook.com ([40.107.77.57]:38238
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbfDIO4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 10:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=macaxM6xnXF7hHV4UNRnWmhS7C415dHGTLKYukT8Mg4=;
 b=fLWF7c+Cj6d9ai9P3/linnzkChuECCSiUplbKJ6wxIsuRtXjIKUZNe1jw5NhNJf5zmT6g8jynpZzlDiMrh/mcu9lcION+Q7gMJWxIFwwtTaDEQtRZoI8EdkbPpqhMebPl5WqI/MDnEArM5NMCOe9jzM1xCo/Lz4DfB+f2/G4i4U=
Received: from BN6PR05MB3316.namprd05.prod.outlook.com (10.174.95.138) by
 BN6PR05MB3395.namprd05.prod.outlook.com (10.174.232.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.11; Tue, 9 Apr 2019 14:55:53 +0000
Received: from BN6PR05MB3316.namprd05.prod.outlook.com
 ([fe80::7d2a:b068:5adf:c0f0]) by BN6PR05MB3316.namprd05.prod.outlook.com
 ([fe80::7d2a:b068:5adf:c0f0%5]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 14:55:52 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5741.namprd05.prod.outlook.com (20.177.253.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.10; Tue, 9 Apr 2019 14:55:22 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 14:55:22 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] mac80211: fix RX STBC override byte order
Thread-Topic: [PATCH v2] mac80211: fix RX STBC override byte order
Thread-Index: AQHU7s1ebtIe+sn5a0S1n9HeZVFkeqYz6uEA
Date:   Tue, 9 Apr 2019 14:55:22 +0000
Message-ID: <20190409145515.kq54n3ca3qukw6du@bars>
References: <20190409121120.7962-1-johannes@sipsolutions.net>
In-Reply-To: <20190409121120.7962-1-johannes@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56280b2c-c5c3-413c-2334-08d6bcfb63ca
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5741;
x-ms-traffictypediagnostic: SN6PR05MB5741:|BN6PR05MB3395:
x-moderation-data: 4/9/2019 2:55:51 PM
x-microsoft-antispam-prvs: <BN6PR05MB33951E9A1D1C738404617AA6A32D0@BN6PR05MB3395.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(346002)(376002)(39850400004)(366004)(136003)(189003)(199004)(436003)(6116002)(305945005)(3846002)(14454004)(7736002)(478600001)(4326008)(53936002)(1076003)(446003)(14444005)(86362001)(476003)(71200400001)(25786009)(486006)(256004)(2906002)(71190400001)(11346002)(316002)(76176011)(52116002)(6916009)(6486002)(6506007)(26005)(186003)(81156014)(6436002)(81166006)(8676002)(5660300002)(386003)(105586002)(33716001)(9686003)(6512007)(8936002)(229853002)(6246003)(99286004)(66066001)(97736004)(68736007)(106356001)(54906003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR05MB3395;H:BN6PR05MB3316.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Dxt0a9+vM2jJpc+GuODm0WCktWOTCnhT3DohdBetjdi91BR3JpJimDyIR1Mi80CN+CYSiKKcPtRnjhWYlPFYWSkxeJCyRrEyCcuNneNED8gIPrjd2O6it5plLR4/GTXtx4yST64i9Tkyd9DdlhnsuLB1IEjl1xwhoDz11xbRccYWSW8IppLaA/5pbtgqzdBgb/nSAZ1cibP2blJhANiuy5itAzziVtK+PUmtWrXPHar9qvb0HUmk7J53xlHd5bbPEraySd0bbnagYl7GTDh8g8ajP90i3W9YAjFjEgbjgbwMw3j8fZtciEStRgzh09VhnpGUn7A5GeGEZZDL7FBQmInAi62X7CO15WApbhCbUv5HcgdHrUJ5RjT8iovZQAlgW6+Mr8Lfs4iLrnbSeWCjDslXuBrUNIxfNjPXTCuRm48=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7CF6801CA65A574BA68937997A287AAD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56280b2c-c5c3-413c-2334-08d6bcfb63ca
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 14:55:52.9697
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3395
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> The original patch neglected to take byte order conversions
> into account, fix that.
>=20
> Fixes: d9bb410888ce ("mac80211: allow overriding HT STBC capabilities")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ht.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index e03c46ac8e4d..c62101857b9b 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -112,8 +112,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211=
_sub_if_data *sdata,
>                              IEEE80211_HT_CAP_TX_STBC);
>=20
>         /* Allow user to configure RX STBC bits */
> -       if (ht_capa_mask->cap_info & IEEE80211_HT_CAP_RX_STBC)
> -               ht_cap->cap |=3D ht_capa->cap_info & IEEE80211_HT_CAP_RX_=
STBC;
> +       if (ht_capa_mask->cap_info & cpu_to_le16(IEEE80211_HT_CAP_RX_STBC=
))
> +               ht_cap->cap |=3D le16_to_cpu(ht_capa->cap_info) &
> +                                       IEEE80211_HT_CAP_RX_STBC;
>=20
>         /* Allow user to decrease AMPDU factor */
>         if (ht_capa_mask->ampdu_params_info &

Thanks for fixing this!

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
