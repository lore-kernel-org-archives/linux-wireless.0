Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16871 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbbJTIOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/13] staging: wilc1000: wilc1000_wlan_init: use netdev private wilc
Date: Tue, 20 Oct 2015 17:13:52 +0900
Message-ID: <1445328843-32247-2-git-send-email-tony.cho@atmel.com> (sfid-20151020_101429_104139_BC7C405B)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch use netdev private data member wilc instead of global variable
g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8fa6b7c..39341a8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1027,14 +1027,15 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 	wilc_wlan_inp_t nwi;
 	perInterface_wlan_t *nic = p_nic;
 	int ret = 0;
+	struct wilc *wl = nic->wilc;
 
-	if (!g_linux_wlan->initialized) {
-		g_linux_wlan->mac_status = WILC_MAC_STATUS_INIT;
-		g_linux_wlan->close = 0;
+	if (!wl->initialized) {
+		wl->mac_status = WILC_MAC_STATUS_INIT;
+		wl->close = 0;
 
-		wlan_init_locks(g_linux_wlan);
+		wlan_init_locks(wl);
 
-		linux_to_wlan(&nwi, g_linux_wlan);
+		linux_to_wlan(&nwi, wl);
 
 		ret = wilc_wlan_init(&nwi);
 		if (ret < 0) {
@@ -1044,7 +1045,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		if (init_irq(g_linux_wlan)) {
+		if (init_irq(wl)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_locks_;
@@ -1073,7 +1074,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/*Download firmware*/
-		ret = linux_wlan_firmware_download(g_linux_wlan);
+		ret = linux_wlan_firmware_download(wl);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
@@ -1101,7 +1102,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			PRINT_D(INIT_DBG, "***** Firmware Ver = %s  *******\n", Firmware_ver);
 		}
 		/* Initialize firmware with default configuration */
-		ret = linux_wlan_init_test_config(dev, g_linux_wlan);
+		ret = linux_wlan_init_test_config(dev, wl);
 
 		if (ret < 0) {
 			PRINT_ER("Failed to configure firmware\n");
@@ -1109,7 +1110,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_fw_start_;
 		}
 
-		g_linux_wlan->initialized = true;
+		wl->initialized = true;
 		return 0; /*success*/
 
 _fail_fw_start_:
@@ -1121,14 +1122,14 @@ _fail_irq_enable_:
 _fail_irq_init_:
 #endif
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wl);
 
 #endif
-		wlan_deinitialize_threads(g_linux_wlan);
+		wlan_deinitialize_threads(wl);
 _fail_wilc_wlan_:
 		wilc_wlan_cleanup();
 _fail_locks_:
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wl);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
 	} else {
 		PRINT_D(INIT_DBG, "wilc1000 already initialized\n");
-- 
1.9.1

