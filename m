Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38126 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1FIXmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 19:42:03 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] mmc: sdio: fix runtime PM path during driver removal
Date: Fri, 10 Jun 2011 02:40:27 +0300
Message-Id: <1307662827-16618-1-git-send-email-ohad@wizery.com> (sfid-20110610_014209_374694_E4D92D86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit e1866b3 "PM / Runtime: Rework runtime PM handling
during driver removal" was introduced, the driver core stopped
incrementing the runtime PM usage counter of the device during
the invocation of the ->remove() callback.

This indirectly broke SDIO's runtime PM path during driver removal,
because no one calls _put_sync() anymore after ->remove() completes.

This means that the power of runtime-PM-managed SDIO cards is kept
high after their driver is removed (even if it was powered down
beforehand).

Fix that by directly calling _put_sync() when the last usage
counter is downref'ed by the SDIO bus.

Reported-and-tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio_bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index d29b9c3..d2565df 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -189,7 +189,7 @@ static int sdio_bus_remove(struct device *dev)
 
 	/* Then undo the runtime PM settings in sdio_bus_probe() */
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
-		pm_runtime_put_noidle(dev);
+		pm_runtime_put_sync(dev);
 
 out:
 	return ret;
-- 
1.7.1

