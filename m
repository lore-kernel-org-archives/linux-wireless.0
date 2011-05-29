Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38481 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1E2M5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 08:57:01 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3143732wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 05:57:00 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wl12xx_sdio: enable wowlan only if enable_irq_wake() succeeded
Date: Sun, 29 May 2011 15:56:52 +0300
Message-Id: <1306673812-27978-4-git-send-email-eliad@wizery.com> (sfid-20110529_145706_749088_D44A6351)
In-Reply-To: <1306673812-27978-1-git-send-email-eliad@wizery.com>
References: <1306673812-27978-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platforms don't support the wake_irq, so disable wowlan
in this case, and avoid the "Unbalanced IRQ wake disable"
warning on disable_irq_wake().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c   |   25 +++++++++++++++----------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 74fd7c6..35b16f2 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -267,17 +267,20 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 		goto out_free;
 	}
 
-	enable_irq_wake(wl->irq);
-	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 1);
+	ret = enable_irq_wake(wl->irq);
+	if (!ret) {
+		wl->irq_wake_enabled = true;
+		device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 1);
 
-	disable_irq(wl->irq);
+		disable_irq(wl->irq);
 
-	/* if sdio can keep power while host is suspended, enable wow */
-	mmcflags = sdio_get_host_pm_caps(func);
-	wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
+		/* if sdio can keep power while host is suspended, enable wow */
+		mmcflags = sdio_get_host_pm_caps(func);
+		wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
 
-	if (mmcflags & MMC_PM_KEEP_POWER)
-		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+		if (mmcflags & MMC_PM_KEEP_POWER)
+			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+	}
 
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
@@ -311,8 +314,10 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	wl1271_unregister_hw(wl);
-	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 0);
-	disable_irq_wake(wl->irq);
+	if (wl->irq_wake_enabled) {
+		device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 0);
+		disable_irq_wake(wl->irq);
+	}
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..06785db 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -579,6 +579,7 @@ struct wl1271 {
 	 * (currently, only "ANY" trigger is supported)
 	 */
 	bool wow_enabled;
+	bool irq_wake_enabled;
 
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
-- 
1.7.0.4

