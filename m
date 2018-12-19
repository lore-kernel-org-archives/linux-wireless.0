Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9F5C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E941C20989
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="msaf8zcS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbeLSNWp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:22:45 -0500
Received: from mail-eopbgr710046.outbound.protection.outlook.com ([40.107.71.46]:28448
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728135AbeLSNWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgsUKZqpOqLQWSj2Ufn3EzqVGIuMWdJPLC+G8NxVT+g=;
 b=msaf8zcSZ8w/+FMsZ7wDPK07N0ow3Mkamy18YN1JvxzDoB9hiJzZd6kZf7KbWptEG3NmLHcweuIYBndHno1wOw4v3trS8jTzg5AgQ8xd1gvAV3ORD8NzYdgwO36+30aJBaeUB9cgQBcqjR446gnNnqxpabvJy3pilGW5F94BUGc=
Received: from BL0PR05MB5537.namprd05.prod.outlook.com (10.167.240.22) by
 BL0PR05MB5235.namprd05.prod.outlook.com (20.177.242.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.16; Wed, 19 Dec 2018 13:22:42 +0000
Received: from BL0PR05MB5537.namprd05.prod.outlook.com
 ([fe80::b5f5:2613:581f:571e]) by BL0PR05MB5537.namprd05.prod.outlook.com
 ([fe80::b5f5:2613:581f:571e%4]) with mapi id 15.20.1446.018; Wed, 19 Dec 2018
 13:22:42 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4989.namprd05.prod.outlook.com (20.177.252.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.14; Wed, 19 Dec 2018 13:19:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::b4ca:4557:88a8:be18]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::b4ca:4557:88a8:be18%2]) with mapi id 15.20.1446.015; Wed, 19 Dec 2018
 13:19:56 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment
 by driver
Thread-Topic: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment
 by driver
Thread-Index: AQHUkkZUIMso+I87c0+gOYYV87vJNKWGFn6A
Date:   Wed, 19 Dec 2018 13:19:56 +0000
Message-ID: <20181219131949.srxuohfwyn53qxui@bars>
References: <20181212181249.9039-1-sarada.prasanna.garnayak@intel.com>
In-Reply-To: <20181212181249.9039-1-sarada.prasanna.garnayak@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:a03:100::38) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5235;6:EdZsCM0MGH/1lhSN7faw2PHaBT6gcugyMatmhFtKQWMJFa6DpIaw86YVHBN0jajej8tgnV7GnWP3uPk8HcecRfPzGZyejrKT6CXN/O9iFHUgpCUJuyQiskpMWRZqyoEe8qGG0LX7fCvYVkO8h2d7a75DwG7xxK6Bic4JU9HntSf7uB6Jjh/33B+YnBvecvMMZCy10kob4BAysZWXx9SqPxZf2TUGQF+qWtVQwPzRzmXyY3gqoAq0euNh4yiTdsq8w9/AleuOM/MIz2wcuvrNtaCOPdhVyleSXx7cimZM3WOgft207tSYViMYtBuCi6wqLAVavqFw8JI9DSW3tZ8qY+MH2fHnuPjOaqMqTnGS11SDdEBpcumr1r3RAoaOx3HBp+QF2uZGgBnZb9p0H41xeEHZKs4C4bkP19zQJImoU+oJ3QceXxweTa9Kw/AafP0v/URMfoYn0XvQL42iyPr+qw==;5:+k/HllMKSiLPzDMF9FCm/1w/STxYL6b+ECQ1NKPIQvudt5Z+QPO5tfUHXAgyp64tTpzUA8oHn9Cngmyd2VtCaTvV+6WPSqxjxNpilcPIXaIfbbZpWZKG20uYILA37IeE495U4VOIbfurAWIvTp7CLvpICvM8o3mFa89h85DdAtQ=;7:onkHs1L9RFWYgLV4dYzVHHwet7BK7KLNt9snYeYi4ksgTV7Z0fE0JdaC+D0j5eQKtzRHTI1s3ecfYCyoi2Zw7yIuRj/TYyvOpBbBCIe4+I7+FIG4n/v9jJM+klJoIlhGJWmJFZe9ckiathDVbKjysg==
x-ms-office365-filtering-correlation-id: 2d4bb995-0f98-4b74-af01-08d665b4ab13
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4989;
x-ms-traffictypediagnostic: SN6PR05MB4989:|BL0PR05MB5235:
x-moderation-data: 12/19/2018 1:22:20 PM
x-microsoft-antispam-prvs: <BL0PR05MB52357A9EB86D01B40B78D5A7A3BE0@BL0PR05MB5235.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(999002)(5005020)(6040522)(2401047)(8121501046)(3002001)(10201501046)(3231475)(944501520)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5235;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5235;
x-forefront-prvs: 0891BC3F3D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(366004)(39850400004)(376002)(346002)(396003)(189003)(199004)(11346002)(229853002)(476003)(446003)(486006)(5660300001)(186003)(53936002)(97736004)(6346003)(3846002)(6506007)(86362001)(68736007)(386003)(102836004)(99286004)(66066001)(436003)(26005)(52116002)(6116002)(9686003)(6512007)(81166006)(81156014)(8936002)(256004)(1076003)(14444005)(6436002)(4326008)(6246003)(6486002)(71190400001)(71200400001)(8676002)(316002)(305945005)(7736002)(106356001)(14454004)(25786009)(33716001)(76176011)(6916009)(33896004)(2906002)(105586002)(217873002)(478600001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5235;H:BL0PR05MB5537.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: rxQXzHOLxoqbJqh+c5vtLUaSZSEBzSctyDRzZo5vyxrm0xEqKm2j1zFE/goGY/D4D1x4FecVOkUtvLwrKKhtZJI3F+UKQKV29MKq5iRhOaecomaKL85DK2T7w7h5XPgHcFnBGoAuEy+Vz4IPJ2yvE9WLeqN4pOy/icypIdRQGo2XQmGWw4mB3I3NdNx/ApfMlV2levdsOo61B62kRwHX6VVyTP42fmtlcKQPBZ8brqWIns3PlTKNzDCZxkpH84AELGNi6Sik8QciqI2tpMs4nPE/MpZzCm0AemxPy7mSRL9Jh1fOgyUAVaBG+qqMQB/o
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14C3CBDD3517304191440BC566BBFCC1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4bb995-0f98-4b74-af01-08d665b4ab13
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2018 13:22:42.4322
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5235
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Add support for getting and free association ID if the station
> association ID management handled by the WLAN driver/firmware.
>=20
> Add cfg80211 driver ops and nl80211 API and CMD to request
> the WLAN driver to assign an AID for a station during association
> and release the AID of the station from the WLAN driver/firmware
> station database on disassociation from the AP.
>=20
> Signed-off-by: Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.c=
om>
> ---
>  include/net/cfg80211.h       | 12 +++++++
>  include/uapi/linux/nl80211.h | 11 +++++++
>  net/wireless/nl80211.c       | 74 ++++++++++++++++++++++++++++++++++++++=
++++++
>  net/wireless/rdev-ops.h      | 22 +++++++++++++
>  net/wireless/trace.h         | 36 +++++++++++++++++++++
>  5 files changed, 155 insertions(+)

Could you please clarify the use-cases for this feature and its potential
users ? Besides, why existing nl80211_set_station can't be used ? It turns
out that there exists station AID field among numerous
'struct station_parameters' fields.

Regards,
Sergey
