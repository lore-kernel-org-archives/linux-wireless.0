Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52474 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbcALHga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:36:30 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/26] staging: wilc1000: get address from wilc
Date: Tue, 12 Jan 2016 16:39:37 +0900
Message-ID: <1452584395-24910-9-git-send-email-glen.lee@atmel.com> (sfid-20160112_083632_578081_153D7418)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get mac address from wilc device instead of using random mac address.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 236996f..58837d7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -511,20 +511,19 @@ static int wilc1000_firmware_download(struct net_device *dev)
 }
 
 static int linux_wlan_init_test_config(struct net_device *dev,
-				       struct wilc *wilc)
+				       struct wilc_vif *vif)
 {
 	unsigned char c_val[64];
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
-
+	struct wilc *wilc = vif->wilc;
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
-	get_random_bytes(&mac_add[5], 1);
-	get_random_bytes(&mac_add[4], 1);
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	PRINT_D(INIT_DBG, "Host = %p\n", hif_drv);
+	wilc_get_mac_address(vif, mac_add);
 
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n",
 		mac_add[0], mac_add[1], mac_add[2],
@@ -944,7 +943,7 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 			Firmware_ver[size] = '\0';
 			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
 		}
-		ret = linux_wlan_init_test_config(dev, wl);
+		ret = linux_wlan_init_test_config(dev, vif);
 
 		if (ret < 0) {
 			PRINT_ER("Failed to configure firmware\n");
-- 
1.9.1

