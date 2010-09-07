Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab0IGL3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:54 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 7/8] sdio: enable Runtime PM for SDIO functions
Date: Tue,  7 Sep 2010 14:29:08 +0300
Message-Id: <1283858949-11073-8-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable runtime PM for SDIO functions.

SDIO functions are initialized with a disabled runtime PM status,
and are set active (and their usage count is incremented)
only before potential drivers are probed.

SDIO function drivers that support runtime PM should call
pm_runtime_put_noidle() in their probe routine, and
pm_runtime_get_noresume() in their remove routine (very
similarly to PCI drivers).

In case a matching driver does not support runtime PM, power will
always be on (since the usage count is positive).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c     |    5 +++++
 drivers/mmc/core/sdio_bus.c |   30 ++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index a5a76a8..c4022da 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -732,6 +732,11 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 		err = sdio_init_func(host->card, i + 1);
 		if (err)
 			goto remove;
+
+		/*
+		 * Enable Runtime PM for this func
+		 */
+		pm_runtime_enable(&card->sdio_func[i]->dev);
 	}
 
 	mmc_release_host(host);
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 256a968..d55a592 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -126,15 +126,34 @@ static int sdio_bus_probe(struct device *dev)
 	if (!id)
 		return -ENODEV;
 
+	/* Unbound SDIO functions are always suspended.
+	 * During probe, the function is set active and the usage count
+	 * is incremented.  If the driver supports runtime PM,
+	 * it should call pm_runtime_put_noidle() in its probe routine and
+	 * pm_runtime_get_noresume() in its remove routine.
+	 */
+	ret = pm_runtime_get_sync(dev);
+	if (ret)
+		goto out;
+
 	/* Set the default block size so the driver is sure it's something
 	 * sensible. */
 	sdio_claim_host(func);
 	ret = sdio_set_block_size(func, 0);
 	sdio_release_host(func);
 	if (ret)
-		return ret;
+		goto disable_runtimepm;
+
+	ret = drv->probe(func, id);
+	if (ret)
+		goto disable_runtimepm;
+
+	return 0;
 
-	return drv->probe(func, id);
+disable_runtimepm:
+	pm_runtime_put_noidle(dev);
+out:
+	return ret;
 }
 
 static int sdio_bus_remove(struct device *dev)
@@ -142,6 +161,8 @@ static int sdio_bus_remove(struct device *dev)
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
+	pm_runtime_get_sync(dev);
+
 	drv->remove(func);
 
 	if (func->irq_handler) {
@@ -152,6 +173,11 @@ static int sdio_bus_remove(struct device *dev)
 		sdio_release_host(func);
 	}
 
+	pm_runtime_put_noidle(dev);
+
+	/* Undo the runtime PM settings in sdio_bus_probe() */
+	pm_runtime_put_noidle(dev);
+
 	return 0;
 }
 
-- 
1.7.0.4

