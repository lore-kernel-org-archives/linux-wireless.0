Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754880AbeDYRTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 12/21] staging: wilc1000: rename mac status macros and moved related #define together
Date: Wed, 25 Apr 2018 22:48:17 +0530
Message-ID: <1524676706-13179-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191959_296164_24FBD227)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the mac status macro to follow the same naming style. Also move
them to keep together.

Renamed like below

>From ------------------------> To

WILC_MAC_STATUS_INIT -> MAC_STATUS_INIT
MAC_CONNECTED --------> MAC_STATUS_CONNECTED
MAC_DISCONNECTED -----> MAC_STATUS_DISCONNECTED

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 22 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  8 ++++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1b282b0..758dc44 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1135,7 +1135,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
 							       &conn_info,
-							       MAC_DISCONNECTED,
+							       MAC_STATUS_DISCONNECTED,
 							       NULL,
 							       conn_attr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
@@ -1193,7 +1193,7 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
 						  &info,
-						  MAC_DISCONNECTED,
+						  MAC_STATUS_DISCONNECTED,
 						  NULL,
 						  hif_drv->usr_conn_req.arg);
 
@@ -1321,7 +1321,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 
 	memset(&conn_info, 0, sizeof(struct connect_info));
 
-	if (mac_status == MAC_CONNECTED) {
+	if (mac_status == MAC_STATUS_CONNECTED) {
 		u32 rcvd_assoc_resp_info_len;
 
 		memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
@@ -1357,20 +1357,20 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 		}
 	}
 
-	if (mac_status == MAC_CONNECTED &&
+	if (mac_status == MAC_STATUS_CONNECTED &&
 	    conn_info.status != SUCCESSFUL_STATUSCODE) {
 		netdev_err(vif->ndev,
-			   "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
+			   "Received MAC status is MAC_STATUS_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 		eth_zero_addr(wilc_connected_ssid);
-	} else if (mac_status == MAC_DISCONNECTED)    {
-		netdev_err(vif->ndev, "Received MAC status is MAC_DISCONNECTED\n");
+	} else if (mac_status == MAC_STATUS_DISCONNECTED)    {
+		netdev_err(vif->ndev, "Received MAC status is MAC_STATUS_DISCONNECTED\n");
 		eth_zero_addr(wilc_connected_ssid);
 	}
 
 	if (hif_drv->usr_conn_req.bssid) {
 		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
 
-		if (mac_status == MAC_CONNECTED &&
+		if (mac_status == MAC_STATUS_CONNECTED &&
 		    conn_info.status == SUCCESSFUL_STATUSCODE) {
 			memcpy(hif_drv->assoc_bssid,
 			       hif_drv->usr_conn_req.bssid, ETH_ALEN);
@@ -1390,7 +1390,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 					  &conn_info, mac_status, NULL,
 					  hif_drv->usr_conn_req.arg);
 
-	if (mac_status == MAC_CONNECTED &&
+	if (mac_status == MAC_STATUS_CONNECTED &&
 	    conn_info.status == SUCCESSFUL_STATUSCODE) {
 		wilc_set_power_mgmt(vif, 0, 0);
 
@@ -1498,10 +1498,10 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 		mac_status_additional_info = rcvd_info->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			host_int_parse_assoc_resp_info(vif, mac_status);
-		} else if ((mac_status == MAC_DISCONNECTED) &&
+		} else if ((mac_status == MAC_STATUS_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
 			host_int_handle_disconnect(vif);
-		} else if ((mac_status == MAC_DISCONNECTED) &&
+		} else if ((mac_status == MAC_STATUS_DISCONNECTED) &&
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 85b290a..f09d6a8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -226,7 +226,7 @@ void wilc_mac_indicate(struct wilc *wilc, int flag)
 	if (flag == WILC_MAC_INDICATE_STATUS) {
 		wilc_wlan_cfg_get_val(WID_STATUS,
 				      (unsigned char *)&status, 4);
-		if (wilc->mac_status == WILC_MAC_STATUS_INIT) {
+		if (wilc->mac_status == MAC_STATUS_INIT) {
 			wilc->mac_status = status;
 			complete(&wilc->sync_event);
 		} else {
@@ -725,7 +725,7 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 	struct wilc *wl = vif->wilc;
 
 	if (!wl->initialized) {
-		wl->mac_status = WILC_MAC_STATUS_INIT;
+		wl->mac_status = MAC_STATUS_INIT;
 		wl->close = 0;
 
 		wlan_init_locks(dev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9e87b91..3ca0c97 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -489,7 +489,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 
 		connect_status = conn_info->status;
 
-		if (mac_status == MAC_DISCONNECTED &&
+		if (mac_status == MAC_STATUS_DISCONNECTED &&
 		    conn_info->status == SUCCESSFUL_STATUSCODE) {
 			connect_status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 1982348..aa0731e 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -48,10 +48,12 @@ struct sdio_cmd53 {
 };
 
 #define WILC_MAC_INDICATE_STATUS	0x1
-#define WILC_MAC_STATUS_INIT		-1
-
 #define WILC_MAC_INDICATE_SCAN		0x2
 
+#define MAC_STATUS_INIT			-1
+#define MAC_STATUS_CONNECTED		1
+#define MAC_STATUS_DISCONNECTED		0
+
 struct tx_complete_data {
 	int size;
 	void *buff;
@@ -117,8 +119,6 @@ enum {
 	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
 };
 
-#define MAC_CONNECTED		1
-#define MAC_DISCONNECTED	0
 enum {
 	PASSIVE_SCAN		= 0,
 	ACTIVE_SCAN		= 1,
-- 
2.7.4
