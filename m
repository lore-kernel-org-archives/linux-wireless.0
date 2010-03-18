Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33116 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:33 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 21/21] wl1271: Changed platform_device to be dynamically allocated
Date: Thu, 18 Mar 2010 12:26:46 +0200
Message-Id: <1268908006-16992-22-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Changed platform_device to be allocated dynamically from the
wl1271_alloc_hw function. Also cleaned up error handling in the
wl1271_alloc_hw function and module probe functions.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_io.h   |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   42 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    3 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    3 +-
 5 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index a0262b7..8f11506 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -353,6 +353,7 @@ struct wl1271_if_operations {
 };
 
 struct wl1271 {
+	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 3ff88d9..d8837ef 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -161,6 +161,7 @@ int wl1271_set_partition(struct wl1271 *wl,
 /* Functions from wl1271_main.c */
 
 int wl1271_register_hw(struct wl1271 *wl);
+void wl1271_unregister_hw(struct wl1271 *wl);
 int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0bebc45..3daba6c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2008,6 +2008,14 @@ int wl1271_register_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1271_register_hw);
 
+void wl1271_unregister_hw(struct wl1271 *wl)
+{
+	ieee80211_unregister_hw(wl->hw);
+	wl->mac80211_registered = false;
+
+}
+EXPORT_SYMBOL_GPL(wl1271_unregister_hw);
+
 int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	/* The tx descriptor buffer and the TKIP space. */
@@ -2046,6 +2054,7 @@ EXPORT_SYMBOL_GPL(wl1271_init_ieee80211);
 struct ieee80211_hw *wl1271_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
+	struct platform_device *plat_dev = NULL;
 	struct wl1271 *wl;
 	int i, ret;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
@@ -2054,15 +2063,25 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	if (!hw) {
 		wl1271_error("could not alloc ieee80211_hw");
 		ret = -ENOMEM;
-		goto err;
+		goto err_hw_alloc;
+	}
+
+	plat_dev = kmalloc(sizeof(wl1271_device), GFP_KERNEL);
+	if (!plat_dev) {
+		wl1271_error("could not allocate platform_device");
+		ret = -ENOMEM;
+		goto err_plat_alloc;
 	}
 
+	memcpy(plat_dev, &wl1271_device, sizeof(wl1271_device));
+
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
 	INIT_LIST_HEAD(&wl->list);
 
 	wl->hw = hw;
+	wl->plat_dev = plat_dev;
 
 	skb_queue_head_init(&wl->tx_queue);
 
@@ -2103,15 +2122,15 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl1271_debugfs_init(wl);
 
 	/* Register platform device */
-	ret = platform_device_register(&wl1271_device);
+	ret = platform_device_register(wl->plat_dev);
 	if (ret) {
 		wl1271_error("couldn't register platform device");
 		goto err_hw;
 	}
-	dev_set_drvdata(&wl1271_device.dev, wl);
+	dev_set_drvdata(&wl->plat_dev->dev, wl);
 
 	/* Create sysfs file to control bt coex state */
-	ret = device_create_file(&wl1271_device.dev, &dev_attr_bt_coex_state);
+	ret = device_create_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
 	if (ret < 0) {
 		wl1271_error("failed to create sysfs file bt_coex_state");
 		goto err_platform;
@@ -2120,20 +2139,25 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	return hw;
 
 err_platform:
-	platform_device_unregister(&wl1271_device);
+	platform_device_unregister(wl->plat_dev);
 
 err_hw:
-	ieee80211_unregister_hw(wl->hw);
+	wl1271_debugfs_exit(wl);
+	kfree(plat_dev);
+
+err_plat_alloc:
+	ieee80211_free_hw(hw);
+
+err_hw_alloc:
 
-err:
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
 int wl1271_free_hw(struct wl1271 *wl)
 {
-	platform_device_unregister(&wl1271_device);
-	ieee80211_unregister_hw(wl->hw);
+	platform_device_unregister(wl->plat_dev);
+	kfree(wl->plat_dev);
 
 	wl1271_debugfs_exit(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 99b5b3f..3c03de7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -239,7 +239,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 
  out_free:
-	ieee80211_free_hw(hw);
+	wl1271_free_hw(wl);
 
 	return ret;
 }
@@ -250,6 +250,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 
 	free_irq(wl->irq, wl);
 
+	wl1271_unregister_hw(wl);
 	wl1271_free_hw(wl);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 4c129c7..f44b05a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -422,7 +422,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	free_irq(wl->irq, wl);
 
  out_free:
-	ieee80211_free_hw(hw);
+	wl1271_free_hw(wl);
 
 	return ret;
 }
@@ -433,6 +433,7 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 
 	free_irq(wl->irq, wl);
 
+	wl1271_unregister_hw(wl);
 	wl1271_free_hw(wl);
 
 	return 0;
-- 
1.6.3.3

