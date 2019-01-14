Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7FBC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A33020659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="TsAnEBE/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfANJkt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:49 -0500
Received: from mail-eopbgr790070.outbound.protection.outlook.com ([40.107.79.70]:43488
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfANJkt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeHCEWSeIcnffZU20VFfQmQHKR/Jac8Ua7kfYOL3Owc=;
 b=TsAnEBE/ZEFCZGlhokdyRhbBrH0/1CiroAWFmifNC0sjaE1zS264s+TEAWDwvFxoK6WwLBtWhzVdt9E0RJTCoejLIEpX16BKOZp2QhI0T4jMQdzznJG8ahMc8itOXEygUJYjI+oonu0aozFD7PNY0uyizhNJrtbvay7q1hVzuU4=
Received: from DM6PR05MB4956.namprd05.prod.outlook.com (20.177.221.139) by
 DM6PR05MB6364.namprd05.prod.outlook.com (20.178.224.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.16; Mon, 14 Jan 2019 09:40:39 +0000
Received: from DM6PR05MB4956.namprd05.prod.outlook.com
 ([fe80::bcdf:d16c:dcc5:524f]) by DM6PR05MB4956.namprd05.prod.outlook.com
 ([fe80::bcdf:d16c:dcc5:524f%5]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:39 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5838.namprd05.prod.outlook.com (20.177.255.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:39 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:39 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 3/9] qtnfmac: add support for 4addr mode
Thread-Topic: [PATCH v2 3/9] qtnfmac: add support for 4addr mode
Thread-Index: AQHUq+0Rf7L9K+H2OUK3+C6FxJ5odA==
Date:   Mon, 14 Jan 2019 09:39:38 +0000
Message-ID: <20190114093925.9061-4-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB6364;6:elckr+ZEbma1Z5UuPzZQeD53VCymo4iy+DDxXqL3eWQ5ddtaCWbn8x6OGEdAg/SitlN7YyBskAY15e34CPRIo0IewdoKC6GDiQ1tnnzvPRkBGyfWF9uLBJ39TiwtaHf0SRC4sgHNoxa2P7UQb9ieBJt9e0HoUcq1jxg53iqWrZIVWysEkAB1Be7kOz9GRi6r5CiH7w4O6is3Olw2PVuxY8vjB/xbtLb5bApzvyBsWvE5UUeVdNm/g3W0NQvTO7O1B9syboiS9E0y0B3XDn0s3Ift+dra9BX9tiYFZSL3UzwulbEsfhwh7LzUIzCrIGWLP1lY8ymdx36CpSbaQ803bhGpa8DkfuQkNGnZhdyUMltBso4i8PoGsGacSOUgTKwzJTjun5RXK5ztAnfD+IKDbbOKR1OTyGp0VeKEUh+bjMWRTFLjhFGfgw9LDXiEJeSQx3F1mWtc/CWFyr46ZHMWAA==;5:U2YgQt6PSQ1nr7pjTTvT4p6gl6kX5R7zMxcC5ThMAsRvVe+SjZEKCCjAJLsbUPH+Z+OoYpUw91rw+O7/tG5JCPnumid0PFIJGJX3cxmqcLwY7f4vfp+d/TH9ur9KNtQKQ1ncoVSSgNyWAI+3w5trCMqwdKMi59tZYtSuskUJJu5+9vuh2QQu4XZ6J/h8MvzLrDLIv0fSEc/8gNcZLy9QIg==;7:3v9DSe8M/BTOvrSEHyWRn00kJgd23THKbj9HaiH94rrCKm6P6yQFWckfyBOSv5/Np4KmFdJo1FZL7Cl32Nc/EaOkUyWU1w/rrUVLjgIKGkyXm//jdMdXr0aP3JIdOWyIf5+uzd14/YBvhYxl67V88Q==
x-ms-office365-filtering-correlation-id: 8ac94d48-b69f-48ac-fafa-08d67a0433aa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5838;
x-ms-traffictypediagnostic: SN6PR05MB5838:|DM6PR05MB6364:
x-moderation-data: 1/14/2019 9:40:37 AM
x-microsoft-antispam-prvs: <DM6PR05MB6364202A831F4E798FC718CBA3800@DM6PR05MB6364.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(346002)(39840400004)(189003)(199004)(305945005)(97736004)(486006)(6506007)(6436002)(66066001)(1076003)(2351001)(8676002)(5640700003)(5660300001)(4326008)(256004)(436003)(478600001)(7736002)(99286004)(102836004)(5024004)(14444005)(386003)(25786009)(68736007)(26005)(6916009)(36756003)(52116002)(71200400001)(71190400001)(6486002)(2906002)(76176011)(103116003)(81156014)(2616005)(316002)(3846002)(186003)(6116002)(446003)(11346002)(476003)(81166006)(14454004)(2501003)(54906003)(6512007)(107886003)(86362001)(53936002)(105586002)(8936002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6364;H:DM6PR05MB4956.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lzc0UTlU1aVzjvcrpFDmYVM+o9S/G9/M4O5BPuaE3qcOsbFJlJDOynH0Yyc5LuCAW+iLR7g1g73zFrOrF/pewX/Sn5lT6r14339ZuRLVqxFaPcb+sV//bRYA+abgi1tbJnI1v0od6nY0R7eztcJkDztGtavG8rH20ocC5ArW7B3z/CszPbkH9EzMPni+gxIafQS/PFh4Donyh6/mo0nBDW9ZobEXLpz4PJA9iWDafP0mWeEysUiIILvM0ectTZtuRj5IPU+k2CkKy04V6at/ktEedMJkE0g2yYqoSpxUViUf/PvzAT7+Ipo+DwVdCm5pHf9ocovqCZoJVCBXJWDRhVtgJl54bLBAGBi/hUcQ72TMY5viSZt/bpAxAdSAw+eZrdD7Kl/kwUH93GyqZ0KTU3ZjrtrBYwT567hyegY+M8o=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac94d48-b69f-48ac-fafa-08d67a0433aa
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:39.4451
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6364
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
$ wpa_supplicant -Dnl80211 -iwlan0 -c/path/to/wpa.conf -b br0

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 21 +++++++++++++------=
--
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 14 +++++++++-----
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  6 ++++--
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  4 +++-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  3 ++-
 5 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 51b33ec78fac..a43f8120df3c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -122,7 +122,8 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
 			 struct vif_params *params)
 {
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(dev);
-	u8 *mac_addr;
+	u8 *mac_addr =3D NULL;
+	int use4addr =3D 0;
 	int ret;
=20
 	ret =3D qtnf_validate_iface_combinations(wiphy, vif, type);
@@ -132,14 +133,14 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
 		return ret;
 	}
=20
-	if (params)
+	if (params) {
 		mac_addr =3D params->macaddr;
-	else
-		mac_addr =3D NULL;
+		use4addr =3D params->use_4addr;
+	}
=20
 	qtnf_scan_done(vif->mac, true);
=20
-	ret =3D qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
+	ret =3D qtnf_cmd_send_change_intf_type(vif, type, use4addr, mac_addr);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to change type to %d\n",
 		       vif->mac->macid, vif->vifid, type);
@@ -190,6 +191,7 @@ static struct wireless_dev *qtnf_add_virtual_intf(struc=
t wiphy *wiphy,
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
 	u8 *mac_addr =3D NULL;
+	int use4addr =3D 0;
 	int ret;
=20
 	mac =3D wiphy_priv(wiphy);
@@ -225,10 +227,12 @@ static struct wireless_dev *qtnf_add_virtual_intf(str=
uct wiphy *wiphy,
 		return ERR_PTR(-ENOTSUPP);
 	}
=20
-	if (params)
+	if (params) {
 		mac_addr =3D params->macaddr;
+		use4addr =3D params->use_4addr;
+	}
=20
-	ret =3D qtnf_cmd_send_add_intf(vif, type, mac_addr);
+	ret =3D qtnf_cmd_send_add_intf(vif, type, use4addr, mac_addr);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to add VIF %pM\n",
 		       mac->macid, vif->vifid, mac_addr);
@@ -1107,7 +1111,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
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

