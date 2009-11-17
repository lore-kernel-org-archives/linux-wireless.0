Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63177 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZKQQtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:02 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 05/16] wl1251: allocate space for firmware with vmalloc()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:45 +0200
Message-ID: <20091117164844.2236.11218.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Earlier firmware was stored to a memory area allocated with kmalloc()
but finding a a contiguous area of memory long enough for the firmware is
very difficult in certain cases. better to allocate the memory for firmware
with vmalloc() instead and use a small buffer for DMA transfers.

Thanks to Eero Tamminen for the idea.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_boot.c |   27 ++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1251_main.c |    5 +++--
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 452d748..8febf27 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -314,8 +314,8 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 static int wl1251_boot_upload_firmware(struct wl1251 *wl)
 {
 	int addr, chunk_num, partition_limit;
-	size_t fw_data_len;
-	u8 *p;
+	size_t fw_data_len, len;
+	u8 *p, *buf;
 
 	/* whal_FwCtrl_LoadFwImageSm() */
 
@@ -334,6 +334,12 @@ static int wl1251_boot_upload_firmware(struct wl1251 *wl)
 		return -EIO;
 	}
 
+	buf = kmalloc(CHUNK_SIZE, GFP_KERNEL);
+	if (!buf) {
+		wl1251_error("allocation for firmware upload chunk failed");
+		return -ENOMEM;
+	}
+
 	wl1251_set_partition(wl, WL1251_PART_DOWN_MEM_START,
 			     WL1251_PART_DOWN_MEM_SIZE,
 			     WL1251_PART_DOWN_REG_START,
@@ -364,7 +370,11 @@ static int wl1251_boot_upload_firmware(struct wl1251 *wl)
 		p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
 		wl1251_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl1251_mem_write(wl, addr, p, CHUNK_SIZE);
+
+		/* need to copy the chunk for dma */
+		len = CHUNK_SIZE;
+		memcpy(buf, p, len);
+		wl1251_mem_write(wl, addr, buf, len);
 
 		chunk_num++;
 	}
@@ -372,9 +382,16 @@ static int wl1251_boot_upload_firmware(struct wl1251 *wl)
 	/* 10.4 upload the last chunk */
 	addr = WL1251_PART_DOWN_MEM_START + chunk_num * CHUNK_SIZE;
 	p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
+
+	/* need to copy the chunk for dma */
+	len = fw_data_len % CHUNK_SIZE;
+	memcpy(buf, p, len);
+
 	wl1251_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
-		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl1251_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+		     len, p, addr);
+	wl1251_mem_write(wl, addr, buf, len);
+
+	kfree(buf);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index b5e3bdb..1f4c238 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -28,6 +28,7 @@
 #include <linux/irq.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
 
 #include "wl1251.h"
 #include "wl12xx_80211.h"
@@ -83,7 +84,7 @@ static int wl1251_fetch_firmware(struct wl1251 *wl)
 	}
 
 	wl->fw_len = fw->size;
-	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
+	wl->fw = vmalloc(wl->fw_len);
 
 	if (!wl->fw) {
 		wl1251_error("could not allocate memory for the firmware");
@@ -1427,7 +1428,7 @@ int wl1251_free_hw(struct wl1251 *wl)
 
 	kfree(wl->target_mem_map);
 	kfree(wl->data_path);
-	kfree(wl->fw);
+	vfree(wl->fw);
 	wl->fw = NULL;
 	kfree(wl->nvs);
 	wl->nvs = NULL;

