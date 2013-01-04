Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35875 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727Ab3ADFZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:25:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/5] mwifiex: use map/unmap APIs in TX and RX to reduce memcpy
Date: Thu,  3 Jan 2013 21:21:32 -0800
Message-Id: <1357276892-32759-6-git-send-email-bzhao@marvell.com> (sfid-20130104_062552_410101_8C9BEAF6)
In-Reply-To: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
References: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch is an enhacement to mwifiex_pcie driver to use
map/unmap PCI memory APIs. This reduces one memcpy each in TX
path and RX path, and enhances throughput.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    6 +-
 drivers/net/wireless/mwifiex/pcie.c     |  219 ++++++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/pcie.h     |   11 ++
 drivers/net/wireless/mwifiex/txrx.c     |    6 +-
 drivers/net/wireless/mwifiex/wmm.c      |    6 +-
 5 files changed, 193 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 68d52cf..af8fe63 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -278,14 +278,16 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
 			__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		return 0;
 	case -EINPROGRESS:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 19b5a83..3da89b4 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -796,15 +796,15 @@ static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function sends data buffer to device
+ * This function unmaps and frees downloaded data buffer
  */
-static int
-mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 {
+	const u32 num_tx_buffs = MWIFIEX_MAX_TXRX_BD;
+	struct sk_buff *skb;
+	dma_addr_t buf_pa;
+	u32 wrdoneidx, rdptr, unmap_count = 0;
 	struct pcie_service_card *card = adapter->card;
-	u32 wrindx, rdptr;
-	phys_addr_t buf_pa;
-	__le16 *tmp;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -812,34 +812,112 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Read the TX ring read pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
 		dev_err(adapter->dev,
-			"SEND DATA: failed to read REG_TXBD_RDPTR\n");
+			"SEND COMP: failed to read REG_TXBD_RDPTR\n");
 		return -1;
 	}
 
-	wrindx = card->txbd_wrptr & MWIFIEX_TXBD_MASK;
+	dev_dbg(adapter->dev, "SEND COMP: rdptr_prev=0x%x, rdptr=0x%x\n",
+		card->txbd_rdptr, rdptr);
 
-	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n", rdptr,
-		card->txbd_wrptr);
-	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) !=
-			(rdptr & MWIFIEX_TXBD_MASK)) ||
-	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
-			(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
-		struct sk_buff *skb_data;
+	/* free from previous txbd_rdptr to current txbd_rdptr */
+	while (((card->txbd_rdptr & MWIFIEX_TXBD_MASK) !=
+		(rdptr & MWIFIEX_TXBD_MASK)) ||
+	       ((card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
+		(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+		wrdoneidx = card->txbd_rdptr & MWIFIEX_TXBD_MASK;
+
+		skb = card->tx_buf_list[wrdoneidx];
+		if (skb) {
+			dev_dbg(adapter->dev,
+				"SEND COMP: Detach skb %p at txbd_rdidx=%d\n",
+				skb, wrdoneidx);
+			MWIFIEX_SKB_PACB(skb, &buf_pa);
+			pci_unmap_single(card->dev, buf_pa, skb->len,
+					 PCI_DMA_TODEVICE);
+
+			unmap_count++;
+
+			if (card->txbd_flush)
+				mwifiex_write_data_complete(adapter, skb, 0,
+							    -1);
+			else
+				mwifiex_write_data_complete(adapter, skb, 0, 0);
+		}
+
+		card->tx_buf_list[wrdoneidx] = NULL;
+		card->txbd_ring[wrdoneidx]->paddr = 0;
+		card->rxbd_ring[wrdoneidx]->len = 0;
+		card->rxbd_ring[wrdoneidx]->flags = 0;
+		card->txbd_rdptr++;
+
+		if ((card->txbd_rdptr & MWIFIEX_TXBD_MASK) == num_tx_buffs)
+			card->txbd_rdptr = ((card->txbd_rdptr &
+					    MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
+					    MWIFIEX_BD_FLAG_ROLLOVER_IND);
+	}
+
+	if (unmap_count)
+		adapter->data_sent = false;
+
+	if (card->txbd_flush) {
+		if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
+		     (card->txbd_rdptr & MWIFIEX_TXBD_MASK)) &&
+		    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
+		     (card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+			card->txbd_flush = 0;
+		else
+			mwifiex_clean_pcie_ring_buf(adapter);
+	}
+
+	return 0;
+}
+
+/* This function sends data buffer to device. First 4 bytes of payload
+ * are filled with payload length and payload type. Then this payload
+ * is mapped to PCI device memory. Tx ring pointers are advanced accordingly.
+ * Download ready interrupt to FW is deffered if Tx ring is not full and
+ * additional payload can be accomodated.
+ */
+static int
+mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
+		       struct mwifiex_tx_param *tx_param)
+{
+	struct pcie_service_card *card = adapter->card;
+	u32 wrindx;
+	int ret;
+	dma_addr_t buf_pa;
+	__le16 *tmp;
+
+	if (!(skb->data && skb->len)) {
+		dev_err(adapter->dev, "%s(): invalid parameter <%p, %#x>\n",
+			__func__, skb->data, skb->len);
+		return -1;
+	}
+
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		mwifiex_pm_wakeup_card(adapter);
+
+	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n",
+		card->txbd_rdptr, card->txbd_wrptr);
+	if (mwifiex_pcie_txbd_not_full(card)) {
 		u8 *payload;
 
 		adapter->data_sent = true;
-		skb_data = card->tx_buf_list[wrindx];
-		memcpy(skb_data->data, skb->data, skb->len);
-		payload = skb_data->data;
+		payload = skb->data;
 		tmp = (__le16 *)&payload[0];
 		*tmp = cpu_to_le16((u16)skb->len);
 		tmp = (__le16 *)&payload[2];
 		*tmp = cpu_to_le16(MWIFIEX_TYPE_DATA);
-		skb_put(skb_data, MWIFIEX_RX_DATA_BUF_SIZE - skb_data->len);
-		skb_trim(skb_data, skb->len);
-		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
+
+		if (mwifiex_map_pci_memory(adapter, skb, skb->len ,
+					   PCI_DMA_TODEVICE))
+			return -1;
+
+		wrindx = card->txbd_wrptr & MWIFIEX_TXBD_MASK;
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
+		card->tx_buf_list[wrindx] = skb;
 		card->txbd_ring[wrindx]->paddr = buf_pa;
-		card->txbd_ring[wrindx]->len = (u16)skb_data->len;
+		card->txbd_ring[wrindx]->len = (u16)skb->len;
 		card->txbd_ring[wrindx]->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
 						MWIFIEX_BD_FLAG_LAST_DESC;
 
@@ -854,19 +932,28 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 				      card->txbd_wrptr)) {
 			dev_err(adapter->dev,
 				"SEND DATA: failed to write REG_TXBD_WRPTR\n");
-			return 0;
+			ret = -1;
+			goto done_unmap;
 		}
-
-		/* Send the TX ready interrupt */
-		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
-				      CPU_INTR_DNLD_RDY)) {
-			dev_err(adapter->dev,
-				"SEND DATA: failed to assert door-bell intr\n");
-			return -1;
+		if ((mwifiex_pcie_txbd_not_full(card)) &&
+		    tx_param->next_pkt_len) {
+			/* have more packets and TxBD still can hold more */
+			dev_dbg(adapter->dev,
+				"SEND DATA: delay dnld-rdy interrupt.\n");
+			adapter->data_sent = false;
+		} else {
+			/* Send the TX ready interrupt */
+			if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+					      CPU_INTR_DNLD_RDY)) {
+				dev_err(adapter->dev,
+					"SEND DATA: failed to assert dnld-rdy interrupt.\n");
+				ret = -1;
+				goto done_unmap;
+			}
 		}
 		dev_dbg(adapter->dev, "info: SEND DATA: Updated <Rd: %#x, Wr: "
 			"%#x> and sent packet to firmware successfully\n",
-			rdptr, card->txbd_wrptr);
+			card->txbd_rdptr, card->txbd_wrptr);
 	} else {
 		dev_dbg(adapter->dev,
 			"info: TX Ring full, can't send packets to fw\n");
@@ -879,7 +966,15 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -EBUSY;
 	}
 
-	return 0;
+	return -EINPROGRESS;
+done_unmap:
+	MWIFIEX_SKB_PACB(skb, &buf_pa);
+	pci_unmap_single(card->dev, buf_pa, skb->len, PCI_DMA_TODEVICE);
+	card->tx_buf_list[wrindx] = NULL;
+	card->txbd_ring[wrindx]->paddr = 0;
+	card->txbd_ring[wrindx]->len = 0;
+	card->txbd_ring[wrindx]->flags = 0;
+	return ret;
 }
 
 /*
@@ -890,9 +985,13 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	u32 wrptr, rd_index;
+	dma_addr_t buf_pa;
 	int ret = 0;
 	struct sk_buff *skb_tmp = NULL;
 
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		mwifiex_pm_wakeup_card(adapter);
+
 	/* Read the RX ring Write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
 		dev_err(adapter->dev,
@@ -900,6 +999,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		ret = -1;
 		goto done;
 	}
+	card->rxbd_wrptr = wrptr;
 
 	while (((wrptr & MWIFIEX_RXBD_MASK) !=
 		(card->rxbd_rdptr & MWIFIEX_RXBD_MASK)) ||
@@ -907,27 +1007,50 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		(card->rxbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
 		struct sk_buff *skb_data;
 		u16 rx_len;
+		__le16 pkt_len;
 
 		rd_index = card->rxbd_rdptr & MWIFIEX_RXBD_MASK;
 		skb_data = card->rx_buf_list[rd_index];
 
+		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
+		pci_unmap_single(card->dev, buf_pa, MWIFIEX_RX_DATA_BUF_SIZE,
+				 PCI_DMA_FROMDEVICE);
+		card->rx_buf_list[rd_index] = NULL;
+
 		/* Get data length from interface header -
-		   first byte is len, second byte is type */
-		rx_len = *((u16 *)skb_data->data);
+		 * first 2 bytes for len, next 2 bytes is for type
+		 */
+		pkt_len = *((__le16 *)skb_data->data);
+		rx_len = le16_to_cpu(pkt_len);
+		skb_put(skb_data, rx_len);
 		dev_dbg(adapter->dev,
 			"info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
 			card->rxbd_rdptr, wrptr, rx_len);
-		skb_tmp = dev_alloc_skb(rx_len);
+		skb_pull(skb_data, INTF_HEADER_LEN);
+		mwifiex_handle_rx_packet(adapter, skb_data);
+
+		skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
 		if (!skb_tmp) {
-			dev_dbg(adapter->dev,
-				"info: Failed to alloc skb for RX\n");
-			ret = -EBUSY;
-			goto done;
+			dev_err(adapter->dev,
+				"Unable to allocate skb.\n");
+			return -ENOMEM;
 		}
 
-		skb_put(skb_tmp, rx_len);
+		if (mwifiex_map_pci_memory(adapter, skb_tmp,
+					   MWIFIEX_RX_DATA_BUF_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb_tmp, &buf_pa);
+
+		dev_dbg(adapter->dev,
+			"RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
+			skb_tmp, rd_index);
+		card->rx_buf_list[rd_index] = skb_tmp;
+		card->rxbd_ring[rd_index]->paddr = buf_pa;
+		card->rxbd_ring[rd_index]->len = skb_tmp->len;
+		card->rxbd_ring[rd_index]->flags = 0;
 
-		memcpy(skb_tmp->data, skb_data->data + INTF_HEADER_LEN, rx_len);
 		if ((++card->rxbd_rdptr & MWIFIEX_RXBD_MASK) ==
 							MWIFIEX_MAX_TXRX_BD) {
 			card->rxbd_rdptr = ((card->rxbd_rdptr &
@@ -955,12 +1078,10 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		}
 		dev_dbg(adapter->dev,
 			"info: RECV DATA: Rcvd packet from fw successfully\n");
-		mwifiex_handle_rx_packet(adapter, skb_tmp);
+		card->rxbd_wrptr = wrptr;
 	}
 
 done:
-	if (ret && skb_tmp)
-		dev_kfree_skb_any(skb_tmp);
 	return ret;
 }
 
@@ -1732,10 +1853,10 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	while (pcie_ireg & HOST_INTR_MASK) {
 		if (pcie_ireg & HOST_INTR_DNLD_DONE) {
 			pcie_ireg &= ~HOST_INTR_DNLD_DONE;
-			if (adapter->data_sent) {
-				dev_dbg(adapter->dev, "info: DATA sent intr\n");
-				adapter->data_sent = false;
-			}
+			dev_dbg(adapter->dev, "info: TX DNLD Done\n");
+			ret = mwifiex_pcie_send_data_complete(adapter);
+			if (ret)
+				return ret;
 		}
 		if (pcie_ireg & HOST_INTR_UPLD_RDY) {
 			pcie_ireg &= ~HOST_INTR_UPLD_RDY;
@@ -1812,7 +1933,7 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 	}
 
 	if (type == MWIFIEX_TYPE_DATA)
-		return mwifiex_pcie_send_data(adapter, skb);
+		return mwifiex_pcie_send_data(adapter, skb, tx_param);
 	else if (type == MWIFIEX_TYPE_CMD)
 		return mwifiex_pcie_send_cmd(adapter, skb);
 
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 24a39b3..37eeb2c 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -159,4 +159,15 @@ mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
 	return 0;
 }
 
+static inline int
+mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
+{
+	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) !=
+	     (card->txbd_rdptr & MWIFIEX_TXBD_MASK)) ||
+	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
+	     (card->txbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+		return 1;
+
+	return 0;
+}
 #endif /* _MWIFIEX_PCIE_H */
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 8c80024..296faec 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -117,14 +117,16 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
 			ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 		break;
 	case 0:
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6d641cb..135d96d 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1208,13 +1208,15 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 				       ra_list_flags);
 		break;
 	case -1:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 		dev_err(adapter->dev, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		adapter->data_sent = false;
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
 	default:
 		break;
 	}
-- 
1.7.0.2

