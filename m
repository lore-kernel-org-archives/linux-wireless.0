Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C834C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E38B7217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="jmlHJPvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbfBZMbY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:31:24 -0500
Received: from mail-eopbgr690050.outbound.protection.outlook.com ([40.107.69.50]:7700
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbfBZMbX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05WvVcCZYpFGVp0nCmhTB7dPHtqTxbSa9JS6A7TJSCo=;
 b=jmlHJPvJwlJMvMkZsWDOjSGw/IA5SIxkCMkw1zebSasOJD11K4ZlewfQkHuD1C7mu/l3SmJXQwEw5qkonQxRlfrX4ZVa9faBsAiv0LBsdPUhsEA4QrFyiz868R536Con9X1wIIFE1PMQWRJUKpXnIKxQfQHzNUTm71jqRFdc6KM=
Received: from BL0PR05MB5617.namprd05.prod.outlook.com (10.167.240.142) by
 BL0PR05MB5364.namprd05.prod.outlook.com (10.167.233.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.6; Tue, 26 Feb 2019 12:31:17 +0000
Received: from BL0PR05MB5617.namprd05.prod.outlook.com
 ([fe80::2832:d27e:e277:fcac]) by BL0PR05MB5617.namprd05.prod.outlook.com
 ([fe80::2832:d27e:e277:fcac%2]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 12:31:17 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4176.namprd05.prod.outlook.com (52.135.67.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.11; Tue, 26 Feb 2019 12:29:08 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066%2]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 12:29:08 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 1/9] nl80211: New netlink command for TID specific
 configuration
Thread-Topic: [PATCHv2 1/9] nl80211: New netlink command for TID specific
 configuration
Thread-Index: AQHUynBEzi6NA1QfrEObRNAMptjmEaXyCNaA
Date:   Tue, 26 Feb 2019 12:29:07 +0000
Message-ID: <20190226122901.focow4odsbkmv7jn@bars>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
 <1550813554-11581-2-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1550813554-11581-2-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0043.prod.exchangelabs.com (2603:10b6:a03:94::20)
 To SN6PR05MB4928.namprd05.prod.outlook.com (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67d8b154-571e-41e2-df56-08d69be60092
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4176;
x-ms-traffictypediagnostic: SN6PR05MB4176:|BL0PR05MB5364:
x-moderation-data: 2/26/2019 12:31:16 PM
x-microsoft-antispam-prvs: <BL0PR05MB53649E8FDAC03742026F42CFA37B0@BL0PR05MB5364.namprd05.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(396003)(376002)(136003)(39840400004)(366004)(189003)(199004)(66066001)(106356001)(54906003)(53936002)(4326008)(316002)(25786009)(105586002)(478600001)(186003)(97736004)(8936002)(9686003)(6512007)(14454004)(86362001)(5660300002)(6916009)(6486002)(68736007)(6246003)(71200400001)(71190400001)(6116002)(3846002)(7736002)(6346003)(99286004)(6436002)(229853002)(1076003)(76176011)(52116002)(2906002)(436003)(486006)(26005)(256004)(102836004)(33716001)(14444005)(6506007)(386003)(476003)(305945005)(446003)(81156014)(81166006)(8676002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5364;H:BL0PR05MB5617.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;BL0PR05MB5364;23:ssnWNPRlBakGSPrcXj2W/V0F1SouDOI+gWRKyZPvZ?=
 =?us-ascii?Q?wQXl0ZiE3Lt8jUr1y4SbxgKVh247EPCBkULIiwj7CpZ98r2Qh4UYeoXTeudf?=
 =?us-ascii?Q?nCCtQjZEnzTLrjTNgzrKCo2oKGuqGHRKqrUMp7Yjnv6hQMvj2at17klMETWW?=
 =?us-ascii?Q?u4zOcvmwKntfOKvMkle+gUyXzxlwQlDGI/5brhfOcJ+YiV+rdapkQ325/l+e?=
 =?us-ascii?Q?IqH09SyArM0nb6YUxp1MnKXz9yCrQh3836iEXVIfNT4XEO1V6FyZR3ug/AD9?=
 =?us-ascii?Q?5bp7G304PKVh5sbXNpexTcWvHBLwR27c8uZqtT8VmL/OT9ZpoEFI1oNO6tRD?=
 =?us-ascii?Q?RN27HKAFJkcqvTzwFBb6GDWs+CE2UVsFsn1owkWNWnRr/u2vH0pMJbIly1K2?=
 =?us-ascii?Q?S3QU4ykt979ypawGDkdPChIjLc1UqqyPaZaHL5caiHs9SwSAZI5fHeB1lgDG?=
 =?us-ascii?Q?4M6dILnmH2Kjd+UFaeyo+pGPbFKLAgCUWeBEx5SkCcJ+HTvgsGKl/+Mlrvp8?=
 =?us-ascii?Q?0ccZfDDxhjYaYawI59tU3/QFVr1boY0/QHjNHbP015XtKmiqjzMANuEBDNP4?=
 =?us-ascii?Q?9SLaqmVSNgOaBq1OrUSoS8XVBERFYMmUCONgx4PTFXtHMUo0I2DGHCao8Xe8?=
 =?us-ascii?Q?FyXpFusUgMu+EYO0fOBKsmtJXyVXN+AsOJHq5XT5mQIfIbaanKFGA6t/1EZx?=
 =?us-ascii?Q?pRyPNjj49NOoxVnKDRuXSOYuJcFlP3Ld+0TmQbDFIhBz90KPuT5jLcv9OqhZ?=
 =?us-ascii?Q?SXRS0a1SNB25+U674lCMn0Bsi81Alo5Rjphpg7AFZi+OqArnHSD0LddIoYbh?=
 =?us-ascii?Q?j6BYNewIh2Y7wf+XwR/SKto21quRD15HWwoyDglwUDtGru53rXDv167YaXJ8?=
 =?us-ascii?Q?0lI2NiFTNr1xJe+889ZEApX9qoffvOCqDSREAQYZnttNiL12CNX7qQA9qUN/?=
 =?us-ascii?Q?RBujqEDro2K4iRDviEhTwJCgO5aafEOT6OhUvpVp0KChydvJOZuCQpYwVPM2?=
 =?us-ascii?Q?y/XCTE3m2px3ST4/kcb//8y0vkKLsaYfYBICd5XpT06vGIENIEn781e4NDaF?=
 =?us-ascii?Q?1Dxj1gKPMqqCw7ypTu7pLFBg8HIDsrlFr653UP1LIHGt8QIXMn9FivMcSSCg?=
 =?us-ascii?Q?aLSIi/K3UGyR49Kwn7rErLihjsJ6x8QaLpMxbbKWLokUk92No/4vXDRjuR/O?=
 =?us-ascii?Q?WQC1cvv9NRT9qmqn0+78O8JV3qMp7M7Q8BIug5ov4jYhlAOhCbjT17tlrY1y?=
 =?us-ascii?Q?ZXcoaZ87tyMFlDJjilC/lOSR0gRtpzkC465gQQc2zq0Z1D3vfG3mugyJ574J?=
 =?us-ascii?B?UT09?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iuh8r9WFNOr8RuGoTymqfdiJMk6E0pbOFcqW1ZjqiyZ5sjb+X5j1KACsgYWnM3KobJzbgRDV+RTlctiXyHn7YKySULpPAaPJb016dqfSk3hIhT2xYlT8cs57TE3kxNkT8sWwaSW/Q/OZpFadsQJnkjyExBQIioin1Yce0qLMOZ2kJ0EuJmpNoyeditPesXW0AvxxzwADXiuh8EhMQlOW4XtNHJ0AwcQV1QnYOaD7deV1dBoHEFqSOKWdWHOXLkJd36eRF08dDdCmnbP8tdC5Laclg3mndkwZ3pj+ubOFupg0oAIclZiFnfRxl90xixEG/SOf2TFndqmrg5jSvepr0nH39pembgUmXPpxBsb3zStRl6Pz3QgAHh0W14diZol3D3hDroYzAwzb8u8C9QinHpIasa40QgiXnFgO2TX+MdM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <50A2951F0876774DB91A1D0A779F8A48@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d8b154-571e-41e2-df56-08d69be60092
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 12:31:17.4868
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5364
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Hello Tamizh,

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  include/net/cfg80211.h       |  35 +++++++++++++++
>  include/uapi/linux/nl80211.h |  51 ++++++++++++++++++++++
>  net/wireless/nl80211.c       | 102 +++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/rdev-ops.h      |  11 +++++
>  net/wireless/trace.h         |  18 ++++++++
>  5 files changed, 217 insertions(+)

...

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 82d5e1e..352eb4a2 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -280,6 +280,13 @@ static int validate_ie_attr(const struct nlattr *att=
r,
>                 NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
>  };
>=20
> +static const struct nla_policy
> +nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] =3D {
> +       [NL80211_ATTR_TID_CONFIG_TID] =3D NLA_POLICY_MAX(NLA_U8, 7),

Such a policy permits configuration of per-TID settings, either
for per-STA or for all the STAs. However it is not possible to
perform configuration for all TIDs at once, e.g. passing -1 value
to driver.

Maybe simplify policy and use .type =3D NLA_U8 ?

Sanity check, if needed, can be performed by driver or even by firmware.

> +       [NL80211_ATTR_TID_CONFIG_NOACK] =3D
> +                       NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE=
),
> +};
> +
>  const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] =3D {
>         [NL80211_ATTR_WIPHY] =3D { .type =3D NLA_U32 },
>         [NL80211_ATTR_WIPHY_NAME] =3D { .type =3D NLA_NUL_STRING,
> @@ -541,6 +548,8 @@ static int validate_ie_attr(const struct nlattr *attr=
,
>         [NL80211_ATTR_PEER_MEASUREMENTS] =3D
>                 NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
>         [NL80211_ATTR_AIRTIME_WEIGHT] =3D NLA_POLICY_MIN(NLA_U16, 1),
> +       [NL80211_ATTR_TID_CONFIG] =3D
> +                       NLA_POLICY_NESTED(nl80211_attr_tid_config_policy)=
,
>  };

...

> +static int nl80211_set_tid_config(struct sk_buff *skb,
> +                                 struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> +       struct nlattr *attrs[NL80211_ATTR_TID_CONFIG_MAX + 1];
> +       struct net_device *dev =3D info->user_ptr[1];
> +       struct ieee80211_tid_config *tid_conf;
> +       struct nlattr *tid;
> +       int conf_idx =3D 0, rem_conf;
> +       u32 num_conf =3D 0, size_of_conf;
> +       int ret =3D -EINVAL;
> +
> +       if (!info->attrs[NL80211_ATTR_TID_CONFIG])
> +               return -EINVAL;
> +
> +       if (!rdev->ops->set_tid_config)
> +               return -EOPNOTSUPP;
> +
> +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
> +                           rem_conf)
> +               num_conf++;
> +
> +       size_of_conf =3D sizeof(struct ieee80211_tid_config) +
> +               num_conf * sizeof(struct ieee80211_tid_cfg);
> +
> +       tid_conf =3D kzalloc(size_of_conf, GFP_KERNEL);
> +       if (!tid_conf)
> +               return -ENOMEM;
> +
> +       tid_conf->n_tid_conf =3D num_conf;
> +
> +       if (info->attrs[NL80211_ATTR_MAC])
> +               tid_conf->peer =3D nla_data(info->attrs[NL80211_ATTR_MAC]=
);
> +       else
> +               tid_conf->peer =3D NULL;
> +
> +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
> +                           rem_conf) {
> +               ret =3D nla_parse_nested(attrs, NL80211_ATTR_TID_CONFIG_M=
AX, tid,
> +                                      NULL, NULL);
> +
> +               if (ret)
> +                       return ret;
> +
> +               if (!attrs[NL80211_ATTR_TID_CONFIG_TID])
> +                       return -EINVAL;
> +
> +               ret =3D parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[c=
onf_idx],
> +                                    tid_conf->peer);
> +               if (ret)
> +                       goto bad_tid_conf;
> +
> +               conf_idx++;
> +       }
> +
> +       return rdev_set_tid_config(rdev, dev, tid_conf);

What is the ownership rule for tid_conf ? In other words, who is
responsible for freeing this structure ?

Unless I am missing something, in the suggested patches there is no
kfree for this structure and all the nested structures (see Tx bitrate
patch), neither in cfg80211/mac80211 nor in ath10k.

As far as I understand, we have two options here. One option is to
explicitly specify that ownership is passed to the caller, similar
to nl80211_set_reg. Another option is to release memory in this
function after driver makes copies of all necessary fields,
e.g. see nl80211_set_mac_acl.

> +
> +bad_tid_conf:
> +       kfree(tid_conf);
> +       return ret;
> +}

Regards,
Sergey
