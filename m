Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:60727 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0DPKWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:22:18 -0400
Received: by bwz25 with SMTP id 25so2861104bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 03:22:16 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Bob Copeland <me@bobcopeland.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: add support for dedicated IRQ line
Date: Fri, 16 Apr 2010 13:22:12 +0300
Message-Id: <1271413332-2979-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251 has WLAN_IRQ pin for generating interrupts to host processor,
which is mandatory in SPI mode and optional in SDIO mode (which can
use SDIO interrupts instead). However TI recommends using deditated
IRQ line for SDIO too.

Add support for using dedicated interrupt line with SDIO, but also leave
ability to switch to SDIO interrupts in case it's needed.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |   56 ++++++++++++++++++++++++++---
 include/linux/spi/wl12xx.h                |    2 +
 2 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index 7409c34..d234285 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -25,6 +25,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/platform_device.h>
 #include <linux/spi/wl12xx.h>
+#include <linux/irq.h>
 
 #include "wl1251.h"
 
@@ -134,18 +135,36 @@ static void wl1251_sdio_disable_irq(struct wl1251 *wl)
 	sdio_release_host(func);
 }
 
+/* Interrupts when using dedicated WLAN_IRQ pin */
+static irqreturn_t wl1251_line_irq(int irq, void *cookie)
+{
+	struct wl1251 *wl = cookie;
+
+	ieee80211_queue_work(wl->hw, &wl->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static void wl1251_enable_line_irq(struct wl1251 *wl)
+{
+	return enable_irq(wl->irq);
+}
+
+static void wl1251_disable_line_irq(struct wl1251 *wl)
+{
+	return disable_irq(wl->irq);
+}
+
 static void wl1251_sdio_set_power(bool enable)
 {
 }
 
-static const struct wl1251_if_operations wl1251_sdio_ops = {
+static struct wl1251_if_operations wl1251_sdio_ops = {
 	.read = wl1251_sdio_read,
 	.write = wl1251_sdio_write,
 	.write_elp = wl1251_sdio_write_elp,
 	.read_elp = wl1251_sdio_read_elp,
 	.reset = wl1251_sdio_reset,
-	.enable_irq = wl1251_sdio_enable_irq,
-	.disable_irq = wl1251_sdio_disable_irq,
 };
 
 static int wl1251_platform_probe(struct platform_device *pdev)
@@ -191,6 +210,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		goto release;
 
 	sdio_set_block_size(func, 512);
+	sdio_release_host(func);
 
 	SET_IEEE80211_DEV(hw, &func->dev);
 	wl->if_priv = func;
@@ -199,17 +219,41 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 
 	if (wl12xx_board_data != NULL) {
 		wl->set_power = wl12xx_board_data->set_power;
+		wl->irq = wl12xx_board_data->irq;
 		wl->use_eeprom = wl12xx_board_data->use_eeprom;
 	}
 
-	sdio_release_host(func);
+	if (wl->irq) {
+		ret = request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
+		if (ret < 0) {
+			wl1251_error("request_irq() failed: %d", ret);
+			goto disable;
+		}
+
+		set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+		disable_irq(wl->irq);
+
+		wl1251_sdio_ops.enable_irq = wl1251_enable_line_irq;
+		wl1251_sdio_ops.disable_irq = wl1251_disable_line_irq;
+
+		wl1251_info("using dedicated interrupt line");
+	} else {
+		wl1251_sdio_ops.enable_irq = wl1251_sdio_enable_irq;
+		wl1251_sdio_ops.disable_irq = wl1251_sdio_disable_irq;
+
+		wl1251_info("using SDIO interrupt");
+	}
+
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
-		goto disable;
+		goto out_free_irq;
 
 	sdio_set_drvdata(func, wl);
 	return ret;
 
+out_free_irq:
+	if (wl->irq)
+		free_irq(wl->irq, wl);
 disable:
 	sdio_claim_host(func);
 	sdio_disable_func(func);
@@ -222,6 +266,8 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 {
 	struct wl1251 *wl = sdio_get_drvdata(func);
 
+	if (wl->irq)
+		free_irq(wl->irq, wl);
 	wl1251_free_hw(wl);
 
 	sdio_claim_host(func);
diff --git a/include/linux/spi/wl12xx.h b/include/linux/spi/wl12xx.h
index aed64ed..a223ecb 100644
--- a/include/linux/spi/wl12xx.h
+++ b/include/linux/spi/wl12xx.h
@@ -26,6 +26,8 @@
 
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
+	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
+	int irq;
 	bool use_eeprom;
 };
 
-- 
1.6.3.3

