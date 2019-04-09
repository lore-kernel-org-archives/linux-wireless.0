Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B763CC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A77520833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="zR50xb2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfDIIgc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:36:32 -0400
Received: from mail-eopbgr800087.outbound.protection.outlook.com ([40.107.80.87]:20608
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfDIIgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LrZ0DZTrY5EfiazN5GmiLfBwhtqHQiPC9LXrkaJVyI=;
 b=zR50xb2QrwjDbG/cW6/F4EbZHcz/GseqqEVi6fuxAVQHS2+DzwN+dW3iZS0c8j2eNSX5MbPPm81sBissRilTetm8QcydmVKHkertBhOIrOMUwTmHCDDszF7efZLJ3sQ3FRwZOQkUF1p62VEq7CUv3rpJZ09xf47Qjj4BMjGIjM8=
Received: from BYAPR05MB5909.namprd05.prod.outlook.com (20.178.50.154) by
 BYAPR05MB4999.namprd05.prod.outlook.com (20.177.230.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.7; Tue, 9 Apr 2019 08:36:18 +0000
Received: from BYAPR05MB5909.namprd05.prod.outlook.com
 ([fe80::b1c5:c55f:bbd1:fcf3]) by BYAPR05MB5909.namprd05.prod.outlook.com
 ([fe80::b1c5:c55f:bbd1:fcf3%3]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 08:36:18 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5952.namprd05.prod.outlook.com (20.178.6.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.7; Tue, 9 Apr 2019 08:35:57 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Tue, 9 Apr 2019
 08:35:57 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: question: crda timeout in cfg80211
Thread-Topic: question: crda timeout in cfg80211
Thread-Index: AQHU49FUZcg4gTfb8k6NNfp7UvpVxKYytK3mgADiKwA=
Date:   Tue, 9 Apr 2019 08:35:57 +0000
Message-ID: <20190409083551.g27qvcxqhfm2x4uq@bars>
References: <20190326124209.j6tdk5cz47kc6mdj@bars>
 <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
In-Reply-To: <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51372f57-35fc-4afc-3cd3-08d6bcc66316
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB5952;
x-ms-traffictypediagnostic: SN6PR05MB5952:|BYAPR05MB4999:
x-moderation-data: 4/9/2019 8:36:15 AM
x-microsoft-antispam-prvs: <BYAPR05MB4999658008A1DB4A6220A03BA32D0@BYAPR05MB4999.namprd05.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(39850400004)(376002)(366004)(136003)(396003)(199004)(189003)(54906003)(105586002)(1076003)(446003)(11346002)(81156014)(71200400001)(486006)(53936002)(71190400001)(52116002)(25786009)(476003)(14444005)(316002)(436003)(97736004)(8676002)(106356001)(9686003)(6512007)(256004)(186003)(8936002)(26005)(99286004)(6116002)(3846002)(2906002)(81166006)(66066001)(68736007)(14454004)(107886003)(33716001)(6436002)(86362001)(6246003)(76176011)(305945005)(102836004)(229853002)(6506007)(386003)(7736002)(6486002)(478600001)(6916009)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4999;H:BYAPR05MB5909.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4paslHxr/oLHeIQII2ufB5cZxfi5NzYhQbB5qVf1ecP5ZYFWqwxfNAs2dFfrO04tTTKhZZlagpxQRsJR/zhTvbqRDF0PgrzpqS91fBdnhobIxmza7+mgkheSf43TU2uoIr4YfOpW84KaWcC//OkTva47X6RpHhqbzvz8rXQsiWGC3RL7+7Dj8mzTEEF7UOpyIQLCvxtw5wxxMDjnZSnVyIv+i6Ct98rHxlmOxsXKV0QLphgQoDhn5mw2e6bniwgFSOt4qYlRCSVe2WPgFMxfFwDJB6MLSpIsjaHPZu161+K2n6kFikwNb50hCaBC2odOk3mSP7587uQaaEfdz9nH3+xg+jI7FFaoO04/gW2pEvSSwlTclMczH8bgeRIv/C/wwOZ6NYUkjVR4xiUbTmUl/x/GVI0UZjHtrLwEjcSZ/8c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAEF3D2ECC6D074096CEBFC0560BC997@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51372f57-35fc-4afc-3cd3-08d6bcc66316
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 08:36:18.0146
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4999
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > Linux cfg80211 regulatory subsystem uses CRDA timeout to ensure complet=
ion
> > of regulatory updates, performed by user-space software. See call_crda
> > functon in net/wireless/reg.c:
> >
> > static int call_crda(const char *alpha2)
> > {
> >       ...
> >
> >       queue_delayed_work(system_power_efficient_wq,
> >                       &crda_timeout, msecs_to_jiffies(3142));
> >       return 0;
> > }
> >
> > So regulatory update/reset operations shall be completed in 3142 msec.
> > And that includes processing of regulatory notifiers for all the
> > wireless cards in the system.
> >
> > It is not quite clear where this specific timeout value came from.
> > Original commit (a90c7a313a1c5b) doesn't go into details about it.
> >
> > Any ideas where it could come from ?
>=20
> No particular reason. It's just ~pi seconds, and IIRC Luis thought that
> was funny :-)

Indeed, it is PI. I should have known. But instead I spent some time
digging through 802.11 specs :)

> Are you seeing any issues with that?
=20
Well, as I mentioned in my question, regulatory update/reset operations
shall be completed in ~pi seconds for _all_ the wireless cards in the
system. In our case, regulatory reset operation may be fairly costly.
As a result, we end up with recurring reset timeout, when more than one
qtn card is installed in a single pcie host. One option for us is to
optimize regulatory reset operations in firmware.

But what do you think about converting crda_timeout into a per-wiphy
timeout in the case when all wiphy-s are being processed, e.g.
in update_all_wiphy_regulatory.

Regards,
Sergey
