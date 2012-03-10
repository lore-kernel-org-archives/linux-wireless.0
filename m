Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62332 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2CJEVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 23:21:49 -0500
Received: by vcqp1 with SMTP id p1so2111742vcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 20:21:48 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 10 Mar 2012 12:21:48 +0800
Message-ID: <CAHPDcRsY2HN7NrrorBhhqPCiV2nG2BDC_n_eFTxBtGyt5REe4A@mail.gmail.com> (sfid-20120310_052216_356828_0889554B)
Subject: [PATCH] wl12xx: Init 80211 items before register irq
From: Yingang Fu <yingang.fu@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: yingang.fu@borqs.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race condition during wl12xx_probe that the interrupt
may arrives before the probe completed. An irq could triggers an
irq thread to run to process the irq work but the probe process has
not finished.
---
 drivers/net/wireless/wl12xx/main.c |   47 ++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c
b/drivers/net/wireless/wl12xx/main.c
index 3900236..be18a1c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5493,29 +5493,6 @@ static int __devinit wl12xx_probe(struct
platform_device *pdev)

 	platform_set_drvdata(pdev, wl);

-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
-		irqflags = IRQF_TRIGGER_RISING;
-	else
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
-
-	ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wl1271_irq,
-				   irqflags,
-				   pdev->name, wl);
-	if (ret < 0) {
-		wl1271_error("request_irq() failed: %d", ret);
-		goto out_free_hw;
-	}
-
-	ret = enable_irq_wake(wl->irq);
-	if (!ret) {
-		wl->irq_wake_enabled = true;
-		device_init_wakeup(wl->dev, 1);
-		if (pdata->pwr_in_suspend)
-			hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
-
-	}
-	disable_irq(wl->irq);
-
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
@@ -5545,6 +5522,30 @@ static int __devinit wl12xx_probe(struct
platform_device *pdev)
 		goto out_hw_pg_ver;
 	}

+        if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+                irqflags = IRQF_TRIGGER_RISING;
+        else
+                irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+
+        ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wl1271_irq,
+                                   irqflags,
+                                   pdev->name, wl);
+        if (ret < 0) {
+                wl1271_error("request_irq() failed: %d", ret);
+                goto out_free_hw;
+        }
+
+        ret = enable_irq_wake(wl->irq);
+        if (!ret) {
+                wl->irq_wake_enabled = true;
+                device_init_wakeup(wl->dev, 1);
+                if (pdata->pwr_in_suspend)
+                        hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
+
+        }
+        disable_irq(wl->irq);
+
+
 	return 0;

 out_hw_pg_ver:
-- 
1.7.0.4
