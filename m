Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53456 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbZHGKeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:02 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 07/23] wl1251: split spi interface into separate module
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:33:34 +0300
Message-ID: <20090807103334.31717.89927.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

This creates a module called wl1251_spi.ko which contains just the
SPI-specific code.  The core remains in the module wl1251.ko.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/Kconfig       |   17 ++++++++++++++---
 drivers/net/wireless/wl12xx/Makefile      |    4 +++-
 drivers/net/wireless/wl12xx/wl1251.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1251_main.c |    9 +++++++++
 drivers/net/wireless/wl12xx/wl1251_spi.c  |   17 +++++++++++------
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 82a0f97..e47d076 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -7,12 +7,23 @@ menuconfig WL12XX
 
 config WL1251
 	tristate "TI wl1251 support"
-	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
+	depends on WL12XX && GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
 	  This module adds support for wireless adapters based on
 	  TI wl1251 chipset.
 
-	  If you choose to build a module, it'll be called wl1251. Say N if
-	  unsure.
+	  If you choose to build a module, it'll be called wl1251. Say
+	  N if unsure.
+
+config WL1251_SPI
+	tristate "TI wl1251 SPI support"
+	depends on WL1251 && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1251 chipset.  Select this if your platform is using
+	  the SPI bus.
+
+	  If you choose to build a module, it'll be called wl1251_spi.
+	  Say N if unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index a978567..ebf623a 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,5 +1,7 @@
-wl1251-objs		= wl1251_main.o wl1251_spi.o wl1251_event.o \
+wl1251-objs		= wl1251_main.o wl1251_event.o \
 			  wl1251_tx.o wl1251_rx.o wl1251_ps.o wl1251_cmd.o \
 			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
 			  wl1251_ops.o wl1251_debugfs.o wl1251_io.o
+
 obj-$(CONFIG_WL1251)	+= wl1251.o
+obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index df4c06d..ebe2c70 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -291,7 +291,7 @@ struct wl1251 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
-	struct spi_device *spi;
+	void *if_priv;
 	const struct wl1251_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 74544e1..abe157a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -69,6 +69,7 @@ irqreturn_t wl1251_irq(int irq, void *cookie)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(wl1251_irq);
 
 static int wl1251_fetch_firmware(struct wl1251 *wl)
 {
@@ -1198,6 +1199,7 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1251_init_ieee80211);
 
 #define WL1251_DEFAULT_CHANNEL 1
 struct ieee80211_hw *wl1251_alloc_hw(void)
@@ -1270,6 +1272,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 
 	return hw;
 }
+EXPORT_SYMBOL_GPL(wl1251_alloc_hw);
 
 int wl1251_free_hw(struct wl1251 *wl)
 {
@@ -1292,3 +1295,9 @@ int wl1251_free_hw(struct wl1251 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1251_free_hw);
+
+MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 13e7a72..5967317 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -31,6 +31,11 @@
 #include "reg.h"
 #include "wl1251_spi.h"
 
+static struct spi_device *wl_to_spi(struct wl1251 *wl)
+{
+	return wl->if_priv;
+}
+
 static void wl1251_spi_reset(struct wl1251 *wl)
 {
 	u8 *cmd;
@@ -52,7 +57,7 @@ static void wl1251_spi_reset(struct wl1251 *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1251_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -106,7 +111,7 @@ static void wl1251_spi_wake(struct wl1251 *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1251_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -149,7 +154,7 @@ static void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 	t[2].len = len;
 	spi_message_add_tail(&t[2], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	/* FIXME: check busy words */
 
@@ -182,13 +187,13 @@ static void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
 	t[1].len = len;
 	spi_message_add_tail(&t[1], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1251_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl1251_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
-const struct wl1251_if_operations wl1251_spi_ops = {
+static const struct wl1251_if_operations wl1251_spi_ops = {
 	.read = wl1251_spi_read,
 	.write = wl1251_spi_write,
 	.reset = wl1251_spi_reset_wake,
@@ -215,7 +220,7 @@ static int __devinit wl1251_spi_probe(struct spi_device *spi)
 
 	SET_IEEE80211_DEV(hw, &spi->dev);
 	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
+	wl->if_priv = spi;
 	wl->if_ops = &wl1251_spi_ops;
 
 	/* This is the only SPI value that we need to set here, the rest

