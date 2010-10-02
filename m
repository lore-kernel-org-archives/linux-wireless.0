Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:32 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 07/11] sdio: enable runtime PM for SDIO functions
Date: Sat,  2 Oct 2010 13:54:11 +0200
Message-Id: <1286020455-28946-8-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable runtime PM for SDIO functions.

SDIO functions are initialized with a disabled runtime PM state,
and are set active (and their usage count is incremented)
only before potential drivers are probed.

SDIO function drivers that support runtime PM should call
pm_runtime_put_noidle() in their probe routine, and
pm_runtime_get_noresume() in their remove routine (very
similarly to PCI drivers).

In case a matching driver does not support runtime PM, power will
always be kept high (since the usage count is positive).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c     |    5 +++++
 drivers/mmc/core/sdio_bus.c |   38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 0dbd6fe..85561dd 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -734,6 +734,11 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
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
index 256a968..3637483 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -126,21 +126,46 @@ static int sdio_bus_probe(struct device *dev)
 	if (!id)
 		return -ENODEV;
 
+	/* Unbound SDIO functions are always suspended.
+	 * During probe, the function is set active and the usage count
+	 * is incremented.  If the driver supports runtime PM,
+	 * it should call pm_runtime_put_noidle() in its probe routine and
+	 * pm_runtime_get_noresume() in its remove routine.
+	 */
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
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
 
-	return drv->probe(func, id);
+	return 0;
+
+disable_runtimepm:
+	pm_runtime_put_noidle(dev);
+out:
+	return ret;
 }
 
 static int sdio_bus_remove(struct device *dev)
 {
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
+	int ret;
+
+	/* Make sure card is powered before invoking ->remove() */
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto out;
 
 	drv->remove(func);
 
@@ -152,7 +177,14 @@ static int sdio_bus_remove(struct device *dev)
 		sdio_release_host(func);
 	}
 
-	return 0;
+	/* First, undo the increment made directly above */
+	pm_runtime_put_noidle(dev);
+
+	/* Then undo the runtime PM settings in sdio_bus_probe() */
+	pm_runtime_put_noidle(dev);
+
+out:
+	return ret;
 }
 
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.0.4

