Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E26C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75F1921904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="V2OKkZTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfBGL3B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:01 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:29552 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfBGL3B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:01 -0500
X-IronPort-AV: E=Sophos;i="5.58,343,1544511600"; 
   d="scan'208";a="23538661"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:00 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTO6/t8e4z26fe6YXYxSZQJ4Yv8ovnL5UBW+MIwBjNY=;
 b=V2OKkZToxcjHNyasuHQjLrk7zqRZw4J4dYuntufPZ4khmE7sqVQg7uEyKzKakUm/cElnJ+9YTUURagwZRplcTxD1WJHMmrvlpAIlH4mQOHVle4UPqCIhn/r6HchNr2770IUJlRM0+F3Fm5RjkiBHWy0+6GqcLtKy0xqj+O/3A3U=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:28:58 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:28:58 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/8] staging: wilc1000: fix to set correct value for
 'vif_num'
Thread-Topic: [PATCH v2 1/8] staging: wilc1000: fix to set correct value for
 'vif_num'
Thread-Index: AQHUvthRCWtCjrOwjE+cjJZP1E/4FQ==
Date:   Thu, 7 Feb 2019 11:28:58 +0000
Message-ID: <1549538913-17463-2-git-send-email-ajay.kathat@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:36RR0B5yVzbzxXxqqU3AJgyiXx5G0+4k619vQcbNQ5IfeUWl14wZQwQNasx7g6DYsT4ijOgncdIkD9/I0ykEMtu2/PNruYpEzCy4Tdqa4yRiBmcVWbwauCDNG8NVs76vYHd+O7TRWd/kgacdMKrl4LQ7k5DIOFUFCP53/yFcWjU0r3Vcl+Yb+YI7wkrcIlXcYpd4NZEbHx46paUfu5/X6IaQk6GrAGqyQ3bYjn2HwWbKYaiYVfycBM+7JTXxoAsArsKs4GxbcWmSRHRL9QlGCu7vtEE9toIUdHU5XVZg1HilxryEqSOftjHI6Vi1m55QORxEuDgMb9RA9gAm5FXRDS/jpCn4yIf+/7bZWVYNjy7fzmITaJ+JpYMLcYiNG29+SlYHinn1lKA7dXU4OKsfSFPaDlH9R48OJNqJg7mvS8umCGlwzArdrcCYUUe7qoQ5ORrprhOqzbXKy+FVg7QT/Q==;5:CgVQ23MO30hz68Yhjj41Nai1Nz1x6qLfzFq7hjYNhcdZMSumK051BOjd/W2YT5AJy7oJk3IQzeFvcUO8xrTV6+KtQae0f/mwtiqP5JygdkGMVcDqxA2PtqLEgu1+owHX7cFYMXStPgR4t2+4KjsEcQ0HKTnQL+9nN9/MfT6/lb2/5UBM0BY7TdGDCdwMZe8UMSjP/NH9SsorDIHo3cAQ3g==;7:Euq45yUttXaqvFqcDdE+zSJRS0U4Jeyd10ggEY2UcooLsJUdSY1rRKbkmocDAwPDpXhKs7F+QN/eyYuJNZcXYzTcOudvWOKH76kCTL2Ij37fFsPeife5FP/c1+ICyPIq4apRacioUmYNFaHd+px+lw==
x-ms-office365-filtering-correlation-id: 909443f5-c091-4ccd-a392-08d68cef737b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB2792EA18612A566DC0CED5D6E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(4744005)(2501003)(256004)(7736002)(68736007)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F7mjiJJTrt+KwFCYj/zw77SAo2Jdf33VX+xkRJfZhpKNPgTbYXYjsWaZzCD3HtKowD0iVloNnfvLVq0PPO7Faw+O/o8fU40W1SeLCdak1lSzOGSQHOITySNGbZXsw6S51LpkKHOZU6tXJMeJg09iircH7vD0EIHaIYgSHuwKp2NdjRHwQAVfpGuhkIEcsyGOatT0rIZeSJ7MRSSz/HrUDntXHE67xDXaiuyAFQpQTeZl6RzuKN46Z67bZyRdafKiOSfB69mJDuVzHm4fc3T5Hh3o/nBjkQnUUZjT3pjx2894UZU8jKDYKGvnJgfvfHGtbD0Q5OE6QqlT0ZPTjWNm/RyGvI4RQtUc0zccvqHGnPvi9wpHuZGTVDOrMFwX/Pa05UrxS7MMx34Mu25cBireK0cTkVz8Qo5lH/cpRUWBJsU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 909443f5-c091-4ccd-a392-08d68cef737b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:28:55.5540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Set correct value in '->vif_num' for the total number of interfaces and
set '->idx' value using 'i'.

Fixes: 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
Fixes: 0e490657c721 ("staging: wilc1000: Fix problem with wrong vif index")
Cc: <stable@vger.kernel.org>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index f096f9e..f3e52af 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1020,8 +1020,8 @@ int wilc_netdev_init(struct wilc **wilc, struct devic=
e *dev, int io_type,
 		vif->wilc =3D *wilc;
 		vif->ndev =3D ndev;
 		wl->vif[i] =3D vif;
-		wl->vif_num =3D i;
-		vif->idx =3D wl->vif_num;
+		wl->vif_num =3D i + 1;
+		vif->idx =3D i;
=20
 		ndev->netdev_ops =3D &wilc_netdev_ops;
=20
--=20
2.7.4

