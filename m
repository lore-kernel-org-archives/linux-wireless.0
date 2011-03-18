Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53204 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760Ab1CROUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:35 -0400
Received: by wwa36 with SMTP id 36so3311144wwa.13
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 10/14] wl12xx: 1281/1283 support - Improve Tx & Rx path
Date: Fri, 18 Mar 2011 16:19:25 +0200
Message-Id: <1300457969-19601-11-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

Reduced bus transactions in the Tx & Rx path.

[Removed unnecessary check wl->chip.id != CHIP_ID_1283_PG20 when
checking the quirk -- Luca]

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/rx.c |   31 +++++++++++++++++++------------
 drivers/net/wireless/wl12xx/tx.c |   30 +++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 919b59f..132b0ca 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -163,18 +163,25 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 			break;
 		}
 
-		/*
-		 * Choose the block we want to read
-		 * For aggregated packets, only the first memory block should
-		 * be retrieved. The FW takes care of the rest.
-		 */
-		mem_block = wl1271_rx_get_mem_block(status, drv_rx_counter);
-		wl->rx_mem_pool_addr.addr = (mem_block << 8) +
-			le32_to_cpu(wl_mem_map->packet_memory_pool_start);
-		wl->rx_mem_pool_addr.addr_extra =
-			wl->rx_mem_pool_addr.addr + 4;
-		wl1271_write(wl, WL1271_SLV_REG_DATA, &wl->rx_mem_pool_addr,
-				sizeof(wl->rx_mem_pool_addr), false);
+		if (wl->chip.id != CHIP_ID_1283_PG20) {
+			/*
+			 * Choose the block we want to read
+			 * For aggregated packets, only the first memory block
+			 * should be retrieved. The FW takes care of the rest.
+			 */
+			mem_block = wl1271_rx_get_mem_block(status,
+							    drv_rx_counter);
+
+			wl->rx_mem_pool_addr.addr = (mem_block << 8) +
+			   le32_to_cpu(wl_mem_map->packet_memory_pool_start);
+
+			wl->rx_mem_pool_addr.addr_extra =
+				wl->rx_mem_pool_addr.addr + 4;
+
+			wl1271_write(wl, WL1271_SLV_REG_DATA,
+				     &wl->rx_mem_pool_addr,
+				     sizeof(wl->rx_mem_pool_addr), false);
+		}
 
 		/* Read all available packets at once */
 		wl1271_read(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index e296f0a..afc8505 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -158,8 +158,14 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
 
-		desc->wl127x_mem.extra_blocks = TX_HW_BLOCK_SPARE;
-		desc->wl127x_mem.total_mem_blocks = total_blocks;
+		/* HW descriptor fields change between wl127x and wl128x */
+		if (wl->chip.id == CHIP_ID_1283_PG20) {
+			desc->wl128x_mem.total_mem_blocks = total_blocks;
+		} else {
+			desc->wl127x_mem.extra_blocks = TX_HW_BLOCK_SPARE;
+			desc->wl127x_mem.total_mem_blocks = total_blocks;
+		}
+
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
@@ -249,6 +255,13 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 
 		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
 		desc->length = cpu_to_le16(aligned_len >> 2);
+
+		wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d "
+			     "tx_attr: 0x%x len: %d life: %d mem: %d",
+			     desc->hlid, tx_attr,
+			     le16_to_cpu(desc->length),
+			     le16_to_cpu(desc->life_time),
+			     desc->wl128x_mem.total_mem_blocks);
 	} else {
 		int pad;
 
@@ -260,16 +273,15 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 		pad = aligned_len - skb->len;
 		tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
 
-		wl1271_debug(DEBUG_TX, "tx_fill_hdr: padding: %d", pad);
+		wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
+			     "tx_attr: 0x%x len: %d life: %d mem: %d", pad,
+			     desc->hlid, tx_attr,
+			     le16_to_cpu(desc->length),
+			     le16_to_cpu(desc->life_time),
+			     desc->wl127x_mem.total_mem_blocks);
 	}
 
 	desc->tx_attr = cpu_to_le16(tx_attr);
-
-	wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d tx_attr: 0x%x "
-		     "len: %d life: %d mem: %d",
-		     desc->hlid, le16_to_cpu(desc->tx_attr),
-		     le16_to_cpu(desc->length),	le16_to_cpu(desc->life_time),
-		     desc->wl127x_mem.total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
-- 
1.7.1

