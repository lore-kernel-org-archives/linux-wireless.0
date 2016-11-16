Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49353 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbcKPPHq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 10:07:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Chris Park <chris.park@atmel.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: simplify vif[i]->ndev accesses
Date: Wed, 16 Nov 2016 16:07:10 +0100
Message-Id: <20161116150728.3055415-1-arnd@arndb.de> (sfid-20161116_160812_963624_4910EC9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With gcc-7, I got a new warning for this driver:

wilc1000/linux_wlan.c: In function 'wilc_netdev_cleanup':
wilc1000/linux_wlan.c:1224:15: error: 'vif[1]' may be used uninitialized in this function [-Werror=maybe-uninitialized]
wilc1000/linux_wlan.c:1224:15: error: 'vif[0]' may be used uninitialized in this function [-Werror=maybe-uninitialized]

A closer look at the function reveals that it's more complex than
it needs to be, given that based on how the device is created
we always get

	netdev_priv(vif->ndev) == vif

Based on this assumption, I found a few other places in the same file
that can be simplified. That code appears to be a relic from times
when the assumption above was not valid.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 82c602ba3289..3775706578b2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -260,23 +260,12 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
 {
-	int i = 0;
-	int ret = -1;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(wilc_netdev);
-	wilc = vif->wilc;
+	struct wilc_vif *vif = netdev_priv(wilc_netdev);
 
-	for (i = 0; i < wilc->vif_num; i++)
-		if (wilc->vif[i]->ndev == wilc_netdev) {
-			memcpy(wilc->vif[i]->bssid, bssid, 6);
-			wilc->vif[i]->mode = mode;
-			ret = 0;
-			break;
-		}
+	memcpy(vif->bssid, bssid, 6);
+	vif->mode = mode;
 
-	return ret;
+	return 0;
 }
 
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
@@ -1203,16 +1192,11 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 
 void wilc_netdev_cleanup(struct wilc *wilc)
 {
-	int i = 0;
-	struct wilc_vif *vif[NUM_CONCURRENT_IFC];
+	int i;
 
-	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
+	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev))
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			vif[i] = netdev_priv(wilc->vif[i]->ndev);
-	}
-
 	if (wilc && wilc->firmware) {
 		release_firmware(wilc->firmware);
 		wilc->firmware = NULL;
@@ -1221,7 +1205,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i]->ndev)
-				if (vif[i]->mac_opened)
+				if (wilc->vif[i]->mac_opened)
 					wilc_mac_close(wilc->vif[i]->ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
@@ -1269,9 +1253,9 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 		vif->idx = wl->vif_num;
 		vif->wilc = *wilc;
+		vif->ndev = ndev;
 		wl->vif[i] = vif;
-		wl->vif[wl->vif_num]->ndev = ndev;
-		wl->vif_num++;
+		wl->vif_num = i;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
-- 
2.9.0
