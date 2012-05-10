Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2EJJQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:25 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:24 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 52/78] wlcore: add module parameter to dump SDIO reads and writes
Date: Thu, 10 May 2012 12:13:57 +0300
Message-Id: <1336641263-5761-53-git-send-email-arik@wizery.com> (sfid-20120510_111638_935292_26B43652)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

In some cases we may want to dump all the SDIO data in order to get
detailed information for debugging the communication with the
firmware.

Add printks to dump the data and a module parameter to enable/disable
it.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 1082e39..c67ec48 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -33,6 +33,7 @@
 #include <linux/gpio.h>
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
+#include <linux/printk.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -46,6 +47,8 @@
 #define SDIO_DEVICE_ID_TI_WL1271	0x4076
 #endif
 
+static bool dump = false;
+
 struct wl12xx_sdio_glue {
 	struct device *dev;
 	struct platform_device *core;
@@ -77,6 +80,13 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 
 	sdio_claim_host(func);
 
+	if (unlikely(dump)) {
+		printk(KERN_DEBUG "wlcore_sdio: READ from 0x%04x\n", addr);
+		print_hex_dump(KERN_DEBUG, "wlcore_sdio: READ ",
+				DUMP_PREFIX_OFFSET, 16, 1,
+				buf, len, false);
+	}
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		dev_dbg(child->parent, "sdio read 52 addr 0x%x, byte 0x%02x\n",
@@ -106,6 +116,13 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 
 	sdio_claim_host(func);
 
+	if (unlikely(dump)) {
+		printk(KERN_DEBUG "wlcore_sdio: WRITE to 0x%04x\n", addr);
+		print_hex_dump(KERN_DEBUG, "wlcore_sdio: WRITE ",
+				DUMP_PREFIX_OFFSET, 16, 1,
+				buf, len, false);
+	}
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		dev_dbg(child->parent, "sdio write 52 addr 0x%x, byte 0x%02x\n",
@@ -380,6 +397,9 @@ static void __exit wl1271_exit(void)
 module_init(wl1271_init);
 module_exit(wl1271_exit);
 
+module_param(dump, bool, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(dump, "Enable sdio read/write dumps.");
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.7.9.5

