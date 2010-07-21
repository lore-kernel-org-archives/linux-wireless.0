Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761093Ab0GURfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:22 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 17/20] mmc: sdio: relocate sdio_set_block_size call
Date: Wed, 21 Jul 2010 20:33:51 +0300
Message-Id: <1279733634-21974-18-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support probing of SDIO function driver while the device
is powered off, we need to relocate the sdio_set_block_size call
from the bus probe to an earlier point where we know the device
is still powered. In addition, we want the block size set also
when cards are resumed.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c     |   14 +++++++++++++-
 drivers/mmc/core/sdio_bus.c |    9 ---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 79e6fa1..5c0fbfa 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -73,6 +73,12 @@ static int sdio_init_func(struct mmc_card *card, unsigned int fn)
 
 	card->sdio_func[fn - 1] = func;
 
+	/* Set the default block size so the driver is sure it's something
+	 * sensible. */
+	ret = sdio_set_block_size(func, 0);
+	if (ret)
+		return ret;
+
 	/* For each SDIO function initialized, increase the power claim
 	 * reference count of the card */
 	atomic_inc(&card->power_claims);
@@ -510,7 +516,13 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
 
-			if (pmops && pmops->resume)
+			/* Set the default block size so the driver is sure
+			 * it's something sensible. */
+			mmc_claim_host(host);
+			err = sdio_set_block_size(func, 0);
+			mmc_release_host(host);
+
+			if (!err && pmops && pmops->resume)
 				err = pmops->resume(&func->dev);
 		}
 	}
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 4a890dc..87269f6 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -119,20 +119,11 @@ static int sdio_bus_probe(struct device *dev)
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	const struct sdio_device_id *id;
-	int ret;
 
 	id = sdio_match_device(func, drv);
 	if (!id)
 		return -ENODEV;
 
-	/* Set the default block size so the driver is sure it's something
-	 * sensible. */
-	sdio_claim_host(func);
-	ret = sdio_set_block_size(func, 0);
-	sdio_release_host(func);
-	if (ret)
-		return ret;
-
 	return drv->probe(func, id);
 }
 
-- 
1.7.0.4

