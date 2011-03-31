Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45836 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab1CaIHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:20 -0400
Received: by fxm17 with SMTP id 17so1636314fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:19 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/5] wl12xx: Clean up the block size alignment code
Date: Thu, 31 Mar 2011 10:06:58 +0200
Message-Id: <1301558821-17787-3-git-send-email-ido@wizery.com>
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify and clean up the block size alignment code:
1. Set the block size according to the padding field type, as it cannot
   exceed the maximum value this field can hold.
2. Move the alignment code into a function instead of duplicating it in
   multiple places.
3. In the current implementation, the block_size member can be
   misleading because a zero value actually means that there's no need to
   align. Declare a block size alignment quirk instead.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/io.c     |    3 ++-
 drivers/net/wireless/wl12xx/main.c   |    4 ++--
 drivers/net/wireless/wl12xx/sdio.c   |   12 ++----------
 drivers/net/wireless/wl12xx/tx.c     |   26 ++++++++++++++------------
 drivers/net/wireless/wl12xx/tx.h     |    9 +++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |   10 ++++++----
 7 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 2dbc083..cf46607 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -514,7 +514,7 @@ int wl1271_chip_specific_init(struct wl1271 *wl)
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
 
-		if (wl1271_set_block_size(wl))
+		if (wl->quirks & WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT)
 			/* Enable SDIO padding */
 			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
 
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index aa40c98..da5c1ad 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -29,6 +29,7 @@
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
 #include "io.h"
+#include "tx.h"
 
 #define OCP_CMD_LOOP  32
 
@@ -46,7 +47,7 @@
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
 	if (wl->if_ops->set_block_size) {
-		wl->if_ops->set_block_size(wl);
+		wl->if_ops->set_block_size(wl, WL12XX_BUS_BLOCK_SIZE);
 		return true;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..960e993 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1017,6 +1017,8 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
+		if (wl1271_set_block_size(wl))
+			wl->quirks |= WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT;
 		break;
 	case CHIP_ID_1283_PG10:
 	default:
@@ -1472,7 +1474,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
-	wl->block_size = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -3602,7 +3603,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
-	wl->block_size = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 26dcd44..15efe0a 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -51,15 +51,10 @@ static const struct sdio_device_id wl1271_devices[] = {
 };
 MODULE_DEVICE_TABLE(sdio, wl1271_devices);
 
-/* The max SDIO block size is 256 when working with tx padding to SDIO block */
-#define TX_PAD_SDIO_BLK_SIZE                  256
-
-static void wl1271_sdio_set_block_size(struct wl1271 *wl)
+static void wl1271_sdio_set_block_size(struct wl1271 *wl, unsigned int blksz)
 {
-	wl->block_size = TX_PAD_SDIO_BLK_SIZE;
-
 	sdio_claim_host(wl->if_priv);
-	sdio_set_block_size(wl->if_priv, TX_PAD_SDIO_BLK_SIZE);
+	sdio_set_block_size(wl->if_priv, blksz);
 	sdio_release_host(wl->if_priv);
 }
 
@@ -178,9 +173,6 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 
-	/* Set the default block size in case it was modified */
-	sdio_set_block_size(func, 0);
-
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index db9e47e..d422f12 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -127,6 +127,15 @@ u8 wl1271_tx_get_hlid(struct sk_buff *skb)
 	}
 }
 
+static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
+						unsigned int packet_length)
+{
+	if (wl->quirks & WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT)
+		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
+	else
+		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
+}
+
 static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset, u8 hlid)
 {
@@ -152,10 +161,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
-	if (wl->block_size)
-		len = ALIGN(total_len, wl->block_size);
-	else
-		len = total_len;
+	len = wl12xx_calc_packet_alignment(wl, total_len);
 
 	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
 		spare_blocks;
@@ -269,9 +275,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
-	if (wl->block_size) {
-		aligned_len = ALIGN(skb->len, wl->block_size);
+	aligned_len = wl12xx_calc_packet_alignment(wl, skb->len);
 
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
 		desc->length = cpu_to_le16(aligned_len >> 2);
 
@@ -284,8 +290,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	} else {
 		int pad;
 
-		/* align the length (and store in terms of words) */
-		aligned_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+		/* Store the aligned length in terms of words */
 		desc->length = cpu_to_le16(aligned_len >> 2);
 
 		/* calculate number of padding bytes */
@@ -362,10 +367,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	 * In special cases, we want to align to a specific block size
 	 * (eg. for wl128x with SDIO we align to 256).
 	 */
-	if (wl->block_size)
-		total_len = ALIGN(skb->len, wl->block_size);
-	else
-		total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
+	total_len = wl12xx_calc_packet_alignment(wl, skb->len);
 
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index a3877ba..d6b05d9 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -89,6 +89,15 @@ struct wl128x_tx_mem {
 	u8 extra_bytes;
 } __packed;
 
+/*
+ * On wl128x based devices, when TX packets are aggregated, each packet
+ * size must be aligned to the SDIO block size. The maximum block size
+ * is bounded by the type of the padded bytes field that is sent to the
+ * FW. Currently the type is u8, so the maximum block size is 256 bytes.
+ */
+#define WL12XX_BUS_BLOCK_SIZE min(512u,	\
+	    (1u << (8 * sizeof(((struct wl128x_tx_mem *) 0)->extra_bytes))))
+
 struct wl1271_tx_hw_descr {
 	/* Length of packet in words, including descriptor+header+data */
 	__le16 length;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b04481a..14b8bc6 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -322,7 +322,7 @@ struct wl1271_if_operations {
 	struct device* (*dev)(struct wl1271 *wl);
 	void (*enable_irq)(struct wl1271 *wl);
 	void (*disable_irq)(struct wl1271 *wl);
-	void (*set_block_size) (struct wl1271 *wl);
+	void (*set_block_size) (struct wl1271 *wl, unsigned int blksz);
 };
 
 #define MAX_NUM_KEYS 14
@@ -556,7 +556,6 @@ struct wl1271 {
 	bool ba_support;
 	u8 ba_rx_bitmap;
 
-	u32 block_size;
 	int tcxo_clock;
 
 	/*
@@ -608,12 +607,15 @@ int wl1271_plt_stop(struct wl1271 *wl);
 /* Quirks */
 
 /* Each RX/TX transaction requires an end-of-transaction transfer */
-#define WL12XX_QUIRK_END_OF_TRANSACTION	BIT(0)
+#define WL12XX_QUIRK_END_OF_TRANSACTION		BIT(0)
 
 /*
  * Older firmwares use 2 spare TX blocks
  * (for STA < 6.1.3.50.58 or for AP < 6.2.0.0.47)
  */
-#define WL12XX_QUIRK_USE_2_SPARE_BLOCKS BIT(1)
+#define WL12XX_QUIRK_USE_2_SPARE_BLOCKS		BIT(1)
+
+/* WL128X requires aggregated packets to be aligned to the SDIO block size */
+#define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
 
 #endif
-- 
1.7.1

