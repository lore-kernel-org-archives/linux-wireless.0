Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14281 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcA0C53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/13] staging: wilc1000: rename hWILCWFIDrv of wilc_priv structure
Date: Wed, 27 Jan 2016 11:50:28 +0900
Message-ID: <1453863037-31073-4-git-send-email-glen.lee@atmel.com> (sfid-20160127_035732_849622_C1AB02CB)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hWILCWFIDrv pointer variable of wilc_priv structure
to hif_drv to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 ++++++++++++----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a3b4939..06c79dd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -89,7 +89,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
-	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hif_drv;
 	vif = netdev_priv(dev);
 	if (!vif || !hif_drv) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
@@ -515,7 +515,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hif_drv;
 	PRINT_D(INIT_DBG, "Host = %p\n", hif_drv);
 	wilc_get_mac_address(vif, mac_add);
 
@@ -1089,7 +1089,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	vif = netdev_priv(dev);
-	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hif_drv;
 
 	if (!dev)
 		return;
@@ -1228,7 +1228,7 @@ int wilc_mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 6e7f5d6..6626347 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -512,7 +512,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	dev = priv->dev;
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
 		u16 u16ConnectStatus;
@@ -711,9 +711,11 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	wilc_connecting = 1;
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
-	pstrWFIDrv = (struct host_if_drv *)(priv->hWILCWFIDrv);
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
-	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
+	PRINT_D(CFG80211_DBG,
+		"Connecting to SSID [%s] on netdev [%p] host if [%p]\n",
+		sme->ssid, dev, priv->hif_drv);
 	if (!(strncmp(sme->ssid, "DIRECT-", 7))) {
 		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
 		pstrWFIDrv->p2p_connect = 1;
@@ -928,7 +930,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 	if (!pstrWFIDrv->p2p_connect)
 		wlan_channel = INVALID_CHANNEL;
 	wilc_wlan_set_bssid(priv->dev, NullBssid, STATION_MODE);
@@ -1276,7 +1278,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		wilc_remove_wep_key(vif, key_index);
 	} else {
 		PRINT_D(CFG80211_DBG, "Removing all installed keys\n");
-		wilc_remove_key(priv->hWILCWFIDrv, mac_addr);
+		wilc_remove_key(priv->hif_drv, mac_addr);
 	}
 
 	return 0;
@@ -1632,7 +1634,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 	s32 s32Freq;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
@@ -1844,7 +1846,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 	vif = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
 	*cookie = (unsigned long)buf;
 	priv->u64tx_cookie = *cookie;
@@ -1970,7 +1972,7 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	struct host_if_drv *pstrWFIDrv;
 
 	priv = wiphy_priv(wiphy);
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 
 
 	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
@@ -2070,7 +2072,7 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
-	if (!priv->hWILCWFIDrv) {
+	if (!priv->hif_drv) {
 		PRINT_ER("Driver is NULL\n");
 		return -EIO;
 	}
@@ -2713,7 +2715,7 @@ int wilc_init_host_int(struct net_device *net)
 	priv->bInP2PlistenState = false;
 
 	sema_init(&(priv->hSemScanReq), 1);
-	s32Error = wilc_init(net, &priv->hWILCWFIDrv);
+	s32Error = wilc_init(net, &priv->hif_drv);
 	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 07eda4d..64fcb77 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -121,7 +121,7 @@ struct wilc_priv {
 	spinlock_t lock;
 	struct net_device *dev;
 	struct napi_struct napi;
-	struct host_if_drv *hWILCWFIDrv;
+	struct host_if_drv *hif_drv;
 	struct host_if_pmkid_attr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
-- 
1.9.1

