Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53331 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab2FWGmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:09 -0400
Received: by lbok6 with SMTP id k6so5180351lbo.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:06 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 10/18] wlcore: Propagate errors from wl1271_read_hwaddr
Date: Sat, 23 Jun 2012 09:41:21 +0300
Message-Id: <1340433689-24320-11-git-send-email-coelho@ti.com> (sfid-20120623_084220_299994_C2E71D9F)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Propagate errors from wl1271_read_hwaddr. This function is only used
when reading the FW log (following a recovery), so don't read the FW log
in case of a bus error.

Also rename prefixes of wlcore functions which their prototypes had to
be changed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.h   |    4 ++--
 drivers/net/wireless/ti/wlcore/main.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 5e4a3d1..4a6688b 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -131,7 +131,7 @@ static inline int wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
 	return wlcore_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
+static inline int wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
 				      void *buf, size_t len, bool fixed)
 {
 	int physical;
@@ -142,7 +142,7 @@ static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
 
 	physical = wlcore_translate_addr(wl, addr);
 
-	wlcore_raw_read(wl, physical, buf, len, fixed);
+	return wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
 static inline int wlcore_read32(struct wl1271 *wl, int addr, u32 *val)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 546fcb0..b0795aa 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -851,8 +851,10 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	/* Traverse the memory blocks linked list */
 	do {
 		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
-		wl1271_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
-				   false);
+		ret = wlcore_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
+					 false);
+		if (ret < 0)
+			goto out;
 
 		/*
 		 * Memory blocks are linked to one another. The first 4 bytes
-- 
1.7.10

