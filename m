Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33031 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0CRK1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:10 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 02/21] wl1271: Cleaned up wlan power on/off functions
Date: Thu, 18 Mar 2010 12:26:27 +0200
Message-Id: <1268908006-16992-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added method for wlan power control to io_ops struct and moved
wl1271_power_on and wl1271_power_off functions to wl1271_io.h.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h         |    1 +
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |   12 +++++-------
 drivers/net/wireless/wl12xx/wl1271_io.h      |   12 ++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c    |   12 ------------
 drivers/net/wireless/wl12xx/wl1271_sdio.c    |   11 +++++------
 drivers/net/wireless/wl12xx/wl1271_spi.c     |    7 +++++++
 6 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 0deb4fd..7397999 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -344,6 +344,7 @@ struct wl1271_if_operations {
 		     bool fixed);
 	void (*reset)(struct wl1271 *wl);
 	void (*init)(struct wl1271 *wl);
+	void (*power)(struct wl1271 *wl, bool enable);
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index 8d7588c..3c0f5b1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -28,6 +28,7 @@
 #include "wl1271.h"
 #include "wl1271_acx.h"
 #include "wl1271_ps.h"
+#include "wl1271_io.h"
 
 /* ms */
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
@@ -276,13 +277,10 @@ static ssize_t gpio_power_write(struct file *file,
 		goto out;
 	}
 
-	if (value) {
-		wl->set_power(true);
-		set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
-	} else {
-		wl->set_power(false);
-		clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
-	}
+	if (value)
+		wl1271_power_on(wl);
+	else
+		wl1271_power_off(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 95d2168..3ff88d9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -138,6 +138,18 @@ static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
 
+static inline void wl1271_power_off(struct wl1271 *wl)
+{
+	wl->if_ops->power(wl, false);
+	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+}
+
+static inline void wl1271_power_on(struct wl1271 *wl)
+{
+	wl->if_ops->power(wl, true);
+	set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+}
+
 
 /* Top Register IO */
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0de337f..b3abb45 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -359,18 +359,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	return ret;
 }
 
-static void wl1271_power_off(struct wl1271 *wl)
-{
-	wl->set_power(false);
-	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
-}
-
-static void wl1271_power_on(struct wl1271 *wl)
-{
-	wl->set_power(true);
-	set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
-}
-
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_status *status)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 1f204db..d43e0d4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -156,20 +156,21 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	sdio_release_host(func);
 }
 
+static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
+{
+}
+
 static struct wl1271_if_operations sdio_ops = {
 	.read		= wl1271_sdio_raw_read,
 	.write		= wl1271_sdio_raw_write,
 	.reset		= wl1271_sdio_reset,
 	.init		= wl1271_sdio_init,
+	.power		= wl1271_sdio_set_power,
 	.dev		= wl1271_sdio_wl_to_dev,
 	.enable_irq	= wl1271_sdio_enable_interrupts,
 	.disable_irq	= wl1271_sdio_disable_interrupts
 };
 
-static void wl1271_sdio_set_power(bool enable)
-{
-}
-
 static int __devinit wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
@@ -190,8 +191,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wl->if_priv = func;
 	wl->if_ops = &sdio_ops;
 
-	wl->set_power = wl1271_sdio_set_power;
-
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index ed285fe..0eea733 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -347,11 +347,18 @@ static struct platform_device wl1271_device = {
 	},
 };
 
+static void wl1271_spi_set_power(struct wl1271 *wl, bool enable)
+{
+	if (wl->set_power)
+		wl->set_power(enable);
+}
+
 static struct wl1271_if_operations spi_ops = {
 	.read		= wl1271_spi_raw_read,
 	.write		= wl1271_spi_raw_write,
 	.reset		= wl1271_spi_reset,
 	.init		= wl1271_spi_init,
+	.power		= wl1271_spi_set_power,
 	.dev		= wl1271_spi_wl_to_dev,
 	.enable_irq	= wl1271_spi_enable_interrupts,
 	.disable_irq	= wl1271_spi_disable_interrupts
-- 
1.6.3.3

