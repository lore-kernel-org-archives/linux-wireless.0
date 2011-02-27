Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50359 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1B0WOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:14:10 -0500
Received: by wyg36 with SMTP id 36so3119314wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:14:09 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: Don't rely on runtime PM for toggling power
Date: Mon, 28 Feb 2011 00:13:58 +0200
Message-Id: <1298844838-11845-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Runtime PM might not always be enabled. Even if it is enabled in the
running kernel, it can still be temporarily disabled, for instance
during suspend. Runtime PM is opportunistic in nature, and should not be
relied on for toggling power.

In case the interface is removed and re-added while runtime PM is
disabled, the FW will fail to boot, as it is mandatory to toggle power
between boots. For instance, this can happen during suspend in case one
of the devices fails to suspend before the MMC host suspends, but after
mac80211 was suspended. The interface will be removed and reactivated
without toggling the power.

Fix this by calling mmc_power_save_host/mmc_power_restore_host in
wl1271_sdio_power_on/off functions. It will toggle the power to the chip
even if runtime PM is disabled. The runtime PM functions should still be
called to make sure runtime PM does not opportunistically power the chip
off (e.g. after resuming from system suspend).

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index d5e8748..f27e915 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -28,6 +28,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
 #include <linux/gpio.h>
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
@@ -163,11 +164,16 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	struct sdio_func *func = wl_to_func(wl);
 	int ret;
 
-	/* Power up the card */
+	/* Make sure the card will not be powered off by runtime PM */
 	ret = pm_runtime_get_sync(&func->dev);
 	if (ret < 0)
 		goto out;
 
+	/* Runtime PM might be disabled, so power up the card manually */
+	ret = mmc_power_restore_host(func->card->host);
+	if (ret < 0)
+		goto out;
+
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 	sdio_release_host(func);
@@ -179,12 +185,18 @@ out:
 static int wl1271_sdio_power_off(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
+	int ret;
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-	/* Power down the card */
+	/* Runtime PM might be disabled, so power off the card manually */
+	ret = mmc_power_save_host(func->card->host);
+	if (ret < 0)
+		return ret;
+
+	/* Let runtime PM know the card is powered off */
 	return pm_runtime_put_sync(&func->dev);
 }
 
-- 
1.7.1

