Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5790 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbbJ1Hpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:45:36 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/12] staging: wilc1000: linux_wlan_firmware_download: change argument
Date: Wed, 28 Oct 2015 16:48:18 +0900
Message-ID: <1446018508-17889-2-git-send-email-glen.lee@atmel.com> (sfid-20151028_084549_179425_DD19DF8E)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes argument p_nic with wilc and use it instead of
g_linux_wlan. Pass argument dev to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2a5b36f..69d2839 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -598,12 +598,16 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 _fail_:
 	return ret;
 }
-static int linux_wlan_firmware_download(struct wilc *p_nic)
+static int linux_wlan_firmware_download(struct net_device *dev)
 {
-
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 	int ret = 0;
 
-	if (!g_linux_wlan->firmware) {
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
+	if (!wilc->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
 		ret = -ENOBUFS;
 		goto _FAIL_;
@@ -612,15 +616,15 @@ static int linux_wlan_firmware_download(struct wilc *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(g_linux_wlan->firmware->data,
-					  g_linux_wlan->firmware->size);
+	ret = wilc_wlan_firmware_download(wilc->firmware->data,
+					  wilc->firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
 	/* Freeing FW buffer */
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
-	release_firmware(g_linux_wlan->firmware);
+	release_firmware(wilc->firmware);
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
@@ -1124,7 +1128,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/*Download firmware*/
-		ret = linux_wlan_firmware_download(wl);
+		ret = linux_wlan_firmware_download(dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
-- 
1.9.1

