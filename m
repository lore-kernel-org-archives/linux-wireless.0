Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2379EC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C042184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="PUDo00aw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfCTKFM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:12 -0400
Received: from mail-eopbgr810048.outbound.protection.outlook.com ([40.107.81.48]:58688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJI8uXrgWKQGmHJi/VJ/LQka0UwCFJ8CqOJlCL4UD08=;
 b=PUDo00aw/MGvaZ4qZcbQNeFFGgjBRPlRyphPzcexlipRVevilPWld14Vo/VOHoLbPbbFATohb94kjjBLUAAnYRCqNikVo79Vez5HG+jHYIT7271nr+82PgY3ZGvnoshJ90g2ziA3jv/99fpnGJ8MNYb/RSCj7Z+57XT8jSNTWGs=
Received: from BL0PR05MB5281.namprd05.prod.outlook.com (10.167.182.151) by
 BL0PR05MB5524.namprd05.prod.outlook.com (10.167.240.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Wed, 20 Mar 2019 10:04:52 +0000
Received: from BL0PR05MB5281.namprd05.prod.outlook.com
 ([fe80::144a:4d99:503f:19fc]) by BL0PR05MB5281.namprd05.prod.outlook.com
 ([fe80::144a:4d99:503f:19fc%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:52 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:53 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:53 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 03/14] qtnfmac: include full channels info to regulatory
 notifier
Thread-Topic: [PATCH 03/14] qtnfmac: include full channels info to regulatory
 notifier
Thread-Index: AQHU3wQ4NxkkAAB85UeZUeUY6uvgfg==
Date:   Wed, 20 Mar 2019 10:03:51 +0000
Message-ID: <20190320100340.14168-4-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: ad9e0e06-3610-4357-d010-08d6ad1b5a74
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|BL0PR05MB5524:
x-moderation-data: 3/20/2019 10:04:50 AM
x-microsoft-antispam-prvs: <BL0PR05MB55243495E4E8E88A935B156FA3410@BL0PR05MB5524.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(136003)(39850400004)(189003)(199004)(99286004)(14454004)(1076003)(4326008)(486006)(436003)(6916009)(2616005)(6486002)(81156014)(8676002)(26005)(66066001)(446003)(2501003)(11346002)(2906002)(86362001)(476003)(386003)(76176011)(97736004)(36756003)(5640700003)(6506007)(105586002)(106356001)(52116002)(50226002)(25786009)(316002)(71190400001)(15650500001)(2351001)(71200400001)(478600001)(6436002)(6512007)(305945005)(7736002)(68736007)(186003)(81166006)(103116003)(8936002)(102836004)(256004)(14444005)(54906003)(5660300002)(107886003)(53936002)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5524;H:BL0PR05MB5281.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: adeglcJFbbFTS79F2w39afGwEGb46216QA4tTepjnX7kdxodQgoEq5LwsZRfioJSJqLd+HW5ocrQsoH7w1Q4U4H5wyvOl3cnC9u5pWWfJNbfjADeX5ILxqwOeQoF1cTouHjIILBrysQGUeBq7ALO9nM7dxNN0xENzm49+OvfgT6DOihPvrTEJOnR4Jc2ZYQjmP4cfigll9RDkKleDjNfyTovyBwCEh8QBM+XaCaLM0VszE2C2wLBWNGz6a0Xn4AylDXUprVL9tNdkGdXFCQGLk8owIwe0meBGoXzEC9MXqA98Qg5fbDtULQQtZnn9euFp32IgbfqZRk+vt/waBJEu7bPHEu7L8pbLTaIcMUrJRNSQbKHl2ill0E9Xmj5DhNdz263O+zP9Fe9ngTNw/oJPzKOQDyL+ckAKIwiMvrVMfg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9e0e06-3610-4357-d010-08d6ad1b5a74
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:52.2286
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5524
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Before regulatory notifier is invoked by a wireless core, it will
update band information for the wiphy. Pass this information to
firmware together with new region alpha2 code.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 20 +++++++++++++++++++=
+
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  8 +++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 9aabba7429ed..b1b622019f12 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2406,10 +2406,13 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,=
 bool up)
=20
 int qtnf_cmd_reg_notify(struct qtnf_wmac *mac, struct regulatory_request *=
req)
 {
+	struct wiphy *wiphy =3D priv_to_wiphy(mac);
 	struct qtnf_bus *bus =3D mac->bus;
 	struct sk_buff *cmd_skb;
 	int ret;
 	struct qlink_cmd_reg_notify *cmd;
+	enum nl80211_band band;
+	const struct ieee80211_supported_band *cfg_band;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
 					    QLINK_CMD_REG_NOTIFY,
@@ -2448,6 +2451,23 @@ int qtnf_cmd_reg_notify(struct qtnf_wmac *mac, struc=
t regulatory_request *req)
 		break;
 	}
=20
+	cmd->num_channels =3D 0;
+
+	for (band =3D 0; band < NUM_NL80211_BANDS; band++) {
+		unsigned int i;
+
+		cfg_band =3D wiphy->bands[band];
+		if (!cfg_band)
+			continue;
+
+		cmd->num_channels +=3D cfg_band->n_channels;
+
+		for (i =3D 0; i < cfg_band->n_channels; ++i) {
+			qtnf_cmd_channel_tlv_add(cmd_skb,
+						 &cfg_band->channels[i]);
+		}
+	}
+
 	qtnf_bus_lock(bus);
 	ret =3D qtnf_cmd_send(bus, cmd_skb);
 	qtnf_bus_unlock(bus);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 7798edcf7980..ca84684a1a93 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -6,7 +6,7 @@
=20
 #include <linux/ieee80211.h>
=20
-#define QLINK_PROTO_VER		13
+#define QLINK_PROTO_VER		14
=20
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -580,12 +580,18 @@ enum qlink_user_reg_hint_type {
  * @initiator: which entity sent the request, one of &enum qlink_reg_initi=
ator.
  * @user_reg_hint_type: type of hint for QLINK_REGDOM_SET_BY_USER request,=
 one
  *	of &enum qlink_user_reg_hint_type.
+ * @num_channels: number of &struct qlink_tlv_channel in a variable portio=
n of a
+ *	payload.
+ * @info: variable portion of regulatory notifier callback.
  */
 struct qlink_cmd_reg_notify {
 	struct qlink_cmd chdr;
 	u8 alpha2[2];
 	u8 initiator;
 	u8 user_reg_hint_type;
+	u8 num_channels;
+	u8 rsvd[3];
+	u8 info[0];
 } __packed;
=20
 /**
--=20
2.11.0

