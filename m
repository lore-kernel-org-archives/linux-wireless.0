Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab2EJJOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:43 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/78] wl18xx: add identify chip operation
Date: Thu, 10 May 2012 12:13:11 +0300
Message-Id: <1336641263-5761-7-git-send-email-arik@wizery.com> (sfid-20120510_111448_260656_259BF804)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add identify_chip operation to detect the chip ID for wl185x and set
the correct firmware name.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   34 ++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 88fd934..e517afd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -27,9 +27,6 @@
 
 #include "reg.h"
 
-static struct wlcore_ops wl18xx_ops = {
-};
-
 static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 	[PART_TOP_PRCM_ELP_SOC] = {
 		.mem  = { .start = 0x00A02000, .size  = 0x00010000 },
@@ -84,6 +81,36 @@ static const int wl18xx_rtable[REG_TABLE_LEN] = {
 	[REG_RAW_FW_STATUS_ADDR]	= WL18XX_FW_STATUS_ADDR,
 };
 
+/* TODO: maybe move to a new header file? */
+#define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw.bin"
+
+static int wl18xx_identify_chip(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	switch (wl->chip.id) {
+	case CHIP_ID_185x_PG10:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
+			     wl->chip.id);
+		wl->sr_fw_name = WL18XX_FW_NAME;
+		wl->quirks |= WLCORE_QUIRK_NO_ELP;
+
+		/* TODO: need to blocksize alignment for RX/TX separately? */
+		break;
+	default:
+		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static struct wlcore_ops wl18xx_ops = {
+	.identify_chip = wl18xx_identify_chip,
+};
+
 int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -133,3 +160,4 @@ module_exit(wl18xx_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
+MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

