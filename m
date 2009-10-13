Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36276 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933837AbZJMJut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:49 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 20/22] wl1271: Correct memory handling for FW boot
Date: Tue, 13 Oct 2009 12:47:57 +0300
Message-Id: <1255427279-1224-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Several memory allocation related failure cases were not properly
handled by the driver - the result was that in low memory conditions
booting of a corrupted FW could be attempted - and user space would not
get proper failure code.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index b8a37a8..41a3050 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -134,7 +134,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	}
 
 	chunk = kmalloc(CHUNK_SIZE, GFP_KERNEL);
-	if (!buf) {
+	if (!chunk) {
 		wl1271_error("allocation for firmware upload chunk failed");
 		return -ENOMEM;
 	}
@@ -184,6 +184,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 static int wl1271_boot_upload_firmware(struct wl1271 *wl)
 {
 	u32 chunks, addr, len;
+	int ret = 0;
 	u8 *fw;
 
 	fw = wl->fw;
@@ -204,11 +205,13 @@ static int wl1271_boot_upload_firmware(struct wl1271 *wl)
 		}
 		wl1271_debug(DEBUG_BOOT, "chunk %d addr 0x%x len %u",
 			     chunks, addr, len);
-		wl1271_boot_upload_firmware_chunk(wl, fw, len, addr);
+		ret = wl1271_boot_upload_firmware_chunk(wl, fw, len, addr);
+		if (ret != 0)
+			break;
 		fw += len;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int wl1271_boot_upload_nvs(struct wl1271 *wl)
@@ -284,6 +287,8 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 
 	/* Copy the NVS tables to a new block to ensure alignment */
 	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
+	if (!nvs_aligned)
+		return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
 	/* FIXME: In wl1271, we upload everything at once.
-- 
1.5.6.5

