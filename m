Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11707 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:18:30 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 34/46] staging: wilc1000: remove duplicate netdev
Date: Mon, 21 Dec 2015 14:18:38 +0900
Message-ID: <1450675130-17866-35-git-send-email-glen.lee@atmel.com> (sfid-20151221_063101_835179_C38C4AAC)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two net_device pointer which is the same because two structures
are merged into wilc_vif in previous patch. Remove wilc_netdev and change
with ndev.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 35 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 -
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 810d7ce..bb3ff49 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -440,8 +440,8 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 		goto _fail_;
 	}
 
-	if (!(&vif->wilc_netdev->dev)) {
-		PRINT_ER("&vif->wilc_netdev->dev  is NULL\n");
+	if (!(&vif->ndev->dev)) {
+		PRINT_ER("&vif->ndev->dev  is NULL\n");
 		goto _fail_;
 	}
 
@@ -1010,7 +1010,7 @@ int wilc_mac_open(struct net_device *ndev)
 
 	vif = netdev_priv(ndev);
 	wilc = vif->wilc;
-	priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
+	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
 	ret = wilc_init_host_int(ndev);
@@ -1050,12 +1050,12 @@ int wilc_mac_open(struct net_device *ndev)
 		return -EINVAL;
 	}
 
-	wilc_mgmt_frame_register(vif->wilc_netdev->ieee80211_ptr->wiphy,
-				 vif->wilc_netdev->ieee80211_ptr,
+	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
+				 vif->ndev->ieee80211_ptr,
 				 vif->g_struct_frame_reg[0].frame_type,
 				 vif->g_struct_frame_reg[0].reg);
-	wilc_mgmt_frame_register(vif->wilc_netdev->ieee80211_ptr->wiphy,
-				 vif->wilc_netdev->ieee80211_ptr,
+	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
+				 vif->ndev->ieee80211_ptr,
 				 vif->g_struct_frame_reg[1].frame_type,
 				 vif->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
@@ -1204,13 +1204,13 @@ int wilc_mac_close(struct net_device *ndev)
 
 	vif = netdev_priv(ndev);
 
-	if (!vif || !vif->wilc_netdev || !vif->wilc_netdev->ieee80211_ptr ||
-	    !vif->wilc_netdev->ieee80211_ptr->wiphy) {
+	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
+	    !vif->ndev->ieee80211_ptr->wiphy) {
 		PRINT_ER("vif = NULL\n");
 		return 0;
 	}
 
-	priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
+	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 	wl = vif->wilc;
 
 	if (!priv) {
@@ -1239,10 +1239,10 @@ int wilc_mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if (vif->wilc_netdev) {
-		netif_stop_queue(vif->wilc_netdev);
+	if (vif->ndev) {
+		netif_stop_queue(vif->ndev);
 
-		wilc_deinit_host_int(vif->wilc_netdev);
+		wilc_deinit_host_int(vif->ndev);
 	}
 
 	if (wl->open_ifcs == 0) {
@@ -1288,7 +1288,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				return PTR_ERR(buff);
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
-				priv = wiphy_priv(vif->wilc_netdev->ieee80211_ptr->wiphy);
+				priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
 				ret = wilc_get_rssi(priv->hWILCWFIDrv, &rssi);
 				if (ret)
 					PRINT_ER("Failed to send get rssi param's message queue ");
@@ -1457,7 +1457,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 			strcpy(ndev->name, "p2p%d");
 
 		vif->u8IfIdx = wl->vif_num;
-		vif->wilc_netdev = ndev;
 		vif->wilc = *wilc;
 		wl->vif[i] = vif;
 		wl->vif[wl->vif_num]->ndev = ndev;
@@ -1476,9 +1475,9 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 				return -1;
 			}
 
-			vif->wilc_netdev->ieee80211_ptr = wdev;
-			vif->wilc_netdev->ml_priv = vif;
-			wdev->netdev = vif->wilc_netdev;
+			vif->ndev->ieee80211_ptr = wdev;
+			vif->ndev->ml_priv = vif;
+			wdev->netdev = vif->ndev;
 			vif->netstats.rx_packets = 0;
 			vif->netstats.tx_packets = 0;
 			vif->netstats.rx_bytes = 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d128fb6..87f8d0d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2621,8 +2621,8 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 
 	if (type == NL80211_IFTYPE_MONITOR) {
 		PRINT_D(HOSTAPD_DBG, "Monitor interface mode: Initializing mon interface virtual device driver\n");
-		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", vif->wilc_netdev);
-		new_ifc = WILC_WFI_init_mon_interface(name, vif->wilc_netdev);
+		PRINT_D(HOSTAPD_DBG, "Adding monitor interface[%p]\n", vif->ndev);
+		new_ifc = WILC_WFI_init_mon_interface(name, vif->ndev);
 		if (new_ifc) {
 			PRINT_D(HOSTAPD_DBG, "Setting monitor flag in private structure\n");
 			vif = netdev_priv(priv->wdev->netdev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 9f5eac8..98ac8ed 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -154,7 +154,6 @@ struct wilc_vif {
 	int monitor_flag;
 	int mac_opened;
 	struct_frame_reg g_struct_frame_reg[num_reg_frame];
-	struct net_device *wilc_netdev;
 	struct net_device_stats netstats;
 	struct wilc *wilc;
 	u8 src_addr[ETH_ALEN];
-- 
1.9.1

