Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0IGL3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 07:29:37 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v1 1/8] mmc: sdio: fully reconfigure oldcard on resume
Date: Tue,  7 Sep 2010 14:29:02 +0300
Message-Id: <1283858949-11073-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-1-git-send-email-ohad@wizery.com>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On resume, let mmc_sdio_init_card go all the way, instead
of skipping the reconfiguration of the card's speed and width.

This is needed to ensure cards wake up with their clock
reconfigured (otherwise it's kept low).

This patch also removes the explicit bus width reconfiguration
on resume, since now this is part of mmc_sdio_init_card.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index bd2755e..8a34945 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -457,7 +457,6 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 			return -ENOENT;
 
 		card = oldcard;
-		return 0;
 	}
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
@@ -615,14 +614,6 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
-	if (!err) {
-		/* We may have switched to 1-bit mode during suspend. */
-		err = sdio_enable_4bit_bus(host->card);
-		if (err > 0) {
-			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
-			err = 0;
-		}
-	}
 	if (!err && host->sdio_irqs)
 		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
-- 
1.7.0.4

