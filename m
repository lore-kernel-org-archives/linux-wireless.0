Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:40482 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbcA2GyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 01:54:17 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 2/6] staging: wilc1000: remove useless log message
Date: Fri, 29 Jan 2016 15:51:34 +0900
Message-ID: <1454050298-25815-2-git-send-email-leo.kim@atmel.com> (sfid-20160129_075425_503421_0902F699)
In-Reply-To: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
References: <1454050298-25815-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove useless log message in wilc_wlan.c file

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 128 ++++++-----------------------------
 1 file changed, 22 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d0a499a..30e3c21 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -104,12 +104,9 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 		wilc->txq_tail = tqe;
 	}
 	wilc->txq_entries += 1;
-	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", wilc->txq_entries);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-	PRINT_D(TX_DBG, "Wake the txq_handling\n");
-
 	up(&wilc->txq_event);
 }
 
@@ -137,12 +134,10 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 		wilc->txq_head = tqe;
 	}
 	wilc->txq_entries += 1;
-	netdev_dbg(vif->ndev, "Number of entries in TxQ = %d\n", wilc->txq_entries);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	up(&wilc->txq_add_to_head_cs);
 	up(&wilc->txq_event);
-	netdev_dbg(vif->ndev, "Wake up the txq_handler\n");
 
 	return 0;
 }
@@ -188,7 +183,6 @@ static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 		ack_session_info[tcp_session].dst_port = dst_prt;
 		tcp_session++;
 	}
-	PRINT_D(TCP_ENH, "TCP Session %d to Ack %d\n", tcp_session, seq);
 	return 0;
 }
 
@@ -310,8 +304,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
-			PRINT_D(TCP_ENH, "DROP ACK: %u\n",
-				pending_acks_info[i].ack_num);
 			tqe = pending_acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(wilc, tqe);
@@ -379,7 +371,6 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-	netdev_dbg(vif->ndev, "Adding the config packet at the Queue tail\n");
 
 	if (wilc_wlan_txq_add_to_head(vif, tqe))
 		return 0;
@@ -408,7 +399,6 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
 
-	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 	if (is_tcp_ack_filter_enabled())
 		tcp_process(dev, tqe);
@@ -438,7 +428,6 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-	PRINT_D(TX_DBG, "Adding Network packet at the Queue tail\n");
 	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return 1;
 }
@@ -478,18 +467,15 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 
 	mutex_lock(&wilc->rxq_cs);
 	if (!wilc->rxq_head) {
-		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
 		wilc->rxq_head = rqe;
 		wilc->rxq_tail = rqe;
 	} else {
-		PRINT_D(RX_DBG, "Add to Queue tail\n");
 		wilc->rxq_tail->next = rqe;
 		rqe->next = NULL;
 		wilc->rxq_tail = rqe;
 	}
 	wilc->rxq_entries += 1;
-	PRINT_D(RX_DBG, "Number of queue entries: %d\n", wilc->rxq_entries);
 	mutex_unlock(&wilc->rxq_cs);
 	return wilc->rxq_entries;
 }
@@ -497,7 +483,6 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 {
 
-	PRINT_D(RX_DBG, "Getting rxQ element\n");
 	if (wilc->rxq_head) {
 		struct rxq_entry_t *rqe;
 
@@ -505,11 +490,9 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 		rqe = wilc->rxq_head;
 		wilc->rxq_head = wilc->rxq_head->next;
 		wilc->rxq_entries -= 1;
-		PRINT_D(RX_DBG, "RXQ entries decreased\n");
 		mutex_unlock(&wilc->rxq_cs);
 		return rqe;
 	}
-	PRINT_D(RX_DBG, "Nothing to get from Q\n");
 	return NULL;
 }
 
@@ -643,7 +626,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 		wilc_wlan_txq_filter_dup_tcp_ack(dev);
-		PRINT_D(TX_DBG, "Getting the head of the TxQ\n");
 		tqe = wilc_wlan_txq_get_first(wilc);
 		i = 0;
 		sum = 0;
@@ -659,27 +641,20 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					vmm_sz = HOST_HDR_OFFSET;
 
 				vmm_sz += tqe->buffer_size;
-				PRINT_D(TX_DBG, "VMM Size before alignment = %d\n", vmm_sz);
+
 				if (vmm_sz & 0x3)
 					vmm_sz = (vmm_sz + 4) & ~0x3;
 
 				if ((sum + vmm_sz) > LINUX_TX_SIZE)
 					break;
 
-				PRINT_D(TX_DBG, "VMM Size AFTER alignment = %d\n", vmm_sz);
 				vmm_table[i] = vmm_sz / 4;
-				PRINT_D(TX_DBG, "VMMTable entry size = %d\n",
-					vmm_table[i]);
-
-				if (tqe->type == WILC_CFG_PKT) {
+				if (tqe->type == WILC_CFG_PKT)
 					vmm_table[i] |= BIT(10);
-					PRINT_D(TX_DBG, "VMMTable entry changed for CFG packet = %d\n", vmm_table[i]);
-				}
 				vmm_table[i] = cpu_to_le32(vmm_table[i]);
 
 				i++;
 				sum += vmm_sz;
-				PRINT_D(TX_DBG, "sum = %d\n", sum);
 				tqe = wilc_wlan_txq_get_next(wilc, tqe);
 			} else {
 				break;
@@ -699,23 +674,18 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			ret = wilc->hif_func->hif_read_reg(wilc,
 							   WILC_HOST_TX_CTRL,
 							   &reg);
-			if (!ret) {
-				wilc_debug(N_ERR, "[wilc txq]: fail can't read reg vmm_tbl_entry..\n");
+			if (!ret)
 				break;
-			}
 
 			if ((reg & 0x1) == 0) {
-				PRINT_D(TX_DBG, "Writing VMM table ... with Size = %d\n", ((i + 1) * 4));
 				break;
 			} else {
 				counter++;
 				if (counter > 200) {
 					counter = 0;
-					PRINT_D(TX_DBG, "Looping in tx ctrl , forcce quit\n");
 					ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
 					break;
 				}
-				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
 			}
 		} while (!wilc->quit);
 
@@ -725,25 +695,19 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		timeout = 200;
 		do {
 			ret = wilc->hif_func->hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
-			if (!ret) {
-				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
+			if (!ret)
 				break;
-			}
 
 			ret = wilc->hif_func->hif_write_reg(wilc,
 							    WILC_HOST_VMM_CTL,
 							    0x2);
-			if (!ret) {
-				wilc_debug(N_ERR, "[wilc txq]: fail can't write reg host_vmm_ctl..\n");
+			if (!ret)
 				break;
-			}
 
 			do {
 				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
-				if (!ret) {
-					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg host_vmm_ctl..\n");
+				if (!ret)
 					break;
-				}
 				if ((reg >> 2) & 0x1) {
 					entries = ((reg >> 3) & 0x3f);
 					break;
@@ -763,16 +727,12 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
 
 				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
-				if (!ret) {
-					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg WILC_HOST_TX_CTRL..\n");
+				if (!ret)
 					break;
-				}
 				reg &= ~BIT(0);
 				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
-				if (!ret) {
-					wilc_debug(N_ERR, "[wilc txq]: fail can't write reg WILC_HOST_TX_CTRL..\n");
+				if (!ret)
 					break;
-				}
 				break;
 			} else {
 				break;
@@ -840,16 +800,12 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 		ret = wilc->hif_func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
-		if (!ret) {
-			wilc_debug(N_ERR, "[wilc txq]: fail can't start tx VMM ...\n");
+		if (!ret)
 			goto _end_;
-		}
 
 		ret = wilc->hif_func->hif_block_tx_ext(wilc, 0, txb, offset);
-		if (!ret) {
-			wilc_debug(N_ERR, "[wilc txq]: fail can't block tx ext...\n");
+		if (!ret)
 			goto _end_;
-		}
 
 _end_:
 
@@ -875,19 +831,15 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 	do {
 		if (wilc->quit) {
-			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
 			up(&wilc->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove(wilc);
-		if (!rqe) {
-			PRINT_D(RX_DBG, "nothing in the queue - exit 1st do-while\n");
+		if (!rqe)
 			break;
-		}
+
 		buffer = rqe->buffer;
 		size = rqe->buffer_size;
-		PRINT_D(RX_DBG, "rxQ entery Size = %d - Address = %p\n",
-			size, buffer);
 		offset = 0;
 
 		do {
@@ -906,10 +858,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			tp_len = (header >> 11) & 0x7ff;
 			pkt_len = header & 0x7ff;
 
-			if (pkt_len == 0 || tp_len == 0) {
-				wilc_debug(N_RXQ, "[wilc rxq]: data corrupt, packet len or tp_len is 0 [%d][%d]\n", pkt_len, tp_len);
+			if (pkt_len == 0 || tp_len == 0)
 				break;
-			}
 
 			#define IS_MANAGMEMENT				0x100
 			#define IS_MANAGMEMENT_CALLBACK			0x080
@@ -935,7 +885,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 					wilc_wlan_cfg_indicate_rx(wilc, &buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
-						PRINT_D(RX_DBG, "wilc->cfg_seq_no = %d - rsp.seq_no = %d\n", wilc->cfg_seq_no, rsp.seq_no);
 						if (wilc->cfg_seq_no == rsp.seq_no)
 							up(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
@@ -977,10 +926,8 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 	else
 		mdelay(WILC_PLL_TO_SPI);
 
-	while (!(ISWILC1000(wilc_get_chipid(wilc, true)) && --trials)) {
-		PRINT_D(TX_DBG, "PLL update retrying\n");
+	while (!(ISWILC1000(wilc_get_chipid(wilc, true)) && --trials))
 		mdelay(1);
-	}
 }
 
 static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
@@ -1000,9 +947,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 	size = ((int_status & 0x7fff) << 2);
 
 	while (!size && retries < 10) {
-		u32 time = 0;
-
-		wilc_debug(N_ERR, "RX Size equal zero ... Trying to read it again for %d time\n", time++);
 		wilc->hif_func->hif_read_size(wilc, &size);
 		size = ((size & 0x7fff) << 2);
 		retries++;
@@ -1012,21 +956,17 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		if (LINUX_RX_SIZE - offset < size)
 			offset = 0;
 
-		if (wilc->rx_buffer) {
+		if (wilc->rx_buffer)
 			buffer = &wilc->rx_buffer[offset];
-		} else {
-			wilc_debug(N_ERR, "[wilc isr]: fail Rx Buffer is NULL...drop the packets (%d)\n", size);
+		else
 			goto _end_;
-		}
 
 		wilc->hif_func->hif_clear_int_ext(wilc,
 					      DATA_INT_CLR | ENABLE_RX_VMM);
 		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
 
-		if (!ret) {
-			wilc_debug(N_ERR, "[wilc isr]: fail block rx...\n");
+		if (!ret)
 			goto _end_;
-		}
 _end_:
 		if (ret) {
 			offset += size;
@@ -1079,12 +1019,9 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
 	if (!dma_buffer) {
 		ret = -EIO;
-		PRINT_ER("Can't allocate buffer for firmware download IO error\n ");
 		goto _fail_1;
 	}
 
-	PRINT_D(INIT_DBG, "Downloading firmware size = %d ...\n", buffer_size);
-
 	offset = 0;
 	do {
 		memcpy(&addr, &buffer[offset], 4);
@@ -1113,7 +1050,6 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 
 		if (!ret) {
 			ret = -EIO;
-			PRINT_ER("Can't download firmware IO error\n ");
 			goto _fail_;
 		}
 		PRINT_D(INIT_DBG, "Offset = %d\n", offset);
@@ -1143,7 +1079,6 @@ int wilc_wlan_start(struct wilc *wilc)
 	acquire_bus(wilc, ACQUIRE_ONLY);
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
-		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
 		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
@@ -1177,7 +1112,6 @@ int wilc_wlan_start(struct wilc *wilc)
 
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_1, reg);
 	if (!ret) {
-		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
@@ -1187,7 +1121,6 @@ int wilc_wlan_start(struct wilc *wilc)
 
 	ret = wilc->hif_func->hif_read_reg(wilc, 0x1000, &chipid);
 	if (!ret) {
-		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
@@ -1223,7 +1156,6 @@ int wilc_wlan_stop(struct wilc *wilc)
 
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if (!ret) {
-		PRINT_ER("Error while reading reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
@@ -1231,7 +1163,6 @@ int wilc_wlan_stop(struct wilc *wilc)
 	reg &= ~BIT(10);
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	if (!ret) {
-		PRINT_ER("Error while writing reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
@@ -1240,34 +1171,24 @@ int wilc_wlan_stop(struct wilc *wilc)
 		ret = wilc->hif_func->hif_read_reg(wilc,
 						   WILC_GLB_RESET_0, &reg);
 		if (!ret) {
-			PRINT_ER("Error while reading reg\n");
 			release_bus(wilc, RELEASE_ALLOW_SLEEP);
 			return ret;
 		}
-		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
-			reg, timeout);
 
 		if ((reg & BIT(10))) {
-			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n",
-				timeout);
 			reg &= ~BIT(10);
 			ret = wilc->hif_func->hif_write_reg(wilc,
 							    WILC_GLB_RESET_0,
 							    reg);
 			timeout--;
 		} else {
-			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n",
-				timeout);
 			ret = wilc->hif_func->hif_read_reg(wilc,
 							   WILC_GLB_RESET_0,
 							   &reg);
 			if (!ret) {
-				PRINT_ER("Error while reading reg\n");
 				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 				return ret;
 			}
-			PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
-				reg, timeout);
 			break;
 		}
 
@@ -1322,17 +1243,14 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GP_REG_0, &reg);
-	if (!ret) {
-		PRINT_ER("Error while reading reg\n");
+	if (!ret)
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
-	}
-	PRINT_ER("Writing ABORT reg\n");
+
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | ABORT_INT));
-	if (!ret) {
-		PRINT_ER("Error while writing reg\n");
+	if (!ret)
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
-	}
+
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	wilc->hif_func->hif_deinit(NULL);
 }
@@ -1437,7 +1355,6 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
 			netdev_dbg(vif->ndev, "Get Timed Out\n");
 			ret_size = 0;
 		}
-		netdev_dbg(vif->ndev, "[WILC]Get Response received\n");
 		wilc->cfg_frame_in_use = 0;
 		wilc->cfg_frame_offset = 0;
 		wilc->cfg_seq_no += 1;
@@ -1589,7 +1506,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
-	PRINT_D(TX_DBG, "wilc->tx_buffer = %p\n", wilc->tx_buffer);
 
 	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
@@ -1599,7 +1515,7 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->rx_buffer)
 		wilc->rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
-	PRINT_D(TX_DBG, "wilc->rx_buffer =%p\n", wilc->rx_buffer);
+
 	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
 		PRINT_ER("Can't allocate Rx Buffer");
-- 
1.9.1

