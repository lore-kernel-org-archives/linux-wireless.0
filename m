Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AA9C00319
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 212D120643
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 10:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="s17+Ui5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfB0KMq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 05:12:46 -0500
Received: from mail-eopbgr680086.outbound.protection.outlook.com ([40.107.68.86]:35139
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbfB0KMm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 05:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFeBOkqGuT5tUbF1FWFuAoh6LUHxRkO8hCkyjG1E6OA=;
 b=s17+Ui5E62q3dKVweIF3+sIlWLkkW1kkaP0/L0n8MsUuC5kv1DAdqfGuC7pp/WdRsplgOMGNWdXqW0mNI9D97eEM5rlCkaTT2dTrg94Tx1UXtbk45jle8fRohZSwCcd42cwywSssGpcC+uXPR2GicQt9A1LvIPNiQ4s0Pf/U/dc=
Received: from MWHPR05MB3567.namprd05.prod.outlook.com (10.174.250.158) by
 MWHPR05MB3341.namprd05.prod.outlook.com (10.174.175.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.14; Wed, 27 Feb 2019 10:12:21 +0000
Received: from MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::b8b9:d12a:c574:a4a1]) by MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::b8b9:d12a:c574:a4a1%4]) with mapi id 15.20.1665.012; Wed, 27 Feb 2019
 10:12:21 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4224.namprd05.prod.outlook.com (52.135.67.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.14; Wed, 27 Feb 2019 10:01:54 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066%2]) with mapi id 15.20.1665.012; Wed, 27 Feb 2019
 10:01:54 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 1/9] nl80211: New netlink command for TID specific
 configuration
Thread-Topic: [PATCHv2 1/9] nl80211: New netlink command for TID specific
 configuration
Thread-Index: AQHUynBEzi6NA1QfrEObRNAMptjmEaXyOx6AgAD0aICAAEKCgA==
Date:   Wed, 27 Feb 2019 10:01:53 +0000
Message-ID: <20190227100147.b62xtvl2plsaxiic@bars>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
 <1550813554-11581-2-git-send-email-tamizhr@codeaurora.org>
 <20190226122901.focow4odsbkmv7jn@bars>
 <1be400e2f95b87ca0f9e7144177a9b3e@codeaurora.org>
In-Reply-To: <1be400e2f95b87ca0f9e7144177a9b3e@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::45) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fbbede5-b18a-40b9-e78d-08d69c9a99a1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4224;
x-ms-traffictypediagnostic: SN6PR05MB4224:|MWHPR05MB3341:
x-moderation-data: 2/27/2019 10:02:16 AM
x-microsoft-antispam-prvs: <MWHPR05MB334125598728A15802AB33D3A3740@MWHPR05MB3341.namprd05.prod.outlook.com>
x-forefront-prvs: 0961DF5286
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(396003)(346002)(136003)(39850400004)(366004)(189003)(52314003)(199004)(446003)(436003)(6916009)(14444005)(54906003)(316002)(9686003)(6512007)(53936002)(486006)(26005)(8676002)(6506007)(11346002)(6436002)(102836004)(476003)(386003)(14454004)(5660300002)(93886005)(25786009)(81166006)(478600001)(6116002)(6346003)(3846002)(229853002)(1076003)(81156014)(76176011)(6486002)(186003)(8936002)(2906002)(305945005)(256004)(33716001)(52116002)(4326008)(106356001)(99286004)(105586002)(66066001)(71190400001)(97736004)(71200400001)(6246003)(7736002)(68736007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3341;H:MWHPR05MB3567.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;MWHPR05MB3341;23:cIcGh8R2HSF4gfaUyVQREWAeMscddqPRSAnwzb9LH?=
 =?us-ascii?Q?AHZSio1oMR4IzrTNSgN6JhxmvLwrAKcX1lnWvbSDXBj78OZ+1v9M+vy6DFgh?=
 =?us-ascii?Q?GOZ0BlBv7MPLYchiduSvIRKYSyzVpSc/zy8fqU8uGIyNvoTGUKIfgII8hs+T?=
 =?us-ascii?Q?R/PM4h3YyV0yuq0SZxH7iadxVnU49Mp0aeBzbppbWmqkqnJtENzcXiWbg9Xb?=
 =?us-ascii?Q?Bb5ykWHgwBZImCcLqVwHqTzkTACGbRoWULU3SXyDJLtO7vHXw87NatR8KlCg?=
 =?us-ascii?Q?bkFEbEgq4UQOi6DziNdpbMltcTHRwZm9uGdiygJTA9fqJFUZypDGzvT+vTOi?=
 =?us-ascii?Q?h+ht+MI462A3/Y86ZdQ+/JzZhC6yaw1uFX5fKfaY/ndokpd0vQvDrtjPv1Me?=
 =?us-ascii?Q?SO4tFV4Kg1q/0Hj0dk0+xVLsG6Wn3zLOGIpgfGd3ZjZ4DDHwqXo5K9FGZUq8?=
 =?us-ascii?Q?pNbiPCv8XUnx0SG10BolfcJbXfr6N+SFxjWg6HESiUQxbI+9ofONrL8kvOO0?=
 =?us-ascii?Q?gkWxN/BCuSJ/MI+Es7UxuTlCgWyICKT0fYrlFgcvDxSDuJQRNNZ6bAZaxLJz?=
 =?us-ascii?Q?PUo/NlTqMTFahXHFypzXmFjwnW2ERlUSgAxiR3E7K338yRW0yY2t5y9uTL7y?=
 =?us-ascii?Q?RTGdOg+Nb7xwzuYTiUXq0VTlZjmWaY0OUuNVCGXs99xtF0nJx1JukW8zV4ol?=
 =?us-ascii?Q?hhcmi83ODJXt8DdFt0qIJTsr7xxWyfTPxBGDnNXDpox2aJlldiztboI5Fpx1?=
 =?us-ascii?Q?Z03IHGrv4tAmW8eNMwP0+9xtZ0EheqE5eKaJ+SHufvs1Gmz925f2B7rQloP3?=
 =?us-ascii?Q?JEDO3VurTZN0Q+aWri0LuOwjlvaVP9y6In1HDdSHF1p4L88J/XN0HVRTT6vw?=
 =?us-ascii?Q?9yPDbRr6Tv8io9si/wppZ/fTOwstaBYJaKWb/ZIDCLAl9zGqgk3WgsXVGGUl?=
 =?us-ascii?Q?Th0YL9QOyFx6c2o2YUSl8dbcfdkl/OJCzcHhf6AwWiTvRUcjEb4dny3QV+3h?=
 =?us-ascii?Q?ioNqoT7oXymKktzn6vsQg97lrjF/l+RtagBZer/L7G0myCfnaGuUyuroR7Sr?=
 =?us-ascii?Q?1fsqxngt9g1rIh6x6YciLeNXNcuiHDe85h1Jxs8KEnpgK3OMyN7XHlWOZMqU?=
 =?us-ascii?Q?m2eWz4cTAxEVxoMNxnGH/M4AhKWbE79a37W4HqrGLXmhIdsYe3RvfailB5kP?=
 =?us-ascii?Q?J8JRmwaTYkmUbDbyRy/nYmagdcQKmoZwXhVCpE4sDndGOOJnJ9lo4mpQD5Fu?=
 =?us-ascii?Q?HQwIOm6Kqd45bqQMR8xDoGdP+iJCw/dsKE0IvOuk6RfIx8aCzts5R3hF29FH?=
 =?us-ascii?Q?s2jhfXdVP69CPLvL3sCkqQHi0krF8yYVPspKubd5GYP?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pInlijUbL8uAJPIXYxl/vpAUaFhzwEfpRdz9m758jTwTz8sWDOajYbqW3m+wa5xcdnNEUSFS+bcbBpvf26ULMWdePBh61LiplnAUzbnOGBhtTwRe+cC3VKsX/5f6jJHWTNJSuY6xEaBJfjzptR8pJjTCNXgaFALbyTRUxEfJTFnXk9OzxC55yf9IGDCXSGAlxry7ptczbwaP56q2zCU5hIjk4O6KusY/Ww+Uv6BoVDsys/GWgLiwUiBY5Z2EuS7OXCvini2jCDgpdrrRYHpjuBrhAqqbMpKPLgc1BAIG0WcJe9x8bEDSe6fCqbMpTByj9nRJ1H5cKXtJTiV7UiAvFxq5QqOywxaB6R9xDY5C3CI82Gkx/qjLlDUVOiy1/54OMJj/vAQ/0LxVcrDe7Q29atk09cRxMlqajeEjWPtch5I=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D4AF52C0186F6498A3B5EA9BC65D11C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fbbede5-b18a-40b9-e78d-08d69c9a99a1
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2019 10:12:21.8730
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3341
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tamizh,

> Hi Sergey,
> >=20
> > > Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> > > ---
> > >  include/net/cfg80211.h       |  35 +++++++++++++++
> > >  include/uapi/linux/nl80211.h |  51 ++++++++++++++++++++++
> > >  net/wireless/nl80211.c       | 102
> > > +++++++++++++++++++++++++++++++++++++++++++
> > >  net/wireless/rdev-ops.h      |  11 +++++
> > >  net/wireless/trace.h         |  18 ++++++++
> > >  5 files changed, 217 insertions(+)
> >=20
> > ...
> >=20
> > > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > > index 82d5e1e..352eb4a2 100644
> > > --- a/net/wireless/nl80211.c
> > > +++ b/net/wireless/nl80211.c
> > > @@ -280,6 +280,13 @@ static int validate_ie_attr(const struct nlattr
> > > *attr,
> > >=20
> > > NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
> > >  };
> > >=20
> > > +static const struct nla_policy
> > > +nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] =3D =
{
> > > +       [NL80211_ATTR_TID_CONFIG_TID] =3D NLA_POLICY_MAX(NLA_U8, 7),
> >=20
> > Such a policy permits configuration of per-TID settings, either
> > for per-STA or for all the STAs. However it is not possible to
> > perform configuration for all TIDs at once, e.g. passing -1 value
> > to driver.
> >=20
> > Maybe simplify policy and use .type =3D NLA_U8 ?
> >=20
> > Sanity check, if needed, can be performed by driver or even by
> > firmware.
> >=20
> Sure, we can have like that. And do you feel driver should advertise
> support to perform configuration for all TIDs(like accepting tid -1) ?

Do you think this additional level of granularity is needed ?
IIUC if driver/firmware supports per TID feature configuration,
then can handle all-TIDs configuration as well. Anyway, attempt
for global feature configuration can be rejected on driver
or firmware level if needed.

> > > +       [NL80211_ATTR_TID_CONFIG_NOACK] =3D
> > > +                       NLA_POLICY_MAX(NLA_U8,
> > > NL80211_TID_CONFIG_DISABLE),
> > > +};
> > > +
> > >  const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] =3D {
> > >         [NL80211_ATTR_WIPHY] =3D { .type =3D NLA_U32 },
> > >         [NL80211_ATTR_WIPHY_NAME] =3D { .type =3D NLA_NUL_STRING,
> > > @@ -541,6 +548,8 @@ static int validate_ie_attr(const struct nlattr
> > > *attr,
> > >         [NL80211_ATTR_PEER_MEASUREMENTS] =3D
> > >                 NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
> > >         [NL80211_ATTR_AIRTIME_WEIGHT] =3D NLA_POLICY_MIN(NLA_U16, 1),
> > > +       [NL80211_ATTR_TID_CONFIG] =3D
> > > +
> > > NLA_POLICY_NESTED(nl80211_attr_tid_config_policy),
> > >  };
> >=20
> > ...
> >=20
> > > +static int nl80211_set_tid_config(struct sk_buff *skb,
> > > +                                 struct genl_info *info)
> > > +{
> > > +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0]=
;
> > > +       struct nlattr *attrs[NL80211_ATTR_TID_CONFIG_MAX + 1];
> > > +       struct net_device *dev =3D info->user_ptr[1];
> > > +       struct ieee80211_tid_config *tid_conf;
> > > +       struct nlattr *tid;
> > > +       int conf_idx =3D 0, rem_conf;
> > > +       u32 num_conf =3D 0, size_of_conf;
> > > +       int ret =3D -EINVAL;
> > > +
> > > +       if (!info->attrs[NL80211_ATTR_TID_CONFIG])
> > > +               return -EINVAL;
> > > +
> > > +       if (!rdev->ops->set_tid_config)
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG]=
,
> > > +                           rem_conf)
> > > +               num_conf++;
> > > +
> > > +       size_of_conf =3D sizeof(struct ieee80211_tid_config) +
> > > +               num_conf * sizeof(struct ieee80211_tid_cfg);
> > > +
> > > +       tid_conf =3D kzalloc(size_of_conf, GFP_KERNEL);
> > > +       if (!tid_conf)
> > > +               return -ENOMEM;
> > > +
> > > +       tid_conf->n_tid_conf =3D num_conf;
> > > +
> > > +       if (info->attrs[NL80211_ATTR_MAC])
> > > +               tid_conf->peer =3D
> > > nla_data(info->attrs[NL80211_ATTR_MAC]);
> > > +       else
> > > +               tid_conf->peer =3D NULL;
> > > +
> > > +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG]=
,
> > > +                           rem_conf) {
> > > +               ret =3D nla_parse_nested(attrs,
> > > NL80211_ATTR_TID_CONFIG_MAX, tid,
> > > +                                      NULL, NULL);
> > > +
> > > +               if (ret)
> > > +                       return ret;
> > > +
> > > +               if (!attrs[NL80211_ATTR_TID_CONFIG_TID])
> > > +                       return -EINVAL;
> > > +
> > > +               ret =3D parse_tid_conf(rdev, attrs,
> > > &tid_conf->tid_conf[conf_idx],
> > > +                                    tid_conf->peer);
> > > +               if (ret)
> > > +                       goto bad_tid_conf;
> > > +
> > > +               conf_idx++;
> > > +       }
> > > +
> > > +       return rdev_set_tid_config(rdev, dev, tid_conf);
> >=20
> > What is the ownership rule for tid_conf ? In other words, who is
> > responsible for freeing this structure ?
> >=20
> > Unless I am missing something, in the suggested patches there is no
> > kfree for this structure and all the nested structures (see Tx bitrate
> > patch), neither in cfg80211/mac80211 nor in ath10k.
> >=20
> > As far as I understand, we have two options here. One option is to
> > explicitly specify that ownership is passed to the caller, similar
> > to nl80211_set_reg. Another option is to release memory in this
> > function after driver makes copies of all necessary fields,
> > e.g. see nl80211_set_mac_acl.
> >=20
> Thanks for pointing out, will free it in this function(cfg80211) itself.
> I will make the change and send next patchset.

Great!

Thanks,
Sergey
