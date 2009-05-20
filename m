Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25916 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751067AbZETC0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 22:26:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] libertas: define macros for SDIO model numbers
Date: Tue, 19 May 2009 19:48:18 -0700
Message-Id: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace direct usages of SDIO model numbers with defined macros.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/if_sdio.c |   18 +++++++++---------
 drivers/net/wireless/libertas/if_sdio.h |    4 ++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 55864c1..69d7fd3 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -66,19 +66,19 @@ struct if_sdio_model {
 static struct if_sdio_model if_sdio_models[] = {
 	{
 		/* 8385 */
-		.model = 0x04,
+		.model = IF_SDIO_MODEL_8385,
 		.helper = "sd8385_helper.bin",
 		.firmware = "sd8385.bin",
 	},
 	{
 		/* 8686 */
-		.model = 0x0B,
+		.model = IF_SDIO_MODEL_8686,
 		.helper = "sd8686_helper.bin",
 		.firmware = "sd8686.bin",
 	},
 	{
 		/* 8688 */
-		.model = 0x10,
+		.model = IF_SDIO_MODEL_8688,
 		.helper = "sd8688_helper.bin",
 		.firmware = "sd8688.bin",
 	},
@@ -118,7 +118,7 @@ static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
 	int ret, reg;
 	u16 scratch;
 
-	if (card->model == 0x04)
+	if (card->model == IF_SDIO_MODEL_8385)
 		reg = IF_SDIO_SCRATCH_OLD;
 	else
 		reg = IF_SDIO_SCRATCH;
@@ -216,7 +216,7 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	if (card->model == 0x04) {
+	if (card->model == IF_SDIO_MODEL_8385) {
 		event = sdio_readb(card->func, IF_SDIO_EVENT, &ret);
 		if (ret)
 			goto out;
@@ -829,10 +829,10 @@ static int if_sdio_probe(struct sdio_func *func,
 		if (sscanf(func->card->info[i],
 				"ID: %x", &model) == 1)
 			break;
-               if (!strcmp(func->card->info[i], "IBIS Wireless SDIO Card")) {
-                       model = 4;
-                       break;
-               }
+		if (!strcmp(func->card->info[i], "IBIS Wireless SDIO Card")) {
+			model = IF_SDIO_MODEL_8385;
+			break;
+		}
 	}
 
 	if (i == func->card->num_info) {
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index 37ada2c..cea343f 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -12,6 +12,10 @@
 #ifndef _LBS_IF_SDIO_H
 #define _LBS_IF_SDIO_H
 
+#define IF_SDIO_MODEL_8385	0x04
+#define IF_SDIO_MODEL_8686	0x0b
+#define IF_SDIO_MODEL_8688	0x10
+
 #define IF_SDIO_IOPORT		0x00
 
 #define IF_SDIO_H_INT_MASK	0x04
-- 
1.5.3.6

