Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15592 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:36 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/7] staging: wilc1000: removes unnecessary test code
Date: Fri, 1 Apr 2016 17:44:16 +0900
Message-ID: <1459500259-27873-4-git-send-email-leo.kim@atmel.com> (sfid-20160401_104740_326503_906A30F3)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary test code that mac address hardcoding setting.
This test code is support to old firmware.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2ed2bf3..47c0132 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -424,7 +424,6 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 				       struct wilc_vif *vif)
 {
 	unsigned char c_val[64];
-	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 	struct wilc *wilc = vif->wilc;
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
@@ -433,9 +432,6 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	hif_drv = (struct host_if_drv *)priv->hif_drv;
 	netdev_dbg(dev, "Host = %p\n", hif_drv);
-	wilc_get_mac_address(vif, mac_add);
-
-	netdev_dbg(dev, "MAC address is : %pM\n", mac_add);
 	wilc_get_chipid(wilc, false);
 
 	*(int *)c_val = 1;
@@ -597,11 +593,6 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 			       0))
 		goto _fail_;
 
-	memcpy(c_val, mac_add, 6);
-
-	if (!wilc_wlan_cfg_set(vif, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
-		goto _fail_;
-
 	c_val[0] = DETECT_PROTECT_REPORT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
 			       0, 0))
-- 
1.9.1

