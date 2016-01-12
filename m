Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52528 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbcALHgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:36:41 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/26] staging: wilc1000: remove wilc_set_machw_change_vir_if
Date: Tue, 12 Jan 2016 16:39:39 +0900
Message-ID: <1452584395-24910-11-git-send-email-glen.lee@atmel.com> (sfid-20160112_083653_607267_43338580)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_set_machw_change_vir_if is not used anymore since we use one unified
firmware. Instead, wilc_set_operation_mode is called when wilc_mac_open to
let the wilc use the proper firmware. Remove wilc_set_machw_change_vir_if
and it's functions calls.
In the later patch, mac index will be passed to wilc device.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  3 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 -----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 -
 drivers/staging/wilc1000/wilc_wlan.c              | 32 -----------------------
 4 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9dccfd8..ff7a717 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1024,14 +1024,13 @@ int wilc_mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	wilc_set_machw_change_vir_if(ndev, false);
-
 	wilc_get_mac_address(vif, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
 			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
+			wilc_set_operation_mode(vif, vif->iftype);
 			break;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b9c3564..0ba0b06 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1274,7 +1274,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		kfree(g_key_gtk_params.seq);
 		g_key_gtk_params.seq = NULL;
 
-		wilc_set_machw_change_vir_if(netdev, false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -2116,10 +2115,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	del_timer(&wilc_during_ip_timer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 
-	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		wilc_set_machw_change_vir_if(dev, true);
-	}
-
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 		wilc_connecting = 0;
@@ -2261,7 +2256,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			}
 
 			refresh_scan(priv, 1, true);
-			wilc_set_machw_change_vir_if(dev, false);
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index cd3d21d..0d851f8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -235,7 +235,6 @@ int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
 		     const struct wilc_hif_func *ops);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
 int wilc_wlan_get_firmware(struct net_device *dev);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index aed1dd2..cc487d8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1578,35 +1578,3 @@ _fail_:
 
 	return ret;
 }
-
-u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
-{
-	u16 ret;
-	u32 reg;
-	struct wilc_vif *vif;
-	struct wilc *wilc;
-
-	vif = netdev_priv(dev);
-	wilc = vif->wilc;
-
-	mutex_lock(&wilc->hif_cs);
-	ret = wilc->hif_func->hif_read_reg(wilc, WILC_CHANGING_VIR_IF,
-					       &reg);
-	if (!ret)
-		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
-
-	if (value)
-		reg |= BIT(31);
-	else
-		reg &= ~BIT(31);
-
-	ret = wilc->hif_func->hif_write_reg(wilc, WILC_CHANGING_VIR_IF,
-						reg);
-
-	if (!ret)
-		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
-
-	mutex_unlock(&wilc->hif_cs);
-
-	return ret;
-}
-- 
1.9.1

