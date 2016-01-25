Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40964 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:43:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 11/26] staging: wilc1000: set bssid with mode
Date: Mon, 25 Jan 2016 16:35:15 +0900
Message-ID: <1453707330-13526-12-git-send-email-glen.lee@atmel.com> (sfid-20160125_084320_600606_C2EFFBB4)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument mode to wilc_wlan_set_bssid and define mode in
struct wilc_vif also. The mode is used by get_if_handler function to get proper
netdevice for each mode.
The get_if_handler is changed together. Remove invalid handle codes and
add mode condition to get netdevice for the mode.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 26 +++++++++--------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 13 ++++++------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  3 ++-
 drivers/staging/wilc1000/wilc_wlan.h              |  1 -
 4 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 08d2cb2..2489ea3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -288,26 +288,19 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	bssid = mac_header + 10;
 	bssid1 = mac_header + 4;
 
-	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN) ||
-		    !memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
-			return wilc->vif[i]->ndev;
-
-	PRINT_INFO(INIT_DBG, "Invalide handle\n");
-	for (i = 0; i < 25; i++)
-		PRINT_D(INIT_DBG, "%02x ", mac_header[i]);
-	bssid = mac_header + 18;
-	bssid1 = mac_header + 12;
-	for (i = 0; i < wilc->vif_num; i++)
-		if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN) ||
-		    !memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
-			return wilc->vif[i]->ndev;
+	for (i = 0; i < wilc->vif_num; i++) {
+		if (wilc->vif[i]->mode == STATION_MODE)
+			if (!memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
+				return wilc->vif[i]->ndev;
+		if (wilc->vif[i]->mode == AP_MODE)
+			if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN))
+				return wilc->vif[i]->ndev;
+	}
 
-	PRINT_INFO(INIT_DBG, "\n");
 	return NULL;
 }
 
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
+int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
 {
 	int i = 0;
 	int ret = -1;
@@ -320,6 +313,7 @@ int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 	for (i = 0; i < wilc->vif_num; i++)
 		if (wilc->vif[i]->ndev == wilc_netdev) {
 			memcpy(wilc->vif[i]->bssid, bssid, 6);
+			wilc->vif[i]->mode = mode;
 			ret = 0;
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ecc63f4..95be39a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -524,7 +524,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		if ((u8MacStatus == MAC_DISCONNECTED) &&
 		    (pstrConnectInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE)) {
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
-			wilc_wlan_set_bssid(priv->dev, NullBssid);
+			wilc_wlan_set_bssid(priv->dev, NullBssid,
+					    STATION_MODE);
 			eth_zero_addr(wilc_connected_ssid);
 
 			if (!pstrWFIDrv->p2p_connect)
@@ -577,7 +578,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		p2p_recv_random = 0x00;
 		wilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
-		wilc_wlan_set_bssid(priv->dev, NullBssid);
+		wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
 		eth_zero_addr(wilc_connected_ssid);
 
 		if (!pstrWFIDrv->p2p_connect)
@@ -903,7 +904,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!pstrWFIDrv->p2p_connect)
 		wlan_channel = pstrNetworkInfo->u8channel;
 
-	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid);
+	wilc_wlan_set_bssid(dev, pstrNetworkInfo->au8bssid, STATION_MODE);
 
 	s32Error = wilc_set_join_req(vif, pstrNetworkInfo->au8bssid, sme->ssid,
 				     sme->ssid_len, sme->ie, sme->ie_len,
@@ -937,7 +938,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	if (!pstrWFIDrv->p2p_connect)
 		wlan_channel = INVALID_CHANNEL;
-	wilc_wlan_set_bssid(priv->dev, NullBssid);
+	wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
 
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
 
@@ -2400,7 +2401,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr);
+	wilc_wlan_set_bssid(dev, wl->vif[0]->src_addr, AP_MODE);
 
 	s32Error = wilc_add_beacon(vif, settings->beacon_interval,
 				   settings->dtim_period, beacon->head_len,
@@ -2444,7 +2445,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
 
-	wilc_wlan_set_bssid(dev, NullBssid);
+	wilc_wlan_set_bssid(dev, NullBssid, AP_MODE);
 
 	s32Error = wilc_del_beacon(vif);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0d851f8..54e762ec 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -160,6 +160,7 @@ struct wilc_vif {
 	u8 bssid[ETH_ALEN];
 	struct host_if_drv *hif_drv;
 	struct net_device *ndev;
+	u8 mode;
 };
 
 struct wilc {
@@ -236,6 +237,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 int wilc_wlan_get_firmware(struct net_device *dev);
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
+int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index a1096ed..7f04653 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -293,7 +293,6 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int wilc_mac_open(struct net_device *ndev);
 int wilc_mac_close(struct net_device *ndev);
 
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
 void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 void host_wakeup_notify(struct wilc *wilc);
 void host_sleep_notify(struct wilc *wilc);
-- 
1.9.1

