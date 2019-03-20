Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6245DC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A6D2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="3Bs5IRzn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfCTKEv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:04:51 -0400
Received: from mail-eopbgr710079.outbound.protection.outlook.com ([40.107.71.79]:22688
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+8YlrRsoHgqbYEKCDNyaacjBfAukgSQ9kyFGgvf6u0=;
 b=3Bs5IRznA54L0/ibPmXDXQOm70430JzA2JagDco8sv/0NNbDhS9FxwVAIu+iQ/sOMWvOaT5iCOfg7DQ2V0Ph4DrN47iJYQa+FauK7wyPVKmHMrm6Wy6avZMuRSIXcTHAcCA4uBtEaWmpA7IXC+Jf2pWt0qjLKXtu/7oFeIzAnww=
Received: from SN6PR05MB4656.namprd05.prod.outlook.com (52.135.114.202) by
 SN6PR05MB5424.namprd05.prod.outlook.com (52.135.109.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Wed, 20 Mar 2019 10:04:42 +0000
Received: from SN6PR05MB4656.namprd05.prod.outlook.com
 ([fe80::a8f6:a314:5b0f:f2a]) by SN6PR05MB4656.namprd05.prod.outlook.com
 ([fe80::a8f6:a314:5b0f:f2a%5]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:42 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:48 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:48 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 01/14] qtnfmac: make regulatory notifier work on per-phy basis
Thread-Topic: [PATCH 01/14] qtnfmac: make regulatory notifier work on per-phy
 basis
Thread-Index: AQHU3wQ2GdxTz1znikS9tg7IZCFdOg==
Date:   Wed, 20 Mar 2019 10:03:48 +0000
Message-ID: <20190320100340.14168-2-sergey.matyukevich.os@quantenna.com>
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
x-ms-office365-filtering-correlation-id: 54721120-37fc-445c-c354-08d6ad1b5852
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|SN6PR05MB5424:
x-moderation-data: 3/20/2019 10:04:38 AM
x-microsoft-antispam-prvs: <SN6PR05MB542407BEF16F2FE9E9314D25A3410@SN6PR05MB5424.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(14454004)(36756003)(1076003)(14444005)(256004)(97736004)(15650500001)(305945005)(103116003)(7736002)(478600001)(2351001)(11346002)(446003)(186003)(99286004)(436003)(6116002)(3846002)(486006)(2616005)(476003)(54906003)(6436002)(6486002)(316002)(52116002)(76176011)(71200400001)(71190400001)(386003)(105586002)(106356001)(25786009)(6506007)(6916009)(2906002)(102836004)(26005)(6512007)(8676002)(8936002)(5640700003)(4326008)(81156014)(68736007)(5660300002)(2501003)(53936002)(86362001)(50226002)(107886003)(81166006)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5424;H:SN6PR05MB4656.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IaIBuZRU2SFLbCTG2emcKtWSey8dcbgMMaKhGmplKLZlV08kdP1M/NXriK4rnEiWloGJxBcDeRFaaH/qK/9KktO1cte/y7VCV0e0AIAVORhQq4gtm5Z0NwrwEj0pud042fFD5qm8J97SbqGOlbn1O0mx0FFXptCShXDv/3nQj6oWvdRu3pfPyEiBSki7vaQlLyb2ZuJPUIz4yk7au+Me3AMUDtxRB6gbTCqEvtXCf8kytmhCDkFkfr2AdDnmimwQP6U1UEPfUjnYLlZIKnAVAow2IttTQS6XD7XT3pr/5QY2TD8lVohdGtEkU+Gx7Z4VceJ8y0ct6T9wsvYfwKm+THtZbyRymm57oy7OppUGDScjyJNf1TSI40wgtxCKnqdk8AUzgMSbkq7A52LbaVQ61dGHR0ZANb7aTFllIaT5a0Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54721120-37fc-445c-c354-08d6ad1b5852
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:42.0911
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5424
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Wireless core calls regulatory notifier for each wiphy and it only
guarantees that bands info is updated for this particular wiphy prior
to calling a notifier. Hence updating all wiphy which belong to driver
in a single notifier callback is redundant and incorrect.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 32 +++++++------------=
----
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  9 +++----
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  2 +-
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index dcb0991432f4..295890b2673c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -993,20 +993,17 @@ static struct cfg80211_ops qtn_cfg80211_ops =3D {
 #endif
 };
=20
-static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
+static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy,
 				       struct regulatory_request *req)
 {
-	struct qtnf_wmac *mac =3D wiphy_priv(wiphy_in);
-	struct qtnf_bus *bus =3D mac->bus;
-	struct wiphy *wiphy;
-	unsigned int mac_idx;
+	struct qtnf_wmac *mac =3D wiphy_priv(wiphy);
 	enum nl80211_band band;
 	int ret;
=20
 	pr_debug("MAC%u: initiator=3D%d alpha=3D%c%c\n", mac->macid, req->initiat=
or,
 		 req->alpha2[0], req->alpha2[1]);
=20
-	ret =3D qtnf_cmd_reg_notify(bus, req);
+	ret =3D qtnf_cmd_reg_notify(mac, req);
 	if (ret) {
 		if (ret =3D=3D -EOPNOTSUPP) {
 			pr_warn("reg update not supported\n");
@@ -1021,25 +1018,14 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy=
 *wiphy_in,
 		return;
 	}
=20
-	for (mac_idx =3D 0; mac_idx < QTNF_MAX_MAC; ++mac_idx) {
-		if (!(bus->hw_info.mac_bitmap & (1 << mac_idx)))
-			continue;
-
-		mac =3D bus->mac[mac_idx];
-		if (!mac)
+	for (band =3D 0; band < NUM_NL80211_BANDS; ++band) {
+		if (!wiphy->bands[band])
 			continue;
=20
-		wiphy =3D priv_to_wiphy(mac);
-
-		for (band =3D 0; band < NUM_NL80211_BANDS; ++band) {
-			if (!wiphy->bands[band])
-				continue;
-
-			ret =3D qtnf_cmd_band_info_get(mac, wiphy->bands[band]);
-			if (ret)
-				pr_err("failed to get chan info for mac %u band %u\n",
-				       mac_idx, band);
-		}
+		ret =3D qtnf_cmd_band_info_get(mac, wiphy->bands[band]);
+		if (ret)
+			pr_err("MAC%u: failed to update band %u\n",
+			       mac->macid, band);
 	}
 }
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 85a2a58f4c16..9aabba7429ed 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2404,13 +2404,14 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,=
 bool up)
 	return ret;
 }
=20
-int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *r=
eq)
+int qtnf_cmd_reg_notify(struct qtnf_wmac *mac, struct regulatory_request *=
req)
 {
+	struct qtnf_bus *bus =3D mac->bus;
 	struct sk_buff *cmd_skb;
 	int ret;
 	struct qlink_cmd_reg_notify *cmd;
=20
-	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
 					    QLINK_CMD_REG_NOTIFY,
 					    sizeof(*cmd));
 	if (!cmd_skb)
@@ -2449,10 +2450,6 @@ int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct=
 regulatory_request *req)
=20
 	qtnf_bus_lock(bus);
 	ret =3D qtnf_cmd_send(bus, cmd_skb);
-	if (ret)
-		goto out;
-
-out:
 	qtnf_bus_unlock(bus);
=20
 	return ret;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.h
index 64f0b9dc8a14..050f9a49d16c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -57,7 +57,7 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
 			     u16 reason_code);
 int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 			      bool up);
-int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *r=
eq);
+int qtnf_cmd_reg_notify(struct qtnf_wmac *mac, struct regulatory_request *=
req);
 int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 			    struct qtnf_chan_stats *stats);
 int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
--=20
2.11.0

