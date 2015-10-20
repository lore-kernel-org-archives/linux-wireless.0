Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16952 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbbJTIOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/13] staging: wilc1000: mac_close: use netdev private wilc instead of g_linux_wlan
Date: Tue, 20 Oct 2015 17:13:55 +0900
Message-ID: <1445328843-32247-5-git-send-email-tony.cho@atmel.com> (sfid-20151020_101446_475455_CB939626)
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
 drivers/staging/wilc1000/linux_wlan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ebedffa..93475aa 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1383,6 +1383,7 @@ int mac_close(struct net_device *ndev)
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	struct host_if_drv *pstrWFIDrv;
+	struct wilc *wl;
 
 	nic = netdev_priv(ndev);
 
@@ -1392,6 +1393,7 @@ int mac_close(struct net_device *ndev)
 	}
 
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
+	wl = nic->wilc;
 
 	if (priv == NULL) {
 		PRINT_ER("priv = NULL\n");
@@ -1402,8 +1404,8 @@ int mac_close(struct net_device *ndev)
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
-	if (g_linux_wlan == NULL) {
-		PRINT_ER("g_linux_wlan = NULL\n");
+	if (!wl) {
+		PRINT_ER("wl = NULL\n");
 		return 0;
 	}
 
@@ -1412,8 +1414,8 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if ((g_linux_wlan->open_ifcs) > 0) {
-		g_linux_wlan->open_ifcs--;
+	if ((wl->open_ifcs) > 0) {
+		wl->open_ifcs--;
 	} else {
 		PRINT_ER("ERROR: MAC close called while number of opened interfaces is zero\n");
 		return 0;
@@ -1426,10 +1428,10 @@ int mac_close(struct net_device *ndev)
 		wilc_deinit_host_int(nic->wilc_netdev);
 	}
 
-	if (g_linux_wlan->open_ifcs == 0) {
+	if (wl->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
-		g_linux_wlan->close = 1;
-		wilc1000_wlan_deinit(g_linux_wlan);
+		wl->close = 1;
+		wilc1000_wlan_deinit(wl);
 		WILC_WFI_deinit_mon_interface();
 	}
 
-- 
1.9.1

