Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47753 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab2I0Kiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:46 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 29/31] wlcore: Load the NVS file asynchronously
Date: Thu, 27 Sep 2012 13:38:07 +0300
Message-Id: <1348742289-6587-30-git-send-email-luca@coelho.fi> (sfid-20120927_123920_966606_85F96C5D)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The NVS file is loaded by the device's probe callback with the help of
request_firmware(). Since request_firmware() relies on udevd, the
modules cannot be loaded before hotplug events are handled.

Fix this by loading the NVS file asynchronously and continue
initialization only after the firmware request is over.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c   |   88 ++++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 2 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7db6384..6ada018 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -744,32 +744,6 @@ out:
 	return ret;
 }
 
-static void wl1271_fetch_nvs(struct wl1271 *wl)
-{
-	const struct firmware *fw;
-	int ret;
-
-	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl->dev);
-
-	if (ret < 0) {
-		wl1271_debug(DEBUG_BOOT, "could not get nvs file %s: %d",
-			     WL12XX_NVS_NAME, ret);
-		return;
-	}
-
-	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
-
-	if (!wl->nvs) {
-		wl1271_error("could not allocate memory for the nvs file");
-		goto out;
-	}
-
-	wl->nvs_len = fw->size;
-
-out:
-	release_firmware(fw);
-}
-
 void wl12xx_queue_recovery_work(struct wl1271 *wl)
 {
 	WARN_ON(!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
@@ -5153,8 +5127,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;
 
-	wl1271_fetch_nvs(wl);
-	if (wl->nvs != NULL) {
+	if (wl->nvs_len >= 12) {
 		/* NOTE: The wl->nvs->nvs element must be first, in
 		 * order to simplify the casting, we assume it is at
 		 * the beginning of the wl->nvs structure.
@@ -5419,6 +5392,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
 	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	mutex_init(&wl->mutex);
 	mutex_init(&wl->flush_mutex);
+	init_completion(&wl->nvs_loading_complete);
 
 	order = get_order(aggr_buf_size);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
@@ -5539,24 +5513,31 @@ static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
 	return IRQ_WAKE_THREAD;
 }
 
-int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
+static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
+	struct wl1271 *wl = context;
+	struct platform_device *pdev = wl->pdev;
 	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
 	unsigned long irqflags;
 	int ret;
 
-	if (!wl->ops || !wl->ptable) {
-		ret = -EINVAL;
-		goto out;
+	if (fw) {
+		wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
+		if (!wl->nvs) {
+			wl1271_error("Could not allocate nvs data");
+			goto out;
+		}
+		wl->nvs_len = fw->size;
+	} else {
+		wl1271_debug(DEBUG_BOOT, "Could not get nvs file %s",
+			     WL12XX_NVS_NAME);
+		wl->nvs = NULL;
+		wl->nvs_len = 0;
 	}
 
-	wl->dev = &pdev->dev;
-	wl->pdev = pdev;
-	platform_set_drvdata(pdev, wl);
-
 	ret = wl->ops->setup(wl);
 	if (ret < 0)
-		goto out;
+		goto out_free_nvs;
 
 	BUG_ON(wl->num_tx_desc > WLCORE_MAX_TX_DESCRIPTORS);
 
@@ -5578,7 +5559,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 				   pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-		goto out;
+		goto out_free_nvs;
 	}
 
 #ifdef CONFIG_PM
@@ -5637,6 +5618,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 		goto out_hw_pg_ver;
 	}
 
+	wl->initialized = true;
 	goto out;
 
 out_hw_pg_ver:
@@ -5651,7 +5633,33 @@ out_unreg:
 out_irq:
 	free_irq(wl->irq, wl);
 
+out_free_nvs:
+	kfree(wl->nvs);
+
 out:
+	release_firmware(fw);
+	complete_all(&wl->nvs_loading_complete);
+}
+
+int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
+{
+	int ret;
+
+	if (!wl->ops || !wl->ptable)
+		return -EINVAL;
+
+	wl->dev = &pdev->dev;
+	wl->pdev = pdev;
+	platform_set_drvdata(pdev, wl);
+
+	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+				      WL12XX_NVS_NAME, &pdev->dev, GFP_KERNEL,
+				      wl, wlcore_nvs_cb);
+	if (ret < 0) {
+		wl1271_error("request_firmware_nowait failed: %d", ret);
+		complete_all(&wl->nvs_loading_complete);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wlcore_probe);
@@ -5660,6 +5668,10 @@ int __devexit wlcore_remove(struct platform_device *pdev)
 {
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 
+	wait_for_completion(&wl->nvs_loading_complete);
+	if (!wl->initialized)
+		return 0;
+
 	if (wl->irq_wake_enabled) {
 		device_init_wakeup(wl->dev, 0);
 		disable_irq_wake(wl->irq);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 6a04556..68584aa 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -146,6 +146,7 @@ struct wl1271_stats {
 };
 
 struct wl1271 {
+	bool initialized;
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
@@ -409,6 +410,8 @@ struct wl1271 {
 
 	/* the minimum FW version required for the driver to work */
 	unsigned int min_fw_ver[NUM_FW_VER];
+
+	struct completion nvs_loading_complete;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.10.4

