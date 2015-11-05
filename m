Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27099 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031175AbbKEFgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 34/38] staging: wilc1000: rename Set_machw_change_vir_if function
Date: Thu, 5 Nov 2015 14:36:35 +0900
Message-ID: <1446701799-24870-34-git-send-email-glen.lee@atmel.com> (sfid-20151105_063650_590311_2F200BCA)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Set_machw_change_vir_if function to set_machw_change_vir_if
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6492103..79e755c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1107,7 +1107,7 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	Set_machw_change_vir_if(ndev, false);
+	set_machw_change_vir_if(ndev, false);
 
 	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e8c8272..5291868 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1408,7 +1408,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		g_key_gtk_params.seq = NULL;
 
 		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-		Set_machw_change_vir_if(netdev, false);
+		set_machw_change_vir_if(netdev, false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -2548,7 +2548,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		Set_machw_change_vir_if(dev, true);
+		set_machw_change_vir_if(dev, true);
 	}
 
 	switch (type) {
@@ -2710,7 +2710,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
 			refresh_scan(priv, 1, true);
-			Set_machw_change_vir_if(dev, false);
+			set_machw_change_vir_if(dev, false);
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 9b11b71..6f9da09 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -217,7 +217,7 @@ void wl_wlan_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue);
+u16 set_machw_change_vir_if(struct net_device *dev, bool bValue);
 int linux_wlan_get_firmware(struct net_device *dev);
 int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 16224ce..0e5535e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2052,7 +2052,7 @@ _fail_:
 
 }
 
-u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue)
+u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
 {
 	u16 ret;
 	u32 reg;
-- 
1.9.1

