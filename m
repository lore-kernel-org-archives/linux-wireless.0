Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11478 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbLUFQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 19/46] staging: wilc1000: replace explicit NULL comparisons with !
Date: Mon, 21 Dec 2015 14:18:23 +0900
Message-ID: <1450675130-17866-20-git-send-email-glen.lee@atmel.com> (sfid-20151221_063102_463724_77974625)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replace explicit NULL comparison with ! operator to simplify code.
Reported by checkpatch.pl for Comparison to NULL could be written !XXX" or "XXX".

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 31 ++++++++++++-----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 71038b1..bdc4537 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -463,7 +463,7 @@ static void CfgScanResult(enum scan_event scan_event,
 
 			down(&(priv->hSemScanReq));
 
-			if (priv->pstrScanReq != NULL) {
+			if (priv->pstrScanReq) {
 				cfg80211_scan_done(priv->pstrScanReq, false);
 				priv->u32RcvdChCount = 0;
 				priv->bCfgScanning = false;
@@ -474,7 +474,7 @@ static void CfgScanResult(enum scan_event scan_event,
 			down(&(priv->hSemScanReq));
 
 			PRINT_D(CFG80211_DBG, "Scan Aborted\n");
-			if (priv->pstrScanReq != NULL) {
+			if (priv->pstrScanReq) {
 				update_scan_time();
 				refresh_scan(priv, 1, false);
 
@@ -645,7 +645,8 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 
 			for (i = 0; i < request->n_ssids; i++) {
-				if (request->ssids[i].ssid != NULL && request->ssids[i].ssid_len != 0) {
+				if (request->ssids[i].ssid &&
+				    request->ssids[i].ssid_len != 0) {
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid = kmalloc(request->ssids[i].ssid_len, GFP_KERNEL);
 					memcpy(strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, request->ssids[i].ssid, request->ssids[i].ssid_len);
 					strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen = request->ssids[i].ssid_len;
@@ -716,7 +717,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			   sme->ssid,
 			   sme->ssid_len) == 0) {
 			PRINT_INFO(CFG80211_DBG, "Network with required SSID is found %s\n", sme->ssid);
-			if (sme->bssid == NULL)	{
+			if (!sme->bssid) {
 				PRINT_INFO(CFG80211_DBG, "BSSID is not passed from the user\n");
 				break;
 			} else {
@@ -1009,12 +1010,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
-			if (priv->wilc_gtk[key_index] == NULL) {
+			if (!priv->wilc_gtk[key_index]) {
 				priv->wilc_gtk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
 				priv->wilc_gtk[key_index]->key = NULL;
 				priv->wilc_gtk[key_index]->seq = NULL;
 			}
-			if (priv->wilc_ptk[key_index] == NULL) {
+			if (!priv->wilc_ptk[key_index]) {
 				priv->wilc_ptk[key_index] = kmalloc(sizeof(struct wilc_wfi_key), GFP_KERNEL);
 				priv->wilc_ptk[key_index]->key = NULL;
 				priv->wilc_ptk[key_index]->seq = NULL;
@@ -1828,12 +1829,12 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
 		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
-		if (mgmt_tx == NULL) {
+		if (!mgmt_tx) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 			return -EFAULT;
 		}
 		mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
-		if (mgmt_tx->buff == NULL) {
+		if (!mgmt_tx->buff) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 			kfree(mgmt_tx);
 			return -EFAULT;
@@ -2037,11 +2038,11 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	PRINT_D(CFG80211_DBG, " Power save Enabled= %d , TimeOut = %d\n", enabled, timeout);
 
-	if (wiphy == NULL)
+	if (!wiphy)
 		return -ENOENT;
 
 	priv = wiphy_priv(wiphy);
-	if (priv->hWILCWFIDrv == NULL) {
+	if (!priv->hWILCWFIDrv) {
 		PRINT_ER("Driver is NULL\n");
 		return -EIO;
 	}
@@ -2451,7 +2452,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
 			strStaParams.rates_len);
 
-		if (params->ht_capa == NULL) {
+		if (!params->ht_capa) {
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
@@ -2511,7 +2512,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Deleting station\n");
 
 
-		if (mac == NULL) {
+		if (!mac) {
 			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
 			s32Error = wilc_del_allstation(priv->hWILCWFIDrv, priv->assoc_stainfo.au8Sta_AssociatedBss);
 		} else {
@@ -2557,7 +2558,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
 			strStaParams.rates_len);
 
-		if (params->ht_capa == NULL) {
+		if (!params->ht_capa) {
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
@@ -2622,7 +2623,7 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 		PRINT_D(HOSTAPD_DBG, "Monitor interface mode: Initializing mon interface virtual device driver\n");
 		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", nic->wilc_netdev);
 		new_ifc = WILC_WFI_init_mon_interface(name, nic->wilc_netdev);
-		if (new_ifc != NULL) {
+		if (new_ifc) {
 			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
 			nic = netdev_priv(priv->wdev->netdev);
 			nic->monitor_flag = 1;
@@ -2748,7 +2749,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	PRINT_D(CFG80211_DBG, "Registering wifi device\n");
 
 	wdev = WILC_WFI_CfgAlloc();
-	if (wdev == NULL) {
+	if (!wdev) {
 		PRINT_ER("CfgAlloc Failed\n");
 		return NULL;
 	}
-- 
1.9.1

