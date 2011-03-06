Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34123 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1CFO2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:12 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESCot019811
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:12 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 03/15] wl12xx: 1281/1283 support - Add acx commands
Date: Sun,  6 Mar 2011 16:32:08 +0200
Message-Id: <1299421940-26292-4-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New acx command that sets: Rx fifo enable reduced bus transactions
in RX path. Tx bus transactions padding to SDIO block size that
improve preference in Tx and essential for working with SDIO HS (48Mhz).
The max SDIO block size is 256 when working with Tx bus transactions
padding to SDIO block.

Add new ops to SDIO & SPI that handles the win size change in case of
transactions padding (relevant only for SDIO).

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   26 +++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   11 ++++++
 drivers/net/wireless/wl12xx/init.c   |   19 +++++++++++
 drivers/net/wireless/wl12xx/io.c     |    5 +++
 drivers/net/wireless/wl12xx/io.h     |    1 +
 drivers/net/wireless/wl12xx/main.c   |   14 ++++++++
 drivers/net/wireless/wl12xx/sdio.c   |   15 ++++++++-
 drivers/net/wireless/wl12xx/spi.c    |   11 ++++++-
 drivers/net/wireless/wl12xx/tx.c     |   59 ++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/tx.h     |   46 +++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    5 +++
 11 files changed, 185 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index a3db755..aa0fc12 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1019,6 +1019,32 @@ out:
 	return ret;
 }
 
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl)
+{
+	struct wl1271_acx_host_config_bitmap *bitmap_conf;
+	int ret;
+
+	bitmap_conf = kzalloc(sizeof(*bitmap_conf), GFP_KERNEL);
+	if (!bitmap_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bitmap_conf->host_cfg_bitmap = wl->host_cfg_bitmap;
+
+	ret = wl1271_cmd_configure(wl, ACX_HOST_IF_CFG_BITMAP,
+				   bitmap_conf, sizeof(*bitmap_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 bitmap config opt failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(bitmap_conf);
+
+	return ret;
+}
+
 int wl1271_acx_init_mem_config(struct wl1271 *wl)
 {
 	int ret;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index dd19b01..2d0bbfe 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -939,6 +939,16 @@ struct wl1271_acx_keep_alive_config {
 	u8 padding;
 } __packed;
 
+#define HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE     BIT(0)
+#define HOST_IF_CFG_BITMAP_TX_EXTRA_BLKS_SWAP BIT(1)
+#define HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK BIT(3)
+
+struct wl1271_acx_host_config_bitmap {
+	struct acx_header header;
+
+	__le32 host_cfg_bitmap;
+} __packed;
+
 enum {
 	WL1271_ACX_TRIG_TYPE_LEVEL = 0,
 	WL1271_ACX_TRIG_TYPE_EDGE,
@@ -1275,6 +1285,7 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_ap_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_sta_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 6072fe4..2f31d14 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -31,6 +31,7 @@
 #include "cmd.h"
 #include "reg.h"
 #include "tx.h"
+#include "io.h"
 
 int wl1271_sta_init_templates_config(struct wl1271 *wl)
 {
@@ -519,6 +520,24 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		wl1271_set_block_size(wl);
+
+		wl->host_cfg_bitmap = HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE;
+
+		if (wl->block_size)
+			wl->host_cfg_bitmap |=
+				      HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK;
+
+		/*
+		 * Host interface configuration must be before
+		 * wl1271_acx_init_mem_config !
+		 */
+		ret = wl1271_acx_host_if_cfg_bitmap(wl);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Mode specific init */
 	if (is_ap)
 		ret = wl1271_ap_hw_init(wl);
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index d557f73..ca7229f 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -43,6 +43,11 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
+void wl1271_set_block_size(struct wl1271 *wl)
+{
+	wl->if_ops->set_block_size(wl);
+}
+
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
 	wl->if_ops->disable_irq(wl);
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index c1aac82..9ae2f4a 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -169,5 +169,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
+void wl1271_set_block_size(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b0c4935..ac0513a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -450,6 +450,20 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		wl1271_set_block_size(wl);
+
+		wl->host_cfg_bitmap = HOST_IF_CFG_BITMAP_RX_FIFO_ENABLE;
+
+		if (wl->block_size)
+			wl->host_cfg_bitmap |=
+				      HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK;
+
+		ret = wl1271_acx_host_if_cfg_bitmap(wl);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 58d0208..ed0f37e 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -51,6 +51,18 @@ static const struct sdio_device_id wl1271_devices[] = {
 };
 MODULE_DEVICE_TABLE(sdio, wl1271_devices);
 
+/* The max SDIO block size is 256 when working with tx padding to SDIO block */
+#define TX_PAD_SDIO_BLK_SIZE                  256
+
+static void wl1271_sdio_set_block_size(struct wl1271 *wl)
+{
+	wl->block_size = TX_PAD_SDIO_BLK_SIZE;
+
+	sdio_claim_host(wl->if_priv);
+	sdio_set_block_size(wl->if_priv, TX_PAD_SDIO_BLK_SIZE);
+	sdio_release_host(wl->if_priv);
+}
+
 static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -203,7 +215,8 @@ static struct wl1271_if_operations sdio_ops = {
 	.power		= wl1271_sdio_set_power,
 	.dev		= wl1271_sdio_wl_to_dev,
 	.enable_irq	= wl1271_sdio_enable_interrupts,
-	.disable_irq	= wl1271_sdio_disable_interrupts
+	.disable_irq	= wl1271_sdio_disable_interrupts,
+	.set_block_size = wl1271_sdio_set_block_size,
 };
 
 static int __devinit wl1271_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 2993715..d6e566e 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -68,6 +68,14 @@
 
 #define WSPI_MAX_NUM_OF_CHUNKS (WL1271_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE)
 
+/* When working with SPI block size not relevent*/
+#define TX_PAD_SDIO_BLK_SIZE                  0
+
+void wl1271_spi_set_block_size(struct wl1271 *wl)
+{
+	wl->block_size = TX_PAD_SDIO_BLK_SIZE;
+}
+
 static inline struct spi_device *wl_to_spi(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -355,7 +363,8 @@ static struct wl1271_if_operations spi_ops = {
 	.power		= wl1271_spi_set_power,
 	.dev		= wl1271_spi_wl_to_dev,
 	.enable_irq	= wl1271_spi_enable_interrupts,
-	.disable_irq	= wl1271_spi_disable_interrupts
+	.disable_irq	= wl1271_spi_disable_interrupts,
+	.set_block_size = wl1271_spi_set_block_size,
 };
 
 static int __devinit wl1271_probe(struct spi_device *spi)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5e9ef7d..542b785 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -145,14 +145,22 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
-	total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
+	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
+		u32 sdio_block_mask = wl->block_size - 1;
+		int pad = (total_len + sdio_block_mask) & (~sdio_block_mask);
+
+		total_blocks = pad + TX_HW_BLOCK_SIZE - 1;
+	} else {
+		total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
+	}
+
 	total_blocks = total_blocks / TX_HW_BLOCK_SIZE + TX_HW_BLOCK_SPARE;
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
 
-		desc->extra_mem_blocks = TX_HW_BLOCK_SPARE;
-		desc->total_mem_blocks = total_blocks;
+		desc->wl127x_mem.extra_blocks = TX_HW_BLOCK_SPARE;
+		desc->wl127x_mem.total_mem_blocks = total_blocks;
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
@@ -237,20 +245,31 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
-	/* align the length (and store in terms of words) */
-	pad = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
-	desc->length = cpu_to_le16(pad >> 2);
+	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
+		u32 sdio_block_mask = wl->block_size - 1;
+		int pad = (skb->len + sdio_block_mask) &
+			  (~sdio_block_mask);
 
-	/* calculate number of padding bytes */
-	pad = pad - skb->len;
-	tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+		desc->wl128x_mem.extra_bytes = pad - skb->len;
+
+		desc->length = cpu_to_le16(pad >> 2);
+	} else {
+		/* align the length (and store in terms of words) */
+		pad = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+		desc->length = cpu_to_le16(pad >> 2);
+
+		/* calculate number of padding bytes */
+		pad = pad - skb->len;
+		tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+	}
 
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
 		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
 		le16_to_cpu(desc->tx_attr), le16_to_cpu(desc->length),
-		le16_to_cpu(desc->life_time), desc->total_mem_blocks);
+		le16_to_cpu(desc->life_time),
+		desc->wl127x_mem.total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
@@ -304,12 +323,20 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
-	/*
-	 * The length of each packet is stored in terms of words. Thus, we must
-	 * pad the skb data to make sure its length is aligned.
-	 * The number of padding bytes is computed and set in wl1271_tx_fill_hdr
-	 */
-	total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+	if (wl->host_cfg_bitmap & HOST_IF_CFG_BITMAP_TX_PAD_TO_SDIO_BLK) {
+		unsigned sdio_block_mask = wl->block_size - 1;
+
+		total_len = (skb->len + sdio_block_mask) & (~sdio_block_mask);
+	} else {
+		/*
+		 * The length of each packet is stored in terms of words. Thus,
+		 * we must pad the skb data to make sure its length is aligned.
+		 * The number of padding bytes is computed and set in
+		 * wl1271_tx_fill_hdr
+		 */
+		total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+	}
+
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 02f07fa..3072f95 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -55,20 +55,48 @@
 #define WL1271_TX_ALIGN_TO 4
 #define WL1271_TKIP_IV_SPACE 4
 
+struct wl127x_tx_mem {
+	/*
+	 * on wl127x: Number of extra memory blocks to allocate
+	 * for this packet in addition to the number of blocks
+	 * derived from the packet length
+	 */
+	u8 extra_blocks;
+	/*
+	 * on wl127x: Total number of memory blocks allocated by
+	 * the host for this packet. Must be equal or greater
+	 * than the actual blocks number allocated by HW!!
+	 */
+	u8 total_mem_blocks;
+} __packed;
+
+struct wl128x_tx_mem {
+	/*
+	 * on wl128x: Total number of memory blocks allocated by
+	 * the host for this packet.
+	 */
+	u8 total_mem_blocks;
+	/*
+	 * on wl128x: Number of extra bytes, at the end of the
+	 * frame. the host uses this padding to complete each
+	 * frame to integer number of SDIO blocks.
+	 */
+	u8 extra_bytes;
+} __packed;
+
 struct wl1271_tx_hw_descr {
 	/* Length of packet in words, including descriptor+header+data */
 	__le16 length;
-	/* Number of extra memory blocks to allocate for this packet in
-	   addition to the number of blocks derived from the packet length */
-	u8 extra_mem_blocks;
-	/* Total number of memory blocks allocated by the host for this packet.
-	   Must be equal or greater than the actual blocks number allocated by
-	   HW!! */
-	u8 total_mem_blocks;
+	union {
+		struct wl127x_tx_mem wl127x_mem;
+		struct wl128x_tx_mem wl128x_mem;
+	} __packed;
 	/* Device time (in us) when the packet arrived to the driver */
 	__le32 start_time;
-	/* Max delay in TUs until transmission. The last device time the
-	   packet can be transmitted is: startTime+(1024*LifeTime) */
+	/*
+	 * Max delay in TUs until transmission. The last device time the
+	 * packet can be transmitted is: startTime+(1024*LifeTime)
+	 */
 	__le16 life_time;
 	/* Bitwise fields - see TX_ATTR... definitions above. */
 	__le16 tx_attr;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 7adb856..3c3bde9 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -303,6 +303,7 @@ struct wl1271_if_operations {
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
+	void (*set_block_size) (struct wl1271 *wl);
 };
 
 #define MAX_NUM_KEYS 14
@@ -533,6 +534,10 @@ struct wl1271 {
 	bool ba_support;
 	u8 ba_rx_bitmap;
 
+	/* wl128x features only */
+	__le32	host_cfg_bitmap;
+	u32	block_size;
+
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
 	 * are always active.
-- 
1.7.0.4

