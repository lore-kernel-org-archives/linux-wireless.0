Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58906 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbbKSGxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:38 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/26] staging: wilc1000: rename u8WLANChannel variable
Date: Thu, 19 Nov 2015 15:56:14 +0900
Message-ID: <1447916195-24851-5-git-send-email-glen.lee@atmel.com> (sfid-20151119_075340_943240_FE1CDF79)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8WLANChannel variable to wlan_channel to avoid camelcase.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 29 +++++++++--------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2e7bf8..3b072ef 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -169,9 +169,7 @@ struct p2p_mgmt_data {
 	u8 *buff;
 };
 
-/*Global variable used to state the current  connected STA channel*/
-static u8 u8WLANChannel = INVALID_CHANNEL;
-
+static u8 wlan_channel = INVALID_CHANNEL;
 static u8 curr_channel;
 
 static u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
@@ -593,9 +591,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			wilc_wlan_set_bssid(priv->dev, NullBssid);
 			eth_zero_addr(wilc_connected_SSID);
 
-			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 			if (!pstrWFIDrv->p2p_connect)
-				u8WLANChannel = INVALID_CHANNEL;
+				wlan_channel = INVALID_CHANNEL;
 
 			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d\n", u16ConnectStatus, u8MacStatus);
 		}
@@ -652,9 +649,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		wilc_wlan_set_bssid(priv->dev, NullBssid);
 		eth_zero_addr(wilc_connected_SSID);
 
-		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 		if (!pstrWFIDrv->p2p_connect)
-			u8WLANChannel = INVALID_CHANNEL;
+			wlan_channel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
 		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
@@ -1029,7 +1025,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	curr_channel = pstrNetworkInfo->u8channel;
 
 	if (!pstrWFIDrv->p2p_connect)
-		u8WLANChannel = pstrNetworkInfo->u8channel;
+		wlan_channel = pstrNetworkInfo->u8channel;
 
 	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
@@ -1069,10 +1065,9 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	wilc_connecting = 0;
 	priv = wiphy_priv(wiphy);
 
-	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->p2p_connect)
-		u8WLANChannel = INVALID_CHANNEL;
+		wlan_channel = INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NullBssid);
 
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
@@ -1855,15 +1850,14 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 			op_channel_attr_index = index;
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
-	if (u8WLANChannel != INVALID_CHANNEL) {
-
+	if (wlan_channel != INVALID_CHANNEL) {
 		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
 				if (buf[i] == 0x51) {
 					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++) {
-						buf[j] = u8WLANChannel;
+						buf[j] = wlan_channel;
 					}
 					break;
 				}
@@ -1873,7 +1867,7 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 		if (op_channel_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
-			buf[op_channel_attr_index + 7] = u8WLANChannel;
+			buf[op_channel_attr_index + 7] = wlan_channel;
 		}
 	}
 }
@@ -1909,15 +1903,14 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 			op_channel_attr_index = index;
 		index += buf[index + 1] + 3; /* ID,Length byte */
 	}
-	if (u8WLANChannel != INVALID_CHANNEL && bOperChan) {
-
+	if (wlan_channel != INVALID_CHANNEL && bOperChan) {
 		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
 				if (buf[i] == 0x51) {
 					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++) {
-						buf[j] = u8WLANChannel;
+						buf[j] = wlan_channel;
 					}
 					break;
 				}
@@ -1927,7 +1920,7 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 		if (op_channel_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
-			buf[op_channel_attr_index + 7] = u8WLANChannel;
+			buf[op_channel_attr_index + 7] = wlan_channel;
 		}
 	}
 }
-- 
1.9.1

