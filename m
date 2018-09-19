Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33719 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbeISLnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 20/29] staging: wilc1000: remove use of unnecessary 'wilc_connected_ssid' variable
Date: Wed, 19 Sep 2018 11:35:10 +0530
Message-ID: <1537337119-14952-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080643_711565_921AB770)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'wilc_connected_ssid' actually used to store the BSSID information for
connected BSSID. 'wilc_vif' already has 'bssid' variable to store the
same information. So refactor code to remove 'wilc_connected_ssid' and
instead used 'wilc_vif' struct 'bssid' element.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 24 -----------------------
 drivers/staging/wilc1000/host_interface.h         |  2 --
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 ++++++++++++++---------
 3 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 529390d..01db899 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -813,7 +813,6 @@ static void handle_scan(struct work_struct *work)
 	kfree(msg);
 }
 
-u8 wilc_connected_ssid[6] = {0};
 static void handle_connect(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
@@ -835,11 +834,6 @@ static void handle_connect(struct work_struct *work)
 		return;
 	}
 
-	if (memcmp(conn_attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
-		netdev_err(vif->ndev, "Discard connect request\n");
-		goto error;
-	}
-
 	bss_param = conn_attr->params;
 	if (!bss_param) {
 		netdev_err(vif->ndev, "Required BSSID not found\n");
@@ -1019,10 +1013,6 @@ static void handle_connect(struct work_struct *work)
 	cur_byte = wid_list[wid_cnt].val;
 	wid_cnt++;
 
-	if (conn_attr->bssid)
-		memcpy(wilc_connected_ssid,
-		       conn_attr->bssid, ETH_ALEN);
-
 	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      wid_cnt,
 				      wilc_get_vif_idx(vif));
@@ -1145,8 +1135,6 @@ static void handle_connect_timeout(struct work_struct *work)
 	kfree(hif_drv->usr_conn_req.ies);
 	hif_drv->usr_conn_req.ies = NULL;
 
-	eth_zero_addr(wilc_connected_ssid);
-
 out:
 	kfree(msg);
 }
@@ -1452,16 +1440,6 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 		}
 	}
 
-	if (mac_status == MAC_STATUS_CONNECTED &&
-	    conn_info.status != WLAN_STATUS_SUCCESS) {
-		netdev_err(vif->ndev,
-			   "Received MAC status is MAC_STATUS_CONNECTED, Assoc Resp is not SUCCESS\n");
-		eth_zero_addr(wilc_connected_ssid);
-	} else if (mac_status == MAC_STATUS_DISCONNECTED)    {
-		netdev_err(vif->ndev, "Received MAC status is MAC_STATUS_DISCONNECTED\n");
-		eth_zero_addr(wilc_connected_ssid);
-	}
-
 	if (hif_drv->usr_conn_req.bssid) {
 		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
 
@@ -1874,8 +1852,6 @@ static void handle_disconnect(struct work_struct *work)
 	vif->obtaining_ip = false;
 	wilc_set_power_mgmt(vif, 0, 0);
 
-	eth_zero_addr(wilc_connected_ssid);
-
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4416f8f..33fb731 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -359,6 +359,4 @@ int wilc_get_vif_idx(struct wilc_vif *vif);
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
 
-extern u8 wilc_connected_ssid[6];
-
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 76d017d..1a4d262 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -478,7 +478,6 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 			connect_status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
 					    STATION_MODE);
-			eth_zero_addr(wilc_connected_ssid);
 
 			if (!wfi_drv->p2p_connect)
 				wlan_channel = INVALID_CHANNEL;
@@ -521,7 +520,6 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 		wilc_ie = false;
 		eth_zero_addr(priv->associated_bss);
 		wilc_wlan_set_bssid(priv->dev, null_bssid, STATION_MODE);
-		eth_zero_addr(wilc_connected_ssid);
 
 		if (!wfi_drv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
@@ -696,8 +694,12 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		nw_info = &priv->scanned_shadow[sel_bssi_idx];
 	} else {
 		ret = -ENOENT;
-		vif->connecting = false;
-		return ret;
+		goto out_error;
+	}
+
+	if (ether_addr_equal_unaligned(vif->bssid, nw_info->bssid)) {
+		ret = -EALREADY;
+		goto out_error;
 	}
 
 	memset(priv->wep_key, 0, sizeof(priv->wep_key));
@@ -739,8 +741,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			ret = -ENOTSUPP;
 			netdev_err(dev, "%s: Unsupported cipher\n",
 				   __func__);
-			vif->connecting = false;
-			return ret;
+			goto out_error;
 		}
 	}
 
@@ -787,13 +788,18 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				security, auth_type,
 				nw_info->ch,
 				nw_info->join_params);
-	if (ret != 0) {
+	if (ret) {
+		u8 null_bssid[ETH_ALEN] = {0};
+
 		netdev_err(dev, "wilc_set_join_req(): Error\n");
 		ret = -ENOENT;
-		vif->connecting = false;
-		return ret;
+		wilc_wlan_set_bssid(dev, null_bssid, STATION_MODE);
+		goto out_error;
 	}
+	return 0;
 
+out_error:
+	vif->connecting = false;
 	return ret;
 }
 
-- 
2.7.4
