Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B51C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 15:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E99320896
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 15:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="e+G7AxcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCYPpr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:45:47 -0400
Received: from mail-eopbgr820043.outbound.protection.outlook.com ([40.107.82.43]:37759
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfCYPpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 11:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMiRz32lPC9WSSOH85L4CY/LUkbbZQllmg93yDAOg/o=;
 b=e+G7AxcJaeY8jSJdeyZosNY+RRYSqPHAIYS+jtEgIJh8NgrraD5G42ISPhv6C8xyx2nQmBAaShUEWl4Mj7qf/3MfioAsQ5eSgXJ6OnUrZRE35b763NWwL2XFqxoLw32BP6cyz0lwyGWCM7/pKda5bG5MpTHw726kkPv5ctuULZA=
Received: from CY4PR05MB3045.namprd05.prod.outlook.com (10.172.161.137) by
 CY4PR05MB3656.namprd05.prod.outlook.com (10.171.249.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.10; Mon, 25 Mar 2019 15:45:33 +0000
Received: from CY4PR05MB3045.namprd05.prod.outlook.com
 ([fe80::519b:3ca:f185:bc53]) by CY4PR05MB3045.namprd05.prod.outlook.com
 ([fe80::519b:3ca:f185:bc53%2]) with mapi id 15.20.1750.010; Mon, 25 Mar 2019
 15:45:33 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5040.namprd05.prod.outlook.com (20.177.252.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Mon, 25 Mar 2019 15:44:49 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1750.014; Mon, 25 Mar 2019
 15:44:49 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [RFC PATCH] mac80211/cfg80211: update bss channel on channel
 switch
Thread-Topic: [RFC PATCH] mac80211/cfg80211: update bss channel on channel
 switch
Thread-Index: AQHU3/l2XQWEB+dp8EKEtVdAAxdJ3KYZKR71gANaRAA=
Date:   Mon, 25 Mar 2019 15:44:49 +0000
Message-ID: <20190325154443.elzp5n6nfngtg5vk@bars>
References: <20190321151915.16826-1-sergey.matyukevich.os@quantenna.com>
 <3d76d0d033609fff4e72448a9fd7d63ad1365cb2.camel@sipsolutions.net>
In-Reply-To: <3d76d0d033609fff4e72448a9fd7d63ad1365cb2.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03041faa-29fa-4d54-1403-08d6b138d06d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5040;
x-ms-traffictypediagnostic: SN6PR05MB5040:|CY4PR05MB3656:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 3/25/2019 3:45:28 PM
x-microsoft-antispam-prvs: <CY4PR05MB365680DB12CA68FC84E399F1A35E0@CY4PR05MB3656.namprd05.prod.outlook.com>
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(366004)(136003)(396003)(346002)(39840400004)(199004)(189003)(54906003)(14444005)(15650500001)(71190400001)(316002)(186003)(66066001)(476003)(71200400001)(97736004)(4326008)(1076003)(5660300002)(105586002)(81166006)(81156014)(102836004)(256004)(25786009)(33716001)(106356001)(26005)(11346002)(486006)(478600001)(86362001)(99286004)(8936002)(386003)(6116002)(2906002)(8676002)(6506007)(7736002)(305945005)(3846002)(9686003)(6436002)(53936002)(446003)(6916009)(6486002)(6512007)(68736007)(436003)(6246003)(229853002)(52116002)(76176011)(14454004)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR05MB3656;H:CY4PR05MB3045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0ujD9wytWbX61vfdYMwgUhpnSVzce/+TSTtWMK6O5AoEQZ7G7bGCeXKrhDnqMF++9E0vEW1HqItU5+qWoejJ8dWtNPPWsrkZxu9t/eb3aIugtV/Osl6YYJ3ZBH5Dv9Qvrkxl6m7bsYWozw9mrf8P8Gsk3BMawGqLTeeoJyb+wmctJ4YzMArxvGJYPE64AG9xELgU+NZmNtw0FKUoS8djIVmg/5dQnMBraxIlCdF+KC9xu1IzHppidp/MLEJxbCTlf10xvY/T9CtCTT7+pZ0rf/6xty0eDB3uUiei1MN0l5qkNEo0IiMaiisWBNVHmBVnftzXoiR++nUBB1g9rf4hnkf2C0uSr0A8cAqWY4PU8unmsGWh9zynfT3uf592EVT6tM4JnpJDaie+j4K7REgDr/T3lOJsDUzUH7kc70xEpZE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74C1AB35A20EA94A849BF769A1C1F4C0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03041faa-29fa-4d54-1403-08d6b138d06d
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2019 15:45:33.8897
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR05MB3656
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > FullMAC STAs have no way to update bss channel after CSA channel switch
> > completion. As a result, user-space tools may provide inconsistent
> > channel info. For instance, consider the following two commands:
> > $ sudo iw dev wlan0 link
> > $ sudo iw dev wlan0 info
> > The latter command gets channel info from the hardware, so most probabl=
y
> > its output will be correct. However the former command gets channel inf=
o
> > from scan cache, so its output will contain outdated channel info.
> > In fact, current bss channel info will not be updated until the
> > next [re-]connect.
> >
> > Note that mac80211 STAs have a workaround for this, but it requires
> > access to internal cfg80211 data, see ieee80211_chswitch_work:
> >
> >       /* XXX: shouldn't really modify cfg80211-owned data! */
> >       ifmgd->associated->channel =3D sdata->csa_chandef.chan;
> >
> > This patch suggests to convert mac80211 workaround to cfg80211 behavior
> > and to update current bss channel in cfg80211_ch_switch_notify.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> >
> > ---
> >
> > This issue has been observed for both qtnfmac and brcmfmac. Fix tested
> > for qtnfmac and iwlwifi, to make sure there is no regression for mac802=
11.
> > However this is not going to be enough to fix brcmfmac behavior as it
> > does not use cfg80211_ch_switch_notify. This issue may also affect
> > ath6kl and mwifiex, but I have no hardware to check.
>=20
> Yeah, I think this makes sense.
>=20
> > +     if (wdev->iftype =3D=3D NL80211_IFTYPE_STATION) {
> > +             if (wdev->current_bss)
> > +                     wdev->current_bss->pub.channel =3D chandef->chan;
> > +     }
>=20
> Maybe do
>=20
>         if (wdev->iftype =3D=3D ... &&
>             !WARN_ON(!wdev->current_bss))
>                 wdev->current_bss->... =3D ...
>=20
> I worry slightly about locking too, since there's no protection on the
> wdev->current_bss pointer here.

Ok, I will add WARN_ON. As for locking, this function is supposed to be
called with wdev->mtx held, see ASSERT_WDEV_LOCK. Do you think this may
not be enough ?=20

I need to check mwifiex more carefully, but other cfg80211_ch_switch_notify
users (mac80211, ath6kl, qtnfmac) seem to do that locking properly.

Regards,
Sergey
