Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24788 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab0BRL2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:31 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 22/22] wl1271: Added alloc and free hw functions
Date: Thu, 18 Feb 2010 13:25:57 +0200
Message-Id: <1266492357-462-23-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Moved allocation and freeing of context structure of the driver to
separate functions from probe and remove functions.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   80 +++++++++++++++++++----------
 1 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 66fb9a0..2a864b2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2025,23 +2025,17 @@ static struct platform_device wl1271_device = {
 };
 
 #define WL1271_DEFAULT_CHANNEL 0
-static int __devinit wl1271_probe(struct spi_device *spi)
+
+static struct ieee80211_hw *wl1271_alloc_hw(void)
 {
-	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
-	int ret, i;
-
-	pdata = spi->dev.platform_data;
-	if (!pdata) {
-		wl1271_error("no platform data");
-		return -ENODEV;
-	}
+	int i;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
 		wl1271_error("could not alloc ieee80211_hw");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	wl = hw->priv;
@@ -2050,8 +2044,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	INIT_LIST_HEAD(&wl->list);
 
 	wl->hw = hw;
-	dev_set_drvdata(&spi->dev, wl);
-	wl->spi = spi;
 
 	skb_queue_head_init(&wl->tx_queue);
 
@@ -2078,6 +2070,54 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->state = WL1271_STATE_OFF;
 	mutex_init(&wl->mutex);
 
+	/* Apply default driver configuration. */
+	wl1271_conf_init(wl);
+
+	return hw;
+}
+
+int wl1271_free_hw(struct wl1271 *wl)
+{
+	ieee80211_unregister_hw(wl->hw);
+
+	wl1271_debugfs_exit(wl);
+
+	kfree(wl->target_mem_map);
+	vfree(wl->fw);
+	wl->fw = NULL;
+	kfree(wl->nvs);
+	wl->nvs = NULL;
+
+	kfree(wl->fw_status);
+	kfree(wl->tx_res_if);
+
+	ieee80211_free_hw(wl->hw);
+
+	return 0;
+}
+
+static int __devinit wl1271_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl1271_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = wl1271_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+
 	/* This is the only SPI value that we need to set here, the rest
 	 * comes from the board-peripherals file */
 	spi->bits_per_word = 32;
@@ -2119,9 +2159,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	}
 	dev_set_drvdata(&wl1271_device.dev, wl);
 
-	/* Apply default driver configuration. */
-	wl1271_conf_init(wl);
-
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_platform;
@@ -2152,21 +2189,10 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 {
 	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
 
-	ieee80211_unregister_hw(wl->hw);
-
-	wl1271_debugfs_exit(wl);
 	platform_device_unregister(&wl1271_device);
 	free_irq(wl->irq, wl);
-	kfree(wl->target_mem_map);
-	vfree(wl->fw);
-	wl->fw = NULL;
-	kfree(wl->nvs);
-	wl->nvs = NULL;
 
-	kfree(wl->fw_status);
-	kfree(wl->tx_res_if);
-
-	ieee80211_free_hw(wl->hw);
+	wl1271_free_hw(wl);
 
 	return 0;
 }
-- 
1.6.3.3

