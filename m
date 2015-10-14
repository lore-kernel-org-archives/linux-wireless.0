Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43553 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbbJNLrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/16] staging: wilc1000: change the type of wilc1000_initialized
Date: Wed, 14 Oct 2015 20:46:33 +0900
Message-ID: <1444823204-16736-5-git-send-email-tony.cho@atmel.com> (sfid-20151014_134746_904069_C6C5E5BC)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the type of wilc1000_initialized in the struct wilc from
int to bool and renames it to the initialized. In addition, the unncessary
wilc1000_initialized codes are removed in this patch.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 13 +++++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6a98660..c75dfc4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -880,9 +880,7 @@ _fail_:
 /**************************/
 void wilc1000_wlan_deinit(struct wilc *nic)
 {
-
-	if (wl->wilc1000_initialized) {
-
+	if (wl->initialized) {
 		printk("Deinitializing wilc1000  ...\n");
 
 		if (nic == NULL) {
@@ -931,7 +929,7 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 		wlan_deinit_locks(wl);
 
 		/* announce that wilc1000 is not initialized */
-		wl->wilc1000_initialized = 0;
+		wl->initialized = false;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
 
@@ -1137,10 +1135,9 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
-	if (!wl->wilc1000_initialized) {
+	if (!wl->initialized) {
 		wl->mac_status = WILC_MAC_STATUS_INIT;
 		wl->close = 0;
-		wl->wilc1000_initialized = 0;
 
 		wlan_init_locks(wl);
 
@@ -1227,7 +1224,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_fw_start_;
 		}
 
-		wl->wilc1000_initialized = 1;
+		wl->initialized = true;
 		return 0; /*success*/
 
 _fail_fw_start_:
@@ -1560,7 +1557,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
 
-	if (!wl->wilc1000_initialized)
+	if (!wl->initialized)
 		return 0;
 
 	switch (cmd) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9696839..b26caa8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2419,7 +2419,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	}
 	/*If mac is closed, then return*/
-	if (!wl->wilc1000_initialized) {
+	if (!wl->initialized) {
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
@@ -2572,7 +2572,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
-		if (wl->wilc1000_initialized) {
+		if (wl->initialized) {
 			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv,
 						      wl->strInterfaceInfo[0].aBSSID,
 						      TID);
@@ -2630,7 +2630,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			if (wl->wilc1000_initialized)
+			if (wl->initialized)
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2660,7 +2660,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading P2P_CONCURRENCY_FIRMWARE\n");
 		nic->iftype = CLIENT_MODE;
 
-		if (wl->wilc1000_initialized) {
+		if (wl->initialized) {
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
@@ -2714,7 +2714,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			refresh_scan(priv, 1, true);
 			Set_machw_change_vir_if(false);
 
-			if (wl->wilc1000_initialized)
+			if (wl->initialized)
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2736,9 +2736,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
-		if (wl->wilc1000_initialized) {
+		if (wl->initialized) {
 			nic->iftype = AP_MODE;
-			wl->wilc1000_initialized = 1;
 			mac_close(dev);
 			mac_open(dev);
 
@@ -2829,7 +2828,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				(struct key_params *)(&g_key_gtk_params));
 		}
 
-		if (wl->wilc1000_initialized)
+		if (wl->initialized)
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ca14fd6..15ce2e8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -157,7 +157,7 @@ struct wilc_vif {
 
 struct wilc {
 	int mac_status;
-	int wilc1000_initialized;
+	bool initialized;
 	#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
 	unsigned short dev_irq_num;
 	#endif
-- 
1.9.1

