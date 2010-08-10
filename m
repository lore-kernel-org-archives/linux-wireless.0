Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab0HJWNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 18:13:46 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 6/9] omap: hsmmc: remove unused variable
Date: Wed, 11 Aug 2010 01:12:25 +0300
Message-Id: <1281478348-24833-7-git-send-email-ohad@wizery.com>
In-Reply-To: <1281478348-24833-1-git-send-email-ohad@wizery.com>
References: <1281478348-24833-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make this go away:

drivers/mmc/host/omap_hsmmc.c: In function 'omap_hsmmc_suspend':
drivers/mmc/host/omap_hsmmc.c:2328: warning: unused variable 'state'

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/host/omap_hsmmc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index b032828..d50e917 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2272,7 +2272,6 @@ static int omap_hsmmc_suspend(struct device *dev)
 	int ret = 0;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
-	pm_message_t state = PMSG_SUSPEND; /* unused by MMC core */
 
 	if (host && host->suspended)
 		return 0;
-- 
1.7.0.4

