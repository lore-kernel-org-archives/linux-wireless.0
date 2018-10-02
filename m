Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78291C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2805220878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="MAEnA5Jp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2805220878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbeJBQIU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:20 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeJBQIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y42ppIgBX5CrXQDb+54JHqLDJRBqNShEOU+0+PepX14=;
 b=MAEnA5JpKzhCSziVWaTULufiXATpVXHJ7v+AzkAus5PDm8WuWZCmsdY2S2SYIYlc39Sg7ja2EQfAzcdQZnYuCj0YQus/W4cZ4ew4a44XU7A8GcCGZcZAKlTirUZAbFrfzHjqOUcl51F/EL7Cn+qV5xiNIH+v6I3qLqkgrqCT9k8=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:25:56 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:25:56 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 01/13] qtnfmac: do not track STA states in driver
Thread-Topic: [PATCH 01/13] qtnfmac: do not track STA states in driver
Thread-Index: AQHUWjHrSNw2vWQO9UKaWyboiqFTHw==
Date:   Tue, 2 Oct 2018 09:25:55 +0000
Message-ID: <20181002092542.18966-2-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:+8QDda0t1RLAFbU7bN2j92tU065RuA8E46/5TsPKe9VkKJ5ASSddSyLVwu19eI1t/e4sRdcWjSJaE14CHiv5HzmMuXuDHAcon631Bh9G/aviYBMyIdqTihzLM47M29g9F6skILybBNlfQAl1H1tyYcQkvjjgDK90u54FE5F+9Oy7fPoQrhdqd73zzUjbCR2WfUf5heicz53ANzswjWLMGcBSmZ5s2AN02DqMUC47bez0IsSHs1RvzpG7LRAK3lbIGwXYIqapIPcNeUSVWC4bthFouNOEWz0HFAqlHbiSYGy72d7FUtL+mdU1xfe+bfiLgN+rIWttnHrEwg9T00A+lA9KvQcAyF3j4jU1mrPJxnOwZqO3Ot1NjeI4NxefYYQx9AJcNmBzLtV+JK6CgJurwK/aUVIlaS/Jgn0IjgXI11Ca7u2rRFCRRltIaOAidn9tAOwoxZH8HIRA6994gf30IA==;5:ld0g6FagAk1iC82MYMz7sUKcYbM7NZKfsnbQBpid2pO0x9ryQBuDQWdVDyAsJYrNcNMPsKWi51QpQFmVTDpXbIpiIzQkvOcV2e40VX605NS3DtoS8GpVKWW1ejPbVgQ4B+8Q5rvKvzEYXEtnTu16Mu5XVux9x40/A33JMPIw6ws=;7:RwIeLsvL61ZTJxbeIjz7k3+YiWEyzvEhggL/9YrypkxTXmbtAmtYIfJLLvfKCE4hB2AkvIliVONgPzhiAmwf/byElCIBuZLRkaODlnd6QM+GyFa6V+YBx2NZZgKGiJOdi0mYKtCBfVX2IIK4a8jOeUJGcCYli46KCuaHqvfQPEgUfN0Tm559mNUa5ycVRLPp56Z8UYFpBSH+/xAMKAu0vRuE0TTXzYMRMJw0+dWjxXWx16zRVtpMO+MLDhCtxl6k
x-ms-office365-filtering-correlation-id: ddaf13d2-e350-4f57-f5cf-08d628490e2f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB5092A58D821BA0BDCBE97F56A3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(54906003)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(8676002)(14444005)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(76176011)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(446003)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(11346002)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: VwkxzcrsTU7CYBo0qvvmHRK3Qjvh0Q1uMD6rCjtECz+sHemEa0Zvl66lLPlDtXXCFP+H1zoYnoFjtfwkuDWqnOeasHQqYkNe63vV4a5I0kMVHYUidqKWDGappGOu3oxMbitF2/yQZ5VXV0D0SLfj7ejJ9QL5EhuwjojRfPIY7SqvcUyKRwn/WTmzRir4+ONtHcnGmCxqaF0JyybkDfmvnXCYAeWQdU6dr1CHZBKV1TlsMZgmeXjP+Im++VQ7YLumz6QiNWQNfJthppPgPnWZL9K72nhozsZcJgY9tABNHHbafrxdfiPcADsBSiUYVBMm4nEvSP2OOuGYjUs4n+AerxNh02sGxLQTrAFsycKkD74=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaf13d2-e350-4f57-f5cf-08d628490e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:25:56.0175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
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

