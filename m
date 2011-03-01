Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1CAUg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:56 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so5089422wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:55 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 6/9] wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
Date: Tue,  1 Mar 2011 22:36:41 +0200
Message-Id: <1299011804-13899-7-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if a wow trigger was configured, set the MMC_PM_KEEP_POWER flag
on suspend, so our power will be kept while the system is suspended.

We needed to set this flag on each suspend attempt (when we want
to keep power)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index eec98a0..6083c3d 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -313,11 +313,41 @@ static int wl1271_suspend(struct device *dev)
 {
 	/* Tell MMC/SDIO core it's OK to power down the card
 	 * (if it isn't already), but not to remove it completely */
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct wl1271 *wl = sdio_get_drvdata(func);
+	mmc_pm_flag_t sdio_flags;
+	int ret = 0;
+
+	/*
+	 * we need to look into wl to tell which suspend method to use.
+	 * we will have full power, ps mode, elp, and power off
+	 */
+	wl1271_info("%s: wow_enabled: %d", __func__, wl->wow_enabled);
+	if (wl->wow_enabled) {
+		sdio_flags = sdio_get_host_pm_caps(func);
+
+		wl1271_info("suspend PM flags = 0x%x", sdio_flags);
+
+		if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
+			wl1271_error("can't keep power while host "
+				     "is suspended");
+			goto power_off;
+		}
+
+		/* keep power while host suspended */
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+		if (ret) {
+			wl1271_error("error while trying to keep power");
+			goto power_off;
+		}
+	}
+power_off:
 	return 0;
 }
 
 static int wl1271_resume(struct device *dev)
 {
+	wl1271_info("wl1271 resume");
 	return 0;
 }
 
-- 
1.7.0.4

