Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab0GURfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:13 -0400
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
Subject: [PATCH v2 14/20] mmc: sdio: fully reconfigure oldcard on resume
Date: Wed, 21 Jul 2010 20:33:48 +0300
Message-Id: <1279733634-21974-15-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
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
 drivers/mmc/core/sdio.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index b9dee28..645f173 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -344,7 +344,6 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 			goto err;
 		}
 		card = oldcard;
-		return 0;
 	}
 
 	/*
@@ -487,9 +486,6 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
-	if (!err)
-		/* We may have switched to 1-bit mode during suspend. */
-		err = sdio_enable_wide(host->card);
 	if (!err && host->sdio_irqs)
 		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
-- 
1.7.0.4

