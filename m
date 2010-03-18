Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62559 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0CRK1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:48 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 16/21] wl1271: Added DEBUG_SDIO flag
Date: Thu, 18 Mar 2010 12:26:41 +0200
Message-Id: <1268908006-16992-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added separate flag for SDIO debugging. Previously it has used
DEBUG_SPI flag. This patch also includes couple indentation fixes.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 23a0c7e..4e60806 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -53,6 +53,7 @@ enum {
 	DEBUG_MAC80211	= BIT(11),
 	DEBUG_CMD	= BIT(12),
 	DEBUG_ACX	= BIT(13),
+	DEBUG_SDIO	= BIT(14),
 	DEBUG_ALL	= ~0,
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index d9183b6..0478919 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -102,14 +102,14 @@ static void wl1271_sdio_init(struct wl1271 *wl)
 }
 
 static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
-			 size_t len, bool fixed)
+				 size_t len, bool fixed)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
-		wl1271_debug(DEBUG_SPI, "sdio read 52 addr 0x%x, byte 0x%02x",
+		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
 			     addr, ((u8 *)buf)[0]);
 	} else {
 		if (fixed)
@@ -117,9 +117,9 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		else
 			ret = sdio_memcpy_fromio(func, buf, addr, len);
 
-		wl1271_debug(DEBUG_SPI, "sdio read 53 addr 0x%x, %d bytes",
+		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %d bytes",
 			     addr, len);
-		wl1271_dump_ascii(DEBUG_SPI, "data: ", buf, len);
+		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 	}
 
 	if (ret)
@@ -128,19 +128,19 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 }
 
 static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
-			  size_t len, bool fixed)
+				  size_t len, bool fixed)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
-		wl1271_debug(DEBUG_SPI, "sdio write 52 addr 0x%x, byte 0x%02x",
+		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
 			     addr, ((u8 *)buf)[0]);
 	} else {
-		wl1271_debug(DEBUG_SPI, "sdio write 53 addr 0x%x, %d bytes",
+		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %d bytes",
 			     addr, len);
-		wl1271_dump_ascii(DEBUG_SPI, "data: ", buf, len);
+		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 
 		if (fixed)
 			ret = sdio_writesb(func, addr, buf, len);
@@ -156,6 +156,10 @@ static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
+	/* Let the SDIO stack handle wlan_enable control, so we
+	 * keep host claimed while wlan is in use to keep wl1271
+	 * alive.
+	 */
 	if (enable) {
 		sdio_claim_host(func);
 		sdio_enable_func(func);
-- 
1.6.3.3

