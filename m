Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42082 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752931AbeEOPni (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 11:43:38 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] wlcore: sdio: Fix flakey SDIO runtime PM handling
Date: Tue, 15 May 2018 08:43:34 -0700
Message-Id: <20180515154334.121621-1-tony@atomide.com> (sfid-20180515_174402_893984_81BB4BC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can have pm_runtime_get_sync() return 1, and we can have
pm_runtime_put_sync() return -EBUSY. See rpm_suspend() and
rpm_resume() for more information.

Fix the issue by returning 0 from wl12xx_sdio_power_on() on success.
And use pm_runtime_put() instead of pm_runtime_put_sync() for
wl12xx_sdio_power_off(), then the MMC subsystem will idle the bus
when suitable.

Otherwise wlcore can sometimes get confused and may report bogus
errors and WLAN connection can fail.

Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -159,15 +159,15 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 		pm_runtime_put_noidle(&card->dev);
 		dev_err(glue->dev, "%s: failed to get_sync(%d)\n",
 			__func__, ret);
-		goto out;
+
+		return ret;
 	}
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 	sdio_release_host(func);
 
-out:
-	return ret;
+	return 0;
 }
 
 static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
@@ -180,7 +180,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 	sdio_release_host(func);
 
 	/* Let runtime PM know the card is powered off */
-	return pm_runtime_put_sync(&card->dev);
+	return pm_runtime_put(&card->dev);
 }
 
 static int wl12xx_sdio_set_power(struct device *child, bool enable)
-- 
2.17.0
