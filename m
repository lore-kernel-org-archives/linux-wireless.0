Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42615 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaBHA0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:26:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Aaron Durbin <adurbin@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 09/30] mwifiex: balance dma map/unmap sizes
Date: Fri, 7 Feb 2014 16:25:50 -0800
Message-ID: <1391819151-21073-1-git-send-email-bzhao@marvell.com> (sfid-20140208_012609_991294_3BDD7707)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aaron Durbin <adurbin@chromium.org>

Depending on the underlying DMA implementation its
not possible to partially unmap DMA buffers. Moreover
its not possible to understand the intent of passing
0 as the size to dma unmap. The intent of this
driver is unmap the entire skb buffer. The only way
to ensure that the size matches on unmap is to store
both the dma address and the size in the skb ca field.

Introduce a mwifiex_dma_mapping structure which tracks
the dma address and the size. Additionally, provide
a mwifiex_unmap_pci_memory() that utilizes the new
structure. This also provide symmetry within the
internal API.

Signed-off-by: Aaron Durbin <adurbin@chromium.org>
Reviewed-by: Paul Stewart <pstew@chromium.org>
Reviewed-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 126 ++++++++++++++++--------------------
 drivers/net/wireless/mwifiex/util.h |  20 +++++-
 2 files changed, 72 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 03688aa..4e1c6b2 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -39,20 +39,31 @@ static struct semaphore add_remove_card_sem;
 
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
-		       int size, int flags)
+		       size_t size, int flags)
 {
 	struct pcie_service_card *card = adapter->card;
-	dma_addr_t buf_pa;
+	struct mwifiex_dma_mapping mapping;
 
-	buf_pa = pci_map_single(card->dev, skb->data, size, flags);
-	if (pci_dma_mapping_error(card->dev, buf_pa)) {
+	mapping.addr = pci_map_single(card->dev, skb->data, size, flags);
+	if (pci_dma_mapping_error(card->dev, mapping.addr)) {
 		dev_err(adapter->dev, "failed to map pci memory!\n");
 		return -1;
 	}
-	memcpy(skb->cb, &buf_pa, sizeof(dma_addr_t));
+	mapping.len = size;
+	memcpy(skb->cb, &mapping, sizeof(mapping));
 	return 0;
 }
 
+static void mwifiex_unmap_pci_memory(struct mwifiex_adapter *adapter,
+				     struct sk_buff *skb, int flags)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct mwifiex_dma_mapping mapping;
+
+	MWIFIEX_SKB_PACB(skb, &mapping);
+	pci_unmap_single(card->dev, mapping.addr, mapping.len, flags);
+}
+
 /*
  * This function reads sleep cookie and checks if FW is ready
  */
@@ -456,7 +467,7 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 					   PCI_DMA_FROMDEVICE))
 			return -1;
 
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
+		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
 		dev_dbg(adapter->dev,
 			"info: RX ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
@@ -513,7 +524,7 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 					   PCI_DMA_FROMDEVICE))
 			return -1;
 
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
+		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
 		dev_dbg(adapter->dev,
 			"info: EVT ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
@@ -549,8 +560,8 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 			desc2 = card->txbd_ring[i];
 			if (card->tx_buf_list[i]) {
 				skb = card->tx_buf_list[i];
-				pci_unmap_single(card->dev, desc2->paddr,
-						 skb->len, PCI_DMA_TODEVICE);
+				mwifiex_unmap_pci_memory(adapter, skb,
+							 PCI_DMA_TODEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc2, 0, sizeof(*desc2));
@@ -558,8 +569,8 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
 			desc = card->txbd_ring[i];
 			if (card->tx_buf_list[i]) {
 				skb = card->tx_buf_list[i];
-				pci_unmap_single(card->dev, desc->paddr,
-						 skb->len, PCI_DMA_TODEVICE);
+				mwifiex_unmap_pci_memory(adapter, skb,
+							 PCI_DMA_TODEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc, 0, sizeof(*desc));
@@ -587,8 +598,8 @@ static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 			desc2 = card->rxbd_ring[i];
 			if (card->rx_buf_list[i]) {
 				skb = card->rx_buf_list[i];
-				pci_unmap_single(card->dev, desc2->paddr,
-						 skb->len, PCI_DMA_FROMDEVICE);
+				mwifiex_unmap_pci_memory(adapter, skb,
+							 PCI_DMA_FROMDEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc2, 0, sizeof(*desc2));
@@ -596,8 +607,8 @@ static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
 			desc = card->rxbd_ring[i];
 			if (card->rx_buf_list[i]) {
 				skb = card->rx_buf_list[i];
-				pci_unmap_single(card->dev, desc->paddr,
-						 skb->len, PCI_DMA_FROMDEVICE);
+				mwifiex_unmap_pci_memory(adapter, skb,
+							 PCI_DMA_FROMDEVICE);
 				dev_kfree_skb_any(skb);
 			}
 			memset(desc, 0, sizeof(*desc));
@@ -622,8 +633,8 @@ static void mwifiex_cleanup_evt_ring(struct mwifiex_adapter *adapter)
 		desc = card->evtbd_ring[i];
 		if (card->evt_buf_list[i]) {
 			skb = card->evt_buf_list[i];
-			pci_unmap_single(card->dev, desc->paddr, MAX_EVENT_SIZE,
-					 PCI_DMA_FROMDEVICE);
+			mwifiex_unmap_pci_memory(adapter, skb,
+						 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb_any(skb);
 		}
 		card->evt_buf_list[i] = NULL;
@@ -861,7 +872,6 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card;
-	dma_addr_t buf_pa;
 
 	if (!adapter)
 		return 0;
@@ -869,16 +879,14 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 	card = adapter->card;
 
 	if (card && card->cmdrsp_buf) {
-		MWIFIEX_SKB_PACB(card->cmdrsp_buf, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		mwifiex_unmap_pci_memory(adapter, card->cmdrsp_buf,
+					 PCI_DMA_FROMDEVICE);
 		dev_kfree_skb_any(card->cmdrsp_buf);
 	}
 
 	if (card && card->cmd_buf) {
-		MWIFIEX_SKB_PACB(card->cmd_buf, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, card->cmd_buf->len,
-				 PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, card->cmd_buf,
+					 PCI_DMA_TODEVICE);
 	}
 	return 0;
 }
@@ -956,7 +964,6 @@ static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 {
 	struct sk_buff *skb;
-	dma_addr_t buf_pa;
 	u32 wrdoneidx, rdptr, num_tx_buffs, unmap_count = 0;
 	struct mwifiex_pcie_buf_desc *desc;
 	struct mwifiex_pfu_buf_desc *desc2;
@@ -986,13 +993,13 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 			    reg->tx_start_ptr;
 
 		skb = card->tx_buf_list[wrdoneidx];
+
 		if (skb) {
 			dev_dbg(adapter->dev,
 				"SEND COMP: Detach skb %p at txbd_rdidx=%d\n",
 				skb, wrdoneidx);
-			MWIFIEX_SKB_PACB(skb, &buf_pa);
-			pci_unmap_single(card->dev, buf_pa, skb->len,
-					 PCI_DMA_TODEVICE);
+			mwifiex_unmap_pci_memory(adapter, skb,
+						 PCI_DMA_TODEVICE);
 
 			unmap_count++;
 
@@ -1082,12 +1089,12 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		tmp = (__le16 *)&payload[2];
 		*tmp = cpu_to_le16(MWIFIEX_TYPE_DATA);
 
-		if (mwifiex_map_pci_memory(adapter, skb, skb->len ,
+		if (mwifiex_map_pci_memory(adapter, skb, skb->len,
 					   PCI_DMA_TODEVICE))
 			return -1;
 
 		wrindx = (card->txbd_wrptr & reg->tx_mask) >> reg->tx_start_ptr;
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
+		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 		card->tx_buf_list[wrindx] = skb;
 
 		if (reg->pfu_enabled) {
@@ -1162,8 +1169,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 
 	return -EINPROGRESS;
 done_unmap:
-	MWIFIEX_SKB_PACB(skb, &buf_pa);
-	pci_unmap_single(card->dev, buf_pa, skb->len, PCI_DMA_TODEVICE);
+	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 	card->tx_buf_list[wrindx] = NULL;
 	if (reg->pfu_enabled)
 		memset(desc2, 0, sizeof(*desc2));
@@ -1211,9 +1217,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		rd_index = card->rxbd_rdptr & reg->rx_mask;
 		skb_data = card->rx_buf_list[rd_index];
 
-		MWIFIEX_SKB_PACB(skb_data, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_RX_DATA_BUF_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb_data, PCI_DMA_FROMDEVICE);
 		card->rx_buf_list[rd_index] = NULL;
 
 		/* Get data length from interface header -
@@ -1240,7 +1244,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 					   PCI_DMA_FROMDEVICE))
 			return -1;
 
-		MWIFIEX_SKB_PACB(skb_tmp, &buf_pa);
+		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb_tmp);
 
 		dev_dbg(adapter->dev,
 			"RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
@@ -1316,7 +1320,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	if (mwifiex_map_pci_memory(adapter, skb, skb->len , PCI_DMA_TODEVICE))
 		return -1;
 
-	MWIFIEX_SKB_PACB(skb, &buf_pa);
+	buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
 	/* Write the lower 32bits of the physical address to low command
 	 * address scratch register
@@ -1325,8 +1329,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
 			__func__);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
-				 PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -1338,8 +1341,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		dev_err(adapter->dev,
 			"%s: failed to write download command to boot code.\n",
 			__func__);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
-				 PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -1348,8 +1350,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		dev_err(adapter->dev,
 			"%s: failed to write command len to cmd_size scratch reg\n",
 			__func__);
-		pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
-				 PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -1358,8 +1359,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 			      CPU_INTR_DOOR_BELL)) {
 		dev_err(adapter->dev,
 			"%s: failed to assert door-bell intr\n", __func__);
-		pci_unmap_single(card->dev, buf_pa,
-				 MWIFIEX_UPLD_SIZE, PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
@@ -1433,7 +1433,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	*/
 
 	if (card->cmdrsp_buf) {
-		MWIFIEX_SKB_PACB(card->cmdrsp_buf, &cmdrsp_buf_pa);
+		cmdrsp_buf_pa = MWIFIEX_SKB_DMA_ADDR(card->cmdrsp_buf);
 		/* Write the lower 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_lo,
@@ -1454,7 +1454,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		}
 	}
 
-	MWIFIEX_SKB_PACB(card->cmd_buf, &cmd_buf_pa);
+	cmd_buf_pa = MWIFIEX_SKB_DMA_ADDR(card->cmd_buf);
 	/* Write the lower 32bits of the physical address to reg->cmd_addr_lo */
 	if (mwifiex_write_reg(adapter, reg->cmd_addr_lo,
 			      (u32)cmd_buf_pa)) {
@@ -1508,13 +1508,10 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	int count = 0;
 	u16 rx_len;
 	__le16 pkt_len;
-	dma_addr_t buf_pa;
 
 	dev_dbg(adapter->dev, "info: Rx CMD Response\n");
 
-	MWIFIEX_SKB_PACB(skb, &buf_pa);
-	pci_unmap_single(card->dev, buf_pa, MWIFIEX_UPLD_SIZE,
-			 PCI_DMA_FROMDEVICE);
+	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_FROMDEVICE);
 
 	pkt_len = *((__le16 *)skb->data);
 	rx_len = le16_to_cpu(pkt_len);
@@ -1538,8 +1535,6 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
 					   PCI_DMA_FROMDEVICE))
 			return -1;
-
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
 	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		adapter->curr_cmd->resp_skb = skb;
 		adapter->cmd_resp_received = true;
@@ -1574,7 +1569,6 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 					struct sk_buff *skb)
 {
 	struct pcie_service_card *card = adapter->card;
-	dma_addr_t buf_pa;
 	struct sk_buff *skb_tmp;
 
 	if (skb) {
@@ -1587,9 +1581,7 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 
 	skb_tmp = card->cmd_buf;
 	if (skb_tmp) {
-		MWIFIEX_SKB_PACB(skb_tmp, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, skb_tmp->len,
-				 PCI_DMA_FROMDEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb_tmp, PCI_DMA_FROMDEVICE);
 		card->cmd_buf = NULL;
 	}
 
@@ -1605,7 +1597,6 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr, event;
-	dma_addr_t buf_pa;
 	struct mwifiex_evt_buf_desc *desc;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
@@ -1641,9 +1632,7 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 
 		dev_dbg(adapter->dev, "info: Read Index: %d\n", rdptr);
 		skb_cmd = card->evt_buf_list[rdptr];
-		MWIFIEX_SKB_PACB(skb_cmd, &buf_pa);
-		pci_unmap_single(card->dev, buf_pa, MAX_EVENT_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb_cmd, PCI_DMA_FROMDEVICE);
 
 		/* Take the pointer and set it to event pointer in adapter
 		   and will return back after event handling callback */
@@ -1689,7 +1678,6 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	int ret = 0;
 	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
 	u32 wrptr;
-	dma_addr_t buf_pa;
 	struct mwifiex_evt_buf_desc *desc;
 
 	if (!skb)
@@ -1714,11 +1702,9 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 					   MAX_EVENT_SIZE,
 					   PCI_DMA_FROMDEVICE))
 			return -1;
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		card->evt_buf_list[rdptr] = skb;
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
 		desc = card->evtbd_ring[rdptr];
-		desc->paddr = buf_pa;
+		desc->paddr = MWIFIEX_SKB_DMA_ADDR(skb);
 		desc->len = (u16)skb->len;
 		desc->flags = 0;
 		skb = NULL;
@@ -1768,7 +1754,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	struct sk_buff *skb;
 	u32 txlen, tx_blocks = 0, tries, len;
 	u32 block_retry_cnt = 0;
-	dma_addr_t buf_pa;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
@@ -1866,8 +1851,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			goto done;
 		}
 
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
-
 		/* Wait for the command done interrupt */
 		do {
 			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
@@ -1875,16 +1858,15 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				dev_err(adapter->dev, "%s: Failed to read "
 					"interrupt status during fw dnld.\n",
 					__func__);
-				pci_unmap_single(card->dev, buf_pa, skb->len,
-						 PCI_DMA_TODEVICE);
+				mwifiex_unmap_pci_memory(adapter, skb,
+							 PCI_DMA_TODEVICE);
 				ret = -1;
 				goto done;
 			}
 		} while ((ireg_intr & CPU_INTR_DOOR_BELL) ==
 			 CPU_INTR_DOOR_BELL);
 
-		pci_unmap_single(card->dev, buf_pa, skb->len,
-				 PCI_DMA_TODEVICE);
+		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 
 		offset += txlen;
 	} while (true);
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index cb2d058..ddae570 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -30,8 +30,24 @@ static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
 	return (struct mwifiex_txinfo *)(skb->cb + sizeof(dma_addr_t));
 }
 
-static inline void MWIFIEX_SKB_PACB(struct sk_buff *skb, dma_addr_t *buf_pa)
+struct mwifiex_dma_mapping {
+	dma_addr_t addr;
+	size_t len;
+};
+
+static inline void MWIFIEX_SKB_PACB(struct sk_buff *skb,
+					struct mwifiex_dma_mapping *mapping)
 {
-	memcpy(buf_pa, skb->cb, sizeof(dma_addr_t));
+	memcpy(mapping, skb->cb, sizeof(*mapping));
 }
+
+static inline dma_addr_t MWIFIEX_SKB_DMA_ADDR(struct sk_buff *skb)
+{
+	struct mwifiex_dma_mapping mapping;
+
+	MWIFIEX_SKB_PACB(skb, &mapping);
+
+	return mapping.addr;
+}
+
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.8.2.3

