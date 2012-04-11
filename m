Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35014 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754255Ab2DKJiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:21 -0400
Received: by lahi5 with SMTP id i5so481288lah.25
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 04/16] wl12xx/wlcore: initial split of probe
Date: Wed, 11 Apr 2012 12:37:51 +0300
Message-Id: <1334137083-13490-5-git-send-email-coelho@ti.com> (sfid-20120411_113826_044634_EBEF6A96)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to set some parameters (eg. partition and register tables)
during probe of the lower driver, so split the probe function, leaving
most of it in wlcore, but moving the hw struct allocation to the lower
driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   21 ++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/main.c   |   28 ++++++++++------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    7 ++++++-
 3 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e6c3502..c4fc93f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -22,7 +22,26 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
+#include <linux/err.h>
+
 #include "../wlcore/wlcore.h"
+#include "../wlcore/debug.h"
+
+static int __devinit wl12xx_probe(struct platform_device *pdev)
+{
+	struct wl1271 *wl;
+	struct ieee80211_hw *hw;
+
+	hw = wlcore_alloc_hw();
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		return PTR_ERR(hw);
+	}
+
+	wl = hw->priv;
+
+	return wlcore_probe(wl, pdev);
+}
 
 static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
 	{ "wl12xx", 0 },
@@ -31,7 +50,7 @@ static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
 MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
 
 static struct platform_driver wl12xx_driver = {
-	.probe		= wlcore_probe,
+	.probe		= wl12xx_probe,
 	.remove		= __devexit_p(wlcore_remove),
 	.id_table	= wl12xx_id_table,
 	.driver = {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 651536e..3cbc774 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5287,7 +5287,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 #define WL1271_DEFAULT_CHANNEL 0
 
-static struct ieee80211_hw *wl1271_alloc_hw(void)
+struct ieee80211_hw *wlcore_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
@@ -5412,8 +5412,9 @@ err_hw_alloc:
 
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(wlcore_alloc_hw);
 
-static int wl1271_free_hw(struct wl1271 *wl)
+int wlcore_free_hw(struct wl1271 *wl)
 {
 	/* Unblock any fwlog readers */
 	mutex_lock(&wl->mutex);
@@ -5447,6 +5448,7 @@ static int wl1271_free_hw(struct wl1271 *wl)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wlcore_free_hw);
 
 static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
 {
@@ -5477,22 +5479,12 @@ static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
 	return IRQ_WAKE_THREAD;
 }
 
-int __devinit wlcore_probe(struct platform_device *pdev)
+int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 {
 	struct wl12xx_platform_data *pdata = pdev->dev.platform_data;
-	struct ieee80211_hw *hw;
-	struct wl1271 *wl;
 	unsigned long irqflags;
-	int ret = -ENODEV;
-
-	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw)) {
-		wl1271_error("can't allocate hw");
-		ret = PTR_ERR(hw);
-		goto out;
-	}
+	int ret;
 
-	wl = hw->priv;
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->ref_clock = pdata->board_ref_clock;
 	wl->tcxo_clock = pdata->board_tcxo_clock;
@@ -5521,7 +5513,7 @@ int __devinit wlcore_probe(struct platform_device *pdev)
 		wl->irq_wake_enabled = true;
 		device_init_wakeup(wl->dev, 1);
 		if (pdata->pwr_in_suspend)
-			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+			wl->hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
 
 	}
 	disable_irq(wl->irq);
@@ -5555,7 +5547,7 @@ int __devinit wlcore_probe(struct platform_device *pdev)
 		goto out_hw_pg_ver;
 	}
 
-	return 0;
+	goto out;
 
 out_hw_pg_ver:
 	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
@@ -5567,7 +5559,7 @@ out_irq:
 	free_irq(wl->irq, wl);
 
 out_free_hw:
-	wl1271_free_hw(wl);
+	wlcore_free_hw(wl);
 
 out:
 	return ret;
@@ -5584,7 +5576,7 @@ int __devexit wlcore_remove(struct platform_device *pdev)
 	}
 	wl1271_unregister_hw(wl);
 	free_irq(wl->irq, wl);
-	wl1271_free_hw(wl);
+	wlcore_free_hw(wl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index e0187d7..4cabf97 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -22,7 +22,12 @@
 #ifndef __WLCORE_H__
 #define __WLCORE_H__
 
-int __devinit wlcore_probe(struct platform_device *pdev);
+#include "wl12xx.h"
+
+int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
+struct ieee80211_hw *wlcore_alloc_hw(void);
+int wlcore_free_hw(struct wl1271 *wl);
+
 
 #endif /* __WLCORE_H__ */
-- 
1.7.5.4

