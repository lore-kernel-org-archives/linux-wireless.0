Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33692 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab1FZPAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 11:00:52 -0400
Received: by wyg8 with SMTP id 8so642375wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2011 08:00:51 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: one SDIO initialization is enough
Date: Sun, 26 Jun 2011 18:00:11 +0300
Message-Id: <1309100411-15353-1-git-send-email-ohad@wizery.com> (sfid-20110626_170058_239570_D3900C60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip manual device power on in case runtime PM is enabled for
our device.

This eliminates a secondary & redundant SDIO init sequence.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
This patch depends on "wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD"

https://patchwork.kernel.org/patch/827772/

 drivers/net/wireless/wl12xx/sdio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 989b077..886c35f 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -174,13 +174,13 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 		ret = pm_runtime_get_sync(&func->dev);
 		if (ret)
 			goto out;
+	} else {
+		/* Runtime PM is disabled: power up the card manually */
+		ret = mmc_power_restore_host(func->card->host);
+		if (ret < 0)
+			goto out;
 	}
 
-	/* Runtime PM might be disabled, so power up the card manually */
-	ret = mmc_power_restore_host(func->card->host);
-	if (ret < 0)
-		goto out;
-
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 
@@ -196,7 +196,7 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-	/* Runtime PM might be disabled, so power off the card manually */
+	/* Power off the card manually, even if runtime PM is enabled. */
 	ret = mmc_power_save_host(func->card->host);
 	if (ret < 0)
 		return ret;
-- 
1.7.1

