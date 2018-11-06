Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C09C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE102083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="CcwGX40/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAE102083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbeKFVmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 16:42:22 -0500
Received: from mail-eopbgr680052.outbound.protection.outlook.com ([40.107.68.52]:28902
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726976AbeKFVmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 16:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dly2RDhLoeAuTQHUt8+Rcs7ytiPkZp8j1cGag1iMqxM=;
 b=CcwGX40/FYZyPiJNktHoynHb+GN0V4iwAOxI81PSSiX3Ei8DdfcD78ooFP5PYR8uyPGwAzdUlq6iq+53FrF+01uh5F88UPiOO2k2egCphpPOIw+KCFLCIpihMCj46+yJSqXHGcwyh1ipJcqoLDntYONdpfvLCThAwFwKkrgzHEY=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 12:17:21 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 12:17:21 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Tamizh chelvam <tamizhr@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Topic: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Index: AQHUajCNfhztlx3c70SkOeCvblyRP6VBvB8AgAEdioD//9mOgIAADbUA
Date:   Tue, 6 Nov 2018 12:17:21 +0000
Message-ID: <20181106121713.33h7npfrbbpolwao@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <b833d8c0987e838759dbf00d97d4989a267a10fb.camel@sipsolutions.net>
 <20181106104547.5mnbymn4peuhgng3@bars>
 <50876f6067d109116a841399006aee950d9a2117.camel@sipsolutions.net>
In-Reply-To: <50876f6067d109116a841399006aee950d9a2117.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0018.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::31) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:O2ek45yWBCzc8QeM30CL29ljgo3K4yFmvhV4fktZyTgjRdi28AUuW910WNfYNRJbW968qGU9XkyA3SD7hIUmoxip2Rg++W5cEpPAXDnJ8nZmrVP9zB3Q/7lBYeLD2wJ3FekY0LKBV8+ntHosZYbaI/yMvi5abUKE9vvDntiwQTkfebGu5t3cXccBPD6HfdVGAiUSEdFPayZDTw/GYvQmuTGKgtDTInuY1gJVES0npZ2onrKgmwd0tBvnPNsmU5YQAR1cU5HWVBNxXhdxwNzuvhwwk2E9kVqNBN+/5rVPnpPlDUlsUquqOVT7qFpImYDqfmL+qH3oxZRN1zy4Hj39qdb50BFpWvVSx3O5ppkqgov3yw2zGAav8XO9thdpavwtdKyDQnyOA10z8w9+vuWOffqyBbV24hE9NwDRFSvYPeTrYBzfKAEkkkM8CWuYScTSv5QB+J8saAueOR8iATh+eA==;5:lylQS6MTfdP6kbXXAmsSJhkIo2jto/I0c7HiWbhSoRjmja+4k6tggiZAm57iYU/SOOy7s27ZRXZcSzSuLpbxjSq67eOHU9b1hrAHBZGt0UkAB2Fxc9V4k/wa/JZG/mEtx2RS2eGChpQ2Ap4hwCCxjUmTmkD2eqYOZIElfKpf1Ik=;7:fvu9+hDrKHHbToze/V+poemfeEdqeyeEM96W4fB2seVQu30ubd3pMv35MKJSyRQZc7jC0zsiVoTliE2/Dt82eBVWyoJI15r/QYxH4AESlaH2+lNjKJ3p9nGLif3PhB85OAWo2+Q6YBDZxW+2UYbcgw==
x-ms-office365-filtering-correlation-id: d55bf132-59b5-40b7-cbbd-08d643e1ccf5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB52665E709D52F1130D0CD89CA3CB0@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(366004)(136003)(346002)(396003)(376002)(199004)(189003)(71200400001)(71190400001)(256004)(305945005)(14444005)(5660300001)(25786009)(6916009)(81166006)(81156014)(93886005)(54906003)(106356001)(68736007)(6116002)(3846002)(7736002)(1076002)(2906002)(8676002)(105586002)(66066001)(14454004)(8936002)(86362001)(99286004)(52116002)(316002)(9686003)(6512007)(446003)(11346002)(476003)(4001150100001)(6246003)(97736004)(53936002)(4326008)(33716001)(486006)(6436002)(102836004)(2900100001)(186003)(6506007)(386003)(478600001)(76176011)(33896004)(229853002)(6486002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 38R/nRRZsg3xdSyLDShFwkmfUbD7BBUXXQKNKqzIqdSsKnjZvaGb+s5vZnLE2xVoEgf3oQbfQwur6jpFbN+y2XVh9PxrwfWuYjb2db5wZ1nvCuM/wj8F1V+ZipCYHVvjOex6K/HcJLNE5KsDO1n3xqB5q6+cMBkmN+wGCuECCQwQ6t1fj7SIgmGP2NgUCnChZM/a89cMByZLBuVGYQVkcM0FMv3oQEw53lo97GA9vO4iPGwGTE5nWn+cklj71EMWlLjJwevCqNVfnXg2xVRa9jhm9jfNasAEUnJq0ScC4NFQ6wRG/7Uruuhx4ZxXa3zLJ8jaM5sTu533oevLXIIKGDVaRic4oTmI1RoEY+7sL3I=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71C2188D84C52843AE85414F23568674@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55bf132-59b5-40b7-cbbd-08d643e1ccf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 12:17:21.3793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Nov 06, 2018 at 12:28:11PM +0100, Johannes Berg wrote:
>=20
> WARNING: External email to Quantenna Communications. Please exercise caut=
ion!
>=20
>=20
> Hi,
>=20
> On Tue, 2018-11-06 at 10:45 +0000, Sergey Matyukevich wrote:
> > > On Mon, 2018-10-22 at 23:25 +0530, Tamizh chelvam wrote:
> > > > Add infrastructure for per TID aggregation/retry count configuratio=
ns
> > > > such as retry count and AMPDU aggregation control(disable/enable).
> > > > In some scenario reducing the number of retry count for a specific =
data
> > > > traffic can reduce the latency by proceeding with the next packet
> > > > instead of retrying the same packet more time. This will be useful
> > > > where the next packet can resume the operation without an issue.
> > >
> > > Not sure I understand this, how can you expect to control something o=
n a
> > > per-packet basis using this?
> > >
> > > Sergey, looks like your A-MPDU control is already in here per RA/TID,
> > > and A-MSDU could be added easily?
>=20
> > Thanks for pointing me at this patch series. Indeed, it looks like an
> > exact match for proper RA/TID aware implementation of AMPDU control.
> > AMSDU can be added following the same approach.
> >
>=20
> Great. I guess if you could take a look that'd be nice, and perhaps also
> see if you could actually implement it? Your driver patch seemed to
> imply the firmware only has global control, rather than per RA/TID.
>=20
> Also, do you think A-MPDU length control would be something useful?
> Perhaps that should be instead of enable/disable (since setting length
> to 0 or 1 could easily mean "no A-MPDU")

Hello Johannes,

I will send a follow-up A-MSDU patch after this patch set lands in your tre=
e.
And then qtnfmac driver patches for both A-MPDU/A-MSDU changes.

As for A-MPDU chain length control, I don't think we have any practical
use-case for this feature at the moment. However Ben Greear suggested
one possible use-case: to decrease A-MPDU chain length for voice TID
in order to decrease latency. Anyways, current A-MPDU patches can be
easily adapted to support it if needed.

Regards,
Sergey
