Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0IAV1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 17:27:30 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v5 2/7] wireless: wl1271: support return value for the set power func
Date: Thu,  2 Sep 2010 00:26:45 +0300
Message-Id: <1283376410-9999-3-git-send-email-ohad@wizery.com>
In-Reply-To: <1283376410-9999-1-git-send-email-ohad@wizery.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it possible for the set power method to indicate a
success/failure return value. This is needed to support
more complex power on/off operations such as bringing up
(and down) sdio functions.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271_io.h   |    9 ++++++---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    4 +++-
 5 files changed, 16 insertions(+), 7 deletions(-)

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
index 9d68f00..e6e0852 100644
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
index 7059b5c..c41293a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -152,7 +152,7 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 
 }
 
-static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
+static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
@@ -167,6 +167,8 @@ static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 		sdio_disable_func(func);
 		sdio_release_host(func);
 	}
+
+	return 0;
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

