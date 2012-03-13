Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:46717 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758738Ab2CMCgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:36:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/15] mwifiex: fix checkpatch --strict warnings/errors  Part 1
Date: Mon, 12 Mar 2012 19:35:14 -0700
Message-Id: <1331606116-32745-8-git-send-email-bzhao@marvell.com> (sfid-20120313_033604_988374_A308B15E)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files 11n.c, 11n.h, 11n_aggr.c, 11n_rxreorder.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   22 +++++++-------
 drivers/net/wireless/mwifiex/11n.h           |    7 ++---
 drivers/net/wireless/mwifiex/11n_aggr.c      |   15 +++++-----
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   38 +++++++++++++------------
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index aeb456d..a5e182b 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -44,16 +44,16 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 
 	ht_cap->ht_cap.ampdu_params_info =
 		(sband->ht_cap.ampdu_factor &
-		 IEEE80211_HT_AMPDU_PARM_FACTOR)|
+		 IEEE80211_HT_AMPDU_PARM_FACTOR) |
 		((sband->ht_cap.ampdu_density <<
 		 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT) &
 		 IEEE80211_HT_AMPDU_PARM_DENSITY);
 
 	memcpy((u8 *) &ht_cap->ht_cap.mcs, &sband->ht_cap.mcs,
-						sizeof(sband->ht_cap.mcs));
+	       sizeof(sband->ht_cap.mcs));
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
-			(sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+	    sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
@@ -389,9 +389,9 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		if ((sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-			&& (bss_desc->bcn_ht_info->ht_param &
-				IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
+		    bss_desc->bcn_ht_info->ht_param &
+		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
 					  (bss_desc->bcn_ht_info->ht_param &
@@ -464,7 +464,7 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	tx_buf = min(priv->adapter->max_tx_buf_size, max_amsdu);
 
 	dev_dbg(priv->adapter->dev, "info: max_amsdu=%d, max_tx_buf=%d\n",
-			max_amsdu, priv->adapter->max_tx_buf_size);
+		max_amsdu, priv->adapter->max_tx_buf_size);
 
 	if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_2K)
 		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
@@ -504,7 +504,7 @@ void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 				struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
 {
 	if (!tx_ba_tsr_tbl &&
-			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
+	    mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
 		return;
 
 	dev_dbg(priv->adapter->dev, "info: tx_ba_tsr_tbl %p\n", tx_ba_tsr_tbl);
@@ -548,8 +548,8 @@ mwifiex_get_ba_tbl(struct mwifiex_private *priv, int tid, u8 *ra)
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, ETH_ALEN))
-		    && (tx_ba_tsr_tbl->tid == tid)) {
+		if (!memcmp(tx_ba_tsr_tbl->ra, ra, ETH_ALEN) &&
+		    tx_ba_tsr_tbl->tid == tid) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
 					       flags);
 			return tx_ba_tsr_tbl;
@@ -718,7 +718,7 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
 		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
-						__func__, rx_reo_tbl->tid);
+			__func__, rx_reo_tbl->tid);
 		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra, ETH_ALEN);
 		rx_reo_tbl++;
 		count++;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 139aa6e..77646d7 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -86,9 +86,8 @@ mwifiex_is_ampdu_allowed(struct mwifiex_private *priv, int tid)
 static inline u8
 mwifiex_is_amsdu_allowed(struct mwifiex_private *priv, int tid)
 {
-	return (((priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED)
-			&& ((priv->is_data_rate_auto)
-			|| !((priv->bitmap_rates[2]) & 0x03)))
+	return (((priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED) &&
+		 (priv->is_data_rate_auto || !(priv->bitmap_rates[2] & 0x03)))
 		? true : false);
 }
 
@@ -149,7 +148,7 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv, int ptr_tid,
  */
 static inline int
 mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
-			  struct mwifiex_ra_list_tbl *ptr, int tid)
+			   struct mwifiex_ra_list_tbl *ptr, int tid)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
 
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index ea6832d..9eefb2a 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -84,7 +84,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	/* Add payload */
 	skb_put(skb_aggr, skb_src->len);
 	memcpy(skb_aggr->data + sizeof(*tx_header), skb_src->data,
-							skb_src->len);
+	       skb_src->len);
 	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
 						      LLC_SNAP_LEN)) & 3)) : 0;
 	skb_put(skb_aggr, *pad);
@@ -119,14 +119,14 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
 	local_tx_pd->tx_pkt_type = cpu_to_le16(PKT_TYPE_AMSDU);
 	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
-			sizeof(*local_tx_pd));
+						 sizeof(*local_tx_pd));
 
 	if (local_tx_pd->tx_control == 0)
 		/* TxCtrl set by user or default */
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
 
-	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-		(priv->adapter->pps_uapsd_mode)) {
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
+	    priv->adapter->pps_uapsd_mode) {
 		if (true == mwifiex_check_last_packet_indication(priv)) {
 			priv->adapter->tx_lock_flag = true;
 			local_tx_pd->flags =
@@ -257,9 +257,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			mwifiex_write_data_complete(adapter, skb_aggr, -1);
 			return -1;
 		}
-		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-			(adapter->pps_uapsd_mode) &&
-			(adapter->tx_lock_flag)) {
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
+		    adapter->pps_uapsd_mode && adapter->tx_lock_flag) {
 				priv->adapter->tx_lock_flag = false;
 				if (ptx_pd)
 					ptx_pd->flags = 0;
@@ -279,7 +278,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	case -1:
 		adapter->data_sent = false;
 		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
-						__func__, ret);
+			__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		return 0;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 06f5d36..f5c5cfb 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -220,7 +220,7 @@ mwifiex_flush_data(unsigned long context)
  */
 static void
 mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
-				 int tid, int win_size, int seq_num)
+				  int tid, int win_size, int seq_num)
 {
 	int i;
 	struct mwifiex_rx_reorder_tbl *tbl, *new_node;
@@ -240,7 +240,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl), GFP_KERNEL);
 	if (!new_node) {
 		dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
-		       __func__);
+			__func__);
 		return;
 	}
 
@@ -352,7 +352,8 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	cmd_addba_req->block_ack_param_set = cpu_to_le16(block_ack_param_set);
 
 	mwifiex_11n_create_rx_reorder_tbl(priv, cmd_addba_req->peer_mac_addr,
-			    tid, win_size, le16_to_cpu(cmd_addba_req->ssn));
+					  tid, win_size,
+					  le16_to_cpu(cmd_addba_req->ssn));
 	return 0;
 }
 
@@ -416,11 +417,11 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	 * packet
 	 */
 	if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
-		if (seq_num >= ((start_win + (TWOPOW11)) & (MAX_TID_VALUE - 1))
-				&& (seq_num < start_win))
+		if (seq_num >= ((start_win + TWOPOW11) &
+				(MAX_TID_VALUE - 1)) && (seq_num < start_win))
 			return -1;
-	} else if ((seq_num < start_win)
-			|| (seq_num > (start_win + (TWOPOW11)))) {
+	} else if ((seq_num < start_win) ||
+		   (seq_num > (start_win + TWOPOW11))) {
 		return -1;
 	}
 
@@ -431,10 +432,11 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	if (pkt_type == PKT_TYPE_BAR)
 		seq_num = ((seq_num + win_size) - 1) & (MAX_TID_VALUE - 1);
 
-	if (((end_win < start_win)
-	     && (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win)))
-	     && (seq_num > end_win)) || ((end_win > start_win)
-	     && ((seq_num > end_win) || (seq_num < start_win)))) {
+	if (((end_win < start_win) &&
+	     (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win))) &&
+	     (seq_num > end_win)) ||
+	    ((end_win > start_win) && ((seq_num > end_win) ||
+				       (seq_num < start_win)))) {
 		end_win = seq_num;
 		if (((seq_num - win_size) + 1) >= 0)
 			start_win = (end_win - win_size) + 1;
@@ -484,14 +486,14 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		cleanup_rx_reorder_tbl = (initiator) ? false : true;
 
 	dev_dbg(priv->adapter->dev, "event: DELBA: %pM tid=%d, "
-	       "initiator=%d\n", peer_mac, tid, initiator);
+		"initiator=%d\n", peer_mac, tid, initiator);
 
 	if (cleanup_rx_reorder_tbl) {
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 								 peer_mac);
 		if (!tbl) {
 			dev_dbg(priv->adapter->dev,
-					"event: TID, TA not found in table\n");
+				"event: TID, TA not found in table\n");
 			return;
 		}
 		mwifiex_del_rx_reorder_entry(priv, tbl);
@@ -499,7 +501,7 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
 			dev_dbg(priv->adapter->dev,
-					"event: TID, RA not found in table\n");
+				"event: TID, RA not found in table\n");
 			return;
 		}
 
@@ -539,12 +541,12 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 			>> BLOCKACKPARAM_WINSIZE_POS;
 
 		dev_dbg(priv->adapter->dev, "cmd: ADDBA RSP: %pM"
-		       " tid=%d ssn=%d win_size=%d\n",
-		       add_ba_rsp->peer_mac_addr,
-		       tid, add_ba_rsp->ssn, win_size);
+			" tid=%d ssn=%d win_size=%d\n",
+			add_ba_rsp->peer_mac_addr,
+			tid, add_ba_rsp->ssn, win_size);
 	} else {
 		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
-				add_ba_rsp->peer_mac_addr, tid);
+			add_ba_rsp->peer_mac_addr, tid);
 
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 						     add_ba_rsp->peer_mac_addr);
-- 
1.7.0.2

