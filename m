Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0IOX1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 19:27:44 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-omap@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v6 2/7] wl1271: propagate set_power's return value
Date: Thu, 16 Sep 2010 01:22:04 +0200
Message-Id: <1284592929-29616-3-git-send-email-ohad@wizery.com>
In-Reply-To: <1284592929-29616-1-git-send-email-ohad@wizery.com>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it possible for the set power method to indicate a
success/failure return value. This is needed to support
more complex power on/off operations such as SDIO
power manipulations.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_io.h   |    9 ++++++---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   15 +++++++++------
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    4 +++-
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index dd3cee6..faa5925 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -313,7 +313,7 @@ struct wl1271_if_operations {
 		     bool fixed);
 	void (*reset)(struct wl1271 *wl);
 	void (*init)(struct wl1271 *wl);
-	void (*power)(struct wl1271 *wl, bool enable);
+	int (*power)(struct wl1271 *wl, bool enable);
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index bc806c7..c1f92e6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -144,10 +144,13 @@ static inline void wl1271_power_off(struct wl1271 *wl)
 	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 }
 
-static inline void wl1271_power_on(struct wl1271 *wl)
+static inline int wl1271_power_on(struct wl1271 *wl)
 {
-	wl->if_ops->power(wl, true);
-	set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+	int ret = wl->if_ops->power(wl, true);
+	if (ret == 0)
+		set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+
+	return ret;
 }
 
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8e55cf8..af26150 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -621,7 +621,9 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	int ret = 0;
 
 	msleep(WL1271_PRE_POWER_ON_SLEEP);
-	wl1271_power_on(wl);
+	ret = wl1271_power_on(wl);
+	if (ret < 0)
+		goto out;
 	msleep(WL1271_POWER_ON_SLEEP);
 	wl1271_io_reset(wl);
 	wl1271_io_init(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index b5d9565..1d5dc72 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -159,35 +159,38 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 		wl1271_error("sdio write failed (%d)", ret);
 }
 
-static void wl1271_sdio_power_on(struct wl1271 *wl)
+static int wl1271_sdio_power_on(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 	sdio_release_host(func);
+
+	return 0;
 }
 
-static void wl1271_sdio_power_off(struct wl1271 *wl)
+static int wl1271_sdio_power_off(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
+
+	return 0;
 }
 
-static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
+static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
 	/* Let the SDIO stack handle wlan_enable control, so we
 	 * keep host claimed while wlan is in use to keep wl1271
 	 * alive.
 	 */
 	if (enable)
-		wl1271_sdio_power_on(wl);
+		return wl1271_sdio_power_on(wl);
 	else
-		wl1271_sdio_power_off(wl);
-
+		return wl1271_sdio_power_off(wl);
 }
 
 static struct wl1271_if_operations sdio_ops = {
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index c3fdab7..de56d8d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -312,10 +312,12 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-static void wl1271_spi_set_power(struct wl1271 *wl, bool enable)
+static int wl1271_spi_set_power(struct wl1271 *wl, bool enable)
 {
 	if (wl->set_power)
 		wl->set_power(enable);
+
+	return 0;
 }
 
 static struct wl1271_if_operations spi_ops = {
-- 
1.7.0.4

