Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43455 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632Ab3ERAzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:55:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 09/17] mwifiex: use u32 variables for SDIO read/write port bitmap
Date: Fri, 17 May 2013 17:50:26 -0700
Message-ID: <1368838234-32585-10-git-send-email-bzhao@marvell.com> (sfid-20130518_025509_042835_3D284C19)
In-Reply-To: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
References: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently supported SDIO chipsets (SD87XX) have 16 ports.
This change is a prerequisite for new chipset.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 40 ++++++++++++++++++-------------------
 drivers/net/wireless/mwifiex/sdio.h | 10 +++++-----
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 363ba31..7368ee1 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -486,21 +486,21 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	u16 rd_bitmap = card->mp_rd_bitmap;
+	u32 rd_bitmap = card->mp_rd_bitmap;
 
-	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%04x\n", rd_bitmap);
+	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%08x\n", rd_bitmap);
 
 	if (!(rd_bitmap & (CTRL_PORT_MASK | DATA_PORT_MASK)))
 		return -1;
 
 	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
-		card->mp_rd_bitmap &= (u16) (~CTRL_PORT_MASK);
+		card->mp_rd_bitmap &= (u32) (~CTRL_PORT_MASK);
 		*port = CTRL_PORT;
-		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%04x\n",
+		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%08x\n",
 			*port, card->mp_rd_bitmap);
 	} else {
 		if (card->mp_rd_bitmap & (1 << card->curr_rd_port)) {
-			card->mp_rd_bitmap &= (u16)
+			card->mp_rd_bitmap &= (u32)
 						(~(1 << card->curr_rd_port));
 			*port = card->curr_rd_port;
 
@@ -511,7 +511,7 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 		}
 
 		dev_dbg(adapter->dev,
-			"data: port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
+			"data: port=%d mp_rd_bitmap=0x%08x -> 0x%08x\n",
 			*port, rd_bitmap, card->mp_rd_bitmap);
 	}
 	return 0;
@@ -527,15 +527,15 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	u16 wr_bitmap = card->mp_wr_bitmap;
+	u32 wr_bitmap = card->mp_wr_bitmap;
 
-	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%04x\n", wr_bitmap);
+	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%08x\n", wr_bitmap);
 
 	if (!(wr_bitmap & card->mp_data_port_mask))
 		return -1;
 
 	if (card->mp_wr_bitmap & (1 << card->curr_wr_port)) {
-		card->mp_wr_bitmap &= (u16) (~(1 << card->curr_wr_port));
+		card->mp_wr_bitmap &= (u32) (~(1 << card->curr_wr_port));
 		*port = card->curr_wr_port;
 		if (++card->curr_wr_port == card->mp_end_port)
 			card->curr_wr_port = 1;
@@ -545,14 +545,14 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 	}
 
 	if (*port == CTRL_PORT) {
-		dev_err(adapter->dev, "invalid data port=%d cur port=%d"
-			" mp_wr_bitmap=0x%04x -> 0x%04x\n",
+		dev_err(adapter->dev,
+			"invalid data port=%d cur port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
 			*port, card->curr_wr_port, wr_bitmap,
 			card->mp_wr_bitmap);
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
+	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
 		*port, wr_bitmap, card->mp_wr_bitmap);
 
 	return 0;
@@ -1024,7 +1024,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		goto rx_curr_single;
 	}
 
-	if (card->mp_rd_bitmap & (~((u16) CTRL_PORT_MASK))) {
+	if (card->mp_rd_bitmap & (~((u32) CTRL_PORT_MASK))) {
 		/* Some more data RX pending */
 		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
 
@@ -1185,9 +1185,9 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		return ret;
 
 	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
-		card->mp_wr_bitmap = ((u16) card->mp_regs[WR_BITMAP_U]) << 8;
-		card->mp_wr_bitmap |= (u16) card->mp_regs[WR_BITMAP_L];
-		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%04x\n",
+		card->mp_wr_bitmap = ((u32) card->mp_regs[WR_BITMAP_U]) << 8;
+		card->mp_wr_bitmap |= (u32) card->mp_regs[WR_BITMAP_L];
+		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%08x\n",
 			card->mp_wr_bitmap);
 		if (adapter->data_sent &&
 		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
@@ -1204,7 +1204,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		/* Check if firmware has attach buffer at command port and
 		   update just that in wr_bit_map. */
 		card->mp_wr_bitmap |=
-			(u16) card->mp_regs[WR_BITMAP_L] & CTRL_PORT_MASK;
+			(u32) card->mp_regs[WR_BITMAP_L] & CTRL_PORT_MASK;
 		if (card->mp_wr_bitmap & CTRL_PORT_MASK)
 			adapter->cmd_sent = false;
 	}
@@ -1212,9 +1212,9 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
 		adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
-		card->mp_rd_bitmap = ((u16) card->mp_regs[RD_BITMAP_U]) << 8;
-		card->mp_rd_bitmap |= (u16) card->mp_regs[RD_BITMAP_L];
-		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%04x\n",
+		card->mp_rd_bitmap = ((u32) card->mp_regs[RD_BITMAP_U]) << 8;
+		card->mp_rd_bitmap |= (u32) card->mp_regs[RD_BITMAP_L];
+		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%08x\n",
 			card->mp_rd_bitmap);
 
 		while (true) {
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 8cc5468..6588069 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -261,7 +261,7 @@ struct mwifiex_sdio_mpa_tx {
 	u8 *buf;
 	u32 buf_len;
 	u32 pkt_cnt;
-	u16 ports;
+	u32 ports;
 	u16 start_port;
 	u8 enabled;
 	u32 buf_size;
@@ -272,7 +272,7 @@ struct mwifiex_sdio_mpa_rx {
 	u8 *buf;
 	u32 buf_len;
 	u32 pkt_cnt;
-	u16 ports;
+	u32 ports;
 	u16 start_port;
 
 	struct sk_buff *skb_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
@@ -290,11 +290,11 @@ struct sdio_mmc_card {
 	struct sdio_func *func;
 	struct mwifiex_adapter *adapter;
 
-	u16 mp_rd_bitmap;
-	u16 mp_wr_bitmap;
+	u32 mp_rd_bitmap;
+	u32 mp_wr_bitmap;
 
 	u16 mp_end_port;
-	u16 mp_data_port_mask;
+	u32 mp_data_port_mask;
 
 	u8 curr_rd_port;
 	u8 curr_wr_port;
-- 
1.8.2.3

