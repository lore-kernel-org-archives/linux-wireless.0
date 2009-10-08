Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23095 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443AbZJHS64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:56 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 16/20] wl1271: Use vmalloc to allocate memory for firmware
Date: Thu,  8 Oct 2009 21:56:32 +0300
Message-Id: <1255028196-6565-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Use vmalloc to allocate memory for the firmware image, and use a smaller
linear buffer for the actual transfer of the firmware to the chipset.

This patch is an adaptation of a similar patch for wl1251 by Kalle Valo.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   16 ++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 +++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 8228ef4..7640313 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -94,7 +94,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 					     size_t fw_data_len, u32 dest)
 {
 	int addr, chunk_num, partition_limit;
-	u8 *p;
+	u8 *p, *chunk;
 
 	/* whal_FwCtrl_LoadFwImageSm() */
 
@@ -103,12 +103,17 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	wl1271_debug(DEBUG_BOOT, "fw_data_len %zd chunk_size %d",
 		     fw_data_len, CHUNK_SIZE);
 
-
 	if ((fw_data_len % 4) != 0) {
 		wl1271_error("firmware length not multiple of four");
 		return -EIO;
 	}
 
+	chunk = kmalloc(CHUNK_SIZE, GFP_KERNEL);
+	if (!buf) {
+		wl1271_error("allocation for firmware upload chunk failed");
+		return -ENOMEM;
+	}
+
 	wl1271_set_partition(wl, dest,
 			     part_table[PART_DOWN].mem.size,
 			     part_table[PART_DOWN].reg.start,
@@ -137,9 +142,10 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		/* 10.3 upload the chunk */
 		addr = dest + chunk_num * CHUNK_SIZE;
 		p = buf + chunk_num * CHUNK_SIZE;
+		memcpy(chunk, p, CHUNK_SIZE);
 		wl1271_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1271_spi_mem_write(wl, addr, p, CHUNK_SIZE);
+		wl1271_spi_mem_write(wl, addr, chunk, CHUNK_SIZE);
 
 		chunk_num++;
 	}
@@ -147,10 +153,12 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	/* 10.4 upload the last chunk */
 	addr = dest + chunk_num * CHUNK_SIZE;
 	p = buf + chunk_num * CHUNK_SIZE;
+	memcpy(chunk, p, fw_data_len % CHUNK_SIZE);
 	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%zd B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1271_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+	wl1271_spi_mem_write(wl, addr, chunk, fw_data_len % CHUNK_SIZE);
 
+	kfree(chunk);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 09fe968..d22de23 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -30,6 +30,7 @@
 #include <linux/spi/spi.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
 #include <linux/spi/wl12xx.h>
 
 #include "wl1271.h"
@@ -231,7 +232,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	}
 
 	wl->fw_len = fw->size;
-	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
+	wl->fw = vmalloc(wl->fw_len);
 
 	if (!wl->fw) {
 		wl1271_error("could not allocate memory for the firmware");
@@ -1484,7 +1485,7 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 	platform_device_unregister(&wl1271_device);
 	free_irq(wl->irq, wl);
 	kfree(wl->target_mem_map);
-	kfree(wl->fw);
+	vfree(wl->fw);
 	wl->fw = NULL;
 	kfree(wl->nvs);
 	wl->nvs = NULL;
-- 
1.5.6.5

