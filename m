Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22862 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbbJTF1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 01/12] staging: wilc1000: change the type of wilc1000_initialized
Date: Tue, 20 Oct 2015 14:26:45 +0900
Message-ID: <1445318816-21686-2-git-send-email-tony.cho@atmel.com> (sfid-20151020_072727_672602_27E15A4E)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the type of wilc1000_initialized in the struc wilc from int
to bool and also renames it to the initialized. In addition, unnecessary
wilc1000_initialized codes are removed in this patch.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 13 +++++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b879b8b..191851b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -884,9 +884,7 @@ _fail_:
 /**************************/
 void wilc1000_wlan_deinit(struct wilc *nic)
 {
-
-	if (g_linux_wlan->wilc1000_initialized)	{
-
+	if (g_linux_wlan->initialized)	{
 		printk("Deinitializing wilc1000  ...\n");
 
 		if (nic == NULL) {
@@ -935,7 +933,7 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 		wlan_deinit_locks(g_linux_wlan);
 
 		/* announce that wilc1000 is not initialized */
-		g_linux_wlan->wilc1000_initialized = 0;
+		g_linux_wlan->initialized = false;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
 
@@ -1143,10 +1141,9 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
 
-	if (!g_linux_wlan->wilc1000_initialized) {
+	if (!g_linux_wlan->initialized) {
 		g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
 		g_linux_wlan->close = 0;
-		g_linux_wlan->wilc1000_initialized = 0;
 
 		wlan_init_locks(g_linux_wlan);
 
@@ -1233,7 +1230,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_fw_start_;
 		}
 
-		g_linux_wlan->wilc1000_initialized = 1;
+		g_linux_wlan->initialized = true;
 		return 0; /*success*/
 
 _fail_fw_start_:
@@ -1567,7 +1564,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	nic = netdev_priv(ndev);
 
-	if (!g_linux_wlan->wilc1000_initialized)
+	if (!g_linux_wlan->initialized)
 		return 0;
 
 	switch (cmd) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bcbf1bd..e463090 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2418,7 +2418,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	}
 	/*If mac is closed, then return*/
-	if (!g_linux_wlan->wilc1000_initialized) {
+	if (!g_linux_wlan->initialized) {
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
 	}
@@ -2571,7 +2571,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (g_linux_wlan->initialized) {
 			host_int_del_All_Rx_BASession(priv->hWILCWFIDrv, g_linux_wlan->strInterfaceInfo[0].aBSSID, TID);
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
@@ -2627,7 +2627,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (g_linux_wlan->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2658,7 +2658,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		nic->iftype = CLIENT_MODE;
 
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (g_linux_wlan->initialized)	{
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
@@ -2712,7 +2712,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			refresh_scan(priv, 1, true);
 			Set_machw_change_vir_if(false);
 
-			if (g_linux_wlan->wilc1000_initialized)	{
+			if (g_linux_wlan->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
 					PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 						nic->g_struct_frame_reg[i].reg);
@@ -2735,9 +2735,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		linux_wlan_get_firmware(nic);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (g_linux_wlan->initialized)	{
 			nic->iftype = AP_MODE;
-			g_linux_wlan->wilc1000_initialized = 1;
 			mac_close(dev);
 			mac_open(dev);
 
@@ -2826,7 +2825,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 				(struct key_params *)(&g_key_gtk_params));
 		}
 
-		if (g_linux_wlan->wilc1000_initialized)	{
+		if (g_linux_wlan->initialized)	{
 			for (i = 0; i < num_reg_frame; i++) {
 				PRINT_D(INIT_DBG, "Frame registering Type: %x - Reg: %d\n", nic->g_struct_frame_reg[i].frame_type,
 					nic->g_struct_frame_reg[i].reg);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c5061fd..863571a 100644
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

