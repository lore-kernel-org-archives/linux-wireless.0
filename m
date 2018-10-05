Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B296C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59BE520645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="sJ/hztcZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59BE520645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbeJERJu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:50 -0400
Received: from mail-eopbgr730079.outbound.protection.outlook.com ([40.107.73.79]:1696
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERJu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmjHCkuQzwD/ijy5/i2LA5UBofyW/RonqfieindctQM=;
 b=sJ/hztcZR1+coxgHk7a1Nw+Y5PKaSfr2jeTtinBiFE4byFosmbwC1avPMb+6XoPltg2CdlNE8Uy8aIouUxn56/sewTJNczye/vK2FTp/yvK7tticyyRYrJaJ1vJU1sauYjGxcvm4ENXxACQCpkA5VcQCHjl5BSH3n8LhBlnYRqM=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:35 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:35 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH v2 06/13] qtnfmac: do not cancel scan in disconnect callback
Thread-Topic: [PATCH v2 06/13] qtnfmac: do not cancel scan in disconnect
 callback
Thread-Index: AQHUXJPLZkrVixFa5USoKjxK52hAgg==
Date:   Fri, 5 Oct 2018 10:11:35 +0000
Message-ID: <20181005101114.3013-7-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:d5MfQsSf9UcEpS2SnGFEQPx5Zis0JGpvhWR58WwcvkitcOvqttx43Z5L+vzYs3r35k0N5FXfPXCVbqXbcinFWLZIO4z7xRNdtdDcH7Qeze6HXuqx9xqjKL0Jl8gJq69rn/or88WZoV+UnjkWgopUTzYzrwX8rM3AzRkMr2S1xo876uYcvQpFkYCYtiBbFLCM9iyn1GVx1u5+jG/McL+rbKyHQKshJ3JLEWt1DO3nOtYXEfZ6QfZGoGjiY5mCivXkeb1l4Sxqv+612t5eTAAX4gmuYSqWbaE4h9V3SFs+/5mwhjfhBK24PAapngmCwoj0i/CL0Fcw0Ff94MbdlxPiC/1sJNldSwU/eqO/6dHy9cNMyFpC1nKxue7RXWmZPCu/rKlcP6GEEKOANWNdo9Dzzj6kcKlB5ETejcy/gTc9sENtP9yNPn6AYpskeotQNrEa5HCF2WvEbYJly6mDOTYfWA==;5:Kx3OjSP3Svry44FYb+Pp4G46Sw41AGqZgu8xa9rd3rjlYcM7Z87TRpr3jF4zPTkVgkstIlsvBBChESnnSwRiO0HEB+4ADD2GCr7g9xNn00Ee/2p/5XGeu+EoavoquA44o24jA9OJbSxdQWawzQGjW50bz+EWEGHs2Mt2I/+b9cw=;7:5AREnU4JpS5DplgiEZGoOmaUWkUadD6L0nhUTZ3qVkWJmrIjCSPyCUkGZLcD8niekVoGBbUIhDfgs/Raj+SEVLUS+5M3e5R8pWdmy7eBU32OIYGMnYwAdgZIkud3Pba5tIHl3UKYmYGgH55uPNmMXutiTT9B4xGGZ/dTgoTyNTet3t883VKJlLfCM5r/tgUQMBOjVu1EtHPe6/TI1/rzmvdUm5hueeX2M2V+4Cvbf2FebRsoS2/PNaaVjsUjenhf
x-ms-office365-filtering-correlation-id: 05732074-4b5a-41ef-e7a8-08d62aaaee21
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB443995D154B2B0AA1C1E05A4A3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(256004)(86362001)(476003)(11346002)(446003)(14454004)(486006)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 3qRq4Lq2A5rQQKZdW545Q2438c76Kwo7JZzBKZveB4ow9pFy0LeLD13bqPJucxGmAlQDJc2fyE9xchXBsfXuJ7C8IyjZu5+5wipda9amH8Xjiqtl5kaPSXsQuw23/9ppV851Ure07pBd2z7aQOGUJlbNo2KNbXovpw3QqNwBI8it+4cVIQ38yZRqobDxCYthBxsmiHQHl5v1jzRvWUk92+ZRBvA/HqGoLXxny8o7ciEr88tWndehBg1b1L95HTfSbjE0sJ9p3OKKVDHwQaCtA7VAYILTKmaC9rqQrDskznfboM5JVFi2pQ/9SxGL/7DAuKU341lUFqROsCviQpcJhrAaIoMmXyZLiNvoq68/1ac=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05732074-4b5a-41ef-e7a8-08d62aaaee21
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:35.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Do not cancel scan in disconnect callback. If there is an active scan,
it will be cancelled by firmware, then host driver will be properly
notified by event.

Cancelling scan in disconnect callback occasionally may lead to the
following race issue. Host is able to queue one scan after scan
abort in disconnect callback, and another scan after scan abort
in event handler. As a result, firmware receives second scan
before the first scan completes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 4631277092bf..8b30d651cbe3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -666,8 +666,6 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device =
*dev,
 		goto out;
 	}
=20
-	qtnf_scan_done(mac, true);
-
 	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret)
 		pr_err("VIF%u.%u: failed to disconnect\n",
--=20
2.11.0

