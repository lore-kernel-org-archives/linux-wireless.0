Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2EJJOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:38 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/78] wl18xx: add partition table
Date: Thu, 10 May 2012 12:13:09 +0300
Message-Id: <1336641263-5761-5-git-send-email-arik@wizery.com> (sfid-20120510_111442_929865_EAA8F322)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Define and add the partition table in the wlcore struct.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 3fa9298..f3a164a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -28,6 +28,40 @@
 static struct wlcore_ops wl18xx_ops = {
 };
 
+static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
+	[PART_TOP_PRCM_ELP_SOC] = {
+		.mem  = { .start = 0x00A02000, .size  = 0x00010000 },
+		.reg  = { .start = 0x00807000, .size  = 0x00005000 },
+		.mem2 = { .start = 0x00800000, .size  = 0x0000B000 },
+		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
+	},
+	[PART_DOWN] = {
+		.mem  = { .start = 0x00000000, .size  = 0x00014000 },
+		.reg  = { .start = 0x00810000, .size  = 0x0000BFFF },
+		.mem2 = { .start = 0x00000000, .size  = 0x00000000 },
+		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
+	},
+	[PART_BOOT] = {
+		.mem  = { .start = 0x00700000, .size = 0x0000030c },
+		.reg  = { .start = 0x00802000, .size = 0x00014578 },
+		.mem2 = { .start = 0x00B00404, .size = 0x00001000 },
+		.mem3 = { .start = 0x00C00000, .size = 0x00000400 },
+	},
+	[PART_WORK] = {
+		.mem  = { .start = 0x00800000, .size  = 0x000050FC },
+		.reg  = { .start = 0x00B00404, .size  = 0x00001000 },
+		.mem2 = { .start = 0x00C00000, .size  = 0x00000400 },
+		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
+	},
+	[PART_PHY_INIT] = {
+		/* TODO: use the phy_conf struct size here */
+		.mem  = { .start = 0x80926000, .size = 252 },
+		.reg  = { .start = 0x00000000, .size = 0x00000000 },
+		.mem2 = { .start = 0x00000000, .size = 0x00000000 },
+		.mem3 = { .start = 0x00000000, .size = 0x00000000 },
+	},
+};
+
 int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -41,6 +75,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 
 	wl = hw->priv;
 	wl->ops = &wl18xx_ops;
+	wl->ptable = wl18xx_ptable;
 
 	return wlcore_probe(wl, pdev);
 }
-- 
1.7.9.5

