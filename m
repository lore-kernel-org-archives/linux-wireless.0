Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59193 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2KVTNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:13:35 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3320903eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:13:34 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/13] wl18xx: change fw name and temporarily fail loading
Date: Thu, 22 Nov 2012 14:05:17 +0200
Message-Id: <1353585928-28666-3-git-send-email-eliad@wizery.com> (sfid-20121122_201349_576281_C04EFE5F)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new fw (8.5.0.0.28) is not backward compatible
with older drivers.

Use a new fw name (along with bumping the min
fw version), and add some code to fail
any boot attempt during the fw api alignment
patches (as the driver is not functional in
these transitional patches).

This code will be removed after the api alignment
will be done.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |    6 +++++-
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a39682a..8ba1c93 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -595,7 +595,7 @@ static const struct wl18xx_clk_cfg wl18xx_clk_table[NUM_CLOCK_CONFIGS] = {
 };
 
 /* TODO: maybe move to a new header file? */
-#define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw.bin"
+#define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw-2.bin"
 
 static int wl18xx_identify_chip(struct wl1271 *wl)
 {
@@ -1385,6 +1385,10 @@ static int wl18xx_setup(struct wl1271 *wl)
 	struct wl18xx_priv *priv = wl->priv;
 	int ret;
 
+	wl1271_error("driver is in transitional commit (due to fw api"
+		     "change) and can't be booted!");
+	return -EINVAL;
+
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 96a1e43..4d295a5 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -26,10 +26,10 @@
 
 /* minimum FW required for driver */
 #define WL18XX_CHIP_VER		8
-#define WL18XX_IFTYPE_VER	2
+#define WL18XX_IFTYPE_VER	5
 #define WL18XX_MAJOR_VER	0
 #define WL18XX_SUBTYPE_VER	0
-#define WL18XX_MINOR_VER	100
+#define WL18XX_MINOR_VER	28
 
 #define WL18XX_CMD_MAX_SIZE          740
 
-- 
1.7.6.401.g6a319

