Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22981 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbJTF2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:28:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/12] staging: wilc1000: rename wilc_firmware in the struct wilc
Date: Tue, 20 Oct 2015 14:26:53 +0900
Message-ID: <1445318816-21686-10-git-send-email-tony.cho@atmel.com> (sfid-20151020_072817_222723_5213A11A)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames wilc_firmware in the struct wilc to the firmware. In
addition, null assignments to the wl->firmware after release_firmware
are removed because it is not necessary.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 15 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 74b7cc0..16b1d80 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -537,7 +537,7 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 		goto _fail_;
 	}
 #endif
-	g_linux_wlan->wilc_firmware = wilc_firmware;
+	g_linux_wlan->firmware = wilc_firmware;
 
 _fail_:
 
@@ -594,7 +594,7 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 
 	int ret = 0;
 
-	if (g_linux_wlan->wilc_firmware == NULL) {
+	if (!g_linux_wlan->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
 		ret = -ENOBUFS;
 		goto _FAIL_;
@@ -603,16 +603,15 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(g_linux_wlan->wilc_firmware->data,
-					  g_linux_wlan->wilc_firmware->size);
+	ret = wilc_wlan_firmware_download(g_linux_wlan->firmware->data,
+					  g_linux_wlan->firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
-	release_firmware(g_linux_wlan->wilc_firmware);
-	g_linux_wlan->wilc_firmware = NULL;
+	release_firmware(g_linux_wlan->firmware);
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
@@ -1709,8 +1708,8 @@ void wl_wlan_cleanup(void)
 			nic[i] = netdev_priv(g_linux_wlan->vif[i].ndev);
 	}
 
-	if (g_linux_wlan && g_linux_wlan->wilc_firmware)
-		release_firmware(g_linux_wlan->wilc_firmware);
+	if (g_linux_wlan && g_linux_wlan->firmware)
+		release_firmware(g_linux_wlan->firmware);
 
 	if (g_linux_wlan &&
 	   (g_linux_wlan->vif[0].ndev || g_linux_wlan->vif[1].ndev)) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b410424..74eb7b6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -182,7 +182,7 @@ struct wilc {
 
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
 
-	const struct firmware *wilc_firmware;
+	const struct firmware *firmware;
 
 #ifdef WILC_SDIO
 	struct sdio_func *wilc_sdio_func;
-- 
1.9.1

