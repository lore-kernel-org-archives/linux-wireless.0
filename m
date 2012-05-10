Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab2EJJPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:16 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:16 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 21/78] wl18xx: add hw_init operation
Date: Thu, 10 May 2012 12:13:26 +0300
Message-Id: <1336641263-5761-22-git-send-email-arik@wizery.com> (sfid-20120510_112453_813543_E7EEACF5)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add wl18xx-specific HW initialization operation and create acx.[ch]
files to support that.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.c    |   57 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    |   52 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |   32 +++++++++++++++++
 drivers/net/wireless/ti/wlcore/acx.h    |    2 ++
 5 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.h

diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index dd3b4c1..764d598 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o tx.o
+wl18xx-objs	= main.o acx.o tx.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
new file mode 100644
index 0000000..aed8d0d
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -0,0 +1,57 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/acx.h"
+
+#include "acx.h"
+
+int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
+				  u32 sdio_blk_size, u32 extra_mem_blks,
+				  u32 len_field_size)
+{
+	struct wl18xx_acx_host_config_bitmap *bitmap_conf;
+	int ret;
+
+	bitmap_conf = kzalloc(sizeof(*bitmap_conf), GFP_KERNEL);
+	if (!bitmap_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bitmap_conf->host_cfg_bitmap = cpu_to_le32(host_cfg_bitmap);
+	bitmap_conf->host_sdio_block_size = cpu_to_le32(sdio_blk_size);
+	bitmap_conf->extra_mem_blocks = cpu_to_le32(extra_mem_blks);
+	bitmap_conf->length_field_size = cpu_to_le32(len_field_size);
+
+	ret = wl1271_cmd_configure(wl, ACX_HOST_IF_CFG_BITMAP,
+				   bitmap_conf, sizeof(*bitmap_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 bitmap config opt failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(bitmap_conf);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
new file mode 100644
index 0000000..c8eebd8
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -0,0 +1,52 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_ACX_H__
+#define __WL18XX_ACX_H__
+
+#include "../wlcore/wlcore.h"
+
+/* numbers of bits the length field takes (add 1 for the actual number) */
+#define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
+
+struct wl18xx_acx_host_config_bitmap {
+	struct acx_header header;
+
+	__le32 host_cfg_bitmap;
+
+	__le32 host_sdio_block_size;
+
+	/* extra mem blocks per frame in TX. */
+	__le32 extra_mem_blocks;
+
+	/*
+	 * number of bits of the length field in the first TX word
+	 * (up to 15 - for using the entire 16 bits).
+	 */
+	__le32 length_field_size;
+
+} __packed;
+
+int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
+				  u32 sdio_blk_size, u32 extra_mem_blks,
+				  u32 len_field_size);
+
+#endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ae71131..1e0719c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -33,6 +33,7 @@
 
 #include "reg.h"
 #include "conf.h"
+#include "acx.h"
 #include "tx.h"
 #include "wl18xx.h"
 
@@ -473,6 +474,36 @@ static void wl18xx_tx_immediate_completion(struct wl1271 *wl)
 	wl18xx_tx_immediate_complete(wl);
 }
 
+static int wl18xx_hw_init(struct wl1271 *wl)
+{
+	int ret;
+	u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE |
+		HOST_IF_CFG_ADD_RX_ALIGNMENT;
+
+	u32 sdio_align_size = 0;
+
+	/* Enable Tx SDIO padding */
+	if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN) {
+		host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
+		sdio_align_size = WL12XX_BUS_BLOCK_SIZE;
+	}
+
+	/* Enable Rx SDIO padding */
+	if (wl->quirks & WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN) {
+		host_cfg_bitmap |= HOST_IF_CFG_RX_PAD_TO_SDIO_BLK;
+		sdio_align_size = WL12XX_BUS_BLOCK_SIZE;
+	}
+
+	ret = wl18xx_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap,
+					    sdio_align_size,
+					    WL18XX_TX_HW_BLOCK_SPARE,
+					    WL18XX_HOST_IF_LEN_SIZE_FIELD);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -485,6 +516,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.get_rx_packet_len = wl18xx_get_rx_packet_len,
 	.tx_immediate_compl = wl18xx_tx_immediate_completion,
 	.tx_delayed_compl = NULL,
+	.hw_init	= wl18xx_hw_init,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 8106b2e..7a8dfba 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -828,6 +828,8 @@ struct wl1271_acx_keep_alive_config {
 #define HOST_IF_CFG_RX_FIFO_ENABLE     BIT(0)
 #define HOST_IF_CFG_TX_EXTRA_BLKS_SWAP BIT(1)
 #define HOST_IF_CFG_TX_PAD_TO_SDIO_BLK BIT(3)
+#define HOST_IF_CFG_RX_PAD_TO_SDIO_BLK BIT(4)
+#define HOST_IF_CFG_ADD_RX_ALIGNMENT   BIT(6)
 
 enum {
 	WL1271_ACX_TRIG_TYPE_LEVEL = 0,
-- 
1.7.9.5

