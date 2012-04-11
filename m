Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:37244 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933005Ab2DKTxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:55 -0400
Received: by lbbgf7 with SMTP id gf7so1044140lbb.29
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 03/24] wlcore/wl12xx: add hw op for calculating hw block count per packet
Date: Wed, 11 Apr 2012 22:53:19 +0300
Message-Id: <1334174020-18957-4-git-send-email-coelho@ti.com> (sfid-20120411_215456_539378_EA36CA2D)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Each chip family has a different block size and calculates the total
number of HW blocks differently, with respect to alignment.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   11 +++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |   37 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |   18 ++++++---------
 drivers/net/wireless/ti/wlcore/tx.h     |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 5 files changed, 58 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wlcore/hw_ops.h

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 3447cef..e1bdeae 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -30,12 +30,14 @@
 #include "../wlcore/debug.h"
 #include "../wlcore/io.h"
 #include "../wlcore/acx.h"
+#include "../wlcore/tx.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"
 
 #define WL12XX_TX_HW_BLOCK_SPARE_DEFAULT        1
 #define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
+#define WL12XX_TX_HW_BLOCK_SIZE                 252
 
 
 static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
@@ -587,6 +589,14 @@ static void wl12xx_ack_event(struct wl1271 *wl)
 	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_EVENT_ACK);
 }
 
+static u32 wl12xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
+{
+	u32 blk_size = WL12XX_TX_HW_BLOCK_SIZE;
+	u32 align_len = wlcore_calc_packet_alignment(wl, len);
+
+	return (align_len + blk_size - 1) / blk_size + spare_blks;
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -655,6 +665,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.boot		= wl12xx_boot,
 	.trigger_cmd	= wl12xx_trigger_cmd,
 	.ack_event	= wl12xx_ack_event,
+	.calc_tx_blocks = wl12xx_calc_tx_blocks,
 	.get_pg_ver	= wl12xx_get_pg_ver,
 	.get_mac	= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
new file mode 100644
index 0000000..904897c
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -0,0 +1,37 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WLCORE_HW_OPS_H__
+#define __WLCORE_HW_OPS_H__
+
+#include "wlcore.h"
+
+static inline u32
+wlcore_hw_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
+{
+	if (!wl->ops->calc_tx_blocks)
+		BUG_ON(1);
+
+	return wl->ops->calc_tx_blocks(wl, len, spare_blks);
+}
+
+#endif
+
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 3306990..3891f96 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -31,6 +31,7 @@
 #include "ps.h"
 #include "tx.h"
 #include "event.h"
+#include "hw_ops.h"
 
 /*
  * TODO: this is here just for now, it must be removed when the data
@@ -172,14 +173,15 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return wlvif->dev_hlid;
 }
 
-static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
-						unsigned int packet_length)
+unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
+					  unsigned int packet_length)
 {
 	if (wl->quirks & WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT)
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
 	else
 		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
 }
+EXPORT_SYMBOL(wlcore_calc_packet_alignment);
 
 static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      struct sk_buff *skb, u32 extra, u32 buf_offset,
@@ -187,7 +189,6 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
-	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY, ac;
 	u32 spare_blocks = wl->normal_tx_spare;
@@ -201,17 +202,12 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (id < 0)
 		return id;
 
-	/* approximate the number of blocks required for this packet
-	   in the firmware */
-	len = wl12xx_calc_packet_alignment(wl, total_len);
-
 	if (unlikely(wl12xx_is_dummy_packet(wl, skb)))
 		is_dummy = true;
 	else if (wlvif->is_gem)
 		spare_blocks = wl->gem_tx_spare;
 
-	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
-		spare_blocks;
+	total_blocks = wlcore_hw_calc_tx_blocks(wl, total_len, spare_blocks);
 
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
@@ -335,7 +331,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
-	aligned_len = wl12xx_calc_packet_alignment(wl, skb->len);
+	aligned_len = wlcore_calc_packet_alignment(wl, skb->len);
 
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
@@ -436,7 +432,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 * In special cases, we want to align to a specific block size
 	 * (eg. for wl128x with SDIO we align to 256).
 	 */
-	total_len = wl12xx_calc_packet_alignment(wl, skb->len);
+	total_len = wlcore_calc_packet_alignment(wl, skb->len);
 
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 2ad7705..4b01c87 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -25,8 +25,6 @@
 #ifndef __TX_H__
 #define __TX_H__
 
-#define TX_HW_BLOCK_SIZE                 252
-
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
 #define TX_HW_AP_MODE_PKT_LIFETIME_TU    8000
 
@@ -223,6 +221,8 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
 void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
+unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
+					  unsigned int packet_length);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 2fb713a..e3d5d73 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -35,6 +35,7 @@ struct wlcore_ops {
 	int (*boot)(struct wl1271 *wl);
 	void (*trigger_cmd)(struct wl1271 *wl);
 	void (*ack_event)(struct wl1271 *wl);
+	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

