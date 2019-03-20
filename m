Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01239C10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C671E2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="rKXbDQyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfCTKEj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:04:39 -0400
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:29968
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKEi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cFlwO3GRUI2Fofof75r8+pPGbyvmgBatKetQXIgUUU=;
 b=rKXbDQyZgTivEr2rAQCDxPU6clXC/B+2A1fjpsf7UJo32WOfegNBbojT/zuXrDrgvNZpfqYL+6fsun27SaadrrDUXnMzjy3FkIOhj0YBNCXifT+m7BYlYkLORQ5A6mlrdKiAh9eoJsg4X8bue/9izNix+pHMBHyhnRMaOQgwDLI=
Received: from CY4PR05MB3271.namprd05.prod.outlook.com (10.172.156.19) by
 CY4PR05MB3399.namprd05.prod.outlook.com (10.171.248.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.7; Wed, 20 Mar 2019 10:04:37 +0000
Received: from CY4PR05MB3271.namprd05.prod.outlook.com
 ([fe80::940d:4a97:1f3d:9c17]) by CY4PR05MB3271.namprd05.prod.outlook.com
 ([fe80::940d:4a97:1f3d:9c17%8]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 10:04:36 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:50 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:50 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 02/14] qtnfmac: simplify error reporting in regulatory
 notifier
Thread-Topic: [PATCH 02/14] qtnfmac: simplify error reporting in regulatory
 notifier
Thread-Index: AQHU3wQ371Gzr4+Z9UOJZoj/YrDPsg==
Date:   Wed, 20 Mar 2019 10:03:49 +0000
Message-ID: <20190320100340.14168-3-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8f6f4d4-a32b-43c0-f86a-08d6ad1b595f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|CY4PR05MB3399:
x-moderation-data: 3/20/2019 10:04:35 AM
x-microsoft-antispam-prvs: <CY4PR05MB33990C893D616C193A7B7CA8A3410@CY4PR05MB3399.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(136003)(346002)(376002)(199004)(189003)(102836004)(446003)(11346002)(76176011)(305945005)(14454004)(52116002)(99286004)(36756003)(476003)(436003)(5640700003)(7736002)(486006)(186003)(8936002)(50226002)(4326008)(6436002)(2616005)(256004)(66066001)(2351001)(8676002)(14444005)(81156014)(106356001)(3846002)(6486002)(97736004)(71190400001)(81166006)(6116002)(71200400001)(54906003)(26005)(316002)(2501003)(6512007)(103116003)(105586002)(25786009)(478600001)(1076003)(6916009)(53936002)(6506007)(86362001)(386003)(15650500001)(2906002)(107886003)(5660300002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR05MB3399;H:CY4PR05MB3271.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VthcsMmbExYcj6qqPOsfBLDcUMK69sKsAfNr6S/1q797v8aSoJYiOswnjMBOwfncwTdTiSmXv1R65ozRqTr5cQYmTPdc/84eC8IPuxovwbK2JT2vsF5y9lVdvDxMdndGHcRFGdyFvPKdcsq5AF1s+xtdzCrJcrTb7B8Raayf2TNalFN8/Sge8+RrV58a+zLS+oNnA1bWeZyYsOer/xHcEfEOYohYNC/L2SvnSQ04ZqsW3UGJ908UjHlBla3KWO/oB5fizUtTapx8CT1ueLg+bwp8QEwnvIjiCWogdrLlJl7v0TfB9dBbi6h6llMWqogpACQghvb9yoSFq4msv1ELav4cwuQqiooeRNnY3UfOlBf/JDLoT/T+ugkTZ5asUTYKwt5kl4JlVMEblmFyFH6OQjyZrC3xmGjQf7OViAFg/GQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f6f4d4-a32b-43c0-f86a-08d6ad1b595f
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:36.9982
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR05MB3399
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Error reporting in qtnf_cfg80211_reg_notifier only requires to print
one type of message and an error code. Firmware will report success
for an attempt to set regulatory region to the same value,
so no special handling is required for this case.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 295890b2673c..ae08b37d81d2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1005,16 +1005,8 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy =
*wiphy,
=20
 	ret =3D qtnf_cmd_reg_notify(mac, req);
 	if (ret) {
-		if (ret =3D=3D -EOPNOTSUPP) {
-			pr_warn("reg update not supported\n");
-		} else if (ret =3D=3D -EALREADY) {
-			pr_info("regulatory domain is already set to %c%c",
-				req->alpha2[0], req->alpha2[1]);
-		} else {
-			pr_err("failed to update reg domain to %c%c\n",
-			       req->alpha2[0], req->alpha2[1]);
-		}
-
+		pr_err("MAC%u: failed to update region to %c%c: %d\n",
+		       mac->macid, req->alpha2[0], req->alpha2[1], ret);
 		return;
 	}
=20
--=20
2.11.0

