Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07726C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 04:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D130222A1
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 04:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="gX+dvSzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbfBPELr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 23:11:47 -0500
Received: from mail-eopbgr800079.outbound.protection.outlook.com ([40.107.80.79]:61019
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbfBPELr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 23:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9TXF3CjMuRIKi0NJE/4InowZ+CXytN1G5IJPLqH3mo=;
 b=gX+dvSzu1XSU3P8ZieYmHUCnquF0YKpEifxZkSQlxBNyEdh+MtQoBfwr0Ag0CYTbw+klQlcurjyTDikcxtWxnjK3KbC/SVp2wjfI1IBfpsBtYMWdWbcytJ0T86hl/j4F0zVMH+ljOZW+i5ks56/knD9FYRRNBl6PvFqgfGDgabk=
Received: from MWHPR05MB3248.namprd05.prod.outlook.com (10.173.230.11) by
 MWHPR05MB3422.namprd05.prod.outlook.com (10.174.248.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.11; Sat, 16 Feb 2019 04:11:32 +0000
Received: from MWHPR05MB3248.namprd05.prod.outlook.com
 ([fe80::f58a:c6d2:32dd:3ce6]) by MWHPR05MB3248.namprd05.prod.outlook.com
 ([fe80::f58a:c6d2:32dd:3ce6%4]) with mapi id 15.20.1643.008; Sat, 16 Feb 2019
 04:11:32 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5549.namprd05.prod.outlook.com (52.135.109.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.13; Sat, 16 Feb 2019 04:11:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620%4]) with mapi id 15.20.1643.008; Sat, 16 Feb 2019
 04:11:15 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Srinivas Dasari <dasaris@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sunil Dutt <usdutt@codeaurora.org>,
        Liangwei Dong <liangwei@codeaurora.org>
Subject: Re: [PATCH] cfg80211/nl80211: Offload OWE processing to user space in
 AP mode
Thread-Topic: [PATCH] cfg80211/nl80211: Offload OWE processing to user space
 in AP mode
Thread-Index: AQHUxWLR4i8+x+0ig0Ks5e0mGd0KMqXh0ImA
Date:   Sat, 16 Feb 2019 04:11:15 +0000
Message-ID: <20190216041112.zl2kpec2xu5fykjw@bars>
References: <1550258078-13504-1-git-send-email-dasaris@codeaurora.org>
In-Reply-To: <1550258078-13504-1-git-send-email-dasaris@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:a03:60::30) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d7e582b-7833-4b82-2e8f-08d693c4cafe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605100)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5549;
x-ms-traffictypediagnostic: SN6PR05MB5549:|MWHPR05MB3422:
x-moderation-data: 2/16/2019 4:11:29 AM
x-microsoft-antispam-prvs: <MWHPR05MB34227D0FC0E8FA69909F62B5A3610@MWHPR05MB3422.namprd05.prod.outlook.com>
x-forefront-prvs: 0950706AC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(136003)(39840400004)(346002)(376002)(366004)(199004)(189003)(86362001)(478600001)(25786009)(6436002)(6486002)(1076003)(2906002)(4326008)(66066001)(3846002)(486006)(6116002)(97736004)(436003)(5660300002)(53936002)(11346002)(446003)(476003)(106356001)(105586002)(6512007)(6246003)(9686003)(14454004)(52116002)(71190400001)(71200400001)(6506007)(6916009)(8676002)(386003)(8936002)(256004)(14444005)(81156014)(305945005)(33716001)(186003)(7736002)(68736007)(229853002)(76176011)(102836004)(99286004)(316002)(54906003)(33896004)(81166006)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3422;H:MWHPR05MB3248.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;MWHPR05MB3422;23:QCcZic10ZhzUMvxmAl0j4NkmWrqTIiKs407MM1ejG?=
 =?us-ascii?Q?Z1o3km1UCaSylk1ZHvbnf0lDW6R02yUZdnmSe0KBBOb9BJMi5oMMcntqck1W?=
 =?us-ascii?Q?9t9rOFjRBhXcAs9w7xgc3nPgVqA2fsPPneD98nV2bBFj2SYEVbs9xG++DqWP?=
 =?us-ascii?Q?6NRZmG6d+vc6T9zbJS5cYN4r0g5T9YkvrIifGcfJQPNseyAcxkGGU9+aGoeg?=
 =?us-ascii?Q?/5xv8jNu8WMTCN389hJwBTyazD2Y+/EJECMW1tTQzdMD7tmShsvbXD60xi2e?=
 =?us-ascii?Q?JGiJKJIVfEEXbGuKMJ67Knw8gPh+S9/CLOzwqAcUvRwbk/9+Ra+9kjWjCSF+?=
 =?us-ascii?Q?gb2atTrPu7x5U0Jc51aAIddwpbqRLpjQiIzceQWxpozZNxprDPGi42r/QFO4?=
 =?us-ascii?Q?MC5ZrLHpPg6t1GB7eBHlvFVoEyqzX5T7ladpNRIrq6535+9tQTZ/KQvGiTKN?=
 =?us-ascii?Q?2G/sj2PTOXxJaZS66AT3WcZHxc/0v6lYEsiDjIn/3xT4HLNe9VIRUN+Z//PF?=
 =?us-ascii?Q?r7Nr9Sxeta6tiLtZt94/9lol/OXOWJwfTSNQ86c/pJCcBD2I1zXEkwq7twDc?=
 =?us-ascii?Q?WcAfXi8HnMGyN6GkJ5vQxztccieUwtE76HUKKmXtEzI9PyL971WNgdKcl2rw?=
 =?us-ascii?Q?XDGvdqUZhQQrudR1YM0nbqZeelrtTwPs1OnxUclPg8b6k34ZCpA5JBNkF7hy?=
 =?us-ascii?Q?DArNWsrAWNuewUjzk/YepCe4DQcx/mMgagrW+9x9v5YlEbln9L0ovIZH9znL?=
 =?us-ascii?Q?K2YSZxuPfMpDun77fqFSLpdx22y2xOQVbn4z2opWRbtuoeiyC/k1LPOjHeWk?=
 =?us-ascii?Q?M6SzYW5FOiLYAY6xQdwOmhXrwdqLHMPnlYNBd+j3a1C1wdR6ENoMUOwDXX6G?=
 =?us-ascii?Q?4bG/V7/dn854xkUKlGFCiFJsNVUA7WXWoPfGKgjPr+Jmsj5fCBg+mL+1vXMo?=
 =?us-ascii?Q?6u6f9w3VvQphP0460z7utjRbO4R9ftY3n+/QyZQPA7x+7ItVWfI/w+aX0ei6?=
 =?us-ascii?Q?u+qIvlvKzA8pNtPnoNs6M2wBUClaakDMDLw1sqXPbx7SJmLHyclntrY+qYrS?=
 =?us-ascii?Q?5lDuaJ2Stoi2J/tSoi8Wlqq26uVUPo+ET/gV6F5N49wVxMH4OIqNLjMMkiG0?=
 =?us-ascii?Q?JC5bNUPCX9tb6lA4XvfeupEX0ynKCynaNAguaGbSwU62YvsTTnSt5Ge4VGpf?=
 =?us-ascii?Q?13uXlb3PXTWaX4pRHiWFlUbKM5f2YYU+zbwTCJK0eq9heqf/c6iGrVj1ihES?=
 =?us-ascii?Q?MfpQzo+B2+RC03jL1uKtzAElAjt/uF9yWgzv89vjlGjjbKYSFKRYvs/S6AM0?=
 =?us-ascii?B?UT09?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O+K3+qBMOGe28BURSjwUQJ/4VNfy9hFsMtYnNFeGsZ2vA/3EUP7zmE+BtNRl6OQZiMVdydX0lMO9VGsJFefjQd7AzEV96y6dkFzN+NZ8H3Q9EL+oHLjwh1laxl7A8mUY58ITF3bNEgKUdwX5Z7Kr/Ki/eP6DFcWlQ/Oh40pn3QaXMexD+Vu5/ItOMRjM1wV5aCX0w1Lo06SmFEp/VW8zBYQjLuDm5ZcvdrVHKyEWdFhYdC1k/PySsibAXC28Kc9QZm/t4o47al/HUCPqgtp2exzL5KcrL4YeMf5w5+LcCNqYiVWJMi+ECEKYA87OXtldW8UXXHwT14mdXpTnXW1HvcCYJoDR/KQWNOV/mBDo0+bjZ40cbFyW/saYYAb2OqXRxwiMu1L1I3uFvWBCtLl47X5sjOOs0UazJFsJ6viwEI0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F82EF49A1DA6A4E966B5DA4EB37CD9C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7e582b-7833-4b82-2e8f-08d693c4cafe
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2019 04:11:32.3101
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3422
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Srinivas,

>  include/net/cfg80211.h       | 42 ++++++++++++++++++++++++++
>  include/uapi/linux/nl80211.h |  7 +++++
>  net/wireless/nl80211.c       | 72 ++++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/rdev-ops.h      | 13 ++++++++
>  net/wireless/trace.h         | 38 +++++++++++++++++++++++
>  5 files changed, 172 insertions(+)

...

> +void cfg80211_update_owe_info_event(struct net_device *netdev,
> +                                   struct cfg80211_update_owe_info *owe_=
info,
> +                                   gfp_t gfp)
> +{
> +       struct wiphy *wiphy =3D netdev->ieee80211_ptr->wiphy;
> +       struct cfg80211_registered_device *rdev =3D wiphy_to_rdev(wiphy);
> +       struct sk_buff *msg;
> +       void *hdr;
> +
> +       trace_cfg80211_update_owe_info_event(wiphy, netdev, owe_info);
> +
> +       msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
> +       if (!msg)
> +               return;
> +
> +       hdr =3D nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_UPDATE_OWE_INFO)=
;
> +       if (!hdr)
> +               goto nla_put_failure;
> +
> +       if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> +           nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
> +           nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, owe_info->peer))
> +               goto nla_put_failure;
> +
> +       if (nla_put(msg, NL80211_ATTR_IE, owe_info->ie_len, owe_info->ie)=
)
> +               goto nla_put_failure;

Maybe worth adding sanity check if IE length is non-zero ?


Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
