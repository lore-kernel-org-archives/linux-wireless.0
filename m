Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D9DC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B332073D
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="vUoeADrg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfBEJtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:49:39 -0500
Received: from mail-eopbgr780079.outbound.protection.outlook.com ([40.107.78.79]:10976
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727226AbfBEJtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 04:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvrNQwsO5Ed4k2SXqGAQBquIN/q2JIGCD6jEalQUo1g=;
 b=vUoeADrgCZerEQtors0NxvR6KrRUIrbq5fjnLXhOAO8s+R2+DoQlZfW7uyTotnkmGi87rwZn04vTB10C6OEkq5Aet9+ra0nsgRzzpT9zj4xrerOMXBWKGfRerFjshGiMqf5Hq0pq4TQL42CWaj90Ipi3QSim5DgpJE/w5gU15wo=
Received: from DM5PR05MB3162.namprd05.prod.outlook.com (10.173.219.20) by
 DM5PR05MB3660.namprd05.prod.outlook.com (10.174.190.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.13; Tue, 5 Feb 2019 09:49:22 +0000
Received: from DM5PR05MB3162.namprd05.prod.outlook.com
 ([fe80::bca0:2f10:431f:3e18]) by DM5PR05MB3162.namprd05.prod.outlook.com
 ([fe80::bca0:2f10:431f:3e18%9]) with mapi id 15.20.1601.013; Tue, 5 Feb 2019
 09:49:22 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5616.namprd05.prod.outlook.com (52.135.111.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.16; Tue, 5 Feb 2019 09:48:57 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620%4]) with mapi id 15.20.1601.016; Tue, 5 Feb 2019
 09:48:57 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/2] qtnfmac: enable WPA3 SAE support
Thread-Topic: [PATCH 2/2] qtnfmac: enable WPA3 SAE support
Thread-Index: AQHUvTgDlzOXScRVvkm/sKbAFqt1ZQ==
Date:   Tue, 5 Feb 2019 09:48:57 +0000
Message-ID: <20190205094842.31568-3-sergey.matyukevich.os@quantenna.com>
References: <20190205094842.31568-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190205094842.31568-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR05MB3660;6:m4blQE4KRSP8k4yL2DVvzH27Hc7ghx0KyGz9P6eAGVWR63zzLfo30aEHYoR+Hl9bf/nqDq0HKoYjwG5ynwrucksWS6kEArHEzN0otbAgEK+jyZrGk9bCkFY6G7b0fVadGoQmOq5QcuorVBY8xv6takjUaKv3VlvBajRY3Lpzxjpli/06SCDZpPkJ1/QwNouLtRuwksRwFsKJ7fhxXb2vjb+FO8brOsi33+i2D7wLWkD7pBhxjnlsmXpP5xR2GL0LnFblU2+7VxXC4/EUOvpbibN5xJPlwiCBzQ8T+yIhSKSir2Gzx26jA0pwSzpnDnvR2pAVM6iCMVLaktvQAerNCYKDMWSQYzoSfAh44l0Q6GoiIsZjixbBJdYz6Ti13UG9VIAJgQP+AkIw2YvEGfoLo06uTtB1Q4IRFzHch0zq59h/ZuVlDaq+9lnn6qZpUJwUf++419hOsN6bKXfh/JII1g==;5:3GFk2lHxak4/rZLdUKQ0INEkDZ16MTFc8F9vPMmX71QOaiD0XkopHK9uGdJYh40IigeV3wQCfwuV7bUy/87yRiVLOrl1oO+MgpfYpFjZjyofN9FnefDnvBSZJ7yF0Oxls83F1yIHabui+a3L7qxL06kFwxipkAFeXT904ftXZHdbsPM3Ory7YwqA2B0Oa6FuGUJ0OHfbsGdRsDHIrkqwjQ==;7:f0K/jmVnHrwQMju6gLKbA+yNCbuXkWTD3aw9VCcnmSGrOxsRodnvvrnA+aft5BthYSFR/+6XHAUN1/qRSaaYGP/W5VkFAkr6PQav0q+USFZGEy7pqq4xfOJmm1EBWf/XbhTBfSs7gx0nWcXrj97t8w==
x-ms-office365-filtering-correlation-id: 9bbba190-3ee4-47c5-d3e8-08d68b4f2579
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5616;
x-ms-traffictypediagnostic: SN6PR05MB5616:|DM5PR05MB3660:
x-moderation-data: 2/5/2019 9:49:20 AM
x-microsoft-antispam-prvs: <DM5PR05MB36605D8D9EAED7E9A3D33F67A36E0@DM5PR05MB3660.namprd05.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(396003)(39840400004)(189003)(199004)(99286004)(25786009)(2616005)(2906002)(11346002)(102836004)(186003)(76176011)(14444005)(446003)(106356001)(105586002)(316002)(86362001)(476003)(5640700003)(68736007)(486006)(256004)(52116002)(6436002)(2351001)(26005)(7736002)(6916009)(436003)(6116002)(8676002)(36756003)(6512007)(2501003)(386003)(3846002)(1076003)(53936002)(71190400001)(50226002)(81166006)(478600001)(66066001)(103116003)(4326008)(97736004)(8936002)(6506007)(107886003)(54906003)(81156014)(71200400001)(6486002)(305945005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR05MB3660;H:DM5PR05MB3162.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WZvtzUwCVBBcjnVTUrMUkAo784a4c9wrarWV+4A/N8+e68Y7SO821oZJ3CBo+clC6goQIn7tHCHLgNZ+avEmvLE4onpAHbap8E4PikdF/IahXpysGx5KjjYqSj5TPYNj5N7EfIzftf7Y4Go1E6QKnnat2ASi2lqml1vJnRVwYIFuNNiVNclH/ztany15j8s7n0QPlL5VYnqqqn/EqNQhgYGZFXMfdJYckZX4intzFLWfQVY1vK+uazm7Y/4WyMzTmOEidUoJ7n7RPxkK+Xr8C/udikA+qd20581OT1qDFH3Mc7C3mPiWkiOP8oK8aUz0Fn+HgGrqywcyy4pXH74GZ2dcgcmN6vJKdUQXAzuT58yN9cIo7AV27l3lbz88cnkRi5ioBD/ir+OUWI/x0jiqOmnWSFY3CN8kQggqXMKzYHE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbba190-3ee4-47c5-d3e8-08d68b4f2579
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 09:49:22.4600
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR05MB3660
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the case of SAE AP, drivers offload authentication to user-space
software, e.g. hostapd. For FullMAC drivers the procedure is as follows.
If auth_type is SAE and user space indicates external authentication
capability, then driver requests authentication offload to user-space
software using cfg80211_external_auth_request call. From that point,
auth frame exchange is performed transparently for driver: user-space
software sends/receives mgmt frames using mgmt_tx/mgmt_frame_register
cfg80211 callbacks. As soon as authenitcation is completed, user-space
software notifies driver about its status using external_auth cfg80211
callback.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 40 +++++++++++++++++++=
+--
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 29 ++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  2 ++
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 41 +++++++++++++++++++=
++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 35 +++++++++++++++++++
 5 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 45f4cef7de9c..dcb0991432f4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -53,9 +53,11 @@ static const u32 qtnf_cipher_suites[] =3D {
 static const struct ieee80211_txrx_stypes
 qtnf_mgmt_stypes[NUM_NL80211_IFTYPES] =3D {
 	[NL80211_IFTYPE_STATION] =3D {
-		.tx =3D BIT(IEEE80211_STYPE_ACTION >> 4),
+		.tx =3D BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4),
 		.rx =3D BIT(IEEE80211_STYPE_ACTION >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4),
 	},
 	[NL80211_IFTYPE_AP] =3D {
 		.tx =3D BIT(IEEE80211_STYPE_ACTION >> 4),
@@ -636,6 +638,12 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *d=
ev,
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
=20
+	if (sme->auth_type =3D=3D NL80211_AUTHTYPE_SAE &&
+	    !(sme->flags & CONNECT_REQ_EXTERNAL_AUTH_SUPPORT)) {
+		pr_err("can not offload authentication to userspace\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (sme->bssid)
 		ether_addr_copy(vif->bssid, sme->bssid);
 	else
@@ -653,6 +661,30 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *d=
ev,
 }
=20
 static int
+qtnf_external_auth(struct wiphy *wiphy, struct net_device *dev,
+		   struct cfg80211_external_auth_params *auth)
+{
+	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
+	int ret;
+
+	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!ether_addr_equal(vif->bssid, auth->bssid))
+		pr_warn("unexpected bssid: %pM", auth->bssid);
+
+	ret =3D qtnf_cmd_send_external_auth(vif, auth);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to report external auth\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static int
 qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		u16 reason_code)
 {
@@ -946,6 +978,7 @@ static struct cfg80211_ops qtn_cfg80211_ops =3D {
 	.set_default_mgmt_key	=3D qtnf_set_default_mgmt_key,
 	.scan			=3D qtnf_scan,
 	.connect		=3D qtnf_connect,
+	.external_auth		=3D qtnf_external_auth,
 	.disconnect		=3D qtnf_disconnect,
 	.dump_survey		=3D qtnf_dump_survey,
 	.get_channel		=3D qtnf_get_channel,
@@ -1125,6 +1158,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 	if (!(hw_info->hw_capab & QLINK_HW_CAPAB_OBSS_SCAN))
 		wiphy->features |=3D NL80211_FEATURE_NEED_OBSS_SCAN;
=20
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_SAE)
+		wiphy->features |=3D NL80211_FEATURE_SAE;
+
 #ifdef CONFIG_PM
 	if (macinfo->wowlan)
 		wiphy->wowlan =3D macinfo->wowlan;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 0f48f541de41..85a2a58f4c16 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2322,6 +2322,35 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	return ret;
 }
=20
+int qtnf_cmd_send_external_auth(struct qtnf_vif *vif,
+				struct cfg80211_external_auth_params *auth)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_external_auth *cmd;
+	int ret;
+
+	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_EXTERNAL_AUTH,
+					    sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	cmd =3D (struct qlink_cmd_external_auth *)cmd_skb->data;
+
+	ether_addr_copy(cmd->bssid, auth->bssid);
+	cmd->status =3D cpu_to_le16(auth->status);
+
+	qtnf_bus_lock(vif->mac->bus);
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
+		goto out;
+
+out:
+	qtnf_bus_unlock(vif->mac->bus);
+
+	return ret;
+}
+
 int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u16 reason_code)
 {
 	struct sk_buff *cmd_skb;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.h
index 96dff643bbc4..64f0b9dc8a14 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -51,6 +51,8 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac);
 int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 			  struct cfg80211_connect_params *sme);
+int qtnf_cmd_send_external_auth(struct qtnf_vif *vif,
+				struct cfg80211_external_auth_params *auth);
 int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
 			     u16 reason_code);
 int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index 944729b74f17..6c1b886339ac 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -574,6 +574,43 @@ static int qtnf_event_handle_radar(struct qtnf_vif *vi=
f,
 	return 0;
 }
=20
+static int
+qtnf_event_handle_external_auth(struct qtnf_vif *vif,
+				const struct qlink_event_external_auth *ev,
+				u16 len)
+{
+	struct cfg80211_external_auth_params auth =3D {0};
+	struct wiphy *wiphy =3D priv_to_wiphy(vif->mac);
+	int ret;
+
+	if (len < sizeof(*ev)) {
+		pr_err("MAC%u: payload is too short\n", vif->mac->macid);
+		return -EINVAL;
+	}
+
+	if (!wiphy->registered || !vif->netdev)
+		return 0;
+
+	if (ev->ssid_len) {
+		memcpy(auth.ssid.ssid, ev->ssid, ev->ssid_len);
+		auth.ssid.ssid_len =3D ev->ssid_len;
+	}
+
+	auth.key_mgmt_suite =3D le32_to_cpu(ev->akm_suite);
+	ether_addr_copy(auth.bssid, ev->bssid);
+	auth.action =3D ev->action;
+
+	pr_info("%s: external auth bss=3D%pM action=3D%u akm=3D%u\n",
+		vif->netdev->name, auth.bssid, auth.action,
+		auth.key_mgmt_suite);
+
+	ret =3D cfg80211_external_auth_request(vif->netdev, &auth, GFP_KERNEL);
+	if (ret)
+		pr_warn("failed to offload external auth request\n");
+
+	return ret;
+}
+
 static int qtnf_event_parse(struct qtnf_wmac *mac,
 			    const struct sk_buff *event_skb)
 {
@@ -632,6 +669,10 @@ static int qtnf_event_parse(struct qtnf_wmac *mac,
 		ret =3D qtnf_event_handle_radar(vif, (const void *)event,
 					      event_len);
 		break;
+	case QLINK_EVENT_EXTERNAL_AUTH:
+		ret =3D qtnf_event_handle_external_auth(vif, (const void *)event,
+						      event_len);
+		break;
 	default:
 		pr_warn("unknown event type: %x\n", event_id);
 		break;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 1f7ced21cb39..7798edcf7980 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -68,6 +68,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_PWR_MGMT			=3D BIT(4),
 	QLINK_HW_CAPAB_OBSS_SCAN		=3D BIT(5),
 	QLINK_HW_CAPAB_SCAN_DWELL		=3D BIT(6),
+	QLINK_HW_CAPAB_SAE			=3D BIT(8),
 };
=20
 enum qlink_iface_type {
@@ -250,6 +251,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_DISCONNECT		=3D 0x0061,
 	QLINK_CMD_PM_SET		=3D 0x0062,
 	QLINK_CMD_WOWLAN_SET		=3D 0x0063,
+	QLINK_CMD_EXTERNAL_AUTH		=3D 0x0066,
 };
=20
 /**
@@ -481,6 +483,20 @@ struct qlink_cmd_connect {
 } __packed;
=20
 /**
+ * struct qlink_cmd_external_auth - data for QLINK_CMD_EXTERNAL_AUTH comma=
nd
+ *
+ * @bssid: BSSID of the BSS to connect to
+ * @status: authentication status code
+ * @payload: variable portion of connection request.
+ */
+struct qlink_cmd_external_auth {
+	struct qlink_cmd chdr;
+	u8 bssid[ETH_ALEN];
+	__le16 status;
+	u8 payload[0];
+} __packed;
+
+/**
  * struct qlink_cmd_disconnect - data for QLINK_CMD_DISCONNECT command
  *
  * @reason: code of the reason of disconnect, see &enum ieee80211_reasonco=
de.
@@ -925,6 +941,7 @@ enum qlink_event_type {
 	QLINK_EVENT_BSS_LEAVE		=3D 0x0027,
 	QLINK_EVENT_FREQ_CHANGE		=3D 0x0028,
 	QLINK_EVENT_RADAR		=3D 0x0029,
+	QLINK_EVENT_EXTERNAL_AUTH	=3D 0x0030,
 };
=20
 /**
@@ -1100,6 +1117,24 @@ struct qlink_event_radar {
 	u8 rsvd[3];
 } __packed;
=20
+/**
+ * struct qlink_event_external_auth - data for QLINK_EVENT_EXTERNAL_AUTH e=
vent
+ *
+ * @ssid: SSID announced by BSS
+ * @ssid_len: SSID length
+ * @bssid: BSSID of the BSS to connect to
+ * @akm_suite: AKM suite for external authentication
+ * @action: action type/trigger for external authentication
+ */
+struct qlink_event_external_auth {
+	struct qlink_event ehdr;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;
+	u8 bssid[ETH_ALEN];
+	__le32 akm_suite;
+	u8 action;
+} __packed;
+
 /* QLINK TLVs (Type-Length Values) definitions
  */
=20
--=20
2.11.0

