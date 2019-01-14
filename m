Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E057CC43612
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1DF020663
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="DVHr1y43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfANJKI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:10:08 -0500
Received: from mail-eopbgr750088.outbound.protection.outlook.com ([40.107.75.88]:1796
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfANJKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZfrzxUneb0rHNHEFZgK2Iqj3z57CeRQst/yLzRU01c=;
 b=DVHr1y43ZSe59jF2TjXPMhZL5ao13iPgTptcaWtV6kVB+AbgcVXLYFqGj3K5Gi3Owp7e1qDksH+9vSS8XWYvR9RT1u75fHIFDk2OtR9Vpwm/7Q4IK9gP/Y0oQqohWNkHn1pV1Iq5xGJPX/UXNQz0MyT6yvrwDnoVKyMHOh+HXZw=
Received: from SN6PR05MB4656.namprd05.prod.outlook.com (52.135.114.202) by
 SN6PR05MB5038.namprd05.prod.outlook.com (20.177.251.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:09:53 +0000
Received: from SN6PR05MB4656.namprd05.prod.outlook.com
 ([fe80::9c5a:8f0:ccf0:70bd]) by SN6PR05MB4656.namprd05.prod.outlook.com
 ([fe80::9c5a:8f0:ccf0:70bd%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:09:53 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5487.namprd05.prod.outlook.com (52.135.111.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.20; Mon, 14 Jan 2019 09:09:38 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:09:38 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Sergey Matyukevich <geomatsi@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: Re: [PATCH] mac80211: allow overriding HT STBC capabilities
Thread-Topic: [PATCH] mac80211: allow overriding HT STBC capabilities
Thread-Index: AQHUp5EuTfeHUvbrZkWlupLD3UZOkaWugpeA
Date:   Mon, 14 Jan 2019 09:09:37 +0000
Message-ID: <20190114090931.n5njhvpugfv3p3u4@bars>
References: <20190108203149.9017-1-geomatsi@gmail.com>
In-Reply-To: <20190108203149.9017-1-geomatsi@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:40::16) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR05MB5038;6:SO/sPay5TW06aHnfgawA3bgRh4cmEYwLoDcdEwObayrdUcygZYLjJYE/OOcl0romBoKrOjrZr8+Dl5OAunZegoummPGVGi7J++NUPLSgCvLNFIPJ5FV4khxZaPm/dfE6n9J8w9MQkHxOuENM4+YpY0IzVUgDnMYKotgSjiacqM+Ug1p7XLq5lZayymBvsS4L7p16wFoLpP44Kn54pWef5pgkgZQUFiV/tBOtmqUON1+eyl7I9kYI8r6FCKktvruUou6o4qbdFPIdXt4epXXEZfPOkcvcrlAXpv5Y3sfbKFEo8QRrLE0ZQMJPv4ZboOwd1KG/NiGw57Pxg66nXhooL+i+ta/W4+VuqrJ3Kcp2LRKwOpgo02KqITwCZqPUda/AsrhpzkqxmuFg7+FZVLxoXTivVCf0dNr2osXq3vwDBYBxCC6wSOIFB7X20rw4jy66vK6nTOdlyN9GJ2CtMXQNrg==;5:LSXR82Z0JKK1Twsi7IA9sKAa0VayZquT6gYP7T58A7447MHIfjnb07HSpS2xSvqojL9RHLjNgF2Y5ldKvuUvJCayqaaLGqWmUHrgX23gp7cb+o9lyNz5jPBBfalgRMDaBH4N1DXwWKQgsAgcsn2FJZQx550fbcvDog54o7yBPWuM9j3TTsbkEw6yA281BXNDifYQ8H+FJah8s6vIX8v0Cw==;7:LdxRxe/DsX58yGYdCIXwDo/WNr5EUX46XJuDhLXTkmvZQdk+pS5XHivJnBu33uQ1WCp9sGJlBmOPDhn9FQ+9c1A6nvOmuZVaOzjTK4Hi98L1rsWPKPE+dwvQLVUZJtsGgXA4y99kaayezsWhcTKqig==
x-ms-office365-filtering-correlation-id: 51b782e9-67d1-46d2-9dd5-08d67a000243
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5487;
x-ms-traffictypediagnostic: SN6PR05MB5487:|SN6PR05MB5038:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:09:51 AM
x-microsoft-antispam-prvs: <SN6PR05MB50382813C6CF77FA6299677DA3800@SN6PR05MB5038.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(189003)(199004)(68736007)(498600001)(256004)(6246003)(5660300001)(305945005)(6916009)(14454004)(6306002)(6512007)(9686003)(7736002)(966005)(81156014)(436003)(11346002)(4744005)(39060400002)(1076003)(53936002)(186003)(8676002)(446003)(81166006)(52116002)(8936002)(71190400001)(71200400001)(6436002)(99286004)(54906003)(6506007)(386003)(86362001)(486006)(106356001)(6486002)(1411001)(26005)(33716001)(229853002)(6116002)(66066001)(476003)(76176011)(97736004)(3846002)(25786009)(102836004)(2906002)(105586002)(4326008)(33896004);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5038;H:SN6PR05MB4656.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fVKKSoODjjD7R1T4pJfWGiS0QNdD7pC/9Uw4UiaiA+UkGHFcmQjRRxuo5tUwJw31gSDK+FsIRr7rQrZwtbGRTnKxsDZO3fCjWL+2D3/FUyS9vbcwXTNsrLrV+TjvzHGvddhdsgSpD8srMt9sbM5hO/stz+Yv+mXth+9k1asOQK2d+uQFh4IsZU2go933di2CagYBqC1EbqXTFMS9r1txEZPMN272r3wNm0a3J456yQoMM31qgnJ+Ip5wHiHIhvfBkXHbi94wjfsjA3fd96ga0oapfCYni2VNT0N8tulz4jQshvh8K9TsU+AmMN4r9w6fZ6fyMN0k+yqRjaYUBoZ29zia5Wf6JNv3xp3tEQ5RkwsmKpQUnbU1Ygf1BOHpACApl7Tc0O3s+VaoK5+DcdjFc8nWSxcgNxHcranhLRWA+L0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3CDD40721BFB4345B125FEB3CE593882@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b782e9-67d1-46d2-9dd5-08d67a000243
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:09:53.4604
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5038
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>=20
> Allow user to override STBC configuration for Rx and Tx spatial streams.
> In practice RX/TX STBC settings can be modified using appropriate
> options in wpa_supplicant configuration file:
>   tx_stbc=3D-1..1
>   rx_stbc=3D-1..3
>=20
> This functionality has been added to wpa_supplicant in commit cdeea70f59d=
0.
>=20
> In FullMAC case these STBC options are passed to drivers by cfg80211
> connect callback in fields of cfg80211_connect_params structure.
> However for mac80211 drivers, e.g. for mac80211_hwsim,
> overrides for STBC settings are ignored.

...

> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> ---
>  net/mac80211/ht.c   | 8 ++++++++
>  net/mac80211/main.c | 2 ++
>  2 files changed, 10 insertions(+)

FWIW, the accompanying RFC patch extending STBC tests in hwsim hostapd test
suite has been posted to hostapd mailing list:

http://lists.infradead.org/pipermail/hostap/2019-January/039274.html

Regards,
Sergey
