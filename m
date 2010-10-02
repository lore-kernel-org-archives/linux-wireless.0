Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:21 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 01/11] mmc: sdio: fully reconfigure oldcard on resume
Date: Sat,  2 Oct 2010 13:54:05 +0200
Message-Id: <1286020455-28946-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
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
index f332c52..3be1571 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -456,7 +456,6 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 			return -ENOENT;
 
 		card = oldcard;
-		return 0;
 	}
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
@@ -614,14 +613,6 @@ static int mmc_sdio_resume(struct mmc_host *host)
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

