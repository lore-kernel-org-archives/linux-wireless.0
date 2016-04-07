Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35409 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbcDGJjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 05:39:52 -0400
From: Shyam Saini <mayhs11saini@gmail.com>
To: johnny.kim@atmel.com
Cc: austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 525/525] Staging: Wilc1000: Fixed coding style ether_addr_copy
Date: Thu,  7 Apr 2016 15:07:15 +0530
Message-Id: <1460021835-8370-1-git-send-email-mayhs11saini@gmail.com> (sfid-20160407_114029_926625_E887B8CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed following warning detected by checkpatch.pl:
warning: Prefer ether_addr_copy() over memcpy() if the Ethernet addressesare __aligned(2)

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 25 +++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b76622d..3a5d04a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -363,8 +363,8 @@ static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].ssid_len = pstrNetworkInfo->ssid_len;
 	memcpy(last_scanned_shadow[ap_index].ssid,
 	       pstrNetworkInfo->ssid, pstrNetworkInfo->ssid_len);
-	memcpy(last_scanned_shadow[ap_index].bssid,
-	       pstrNetworkInfo->bssid, ETH_ALEN);
+	ether_addr_copy(last_scanned_shadow[ap_index].bssid,
+	       pstrNetworkInfo->bssid);
 	last_scanned_shadow[ap_index].beacon_period = pstrNetworkInfo->beacon_period;
 	last_scanned_shadow[ap_index].dtim_period = pstrNetworkInfo->dtim_period;
 	last_scanned_shadow[ap_index].ch = pstrNetworkInfo->ch;
@@ -521,7 +521,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			bool bNeedScanRefresh = false;
 			u32 i;
 
-			memcpy(priv->au8AssociatedBss, pstrConnectInfo->bssid, ETH_ALEN);
+			ether_addr_copy(priv->au8AssociatedBss, pstrConnectInfo->bssid);
 
 
 			for (i = 0; i < last_scanned_cnt; i++) {
@@ -1000,7 +1000,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						g_add_gtk_key_params.mac_addr = NULL;
 					} else {
 						g_add_gtk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
-						memcpy(g_add_gtk_key_params.mac_addr, mac_addr, ETH_ALEN);
+						ether_addr_copy(g_add_gtk_key_params.mac_addr, mac_addr);
 					}
 					g_key_gtk_params.key_len = params->key_len;
 					g_key_gtk_params.seq_len = params->seq_len;
@@ -1033,7 +1033,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						g_add_ptk_key_params.mac_addr = NULL;
 					} else {
 						g_add_ptk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
-						memcpy(g_add_ptk_key_params.mac_addr, mac_addr, ETH_ALEN);
+						ether_addr_copy(g_add_ptk_key_params.mac_addr, mac_addr);
 					}
 					g_key_ptk_params.key_len = params->key_len;
 					g_key_ptk_params.seq_len = params->seq_len;
@@ -1287,8 +1287,8 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		}
 	}
 	if (i < WILC_MAX_NUM_PMKIDS) {
-		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
-			    ETH_ALEN);
+		ether_addr_copy(priv->pmkid_list.pmkidlist[i].bssid,
+				pmksa->bssid);
 		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
 			    PMKID_LEN);
 		if (!(flag == PMKID_FOUND))
@@ -1322,9 +1322,8 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (i < priv->pmkid_list.numpmkid && priv->pmkid_list.numpmkid > 0) {
 		for (; i < (priv->pmkid_list.numpmkid - 1); i++) {
-			memcpy(priv->pmkid_list.pmkidlist[i].bssid,
-				    priv->pmkid_list.pmkidlist[i + 1].bssid,
-				    ETH_ALEN);
+			ether_addr_copy(priv->pmkid_list.pmkidlist[i].bssid,
+				    priv->pmkid_list.pmkidlist[i + 1].bssid);
 			memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
 				    priv->pmkid_list.pmkidlist[i].pmkid,
 				    PMKID_LEN);
@@ -1983,8 +1982,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		memcpy(strStaParams.bssid, mac, ETH_ALEN);
-		memcpy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac, ETH_ALEN);
+		ether_addr_copy(strStaParams.bssid, mac);
+		ether_addr_copy(priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid], mac);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.rates = params->supported_rates;
@@ -2056,7 +2055,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		memcpy(strStaParams.bssid, mac, ETH_ALEN);
+		ether_addr_copy(strStaParams.bssid, mac);
 		strStaParams.aid = params->aid;
 		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.rates = params->supported_rates;
-- 
1.9.1

