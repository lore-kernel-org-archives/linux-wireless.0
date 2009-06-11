Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1646 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761479AbZFKCDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:46 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 6/7] wl12xx: split spi interface into separate module
Date: Wed, 10 Jun 2009 22:02:59 -0400
Message-Id: <1244685780-28930-7-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This creates a module called wl12xx_spi.ko which contains just the
SPI-specific code.  The core remains in the module wl12xx.ko.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/Kconfig  |   13 ++++++++++++-
 drivers/net/wireless/wl12xx/Makefile |    6 +++++-
 drivers/net/wireless/wl12xx/main.c   |    9 +++++++++
 drivers/net/wireless/wl12xx/spi.c    |   15 ++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 5 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index a82c4cd..9575d16 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,6 +1,6 @@
 config WL12XX
 	tristate "TI wl1251/wl1271 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && GENERIC_HARDIRQS && EXPERIMENTAL
 	select FW_LOADER
 	select CRC7
 	---help---
@@ -9,3 +9,14 @@ config WL12XX
 
 	  If you choose to build a module, it'll be called wl12xx. Say N if
 	  unsure.
+
+config WL12XX_SPI
+	tristate "TI wl1251/wl1271 SPI support"
+	depends on WL12XX && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1251/wl1271 chipsets.  Select this if your platform is using
+	  the SPI bus.
+
+	  If you choose to build a module, it'll be called wl12xx_spi. Say N if
+	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index c1281fc..ffd5664 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,8 @@
-wl12xx-objs		= main.o spi.o event.o tx.o rx.o \
+wl12xx-objs		= main.o event.o tx.o rx.o \
 			  ps.o cmd.o acx.o boot.o init.o wl1251.o \
 			  debugfs.o io.o
+
+wl12xx_spi-objs		+= spi.o
+
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
+obj-$(CONFIG_WL12XX_SPI)	+= wl12xx_spi.o
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 06c1973..d5faaa1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -69,6 +69,7 @@ irqreturn_t wl12xx_irq(int irq, void *cookie)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(wl12xx_irq);
 
 static int wl12xx_fetch_firmware(struct wl12xx *wl)
 {
@@ -1179,6 +1180,7 @@ int wl12xx_init_ieee80211(struct wl12xx *wl)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl12xx_init_ieee80211);
 
 #define WL12XX_DEFAULT_CHANNEL 1
 struct ieee80211_hw *wl12xx_alloc_hw(void)
@@ -1245,6 +1247,7 @@ struct ieee80211_hw *wl12xx_alloc_hw(void)
 
 	return hw;
 }
+EXPORT_SYMBOL_GPL(wl12xx_alloc_hw);
 
 int wl12xx_free_hw(struct wl12xx *wl)
 {
@@ -1263,3 +1266,9 @@ int wl12xx_free_hw(struct wl12xx *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl12xx_free_hw);
+
+MODULE_DESCRIPTION("TI 12xx Wireles LAN Driver Core");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 852c990..6b453e2 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -32,6 +32,11 @@
 #include "spi.h"
 #include "ps.h"
 
+static struct spi_device *wl_to_spi(struct wl12xx *wl)
+{
+	return wl->if_priv;
+}
+
 static void wl12xx_spi_reset(struct wl12xx *wl)
 {
 	u8 *cmd;
@@ -53,7 +58,7 @@ static void wl12xx_spi_reset(struct wl12xx *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -107,7 +112,7 @@ static void wl12xx_spi_wake(struct wl12xx *wl)
 	t.len = WSPI_INIT_CMD_LEN;
 	spi_message_add_tail(&t, &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
@@ -147,7 +152,7 @@ static void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 	t[2].len = len;
 	spi_message_add_tail(&t[2], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	/* FIXME: check busy words */
 
@@ -178,7 +183,7 @@ static void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 	t[1].len = len;
 	spi_message_add_tail(&t[1], &m);
 
-	spi_sync(wl->spi, &m);
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", &cmd, sizeof(cmd));
 	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
@@ -211,7 +216,7 @@ static int __devinit wl12xx_spi_probe(struct spi_device *spi)
 
 	SET_IEEE80211_DEV(hw, &spi->dev);
 	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
+	wl->if_priv = spi;
 	wl->if_ops = &wl12xx_spi_ops;
 
 	/* This is the only SPI value that we need to set here, the rest
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 46d3bc1..d8bc4c6 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -286,7 +286,7 @@ struct wl12xx {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
-	struct spi_device *spi;
+	void *if_priv;
 	const struct wl12xx_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
-- 
1.6.0.6


