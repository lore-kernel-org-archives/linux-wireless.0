Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22270 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0CZKym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:42 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 07/24] wl1271: Warnings caused by wrong format specifiers fixed
Date: Fri, 26 Mar 2010 12:53:16 +0200
Message-Id: <1269600813-32145-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

There were wrong format specifiers in wl1271_sdio.c in some debug
outputs. This has been causing warnings on some platforms.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 3c03de7..abfe75b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -117,7 +117,7 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		else
 			ret = sdio_memcpy_fromio(func, buf, addr, len);
 
-		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %d bytes",
+		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %zu bytes",
 			     addr, len);
 		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 	}
@@ -138,7 +138,7 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
 			     addr, ((u8 *)buf)[0]);
 	} else {
-		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %d bytes",
+		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %zu bytes",
 			     addr, len);
 		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 
-- 
1.6.3.3

