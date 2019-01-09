Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18D0C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83BE9206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="f/5I9Ohp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbfAIQVP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:21:15 -0500
Received: from mail-eopbgr780071.outbound.protection.outlook.com ([40.107.78.71]:35136
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731100AbfAIQVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibrdH3Wb03akSIyfyMarEpEJn9iSs6l9EvYRZDtHYzU=;
 b=f/5I9OhpuSI/l3sBKbcjjcNJBmI6DBwmclyyaTYpZxx53BeDbzlNy94eY3MQ2dozz5mIHvYHc8MFKwAxkp2Lk2uhUAX/NyVqUX/F3P0G3jHyPd3BJ42Gthd2UGIIXRhj4Xu//q/z49BHL1FM8Pb5qhu7WL64rwcc2KVM9mzud5Y=
Received: from BN6PR05MB3282.namprd05.prod.outlook.com (10.174.95.29) by
 BN6PR05MB3364.namprd05.prod.outlook.com (10.174.95.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:18:25 +0000
Received: from BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::93c:653a:fcac:74fe]) by BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::93c:653a:fcac:74fe%3]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:18:25 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:08:58 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:08:58 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 3/7] qtnfmac: add support for 4addr mode
Thread-Topic: [PATCH 3/7] qtnfmac: add support for 4addr mode
Thread-Index: AQHUqDWg3er6X1GCYEuBkwCp6ITIQQ==
Date:   Wed, 9 Jan 2019 16:08:58 +0000
Message-ID: <20190109160843.14832-4-sergey.matyukevich.os@quantenna.com>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR05MB3364;6:VxkXWgfrvGe0s/lIhYjrxcBYCjokcJlyIeESNj0ZWAXF3j2MET9EKzRoSXnrEts8IBwcQAuQ9n71a/eBSc0RcI94FN4vFOLO/0W3qfTrJlYX/5tNuqnYHNPyfo3vV/DC3ms0PZIXMUBIqATypKmxBoABLoJWUuoL6jtCKMZa0jxi3gonUr+2b2dm2w+42yX+uKigWSFV7EuMd7GysP5Xjy4zSzDGPE4o9uelo6ZIvX6j+6G7rYV0rsucSwW66dueRnV1VzQt1QFROOuPQbD3pmQXdygC3G9oRuSTclG/qdS8VuK1qtsJf4Xy543iLZgtzq0saYoovxe5Tb74/VW1ygV80Mm0naKblaFPrggQRun4PBFDI0ioEWh0CTmUIF94GhfipQqJc1tJ3u6UsVfr3OSphV9tkMaKZScqHfKskvzIlkY+r1sOzAJ4ihSLXpXsgJ9T/0cKWvX5F3F/wO7sYA==;5:jpHiHdZb+5RYM2VZgvST8ATwH4adhdIBVcJcxxV7kn91WMDQ4ZIipAxasCyKCfCCRsTxebBA+7592PjAG6zQXTvIZjNo60nwYVaAMeR+s3b7t/lZGfWv1+LdtBlxCZwumBvYc5A7Yd96S4hchHm7U7/HDWsmBqOVHWaQVm15d7WfI7tBFXWqZxgqLA4HXn/3ta4Ci1cp0xXubHKngvZHuw==;7:OJ9bqTfBCZE674TDJcxv/+qIG+pZSDz6tUvp4pc9jUzT8cafTUTLwIbSq8C7JR2qQ6szWSJrZI9jv+jZ6k0CWCxXX+baENyQZuRxqBIX1WBDnU8wffk/I+s0N7nZggYtKvObbK+ggcDiEooVjI/xSg==
x-ms-office365-filtering-correlation-id: f792521d-1d60-4a86-81e5-08d6764cc2f6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|BN6PR05MB3364:
x-moderation-data: 1/9/2019 4:18:15 PM
x-microsoft-antispam-prvs: <BN6PR05MB336411F367B2E47FD0EC6CE9A38B0@BN6PR05MB3364.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(39850400004)(136003)(376002)(199004)(189003)(6346003)(68736007)(186003)(26005)(5024004)(14444005)(2906002)(102836004)(256004)(103116003)(436003)(71200400001)(71190400001)(6916009)(5660300001)(25786009)(11346002)(2616005)(446003)(476003)(3846002)(53936002)(36756003)(6116002)(6512007)(1076003)(478600001)(2501003)(14454004)(54906003)(2351001)(99286004)(6486002)(4326008)(5640700003)(486006)(66066001)(97736004)(6436002)(386003)(6506007)(316002)(105586002)(7736002)(305945005)(107886003)(86362001)(575784001)(52116002)(76176011)(8936002)(81166006)(81156014)(106356001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR05MB3364;H:BN6PR05MB3282.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l2yxatsjsgKXyMQ/wz2+kGwGtzzj7hbV/qY0uJfw+Ks9zJGmHJUPZci8yZ/VnqCswvQQDVTLUfXBaf095WsVFwEurV6jBjiVpvcjPdCrZkLxlfvsstDBZZnFQD+oxrt1lReiGU0+5d+fvo8QTv7mShgBg0Qj4RiQtLSH+ku+0jM5kfZGdxbGSbAccuE+sAfH/9x4ZzC6xH8p40l2/nqviTdqW7RT1YJx1S5c3r4rnJG55CWg/XK3jPARIhhp5ruenrpTE/21wG7UWe8M1f8cYOCShzlNQa4EFmdiquwsH69lWshlmyCPifyVIqQqYguK
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f792521d-1d60-4a86-81e5-08d6764cc2f6
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:18:25.0785
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3364
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Advertise WIPHY_FLAG_4ADDR_STATION capability to wireless core. Send
use4addr interface change flag to firmware in change_virtual_intf
cfg80211 callback.

In order to enable adding wireless station interface to bridge
one should turn on 4addr mode using the following command:
$ iw dev wlan0 set 4addr on
$ brctl addif br0 wlan0

If this commands succeeds, then interface can be added to bridge.
Note that when wireless interface is added to bridge, wpa_supplicant
should be started with appropriate -b <brname> parameter, e.g:
$ wpa_supplicant -Dnl80211 -iwlan0 -c/path/to/wpa_s.conf -b br0

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  8 +++++---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 14 +++++++++-----
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  6 ++++--
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  4 +++-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  3 ++-
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 51b33ec78fac..9e0ac1744be7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -139,7 +139,8 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
=20
 	qtnf_scan_done(vif->mac, true);
=20
-	ret =3D qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
+	ret =3D qtnf_cmd_send_change_intf_type(vif, type, params->use_4addr,
+					     mac_addr);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to change type to %d\n",
 		       vif->mac->macid, vif->vifid, type);
@@ -228,7 +229,7 @@ static struct wireless_dev *qtnf_add_virtual_intf(struc=
t wiphy *wiphy,
 	if (params)
 		mac_addr =3D params->macaddr;
=20
-	ret =3D qtnf_cmd_send_add_intf(vif, type, mac_addr);
+	ret =3D qtnf_cmd_send_add_intf(vif, type, params->use_4addr, mac_addr);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to add VIF %pM\n",
 		       mac->macid, vif->vifid, mac_addr);
@@ -1107,7 +1108,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 	wiphy->flags |=3D WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
-			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+			WIPHY_FLAG_HAS_CHANNEL_SWITCH |
+			WIPHY_FLAG_4ADDR_STATION;
 	wiphy->flags &=3D ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
=20
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index c2f085589f54..0748a756cc1c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -734,6 +734,7 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u=
8 *sta_mac,
=20
 static int qtnf_cmd_send_add_change_intf(struct qtnf_vif *vif,
 					 enum nl80211_iftype iftype,
+					 int use4addr,
 					 u8 *mac_addr,
 					 enum qlink_cmd_type cmd_type)
 {
@@ -751,6 +752,7 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vi=
f *vif,
 	qtnf_bus_lock(vif->mac->bus);
=20
 	cmd =3D (struct qlink_cmd_manage_intf *)cmd_skb->data;
+	cmd->intf_info.use4addr =3D use4addr;
=20
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
@@ -786,17 +788,19 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_=
vif *vif,
 	return ret;
 }
=20
-int qtnf_cmd_send_add_intf(struct qtnf_vif *vif,
-			   enum nl80211_iftype iftype, u8 *mac_addr)
+int qtnf_cmd_send_add_intf(struct qtnf_vif *vif, enum nl80211_iftype iftyp=
e,
+			   int use4addr, u8 *mac_addr)
 {
-	return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+	return qtnf_cmd_send_add_change_intf(vif, iftype, use4addr, mac_addr,
 			QLINK_CMD_ADD_INTF);
 }
=20
 int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
-				   enum nl80211_iftype iftype, u8 *mac_addr)
+				   enum nl80211_iftype iftype,
+				   int use4addr,
+				   u8 *mac_addr)
 {
-	return qtnf_cmd_send_add_change_intf(vif, iftype, mac_addr,
+	return qtnf_cmd_send_add_change_intf(vif, iftype, use4addr, mac_addr,
 					     QLINK_CMD_CHANGE_INTF);
 }
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.h
index 1ac41156c192..1c25e7905e9a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -26,9 +26,11 @@ void qtnf_cmd_send_deinit_fw(struct qtnf_bus *bus);
 int qtnf_cmd_get_hw_info(struct qtnf_bus *bus);
 int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac);
 int qtnf_cmd_send_add_intf(struct qtnf_vif *vif, enum nl80211_iftype iftyp=
e,
-			   u8 *mac_addr);
+			   int use4addr, u8 *mac_addr);
 int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
-				   enum nl80211_iftype iftype, u8 *mac_addr);
+				   enum nl80211_iftype iftype,
+				   int use4addr,
+				   u8 *mac_addr);
 int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
 int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 			   struct ieee80211_supported_band *band);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index 5d18a4a917c9..29258acfa8dc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -195,6 +195,7 @@ static int qtnf_netdev_set_mac_address(struct net_devic=
e *ndev, void *addr)
 	qtnf_scan_done(vif->mac, true);
=20
 	ret =3D qtnf_cmd_send_change_intf_type(vif, vif->wdev.iftype,
+					     vif->wdev.use_4addr,
 					     sa->sa_data);
=20
 	if (ret)
@@ -545,7 +546,8 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, u=
nsigned int macid)
 		goto error;
 	}
=20
-	ret =3D qtnf_cmd_send_add_intf(vif, vif->wdev.iftype, vif->mac_addr);
+	ret =3D qtnf_cmd_send_add_intf(vif, vif->wdev.iftype,
+				     vif->wdev.use_4addr, vif->mac_addr);
 	if (ret) {
 		pr_err("MAC%u: failed to add VIF\n", macid);
 		goto error;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index f9c7f87afaf8..a78cb9e05068 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -105,7 +105,8 @@ struct qlink_intf_info {
 	__le16 if_type;
 	__le16 vlanid;
 	u8 mac_addr[ETH_ALEN];
-	u8 rsvd[2];
+	u8 use4addr;
+	u8 rsvd[1];
 } __packed;
=20
 enum qlink_sta_flags {
--=20
2.11.0

