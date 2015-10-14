Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43712 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbbJNLsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:48:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/16] staging: wilc1000: rename wilc_firmware in the struct wilc
Date: Wed, 14 Oct 2015 20:46:41 +0900
Message-ID: <1444823204-16736-13-git-send-email-tony.cho@atmel.com> (sfid-20151014_134836_379589_055813E0)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames wilc_firmware in the struct wilc to the firmware. In
addition, null assignments to the wl->firmware after release_firmware are
removed because it is not necessary.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 15 +++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e22d164..e8fe780 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -538,7 +538,7 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 		goto _fail_;
 	}
 #endif
-	wl->wilc_firmware = wilc_firmware;
+	wl->firmware = wilc_firmware;
 
 _fail_:
 
@@ -595,7 +595,7 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 
 	int ret = 0;
 
-	if (!wl->wilc_firmware) {
+	if (!wl->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
 		ret = -ENOBUFS;
 		goto _FAIL_;
@@ -604,16 +604,15 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(wl->wilc_firmware->data,
-					  wl->wilc_firmware->size);
+	ret = wilc_wlan_firmware_download(wl->firmware->data,
+					  wl->firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
-	release_firmware(wl->wilc_firmware);
-	wl->wilc_firmware = NULL;
+	release_firmware(wl->firmware);
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
@@ -1706,8 +1705,8 @@ void wl_wlan_cleanup(void)
 			nic[i] = netdev_priv(wl->vif[i].ndev);
 	}
 
-	if (wl && wl->wilc_firmware)
-		release_firmware(wl->wilc_firmware);
+	if (wl && wl->firmware)
+		release_firmware(wl->firmware);
 
 	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
 		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4f7c600..a6b948a 100644
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

