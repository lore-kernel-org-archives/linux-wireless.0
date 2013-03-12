Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56356 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3CLPFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 11:05:08 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: use print_hex_dump_debug()
Date: Tue, 12 Mar 2013 17:04:01 +0200
Message-ID: <1363100641-24815-1-git-send-email-coelho@ti.com> (sfid-20130312_160513_657139_DD5F98F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were printing out all the hex dumps regardless of whether dynamic
debugging was enabled or not.  Now that print_hex_dump_debug() has
been implemented, we can use that instead.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/debug.h |   33 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debug.h b/drivers/net/wireless/ti/wlcore/debug.h
index db4bf5a..0420bd4 100644
--- a/drivers/net/wireless/ti/wlcore/debug.h
+++ b/drivers/net/wireless/ti/wlcore/debug.h
@@ -89,25 +89,24 @@ extern u32 wl12xx_debug_level;
 	} while (0)
 #endif
 
-/* TODO: use pr_debug_hex_dump when it becomes available */
-#define wl1271_dump(level, prefix, buf, len)	\
-	do { \
-		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       0);				\
+#define wl1271_dump(level, prefix, buf, len)				      \
+	do {								      \
+		if (level & wl12xx_debug_level)				      \
+			print_hex_dump_debug(DRIVER_PREFIX prefix,	      \
+					DUMP_PREFIX_OFFSET, 16, 1,	      \
+					buf,				      \
+					min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+					0);				      \
 	} while (0)
 
-#define wl1271_dump_ascii(level, prefix, buf, len)	\
-	do { \
-		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       true);				\
+#define wl1271_dump_ascii(level, prefix, buf, len)			      \
+	do {								      \
+		if (level & wl12xx_debug_level)				      \
+			print_hex_dump_debug(DRIVER_PREFIX prefix,	      \
+					DUMP_PREFIX_OFFSET, 16, 1,	      \
+					buf,				      \
+					min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+					true);				      \
 	} while (0)
 
 #endif /* __DEBUG_H__ */
-- 
1.7.10.4

