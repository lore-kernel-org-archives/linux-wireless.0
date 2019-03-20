Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8F2C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED222184D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="WZ2CBnaw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfCTPWO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:22:14 -0400
Received: from mail-eopbgr750079.outbound.protection.outlook.com ([40.107.75.79]:8513
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726123AbfCTPWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 11:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq5b0KX29SOCnU0wuXliZ0w2VgCbAiyHfzHbU8/EQkU=;
 b=WZ2CBnawmvOmm6gJmENAU8RXSVedhIzWDkawexhuy6Mj5x1dNLX/V7xDAJxfE+Ss1B2vhvXXpaDVg8Oy6NotirzbgNHFEO4wm++NkHC6GtKpHYCg02egiIUTYVctWyrIYRrHf7QxJbytYjBxxcUgyQ9s1+UTbpeKIkQutgLjXSY=
Received: from MWHPR05MB2925.namprd05.prod.outlook.com (10.168.245.147) by
 MWHPR05MB3645.namprd05.prod.outlook.com (10.174.251.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Wed, 20 Mar 2019 15:21:56 +0000
Received: from MWHPR05MB2925.namprd05.prod.outlook.com
 ([fe80::3dee:76f0:47b7:eeae]) by MWHPR05MB2925.namprd05.prod.outlook.com
 ([fe80::3dee:76f0:47b7:eeae%6]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 15:21:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4926.namprd05.prod.outlook.com (52.135.117.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 15:21:33 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 15:21:33 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 14/14] qtnfmac: use scan duration param for different scan
 types
Thread-Topic: [PATCH 14/14] qtnfmac: use scan duration param for different
 scan types
Thread-Index: AQHU3wRDm2OHCHUsXE+fPKDxuoHk86YUjtjEgAAUTAA=
Date:   Wed, 20 Mar 2019 15:21:33 +0000
Message-ID: <20190320152127.zdcwpm254ghc2qp2@bars>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
 <20190320100340.14168-15-sergey.matyukevich.os@quantenna.com>
 <87zhppy6xi.fsf@purkki.adurom.net>
In-Reply-To: <87zhppy6xi.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::38) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8ee04d2-622e-434a-7895-08d6ad47bc24
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4926;
x-ms-traffictypediagnostic: SN6PR05MB4926:|MWHPR05MB3645:
x-moderation-data: 3/20/2019 3:21:53 PM
x-microsoft-antispam-prvs: <MWHPR05MB36456EC2BD0DE3EDA8B477FFA3410@MWHPR05MB3645.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(136003)(39850400004)(376002)(346002)(366004)(189003)(199004)(105586002)(316002)(54906003)(25786009)(6486002)(478600001)(256004)(305945005)(8936002)(7736002)(71200400001)(71190400001)(5660300002)(229853002)(86362001)(11346002)(446003)(68736007)(99286004)(76176011)(486006)(186003)(52116002)(66066001)(436003)(107886003)(4326008)(476003)(106356001)(6916009)(6506007)(26005)(386003)(6246003)(102836004)(6346003)(1076003)(81156014)(81166006)(14454004)(97736004)(6116002)(33716001)(3846002)(6512007)(9686003)(6436002)(8676002)(2906002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3645;H:MWHPR05MB2925.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Cfam2Gp8wSPrj+4kz103+NioQ5FHbs1QqE677Ah4mf/yyJAce7U3kxev30utci7KUGYY58Ue/Y3HRZzIjaNk46gJWSRdC9zEgyEWS++1L1uGUicFdTRKY2crYiMSiuNIGVFIdQaNhXSIBQeoiLpNu8Bc+EfZ9dhbTkNp4NbxXDnowvFnjtUEt14X6v+vQvFplnld6IpeRzORb8d/DbDg6V0UeRrnkCs6AVEeO+Q/Cc8c+ayonKjwPPFgvMhclwOMtb6jz7AgiTV3HbGC7QF76HAw7XZrkzDXpmQDttTU71aibwJ/tj0vkqdOlI2HxNwpOOlijdj7dsc7p8dKz6Qrj2avKKMr3tFJQCEPcLKbokwvAN2WZQ5aZ5/kgXMXR896yLcmByaNmBJHn5wLkXEXusLdaxAPo5HaeLCfd5cO95s=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <497176569E6CCD4B85C18B022BA63821@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ee04d2-622e-434a-7895-08d6ad47bc24
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 15:21:56.3483
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3645
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> >
> > Use scan duration param for both active and passive scan dwell times.
> > Document what different types of dwell times are used for. Explicitly
> > specify that if unset, automatic selection by device firmware
> > will be used.
> >
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> > ---
> >  drivers/net/wireless/quantenna/qtnfmac/commands.c | 49 +++++++++++++++=
+++-----
> >  drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 ++++-
> >  2 files changed, 49 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/driver=
s/net/wireless/quantenna/qtnfmac/commands.c
> > index 62edddb8551e..e58495403dde 100644
> > --- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
> > +++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
> > @@ -11,6 +11,13 @@
> >  #include "bus.h"
> >  #include "commands.h"
> >
> > +#define QTNF_SCAN_TIME_AUTO  0
> > +
> > +/* Let device itself to select best values for current conditions */
> > +#define QTNF_SCAN_DWELL_ACTIVE_DEFAULT               QTNF_SCAN_TIME_AU=
TO
> > +#define QTNF_SCAN_DWELL_PASSIVE_DEFAULT              QTNF_SCAN_TIME_AU=
TO
> > +#define QTNF_SCAN_SAMPLE_DURATION_DEFAULT    QTNF_SCAN_TIME_AUTO
>=20
> These three defines look odd. Why not just use QTNF_SCAN_TIME_AUTO
> directly?

Well, this is to be able to tweak their defaults independently if needed.

Regards,
Sergey
