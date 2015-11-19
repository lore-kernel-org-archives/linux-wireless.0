Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59077 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbbKSGyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:18 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/26] staging: wilc1000: rename wilc_connected_SSID variable
Date: Thu, 19 Nov 2015 15:56:21 +0900
Message-ID: <1447916195-24851-12-git-send-email-glen.lee@atmel.com> (sfid-20151119_082251_591585_9BD484B5)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames wilc_connected_SSID variable to wilc_connected_ssid
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 22 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e366366..aae5a03 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -987,7 +987,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 	return result;
 }
 
-u8 wilc_connected_SSID[6] = {0};
+u8 wilc_connected_ssid[6] = {0};
 static s32 Handle_Connect(struct host_if_drv *hif_drv,
 			  struct connect_attr *pstrHostIFconnectAttr)
 {
@@ -999,7 +999,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_SSID, ETH_ALEN) == 0) {
+	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
 		result = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
 		return result;
@@ -1212,10 +1212,11 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
 	if (pstrHostIFconnectAttr->bssid) {
-		memcpy(wilc_connected_SSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
-
-		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->bssid);
-		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_SSID);
+		memcpy(wilc_connected_ssid,
+		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
+		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n",
+			pstrHostIFconnectAttr->bssid);
+		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_ssid);
 	}
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
@@ -1389,7 +1390,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	hif_drv->usr_conn_req.ies_len = 0;
 	kfree(hif_drv->usr_conn_req.ies);
 
-	eth_zero_addr(wilc_connected_SSID);
+	eth_zero_addr(wilc_connected_ssid);
 
 	if (join_req && join_req_drv == hif_drv) {
 		kfree(join_req);
@@ -1585,11 +1586,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
 				PRINT_ER("Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
-				eth_zero_addr(wilc_connected_SSID);
-
+				eth_zero_addr(wilc_connected_ssid);
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
 				PRINT_ER("Received MAC status is MAC_DISCONNECTED\n");
-				eth_zero_addr(wilc_connected_SSID);
+				eth_zero_addr(wilc_connected_ssid);
 			}
 
 			if (hif_drv->usr_conn_req.pu8bssid) {
@@ -2007,7 +2007,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 	wilc_optaining_ip = false;
 	wilc_set_power_mgmt(hif_drv, 0, 0);
 
-	eth_zero_addr(wilc_connected_SSID);
+	eth_zero_addr(wilc_connected_ssid);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 004467c6..4f5300d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -398,7 +398,7 @@ s32 wilc_get_statistics(struct host_if_drv *hWFIDrv,
 void wilc_resolve_disconnect_aberration(struct host_if_drv *hif_drv);
 
 extern bool wilc_optaining_ip;
-extern u8 wilc_connected_SSID[6];
+extern u8 wilc_connected_ssid[6];
 extern u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 extern int wilc_connecting;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c49b989..718b060 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -588,7 +588,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, NullBssid);
-			eth_zero_addr(wilc_connected_SSID);
+			eth_zero_addr(wilc_connected_ssid);
 
 			if (!pstrWFIDrv->p2p_connect)
 				wlan_channel = INVALID_CHANNEL;
@@ -646,7 +646,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		wilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
 		wilc_wlan_set_bssid(priv->dev, NullBssid);
-		eth_zero_addr(wilc_connected_SSID);
+		eth_zero_addr(wilc_connected_ssid);
 
 		if (!pstrWFIDrv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-- 
1.9.1

