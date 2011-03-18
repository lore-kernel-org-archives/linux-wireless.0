Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42799 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756702Ab1CROUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:07 -0400
Received: by mail-wy0-f181.google.com with SMTP id 23so5230798wyf.40
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:06 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 04/14] wl12xx: 1281/1283 support - Add acx commands
Date: Fri, 18 Mar 2011 16:19:19 +0200
Message-Id: <1300457969-19601-5-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

New acx command that sets: Rx fifo enable reduced bus transactions
in RX path. Tx bus transactions padding to SDIO block size that
improve preference in Tx and essential for working with SDIO HS (48Mhz).
The max SDIO block size is 256 when working with Tx bus transactions
padding to SDIO block.

Add new ops to SDIO & SPI that handles the win size change in case of
transactions padding (relevant only for SDIO).

[Fix endianess issues; simplify sdio-specific block_size handling;
minor changes in comments; use "aligned_len" in one calculation
instead of "pad" to avoid confusion -- Luca]

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   26 ++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   11 ++++++
 drivers/net/wireless/wl12xx/init.c   |   27 ++++++++++++++
 drivers/net/wireless/wl12xx/init.h   |    1 +
 drivers/net/wireless/wl12xx/io.c     |   10 +++++
 drivers/net/wireless/wl12xx/io.h     |    1 +
 drivers/net/wireless/wl12xx/main.c   |    7 ++++
 drivers/net/wireless/wl12xx/tx.c     |   64 ++++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/tx.h     |   46 +++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++
 10 files changed, 168 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index a3db755..50676b3 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1019,6 +1019,32 @@ out:
 	return ret;
 }
 
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap)
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
+	bitmap_conf->host_cfg_bitmap = cpu_to_le32(host_cfg_bitmap);
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
index dd19b01..0a40cae 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -939,6 +939,16 @@ struct wl1271_acx_keep_alive_config {
 	u8 padding;
 } __packed;
 
+#define HOST_IF_CFG_RX_FIFO_ENABLE     BIT(0)
+#define HOST_IF_CFG_TX_EXTRA_BLKS_SWAP BIT(1)
+#define HOST_IF_CFG_TX_PAD_TO_SDIO_BLK BIT(3)
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
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 6072fe4..34c4108 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -31,6 +31,7 @@
 #include "cmd.h"
 #include "reg.h"
 #include "tx.h"
+#include "io.h"
 
 int wl1271_sta_init_templates_config(struct wl1271 *wl)
 {
@@ -504,6 +505,27 @@ static int wl1271_set_ba_policies(struct wl1271 *wl)
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
@@ -519,6 +541,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* Chip-specific init */
+	ret = wl1271_chip_specific_init(wl);
+	if (ret < 0)
+		return ret;
+
 	/* Mode specific init */
 	if (is_ap)
 		ret = wl1271_ap_hw_init(wl);
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
index d557f73..aa40c98 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -43,6 +43,16 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
+bool wl1271_set_block_size(struct wl1271 *wl)
+{
+	if (wl->if_ops->set_block_size) {
+		wl->if_ops->set_block_size(wl);
+		return true;
+	}
+
+	return false;
+}
+
 void wl1271_disable_interrupts(struct wl1271 *wl)
 {
 	wl->if_ops->disable_irq(wl);
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index c1aac82..84454f6 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -169,5 +169,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
+bool wl1271_set_block_size(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b0c4935..f24906f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -450,6 +450,11 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* Chip-specific initializations */
+	ret = wl1271_chip_specific_init(wl);
+	if (ret < 0)
+		return ret;
+
 	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
@@ -1335,6 +1340,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
+	wl->block_size = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -3458,6 +3464,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
+	wl->block_size = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5e9ef7d..e296f0a 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -132,6 +132,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
+	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
 
@@ -145,14 +146,20 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
-	total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
-	total_blocks = total_blocks / TX_HW_BLOCK_SIZE + TX_HW_BLOCK_SPARE;
+	if (wl->block_size)
+		len = ALIGN(total_len, wl->block_size);
+	else
+		len = total_len;
+
+	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
+		TX_HW_BLOCK_SPARE;
+
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
 
-		desc->extra_mem_blocks = TX_HW_BLOCK_SPARE;
-		desc->total_mem_blocks = total_blocks;
+		desc->wl127x_mem.extra_blocks = TX_HW_BLOCK_SPARE;
+		desc->wl127x_mem.total_mem_blocks = total_blocks;
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
@@ -178,7 +185,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 {
 	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
-	int pad, ac, rate_idx;
+	int aligned_len, ac, rate_idx;
 	s64 hosttime;
 	u16 tx_attr;
 
@@ -237,20 +244,32 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
-	/* align the length (and store in terms of words) */
-	pad = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
-	desc->length = cpu_to_le16(pad >> 2);
+	if (wl->block_size) {
+		aligned_len = ALIGN(skb->len, wl->block_size);
+
+		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
+		desc->length = cpu_to_le16(aligned_len >> 2);
+	} else {
+		int pad;
+
+		/* align the length (and store in terms of words) */
+		aligned_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+		desc->length = cpu_to_le16(aligned_len >> 2);
+
+		/* calculate number of padding bytes */
+		pad = aligned_len - skb->len;
+		tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
 
-	/* calculate number of padding bytes */
-	pad = pad - skb->len;
-	tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+		wl1271_debug(DEBUG_TX, "tx_fill_hdr: padding: %d", pad);
+	}
 
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
-	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
-		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
-		le16_to_cpu(desc->tx_attr), le16_to_cpu(desc->length),
-		le16_to_cpu(desc->life_time), desc->total_mem_blocks);
+	wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d tx_attr: 0x%x "
+		     "len: %d life: %d mem: %d",
+		     desc->hlid, le16_to_cpu(desc->tx_attr),
+		     le16_to_cpu(desc->length),	le16_to_cpu(desc->life_time),
+		     desc->wl127x_mem.total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
@@ -305,11 +324,18 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
 	/*
-	 * The length of each packet is stored in terms of words. Thus, we must
-	 * pad the skb data to make sure its length is aligned.
-	 * The number of padding bytes is computed and set in wl1271_tx_fill_hdr
+	 * The length of each packet is stored in terms of
+	 * words. Thus, we must pad the skb data to make sure its
+	 * length is aligned.  The number of padding bytes is computed
+	 * and set in wl1271_tx_fill_hdr.
+	 * In special cases, we want to align to a specific block size
+	 * (eg. for wl128x with SDIO we align to 256).
 	 */
-	total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+	if (wl->block_size)
+		total_len = ALIGN(skb->len, wl->block_size);
+	else
+		total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 02f07fa..e313177 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -55,20 +55,48 @@
 #define WL1271_TX_ALIGN_TO 4
 #define WL1271_TKIP_IV_SPACE 4
 
+struct wl127x_tx_mem {
+	/*
+	 * Number of extra memory blocks to allocate for this packet
+	 * in addition to the number of blocks derived from the packet
+	 * length.
+	 */
+	u8 extra_blocks;
+	/*
+	 * Total number of memory blocks allocated by the host for
+	 * this packet. Must be equal or greater than the actual
+	 * blocks number allocated by HW.
+	 */
+	u8 total_mem_blocks;
+} __packed;
+
+struct wl128x_tx_mem {
+	/*
+	 * Total number of memory blocks allocated by the host for
+	 * this packet.
+	 */
+	u8 total_mem_blocks;
+	/*
+	 * Number of extra bytes, at the end of the frame. the host
+	 * uses this padding to complete each frame to integer number
+	 * of SDIO blocks.
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
+	 * packet can be transmitted is: start_time + (1024 * life_time)
+	 */
 	__le16 life_time;
 	/* Bitwise fields - see TX_ATTR... definitions above. */
 	__le16 tx_attr;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a2e899d..959b338 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -303,6 +303,7 @@ struct wl1271_if_operations {
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
+	void (*set_block_size) (struct wl1271 *wl);
 };
 
 #define MAX_NUM_KEYS 14
@@ -533,6 +534,8 @@ struct wl1271 {
 	bool ba_support;
 	u8 ba_rx_bitmap;
 
+	u32 block_size;
+
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
 	 * are always active.
-- 
1.7.1

