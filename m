Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16922 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbbJTIOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/13] staging: wilc1000: mac_open: use netdev private wilc
Date: Tue, 20 Oct 2015 17:13:54 +0900
Message-ID: <1445328843-32247-4-git-send-email-tony.cho@atmel.com> (sfid-20151020_101440_547967_5058E8E3)
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
 drivers/staging/wilc1000/linux_wlan.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5fcbfac..ebedffa 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1167,9 +1167,13 @@ int mac_open(struct net_device *ndev)
 	int ret = 0;
 	int i = 0;
 	struct wilc_priv *priv;
+	struct wilc *wl;
+
+	nic = netdev_priv(ndev);
+	wl = nic->wilc;
 
 #ifdef WILC_SPI
-	if (!g_linux_wlan || !g_linux_wlan->wilc_spidev) {
+	if (!wl|| !wl->wilc_spidev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
@@ -1200,16 +1204,16 @@ int mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		if (ndev == g_linux_wlan->vif[i].ndev) {
-			memcpy(g_linux_wlan->vif[i].src_addr, mac_add, ETH_ALEN);
-			g_linux_wlan->vif[i].hif_drv = priv->hWILCWFIDrv;
+	for (i = 0; i < wl->vif_num; i++) {
+		if (ndev == wl->vif[i].ndev) {
+			memcpy(wl->vif[i].src_addr, mac_add, ETH_ALEN);
+			wl->vif[i].hif_drv = priv->hWILCWFIDrv;
 			break;
 		}
 	}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, g_linux_wlan->vif[i].src_addr, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->vif[i].src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
@@ -1222,13 +1226,13 @@ int mac_open(struct net_device *ndev)
 	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
 				 nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
-	g_linux_wlan->open_ifcs++;
+	wl->open_ifcs++;
 	nic->mac_opened = 1;
 	return 0;
 
 _err_:
 	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(g_linux_wlan);
+	wilc1000_wlan_deinit(wl);
 	return ret;
 }
 
-- 
1.9.1

