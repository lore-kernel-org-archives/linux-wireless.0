Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1654 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761723AbZFKCDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 5/7] wl12xx: move module probe methods into spi.c
Date: Wed, 10 Jun 2009 22:02:58 -0400
Message-Id: <1244685780-28930-6-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change moves all of the spi specific code from main.c into
spi.c.  The module initialization code also moves, but common
code for initializing mac80211 etc. stays in main.c, as this will
eventually form a common library module also used by wl12xx_sdio.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/acx.c    |    1 -
 drivers/net/wireless/wl12xx/cmd.c    |    1 -
 drivers/net/wireless/wl12xx/main.c   |  138 +++++-----------------------------
 drivers/net/wireless/wl12xx/spi.c    |  124 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/tx.c     |    1 -
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++-
 6 files changed, 148 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 9e48de2..c55d6a6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 56bf6a6..0fe296d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/crc7.h>
-#include <linux/spi/spi.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index eb4b5da..06c1973 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -26,17 +26,15 @@
 #include <linux/firmware.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
-#include <linux/spi/spi.h>
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
-#include <linux/spi/wl12xx.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251.h"
 #include "io.h"
-#include "spi.h"
+#include "cmd.h"
 #include "event.h"
 #include "tx.h"
 #include "rx.h"
@@ -59,7 +57,7 @@ static void wl12xx_power_on(struct wl12xx *wl)
 	wl->set_power(true);
 }
 
-static irqreturn_t wl12xx_irq(int irq, void *cookie)
+irqreturn_t wl12xx_irq(int irq, void *cookie)
 {
 	struct wl12xx *wl;
 
@@ -1150,8 +1148,10 @@ static int wl12xx_register_hw(struct wl12xx *wl)
 	return 0;
 }
 
-static int wl12xx_init_ieee80211(struct wl12xx *wl)
+int wl12xx_init_ieee80211(struct wl12xx *wl)
 {
+	int ret;
+
 	/* The tx descriptor buffer and the TKIP space */
 	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
 		+ WL12XX_TKIP_IV_SPACE;
@@ -1167,41 +1167,37 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
 
-	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+	ret = wl12xx_register_hw(wl);
+	if (ret)
+		goto out;
 
-	return 0;
-}
+	wl12xx_debugfs_init(wl);
 
-extern struct wl12xx_if_operations wl12xx_spi_ops;
+	wl12xx_notice("initialized");
+
+	ret = 0;
+out:
+	return ret;
+}
 
 #define WL12XX_DEFAULT_CHANNEL 1
-static int __devinit wl12xx_probe(struct spi_device *spi)
+struct ieee80211_hw *wl12xx_alloc_hw(void)
 {
-	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl12xx *wl;
-	int ret, i;
+	int i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl12xx_error("no platform data");
-		return -ENODEV;
-	}
-
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
 	if (!hw) {
 		wl12xx_error("could not alloc ieee80211_hw");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
 	wl->hw = hw;
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
-	wl->if_ops = &wl12xx_spi_ops;
 
 	wl->data_in_count = 0;
 
@@ -1247,65 +1243,11 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
 	wl->tx_mgmt_frm_mod = DEFAULT_HW_GEN_MODULATION_TYPE;
 
-	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
-	spi->bits_per_word = 32;
-
-	ret = spi_setup(spi);
-	if (ret < 0) {
-		wl12xx_error("spi_setup failed");
-		goto out_free;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl12xx_error("set power function missing in platform data");
-		return -ENODEV;
-	}
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl12xx_error("irq missing in platform data");
-		return -ENODEV;
-	}
-
-	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl12xx_error("request_irq() failed: %d", ret);
-		goto out_free;
-	}
-
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(wl->irq);
-
-	ret = wl12xx_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl12xx_register_hw(wl);
-	if (ret)
-		goto out_irq;
-
-	wl12xx_debugfs_init(wl);
-
-	wl12xx_notice("initialized");
-
-	return 0;
-
- out_irq:
-	free_irq(wl->irq, wl);
-
- out_free:
-	ieee80211_free_hw(hw);
-
-	return ret;
+	return hw;
 }
 
-static int __devexit wl12xx_remove(struct spi_device *spi)
+int wl12xx_free_hw(struct wl12xx *wl)
 {
-	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
-
 	ieee80211_unregister_hw(wl->hw);
 
 	wl12xx_debugfs_exit(wl);
@@ -1321,43 +1263,3 @@ static int __devexit wl12xx_remove(struct spi_device *spi)
 
 	return 0;
 }
-
-
-static struct spi_driver wl12xx_spi_driver = {
-	.driver = {
-		.name		= "wl12xx",
-		.bus		= &spi_bus_type,
-		.owner		= THIS_MODULE,
-	},
-
-	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wl12xx_remove),
-};
-
-static int __init wl12xx_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl12xx_spi_driver);
-	if (ret < 0) {
-		wl12xx_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void __exit wl12xx_exit(void)
-{
-	spi_unregister_driver(&wl12xx_spi_driver);
-
-	wl12xx_notice("unloaded");
-}
-
-module_init(wl12xx_init);
-module_exit(wl12xx_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
-		"Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 658464e..852c990 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/wl12xx.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
@@ -57,7 +58,7 @@ static void wl12xx_spi_reset(struct wl12xx *wl)
 	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-static void wl12xx_spi_init(struct wl12xx *wl)
+static void wl12xx_spi_wake(struct wl12xx *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -114,7 +115,7 @@ static void wl12xx_spi_init(struct wl12xx *wl)
 static void wl12xx_spi_reset_wake(struct wl12xx *wl)
 {
 	wl12xx_spi_reset(wl);
-	wl12xx_spi_init(wl);
+	wl12xx_spi_wake(wl);
 }
 
 static void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
@@ -188,3 +189,122 @@ const struct wl12xx_if_operations wl12xx_spi_ops = {
 	.write = wl12xx_spi_write,
 	.reset = wl12xx_spi_reset_wake,
 };
+
+static int __devinit wl12xx_spi_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl12xx *wl;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl12xx_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = wl12xx_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	SET_IEEE80211_DEV(hw, &spi->dev);
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+	wl->if_ops = &wl12xx_spi_ops;
+
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl12xx_error("spi_setup failed");
+		goto out_free;
+	}
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl12xx_error("set power function missing in platform data");
+		return -ENODEV;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl12xx_error("irq missing in platform data");
+		return -ENODEV;
+	}
+
+	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl12xx_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = wl12xx_init_ieee80211(wl);
+	if (ret)
+		goto out_irq;
+
+	return 0;
+
+ out_irq:
+	free_irq(wl->irq, wl);
+
+ out_free:
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+
+static int __devexit wl12xx_spi_remove(struct spi_device *spi)
+{
+	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
+
+	wl12xx_free_hw(wl);
+
+	return 0;
+}
+
+static struct spi_driver wl12xx_spi_driver = {
+	.driver = {
+		.name		= "wl12xx",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl12xx_spi_probe,
+	.remove		= __devexit_p(wl12xx_spi_remove),
+};
+
+static int __init wl12xx_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&wl12xx_spi_driver);
+	if (ret < 0) {
+		wl12xx_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl12xx_spi_exit(void)
+{
+	spi_unregister_driver(&wl12xx_spi_driver);
+
+	wl12xx_notice("unloaded");
+}
+
+module_init(wl12xx_spi_init);
+module_exit(wl12xx_spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 2079aba..b327a93 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -27,7 +27,6 @@
 
 #include "wl12xx.h"
 #include "reg.h"
-#include "spi.h"
 #include "tx.h"
 #include "ps.h"
 #include "io.h"
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index bfabf8f..46d3bc1 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -287,7 +287,7 @@ struct wl12xx {
 	bool mac80211_registered;
 
 	struct spi_device *spi;
-	struct wl12xx_if_operations *if_ops;
+	const struct wl12xx_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
 	int irq;
@@ -394,6 +394,11 @@ struct wl12xx {
 int wl12xx_plt_start(struct wl12xx *wl);
 int wl12xx_plt_stop(struct wl12xx *wl);
 
+irqreturn_t wl12xx_irq(int irq, void *cookie);
+struct ieee80211_hw *wl12xx_alloc_hw(void);
+int wl12xx_free_hw(struct wl12xx *wl);
+int wl12xx_init_ieee80211(struct wl12xx *wl);
+
 #define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
 #define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
-- 
1.6.0.6


