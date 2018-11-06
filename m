Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30685C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C172085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ZNysDTvj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C172085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387799AbeKFTks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:40:48 -0500
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:29600
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387480AbeKFTks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 14:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nidiNeN38OFIVoMCUpPEC/yl7DoUMEGUjVSv3rBJpwU=;
 b=ZNysDTvjnV4mIsQ0A/q0OCGlS34iO1g/p7xYXzTJONxNfgVLID5w60mXhiOsrePZPCqhEb7jU8fVkkdrPcTioWlQE4R3KPnzhI3E0oA1uKKKt3OTNvJe6CQrtsvM8RY01NVi187p9jGXMYQGhVDBWtydQlLEEroiX45KOt6RWK8=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5377.namprd05.prod.outlook.com (10.167.233.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.8; Tue, 6 Nov 2018 10:16:11 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 10:16:11 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Topic: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Index: AQHUajCNBN9RHbfm70WKuA3PqJ0Zo6VCnxEA
Date:   Tue, 6 Nov 2018 10:16:11 +0000
Message-ID: <20181106101601.526ovvmabfqrr7sl@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0102CA0029.eurprd01.prod.exchangelabs.com
 (2603:10a6:206::42) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5377;6:Ghcz8FmKDgRWtTiF1FFUySsMekn71wAm336vWf/oXW1tijeCimxSRj6S8XS2irg+Y3Gp5a9YKEBqiDvly3BUm16cgAXDWkODP88PIIkNi9DCX3MUsY5/2KbgmL7kv7rbI1lJqIpwUWBMVISwSOeCqPmq6HUq+EmEh1+krSMeg0wrXuzH6TqhFVKTJXO8C165NWnvKPdvU9FguGCN+1U0rkw6HAVmtQO0julhJUazetHGlOqg5NGQ10SPs4Xcu2W3aSpck7Cq6ogRMInTR6+CF9J6VgxzEUEFAuinOKDEq9TPv5LeGnTKZIhBoXGuIsPOtC5UaQudxKUVNruT893Ce/v7KLnHyPg2DEKcU40pwjkaSs50gdxrGJbzo6RkC2ZVAl2vYkziAhzcnlOO0Crpi60jcbfLP0JnP7JfoXstg4a5Eqb8/Jxh1UiKoQ+9zU1nYAbe04LudZiOn4PO5zIgnA==;5:ZUaZHWGBWEfEWvzOyVssrkfsSYvCGKtzPFwevyFGQEKXL2tmUxvL5o78cYHiAQZDA8QUbYzqQgn1fY/hQz8UUliDHfyuHNE2FlhCYnW/yLi6H7a9B3WpjJhfJZMONu98XVnJ7zEVlLMWkW3AWHJVsBJrcJzvUTHxtw39uYh3vj8=;7:+s82vHKXujqWRdeE4UcpNrFxxbgl67XO8lnhO6QRbhWZWDXyQRKRESJEM7DUPjKZDPPe8KgyKsiK1Rou9xo9hTtWx2RuuYTedpqWONEKbrUz3gCIdavjZlGFSmQLvG3M1VlZg/VwwFExi25ljFOcLA==
x-ms-office365-filtering-correlation-id: 27898206-032d-46ee-a72a-08d643d0df4a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5377;
x-ms-traffictypediagnostic: BL0PR05MB5377:
x-microsoft-antispam-prvs: <BL0PR05MB53771B28CF56891A9BFF4316A3CB0@BL0PR05MB5377.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(10201501046)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5377;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5377;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(346002)(136003)(366004)(39850400004)(396003)(189003)(199004)(14444005)(1076002)(102836004)(6116002)(3846002)(316002)(54906003)(66066001)(26005)(71200400001)(71190400001)(68736007)(97736004)(86362001)(229853002)(186003)(4326008)(25786009)(5660300001)(6916009)(478600001)(2906002)(11346002)(446003)(107886003)(6512007)(9686003)(6436002)(33716001)(6486002)(256004)(8936002)(99286004)(52116002)(33896004)(2900100001)(8676002)(386003)(6506007)(81166006)(305945005)(105586002)(81156014)(76176011)(7736002)(486006)(14454004)(476003)(6246003)(106356001)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5377;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: F2kPPsimIYl6bWgjL0jGA/PS5a7Fk0mnt4H0XQoEtzv7j+3jrgGItfwqfGiykKSDmp2BFsByxHHY0egjxrOXooc7z4w+vqzK+dwrAMOrcdBm2uNoPKuwdYPcuUCkB1hZ9CIDPY2ayc1Fx34Cm7srJaPjh/2nJbvf6/rwJjoYyoELb4NX1ILC9QP/hU8RMGq7W6zu6c8mfpxTa6u7QVQkKO9/SBsswjLF3b8BMwQ1J3MokHEYTAfcHyH+FQgKZDNT7/DY1EnXc8jWzPKQuLneuJxQHUlZzUDutLG7WQztlwzfX/CBINCdtjSrq6LGcbzJPN68+gXREw6CkxWQn95VHfeSOyHp3thzIZ8FV2CqpSI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2C02070ED8C72479989A08E6F5DDCF7@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27898206-032d-46ee-a72a-08d643d0df4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 10:16:11.8388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5377
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

> Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  include/net/cfg80211.h       |   14 +++++++
>  include/uapi/linux/nl80211.h |   69 +++++++++++++++++++++++++++++++++
>  net/wireless/nl80211.c       |   86 ++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/rdev-ops.h      |   15 ++++++++
>  net/wireless/trace.h         |   27 +++++++++++++
>  5 files changed, 211 insertions(+)

...

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 5801d76..dd024da 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h

...

>  /**
> @@ -4035,6 +4044,9 @@ struct wiphy_iftype_ext_capab {
>   * @txq_limit: configuration of internal TX queue frame limit
>   * @txq_memory_limit: configuration internal TX queue memory limit
>   * @txq_quantum: configuration of internal TX queue scheduler quantum
> + *
> + * @max_data_retry_count: Maximum limit can be configured as retry count
> + *     for a TID.
>   */
>  struct wiphy {
>         /* assign these fields before you register the wiphy */
> @@ -4171,6 +4183,8 @@ struct wiphy {
>         u32 txq_memory_limit;
>         u32 txq_quantum;
>=20
> +       u8 max_data_retry_count;
> +
>         char priv[0] __aligned(NETDEV_ALIGN);
>  };

Could you please clarify why do you define max_data_retry_count instead of
making use of existing wiphy params: retry_short (dot11ShortRetryLimit)
and retry_long (dot11LongRetryLimit) ?

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index d744388..d386ad7 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c

...

> +static int nl80211_set_tid_config(struct sk_buff *skb,
> +                                 struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> +       struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
> +       struct nlattr *tid;
> +       struct net_device *dev =3D info->user_ptr[1];
> +       const char *peer =3D NULL;
> +       u8 tid_no;
> +       int ret =3D -EINVAL, retry_short =3D -1, retry_long =3D -1;
> +
> +       tid =3D info->attrs[NL80211_ATTR_TID_CONFIG];
> +       if (!tid)
> +               return -EINVAL;
> +
> +       ret =3D nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
> +                              nl80211_attr_tid_policy, info->extack);
> +       if (ret)
> +               return ret;
> +
> +       if (!attrs[NL80211_ATTR_TID])
> +               return -EINVAL;
> +
> +       if (attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
> +               retry_short =3D nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_S=
HORT]);
> +               if (!retry_short ||
> +                   retry_short > rdev->wiphy.max_data_retry_count)
> +                       return -EINVAL;
> +       }
> +
> +       if (attrs[NL80211_ATTR_TID_RETRY_LONG]) {
> +               retry_long =3D nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_LO=
NG]);
> +               if (!retry_long ||
> +                   retry_long > rdev->wiphy.max_data_retry_count)
> +                       return -EINVAL;
> +       }
> +
> +       tid_no =3D nla_get_u8(attrs[NL80211_ATTR_TID]);
> +       if (tid_no >=3D IEEE80211_FIRST_TSPEC_TSID)
> +               return -EINVAL;

Not that important, but this tid_no check can be placed after
attrs[NL80211_ATTR_TID].

BTW, some special tid_no value (e.g. (u8)-1) could be used to notify driver
that retry settings should be applied for all the TIDs. IIUC the only
required change would be to modify this tid_no sanity check.

Regards,
Sergey
