Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45412 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759167Ab1JFTLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:22 -0400
Received: by mail-bw0-f41.google.com with SMTP id zs2so4300845bkb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:21 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] wl12xx: move common init code from bus modules to main
Date: Thu,  6 Oct 2011 22:10:57 +0300
Message-Id: <1317928259-26437-7-git-send-email-coelho@ti.com> (sfid-20111006_211128_636604_FA1953DB)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

Move all common parts from sdio.c and spi.c to main.c, since they now
can be handled as part of the platform driver.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward-ported, cleaned-up and rephrased commit message]
[added a bunch of fixes and a new pdata element]
[moved some new code into main.c as well]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

A list of my changes, besides the ones mentioned above:

* added some missing #includes;
* added new code from sdio hardirq to main;
* assign some wl elements directly instead of copying from a local;
* added wl->if_ops assignment, which was missing;
* added a new pdata element to pass info whether power on during
  suspend is supported;
* removed one unused label in wl12xx_probe().

 drivers/net/wireless/wl12xx/io.c                   |   11 +-
 drivers/net/wireless/wl12xx/io.h                   |   14 +-
 drivers/net/wireless/wl12xx/main.c                 |  110 ++++++++++++-
 drivers/net/wireless/wl12xx/sdio.c                 |  174 ++++----------------
 drivers/net/wireless/wl12xx/spi.c                  |  161 +++----------------
 drivers/net/wireless/wl12xx/wl12xx.h               |   17 +-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |    4 +-
 include/linux/wl12xx.h                             |    5 +-
 8 files changed, 184 insertions(+), 312 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index c2da66f..1a7df8a 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
+#include <linux/interrupt.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
@@ -46,7 +47,7 @@
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
 	if (wl->if_ops->set_block_size) {
-		wl->if_ops->set_block_size(wl, WL12XX_BUS_BLOCK_SIZE);
+		wl->if_ops->set_block_size(wl->dev, WL12XX_BUS_BLOCK_SIZE);
 		return true;
 	}
 
@@ -55,12 +56,12 @@ bool wl1271_set_block_size(struct wl1271 *wl)
 
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
-	wl->if_ops->disable_irq(wl);
+	disable_irq(wl->irq);
 }
 
 void wl1271_enable_interrupts(struct wl1271 *wl)
 {
-	wl->if_ops->enable_irq(wl);
+	enable_irq(wl->irq);
 }
 
 /* Set the SPI partitions to access the chip addresses
@@ -128,13 +129,13 @@ EXPORT_SYMBOL_GPL(wl1271_set_partition);
 void wl1271_io_reset(struct wl1271 *wl)
 {
 	if (wl->if_ops->reset)
-		wl->if_ops->reset(wl);
+		wl->if_ops->reset(wl->dev);
 }
 
 void wl1271_io_init(struct wl1271 *wl)
 {
 	if (wl->if_ops->init)
-		wl->if_ops->init(wl);
+		wl->if_ops->init(wl->dev);
 }
 
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index e839341..e82dad1 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -51,23 +51,17 @@ void wl1271_enable_interrupts(struct wl1271 *wl);
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
 
-static inline struct device *wl1271_wl_to_dev(struct wl1271 *wl)
-{
-	return wl->if_ops->dev(wl);
-}
-
-
 /* Raw target IO, address is not translated */
 static inline void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 				    size_t len, bool fixed)
 {
-	wl->if_ops->write(wl, addr, buf, len, fixed);
+	wl->if_ops->write(wl->dev, addr, buf, len, fixed);
 }
 
 static inline void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
 				   size_t len, bool fixed)
 {
-	wl->if_ops->read(wl, addr, buf, len, fixed);
+	wl->if_ops->read(wl->dev, addr, buf, len, fixed);
 }
 
 static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
@@ -155,13 +149,13 @@ static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 
 static inline void wl1271_power_off(struct wl1271 *wl)
 {
-	wl->if_ops->power(wl, false);
+	wl->if_ops->power(wl->dev, false);
 	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 }
 
 static inline int wl1271_power_on(struct wl1271 *wl)
 {
-	int ret = wl->if_ops->power(wl, true);
+	int ret = wl->if_ops->power(wl->dev, true);
 	if (ret == 0)
 		set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 84904bd..e84948d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/wl12xx.h>
 #include <linux/sched.h>
+#include <linux/interrupt.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
@@ -1058,7 +1059,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_BOOT, "booting firmware %s", fw_name);
 
-	ret = request_firmware(&fw, fw_name, wl1271_wl_to_dev(wl));
+	ret = request_firmware(&fw, fw_name, wl->dev);
 
 	if (ret < 0) {
 		wl1271_error("could not get firmware: %d", ret);
@@ -1096,7 +1097,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl1271_wl_to_dev(wl));
+	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl->dev);
 
 	if (ret < 0) {
 		wl1271_error("could not get nvs file: %d", ret);
@@ -4807,7 +4808,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
 
-	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
+	SET_IEEE80211_DEV(wl->hw, wl->dev);
 
 	wl->hw->sta_data_size = sizeof(struct wl1271_station);
 	wl->hw->vif_data_size = sizeof(struct wl12xx_vif);
@@ -5041,13 +5042,116 @@ int wl1271_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1271_free_hw);
 
+static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
+{
+	struct wl1271 *wl = cookie;
+	unsigned long flags;
+
+	wl1271_debug(DEBUG_IRQ, "IRQ");
+
+	/* complete the ELP completion */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
+	if (wl->elp_compl) {
+		complete(wl->elp_compl);
+		wl->elp_compl = NULL;
+	}
+
+	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
+		/* don't enqueue a work right now. mark it as pending */
+		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
+		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
+		disable_irq_nosync(wl->irq);
+		pm_wakeup_event(wl->dev, 0);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	return IRQ_WAKE_THREAD;
+}
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
+	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	unsigned long irqflags;
+	int ret = -ENODEV;
+
+	hw = wl1271_alloc_hw();
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		ret = PTR_ERR(hw);
+		goto out;
+	}
+
+	wl = hw->priv;
+	wl->irq = platform_get_irq(pdev, 0);
+	wl->ref_clock = pdata->board_ref_clock;
+	wl->tcxo_clock = pdata->board_tcxo_clock;
+	wl->platform_quirks = pdata->platform_quirks;
+	wl->set_power = pdata->set_power;
+	wl->dev = &pdev->dev;
+	wl->if_ops = pdata->ops;
+
+	platform_set_drvdata(pdev, wl);
+
+	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+		irqflags = IRQF_TRIGGER_RISING;
+	else
+		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+
+	ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wl1271_irq,
+				   irqflags,
+				   pdev->name, wl);
+	if (ret < 0) {
+		wl1271_error("request_irq() failed: %d", ret);
+		goto out_free_hw;
+	}
+
+	ret = enable_irq_wake(wl->irq);
+	if (!ret) {
+		wl->irq_wake_enabled = true;
+		device_init_wakeup(wl->dev, 1);
+		if (pdata->pwr_in_suspend)
+			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+
+	}
+	disable_irq(wl->irq);
+
+	ret = wl1271_init_ieee80211(wl);
+	if (ret)
+		goto out_irq;
+
+	ret = wl1271_register_hw(wl);
+	if (ret)
+		goto out_irq;
+
 	return 0;
+
+out_irq:
+	free_irq(wl->irq, wl);
+
+out_free_hw:
+	wl1271_free_hw(wl);
+
+out:
+	return ret;
 }
 
 static int __devexit wl12xx_remove(struct platform_device *pdev)
 {
+	struct wl1271 *wl = platform_get_drvdata(pdev);
+
+	if (wl->irq_wake_enabled) {
+		device_init_wakeup(wl->dev, 0);
+		disable_irq_wake(wl->irq);
+	}
+	wl1271_unregister_hw(wl);
+	free_irq(wl->irq, wl);
+	wl1271_free_hw(wl);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 500704f..0374bcd 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -47,7 +47,6 @@
 
 struct wl12xx_sdio_glue {
 	struct device *dev;
-	struct wl1271 *wl;
 	struct platform_device *core;
 };
 
@@ -57,67 +56,22 @@ static const struct sdio_device_id wl1271_devices[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(sdio, wl1271_devices);
 
-static void wl1271_sdio_set_block_size(struct wl1271 *wl, unsigned int blksz)
+static void wl1271_sdio_set_block_size(struct device *child,
+				       unsigned int blksz)
 {
-	sdio_claim_host(wl->if_priv);
-	sdio_set_block_size(wl->if_priv, blksz);
-	sdio_release_host(wl->if_priv);
-}
-
-static inline struct wl12xx_sdio_glue *wl_to_glue(struct wl1271 *wl)
-{
-	return wl->if_priv;
-}
-
-static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
-{
-	return wl_to_glue(wl)->dev;
-}
-
-static irqreturn_t wl1271_hardirq(int irq, void *cookie)
-{
-	struct wl1271 *wl = cookie;
-	unsigned long flags;
-
-	wl1271_debug(DEBUG_IRQ, "IRQ");
-
-	/* complete the ELP completion */
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
-	if (wl->elp_compl) {
-		complete(wl->elp_compl);
-		wl->elp_compl = NULL;
-	}
-
-	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
-		/* don't enqueue a work right now. mark it as pending */
-		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
-		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
-		disable_irq_nosync(wl->irq);
-		pm_wakeup_event(wl1271_sdio_wl_to_dev(wl), 0);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-		return IRQ_HANDLED;
-	}
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	return IRQ_WAKE_THREAD;
-}
-
-static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
-{
-	disable_irq(wl->irq);
-}
+	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
-static void wl1271_sdio_enable_interrupts(struct wl1271 *wl)
-{
-	enable_irq(wl->irq);
+	sdio_claim_host(func);
+	sdio_set_block_size(func, blksz);
+	sdio_release_host(func);
 }
 
-static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
+static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 				 size_t len, bool fixed)
 {
 	int ret;
-	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
@@ -139,11 +93,11 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		wl1271_error("sdio read failed (%d)", ret);
 }
 
-static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
+static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 				  size_t len, bool fixed)
 {
 	int ret;
-	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
@@ -165,10 +119,9 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 		wl1271_error("sdio write failed (%d)", ret);
 }
 
-static int wl1271_sdio_power_on(struct wl1271 *wl)
+static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 {
 	int ret;
-	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	/* If enabled, tell runtime PM not to power off the card */
@@ -190,10 +143,9 @@ out:
 	return ret;
 }
 
-static int wl1271_sdio_power_off(struct wl1271 *wl)
+static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 {
 	int ret;
-	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	sdio_disable_func(func);
@@ -211,33 +163,29 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 	return ret;
 }
 
-static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
+static int wl12xx_sdio_set_power(struct device *child, bool enable)
 {
+	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
+
 	if (enable)
-		return wl1271_sdio_power_on(wl);
+		return wl12xx_sdio_power_on(glue);
 	else
-		return wl1271_sdio_power_off(wl);
+		return wl12xx_sdio_power_off(glue);
 }
 
 static struct wl1271_if_operations sdio_ops = {
-	.read		= wl1271_sdio_raw_read,
-	.write		= wl1271_sdio_raw_write,
-	.power		= wl1271_sdio_set_power,
-	.dev		= wl1271_sdio_wl_to_dev,
-	.enable_irq	= wl1271_sdio_enable_interrupts,
-	.disable_irq	= wl1271_sdio_disable_interrupts,
+	.read		= wl12xx_sdio_raw_read,
+	.write		= wl12xx_sdio_raw_write,
+	.power		= wl12xx_sdio_set_power,
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
 static int __devinit wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
-	struct ieee80211_hw *hw;
-	const struct wl12xx_platform_data *wlan_data;
-	struct wl1271 *wl;
+	struct wl12xx_platform_data *wlan_data;
 	struct wl12xx_sdio_glue *glue;
 	struct resource res[1];
-	unsigned long irqflags;
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
 
@@ -251,20 +199,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 		goto out;
 	}
 
-	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw)) {
-		wl1271_error("can't allocate hw");
-		ret = PTR_ERR(hw);
-		goto out_free_glue;
-	}
-
-	wl = hw->priv;
-
 	glue->dev = &func->dev;
-	glue->wl = wl;
-
-	wl->if_priv = glue;
-	wl->if_ops = &sdio_ops;
 
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
@@ -276,48 +211,17 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	if (IS_ERR(wlan_data)) {
 		ret = PTR_ERR(wlan_data);
 		wl1271_error("missing wlan platform data: %d", ret);
-		goto out_free_hw;
-	}
-
-	wl->irq = wlan_data->irq;
-	wl->ref_clock = wlan_data->board_ref_clock;
-	wl->tcxo_clock = wlan_data->board_tcxo_clock;
-	wl->platform_quirks = wlan_data->platform_quirks;
-
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
-		irqflags = IRQF_TRIGGER_RISING;
-	else
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
-
-	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   irqflags,
-				   DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free_hw;
+		goto out_free_glue;
 	}
 
-	ret = enable_irq_wake(wl->irq);
-	if (!ret) {
-		wl->irq_wake_enabled = true;
-		device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 1);
+	/* if sdio can keep power while host is suspended, enable wow */
+	mmcflags = sdio_get_host_pm_caps(func);
+	wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
 
-		/* if sdio can keep power while host is suspended, enable wow */
-		mmcflags = sdio_get_host_pm_caps(func);
-		wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
+	if (mmcflags & MMC_PM_KEEP_POWER)
+		wlan_data->pwr_in_suspend = true;
 
-		if (mmcflags & MMC_PM_KEEP_POWER)
-			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
-	}
-	disable_irq(wl->irq);
-
-	ret = wl1271_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl1271_register_hw(wl);
-	if (ret)
-		goto out_irq;
+	wlan_data->ops = &sdio_ops;
 
 	sdio_set_drvdata(func, glue);
 
@@ -328,7 +232,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		wl1271_error("can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_unreg_hw;
+		goto out_free_glue;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -362,17 +266,9 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
-out_unreg_hw:
-	wl1271_unregister_hw(wl);
-
-out_irq:
-	free_irq(wl->irq, wl);
-
-out_free_hw:
-	wl1271_free_hw(wl);
-
 out_free_glue:
 	kfree(glue);
+
 out:
 	return ret;
 }
@@ -380,18 +276,10 @@ out:
 static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue= sdio_get_drvdata(func);
-	struct wl1271 *wl = glue->wl;
 
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
-	wl1271_unregister_hw(wl);
-	if (wl->irq_wake_enabled) {
-		device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 0);
-		disable_irq_wake(wl->irq);
-	}
-	free_irq(wl->irq, wl);
-	wl1271_free_hw(wl);
 	platform_device_del(glue->core);
 	platform_device_put(glue->core);
 	kfree(glue);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index e075d69..54ee9c1 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -72,33 +72,12 @@
 
 struct wl12xx_spi_glue {
 	struct device *dev;
-	struct wl1271 *wl;
 	struct platform_device *core;
 };
 
-static inline struct wl12xx_spi_glue *wl_to_glue(struct wl1271 *wl)
+static void wl12xx_spi_reset(struct device *child)
 {
-	return wl->if_priv;
-}
-
-static struct device *wl1271_spi_wl_to_dev(struct wl1271 *wl)
-{
-	return wl_to_glue(wl)->dev;
-}
-
-static void wl1271_spi_disable_interrupts(struct wl1271 *wl)
-{
-	disable_irq(wl->irq);
-}
-
-static void wl1271_spi_enable_interrupts(struct wl1271 *wl)
-{
-	enable_irq(wl->irq);
-}
-
-static void wl1271_spi_reset(struct wl1271 *wl)
-{
-	struct wl12xx_spi_glue *glue = wl_to_glue(wl);
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	u8 *cmd;
 	struct spi_transfer t;
 	struct spi_message m;
@@ -124,9 +103,9 @@ static void wl1271_spi_reset(struct wl1271 *wl)
 	kfree(cmd);
 }
 
-static void wl1271_spi_init(struct wl1271 *wl)
+static void wl12xx_spi_init(struct device *child)
 {
-	struct wl12xx_spi_glue *glue = wl_to_glue(wl);
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
 	struct spi_message m;
@@ -181,9 +160,10 @@ static void wl1271_spi_init(struct wl1271 *wl)
 
 #define WL1271_BUSY_WORD_TIMEOUT 1000
 
-static int wl1271_spi_read_busy(struct wl1271 *wl)
+static int wl12xx_spi_read_busy(struct device *child)
 {
-	struct wl12xx_spi_glue *glue = wl_to_glue(wl);
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
+	struct wl1271 *wl = dev_get_drvdata(child);
 	struct spi_transfer t[1];
 	struct spi_message m;
 	u32 *busy_buf;
@@ -215,10 +195,11 @@ static int wl1271_spi_read_busy(struct wl1271 *wl)
 	return -ETIMEDOUT;
 }
 
-static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
+static void wl12xx_spi_raw_read(struct device *child, int addr, void *buf,
 				size_t len, bool fixed)
 {
-	struct wl12xx_spi_glue *glue = wl_to_glue(wl);
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
+	struct wl1271 *wl = dev_get_drvdata(child);
 	struct spi_transfer t[2];
 	struct spi_message m;
 	u32 *busy_buf;
@@ -257,7 +238,7 @@ static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 		spi_sync(to_spi_device(glue->dev), &m);
 
 		if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1) &&
-		    wl1271_spi_read_busy(wl)) {
+		    wl12xx_spi_read_busy(child)) {
 			memset(buf, 0, chunk_len);
 			return;
 		}
@@ -282,10 +263,10 @@ static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 	}
 }
 
-static void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
-			  size_t len, bool fixed)
+static void wl12xx_spi_raw_write(struct device *child, int addr, void *buf,
+				 size_t len, bool fixed)
 {
-	struct wl12xx_spi_glue *glue = wl_to_glue(wl);
+	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
 	struct spi_transfer t[2 * WSPI_MAX_NUM_OF_CHUNKS];
 	struct spi_message m;
 	u32 commands[WSPI_MAX_NUM_OF_CHUNKS];
@@ -333,42 +314,11 @@ static void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 	spi_sync(to_spi_device(glue->dev), &m);
 }
 
-static irqreturn_t wl1271_hardirq(int irq, void *cookie)
-{
-	struct wl1271 *wl = cookie;
-	unsigned long flags;
-
-	wl1271_debug(DEBUG_IRQ, "IRQ");
-
-	/* complete the ELP completion */
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
-	if (wl->elp_compl) {
-		complete(wl->elp_compl);
-		wl->elp_compl = NULL;
-	}
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	return IRQ_WAKE_THREAD;
-}
-
-static int wl1271_spi_set_power(struct wl1271 *wl, bool enable)
-{
-	if (wl->set_power)
-		wl->set_power(enable);
-
-	return 0;
-}
-
 static struct wl1271_if_operations spi_ops = {
-	.read		= wl1271_spi_raw_read,
-	.write		= wl1271_spi_raw_write,
-	.reset		= wl1271_spi_reset,
-	.init		= wl1271_spi_init,
-	.power		= wl1271_spi_set_power,
-	.dev		= wl1271_spi_wl_to_dev,
-	.enable_irq	= wl1271_spi_enable_interrupts,
-	.disable_irq	= wl1271_spi_disable_interrupts,
+	.read		= wl12xx_spi_raw_read,
+	.write		= wl12xx_spi_raw_write,
+	.reset		= wl12xx_spi_reset,
+	.init		= wl12xx_spi_init,
 	.set_block_size = NULL,
 };
 
@@ -376,10 +326,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
 	struct wl12xx_platform_data *pdata;
-	struct ieee80211_hw *hw;
-	struct wl1271 *wl;
 	struct resource res[1];
-	unsigned long irqflags;
 	int ret = -ENOMEM;
 
 	pdata = spi->dev.platform_data;
@@ -388,27 +335,17 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		return -ENODEV;
 	}
 
+	pdata->ops = &spi_ops;
+
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		wl1271_error("can't allocate glue");
 		goto out;
 	}
 
-	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw)) {
-		ret = PTR_ERR(hw);
-		goto out_free_glue;
-	}
-
-	wl = hw->priv;
-
 	glue->dev = &spi->dev;
-	glue->wl = wl;
 
 	spi_set_drvdata(spi, glue);
-	wl->if_priv = glue;
-
-	wl->if_ops = &spi_ops;
 
 	/* This is the only SPI value that we need to set here, the rest
 	 * comes from the board-peripherals file */
@@ -417,55 +354,14 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		wl1271_error("spi_setup failed");
-		goto out_free_hw;
-	}
-
-	wl->set_power = pdata->set_power;
-	if (!wl->set_power) {
-		wl1271_error("set power function missing in platform data");
-		ret = -ENODEV;
-		goto out_free_hw;
-	}
-
-	wl->ref_clock = pdata->board_ref_clock;
-	wl->tcxo_clock = pdata->board_tcxo_clock;
-	wl->platform_quirks = pdata->platform_quirks;
-
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
-		irqflags = IRQF_TRIGGER_RISING;
-	else
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
-
-	wl->irq = spi->irq;
-	if (wl->irq < 0) {
-		wl1271_error("irq missing in platform data");
-		ret = -ENODEV;
-		goto out_free_hw;
-	}
-
-	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   irqflags,
-				   DRIVER_NAME, wl);
-	if (ret < 0) {
-		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free_hw;
+		goto out_free_glue;
 	}
 
-	disable_irq(wl->irq);
-
-	ret = wl1271_init_ieee80211(wl);
-	if (ret)
-		goto out_irq;
-
-	ret = wl1271_register_hw(wl);
-	if (ret)
-		goto out_irq;
-
 	glue->core = platform_device_alloc("wl12xx-spi", -1);
 	if (!glue->core) {
 		dev_err(&spi->dev, "can't allocate platform_device\n");
 		ret = -ENOMEM;
-		goto out_unreg_hw;
+		goto out_free_glue;
 	}
 
 	glue->core->dev.parent = &spi->dev;
@@ -499,15 +395,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 out_dev_put:
 	platform_device_put(glue->core);
 
-out_unreg_hw:
-	wl1271_unregister_hw(wl);
-
-out_irq:
-	free_irq(wl->irq, wl);
-
-out_free_hw:
-	wl1271_free_hw(wl);
-
 out_free_glue:
 	kfree(glue);
 out:
@@ -517,11 +404,7 @@ out:
 static int __devexit wl1271_remove(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue = spi_get_drvdata(spi);
-	struct wl1271 *wl = glue->wl;
 
-	wl1271_unregister_hw(wl);
-	free_irq(wl->irq, wl);
-	wl1271_free_hw(wl);
 	platform_device_del(glue->core);
 	platform_device_put(glue->core);
 	kfree(glue);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 074de4e..091fdd2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -286,17 +286,14 @@ struct wl1271_scan {
 };
 
 struct wl1271_if_operations {
-	void (*read)(struct wl1271 *wl, int addr, void *buf, size_t len,
+	void (*read)(struct device *child, int addr, void *buf, size_t len,
 		     bool fixed);
-	void (*write)(struct wl1271 *wl, int addr, void *buf, size_t len,
+	void (*write)(struct device *child, int addr, void *buf, size_t len,
 		     bool fixed);
-	void (*reset)(struct wl1271 *wl);
-	void (*init)(struct wl1271 *wl);
-	int (*power)(struct wl1271 *wl, bool enable);
-	struct device* (*dev)(struct wl1271 *wl);
-	void (*enable_irq)(struct wl1271 *wl);
-	void (*disable_irq)(struct wl1271 *wl);
-	void (*set_block_size) (struct wl1271 *wl, unsigned int blksz);
+	void (*reset)(struct device *child);
+	void (*init)(struct device *child);
+	int (*power)(struct device *child, bool enable);
+	void (*set_block_size) (struct device *child, unsigned int blksz);
 };
 
 #define MAX_NUM_KEYS 14
@@ -357,6 +354,8 @@ struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
+	struct device *dev;
+
 	void *if_priv;
 
 	struct wl1271_if_operations *if_ops;
diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
index 973b110..3c96b33 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
+++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
@@ -2,7 +2,7 @@
 #include <linux/err.h>
 #include <linux/wl12xx.h>
 
-static const struct wl12xx_platform_data *platform_data;
+static struct wl12xx_platform_data *platform_data;
 
 int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
 {
@@ -18,7 +18,7 @@ int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
 	return 0;
 }
 
-const struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+struct wl12xx_platform_data *wl12xx_get_platform_data(void)
 {
 	if (!platform_data)
 		return ERR_PTR(-ENODEV);
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 4b69739..0d63731 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -54,6 +54,9 @@ struct wl12xx_platform_data {
 	int board_ref_clock;
 	int board_tcxo_clock;
 	unsigned long platform_quirks;
+	bool pwr_in_suspend;
+
+	struct wl1271_if_operations *ops;
 };
 
 /* Platform does not support level trigger interrupts */
@@ -73,6 +76,6 @@ int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
 
 #endif
 
-const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+struct wl12xx_platform_data *wl12xx_get_platform_data(void);
 
 #endif
-- 
1.7.1

