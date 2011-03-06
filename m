Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47020 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1CFO2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:19 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESIiB015830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:18 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 08/15] wl12xx: 1281/1283 support - Improve Tx & Rx path
Date: Sun,  6 Mar 2011 16:32:13 +0200
Message-Id: <1299421940-26292-9-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduced bus transactions in Tx & Rx path

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/rx.c |   34 +++++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/tx.c |   22 ++++++++++++++++++----
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 919b59f..c95ae19 100644
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
@@ -204,7 +211,8 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 	 * Write the driver's packet counter to the FW. This is only required
 	 * for older hardware revisions
 	 */
-	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+	if ((wl->chip.id != CHIP_ID_1283_PG20) &&
+	    (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION))
 		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 542b785..a7cec1c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -159,8 +159,14 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
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
@@ -265,7 +271,14 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
-	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
+		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
+		le16_to_cpu(desc->tx_attr), le16_to_cpu(desc->length),
+		le16_to_cpu(desc->life_time),
+		desc->wl128x_mem.total_mem_blocks);
+	else
+		wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
 		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, desc->hlid,
 		le16_to_cpu(desc->tx_attr), le16_to_cpu(desc->length),
 		le16_to_cpu(desc->life_time),
@@ -537,7 +550,8 @@ out_ack:
 		 * Interrupt the firmware with the new packets. This is only
 		 * required for older hardware revisions
 		 */
-		if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+		if ((wl->chip.id != CHIP_ID_1283_PG20) &&
+		    (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION))
 			wl1271_write32(wl, WL1271_HOST_WR_ACCESS,
 				       wl->tx_packets_count);
 
-- 
1.7.0.4

