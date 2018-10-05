Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9440DC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39E0720875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="LaTxkl/5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39E0720875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbeJERJg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:36 -0400
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:30496
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y42ppIgBX5CrXQDb+54JHqLDJRBqNShEOU+0+PepX14=;
 b=LaTxkl/5WA8fITS+ZAy6trjJtuVylKrF5Eyz1AcC8cz5Ss8cKVMqKz33fLUHKLWnGYKUo2LviEQF2okN7RNAxhQGHQ8XqtXrijU4GEOWSkA61qKfvHLzts5UHjpsBkbQh7zhheTtmiJDyVGjss2aRvg7a/yn5tiXgeEKPvLdKeo=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4375.namprd05.prod.outlook.com (52.135.202.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:27 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:27 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 01/13] qtnfmac: do not track STA states in driver
Thread-Topic: [PATCH v2 01/13] qtnfmac: do not track STA states in driver
Thread-Index: AQHUXJPHFGcPHuWBbEuV96JQbGs6cQ==
Date:   Fri, 5 Oct 2018 10:11:27 +0000
Message-ID: <20181005101114.3013-2-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4375;6:Cd1rPVSQx/v9uWyELn++LWstlw4zD/sHlCn4Hjf03+AbJ7dfE/kugkSEs1ZWpbTa7djJAfr1qwdFeUisD49sVagiog1F18YZy/h5cgpW5XPVT8UkiIjN2cBWKQ5bJQsMyLIHeWT3nT+cQOVvcrKZ1zaWBxSSJvOsD3ml4ay66j5iG2lWUOgcpHzi1ZLCKIJHPMxJqGQrnjJzP0Ne7mPIu7IPb4LF45YVihB9ZdavSJvpwfBsgcQzWT1Q3vLHP6mAxd+kawMghEYsc82yt5XaX1AWZFJRksuy1vwAwzBkFJi9Xs94wLt6sHqOXfSleBrabFE1g9Y4uZmkODW97HTccnRJlj1hmAuBbJzt/5eqYeEuyrKX562CDE/qThv1IZLIJc1XZnOAafHar9piA2RqWQfyaY5sjyR1dZIiGBZltAQDBWIEdG+j+KbiljevPEUIXF9axseufBcOCv1iSAv+Lg==;5:Fe3CD2zw6QB0LjAj02XJQoCCG+MvwzT0tzvWnGCyOsN/iOeNORz4FxvC6PnzDrGQPEuPTRQyr9SJ999F2uPT/m7zUStjDZ1mh6BiSo+H5EUwKDALsO7bSBD1muHuANYUHy7yw7VfWTTz5sjWf0hXpYqmt41RdKALKX/tD9uOmew=;7:d+xBrQ7lVUlBtiE495moa1yUY82LJ2SeeqfF6g0YpWYMdulv1geP2H+Mrowzw8inhyDVPrn6D+B7l66ac4BzegRlQnBA6LKHOunwcIQ+87pgtqyfKC9FiIyvtMDz+KqHlQM+3U5V5zbpuvXANZYXKIYYHmxOQ9Nn/dkkd8jARK08YI67X3OGsH5EWl92/1zBhLRIci5mDKbXKLZRBwwBwa7Ch19TCJdaTFzBQhdGO+4klxzL5FJYCDEHgm+N1vh2
x-ms-office365-filtering-correlation-id: aee0dec9-3ecf-45d6-d48f-08d62aaae980
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4375;
x-ms-traffictypediagnostic: BYAPR05MB4375:
x-microsoft-antispam-prvs: <BYAPR05MB4375CBE377612B68DABCD404A3EB0@BYAPR05MB4375.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051);SRVR:BYAPR05MB4375;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4375;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(366004)(376002)(346002)(189003)(199004)(6916009)(478600001)(6506007)(386003)(106356001)(105586002)(99286004)(6512007)(2900100001)(97736004)(2351001)(4326008)(25786009)(76176011)(36756003)(53936002)(2906002)(103116003)(107886003)(2501003)(52116002)(486006)(5660300001)(5250100002)(2616005)(446003)(476003)(305945005)(8676002)(8936002)(102836004)(14444005)(26005)(11346002)(3846002)(71190400001)(71200400001)(1076002)(6116002)(14454004)(68736007)(6436002)(6486002)(5640700003)(7736002)(54906003)(186003)(86362001)(316002)(256004)(66066001)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4375;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: JGZdYwn6Wo7x5zHBluEhbrROJ4xsB5b4PFDLRMD9nt9hIF05yPtdp9bk3yhvwVwN/8cncybKTBxbX5Rc1DjnK3DeAyjACV9Fn+/eknJulkZ+ZP+yAy1yV9fhpiv2hA3rdZExIOFa1ZY3Ky5wISEwlchMSaYPNpaPDMaVKPvlhF8Ssf0sZWkkwOIX+dU2kkQnbLsttxUtG1H9sRZ7e2W8dcwScRRYLPbNZ1O+zS4abEisbwTMlcnho0kbtG+Dw5DudLb06ThrMUIIl1niSsZNKGnceHeJuObLIQoSyrDOD+d2/ysfizJAyF4TGtMjL8csYaOUelajIsPmzYHuAud6r70Evkk0LN5uBe3t4ST6Snw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee0dec9-3ecf-45d6-d48f-08d62aaae980
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:27.4238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4375
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove STA connection states tracking from driver.
Leave it wireless core on host and to firmware.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 59 +++----------------=
----
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  7 ---
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 18 +------
 3 files changed, 8 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 452d4b7c832d..776cfba7396e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -216,7 +216,6 @@ static struct wireless_dev *qtnf_add_virtual_intf(struc=
t wiphy *wiphy,
 		eth_zero_addr(vif->mac_addr);
 		eth_zero_addr(vif->bssid);
 		vif->bss_priority =3D QTNF_DEF_BSS_PRIORITY;
-		vif->sta_state =3D QTNF_STA_DISCONNECTED;
 		memset(&vif->wdev, 0, sizeof(vif->wdev));
 		vif->wdev.wiphy =3D wiphy;
 		vif->wdev.iftype =3D type;
@@ -624,9 +623,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *de=
v,
 	if (vif->wdev.iftype !=3D NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
=20
-	if (vif->sta_state !=3D QTNF_STA_DISCONNECTED)
-		return -EBUSY;
-
 	if (sme->bssid)
 		ether_addr_copy(vif->bssid, sme->bssid);
 	else
@@ -639,7 +635,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *de=
v,
 		return ret;
 	}
=20
-	vif->sta_state =3D QTNF_STA_CONNECTING;
 	return 0;
 }
=20
@@ -664,9 +659,6 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device =
*dev,
=20
 	qtnf_scan_done(mac, true);
=20
-	if (vif->sta_state =3D=3D QTNF_STA_DISCONNECTED)
-		goto out;
-
 	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
@@ -675,9 +667,6 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device =
*dev,
 	}
=20
 out:
-	if (vif->sta_state =3D=3D QTNF_STA_CONNECTING)
-		vif->sta_state =3D QTNF_STA_DISCONNECTED;
-
 	return ret;
 }
=20
@@ -1152,28 +1141,10 @@ void qtnf_virtual_intf_cleanup(struct net_device *n=
dev)
 	struct qtnf_wmac *mac =3D wiphy_priv(vif->wdev.wiphy);
=20
 	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION) {
-		switch (vif->sta_state) {
-		case QTNF_STA_DISCONNECTED:
-			break;
-		case QTNF_STA_CONNECTING:
-			cfg80211_connect_result(vif->netdev,
-						vif->bssid, NULL, 0,
-						NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_KERNEL);
-			qtnf_disconnect(vif->wdev.wiphy, ndev,
-					WLAN_REASON_DEAUTH_LEAVING);
-			break;
-		case QTNF_STA_CONNECTED:
-			cfg80211_disconnected(vif->netdev,
-					      WLAN_REASON_DEAUTH_LEAVING,
-					      NULL, 0, 1, GFP_KERNEL);
-			qtnf_disconnect(vif->wdev.wiphy, ndev,
-					WLAN_REASON_DEAUTH_LEAVING);
-			break;
-		}
-
-		vif->sta_state =3D QTNF_STA_DISCONNECTED;
+		cfg80211_disconnected(vif->netdev, WLAN_REASON_DEAUTH_LEAVING,
+				      NULL, 0, 1, GFP_KERNEL);
+		qtnf_disconnect(vif->wdev.wiphy, ndev,
+				WLAN_REASON_DEAUTH_LEAVING);
 	}
=20
 	qtnf_scan_done(mac, true);
@@ -1181,27 +1152,11 @@ void qtnf_virtual_intf_cleanup(struct net_device *n=
dev)
=20
 void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif)
 {
-	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION) {
-		switch (vif->sta_state) {
-		case QTNF_STA_CONNECTING:
-			cfg80211_connect_result(vif->netdev,
-						vif->bssid, NULL, 0,
-						NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_KERNEL);
-			break;
-		case QTNF_STA_CONNECTED:
-			cfg80211_disconnected(vif->netdev,
-					      WLAN_REASON_DEAUTH_LEAVING,
-					      NULL, 0, 1, GFP_KERNEL);
-			break;
-		case QTNF_STA_DISCONNECTED:
-			break;
-		}
-	}
+	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION)
+		cfg80211_disconnected(vif->netdev, WLAN_REASON_DEAUTH_LEAVING,
+				      NULL, 0, 1, GFP_KERNEL);
=20
 	cfg80211_shutdown_all_interfaces(vif->wdev.wiphy);
-	vif->sta_state =3D QTNF_STA_DISCONNECTED;
 }
=20
 void qtnf_band_init_rates(struct ieee80211_supported_band *band)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index a1e338a1f055..1722aecf7633 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -64,12 +64,6 @@ struct qtnf_sta_list {
 	atomic_t size;
 };
=20
-enum qtnf_sta_state {
-	QTNF_STA_DISCONNECTED,
-	QTNF_STA_CONNECTING,
-	QTNF_STA_CONNECTED
-};
-
 struct qtnf_vif {
 	struct wireless_dev wdev;
 	u8 bssid[ETH_ALEN];
@@ -77,7 +71,6 @@ struct qtnf_vif {
 	u8 vifid;
 	u8 bss_priority;
 	u8 bss_status;
-	enum qtnf_sta_state sta_state;
 	u16 mgmt_frames_bitmask;
 	struct net_device *netdev;
 	struct qtnf_wmac *mac;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index 68da81bec4e9..8b542b431b75 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -171,24 +171,14 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 		return -EPROTO;
 	}
=20
-	if (vif->sta_state !=3D QTNF_STA_CONNECTING) {
-		pr_err("VIF%u.%u: BSS_JOIN event when STA is not connecting\n",
-		       vif->mac->macid, vif->vifid);
-		return -EPROTO;
-	}
-
 	pr_debug("VIF%u.%u: BSSID:%pM\n", vif->mac->macid, vif->vifid,
 		 join_info->bssid);
=20
 	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
 				0, le16_to_cpu(join_info->status), GFP_KERNEL);
=20
-	if (le16_to_cpu(join_info->status) =3D=3D WLAN_STATUS_SUCCESS) {
-		vif->sta_state =3D QTNF_STA_CONNECTED;
+	if (le16_to_cpu(join_info->status) =3D=3D WLAN_STATUS_SUCCESS)
 		netif_carrier_on(vif->netdev);
-	} else {
-		vif->sta_state =3D QTNF_STA_DISCONNECTED;
-	}
=20
 	return 0;
 }
@@ -211,16 +201,10 @@ qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
 		return -EPROTO;
 	}
=20
-	if (vif->sta_state !=3D QTNF_STA_CONNECTED)
-		pr_warn("VIF%u.%u: BSS_LEAVE event when STA is not connected\n",
-			vif->mac->macid, vif->vifid);
-
 	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
=20
 	cfg80211_disconnected(vif->netdev, le16_to_cpu(leave_info->reason),
 			      NULL, 0, 0, GFP_KERNEL);
-
-	vif->sta_state =3D QTNF_STA_DISCONNECTED;
 	netif_carrier_off(vif->netdev);
=20
 	return 0;
--=20
2.11.0

