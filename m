Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	SUBJ_ALL_CAPS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1FFC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 655C92171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="hlSjY9Ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfDLJ1K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:27:10 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:26462
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726838AbfDLJ1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 05:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN7NAgmA6AtdQmWK2L4c8E1mn2HC8FQjL5SX2KI90+o=;
 b=hlSjY9KaEVs8L/HPFg2LOJK7fWBDm4sk4b6r0xZ1dgI43ho+1/7FX/5G2buuhcTQkHMaEiXKguCr6AISOTIYPwAFm7Y/a90mFi33TtQPfD+AmqnLtUPmp5ZRkxuOLCJDRHAmhxE79T9tvoKRZNMn7PFPJVjcSLt2qxuPrfS2zbE=
Received: from BN7PR05MB4402.namprd05.prod.outlook.com (52.133.223.153) by
 BN7PR05MB5922.namprd05.prod.outlook.com (20.176.31.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.8; Fri, 12 Apr 2019 09:27:08 +0000
Received: from BN7PR05MB4402.namprd05.prod.outlook.com
 ([fe80::893a:30d3:519a:c689]) by BN7PR05MB4402.namprd05.prod.outlook.com
 ([fe80::893a:30d3:519a:c689%7]) with mapi id 15.20.1792.007; Fri, 12 Apr 2019
 09:27:08 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4974.namprd05.prod.outlook.com (20.177.249.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.8; Fri, 12 Apr 2019 09:26:29 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Fri, 12 Apr 2019
 09:26:29 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Denis Kenzior <denkenz@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
Thread-Topic: NL80211_SCAN_FLAG_RANDOM_ADDR ?
Thread-Index: AQHU8LZobZQXlUakgkOCoEp4s/HYnaY4QisA
Date:   Fri, 12 Apr 2019 09:26:28 +0000
Message-ID: <20190412092623.46ygdnec3wx26zvd@bars>
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
In-Reply-To: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::26) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 071b321b-31a7-4d36-9d5f-08d6bf28f118
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB4974;
x-ms-traffictypediagnostic: SN6PR05MB4974:|BN7PR05MB5922:
x-ms-exchange-purlcount: 1
x-moderation-data: 4/12/2019 9:27:05 AM
x-microsoft-antispam-prvs: <BN7PR05MB592285D0274F06028BBE5F93A3280@BN7PR05MB5922.namprd05.prod.outlook.com>
x-forefront-prvs: 0005B05917
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(136003)(396003)(39850400004)(376002)(366004)(199004)(189003)(71200400001)(436003)(186003)(102836004)(53936002)(1411001)(476003)(6246003)(256004)(1076003)(11346002)(229853002)(6916009)(486006)(76176011)(446003)(26005)(5660300002)(86362001)(7116003)(386003)(52116002)(478600001)(14454004)(97736004)(6506007)(66066001)(99286004)(316002)(966005)(71190400001)(81166006)(81156014)(25786009)(4326008)(3846002)(6512007)(6306002)(9686003)(33716001)(68736007)(8676002)(105586002)(8936002)(106356001)(6486002)(6116002)(7736002)(6436002)(2906002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR05MB5922;H:BN7PR05MB4402.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s7tYJRn1/pi03u/2SZ6vxByV4PE/y8evBEASaYxUfBuT7N3vxYIRnVxDcXWwlNHOm6YnON5gkiOddZoNRlhoCUVkzm23NVXI7RZPYCees4VlMaC3/PTqeiJ+IlCWn5Eq6PRYMNSYD6+mRsSNJx1B5pTW9cvoqXTBDULfGeUsX3h7yvVzgJBbX+FZueLytkxTGn8AO7yUWVC1gj6So+/15ukaMefxr1cyoKlfmO9qa6MEBb+ZII+Zstp8oqNj5kVOn9syPejBwarZNyqdDJ4g0omPPzcuaCvkQCttOEcvZACinfJ6CQhJ137UQQWGsuYlOVrUb8uQC8ZT0O4WK2FTNoOzM+6VF+wmgbPDk6p+w2tTTFj+qF63kSfNZgjsBoWNx+11R+D3cb5UHJ4DeN5NokTqHru6H3tW3OCECqXUl7c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F68A22597D9A742A9FEA468596EE82B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071b321b-31a7-4d36-9d5f-08d6bf28f118
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2019 09:27:08.0225
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB5922
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I've been poking around at how this flag is used and I noticed this
> check in net/wireless/nl80211.c:
>=20
> nl80211_check_scan_flags()
>=20
>         if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>                 int err;
>=20
>                 if (!(wiphy->features & randomness_flag) ||
>                     (wdev && wdev->current_bss))
>                         return -EOPNOTSUPP;
>=20
>=20
> The above disallows the use of RANDOM_ADDR for scans while connected.
> The nl80211.h uapi header seems to concur:
>=20
>  "@NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports
> using a random MAC address during scan (if the device is unassociated);"
>=20
> However, if I create a P2P Device (in addition to the default STA
> device), the kernel happily lets me scan on the wdev while the STA
> interface is connected.
>=20
> sudo iw phy0 interface add p2p type __p2pdev
> sudo iw wdev 0x2 p2p start
> sudo iw wdev 0x2 scan randomize
>=20
> So the immediate question I have is, should the RANDOM_ADDR flag indeed
> be limited to unassociated STA interfaces?  It would seem the hardware
> is capable randomizing even when connected? Please educate me :)

Hello Denis,

IIUC, this feature could be introduced to support Android Compatibility
Definition Document (CDD). Those documents are available at the
following page: https://source.android.com/compatibility/cdd

For instance, in the latest CDD randomized scan requirements are described
in the section 7.4.2. It looks like current high level nl80211 API follows
those recommendations. Probably it has been implemented with STA use-case
in mind, that is why you can use that flag for P2P connection. But, as
Ben pointed out, actual application of this flag may depend on
implementation in firwmare and hardware.

Regards,
Sergey
