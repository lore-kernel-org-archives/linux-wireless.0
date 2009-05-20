Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25920 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860AbZETC0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 22:26:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] libertas: read SD8688 firmware status from new register
Date: Tue, 19 May 2009 19:48:21 -0700
Message-Id: <1242787701-10685-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
References: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scratch pad register is used to store firmware status after
firmware is downloaded and initialized. After firmware status is
verified OK, the same register is used to store RX packet length.
Hence the firmware status code is no longer valid afterwards.

SD8688 firmware introduces a new register for firmware status
which will never be overwritten.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/if_sdio.c |   20 ++++++++++++++++++--
 drivers/net/wireless/libertas/if_sdio.h |    1 +
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 478d766..18132d4 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -119,15 +119,29 @@ struct if_sdio_card {
 /* I/O                                                              */
 /********************************************************************/
 
+/*
+ *  For SD8385/SD8686, this function reads firmware status after
+ *  the image is downloaded, or reads RX packet length when
+ *  interrupt (with IF_SDIO_H_INT_UPLD bit set) is received.
+ *  For SD8688, this function reads firmware status only.
+ */
 static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
 {
 	int ret, reg;
 	u16 scratch;
 
-	if (card->model == IF_SDIO_MODEL_8385)
+	switch (card->model) {
+	case IF_SDIO_MODEL_8385:
 		reg = IF_SDIO_SCRATCH_OLD;
-	else
+		break;
+	case IF_SDIO_MODEL_8686:
 		reg = IF_SDIO_SCRATCH;
+		break;
+	case IF_SDIO_MODEL_8688:
+	default: /* for newer chipsets */
+		reg = IF_SDIO_FW_STATUS;
+		break;
+	}
 
 	scratch = sdio_readb(card->func, reg, &ret);
 	if (!ret)
@@ -706,6 +720,8 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 	if (ret)
 		goto out;
 
+	lbs_deb_sdio("firmware status = %#x\n", scratch);
+
 	if (scratch == IF_SDIO_FIRMWARE_OK) {
 		lbs_deb_sdio("firmware already loaded\n");
 		goto success;
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index d3a4fbe..60c9b2f 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -42,6 +42,7 @@
 
 #define IF_SDIO_SCRATCH		0x34
 #define IF_SDIO_SCRATCH_OLD	0x80fe
+#define IF_SDIO_FW_STATUS	0x40
 #define   IF_SDIO_FIRMWARE_OK	0xfedc
 
 #define IF_SDIO_RX_LEN		0x42
-- 
1.5.3.6

