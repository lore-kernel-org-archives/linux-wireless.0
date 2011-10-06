Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42853 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759084Ab1JFTLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:13 -0400
Received: by mail-bw0-f41.google.com with SMTP id zs2so4785474bkb.14
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:11 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] wl12xx: add an sdio glue struct to keep wl and device side-by-side
Date: Thu,  6 Oct 2011 22:10:52 +0300
Message-Id: <1317928259-26437-2-git-send-email-coelho@ti.com> (sfid-20111006_211118_427595_8952F2E7)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

In order to fully abstract the bus, we need to save the device
structure *beside* wl1271, instead of inside it.

This will help re-structuring the driver so that we avoid the
duplicated code in the bus modules.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward-ported and cleaned up and rephrased commit message]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   59 ++++++++++++++++++++++++++----------
 1 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 516a898..c3ddaa6 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -44,6 +44,11 @@
 #define SDIO_DEVICE_ID_TI_WL1271	0x4076
 #endif
 
+struct wl12xx_sdio_glue {
+	struct device *dev;
+	struct wl1271 *wl;
+};
+
 static const struct sdio_device_id wl1271_devices[] __devinitconst = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
 	{}
@@ -57,14 +62,14 @@ static void wl1271_sdio_set_block_size(struct wl1271 *wl, unsigned int blksz)
 	sdio_release_host(wl->if_priv);
 }
 
-static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
+static inline struct wl12xx_sdio_glue *wl_to_glue(struct wl1271 *wl)
 {
 	return wl->if_priv;
 }
 
 static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
 {
-	return &(wl_to_func(wl)->dev);
+	return wl_to_glue(wl)->dev;
 }
 
 static irqreturn_t wl1271_hardirq(int irq, void *cookie)
@@ -110,7 +115,8 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 				 size_t len, bool fixed)
 {
 	int ret;
-	struct sdio_func *func = wl_to_func(wl);
+	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
@@ -135,7 +141,8 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 				  size_t len, bool fixed)
 {
 	int ret;
-	struct sdio_func *func = wl_to_func(wl);
+	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
@@ -158,8 +165,9 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 
 static int wl1271_sdio_power_on(struct wl1271 *wl)
 {
-	struct sdio_func *func = wl_to_func(wl);
 	int ret;
+	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	/* If enabled, tell runtime PM not to power off the card */
 	if (pm_runtime_enabled(&func->dev)) {
@@ -182,8 +190,9 @@ out:
 
 static int wl1271_sdio_power_off(struct wl1271 *wl)
 {
-	struct sdio_func *func = wl_to_func(wl);
 	int ret;
+	struct wl12xx_sdio_glue *glue = wl_to_glue(wl);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
 	sdio_disable_func(func);
 	sdio_release_host(func);
@@ -224,21 +233,34 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	struct ieee80211_hw *hw;
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
+	struct wl12xx_sdio_glue *glue;
 	unsigned long irqflags;
 	mmc_pm_flag_t mmcflags;
-	int ret;
+	int ret = -ENOMEM;
 
 	/* We are only able to handle the wlan function */
 	if (func->num != 0x02)
 		return -ENODEV;
 
+	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	if (!glue) {
+		wl1271_error("can't allocate glue");
+		goto out;
+	}
+
 	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw))
-		return PTR_ERR(hw);
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		ret = PTR_ERR(hw);
+		goto out_free_glue;
+	}
 
 	wl = hw->priv;
 
-	wl->if_priv = func;
+	glue->dev = &func->dev;
+	glue->wl = wl;
+
+	wl->if_priv = glue;
 	wl->if_ops = &sdio_ops;
 
 	/* Grab access to FN0 for ELP reg. */
@@ -251,7 +273,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	if (IS_ERR(wlan_data)) {
 		ret = PTR_ERR(wlan_data);
 		wl1271_error("missing wlan platform data: %d", ret);
-		goto out_free;
+		goto out_free_hw;
 	}
 
 	wl->irq = wlan_data->irq;
@@ -269,7 +291,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free;
+		goto out_free_hw;
 	}
 
 	ret = enable_irq_wake(wl->irq);
@@ -294,25 +316,29 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	if (ret)
 		goto out_irq;
 
-	sdio_set_drvdata(func, wl);
+	sdio_set_drvdata(func, glue);
 
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
 	return 0;
 
- out_irq:
+out_irq:
 	free_irq(wl->irq, wl);
 
- out_free:
+out_free_hw:
 	wl1271_free_hw(wl);
 
+out_free_glue:
+	kfree(glue);
+out:
 	return ret;
 }
 
 static void __devexit wl1271_remove(struct sdio_func *func)
 {
-	struct wl1271 *wl = sdio_get_drvdata(func);
+	struct wl12xx_sdio_glue *glue= sdio_get_drvdata(func);
+	struct wl1271 *wl = glue->wl;
 
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
@@ -324,6 +350,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	}
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
+	kfree(glue);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.1

