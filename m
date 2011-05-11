Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab1EKQZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:25:22 -0400
Received: by wwa36 with SMTP id 36so796804wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:25:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
Date: Wed, 11 May 2011 11:54:24 +0300
Message-Id: <1305104068-32240-4-git-send-email-eliad@wizery.com> (sfid-20110511_182606_615423_78F11861)
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if a wow trigger was configured, set the MMC_PM_KEEP_POWER flag
on suspend, so our power will be kept while the system is suspended.

We needed to set this flag on each suspend attempt (when we want
to keep power)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 1298461..5b03fd5 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -314,7 +314,34 @@ static int wl1271_suspend(struct device *dev)
 {
 	/* Tell MMC/SDIO core it's OK to power down the card
 	 * (if it isn't already), but not to remove it completely */
-	return 0;
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct wl1271 *wl = sdio_get_drvdata(func);
+	mmc_pm_flag_t sdio_flags;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "wl1271 suspend. wow_enabled: %d",
+		     wl->wow_enabled);
+
+	/* check whether sdio should keep power */
+	if (wl->wow_enabled) {
+		sdio_flags = sdio_get_host_pm_caps(func);
+
+		if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
+			wl1271_error("can't keep power while host "
+				     "is suspended");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/* keep power while host suspended */
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+		if (ret) {
+			wl1271_error("error while trying to keep power");
+			goto out;
+		}
+	}
+out:
+	return ret;
 }
 
 static int wl1271_resume(struct device *dev)
-- 
1.7.0.4

