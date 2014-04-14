Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16863 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbaDNWdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: increase SDIO multiport aggregation buffer sizes
Date: Mon, 14 Apr 2014 15:32:50 -0700
Message-ID: <1397514775-4777-2-git-send-email-bzhao@marvell.com> (sfid-20140415_003307_508981_69AB6148)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently Tx and Rx buffer sizes are 8K and 16K respectively for
all chipsets. We will change them to 32K for SD8897 and 16K for
older chipsets. SD8897 chipset has more SDIO data ports than
older chipsets.
This patch will help to improve throughput numbers.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |  6 ++++--
 drivers/net/wireless/mwifiex/sdio.h | 18 ++++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d206f04..accceed 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -85,6 +85,8 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->supports_sdio_new_mode = data->supports_sdio_new_mode;
 		card->has_control_mask = data->has_control_mask;
 		card->tx_buf_size = data->tx_buf_size;
+		card->mp_tx_agg_buf_size = data->mp_tx_agg_buf_size;
+		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
 	}
 
 	sdio_claim_host(func);
@@ -1842,8 +1844,8 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
 				       card->mp_agg_pkt_limit, GFP_KERNEL);
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
-					     SDIO_MP_TX_AGGR_DEF_BUF_SIZE,
-					     SDIO_MP_RX_AGGR_DEF_BUF_SIZE);
+					     card->mp_tx_agg_buf_size,
+					     card->mp_rx_agg_buf_size);
 	if (ret) {
 		dev_err(adapter->dev, "failed to alloc sdio mp-a buffers\n");
 		kfree(card->mp_regs);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index c71201b..6eea30b 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -64,10 +64,8 @@
 #define UP_LD_CMD_PORT_HOST_INT_STATUS	(0x40U)
 #define DN_LD_CMD_PORT_HOST_INT_STATUS	(0x80U)
 
-#define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (8192)	/* 8K */
-
-/* Multi port RX aggregation buffer size */
-#define SDIO_MP_RX_AGGR_DEF_BUF_SIZE        (16384)	/* 16K */
+#define MWIFIEX_MP_AGGR_BUF_SIZE_16K	(16384)
+#define MWIFIEX_MP_AGGR_BUF_SIZE_32K	(32768)
 
 /* Misc. Config Register : Auto Re-enable interrupts */
 #define AUTO_RE_ENABLE_INT              BIT(4)
@@ -234,6 +232,8 @@ struct sdio_mmc_card {
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
 	u16 tx_buf_size;
+	u32 mp_tx_agg_buf_size;
+	u32 mp_rx_agg_buf_size;
 
 	u32 mp_rd_bitmap;
 	u32 mp_wr_bitmap;
@@ -258,6 +258,8 @@ struct mwifiex_sdio_device {
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
 	u16 tx_buf_size;
+	u32 mp_tx_agg_buf_size;
+	u32 mp_rx_agg_buf_size;
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
@@ -315,6 +317,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -325,6 +329,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -335,6 +341,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -345,6 +353,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.supports_sdio_new_mode = true,
 	.has_control_mask = false,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 };
 
 /*
-- 
1.8.2.3

