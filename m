Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:30 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 06/11] sdio: enable runtime PM for SDIO cards
Date: Sat,  2 Oct 2010 13:54:10 +0200
Message-Id: <1286020455-28946-7-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable runtime PM for new SDIO cards.

As soon as the card will be added to the device tree, runtime PM core
will release its power, since it doesn't have any users yet.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/mmc/core/sdio.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index f17e0e0..0dbd6fe 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -708,6 +709,18 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 	card = host->card;
 
 	/*
+	 * Let runtime PM core know our card is active
+	 */
+	err = pm_runtime_set_active(&card->dev);
+	if (err)
+		goto remove;
+
+	/*
+	 * Enable runtime PM for this card
+	 */
+	pm_runtime_enable(&card->dev);
+
+	/*
 	 * The number of functions on the card is encoded inside
 	 * the ocr.
 	 */
-- 
1.7.0.4

