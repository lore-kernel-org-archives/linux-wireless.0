Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33888 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab1LUUgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:36:45 -0500
Received: by lami14 with SMTP id i14so3216854lam.20
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 12:36:42 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 2/3] wl1251: convert 32-bit values to le32 before writing to the chip
Date: Wed, 21 Dec 2011 22:36:28 +0200
Message-Id: <1324499789-13525-3-git-send-email-coelho@ti.com> (sfid-20111221_213647_884271_DC469CB0)
In-Reply-To: <1324499789-13525-1-git-send-email-coelho@ti.com>
References: <1324499789-13525-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 32-bit values were not converted before writing them to the chip.
Change the wl1251_read32() and wl1251_write32() so that they always
read and write le32 values and convert to and from the CPU endianess.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl1251/io.h     |    9 ++++-----
 drivers/net/wireless/wl1251/wl1251.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl1251/io.h b/drivers/net/wireless/wl1251/io.h
index c545e9d..d382877 100644
--- a/drivers/net/wireless/wl1251/io.h
+++ b/drivers/net/wireless/wl1251/io.h
@@ -36,16 +36,15 @@
 
 static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
-	u32 response;
-
-	wl->if_ops->read(wl, addr, &response, sizeof(u32));
+	wl->if_ops->read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 
-	return response;
+	return le32_to_cpu(wl->buffer_32);
 }
 
 static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
 {
-	wl->if_ops->write(wl, addr, &val, sizeof(u32));
+	wl->buffer_32 = cpu_to_le32(val);
+	wl->if_ops->write(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 }
 
 static inline u32 wl1251_read_elp(struct wl1251 *wl, int addr)
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index a77f1bb..9d8f581 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -380,7 +380,7 @@ struct wl1251 {
 	struct wl1251_stats stats;
 	struct wl1251_debugfs debugfs;
 
-	u32 buffer_32;
+	__le32 buffer_32;
 	u32 buffer_cmd;
 	u8 buffer_busyword[WL1251_BUSY_WORD_LEN];
 	struct wl1251_rx_descriptor *rx_descriptor;
-- 
1.7.4.1

