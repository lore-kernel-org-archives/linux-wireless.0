Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1611 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZDECLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/6] wl12xx: separate platform data into arch-independent code
Date: Sat,  4 Apr 2009 22:10:25 -0400
Message-Id: <1238897428-19639-4-git-send-email-me@bobcopeland.com> (sfid-20090405_041124_022826_C6844045)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to build the wl12xx driver on any arch, extract the SPI
config struct into include/linux/spi/ and remove the OMAP tag-based
retrieval.  The board code can then set the platform data on
the spi struct device before probe.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/main.c   |    7 ++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    5 ++---
 include/linux/spi/wl12xx_spi.h       |   18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/spi/wl12xx_spi.h

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9de45c7..dd3c277 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1266,6 +1266,7 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	struct wl12xx *wl;
 	int ret, i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+	struct wl12xx_platform_data *pdata = spi->dev.platform_data;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
 	if (!hw) {
@@ -1279,9 +1280,9 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->hw = hw;
 	dev_set_drvdata(&spi->dev, wl);
 	wl->spi = spi;
-	wl->config = omap_get_config(OMAP_TAG_WLAN_CX3110X,
-				     struct omap_wlan_cx3110x_config);
-	if (wl->config == NULL) {
+
+	wl->config = pdata;
+	if (!wl->config) {
 		ret = -ENODEV;
 		goto out_free;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1856b07..6f0b33d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -28,9 +28,8 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
+#include <linux/spi/wl12xx_spi.h>
 #include <net/mac80211.h>
-#include <mach/board.h>
-#include <mach/board-nokia.h>
 
 #define DRIVER_NAME "wl12xx"
 #define DRIVER_PREFIX DRIVER_NAME ": "
@@ -175,7 +174,7 @@ struct wl12xx {
 	bool mac80211_registered;
 
 	struct spi_device *spi;
-	const struct omap_wlan_cx3110x_config *config;
+	const struct wl12xx_platform_data *config;
 
 	enum wl12xx_state state;
 	struct mutex mutex;
diff --git a/include/linux/spi/wl12xx_spi.h b/include/linux/spi/wl12xx_spi.h
new file mode 100644
index 0000000..4011d00
--- /dev/null
+++ b/include/linux/spi/wl12xx_spi.h
@@ -0,0 +1,18 @@
+/*
+ * wl12xx_spi.h
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _WL12XX_SPI_H
+#define _WL12XX_SPI_H
+
+struct wl12xx_platform_data {
+	u8  chip_type;
+	s16 power_gpio;
+	s16 irq_gpio;
+	s16 spi_cs_gpio;
+};
+
+#endif
-- 
1.6.0.6


