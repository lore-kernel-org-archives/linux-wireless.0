Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab2EJJO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:59 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/78] wl18xx: implement hw op for setting blocks in hw_tx_desc
Date: Thu, 10 May 2012 12:13:18 +0300
Message-Id: <1336641263-5761-14-git-send-email-arik@wizery.com> (sfid-20120510_111508_635736_82FC0304)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the 18xx variant to the HW Tx descriptor union and set the 18xx
specific values during Tx.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   10 ++++++++++
 drivers/net/wireless/ti/wlcore/tx.h   |   14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 055b194..c85492e 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -26,6 +26,7 @@
 #include "../wlcore/debug.h"
 #include "../wlcore/io.h"
 #include "../wlcore/acx.h"
+#include "../wlcore/tx.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"
@@ -312,12 +313,21 @@ static u32 wl18xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
 	return (len + blk_size - 1) / blk_size + spare_blks;
 }
 
+static void
+wl18xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
+			  u32 blks, u32 spare_blks)
+{
+	desc->wl18xx_mem.total_mem_blocks = blks;
+	desc->wl18xx_mem.reserved = 0;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
 	.trigger_cmd	= wl18xx_trigger_cmd,
 	.ack_event	= wl18xx_ack_event,
 	.calc_tx_blocks = wl18xx_calc_tx_blocks,
+	.set_tx_desc_blocks = wl18xx_set_tx_desc_blocks,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 2fd6e5d..e440c31 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -85,6 +85,19 @@ struct wl128x_tx_mem {
 	u8 extra_bytes;
 } __packed;
 
+struct wl18xx_tx_mem {
+	/*
+	 * Total number of memory blocks allocated by the host for
+	 * this packet.
+	 */
+	u8 total_mem_blocks;
+
+	/*
+	 * always zero
+	 */
+	u8 reserved;
+} __packed;
+
 /*
  * On wl128x based devices, when TX packets are aggregated, each packet
  * size must be aligned to the SDIO block size. The maximum block size
@@ -100,6 +113,7 @@ struct wl1271_tx_hw_descr {
 	union {
 		struct wl127x_tx_mem wl127x_mem;
 		struct wl128x_tx_mem wl128x_mem;
+		struct wl18xx_tx_mem wl18xx_mem;
 	} __packed;
 	/* Device time (in us) when the packet arrived to the driver */
 	__le32 start_time;
-- 
1.7.9.5

