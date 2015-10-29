Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27078 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965300AbbJ2DE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:59 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 48/64] staging: wilc1000: rename u8P2PConnect of struct host_if_drv
Date: Thu, 29 Oct 2015 12:05:40 +0900
Message-ID: <1446087956-19054-15-git-send-email-glen.lee@atmel.com> (sfid-20151029_040501_642276_62681DFF)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8P2PConnect of struct host_if_drv to p2p_connect
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c9a4ce8..60dcc36 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -265,7 +265,7 @@ struct host_if_drv {
 	struct remain_ch remain_on_ch;
 	u8 remain_on_ch_pending;
 	u64 p2p_timeout;
-	u8 u8P2PConnect;
+	u8 p2p_connect;
 
 	enum host_if_state hif_state;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 116c37d..4828deb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -564,7 +564,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			eth_zero_addr(u8ConnectedSSID);
 
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-			if (!pstrWFIDrv->u8P2PConnect)
+			if (!pstrWFIDrv->p2p_connect)
 				u8WLANChannel = INVALID_CHANNEL;
 
 			PRINT_ER("Unspecified failure: Connection status %d : MAC status = %d\n", u16ConnectStatus, u8MacStatus);
@@ -623,7 +623,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		eth_zero_addr(u8ConnectedSSID);
 
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-		if (!pstrWFIDrv->u8P2PConnect)
+		if (!pstrWFIDrv->p2p_connect)
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
@@ -804,9 +804,10 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
 		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
-		pstrWFIDrv->u8P2PConnect = 1;
-	} else
-		pstrWFIDrv->u8P2PConnect = 0;
+		pstrWFIDrv->p2p_connect = 1;
+	} else {
+		pstrWFIDrv->p2p_connect = 0;
+	}
 	PRINT_INFO(CFG80211_DBG, "Required SSID = %s\n , AuthType = %d\n", sme->ssid, sme->auth_type);
 
 	for (i = 0; i < u32LastScannedNtwrksCountShadow; i++) {
@@ -997,9 +998,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	curr_channel = pstrNetworkInfo->u8channel;
 
-	if (!pstrWFIDrv->u8P2PConnect) {
+	if (!pstrWFIDrv->p2p_connect)
 		u8WLANChannel = pstrNetworkInfo->u8channel;
-	}
 
 	linux_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
 
@@ -1041,7 +1041,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 
 	/*Invalidate u8WLANChannel value on wlan0 disconnect*/
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
-	if (!pstrWFIDrv->u8P2PConnect)
+	if (!pstrWFIDrv->p2p_connect)
 		u8WLANChannel = INVALID_CHANNEL;
 	linux_wlan_set_bssid(priv->dev, NullBssid);
 
-- 
1.9.1

