Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1E2Nhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 09:37:34 -0400
Received: by wya21 with SMTP id 21so2131759wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 06:37:33 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: <tim@kangatronix.co.uk>, Luciano Coelho <coelho@ti.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD
Date: Sun, 29 May 2011 16:36:03 +0300
Message-Id: <1306676163-17325-1-git-send-email-ohad@wizery.com> (sfid-20110529_153738_303070_7781C937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If our SDIO function has its runtime PM disabled, don't try to
manipulate its runtime PM status at all. This way we can still
power on cards plugged to mmc hosts that are not MMC_CAP_POWER_OFF_CARD.

Reported-and-tested-by: Tim Yamin <tim@kangatronix.co.uk>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 74fd7c6..e3b0436 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -161,10 +161,12 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	struct sdio_func *func = wl_to_func(wl);
 	int ret;
 
-	/* Make sure the card will not be powered off by runtime PM */
-	ret = pm_runtime_get_sync(&func->dev);
-	if (ret < 0)
-		goto out;
+	/* If enabled, tell runtime PM not to power off the card */
+	if (pm_runtime_enabled(&func->dev)) {
+		ret = pm_runtime_get_sync(&func->dev);
+		if (ret)
+			goto out;
+	}
 
 	/* Runtime PM might be disabled, so power up the card manually */
 	ret = mmc_power_restore_host(func->card->host);
@@ -191,8 +193,11 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	/* Let runtime PM know the card is powered off */
-	return pm_runtime_put_sync(&func->dev);
+	/* If enabled, let runtime PM know the card is powered off */
+	if (pm_runtime_enabled(&func->dev))
+		ret = pm_runtime_put_sync(&func->dev);
+
+	return ret;
 }
 
 static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
-- 
1.7.1

