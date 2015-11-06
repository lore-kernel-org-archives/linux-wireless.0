Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37657 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031547AbbKFCRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:34 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 55/73] staging: wilc1000: remove warnings line over 80 characters
Date: Fri, 6 Nov 2015 11:19:54 +0900
Message-ID: <1446776412-30670-6-git-send-email-glen.lee@atmel.com> (sfid-20151106_031751_266099_1B24838C)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the warnings reported by checkpatch.pl
for line over 80 characters.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 50 ++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 70d794b..ffe7baa 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -361,7 +361,8 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 				dropped_acks++;
 				tqe->status = 1;
 				if (tqe->tx_complete_func)
-					tqe->tx_complete_func(tqe->priv, tqe->status);
+					tqe->tx_complete_func(tqe->priv,
+							      tqe->status);
 				kfree(tqe);
 				dropped++;
 			}
@@ -747,7 +748,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 				PRINT_D(TX_DBG, "VMM Size AFTER alignment = %d\n", vmm_sz);
 				vmm_table[i] = vmm_sz / 4;
-				PRINT_D(TX_DBG, "VMMTable entry size = %d\n", vmm_table[i]);
+				PRINT_D(TX_DBG, "VMMTable entry size = %d\n",
+					vmm_table[i]);
 
 				if (tqe->type == WILC_CFG_PKT) {
 					vmm_table[i] |= BIT(10);
@@ -883,7 +885,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 #endif
 				vmm_sz = (vmm_table[i] & 0x3ff);
 				vmm_sz *= 4;
-				header = (tqe->type << 31) | (tqe->buffer_size << 15) | vmm_sz;
+				header = (tqe->type << 31) |
+					 (tqe->buffer_size << 15) |
+					 vmm_sz;
 				if (tqe->type == WILC_MGMT_PKT)
 					header |= BIT(30);
 				else
@@ -904,12 +908,14 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					buffer_offset = HOST_HDR_OFFSET;
 				}
 
-				memcpy(&txb[offset + buffer_offset], tqe->buffer, tqe->buffer_size);
+				memcpy(&txb[offset + buffer_offset],
+				       tqe->buffer, tqe->buffer_size);
 				offset += vmm_sz;
 				i++;
 				tqe->status = 1;
 				if (tqe->tx_complete_func)
-					tqe->tx_complete_func(tqe->priv, tqe->status);
+					tqe->tx_complete_func(tqe->priv,
+							      tqe->status);
 				#ifdef TCP_ACK_FILTER
 				if (tqe->index != NOT_TCP_ACK)
 					pending_acks_info[tqe->index].txqe = NULL;
@@ -970,7 +976,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 		}
 		buffer = rqe->buffer;
 		size = rqe->buffer_size;
-		PRINT_D(RX_DBG, "rxQ entery Size = %d - Address = %p\n", size, buffer);
+		PRINT_D(RX_DBG, "rxQ entery Size = %d - Address = %p\n",
+			size, buffer);
 		offset = 0;
 
 		do {
@@ -983,7 +990,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 #ifdef BIG_ENDIAN
 			header = BYTE_SWAP(header);
 #endif
-			PRINT_D(RX_DBG, "Header = %04x - Offset = %d\n", header, offset);
+			PRINT_D(RX_DBG, "Header = %04x - Offset = %d\n",
+				header, offset);
 
 			is_cfg_packet = (header >> 31) & 0x1;
 			pkt_offset = (header >> 22) & 0x1ff;
@@ -1000,7 +1008,9 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			#define IS_MGMT_STATUS_SUCCES			0x040
 
 			if (pkt_offset & IS_MANAGMEMENT) {
-				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
+				pkt_offset &= ~(IS_MANAGMEMENT |
+						IS_MANAGMEMENT_CALLBACK |
+						IS_MGMT_STATUS_SUCCES);
 
 				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
 			} else {
@@ -1356,22 +1366,26 @@ int wilc_wlan_stop(void)
 			release_bus(RELEASE_ALLOW_SLEEP);
 			return ret;
 		}
-		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n", reg, timeout);
+		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
+			reg, timeout);
 
 		if ((reg & BIT(10))) {
-			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n", timeout);
+			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n",
+				timeout);
 			reg &= ~BIT(10);
 			ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 			timeout--;
 		} else {
-			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n", timeout);
+			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n",
+				timeout);
 			ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
 				release_bus(RELEASE_ALLOW_SLEEP);
 				return ret;
 			}
-			PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n", reg, timeout);
+			PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
+				reg, timeout);
 			break;
 		}
 
@@ -1492,7 +1506,8 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 	p->cfg_frame_offset = offset;
 
 	if (commit) {
-		PRINT_D(TX_DBG, "[WILC]PACKET Commit with sequence number %d\n", p->cfg_seq_no);
+		PRINT_D(TX_DBG, "[WILC]PACKET Commit with sequence number %d\n",
+			p->cfg_seq_no);
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
 		p->cfg_frame_in_use = 1;
 
@@ -1641,21 +1656,24 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
 	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
-	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
+	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func,
+	       sizeof(wilc_wlan_io_func_t));
 
 	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
 		if (!hif_sdio.hif_init(inp, wilc_debug)) {
 			ret = -5;
 			goto _fail_;
 		}
-		memcpy((void *)&g_wlan.hif_func, &hif_sdio, sizeof(wilc_hif_func_t));
+		memcpy((void *)&g_wlan.hif_func, &hif_sdio,
+		       sizeof(wilc_hif_func_t));
 	} else {
 		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
 			if (!hif_spi.hif_init(inp, wilc_debug)) {
 				ret = -5;
 				goto _fail_;
 			}
-			memcpy((void *)&g_wlan.hif_func, &hif_spi, sizeof(wilc_hif_func_t));
+			memcpy((void *)&g_wlan.hif_func, &hif_spi,
+			       sizeof(wilc_hif_func_t));
 		} else {
 			ret = -5;
 			goto _fail_;
-- 
1.9.1

