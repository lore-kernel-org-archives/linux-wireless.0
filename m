Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35381 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdEEMI2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 08:08:28 -0400
Received: by mail-pg0-f65.google.com with SMTP id i63so580139pgd.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 05:08:28 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 1/6] mwifiex: use variable interface header length
Date: Fri,  5 May 2017 12:08:15 +0000
Message-Id: <1493986100-24509-1-git-send-email-huxinming820@gmail.com> (sfid-20170505_140833_973194_36675B87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Usb tx aggregation feature will utilize 4-bytes bus interface header,
otherwise it will be set to zero in default case.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: same as v1
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c |  2 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c   |  8 ++++----
 drivers/net/wireless/marvell/mwifiex/init.c     |  5 +++++
 drivers/net/wireless/marvell/mwifiex/main.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c     | 19 ++++++++++---------
 drivers/net/wireless/marvell/mwifiex/sdio.c     | 12 ++++++------
 drivers/net/wireless/marvell/mwifiex/sta_tx.c   | 12 ++++++------
 drivers/net/wireless/marvell/mwifiex/txrx.c     | 11 +++--------
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c |  5 ++---
 9 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index a75013a..e8ffb26 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -164,7 +164,7 @@
 	int pad = 0, aggr_num = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
-	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
+	int headroom = adapter->intf_hdr_len;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 0c3b217..d62f729 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -258,10 +258,10 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		if (ret == -EBUSY)
 			cmd_node->cmd_skb = NULL;
 	} else {
-		skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
+		skb_push(cmd_node->cmd_skb, adapter->intf_hdr_len);
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
 						   cmd_node->cmd_skb, NULL);
-		skb_pull(cmd_node->cmd_skb, INTF_HEADER_LEN);
+		skb_pull(cmd_node->cmd_skb, adapter->intf_hdr_len);
 	}
 
 	if (ret == -1) {
@@ -351,10 +351,10 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		if (ret != -EBUSY)
 			dev_kfree_skb_any(sleep_cfm_tmp);
 	} else {
-		skb_push(adapter->sleep_cfm, INTF_HEADER_LEN);
+		skb_push(adapter->sleep_cfm, adapter->intf_hdr_len);
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
 						   adapter->sleep_cfm, NULL);
-		skb_pull(adapter->sleep_cfm, INTF_HEADER_LEN);
+		skb_pull(adapter->sleep_cfm, adapter->intf_hdr_len);
 	}
 
 	if (ret == -1) {
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 7569483..0710b917 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -217,6 +217,11 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	else
 		adapter->data_sent = false;
 
+	if (adapter->iface_type == MWIFIEX_USB)
+		adapter->intf_hdr_len = 0;
+	else
+		adapter->intf_hdr_len = INTF_HEADER_LEN;
+
 	adapter->cmd_resp_received = false;
 	adapter->event_received = false;
 	adapter->data_received = false;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index bb2a467..96d1bbe 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -849,6 +849,7 @@ struct mwifiex_adapter {
 	u8 perm_addr[ETH_ALEN];
 	bool surprise_removed;
 	u32 fw_release_number;
+	u8 intf_hdr_len;
 	u16 init_wait_q_woken;
 	wait_queue_head_t init_wait_q;
 	void *card;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ac62bce..189c76d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1391,7 +1391,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		 * first 2 bytes for len, next 2 bytes is for type
 		 */
 		rx_len = get_unaligned_le16(skb_data->data);
-		if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
+		if (WARN_ON(rx_len <= adapter->intf_hdr_len ||
 			    rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
 			mwifiex_dbg(adapter, ERROR,
 				    "Invalid RX len %d, Rd=%#x, Wr=%#x\n",
@@ -1402,7 +1402,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 			mwifiex_dbg(adapter, DATA,
 				    "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
 				    card->rxbd_rdptr, wrptr, rx_len);
-			skb_pull(skb_data, INTF_HEADER_LEN);
+			skb_pull(skb_data, adapter->intf_hdr_len);
 			if (adapter->rx_work_enabled) {
 				skb_queue_tail(&adapter->rx_data_q, skb_data);
 				adapter->data_received = true;
@@ -1736,7 +1736,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 						       MWIFIEX_MAX_DELAY_COUNT);
 			mwifiex_unmap_pci_memory(adapter, skb,
 						 PCI_DMA_FROMDEVICE);
-			skb_pull(skb, INTF_HEADER_LEN);
+			skb_pull(skb, adapter->intf_hdr_len);
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
@@ -1749,12 +1749,12 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		}
 		memcpy(adapter->upld_buf, skb->data,
 		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
-		skb_push(skb, INTF_HEADER_LEN);
+		skb_push(skb, adapter->intf_hdr_len);
 		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
 					   PCI_DMA_FROMDEVICE))
 			return -1;
 	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
-		skb_pull(skb, INTF_HEADER_LEN);
+		skb_pull(skb, adapter->intf_hdr_len);
 		adapter->curr_cmd->resp_skb = skb;
 		adapter->cmd_resp_received = true;
 		/* Take the pointer and set it to CMD node and will
@@ -1791,7 +1791,7 @@ static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
 
 	if (skb) {
 		card->cmdrsp_buf = skb;
-		skb_push(card->cmdrsp_buf, INTF_HEADER_LEN);
+		skb_push(card->cmdrsp_buf, adapter->intf_hdr_len);
 		if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
 					   PCI_DMA_FROMDEVICE))
 			return -1;
@@ -1856,14 +1856,15 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		desc = card->evtbd_ring[rdptr];
 		memset(desc, 0, sizeof(*desc));
 
-		event = get_unaligned_le32(&skb_cmd->data[INTF_HEADER_LEN]);
+		event = get_unaligned_le32(
+			&skb_cmd->data[adapter->intf_hdr_len]);
 		adapter->event_cause = event;
 		/* The first 4bytes will be the event transfer header
 		   len is 2 bytes followed by type which is 2 bytes */
 		memcpy(&data_len, skb_cmd->data, sizeof(__le16));
 		evt_len = le16_to_cpu(data_len);
 		skb_trim(skb_cmd, evt_len);
-		skb_pull(skb_cmd, INTF_HEADER_LEN);
+		skb_pull(skb_cmd, adapter->intf_hdr_len);
 		mwifiex_dbg(adapter, EVENT,
 			    "info: Event length: %d\n", evt_len);
 
@@ -1922,7 +1923,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	}
 
 	if (!card->evt_buf_list[rdptr]) {
-		skb_push(skb, INTF_HEADER_LEN);
+		skb_push(skb, adapter->intf_hdr_len);
 		skb_put(skb, MAX_EVENT_SIZE - skb->len);
 		if (mwifiex_map_pci_memory(adapter, skb,
 					   MAX_EVENT_SIZE,
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 0af1c67..8e6706f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1125,7 +1125,7 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 	data = skb->data;
 	total_pkt_len = skb->len;
 
-	while (total_pkt_len >= (SDIO_HEADER_OFFSET + INTF_HEADER_LEN)) {
+	while (total_pkt_len >= (SDIO_HEADER_OFFSET + adapter->intf_hdr_len)) {
 		if (total_pkt_len < adapter->sdio_rx_block_size)
 			break;
 		blk_num = *(data + BLOCK_NUMBER_OFFSET);
@@ -1152,7 +1152,7 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 			break;
 		skb_put(skb_deaggr, pkt_len);
 		memcpy(skb_deaggr->data, data + SDIO_HEADER_OFFSET, pkt_len);
-		skb_pull(skb_deaggr, INTF_HEADER_LEN);
+		skb_pull(skb_deaggr, adapter->intf_hdr_len);
 
 		mwifiex_handle_rx_packet(adapter, skb_deaggr);
 		data += blk_size;
@@ -1178,7 +1178,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 
 	if (upld_typ != MWIFIEX_TYPE_AGGR_DATA) {
 		skb_trim(skb, pkt_len);
-		skb_pull(skb, INTF_HEADER_LEN);
+		skb_pull(skb, adapter->intf_hdr_len);
 	}
 
 	switch (upld_typ) {
@@ -1537,7 +1537,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		rx_len = card->mp_regs[reg->cmd_rd_len_1] << 8;
 		rx_len |= (u16)card->mp_regs[reg->cmd_rd_len_0];
 		rx_blocks = DIV_ROUND_UP(rx_len, MWIFIEX_SDIO_BLOCK_SIZE);
-		if (rx_len <= INTF_HEADER_LEN ||
+		if (rx_len <= adapter->intf_hdr_len ||
 		    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 		     MWIFIEX_RX_DATA_BUF_SIZE)
 			return -1;
@@ -1635,7 +1635,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			rx_blocks =
 				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
-			if (rx_len <= INTF_HEADER_LEN ||
+			if (rx_len <= adapter->intf_hdr_len ||
 			    (card->mpa_rx.enabled &&
 			     ((rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 			      card->mpa_rx.buf_size))) {
@@ -1896,7 +1896,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		adapter->cmd_sent = true;
 		/* Type must be MWIFIEX_TYPE_CMD */
 
-		if (pkt_len <= INTF_HEADER_LEN ||
+		if (pkt_len <= adapter->intf_hdr_len ||
 		    pkt_len > MWIFIEX_UPLD_SIZE)
 			mwifiex_dbg(adapter, ERROR,
 				    "%s: payload=%p, nb=%d\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_tx.c b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
index f6683ea..620f865 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
@@ -49,8 +49,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 	unsigned int pad;
 	u16 pkt_type, pkt_offset;
-	int hroom = (priv->adapter->iface_type == MWIFIEX_USB) ? 0 :
-		       INTF_HEADER_LEN;
+	int hroom = adapter->intf_hdr_len;
 
 	if (!skb->len) {
 		mwifiex_dbg(adapter, ERROR,
@@ -116,7 +115,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 
 	local_tx_pd->tx_pkt_offset = cpu_to_le16(pkt_offset);
 
-	/* make space for INTF_HEADER_LEN */
+	/* make space for adapter->intf_hdr_len */
 	skb_push(skb, hroom);
 
 	if (!local_tx_pd->tx_control)
@@ -165,8 +164,9 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
-	tx_info->pkt_len = data_len - (sizeof(struct txpd) + INTF_HEADER_LEN);
-	skb_reserve(skb, sizeof(struct txpd) + INTF_HEADER_LEN);
+	tx_info->pkt_len = data_len -
+			(sizeof(struct txpd) + adapter->intf_hdr_len);
+	skb_reserve(skb, sizeof(struct txpd) + adapter->intf_hdr_len);
 	skb_push(skb, sizeof(struct txpd));
 
 	local_tx_pd = (struct txpd *) skb->data;
@@ -177,11 +177,11 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 
+	skb_push(skb, adapter->intf_hdr_len);
 	if (adapter->iface_type == MWIFIEX_USB) {
 		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
 						   skb, NULL);
 	} else {
-		skb_push(skb, INTF_HEADER_LEN);
 		tx_param.next_pkt_len = 0;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 						   skb, &tx_param);
diff --git a/drivers/net/wireless/marvell/mwifiex/txrx.c b/drivers/net/wireless/marvell/mwifiex/txrx.c
index fac28bd..15e92af 100644
--- a/drivers/net/wireless/marvell/mwifiex/txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/txrx.c
@@ -91,7 +91,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	struct mwifiex_sta_node *dest_node;
 	struct ethhdr *hdr = (void *)skb->data;
 
-	hroom = (adapter->iface_type == MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
+	hroom = adapter->intf_hdr_len;
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP) {
 		dest_node = mwifiex_get_sta_entry(priv, hdr->h_dest);
@@ -179,13 +179,8 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 		mwifiex_write_data_complete(adapter, skb, 0, 0);
 		return ret;
 	}
-	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
-		if (adapter->iface_type == MWIFIEX_USB)
-			local_tx_pd = (struct txpd *)head_ptr;
-		else
-			local_tx_pd = (struct txpd *) (head_ptr +
-				INTF_HEADER_LEN);
-	}
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+		local_tx_pd = (struct txpd *)(head_ptr + adapter->intf_hdr_len);
 
 	if (adapter->iface_type == MWIFIEX_USB) {
 		ret = adapter->if_ops.host_to_card(adapter,
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index bf5660e..1e6a62c 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -468,8 +468,7 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 	int pad;
 	u16 pkt_type, pkt_offset;
-	int hroom = (priv->adapter->iface_type == MWIFIEX_USB) ? 0 :
-		       INTF_HEADER_LEN;
+	int hroom = adapter->intf_hdr_len;
 
 	if (!skb->len) {
 		mwifiex_dbg(adapter, ERROR,
@@ -521,7 +520,7 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 
 	txpd->tx_pkt_offset = cpu_to_le16(pkt_offset);
 
-	/* make space for INTF_HEADER_LEN */
+	/* make space for adapter->intf_hdr_len */
 	skb_push(skb, hroom);
 
 	if (!txpd->tx_control)
-- 
1.9.1
