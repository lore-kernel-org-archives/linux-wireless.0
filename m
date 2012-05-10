Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58739 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2EJJQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:00 -0400
Received: by mail-wg0-f42.google.com with SMTP id ds11so231730wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:59 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 40/78] wlcore/wl12xx: move rx_mem_pool_addr element to wl12xx
Date: Thu, 10 May 2012 12:13:45 +0300
Message-Id: <1336641263-5761-41-git-send-email-arik@wizery.com> (sfid-20120510_112147_526973_7919FDC2)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Only wl127x chips use the rx_mem_pool_addr values, which need to be
given to the firmware as part of the RX path.  Move this from core to
the wl12xx driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |    2 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    5 +++++
 drivers/net/wireless/ti/wlcore/wlcore.h   |    3 ---
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    5 -----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 962d85d..0266855 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -596,7 +596,7 @@ static void wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 {
 	if (wl->chip.id != CHIP_ID_1283_PG20) {
 		struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
-		struct wl1271_rx_mem_pool_addr rx_mem_addr;
+		struct wl127x_rx_mem_pool_addr rx_mem_addr;
 
 		/*
 		 * Choose the block we want to read
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 0d81c1e..de11324 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -24,6 +24,11 @@
 
 #include "conf.h"
 
+struct wl127x_rx_mem_pool_addr {
+	u32 addr;
+	u32 addr_extra;
+};
+
 struct wl12xx_priv {
 	struct wl12xx_priv_conf conf;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 89abbce..f62152e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -213,9 +213,6 @@ struct wl1271 {
 	/* FW Rx counter */
 	u32 rx_counter;
 
-	/* Rx memory pool address */
-	struct wl1271_rx_mem_pool_addr rx_mem_pool_addr;
-
 	/* Intermediate buffer, used for packet aggregation */
 	u8 *aggr_buf;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 819c97c..53263a9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -194,11 +194,6 @@ struct wl_fw_status {
 	u8 priv[0];
 } __packed;
 
-struct wl1271_rx_mem_pool_addr {
-	u32 addr;
-	u32 addr_extra;
-};
-
 #define WL1271_MAX_CHANNELS 64
 struct wl1271_scan {
 	struct cfg80211_scan_request *req;
-- 
1.7.9.5

