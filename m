Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48466 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1BOBpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 20:45:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH] mwifiex: remove struct mwifiex_buffer and associated
Date: Mon, 14 Feb 2011 17:47:21 -0800
Message-Id: <1297734441-31200-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

mwifiex will now use sk_buff instead of mwifiex_buffer and make
use of skb->cb for storing and retrieving extra information.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c      |  251 ++++++++++--------------
 drivers/net/wireless/mwifiex/11n_aggr.h      |    2 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |  130 +++++--------
 drivers/net/wireless/mwifiex/decl.h          |   30 +--
 drivers/net/wireless/mwifiex/fw.h            |    5 +
 drivers/net/wireless/mwifiex/init.c          |   27 ++--
 drivers/net/wireless/mwifiex/main.c          |   32 ++--
 drivers/net/wireless/mwifiex/main.h          |   45 ++---
 drivers/net/wireless/mwifiex/sdio.c          |  254 ++++++++++---------------
 drivers/net/wireless/mwifiex/sdio.h          |   21 +-
 drivers/net/wireless/mwifiex/sta_rx.c        |   93 ++-------
 drivers/net/wireless/mwifiex/sta_tx.c        |   87 ++++------
 drivers/net/wireless/mwifiex/txrx.c          |  106 ++++++-----
 drivers/net/wireless/mwifiex/util.c          |  264 ++++----------------------
 drivers/net/wireless/mwifiex/util.h          |    9 +
 drivers/net/wireless/mwifiex/wmm.c           |  160 +++++++---------
 drivers/net/wireless/mwifiex/wmm.h           |   27 +--
 19 files changed, 553 insertions(+), 994 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 56f4531..b122f2c 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -40,12 +40,17 @@
  *
  * This function also computes the amount of padding required to make the
  * buffer length multiple of 4 bytes.
+ *
+ * Data => |DA|SA|SNAP-TYPE|........    .|
+ * MSDU => |DA|SA|Length|SNAP|......   ..|
  */
 static int
-mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter, u8 *amsdu_buf,
-			   u8 *data, int pkt_len, int *pad)
+mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter,
+			   struct sk_buff *skb_aggr,
+			   struct sk_buff *skb_src, int *pad)
+
 {
-	int dt_offset, amsdu_buf_offset;
+	int dt_offset;
 	struct rfc_1042_hdr snap = {
 		0xaa,		/* LLC DSAP */
 		0xaa,		/* LLC SSAP */
@@ -57,30 +62,39 @@ mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter, u8 *amsdu_buf,
 			 * later with ethertype
 			 */
 	};
+	struct tx_packet_hdr *tx_header = NULL;
 
 	ENTER();
 
-	memcpy(amsdu_buf, data, (MWIFIEX_MAC_ADDR_LENGTH) * 2);
-	amsdu_buf_offset = (MWIFIEX_MAC_ADDR_LENGTH) * 2;
-	dt_offset = amsdu_buf_offset;
+	skb_put(skb_aggr, sizeof(*tx_header));
+
+	tx_header = (struct tx_packet_hdr *) skb_aggr->data;
 
-	snap.snap_type = *(u16 *) (data + dt_offset);
+	/* Copy DA and SA */
+	dt_offset = 2 * ETH_ALEN;
+	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
+
+	/* Copy SNAP header */
+	snap.snap_type = *(u16 *) ((u8 *)skb_src->data + dt_offset);
 	dt_offset += sizeof(u16);
-	*(__be16 *) (amsdu_buf + amsdu_buf_offset) =
-		htons(pkt_len + LLC_SNAP_LEN - ((2 * MWIFIEX_MAC_ADDR_LENGTH)
-						+ sizeof(u16)));
-	amsdu_buf_offset += sizeof(u16);
-	memcpy(amsdu_buf + amsdu_buf_offset, &snap, LLC_SNAP_LEN);
-	amsdu_buf_offset += LLC_SNAP_LEN;
-
-	memcpy(amsdu_buf + amsdu_buf_offset, data + dt_offset,
-	       pkt_len - dt_offset);
-	*pad = (((pkt_len + LLC_SNAP_LEN) & 3)) ? (4 -
-						   (((pkt_len +
+
+	memcpy(&tx_header->rfc1042_hdr, &snap, sizeof(struct rfc_1042_hdr));
+
+	skb_pull(skb_src, dt_offset);
+
+	/* Update Length field */
+	tx_header->eth803_hdr.h_proto = htons(skb_src->len + LLC_SNAP_LEN);
+
+	/* Add payload */
+	skb_put(skb_aggr, skb_src->len);
+	memcpy(skb_aggr->data + sizeof(*tx_header), skb_src->data,
+							skb_src->len);
+	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
 						      LLC_SNAP_LEN)) & 3)) : 0;
+	skb_put(skb_aggr, *pad);
 
 	LEAVE();
-	return pkt_len + LLC_SNAP_LEN + *pad;
+	return skb_aggr->len + *pad;
 }
 
 /*
@@ -91,53 +105,34 @@ mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter, u8 *amsdu_buf,
  */
 static void
 mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
-			    struct mwifiex_buffer *mbuf)
+			    struct sk_buff *skb)
 {
 	struct txpd *local_tx_pd;
 	ENTER();
 
-	local_tx_pd = (struct txpd *) mbuf->buffer;
+	skb_push(skb, sizeof(*local_tx_pd));
+
+	local_tx_pd = (struct txpd *) skb->data;
 	memset(local_tx_pd, 0, sizeof(struct txpd));
 
 	/*
 	 * Original priority has been overwritten
 	 */
-	local_tx_pd->priority = (u8) mbuf->priority;
+	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
-		mwifiex_wmm_compute_drv_pkt_delay(priv, mbuf);
+		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 	/* Always zero as the data is followed by struct txpd */
 	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
 	local_tx_pd->tx_pkt_type = cpu_to_le16(PKT_TYPE_AMSDU);
+	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
+			sizeof(*local_tx_pd));
 
 	if (local_tx_pd->tx_control == 0)
 		/* TxCtrl set by user or default */
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
 
-	LEAVE();
-}
-
-/*
- * Updates the packet length field of TxPD.
- *
- * This function checks the current packet length and updates the TxPD
- * field accordingly. This is needed because when the TxPD was added
- * at the beginning of buffer creation, the total packet was still not
- * formed and the correct packet length was not known.
- */
-static void
-mwifiex_11n_update_pktlen_amsdu_txpd(struct mwifiex_private *priv,
-				     struct mwifiex_buffer *mbuf)
-{
-	struct txpd *local_tx_pd;
-
-	ENTER();
-
-	local_tx_pd = (struct txpd *) mbuf->buffer;
-	local_tx_pd->tx_pkt_length =
-		cpu_to_le16(mbuf->data_len - sizeof(struct txpd));
-
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 		(priv->adapter->pps_uapsd_mode)) {
 		if (true == mwifiex_check_last_packet_indication(priv)) {
@@ -192,15 +187,18 @@ mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
  */
 enum mwifiex_status
 mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
-			    struct mwifiex_buffer *mbuf)
+			    struct sk_buff *skb)
 {
 	u16 pkt_len;
 	int total_pkt_len;
 	u8 *data;
 	int pad;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct rxpd *local_rx_pd = (struct rxpd *) skb->data;
+	struct sk_buff *skb_daggr;
+	struct mwifiex_rxinfo *rx_info_daggr = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
 	struct rx_packet_hdr *rx_pkt_hdr;
-	struct mwifiex_buffer *mbuf_daggr;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
 		0x00, 0x00, 0x00
@@ -208,8 +206,8 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 
 	ENTER();
 
-	data = (u8 *) (mbuf->buffer + mbuf->data_offset);
-	total_pkt_len = mbuf->data_len;
+	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
+	total_pkt_len = local_rx_pd->rx_pkt_length;
 
 	/* Sanity test */
 	if (total_pkt_len > MWIFIEX_RX_DATA_BUF_SIZE) {
@@ -218,7 +216,7 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		goto done;
 	}
 
-	mbuf->use_count = mwifiex_11n_get_num_aggr_pkts(data, total_pkt_len);
+	rx_info->use_count = mwifiex_11n_get_num_aggr_pkts(data, total_pkt_len);
 
 	while (total_pkt_len > 0) {
 		rx_pkt_hdr = (struct rx_packet_hdr *) data;
@@ -248,24 +246,23 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 			pkt_len += sizeof(struct ethhdr);
 		}
 
-		mbuf_daggr = mwifiex_alloc_buffer(pkt_len);
-		if (!mbuf_daggr) {
+		skb_daggr = dev_alloc_skb(pkt_len);
+		if (!skb_daggr) {
 			PRINTM(MERROR, "%s: failed to alloc mbuf_daggr\n",
 			       __func__);
 			ret = MWIFIEX_STATUS_FAILURE;
 			goto done;
 		}
+		rx_info_daggr = MWIFIEX_SKB_RXCB(skb_daggr);
 
-		mbuf_daggr->bss_index = mbuf->bss_index;
-		mbuf_daggr->buf_type = mbuf->buf_type;
-		mbuf_daggr->data_len = pkt_len;
-		mbuf_daggr->in_tstamp = mbuf->in_tstamp;
-		mbuf_daggr->parent = mbuf;
-		mbuf_daggr->priority = mbuf->priority;
-		memcpy(mbuf_daggr->buffer + mbuf_daggr->data_offset, data,
-								pkt_len);
+		rx_info_daggr->bss_index = rx_info->bss_index;
+		skb_daggr->tstamp = skb->tstamp;
+		rx_info_daggr->parent = skb;
+		skb_daggr->priority = skb->priority;
+		skb_put(skb_daggr, pkt_len);
+		memcpy(skb_daggr->data, data, pkt_len);
 
-		ret = mwifiex_recv_packet(adapter, mbuf_daggr);
+		ret = mwifiex_recv_packet(adapter, skb_daggr);
 
 		switch (ret) {
 		case MWIFIEX_STATUS_PENDING:
@@ -273,7 +270,7 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		case MWIFIEX_STATUS_FAILURE:
 			PRINTM(MERROR, "Deaggr, send to mwifiex failed\n");
 		case MWIFIEX_STATUS_SUCCESS:
-			mwifiex_recv_packet_complete(adapter, mbuf_daggr, ret);
+			mwifiex_recv_packet_complete(adapter, skb_daggr, ret);
 			break;
 		default:
 			break;
@@ -309,87 +306,54 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
-	int pkt_size = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_buffer *mbuf_aggr, *mbuf_src;
-	u8 *data;
+	struct sk_buff *skb_aggr, *skb_src;
+	struct mwifiex_txinfo *tx_info_aggr, *tx_info_src;
 	int pad = 0;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct timeval tstamp;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
-	unsigned long ra_list_tbl_flags;
 
 	ENTER();
 
 	PRINTM(MDAT_D, "Handling Aggr packet\n");
 
-	spin_lock_irqsave(&pra_list->ra_list_tbl_lock, ra_list_tbl_flags);
-	if (list_empty(&pra_list->buf_head)) {
-		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+	if (skb_queue_empty(&pra_list->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		goto exit;
 	}
-	mbuf_src = list_first_entry(&pra_list->buf_head,
-				    struct mwifiex_buffer, list);
-	spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock, ra_list_tbl_flags);
-
-	mbuf_aggr = mwifiex_alloc_buffer(adapter->tx_buf_size);
-	if (!mbuf_aggr) {
-		PRINTM(MERROR,
-		       "Error allocating struct mwifiex_buffer\n");
+	skb_src = skb_peek(&pra_list->skb_head);
+	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
+	skb_aggr = dev_alloc_skb(adapter->tx_buf_size);
+	if (!skb_aggr) {
+		PRINTM(MERROR, "Error allocating SKB\n");
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		return MWIFIEX_STATUS_FAILURE;
 	}
+	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
+	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
 
-	data = mbuf_aggr->buffer + headroom;
+	tx_info_aggr->bss_index = tx_info_src->bss_index;
+	skb_aggr->priority = skb_src->priority;
 
-	mbuf_aggr->bss_index = mbuf_src->bss_index;
-	mbuf_aggr->buf_type = mbuf_src->buf_type;
-	mbuf_aggr->priority = mbuf_src->priority;
+	while (skb_src && ((skb_headroom(skb_aggr) + skb_src->len
+					+ LLC_SNAP_LEN)
+				<= adapter->tx_buf_size)) {
 
-	mbuf_aggr->buffer = data;
-	mbuf_aggr->data_offset = 0;
-
-	/* Form AMSDU */
-	mwifiex_11n_form_amsdu_txpd(priv, mbuf_aggr);
-	pkt_size = sizeof(struct txpd);
-	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
-		ptx_pd = (struct txpd *)mbuf_aggr->buffer;
-
-	while (mbuf_src && ((pkt_size + (mbuf_src->data_len + LLC_SNAP_LEN)
-			      + headroom)
-			     <= adapter->tx_buf_size)) {
-
-		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
-				  ra_list_tbl_flags);
-		if (!list_empty(&pra_list->buf_head)) {
-			mbuf_src = list_first_entry(&pra_list->buf_head,
-					struct mwifiex_buffer, list);
-			list_del(&mbuf_src->list);
-		} else {
-			mbuf_src = NULL;
-		}
-		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+		if (!skb_queue_empty(&pra_list->skb_head))
+			skb_src = skb_dequeue(&pra_list->skb_head);
+		else
+			skb_src = NULL;
 
-		pra_list->total_pkts_size -= mbuf_src->data_len;
+		pra_list->total_pkts_size -= skb_src->len;
 
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		pkt_size += mwifiex_11n_form_amsdu_pkt(adapter,
-						       (data + pkt_size),
-						       mbuf_src->buffer +
-						       mbuf_src->data_offset,
-						       mbuf_src->data_len,
-						       &pad);
-
-		DBG_HEXDUMP(MDAT_D, "mbuf_src", mbuf_src,
-			    sizeof(struct mwifiex_buffer));
-		mwifiex_write_data_complete(adapter, mbuf_src,
+		mwifiex_11n_form_amsdu_pkt(adapter, skb_aggr, skb_src, &pad);
+
+		mwifiex_write_data_complete(adapter, skb_src,
 					     MWIFIEX_STATUS_SUCCESS);
 
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
@@ -401,39 +365,39 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			return MWIFIEX_STATUS_FAILURE;
 		}
 
-		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
-				  ra_list_tbl_flags);
-		if (!list_empty(&pra_list->buf_head))
-			mbuf_src = list_first_entry(&pra_list->buf_head,
-					struct mwifiex_buffer, list);
+		if (!skb_queue_empty(&pra_list->skb_head))
+			skb_src = skb_peek(&pra_list->skb_head);
 		else
-			mbuf_src = NULL;
-		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+			skb_src = NULL;
 	}
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 	/* Last AMSDU packet does not need padding */
-	pkt_size -= pad;
-	mbuf_aggr->data_len = pkt_size;
-	mwifiex_11n_update_pktlen_amsdu_txpd(priv, mbuf_aggr);
-	mbuf_aggr->data_len += headroom;
-	mbuf_aggr->buffer = data - headroom;
+	skb_trim(skb_aggr, skb_aggr->len - pad);
+
+	/* Form AMSDU */
+	mwifiex_11n_form_amsdu_txpd(priv, skb_aggr);
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+		ptx_pd = (struct txpd *)skb_aggr->data;
+
+	skb_push(skb_aggr, headroom);
+
 	tx_param.next_pkt_len = ((pra_list->total_pkts_size) ?
 				 (((pra_list->total_pkts_size) >
 				   adapter->tx_buf_size) ? adapter->
 				  tx_buf_size : pra_list->total_pkts_size +
 				  LLC_SNAP_LEN + sizeof(struct txpd)) : 0);
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     mbuf_aggr, &tx_param);
+					     skb_aggr->data,
+					     skb_aggr->len, &tx_param);
 	switch (ret) {
 	case MWIFIEX_STATUS_RESOURCE:
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			mwifiex_write_data_complete(adapter, mbuf_aggr,
+			mwifiex_write_data_complete(adapter, skb_aggr,
 						    MWIFIEX_STATUS_FAILURE);
 			LEAVE();
 			return MWIFIEX_STATUS_FAILURE;
@@ -445,15 +409,11 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				ptx_pd->flags = 0;
 		}
 
-		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
-				  ra_list_tbl_flags);
-		list_add(&mbuf_aggr->list, &pra_list->buf_head);
-		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+		skb_queue_tail(&pra_list->skb_head, skb_aggr);
 
-		pra_list->total_pkts_size += mbuf_aggr->data_len;
+		pra_list->total_pkts_size += skb_aggr->len;
 
-		mbuf_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
@@ -463,13 +423,13 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, mbuf_aggr, ret);
+		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		goto exit;
 	case MWIFIEX_STATUS_PENDING:
 		adapter->data_sent = false;
 		break;
 	case MWIFIEX_STATUS_SUCCESS:
-		mwifiex_write_data_complete(adapter, mbuf_aggr, ret);
+		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		break;
 	default:
 		break;
@@ -489,11 +449,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	}
-	do_gettimeofday(&tstamp);
-	PRINTM(MDATA, "%lu.%lu : Data => kernel\n",
-	       tstamp.tv_sec, tstamp.tv_usec);
 
 exit:
 	LEAVE();
-	return pkt_size + headroom;
+	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 5b076f2..5639aa8 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -23,7 +23,7 @@
 #define PKT_TYPE_AMSDU	0xE6
 
 enum mwifiex_status mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
-						struct mwifiex_buffer *mbuf);
+						struct sk_buff *skb);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ptr, int headroom,
 			      int ptr_index, unsigned long flags)
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 567c93d..6d6a280 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -38,7 +38,7 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ret = mwifiex_process_rx_packet(adapter,
-					(struct mwifiex_buffer *) payload);
+					(struct sk_buff *) payload);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 45fabaa..fc9a116 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1525,7 +1525,7 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
 	dev->hard_header_len +=
-		MWIFIEX_MIN_DATA_HEADER_LEN + sizeof(struct mwifiex_buffer);
+		MWIFIEX_MIN_DATA_HEADER_LEN;
 
 done:
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5c512d5..d503eb2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -39,22 +39,11 @@ mwifiex_init_cmd_node(struct mwifiex_private *priv,
 		      struct cmd_ctrl_node *cmd_node,
 		      u32 cmd_oid, void *ioctl_buf, void *data_buf)
 {
-	ENTER();
-
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
 	cmd_node->ioctl_buf = ioctl_buf;
 	cmd_node->data_buf = data_buf;
-
-	cmd_node->cmd_buf = cmd_node->mbuf;
-
-	cmd_node->cmd_buf->data_offset = 0;
-	memset(cmd_node->cmd_buf->buffer, 0, MWIFIEX_SIZE_OF_CMD_BUFFER);
-
-	cmd_node->cmd_buf->buf_type = MWIFIEX_BUF_TYPE_CMD;
-	cmd_node->cmd_buf->data_offset += INTF_HEADER_LEN;
-
-	LEAVE();
+	cmd_node->cmd_skb = cmd_node->skb;
 }
 
 /*
@@ -67,8 +56,6 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 	struct cmd_ctrl_node *cmd_node;
 	unsigned long flags;
 
-	ENTER();
-
 	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
 	if (list_empty(&adapter->cmd_free_q)) {
 		PRINTM(MERROR,
@@ -81,7 +68,6 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 	list_del(&cmd_node->list);
 	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 
-	LEAVE();
 	return cmd_node;
 }
 
@@ -107,11 +93,10 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 	cmd_node->ioctl_buf = NULL;
 	cmd_node->data_buf = NULL;
 
-	if (cmd_node->resp_buf) {
-		mwifiex_recv_complete(adapter,
-				      cmd_node->resp_buf, 0,
+	if (cmd_node->resp_skb) {
+		mwifiex_recv_complete(adapter, cmd_node->resp_skb,
 				      MWIFIEX_STATUS_SUCCESS);
-		cmd_node->resp_buf = NULL;
+		cmd_node->resp_skb = NULL;
 	}
 
 	LEAVE();
@@ -223,8 +208,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		goto done;
 	}
 
-	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_buf->buffer +
-					       cmd_node->cmd_buf->data_offset);
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (cmd_node->ioctl_buf != NULL)
 		ioctl_buf = (struct mwifiex_ioctl_req *) cmd_node->ioctl_buf;
 
@@ -255,7 +239,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	cmd_code = le16_to_cpu(host_cmd->command);
 	cmd_size = le16_to_cpu(host_cmd->size);
 
-	cmd_node->cmd_buf->data_len = cmd_size;
+	skb_trim(cmd_node->cmd_skb, cmd_size);
 
 	do_gettimeofday(&tstamp);
 	PRINTM(MCMND,
@@ -265,11 +249,11 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	       le16_to_cpu(host_cmd->seq_num));
 	DBG_HEXDUMP(MCMD_D, "DNLD_CMD", (u8 *) host_cmd, cmd_size);
 
-	cmd_node->cmd_buf->data_offset -= INTF_HEADER_LEN;
-	cmd_node->cmd_buf->data_len += INTF_HEADER_LEN;
+	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					     cmd_node->cmd_buf, NULL);
+					     cmd_node->cmd_skb->data,
+					     cmd_node->cmd_skb->len, NULL);
 
 	if (ret == MWIFIEX_STATUS_FAILURE) {
 		PRINTM(MERROR, "DNLD_CMD: Host to Card Failed\n");
@@ -324,32 +308,25 @@ mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	static u32 i;
 	u16 cmd_len = 0;
+	struct mwifiex_private *priv;
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf =
-		(struct mwifiex_opt_sleep_confirm_buffer *) (adapter->
-							     sleep_cfm->buffer +
-							     adapter->
-							     sleep_cfm->
-							     data_offset);
-
-	ENTER();
-
+				(struct mwifiex_opt_sleep_confirm_buffer *)
+				adapter->sleep_cfm->data;
 	cmd_len = sizeof(struct mwifiex_opt_sleep_confirm);
-	adapter->seq_num++;
-	sleep_cfm_buf->ps_cfm_sleep.seq_num =
-		cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
-			    (adapter->seq_num,
-			     (mwifiex_get_priv
-			      (adapter, MWIFIEX_BSS_ROLE_ANY))->bss_num,
-			     (mwifiex_get_priv
-			      (adapter, MWIFIEX_BSS_ROLE_ANY))->bss_type));
-	DBG_HEXDUMP(MCMD_D, "SLEEP_CFM", &sleep_cfm_buf->ps_cfm_sleep, cmd_len);
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-	/* Send sleep confirm command to firmware */
+	sleep_cfm_buf->ps_cfm_sleep.seq_num =
+		cpu_to_le16((HostCmd_SET_SEQ_NO_BSS_INFO
+					(adapter->seq_num, priv->bss_num,
+					 priv->bss_type)));
+	adapter->seq_num++;
 
-	adapter->sleep_cfm->data_len = cmd_len + INTF_HEADER_LEN;
+	DBG_HEXDUMP(MCMD_D, "SLEEP_CFM", &sleep_cfm_buf->ps_cfm_sleep, cmd_len);
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					     adapter->sleep_cfm, NULL);
+					     adapter->sleep_cfm->data,
+					     adapter->sleep_cfm->len +
+					     INTF_HEADER_LEN, NULL);
 
 	if (ret == MWIFIEX_STATUS_FAILURE) {
 		PRINTM(MERROR, "SLEEP_CFM: failed\n");
@@ -385,7 +362,6 @@ mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	}
 
 done:
-	LEAVE();
 	return ret;
 }
 
@@ -425,9 +401,9 @@ mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 
 	/* Allocate and initialize command buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
-		cmd_array[i].mbuf =
-			mwifiex_alloc_buffer(MWIFIEX_SIZE_OF_CMD_BUFFER);
-		if (!cmd_array[i].mbuf) {
+		cmd_array[i].skb =
+			dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
+		if (!cmd_array[i].skb) {
 			PRINTM(MERROR,
 			       "ALLOC_CMD_BUF: pcmd_buf: out of memory\n");
 			ret = MWIFIEX_STATUS_FAILURE;
@@ -467,16 +443,13 @@ mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 
 	/* Release shared memory buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
-		if (cmd_array[i].mbuf) {
+		if (cmd_array[i].skb) {
 			PRINTM(MCMND, "Free all the command buffer.\n");
-			mwifiex_free_buffer(cmd_array[i].mbuf);
-			cmd_array[i].mbuf = NULL;
+			dev_kfree_skb_any(cmd_array[i].skb);
 		}
-		if (cmd_array[i].resp_buf) {
-			mwifiex_recv_complete(adapter,
-					      cmd_array[i].resp_buf, 0,
+		if (cmd_array[i].resp_skb) {
+			mwifiex_recv_complete(adapter, cmd_array[i].resp_skb,
 					      MWIFIEX_STATUS_SUCCESS);
-			cmd_array[i].resp_buf = NULL;
 		}
 	}
 	/* Release struct cmd_ctrl_node */
@@ -507,9 +480,11 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-	struct mwifiex_buffer *mbuf = adapter->mwifiex_buffer_event;
+	struct sk_buff *skb = adapter->event_skb;
 	u32 eventcause = adapter->event_cause;
 	struct timeval tstamp;
+	struct mwifiex_rxinfo *rx_info = NULL;
+
 	ENTER();
 
 	/* Save the last event to debug log */
@@ -527,8 +502,10 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
 	eventcause &= EVENT_ID_MASK;
 	adapter->event_cause = eventcause;
 
-	if (mbuf)
-		mbuf->bss_index = priv->bss_index;
+	if (skb) {
+		rx_info = MWIFIEX_SKB_RXCB(skb);
+		rx_info->bss_index = priv->bss_index;
+	}
 
 	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
 		do_gettimeofday(&tstamp);
@@ -539,12 +516,9 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
 	ret = mwifiex_process_sta_event(priv);
 
 	adapter->event_cause = 0;
-	adapter->mwifiex_buffer_event = NULL;
+	adapter->event_skb = NULL;
 
-	if (mbuf) {
-		mwifiex_recv_complete(adapter, mbuf,
-				      0, MWIFIEX_STATUS_SUCCESS);
-	}
+	mwifiex_recv_complete(adapter, skb, MWIFIEX_STATUS_SUCCESS);
 
 	LEAVE();
 	return ret;
@@ -608,15 +582,16 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, ioctl_buf,
 			      data_buf);
 
-	if (cmd_node->cmd_buf == NULL) {
+	if (!cmd_node->cmd_skb) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd buf\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
+	skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command));
+
 	cmd_ptr =
-		(struct host_cmd_ds_command *) (cmd_node->cmd_buf->buffer +
-						cmd_node->cmd_buf->data_offset);
+		(struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	cmd_ptr->command = cpu_to_le16(cmd_no);
 	cmd_ptr->result = 0;
 
@@ -706,8 +681,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 
 	ENTER();
 
-	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_buf->buffer +
-					       cmd_node->cmd_buf->data_offset);
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (host_cmd == NULL) {
 		PRINTM(MERROR, "QUEUE_CMD: host_cmd is NULL\n");
 		goto done;
@@ -787,8 +761,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 			       cmd_pending_q_flags);
 
 	host_cmd = (struct host_cmd_ds_command *)
-				(cmd_node->cmd_buf->buffer +
-				 cmd_node->cmd_buf->data_offset);
+				(cmd_node->cmd_skb->data);
 	priv = cmd_node->priv;
 
 	if (adapter->ps_state != PS_STATE_AWAKE) {
@@ -850,7 +823,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	/* Now we got response from FW, cancel the command timer */
 	del_timer(&adapter->cmd_timer);
 
-	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_buf) {
+	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
 		PRINTM(MERROR, "CMD_RESP: NULL curr_cmd, 0x%x\n",
 		       le16_to_cpu(resp->command));
@@ -867,14 +840,11 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	adapter->num_cmd_timeout = 0;
 
 	DBG_HEXDUMP(MCMD_D, "CMD_RESP",
-		    adapter->curr_cmd->resp_buf->buffer +
-		    adapter->curr_cmd->resp_buf->data_offset,
-		    adapter->curr_cmd->resp_buf->data_len);
-
-	resp = (struct host_cmd_ds_command *) (adapter->curr_cmd->resp_buf->
-					       buffer +
-					       adapter->curr_cmd->resp_buf->
-					       data_offset);
+		    adapter->curr_cmd->resp_skb->data,
+		    adapter->curr_cmd->resp_skb->len);
+
+	resp = (struct host_cmd_ds_command *)
+					adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
 		PRINTM(MERROR, "CMD_RESP: 0x%x been canceled!\n",
 				le16_to_cpu(resp->command));
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 467eccc..0ffa0d9 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -64,7 +64,6 @@
 #define MWIFIEX_SDIO_BLOCK_SIZE            256
 
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
-#define MWIFIEX_FLAG_TX_BUF                BIT(1)
 
 enum mwifiex_status {
 	MWIFIEX_STATUS_FAILURE = 0xffffffff,
@@ -90,12 +89,6 @@ enum mwifiex_error_code {
 	MWIFIEX_ERROR_INVALID_PARAMETER,
 };
 
-enum mwifiex_buf_type {
-	MWIFIEX_BUF_TYPE_CMD = 1,
-	MWIFIEX_BUF_TYPE_DATA,
-	MWIFIEX_BUF_TYPE_EVENT,
-};
-
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -149,21 +142,16 @@ struct mwifiex_ioctl_req {
 	struct mwifiex_wait_queue wq;
 };
 
-struct mwifiex_buffer {
-	struct list_head list;
+struct mwifiex_rxinfo {
+	u8 bss_index;
+	struct sk_buff *parent;
+	u8 use_count;
+};
+
+struct mwifiex_txinfo {
 	u32 status_code;
-	u32 flags;
-	u32 bss_index;
-	void *desc;
-	u8 *buffer;
-	u32 data_offset;
-	u32 data_len;
-	enum mwifiex_buf_type buf_type;
-	u32 priority;
-	struct timeval in_tstamp;
-	struct timeval out_tstamp;
-	struct mwifiex_buffer *parent;
-	u32 use_count;
+	u8 flags;
+	u8 bss_index;
 };
 
 struct mwifiex_bss_attr {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 551dbbe..0c325f5 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -38,6 +38,11 @@ struct rx_packet_hdr {
 	struct rfc_1042_hdr rfc1042_hdr;
 };
 
+struct tx_packet_hdr {
+	struct ethhdr eth803_hdr;
+	struct rfc_1042_hdr rfc1042_hdr;
+};
+
 #define B_SUPPORTED_RATES               5
 #define G_SUPPORTED_RATES               9
 #define BG_SUPPORTED_RATES              13
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 91a484c..9a04f7e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -198,8 +198,14 @@ mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->sleep_cfm =
-		mwifiex_alloc_buffer(sizeof
-				     (struct mwifiex_opt_sleep_confirm_buffer));
+		dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm_buffer)
+				+ INTF_HEADER_LEN);
+
+	if (!adapter->sleep_cfm) {
+		PRINTM(MERROR, "Failed to allocate sleep cfm\n");
+		return MWIFIEX_STATUS_FAILURE;
+	}
+	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
 
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
@@ -219,12 +225,10 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
+	skb_put(adapter->sleep_cfm, sizeof(sleep_cfm_buf->ps_cfm_sleep));
 	sleep_cfm_buf =
-		(struct mwifiex_opt_sleep_confirm_buffer *) (adapter->
-							     sleep_cfm->buffer +
-							     adapter->
-							     sleep_cfm->
-							     data_offset);
+		(struct mwifiex_opt_sleep_confirm_buffer *)
+						(adapter->sleep_cfm->data);
 
 	adapter->cmd_sent = false;
 	adapter->data_sent = true;
@@ -294,15 +298,12 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	mwifiex_wmm_init(adapter);
 
 	if (adapter->sleep_cfm) {
-		adapter->sleep_cfm->buf_type = MWIFIEX_BUF_TYPE_CMD;
-		adapter->sleep_cfm->data_len =
-			sizeof(struct mwifiex_opt_sleep_confirm);
 		memset(&sleep_cfm_buf->ps_cfm_sleep, 0,
-		       adapter->sleep_cfm->data_len);
+			adapter->sleep_cfm->len);
 		sleep_cfm_buf->ps_cfm_sleep.command =
 			cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
 		sleep_cfm_buf->ps_cfm_sleep.size =
-			cpu_to_le16(adapter->sleep_cfm->data_len);
+			cpu_to_le16(adapter->sleep_cfm->len);
 		sleep_cfm_buf->ps_cfm_sleep.result = 0;
 		sleep_cfm_buf->ps_cfm_sleep.action = cpu_to_le16(SLEEP_CONFIRM);
 		sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl =
@@ -369,7 +370,7 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->if_ops.cleanup_if(adapter);
 
-	mwifiex_free_buffer(adapter->sleep_cfm);
+	dev_kfree_skb_any(adapter->sleep_cfm);
 
 	LEAVE();
 	return;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0f26068..9f56ded 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -521,10 +521,11 @@ done:
  * priority and timestamp.
  */
 static void
-mwifiex_fill_buffer(struct mwifiex_buffer *mbuf, struct sk_buff *skb)
+mwifiex_fill_buffer(struct sk_buff *skb)
 {
 	struct ethhdr *eth = NULL;
 	struct iphdr *iph;
+	struct timeval tv;
 	u8 tid = 0;
 
 	ENTER();
@@ -553,15 +554,8 @@ mwifiex_fill_buffer(struct mwifiex_buffer *mbuf, struct sk_buff *skb)
 	   firmware for aggregate delay calculation for stats and
 	   MSDU lifetime expiry.
 	 */
-	do_gettimeofday(&mbuf->in_tstamp);
-	skb->tstamp = timeval_to_ktime(mbuf->in_tstamp);
-	mbuf->desc = skb;
-	mbuf->buffer = skb->head + sizeof(struct mwifiex_buffer);
-	mbuf->data_offset =
-		skb->data - (skb->head + sizeof(struct mwifiex_buffer));
-	mbuf->data_len = skb->len;
-	mbuf->priority = skb->priority;
-	mbuf->flags = MWIFIEX_FLAG_TX_BUF;
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 	LEAVE();
 	return;
 }
@@ -601,8 +595,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_netdev_get_priv(dev);
-	struct mwifiex_buffer *mbuf = NULL;
 	struct sk_buff *new_skb = NULL;
+	struct mwifiex_txinfo *tx_info;
 
 	ENTER();
 
@@ -621,15 +615,12 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		priv->stats.tx_dropped++;
 		goto done;
 	}
-	if (skb_headroom(skb) < (MWIFIEX_MIN_DATA_HEADER_LEN
-				 + sizeof(struct mwifiex_buffer))) {
+	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
 		PRINTM(MWARN, "Tx: Insufficient skb headroomd\n",
 		       skb_headroom(skb));
 		/* Insufficient skb headroom - allocate a new skb */
 		new_skb =
-			skb_realloc_headroom(skb,
-					     MWIFIEX_MIN_DATA_HEADER_LEN +
-					     sizeof(struct mwifiex_buffer));
+			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
 		if (unlikely(!new_skb)) {
 			PRINTM(MERROR, "Tx: Cannot allocate skb\n");
 			kfree(skb);
@@ -640,11 +631,12 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb = new_skb;
 		PRINTM(MINFO, "new skb headroomd\n", skb_headroom(skb));
 	}
-	mbuf = (struct mwifiex_buffer *) skb->head;
-	mbuf->bss_index = priv->bss_index;
-	mwifiex_fill_buffer(mbuf, skb);
 
-	mwifiex_wmm_add_buf_txqueue(priv->adapter, mbuf);
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_index = priv->bss_index;
+	mwifiex_fill_buffer(skb);
+
+	mwifiex_wmm_add_buf_txqueue(priv->adapter, skb);
 	atomic_inc(&priv->adapter->tx_pending);
 
 	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6c85bf4..c6cdc8e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -204,10 +204,7 @@ struct mwifiex_tx_aggr {
 
 struct mwifiex_ra_list_tbl {
 	struct list_head list;
-	struct list_head buf_head;
-	/* spin lock for ra list table */
-	spinlock_t ra_list_tbl_lock;
-
+	struct sk_buff_head skb_head;
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
 	u32 total_pkts_size;
 	u32 is_11n_enabled;
@@ -486,11 +483,11 @@ struct cmd_ctrl_node {
 	struct mwifiex_private *priv;
 	u32 cmd_oid;
 	u32 cmd_flag;
-	struct mwifiex_buffer *cmd_buf;
-	struct mwifiex_buffer *resp_buf;
+	struct sk_buff *cmd_skb;
+	struct sk_buff *resp_skb;
 	void *data_buf;
 	void *ioctl_buf;
-	struct mwifiex_buffer *mbuf;
+	struct sk_buff *skb;
 };
 
 struct mwifiex_if_ops {
@@ -505,7 +502,7 @@ struct mwifiex_if_ops {
 	enum mwifiex_status (*enable_int) (struct mwifiex_adapter *);
 	enum mwifiex_status (*process_int_status) (struct mwifiex_adapter *);
 	enum mwifiex_status (*host_to_card) (struct mwifiex_adapter *, u8,
-					     struct mwifiex_buffer *,
+					     u8 *payload, u32 pkt_len,
 					     struct mwifiex_tx_param *);
 	enum mwifiex_status (*wakeup) (struct mwifiex_adapter *);
 	enum mwifiex_status (*wakeup_complete) (struct mwifiex_adapter *);
@@ -551,7 +548,7 @@ struct mwifiex_adapter {
 	spinlock_t int_lock;
 	u8 int_status;
 	u32 event_cause;
-	struct mwifiex_buffer *mwifiex_buffer_event;
+	struct sk_buff *event_skb;
 	u32 upld_len;
 	u8 upld_buf[MWIFIEX_UPLD_SIZE];
 	u8 data_sent;
@@ -601,7 +598,7 @@ struct mwifiex_adapter {
 	u16 multiple_dtim;
 	u16 local_listen_interval;
 	u16 null_pkt_interval;
-	struct mwifiex_buffer *sleep_cfm;
+	struct sk_buff *sleep_cfm;
 	u16 bcn_miss_time_out;
 	u16 adhoc_awake_period;
 	u8 is_deep_sleep;
@@ -645,19 +642,12 @@ enum mwifiex_status mwifiex_shutdown_fw_complete(struct mwifiex_adapter
 enum mwifiex_status mwifiex_dnld_fw(struct mwifiex_adapter *,
 				    struct mwifiex_fw_image *);
 
-enum mwifiex_status mwifiex_send_packet_complete(struct mwifiex_adapter *,
-						 struct mwifiex_buffer *mbuf,
-						 enum mwifiex_status status);
 enum mwifiex_status mwifiex_recv_complete(struct mwifiex_adapter *,
-					  struct mwifiex_buffer *mbuf,
-					  u32 port,
+					  struct sk_buff *skb,
 					  enum mwifiex_status status);
 
 enum mwifiex_status mwifiex_recv_packet(struct mwifiex_adapter *,
-					struct mwifiex_buffer *mbuf);
-
-struct mwifiex_buffer *mwifiex_alloc_buffer_skb(int size);
-void mwifiex_free_buffer_skb(struct mwifiex_buffer *mbuf);
+					struct sk_buff *skb);
 
 void mwifiex_init_adapter(struct mwifiex_adapter *adapter);
 void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv);
@@ -707,23 +697,21 @@ void mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 enum mwifiex_status mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter);
 enum mwifiex_status mwifiex_process_cmdresp(struct mwifiex_adapter *adapter);
 enum mwifiex_status mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
-					     struct mwifiex_buffer *mbuf);
+					     struct sk_buff *skb);
 enum mwifiex_status mwifiex_process_tx(struct mwifiex_private *priv,
-				       struct mwifiex_buffer *mbuf,
+				       struct sk_buff *skb,
 				       struct mwifiex_tx_param *tx_param);
 enum mwifiex_status mwifiex_send_null_packet(struct mwifiex_private *priv,
 					     u8 flags);
 enum mwifiex_status mwifiex_write_data_complete(struct mwifiex_adapter
 						*adapter,
-						struct mwifiex_buffer *mbuf,
+						struct sk_buff *skb,
 						enum mwifiex_status status);
 enum mwifiex_status mwifiex_recv_packet_complete(struct mwifiex_adapter *,
-						 struct mwifiex_buffer *mbuf,
+						 struct sk_buff *skb,
 						 enum mwifiex_status status);
 void mwifiex_clean_txrx(struct mwifiex_private *priv);
 u8 mwifiex_check_last_packet_indication(struct mwifiex_private *priv);
-struct mwifiex_buffer *mwifiex_alloc_buffer(u32 data_len);
-void mwifiex_free_buffer(struct mwifiex_buffer *mbuf);
 void mwifiex_check_ps_cond(struct mwifiex_adapter *adapter);
 void mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *, u8 *,
 					u32);
@@ -745,7 +733,7 @@ enum mwifiex_status mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 					      *ioctl_buf);
 void mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv);
 enum mwifiex_status mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
-					      struct mwifiex_buffer *mbuf);
+					      struct sk_buff *skb);
 enum mwifiex_status mwifiex_sta_ioctl(struct mwifiex_adapter *,
 				      struct mwifiex_ioctl_req *ioctl_req);
 enum mwifiex_status mwifiex_sta_prepare_cmd(struct mwifiex_private *,
@@ -757,10 +745,9 @@ enum mwifiex_status mwifiex_process_sta_cmdresp(struct mwifiex_private *,
 						u16 cmdresp_no,
 						void *cmd_buf, void *ioctl);
 enum mwifiex_status mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
-						  struct mwifiex_buffer *mbuf);
+						  struct sk_buff *skb);
 enum mwifiex_status mwifiex_process_sta_event(struct mwifiex_private *);
-void *mwifiex_process_sta_txpd(struct mwifiex_private *,
-				struct mwifiex_buffer *mbuf);
+void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 enum mwifiex_status mwifiex_sta_init_cmd(struct mwifiex_private *,
 						u8 first_sta);
 enum mwifiex_status mwifiex_scan_networks(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d0d9ed7..420ecce 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -310,18 +310,17 @@ mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
  */
 static enum mwifiex_status
 mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
-			struct mwifiex_buffer *mbuf, u32 port, u32 timeout)
+			u8 *buffer, u32 pkt_len, u32 port, u32 timeout)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
-	u8 *buffer = (u8 *) (mbuf->buffer + mbuf->data_offset);
 	u8 blk_mode =
 		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
 	u32 blk_cnt =
 		(blk_mode ==
-		 BLOCK_MODE) ? (mbuf->data_len /
-				MWIFIEX_SDIO_BLOCK_SIZE) : mbuf->data_len;
+		 BLOCK_MODE) ? (pkt_len /
+				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
 	if (adapter->is_suspended) {
@@ -344,19 +343,17 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
  */
 static enum mwifiex_status
 mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
-		       struct mwifiex_buffer *mbuf,
+		       u8 *buffer, u32 len,
 		       u32 port, u32 timeout, u8 claim)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
-	u8 *buffer = (u8 *) (mbuf->buffer + mbuf->data_offset);
 	u8 blk_mode =
 		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
 	u32 blk_cnt =
 		(blk_mode ==
-		 BLOCK_MODE) ? (mbuf->data_len /
-				MWIFIEX_SDIO_BLOCK_SIZE) : mbuf->data_len;
+		 BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE) : len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
 	if (claim)
@@ -470,13 +467,14 @@ mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
  */
 static enum mwifiex_status
 mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
-			   struct mwifiex_buffer *mbuf, u32 port)
+			   u8 *payload, u32 pkt_len, u32 port)
 {
 	u32 i = 0;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	do {
-		ret = mwifiex_write_data_sync(adapter, mbuf, port, 0);
+		ret = mwifiex_write_data_sync(adapter, payload, pkt_len,
+								port, 0);
 		if (ret != MWIFIEX_STATUS_SUCCESS) {
 			i++;
 			PRINTM(MERROR, "host_to_card, write iomem (%d) failed:"
@@ -693,27 +691,28 @@ mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 static enum mwifiex_status
 mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 			  u32 *type, u32 *nb,
-			  struct mwifiex_buffer *mbuf, u32 npayload,
+			  u8 *buffer, u32 npayload,
 			  u32 ioport)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	if (!mbuf) {
-		PRINTM(MWARN, "mbuf NULL pointer received!\n");
+	if (!buffer) {
+		PRINTM(MWARN, "skb NULL pointer received!\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
 
-	ret = mwifiex_read_data_sync(adapter, mbuf, ioport, 0, 1);
+	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
 
 	if (ret != MWIFIEX_STATUS_SUCCESS) {
 		PRINTM(MERROR, "card_to_host, read iomem failed: %d\n", ret);
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
-	*nb = le16_to_cpu(*(__le16 *) (mbuf->buffer + mbuf->data_offset));
+
+	*nb = le16_to_cpu(*(__le16 *) (buffer));
 	if (*nb > npayload) {
 		PRINTM(MERROR, "invalid packet, *nb=%d, npayload=%d\n", *nb,
 		       npayload);
@@ -721,10 +720,10 @@ mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 		goto exit;
 	}
 
-	DBG_HEXDUMP(MDAT_D, "SDIO Blk Rd", mbuf->buffer + mbuf->data_offset,
+	DBG_HEXDUMP(MDAT_D, "SDIO Blk Rd", buffer,
 		    min_t(u32, *nb, MAX_DATA_DUMP_LEN));
 
-	*type = le16_to_cpu(*(__le16 *) (mbuf->buffer + mbuf->data_offset + 2));
+	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
 
 exit:
 	LEAVE();
@@ -748,7 +747,6 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 offset = 0;
 	u32 base0, base1;
 	u8 *fwbuf;
-	struct mwifiex_buffer mbuf;
 	u16 len = 0;
 	u32 txlen = 0, tx_blocks = 0, tries = 0;
 	u32 i = 0;
@@ -868,11 +866,8 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			memmove(fwbuf, &firmware[offset], txlen);
 		}
 
-		memset(&mbuf, 0, sizeof(struct mwifiex_buffer));
-		mbuf.buffer = (u8 *) fwbuf;
-		mbuf.data_len = tx_blocks * MWIFIEX_SDIO_BLOCK_SIZE;
-
-		ret = mwifiex_write_data_sync(adapter, &mbuf,
+		ret = mwifiex_write_data_sync(adapter, fwbuf, tx_blocks *
+					      MWIFIEX_SDIO_BLOCK_SIZE,
 					      adapter->ioport, 0);
 		if (ret != MWIFIEX_STATUS_SUCCESS) {
 			PRINTM(MERROR,
@@ -952,18 +947,13 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num,
 static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	struct mwifiex_buffer mbuf;
 	u32 sdio_ireg = 0;
 	unsigned long flags;
 
 	ENTER();
 
-	memset(&mbuf, 0, sizeof(struct mwifiex_buffer));
-	mbuf.buffer = card->mp_regs;
-	mbuf.data_len = MAX_MP_REGS;
-
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_read_data_sync(adapter, &mbuf,
+	    mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
 				   0)) {
 		PRINTM(MWARN,
@@ -1034,81 +1024,59 @@ exit:
  */
 static enum mwifiex_status
 mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
-			 struct mwifiex_buffer *mbuf, u32 upld_typ)
+			 struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
-	u32 event;
+
+	skb_pull(skb, INTF_HEADER_LEN);
 
 	switch (upld_typ) {
 	case MWIFIEX_TYPE_DATA:
 		PRINTM(MINFO, "--- Rx: Data packet ---\n");
-		mbuf->data_len = (adapter->upld_len - INTF_HEADER_LEN);
-		mbuf->data_offset += INTF_HEADER_LEN;
-		mwifiex_handle_rx_packet(adapter, mbuf);
+		mwifiex_handle_rx_packet(adapter, skb);
 		break;
 
 	case MWIFIEX_TYPE_CMD:
 		PRINTM(MINFO, "--- Rx: Cmd Response ---\n");
-		DBG_HEXDUMP(MDAT_D, "Cmd RESP BUFFER", mbuf->buffer
-			    + mbuf->data_offset, adapter->upld_len);
+		DBG_HEXDUMP(MDAT_D, "Cmd RESP BUFFER", skb->data, skb->len);
 		/* take care of curr_cmd = NULL case */
 		if (!adapter->curr_cmd) {
 			cmd_buf = adapter->upld_buf;
 
 			if (adapter->ps_state == PS_STATE_SLEEP_CFM)
 				mwifiex_process_sleep_confirm_resp(adapter,
-						mbuf->buffer +
-						mbuf->
-						data_offset +
-						INTF_HEADER_LEN,
-						adapter->
-						upld_len -
-						INTF_HEADER_LEN);
-
-			adapter->upld_len -= INTF_HEADER_LEN;
-			memcpy(cmd_buf,
-			       mbuf->buffer + mbuf->data_offset +
-			       INTF_HEADER_LEN, min_t(u32,
-				       MWIFIEX_SIZE_OF_CMD_BUFFER,
-				       adapter->upld_len -
-				       INTF_HEADER_LEN));
-			mwifiex_free_buffer_skb(mbuf);
+							skb->data, skb->len);
+
+			memcpy(cmd_buf, skb->data, min_t(u32,
+				       MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
+
+			dev_kfree_skb_any(skb);
 		} else {
 			adapter->cmd_resp_received = true;
-			adapter->upld_len -= INTF_HEADER_LEN;
-			mbuf->data_len = adapter->upld_len;
-			mbuf->data_offset += INTF_HEADER_LEN;
-			adapter->curr_cmd->resp_buf = mbuf;
+			adapter->curr_cmd->resp_skb = skb;
 		}
+
+		adapter->upld_len = skb->len;
 		break;
 
 	case MWIFIEX_TYPE_EVENT:
 		PRINTM(MINFO, "--- Rx: Event ---\n");
-		event = *(u32 *) &mbuf->buffer[mbuf->data_offset +
-						 INTF_HEADER_LEN];
-		adapter->event_cause = event;
-		if ((adapter->upld_len > MWIFIEX_EVENT_HEADER_LEN) &&
-		    ((adapter->upld_len - MWIFIEX_EVENT_HEADER_LEN) <
-		     MAX_EVENT_SIZE)) {
-			memcpy(adapter->event_body,
-			       mbuf->buffer + mbuf->data_offset +
-			       MWIFIEX_EVENT_HEADER_LEN,
-			       adapter->upld_len - MWIFIEX_EVENT_HEADER_LEN);
-		}
+		adapter->event_cause = *(u32 *) skb->data;
+
+		skb_pull(skb, MWIFIEX_EVENT_HEADER_LEN);
+
+		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
+			memcpy(adapter->event_body, skb->data, skb->len);
 
 		/* event cause has been saved to adapter->event_cause */
 		adapter->event_received = true;
-		mbuf->data_len = adapter->upld_len;
-		adapter->mwifiex_buffer_event = mbuf;
+		adapter->event_skb = skb;
 
-		/* remove SDIO header */
-		mbuf->data_offset += INTF_HEADER_LEN;
-		mbuf->data_len -= INTF_HEADER_LEN;
 		break;
 
 	default:
 		PRINTM(MERROR, "SDIO unknown upload type = 0x%x\n", upld_typ);
-		mwifiex_free_buffer_skb(mbuf);
+		dev_kfree_skb_any(skb);
 		break;
 	}
 
@@ -1126,22 +1094,20 @@ mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
  */
 static enum mwifiex_status
 mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
-				  struct mwifiex_buffer *mbuf, u8 port,
-				  u16 rx_len)
+				  struct sk_buff *skb, u8 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	s32 f_do_rx_aggr = 0;
 	s32 f_do_rx_cur = 0;
 	s32 f_aggr_cur = 0;
-	struct mwifiex_buffer mbuf_aggr;
-	struct mwifiex_buffer *mbuf_deaggr;
+	struct sk_buff *skb_deaggr;
 	u32 pind = 0;
 	u32 pkt_len, pkt_type = 0;
 	u8 *curr_ptr;
+	u32 rx_len = skb->len;
 
 	ENTER();
-
 	if (port == CTRL_PORT) {
 		/* Read the command Resp without aggr */
 		PRINTM(MINFO, "card_2_host_mp_aggr: No "
@@ -1164,7 +1130,7 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		PRINTM(MINFO, "card_2_host_mp_aggr: Not last packet\n");
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
-			if (MP_RX_AGGR_BUF_HAS_ROOM(card, rx_len)) {
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
 				f_aggr_cur = 1;
 			} else {
 				/* No room in Aggr buf, do rx aggr now */
@@ -1182,7 +1148,7 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			f_do_rx_aggr = 1;
-			if (MP_RX_AGGR_BUF_HAS_ROOM(card, rx_len)) {
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
 				f_aggr_cur = 1;
 			} else {
 				/* No room in Aggr buf, do rx aggr now */
@@ -1197,7 +1163,7 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	if (f_aggr_cur) {
 		PRINTM(MINFO, "Current packet aggregation.\n");
 		/* Curr pkt can be aggregated */
-		MP_RX_AGGR_SETUP(card, mbuf, port, rx_len);
+		MP_RX_AGGR_SETUP(card, skb, port);
 
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    MP_RX_AGGR_PORT_LIMIT_REACHED(card)) {
@@ -1214,12 +1180,9 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		PRINTM(MINFO, "do_rx_aggr: num of packets: %d\n",
 		       card->mpa_rx.pkt_cnt);
 
-		memset(&mbuf_aggr, 0, sizeof(struct mwifiex_buffer));
-
-		mbuf_aggr.buffer = (u8 *) card->mpa_rx.buf;
-		mbuf_aggr.data_len = card->mpa_rx.buf_len;
 		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_read_data_sync(adapter, &mbuf_aggr,
+		    mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
+					   card->mpa_rx.buf_len,
 					   (adapter->ioport | 0x1000 |
 					    (card->mpa_rx.ports << 4)) +
 					   card->mpa_rx.start_port, 0, 1)) {
@@ -1235,19 +1198,19 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			pkt_len = *(u16 *) &curr_ptr[0];
 			pkt_type = *(u16 *) &curr_ptr[2];
 
-			PRINTM(MINFO, "RX: [%d] pktlen: %d pkt_type: 0x%x\n",
-			       pind, pkt_len, pkt_type);
-
 			/* copy pkt to deaggr buf */
-			mbuf_deaggr = card->mpa_rx.mbuf_arr[pind];
-			if ((pkt_type == MWIFIEX_TYPE_DATA) &&
-			    (pkt_len <= card->mpa_rx.len_arr[pind])) {
-				memcpy(mbuf_deaggr->buffer +
-				       mbuf_deaggr->data_offset, curr_ptr,
-				       pkt_len);
+			skb_deaggr = card->mpa_rx.skb_arr[pind];
+
+			if ((pkt_type == MWIFIEX_TYPE_DATA) && (pkt_len <=
+					 card->mpa_rx.len_arr[pind])) {
+
+				memcpy(skb_deaggr->data, curr_ptr, pkt_len);
+
+				skb_trim(skb_deaggr, pkt_len);
+
 				adapter->upld_len = pkt_len;
 				/* Process de-aggr packet */
-				mwifiex_decode_rx_packet(adapter, mbuf_deaggr,
+				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
 			} else {
 				PRINTM(MERROR,
@@ -1255,7 +1218,7 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				       "max_len=%d\n",
 				       pkt_type, pkt_len,
 				       card->mpa_rx.len_arr[pind]);
-				mwifiex_free_buffer_skb(mbuf_deaggr);
+				dev_kfree_skb_any(skb_deaggr);
 			}
 			curr_ptr += card->mpa_rx.len_arr[pind];
 		}
@@ -1270,13 +1233,13 @@ rx_curr_single:
 		if (MWIFIEX_STATUS_SUCCESS !=
 		    mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      (u32 *) &adapter->upld_len,
-					      mbuf, rx_len,
+					      skb->data, skb->len,
 					      adapter->ioport + port)) {
 			ret = MWIFIEX_STATUS_FAILURE;
 			goto done;
 		}
 
-		mwifiex_decode_rx_packet(adapter, mbuf, pkt_type);
+		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 
 	}
 
@@ -1307,8 +1270,7 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	u8 sdio_ireg;
-	struct mwifiex_buffer *mbuf = NULL;
-	u8 *tmp_buf = NULL;
+	struct sk_buff *skb = NULL;
 	u8 port = CTRL_PORT;
 	u32 len_reg_l, len_reg_u;
 	u32 rx_blocks;
@@ -1379,26 +1341,23 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-			mbuf = mwifiex_alloc_buffer_skb(rx_len +
-							 HEADER_ALIGNMENT);
-			if (mbuf == NULL) {
-				PRINTM(MERROR, "Failed to allocate 'struct "
-					"mwifiex_buffer'\n");
+			skb = dev_alloc_skb(rx_len);
+
+			if (!skb) {
+				PRINTM(MERROR, "%s: failed to alloc skb",
+								__func__);
 				ret = MWIFIEX_STATUS_FAILURE;
 				goto done;
 			}
-			mbuf->data_offset = 0;
-			tmp_buf = (u8 *) PTR_ALIGN(mbuf->buffer +
-						     mbuf->data_offset,
-						     HEADER_ALIGNMENT);
-			mbuf->data_offset +=
-				tmp_buf - (mbuf->buffer + mbuf->data_offset);
-			mbuf->data_len = rx_len;
-			PRINTM(MINFO, "rx_len = %d\n", rx_len);
+
+			skb_put(skb, rx_len);
+
+			PRINTM(MINFO, "rx_len = %d skb->len = %d\n", rx_len,
+					skb->len);
 
 			if (MWIFIEX_STATUS_SUCCESS !=
-			    mwifiex_sdio_card_to_host_mp_aggr(adapter, mbuf,
-							      port, rx_len)) {
+			    mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
+							      port)) {
 				u32 cr = 0;
 
 				PRINTM(MERROR,
@@ -1425,7 +1384,7 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 				PRINTM(MINFO, "Config reg val =%x\n", cr);
 				ret = MWIFIEX_STATUS_FAILURE;
-				mwifiex_free_buffer_skb(mbuf);
+				dev_kfree_skb_any(skb);
 				goto done;
 			}
 		}
@@ -1450,7 +1409,7 @@ done:
  */
 static enum mwifiex_status
 mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
-			  u8 type, struct mwifiex_buffer *mbuf,
+			  u8 type, u8 *payload, u32 pkt_len,
 			  struct mwifiex_tx_param *tx_param)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -1458,14 +1417,13 @@ mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	u32 buf_block_len;
 	u32 blk_size;
 	u8 port = CTRL_PORT;
-	u8 *payload = mbuf->buffer + mbuf->data_offset;
 
 	ENTER();
 
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
-	buf_block_len = (mbuf->data_len + blk_size - 1) / blk_size;
-	*(u16 *) &payload[0] = (u16) mbuf->data_len;
+	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
+	*(u16 *) &payload[0] = (u16) pkt_len;
 	*(u16 *) &payload[2] = type;
 
 	/*
@@ -1484,23 +1442,21 @@ mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		adapter->cmd_sent = true;
 		/* Type must be MWIFIEX_TYPE_CMD */
 
-		if (mbuf->data_len <= INTF_HEADER_LEN ||
-		    mbuf->data_len > MWIFIEX_UPLD_SIZE)
+		if (pkt_len <= INTF_HEADER_LEN ||
+		    pkt_len > MWIFIEX_UPLD_SIZE)
 			PRINTM(MWARN, "mwifiex_sdio_host_to_card(): Error: "
 			       "payload=%p, nb=%d\n",
-			       payload, mbuf->data_len);
+			       payload, pkt_len);
 	}
 
 	/* Transfer data to card */
-	mbuf->data_len = buf_block_len * blk_size;
+	pkt_len = buf_block_len * blk_size;
 
 	if (tx_param)
-		ret = mwifiex_host_to_card_mp_aggr(adapter, mbuf,
-				port,
-				tx_param->
-				next_pkt_len);
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
+				port, tx_param->next_pkt_len);
 	else
-		ret = mwifiex_host_to_card_mp_aggr(adapter, mbuf,
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
 				port, 0);
 
 	if (ret != MWIFIEX_STATUS_SUCCESS) {
@@ -1518,9 +1474,8 @@ mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 				adapter->data_sent = false;
 		}
 		DBG_HEXDUMP(MDAT_D, "SDIO Blk Wr",
-				mbuf->buffer + mbuf->data_offset,
-				min_t(u32, mbuf->data_len,
-					MAX_DATA_DUMP_LEN));
+				payload,
+				min_t(u32, pkt_len, MAX_DATA_DUMP_LEN));
 	}
 
 exit:
@@ -1544,7 +1499,7 @@ exit:
  */
 enum mwifiex_status
 mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
-			     struct mwifiex_buffer *mbuf, u8 port,
+			     u8 *payload, u32 pkt_len, u8 port,
 			     u32 next_pkt_len)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -1553,7 +1508,6 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_send_cur_buf = 0;
 	s32 f_precopy_cur_buf = 0;
 	s32 f_postcopy_cur_buf = 0;
-	struct mwifiex_buffer mbuf_aggr;
 
 	ENTER();
 
@@ -1574,14 +1528,13 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			if (!MP_TX_AGGR_PORT_LIMIT_REACHED(card) &&
-			    MP_TX_AGGR_BUF_HAS_ROOM(card, mbuf,
-						    mbuf->data_len)) {
+			    MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
 				f_precopy_cur_buf = 1;
 
-				if (!
-				    (card->
-				     mp_wr_bitmap & (1 << card->curr_wr_port))
-|| !MP_TX_AGGR_BUF_HAS_ROOM(card, mbuf, next_pkt_len)) {
+				if (!(card->mp_wr_bitmap &
+						(1 << card->curr_wr_port))
+						|| !MP_TX_AGGR_BUF_HAS_ROOM(
+							card, next_pkt_len)) {
 					f_send_aggr_buf = 1;
 				}
 			} else {
@@ -1597,7 +1550,7 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				}
 			}
 		} else {
-			if (MP_TX_AGGR_BUF_HAS_ROOM(card, mbuf, mbuf->data_len)
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)
 			    && (card->mp_wr_bitmap & (1 << card->curr_wr_port)))
 				f_precopy_cur_buf = 1;
 			else
@@ -1612,8 +1565,7 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 			/* some packs in Aggr buf already */
 			f_send_aggr_buf = 1;
 
-			if (MP_TX_AGGR_BUF_HAS_ROOM(card, mbuf,
-					mbuf->data_len)) {
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
 				f_precopy_cur_buf = 1;
 			} else {
 				/* No room in Aggr buf, send it */
@@ -1626,7 +1578,7 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (f_precopy_cur_buf) {
 		PRINTM(MDATA, "host_2_card_mp_aggr: Precopy current buffer\n");
-		MP_TX_AGGR_BUF_PUT(card, mbuf, port);
+		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 
 		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    MP_TX_AGGR_PORT_LIMIT_REACHED(card)) {
@@ -1640,12 +1592,8 @@ mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	if (f_send_aggr_buf) {
 		PRINTM(MDATA, "host_2_card_mp_aggr: Send aggregation buffer."
 		       "%d %d\n", card->mpa_tx.start_port, card->mpa_tx.ports);
-
-		memset(&mbuf_aggr, 0, sizeof(struct mwifiex_buffer));
-
-		mbuf_aggr.buffer = (u8 *) card->mpa_tx.buf;
-		mbuf_aggr.data_len = card->mpa_tx.buf_len;
-		ret = mwifiex_write_data_to_card(adapter, &mbuf_aggr,
+		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
+						 card->mpa_tx.buf_len,
 						 (adapter->ioport | 0x1000 |
 						 (card->mpa_tx.ports << 4)) +
 						  card->mpa_tx.start_port);
@@ -1657,13 +1605,13 @@ tx_curr_single:
 	if (f_send_cur_buf) {
 		PRINTM(MDATA, "host_2_card_mp_aggr: Send current buffer %d\n",
 		       port);
-		ret = mwifiex_write_data_to_card(adapter, mbuf,
+		ret = mwifiex_write_data_to_card(adapter, payload, pkt_len,
 						 adapter->ioport + port);
 	}
 
 	if (f_postcopy_cur_buf) {
 		PRINTM(MDATA, "host_2_card_mp_aggr: Postcopy current buffer\n");
-		MP_TX_AGGR_BUF_PUT(card, mbuf, port);
+		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 	}
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 5a70cd8..b5d9166 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -177,13 +177,14 @@
 #define MP_TX_AGGR_IN_PROGRESS(a) (a->mpa_tx.pkt_cnt > 0)
 
 /** SDIO Tx aggregation buffer room for next packet ? */
-#define MP_TX_AGGR_BUF_HAS_ROOM(a, mbuf, len) ((a->mpa_tx.buf_len+len) <= a->mpa_tx.buf_size)
+#define MP_TX_AGGR_BUF_HAS_ROOM(a, len) ((a->mpa_tx.buf_len+len) \
+						<= a->mpa_tx.buf_size)
 
 /** Copy current packet (SDIO Tx aggregation buffer) to SDIO buffer */
-#define MP_TX_AGGR_BUF_PUT(a, mbuf, port) do {                   \
+#define MP_TX_AGGR_BUF_PUT(a, payload, pkt_len, port) do {                   \
 	memmove(&a->mpa_tx.buf[a->mpa_tx.buf_len], \
-			mbuf->buffer+mbuf->data_offset, mbuf->data_len);\
-	a->mpa_tx.buf_len += mbuf->data_len;                        \
+			payload, pkt_len);				\
+	a->mpa_tx.buf_len += pkt_len;                        \
 	if (!a->mpa_tx.pkt_cnt) {                                     \
 		a->mpa_tx.start_port = port;                            \
 	}                                                           \
@@ -229,8 +230,8 @@
 #define MP_RX_AGGR_BUF_HAS_ROOM(a, rx_len)   ((a->mpa_rx.buf_len+rx_len) <= a->mpa_rx.buf_size)
 
 /** Prepare to copy current packet from card to SDIO Rx aggregation buffer */
-#define MP_RX_AGGR_SETUP(a, mbuf, port, rx_len) do {    \
-	a->mpa_rx.buf_len += rx_len;                       \
+#define MP_RX_AGGR_SETUP(a, skb, port) do {    \
+	a->mpa_rx.buf_len += skb->len;                       \
 	if (!a->mpa_rx.pkt_cnt) {                            \
 		a->mpa_rx.start_port = port;                   \
 	}                                                  \
@@ -239,8 +240,8 @@
 	} else {                                             \
 		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt+1)); \
 	}                                                  \
-	a->mpa_rx.mbuf_arr[a->mpa_rx.pkt_cnt] = mbuf;      \
-	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = rx_len;     \
+	a->mpa_rx.skb_arr[a->mpa_rx.pkt_cnt] = skb;      \
+	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = skb->len;     \
 	a->mpa_rx.pkt_cnt++;                               \
 } while (0);
 
@@ -273,7 +274,7 @@ struct mwifiex_sdio_mpa_rx {
 	u16 ports;
 	u16 start_port;
 
-	struct mwifiex_buffer *mbuf_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
+	struct sk_buff *skb_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
 	u32 len_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
 
 	u8 enabled;
@@ -283,7 +284,7 @@ struct mwifiex_sdio_mpa_rx {
 
 enum mwifiex_status mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter
 						 *adapter,
-						 struct mwifiex_buffer *mbuf,
+						 u8 *payload, u32 pkt_len,
 						 u8 port, u32 next_pkt_len);
 
 enum mwifiex_status mwifiex_bus_register(void);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 47e20ad..8165513 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -41,10 +41,11 @@
  */
 enum mwifiex_status
 mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
-			  struct mwifiex_buffer *mbuf)
+			  struct sk_buff *skb)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[mbuf->bss_index];
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
@@ -53,46 +54,12 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 							0x00, 0x00, 0x00 };
 
 	ENTER();
-	local_rx_pd = (struct rxpd *) (mbuf->buffer + mbuf->data_offset);
+	local_rx_pd = (struct rxpd *) (skb->data);
 
 	rx_pkt_hdr =
 		(struct rx_packet_hdr *) ((u8 *) local_rx_pd +
 					local_rx_pd->rx_pkt_offset);
 
-	DBG_HEXDUMP(MDAT_D, "Rx", mbuf->buffer + mbuf->data_offset,
-		    min_t(u32, mbuf->data_len, MAX_DATA_DUMP_LEN));
-
-/** Rx packet type debugging */
-#define RX_PKT_TYPE_DEBUG  0xEF
-/** Small debug type */
-#define DBG_TYPE_SMALL  2
-/** Size of debugging structure */
-#define SIZE_OF_DBG_STRUCT 4
-	if (local_rx_pd->rx_pkt_type == RX_PKT_TYPE_DEBUG) {
-		u8 dbgType;
-		dbgType = *(u8 *) &rx_pkt_hdr->eth803_hdr;
-		if (dbgType == DBG_TYPE_SMALL) {
-			PRINTM(MFW_D, "\n");
-			DBG_HEXDUMP(MFW_D, "FWDBG",
-				    (s8 *) ((u8 *) &rx_pkt_hdr->eth803_hdr +
-					      SIZE_OF_DBG_STRUCT),
-				    local_rx_pd->rx_pkt_length);
-			PRINTM(MFW_D, "FWDBG::\n");
-		}
-		goto done;
-	}
-
-	PRINTM(MINFO,
-	       "RX Data: data_len - local_rx_pd->rx_pkt_offset = "
-	       "%d - %d = %d\n",
-	       mbuf->data_len, local_rx_pd->rx_pkt_offset,
-	       mbuf->data_len - local_rx_pd->rx_pkt_offset);
-
-	HEXDUMP("RX Data: Dest", rx_pkt_hdr->eth803_hdr.h_dest,
-		sizeof(rx_pkt_hdr->eth803_hdr.h_dest));
-	HEXDUMP("RX Data: Src", rx_pkt_hdr->eth803_hdr.h_source,
-		sizeof(rx_pkt_hdr->eth803_hdr.h_source));
-
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
 		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
 		/*
@@ -132,30 +99,18 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 
 	/* Chop off the leading header bytes so the it points to the start of
 	   either the reconstructed EthII frame or the 802.2/llc/snap frame */
-	mbuf->data_len -= hdr_chop;
-	mbuf->data_offset += hdr_chop;
-	mbuf->parent = NULL;
+	skb_pull(skb, hdr_chop);
 
 	priv->rxpd_rate = local_rx_pd->rx_rate;
 
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
 
-	ret = mwifiex_recv_packet(adapter, mbuf);
+	ret = mwifiex_recv_packet(adapter, skb);
 	if (ret == MWIFIEX_STATUS_FAILURE) {
 		PRINTM(MERROR,
 		       "RX Error: mwifiex_recv_packet" " returns failure\n");
 	}
 
-	do_gettimeofday(&mbuf->out_tstamp);
-	PRINTM(MDATA, "%lu.%lu : Data => kernel seq_num=%d tid=%d\n",
-			mbuf->out_tstamp.tv_sec, mbuf->out_tstamp.tv_usec,
-			local_rx_pd->seq_num, local_rx_pd->priority);
-
-	if (ret != MWIFIEX_STATUS_PENDING)
-		mwifiex_recv_complete(adapter, mbuf, 0, ret);
-
-
-done:
 	LEAVE();
 
 	return ret;
@@ -175,18 +130,19 @@ done:
  */
 enum mwifiex_status
 mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
-				struct mwifiex_buffer *mbuf)
+				struct sk_buff *skb)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct rxpd *local_rx_pd;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
-	struct mwifiex_private *priv = adapter->priv[mbuf->bss_index];
 	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
 	u16 rx_pkt_type = 0;
+	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 
 	ENTER();
 
-	local_rx_pd = (struct rxpd *) (mbuf->buffer + mbuf->data_offset);
+	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = local_rx_pd->rx_pkt_type;
 
 	rx_pkt_hdr =
@@ -194,22 +150,17 @@ mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 					local_rx_pd->rx_pkt_offset);
 
 	if ((local_rx_pd->rx_pkt_offset + local_rx_pd->rx_pkt_length) >
-	    (u16) mbuf->data_len) {
+	    (u16) skb->len) {
 		PRINTM(MERROR,
 		       "Wrong rx packet: len=%d, rx_pkt_offset=%d, "
-		       " rx_pkt_length=%d\n", mbuf->data_len,
+		       " rx_pkt_length=%d\n", skb->len,
 		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
-		ret = MWIFIEX_STATUS_FAILURE;
-		mwifiex_recv_complete(adapter, mbuf, 0, ret);
-
+		priv->stats.rx_dropped++;
+		dev_kfree_skb_any(skb);
 		goto done;
 	}
-	mbuf->data_len = local_rx_pd->rx_pkt_offset +
-		local_rx_pd->rx_pkt_length;
 	if (local_rx_pd->rx_pkt_type == PKT_TYPE_AMSDU) {
-		mbuf->data_len = local_rx_pd->rx_pkt_length;
-		mbuf->data_offset += local_rx_pd->rx_pkt_offset;
-		mwifiex_11n_deaggregate_pkt(priv, mbuf);
+		mwifiex_11n_deaggregate_pkt(priv, skb);
 		goto done;
 	}
 	/*
@@ -219,7 +170,7 @@ mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	if (!IS_11N_ENABLED(priv) ||
 	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest,
 		   MWIFIEX_MAC_ADDR_LENGTH)) {
-		mwifiex_process_rx_packet(adapter, mbuf);
+		mwifiex_process_rx_packet(adapter, skb);
 		goto done;
 	}
 
@@ -239,16 +190,14 @@ mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	ret = mwifiex_11n_rx_reorder_pkt(priv, local_rx_pd->seq_num,
 					     local_rx_pd->priority, ta,
 					     (u8) local_rx_pd->rx_pkt_type,
-						(void *) mbuf);
+						(void *) skb);
 
 	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
-		ret = mwifiex_recv_complete(adapter, mbuf, 0, ret);
-		if (ret)
-			PRINTM(MERROR,
-			       "RX Error: mwifiex_recv_complete returns"
-			       " failure\n");
-	}
+		if (priv && (ret == MWIFIEX_STATUS_FAILURE))
+			priv->stats.rx_dropped++;
 
+		dev_kfree_skb_any(skb);
+	}
 done:
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index c4385ef..9dd05e1 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -44,44 +44,32 @@
  */
 void *
 mwifiex_process_sta_txpd(struct mwifiex_private *priv,
-				struct mwifiex_buffer *mbuf)
+				struct sk_buff *skb)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct txpd *local_tx_pd;
-	u8 *head_ptr = NULL;
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 
-	if (!mbuf->data_len) {
+	if (!skb->len) {
 		PRINTM(MERROR, "Tx Error: bad packet length: %d\n",
-		       mbuf->data_len);
-		mbuf->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
+		       skb->len);
+		tx_info->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
 		goto done;
 	}
 
-	if (mbuf->data_offset < (sizeof(struct txpd) + INTF_HEADER_LEN +
-				  HEADER_ALIGNMENT)) {
-		PRINTM(MERROR, "not enough space for struct txpd: %d\n",
-		       mbuf->data_len);
-		mbuf->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
-		goto done;
-	}
-
-	/* head_ptr should be aligned */
-	head_ptr =
-		mbuf->buffer + mbuf->data_offset - sizeof(struct txpd) -
-		INTF_HEADER_LEN;
-	head_ptr =
-		(u8 *) ((unsigned long) head_ptr &
-			  ~((unsigned long) (HEADER_ALIGNMENT - 1)));
+	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN));
+	skb_push(skb, sizeof(*local_tx_pd));
 
-	local_tx_pd = (struct txpd *) (head_ptr + INTF_HEADER_LEN);
+	local_tx_pd = (struct txpd *) skb->data;
 	memset(local_tx_pd, 0, sizeof(struct txpd));
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
-	local_tx_pd->tx_pkt_length = cpu_to_le16((u16) mbuf->data_len);
+	local_tx_pd->tx_pkt_length = cpu_to_le16((u16) (skb->len -
+							sizeof(struct txpd)));
 
-	local_tx_pd->priority = (u8) mbuf->priority;
+	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
-		mwifiex_wmm_compute_drv_pkt_delay(priv, mbuf);
+		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
 	if (local_tx_pd->priority <
 	    ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
@@ -103,23 +91,18 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	}
 
 	/* Offset of actual data */
-	local_tx_pd->tx_pkt_offset =
-		cpu_to_le16((u16) ((unsigned long) mbuf->buffer
-			+ mbuf->data_offset
-			- (unsigned long) local_tx_pd));
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+
+	/* make space for INTF_HEADER_LEN */
+	skb_push(skb, INTF_HEADER_LEN);
 
 	if (!local_tx_pd->tx_control) {
 		/* TxCtrl set by user or default */
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
 	}
 
-	/* Adjust the data offset and length to include struct txpd in mbuf */
-	mbuf->data_len += mbuf->data_offset;
-	mbuf->data_offset = head_ptr - mbuf->buffer;
-	mbuf->data_len -= mbuf->data_offset;
-
 done:
-	return head_ptr;
+	return skb->data;
 }
 
 /*
@@ -136,10 +119,9 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 /* sizeof(struct txpd) + Interface specific header */
 #define NULL_PACKET_HDR 64
 	u32 data_len = NULL_PACKET_HDR;
-	struct mwifiex_buffer *mbuf = NULL;
-	u8 *ptr;
+	struct sk_buff *skb = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct timeval tstamp;
+	struct mwifiex_txinfo *tx_info = NULL;
 
 	ENTER();
 
@@ -158,17 +140,18 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		goto done;
 	}
 
-	mbuf = mwifiex_alloc_buffer(data_len);
-	if (!mbuf) {
+	skb = dev_alloc_skb(data_len);
+	if (!skb) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
-	memset(mbuf->buffer, 0, data_len);
-	mbuf->bss_index = priv->bss_index;
-	mbuf->buf_type = MWIFIEX_BUF_TYPE_DATA;
-	ptr = mbuf->buffer + mbuf->data_offset;
-	mbuf->data_len = sizeof(struct txpd) + INTF_HEADER_LEN;
-	local_tx_pd = (struct txpd *) (ptr + INTF_HEADER_LEN);
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_index = priv->bss_index;
+	skb_reserve(skb, sizeof(struct txpd) + INTF_HEADER_LEN);
+	skb_push(skb, sizeof(struct txpd));
+
+	local_tx_pd = (struct txpd *) skb->data;
 	local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
 	local_tx_pd->flags = flags;
 	local_tx_pd->priority = WMM_HIGHEST_PRIORITY;
@@ -176,22 +159,23 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     mbuf, NULL);
+	skb_push(skb, INTF_HEADER_LEN);
 
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					     skb->data, skb->len, NULL);
 	switch (ret) {
 	case MWIFIEX_STATUS_RESOURCE:
 		adapter->data_sent = true;
 		/* Fall through FAILURE handling */
 	case MWIFIEX_STATUS_FAILURE:
-		mwifiex_free_buffer(mbuf);
+		dev_kfree_skb_any(skb);
 		PRINTM(MERROR,
 		       "TX Error: mwifiex_send_null_packet failed! ret=%d\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		goto done;
 	case MWIFIEX_STATUS_SUCCESS:
-		mwifiex_free_buffer(mbuf);
+		dev_kfree_skb_any(skb);
 		PRINTM(MDATA, "TX: mwifiex_send_null_packet succeeded!\n");
 		adapter->tx_lock_flag = true;
 		break;
@@ -201,11 +185,6 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		break;
 	}
 
-	do_gettimeofday(&tstamp);
-	PRINTM(MDATA, "%lu.%lu : Null data => FW\n",
-	       tstamp.tv_sec, tstamp.tv_usec);
-	DBG_HEXDUMP(MDAT_D, "Null data", ptr,
-		    sizeof(struct txpd) + INTF_HEADER_LEN);
 done:
 	LEAVE();
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 25a3205..ceaf6b7 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -36,16 +36,17 @@
  */
 enum mwifiex_status
 mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
-			 struct mwifiex_buffer *mbuf)
+			 struct sk_buff *skb)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct rxpd *local_rx_pd;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 
 	ENTER();
 
-	local_rx_pd = (struct rxpd *) (mbuf->buffer + mbuf->data_offset);
+	local_rx_pd = (struct rxpd *) (skb->data);
 	/* Get the BSS number from rxpd, get corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, local_rx_pd->bss_num &
 				      BSS_NUM_MASK,
@@ -53,8 +54,8 @@ mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-	mbuf->bss_index = priv->bss_index;
-	ret = mwifiex_process_sta_rx_packet(adapter, mbuf);
+	rx_info->bss_index = priv->bss_index;
+	ret = mwifiex_process_sta_rx_packet(adapter, skb);
 
 	LEAVE();
 	return ret;
@@ -71,29 +72,27 @@ EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
  * and logs the time.
  */
 enum mwifiex_status
-mwifiex_process_tx(struct mwifiex_private *priv, struct mwifiex_buffer *mbuf,
+mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		   struct mwifiex_tx_param *tx_param)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 *head_ptr = NULL;
-	struct timeval tstamp;
 	struct txpd *local_tx_pd = NULL;
 
 	ENTER();
 
-	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, mbuf);
+	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
 	if (!head_ptr) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
-		local_tx_pd = (struct txpd *)head_ptr + INTF_HEADER_LEN;
+		local_tx_pd = (struct txpd *) (head_ptr + INTF_HEADER_LEN);
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     mbuf, tx_param);
-
+					     skb->data, skb->len, tx_param);
 done:
 
 	switch (ret) {
@@ -111,28 +110,18 @@ done:
 		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, mbuf, ret);
+		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
 	case MWIFIEX_STATUS_PENDING:
 		adapter->data_sent = false;
 		break;
 	case MWIFIEX_STATUS_SUCCESS:
-		mwifiex_write_data_complete(adapter, mbuf, ret);
+		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
 	default:
 		break;
 	}
 
-	if ((ret == MWIFIEX_STATUS_SUCCESS) ||
-			(ret == MWIFIEX_STATUS_PENDING)) {
-		do_gettimeofday(&tstamp);
-		PRINTM(MDATA, "%lu.%lu : Data => FW\n",
-		       tstamp.tv_sec, tstamp.tv_usec);
-
-		DBG_HEXDUMP(MDAT_D, "Tx", head_ptr + INTF_HEADER_LEN,
-			    min_t(u32, mbuf->data_len + sizeof(struct txpd),
-				  MAX_DATA_DUMP_LEN));
-	}
 	LEAVE();
 	return ret;
 }
@@ -146,24 +135,45 @@ done:
  */
 enum mwifiex_status
 mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
-			    struct mwifiex_buffer *mbuf,
+			    struct sk_buff *skb,
 			    enum mwifiex_status status)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_private *priv = NULL, *tpriv = NULL;
+	struct mwifiex_txinfo *tx_info = NULL;
+	int i;
 
-	ENTER();
+	if (!skb)
+		return MWIFIEX_STATUS_SUCCESS;
 
-	if (mbuf->buf_type == MWIFIEX_BUF_TYPE_DATA) {
-		PRINTM(MDATA, "mwifiex_write_data_complete: DATA\n");
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, tx_info->bss_index);
+	if (!priv)
+		goto done;
 
-		if (mbuf->flags & MWIFIEX_FLAG_TX_BUF)
-			mwifiex_send_packet_complete(adapter, mbuf, status);
-		else
-			mwifiex_free_buffer(mbuf);
+	priv->netdev->trans_start = jiffies;
+	if (status == MWIFIEX_STATUS_SUCCESS) {
+		priv->stats.tx_packets++;
+		priv->stats.tx_bytes += skb->len;
+	} else {
+		priv->stats.tx_errors++;
 	}
+	atomic_dec(&adapter->tx_pending);
 
-	LEAVE();
-	return ret;
+	for (i = 0; i < adapter->priv_num; i++) {
+
+		tpriv = adapter->priv[i];
+
+		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA)
+				&& (tpriv->media_connected)) {
+
+			if (netif_queue_stopped(tpriv->netdev))
+				netif_wake_queue(tpriv->netdev);
+		}
+	}
+done:
+	dev_kfree_skb_any(skb);
+
+	return MWIFIEX_STATUS_SUCCESS;
 }
 
 /*
@@ -175,36 +185,38 @@ mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
  */
 enum mwifiex_status
 mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
-			     struct mwifiex_buffer *mbuf,
+			     struct sk_buff *skb,
 			     enum mwifiex_status status)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct mwifiex_rxinfo *rx_info_parent = NULL;
 	struct mwifiex_private *priv;
-	struct mwifiex_buffer *mbuf_parent;
+	struct sk_buff *skb_parent = NULL;
 	unsigned long flags;
 
 	ENTER();
 
-	priv = adapter->priv[mbuf->bss_index];
+	priv = adapter->priv[rx_info->bss_index];
+
+	if (priv && (status == MWIFIEX_STATUS_FAILURE))
+		priv->stats.rx_dropped++;
 
-	if (mbuf->parent) {
-		mbuf_parent = mbuf->parent;
+	if (rx_info->parent) {
+		skb_parent = rx_info->parent;
+		rx_info_parent = MWIFIEX_SKB_RXCB(skb_parent);
 
 		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
-		--mbuf_parent->use_count;
-		if (!mbuf_parent->use_count) {
+		--rx_info_parent->use_count;
+
+		if (!rx_info_parent->use_count) {
 			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-			mwifiex_recv_complete(adapter,
-					      mbuf_parent, adapter->ioport,
-					      status);
+			dev_kfree_skb_any(skb_parent);
 		} else {
 			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		}
-
-		mwifiex_free_buffer(mbuf);
 	} else {
-		mwifiex_recv_complete(adapter, mbuf,
-				      adapter->ioport, status);
+		dev_kfree_skb_any(skb);
 	}
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index c16f5f5..0751536 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -242,112 +242,6 @@ mwifiex_get_info_debug_info(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function allocates a driver buffer of given length.
- *
- * This results in one memory chunk, which includes both the driver
- * buffer header structure and the data portion.
- *
- * +--------------..---------------+-----------------..-----------------+
- * |    mwifiex buffer header      |                Data                |
- * +------..------+-------..-------+           (given length)           |
- * | Other fields | buffer pointer |                                    |
- * +------..------+-------..-------+-----------------..-----------------+
- *                        |         ^
- *                        +---------+
- */
-struct mwifiex_buffer *
-mwifiex_alloc_buffer(u32 data_len)
-{
-	struct mwifiex_buffer *mbuf;
-	u32 buf_size =
-		sizeof(struct mwifiex_buffer) + data_len + HEADER_ALIGNMENT;
-
-	ENTER();
-
-	mbuf = kzalloc(buf_size, GFP_KERNEL);
-	if (!mbuf) {
-		PRINTM(MERROR, "%s: failed to alloc struct mwifiex_buffer\n",
-		       __func__);
-		goto exit;
-	}
-
-	mbuf->desc = NULL;
-	/* Align address */
-	mbuf->buffer = (u8 *) mbuf + sizeof(struct mwifiex_buffer);
-	mbuf->buffer = (u8 *) PTR_ALIGN(mbuf->buffer, HEADER_ALIGNMENT);
-	mbuf->data_offset = (u8 *) mbuf->buffer -
-		((u8 *) mbuf + sizeof(struct mwifiex_buffer));
-	mbuf->data_len = data_len;
-
-exit:
-	LEAVE();
-	return mbuf;
-}
-
-/*
- * This function frees a driver buffer.
- */
-void
-mwifiex_free_buffer(struct mwifiex_buffer *mbuf)
-{
-	ENTER();
-
-	kfree(mbuf);
-
-	LEAVE();
-	return;
-}
-
-/*
- * Send packet completion callback handler.
- *
- * This function updates the statistics and frees the buffer SKB.
- */
-enum mwifiex_status
-mwifiex_send_packet_complete(struct mwifiex_adapter *adapter,
-			     struct mwifiex_buffer *mbuf,
-			     enum mwifiex_status status)
-{
-	struct mwifiex_private *priv = NULL;
-	struct sk_buff *skb = NULL;
-	int i;
-	ENTER();
-	if (mbuf) {
-		priv = mwifiex_bss_index_to_priv(adapter, mbuf->bss_index);
-		skb = (struct sk_buff *) mbuf->desc;
-		if (priv) {
-			priv->netdev->trans_start = jiffies;
-			if (skb) {
-				if (status == MWIFIEX_STATUS_SUCCESS) {
-					priv->stats.tx_packets++;
-					priv->stats.tx_bytes += skb->len;
-				} else {
-					priv->stats.tx_errors++;
-				}
-				atomic_dec(&adapter->tx_pending);
-				for (i = 0; i < adapter->priv_num; i++) {
-					if ((GET_BSS_ROLE(adapter->priv[i]) ==
-					     MWIFIEX_BSS_ROLE_STA)
-					    && (adapter->priv[i]->
-						media_connected)) {
-						if (netif_queue_stopped
-						    (adapter->priv[i]->netdev))
-							netif_wake_queue
-								(adapter->
-								 priv[i]->
-								 netdev);
-					}
-				}
-			}
-		}
-		if (skb)
-			dev_kfree_skb_any(skb);
-	}
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
  * This function processes the received packet before sending it to the
  * kernel.
  *
@@ -357,58 +251,32 @@ mwifiex_send_packet_complete(struct mwifiex_adapter *adapter,
  * received buffer and then sends this new SKB to the kernel.
  */
 enum mwifiex_status
-mwifiex_recv_packet(struct mwifiex_adapter *adapter,
-			struct mwifiex_buffer *mbuf)
+mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_rxinfo *rx_info = NULL;
 	struct mwifiex_private *priv = NULL;
-	struct sk_buff *skb = NULL;
-
 	ENTER();
 
-	if (mbuf) {
-		priv = mwifiex_bss_index_to_priv(adapter, mbuf->bss_index);
-		skb = (struct sk_buff *) mbuf->desc;
-		if (priv) {
-			if (skb) {
-				skb_reserve(skb, mbuf->data_offset);
-				skb_put(skb, mbuf->data_len);
-				mbuf->desc = NULL;
-				mbuf->buffer = NULL;
-				mbuf->data_len = 0;
-				mbuf->data_offset = mbuf->data_len;
-			} else {
-				PRINTM(MERROR, "%s without skb attach!!!\n",
-					      __func__);
-				skb = dev_alloc_skb(mbuf->data_len);
-				if (!skb) {
-					PRINTM(MERROR, "%s fail to alloc skb\n",
-					       __func__);
-					status = MWIFIEX_STATUS_FAILURE;
-					priv->stats.rx_dropped++;
-					goto done;
-				}
-
-				memcpy(skb->data,
-				       (u8 *) (mbuf->buffer +
-						 mbuf->data_offset),
-				       mbuf->data_len);
-				skb_put(skb, mbuf->data_len);
-			}
-			skb->dev = priv->netdev;
-			skb->protocol = eth_type_trans(skb, priv->netdev);
-			skb->ip_summed = CHECKSUM_NONE;
-			priv->stats.rx_bytes += skb->len;
-			priv->stats.rx_packets++;
-			if (in_interrupt())
-				netif_rx(skb);
-			else
-				netif_rx_ni(skb);
-		}
-	}
-done:
+	if (!skb)
+		return MWIFIEX_STATUS_FAILURE;
+
+	rx_info = MWIFIEX_SKB_RXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
+	if (!priv)
+		return MWIFIEX_STATUS_FAILURE;
+
+	skb->dev = priv->netdev;
+	skb->protocol = eth_type_trans(skb, priv->netdev);
+	skb->ip_summed = CHECKSUM_NONE;
+	priv->stats.rx_bytes += skb->len;
+	priv->stats.rx_packets++;
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
+
 	LEAVE();
-	return status;
+	return MWIFIEX_STATUS_SUCCESS;
 }
 
 /*
@@ -418,22 +286,22 @@ done:
  */
 enum mwifiex_status
 mwifiex_recv_complete(struct mwifiex_adapter *adapter,
-		      struct mwifiex_buffer *mbuf, u32 port,
-		      enum mwifiex_status status)
+		struct sk_buff *skb, enum mwifiex_status status)
 {
 	struct mwifiex_private *priv = NULL;
+	struct mwifiex_rxinfo *rx_info = NULL;
 
-	ENTER();
+	if (!skb)
+		return MWIFIEX_STATUS_SUCCESS;
+
+	rx_info = MWIFIEX_SKB_RXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
+
+	if (priv && (status == MWIFIEX_STATUS_FAILURE))
+		priv->stats.rx_dropped++;
+
+	dev_kfree_skb_any(skb);
 
-	if (mbuf) {
-		priv = mwifiex_bss_index_to_priv(adapter, mbuf->bss_index);
-		if (priv && (mbuf->buf_type == MWIFIEX_BUF_TYPE_DATA) &&
-		    (status == MWIFIEX_STATUS_FAILURE)) {
-			priv->stats.rx_dropped++;
-		}
-		mwifiex_free_buffer_skb(mbuf);
-	}
-	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
 
@@ -619,69 +487,3 @@ done:
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
-
-/*
- * This function allocates a driver buffer and a linked SKB of given
- * length.
- *
- * This results in two memory chunks, one is the driver buffer header
- * structure and the other is a SKB. The SKB is used as the driver buffer
- * data portion.
- *
- * +--------------..---------------+    +-------------..--------------+
- * |    mwifiex buffer header      |    |            SKB              |
- * +------..------+-------..-------+    +       (given length)        |
- * | Other fields | buffer pointer |    |                             |
- * +------..------+-------..-------+    +-------------..--------------+
- *                        |             ^
- *                        +-------------+
- */
-struct mwifiex_buffer *
-mwifiex_alloc_buffer_skb(int size)
-{
-	struct mwifiex_buffer *mbuf;
-	struct sk_buff *skb;
-
-	ENTER();
-
-	mbuf = kzalloc(sizeof(struct mwifiex_buffer), GFP_KERNEL);
-	if (!mbuf) {
-		PRINTM(MERROR, "%s: failed to alloc struct mwifiex_buffer",
-		       __func__);
-		goto exit;
-	}
-
-	skb = dev_alloc_skb(size);
-	if (!skb) {
-		kfree(mbuf);
-		mbuf = NULL;
-		PRINTM(MERROR, "%s: failed to alloc skb", __func__);
-		goto exit;
-	}
-
-	mbuf->desc = (void *) skb;
-	mbuf->buffer = (u8 *) skb->data;
-
-exit:
-	LEAVE();
-	return mbuf;
-}
-EXPORT_SYMBOL_GPL(mwifiex_alloc_buffer_skb);
-
-/*
- * This function frees a driver buffer and its linked SKB.
- */
-void
-mwifiex_free_buffer_skb(struct mwifiex_buffer *mbuf)
-{
-	ENTER();
-
-	if (mbuf->desc)
-		dev_kfree_skb_any((struct sk_buff *) mbuf->desc);
-
-	kfree(mbuf);
-
-	LEAVE();
-	return;
-}
-EXPORT_SYMBOL_GPL(mwifiex_free_buffer_skb);
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index eaf4b06..51ffff2 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -103,4 +103,13 @@ do {                \
 	mwifiex_print(MHEX_DUMP | MINFO, x, y, z); \
 } while (0)
 
+static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
+{
+	return (struct mwifiex_rxinfo *)skb->cb;
+}
+
+static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
+{
+	return (struct mwifiex_txinfo *)skb->cb;
+}
 #endif /* !_MWIFIEX_UTIL_H_ */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 95126ad..0b3d71d 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -122,8 +122,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 		goto done;
 	}
 	INIT_LIST_HEAD(&ra_list->list);
-	INIT_LIST_HEAD(&ra_list->buf_head);
-	spin_lock_init(&ra_list->ra_list_tbl_lock);
+	skb_queue_head_init(&ra_list->skb_head);
 
 	memcpy(ra_list->ra, ra, MWIFIEX_MAC_ADDR_LENGTH);
 
@@ -547,19 +546,13 @@ static void
 mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 				    struct mwifiex_ra_list_tbl *ra_list)
 {
-	struct mwifiex_buffer *mbuf, *tmp_node;
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct sk_buff *skb, *tmp;
 
-	ENTER();
-
-	list_for_each_entry_safe(mbuf, tmp_node, &ra_list->buf_head, list) {
-		list_del(&mbuf->list);
-		mwifiex_write_data_complete(adapter, mbuf,
-				MWIFIEX_STATUS_FAILURE);
+	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp) {
+		mwifiex_write_data_complete(adapter, skb,
+					     MWIFIEX_STATUS_FAILURE);
 	}
-	list_del(&ra_list->buf_head);
-
-	LEAVE();
 }
 
 /*
@@ -708,9 +701,10 @@ mwifiex_is_ralist_valid(struct mwifiex_private *priv,
  */
 void
 mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
-			    struct mwifiex_buffer *mbuf)
+			    struct sk_buff *skb)
 {
-	struct mwifiex_private *priv = adapter->priv[mbuf->bss_index];
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+	struct mwifiex_private *priv = adapter->priv[tx_info->bss_index];
 	u32 tid;
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH], tid_down;
@@ -718,17 +712,15 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	ENTER();
 
-	mbuf->buf_type = MWIFIEX_BUF_TYPE_DATA;
-
 	if (!priv->media_connected) {
 		PRINTM(MWARN, "Drop packet in disconnect\n");
-		mwifiex_write_data_complete(adapter, mbuf,
+		mwifiex_write_data_complete(adapter, skb,
 					    MWIFIEX_STATUS_FAILURE);
 		LEAVE();
 		return;
 	}
 
-	tid = mbuf->priority;
+	tid = skb->priority;
 
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
@@ -747,23 +739,22 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 		else
 			ra_list = NULL;
 	} else {
-		memcpy(ra, mbuf->buffer + mbuf->data_offset,
-		       MWIFIEX_MAC_ADDR_LENGTH);
+		memcpy(ra, skb->data, MWIFIEX_MAC_ADDR_LENGTH);
 		ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down, ra);
 	}
 
 	if (!ra_list) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		mwifiex_send_packet_complete(adapter, mbuf,
+		mwifiex_write_data_complete(adapter, skb,
 					     MWIFIEX_STATUS_FAILURE);
 		LEAVE();
 		return;
 	}
 
-	PRINTM(MDAT_D, "Adding pkt to ra_list %p %p\n", ra_list, mbuf);
-	list_add_tail(&mbuf->list, &ra_list->buf_head);
+	PRINTM(MDAT_D, "Adding pkt to ra_list %p %p\n", ra_list, skb);
+	skb_queue_tail(&ra_list->skb_head, skb);
 
-	ra_list->total_pkts_size += mbuf->data_len;
+	ra_list->total_pkts_size += skb->len;
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
@@ -942,18 +933,19 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
  */
 u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
-					const struct mwifiex_buffer *mbuf)
+					const struct sk_buff *skb)
 {
 	u8 ret_val = 0;
-	struct timeval out_tstamp;
+	struct timeval out_tstamp, in_tstamp;
 	u32 queue_delay;
 
 	ENTER();
 
 	do_gettimeofday(&out_tstamp);
+	in_tstamp = ktime_to_timeval(skb->tstamp);
 
-	queue_delay = (out_tstamp.tv_sec - mbuf->in_tstamp.tv_sec) * 1000;
-	queue_delay += (out_tstamp.tv_usec - mbuf->in_tstamp.tv_usec) / 1000;
+	queue_delay = (out_tstamp.tv_sec - in_tstamp.tv_sec) * 1000;
+	queue_delay += (out_tstamp.tv_usec - in_tstamp.tv_usec) / 1000;
 
 	/*
 	 * Queue delay is passed as a uint8 in units of 2ms (ms shifted
@@ -1052,14 +1044,8 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				}
 
 				do {
-					spin_lock_irqsave(
-							&ptr->ra_list_tbl_lock,
-							flags);
 					is_list_empty =
-						list_empty(&ptr->buf_head);
-					spin_unlock_irqrestore(
-							&ptr->ra_list_tbl_lock,
-							flags);
+						skb_queue_empty(&ptr->skb_head);
 					if (!is_list_empty) {
 						*priv = priv_tmp;
 						*tid = tos_to_tid[i];
@@ -1108,12 +1094,12 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
 			struct mwifiex_ra_list_tbl *ptr, int max_buf_size)
 {
 	int count = 0, total_size = 0;
-	struct mwifiex_buffer *mbuf;
+	struct sk_buff *skb, *tmp;
 
 	ENTER();
 
-	list_for_each_entry(mbuf, &ptr->buf_head, list) {
-		total_size += mbuf->data_len;
+	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
+		total_size += skb->len;
 		if (total_size < max_buf_size)
 			++count;
 		else
@@ -1133,69 +1119,61 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 			   unsigned long ra_list_flags)
 			   __releases(&priv->wmm.ra_list_spinlock)
 {
-	struct mwifiex_buffer *mbuf;
-	struct mwifiex_buffer *mbuf_next;
+	struct sk_buff *skb, *skb_next;
 	struct mwifiex_tx_param tx_param;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	unsigned long ra_list_tbl_flags;
+	struct mwifiex_txinfo *tx_info;
 
 	ENTER();
 
-	spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
-	if (list_empty(&ptr->buf_head)) {
-		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		PRINTM(MDATA, "Nothing to send\n");
 		return;
 	}
-	mbuf = list_first_entry(&ptr->buf_head,
-				struct mwifiex_buffer, list);
-	list_del(&mbuf->list);
-	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
 
-	PRINTM(MDATA, "Dequeuing the packet %p %p\n", ptr, mbuf);
+	skb = skb_dequeue(&ptr->skb_head);
 
-	ptr->total_pkts_size -= mbuf->data_len;
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	PRINTM(MDATA, "Dequeuing the packet %p %p\n", ptr, skb);
 
-	if (!list_empty(&ptr->buf_head))
-		mbuf_next = list_first_entry(&ptr->buf_head,
-					     struct mwifiex_buffer, list);
+	ptr->total_pkts_size -= skb->len;
+
+	if (!skb_queue_empty(&ptr->skb_head))
+		skb_next = skb_peek(&ptr->skb_head);
 	else
-		mbuf_next = NULL;
+		skb_next = NULL;
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 	tx_param.next_pkt_len =
-		((mbuf_next) ? mbuf_next->data_len +
+		((skb_next) ? skb_next->len +
 		 sizeof(struct txpd) : 0);
-	status = mwifiex_process_tx(priv, mbuf, &tx_param);
+
+	status = mwifiex_process_tx(priv, skb, &tx_param);
 
 	if (status == MWIFIEX_STATUS_RESOURCE) {
 		/** Queue the packet back at the head */
 		PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
-		       ptr, mbuf);
+		       ptr, skb);
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			spin_unlock_irqrestore(
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
-			mwifiex_write_data_complete(adapter, mbuf,
+			mwifiex_write_data_complete(adapter, skb,
 					MWIFIEX_STATUS_FAILURE);
 			LEAVE();
 			return;
 		}
 
-		spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
-		list_add(&mbuf->list, &ptr->buf_head);
-		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+		skb_queue_tail(&ptr->skb_head, skb);
 
-		ptr->total_pkts_size += mbuf->data_len;
-		mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		ptr->total_pkts_size += skb->len;
+		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	} else {
@@ -1226,14 +1204,16 @@ static int
 mwifiex_is_ptr_processed(struct mwifiex_private *priv,
 			 struct mwifiex_ra_list_tbl *ptr)
 {
-	struct mwifiex_buffer *mbuf;
+	struct sk_buff *skb;
+	struct mwifiex_txinfo *tx_info;
 
-	if (list_empty(&ptr->buf_head))
+	if (skb_queue_empty(&ptr->skb_head))
 		return false;
 
-	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
+	skb = skb_peek(&ptr->skb_head);
 
-	if (mbuf->flags & MWIFIEX_BUF_FLAG_REQUEUED_PKT)
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_REQUEUED_PKT)
 		return true;
 
 	return false;
@@ -1249,41 +1229,36 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			      unsigned long ra_list_flags)
 				__releases(&priv->wmm.ra_list_spinlock)
 {
-	struct mwifiex_buffer *mbuf_next;
 	struct mwifiex_tx_param tx_param;
-	struct mwifiex_buffer *mbuf;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
-	unsigned long ra_list_tbl_flags;
+	struct sk_buff *skb, *skb_next;
+	struct mwifiex_txinfo *tx_info;
 
 	ENTER();
 
-	spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
-	if (list_empty(&ptr->buf_head)) {
-		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		return;
 	}
 
-	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
-
-	list_del(&mbuf->list);
-	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+	skb = skb_dequeue(&ptr->skb_head);
 
-	if (!list_empty(&ptr->buf_head))
-		mbuf_next = list_first_entry(&ptr->buf_head,
-					     struct mwifiex_buffer, list);
+	if (!skb_queue_empty(&ptr->skb_head))
+		skb_next = skb_peek(&ptr->skb_head);
 	else
-		mbuf_next = NULL;
+		skb_next = NULL;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 	tx_param.next_pkt_len =
-		((mbuf_next) ? mbuf_next->data_len +
+		((skb_next) ? skb_next->len +
 		 sizeof(struct txpd) : 0);
 	ret = adapter->if_ops.host_to_card(adapter,
-					     MWIFIEX_TYPE_DATA, mbuf,
+					     MWIFIEX_TYPE_DATA,
+					     skb->data, skb->len,
 					     &tx_param);
 	switch (ret) {
 	case MWIFIEX_STATUS_RESOURCE:
@@ -1294,18 +1269,15 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
-			mwifiex_write_data_complete(adapter, mbuf,
+			mwifiex_write_data_complete(adapter, skb,
 					MWIFIEX_STATUS_FAILURE);
 			LEAVE();
 			return;
 		}
 
-		spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
-		list_add(&mbuf->list, &ptr->buf_head);
-		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
-				       ra_list_tbl_flags);
+		skb_queue_tail(&ptr->skb_head, skb);
 
-		mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		break;
@@ -1314,7 +1286,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		PRINTM(MERROR,
 		       "Error: mwifiex_write_data failed: 0x%X\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, mbuf, ret);
+		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
 	case MWIFIEX_STATUS_PENDING:
 		adapter->data_sent = false;
@@ -1328,7 +1300,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
 				ptr;
 		}
-		/* Now bss_prio_cur pointer points to next node */
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
 				&adapter->bss_prio_tbl[priv->bss_priority]
@@ -1425,7 +1396,6 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 			   mwifiex_send_single_packet() */
 		}
 	}
-
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 4d76b85..37c6032 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -27,21 +27,14 @@ static inline int
 mwifiex_get_tid(struct mwifiex_adapter *adapter,
 		struct mwifiex_ra_list_tbl *ptr)
 {
-	struct mwifiex_buffer *mbuf;
-	unsigned long flags;
+	struct sk_buff *skb;
 
-	ENTER();
-
-	spin_lock_irqsave(&ptr->ra_list_tbl_lock, flags);
-	if (list_empty(&ptr->buf_head)) {
-		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, flags);
+	if (skb_queue_empty(&ptr->skb_head))
 		return 0;
-	}
-	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
-	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, flags);
 
-	LEAVE();
-	return mbuf->priority;
+	skb = skb_peek(&ptr->skb_head);
+
+	return skb->priority;
 }
 
 /*
@@ -72,12 +65,9 @@ mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 	int is_list_empty;
-	unsigned long flags;
 
 	list_for_each_entry(ra_list, ra_list_hhead, list) {
-		spin_lock_irqsave(&ra_list->ra_list_tbl_lock, flags);
-		is_list_empty = list_empty(&ra_list->buf_head);
-		spin_unlock_irqrestore(&ra_list->ra_list_tbl_lock, flags);
+		is_list_empty = skb_queue_empty(&ra_list->skb_head);
 		if (!is_list_empty)
 			return false;
 	}
@@ -88,7 +78,7 @@ mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
 struct mwifiex_ra_list_tbl *mwifiex_wmm_allocate_ralist_node(
 				struct mwifiex_adapter *adapter, u8 *ra);
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
-				 struct mwifiex_buffer *mbuf);
+				 struct sk_buff *skb);
 void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
 
@@ -99,8 +89,7 @@ int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 			    struct mwifiex_ra_list_tbl *ra_list, int tid);
 
 u8 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
-					     const struct mwifiex_buffer
-					     *mbuf);
+					     const struct sk_buff *skb);
 void mwifiex_wmm_init(struct mwifiex_adapter *adapter);
 void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv);
 
-- 
1.7.0.2

