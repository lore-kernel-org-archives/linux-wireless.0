Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8C8C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 772E72085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="cYucINpe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 772E72085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbeKFUVE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 15:21:04 -0500
Received: from mail-eopbgr810057.outbound.protection.outlook.com ([40.107.81.57]:6245
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387556AbeKFUVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 15:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eXaoEYFskO3NBUY/Ot6S0TdoK4b9o9AV1JxLuDJJOc=;
 b=cYucINpeACSmsekvg2xj2gcYauodOqqwFQFO13HnoKx8WqqrxgEZwSi9EJtB8napu7O087EQbpJtw5evaK/DqYvvt8taQXXlpOMibsb4dK8w1whyg7hJUcNjMFzZ31S5C2XuqJGSXdOngG8UlgoAEdutk1tXvaCRwJefDXJ6W4o=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5667.namprd05.prod.outlook.com (10.167.240.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.14; Tue, 6 Nov 2018 10:56:22 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 10:56:22 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Ben Greear <greearb@candelatech.com>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Subject: Re: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Topic: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
Thread-Index: AQHUdRQdP3Y7plTpG06kvM3cndpYM6VBoyiAgAADvQCAACKFgIAAAZkAgADJggA=
Date:   Tue, 6 Nov 2018 10:56:22 +0000
Message-ID: <20181106105615.npimwoh3kgvnx4jn@bars>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
 <34042c1e8020bfb49ab97c9160ab50df044846af.camel@sipsolutions.net>
 <a65739ee-ab89-cf4d-af1b-f86fcc783bac@candelatech.com>
 <97d75b4c-3dc6-d863-c08b-bcc31da635b1@quantenna.com>
 <5BE0CA46.7080705@candelatech.com>
In-Reply-To: <5BE0CA46.7080705@candelatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0049.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::26) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5667;6:dmSFE9qOCZZMKLQ2YXrxAyih9oVfA7TVPl1/nrTscwMk547Pq3mwMOjfsLJiFyS2EaIRe8lFnVPUHThbeMmrTlsxMeSpIVovjSyLwPPLyNU8jQ4NzhvoNgsFCqNPiiWZ7Z7Tvuj8pSWSxNt8141pYQO74rZsF+uwBOGOMjJdqY9gjUOhWaJGtuzz4OQm44YmSxhwcP4E1pSCs//FbfBhvm2PCeq34H2AHq59nFPxy/LUHNwOEGMAim6Urxt1DmdCUL6xCGrigS4C7ZFFWjeeupCsM5T46s6uJXLfnQcvgOAUib6rIUUW0OgJLqwDCxh6egWFsoZGUXVi+c6xwYctkDz8y3jhNbpmHWFfiHrXJl27u6Y/5NK8HlfSZfZ5eTlksdDSUALGJ1NCTMcGTt+3P4ggsDN1r3cygQn+rFjb4qQZSRaNYJKml6ZZd8F7jKy4gYFRswTNufh9rzHvSqFzpA==;5:SIclHc4tSrYAkovFG8jWNMdDbyxrd/CmGjcpc03Mz1O4U5pB/l2Rj446Xt12vUy5/m+pgyDAWZlXn3e9hVRiHwXpCm3b3UcBZmp4DeOrK5BfO5dDlTXtHvzTKMGpThVPm8WPcBWek0cXKv96iQkmZ7ODdHoEPcfK2hOIJQ/nljs=;7:tB4gxnZNxwsQAcwUsioWfpv1dbNf74+2R95itGXE9dyHRMITk5wlptAKThAPYGCcrGFqco1qPk6OfAD6+kj7Ub3ExdsX+MWypVSitYaxJz5/463WwSXWkgk8tgvCU07l+MRLIRBU5dVRcjTWR5hmcQ==
x-ms-office365-filtering-correlation-id: 94984555-197e-4f5d-e00d-08d643d67d3d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5667;
x-ms-traffictypediagnostic: BL0PR05MB5667:
x-microsoft-antispam-prvs: <BL0PR05MB5667B5506142F9EB173C855DA3CB0@BL0PR05MB5667.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(131327999870524);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5667;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5667;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(346002)(136003)(396003)(39850400004)(376002)(53754006)(51914003)(189003)(199004)(6246003)(76176011)(1076002)(14444005)(52116002)(256004)(102836004)(33896004)(71190400001)(71200400001)(86362001)(11346002)(446003)(99286004)(33716001)(486006)(6116002)(476003)(229853002)(54906003)(97736004)(26005)(93886005)(386003)(316002)(6506007)(53546011)(186003)(6436002)(6486002)(5660300001)(6916009)(7736002)(305945005)(68736007)(66066001)(966005)(14454004)(8936002)(2906002)(2900100001)(25786009)(81156014)(3846002)(8676002)(81166006)(6512007)(6306002)(9686003)(53936002)(105586002)(478600001)(106356001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5667;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: tUMQ7mGSJTGVbHeDQDwPUrAEOGTiuFhtf2XkmThF1LiOSHcVcRv+4zlOAL7YqTh7/qf3B1m4P23zQlUEk1kYRMZ9JQ2eden0TqW0mV2SPzST+a9dOCmFfEj2qJNf8oZv4Az/s0VQhnPXp7/Ji1e4/Ha+JS28PbQ/Dd5ZBCeCFtiThLKRAPKBRK+pJeOytShz8IU5rTGBZXQwwEdCDtr7LGRge8TRKGlbQT9ov6C0aBvf3SjffBiALtJXY1132LnqFWKEHe/4bFeyLdeMtQFgtlXG0ihl38pDBp8UTtW7U8bBRp2E5u5FSGl42FyWrrHU/FQ6tkIbJZ41Y4u+z4l8o2lpNTHKbroHDNEbjjlkLFA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A622860E8BA1341B328786C4C73B611@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94984555-197e-4f5d-e00d-08d643d67d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 10:56:22.6115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5667
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On 11/05/2018 02:49 PM, Igor Mitsyanko wrote:
> > On 11/05/2018 12:45 PM, Ben Greear wrote:
> > > >=20
> > > > I see you don't implement it this way in the driver, but wouldn't i=
t
> > > > make more sense to have this as a per-STA (RA) setting? That's real=
ly
> > > > the granularity it can be done on, I think?
> > > >=20
> > > > Arguably even per-RA/TID, though that seems a little excessive?
> > >=20
> > > I like the idea of providing this API per peer/tid.  And, just allow
> > > peer =3D=3D -1, tid =3D=3D -1 or similar to mean 'all' so that you ca=
n still set
> > > the entire device
> > > to one particular setting w/out having to iterate through all peers i=
f you
> > > don't want to iterate...
> >=20
> > Maye I'm wrong, but isn't the setting we're discussing are for the
> > device itself, not for its peers? I mean, disabling AMSDU, AMPDU implie=
s
> > we need to update capabilities advertised in our information elements,
> > which are common for all devices, and it affects both Tx and Rx.
> >=20
> > And per-node/per-TID aggregation settings are a separate configuration
> > option related to rate adaptation on Tx path only..
>=20
> You can advertise your maximum capabilities, but just because you adverti=
se
> that you can do large AMPDU chains doesn't mean you are required to send
> them.
>=20
> So, to advertise stuff, it is per vdev (not per radio), but once you asso=
ciate
> a peer, you might decide to configure it so that you always send no more =
than 5
> frames in an AMPDU chain, for instance.
>=20
> And, you might decide that BE gets up to 32 AMPDU chain, but VI should be=
 limitted to 16
> to decrease latency just a bit.

Hi all,

Thanks for the comments. It turns out that RA/TID-aware approach to
AMPDU configuration has been already posted. Johannes pointed me at
the patch set adding support for TID specific configuration:
https://patchwork.kernel.org/project/linux-wireless/list/?series=3D33855

That patch set enables per-TID and per-STA configuration. AFAICS it
can be easily extended to support AMSDU and even configurable
AMPDU chain depth.

Regards,
Sergey
