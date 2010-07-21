Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab0GURfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:16 -0400
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
Subject: [PATCH v2 15/20] mmc: sdio: verify existence of resume handler
Date: Wed, 21 Jul 2010 20:33:49 +0300
Message-Id: <1279733634-21974-16-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before invoking a card's resume handler, verify one exists.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 645f173..37739f5 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -504,7 +504,9 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
-			err = pmops->resume(&func->dev);
+
+			if (pmops && pmops->resume)
+				err = pmops->resume(&func->dev);
 		}
 	}
 
-- 
1.7.0.4

