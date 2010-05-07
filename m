Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43279 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0EGIjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:18 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 2/5] wl1271: Fix 32 bit register read related endiannes bug
Date: Fri,  7 May 2010 11:38:59 +0300
Message-Id: <1273221542-14283-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
References: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Reading single registers did not pay attention to data endianness. This patch
fix that.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h    |    2 +-
 drivers/net/wireless/wl12xx/wl1271_io.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 3e1769d..6f1b6b5 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -481,7 +481,7 @@ struct wl1271 {
 	struct wl1271_stats stats;
 	struct wl1271_debugfs debugfs;
 
-	u32 buffer_32;
+	__le32 buffer_32;
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index d8837ef..bc806c7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -74,12 +74,12 @@ static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 	wl1271_raw_read(wl, addr, &wl->buffer_32,
 			    sizeof(wl->buffer_32), false);
 
-	return wl->buffer_32;
+	return le32_to_cpu(wl->buffer_32);
 }
 
 static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	wl->buffer_32 = val;
+	wl->buffer_32 = cpu_to_le32(val);
 	wl1271_raw_write(wl, addr, &wl->buffer_32,
 			     sizeof(wl->buffer_32), false);
 }
-- 
1.6.3.3

