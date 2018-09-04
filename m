Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53863 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbeIDLEp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:45 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 22/26] staging: wilc1000: move 'wilc_connecting' static variable to 'wilc_vif' struct
Date: Tue, 4 Sep 2018 12:09:38 +0530
Message-ID: <1536043182-19735-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084930_917159_94A3B741)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move static variable 'wilc_connecting' as part of 'wilc_vif' private
struct. Remove "wilc_" prefix from name as its already part of wilc_vif
struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/host_interface.h         |  2 --
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 ++++++++----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 14dfa61..7805ec1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -724,7 +724,7 @@ static void handle_scan(struct work_struct *work)
 		goto error;
 	}
 
-	if (vif->obtaining_ip || wilc_connecting) {
+	if (vif->obtaining_ip || vif->connecting) {
 		netdev_err(vif->ndev, "Don't do obss scan\n");
 		result = -EBUSY;
 		goto error;
@@ -2330,7 +2330,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		goto error;
 	}
 
-	if (vif->obtaining_ip || wilc_connecting) {
+	if (vif->obtaining_ip || vif->connecting) {
 		result = -EBUSY;
 		goto error;
 	}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6006769..a48818f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -361,6 +361,4 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
 
 extern u8 wilc_connected_ssid[6];
 
-extern int wilc_connecting;
-
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 35a83d4..d103dce2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -453,8 +453,6 @@ static inline bool wilc_cfg_scan_time_expired(struct wilc_priv *priv, int i)
 		return false;
 }
 
-int wilc_connecting;
-
 static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			       struct connect_info *conn_info,
 			       u8 mac_status,
@@ -468,7 +466,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 	struct host_if_drv *wfi_drv = priv->hif_drv;
 	u8 null_bssid[ETH_ALEN] = {0};
 
-	wilc_connecting = 0;
+	vif->connecting = false;
 
 	if (conn_disconn_evt == CONN_DISCONN_EVENT_CONN_RESP) {
 		u16 connect_status;
@@ -666,7 +664,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	enum authtype auth_type = ANY;
 	u32 cipher_group;
 
-	wilc_connecting = 1;
+	vif->connecting = true;
 
 	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
 		wfi_drv->p2p_connect = 1;
@@ -698,7 +696,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		nw_info = &priv->scanned_shadow[sel_bssi_idx];
 	} else {
 		ret = -ENOENT;
-		wilc_connecting = 0;
+		vif->connecting = false;
 		return ret;
 	}
 
@@ -741,7 +739,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			ret = -ENOTSUPP;
 			netdev_err(dev, "%s: Unsupported cipher\n",
 				   __func__);
-			wilc_connecting = 0;
+			vif->connecting = false;
 			return ret;
 		}
 	}
@@ -792,7 +790,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (ret != 0) {
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret = -ENOENT;
-		wilc_connecting = 0;
+		vif->connecting = false;
 		return ret;
 	}
 
@@ -809,7 +807,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 	u8 null_bssid[ETH_ALEN] = {0};
 
-	wilc_connecting = 0;
+	vif->connecting = false;
 
 	if (!wilc)
 		return -EIO;
@@ -1747,7 +1745,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
-		wilc_connecting = 0;
+		vif->connecting = false;
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
@@ -1762,7 +1760,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wilc_connecting = 0;
+		vif->connecting = false;
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ede967b..1837808 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -149,6 +149,7 @@ struct wilc_vif {
 	struct timer_list periodic_rssi;
 	struct rf_info periodic_stat;
 	struct tcp_ack_filter ack_filter;
+	bool connecting;
 };
 
 struct wilc {
-- 
2.7.4
