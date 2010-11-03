Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44763 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0KCWN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:13:57 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so668478eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 15:13:56 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/3] wl1251: add power callback to wl1251_if_operations
Date: Thu,  4 Nov 2010 00:13:47 +0200
Message-Id: <1288822429-24541-2-git-send-email-notasas@gmail.com>
In-Reply-To: <1288822429-24541-1-git-send-email-notasas@gmail.com>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call interface specific power callback before calling board specific
one. Also allow that callback to fail. This is how it's done for
wl1271 and will be used for runtime_pm support.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/main.c   |   15 +++++++++------
 drivers/net/wireless/wl1251/sdio.c   |    8 ++++++--
 drivers/net/wireless/wl1251/spi.c    |    9 +++++++++
 drivers/net/wireless/wl1251/wl1251.h |    1 +
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 7a87625..012e1a4 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -52,14 +52,14 @@ void wl1251_disable_interrupts(struct wl1251 *wl)
 	wl->if_ops->disable_irq(wl);
 }
 
-static void wl1251_power_off(struct wl1251 *wl)
+static int wl1251_power_off(struct wl1251 *wl)
 {
-	wl->set_power(false);
+	return wl->if_ops->power(wl, false);
 }
 
-static void wl1251_power_on(struct wl1251 *wl)
+static int wl1251_power_on(struct wl1251 *wl)
 {
-	wl->set_power(true);
+	return wl->if_ops->power(wl, true);
 }
 
 static int wl1251_fetch_firmware(struct wl1251 *wl)
@@ -152,9 +152,12 @@ static void wl1251_fw_wakeup(struct wl1251 *wl)
 
 static int wl1251_chip_wakeup(struct wl1251 *wl)
 {
-	int ret = 0;
+	int ret;
+
+	ret = wl1251_power_on(wl);
+	if (ret < 0)
+		return ret;
 
-	wl1251_power_on(wl);
 	msleep(WL1251_POWER_ON_SLEEP);
 	wl->if_ops->reset(wl);
 
diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index 74ba9ce..0285190 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -171,8 +171,12 @@ static void wl1251_disable_line_irq(struct wl1251 *wl)
 	return disable_irq(wl->irq);
 }
 
-static void wl1251_sdio_set_power(bool enable)
+static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
 {
+	if (wl->set_power)
+		wl->set_power(enable);
+
+	return 0;
 }
 
 static struct wl1251_if_operations wl1251_sdio_ops = {
@@ -181,6 +185,7 @@ static struct wl1251_if_operations wl1251_sdio_ops = {
 	.write_elp = wl1251_sdio_write_elp,
 	.read_elp = wl1251_sdio_read_elp,
 	.reset = wl1251_sdio_reset,
+	.power = wl1251_sdio_set_power,
 };
 
 static int wl1251_platform_probe(struct platform_device *pdev)
@@ -239,7 +244,6 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	wl_sdio->func = func;
 	wl->if_priv = wl_sdio;
 	wl->if_ops = &wl1251_sdio_ops;
-	wl->set_power = wl1251_sdio_set_power;
 
 	if (wl12xx_board_data != NULL) {
 		wl->set_power = wl12xx_board_data->set_power;
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl1251/spi.c
index 88fa8e6..ac872b3 100644
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -215,12 +215,21 @@ static void wl1251_spi_disable_irq(struct wl1251 *wl)
 	return disable_irq(wl->irq);
 }
 
+static int wl1251_spi_set_power(struct wl1251 *wl, bool enable)
+{
+	if (wl->set_power)
+		wl->set_power(enable);
+
+	return 0;
+}
+
 static const struct wl1251_if_operations wl1251_spi_ops = {
 	.read = wl1251_spi_read,
 	.write = wl1251_spi_write,
 	.reset = wl1251_spi_reset_wake,
 	.enable_irq = wl1251_spi_enable_irq,
 	.disable_irq = wl1251_spi_disable_irq,
+	.power = wl1251_spi_set_power,
 };
 
 static int __devinit wl1251_spi_probe(struct spi_device *spi)
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index e113d4c..13fbeec 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -256,6 +256,7 @@ struct wl1251_if_operations {
 	void (*write)(struct wl1251 *wl, int addr, void *buf, size_t len);
 	void (*read_elp)(struct wl1251 *wl, int addr, u32 *val);
 	void (*write_elp)(struct wl1251 *wl, int addr, u32 val);
+	int  (*power)(struct wl1251 *wl, bool enable);
 	void (*reset)(struct wl1251 *wl);
 	void (*enable_irq)(struct wl1251 *wl);
 	void (*disable_irq)(struct wl1251 *wl);
-- 
1.6.3.3

