Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55002 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeDZFrg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 01:47:36 -0400
From: Eyal Reizer <eyalreizer@gmail.com>
To: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        robh@kernel.org, sre@kernel.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Cc: Eyal Reizer <eyalr@ti.com>
Subject: [PATCH v2] wlcore: sdio: allow pm to handle sdio power
Date: Thu, 26 Apr 2018 08:47:11 +0300
Message-Id: <1524721631-5983-1-git-send-email-eyalr@ti.com> (sfid-20180426_074751_823507_E8AD5FB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pm_runtime handles sdio power on and power off transitions.
An old workaround for trying to control the power explicitly from the
driver was in fact causing failures on suspend/resume as the mmc layer
already power the module on resume.

In case of resume pm_runtime_get sync returns a positive device's usage
count causing the driver to try an re-initialize an already initialized
device. This was causing sdio bus failure on resume.

Remove this manual power on/off sequence as it is in-fact not needed.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 1f727ba..6dbe61d 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -155,17 +155,11 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 	struct mmc_card *card = func->card;
 
 	ret = pm_runtime_get_sync(&card->dev);
-	if (ret) {
-		/*
-		 * Runtime PM might be temporarily disabled, or the device
-		 * might have a positive reference counter. Make sure it is
-		 * really powered on.
-		 */
-		ret = mmc_power_restore_host(card->host);
-		if (ret < 0) {
-			pm_runtime_put_sync(&card->dev);
-			goto out;
-		}
+	if (ret < 0) {
+		pm_runtime_put_noidle(&card->dev);
+		dev_err(glue->dev, "%s: failed to get_sync(%d)\n",
+			__func__, ret);
+		goto out;
 	}
 
 	sdio_claim_host(func);
@@ -178,7 +172,6 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 
 static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 {
-	int ret;
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 	struct mmc_card *card = func->card;
 
@@ -186,16 +179,8 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-	/* Power off the card manually in case it wasn't powered off above */
-	ret = mmc_power_save_host(card->host);
-	if (ret < 0)
-		goto out;
-
 	/* Let runtime PM know the card is powered off */
-	pm_runtime_put_sync(&card->dev);
-
-out:
-	return ret;
+	return pm_runtime_put_sync(&card->dev);
 }
 
 static int wl12xx_sdio_set_power(struct device *child, bool enable)
-- 
2.7.4
