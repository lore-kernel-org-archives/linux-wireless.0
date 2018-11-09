Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD1CC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C6220883
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="d4fJRpZU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7C6220883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbeKITFw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:05:52 -0500
Received: from mail-eopbgr810070.outbound.protection.outlook.com ([40.107.81.70]:37696
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727827AbeKITFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 14:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpvnUs1kEZMueCKEa9E3AIolDmvFjDo8fLL6CtKuS/k=;
 b=d4fJRpZUV8mvEsPdcaTdIWsk+UJujLFjH21R0NIdzkVLZYt0U+waNnjnS0rqN0Phrx0RVp3RQDt0C63X+XdvLILXgoVMPMertlV3yQlYBKgByWzaIuyv1j+E4ifYjnuaK1tUlTbNyA6GrEgjnlAH7Pn2jtfEf+UaDPbQj2N+iwU=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5041.namprd05.prod.outlook.com (20.177.241.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.13; Fri, 9 Nov 2018 09:26:03 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%3]) with mapi id 15.20.1339.013; Fri, 9 Nov 2018
 09:26:03 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath10k: Add support to configure TID specific
 configuration
Thread-Topic: [PATCH 4/4] ath10k: Add support to configure TID specific
 configuration
Thread-Index: AQHUajCS+6xeKeRFvUam1XpDiKXrSaVHSA+A
Date:   Fri, 9 Nov 2018 09:26:03 +0000
Message-ID: <20181109092557.ciw457se3ssajl3v@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-5-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-5-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:206:14::16) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5041;6:hvdy7RkbOlNPddB/J7H18eS6qVyBejIMnQoQbJL+pwzFo8Vz8vYGCT2tfQjYPHoern+vzQNp8a4z5K2dCkw4xXigb1/Ota5GS3nSyawYWPcBwAQtdRtUhLVEuakpF+UHfVSXr3v/6093q5jnC+kuvcXu8P9kw4VPxMk6Hlpw9dxuEGiuG5ZW/BaZGCLiOqFUhAjIGo/W4ikTrjRQRoyWeyiCUvlEhU74kz6NPvQX1uAtElbDsodbUS29pgJMeAw/TO0HRRO8jbK6tK5t1qZye1YsR+KAm+RCgyuHs9yu83cWP+TYUUXvq3886R7OAMhtJx6Vt6+dZrPC3wIWmoj8MfhImu5oMlwhQZXKqLRP8996Ew0f3ri1x33rEuuINivt79EqNTzNHLdfoZyExRTIDh3z0wvRHJHT+SwGv+BJ2+gB3sLufbEkxSIHLZdzuAubXwDlQcxEXFD7KkFdR2uQzQ==;5:V7sfMmNIlC1aJKgXBfvhkkdwaJyq23vBZMKX/l8336mQTuShP9hvhKGjLbGT9wP36j7UOKH1dP7nm5Qu5QheUs8uXWdTPbxnGkxBeNvlgeRzX2F1fLVItnEPKfSBdUL+y6VLL7+bGUjCdl0SDPr1zF+Y2A7qkD4vI+GIpzbXvtI=;7:aPhUeLfHDPEx36MRwAohy6NCckZVsB/r0PtY9dtHQ0uur4ZAC8cfgHTvfetnCg1iGLhv56VzUO4Kywz1P5jjp9Yz1ZySdlT8NKRwKT1BYuSBe1p8lH/DRhJExaNp5gPxYo9DOUTZ1s6aZHjuT/lcPw==
x-ms-office365-filtering-correlation-id: 91e35025-e97b-430b-c88c-08d646255e96
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5041;
x-ms-traffictypediagnostic: BL0PR05MB5041:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB50417C350EE2F7A08F66BD15A3C60@BL0PR05MB5041.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231382)(944501410)(52105095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5041;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5041;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(396003)(39850400004)(136003)(366004)(376002)(199004)(189003)(66066001)(305945005)(4326008)(7736002)(14444005)(256004)(229853002)(1076002)(33716001)(99286004)(6116002)(3846002)(102836004)(106356001)(2906002)(105586002)(86362001)(5660300001)(26005)(6506007)(386003)(478600001)(52116002)(76176011)(25786009)(71200400001)(71190400001)(33896004)(6486002)(6512007)(9686003)(53936002)(6436002)(97736004)(6246003)(8936002)(11346002)(446003)(81166006)(68736007)(486006)(476003)(2900100001)(8676002)(81156014)(54906003)(6916009)(14454004)(316002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5041;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 7/zRpUOxlHQf3lGJSZG3DsP7YPHTOMmhuWuH9AZw+Kpx21eOpFO5aeMeOQpTQ1CZi8k4H8uH5dqo79ayvXuBk6+rnyakJVomSIJtPFwQ9jXt7otR7QAjkB+fpQRp4OF32ebUZrt0yw3o69nI3/ScVhSzDw9EOE7Buvt1eUDULfGI6bkHhADBg246jBiLLrJOn02KZanS5wushZ9KE3R9lzF5iuwC+p/Rjjn4sMfaI8X/iarEXCJpwSL10efX62kPPMlC6sae7lhgxIUAoRQy16+akkDCYkO1GWhPsFeJFkXGOwbA4MzRCJrGGYMsUoKnSI9QCuD+xOmpTegBupxnuGCcUPBlNq1CRbOfDdmps5s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F01E0BEA6845B4595E108C3CA6B2309@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e35025-e97b-430b-c88c-08d646255e96
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 09:26:03.8671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5041
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Hello Tamizh,

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.h |  23 ++++
>  drivers/net/wireless/ath/ath10k/mac.c  | 240 +++++++++++++++++++++++++++=
++----
>  drivers/net/wireless/ath/ath10k/wmi.c  |   6 +-
>  drivers/net/wireless/ath/ath10k/wmi.h  |   1 +
>  4 files changed, 245 insertions(+), 25 deletions(-)

...

> +static int ath10k_mac_op_set_tid_conf(struct ieee80211_hw *hw,
> +                                     struct ieee80211_vif *vif,
> +                                     struct ieee80211_sta *sta,
> +                                     struct ieee80211_tid_conf *tid_conf=
,
> +                                     u8 changed)
> +{
> +       int ret;
> +       struct ath10k *ar =3D hw->priv;
> +       struct ath10k_vif *arvif =3D (void *)vif->drv_priv;
> +       struct ath10k_mac_iter_tid_config data =3D {};
> +       struct wmi_per_peer_per_tid_cfg_arg arg =3D {};
> +       struct ath10k_sta *arsta;
> +
> +       if (!(changed & TID_RETRY_CONF_CHANGED) &&
> +           !(changed & TID_AGGR_CONF_CHANGED))
> +               return 0;
> +
> +       mutex_lock(&ar->conf_mutex);
> +       arg.vdev_id =3D arvif->vdev_id;
> +       arg.tid =3D tid_conf->tid;
> +
> +       if (sta) {
> +               arsta =3D (struct ath10k_sta *)sta->drv_priv;
> +               ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
> +
> +               if (changed & TID_RETRY_CONF_CHANGED) {
> +                       if (tid_conf->retry_long =3D=3D
> +                           arsta->retry_count[arg.tid]) {
> +                               ret =3D 0;
> +                               goto exit;
> +                       }
> +
> +                       if (tid_conf->retry_long =3D=3D -1) {
> +                               if (arvif->retry_count[arg.tid])
> +                                       arg.retry_count =3D
> +                                               arvif->retry_count[arg.ti=
d];
> +                               else
> +                                       arg.retry_count =3D
> +                                               ATH10K_MAX_RETRY_COUNT;
> +                       } else {
> +                               arg.retry_count =3D tid_conf->retry_long;
> +                       }
> +               }
> +               if (changed & TID_AGGR_CONF_CHANGED) {
> +                       if (tid_conf->aggr)
> +                               arg.aggr_control =3D
> +                                       WMI_TID_CONFIG_AGGR_CONTROL_ENABL=
E;
> +                       else
> +                               arg.aggr_control =3D
> +                                       WMI_TID_CONFIG_AGGR_CONTROL_DISAB=
LE;
> +               }
> +
> +               ret =3D ath10k_wmi_set_per_peer_per_tid_cfg(ar, &arg);
> +               if (!ret) {
> +                       /* Store the configured parameters in success cas=
e */
> +                       if (changed & TID_RETRY_CONF_CHANGED)
> +                               arsta->retry_count[arg.tid] =3D
> +                                                       tid_conf->retry_l=
ong;
> +                       if (changed & TID_AGGR_CONF_CHANGED)
> +                               arsta->aggr_ctrl[arg.tid] =3D arg.aggr_co=
ntrol;
> +               }
> +
> +               goto exit;
> +       }
> +
> +       ret =3D 0;
> +
> +       if (changed & TID_RETRY_CONF_CHANGED)
> +               arvif->retry_count[tid_conf->tid] =3D tid_conf->retry_lon=
g;

Shouldn't it use default ATH10K_MAX_RETRY_COUNT value when
incoming retry_long value is -1 ?

Regards,
Sergey
