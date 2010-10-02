Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:34 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 08/11] sdio: ensure mmc_sdio_detect is powered
Date: Sat,  2 Oct 2010 13:54:12 +0200
Message-Id: <1286020455-28946-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prevent an erroneous removal of the card, make sure
the device is powered when it is mmc_sdio_detect()ed.

This is required since mmc_sdio_detect may be invoked
while the device is runtime suspended (e.g., MMC core
is rescanning when system comes out of suspend).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 85561dd..c3ad105 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -546,6 +546,11 @@ static void mmc_sdio_detect(struct mmc_host *host)
 	BUG_ON(!host);
 	BUG_ON(!host->card);
 
+	/* Make sure card is powered before detecting it */
+	err = pm_runtime_get_sync(&host->card->dev);
+	if (err < 0)
+		goto out;
+
 	mmc_claim_host(host);
 
 	/*
@@ -555,6 +560,7 @@ static void mmc_sdio_detect(struct mmc_host *host)
 
 	mmc_release_host(host);
 
+out:
 	if (err) {
 		mmc_sdio_remove(host);
 
@@ -562,6 +568,9 @@ static void mmc_sdio_detect(struct mmc_host *host)
 		mmc_detach_bus(host);
 		mmc_release_host(host);
 	}
+
+	/* Tell PM core that we're done */
+	pm_runtime_put(&host->card->dev);
 }
 
 /*
-- 
1.7.0.4

