Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:43174 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab1CHH52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 02:57:28 -0500
Received: by ewy6 with SMTP id 6so2142969ewy.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 23:57:25 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: shahar_levi@ti.com, ido@wizery.com
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Subject: [PATCH v2] wl12xx: fixes for 1281/1283 support - Add acx commands
Date: Tue,  8 Mar 2011 09:57:10 +0200
Message-Id: <1299571030-11753-1-git-send-email-coelho@ti.com>
In-Reply-To: <1299502396-11455-1-git-send-email-coelho@ti.com>
References: <1299502396-11455-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes up some issues with patch 03/15 in the wl128x support
series:

* Fix endianess issues;
* Simplify sdio-specific block_size handling;
* Minor changes in comments

This has been compile-tested only.  I will test this changes after I
go through the whole series and, if everything is still ok, I'll merge
this patch into 03/15.

Cc: Shahar Levi <shahar_levi@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c    |    4 +-
 drivers/net/wireless/wl12xx/acx.h    |    8 +++---
 drivers/net/wireless/wl12xx/init.c   |   42 ++++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/init.h   |    1 +
 drivers/net/wireless/wl12xx/io.c     |    9 +++++-
 drivers/net/wireless/wl12xx/io.h     |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   19 +++++----------
 drivers/net/wireless/wl12xx/sdio.c   |    3 ++
 drivers/net/wireless/wl12xx/spi.c    |   10 +-------
 drivers/net/wireless/wl12xx/tx.c     |   41 +++++++++++++-------------------
 drivers/net/wireless/wl12xx/tx.h     |   24 +++++++++---------
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +--
 12 files changed, 80 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index aa0fc12..50676b3 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1019,7 +1019,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl)
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap)
 {
 	struct wl1271_acx_host_config_bitmap *bitmap_conf;
 	int ret;
@@ -1030,7 +1030,7 @@ int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl)
 		goto out;
 	}
 
-	bitmap_conf->host_cfg_bitmap = wl->host_cfg_bitmap;
+	bitmap_conf->host_cfg_bitmap = cpu_to_le32(host_cfg_bitmap);
 
 	ret = wl1271_cmd_configure(wl, ACX_HOST_IF_CFG_BITMAP,
 				   bitmap_conf, sizeof(*bitmap_conf));
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 2d0bbfe..0a40cae 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -939,9 +939,9 @@ struct wl1271_acx_keep_alive_config {
 	u8 padding;
 } __packed;
 
-#define HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE     BIT(0)
-#define HOST_IF_CFG_BITMAP_TX_EXTRA_BLKS_SWAP BIT(1)
-#define HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK BIT(3)
+#define HOST_IF_CFG_RX_FIFO_ENABLE     BIT(0)
+#define HOST_IF_CFG_TX_EXTRA_BLKS_SWAP BIT(1)
+#define HOST_IF_CFG_TX_PAD_TO_SDIO_BLK BIT(3)
 
 struct wl1271_acx_host_config_bitmap {
 	struct acx_header header;
@@ -1285,7 +1285,7 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_ap_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_sta_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
-int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl);
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 2f31d14..34c4108 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -505,6 +505,27 @@ static int wl1271_set_ba_policies(struct wl1271 *wl)
 	return ret;
 }
 
+int wl1271_chip_specific_init(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
+
+		if (wl1271_set_block_size(wl))
+			/* Enable SDIO padding */
+			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
+
+		/* Must be before wl1271_acx_init_mem_config() */
+		ret = wl1271_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	return ret;
+}
+
+
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	struct conf_tx_ac_category *conf_ac;
@@ -520,23 +541,10 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		wl1271_set_block_size(wl);
-
-		wl->host_cfg_bitmap = HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE;
-
-		if (wl->block_size)
-			wl->host_cfg_bitmap |=
-				      HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK;
-
-		/*
-		 * Host interface configuration must be before
-		 * wl1271_acx_init_mem_config !
-		 */
-		ret = wl1271_acx_host_if_cfg_bitmap(wl);
-		if (ret < 0)
-			return ret;
-	}
+	/* Chip-specific init */
+	ret = wl1271_chip_specific_init(wl);
+	if (ret < 0)
+		return ret;
 
 	/* Mode specific init */
 	if (is_ap)
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 3a8bd3f..4975270 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -31,6 +31,7 @@ int wl1271_sta_init_templates_config(struct wl1271 *wl);
 int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
+int wl1271_chip_specific_init(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index ca7229f..aa40c98 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -43,9 +43,14 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
-void wl1271_set_block_size(struct wl1271 *wl)
+bool wl1271_set_block_size(struct wl1271 *wl)
 {
-	wl->if_ops->set_block_size(wl);
+	if (wl->if_ops->set_block_size) {
+		wl->if_ops->set_block_size(wl);
+		return true;
+	}
+
+	return false;
 }
 
 void wl1271_disable_interrupts(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index 9ae2f4a..84454f6 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -169,6 +169,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
-void wl1271_set_block_size(struct wl1271 *wl);
+bool wl1271_set_block_size(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ac0513a..f24906f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -450,19 +450,10 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		wl1271_set_block_size(wl);
-
-		wl->host_cfg_bitmap = HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE;
-
-		if (wl->block_size)
-			wl->host_cfg_bitmap |=
-				      HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK;
-
-		ret = wl1271_acx_host_if_cfg_bitmap(wl);
-		if (ret < 0)
-			return ret;
-	}
+	/* Chip-specific initializations */
+	ret = wl1271_chip_specific_init(wl);
+	if (ret < 0)
+		return ret;
 
 	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
@@ -1349,6 +1340,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
+	wl->block_size = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -3472,6 +3464,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
+	wl->block_size = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index ed0f37e..55dc6e3 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -178,6 +178,9 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 
+	/* Set the default block size in case it was modified */
+	sdio_set_block_size(func, 0);
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index d6e566e..2a57583 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -68,14 +68,6 @@
 
 #define WSPI_MAX_NUM_OF_CHUNKS (WL1271_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE)
 
-/* When working with SPI block size not relevent*/
-#define TX_PAD_SDIO_BLK_SIZE                  0
-
-void wl1271_spi_set_block_size(struct wl1271 *wl)
-{
-	wl->block_size = TX_PAD_SDIO_BLK_SIZE;
-}
-
 static inline struct spi_device *wl_to_spi(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -364,7 +356,7 @@ static struct wl1271_if_operations spi_ops = {
 	.dev		= wl1271_spi_wl_to_dev,
 	.enable_irq	= wl1271_spi_enable_interrupts,
 	.disable_irq	= wl1271_spi_disable_interrupts,
-	.set_block_size = wl1271_spi_set_block_size,
+	.set_block_size = NULL,
 };
 
 static int __devinit wl1271_probe(struct spi_device *spi)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 542b785..30dc45a 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -145,14 +145,11 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
-	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
-		u32 sdio_block_mask = wl->block_size - 1;
-		int pad = (total_len + sdio_block_mask) & (~sdio_block_mask);
-
-		total_blocks = pad + TX_HW_BLOCK_SIZE - 1;
-	} else {
+	if (wl->block_size)
+		total_blocks = ALIGN(total_len, wl->block_size) +
+			TX_HW_BLOCK_SIZE - 1;
+	else
 		total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
-	}
 
 	total_blocks = total_blocks / TX_HW_BLOCK_SIZE + TX_HW_BLOCK_SPARE;
 	if (total_blocks <= wl->tx_blocks_available) {
@@ -245,13 +242,10 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
-	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
-		u32 sdio_block_mask = wl->block_size - 1;
-		int pad = (skb->len + sdio_block_mask) &
-			  (~sdio_block_mask);
+	if (wl->block_size) {
+		pad = ALIGN(skb->len, wl->block_size);
 
 		desc->wl128x_mem.extra_bytes = pad - skb->len;
-
 		desc->length = cpu_to_le16(pad >> 2);
 	} else {
 		/* align the length (and store in terms of words) */
@@ -323,19 +317,18 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
-	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
-		unsigned sdio_block_mask = wl->block_size - 1;
-
-		total_len = (skb->len + sdio_block_mask) & (~sdio_block_mask);
-	} else {
-		/*
-		 * The length of each packet is stored in terms of words. Thus,
-		 * we must pad the skb data to make sure its length is aligned.
-		 * The number of padding bytes is computed and set in
-		 * wl1271_tx_fill_hdr
-		 */
+	/*
+	 * The length of each packet is stored in terms of
+	 * words. Thus, we must pad the skb data to make sure its
+	 * length is aligned.  The number of padding bytes is computed
+	 * and set in wl1271_tx_fill_hdr.
+	 * In special cases, we want to align to a specific block size
+	 * (eg. for wl128x with SDIO we align to 256).
+	 */
+	if (wl->block_size)
+		total_len = ALIGN(skb->len, wl->block_size);
+	else
 		total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
-	}
 
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 3072f95..e313177 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -57,29 +57,29 @@
 
 struct wl127x_tx_mem {
 	/*
-	 * on wl127x: Number of extra memory blocks to allocate
-	 * for this packet in addition to the number of blocks
-	 * derived from the packet length
+	 * Number of extra memory blocks to allocate for this packet
+	 * in addition to the number of blocks derived from the packet
+	 * length.
 	 */
 	u8 extra_blocks;
 	/*
-	 * on wl127x: Total number of memory blocks allocated by
-	 * the host for this packet. Must be equal or greater
-	 * than the actual blocks number allocated by HW!!
+	 * Total number of memory blocks allocated by the host for
+	 * this packet. Must be equal or greater than the actual
+	 * blocks number allocated by HW.
 	 */
 	u8 total_mem_blocks;
 } __packed;
 
 struct wl128x_tx_mem {
 	/*
-	 * on wl128x: Total number of memory blocks allocated by
-	 * the host for this packet.
+	 * Total number of memory blocks allocated by the host for
+	 * this packet.
 	 */
 	u8 total_mem_blocks;
 	/*
-	 * on wl128x: Number of extra bytes, at the end of the
-	 * frame. the host uses this padding to complete each
-	 * frame to integer number of SDIO blocks.
+	 * Number of extra bytes, at the end of the frame. the host
+	 * uses this padding to complete each frame to integer number
+	 * of SDIO blocks.
 	 */
 	u8 extra_bytes;
 } __packed;
@@ -95,7 +95,7 @@ struct wl1271_tx_hw_descr {
 	__le32 start_time;
 	/*
 	 * Max delay in TUs until transmission. The last device time the
-	 * packet can be transmitted is: startTime+(1024*LifeTime)
+	 * packet can be transmitted is: start_time + (1024 * life_time)
 	 */
 	__le16 life_time;
 	/* Bitwise fields - see TX_ATTR... definitions above. */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 94b4062..959b338 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -534,9 +534,7 @@ struct wl1271 {
 	bool ba_support;
 	u8 ba_rx_bitmap;
 
-	/* wl128x features only */
-	__le32	host_cfg_bitmap;
-	u32	block_size;
+	u32 block_size;
 
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
-- 
1.7.1

