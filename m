Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20506 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0BVGl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:26 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 03/22] wl1271: Implemented abstraction of IO functions.
Date: Mon, 22 Feb 2010 08:38:23 +0200
Message-Id: <1266820722-20202-4-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Changed the driver to use if_ops structure to abstract access to the IO
layer (SPI or SDIO).

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |   16 +++++++++++-
 drivers/net/wireless/wl12xx/wl1271_io.c   |   21 ++++++++++------
 drivers/net/wireless/wl12xx/wl1271_io.h   |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++--
 drivers/net/wireless/wl12xx/wl1271_spi.c  |   37 ++++++++++++++++++++++------
 5 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 97ea509..10135c9 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -334,11 +334,25 @@ struct wl1271_scan {
 	u8 probe_requests;
 };
 
+struct wl1271_if_operations {
+	void (*read)(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed);
+	void (*write)(struct wl1271 *wl, int addr, void *buf, size_t len,
+		     bool fixed);
+	void (*reset)(struct wl1271 *wl);
+	void (*init)(struct wl1271 *wl);
+	struct device* (*dev)(struct wl1271 *wl);
+	void (*enable_irq)(struct wl1271 *wl);
+	void (*disable_irq)(struct wl1271 *wl);
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
-	struct spi_device *spi;
+	void *if_priv;
+
+	struct wl1271_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index b825cfa..d00f7ed 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -31,14 +31,19 @@
 #include "wl1271_spi.h"
 #include "wl1271_io.h"
 
+struct device *wl1271_wl_to_dev(struct wl1271 *wl)
+{
+	return wl->if_ops->dev(wl);
+}
+
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
-	wl1271_spi_disable_interrupts(wl);
+	wl->if_ops->disable_irq(wl);
 }
 
 void wl1271_enable_interrupts(struct wl1271 *wl)
 {
-	wl1271_spi_enable_interrupts(wl);
+	wl->if_ops->enable_irq(wl);
 }
 
 static int wl1271_translate_addr(struct wl1271 *wl, int addr)
@@ -127,24 +132,24 @@ int wl1271_set_partition(struct wl1271 *wl,
 
 void wl1271_io_reset(struct wl1271 *wl)
 {
-	wl1271_spi_reset(wl);
+	wl->if_ops->reset(wl);
 }
 
 void wl1271_io_init(struct wl1271 *wl)
 {
-	wl1271_spi_init(wl);
+	wl->if_ops->init(wl);
 }
 
 void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 		      size_t len, bool fixed)
 {
-	wl1271_spi_raw_write(wl, addr, buf, len, fixed);
+	wl->if_ops->write(wl, addr, buf, len, fixed);
 }
 
 void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed)
 {
-	wl1271_spi_raw_read(wl, addr, buf, len, fixed);
+	wl->if_ops->read(wl, addr, buf, len, fixed);
 }
 
 void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
@@ -154,7 +159,7 @@ void wl1271_read(struct wl1271 *wl, int addr, void *buf, size_t len,
 
 	physical = wl1271_translate_addr(wl, addr);
 
-	wl1271_spi_raw_read(wl, physical, buf, len, fixed);
+	wl1271_raw_read(wl, physical, buf, len, fixed);
 }
 
 void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
@@ -164,7 +169,7 @@ void wl1271_write(struct wl1271 *wl, int addr, void *buf, size_t len,
 
 	physical = wl1271_translate_addr(wl, addr);
 
-	wl1271_spi_raw_write(wl, physical, buf, len, fixed);
+	wl1271_raw_write(wl, physical, buf, len, fixed);
 }
 
 u32 wl1271_read32(struct wl1271 *wl, int addr)
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index c8b0971..f2b6325 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -33,6 +33,8 @@ void wl1271_enable_interrupts(struct wl1271 *wl);
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
 
+struct device *wl1271_wl_to_dev(struct wl1271 *wl);
+
 /* Raw target IO, address is not translated */
 void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 		      size_t len, bool fixed);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 18347c3..6b3fd00 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -480,7 +480,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_FW_NAME, &wl->spi->dev);
+	ret = request_firmware(&fw, WL1271_FW_NAME, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get firmware: %d", ret);
@@ -552,7 +552,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_NVS_NAME, &wl->spi->dev);
+	ret = request_firmware(&fw, WL1271_NVS_NAME, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get nvs file: %d", ret);
@@ -1973,7 +1973,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	if (wl1271_11a_enabled())
 		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
-	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index b422c9f..a0f4169 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -33,6 +33,15 @@
 #include "wl1271_spi.h"
 #include "wl1271_io.h"
 
+static struct spi_device *wl_to_spi(struct wl1271 *wl)
+{
+	return wl->if_priv;
+}
+
+static struct device *wl1271_spi_wl_to_dev(struct wl1271 *wl)
+{
+	return &(wl_to_spi(wl)->dev);
+}
 
 void wl1271_spi_disable_interrupts(struct wl1271 *wl)
 {
@@ -65,7 +74,7 @@ void wl1271_spi_reset(struct wl1271 *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -119,7 +128,7 @@ void wl1271_spi_init(struct wl1271 *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1271_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -151,7 +160,7 @@ static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 			t[0].rx_buf = buf + (len - num_busy_bytes);
 			t[0].len = num_busy_bytes;
 			spi_message_add_tail(&t[0], &m);
-			spi_sync(wl->spi, &m);
+			spi_sync(wl_to_spi(wl), &m);
 			return;
 		}
 	}
@@ -171,7 +180,7 @@ static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 		t[0].rx_buf = busy_buf;
 		t[0].len = sizeof(u32);
 		spi_message_add_tail(&t[0], &m);
-		spi_sync(wl->spi, &m);
+		spi_sync(wl_to_spi(wl), &m);
 
 		if (*busy_buf & 0x1) {
 			spi_message_init(&m);
@@ -179,7 +188,7 @@ static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 			t[0].rx_buf = buf;
 			t[0].len = len;
 			spi_message_add_tail(&t[0], &m);
-			spi_sync(wl->spi, &m);
+			spi_sync(wl_to_spi(wl), &m);
 			return;
 		}
 	}
@@ -225,7 +234,7 @@ void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 	t[2].len = len;
 	spi_message_add_tail(&t[2], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	/* FIXME: Check busy words, removed due to SPI bug */
 	/* if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1))
@@ -263,7 +272,7 @@ void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 	t[1].len = len;
 	spi_message_add_tail(&t[1], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
@@ -306,6 +315,16 @@ static struct platform_device wl1271_device = {
 	},
 };
 
+static struct wl1271_if_operations spi_ops = {
+	.read		= wl1271_spi_raw_read,
+	.write		= wl1271_spi_raw_write,
+	.reset		= wl1271_spi_reset,
+	.init		= wl1271_spi_init,
+	.dev		= wl1271_spi_wl_to_dev,
+	.enable_irq	= wl1271_spi_enable_interrupts,
+	.disable_irq	= wl1271_spi_disable_interrupts
+};
+
 static int __devinit wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_platform_data *pdata;
@@ -326,7 +345,9 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl = hw->priv;
 
 	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
+	wl->if_priv = spi;
+
+	wl->if_ops = &spi_ops;
 
 	/* This is the only SPI value that we need to set here, the rest
 	 * comes from the board-peripherals file */
-- 
1.6.3.3

