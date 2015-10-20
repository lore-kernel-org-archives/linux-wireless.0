Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:17049 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbJTIPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/13] staging: wilc1000: CfgConnectResult: use netdev private wilc
Date: Tue, 20 Oct 2015 17:13:58 +0900
Message-ID: <1445328843-32247-8-git-send-email-tony.cho@atmel.com> (sfid-20151020_101511_270851_689F72E7)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Use netdev private data member wilc instead of global variable g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 33a082f..1533804 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -537,11 +537,15 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	struct net_device *dev;
 	struct host_if_drv *pstrWFIDrv;
 	u8 NullBssid[ETH_ALEN] = {0};
+	struct wilc *wl;
+	perInterface_wlan_t *nic;
 
 	connecting = 0;
 
 	priv = (struct wilc_priv *)pUserVoid;
 	dev = priv->dev;
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
@@ -624,12 +628,12 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			u8WLANChannel = INVALID_CHANNEL;
 		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
 		 *      virtual interface to station*/
-		if ((pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].ndev)) {
+		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
 		}
 		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
 		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == g_linux_wlan->vif[1].ndev)) {
+		else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
-- 
1.9.1

