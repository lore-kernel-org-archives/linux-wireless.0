Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789ECC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E0F32077C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="HeGUpLB4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E0F32077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbeJHVIO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:08:14 -0400
Received: from mail-eopbgr710067.outbound.protection.outlook.com ([40.107.71.67]:47089
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbeJHVIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYLm28gIGsewtcWrn53nf9eTSc+Rv/zuAex8CRgsPYA=;
 b=HeGUpLB4zbe+9D6n672A66HcLDXdg+x/0OIhrAEOEnwciOwaNBu4WU8EsmiptONZa5c7u/Rxpnl0hPrA/DZY7eh111XJ2rGH9oga7Y41SOerttCu7HtixgNbiDVMv0eDjdEFBqk/jRzo6jck/F20mu3TGEmoC6+cu/JWAHR6yzY=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4038.namprd05.prod.outlook.com (52.135.199.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.20; Mon, 8 Oct 2018 13:56:21 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 13:56:21 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Joel Fernandes <joelaf@google.com>
CC:     Cody Schuffelen <schuffelen@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation
 device
Thread-Topic: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation
 device
Thread-Index: AQHUXBznuCllGId5gkCyxGUX3pr0aaUQ6s2AgAA7YoCABD7vAA==
Date:   Mon, 8 Oct 2018 13:56:21 +0000
Message-ID: <20181008135611.otj53psegxtd3hcq@bars>
References: <20181004195906.201895-1-schuffelen@google.com>
 <20181005143323.ezyd2x6x5ymlb7rg@bars>
 <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
In-Reply-To: <CAJWu+ooTRUxj2PAiUkgjTLb+VC9OoBpkj9-_ZoC-oCS3owc5Hg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0044.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::21) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4038;6:pVfu9Qo9lvaT66jtjDxgHfxGPccTVo8SsnxtEOqmZLHnzJ2bLE0/CEsYLmYnvfgP+krfop/7zbuh3bM6N8fZdNVRJ7cW5DyirDyoWZCZGZeKHEnZTFr1fm93fKpJ5Tr4Oh/DihMvwI0Mx1pPENLum1Bm4njZCTPhYtSspTidKjiSz/LgtwZ8HppTnbGvook0gsXg/JvAdnSA/pd4951rYaoMaGcg6Hq5EXnyar2H1CCHeSCoVAyP2mjc18jkQIzEsu/Uq+I1TzjxfPhKv9xWUG2ASbeV+hWp4J90q6KO9YRf92Rnwobt52e1cMEpiHpKtCS0ebWqV9TBKPw6okopr0fN8hw1uljlbHKPPIQYqHFlzg5Go603tbH0r4BFc2DlCsIcA04xdAp9iTdr2tbFYgJtGyiJrHWy1ViasklxgZ/7QjCBcdPSuInkIrFH8RFDqfOJoJvL4CDQyueZKCYkqg==;5:UVnh6zrjk8O5vA+5h3R7CX/JeKi0CNprl0x+yT0hvs/ohGRYMFMsFx1frCOVWOWi3HoSj1t8x5uOpz9qboxjfNwcd/bSps8mygG4thN5aQ0pdPP6pP7zXCV9uvIc2IzPBHB1As0/8bKh3gz0sindcxeW3L0bTTXAZffdHBTLwGU=;7:FuaKXEB46owJYIh8eJneRu/9Gu89wNGoYcQRGbuY6NLDpvIRY7xdiLsIM7fDD2kj0At05ovZNwyHFddvoWYla4jerrATIbB3quJWDagdLpi+2aT7S3SQQS+wivqgq3NS3Rzi/om6b7SKpO3QuefEqrz1PH0bGo/BtyBoUckFbJkzH4WchbTQKFLJKvTtroIHCVL4rjT8gB/mebNyYceRHVirVaGrH0+K+XIGDuc/7fJHLxFJulS0K6vTfb6cXXak
x-ms-office365-filtering-correlation-id: a836ac63-3ce4-40d4-ac9f-08d62d25d3fc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4038;
x-ms-traffictypediagnostic: BYAPR05MB4038:
x-microsoft-antispam-prvs: <BYAPR05MB40387FF7E9571D525FD20970A3E60@BYAPR05MB4038.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(211936372134217);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BYAPR05MB4038;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4038;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(376002)(39840400004)(366004)(396003)(346002)(199004)(189003)(26005)(105586002)(102836004)(476003)(11346002)(106356001)(86362001)(14454004)(68736007)(2900100001)(97736004)(6116002)(6916009)(9686003)(6512007)(66066001)(5250100002)(486006)(446003)(3846002)(1076002)(186003)(71200400001)(71190400001)(316002)(33896004)(478600001)(52116002)(25786009)(386003)(6506007)(966005)(76176011)(54906003)(6306002)(256004)(229853002)(305945005)(7736002)(14444005)(81166006)(8676002)(81156014)(33716001)(8936002)(6246003)(53936002)(2906002)(6436002)(5660300001)(99286004)(6486002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4038;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 76JG9BrAjikipYm7Niplav4uQ032S5zOQT7eAxX9nsF+3JyYleSFryJ0XSGTNFUE0QvDOKTqrOsw4ozKcm1p8qPROopRbP5RLivMJUmYkPkiUISSQNKHI6bs1GfgmgdXDcZvUwnzgrAoj/ESRlDTTVgIUktxB8eZty2Mh4ZtzAUZvoew3traN8ROkhQj0Dnu/yUfm73AnjeGHuEV4lb8zrpnmKN95Pr7BwFIX0q+jA0K0dbrfKdgBahysJiEX3D2KE+b1w7aJ1c960Q86JEtWo2Ii0BktOYw6jrzGju8CZ2qpt7amK2NezfOxLem2AJCK8FGfPKdayAGmGz1+yvZ3GfLL4DocMBzmrWsTKKz35s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C1D1C68552113748A0CD96754870DD5F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a836ac63-3ce4-40d4-ac9f-08d62d25d3fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 13:56:21.4496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4038
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > Hi Cody,
> >
> >>  drivers/net/wireless/Kconfig     |   7 +
> >>  drivers/net/wireless/Makefile    |   2 +
> >>  drivers/net/wireless/virt_wifi.c | 618 ++++++++++++++++++++++++++++++=
+
> >>  3 files changed, 627 insertions(+)
> >>  create mode 100644 drivers/net/wireless/virt_wifi.c
> >
> > I did a quick check of your patch using checkpatch kernel tool,
> > here is a summary of its output:
> >
> > $ ./scripts/checkpatch.pl --strict test.patch
> > ...
> > total: 165 errors, 428 warnings, 9 checks, 634 lines checked
> >
> > Most part of those complaints is about either whitespaces or code
> > idents. I am not sure whether this is a patch itself or email client.
> > So could you please take a look and run checkpatch on your side.
> >
>=20
> Yeah, it could be his email client, weird though because if I pull the
> patch from the kernel.org archive's mbox though, I don't get any
> errors except the MAINTAINERS file thing:
>=20
> wget https://lore.kernel.org/lkml/20181004195906.201895-1-schuffelen@goog=
le.com/raw
> -O /tmp/tmp.patch
> ./scripts/checkpatch.pl --strict /tmp/tmp.patch
>=20
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #167:
> new file mode 100644
>=20
> total: 0 errors, 1 warnings, 0 checks, 634 lines checked

Hi Cody and Joel,

Please ignore my comment regarding the whitespace issues in the patch.
I don't see those issues when downloading the patch via gmail server.
So the issue was on my side.

Regards,
Sergey
