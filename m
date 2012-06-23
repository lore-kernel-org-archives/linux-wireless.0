Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:57923 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab2FWGl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:41:57 -0400
Received: by lban1 with SMTP id n1so4046651lba.38
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:54 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 01/18] wlcore: Fix sdio out-of-sync power state
Date: Sat, 23 Jun 2012 09:41:12 +0300
Message-Id: <1340433689-24320-2-git-send-email-coelho@ti.com> (sfid-20120623_084202_926570_BD2A912F)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

wl12xx_sdio_power_off() manually powers down the card regardless of the
runtime pm state. If wl12xx_sdio_power_on() is called before the card
was suspended by runtime PM, it will not power up the card.

As part of the HW detection, the chip's power is toggled. Since this
happens in the context of probing sdio, the power reference counter will
be higher than zero. As a result, when wl12xx_sdio_power_off() is
called, the chip will be powered down while still having a positive
power reference counter. If the interface is quickly activated, the
driver might try to transfer data to a powered off chip.

Fix this by ensuring that wl12xx_sdio_power_on() explicitly powers on
the chip in case runtime pm claims the chip is already powered on. To
avoid cases in which it is not possible to determine if the chip was
really powered on (card's power reference counter is positive), operate
on the mmc_card instead of the function.

Also verify that the chip is indeed powered on before powering off, to
avoid wrong reference counter values in error cases.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.h   |   10 ++++++++--
 drivers/net/wireless/ti/wlcore/sdio.c |   34 ++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 8942954..404cb14 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -160,8 +160,14 @@ static inline void wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
 
 static inline void wl1271_power_off(struct wl1271 *wl)
 {
-	wl->if_ops->power(wl->dev, false);
-	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+	int ret;
+
+	if (!test_bit(WL1271_FLAG_GPIO_POWER, &wl->flags))
+		return;
+
+	ret = wl->if_ops->power(wl->dev, false);
+	if (!ret)
+		clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 }
 
 static inline int wl1271_power_on(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index c67ec48..4edaa20 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -147,17 +147,20 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 {
 	int ret;
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
+	struct mmc_card *card = func->card;
 
-	/* If enabled, tell runtime PM not to power off the card */
-	if (pm_runtime_enabled(&func->dev)) {
-		ret = pm_runtime_get_sync(&func->dev);
-		if (ret < 0)
-			goto out;
-	} else {
-		/* Runtime PM is disabled: power up the card manually */
-		ret = mmc_power_restore_host(func->card->host);
-		if (ret < 0)
+	ret = pm_runtime_get_sync(&card->dev);
+	if (ret) {
+		/*
+		 * Runtime PM might be temporarily disabled, or the device
+		 * might have a positive reference counter. Make sure it is
+		 * really powered on.
+		 */
+		ret = mmc_power_restore_host(card->host);
+		if (ret < 0) {
+			pm_runtime_put_sync(&card->dev);
 			goto out;
+		}
 	}
 
 	sdio_claim_host(func);
@@ -172,20 +175,21 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 {
 	int ret;
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
+	struct mmc_card *card = func->card;
 
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-	/* Power off the card manually, even if runtime PM is enabled. */
-	ret = mmc_power_save_host(func->card->host);
+	/* Power off the card manually in case it wasn't powered off above */
+	ret = mmc_power_save_host(card->host);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	/* If enabled, let runtime PM know the card is powered off */
-	if (pm_runtime_enabled(&func->dev))
-		ret = pm_runtime_put_sync(&func->dev);
+	/* Let runtime PM know the card is powered off */
+	pm_runtime_put_sync(&card->dev);
 
+out:
 	return ret;
 }
 
-- 
1.7.10

