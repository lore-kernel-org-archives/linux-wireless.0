Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BA5C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE00E2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="np7+rk67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfCTKE7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:04:59 -0400
Received: from mail-eopbgr780059.outbound.protection.outlook.com ([40.107.78.59]:41504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUc0VWfGocqZonnzNYqq6B41FC9DgWqxj1JO0ULDOt4=;
 b=np7+rk67vKga48Cx7xlY6ihw7/C1EBUSMIG34WNqDyLYiTKjaAGIi5jUbld4gssjFw0U9XquaURQ845M9qDEt+jdTA1C8KxCdUapNPXvW0JOh3taeVz1fxil0i9VHLb5nfQJwfqxD2W3xskRP/tRtgiA+XC6x31gOW5CZOD8uY4=
Received: from MWHPR05MB3021.namprd05.prod.outlook.com (10.168.246.139) by
 MWHPR05MB2845.namprd05.prod.outlook.com (10.168.245.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.11; Wed, 20 Mar 2019 10:04:56 +0000
Received: from MWHPR05MB3021.namprd05.prod.outlook.com
 ([fe80::58de:69e7:147c:1d2d]) by MWHPR05MB3021.namprd05.prod.outlook.com
 ([fe80::58de:69e7:147c:1d2d%2]) with mapi id 15.20.1730.008; Wed, 20 Mar 2019
 10:04:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:59 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:59 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 07/14] qtnfmac: pass DFS region to firmware on region update
Thread-Topic: [PATCH 07/14] qtnfmac: pass DFS region to firmware on region
 update
Thread-Index: AQHU3wQ8ZyBKWbEOiUOAT+EuksObHw==
Date:   Wed, 20 Mar 2019 10:03:58 +0000
Message-ID: <20190320100340.14168-8-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: 4b9982eb-8833-4855-249b-08d6ad1b5ec3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|MWHPR05MB2845:
x-moderation-data: 3/20/2019 10:04:53 AM
x-microsoft-antispam-prvs: <MWHPR05MB28454581B94B990CFE529D44A3410@MWHPR05MB2845.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39850400004)(396003)(366004)(136003)(346002)(199004)(189003)(14444005)(256004)(103116003)(52116002)(107886003)(26005)(4326008)(446003)(102836004)(66066001)(6486002)(8936002)(8676002)(53936002)(478600001)(11346002)(6506007)(476003)(76176011)(25786009)(6512007)(50226002)(436003)(81166006)(3846002)(6436002)(186003)(5640700003)(2616005)(6116002)(386003)(6916009)(15650500001)(99286004)(2501003)(305945005)(1076003)(36756003)(68736007)(81156014)(2351001)(71190400001)(105586002)(106356001)(7736002)(86362001)(71200400001)(2906002)(5660300002)(14454004)(97736004)(316002)(486006)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2845;H:MWHPR05MB3021.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /FR+LCGx8aiuG7XJmizwkJ/8dPHvnp2/7hP1D+0HgYI4l73seGPfL8jaXSPUNXoaLhP42dHdWLlnb8nZ70n42PmnfWw+dOWj+wrYg3QYdVVBNLLLVITCoFqjz8hQXJcPYiOE3tpkay7mhkiyMCUkevxkrlwSEO0siYEdWdGqMVb1Z2i21vE09HGxGHMCD3/RC12hKTBIdeBRyODouZUb12xeNUXoGRGR/QJTDwKq9wrLuc7V8bc/d2WpnK+lv8kKoq1HlZprZ6eyq+KfAC0D8XJ45FPkVj9qa4IzGloZ2A3TVYrv8qz9Wm4B+HhHxOUzUIGkQzc4Qm6cMvE10QwuMmWA08zdSKyZz6En92585jnBJeCLc5s4b7W7OgR6OM30n1/U5lWpLdQML0pmY5J+Nlp9ddD3xTv5JCn5XhDuc6s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9982eb-8833-4855-249b-08d6ad1b5ec3
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:56.1546
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2845
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Pass DFS region as requested by regulatory core directly to firmware
so it can initialize radar detection block accordingly.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 15 +++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  6 ++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 1a248d9f2e4c..cc7f74333f48 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2376,6 +2376,21 @@ int qtnf_cmd_reg_notify(struct qtnf_wmac *mac, struc=
t regulatory_request *req)
 		break;
 	}
=20
+	switch (req->dfs_region) {
+	case NL80211_DFS_FCC:
+		cmd->dfs_region =3D QLINK_DFS_FCC;
+		break;
+	case NL80211_DFS_ETSI:
+		cmd->dfs_region =3D QLINK_DFS_ETSI;
+		break;
+	case NL80211_DFS_JP:
+		cmd->dfs_region =3D QLINK_DFS_JP;
+		break;
+	default:
+		cmd->dfs_region =3D QLINK_DFS_UNSET;
+		break;
+	}
+
 	cmd->num_channels =3D 0;
=20
 	for (band =3D 0; band < NUM_NL80211_BANDS; band++) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 6951f6370985..f6d30069ef3a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -582,6 +582,7 @@ enum qlink_user_reg_hint_type {
  *	of &enum qlink_user_reg_hint_type.
  * @num_channels: number of &struct qlink_tlv_channel in a variable portio=
n of a
  *	payload.
+ * @dfs_region: one of &enum qlink_dfs_regions.
  * @info: variable portion of regulatory notifier callback.
  */
 struct qlink_cmd_reg_notify {
@@ -590,7 +591,8 @@ struct qlink_cmd_reg_notify {
 	u8 initiator;
 	u8 user_reg_hint_type;
 	u8 num_channels;
-	u8 rsvd[3];
+	u8 dfs_region;
+	u8 rsvd[2];
 	u8 info[0];
 } __packed;
=20
@@ -800,7 +802,7 @@ enum qlink_dfs_regions {
  * @alpha2: country code ID firmware is configured to.
  * @n_reg_rules: number of regulatory rules TLVs in variable portion of th=
e
  *	message.
- * @dfs_region: regulatory DFS region, one of @enum qlink_dfs_region.
+ * @dfs_region: regulatory DFS region, one of &enum qlink_dfs_regions.
  * @var_info: variable-length WMAC info data.
  */
 struct qlink_resp_get_mac_info {
--=20
2.11.0

