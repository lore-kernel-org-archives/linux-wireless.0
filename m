Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30040 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425347AbcBRLeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:34:08 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V2 09/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 20:30:09 +0900
Message-ID: <1455795024-26978-9-git-send-email-leo.kim@atmel.com> (sfid-20160218_123413_868790_EC9BCEAA)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes the unnecessary log messages which is used with
the HOSTAPD_DBG tag.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 88 +----------------------
 1 file changed, 1 insertion(+), 87 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a71c01d..0794f93 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1358,10 +1358,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		PRINT_D(HOSTAPD_DBG, "Getting station parameters\n");
-
-		PRINT_INFO(HOSTAPD_DBG, ": %x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4]);
-
 		for (i = 0; i < NUM_STA_ASSOCIATED; i++) {
 			if (!(memcmp(mac, priv->assoc_stainfo.au8Sta_AssociatedBss[i], ETH_ALEN))) {
 				associatedsta = i;
@@ -2039,9 +2035,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 	priv = wiphy_priv(wiphy);
 	wl = vif->wilc;
-
-	PRINT_D(HOSTAPD_DBG, "In Change virtual interface function\n");
-	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
 	wilc_ie = false;
@@ -2051,8 +2044,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 		wilc_connecting = 0;
-		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_STATION\n");
-
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
@@ -2067,8 +2058,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wilc_connecting = 0;
-		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
-
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->monitor_flag = 0;
@@ -2081,7 +2070,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	case NL80211_IFTYPE_AP:
 		wilc_enable_ps = false;
-		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_AP %d\n", type);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->iftype = AP_MODE;
@@ -2098,8 +2086,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
-		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
-
 		wilc_set_operation_mode(vif, AP_MODE);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
@@ -2129,10 +2115,6 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
 	wl = vif ->wilc;
-	PRINT_D(HOSTAPD_DBG, "Starting ap\n");
-
-	PRINT_D(HOSTAPD_DBG, "Interval = %d\n DTIM period = %d\n Head length = %zu Tail length = %zu\n",
-		settings->beacon_interval, settings->dtim_period, beacon->head_len, beacon->tail_len);
 
 	s32Error = set_channel(wiphy, &settings->chandef);
 
@@ -2159,8 +2141,6 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
-	PRINT_D(HOSTAPD_DBG, "Setting beacon\n");
-
 
 	s32Error = wilc_add_beacon(vif, 0, 0, beacon->head_len,
 				   (u8 *)beacon->head, beacon->tail_len,
@@ -2182,8 +2162,6 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	PRINT_D(HOSTAPD_DBG, "Deleting beacon\n");
-
 	wilc_wlan_set_bssid(dev, NullBssid, AP_MODE);
 
 	s32Error = wilc_del_beacon(vif);
@@ -2219,9 +2197,6 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n", priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][0], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][1], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][2], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][3], priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][4],
 			priv->assoc_stainfo.au8Sta_AssociatedBss[params->aid][5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
-		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
-			strStaParams.rates_len);
 
 		if (!params->ht_capa) {
 			strStaParams.ht_supported = false;
@@ -2240,23 +2215,6 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.flags_set = params->sta_flags_set;
 
-		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
-			strStaParams.ht_supported);
-		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
-			strStaParams.ht_capa_info);
-		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
-			strStaParams.ht_ampdu_params);
-		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
-			strStaParams.ht_ext_params);
-		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
-			strStaParams.ht_tx_bf_cap);
-		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
-			strStaParams.ht_ante_sel);
-		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
-			strStaParams.flags_mask);
-		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
-			strStaParams.flags_set);
-
 		s32Error = wilc_add_station(vif, &strStaParams);
 		if (s32Error)
 			netdev_err(dev, "Host add station fail\n");
@@ -2280,16 +2238,9 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	vif = netdev_priv(dev);
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
-		PRINT_D(HOSTAPD_DBG, "Deleting station\n");
-
-
-		if (!mac) {
-			PRINT_D(HOSTAPD_DBG, "All associated stations\n");
+		if (!mac)
 			s32Error = wilc_del_allstation(vif,
 				     priv->assoc_stainfo.au8Sta_AssociatedBss);
-		} else {
-			PRINT_D(HOSTAPD_DBG, "With mac address: %x%x%x%x%x%x\n", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-		}
 
 		s32Error = wilc_del_station(vif, mac);
 
@@ -2307,9 +2258,6 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	struct add_sta_param strStaParams = { {0} };
 	struct wilc_vif *vif;
 
-
-	PRINT_D(HOSTAPD_DBG, "Change station paramters\n");
-
 	if (!wiphy)
 		return -EFAULT;
 
@@ -2322,14 +2270,6 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.rates_len = params->supported_rates_len;
 		strStaParams.rates = params->supported_rates;
 
-		PRINT_D(HOSTAPD_DBG, "BSSID = %x%x%x%x%x%x\n",
-			strStaParams.bssid[0], strStaParams.bssid[1],
-			strStaParams.bssid[2], strStaParams.bssid[3],
-			strStaParams.bssid[4], strStaParams.bssid[5]);
-		PRINT_D(HOSTAPD_DBG, "ASSOC ID = %d\n", strStaParams.aid);
-		PRINT_D(HOSTAPD_DBG, "Number of supported rates = %d\n",
-			strStaParams.rates_len);
-
 		if (!params->ht_capa) {
 			strStaParams.ht_supported = false;
 		} else {
@@ -2347,23 +2287,6 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 		strStaParams.flags_mask = params->sta_flags_mask;
 		strStaParams.flags_set = params->sta_flags_set;
 
-		PRINT_D(HOSTAPD_DBG, "IS HT supported = %d\n",
-			strStaParams.ht_supported);
-		PRINT_D(HOSTAPD_DBG, "Capability Info = %d\n",
-			strStaParams.ht_capa_info);
-		PRINT_D(HOSTAPD_DBG, "AMPDU Params = %d\n",
-			strStaParams.ht_ampdu_params);
-		PRINT_D(HOSTAPD_DBG, "HT Extended params = %d\n",
-			strStaParams.ht_ext_params);
-		PRINT_D(HOSTAPD_DBG, "Tx Beamforming Cap = %d\n",
-			strStaParams.ht_tx_bf_cap);
-		PRINT_D(HOSTAPD_DBG, "Antenna selection info = %d\n",
-			strStaParams.ht_ante_sel);
-		PRINT_D(HOSTAPD_DBG, "Flag Mask = %d\n",
-			strStaParams.flags_mask);
-		PRINT_D(HOSTAPD_DBG, "Flag Set = %d\n",
-			strStaParams.flags_set);
-
 		s32Error = wilc_edit_station(vif, &strStaParams);
 		if (s32Error)
 			netdev_err(dev, "Host edit station fail\n");
@@ -2383,20 +2306,12 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 	struct net_device *new_ifc = NULL;
 
 	priv = wiphy_priv(wiphy);
-
-
-
-	PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", priv->wdev->netdev);
-
 	vif = netdev_priv(priv->wdev->netdev);
 
 
 	if (type == NL80211_IFTYPE_MONITOR) {
-		PRINT_D(HOSTAPD_DBG, "Monitor interface mode: Initializing mon interface virtual device driver\n");
-		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", vif->ndev);
 		new_ifc = WILC_WFI_init_mon_interface(name, vif->ndev);
 		if (new_ifc) {
-			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
 			vif = netdev_priv(priv->wdev->netdev);
 			vif->monitor_flag = 1;
 		}
@@ -2406,7 +2321,6 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 
 static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return 0;
 }
 
-- 
1.9.1

