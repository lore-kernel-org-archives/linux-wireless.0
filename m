Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:23 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 03/11] sdio: add power_restore support
Date: Sat,  2 Oct 2010 13:54:07 +0200
Message-Id: <1286020455-28946-4-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a power_restore handler to the SDIO bus ops,
in order to support waking up SDIO cards that
were powered off by runtime pm.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3be1571..f17e0e0 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -638,11 +638,29 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	return err;
 }
 
+static int mmc_sdio_power_restore(struct mmc_host *host)
+{
+	int ret;
+
+	BUG_ON(!host);
+	BUG_ON(!host->card);
+
+	mmc_claim_host(host);
+	ret = mmc_sdio_init_card(host, host->ocr, host->card,
+			(host->pm_flags & MMC_PM_KEEP_POWER));
+	if (!ret && host->sdio_irqs)
+		mmc_signal_sdio_irq(host);
+	mmc_release_host(host);
+
+	return ret;
+}
+
 static const struct mmc_bus_ops mmc_sdio_ops = {
 	.remove = mmc_sdio_remove,
 	.detect = mmc_sdio_detect,
 	.suspend = mmc_sdio_suspend,
 	.resume = mmc_sdio_resume,
+	.power_restore = mmc_sdio_power_restore,
 };
 
 
-- 
1.7.0.4

