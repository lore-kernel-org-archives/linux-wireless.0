Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25918 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbZETC0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 22:26:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] libertas: get SD8688 rx length with one CMD52
Date: Tue, 19 May 2009 19:48:19 -0700
Message-Id: <1242787701-10685-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
References: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Usually, the 16-bit rx length is read from scratch pad registers
with two CMD52 transactions:
SD8385: 	IF_SDIO_SCRATCH_OLD (0x80fe/0x80ff)
SD8686/SD8688:	IF_SDIO_SCRATCH     (0x34/0x35)

Alternatively, SD8688 firmware offers an enhanced method for driver
to read an 8-bit rx length (in units) with a single CMD52:
IF_SDIO_RX_UNIT 0x43 is read one time after firmware is ready.
IF_SDIO_RX_LEN  0x42 is read every time when rx interrupt is received.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/if_sdio.c |   57 +++++++++++++++++++++++++++++-
 drivers/net/wireless/libertas/if_sdio.h |    3 ++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 69d7fd3..e998c12 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -107,6 +107,8 @@ struct if_sdio_card {
 
 	struct workqueue_struct	*workqueue;
 	struct work_struct	packet_worker;
+
+	u8			rx_unit;
 };
 
 /********************************************************************/
@@ -136,6 +138,46 @@ static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
 	return scratch;
 }
 
+static u8 if_sdio_read_rx_unit(struct if_sdio_card *card)
+{
+	int ret;
+	u8 rx_unit;
+
+	rx_unit = sdio_readb(card->func, IF_SDIO_RX_UNIT, &ret);
+
+	if (ret)
+		rx_unit = 0;
+
+	return rx_unit;
+}
+
+static u16 if_sdio_read_rx_len(struct if_sdio_card *card, int *err)
+{
+	int ret;
+	u16 rx_len;
+
+	switch (card->model) {
+	case IF_SDIO_MODEL_8385:
+	case IF_SDIO_MODEL_8686:
+		rx_len = if_sdio_read_scratch(card, &ret);
+		break;
+	case IF_SDIO_MODEL_8688:
+	default: /* for newer chipsets */
+		rx_len = sdio_readb(card->func, IF_SDIO_RX_LEN, &ret);
+		if (!ret)
+			rx_len <<= card->rx_unit;
+		else
+			rx_len = 0xffff;	/* invalid length */
+
+		break;
+	}
+
+	if (err)
+		*err = ret;
+
+	return rx_len;
+}
+
 static int if_sdio_handle_cmd(struct if_sdio_card *card,
 		u8 *buffer, unsigned size)
 {
@@ -254,7 +296,7 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	size = if_sdio_read_scratch(card, &ret);
+	size = if_sdio_read_rx_len(card, &ret);
 	if (ret)
 		goto out;
 
@@ -923,10 +965,21 @@ static int if_sdio_probe(struct sdio_func *func,
 
 	priv->fw_ready = 1;
 
+	sdio_claim_host(func);
+
+	/*
+	 * Get rx_unit if the chip is SD8688 or newer.
+	 * SD8385 & SD8686 do not have rx_unit.
+	 */
+	if ((card->model != IF_SDIO_MODEL_8385)
+			&& (card->model != IF_SDIO_MODEL_8686))
+		card->rx_unit = if_sdio_read_rx_unit(card);
+	else
+		card->rx_unit = 0;
+
 	/*
 	 * Enable interrupts now that everything is set up
 	 */
-	sdio_claim_host(func);
 	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
 	sdio_release_host(func);
 	if (ret)
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index cea343f..d3a4fbe 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -44,6 +44,9 @@
 #define IF_SDIO_SCRATCH_OLD	0x80fe
 #define   IF_SDIO_FIRMWARE_OK	0xfedc
 
+#define IF_SDIO_RX_LEN		0x42
+#define IF_SDIO_RX_UNIT		0x43
+
 #define IF_SDIO_EVENT           0x80fc
 
 #define IF_SDIO_BLOCK_SIZE	256
-- 
1.5.3.6

