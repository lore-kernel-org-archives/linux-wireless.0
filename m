Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab1CaIHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:24 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1636302fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:23 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 5/5] wl12xx: Handle platforms without level trigger interrupts
Date: Thu, 31 Mar 2011 10:07:01 +0200
Message-Id: <1301558821-17787-6-git-send-email-ido@wizery.com>
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platforms are incapable of triggering on level interrupts. Add a
platform quirks member in the platform data structure, as well as an
edge interrupt quirk which can be set on such platforms.

When the interrupt is requested with IRQF_TRIGGER_RISING, IRQF_ONESHOT
cannot be used, as we might miss interrupts that occur after the FW
status is cleared and before the threaded interrupt handler exits.

Moreover, when IRQF_ONESHOT is not set, iterating more than once in the
threaded interrupt handler introduces a few race conditions between this
handler and the hardirq handler. Currently this is worked around by
limiting the loop to one iteration only. This workaround has an impact
on performance. To remove to this restriction, the race conditions will
need to be addressed.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    9 +++++++++
 drivers/net/wireless/wl12xx/sdio.c   |    9 ++++++++-
 drivers/net/wireless/wl12xx/spi.c    |    9 ++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 include/linux/wl12xx.h               |    4 ++++
 5 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f1c9941..ccc468a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -30,6 +30,7 @@
 #include <linux/vmalloc.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/wl12xx.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
@@ -719,6 +720,13 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 	set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
 	cancel_work_sync(&wl->tx_work);
 
+	/*
+	 * In case edge triggered interrupt must be used, we cannot iterate
+	 * more than once without introducing race conditions with the hardirq.
+	 */
+	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+		loopcount = 1;
+
 	mutex_lock(&wl->mutex);
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
@@ -3618,6 +3626,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
+	wl->platform_quirks = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 15efe0a..82844aa 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -220,6 +220,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	struct ieee80211_hw *hw;
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
+	unsigned long irqflags;
 	int ret;
 
 	/* We are only able to handle the wlan function */
@@ -251,9 +252,15 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wl->irq = wlan_data->irq;
 	wl->ref_clock = wlan_data->board_ref_clock;
 	wl->tcxo_clock = wlan_data->board_tcxo_clock;
+	wl->platform_quirks = wlan_data->platform_quirks;
+
+	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+		irqflags = IRQF_TRIGGER_RISING;
+	else
+		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
 
 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   irqflags,
 				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 3b862a2..78c3ce6 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -364,6 +364,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
+	unsigned long irqflags;
 	int ret;
 
 	pdata = spi->dev.platform_data;
@@ -402,6 +403,12 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	wl->ref_clock = pdata->board_ref_clock;
 	wl->tcxo_clock = pdata->board_tcxo_clock;
+	wl->platform_quirks = pdata->platform_quirks;
+
+	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+		irqflags = IRQF_TRIGGER_RISING;
+	else
+		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
 
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
@@ -411,7 +418,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	}
 
 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   irqflags,
 				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 34b03eb..4137b1d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -577,6 +577,9 @@ struct wl1271 {
 
 	/* Quirks of specific hardware revisions */
 	unsigned int quirks;
+
+	/* Platform limitations */
+	unsigned int platform_quirks;
 };
 
 struct wl1271_station {
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index c1a743e..4b69739 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -53,8 +53,12 @@ struct wl12xx_platform_data {
 	bool use_eeprom;
 	int board_ref_clock;
 	int board_tcxo_clock;
+	unsigned long platform_quirks;
 };
 
+/* Platform does not support level trigger interrupts */
+#define WL12XX_PLATFORM_QUIRK_EDGE_IRQ	BIT(0)
+
 #ifdef CONFIG_WL12XX_PLATFORM_DATA
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
-- 
1.7.1

