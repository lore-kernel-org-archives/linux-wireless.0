Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61124 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761153Ab0GURfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:32 -0400
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
Subject: [PATCH v2 18/20] mmc: sdio: enable a default power off mode of the card
Date: Wed, 21 Jul 2010 20:33:52 +0300
Message-Id: <1279733634-21974-19-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for an SDIO device to stay powered off even without
the presence of an SDIO function driver. A host should explicitly
ask for it by means of MMC_CAP_DONT_POWER_CARD, and the SDIO
function driver should know it needs to call sdio_claim_power
before accessing the device.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c  |   15 +++++++++++++--
 include/linux/mmc/host.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 5c0fbfa..164353f 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -80,8 +80,9 @@ static int sdio_init_func(struct mmc_card *card, unsigned int fn)
 		return ret;
 
 	/* For each SDIO function initialized, increase the power claim
-	 * reference count of the card */
-	atomic_inc(&card->power_claims);
+	 * reference count of the card, unless explicitly requested not to */
+	if (!(card->host->caps & MMC_CAP_DONT_POWER_CARD))
+		atomic_inc(&card->power_claims);
 
 	return 0;
 
@@ -607,6 +608,16 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 	mmc_release_host(host);
 
 	/*
+	 * If power is not required for this card, power it off.
+	 * The sdio function will need to call sdio_claim_power.
+	 */
+	if (!atomic_read(&card->power_claims)) {
+		pr_info("%s: power is not claimed, releasing\n",
+						mmc_hostname(host));
+		mmc_release_power(host);
+	}
+
+	/*
 	 * First add the card to the driver model...
 	 */
 	err = mmc_add_card(host->card);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 3675d58..756cf38 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -155,6 +155,7 @@ struct mmc_host {
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
+#define MMC_CAP_DONT_POWER_CARD	(1 << 10)	/* Keep the card powered off */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
-- 
1.7.0.4

