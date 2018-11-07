Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE9AC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 14:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40CB82085B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 14:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JdaUePk3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40CB82085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbeKGXge (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 18:36:34 -0500
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:17049
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726635AbeKGXge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 18:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xIR3SZvoRsMFiKC/IWI7xqkzu/PYtGJQjWyngRmwZU=;
 b=JdaUePk3gHpJCPEXm5z28mhId+BwuUDLRzK5qsNKJuidx5OYT9cz6NGMJh6xeh1Ddl6uh2UXBSTV4brXWDXyl5cuukyeNWarmaIf/x1X9ZM1DoVmgLtroGz5cc9eR2pXJD3qi4OeuyUs/S6XQz1T0yOjEz20nY1sXCEuxP/T7oo=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5588.namprd05.prod.outlook.com (10.167.240.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.12; Wed, 7 Nov 2018 14:05:59 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Wed, 7 Nov 2018
 14:05:59 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Topic: [PATCH 1/4] New netlink command for TID specific configuration
Thread-Index: AQHUajCNBN9RHbfm70WKuA3PqJ0Zo6VEcZyA
Date:   Wed, 7 Nov 2018 14:05:58 +0000
Message-ID: <20181107140552.zfuusbapgqjumoln@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0601CA0045.eurprd06.prod.outlook.com
 (2603:10a6:203:68::31) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5588;6:RR9f74psGC12NWWbU1cKXOWZ0H7OEcEg6lbhmLU060XR/o+WTwpTalJGt1QvdW+x6IGx5R/WtGWAd6+n06RllzzzIkIiS13sX1cdjZCwMfIxtyzALtsNoDuw4PhMBcsuKGrVOkfAjviflSoyXYhM5gW1lDfGQ3jJhalvZo86BZML8BCZrRXSpWxk+/QfI3RNxwmgSq3/C1D2SU6SdaHIFmGAojnAkToSEqAjjRmDuDwRW8ePcy+KsCCDMS3P/bjyWVosO3eu5xn5q/lCwxQE03ShXxBKE0A2Mtm7rC8z/5DgURCo72W1XdIuQtKCZh3Fz7SNmeHhrhnhJ4mICti5vZ7r6j2R124NAOd10J9RxgFgKe4UQ4fbNs1kW2A6F6rrkCw8XNWp3dsvEgwEXqKdeiHI/81UigZg7twcBuDzFe14f8iwmpByKRG2vAzqMBagjCO2R6Z4TFC0UbbnhJHSJQ==;5:FI/lN5O4BgoiCLKL4uspfHoYV0lwM+65Hx3sbpeypEnvfMMSub760WrMEP/YeWzf852pDk6iSzr6X1/3r0RVlNLFuCKYXJPecdrtL71XMJfDwkvb/v0xD1kUlbYmjb9jM72BHp/4tOdkp9QB0LHtxjjslk+hSuK06r+Bl8cKr1Y=;7:GIGpAR9FhW161RCyta8uAwAzPyWpgkQgD1DFhcv2sAnUDqgaB0RYNdIwGdSz2zoseVb3BIYm4n/yqjElEOzCLdZy5uTqWvISTCGIXnFstiFM+CzYEfQqbDJSi0vKbWuHBxobwTmP2Akia2KxO5vWow==
x-ms-office365-filtering-correlation-id: 9b437c78-2ae1-4262-17ce-08d644ba244f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5588;
x-ms-traffictypediagnostic: BL0PR05MB5588:
x-microsoft-antispam-prvs: <BL0PR05MB558873A7082E5740DD1F5B01A3C40@BL0PR05MB5588.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5588;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5588;
x-forefront-prvs: 08497C3D99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(376002)(346002)(39840400004)(396003)(136003)(189003)(199004)(97736004)(6506007)(11346002)(71190400001)(71200400001)(446003)(99286004)(76176011)(6436002)(256004)(54906003)(9686003)(2906002)(6512007)(8936002)(8676002)(81166006)(6486002)(81156014)(4326008)(6916009)(68736007)(5660300001)(476003)(478600001)(2900100001)(229853002)(486006)(316002)(105586002)(1076002)(106356001)(26005)(3716004)(3846002)(6116002)(66066001)(33716001)(25786009)(52116002)(86362001)(33896004)(53936002)(6246003)(305945005)(14454004)(102836004)(7736002)(386003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5588;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: tI9LPx59ehfdT8ydDnbK+gBXqZB/4Io/5DshVaS1LSv3N95uy9xbkfRu9piRnM+yWd88zU036pc7drgHYzbUmFsQQ58yUgI7BAAJzCJjFLIgPosvo+M7dD/BwDpDVEtm/URFI+Et6yH2izZJAZhLyygkkNqpCpVkLCIMduzOmUZQ4nTuJZGwjjf14ahn4ILGThRVMLyhNtXOPEUbzqnmwMz1/qw4yEtE9z3mlQbIl3ooQxA1h6Fe4Hx6yNb04nel9q4F4Qk2iEffojBaFr/kDBCQw8LV6sKCREjPsWrDHMMy6kePohVQj+vay+eGs0vNlTMZ42whVEnO5AqVd+0FETHibHcfpie9l/1mBBY9aKA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C57996E9EE5522498033E3BB2BDA6CD8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b437c78-2ae1-4262-17ce-08d644ba244f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2018 14:05:58.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5588
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
> +
> +       if (info->attrs[NL80211_ATTR_MAC])
> +               peer =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
> +
> +       if (nla_get_flag(attrs[NL80211_ATTR_TID_RETRY_CONFIG])) {

Do we really need this additional flag to indicate retry data ?
Maybe we can simply check retry attrs or even retry data, e.g.:

if (attrs[NL80211_ATTR_TID_RETRY_LONG] ||
    attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
    ...

if ((retry_short > 0) || (retry_long > 0)) {
    ...

> +               if (!wiphy_ext_feature_isset(
> +                               &rdev->wiphy,
> +                               NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG)=
)
> +                       return -EOPNOTSUPP;
> +
> +               if (peer && !wiphy_ext_feature_isset(
> +                               &rdev->wiphy,
> +                               NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG)=
)
> +                       return -EOPNOTSUPP;
> +
> +               if (!rdev->ops->set_data_retry_count ||
> +                   !rdev->wiphy.max_data_retry_count)
> +                       return -EOPNOTSUPP;
> +
> +               ret =3D rdev_set_data_retry_count(rdev, dev, peer, tid_no=
,
> +                                               retry_short, retry_long);
> +       }
> +
> +       return ret;
> +}

Regards,
Sergey
