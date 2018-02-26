Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25647 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbeBZQfu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:35:50 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/8] staging: wilc1000: remove unnecessary while(0) in wilc_wlan_handle_txq()
Date: Mon, 26 Feb 2018 22:01:55 +0530
Message-ID: <1519662722-15761-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173554_047239_A29E472B)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_wlan_handle_txq() by removing unnecessary while(0)
loop. "Line over 80 char" issues in wilc_wlan_handle_txq() are fix by
reducing extra leading tab.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 295 +++++++++++++++++------------------
 1 file changed, 141 insertions(+), 154 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 1a9ef1a..37d6d87 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -583,200 +583,187 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 	txb = wilc->tx_buffer;
 	wilc->txq_exit = 0;
+
+	if (wilc->quit)
+		goto out;
+
+	mutex_lock(&wilc->txq_add_to_head_cs);
+	wilc_wlan_txq_filter_dup_tcp_ack(dev);
+	tqe = wilc_wlan_txq_get_first(wilc);
+	i = 0;
+	sum = 0;
 	do {
-		if (wilc->quit)
-			break;
+		if (tqe && (i < (WILC_VMM_TBL_SIZE - 1))) {
+			if (tqe->type == WILC_CFG_PKT)
+				vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
 
-		mutex_lock(&wilc->txq_add_to_head_cs);
-		wilc_wlan_txq_filter_dup_tcp_ack(dev);
-		tqe = wilc_wlan_txq_get_first(wilc);
-		i = 0;
-		sum = 0;
-		do {
-			if (tqe && (i < (WILC_VMM_TBL_SIZE - 1))) {
-				if (tqe->type == WILC_CFG_PKT)
-					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
+			else if (tqe->type == WILC_NET_PKT)
+				vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 
-				else if (tqe->type == WILC_NET_PKT)
-					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
+			else
+				vmm_sz = HOST_HDR_OFFSET;
 
-				else
-					vmm_sz = HOST_HDR_OFFSET;
+			vmm_sz += tqe->buffer_size;
 
-				vmm_sz += tqe->buffer_size;
+			if (vmm_sz & 0x3)
+				vmm_sz = (vmm_sz + 4) & ~0x3;
 
-				if (vmm_sz & 0x3)
-					vmm_sz = (vmm_sz + 4) & ~0x3;
+			if ((sum + vmm_sz) > LINUX_TX_SIZE)
+				break;
 
-				if ((sum + vmm_sz) > LINUX_TX_SIZE)
-					break;
+			vmm_table[i] = vmm_sz / 4;
+			if (tqe->type == WILC_CFG_PKT)
+				vmm_table[i] |= BIT(10);
+			vmm_table[i] = cpu_to_le32(vmm_table[i]);
 
-				vmm_table[i] = vmm_sz / 4;
-				if (tqe->type == WILC_CFG_PKT)
-					vmm_table[i] |= BIT(10);
-				vmm_table[i] = cpu_to_le32(vmm_table[i]);
+			i++;
+			sum += vmm_sz;
+			tqe = wilc_wlan_txq_get_next(wilc, tqe);
+		} else {
+			break;
+		}
+	} while (1);
 
-				i++;
-				sum += vmm_sz;
-				tqe = wilc_wlan_txq_get_next(wilc, tqe);
-			} else {
-				break;
-			}
-		} while (1);
+	if (i == 0)
+		goto out;
+	vmm_table[i] = 0x0;
 
-		if (i == 0)
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+	counter = 0;
+	func = wilc->hif_func;
+	do {
+		ret = func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
+		if (!ret)
 			break;
-		vmm_table[i] = 0x0;
 
-		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-		counter = 0;
-		func = wilc->hif_func;
-		do {
-			ret = func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
-			if (!ret)
-				break;
+		if ((reg & 0x1) == 0)
+			break;
 
-			if ((reg & 0x1) == 0)
-				break;
+		counter++;
+		if (counter > 200) {
+			counter = 0;
+			ret = func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
+			break;
+		}
+	} while (!wilc->quit);
 
-			counter++;
-			if (counter > 200) {
-				counter = 0;
-				ret = func->hif_write_reg(wilc,
-							  WILC_HOST_TX_CTRL, 0);
-				break;
-			}
-		} while (!wilc->quit);
+	if (!ret)
+		goto _end_;
 
+	timeout = 200;
+	do {
+		ret = func->hif_block_tx(wilc,
+					 WILC_VMM_TBL_RX_SHADOW_BASE,
+					 (u8 *)vmm_table,
+					 ((i + 1) * 4));
 		if (!ret)
-			goto _end_;
+			break;
 
-		timeout = 200;
-		do {
-			ret = func->hif_block_tx(wilc,
-						 WILC_VMM_TBL_RX_SHADOW_BASE,
-						 (u8 *)vmm_table,
-						 ((i + 1) * 4));
-			if (!ret)
-				break;
+		ret = func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x2);
+		if (!ret)
+			break;
 
-			ret = func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x2);
+		do {
+			ret = func->hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
 			if (!ret)
 				break;
-
-			do {
-				ret = func->hif_read_reg(wilc,
-							 WILC_HOST_VMM_CTL,
-							 &reg);
-				if (!ret)
-					break;
-				if ((reg >> 2) & 0x1) {
-					entries = ((reg >> 3) & 0x3f);
-					break;
-				}
-				release_bus(wilc, RELEASE_ALLOW_SLEEP);
-			} while (--timeout);
-			if (timeout <= 0) {
-				ret = func->hif_write_reg(wilc,
-							  WILC_HOST_VMM_CTL,
-							  0x0);
+			if ((reg >> 2) & 0x1) {
+				entries = ((reg >> 3) & 0x3f);
 				break;
 			}
+			release_bus(wilc, RELEASE_ALLOW_SLEEP);
+		} while (--timeout);
+		if (timeout <= 0) {
+			ret = func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
+			break;
+		}
+
+		if (!ret)
+			break;
 
+		if (entries == 0) {
+			ret = func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 			if (!ret)
 				break;
-
-			if (entries == 0) {
-				ret = func->hif_read_reg(wilc,
-							 WILC_HOST_TX_CTRL,
-							 &reg);
-				if (!ret)
-					break;
-				reg &= ~BIT(0);
-				ret = func->hif_write_reg(wilc,
-							  WILC_HOST_TX_CTRL,
-							  reg);
-				if (!ret)
-					break;
+			reg &= ~BIT(0);
+			ret = func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
+			if (!ret)
 				break;
-			}
 			break;
-		} while (1);
+		}
+		break;
+	} while (1);
 
-		if (!ret)
-			goto _end_;
+	if (!ret)
+		goto _end_;
 
-		if (entries == 0) {
-			ret = WILC_TX_ERR_NO_BUF;
-			goto _end_;
-		}
+	if (entries == 0) {
+		ret = WILC_TX_ERR_NO_BUF;
+		goto _end_;
+	}
 
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
-		offset = 0;
-		i = 0;
-		do {
-			tqe = wilc_wlan_txq_remove_from_head(dev);
-			if (tqe && vmm_table[i] != 0) {
-				u32 header, buffer_offset;
-
-				vmm_table[i] = cpu_to_le32(vmm_table[i]);
-				vmm_sz = (vmm_table[i] & 0x3ff);
-				vmm_sz *= 4;
-				header = (tqe->type << 31) |
-					 (tqe->buffer_size << 15) |
-					 vmm_sz;
-				if (tqe->type == WILC_MGMT_PKT)
-					header |= BIT(30);
-				else
-					header &= ~BIT(30);
-
-				header = cpu_to_le32(header);
-				memcpy(&txb[offset], &header, 4);
-				if (tqe->type == WILC_CFG_PKT) {
-					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-				} else if (tqe->type == WILC_NET_PKT) {
-					char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
-
-					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
-					memcpy(&txb[offset + 8], bssid, 6);
-				} else {
-					buffer_offset = HOST_HDR_OFFSET;
-				}
+	offset = 0;
+	i = 0;
+	do {
+		tqe = wilc_wlan_txq_remove_from_head(dev);
+		if (tqe && vmm_table[i] != 0) {
+			u32 header, buffer_offset;
+
+			vmm_table[i] = cpu_to_le32(vmm_table[i]);
+			vmm_sz = (vmm_table[i] & 0x3ff);
+			vmm_sz *= 4;
+			header = (tqe->type << 31) |
+				 (tqe->buffer_size << 15) |
+				 vmm_sz;
+			if (tqe->type == WILC_MGMT_PKT)
+				header |= BIT(30);
+			else
+				header &= ~BIT(30);
 
-				memcpy(&txb[offset + buffer_offset],
-				       tqe->buffer, tqe->buffer_size);
-				offset += vmm_sz;
-				i++;
-				tqe->status = 1;
-				if (tqe->tx_complete_func)
-					tqe->tx_complete_func(tqe->priv,
-							      tqe->status);
-				if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
-				    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
-					pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
-				kfree(tqe);
+			header = cpu_to_le32(header);
+			memcpy(&txb[offset], &header, 4);
+			if (tqe->type == WILC_CFG_PKT) {
+				buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
+			} else if (tqe->type == WILC_NET_PKT) {
+				char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
+
+				buffer_offset = ETH_ETHERNET_HDR_OFFSET;
+				memcpy(&txb[offset + 8], bssid, 6);
 			} else {
-				break;
+				buffer_offset = HOST_HDR_OFFSET;
 			}
-		} while (--entries);
 
-		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
+			memcpy(&txb[offset + buffer_offset],
+			       tqe->buffer, tqe->buffer_size);
+			offset += vmm_sz;
+			i++;
+			tqe->status = 1;
+			if (tqe->tx_complete_func)
+				tqe->tx_complete_func(tqe->priv,
+						      tqe->status);
+			if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
+			    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
+				pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
+			kfree(tqe);
+		} else {
+			break;
+		}
+	} while (--entries);
 
-		ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
-		if (!ret)
-			goto _end_;
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-		ret = func->hif_block_tx_ext(wilc, 0, txb, offset);
-		if (!ret)
-			goto _end_;
+	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
+	if (!ret)
+		goto _end_;
+
+	ret = func->hif_block_tx_ext(wilc, 0, txb, offset);
 
 _end_:
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
-		release_bus(wilc, RELEASE_ALLOW_SLEEP);
-		if (ret != 1)
-			break;
-	} while (0);
+out:
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 
 	wilc->txq_exit = 1;
-- 
2.7.4
