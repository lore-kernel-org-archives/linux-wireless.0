Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFFDC10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2352184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="TgTHAMt9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfCTKFM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:12 -0400
Received: from mail-eopbgr710061.outbound.protection.outlook.com ([40.107.71.61]:37882
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727493AbfCTKFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYkU8545NTNaIJzczqNIYJzC2lkgtUs90wWmiJfeOmE=;
 b=TgTHAMt94hSHGXDXfTgB+0huY2HxH6QekmapLEmlZqlv/7dbqPlfsaqTOQ8NAaYDAueKWbZR5Uw4vokSi8MzzdWEzTvELIFa7tEowELpaBZtLeUWYrMBOQqoCCayaMwTsY6nob4PX0k8365gdhhpa6iczki1Ce/4tn4ijnfJvus=
Received: from MWHPR0501MB3739.namprd05.prod.outlook.com (10.167.163.147) by
 MWHPR0501MB3770.namprd05.prod.outlook.com (10.167.163.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:50 +0000
Received: from MWHPR0501MB3739.namprd05.prod.outlook.com
 ([fe80::c4ff:fb38:941f:deee]) by MWHPR0501MB3739.namprd05.prod.outlook.com
 ([fe80::c4ff:fb38:941f:deee%3]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 10:04:50 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:55 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:55 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 05/14] qtnfmac: flexible regulatory domain registration logic
Thread-Topic: [PATCH 05/14] qtnfmac: flexible regulatory domain registration
 logic
Thread-Index: AQHU3wQ69YnqsxqY6EO5lH8BefM+WA==
Date:   Wed, 20 Mar 2019 10:03:55 +0000
Message-ID: <20190320100340.14168-6-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: 65656ca0-a903-4823-7e6a-08d6ad1b5c8a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|MWHPR0501MB3770:
x-moderation-data: 3/20/2019 10:04:48 AM
x-microsoft-antispam-prvs: <MWHPR0501MB3770E06E09B2C28BED3D6D03A3410@MWHPR0501MB3770.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(346002)(39850400004)(136003)(189003)(199004)(14454004)(54906003)(2906002)(36756003)(97736004)(71200400001)(71190400001)(99286004)(3846002)(1076003)(186003)(8936002)(81166006)(81156014)(8676002)(6116002)(15650500001)(50226002)(53936002)(305945005)(6486002)(107886003)(6436002)(7736002)(6916009)(4326008)(68736007)(66066001)(5640700003)(256004)(5660300002)(386003)(478600001)(2501003)(6512007)(6506007)(76176011)(86362001)(25786009)(102836004)(26005)(52116002)(476003)(486006)(436003)(11346002)(446003)(2351001)(2616005)(105586002)(103116003)(316002)(14444005)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3770;H:MWHPR0501MB3739.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B58x1ulXBgGVnubxek3EoJd41KPX3lFBLfa42dxwfxCowQAZ010AQPifTFJGltgQ1r/RY+Bc/rnXV8Q8caJlSiRFrQFEOjV47NlStHM6WSAgflsx7WL2hxCnoj2PRc1YPFBXZrsFxW1jX7A2jeBjr1DCo+tocUaOa55y9/VAfKB8ilWuDDApBpHSl/rd1chkenTbjaWFcH9yigfHMdi+jMVlNnsCYHxRVp2ZuI++u7e435/Zw1WIp0n+sCGCiUizwWX7hYmfpzMFgdhu+R4SEBhIYiZykYuVAi4pGgyhQNvKqDCnieCyXziAy3sm8tGhfSWkZK1Yp3/7Ixsd33PCvFkTJzPkIf1xKW/Lf5dy/n5+zPvMWmjiytWog1hmJCOPnmwa17exYvfjn69h7y1zCRfdzUSnKuzhG17/eINod8k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65656ca0-a903-4823-7e6a-08d6ad1b5c8a
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:50.3070
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3770
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Use REGULATORY_CUSTOM_REG flag only if firmware advertised a custom
regulatory domain prior to wiphy registration. Use REGULATORY_STRICT_REG
flag only if firmware knows its regulatory domain.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index ae08b37d81d2..3131ced8801f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1073,6 +1073,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 	struct wiphy *wiphy =3D priv_to_wiphy(mac);
 	struct qtnf_mac_info *macinfo =3D &mac->macinfo;
 	int ret;
+	bool regdomain_is_known;
=20
 	if (!wiphy) {
 		pr_err("invalid wiphy pointer\n");
@@ -1144,11 +1145,20 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_inf=
o, struct qtnf_wmac *mac)
 		wiphy->wowlan =3D macinfo->wowlan;
 #endif
=20
+	regdomain_is_known =3D isalpha(hw_info->rd->alpha2[0]) &&
+		isalpha(hw_info->rd->alpha2[1]);
+
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_REG_UPDATE) {
-		wiphy->regulatory_flags |=3D REGULATORY_STRICT_REG |
-			REGULATORY_CUSTOM_REG;
 		wiphy->reg_notifier =3D qtnf_cfg80211_reg_notifier;
-		wiphy_apply_custom_regulatory(wiphy, hw_info->rd);
+
+		if (hw_info->rd->alpha2[0] =3D=3D '9' &&
+		    hw_info->rd->alpha2[1] =3D=3D '9') {
+			wiphy->regulatory_flags |=3D REGULATORY_CUSTOM_REG |
+				REGULATORY_STRICT_REG;
+			wiphy_apply_custom_regulatory(wiphy, hw_info->rd);
+		} else if (regdomain_is_known) {
+			wiphy->regulatory_flags |=3D REGULATORY_STRICT_REG;
+		}
 	} else {
 		wiphy->regulatory_flags |=3D REGULATORY_WIPHY_SELF_MANAGED;
 	}
@@ -1172,8 +1182,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
=20
 	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
 		ret =3D regulatory_set_wiphy_regd(wiphy, hw_info->rd);
-	else if (isalpha(hw_info->rd->alpha2[0]) &&
-		 isalpha(hw_info->rd->alpha2[1]))
+	else if (regdomain_is_known)
 		ret =3D regulatory_hint(wiphy, hw_info->rd->alpha2);
=20
 out:
--=20
2.11.0

