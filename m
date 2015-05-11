Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11650 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbbEKNt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:49:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4BDmstF004707
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:49:26 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1u9729wwx0-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:49:23 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/4] mwifiex: change dbg print func to mwifiex_dbg
Date: Tue, 12 May 2015 00:48:20 +0530
Message-ID: <1431371900-7260-4-git-send-email-patila@marvell.com> (sfid-20150511_154943_972490_8FDFFEAB)
In-Reply-To: <1431371900-7260-1-git-send-email-patila@marvell.com>
References: <1431371900-7260-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch changes all debug print functions from dev_dbg/dev_err/dev_info
to mwifiex specific debug functions.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c           |  48 +--
 drivers/net/wireless/mwifiex/11n.c           |  24 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   7 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  51 +--
 drivers/net/wireless/mwifiex/cfg80211.c      | 462 ++++++++++++----------
 drivers/net/wireless/mwifiex/cfp.c           |  50 ++-
 drivers/net/wireless/mwifiex/cmdevt.c        | 354 +++++++++--------
 drivers/net/wireless/mwifiex/debugfs.c       |   3 +-
 drivers/net/wireless/mwifiex/ethtool.c       |   6 +-
 drivers/net/wireless/mwifiex/init.c          |  53 +--
 drivers/net/wireless/mwifiex/join.c          | 208 +++++-----
 drivers/net/wireless/mwifiex/main.c          | 109 +++---
 drivers/net/wireless/mwifiex/pcie.c          | 550 +++++++++++++++------------
 drivers/net/wireless/mwifiex/scan.c          | 374 ++++++++++--------
 drivers/net/wireless/mwifiex/sdio.c          | 424 ++++++++++++---------
 drivers/net/wireless/mwifiex/sta_cmd.c       | 136 ++++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c   | 181 ++++-----
 drivers/net/wireless/mwifiex/sta_event.c     | 130 ++++---
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 145 ++++---
 drivers/net/wireless/mwifiex/sta_rx.c        |  13 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |  18 +-
 drivers/net/wireless/mwifiex/tdls.c          |  86 +++--
 drivers/net/wireless/mwifiex/txrx.c          |  25 +-
 drivers/net/wireless/mwifiex/uap_cmd.c       |  20 +-
 drivers/net/wireless/mwifiex/uap_event.c     |  44 ++-
 drivers/net/wireless/mwifiex/uap_txrx.c      |  36 +-
 drivers/net/wireless/mwifiex/usb.c           | 141 ++++---
 drivers/net/wireless/mwifiex/util.c          |  24 +-
 drivers/net/wireless/mwifiex/wmm.c           |  98 ++---
 29 files changed, 2122 insertions(+), 1698 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 3ab87a8..65cd461 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -134,8 +134,8 @@ void mwifiex_dfs_cac_work_queue(struct work_struct *work)
 
 	chandef = priv->dfs_chandef;
 	if (priv->wdev.cac_started) {
-		dev_dbg(priv->adapter->dev,
-			"CAC timer finished; No radar detected\n");
+		mwifiex_dbg(priv->adapter, MSG,
+			    "CAC timer finished; No radar detected\n");
 		cfg80211_cac_event(priv->netdev, &chandef,
 				   NL80211_RADAR_CAC_FINISHED,
 				   GFP_KERNEL);
@@ -161,9 +161,9 @@ int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 	cr_req->chan_desc.chan_width = radar_params->chandef->width;
 	cr_req->msec_dwell_time = cpu_to_le32(radar_params->cac_time_ms);
 
-	dev_dbg(priv->adapter->dev,
-		"11h: issuing DFS Radar check for channel=%d\n",
-		radar_params->chandef->chan->hw_value);
+	mwifiex_dbg(priv->adapter, MSG,
+		    "11h: issuing DFS Radar check for channel=%d\n",
+		    radar_params->chandef->chan->hw_value);
 
 	return 0;
 }
@@ -174,8 +174,8 @@ int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 void mwifiex_abort_cac(struct mwifiex_private *priv)
 {
 	if (priv->wdev.cac_started) {
-		dev_dbg(priv->adapter->dev,
-			"Aborting delayed work for CAC.\n");
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Aborting delayed work for CAC.\n");
 		cancel_delayed_work_sync(&priv->dfs_cac_work);
 		cfg80211_cac_event(priv->netdev, &priv->dfs_chandef,
 				   NL80211_RADAR_CAC_ABORTED, GFP_KERNEL);
@@ -199,7 +199,8 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 				sizeof(u32));
 
 	if (le32_to_cpu(rpt_event->result) != HostCmd_RESULT_OK) {
-		dev_err(priv->adapter->dev, "Error in channel report event\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Error in channel report event\n");
 		return -1;
 	}
 
@@ -212,8 +213,8 @@ int mwifiex_11h_handle_chanrpt_ready(struct mwifiex_private *priv,
 		switch (le16_to_cpu(rpt->header.type)) {
 		case TLV_TYPE_CHANRPT_11H_BASIC:
 			if (rpt->map.radar) {
-				dev_notice(priv->adapter->dev,
-					   "RADAR Detected on channel %d!\n",
+				mwifiex_dbg(priv->adapter, MSG,
+					    "RADAR Detected on channel %d!\n",
 					    priv->dfs_chandef.chan->hw_value);
 				cancel_delayed_work_sync(&priv->dfs_cac_work);
 				cfg80211_cac_event(priv->netdev,
@@ -242,16 +243,17 @@ int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 	rdr_event = (void *)(skb->data + sizeof(u32));
 
 	if (le32_to_cpu(rdr_event->passed)) {
-		dev_notice(priv->adapter->dev,
-			   "radar detected; indicating kernel\n");
+		mwifiex_dbg(priv->adapter, MSG,
+			    "radar detected; indicating kernel\n");
 		cfg80211_radar_event(priv->adapter->wiphy, &priv->dfs_chandef,
 				     GFP_KERNEL);
-		dev_dbg(priv->adapter->dev, "regdomain: %d\n",
-			rdr_event->reg_domain);
-		dev_dbg(priv->adapter->dev, "radar detection type: %d\n",
-			rdr_event->det_type);
+		mwifiex_dbg(priv->adapter, MSG, "regdomain: %d\n",
+			    rdr_event->reg_domain);
+		mwifiex_dbg(priv->adapter, MSG, "radar detection type: %d\n",
+			    rdr_event->det_type);
 	} else {
-		dev_dbg(priv->adapter->dev, "false radar detection event!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "false radar detection event!\n");
 	}
 
 	return 0;
@@ -276,20 +278,20 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 
 	bss_cfg = &priv->bss_cfg;
 	if (!bss_cfg->beacon_period) {
-		dev_err(priv->adapter->dev,
-			"channel switch: AP already stopped\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "channel switch: AP already stopped\n");
 		return;
 	}
 
 	mwifiex_uap_set_channel(bss_cfg, priv->dfs_chandef);
 
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
-		dev_dbg(priv->adapter->dev,
-			"Failed to start AP after channel switch\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to start AP after channel switch\n");
 		return;
 	}
 
-	dev_notice(priv->adapter->dev,
-		   "indicating channel switch completion to kernel\n");
+	mwifiex_dbg(priv->adapter, MSG,
+		    "indicating channel switch completion to kernel\n");
 	cfg80211_ch_switch_notify(priv->netdev, &priv->dfs_chandef);
 }
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 433bd68..8422986 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -42,7 +42,7 @@ int mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 					priv->wdev.wiphy->bands[radio_type];
 
 	if (WARN_ON_ONCE(!sband)) {
-		dev_err(priv->adapter->dev, "Invalid radio type!\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Invalid radio type!\n");
 		return -EINVAL;
 	}
 
@@ -184,7 +184,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 
 	tx_ba_tbl = mwifiex_get_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr);
 	if (tx_ba_tbl) {
-		dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
+		mwifiex_dbg(priv->adapter, EVENT, "info: BA stream complete\n");
 		tx_ba_tbl->ba_status = BA_SETUP_COMPLETE;
 		if ((block_ack_param_set & BLOCKACKPARAM_AMSDU_SUPP_MASK) &&
 		    priv->add_ba_param.tx_amsdu &&
@@ -197,7 +197,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			ra_list->ba_status = BA_SETUP_COMPLETE;
 		}
 	} else {
-		dev_err(priv->adapter->dev, "BA stream not created\n");
+		mwifiex_dbg(priv->adapter, ERROR, "BA stream not created\n");
 	}
 
 	return 0;
@@ -224,7 +224,8 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 	tx_buf->action = cpu_to_le16(action);
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
-		dev_dbg(priv->adapter->dev, "cmd: set tx_buf=%d\n", *buf_size);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: set tx_buf=%d\n", *buf_size);
 		tx_buf->buff_size = cpu_to_le16(*buf_size);
 		break;
 	case HostCmd_ACT_GEN_GET:
@@ -466,7 +467,8 @@ void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 	    mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
 		return;
 
-	dev_dbg(priv->adapter->dev, "info: tx_ba_tsr_tbl %p\n", tx_ba_tsr_tbl);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: tx_ba_tsr_tbl %p\n", tx_ba_tsr_tbl);
 
 	list_del(&tx_ba_tsr_tbl->list);
 
@@ -563,7 +565,7 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	unsigned long flags;
 	u16 block_ack_param_set;
 
-	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
+	mwifiex_dbg(priv->adapter, CMD, "cmd: %s: tid %d\n", __func__, tid);
 
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
@@ -575,9 +577,9 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 		sta_ptr = mwifiex_get_sta_entry(priv, peer_mac);
 		if (!sta_ptr) {
 			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-			dev_warn(priv->adapter->dev,
-				 "BA setup with unknown TDLS peer %pM!\n",
-				peer_mac);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "BA setup with unknown TDLS peer %pM!\n",
+				    peer_mac);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
@@ -706,8 +708,8 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
-		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
-			__func__, rx_reo_tbl->tid);
+		mwifiex_dbg(priv->adapter, DATA, "data: %s tid=%d\n",
+			    __func__, rx_reo_tbl->tid);
 		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra, ETH_ALEN);
 		rx_reo_tbl->amsdu = tx_ba_tsr_tbl->amsdu;
 		rx_reo_tbl++;
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 6183e25..f7c7172 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -187,7 +187,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	skb_aggr = mwifiex_alloc_dma_align_buf(adapter->tx_buf_size,
 					       GFP_ATOMIC | GFP_DMA);
 	if (!skb_aggr) {
-		dev_err(adapter->dev, "%s: alloc skb_aggr\n", __func__);
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		return -1;
@@ -297,13 +296,13 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
 		if (adapter->iface_type != MWIFIEX_PCIE)
 			adapter->data_sent = false;
-		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
-			__func__, ret);
+		mwifiex_dbg(adapter, ERROR, "%s: host_to_card failed: %#x\n",
+			    __func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		return 0;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index f75f8ac..39d7a95 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -51,8 +51,8 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 			rx_skb = __skb_dequeue(&list);
 			ret = mwifiex_recv_packet(priv, rx_skb);
 			if (ret == -1)
-				dev_err(priv->adapter->dev,
-					"Rx of A-MSDU failed");
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "Rx of A-MSDU failed");
 		}
 		return 0;
 	}
@@ -304,7 +304,7 @@ mwifiex_flush_data(unsigned long context)
 	if (seq_num < 0)
 		return;
 
-	dev_dbg(ctx->priv->adapter->dev, "info: flush data %d\n", seq_num);
+	mwifiex_dbg(ctx->priv->adapter, INFO, "info: flush data %d\n", seq_num);
 	start_win = (ctx->ptr->start_win + seq_num + 1) & (MAX_TID_VALUE - 1);
 	mwifiex_11n_dispatch_pkt_until_start_win(ctx->priv, ctx->ptr,
 						 start_win);
@@ -367,8 +367,9 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	}
 	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
-	dev_dbg(priv->adapter->dev, "info: last_seq=%d start_win=%d\n",
-		last_seq, new_node->start_win);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: last_seq=%d start_win=%d\n",
+		    last_seq, new_node->start_win);
 
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
 	    last_seq >= new_node->start_win) {
@@ -382,8 +383,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 					GFP_KERNEL);
 	if (!new_node->rx_reorder_ptr) {
 		kfree((u8 *) new_node);
-		dev_err(priv->adapter->dev,
-			"%s: failed to alloc reorder_ptr\n", __func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: failed to alloc reorder_ptr\n", __func__);
 		return;
 	}
 
@@ -467,9 +468,9 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 						cmd_addba_req->peer_mac_addr);
 		if (!sta_ptr) {
 			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-			dev_warn(priv->adapter->dev,
-				 "BA setup with unknown TDLS peer %pM!\n",
-				 cmd_addba_req->peer_mac_addr);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "BA setup with unknown TDLS peer %pM!\n",
+				    cmd_addba_req->peer_mac_addr);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
@@ -573,14 +574,14 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	}
 
 	if (tbl->flags & RXREOR_FORCE_NO_DROP) {
-		dev_dbg(priv->adapter->dev,
-			"RXREOR_FORCE_NO_DROP when HS is activated\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "RXREOR_FORCE_NO_DROP when HS is activated\n");
 		tbl->flags &= ~RXREOR_FORCE_NO_DROP;
 	} else if (init_window_shift && seq_num < start_win &&
 		   seq_num >= tbl->init_win) {
-		dev_dbg(priv->adapter->dev,
-			"Sender TID sequence number reset %d->%d for SSN %d\n",
-			start_win, seq_num, tbl->init_win);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "Sender TID sequence number reset %d->%d for SSN %d\n",
+			    start_win, seq_num, tbl->init_win);
 		tbl->start_win = start_win = seq_num;
 		end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
 	} else {
@@ -668,23 +669,23 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	else
 		cleanup_rx_reorder_tbl = (initiator) ? false : true;
 
-	dev_dbg(priv->adapter->dev, "event: DELBA: %pM tid=%d initiator=%d\n",
-		peer_mac, tid, initiator);
+	mwifiex_dbg(priv->adapter, EVENT, "event: DELBA: %pM tid=%d initiator=%d\n",
+		    peer_mac, tid, initiator);
 
 	if (cleanup_rx_reorder_tbl) {
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 								 peer_mac);
 		if (!tbl) {
-			dev_dbg(priv->adapter->dev,
-				"event: TID, TA not found in table\n");
+			mwifiex_dbg(priv->adapter, EVENT,
+				    "event: TID, TA not found in table\n");
 			return;
 		}
 		mwifiex_del_rx_reorder_entry(priv, tbl);
 	} else {
 		ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
-			dev_dbg(priv->adapter->dev,
-				"event: TID, RA not found in table\n");
+			mwifiex_dbg(priv->adapter, EVENT,
+				    "event: TID, RA not found in table\n");
 			return;
 		}
 		ra_list = mwifiex_wmm_get_ralist_node(priv, tid, peer_mac);
@@ -721,8 +722,8 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	 * the stream
 	 */
 	if (le16_to_cpu(add_ba_rsp->status_code) != BA_RESULT_SUCCESS) {
-		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
-			add_ba_rsp->peer_mac_addr, tid);
+		mwifiex_dbg(priv->adapter, ERROR, "ADDBA RSP: failed %pM tid=%d)\n",
+			    add_ba_rsp->peer_mac_addr, tid);
 
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 						     add_ba_rsp->peer_mac_addr);
@@ -746,8 +747,8 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 			tbl->amsdu = false;
 	}
 
-	dev_dbg(priv->adapter->dev,
-		"cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
+	mwifiex_dbg(priv->adapter, CMD,
+		    "cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
 		add_ba_rsp->peer_mac_addr, tid, add_ba_rsp->ssn, win_size);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index bf9020f..4eeceda 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -104,11 +104,11 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
 
 	if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index, peer_mac, 1)) {
-		wiphy_err(wiphy, "deleting the crypto keys\n");
+		mwifiex_dbg(priv->adapter, ERROR, "deleting the crypto keys\n");
 		return -EFAULT;
 	}
 
-	wiphy_dbg(wiphy, "info: crypto keys deleted\n");
+	mwifiex_dbg(priv->adapter, INFO, "info: crypto keys deleted\n");
 	return 0;
 }
 
@@ -163,7 +163,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 
 	if (!buf || !len) {
-		wiphy_err(wiphy, "invalid buffer and length\n");
+		mwifiex_dbg(priv->adapter, ERROR, "invalid buffer and length\n");
 		return -EFAULT;
 	}
 
@@ -172,8 +172,8 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	    ieee80211_is_probe_resp(mgmt->frame_control)) {
 		/* Since we support offload probe resp, we need to skip probe
 		 * resp in AP or GO mode */
-		wiphy_dbg(wiphy,
-			  "info: skip to send probe resp in AP or GO mode\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: skip to send probe resp in AP or GO mode\n");
 		return 0;
 	}
 
@@ -183,7 +183,8 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    pkt_len + sizeof(pkt_len));
 
 	if (!skb) {
-		wiphy_err(wiphy, "allocate skb failed for management frame\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "allocate skb failed for management frame\n");
 		return -ENOMEM;
 	}
 
@@ -206,7 +207,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	mwifiex_queue_tx_pkt(priv, skb);
 
-	wiphy_dbg(wiphy, "info: management frame transmitted\n");
+	mwifiex_dbg(priv->adapter, INFO, "info: management frame transmitted\n");
 	return 0;
 }
 
@@ -231,7 +232,7 @@ mwifiex_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 		mwifiex_send_cmd(priv, HostCmd_CMD_MGMT_FRAME_REG,
 				 HostCmd_ACT_GEN_SET, 0,
 				 &priv->mgmt_frame_mask, false);
-		wiphy_dbg(wiphy, "info: mgmt frame registered\n");
+		mwifiex_dbg(priv->adapter, INFO, "info: mgmt frame registered\n");
 	}
 }
 
@@ -248,13 +249,14 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 	int ret;
 
 	if (!chan || !cookie) {
-		wiphy_err(wiphy, "Invalid parameter for ROC\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Invalid parameter for ROC\n");
 		return -EINVAL;
 	}
 
 	if (priv->roc_cfg.cookie) {
-		wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llx\n",
-			  priv->roc_cfg.cookie);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ongoing ROC, cookie = 0x%llx\n",
+			    priv->roc_cfg.cookie);
 		return -EBUSY;
 	}
 
@@ -269,7 +271,8 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 		cfg80211_ready_on_channel(wdev, *cookie, chan,
 					  duration, GFP_ATOMIC);
 
-		wiphy_dbg(wiphy, "info: ROC, cookie = 0x%llx\n", *cookie);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ROC, cookie = 0x%llx\n", *cookie);
 	}
 
 	return ret;
@@ -298,7 +301,8 @@ mwifiex_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 		memset(&priv->roc_cfg, 0, sizeof(struct mwifiex_roc_cfg));
 
-		wiphy_dbg(wiphy, "info: cancel ROC, cookie = 0x%llx\n", cookie);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: cancel ROC, cookie = 0x%llx\n", cookie);
 	}
 
 	return ret;
@@ -344,8 +348,8 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	u32 ps_mode;
 
 	if (timeout)
-		wiphy_dbg(wiphy,
-			  "info: ignore timeout value for IEEE Power Save\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ignore timeout value for IEEE Power Save\n");
 
 	ps_mode = enabled;
 
@@ -370,7 +374,7 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 		priv->wep_key_curr_index = key_index;
 	} else if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index,
 				      NULL, 0)) {
-		wiphy_err(wiphy, "set default Tx key index\n");
+		mwifiex_dbg(priv->adapter, ERROR, "set default Tx key index\n");
 		return -EFAULT;
 	}
 
@@ -407,7 +411,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	if (mwifiex_set_encode(priv, params, params->key, params->key_len,
 			       key_index, peer_mac, 0)) {
-		wiphy_err(wiphy, "crypto keys added\n");
+		mwifiex_dbg(priv->adapter, ERROR, "crypto keys added\n");
 		return -EFAULT;
 	}
 
@@ -442,7 +446,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	band = mwifiex_band_to_radio_type(adapter->config_bands);
 	if (!wiphy->bands[band]) {
-		wiphy_err(wiphy, "11D: setting domain info in FW\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "11D: setting domain info in FW\n");
 		return -1;
 	}
 
@@ -493,7 +498,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
 			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
-		wiphy_err(wiphy, "11D: setting domain info in FW\n");
+		mwifiex_dbg(adapter, INFO,
+			    "11D: setting domain info in FW\n");
 		return -1;
 	}
 
@@ -516,9 +522,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 	struct mwifiex_private *priv = mwifiex_get_priv(adapter,
 							MWIFIEX_BSS_ROLE_ANY);
-
-	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for %c%c\n",
-		  request->alpha2[0], request->alpha2[1]);
+	mwifiex_dbg(adapter, INFO,
+		    "info: cfg80211 regulatory domain callback for %c%c\n",
+		    request->alpha2[0], request->alpha2[1]);
 
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_DRIVER:
@@ -527,8 +533,9 @@ static void mwifiex_reg_notifier(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		break;
 	default:
-		wiphy_err(wiphy, "unknown regdom initiator: %d\n",
-			  request->initiator);
+		mwifiex_dbg(adapter, ERROR,
+			    "unknown regdom initiator: %d\n",
+			    request->initiator);
 		return;
 	}
 
@@ -597,8 +604,8 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	switch (priv->bss_role) {
 	case MWIFIEX_BSS_ROLE_UAP:
 		if (priv->bss_started) {
-			dev_err(adapter->dev,
-				"cannot change wiphy params when bss started");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot change wiphy params when bss started");
 			return -EINVAL;
 		}
 
@@ -622,15 +629,16 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 
 		kfree(bss_cfg);
 		if (ret) {
-			wiphy_err(wiphy, "Failed to set wiphy phy params\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to set wiphy phy params\n");
 			return ret;
 		}
 		break;
 
 		case MWIFIEX_BSS_ROLE_STA:
 		if (priv->media_connected) {
-			dev_err(adapter->dev,
-				"cannot change wiphy params when connected");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot change wiphy params when connected");
 			return -EINVAL;
 		}
 		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
@@ -724,8 +732,8 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_MGMT_FRAME_REG,
 			     HostCmd_ACT_GEN_SET, 0,
 			     &priv->mgmt_frame_mask, false)) {
-		dev_warn(priv->adapter->dev,
-			 "could not unregister mgmt frame rx\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "could not unregister mgmt frame rx\n");
 		return -1;
 	}
 
@@ -789,9 +797,9 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"%s: changing to %d not supported\n",
-			dev->name, type);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: changing to %d not supported\n",
+			    dev->name, type);
 		return -EOPNOTSUPP;
 	}
 
@@ -824,12 +832,13 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 
 	if (adapter->curr_iface_comb.p2p_intf ==
 	    adapter->iface_limit.p2p_intf) {
-		dev_err(adapter->dev,
-			"cannot create multiple P2P ifaces\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot create multiple P2P ifaces\n");
 		return -1;
 	}
 
-	dev_dbg(priv->adapter->dev, "%s: changing role to p2p\n", dev->name);
+	mwifiex_dbg(adapter, INFO,
+		    "%s: changing role to p2p\n", dev->name);
 
 	if (mwifiex_deinit_priv_params(priv))
 		return -1;
@@ -846,9 +855,9 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 			return -EFAULT;
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"%s: changing to %d not supported\n",
-			dev->name, type);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: changing to %d not supported\n",
+			    dev->name, type);
 		return -EOPNOTSUPP;
 	}
 
@@ -897,17 +906,17 @@ mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 	     curr_iftype != NL80211_IFTYPE_P2P_GO) &&
 	    (adapter->curr_iface_comb.sta_intf ==
 	     adapter->iface_limit.sta_intf)) {
-		dev_err(adapter->dev,
-			"cannot create multiple station/adhoc ifaces\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot create multiple station/adhoc ifaces\n");
 		return -1;
 	}
 
 	if (type == NL80211_IFTYPE_STATION)
-		dev_notice(adapter->dev,
-			   "%s: changing role to station\n", dev->name);
+		mwifiex_dbg(adapter, INFO,
+			    "%s: changing role to station\n", dev->name);
 	else
-		dev_notice(adapter->dev,
-			   "%s: changing role to adhoc\n", dev->name);
+		mwifiex_dbg(adapter, INFO,
+			    "%s: changing role to adhoc\n", dev->name);
 
 	if (mwifiex_deinit_priv_params(priv))
 		return -1;
@@ -954,12 +963,13 @@ mwifiex_change_vif_to_ap(struct net_device *dev,
 
 	if (adapter->curr_iface_comb.uap_intf ==
 	    adapter->iface_limit.uap_intf) {
-		dev_err(adapter->dev,
-			"cannot create multiple AP ifaces\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot create multiple AP ifaces\n");
 		return -1;
 	}
 
-	dev_notice(adapter->dev, "%s: changing role to AP\n", dev->name);
+	mwifiex_dbg(adapter, INFO,
+		    "%s: changing role to AP\n", dev->name);
 
 	if (mwifiex_deinit_priv_params(priv))
 		return -1;
@@ -1020,12 +1030,14 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-			wiphy_warn(wiphy, "%s: kept type as IBSS\n", dev->name);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "%s: kept type as IBSS\n", dev->name);
 		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
 			return 0;
 		default:
-			wiphy_err(wiphy, "%s: changing to %d not supported\n",
-				  dev->name, type);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "%s: changing to %d not supported\n",
+				    dev->name, type);
 			return -EOPNOTSUPP;
 		}
 		break;
@@ -1048,12 +1060,14 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-			wiphy_warn(wiphy, "%s: kept type as STA\n", dev->name);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "%s: kept type as STA\n", dev->name);
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
 			return 0;
 		default:
-			wiphy_err(wiphy, "%s: changing to %d not supported\n",
-				  dev->name, type);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "%s: changing to %d not supported\n",
+				    dev->name, type);
 			return -EOPNOTSUPP;
 		}
 		break;
@@ -1070,12 +1084,14 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
 							 type, flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-			wiphy_warn(wiphy, "%s: kept type as AP\n", dev->name);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "%s: kept type as AP\n", dev->name);
 		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
 			return 0;
 		default:
-			wiphy_err(wiphy, "%s: changing to %d not supported\n",
-				  dev->name, type);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "%s: changing to %d not supported\n",
+				    dev->name, type);
 			return -EOPNOTSUPP;
 		}
 		break;
@@ -1100,19 +1116,22 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							flags, params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-			wiphy_warn(wiphy, "%s: kept type as P2P\n", dev->name);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "%s: kept type as P2P\n", dev->name);
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return 0;
 		default:
-			wiphy_err(wiphy, "%s: changing to %d not supported\n",
-				  dev->name, type);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "%s: changing to %d not supported\n",
+				    dev->name, type);
 			return -EOPNOTSUPP;
 		}
 		break;
 	default:
-		wiphy_err(wiphy, "%s: unknown iftype: %d\n",
-			  dev->name, dev->ieee80211_ptr->iftype);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: unknown iftype: %d\n",
+			    dev->name, dev->ieee80211_ptr->iftype);
 		return -EOPNOTSUPP;
 	}
 
@@ -1206,12 +1225,14 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	/* Get signal information from the firmware */
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 			     HostCmd_ACT_GEN_GET, 0, NULL, true)) {
-		dev_err(priv->adapter->dev, "failed to get signal information\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "failed to get signal information\n");
 		return -EFAULT;
 	}
 
 	if (mwifiex_drv_get_data_rate(priv, &rate)) {
-		dev_err(priv->adapter->dev, "getting data rate\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "getting data rate error\n");
 		return -EFAULT;
 	}
 
@@ -1295,7 +1316,7 @@ mwifiex_cfg80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_chan_stats *pchan_stats = priv->adapter->chan_stats;
 	enum ieee80211_band band;
 
-	dev_dbg(priv->adapter->dev, "dump_survey idx=%d\n", idx);
+	mwifiex_dbg(priv->adapter, DUMP, "dump_survey idx=%d\n", idx);
 
 	memset(survey, 0, sizeof(struct survey_info));
 
@@ -1472,8 +1493,8 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (!priv->media_connected) {
-		dev_err(adapter->dev,
-			"Can not set Tx data rate in disconnected state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Can not set Tx data rate in disconnected state\n");
 		return -EINVAL;
 	}
 
@@ -1556,17 +1577,20 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP) {
-		wiphy_err(wiphy, "%s: bss_type mismatched\n", __func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: bss_type mismatched\n", __func__);
 		return -EINVAL;
 	}
 
 	if (!priv->bss_started) {
-		wiphy_err(wiphy, "%s: bss not started\n", __func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: bss not started\n", __func__);
 		return -EINVAL;
 	}
 
 	if (mwifiex_set_mgmt_ies(priv, data)) {
-		wiphy_err(wiphy, "%s: setting mgmt ies failed\n", __func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: setting mgmt ies failed\n", __func__);
 		return -EFAULT;
 	}
 
@@ -1594,7 +1618,8 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!params->mac || is_broadcast_ether_addr(params->mac))
 		return 0;
 
-	wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__, params->mac);
+	mwifiex_dbg(priv->adapter, INFO, "%s: mac address %pM\n",
+		    __func__, params->mac);
 
 	eth_zero_addr(deauth_mac);
 
@@ -1687,14 +1712,16 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	mwifiex_abort_cac(priv);
 
 	if (mwifiex_del_mgmt_ies(priv))
-		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to delete mgmt IEs!\n");
 
 	priv->ap_11n_enabled = 0;
 	memset(&priv->bss_cfg, 0, sizeof(priv->bss_cfg));
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		wiphy_err(wiphy, "Failed to stop the BSS\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to stop the BSS\n");
 		return -1;
 	}
 
@@ -1756,7 +1783,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
-		wiphy_err(wiphy, "Failed to parse secuirty parameters!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to parse secuirty parameters!\n");
 		return -1;
 	}
 
@@ -1778,17 +1806,19 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	if (mwifiex_is_11h_active(priv) &&
 	    !cfg80211_chandef_dfs_required(wiphy, &params->chandef,
 					   priv->bss_mode)) {
-		dev_dbg(priv->adapter->dev, "Disable 11h extensions in FW\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "Disable 11h extensions in FW\n");
 		if (mwifiex_11h_activate(priv, false)) {
-			dev_err(priv->adapter->dev,
-				"Failed to disable 11h extensions!!");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Failed to disable 11h extensions!!");
 			return -1;
 		}
 		priv->state_11h.is_11h_active = true;
 	}
 
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
-		wiphy_err(wiphy, "Failed to start AP\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to start AP\n");
 		kfree(bss_cfg);
 		return -1;
 	}
@@ -1816,8 +1846,9 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
-	wiphy_dbg(wiphy, "info: successfully disconnected from %pM:"
-		" reason code %d\n", priv->cfg_bssid, reason_code);
+	mwifiex_dbg(priv->adapter, MSG,
+		    "info: successfully disconnected from %pM:\t"
+		    "reason code %d\n", priv->cfg_bssid, reason_code);
 
 	eth_zero_addr(priv->cfg_bssid);
 	priv->hs2_enabled = false;
@@ -1899,13 +1930,13 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 
 	req_ssid.ssid_len = ssid_len;
 	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
-		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
+		mwifiex_dbg(priv->adapter, ERROR, "invalid SSID - aborting\n");
 		return -EINVAL;
 	}
 
 	memcpy(req_ssid.ssid, ssid, ssid_len);
 	if (!req_ssid.ssid_len || req_ssid.ssid[0] < 0x20) {
-		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
+		mwifiex_dbg(priv->adapter, ERROR, "invalid SSID - aborting\n");
 		return -EINVAL;
 	}
 
@@ -1959,9 +1990,9 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 
 	if (sme->key) {
 		if (mwifiex_is_alg_wep(priv->sec_info.encryption_mode)) {
-			dev_dbg(priv->adapter->dev,
-				"info: setting wep encryption"
-				" with key len %d\n", sme->key_len);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: setting wep encryption\t"
+				    "with key len %d\n", sme->key_len);
 			priv->wep_key_curr_index = sme->key_idx;
 			ret = mwifiex_set_encode(priv, NULL, sme->key,
 						 sme->key_len, sme->key_idx,
@@ -1978,7 +2009,7 @@ done:
 		if (is_scanning_required) {
 			/* Do specific SSID scanning */
 			if (mwifiex_request_scan(priv, &req_ssid)) {
-				dev_err(priv->adapter->dev, "scan error\n");
+				mwifiex_dbg(priv->adapter, ERROR, "scan error\n");
 				return -EFAULT;
 			}
 		}
@@ -1997,15 +2028,15 @@ done:
 
 		if (!bss) {
 			if (is_scanning_required) {
-				dev_warn(priv->adapter->dev,
-					 "assoc: requested bss not found in scan results\n");
+				mwifiex_dbg(priv->adapter, WARN,
+					    "assoc: requested bss not found in scan results\n");
 				break;
 			}
 			is_scanning_required = 1;
 		} else {
-			dev_dbg(priv->adapter->dev,
-				"info: trying to associate to '%s' bssid %pM\n",
-				(char *) req_ssid.ssid, bss->bssid);
+			mwifiex_dbg(priv->adapter, MSG,
+				    "info: trying to associate to '%s' bssid %pM\n",
+				    (char *)req_ssid.ssid, bss->bssid);
 			memcpy(&priv->cfg_bssid, bss->bssid, ETH_ALEN);
 			break;
 		}
@@ -2041,26 +2072,29 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) {
-		wiphy_err(wiphy,
-			  "%s: reject infra assoc request in non-STA role\n",
-			  dev->name);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: reject infra assoc request in non-STA role\n",
+			    dev->name);
 		return -EINVAL;
 	}
 
 	if (priv->wdev.current_bss) {
-		wiphy_warn(wiphy, "%s: already connected\n", dev->name);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: already connected\n", dev->name);
 		return -EALREADY;
 	}
 
 	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
-		wiphy_err(wiphy,
-			  "%s: Ignore connection. Card removed or FW in bad state\n",
-			  dev->name);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: Ignore connection.\t"
+			    "Card removed or FW in bad state\n",
+			    dev->name);
 		return -EFAULT;
 	}
 
-	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
-		  (char *) sme->ssid, sme->bssid);
+	mwifiex_dbg(adapter, INFO,
+		    "info: Trying to associate to %s and bssid %pM\n",
+		    (char *)sme->ssid, sme->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
@@ -2068,17 +2102,17 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		cfg80211_connect_result(priv->netdev, priv->cfg_bssid, NULL, 0,
 					NULL, 0, WLAN_STATUS_SUCCESS,
 					GFP_KERNEL);
-		dev_dbg(priv->adapter->dev,
-			"info: associated to bssid %pM successfully\n",
-			priv->cfg_bssid);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "info: associated to bssid %pM successfully\n",
+			    priv->cfg_bssid);
 		if (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
 		    priv->adapter->auto_tdls &&
 		    priv->bss_type == MWIFIEX_BSS_TYPE_STA)
 			mwifiex_setup_auto_tdls_timer(priv);
 	} else {
-		dev_dbg(priv->adapter->dev,
-			"info: association to bssid %pM failed\n",
-			priv->cfg_bssid);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "info: association to bssid %pM failed\n",
+			    priv->cfg_bssid);
 		eth_zero_addr(priv->cfg_bssid);
 
 		if (ret > 0)
@@ -2105,7 +2139,6 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 				   struct cfg80211_ibss_params *params)
 {
-	struct wiphy *wiphy = priv->wdev.wiphy;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int index = 0, i;
 	u8 config_bands = 0;
@@ -2162,8 +2195,10 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	priv->adhoc_channel = ieee80211_frequency_to_channel(
 				params->chandef.chan->center_freq);
 
-	wiphy_dbg(wiphy, "info: set ibss band %d, chan %d, chan offset %d\n",
-		  config_bands, priv->adhoc_channel, adapter->sec_chan_offset);
+	mwifiex_dbg(adapter, INFO,
+		    "info: set ibss band %d, chan %d, chan offset %d\n",
+		    config_bands, priv->adhoc_channel,
+		    adapter->sec_chan_offset);
 
 	return 0;
 }
@@ -2182,13 +2217,15 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	int ret = 0;
 
 	if (priv->bss_mode != NL80211_IFTYPE_ADHOC) {
-		wiphy_err(wiphy, "request to join ibss received "
-				"when station is not in ibss mode\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "request to join ibss received\t"
+			    "when station is not in ibss mode\n");
 		goto done;
 	}
 
-	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
-		  (char *) params->ssid, params->bssid);
+	mwifiex_dbg(priv->adapter, MSG,
+		    "info: trying to join to %s and bssid %pM\n",
+		    (char *)params->ssid, params->bssid);
 
 	mwifiex_set_ibss_params(priv, params);
 
@@ -2200,12 +2237,12 @@ done:
 	if (!ret) {
 		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
 				     params->chandef.chan, GFP_KERNEL);
-		dev_dbg(priv->adapter->dev,
-			"info: joined/created adhoc network with bssid"
-			" %pM successfully\n", priv->cfg_bssid);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "info: joined/created adhoc network with bssid\t"
+			    "%pM successfully\n", priv->cfg_bssid);
 	} else {
-		dev_dbg(priv->adapter->dev,
-			"info: failed creating/joining adhoc network\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "info: failed creating/joining adhoc network\n");
 	}
 
 	return ret;
@@ -2222,8 +2259,8 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
-		  priv->cfg_bssid);
+	mwifiex_dbg(priv->adapter, MSG, "info: disconnecting from essid %pM\n",
+		    priv->cfg_bssid);
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
@@ -2250,13 +2287,15 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	struct ieee_types_header *ie;
 	struct mwifiex_user_scan_cfg *user_scan_cfg;
 
-	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
+	mwifiex_dbg(priv->adapter, CMD,
+		    "info: received scan request on %s\n", dev->name);
 
 	/* Block scan request if scan operation or scan cleanup when interface
 	 * is disabled is in process
 	 */
 	if (priv->scan_request || priv->scan_aborting) {
-		dev_err(priv->adapter->dev, "cmd: Scan already in process..\n");
+		mwifiex_dbg(priv->adapter, WARN,
+			    "cmd: Scan already in process..\n");
 		return -EBUSY;
 	}
 
@@ -2308,7 +2347,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	ret = mwifiex_scan_networks(priv, user_scan_cfg);
 	kfree(user_scan_cfg);
 	if (ret) {
-		dev_err(priv->adapter->dev, "scan failed: %d\n", ret);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "scan failed: %d\n", ret);
 		priv->scan_aborting = false;
 		priv->scan_request = NULL;
 		return ret;
@@ -2454,15 +2494,15 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_ADHOC:
 		if (adapter->curr_iface_comb.sta_intf ==
 		    adapter->iface_limit.sta_intf) {
-			wiphy_err(wiphy,
-				  "cannot create multiple sta/adhoc ifaces\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot create multiple sta/adhoc ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
 		priv = mwifiex_get_unused_priv(adapter);
 		if (!priv) {
-			wiphy_err(wiphy,
-				  "could not get free private struct\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "could not get free private struct\n");
 			return ERR_PTR(-EFAULT);
 		}
 
@@ -2484,15 +2524,15 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP:
 		if (adapter->curr_iface_comb.uap_intf ==
 		    adapter->iface_limit.uap_intf) {
-			wiphy_err(wiphy,
-				  "cannot create multiple AP ifaces\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot create multiple AP ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
 		priv = mwifiex_get_unused_priv(adapter);
 		if (!priv) {
-			wiphy_err(wiphy,
-				  "could not get free private struct\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "could not get free private struct\n");
 			return ERR_PTR(-EFAULT);
 		}
 
@@ -2511,15 +2551,15 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (adapter->curr_iface_comb.p2p_intf ==
 		    adapter->iface_limit.p2p_intf) {
-			wiphy_err(wiphy,
-				  "cannot create multiple P2P ifaces\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot create multiple P2P ifaces\n");
 			return ERR_PTR(-EINVAL);
 		}
 
 		priv = mwifiex_get_unused_priv(adapter);
 		if (!priv) {
-			wiphy_err(wiphy,
-				  "could not get free private struct\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "could not get free private struct\n");
 			return ERR_PTR(-EFAULT);
 		}
 
@@ -2550,7 +2590,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		break;
 	default:
-		wiphy_err(wiphy, "type not supported\n");
+		mwifiex_dbg(adapter, ERROR, "type not supported\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2558,7 +2598,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			       name_assign_type, ether_setup,
 			       IEEE80211_NUM_ACS, 1);
 	if (!dev) {
-		wiphy_err(wiphy, "no memory available for netdevice\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "no memory available for netdevice\n");
 		memset(&priv->wdev, 0, sizeof(priv->wdev));
 		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -2599,7 +2640,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	/* Register network device */
 	if (register_netdevice(dev)) {
-		wiphy_err(wiphy, "cannot register virtual network device\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot register virtual network device\n");
 		free_netdev(dev);
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 		priv->netdev = NULL;
@@ -2613,7 +2655,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 						  WQ_MEM_RECLAIM |
 						  WQ_UNBOUND, 1, name);
 	if (!priv->dfs_cac_workqueue) {
-		wiphy_err(wiphy, "cannot register virtual network device\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot register virtual network device\n");
 		free_netdev(dev);
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 		priv->netdev = NULL;
@@ -2628,7 +2671,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 						      WQ_HIGHPRI | WQ_UNBOUND |
 						      WQ_MEM_RECLAIM, 1, name);
 	if (!priv->dfs_chan_sw_workqueue) {
-		wiphy_err(wiphy, "cannot register virtual network device\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot register virtual network device\n");
 		free_netdev(dev);
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 		priv->netdev = NULL;
@@ -2642,7 +2686,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	sema_init(&priv->async_sem, 1);
 
-	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
+	mwifiex_dbg(adapter, INFO,
+		    "info: %s: Marvell 802.11 Adapter\n", dev->name);
 
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
@@ -2661,7 +2706,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		adapter->curr_iface_comb.p2p_intf++;
 		break;
 	default:
-		wiphy_err(wiphy, "type not supported\n");
+		mwifiex_dbg(adapter, ERROR, "type not supported\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2721,7 +2766,8 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 		adapter->curr_iface_comb.p2p_intf++;
 		break;
 	default:
-		dev_err(adapter->dev, "del_virtual_intf: type not supported\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "del_virtual_intf: type not supported\n");
 		break;
 	}
 
@@ -2839,7 +2885,8 @@ static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
 		if (!mwifiex_is_pattern_supported(&wowlan->patterns[i],
 					byte_seq,
 					MWIFIEX_MEF_MAX_BYTESEQ)) {
-			dev_err(priv->adapter->dev, "Pattern not supported\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Pattern not supported\n");
 			kfree(mef_entry);
 			return -EOPNOTSUPP;
 		}
@@ -2954,21 +3001,22 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	mwifiex_cancel_all_pending_cmd(adapter);
 
 	if (!wowlan) {
-		dev_warn(adapter->dev, "None of the WOWLAN triggers enabled\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "None of the WOWLAN triggers enabled\n");
 		return 0;
 	}
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 
 	if (!priv->media_connected) {
-		dev_warn(adapter->dev,
-			 "Can not configure WOWLAN in disconnected state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Can not configure WOWLAN in disconnected state\n");
 		return 0;
 	}
 
 	ret = mwifiex_set_mef_filter(priv, wowlan);
 	if (ret) {
-		dev_err(adapter->dev, "Failed to set MEF filter\n");
+		mwifiex_dbg(adapter, ERROR, "Failed to set MEF filter\n");
 		return ret;
 	}
 
@@ -2981,7 +3029,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
 					    MWIFIEX_SYNC_CMD, &hs_cfg);
 		if (ret) {
-			dev_err(adapter->dev, "Failed to set HS params\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to set HS params\n");
 			return ret;
 		}
 	}
@@ -3041,7 +3090,8 @@ mwifiex_fill_coalesce_rule_info(struct mwifiex_private *priv,
 		if (!mwifiex_is_pattern_supported(&crule->patterns[i],
 						  byte_seq,
 						MWIFIEX_COALESCE_MAX_BYTESEQ)) {
-			dev_err(priv->adapter->dev, "Pattern not supported\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Pattern not supported\n");
 			return -EOPNOTSUPP;
 		}
 
@@ -3050,8 +3100,8 @@ mwifiex_fill_coalesce_rule_info(struct mwifiex_private *priv,
 
 			pkt_type = mwifiex_get_coalesce_pkt_type(byte_seq);
 			if (pkt_type && mrule->pkt_type) {
-				dev_err(priv->adapter->dev,
-					"Multiple packet types not allowed\n");
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "Multiple packet types not allowed\n");
 				return -EOPNOTSUPP;
 			} else if (pkt_type) {
 				mrule->pkt_type = pkt_type;
@@ -3074,8 +3124,8 @@ mwifiex_fill_coalesce_rule_info(struct mwifiex_private *priv,
 	}
 
 	if (!mrule->pkt_type) {
-		dev_err(priv->adapter->dev,
-			"Packet type can not be determined\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Packet type can not be determined\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -3093,8 +3143,8 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 
 	memset(&coalesce_cfg, 0, sizeof(coalesce_cfg));
 	if (!coalesce) {
-		dev_dbg(adapter->dev,
-			"Disable coalesce and reset all previous rules\n");
+		mwifiex_dbg(adapter, WARN,
+			    "Disable coalesce and reset all previous rules\n");
 		return mwifiex_send_cmd(priv, HostCmd_CMD_COALESCE_CFG,
 					HostCmd_ACT_GEN_SET, 0,
 					&coalesce_cfg, true);
@@ -3105,8 +3155,8 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 		ret = mwifiex_fill_coalesce_rule_info(priv, &coalesce->rules[i],
 						      &coalesce_cfg.rule[i]);
 		if (ret) {
-			dev_err(priv->adapter->dev,
-				"Recheck the patterns provided for rule %d\n",
+			mwifiex_dbg(adapter, ERROR,
+				    "Recheck the patterns provided for rule %d\n",
 				i + 1);
 			return ret;
 		}
@@ -3138,9 +3188,9 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
-		dev_dbg(priv->adapter->dev,
-			"Send TDLS Setup Request to %pM status_code=%d\n", peer,
-			 status_code);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Setup Request to %pM status_code=%d\n",
+			    peer, status_code);
 		mwifiex_add_auto_tdls_peer(priv, peer);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
@@ -3148,45 +3198,45 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
 		mwifiex_add_auto_tdls_peer(priv, peer);
-		dev_dbg(priv->adapter->dev,
-			"Send TDLS Setup Response to %pM status_code=%d\n",
-			peer, status_code);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Setup Response to %pM status_code=%d\n",
+			    peer, status_code);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
-		dev_dbg(priv->adapter->dev,
-			"Send TDLS Confirm to %pM status_code=%d\n", peer,
-			status_code);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Confirm to %pM status_code=%d\n", peer,
+			    status_code);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	case WLAN_TDLS_TEARDOWN:
-		dev_dbg(priv->adapter->dev, "Send TDLS Tear down to %pM\n",
-			peer);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Tear down to %pM\n", peer);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	case WLAN_TDLS_DISCOVERY_REQUEST:
-		dev_dbg(priv->adapter->dev,
-			"Send TDLS Discovery Request to %pM\n", peer);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Discovery Request to %pM\n", peer);
 		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		dev_dbg(priv->adapter->dev,
-			"Send TDLS Discovery Response to %pM\n", peer);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Send TDLS Discovery Response to %pM\n", peer);
 		ret = mwifiex_send_tdls_action_frame(priv, peer, action_code,
 						   dialog_token, status_code,
 						   extra_ies, extra_ies_len);
 		break;
 	default:
-		dev_warn(priv->adapter->dev,
-			 "Unknown TDLS mgmt/action frame %pM\n", peer);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Unknown TDLS mgmt/action frame %pM\n", peer);
 		ret = -EINVAL;
 		break;
 	}
@@ -3208,8 +3258,8 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
 		return -ENOTSUPP;
 
-	dev_dbg(priv->adapter->dev,
-		"TDLS peer=%pM, oper=%d\n", peer, action);
+	mwifiex_dbg(priv->adapter, MSG,
+		    "TDLS peer=%pM, oper=%d\n", peer, action);
 
 	switch (action) {
 	case NL80211_TDLS_ENABLE_LINK:
@@ -3220,22 +3270,22 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	case NL80211_TDLS_TEARDOWN:
 		/* shouldn't happen!*/
-		dev_warn(priv->adapter->dev,
-			 "tdls_oper: teardown from driver not supported\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tdls_oper: teardown from driver not supported\n");
 		return -EINVAL;
 	case NL80211_TDLS_SETUP:
 		/* shouldn't happen!*/
-		dev_warn(priv->adapter->dev,
-			 "tdls_oper: setup from driver not supported\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tdls_oper: setup from driver not supported\n");
 		return -EINVAL;
 	case NL80211_TDLS_DISCOVERY_REQ:
 		/* shouldn't happen!*/
-		dev_warn(priv->adapter->dev,
-			 "tdls_oper: discovery from driver not supported\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tdls_oper: discovery from driver not supported\n");
 		return -EINVAL;
 	default:
-		dev_err(priv->adapter->dev,
-			"tdls_oper: operation not supported\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tdls_oper: operation not supported\n");
 		return -ENOTSUPP;
 	}
 
@@ -3268,8 +3318,8 @@ mwifiex_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->adapter->scan_processing) {
-		dev_err(priv->adapter->dev,
-			"radar detection: scan in process...\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "radar detection: scan in process...\n");
 		return -EBUSY;
 	}
 
@@ -3284,8 +3334,8 @@ mwifiex_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 					   params->beacon_csa.tail,
 					   params->beacon_csa.tail_len);
 	if (!chsw_ie) {
-		dev_err(priv->adapter->dev,
-			"Could not parse channel switch announcement IE\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Could not parse channel switch announcement IE\n");
 		return -EINVAL;
 	}
 
@@ -3297,10 +3347,12 @@ mwifiex_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (mwifiex_del_mgmt_ies(priv))
-		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to delete mgmt IEs!\n");
 
 	if (mwifiex_set_mgmt_ies(priv, &params->beacon_csa)) {
-		wiphy_err(wiphy, "%s: setting mgmt ies failed\n", __func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: setting mgmt ies failed\n", __func__);
 		return -EFAULT;
 	}
 
@@ -3324,16 +3376,17 @@ mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
 	struct mwifiex_radar_params radar_params;
 
 	if (priv->adapter->scan_processing) {
-		dev_err(priv->adapter->dev,
-			"radar detection: scan already in process...\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "radar detection: scan already in process...\n");
 		return -EBUSY;
 	}
 
 	if (!mwifiex_is_11h_active(priv)) {
-		dev_dbg(priv->adapter->dev, "Enable 11h extensions in FW\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "Enable 11h extensions in FW\n");
 		if (mwifiex_11h_activate(priv, true)) {
-			dev_err(priv->adapter->dev,
-				"Failed to activate 11h extensions!!");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Failed to activate 11h extensions!!");
 			return -1;
 		}
 		priv->state_11h.is_11h_active = true;
@@ -3492,7 +3545,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy = wiphy_new(&mwifiex_cfg80211_ops,
 			  sizeof(struct mwifiex_adapter *));
 	if (!wiphy) {
-		dev_err(adapter->dev, "%s: creating new wiphy\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: creating new wiphy\n", __func__);
 		return -ENOMEM;
 	}
 	wiphy->max_scan_ssids = MWIFIEX_MAX_SSID_LIST_LENGTH;
@@ -3563,20 +3617,22 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
-		dev_err(adapter->dev,
-			"%s: wiphy_register failed: %d\n", __func__, ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: wiphy_register failed: %d\n", __func__, ret);
 		wiphy_free(wiphy);
 		return ret;
 	}
 
 	if (reg_alpha2 && mwifiex_is_valid_alpha2(reg_alpha2)) {
-		wiphy_info(wiphy, "driver hint alpha2: %2.2s\n", reg_alpha2);
+		mwifiex_dbg(adapter, INFO,
+			    "driver hint alpha2: %2.2s\n", reg_alpha2);
 		regulatory_hint(wiphy, reg_alpha2);
 	} else {
 		country_code = mwifiex_11d_code_2_region(adapter->region_code);
 		if (country_code)
-			wiphy_info(wiphy, "ignoring F/W country code %2.2s\n",
-				   country_code);
+			mwifiex_dbg(adapter, WARN,
+				    "ignoring F/W country code %2.2s\n",
+				    country_code);
 	}
 
 	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index e9df882..3ddb8ec 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -327,8 +327,9 @@ mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
 		sband = priv->wdev.wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband) {
-		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d\n",
-			__func__, band);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: cannot find cfp by band %d\n",
+			    __func__, band);
 		return cfp;
 	}
 
@@ -349,9 +350,10 @@ mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
 		}
 	}
 	if (i == sband->n_channels) {
-		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
-			" & channel=%d freq=%d\n", __func__, band, channel,
-			freq);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: cannot find cfp by band %d\t"
+			    "& channel=%d freq=%d\n",
+			    __func__, band, channel, freq);
 	} else {
 		if (!ch)
 			return cfp;
@@ -431,15 +433,17 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		switch (adapter->config_bands) {
 		case BAND_B:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_b\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_b\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_b,
 					       sizeof(supported_rates_b));
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_g\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_g\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_g,
 					       sizeof(supported_rates_g));
 			break;
@@ -449,15 +453,17 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN:
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN | BAND_AAC:
 		case BAND_B | BAND_G | BAND_GN:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_bg\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_bg\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_bg,
 					       sizeof(supported_rates_bg));
 			break;
 		case BAND_A:
 		case BAND_A | BAND_G:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_a\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_a\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
@@ -466,14 +472,16 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		case BAND_A | BAND_AN | BAND_AAC:
 		case BAND_A | BAND_G | BAND_AN | BAND_GN:
 		case BAND_A | BAND_G | BAND_AN | BAND_GN | BAND_AAC:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_a\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_a\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
 		case BAND_GN:
-			dev_dbg(adapter->dev, "info: infra band=%d "
-				"supported_rates_n\n", adapter->config_bands);
+			mwifiex_dbg(adapter, INFO, "info: infra band=%d\t"
+				    "supported_rates_n\n",
+				    adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_n,
 					       sizeof(supported_rates_n));
 			break;
@@ -482,25 +490,25 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		/* Ad-hoc mode */
 		switch (adapter->adhoc_start_band) {
 		case BAND_B:
-			dev_dbg(adapter->dev, "info: adhoc B\n");
+			mwifiex_dbg(adapter, INFO, "info: adhoc B\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_b,
 					       sizeof(adhoc_rates_b));
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
-			dev_dbg(adapter->dev, "info: adhoc G only\n");
+			mwifiex_dbg(adapter, INFO, "info: adhoc G only\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_g,
 					       sizeof(adhoc_rates_g));
 			break;
 		case BAND_B | BAND_G:
 		case BAND_B | BAND_G | BAND_GN:
-			dev_dbg(adapter->dev, "info: adhoc BG\n");
+			mwifiex_dbg(adapter, INFO, "info: adhoc BG\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_bg,
 					       sizeof(adhoc_rates_bg));
 			break;
 		case BAND_A:
 		case BAND_A | BAND_AN:
-			dev_dbg(adapter->dev, "info: adhoc A\n");
+			mwifiex_dbg(adapter, INFO, "info: adhoc A\n");
 			k = mwifiex_copy_rates(rates, k, adhoc_rates_a,
 					       sizeof(adhoc_rates_a));
 			break;
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5b19786..ac89a1d 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -62,7 +62,8 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
 	if (list_empty(&adapter->cmd_free_q)) {
-		dev_err(adapter->dev, "GET_CMD_NODE: cmd node not available\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "GET_CMD_NODE: cmd node not available\n");
 		spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 		return NULL;
 	}
@@ -116,7 +117,8 @@ static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
 {
 	/* Copy the HOST command to command buffer */
 	memcpy(cmd, pcmd_ptr->cmd, pcmd_ptr->len);
-	dev_dbg(priv->adapter->dev, "cmd: host cmd size = %d\n", pcmd_ptr->len);
+	mwifiex_dbg(priv->adapter, CMD,
+		    "cmd: host cmd size = %d\n", pcmd_ptr->len);
 	return 0;
 }
 
@@ -147,8 +149,9 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	/* Sanity test */
 	if (host_cmd == NULL || host_cmd->size == 0) {
-		dev_err(adapter->dev, "DNLD_CMD: host_cmd is null"
-			" or cmd size is 0, not sending\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "DNLD_CMD: host_cmd is null\t"
+			    "or cmd size is 0, not sending\n");
 		if (cmd_node->wait_q_enabled)
 			adapter->cmd_wait_q.status = -1;
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
@@ -161,8 +164,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET &&
 	    cmd_code != HostCmd_CMD_FUNC_SHUTDOWN &&
 	    cmd_code != HostCmd_CMD_FUNC_INIT) {
-		dev_err(adapter->dev,
-			"DNLD_CMD: FW in reset state, ignore cmd %#x\n",
+		mwifiex_dbg(adapter, ERROR,
+			    "DNLD_CMD: FW in reset state, ignore cmd %#x\n",
 			cmd_code);
 		if (cmd_node->wait_q_enabled)
 			mwifiex_complete_cmd(adapter, cmd_node);
@@ -197,10 +200,11 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		 */
 		skb_put(cmd_node->cmd_skb, cmd_size - cmd_node->cmd_skb->len);
 
-	dev_dbg(adapter->dev,
-		"cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n", cmd_code,
-		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
-		le16_to_cpu(host_cmd->seq_num));
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
+		    cmd_code,
+		    le16_to_cpu(*(__le16 *)((u8 *)host_cmd + S_DS_GEN)),
+		    cmd_size, le16_to_cpu(host_cmd->seq_num));
 	mwifiex_dbg_dump(adapter, CMD_D, "cmd buffer:", host_cmd, cmd_size);
 
 	if (adapter->iface_type == MWIFIEX_USB) {
@@ -222,7 +226,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	}
 
 	if (ret == -1) {
-		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "DNLD_CMD: host to card failed\n");
 		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->cmd_sent = false;
 		if (cmd_node->wait_q_enabled)
@@ -281,8 +286,8 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					(adapter->seq_num, priv->bss_num,
 					 priv->bss_type)));
 
-	dev_dbg(adapter->dev,
-		"cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
 		le16_to_cpu(sleep_cfm_buf->command),
 		le16_to_cpu(sleep_cfm_buf->action),
 		le16_to_cpu(sleep_cfm_buf->size),
@@ -314,7 +319,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	}
 
 	if (ret == -1) {
-		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
+		mwifiex_dbg(adapter, ERROR, "SLEEP_CFM: failed\n");
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
 		return -1;
 	}
@@ -365,8 +370,8 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
 		cmd_array[i].skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (!cmd_array[i].skb) {
-			dev_err(adapter->dev,
-				"unable to allocate command buffer\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "unable to allocate command buffer\n");
 			return -ENOMEM;
 		}
 	}
@@ -390,7 +395,8 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 
 	/* Need to check if cmd pool is allocated or not */
 	if (!adapter->cmd_pool) {
-		dev_dbg(adapter->dev, "info: FREE_CMD_BUF: cmd_pool is null\n");
+		mwifiex_dbg(adapter, FATAL,
+			    "info: FREE_CMD_BUF: cmd_pool is null\n");
 		return 0;
 	}
 
@@ -399,7 +405,8 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	/* Release shared memory buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
 		if (cmd_array[i].skb) {
-			dev_dbg(adapter->dev, "cmd: free cmd buffer %d\n", i);
+			mwifiex_dbg(adapter, CMD,
+				    "cmd: free cmd buffer %d\n", i);
 			dev_kfree_skb_any(cmd_array[i].skb);
 		}
 		if (!cmd_array[i].resp_skb)
@@ -413,7 +420,8 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 	}
 	/* Release struct cmd_ctrl_node */
 	if (adapter->cmd_pool) {
-		dev_dbg(adapter->dev, "cmd: free cmd pool\n");
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: free cmd pool\n");
 		kfree(adapter->cmd_pool);
 		adapter->cmd_pool = NULL;
 	}
@@ -463,7 +471,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		rx_info->bss_type = priv->bss_type;
 	}
 
-	dev_dbg(adapter->dev, "EVENT: cause: %#x\n", eventcause);
+	mwifiex_dbg(adapter, EVENT, "EVENT: cause: %#x\n", eventcause);
 	mwifiex_dbg_dump(adapter, EVT_D, "Event Buf:", skb->data, skb->len);
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
@@ -503,28 +511,33 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	}
 
 	if (adapter->is_suspended) {
-		dev_err(adapter->dev, "PREP_CMD: device in suspended state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: device in suspended state\n");
 		return -1;
 	}
 
 	if (adapter->hs_enabling && cmd_no != HostCmd_CMD_802_11_HS_CFG_ENH) {
-		dev_err(adapter->dev, "PREP_CMD: host entering sleep state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: host entering sleep state\n");
 		return -1;
 	}
 
 	if (adapter->surprise_removed) {
-		dev_err(adapter->dev, "PREP_CMD: card is removed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: card is removed\n");
 		return -1;
 	}
 
 	if (adapter->is_cmd_timedout) {
-		dev_err(adapter->dev, "PREP_CMD: FW is in bad state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: FW is in bad state\n");
 		return -1;
 	}
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
 		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
-			dev_err(adapter->dev, "PREP_CMD: FW in reset state\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "PREP_CMD: FW in reset state\n");
 			return -1;
 		}
 	}
@@ -533,7 +546,8 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	cmd_node = mwifiex_get_cmd_node(adapter);
 
 	if (!cmd_node) {
-		dev_err(adapter->dev, "PREP_CMD: no free cmd node\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: no free cmd node\n");
 		return -1;
 	}
 
@@ -541,7 +555,8 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, data_buf, sync);
 
 	if (!cmd_node->cmd_skb) {
-		dev_err(adapter->dev, "PREP_CMD: no free cmd buf\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: no free cmd buf\n");
 		return -1;
 	}
 
@@ -576,7 +591,8 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 
 	/* Return error, since the command preparation failed */
 	if (ret) {
-		dev_err(adapter->dev, "PREP_CMD: cmd %#x preparation failed\n",
+		mwifiex_dbg(adapter, ERROR,
+			    "PREP_CMD: cmd %#x preparation failed\n",
 			cmd_no);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		return -1;
@@ -631,7 +647,8 @@ void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
 	mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 
 	atomic_dec(&adapter->cmd_pending);
-	dev_dbg(adapter->dev, "cmd: FREE_CMD: cmd=%#x, cmd_pending=%d\n",
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: FREE_CMD: cmd=%#x, cmd_pending=%d\n",
 		le16_to_cpu(host_cmd->command),
 		atomic_read(&adapter->cmd_pending));
 }
@@ -653,7 +670,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	if (!host_cmd) {
-		dev_err(adapter->dev, "QUEUE_CMD: host_cmd is NULL\n");
+		mwifiex_dbg(adapter, ERROR, "QUEUE_CMD: host_cmd is NULL\n");
 		return;
 	}
 
@@ -678,7 +695,8 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
 	atomic_inc(&adapter->cmd_pending);
-	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x, cmd_pending=%d\n",
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: QUEUE_CMD: cmd=%#x, cmd_pending=%d\n",
 		command, atomic_read(&adapter->cmd_pending));
 }
 
@@ -704,7 +722,8 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 
 	/* Check if already in processing */
 	if (adapter->curr_cmd) {
-		dev_err(adapter->dev, "EXEC_NEXT_CMD: cmd in processing\n");
+		mwifiex_dbg(adapter, FATAL,
+			    "EXEC_NEXT_CMD: cmd in processing\n");
 		return -1;
 	}
 
@@ -726,8 +745,9 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	priv = cmd_node->priv;
 
 	if (adapter->ps_state != PS_STATE_AWAKE) {
-		dev_err(adapter->dev, "%s: cannot send cmd in sleep state,"
-				" this should not happen\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: cannot send cmd in sleep state,\t"
+			    "this should not happen\n", __func__);
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 		return ret;
 	}
@@ -777,8 +797,9 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
-		dev_err(adapter->dev, "CMD_RESP: NULL curr_cmd, %#x\n",
-			le16_to_cpu(resp->command));
+		mwifiex_dbg(adapter, ERROR,
+			    "CMD_RESP: NULL curr_cmd, %#x\n",
+			    le16_to_cpu(resp->command));
 		return -1;
 	}
 
@@ -786,8 +807,9 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
-		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
-			le16_to_cpu(resp->command));
+		mwifiex_dbg(adapter, ERROR,
+			    "CMD_RESP: %#x been canceled\n",
+			    le16_to_cpu(resp->command));
 		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
@@ -799,7 +821,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		/* Copy original response back to response buffer */
 		struct mwifiex_ds_misc_cmd *hostcmd;
 		uint16_t size = le16_to_cpu(resp->size);
-		dev_dbg(adapter->dev, "info: host cmd resp size = %d\n", size);
+		mwifiex_dbg(adapter, INFO,
+			    "info: host cmd resp size = %d\n", size);
 		size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (adapter->curr_cmd->data_buf) {
 			hostcmd = adapter->curr_cmd->data_buf;
@@ -827,15 +850,15 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	adapter->dbg.last_cmd_resp_id[adapter->dbg.last_cmd_resp_index] =
 								orig_cmdresp_no;
 
-	dev_dbg(adapter->dev,
-		"cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
-		orig_cmdresp_no, cmdresp_result,
-		le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
+		    orig_cmdresp_no, cmdresp_result,
+		    le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
 	mwifiex_dbg_dump(adapter, CMD_D, "CMD_RESP buffer:", resp,
 			 le16_to_cpu(resp->size));
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
-		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
+		mwifiex_dbg(adapter, ERROR, "CMD_RESP: invalid cmd resp\n");
 		if (adapter->curr_cmd->wait_q_enabled)
 			adapter->cmd_wait_q.status = -1;
 
@@ -859,8 +882,9 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	/* Check init command response */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
 		if (ret) {
-			dev_err(adapter->dev, "%s: cmd %#x failed during "
-				"initialization\n", __func__, cmdresp_no);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: cmd %#x failed during\t"
+				    "initialization\n", __func__, cmdresp_no);
 			mwifiex_init_fw_complete(adapter);
 			return -1;
 		} else if (adapter->last_init_cmd == cmdresp_no)
@@ -895,7 +919,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 	adapter->is_cmd_timedout = 1;
 	if (!adapter->curr_cmd) {
-		dev_dbg(adapter->dev, "cmd: empty curr_cmd\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cmd: empty curr_cmd\n");
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
@@ -904,47 +929,60 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
 		adapter->dbg.timeout_cmd_act =
 			adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index];
-		dev_err(adapter->dev,
-			"%s: Timeout cmd id = %#x, act = %#x\n", __func__,
-			adapter->dbg.timeout_cmd_id,
-			adapter->dbg.timeout_cmd_act);
-
-		dev_err(adapter->dev, "num_data_h2c_failure = %d\n",
-			adapter->dbg.num_tx_host_to_card_failure);
-		dev_err(adapter->dev, "num_cmd_h2c_failure = %d\n",
-			adapter->dbg.num_cmd_host_to_card_failure);
-
-		dev_err(adapter->dev, "is_cmd_timedout = %d\n",
-			adapter->is_cmd_timedout);
-		dev_err(adapter->dev, "num_tx_timeout = %d\n",
-			adapter->dbg.num_tx_timeout);
-
-		dev_err(adapter->dev, "last_cmd_index = %d\n",
-			adapter->dbg.last_cmd_index);
-		dev_err(adapter->dev, "last_cmd_id: %*ph\n",
-			(int)sizeof(adapter->dbg.last_cmd_id),
-			adapter->dbg.last_cmd_id);
-		dev_err(adapter->dev, "last_cmd_act: %*ph\n",
-			(int)sizeof(adapter->dbg.last_cmd_act),
-			adapter->dbg.last_cmd_act);
-
-		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
-			adapter->dbg.last_cmd_resp_index);
-		dev_err(adapter->dev, "last_cmd_resp_id: %*ph\n",
-			(int)sizeof(adapter->dbg.last_cmd_resp_id),
-			adapter->dbg.last_cmd_resp_id);
-
-		dev_err(adapter->dev, "last_event_index = %d\n",
-			adapter->dbg.last_event_index);
-		dev_err(adapter->dev, "last_event: %*ph\n",
-			(int)sizeof(adapter->dbg.last_event),
-			adapter->dbg.last_event);
-
-		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
-			adapter->data_sent, adapter->cmd_sent);
-
-		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
-			adapter->ps_mode, adapter->ps_state);
+		mwifiex_dbg(adapter, MSG,
+			    "%s: Timeout cmd id = %#x, act = %#x\n", __func__,
+			    adapter->dbg.timeout_cmd_id,
+			    adapter->dbg.timeout_cmd_act);
+
+		mwifiex_dbg(adapter, MSG,
+			    "num_data_h2c_failure = %d\n",
+			    adapter->dbg.num_tx_host_to_card_failure);
+		mwifiex_dbg(adapter, MSG,
+			    "num_cmd_h2c_failure = %d\n",
+			    adapter->dbg.num_cmd_host_to_card_failure);
+
+		mwifiex_dbg(adapter, MSG,
+			    "is_cmd_timedout = %d\n",
+			    adapter->is_cmd_timedout);
+		mwifiex_dbg(adapter, MSG,
+			    "num_tx_timeout = %d\n",
+			    adapter->dbg.num_tx_timeout);
+
+		mwifiex_dbg(adapter, MSG,
+			    "last_cmd_index = %d\n",
+			    adapter->dbg.last_cmd_index);
+		mwifiex_dbg(adapter, MSG,
+			    "last_cmd_id: %*ph\n",
+			    (int)sizeof(adapter->dbg.last_cmd_id),
+			    adapter->dbg.last_cmd_id);
+		mwifiex_dbg(adapter, MSG,
+			    "last_cmd_act: %*ph\n",
+			    (int)sizeof(adapter->dbg.last_cmd_act),
+			    adapter->dbg.last_cmd_act);
+
+		mwifiex_dbg(adapter, MSG,
+			    "last_cmd_resp_index = %d\n",
+			    adapter->dbg.last_cmd_resp_index);
+		mwifiex_dbg(adapter, MSG,
+			    "last_cmd_resp_id: %*ph\n",
+			    (int)sizeof(adapter->dbg.last_cmd_resp_id),
+			    adapter->dbg.last_cmd_resp_id);
+
+		mwifiex_dbg(adapter, MSG,
+			    "last_event_index = %d\n",
+			    adapter->dbg.last_event_index);
+		mwifiex_dbg(adapter, MSG,
+			    "last_event: %*ph\n",
+			    (int)sizeof(adapter->dbg.last_event),
+			    adapter->dbg.last_event);
+
+		mwifiex_dbg(adapter, MSG,
+			    "data_sent=%d cmd_sent=%d\n",
+			    adapter->data_sent, adapter->cmd_sent);
+
+		mwifiex_dbg(adapter, MSG,
+			    "ps_mode=%d ps_state=%d\n",
+			    adapter->ps_mode, adapter->ps_state);
 
 		if (cmd_node->wait_q_enabled) {
 			adapter->cmd_wait_q.status = -ETIMEDOUT;
@@ -1022,7 +1060,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 			if (!priv)
 				continue;
 			if (priv->scan_request) {
-				dev_dbg(adapter->dev, "info: aborting scan\n");
+				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
 				cfg80211_scan_done(priv->scan_request, 1);
 				priv->scan_request = NULL;
 			}
@@ -1082,7 +1120,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 			if (!priv)
 				continue;
 			if (priv->scan_request) {
-				dev_dbg(adapter->dev, "info: aborting scan\n");
+				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
 				cfg80211_scan_done(priv->scan_request, 1);
 				priv->scan_request = NULL;
 			}
@@ -1107,11 +1145,11 @@ mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
 	else
-		dev_dbg(adapter->dev,
-			"cmd: Delay Sleep Confirm (%s%s%s)\n",
-			(adapter->cmd_sent) ? "D" : "",
-			(adapter->curr_cmd) ? "C" : "",
-			(IS_CARD_RX_RCVD(adapter)) ? "R" : "");
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: Delay Sleep Confirm (%s%s%s)\n",
+			    (adapter->cmd_sent) ? "D" : "",
+			    (adapter->curr_cmd) ? "C" : "",
+			    (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
 }
 
 /*
@@ -1127,15 +1165,18 @@ mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
 			priv->adapter->hs_activated = true;
 			mwifiex_update_rxreor_flags(priv->adapter,
 						    RXREOR_FORCE_NO_DROP);
-			dev_dbg(priv->adapter->dev, "event: hs_activated\n");
+			mwifiex_dbg(priv->adapter, EVENT,
+				    "event: hs_activated\n");
 			priv->adapter->hs_activate_wait_q_woken = true;
 			wake_up_interruptible(
 				&priv->adapter->hs_activate_wait_q);
 		} else {
-			dev_dbg(priv->adapter->dev, "event: HS not configured\n");
+			mwifiex_dbg(priv->adapter, EVENT,
+				    "event: HS not configured\n");
 		}
 	} else {
-		dev_dbg(priv->adapter->dev, "event: hs_deactivated\n");
+		mwifiex_dbg(priv->adapter, EVENT,
+			    "event: hs_deactivated\n");
 		priv->adapter->hs_activated = false;
 	}
 }
@@ -1163,11 +1204,12 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 		mwifiex_hs_activated_event(priv, true);
 		return 0;
 	} else {
-		dev_dbg(adapter->dev, "cmd: CMD_RESP: HS_CFG cmd reply"
-			" result=%#x, conditions=0x%x gpio=0x%x gap=0x%x\n",
-			resp->result, conditions,
-			phs_cfg->params.hs_config.gpio,
-			phs_cfg->params.hs_config.gap);
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: CMD_RESP: HS_CFG cmd reply\t"
+			    " result=%#x, conditions=0x%x gpio=0x%x gap=0x%x\n",
+			    resp->result, conditions,
+			    phs_cfg->params.hs_config.gpio,
+			    phs_cfg->params.hs_config.gap);
 	}
 	if (conditions != HS_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
@@ -1189,8 +1231,10 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 void
 mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 {
-	dev_dbg(adapter->dev, "info: %s: auto cancelling host sleep"
-		" since there is interrupt from the firmware\n", __func__);
+	mwifiex_dbg(adapter, INFO,
+		    "info: %s: auto cancelling host sleep\t"
+		    "since there is interrupt from the firmware\n",
+		    __func__);
 
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
@@ -1219,13 +1263,14 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
 
 	if (!upld_len) {
-		dev_err(adapter->dev, "%s: cmd size is 0\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: cmd size is 0\n", __func__);
 		return;
 	}
 
-	dev_dbg(adapter->dev,
-		"cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
-		command, result, le16_to_cpu(cmd->size), seq_num);
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
+		    command, result, le16_to_cpu(cmd->size), seq_num);
 
 	/* Get BSS number and corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, HostCmd_GET_BSS_NO(seq_num),
@@ -1239,15 +1284,16 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	command &= HostCmd_CMD_ID_MASK;
 
 	if (command != HostCmd_CMD_802_11_PS_MODE_ENH) {
-		dev_err(adapter->dev,
-			"%s: rcvd unexpected resp for cmd %#x, result = %x\n",
-			__func__, command, result);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: rcvd unexpected resp for cmd %#x, result = %x\n",
+			    __func__, command, result);
 		return;
 	}
 
 	if (result) {
-		dev_err(adapter->dev, "%s: sleep confirm cmd failed\n",
-			__func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: sleep confirm cmd failed\n",
+			    __func__);
 		adapter->pm_wakeup_card_req = false;
 		adapter->ps_state = PS_STATE_AWAKE;
 		return;
@@ -1312,7 +1358,8 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 					sizeof(struct mwifiex_ie_types_header));
 			cmd_size += sizeof(*ps_tlv);
 			tlv += sizeof(*ps_tlv);
-			dev_dbg(adapter->dev, "cmd: PS Command: Enter PS\n");
+			mwifiex_dbg(priv->adapter, CMD,
+				    "cmd: PS Command: Enter PS\n");
 			ps_mode->null_pkt_interval =
 					cpu_to_le16(adapter->null_pkt_interval);
 			ps_mode->multiple_dtims =
@@ -1342,8 +1389,8 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			tlv += sizeof(*auto_ds_tlv);
 			if (auto_ds)
 				idletime = auto_ds->idle_time;
-			dev_dbg(priv->adapter->dev,
-				"cmd: PS Command: Enter Auto Deep Sleep\n");
+			mwifiex_dbg(priv->adapter, CMD,
+				    "cmd: PS Command: Enter Auto Deep Sleep\n");
 			auto_ds_tlv->deep_sleep_timeout = cpu_to_le16(idletime);
 		}
 		cmd->size = cpu_to_le16(cmd_size);
@@ -1370,27 +1417,31 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 	uint16_t auto_ps_bitmap =
 		le16_to_cpu(ps_mode->params.ps_bitmap);
 
-	dev_dbg(adapter->dev,
-		"info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
-		__func__, resp->result, action);
+	mwifiex_dbg(adapter, INFO,
+		    "info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
+		    __func__, resp->result, action);
 	if (action == EN_AUTO_PS) {
 		if (auto_ps_bitmap & BITMAP_AUTO_DS) {
-			dev_dbg(adapter->dev, "cmd: Enabled auto deep sleep\n");
+			mwifiex_dbg(adapter, CMD,
+				    "cmd: Enabled auto deep sleep\n");
 			priv->adapter->is_deep_sleep = true;
 		}
 		if (auto_ps_bitmap & BITMAP_STA_PS) {
-			dev_dbg(adapter->dev, "cmd: Enabled STA power save\n");
+			mwifiex_dbg(adapter, CMD,
+				    "cmd: Enabled STA power save\n");
 			if (adapter->sleep_period.period)
-				dev_dbg(adapter->dev,
-					"cmd: set to uapsd/pps mode\n");
+				mwifiex_dbg(adapter, CMD,
+					    "cmd: set to uapsd/pps mode\n");
 		}
 	} else if (action == DIS_AUTO_PS) {
 		if (ps_bitmap & BITMAP_AUTO_DS) {
 			priv->adapter->is_deep_sleep = false;
-			dev_dbg(adapter->dev, "cmd: Disabled auto deep sleep\n");
+			mwifiex_dbg(adapter, CMD,
+				    "cmd: Disabled auto deep sleep\n");
 		}
 		if (ps_bitmap & BITMAP_STA_PS) {
-			dev_dbg(adapter->dev, "cmd: Disabled STA power save\n");
+			mwifiex_dbg(adapter, CMD,
+				    "cmd: Disabled STA power save\n");
 			if (adapter->sleep_period.period) {
 				adapter->delay_null_pkt = false;
 				adapter->tx_lock_flag = false;
@@ -1403,7 +1454,8 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 		else
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
 
-		dev_dbg(adapter->dev, "cmd: ps_bitmap=%#x\n", ps_bitmap);
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: ps_bitmap=%#x\n", ps_bitmap);
 
 		if (pm_cfg) {
 			/* This section is for get power save mode */
@@ -1540,29 +1592,29 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 							api_rev->major_ver;
 					adapter->key_api_minor_ver =
 							api_rev->minor_ver;
-					dev_dbg(adapter->dev,
-						"key_api v%d.%d\n",
-						adapter->key_api_major_ver,
-						adapter->key_api_minor_ver);
+					mwifiex_dbg(adapter, INFO,
+						    "key_api v%d.%d\n",
+						    adapter->key_api_major_ver,
+						    adapter->key_api_minor_ver);
 					break;
 				case FW_API_VER_ID:
 					adapter->fw_api_ver =
 							api_rev->major_ver;
-					dev_dbg(adapter->dev,
-						"Firmware api version %d\n",
-						adapter->fw_api_ver);
+					mwifiex_dbg(adapter, INFO,
+						    "Firmware api version %d\n",
+						    adapter->fw_api_ver);
 					break;
 				default:
-					dev_warn(adapter->dev,
-						 "Unknown api_id: %d\n",
-						 api_id);
+					mwifiex_dbg(adapter, FATAL,
+						    "Unknown api_id: %d\n",
+						    api_id);
 					break;
 				}
 				break;
 			default:
-				dev_warn(adapter->dev,
-					 "Unknown GET_HW_SPEC TLV type: %#x\n",
-					 le16_to_cpu(tlv->type));
+				mwifiex_dbg(adapter, FATAL,
+					    "Unknown GET_HW_SPEC TLV type: %#x\n",
+					    le16_to_cpu(tlv->type));
 				break;
 			}
 			parsed_len += le16_to_cpu(tlv->len) +
@@ -1572,14 +1624,16 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		}
 	}
 
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
-		adapter->fw_release_number);
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
-		hw_spec->permanent_addr);
-	dev_dbg(adapter->dev,
-		"info: GET_HW_SPEC: hw_if_version=%#x version=%#x\n",
-		le16_to_cpu(hw_spec->hw_if_version),
-		le16_to_cpu(hw_spec->version));
+	mwifiex_dbg(adapter, INFO,
+		    "info: GET_HW_SPEC: fw_release_number- %#x\n",
+		    adapter->fw_release_number);
+	mwifiex_dbg(adapter, INFO,
+		    "info: GET_HW_SPEC: permanent addr: %pM\n",
+		    hw_spec->permanent_addr);
+	mwifiex_dbg(adapter, INFO,
+		    "info: GET_HW_SPEC: hw_if_version=%#x version=%#x\n",
+		    le16_to_cpu(hw_spec->hw_if_version),
+		    le16_to_cpu(hw_spec->version));
 
 	ether_addr_copy(priv->adapter->perm_addr, hw_spec->permanent_addr);
 	adapter->region_code = le16_to_cpu(hw_spec->region_code);
@@ -1592,8 +1646,8 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	/* If it's unidentified region code, use the default (USA) */
 	if (i >= MWIFIEX_MAX_REGION_CODE) {
 		adapter->region_code = 0x10;
-		dev_dbg(adapter->dev,
-			"cmd: unknown region code, use default (USA)\n");
+		mwifiex_dbg(adapter, WARN,
+			    "cmd: unknown region code, use default (USA)\n");
 	}
 
 	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index f3e19e9..8895906 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -792,7 +792,8 @@ mwifiex_hscfg_write(struct file *file, const char __user *ubuf,
 	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
 
 	if (arg_num > 3) {
-		dev_err(priv->adapter->dev, "Too many arguments\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Too many arguments\n");
 		ret = -EINVAL;
 		goto done;
 	}
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index 65d8d6d..a6b3b41 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -108,7 +108,8 @@ mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	}
 
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
-		dev_err(adapter->dev, "firmware dump in progress!!\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "firmware dump in progress!!\n");
 		return -EBUSY;
 	}
 
@@ -140,7 +141,8 @@ static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
 	}
 
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
-		dev_err(adapter->dev, "firmware dump in progress!!\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "firmware dump in progress!!\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e12192f..fdf38d0 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -56,7 +56,7 @@ static void wakeup_timer_fn(unsigned long data)
 {
 	struct mwifiex_adapter *adapter = (struct mwifiex_adapter *)data;
 
-	dev_err(adapter->dev, "Firmware wakeup failed\n");
+	mwifiex_dbg(adapter, ERROR, "Firmware wakeup failed\n");
 	adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
 	mwifiex_cancel_all_pending_cmd(adapter);
 
@@ -172,8 +172,9 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	/* Allocate command buffer */
 	ret = mwifiex_alloc_cmd_buffer(adapter);
 	if (ret) {
-		dev_err(adapter->dev, "%s: failed to alloc cmd buffer\n",
-			__func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to alloc cmd buffer\n",
+			    __func__);
 		return -1;
 	}
 
@@ -182,8 +183,9 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 			      + INTF_HEADER_LEN);
 
 	if (!adapter->sleep_cfm) {
-		dev_err(adapter->dev, "%s: failed to alloc sleep cfm"
-			" cmd buffer\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to alloc sleep cfm\t"
+			    " cmd buffer\n", __func__);
 		return -1;
 	}
 	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
@@ -417,7 +419,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 	mwifiex_free_lock_list(adapter);
 
 	/* Free command buffer */
-	dev_dbg(adapter->dev, "info: free cmd buffer\n");
+	mwifiex_dbg(adapter, INFO, "info: free cmd buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
 	for (idx = 0; idx < adapter->num_mem_types; idx++) {
@@ -595,10 +597,11 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 	for (i = 0; i < adapter->priv_num; ++i) {
 		head = &adapter->bss_prio_tbl[i].bss_prio_head;
 		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
-		dev_dbg(adapter->dev, "info: delete BSS priority table,"
-				" bss_type = %d, bss_num = %d, i = %d,"
-				" head = %p\n",
-			      priv->bss_type, priv->bss_num, i, head);
+		mwifiex_dbg(adapter, INFO,
+			    "info: delete BSS priority table,\t"
+			    "bss_type = %d, bss_num = %d, i = %d,\t"
+			    "head = %p\n",
+			    priv->bss_type, priv->bss_num, i, head);
 
 		{
 			spin_lock_irqsave(lock, flags);
@@ -609,9 +612,10 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 			list_for_each_entry_safe(bssprio_node, tmp_node, head,
 						 list) {
 				if (bssprio_node->priv == priv) {
-					dev_dbg(adapter->dev, "info: Delete "
-						"node %p, next = %p\n",
-						bssprio_node, tmp_node);
+					mwifiex_dbg(adapter, INFO,
+						    "info: Delete\t"
+						    "node %p, next = %p\n",
+						    bssprio_node, tmp_node);
 					list_del(&bssprio_node->list);
 					kfree(bssprio_node);
 				}
@@ -659,20 +663,23 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
 	/* wait for mwifiex_process to complete */
 	if (adapter->mwifiex_processing) {
-		dev_warn(adapter->dev, "main process is still running\n");
+		mwifiex_dbg(adapter, WARN,
+			    "main process is still running\n");
 		return ret;
 	}
 
 	/* cancel current command */
 	if (adapter->curr_cmd) {
-		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
+		mwifiex_dbg(adapter, WARN,
+			    "curr_cmd is still in processing\n");
 		del_timer_sync(&adapter->cmd_timer);
 		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
 		adapter->curr_cmd = NULL;
 	}
 
 	/* shut down mwifiex */
-	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
+	mwifiex_dbg(adapter, MSG,
+		    "info: shutdown mwifiex...\n");
 
 	/* Clean up Tx/Rx queues and delete BSS priority table */
 	for (i = 0; i < adapter->priv_num; i++) {
@@ -741,8 +748,8 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		/* check if firmware is already running */
 		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 		if (!ret) {
-			dev_notice(adapter->dev,
-				   "WLAN FW already running! Skip FW dnld\n");
+			mwifiex_dbg(adapter, MSG,
+				    "WLAN FW already running! Skip FW dnld\n");
 			return 0;
 		}
 
@@ -750,8 +757,8 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 
 		/* check if we are the winner for downloading FW */
 		if (!adapter->winner) {
-			dev_notice(adapter->dev,
-				   "FW already running! Skip FW dnld\n");
+			mwifiex_dbg(adapter, MSG,
+				    "FW already running! Skip FW dnld\n");
 			goto poll_fw;
 		}
 	}
@@ -760,7 +767,8 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		/* Download firmware with helper */
 		ret = adapter->if_ops.prog_fw(adapter, pmfw);
 		if (ret) {
-			dev_err(adapter->dev, "prog_fw failed ret=%#x\n", ret);
+			mwifiex_dbg(adapter, ERROR,
+				    "prog_fw failed ret=%#x\n", ret);
 			return ret;
 		}
 	}
@@ -769,7 +777,8 @@ poll_fw:
 	/* Check if the firmware is downloaded successfully or not */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 	if (ret)
-		dev_err(adapter->dev, "FW failed to be active in time\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "FW failed to be active in time\n");
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index f214a7c..6208ef1 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -53,9 +53,9 @@ mwifiex_cmd_append_generic_ie(struct mwifiex_private *priv, u8 **buffer)
 	 *   parameter buffer pointer.
 	 */
 	if (priv->gen_ie_buf_len) {
-		dev_dbg(priv->adapter->dev,
-			"info: %s: append generic ie len %d to %p\n",
-			__func__, priv->gen_ie_buf_len, *buffer);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: %s: append generic ie len %d to %p\n",
+			    __func__, priv->gen_ie_buf_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
@@ -125,9 +125,9 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 
 	tsf_val = cpu_to_le64(bss_desc->timestamp);
 
-	dev_dbg(priv->adapter->dev,
-		"info: %s: TSF offset calc: %016llx - %016llx\n",
-		__func__, bss_desc->timestamp, bss_desc->fw_tsf);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: %s: TSF offset calc: %016llx - %016llx\n",
+		    __func__, bss_desc->timestamp, bss_desc->fw_tsf);
 
 	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
 	*buffer += sizeof(tsf_val);
@@ -152,7 +152,7 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 
 	tmp = kmemdup(rate1, rate1_size, GFP_KERNEL);
 	if (!tmp) {
-		dev_err(priv->adapter->dev, "failed to alloc tmp buf\n");
+		mwifiex_dbg(priv->adapter, ERROR, "failed to alloc tmp buf\n");
 		return -ENOMEM;
 	}
 
@@ -169,8 +169,8 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 		}
 	}
 
-	dev_dbg(priv->adapter->dev, "info: Tx data rate set to %#x\n",
-		priv->data_rate);
+	mwifiex_dbg(priv->adapter, INFO, "info: Tx data rate set to %#x\n",
+		    priv->data_rate);
 
 	if (!priv->is_data_rate_auto) {
 		while (*ptr) {
@@ -180,9 +180,10 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 			}
 			ptr++;
 		}
-		dev_err(priv->adapter->dev, "previously set fixed data rate %#x"
-			" is not compatible with the network\n",
-			priv->data_rate);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "previously set fixed data rate %#x\t"
+			    "is not compatible with the network\n",
+			    priv->data_rate);
 
 		ret = -1;
 		goto done;
@@ -214,8 +215,9 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 	if (mwifiex_get_common_rates(priv, out_rates, MWIFIEX_SUPPORTED_RATES,
 				     card_rates, card_rates_size)) {
 		*out_rates_size = 0;
-		dev_err(priv->adapter->dev, "%s: cannot get common rates\n",
-			__func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: cannot get common rates\n",
+			    __func__);
 		return -1;
 	}
 
@@ -246,8 +248,9 @@ mwifiex_cmd_append_wps_ie(struct mwifiex_private *priv, u8 **buffer)
 	 * parameter buffer pointer.
 	 */
 	if (priv->wps_ie_len) {
-		dev_dbg(priv->adapter->dev, "cmd: append wps ie %d to %p\n",
-			priv->wps_ie_len, *buffer);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: append wps ie %d to %p\n",
+			    priv->wps_ie_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_MGMT_IE);
@@ -292,8 +295,9 @@ mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
 	 *   parameter buffer pointer.
 	 */
 	if (priv->wapi_ie_len) {
-		dev_dbg(priv->adapter->dev, "cmd: append wapi ie %d to %p\n",
-			priv->wapi_ie_len, *buffer);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: append wapi ie %d to %p\n",
+			    priv->wapi_ie_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
 		ie_header.type = cpu_to_le16(TLV_TYPE_WAPI_IE);
@@ -453,8 +457,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
 	memcpy(rates_tlv->rates, rates, rates_size);
 	pos += sizeof(rates_tlv->header) + rates_size;
-	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: rates size = %d\n",
-		rates_size);
+	mwifiex_dbg(priv->adapter, INFO, "info: ASSOC_CMD: rates size = %d\n",
+		    rates_size);
 
 	/* Add the Authentication type to be used for Auth frames */
 	auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
@@ -487,14 +491,14 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_chan_scan_param_set));
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
-		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Chan = %d\n",
-			chan_tlv->chan_scan_param[0].chan_number);
+		mwifiex_dbg(priv->adapter, INFO, "info: Assoc: TLV Chan = %d\n",
+			    chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Band = %d\n",
-			chan_tlv->chan_scan_param[0].radio_type);
+		mwifiex_dbg(priv->adapter, INFO, "info: Assoc: TLV Band = %d\n",
+			    chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
 	}
@@ -544,8 +548,9 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		tmp_cap &= ~WLAN_CAPABILITY_SHORT_SLOT_TIME;
 
 	tmp_cap &= CAPINFO_MASK;
-	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
-		tmp_cap, CAPINFO_MASK);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
+		    tmp_cap, CAPINFO_MASK);
 	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 	return 0;
@@ -645,9 +650,11 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	if (status_code) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
-		dev_err(priv->adapter->dev,
-			"ASSOC_RESP: failed, status code=%d err=%#x a_id=%#x\n",
-			status_code, cap_info, le16_to_cpu(assoc_rsp->a_id));
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "ASSOC_RESP: failed,\t"
+			    "status code=%d err=%#x a_id=%#x\n",
+			    status_code, cap_info,
+			    le16_to_cpu(assoc_rsp->a_id));
 
 		if (cap_info == MWIFIEX_TIMEOUT_FOR_AP_RESP) {
 			if (status_code == MWIFIEX_STATUS_CODE_AUTH_TIMEOUT)
@@ -671,8 +678,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	/* Set the attempted BSSID Index to current */
 	bss_desc = priv->attempted_bss_desc;
 
-	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: %s\n",
-		bss_desc->ssid.ssid);
+	mwifiex_dbg(priv->adapter, INFO, "info: ASSOC_RESP: %s\n",
+		    bss_desc->ssid.ssid);
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor,
@@ -702,8 +709,9 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 			= ((bss_desc->wmm_ie.qos_info_bitmap &
 				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
 
-	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
-		priv->curr_pkt_filter);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
+		    priv->curr_pkt_filter);
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->wpa_is_gtk_set = false;
 
@@ -719,8 +727,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	}
 
 	if (enable_data)
-		dev_dbg(priv->adapter->dev,
-			"info: post association, re-enabling data flow\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: post association, re-enabling data flow\n");
 
 	/* Reset SNR/NF/RSSI values */
 	priv->data_rssi_last = 0;
@@ -738,7 +746,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	priv->adapter->dbg.num_cmd_assoc_success++;
 
-	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: associated\n");
+	mwifiex_dbg(priv->adapter, INFO, "info: ASSOC_RESP: associated\n");
 
 	/* Add the ra_list here for infra mode as there will be only 1 ra
 	   always */
@@ -825,8 +833,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
-	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
-		adhoc_start->ssid);
+	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: SSID = %s\n",
+		    adhoc_start->ssid);
 
 	memset(bss_desc->ssid.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	memcpy(bss_desc->ssid.ssid, req_ssid->ssid, req_ssid->ssid_len);
@@ -858,12 +866,14 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	if (!priv->adhoc_channel) {
-		dev_err(adapter->dev, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: creating ADHOC on channel %d\n",
-		priv->adhoc_channel);
+	mwifiex_dbg(adapter, INFO,
+		    "info: ADHOC_S_CMD: creating ADHOC on channel %d\n",
+		    priv->adhoc_channel);
 
 	priv->curr_bss_params.bss_descriptor.channel = priv->adhoc_channel;
 	priv->curr_bss_params.band = adapter->adhoc_start_band;
@@ -895,13 +905,14 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	/* Set up privacy in bss_desc */
 	if (priv->sec_info.encryption_mode) {
 		/* Ad-Hoc capability privacy on */
-		dev_dbg(adapter->dev,
-			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 	} else {
-		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: wep_status NOT set,"
-				" setting privacy to ACCEPT ALL\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: ADHOC_S_CMD: wep_status NOT set,\t"
+			    "setting privacy to ACCEPT ALL\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
 	}
 
@@ -912,8 +923,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 				     HostCmd_ACT_GEN_SET, 0,
 				     &priv->curr_pkt_filter, false)) {
-			dev_err(adapter->dev,
-				"ADHOC_S_CMD: G Protection config failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "ADHOC_S_CMD: G Protection config failed\n");
 			return -1;
 		}
 	}
@@ -928,10 +939,10 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	memcpy(&priv->curr_bss_params.data_rates,
 	       &adhoc_start->data_rate, priv->curr_bss_params.num_of_rates);
 
-	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%4ph\n",
-		adhoc_start->data_rate);
+	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: rates=%4ph\n",
+		    adhoc_start->data_rate);
 
-	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
+	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
 
 	if (IS_SUPPORT_MULTI_BANDS(adapter)) {
 		/* Append a channel TLV */
@@ -945,8 +956,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		chan_tlv->chan_scan_param[0].chan_number =
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
 
-		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Chan = %d\n",
-			chan_tlv->chan_scan_param[0].chan_number);
+		mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: TLV Chan = %d\n",
+			    chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type
 		       = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
@@ -961,8 +972,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				chan_tlv->chan_scan_param[0].radio_type |=
 					(IEEE80211_HT_PARAM_CHA_SEC_BELOW << 4);
 		}
-		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Band = %d\n",
-			chan_tlv->chan_scan_param[0].radio_type);
+		mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: TLV Band = %d\n",
+			    chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
 		cmd_append_size +=
@@ -1084,8 +1095,8 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 				     HostCmd_ACT_GEN_SET, 0,
 				     &curr_pkt_filter, false)) {
-			dev_err(priv->adapter->dev,
-				"ADHOC_J_CMD: G Protection config failed\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "ADHOC_J_CMD: G Protection config failed\n");
 			return -1;
 		}
 	}
@@ -1116,14 +1127,15 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	tmp_cap &= CAPINFO_MASK;
 
-	dev_dbg(priv->adapter->dev,
-		"info: ADHOC_J_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
-		tmp_cap, CAPINFO_MASK);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: ADHOC_J_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
+		    tmp_cap, CAPINFO_MASK);
 
 	/* Information on BSSID descriptor passed to FW */
-	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: BSSID=%pM, SSID='%s'\n",
-		adhoc_join->bss_descriptor.bssid,
-		adhoc_join->bss_descriptor.ssid);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: ADHOC_J_CMD: BSSID=%pM, SSID='%s'\n",
+		    adhoc_join->bss_descriptor.bssid,
+		    adhoc_join->bss_descriptor.ssid);
 
 	for (i = 0; i < MWIFIEX_SUPPORTED_RATES &&
 		    bss_desc->supported_rates[i]; i++)
@@ -1159,14 +1171,14 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_chan_scan_param_set));
 		chan_tlv->chan_scan_param[0].chan_number =
 			(bss_desc->phy_param_set.ds_param_set.current_chan);
-		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Chan=%d\n",
-			chan_tlv->chan_scan_param[0].chan_number);
+		mwifiex_dbg(priv->adapter, INFO, "info: ADHOC_J_CMD: TLV Chan=%d\n",
+			    chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Band=%d\n",
-			chan_tlv->chan_scan_param[0].radio_type);
+		mwifiex_dbg(priv->adapter, INFO, "info: ADHOC_J_CMD: TLV Band=%d\n",
+			    chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 				sizeof(struct mwifiex_chan_scan_param_set);
 		cmd_append_size += sizeof(chan_tlv->header) +
@@ -1220,7 +1232,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	/* Join result code 0 --> SUCCESS */
 	reason_code = le16_to_cpu(resp->result);
 	if (reason_code) {
-		dev_err(priv->adapter->dev, "ADHOC_RESP: failed\n");
+		mwifiex_dbg(priv->adapter, ERROR, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
 			mwifiex_reset_connect_state(priv, reason_code);
 
@@ -1235,8 +1247,8 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	priv->media_connected = true;
 
 	if (le16_to_cpu(resp->command) == HostCmd_CMD_802_11_AD_HOC_START) {
-		dev_dbg(priv->adapter->dev, "info: ADHOC_S_RESP %s\n",
-			bss_desc->ssid.ssid);
+		mwifiex_dbg(priv->adapter, INFO, "info: ADHOC_S_RESP %s\n",
+			    bss_desc->ssid.ssid);
 
 		/* Update the created network descriptor with the new BSSID */
 		memcpy(bss_desc->mac_address,
@@ -1248,8 +1260,9 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		 * Now the join cmd should be successful.
 		 * If BSSID has changed use SSID to compare instead of BSSID
 		 */
-		dev_dbg(priv->adapter->dev, "info: ADHOC_J_RESP %s\n",
-			bss_desc->ssid.ssid);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ADHOC_J_RESP %s\n",
+			    bss_desc->ssid.ssid);
 
 		/*
 		 * Make a copy of current BSSID descriptor, only needed for
@@ -1262,10 +1275,10 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		priv->adhoc_state = ADHOC_JOINED;
 	}
 
-	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: channel = %d\n",
-		priv->adhoc_channel);
-	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: BSSID = %pM\n",
-		priv->curr_bss_params.bss_descriptor.mac_address);
+	mwifiex_dbg(priv->adapter, INFO, "info: ADHOC_RESP: channel = %d\n",
+		    priv->adhoc_channel);
+	mwifiex_dbg(priv->adapter, INFO, "info: ADHOC_RESP: BSSID = %pM\n",
+		    priv->curr_bss_params.bss_descriptor.mac_address);
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
@@ -1327,12 +1340,12 @@ int
 mwifiex_adhoc_start(struct mwifiex_private *priv,
 		    struct cfg80211_ssid *adhoc_ssid)
 {
-	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
-		priv->adhoc_channel);
-	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
-		priv->curr_bss_params.bss_descriptor.channel);
-	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
-		priv->curr_bss_params.band);
+	mwifiex_dbg(priv->adapter, INFO, "info: Adhoc Channel = %d\n",
+		    priv->adhoc_channel);
+	mwifiex_dbg(priv->adapter, INFO, "info: curr_bss_params.channel = %d\n",
+		    priv->curr_bss_params.bss_descriptor.channel);
+	mwifiex_dbg(priv->adapter, INFO, "info: curr_bss_params.band = %d\n",
+		    priv->curr_bss_params.band);
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
 	    priv->adapter->config_bands & BAND_AAC)
@@ -1353,14 +1366,16 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc)
 {
-	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid =%s\n",
-		priv->curr_bss_params.bss_descriptor.ssid.ssid);
-	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid_len =%u\n",
-		priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
-	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid =%s\n",
-		bss_desc->ssid.ssid);
-	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid_len =%u\n",
-		bss_desc->ssid.ssid_len);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: adhoc join: curr_bss ssid =%s\n",
+		    priv->curr_bss_params.bss_descriptor.ssid.ssid);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: adhoc join: curr_bss ssid_len =%u\n",
+		    priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+	mwifiex_dbg(priv->adapter, INFO, "info: adhoc join: ssid =%s\n",
+		    bss_desc->ssid.ssid);
+	mwifiex_dbg(priv->adapter, INFO, "info: adhoc join: ssid_len =%u\n",
+		    bss_desc->ssid.ssid_len);
 
 	/* Check if the requested SSID is already joined */
 	if (priv->curr_bss_params.bss_descriptor.ssid.ssid_len &&
@@ -1368,8 +1383,9 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 			      &priv->curr_bss_params.bss_descriptor.ssid) &&
 	    (priv->curr_bss_params.bss_descriptor.bss_mode ==
 							NL80211_IFTYPE_ADHOC)) {
-		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: new ad-hoc SSID"
-			" is the same as current; not attempting to re-join\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ADHOC_J_CMD: new ad-hoc SSID\t"
+			    "is the same as current; not attempting to re-join\n");
 		return -1;
 	}
 
@@ -1380,10 +1396,12 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	else
 		mwifiex_set_ba_params(priv);
 
-	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
-		priv->curr_bss_params.bss_descriptor.channel);
-	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
-		priv->curr_bss_params.band);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: curr_bss_params.channel = %d\n",
+		    priv->curr_bss_params.bss_descriptor.channel);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: curr_bss_params.band = %c\n",
+		    priv->curr_bss_params.band);
 
 	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
 				HostCmd_ACT_GEN_SET, 0, bss_desc, true);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index eca4378..138c1cc 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -94,7 +94,8 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	return 0;
 
 error:
-	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
+	mwifiex_dbg(adapter, ERROR,
+		    "info: leave mwifiex_register with error\n");
 
 	for (i = 0; i < adapter->priv_num; i++)
 		kfree(adapter->priv[i]);
@@ -459,8 +460,8 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	struct wireless_dev *wdev;
 
 	if (!firmware) {
-		dev_err(adapter->dev,
-			"Failed to get firmware %s\n", adapter->fw_name);
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to get firmware %s\n", adapter->fw_name);
 		goto err_dnld_fw;
 	}
 
@@ -476,13 +477,13 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (ret == -1)
 		goto err_dnld_fw;
 
-	dev_notice(adapter->dev, "WLAN FW is active\n");
+	mwifiex_dbg(adapter, MSG, "WLAN FW is active\n");
 
 	if (cal_data_cfg) {
 		if ((request_firmware(&adapter->cal_data, cal_data_cfg,
 				      adapter->dev)) < 0)
-			dev_err(adapter->dev,
-				"Cal data request_firmware() failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Cal data request_firmware() failed\n");
 	}
 
 	/* enable host interrupt after fw dnld is successful */
@@ -507,12 +508,14 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 
 	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
 	if (mwifiex_register_cfg80211(adapter)) {
-		dev_err(adapter->dev, "cannot register with cfg80211\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot register with cfg80211\n");
 		goto err_init_fw;
 	}
 
 	if (mwifiex_init_channel_scan_gap(adapter)) {
-		dev_err(adapter->dev, "could not init channel stats table\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "could not init channel stats table\n");
 		goto err_init_fw;
 	}
 
@@ -526,7 +529,8 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	wdev = mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d", NET_NAME_ENUM,
 					NL80211_IFTYPE_STATION, NULL, NULL);
 	if (IS_ERR(wdev)) {
-		dev_err(adapter->dev, "cannot create default STA interface\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot create default STA interface\n");
 		rtnl_unlock();
 		goto err_add_intf;
 	}
@@ -535,7 +539,8 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		wdev = mwifiex_add_virtual_intf(adapter->wiphy, "uap%d", NET_NAME_ENUM,
 						NL80211_IFTYPE_AP, NULL, NULL);
 		if (IS_ERR(wdev)) {
-			dev_err(adapter->dev, "cannot create AP interface\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot create AP interface\n");
 			rtnl_unlock();
 			goto err_add_intf;
 		}
@@ -546,8 +551,8 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 						NL80211_IFTYPE_P2P_CLIENT, NULL,
 						NULL);
 		if (IS_ERR(wdev)) {
-			dev_err(adapter->dev,
-				"cannot create p2p client interface\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cannot create p2p client interface\n");
 			rtnl_unlock();
 			goto err_add_intf;
 		}
@@ -555,7 +560,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
-	dev_notice(adapter->dev, "driver_version = %s\n", fmt);
+	mwifiex_dbg(adapter, MSG, "driver_version = %s\n", fmt);
 	goto done;
 
 err_add_intf:
@@ -565,7 +570,8 @@ err_init_fw:
 	if (adapter->if_ops.disable_int)
 		adapter->if_ops.disable_int(adapter);
 err_dnld_fw:
-	pr_debug("info: %s: unregister device\n", __func__);
+	mwifiex_dbg(adapter, ERROR,
+		    "info: %s: unregister device\n", __func__);
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 
@@ -606,8 +612,8 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 				      adapter->dev, GFP_KERNEL, adapter,
 				      mwifiex_fw_dpc);
 	if (ret < 0)
-		dev_err(adapter->dev,
-			"request_firmware_nowait() returned error %d\n", ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "request_firmware_nowait error %d\n", ret);
 	return ret;
 }
 
@@ -633,7 +639,8 @@ mwifiex_close(struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->scan_request) {
-		dev_dbg(priv->adapter->dev, "aborting scan on ndo_stop\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "aborting scan on ndo_stop\n");
 		cfg80211_scan_done(priv->scan_request, 1);
 		priv->scan_request = NULL;
 		priv->scan_aborting = true;
@@ -654,7 +661,8 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 		txq = netdev_get_tx_queue(priv->netdev, index);
 		if (!netif_tx_queue_stopped(txq)) {
 			netif_tx_stop_queue(txq);
-			dev_dbg(priv->adapter->dev, "stop queue: %d\n", index);
+			mwifiex_dbg(priv->adapter, DATA,
+				    "stop queue: %d\n", index);
 		}
 	}
 
@@ -719,8 +727,9 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_txinfo *tx_info;
 	bool multicast;
 
-	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
-		jiffies, priv->bss_type, priv->bss_num);
+	mwifiex_dbg(priv->adapter, DATA,
+		    "data: %lu BSS(%d-%d): Data <= kernel\n",
+		    jiffies, priv->bss_type, priv->bss_num);
 
 	if (priv->adapter->surprise_removed) {
 		kfree_skb(skb);
@@ -728,28 +737,31 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return 0;
 	}
 	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
-		dev_err(priv->adapter->dev, "Tx: bad skb len %d\n", skb->len);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Tx: bad skb len %d\n", skb->len);
 		kfree_skb(skb);
 		priv->stats.tx_dropped++;
 		return 0;
 	}
 	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
-		dev_dbg(priv->adapter->dev,
-			"data: Tx: insufficient skb headroom %d\n",
-			skb_headroom(skb));
+		mwifiex_dbg(priv->adapter, DATA,
+			    "data: Tx: insufficient skb headroom %d\n",
+			    skb_headroom(skb));
 		/* Insufficient skb headroom - allocate a new skb */
 		new_skb =
 			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
 		if (unlikely(!new_skb)) {
-			dev_err(priv->adapter->dev, "Tx: cannot alloca new_skb\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Tx: cannot alloca new_skb\n");
 			kfree_skb(skb);
 			priv->stats.tx_dropped++;
 			return 0;
 		}
 		kfree_skb(skb);
 		skb = new_skb;
-		dev_dbg(priv->adapter->dev, "info: new skb headroomd %d\n",
-			skb_headroom(skb));
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: new skb headroomd %d\n",
+			    skb_headroom(skb));
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
@@ -807,8 +819,8 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 	if (!ret)
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
 	else
-		dev_err(priv->adapter->dev,
-			"set mac address failed: ret=%d\n", ret);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "set mac address failed: ret=%d\n", ret);
 
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
@@ -846,15 +858,17 @@ mwifiex_tx_timeout(struct net_device *dev)
 
 	priv->num_tx_timeout++;
 	priv->tx_timeout_cnt++;
-	dev_err(priv->adapter->dev,
-		"%lu : Tx timeout(#%d), bss_type-num = %d-%d\n",
-		jiffies, priv->tx_timeout_cnt, priv->bss_type, priv->bss_num);
+	mwifiex_dbg(priv->adapter, ERROR,
+		    "%lu : Tx timeout(#%d), bss_type-num = %d-%d\n",
+		    jiffies, priv->tx_timeout_cnt, priv->bss_type,
+		    priv->bss_num);
 	mwifiex_set_trans_start(dev);
 
 	if (priv->tx_timeout_cnt > TX_TIMEOUT_THRESHOLD &&
 	    priv->adapter->if_ops.card_reset) {
-		dev_err(priv->adapter->dev,
-			"tx_timeout_cnt exceeds threshold. Triggering card reset!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tx_timeout_cnt exceeds threshold.\t"
+			    "Triggering card reset!\n");
 		priv->adapter->if_ops.card_reset(priv->adapter);
 	}
 }
@@ -875,7 +889,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 		adapter->drv_info_size = 0;
 	}
 
-	dev_info(adapter->dev, "=== DRIVER INFO DUMP START===\n");
+	mwifiex_dbg(adapter, MSG, "=== DRIVER INFO DUMP START===\n");
 
 	adapter->drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
 
@@ -963,7 +977,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->drv_info_size = p - adapter->drv_info_dump;
-	dev_info(adapter->dev, "=== DRIVER INFO DUMP END===\n");
+	mwifiex_dbg(adapter, MSG, "=== DRIVER INFO DUMP END===\n");
 }
 EXPORT_SYMBOL_GPL(mwifiex_dump_drv_info);
 
@@ -1234,21 +1248,24 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		}
 	}
 
-	dev_dbg(adapter->dev, "cmd: calling mwifiex_shutdown_drv...\n");
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: calling mwifiex_shutdown_drv...\n");
 	adapter->init_wait_q_woken = false;
 
 	if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
 		wait_event_interruptible(adapter->init_wait_q,
 					 adapter->init_wait_q_woken);
-	dev_dbg(adapter->dev, "cmd: mwifiex_shutdown_drv done\n");
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: mwifiex_shutdown_drv done\n");
 	if (atomic_read(&adapter->rx_pending) ||
 	    atomic_read(&adapter->tx_pending) ||
 	    atomic_read(&adapter->cmd_pending)) {
-		dev_err(adapter->dev, "rx_pending=%d, tx_pending=%d, "
-		       "cmd_pending=%d\n",
-		       atomic_read(&adapter->rx_pending),
-		       atomic_read(&adapter->tx_pending),
-		       atomic_read(&adapter->cmd_pending));
+		mwifiex_dbg(adapter, ERROR,
+			    "rx_pending=%d, tx_pending=%d,\t"
+			    "cmd_pending=%d\n",
+			    atomic_read(&adapter->rx_pending),
+			    atomic_read(&adapter->tx_pending),
+			    atomic_read(&adapter->cmd_pending));
 	}
 
 	for (i = 0; i < adapter->priv_num; i++) {
@@ -1268,11 +1285,13 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	wiphy_free(adapter->wiphy);
 
 	/* Unregister device */
-	dev_dbg(adapter->dev, "info: unregister device\n");
+	mwifiex_dbg(adapter, INFO,
+		    "info: unregister device\n");
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 	/* Free adapter structure */
-	dev_dbg(adapter->dev, "info: free adapter\n");
+	mwifiex_dbg(adapter, INFO,
+		    "info: free adapter\n");
 	mwifiex_free_adapter(adapter);
 
 exit_remove:
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 88bda3f..7219243 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -57,7 +57,7 @@ mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 
 	mapping.addr = pci_map_single(card->dev, skb->data, size, flags);
 	if (pci_dma_mapping_error(card->dev, mapping.addr)) {
-		dev_err(adapter->dev, "failed to map pci memory!\n");
+		mwifiex_dbg(adapter, ERROR, "failed to map pci memory!\n");
 		return -1;
 	}
 	mapping.len = size;
@@ -89,8 +89,9 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 
 	if (card->sleep_cookie_vbase) {
 		cookie_addr = (u32 *)card->sleep_cookie_vbase;
-		dev_dbg(adapter->dev, "info: ACCESS_HW: sleep cookie=0x%x\n",
-			*cookie_addr);
+		mwifiex_dbg(adapter, INFO,
+			    "info: ACCESS_HW: sleep cookie=0x%x\n",
+			    *cookie_addr);
 		if (*cookie_addr == FW_AWAKE_COOKIE)
 			return true;
 	}
@@ -164,7 +165,8 @@ static int mwifiex_pcie_resume(struct device *dev)
 	adapter = card->adapter;
 
 	if (!adapter->is_suspended) {
-		dev_warn(adapter->dev, "Device already resumed\n");
+		mwifiex_dbg(adapter, WARN,
+			    "Device already resumed\n");
 		return 0;
 	}
 
@@ -361,16 +363,16 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 		sleep_cookie = *(u32 *)buffer;
 
 		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
-			dev_dbg(adapter->dev,
-				"sleep cookie found at count %d\n", count);
+			mwifiex_dbg(adapter, INFO,
+				    "sleep cookie found at count %d\n", count);
 			break;
 		}
 		usleep_range(20, 30);
 	}
 
 	if (count >= max_delay_loop_cnt)
-		dev_dbg(adapter->dev,
-			"max count reached while accessing sleep cookie\n");
+		mwifiex_dbg(adapter, INFO,
+			    "max count reached while accessing sleep cookie\n");
 }
 
 /* This function wakes up the card by reading fw_status register. */
@@ -380,20 +382,23 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	dev_dbg(adapter->dev, "event: Wakeup device...\n");
+	mwifiex_dbg(adapter, EVENT,
+		    "event: Wakeup device...\n");
 
 	if (reg->sleep_cookie)
 		mwifiex_pcie_dev_wakeup_delay(adapter);
 
 	/* Reading fw_status register will wakeup device */
 	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status)) {
-		dev_warn(adapter->dev, "Reading fw_status register failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Reading fw_status register failed\n");
 		return -1;
 	}
 
 	if (reg->sleep_cookie) {
 		mwifiex_pcie_dev_wakeup_delay(adapter);
-		dev_dbg(adapter->dev, "PCIE wakeup: Setting PS_STATE_AWAKE\n");
+		mwifiex_dbg(adapter, INFO,
+			    "PCIE wakeup: Setting PS_STATE_AWAKE\n");
 		adapter->ps_state = PS_STATE_AWAKE;
 	}
 
@@ -407,7 +412,8 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
-	dev_dbg(adapter->dev, "cmd: Wakeup device completed\n");
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: Wakeup device completed\n");
 
 	return 0;
 }
@@ -423,7 +429,8 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK,
 				      0x00000000)) {
-			dev_warn(adapter->dev, "Disable host interrupt failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Disable host interrupt failed\n");
 			return -1;
 		}
 	}
@@ -443,7 +450,8 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 		/* Simply write the mask to the register */
 		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK,
 				      HOST_INTR_MASK)) {
-			dev_warn(adapter->dev, "Enable host interrupt failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Enable host interrupt failed\n");
 			return -1;
 		}
 	}
@@ -499,8 +507,8 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 		skb = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
 						  GFP_KERNEL | GFP_DMA);
 		if (!skb) {
-			dev_err(adapter->dev,
-				"Unable to allocate skb for RX ring.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Unable to allocate skb for RX ring.\n");
 			kfree(card->rxbd_ring_vbase);
 			return -ENOMEM;
 		}
@@ -512,10 +520,10 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
-		dev_dbg(adapter->dev,
-			"info: RX ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
-			skb, skb->len, skb->data, (u32)buf_pa,
-			(u32)((u64)buf_pa >> 32));
+		mwifiex_dbg(adapter, INFO,
+			    "info: RX ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
+			    skb, skb->len, skb->data, (u32)buf_pa,
+			    (u32)((u64)buf_pa >> 32));
 
 		card->rx_buf_list[i] = skb;
 		if (reg->pfu_enabled) {
@@ -556,8 +564,8 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 		/* Allocate skb here so that firmware can DMA data from it */
 		skb = dev_alloc_skb(MAX_EVENT_SIZE);
 		if (!skb) {
-			dev_err(adapter->dev,
-				"Unable to allocate skb for EVENT buf.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Unable to allocate skb for EVENT buf.\n");
 			kfree(card->evtbd_ring_vbase);
 			return -ENOMEM;
 		}
@@ -569,10 +577,10 @@ static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
 
-		dev_dbg(adapter->dev,
-			"info: EVT ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
-			skb, skb->len, skb->data, (u32)buf_pa,
-			(u32)((u64)buf_pa >> 32));
+		mwifiex_dbg(adapter, EVENT,
+			    "info: EVT ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
+			    skb, skb->len, skb->data, (u32)buf_pa,
+			    (u32)((u64)buf_pa >> 32));
 
 		card->evt_buf_list[i] = skb;
 		card->evtbd_ring[i] = (void *)(card->evtbd_ring_vbase +
@@ -715,21 +723,23 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 		card->txbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
 				       MWIFIEX_MAX_TXRX_BD;
 
-	dev_dbg(adapter->dev, "info: txbd_ring: Allocating %d bytes\n",
-		card->txbd_ring_size);
+	mwifiex_dbg(adapter, INFO,
+		    "info: txbd_ring: Allocating %d bytes\n",
+		    card->txbd_ring_size);
 	card->txbd_ring_vbase = pci_alloc_consistent(card->dev,
 						     card->txbd_ring_size,
 						     &card->txbd_ring_pbase);
 	if (!card->txbd_ring_vbase) {
-		dev_err(adapter->dev,
-			"allocate consistent memory (%d bytes) failed!\n",
-			card->txbd_ring_size);
+		mwifiex_dbg(adapter, ERROR,
+			    "allocate consistent memory (%d bytes) failed!\n",
+			    card->txbd_ring_size);
 		return -ENOMEM;
 	}
-	dev_dbg(adapter->dev,
-		"info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
-		card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
-		(u32)((u64)card->txbd_ring_pbase >> 32), card->txbd_ring_size);
+	mwifiex_dbg(adapter, DATA,
+		    "info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
+		    card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
+		    (u32)((u64)card->txbd_ring_pbase >> 32),
+		    card->txbd_ring_size);
 
 	return mwifiex_init_txq_ring(adapter);
 }
@@ -777,23 +787,24 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 		card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
 				       MWIFIEX_MAX_TXRX_BD;
 
-	dev_dbg(adapter->dev, "info: rxbd_ring: Allocating %d bytes\n",
-		card->rxbd_ring_size);
+	mwifiex_dbg(adapter, INFO,
+		    "info: rxbd_ring: Allocating %d bytes\n",
+		    card->rxbd_ring_size);
 	card->rxbd_ring_vbase = pci_alloc_consistent(card->dev,
 						     card->rxbd_ring_size,
 						     &card->rxbd_ring_pbase);
 	if (!card->rxbd_ring_vbase) {
-		dev_err(adapter->dev,
-			"allocate consistent memory (%d bytes) failed!\n",
-			card->rxbd_ring_size);
+		mwifiex_dbg(adapter, ERROR,
+			    "allocate consistent memory (%d bytes) failed!\n",
+			    card->rxbd_ring_size);
 		return -ENOMEM;
 	}
 
-	dev_dbg(adapter->dev,
-		"info: rxbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
-		card->rxbd_ring_vbase, (u32)card->rxbd_ring_pbase,
-		(u32)((u64)card->rxbd_ring_pbase >> 32),
-		card->rxbd_ring_size);
+	mwifiex_dbg(adapter, DATA,
+		    "info: rxbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
+		    card->rxbd_ring_vbase, (u32)card->rxbd_ring_pbase,
+		    (u32)((u64)card->rxbd_ring_pbase >> 32),
+		    card->rxbd_ring_size);
 
 	return mwifiex_init_rxq_ring(adapter);
 }
@@ -840,23 +851,24 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	card->evtbd_ring_size = sizeof(struct mwifiex_evt_buf_desc) *
 				MWIFIEX_MAX_EVT_BD;
 
-	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
+	mwifiex_dbg(adapter, INFO,
+		    "info: evtbd_ring: Allocating %d bytes\n",
 		card->evtbd_ring_size);
 	card->evtbd_ring_vbase = pci_alloc_consistent(card->dev,
 						      card->evtbd_ring_size,
 						      &card->evtbd_ring_pbase);
 	if (!card->evtbd_ring_vbase) {
-		dev_err(adapter->dev,
-			"allocate consistent memory (%d bytes) failed!\n",
-			card->evtbd_ring_size);
+		mwifiex_dbg(adapter, ERROR,
+			    "allocate consistent memory (%d bytes) failed!\n",
+			    card->evtbd_ring_size);
 		return -ENOMEM;
 	}
 
-	dev_dbg(adapter->dev,
-		"info: CMDRSP/EVT bd_ring - base: %p pbase: %#x:%x len: %#x\n",
-		card->evtbd_ring_vbase, (u32)card->evtbd_ring_pbase,
-		(u32)((u64)card->evtbd_ring_pbase >> 32),
-		card->evtbd_ring_size);
+	mwifiex_dbg(adapter, EVENT,
+		    "info: CMDRSP/EVT bd_ring - base: %p pbase: %#x:%x len: %#x\n",
+		    card->evtbd_ring_vbase, (u32)card->evtbd_ring_pbase,
+		    (u32)((u64)card->evtbd_ring_pbase >> 32),
+		    card->evtbd_ring_size);
 
 	return mwifiex_pcie_init_evt_ring(adapter);
 }
@@ -895,8 +907,8 @@ static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
 	/* Allocate memory for receiving command response data */
 	skb = dev_alloc_skb(MWIFIEX_UPLD_SIZE);
 	if (!skb) {
-		dev_err(adapter->dev,
-			"Unable to allocate skb for command response data.\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Unable to allocate skb for command response data.\n");
 		return -ENOMEM;
 	}
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
@@ -944,14 +956,16 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
 						     &card->sleep_cookie_pbase);
 	if (!card->sleep_cookie_vbase) {
-		dev_err(adapter->dev, "pci_alloc_consistent failed!\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "pci_alloc_consistent failed!\n");
 		return -ENOMEM;
 	}
 	/* Init val of Sleep Cookie */
 	*(u32 *)card->sleep_cookie_vbase = FW_AWAKE_COOKIE;
 
-	dev_dbg(adapter->dev, "alloc_scook: sleep cookie=0x%x\n",
-		*((u32 *)card->sleep_cookie_vbase));
+	mwifiex_dbg(adapter, INFO,
+		    "alloc_scook: sleep cookie=0x%x\n",
+		    *((u32 *)card->sleep_cookie_vbase));
 
 	return 0;
 }
@@ -993,8 +1007,8 @@ static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
 		 */
 		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 				      CPU_INTR_DNLD_RDY)) {
-			dev_err(adapter->dev,
-				"failed to assert dnld-rdy interrupt.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "failed to assert dnld-rdy interrupt.\n");
 			return -1;
 		}
 	}
@@ -1018,13 +1032,14 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 
 	/* Read the TX ring read pointer set by firmware */
 	if (mwifiex_read_reg(adapter, reg->tx_rdptr, &rdptr)) {
-		dev_err(adapter->dev,
-			"SEND COMP: failed to read reg->tx_rdptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "SEND COMP: failed to read reg->tx_rdptr\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "SEND COMP: rdptr_prev=0x%x, rdptr=0x%x\n",
-		card->txbd_rdptr, rdptr);
+	mwifiex_dbg(adapter, DATA,
+		    "SEND COMP: rdptr_prev=0x%x, rdptr=0x%x\n",
+		    card->txbd_rdptr, rdptr);
 
 	num_tx_buffs = MWIFIEX_MAX_TXRX_BD << reg->tx_start_ptr;
 	/* free from previous txbd_rdptr to current txbd_rdptr */
@@ -1038,9 +1053,9 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 		skb = card->tx_buf_list[wrdoneidx];
 
 		if (skb) {
-			dev_dbg(adapter->dev,
-				"SEND COMP: Detach skb %p at txbd_rdidx=%d\n",
-				skb, wrdoneidx);
+			mwifiex_dbg(adapter, DATA,
+				    "SEND COMP: Detach skb %p at txbd_rdidx=%d\n",
+				    skb, wrdoneidx);
 			mwifiex_unmap_pci_memory(adapter, skb,
 						 PCI_DMA_TODEVICE);
 
@@ -1112,8 +1127,9 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 	__le16 *tmp;
 
 	if (!(skb->data && skb->len)) {
-		dev_err(adapter->dev, "%s(): invalid parameter <%p, %#x>\n",
-			__func__, skb->data, skb->len);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s(): invalid parameter <%p, %#x>\n",
+			    __func__, skb->data, skb->len);
 		return -1;
 	}
 
@@ -1121,7 +1137,8 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		mwifiex_pm_wakeup_card(adapter);
 
 	num_tx_buffs = MWIFIEX_MAX_TXRX_BD << reg->tx_start_ptr;
-	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n",
+	mwifiex_dbg(adapter, DATA,
+		    "info: SEND DATA: <Rd: %#x, Wr: %#x>\n",
 		card->txbd_rdptr, card->txbd_wrptr);
 	if (mwifiex_pcie_txbd_not_full(card)) {
 		u8 *payload;
@@ -1175,39 +1192,40 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		/* Write the TX ring write pointer in to reg->tx_wrptr */
 		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
 				      card->txbd_wrptr | rx_val)) {
-			dev_err(adapter->dev,
-				"SEND DATA: failed to write reg->tx_wrptr\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "SEND DATA: failed to write reg->tx_wrptr\n");
 			ret = -1;
 			goto done_unmap;
 		}
 		if ((mwifiex_pcie_txbd_not_full(card)) &&
 		    tx_param->next_pkt_len) {
 			/* have more packets and TxBD still can hold more */
-			dev_dbg(adapter->dev,
-				"SEND DATA: delay dnld-rdy interrupt.\n");
+			mwifiex_dbg(adapter, DATA,
+				    "SEND DATA: delay dnld-rdy interrupt.\n");
 			adapter->data_sent = false;
 		} else {
 			/* Send the TX ready interrupt */
 			if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 					      CPU_INTR_DNLD_RDY)) {
-				dev_err(adapter->dev,
-					"SEND DATA: failed to assert dnld-rdy interrupt.\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "SEND DATA: failed to assert dnld-rdy interrupt.\n");
 				ret = -1;
 				goto done_unmap;
 			}
 		}
-		dev_dbg(adapter->dev, "info: SEND DATA: Updated <Rd: %#x, Wr: "
-			"%#x> and sent packet to firmware successfully\n",
-			card->txbd_rdptr, card->txbd_wrptr);
+		mwifiex_dbg(adapter, DATA,
+			    "info: SEND DATA: Updated <Rd: %#x, Wr:\t"
+			    "%#x> and sent packet to firmware successfully\n",
+			    card->txbd_rdptr, card->txbd_wrptr);
 	} else {
-		dev_dbg(adapter->dev,
-			"info: TX Ring full, can't send packets to fw\n");
+		mwifiex_dbg(adapter, DATA,
+			    "info: TX Ring full, can't send packets to fw\n");
 		adapter->data_sent = true;
 		/* Send the TX ready interrupt */
 		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 				      CPU_INTR_DNLD_RDY))
-			dev_err(adapter->dev,
-				"SEND DATA: failed to assert door-bell intr\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "SEND DATA: failed to assert door-bell intr\n");
 		return -EBUSY;
 	}
 
@@ -1243,8 +1261,8 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 
 	/* Read the RX ring Write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, reg->rx_wrptr, &wrptr)) {
-		dev_err(adapter->dev,
-			"RECV DATA: failed to read reg->rx_wrptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "RECV DATA: failed to read reg->rx_wrptr\n");
 		ret = -1;
 		goto done;
 	}
@@ -1277,15 +1295,15 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		rx_len = le16_to_cpu(pkt_len);
 		if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
 			    rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
-			dev_err(adapter->dev,
-				"Invalid RX len %d, Rd=%#x, Wr=%#x\n",
-				rx_len, card->rxbd_rdptr, wrptr);
+			mwifiex_dbg(adapter, ERROR,
+				    "Invalid RX len %d, Rd=%#x, Wr=%#x\n",
+				    rx_len, card->rxbd_rdptr, wrptr);
 			dev_kfree_skb_any(skb_data);
 		} else {
 			skb_put(skb_data, rx_len);
-			dev_dbg(adapter->dev,
-				"info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
-				card->rxbd_rdptr, wrptr, rx_len);
+			mwifiex_dbg(adapter, DATA,
+				    "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
+				    card->rxbd_rdptr, wrptr, rx_len);
 			skb_pull(skb_data, INTF_HEADER_LEN);
 			if (adapter->rx_work_enabled) {
 				skb_queue_tail(&adapter->rx_data_q, skb_data);
@@ -1299,8 +1317,8 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		skb_tmp = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
 						      GFP_KERNEL | GFP_DMA);
 		if (!skb_tmp) {
-			dev_err(adapter->dev,
-				"Unable to allocate skb.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Unable to allocate skb.\n");
 			return -ENOMEM;
 		}
 
@@ -1311,9 +1329,9 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 
 		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb_tmp);
 
-		dev_dbg(adapter->dev,
-			"RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
-			skb_tmp, rd_index);
+		mwifiex_dbg(adapter, INFO,
+			    "RECV DATA: Attach new sk_buff %p at rxbd_rdidx=%d\n",
+			    skb_tmp, rd_index);
 		card->rx_buf_list[rd_index] = skb_tmp;
 
 		if (reg->pfu_enabled) {
@@ -1336,28 +1354,29 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 					     reg->rx_rollover_ind) ^
 					     reg->rx_rollover_ind);
 		}
-		dev_dbg(adapter->dev, "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
-			card->rxbd_rdptr, wrptr);
+		mwifiex_dbg(adapter, DATA,
+			    "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
+			    card->rxbd_rdptr, wrptr);
 
 		tx_val = card->txbd_wrptr & reg->tx_wrap_mask;
 		/* Write the RX ring read pointer in to reg->rx_rdptr */
 		if (mwifiex_write_reg(adapter, reg->rx_rdptr,
 				      card->rxbd_rdptr | tx_val)) {
-			dev_err(adapter->dev,
-				"RECV DATA: failed to write reg->rx_rdptr\n");
+			mwifiex_dbg(adapter, DATA,
+				    "RECV DATA: failed to write reg->rx_rdptr\n");
 			ret = -1;
 			goto done;
 		}
 
 		/* Read the RX ring Write pointer set by firmware */
 		if (mwifiex_read_reg(adapter, reg->rx_wrptr, &wrptr)) {
-			dev_err(adapter->dev,
-				"RECV DATA: failed to read reg->rx_wrptr\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "RECV DATA: failed to read reg->rx_wrptr\n");
 			ret = -1;
 			goto done;
 		}
-		dev_dbg(adapter->dev,
-			"info: RECV DATA: Rcvd packet from fw successfully\n");
+		mwifiex_dbg(adapter, DATA,
+			    "info: RECV DATA: Rcvd packet from fw successfully\n");
 		card->rxbd_wrptr = wrptr;
 	}
 
@@ -1376,9 +1395,9 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (!(skb->data && skb->len)) {
-		dev_err(adapter->dev,
-			"Invalid parameter in %s <%p. len %d>\n",
-			__func__, skb->data, skb->len);
+		mwifiex_dbg(adapter, ERROR,
+			    "Invalid parameter in %s <%p. len %d>\n",
+			    __func__, skb->data, skb->len);
 		return -1;
 	}
 
@@ -1391,9 +1410,9 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	 * address scratch register
 	 */
 	if (mwifiex_write_reg(adapter, reg->cmd_addr_lo, (u32)buf_pa)) {
-		dev_err(adapter->dev,
-			"%s: failed to write download command to boot code.\n",
-			__func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to write download command to boot code.\n",
+			    __func__);
 		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
@@ -1403,18 +1422,18 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	 */
 	if (mwifiex_write_reg(adapter, reg->cmd_addr_hi,
 			      (u32)((u64)buf_pa >> 32))) {
-		dev_err(adapter->dev,
-			"%s: failed to write download command to boot code.\n",
-			__func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to write download command to boot code.\n",
+			    __func__);
 		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
 
 	/* Write the command length to cmd_size scratch register */
 	if (mwifiex_write_reg(adapter, reg->cmd_size, skb->len)) {
-		dev_err(adapter->dev,
-			"%s: failed to write command len to cmd_size scratch reg\n",
-			__func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to write command len to cmd_size scratch reg\n",
+			    __func__);
 		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
@@ -1422,8 +1441,8 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Ring the door bell */
 	if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 			      CPU_INTR_DOOR_BELL)) {
-		dev_err(adapter->dev,
-			"%s: failed to assert door-bell intr\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: failed to assert door-bell intr\n", __func__);
 		mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
 		return -1;
 	}
@@ -1443,8 +1462,8 @@ static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
 	/* Write the RX ring read pointer in to reg->rx_rdptr */
 	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr |
 			      tx_wrap)) {
-		dev_err(adapter->dev,
-			"RECV DATA: failed to write reg->rx_rdptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "RECV DATA: failed to write reg->rx_rdptr\n");
 		return -1;
 	}
 	return 0;
@@ -1462,15 +1481,16 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	u8 *payload = (u8 *)skb->data;
 
 	if (!(skb->data && skb->len)) {
-		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x>\n",
-			__func__, skb->data, skb->len);
+		mwifiex_dbg(adapter, ERROR,
+			    "Invalid parameter in %s <%p, %#x>\n",
+			    __func__, skb->data, skb->len);
 		return -1;
 	}
 
 	/* Make sure a command response buffer is available */
 	if (!card->cmdrsp_buf) {
-		dev_err(adapter->dev,
-			"No response buffer available, send command failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "No response buffer available, send command failed\n");
 		return -EBUSY;
 	}
 
@@ -1503,8 +1523,8 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		   address */
 		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_lo,
 				      (u32)cmdrsp_buf_pa)) {
-			dev_err(adapter->dev,
-				"Failed to write download cmd to boot code.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to write download cmd to boot code.\n");
 			ret = -1;
 			goto done;
 		}
@@ -1512,8 +1532,8 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		   address */
 		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_hi,
 				      (u32)((u64)cmdrsp_buf_pa >> 32))) {
-			dev_err(adapter->dev,
-				"Failed to write download cmd to boot code.\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to write download cmd to boot code.\n");
 			ret = -1;
 			goto done;
 		}
@@ -1523,16 +1543,16 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Write the lower 32bits of the physical address to reg->cmd_addr_lo */
 	if (mwifiex_write_reg(adapter, reg->cmd_addr_lo,
 			      (u32)cmd_buf_pa)) {
-		dev_err(adapter->dev,
-			"Failed to write download cmd to boot code.\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to write download cmd to boot code.\n");
 		ret = -1;
 		goto done;
 	}
 	/* Write the upper 32bits of the physical address to reg->cmd_addr_hi */
 	if (mwifiex_write_reg(adapter, reg->cmd_addr_hi,
 			      (u32)((u64)cmd_buf_pa >> 32))) {
-		dev_err(adapter->dev,
-			"Failed to write download cmd to boot code.\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to write download cmd to boot code.\n");
 		ret = -1;
 		goto done;
 	}
@@ -1540,8 +1560,8 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Write the command length to reg->cmd_size */
 	if (mwifiex_write_reg(adapter, reg->cmd_size,
 			      card->cmd_buf->len)) {
-		dev_err(adapter->dev,
-			"Failed to write cmd len to reg->cmd_size\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to write cmd len to reg->cmd_size\n");
 		ret = -1;
 		goto done;
 	}
@@ -1549,8 +1569,8 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Ring the door bell */
 	if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 			      CPU_INTR_DOOR_BELL)) {
-		dev_err(adapter->dev,
-			"Failed to assert door-bell intr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to assert door-bell intr\n");
 		ret = -1;
 		goto done;
 	}
@@ -1574,7 +1594,8 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	u16 rx_len;
 	__le16 pkt_len;
 
-	dev_dbg(adapter->dev, "info: Rx CMD Response\n");
+	mwifiex_dbg(adapter, CMD,
+		    "info: Rx CMD Response\n");
 
 	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_FROMDEVICE);
 
@@ -1598,8 +1619,8 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 			if (mwifiex_write_reg(adapter,
 					      PCIE_CPU_INT_EVENT,
 					      CPU_INTR_SLEEP_CFM_DONE)) {
-				dev_warn(adapter->dev,
-					 "Write register failed\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "Write register failed\n");
 				return -1;
 			}
 			mwifiex_delay_for_sleep_cookie(adapter,
@@ -1608,8 +1629,8 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
 		} else {
-			dev_err(adapter->dev,
-				"There is no command but got cmdrsp\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "There is no command but got cmdrsp\n");
 		}
 		memcpy(adapter->upld_buf, skb->data,
 		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
@@ -1628,15 +1649,15 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		   will prevent firmware from writing to the same response
 		   buffer again. */
 		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_lo, 0)) {
-			dev_err(adapter->dev,
-				"cmd_done: failed to clear cmd_rsp_addr_lo\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cmd_done: failed to clear cmd_rsp_addr_lo\n");
 			return -1;
 		}
 		/* Write the upper 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, reg->cmdrsp_addr_hi, 0)) {
-			dev_err(adapter->dev,
-				"cmd_done: failed to clear cmd_rsp_addr_hi\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "cmd_done: failed to clear cmd_rsp_addr_hi\n");
 			return -1;
 		}
 	}
@@ -1678,25 +1699,28 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		mwifiex_pm_wakeup_card(adapter);
 
 	if (adapter->event_received) {
-		dev_dbg(adapter->dev, "info: Event being processed, "
-			"do not process this interrupt just yet\n");
+		mwifiex_dbg(adapter, EVENT,
+			    "info: Event being processed,\t"
+			    "do not process this interrupt just yet\n");
 		return 0;
 	}
 
 	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
-		dev_dbg(adapter->dev, "info: Invalid read pointer...\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "info: Invalid read pointer...\n");
 		return -1;
 	}
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, reg->evt_wrptr, &wrptr)) {
-		dev_err(adapter->dev,
-			"EventReady: failed to read reg->evt_wrptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "EventReady: failed to read reg->evt_wrptr\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "info: EventReady: Initial <Rd: 0x%x, Wr: 0x%x>",
-		card->evtbd_rdptr, wrptr);
+	mwifiex_dbg(adapter, EVENT,
+		    "info: EventReady: Initial <Rd: 0x%x, Wr: 0x%x>",
+		    card->evtbd_rdptr, wrptr);
 	if (((wrptr & MWIFIEX_EVTBD_MASK) != (card->evtbd_rdptr
 					      & MWIFIEX_EVTBD_MASK)) ||
 	    ((wrptr & reg->evt_rollover_ind) ==
@@ -1705,7 +1729,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		__le16 data_len = 0;
 		u16 evt_len;
 
-		dev_dbg(adapter->dev, "info: Read Index: %d\n", rdptr);
+		mwifiex_dbg(adapter, INFO,
+			    "info: Read Index: %d\n", rdptr);
 		skb_cmd = card->evt_buf_list[rdptr];
 		mwifiex_unmap_pci_memory(adapter, skb_cmd, PCI_DMA_FROMDEVICE);
 
@@ -1723,7 +1748,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		evt_len = le16_to_cpu(data_len);
 		skb_trim(skb_cmd, evt_len);
 		skb_pull(skb_cmd, INTF_HEADER_LEN);
-		dev_dbg(adapter->dev, "info: Event length: %d\n", evt_len);
+		mwifiex_dbg(adapter, EVENT,
+			    "info: Event length: %d\n", evt_len);
 
 		if ((evt_len > 0) && (evt_len  < MAX_EVENT_SIZE))
 			memcpy(adapter->event_body, skb_cmd->data +
@@ -1740,8 +1766,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 	} else {
 		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 				      CPU_INTR_EVENT_DONE)) {
-			dev_warn(adapter->dev,
-				 "Write register failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Write register failed\n");
 			return -1;
 		}
 	}
@@ -1766,15 +1792,16 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 		return 0;
 
 	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
-		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
-			rdptr);
+		mwifiex_dbg(adapter, ERROR,
+			    "event_complete: Invalid rdptr 0x%x\n",
+			    rdptr);
 		return -EINVAL;
 	}
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, reg->evt_wrptr, &wrptr)) {
-		dev_err(adapter->dev,
-			"event_complete: failed to read reg->evt_wrptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "event_complete: failed to read reg->evt_wrptr\n");
 		return -1;
 	}
 
@@ -1791,9 +1818,9 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 		desc->flags = 0;
 		skb = NULL;
 	} else {
-		dev_dbg(adapter->dev,
-			"info: ERROR: buf still valid at index %d, <%p, %p>\n",
-			rdptr, card->evt_buf_list[rdptr], skb);
+		mwifiex_dbg(adapter, ERROR,
+			    "info: ERROR: buf still valid at index %d, <%p, %p>\n",
+			    rdptr, card->evt_buf_list[rdptr], skb);
 	}
 
 	if ((++card->evtbd_rdptr & MWIFIEX_EVTBD_MASK) == MWIFIEX_MAX_EVT_BD) {
@@ -1802,18 +1829,20 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 					reg->evt_rollover_ind);
 	}
 
-	dev_dbg(adapter->dev, "info: Updated <Rd: 0x%x, Wr: 0x%x>",
-		card->evtbd_rdptr, wrptr);
+	mwifiex_dbg(adapter, EVENT,
+		    "info: Updated <Rd: 0x%x, Wr: 0x%x>",
+		    card->evtbd_rdptr, wrptr);
 
 	/* Write the event ring read pointer in to reg->evt_rdptr */
 	if (mwifiex_write_reg(adapter, reg->evt_rdptr,
 			      card->evtbd_rdptr)) {
-		dev_err(adapter->dev,
-			"event_complete: failed to read reg->evt_rdptr\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "event_complete: failed to read reg->evt_rdptr\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "info: Check Events Again\n");
+	mwifiex_dbg(adapter, EVENT,
+		    "info: Check Events Again\n");
 	ret = mwifiex_pcie_process_event_ready(adapter);
 
 	return ret;
@@ -1840,17 +1869,18 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (!firmware || !firmware_len) {
-		dev_err(adapter->dev,
-			"No firmware image found! Terminating download\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "No firmware image found! Terminating download\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "info: Downloading FW image (%d bytes)\n",
-		firmware_len);
+	mwifiex_dbg(adapter, INFO,
+		    "info: Downloading FW image (%d bytes)\n",
+		    firmware_len);
 
 	if (mwifiex_pcie_disable_host_int(adapter)) {
-		dev_err(adapter->dev,
-			"%s: Disabling interrupts failed.\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: Disabling interrupts failed.\n", __func__);
 		return -1;
 	}
 
@@ -1872,8 +1902,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			ret = mwifiex_read_reg(adapter, reg->cmd_size,
 					       &len);
 			if (ret) {
-				dev_warn(adapter->dev,
-					 "Failed reading len from boot code\n");
+				mwifiex_dbg(adapter, FATAL,
+					    "Failed reading len from boot code\n");
 				goto done;
 			}
 			if (len)
@@ -1884,8 +1914,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (!len) {
 			break;
 		} else if (len > MWIFIEX_UPLD_SIZE) {
-			pr_err("FW download failure @ %d, invalid length %d\n",
-			       offset, len);
+			mwifiex_dbg(adapter, ERROR,
+				    "FW download failure @ %d, invalid length %d\n",
+				    offset, len);
 			ret = -1;
 			goto done;
 		}
@@ -1895,14 +1926,16 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (len & BIT(0)) {
 			block_retry_cnt++;
 			if (block_retry_cnt > MAX_WRITE_IOMEM_RETRY) {
-				pr_err("FW download failure @ %d, over max "
-				       "retry count\n", offset);
+				mwifiex_dbg(adapter, ERROR,
+					    "FW download failure @ %d, over max\t"
+					    "retry count\n", offset);
 				ret = -1;
 				goto done;
 			}
-			dev_err(adapter->dev, "FW CRC error indicated by the "
-				"helper: len = 0x%04X, txlen = %d\n",
-				len, txlen);
+			mwifiex_dbg(adapter, ERROR,
+				    "FW CRC error indicated by the\t"
+				    "helper: len = 0x%04X, txlen = %d\n",
+				    len, txlen);
 			len &= ~BIT(0);
 			/* Setting this to 0 to resend from same offset */
 			txlen = 0;
@@ -1913,7 +1946,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (firmware_len - offset < txlen)
 				txlen = firmware_len - offset;
 
-			dev_dbg(adapter->dev, ".");
+			mwifiex_dbg(adapter, INFO, ".");
 
 			tx_blocks = (txlen + card->pcie.blksz_fw_dl - 1) /
 				    card->pcie.blksz_fw_dl;
@@ -1927,8 +1960,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 		/* Send the boot command to device */
 		if (mwifiex_pcie_send_boot_cmd(adapter, skb)) {
-			dev_err(adapter->dev,
-				"Failed to send firmware download command\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to send firmware download command\n");
 			ret = -1;
 			goto done;
 		}
@@ -1937,9 +1970,10 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		do {
 			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
 					     &ireg_intr)) {
-				dev_err(adapter->dev, "%s: Failed to read "
-					"interrupt status during fw dnld.\n",
-					__func__);
+				mwifiex_dbg(adapter, ERROR,
+					    "%s: Failed to read\t"
+					    "interrupt status during fw dnld.\n",
+					    __func__);
 				mwifiex_unmap_pci_memory(adapter, skb,
 							 PCI_DMA_TODEVICE);
 				ret = -1;
@@ -1953,8 +1987,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	dev_notice(adapter->dev,
-		   "info: FW download over, size %d bytes\n", offset);
+	mwifiex_dbg(adapter, MSG,
+		    "info: FW download over, size %d bytes\n", offset);
 
 	ret = 0;
 
@@ -1980,15 +2014,17 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 	/* Mask spurios interrupts */
 	if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS_MASK,
 			      HOST_INTR_MASK)) {
-		dev_warn(adapter->dev, "Write register failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Write register failed\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "Setting driver ready signature\n");
+	mwifiex_dbg(adapter, INFO,
+		    "Setting driver ready signature\n");
 	if (mwifiex_write_reg(adapter, reg->drv_rdy,
 			      FIRMWARE_READY_PCIE)) {
-		dev_err(adapter->dev,
-			"Failed to write driver ready signature\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to write driver ready signature\n");
 		return -1;
 	}
 
@@ -2015,12 +2051,13 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 				     &winner_status))
 			ret = -1;
 		else if (!winner_status) {
-			dev_err(adapter->dev, "PCI-E is the winner\n");
+			mwifiex_dbg(adapter, INFO,
+				    "PCI-E is the winner\n");
 			adapter->winner = 1;
 		} else {
-			dev_err(adapter->dev,
-				"PCI-E is not the winner <%#x,%d>, exit dnld\n",
-				ret, adapter->winner);
+			mwifiex_dbg(adapter, ERROR,
+				    "PCI-E is not the winner <%#x,%d>, exit dnld\n",
+				    ret, adapter->winner);
 		}
 	}
 
@@ -2039,7 +2076,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		return;
 
 	if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS, &pcie_ireg)) {
-		dev_warn(adapter->dev, "Read register failed\n");
+		mwifiex_dbg(adapter, ERROR, "Read register failed\n");
 		return;
 	}
 
@@ -2050,7 +2087,8 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		/* Clear the pending interrupts */
 		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS,
 				      ~pcie_ireg)) {
-			dev_warn(adapter->dev, "Write register failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Write register failed\n");
 			return;
 		}
 		spin_lock_irqsave(&adapter->int_lock, flags);
@@ -2133,21 +2171,24 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	while (pcie_ireg & HOST_INTR_MASK) {
 		if (pcie_ireg & HOST_INTR_DNLD_DONE) {
 			pcie_ireg &= ~HOST_INTR_DNLD_DONE;
-			dev_dbg(adapter->dev, "info: TX DNLD Done\n");
+			mwifiex_dbg(adapter, INTR,
+				    "info: TX DNLD Done\n");
 			ret = mwifiex_pcie_send_data_complete(adapter);
 			if (ret)
 				return ret;
 		}
 		if (pcie_ireg & HOST_INTR_UPLD_RDY) {
 			pcie_ireg &= ~HOST_INTR_UPLD_RDY;
-			dev_dbg(adapter->dev, "info: Rx DATA\n");
+			mwifiex_dbg(adapter, INTR,
+				    "info: Rx DATA\n");
 			ret = mwifiex_pcie_process_recv_data(adapter);
 			if (ret)
 				return ret;
 		}
 		if (pcie_ireg & HOST_INTR_EVENT_RDY) {
 			pcie_ireg &= ~HOST_INTR_EVENT_RDY;
-			dev_dbg(adapter->dev, "info: Rx EVENT\n");
+			mwifiex_dbg(adapter, INTR,
+				    "info: Rx EVENT\n");
 			ret = mwifiex_pcie_process_event_ready(adapter);
 			if (ret)
 				return ret;
@@ -2156,8 +2197,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		if (pcie_ireg & HOST_INTR_CMD_DONE) {
 			pcie_ireg &= ~HOST_INTR_CMD_DONE;
 			if (adapter->cmd_sent) {
-				dev_dbg(adapter->dev,
-					"info: CMD sent Interrupt\n");
+				mwifiex_dbg(adapter, INTR,
+					    "info: CMD sent Interrupt\n");
 				adapter->cmd_sent = false;
 			}
 			/* Handle command response */
@@ -2169,8 +2210,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
 					     &pcie_ireg)) {
-				dev_warn(adapter->dev,
-					 "Read register failed\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "Read register failed\n");
 				return -1;
 			}
 
@@ -2178,16 +2219,17 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 				if (mwifiex_write_reg(adapter,
 						      PCIE_HOST_INT_STATUS,
 						      ~pcie_ireg)) {
-					dev_warn(adapter->dev,
-						 "Write register failed\n");
+					mwifiex_dbg(adapter, ERROR,
+						    "Write register failed\n");
 					return -1;
 				}
 			}
 
 		}
 	}
-	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
-		adapter->cmd_sent, adapter->data_sent);
+	mwifiex_dbg(adapter, INTR,
+		    "info: cmd_sent=%d data_sent=%d\n",
+		    adapter->cmd_sent, adapter->data_sent);
 	if (adapter->ps_state != PS_STATE_SLEEP)
 		mwifiex_pcie_enable_host_int(adapter);
 
@@ -2209,7 +2251,8 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 				     struct mwifiex_tx_param *tx_param)
 {
 	if (!skb) {
-		dev_err(adapter->dev, "Passed NULL skb to %s\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "Passed NULL skb to %s\n", __func__);
 		return -1;
 	}
 
@@ -2232,7 +2275,8 @@ mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
 
 	ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl, FW_DUMP_HOST_READY);
 	if (ret) {
-		dev_err(adapter->dev, "PCIE write err\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "PCIE write err\n");
 		return RDWR_STATUS_FAILURE;
 	}
 
@@ -2243,19 +2287,20 @@ mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
 		if (doneflag && ctrl_data == doneflag)
 			return RDWR_STATUS_DONE;
 		if (ctrl_data != FW_DUMP_HOST_READY) {
-			dev_info(adapter->dev,
-				 "The ctrl reg was changed, re-try again!\n");
+			mwifiex_dbg(adapter, WARN,
+				    "The ctrl reg was changed, re-try again!\n");
 			ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
 						FW_DUMP_HOST_READY);
 			if (ret) {
-				dev_err(adapter->dev, "PCIE write err\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "PCIE write err\n");
 				return RDWR_STATUS_FAILURE;
 			}
 		}
 		usleep_range(100, 200);
 	}
 
-	dev_err(adapter->dev, "Fail to pull ctrl_data\n");
+	mwifiex_dbg(adapter, ERROR, "Fail to pull ctrl_data\n");
 	return RDWR_STATUS_FAILURE;
 }
 
@@ -2284,7 +2329,7 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 		entry->mem_size = 0;
 	}
 
-	dev_info(adapter->dev, "== mwifiex firmware dump start ==\n");
+	mwifiex_dbg(adapter, DUMP, "== mwifiex firmware dump start ==\n");
 
 	/* Read the number of the memories which will dump */
 	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
@@ -2311,31 +2356,31 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 		}
 
 		if (memory_size == 0) {
-			dev_info(adapter->dev, "Firmware dump Finished!\n");
+			mwifiex_dbg(adapter, MSG, "Firmware dump Finished!\n");
 			ret = mwifiex_write_reg(adapter, creg->fw_dump_ctrl,
 						FW_DUMP_READ_DONE);
 			if (ret) {
-				dev_err(adapter->dev, "PCIE write err\n");
+				mwifiex_dbg(adapter, ERROR, "PCIE write err\n");
 				goto done;
 			}
 			break;
 		}
 
-		dev_info(adapter->dev,
-			 "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
+		mwifiex_dbg(adapter, DUMP,
+			    "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
 		entry->mem_ptr = vmalloc(memory_size + 1);
 		entry->mem_size = memory_size;
 		if (!entry->mem_ptr) {
-			dev_err(adapter->dev,
-				"Vmalloc %s failed\n", entry->mem_name);
+			mwifiex_dbg(adapter, ERROR,
+				    "Vmalloc %s failed\n", entry->mem_name);
 			goto done;
 		}
 		dbg_ptr = entry->mem_ptr;
 		end_ptr = dbg_ptr + memory_size;
 
 		doneflag = entry->done_flag;
-		dev_info(adapter->dev, "Start %s output, please wait...\n",
-			 entry->mem_name);
+		mwifiex_dbg(adapter, DUMP, "Start %s output, please wait...\n",
+			    entry->mem_name);
 
 		do {
 			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
@@ -2349,8 +2394,8 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 				if (dbg_ptr < end_ptr) {
 					dbg_ptr++;
 				} else {
-					dev_err(adapter->dev,
-						"Allocated buf not enough\n");
+					mwifiex_dbg(adapter, ERROR,
+						    "Allocated buf not enough\n");
 					goto done;
 				}
 			}
@@ -2358,12 +2403,13 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 			if (stat != RDWR_STATUS_DONE)
 				continue;
 
-			dev_info(adapter->dev, "%s done: size=0x%tx\n",
-				 entry->mem_name, dbg_ptr - entry->mem_ptr);
+			mwifiex_dbg(adapter, DUMP,
+				    "%s done: size=0x%tx\n",
+				    entry->mem_name, dbg_ptr - entry->mem_ptr);
 			break;
 		} while (true);
 	}
-	dev_info(adapter->dev, "== mwifiex firmware dump end ==\n");
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
 
 	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
 
@@ -2418,45 +2464,50 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 
 	pci_set_master(pdev);
 
-	dev_dbg(adapter->dev, "try set_consistent_dma_mask(32)\n");
+	mwifiex_dbg(adapter, INFO,
+		    "try set_consistent_dma_mask(32)\n");
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		dev_err(adapter->dev, "set_dma_mask(32) failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "set_dma_mask(32) failed\n");
 		goto err_set_dma_mask;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		dev_err(adapter->dev, "set_consistent_dma_mask(64) failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "set_consistent_dma_mask(64) failed\n");
 		goto err_set_dma_mask;
 	}
 
 	ret = pci_request_region(pdev, 0, DRV_NAME);
 	if (ret) {
-		dev_err(adapter->dev, "req_reg(0) error\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "req_reg(0) error\n");
 		goto err_req_region0;
 	}
 	card->pci_mmap = pci_iomap(pdev, 0, 0);
 	if (!card->pci_mmap) {
-		dev_err(adapter->dev, "iomap(0) error\n");
+		mwifiex_dbg(adapter, ERROR, "iomap(0) error\n");
 		ret = -EIO;
 		goto err_iomap0;
 	}
 	ret = pci_request_region(pdev, 2, DRV_NAME);
 	if (ret) {
-		dev_err(adapter->dev, "req_reg(2) error\n");
+		mwifiex_dbg(adapter, ERROR, "req_reg(2) error\n");
 		goto err_req_region2;
 	}
 	card->pci_mmap1 = pci_iomap(pdev, 2, 0);
 	if (!card->pci_mmap1) {
-		dev_err(adapter->dev, "iomap(2) error\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "iomap(2) error\n");
 		ret = -EIO;
 		goto err_iomap2;
 	}
 
-	dev_dbg(adapter->dev,
-		"PCI memory map Virt0: %p PCI memory map Virt2: %p\n",
-		card->pci_mmap, card->pci_mmap1);
+	mwifiex_dbg(adapter, INFO,
+		    "PCI memory map Virt0: %p PCI memory map Virt2: %p\n",
+		    card->pci_mmap, card->pci_mmap1);
 
 	card->cmdrsp_buf = NULL;
 	ret = mwifiex_pcie_create_txbd_ring(adapter);
@@ -2521,10 +2572,11 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	if (user_rmmod) {
-		dev_dbg(adapter->dev, "Clearing driver ready signature\n");
+		mwifiex_dbg(adapter, INFO,
+			    "Clearing driver ready signature\n");
 		if (mwifiex_write_reg(adapter, reg->drv_rdy, 0x00000000))
-			dev_err(adapter->dev,
-				"Failed to write driver not-ready signature\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "Failed to write driver not-ready signature\n");
 	}
 
 	if (pdev) {
@@ -2555,7 +2607,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	ret = request_irq(pdev->irq, mwifiex_pcie_interrupt, IRQF_SHARED,
 			  "MRVL_PCIE", pdev);
 	if (ret) {
-		pr_err("request_irq failed: ret=%d\n", ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "request_irq failed: ret=%d\n", ret);
 		adapter->card = NULL;
 		return -1;
 	}
@@ -2582,7 +2635,8 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	const struct mwifiex_pcie_card_reg *reg;
 
 	if (card) {
-		dev_dbg(adapter->dev, "%s(): calling free_irq()\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "%s(): calling free_irq()\n", __func__);
 		free_irq(card->dev->irq, card->dev);
 
 		reg = card->pcie.reg;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 84843d1..baf9715 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -241,20 +241,21 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
 	    * LinkSys WRT54G && bss_desc->privacy
 	    */
 	 ) {
-		dev_dbg(priv->adapter->dev, "info: %s: WPA:"
-			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			"EncMode=%#x privacy=%#x\n", __func__,
-			(bss_desc->bcn_wpa_ie) ?
-			(*(bss_desc->bcn_wpa_ie)).
-			vend_hdr.element_id : 0,
-			(bss_desc->bcn_rsn_ie) ?
-			(*(bss_desc->bcn_rsn_ie)).
-			ieee_hdr.element_id : 0,
-			(priv->sec_info.wep_enabled) ? "e" : "d",
-			(priv->sec_info.wpa_enabled) ? "e" : "d",
-			(priv->sec_info.wpa2_enabled) ? "e" : "d",
-			priv->sec_info.encryption_mode,
-			bss_desc->privacy);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: %s: WPA:\t"
+			    "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
+			    "EncMode=%#x privacy=%#x\n", __func__,
+			    (bss_desc->bcn_wpa_ie) ?
+			    (*bss_desc->bcn_wpa_ie).
+			    vend_hdr.element_id : 0,
+			    (bss_desc->bcn_rsn_ie) ?
+			    (*bss_desc->bcn_rsn_ie).
+			    ieee_hdr.element_id : 0,
+			    (priv->sec_info.wep_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
+			    priv->sec_info.encryption_mode,
+			    bss_desc->privacy);
 		return true;
 	}
 	return false;
@@ -277,20 +278,21 @@ mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
 		 * Privacy bit may NOT be set in some APs like
 		 * LinkSys WRT54G && bss_desc->privacy
 		 */
-		dev_dbg(priv->adapter->dev, "info: %s: WPA2: "
-			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			"EncMode=%#x privacy=%#x\n", __func__,
-			(bss_desc->bcn_wpa_ie) ?
-			(*(bss_desc->bcn_wpa_ie)).
-			vend_hdr.element_id : 0,
-			(bss_desc->bcn_rsn_ie) ?
-			(*(bss_desc->bcn_rsn_ie)).
-			ieee_hdr.element_id : 0,
-			(priv->sec_info.wep_enabled) ? "e" : "d",
-			(priv->sec_info.wpa_enabled) ? "e" : "d",
-			(priv->sec_info.wpa2_enabled) ? "e" : "d",
-			priv->sec_info.encryption_mode,
-			bss_desc->privacy);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: %s: WPA2:\t"
+			    "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
+			    "EncMode=%#x privacy=%#x\n", __func__,
+			    (bss_desc->bcn_wpa_ie) ?
+			    (*bss_desc->bcn_wpa_ie).
+			    vend_hdr.element_id : 0,
+			    (bss_desc->bcn_rsn_ie) ?
+			    (*bss_desc->bcn_rsn_ie).
+			    ieee_hdr.element_id : 0,
+			    (priv->sec_info.wep_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
+			    priv->sec_info.encryption_mode,
+			    bss_desc->privacy);
 		return true;
 	}
 	return false;
@@ -333,18 +335,19 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
 	    ((!bss_desc->bcn_rsn_ie) ||
 	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
 	    priv->sec_info.encryption_mode && bss_desc->privacy) {
-		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
-			"WEP: wpa_ie=%#x wpa2_ie=%#x "
-			"EncMode=%#x privacy=%#x\n",
-			__func__,
-			(bss_desc->bcn_wpa_ie) ?
-			(*(bss_desc->bcn_wpa_ie)).
-			vend_hdr.element_id : 0,
-			(bss_desc->bcn_rsn_ie) ?
-			(*(bss_desc->bcn_rsn_ie)).
-			ieee_hdr.element_id : 0,
-			priv->sec_info.encryption_mode,
-			bss_desc->privacy);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: %s: dynamic\t"
+			    "WEP: wpa_ie=%#x wpa2_ie=%#x\t"
+			    "EncMode=%#x privacy=%#x\n",
+			    __func__,
+			    (bss_desc->bcn_wpa_ie) ?
+			    (*bss_desc->bcn_wpa_ie).
+			    vend_hdr.element_id : 0,
+			    (bss_desc->bcn_rsn_ie) ?
+			    (*bss_desc->bcn_rsn_ie).
+			    ieee_hdr.element_id : 0,
+			    priv->sec_info.encryption_mode,
+			    bss_desc->privacy);
 		return true;
 	}
 	return false;
@@ -383,19 +386,20 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		return 0;
 
 	if (priv->wps.session_enable) {
-		dev_dbg(adapter->dev,
-			"info: return success directly in WPS period\n");
+		mwifiex_dbg(adapter, IOCTL,
+			    "info: return success directly in WPS period\n");
 		return 0;
 	}
 
 	if (bss_desc->chan_sw_ie_present) {
-		dev_err(adapter->dev,
-			"Don't connect to AP with WLAN_EID_CHANNEL_SWITCH\n");
+		mwifiex_dbg(adapter, INFO,
+			    "Don't connect to AP with WLAN_EID_CHANNEL_SWITCH\n");
 		return -1;
 	}
 
 	if (mwifiex_is_bss_wapi(priv, bss_desc)) {
-		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: return success for WAPI AP\n");
 		return 0;
 	}
 
@@ -405,7 +409,8 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 			return 0;
 		} else if (mwifiex_is_bss_static_wep(priv, bss_desc)) {
 			/* Static WEP enabled */
-			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
 			return 0;
 		} else if (mwifiex_is_bss_wpa(priv, bss_desc)) {
@@ -418,9 +423,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 
 				if (mwifiex_is_wpa_oui_present
 						(bss_desc, CIPHER_SUITE_TKIP)) {
-					dev_dbg(adapter->dev,
-						"info: Disable 11n if AES "
-						"is not supported by AP\n");
+					mwifiex_dbg(adapter, INFO,
+						    "info: Disable 11n if AES\t"
+						    "is not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
 					return -1;
@@ -437,9 +442,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 
 				if (mwifiex_is_rsn_oui_present
 						(bss_desc, CIPHER_SUITE_TKIP)) {
-					dev_dbg(adapter->dev,
-						"info: Disable 11n if AES "
-						"is not supported by AP\n");
+					mwifiex_dbg(adapter, INFO,
+						    "info: Disable 11n if AES\t"
+						    "is not supported by AP\n");
 					bss_desc->disable_11n = true;
 				} else {
 					return -1;
@@ -455,17 +460,18 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		}
 
 		/* Security doesn't match */
-		dev_dbg(adapter->dev,
-			"info: %s: failed: wpa_ie=%#x wpa2_ie=%#x WEP=%s "
-			"WPA=%s WPA2=%s EncMode=%#x privacy=%#x\n", __func__,
-			(bss_desc->bcn_wpa_ie) ?
-			(*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id : 0,
-			(bss_desc->bcn_rsn_ie) ?
-			(*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id : 0,
-			(priv->sec_info.wep_enabled) ? "e" : "d",
-			(priv->sec_info.wpa_enabled) ? "e" : "d",
-			(priv->sec_info.wpa2_enabled) ? "e" : "d",
-			priv->sec_info.encryption_mode, bss_desc->privacy);
+		mwifiex_dbg(adapter, ERROR,
+			    "info: %s: failed: wpa_ie=%#x wpa2_ie=%#x WEP=%s\t"
+			    "WPA=%s WPA2=%s EncMode=%#x privacy=%#x\n",
+			    __func__,
+			    (bss_desc->bcn_wpa_ie) ?
+			    (*bss_desc->bcn_wpa_ie).vend_hdr.element_id : 0,
+			    (bss_desc->bcn_rsn_ie) ?
+			    (*bss_desc->bcn_rsn_ie).ieee_hdr.element_id : 0,
+			    (priv->sec_info.wep_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa_enabled) ? "e" : "d",
+			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
+			    priv->sec_info.encryption_mode, bss_desc->privacy);
 		return -1;
 	}
 
@@ -560,7 +566,8 @@ mwifiex_append_rate_tlv(struct mwifiex_private *priv,
 	else
 		rates_size = mwifiex_get_supported_rates(priv, rates);
 
-	dev_dbg(priv->adapter->dev, "info: SCAN_CMD: Rates size = %d\n",
+	mwifiex_dbg(priv->adapter, CMD,
+		    "info: SCAN_CMD: Rates size = %d\n",
 		rates_size);
 	rates_tlv = (struct mwifiex_ie_types_rates_param_set *)tlv_pos;
 	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
@@ -600,9 +607,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	u8 radio_type;
 
 	if (!scan_cfg_out || !chan_tlv_out || !scan_chan_list) {
-		dev_dbg(priv->adapter->dev,
-			"info: Scan: Null detect: %p, %p, %p\n",
-		       scan_cfg_out, chan_tlv_out, scan_chan_list);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "info: Scan: Null detect: %p, %p, %p\n",
+			    scan_cfg_out, chan_tlv_out, scan_chan_list);
 		return -1;
 	}
 
@@ -645,16 +652,16 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			}
 
 			radio_type = tmp_chan_list->radio_type;
-			dev_dbg(priv->adapter->dev,
-				"info: Scan: Chan(%3d), Radio(%d),"
-				" Mode(%d, %d), Dur(%d)\n",
-				tmp_chan_list->chan_number,
-				tmp_chan_list->radio_type,
-				tmp_chan_list->chan_scan_mode_bitmap
-				& MWIFIEX_PASSIVE_SCAN,
-				(tmp_chan_list->chan_scan_mode_bitmap
-				 & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
-				le16_to_cpu(tmp_chan_list->max_scan_time));
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: Scan: Chan(%3d), Radio(%d),\t"
+				    "Mode(%d, %d), Dur(%d)\n",
+				    tmp_chan_list->chan_number,
+				    tmp_chan_list->radio_type,
+				    tmp_chan_list->chan_scan_mode_bitmap
+				    & MWIFIEX_PASSIVE_SCAN,
+				    (tmp_chan_list->chan_scan_mode_bitmap
+				    & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
+				    le16_to_cpu(tmp_chan_list->max_scan_time));
 
 			/* Copy the current channel TLV to the command being
 			   prepared */
@@ -718,9 +725,11 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		/* The total scan time should be less than scan command timeout
 		   value */
 		if (total_scan_time > MWIFIEX_MAX_TOTAL_SCAN_TIME) {
-			dev_err(priv->adapter->dev, "total scan time %dms"
-				" is over limit (%dms), scan skipped\n",
-				total_scan_time, MWIFIEX_MAX_TOTAL_SCAN_TIME);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "total scan time %dms\t"
+				    "is over limit (%dms), scan skipped\n",
+				    total_scan_time,
+				    MWIFIEX_MAX_TOTAL_SCAN_TIME);
 			ret = -1;
 			break;
 		}
@@ -905,9 +914,10 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
 
-			dev_dbg(adapter->dev, "info: scan: ssid[%d]: %s, %d\n",
-				i, wildcard_ssid_tlv->ssid,
-				wildcard_ssid_tlv->max_ssid_length);
+			mwifiex_dbg(adapter, INFO,
+				    "info: scan: ssid[%d]: %s, %d\n",
+				    i, wildcard_ssid_tlv->ssid,
+				    wildcard_ssid_tlv->max_ssid_length);
 
 			/* Empty wildcard ssid with a maxlen will match many or
 			   potentially all SSIDs (maxlen == 32), therefore do
@@ -928,8 +938,9 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			*filtered_scan = true;
 
 		if (user_scan_in->scan_chan_gap) {
-			dev_dbg(adapter->dev, "info: scan: channel gap = %d\n",
-				user_scan_in->scan_chan_gap);
+			mwifiex_dbg(adapter, INFO,
+				    "info: scan: channel gap = %d\n",
+				    user_scan_in->scan_chan_gap);
 			*max_chan_per_scan =
 					MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
 
@@ -961,8 +972,9 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	   add tlv */
 	if (num_probes) {
 
-		dev_dbg(adapter->dev, "info: scan: num_probes = %d\n",
-			num_probes);
+		mwifiex_dbg(adapter, INFO,
+			    "info: scan: num_probes = %d\n",
+			    num_probes);
 
 		num_probes_tlv = (struct mwifiex_ie_types_num_probes *) tlv_pos;
 		num_probes_tlv->header.type = cpu_to_le16(TLV_TYPE_NUMPROBES);
@@ -1003,7 +1015,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 
 	if (user_scan_in && user_scan_in->chan_list[0].chan_number) {
 
-		dev_dbg(adapter->dev, "info: Scan: Using supplied channel list\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: Scan: Using supplied channel list\n");
 
 		for (chan_idx = 0;
 		     chan_idx < MWIFIEX_USER_SCAN_CHAN_MAX &&
@@ -1056,13 +1069,13 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		    (user_scan_in->chan_list[0].chan_number ==
 		     priv->curr_bss_params.bss_descriptor.channel)) {
 			*scan_current_only = true;
-			dev_dbg(adapter->dev,
-				"info: Scan: Scanning current channel only\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: Scan: Scanning current channel only\n");
 		}
 		chan_num = chan_idx;
 	} else {
-		dev_dbg(adapter->dev,
-			"info: Scan: Creating full region channel list\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: Scan: Creating full region channel list\n");
 		chan_num = mwifiex_scan_create_channel_list(priv, user_scan_in,
 							    scan_chan_list,
 							    *filtered_scan);
@@ -1094,8 +1107,9 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 	tlv_buf_left = tlv_buf_size;
 	*tlv_data = NULL;
 
-	dev_dbg(adapter->dev, "info: SCAN_RESP: tlv_buf_size = %d\n",
-		tlv_buf_size);
+	mwifiex_dbg(adapter, INFO,
+		    "info: SCAN_RESP: tlv_buf_size = %d\n",
+		    tlv_buf_size);
 
 	while (tlv_buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 
@@ -1103,26 +1117,31 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 		tlv_len = le16_to_cpu(current_tlv->header.len);
 
 		if (sizeof(tlv->header) + tlv_len > tlv_buf_left) {
-			dev_err(adapter->dev, "SCAN_RESP: TLV buffer corrupt\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "SCAN_RESP: TLV buffer corrupt\n");
 			break;
 		}
 
 		if (req_tlv_type == tlv_type) {
 			switch (tlv_type) {
 			case TLV_TYPE_TSFTIMESTAMP:
-				dev_dbg(adapter->dev, "info: SCAN_RESP: TSF "
-					"timestamp TLV, len = %d\n", tlv_len);
+				mwifiex_dbg(adapter, INFO,
+					    "info: SCAN_RESP: TSF\t"
+					    "timestamp TLV, len = %d\n",
+					    tlv_len);
 				*tlv_data = current_tlv;
 				break;
 			case TLV_TYPE_CHANNELBANDLIST:
-				dev_dbg(adapter->dev, "info: SCAN_RESP: channel"
-					" band list TLV, len = %d\n", tlv_len);
+				mwifiex_dbg(adapter, INFO,
+					    "info: SCAN_RESP: channel\t"
+					    "band list TLV, len = %d\n",
+					    tlv_len);
 				*tlv_data = current_tlv;
 				break;
 			default:
-				dev_err(adapter->dev,
-					"SCAN_RESP: unhandled TLV = %d\n",
-				       tlv_type);
+				mwifiex_dbg(adapter, ERROR,
+					    "SCAN_RESP: unhandled TLV = %d\n",
+					    tlv_type);
 				/* Give up, this seems corrupted */
 				return;
 			}
@@ -1177,8 +1196,9 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		total_ie_len = element_len + sizeof(struct ieee_types_header);
 
 		if (bytes_left < total_ie_len) {
-			dev_err(adapter->dev, "err: InterpretIE: in processing"
-				" IE, bytes left < IE length\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "err: InterpretIE: in processing\t"
+				    "IE, bytes left < IE length\n");
 			return -1;
 		}
 		switch (element_id) {
@@ -1186,9 +1206,9 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
-			dev_dbg(adapter->dev,
-				"info: InterpretIE: ssid: %-32s\n",
-				bss_entry->ssid.ssid);
+			mwifiex_dbg(adapter, INFO,
+				    "info: InterpretIE: ssid: %-32s\n",
+				    bss_entry->ssid.ssid);
 			break;
 
 		case WLAN_EID_SUPP_RATES:
@@ -1419,19 +1439,20 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	unsigned long flags;
 
 	if (adapter->scan_processing) {
-		dev_err(adapter->dev, "cmd: Scan already in process...\n");
+		mwifiex_dbg(adapter, WARN,
+			    "cmd: Scan already in process...\n");
 		return -EBUSY;
 	}
 
 	if (priv->scan_block) {
-		dev_err(adapter->dev,
-			"cmd: Scan is blocked during association...\n");
+		mwifiex_dbg(adapter, WARN,
+			    "cmd: Scan is blocked during association...\n");
 		return -EBUSY;
 	}
 
 	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
-		dev_err(adapter->dev,
-			"Ignore scan. Card removed or firmware in bad state\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Ignore scan. Card removed or firmware in bad state\n");
 		return -EFAULT;
 	}
 
@@ -1478,7 +1499,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 
 			/* Perform internal scan synchronously */
 			if (!priv->scan_request) {
-				dev_dbg(adapter->dev, "wait internal scan\n");
+				mwifiex_dbg(adapter, INFO,
+					    "wait internal scan\n");
 				mwifiex_wait_queue_complete(adapter, cmd_node);
 			}
 		} else {
@@ -1553,8 +1575,8 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 			ret = mwifiex_is_network_compatible(priv, bss_desc,
 							    priv->bss_mode);
 			if (ret)
-				dev_err(priv->adapter->dev,
-					"Incompatible network settings\n");
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "Incompatible network settings\n");
 			break;
 		default:
 			ret = 0;
@@ -1656,7 +1678,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 	 */
 	if (curr_bcn_bytes < ETH_ALEN + sizeof(u8) +
 	    sizeof(struct mwifiex_fixed_bcn_param)) {
-		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "InterpretIE: not enough bytes left\n");
 		return -EFAULT;
 	}
 
@@ -1669,7 +1692,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
 		current_ptr += sizeof(u8);
 		curr_bcn_bytes -= sizeof(u8);
-		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
+		mwifiex_dbg(adapter, INFO,
+			    "info: InterpretIE: RSSI=%d\n", rssi);
 	} else {
 		rssi = rssi_val;
 	}
@@ -1682,14 +1706,16 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 	beacon_period = le16_to_cpu(bcn_param->beacon_period);
 
 	cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
-	dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
-		cap_info_bitmap);
+	mwifiex_dbg(adapter, INFO,
+		    "info: InterpretIE: capabilities=0x%X\n",
+		    cap_info_bitmap);
 
 	/* Rest of the current buffer are IE's */
 	ie_buf = current_ptr;
 	ie_len = curr_bcn_bytes;
-	dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP = %d\n",
-		curr_bcn_bytes);
+	mwifiex_dbg(adapter, INFO,
+		    "info: InterpretIE: IELength for this AP = %d\n",
+		    curr_bcn_bytes);
 
 	while (curr_bcn_bytes >= sizeof(struct ieee_types_header)) {
 		u8 element_id, element_len;
@@ -1698,8 +1724,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 		element_len = *(current_ptr + 1);
 		if (curr_bcn_bytes < element_len +
 				sizeof(struct ieee_types_header)) {
-			dev_err(adapter->dev,
-				"%s: bytes left < IE length\n", __func__);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: bytes left < IE length\n", __func__);
 			return -EFAULT;
 		}
 		if (element_id == WLAN_EID_DS_PARAMS) {
@@ -1719,8 +1745,8 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 
 		/* Skip entry if on csa closed channel */
 		if (channel == priv->csa_chan) {
-			dev_dbg(adapter->dev,
-				"Dropping entry on csa closed channel\n");
+			mwifiex_dbg(adapter, WARN,
+				    "Dropping entry on csa closed channel\n");
 			return 0;
 		}
 
@@ -1751,7 +1777,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 			cfg80211_put_bss(priv->wdev.wiphy, bss);
 		}
 	} else {
-		dev_dbg(adapter->dev, "missing BSS channel IE\n");
+		mwifiex_dbg(adapter, WARN, "missing BSS channel IE\n");
 	}
 
 	return 0;
@@ -1765,7 +1791,8 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 	if (adapter->curr_cmd->wait_q_enabled) {
 		adapter->cmd_wait_q.status = 0;
 		if (!priv->scan_request) {
-			dev_dbg(adapter->dev, "complete internal scan\n");
+			mwifiex_dbg(adapter, INFO,
+				    "complete internal scan\n");
 			mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 		}
 	}
@@ -1788,12 +1815,14 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 			mwifiex_complete_scan(priv);
 
 		if (priv->scan_request) {
-			dev_dbg(adapter->dev, "info: notifying scan done\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: notifying scan done\n");
 			cfg80211_scan_done(priv->scan_request, 0);
 			priv->scan_request = NULL;
 		} else {
 			priv->scan_aborting = false;
-			dev_dbg(adapter->dev, "info: scan already aborted\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: scan already aborted\n");
 		}
 	} else if ((priv->scan_aborting && !priv->scan_request) ||
 		   priv->scan_block) {
@@ -1809,12 +1838,14 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		if (priv->scan_request) {
-			dev_dbg(adapter->dev, "info: aborting scan\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: aborting scan\n");
 			cfg80211_scan_done(priv->scan_request, 1);
 			priv->scan_request = NULL;
 		} else {
 			priv->scan_aborting = false;
-			dev_dbg(adapter->dev, "info: scan already aborted\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: scan already aborted\n");
 		}
 	} else {
 		/* Get scan command from scan_pending_q and put to
@@ -1877,8 +1908,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 
 	if (scan_rsp->number_of_sets > MWIFIEX_MAX_AP) {
-		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
-			scan_rsp->number_of_sets);
+		mwifiex_dbg(adapter, ERROR,
+			    "SCAN_RESP: too many AP returned (%d)\n",
+			    scan_rsp->number_of_sets);
 		ret = -1;
 		goto check_next_scan;
 	}
@@ -1887,14 +1919,15 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	mwifiex_11h_get_csa_closed_channel(priv);
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
-	dev_dbg(adapter->dev, "info: SCAN_RESP: bss_descript_size %d\n",
-		bytes_left);
+	mwifiex_dbg(adapter, INFO,
+		    "info: SCAN_RESP: bss_descript_size %d\n",
+		    bytes_left);
 
 	scan_resp_size = le16_to_cpu(resp->size);
 
-	dev_dbg(adapter->dev,
-		"info: SCAN_RESP: returned %d APs before parsing\n",
-		scan_rsp->number_of_sets);
+	mwifiex_dbg(adapter, INFO,
+		    "info: SCAN_RESP: returned %d APs before parsing\n",
+		    scan_rsp->number_of_sets);
 
 	bss_info = scan_rsp->bss_desc_and_tlv_buffer;
 
@@ -2007,13 +2040,13 @@ mwifiex_update_chan_statistics(struct mwifiex_private *priv,
 				       le16_to_cpu(fw_chan_stats->cca_scan_dur);
 		chan_stats.cca_busy_dur =
 				       le16_to_cpu(fw_chan_stats->cca_busy_dur);
-		dev_dbg(adapter->dev,
-			"chan=%d, noise=%d, total_network=%d scan_duration=%d, busy_duration=%d\n",
-			chan_stats.chan_num,
-			chan_stats.noise,
-			chan_stats.total_bss,
-			chan_stats.cca_scan_dur,
-			chan_stats.cca_busy_dur);
+		mwifiex_dbg(adapter, INFO,
+			    "chan=%d, noise=%d, total_network=%d scan_duration=%d, busy_duration=%d\n",
+			    chan_stats.chan_num,
+			    chan_stats.noise,
+			    chan_stats.total_bss,
+			    chan_stats.cca_scan_dur,
+			    chan_stats.cca_busy_dur);
 		memcpy(&adapter->chan_stats[adapter->survey_idx++], &chan_stats,
 		       sizeof(struct mwifiex_chan_stats));
 		fw_chan_stats++;
@@ -2035,7 +2068,7 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 	unsigned long cmd_flags, scan_flags;
 	bool complete_scan = false;
 
-	dev_dbg(priv->adapter->dev, "info: EXT scan returns successfully\n");
+	mwifiex_dbg(adapter, INFO, "info: EXT scan returns successfully\n");
 
 	ext_scan_resp = &resp->params.ext_scan;
 
@@ -2048,8 +2081,8 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 		len = le16_to_cpu(tlv->len);
 
 		if (buf_left < (sizeof(struct mwifiex_ie_types_header) + len)) {
-			dev_err(adapter->dev,
-				"error processing scan response TLVs");
+			mwifiex_dbg(adapter, ERROR,
+				    "error processing scan response TLVs");
 			break;
 		}
 
@@ -2075,8 +2108,8 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 			cmd_ptr = (void *)cmd_node->cmd_skb->data;
 			if (le16_to_cpu(cmd_ptr->command) ==
 			    HostCmd_CMD_802_11_SCAN_EXT) {
-				dev_dbg(priv->adapter->dev,
-					"Scan pending in command pending list");
+				mwifiex_dbg(adapter, INFO,
+					    "Scan pending in command pending list");
 				complete_scan = false;
 				break;
 			}
@@ -2114,17 +2147,17 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 	u16 scan_resp_size = le16_to_cpu(event_scan->buf_size);
 
 	if (num_of_set > MWIFIEX_MAX_AP) {
-		dev_err(adapter->dev,
-			"EXT_SCAN: Invalid number of AP returned (%d)!!\n",
-			num_of_set);
+		mwifiex_dbg(adapter, ERROR,
+			    "EXT_SCAN: Invalid number of AP returned (%d)!!\n",
+			    num_of_set);
 		ret = -1;
 		goto check_next_scan;
 	}
 
 	bytes_left = scan_resp_size;
-	dev_dbg(adapter->dev,
-		"EXT_SCAN: size %d, returned %d APs...",
-		scan_resp_size, num_of_set);
+	mwifiex_dbg(adapter, INFO,
+		    "EXT_SCAN: size %d, returned %d APs...",
+		    scan_resp_size, num_of_set);
 	mwifiex_dbg_dump(adapter, CMD_D, "EXT_SCAN buffer:", buf,
 			 scan_resp_size +
 			 sizeof(struct mwifiex_event_scan_result));
@@ -2135,7 +2168,8 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 		type = le16_to_cpu(tlv->header.type);
 		len = le16_to_cpu(tlv->header.len);
 		if (bytes_left < sizeof(struct mwifiex_ie_types_header) + len) {
-			dev_err(adapter->dev, "EXT_SCAN: Error bytes left < TLV length\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "EXT_SCAN: Error bytes left < TLV length\n");
 			break;
 		}
 		scan_rsp_tlv = NULL;
@@ -2161,8 +2195,9 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 			len = le16_to_cpu(tlv->header.len);
 			if (bytes_left_for_tlv <
 			    sizeof(struct mwifiex_ie_types_header) + len) {
-				dev_err(adapter->dev,
-					"EXT_SCAN: Error in processing TLV, bytes left < TLV length\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "EXT_SCAN: Error in processing TLV,\t"
+					    "bytes left < TLV length\n");
 				scan_rsp_tlv = NULL;
 				bytes_left_for_tlv = 0;
 				continue;
@@ -2202,8 +2237,8 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 		if (scan_info_tlv) {
 			rssi = (s32)(s16)(le16_to_cpu(scan_info_tlv->rssi));
 			rssi *= 100;           /* Convert dBm to mBm */
-			dev_dbg(adapter->dev,
-				"info: InterpretIE: RSSI=%d\n", rssi);
+			mwifiex_dbg(adapter, INFO,
+				    "info: InterpretIE: RSSI=%d\n", rssi);
 			fw_tsf = le64_to_cpu(scan_info_tlv->tsf);
 			radio_type = &scan_info_tlv->radio_type;
 		} else {
@@ -2274,13 +2309,14 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
 	if (adapter->scan_processing) {
-		dev_err(adapter->dev, "cmd: Scan already in process...\n");
+		mwifiex_dbg(adapter, WARN,
+			    "cmd: Scan already in process...\n");
 		return -EBUSY;
 	}
 
 	if (priv->scan_block) {
-		dev_err(adapter->dev,
-			"cmd: Scan is blocked during association...\n");
+		mwifiex_dbg(adapter, WARN,
+			    "cmd: Scan is blocked during association...\n");
 		return -EBUSY;
 	}
 
@@ -2312,8 +2348,9 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 	int ret;
 
 	if (down_interruptible(&priv->async_sem)) {
-		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
-			__func__);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: acquire semaphore fail\n",
+			    __func__);
 		return -1;
 	}
 
@@ -2403,8 +2440,9 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 
 	memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
 	       curr_bss->beacon_buf_size);
-	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
-		priv->curr_bcn_size);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: current beacon saved %d\n",
+		    priv->curr_bcn_size);
 
 	curr_bss->beacon_buf = priv->curr_bcn_buf;
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index d10320f..f4b1de7 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -166,7 +166,8 @@ static int mwifiex_sdio_resume(struct device *dev)
 	adapter = card->adapter;
 
 	if (!adapter->is_suspended) {
-		dev_warn(adapter->dev, "device already resumed\n");
+		mwifiex_dbg(adapter, WARN,
+			    "device already resumed\n");
 		return 0;
 	}
 
@@ -191,8 +192,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	struct mwifiex_adapter *adapter;
 	struct mwifiex_private *priv;
 
-	pr_debug("info: SDIO func num=%d\n", func->num);
-
 	card = sdio_get_drvdata(func);
 	if (!card)
 		return;
@@ -201,6 +200,8 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
+
 	if (user_rmmod) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
@@ -257,12 +258,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 
 	/* Enable the Host Sleep */
 	if (!mwifiex_enable_hs(adapter)) {
-		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cmd: failed to suspend\n");
 		adapter->hs_enabling = false;
 		return -EFAULT;
 	}
 
-	dev_dbg(adapter->dev, "cmd: suspend with MMC_PM_KEEP_POWER\n");
+	mwifiex_dbg(adapter, INFO,
+		    "cmd: suspend with MMC_PM_KEEP_POWER\n");
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 
 	/* Indicate device suspended */
@@ -386,8 +389,8 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
 	if (adapter->is_suspended) {
-		dev_err(adapter->dev,
-			"%s: not allowed while suspended\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: not allowed while suspended\n", __func__);
 		return -1;
 	}
 
@@ -434,7 +437,8 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
  */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
-	dev_dbg(adapter->dev, "event: wakeup device...\n");
+	mwifiex_dbg(adapter, EVENT,
+		    "event: wakeup device...\n");
 
 	return mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
 }
@@ -446,7 +450,8 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
-	dev_dbg(adapter->dev, "cmd: wakeup device completed\n");
+	mwifiex_dbg(adapter, EVENT,
+		    "cmd: wakeup device completed\n");
 
 	return mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
 }
@@ -524,7 +529,8 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	else
 		return -1;
 cont:
-	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
+	mwifiex_dbg(adapter, INFO,
+		    "info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
 	if (!mwifiex_read_reg(adapter, card->reg->host_int_rsr_reg, &reg))
@@ -556,10 +562,12 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 		ret = mwifiex_write_data_sync(adapter, payload, pkt_len, port);
 		if (ret) {
 			i++;
-			dev_err(adapter->dev, "host_to_card, write iomem"
-					" (%d) failed: %d\n", i, ret);
+			mwifiex_dbg(adapter, ERROR,
+				    "host_to_card, write iomem\t"
+				    "(%d) failed: %d\n", i, ret);
 			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
-				dev_err(adapter->dev, "write CFG reg failed\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "write CFG reg failed\n");
 
 			ret = -1;
 			if (i > MAX_WRITE_IOMEM_RETRY)
@@ -584,7 +592,8 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	u32 rd_bitmap = card->mp_rd_bitmap;
 
-	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%08x\n", rd_bitmap);
+	mwifiex_dbg(adapter, DATA,
+		    "data: mp_rd_bitmap=0x%08x\n", rd_bitmap);
 
 	if (card->supports_sdio_new_mode) {
 		if (!(rd_bitmap & reg->data_port_mask))
@@ -598,8 +607,9 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	    (card->mp_rd_bitmap & CTRL_PORT_MASK)) {
 		card->mp_rd_bitmap &= (u32) (~CTRL_PORT_MASK);
 		*port = CTRL_PORT;
-		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%08x\n",
-			*port, card->mp_rd_bitmap);
+		mwifiex_dbg(adapter, DATA,
+			    "data: port=%d mp_rd_bitmap=0x%08x\n",
+			    *port, card->mp_rd_bitmap);
 		return 0;
 	}
 
@@ -613,9 +623,9 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	if (++card->curr_rd_port == card->max_ports)
 		card->curr_rd_port = reg->start_rd_port;
 
-	dev_dbg(adapter->dev,
-		"data: port=%d mp_rd_bitmap=0x%08x -> 0x%08x\n",
-		*port, rd_bitmap, card->mp_rd_bitmap);
+	mwifiex_dbg(adapter, DATA,
+		    "data: port=%d mp_rd_bitmap=0x%08x -> 0x%08x\n",
+		    *port, rd_bitmap, card->mp_rd_bitmap);
 
 	return 0;
 }
@@ -633,7 +643,8 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	u32 wr_bitmap = card->mp_wr_bitmap;
 
-	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%08x\n", wr_bitmap);
+	mwifiex_dbg(adapter, DATA,
+		    "data: mp_wr_bitmap=0x%08x\n", wr_bitmap);
 
 	if (!(wr_bitmap & card->mp_data_port_mask)) {
 		adapter->data_sent = true;
@@ -651,15 +662,16 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 	}
 
 	if ((card->has_control_mask) && (*port == CTRL_PORT)) {
-		dev_err(adapter->dev,
-			"invalid data port=%d cur port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
-			*port, card->curr_wr_port, wr_bitmap,
-			card->mp_wr_bitmap);
+		mwifiex_dbg(adapter, ERROR,
+			    "invalid data port=%d cur port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
+			    *port, card->curr_wr_port, wr_bitmap,
+			    card->mp_wr_bitmap);
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
-		*port, wr_bitmap, card->mp_wr_bitmap);
+	mwifiex_dbg(adapter, DATA,
+		    "data: port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
+		    *port, wr_bitmap, card->mp_wr_bitmap);
 
 	return 0;
 }
@@ -683,7 +695,8 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 		usleep_range(10, 20);
 	}
 
-	dev_err(adapter->dev, "poll card status failed, tries = %d\n", tries);
+	mwifiex_dbg(adapter, ERROR,
+		    "poll card status failed, tries = %d\n", tries);
 
 	return -1;
 }
@@ -738,7 +751,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	if (mwifiex_read_data_sync(adapter, card->mp_regs,
 				   card->reg->max_mp_regs,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0)) {
-		dev_err(adapter->dev, "read mp_regs failed\n");
+		mwifiex_dbg(adapter, ERROR, "read mp_regs failed\n");
 		return;
 	}
 
@@ -751,7 +764,8 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		 *	UP_LD_CMD_PORT_HOST_INT_STATUS
 		 * Clear the interrupt status register
 		 */
-		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
+		mwifiex_dbg(adapter, INTR,
+			    "int: sdio_ireg = %#x\n", sdio_ireg);
 		spin_lock_irqsave(&adapter->int_lock, flags);
 		adapter->int_status |= sdio_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
@@ -802,7 +816,8 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 	/* Request the SDIO IRQ */
 	ret = sdio_claim_irq(func, mwifiex_sdio_interrupt);
 	if (ret) {
-		dev_err(adapter->dev, "claim irq failed: ret=%d\n", ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "claim irq failed: ret=%d\n", ret);
 		goto out;
 	}
 
@@ -810,7 +825,8 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 	ret = mwifiex_write_reg_locked(func, card->reg->host_int_mask_reg,
 				       card->reg->host_int_enable);
 	if (ret) {
-		dev_err(adapter->dev, "enable host interrupt failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "enable host interrupt failed\n");
 		sdio_release_irq(func);
 	}
 
@@ -830,22 +846,25 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 	u32 nb;
 
 	if (!buffer) {
-		dev_err(adapter->dev, "%s: buffer is NULL\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: buffer is NULL\n", __func__);
 		return -1;
 	}
 
 	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 1);
 
 	if (ret) {
-		dev_err(adapter->dev, "%s: read iomem failed: %d\n", __func__,
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: read iomem failed: %d\n", __func__,
 			ret);
 		return -1;
 	}
 
 	nb = le16_to_cpu(*(__le16 *) (buffer));
 	if (nb > npayload) {
-		dev_err(adapter->dev, "%s: invalid packet, nb=%d npayload=%d\n",
-			__func__, nb, npayload);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: invalid packet, nb=%d npayload=%d\n",
+			    __func__, nb, npayload);
 		return -1;
 	}
 
@@ -877,13 +896,14 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 i = 0;
 
 	if (!firmware_len) {
-		dev_err(adapter->dev,
-			"firmware image not found! Terminating download\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "firmware image not found! Terminating download\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "info: downloading FW image (%d bytes)\n",
-		firmware_len);
+	mwifiex_dbg(adapter, INFO,
+		    "info: downloading FW image (%d bytes)\n",
+		    firmware_len);
 
 	/* Assume that the allocated buffer is 8-byte aligned */
 	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_KERNEL);
@@ -897,8 +917,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		ret = mwifiex_sdio_poll_card_status(adapter, CARD_IO_READY |
 						    DN_LD_CARD_RDY);
 		if (ret) {
-			dev_err(adapter->dev, "FW download with helper:"
-				" poll status timeout @ %d\n", offset);
+			mwifiex_dbg(adapter, ERROR,
+				    "FW download with helper:\t"
+				    "poll status timeout @ %d\n", offset);
 			goto done;
 		}
 
@@ -910,19 +931,19 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			ret = mwifiex_read_reg(adapter, reg->base_0_reg,
 					       &base0);
 			if (ret) {
-				dev_err(adapter->dev,
-					"dev BASE0 register read failed: "
-					"base0=%#04X(%d). Terminating dnld\n",
-					base0, base0);
+				mwifiex_dbg(adapter, ERROR,
+					    "dev BASE0 register read failed:\t"
+					    "base0=%#04X(%d). Terminating dnld\n",
+					    base0, base0);
 				goto done;
 			}
 			ret = mwifiex_read_reg(adapter, reg->base_1_reg,
 					       &base1);
 			if (ret) {
-				dev_err(adapter->dev,
-					"dev BASE1 register read failed: "
-					"base1=%#04X(%d). Terminating dnld\n",
-					base1, base1);
+				mwifiex_dbg(adapter, ERROR,
+					    "dev BASE1 register read failed:\t"
+					    "base1=%#04X(%d). Terminating dnld\n",
+					    base1, base1);
 				goto done;
 			}
 			len = (u16) (((base1 & 0xff) << 8) | (base0 & 0xff));
@@ -936,9 +957,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (!len) {
 			break;
 		} else if (len > MWIFIEX_UPLD_SIZE) {
-			dev_err(adapter->dev,
-				"FW dnld failed @ %d, invalid length %d\n",
-				offset, len);
+			mwifiex_dbg(adapter, ERROR,
+				    "FW dnld failed @ %d, invalid length %d\n",
+				    offset, len);
 			ret = -1;
 			goto done;
 		}
@@ -948,14 +969,15 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		if (len & BIT(0)) {
 			i++;
 			if (i > MAX_WRITE_IOMEM_RETRY) {
-				dev_err(adapter->dev,
-					"FW dnld failed @ %d, over max retry\n",
-					offset);
+				mwifiex_dbg(adapter, ERROR,
+					    "FW dnld failed @ %d, over max retry\n",
+					    offset);
 				ret = -1;
 				goto done;
 			}
-			dev_err(adapter->dev, "CRC indicated by the helper:"
-				" len = 0x%04X, txlen = %d\n", len, txlen);
+			mwifiex_dbg(adapter, ERROR,
+				    "CRC indicated by the helper:\t"
+				    "len = 0x%04X, txlen = %d\n", len, txlen);
 			len &= ~BIT(0);
 			/* Setting this to 0 to resend from same offset */
 			txlen = 0;
@@ -978,11 +1000,12 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 					      MWIFIEX_SDIO_BLOCK_SIZE,
 					      adapter->ioport);
 		if (ret) {
-			dev_err(adapter->dev,
-				"FW download, write iomem (%d) failed @ %d\n",
-				i, offset);
+			mwifiex_dbg(adapter, ERROR,
+				    "FW download, write iomem (%d) failed @ %d\n",
+				    i, offset);
 			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
-				dev_err(adapter->dev, "write CFG reg failed\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "write CFG reg failed\n");
 
 			ret = -1;
 			goto done;
@@ -991,8 +1014,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		offset += txlen;
 	} while (true);
 
-	dev_notice(adapter->dev,
-		   "info: FW download over, size %d bytes\n", offset);
+	mwifiex_dbg(adapter, MSG,
+		    "info: FW download over, size %d bytes\n", offset);
 
 	ret = 0;
 done:
@@ -1066,18 +1089,20 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 		blk_num = *(data + BLOCK_NUMBER_OFFSET);
 		blk_size = adapter->sdio_rx_block_size * blk_num;
 		if (blk_size > total_pkt_len) {
-			dev_err(adapter->dev, "%s: error in pkt,\t"
-				"blk_num=%d, blk_size=%d, total_pkt_len=%d\n",
-				__func__, blk_num, blk_size, total_pkt_len);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: error in blk_size,\t"
+				    "blk_num=%d, blk_size=%d, total_pkt_len=%d\n",
+				    __func__, blk_num, blk_size, total_pkt_len);
 			break;
 		}
 		pkt_len = le16_to_cpu(*(__le16 *)(data + SDIO_HEADER_OFFSET));
 		pkt_type = le16_to_cpu(*(__le16 *)(data + SDIO_HEADER_OFFSET +
 					 2));
 		if ((pkt_len + SDIO_HEADER_OFFSET) > blk_size) {
-			dev_err(adapter->dev, "%s: error in pkt,\t"
-				"pkt_len=%d, blk_size=%d\n",
-				__func__, pkt_len, blk_size);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: error in pkt_len,\t"
+				    "pkt_len=%d, blk_size=%d\n",
+				    __func__, pkt_len, blk_size);
 			break;
 		}
 		skb_deaggr = mwifiex_alloc_dma_align_buf(pkt_len,
@@ -1116,7 +1141,8 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 
 	switch (upld_typ) {
 	case MWIFIEX_TYPE_AGGR_DATA:
-		dev_dbg(adapter->dev, "info: --- Rx: Aggr Data packet ---\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: --- Rx: Aggr Data packet ---\n");
 		rx_info = MWIFIEX_SKB_RXCB(skb);
 		rx_info->buf_type = MWIFIEX_TYPE_AGGR_DATA;
 		if (adapter->rx_work_enabled) {
@@ -1130,7 +1156,8 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	case MWIFIEX_TYPE_DATA:
-		dev_dbg(adapter->dev, "info: --- Rx: Data packet ---\n");
+		mwifiex_dbg(adapter, DATA,
+			    "info: --- Rx: Data packet ---\n");
 		if (adapter->rx_work_enabled) {
 			skb_queue_tail(&adapter->rx_data_q, skb);
 			adapter->data_received = true;
@@ -1141,7 +1168,8 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	case MWIFIEX_TYPE_CMD:
-		dev_dbg(adapter->dev, "info: --- Rx: Cmd Response ---\n");
+		mwifiex_dbg(adapter, CMD,
+			    "info: --- Rx: Cmd Response ---\n");
 		/* take care of curr_cmd = NULL case */
 		if (!adapter->curr_cmd) {
 			cmd_buf = adapter->upld_buf;
@@ -1163,7 +1191,8 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	case MWIFIEX_TYPE_EVENT:
-		dev_dbg(adapter->dev, "info: --- Rx: Event ---\n");
+		mwifiex_dbg(adapter, EVENT,
+			    "info: --- Rx: Event ---\n");
 		adapter->event_cause = le32_to_cpu(*(__le32 *) skb->data);
 
 		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
@@ -1178,7 +1207,8 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 
 	default:
-		dev_err(adapter->dev, "unknown upload type %#x\n", upld_typ);
+		mwifiex_dbg(adapter, ERROR,
+			    "unknown upload type %#x\n", upld_typ);
 		dev_kfree_skb_any(skb);
 		break;
 	}
@@ -1210,16 +1240,18 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if ((card->has_control_mask) && (port == CTRL_PORT)) {
 		/* Read the command Resp without aggr */
-		dev_dbg(adapter->dev, "info: %s: no aggregation for cmd "
-			"response\n", __func__);
+		mwifiex_dbg(adapter, CMD,
+			    "info: %s: no aggregation for cmd\t"
+			    "response\n", __func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
 	}
 
 	if (!card->mpa_rx.enabled) {
-		dev_dbg(adapter->dev, "info: %s: rx aggregation disabled\n",
-			__func__);
+		mwifiex_dbg(adapter, WARN,
+			    "info: %s: rx aggregation disabled\n",
+			    __func__);
 
 		f_do_rx_cur = 1;
 		goto rx_curr_single;
@@ -1230,7 +1262,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	    (card->has_control_mask && (card->mp_rd_bitmap &
 					(~((u32) CTRL_PORT_MASK))))) {
 		/* Some more data RX pending */
-		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "info: %s: not last packet\n", __func__);
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			if (MP_RX_AGGR_BUF_HAS_ROOM(card, rx_len)) {
@@ -1247,7 +1280,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	} else {
 		/* No more data RX pending */
-		dev_dbg(adapter->dev, "info: %s: last packet\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "info: %s: last packet\n", __func__);
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			f_do_rx_aggr = 1;
@@ -1262,14 +1296,16 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	}
 
 	if (f_aggr_cur) {
-		dev_dbg(adapter->dev, "info: current packet aggregation\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
 		mp_rx_aggr_setup(card, rx_len, port);
 
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    mp_rx_aggr_port_limit_reached(card)) {
-			dev_dbg(adapter->dev, "info: %s: aggregated packet "
-				"limit reached\n", __func__);
+			mwifiex_dbg(adapter, INFO,
+				    "info: %s: aggregated packet\t"
+				    "limit reached\n", __func__);
 			/* No more pkts allowed in Aggr buf, rx it */
 			f_do_rx_aggr = 1;
 		}
@@ -1277,8 +1313,9 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (f_do_rx_aggr) {
 		/* do aggr RX now */
-		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
-			card->mpa_rx.pkt_cnt);
+		mwifiex_dbg(adapter, DATA,
+			    "info: do_rx_aggr: num of packets: %d\n",
+			    card->mpa_rx.pkt_cnt);
 
 		if (card->supports_sdio_new_mode) {
 			int i;
@@ -1318,8 +1355,9 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 								 GFP_KERNEL |
 								 GFP_DMA);
 			if (!skb_deaggr) {
-				dev_err(adapter->dev, "skb allocation failure drop pkt len=%d type=%d\n",
-					pkt_len, pkt_type);
+				mwifiex_dbg(adapter, ERROR, "skb allocation failure\t"
+					    "drop pkt len=%d type=%d\n",
+					    pkt_len, pkt_type);
 				curr_ptr += len_arr[pind];
 				continue;
 			}
@@ -1339,12 +1377,12 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
 			} else {
-				dev_err(adapter->dev, " drop wrong aggr pkt:\t"
-					"sdio_single_port_rx_aggr=%d\t"
-					"type=%d len=%d max_len=%d\n",
-					adapter->sdio_rx_aggr_enable,
-					pkt_type, pkt_len,
-					len_arr[pind]);
+				mwifiex_dbg(adapter, ERROR,
+					    "drop wrong aggr pkt:\t"
+					    "sdio_single_port_rx_aggr=%d\t"
+					    "type=%d len=%d max_len=%d\n",
+					    adapter->sdio_rx_aggr_enable,
+					    pkt_type, pkt_len, len_arr[pind]);
 				dev_kfree_skb_any(skb_deaggr);
 			}
 			curr_ptr += len_arr[pind];
@@ -1354,13 +1392,14 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 rx_curr_single:
 	if (f_do_rx_cur) {
-		dev_dbg(adapter->dev, "info: RX: port: %d, rx_len: %d\n",
-			port, rx_len);
+		mwifiex_dbg(adapter, INFO, "info: RX: port: %d, rx_len: %d\n",
+			    port, rx_len);
 
 		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
 		if (!skb) {
-			dev_err(adapter->dev, "single skb allocated fail,\t"
-				"drop pkt port=%d len=%d\n", port, rx_len);
+			mwifiex_dbg(adapter, ERROR,
+				    "single skb allocated fail,\t"
+				    "drop pkt port=%d len=%d\n", port, rx_len);
 			if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 						      card->mpa_rx.buf, rx_len,
 						      adapter->ioport + port))
@@ -1376,9 +1415,9 @@ rx_curr_single:
 			goto error;
 		if (!adapter->sdio_rx_aggr_enable &&
 		    pkt_type == MWIFIEX_TYPE_AGGR_DATA) {
-			dev_err(adapter->dev, "drop wrong pkt type %d\t"
-				"current SDIO RX Aggr not enabled\n",
-				pkt_type);
+			mwifiex_dbg(adapter, ERROR, "drop wrong pkt type %d\t"
+				    "current SDIO RX Aggr not enabled\n",
+				    pkt_type);
 			dev_kfree_skb_any(skb);
 			return 0;
 		}
@@ -1386,7 +1425,8 @@ rx_curr_single:
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 	}
 	if (f_post_aggr_cur) {
-		dev_dbg(adapter->dev, "info: current packet aggregation\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
 		mp_rx_aggr_setup(card, rx_len, port);
 	}
@@ -1458,7 +1498,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		     MWIFIEX_RX_DATA_BUF_SIZE)
 			return -1;
 		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
-		dev_dbg(adapter->dev, "info: rx_len = %d\n", rx_len);
+		mwifiex_dbg(adapter, INFO, "info: rx_len = %d\n", rx_len);
 
 		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
 		if (!skb)
@@ -1469,17 +1509,17 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type, skb->data,
 					      skb->len, adapter->ioport |
 							CMD_PORT_SLCT)) {
-			dev_err(adapter->dev,
-				"%s: failed to card_to_host", __func__);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: failed to card_to_host", __func__);
 			dev_kfree_skb_any(skb);
 			goto term_cmd;
 		}
 
 		if ((pkt_type != MWIFIEX_TYPE_CMD) &&
 		    (pkt_type != MWIFIEX_TYPE_EVENT))
-			dev_err(adapter->dev,
-				"%s:Received wrong packet on cmd port",
-				__func__);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s:Received wrong packet on cmd port",
+				    __func__);
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 	}
@@ -1495,12 +1535,13 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		}
 		card->mp_wr_bitmap = bitmap;
 
-		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%x\n",
-			card->mp_wr_bitmap);
+		mwifiex_dbg(adapter, INTR,
+			    "int: DNLD: wr_bitmap=0x%x\n",
+			    card->mp_wr_bitmap);
 		if (adapter->data_sent &&
 		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
-			dev_dbg(adapter->dev,
-				"info:  <--- Tx DONE Interrupt --->\n");
+			mwifiex_dbg(adapter, INTR,
+				    "info:  <--- Tx DONE Interrupt --->\n");
 			adapter->data_sent = false;
 		}
 	}
@@ -1517,8 +1558,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			adapter->cmd_sent = false;
 	}
 
-	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
-		adapter->cmd_sent, adapter->data_sent);
+	mwifiex_dbg(adapter, INTR, "info: cmd_sent=%d data_sent=%d\n",
+		    adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
 		bitmap = (u32) card->mp_regs[reg->rd_bitmap_l];
 		bitmap |= ((u32) card->mp_regs[reg->rd_bitmap_u]) << 8;
@@ -1529,40 +1570,45 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 				((u32) card->mp_regs[reg->rd_bitmap_1u]) << 24;
 		}
 		card->mp_rd_bitmap = bitmap;
-		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%x\n",
-			card->mp_rd_bitmap);
+		mwifiex_dbg(adapter, INTR,
+			    "int: UPLD: rd_bitmap=0x%x\n",
+			    card->mp_rd_bitmap);
 
 		while (true) {
 			ret = mwifiex_get_rd_port(adapter, &port);
 			if (ret) {
-				dev_dbg(adapter->dev,
-					"info: no more rd_port available\n");
+				mwifiex_dbg(adapter, INFO,
+					    "info: no more rd_port available\n");
 				break;
 			}
 			len_reg_l = reg->rd_len_p0_l + (port << 1);
 			len_reg_u = reg->rd_len_p0_u + (port << 1);
 			rx_len = ((u16) card->mp_regs[len_reg_u]) << 8;
 			rx_len |= (u16) card->mp_regs[len_reg_l];
-			dev_dbg(adapter->dev, "info: RX: port=%d rx_len=%u\n",
-				port, rx_len);
+			mwifiex_dbg(adapter, INFO,
+				    "info: RX: port=%d rx_len=%u\n",
+				    port, rx_len);
 			rx_blocks =
 				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
 				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
 			if (rx_len <= INTF_HEADER_LEN ||
 			    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 			     card->mpa_rx.buf_size) {
-				dev_err(adapter->dev, "invalid rx_len=%d\n",
-					rx_len);
+				mwifiex_dbg(adapter, ERROR,
+					    "invalid rx_len=%d\n",
+					    rx_len);
 				return -1;
 			}
 
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
-			dev_dbg(adapter->dev, "info: rx_len = %d\n", rx_len);
+			mwifiex_dbg(adapter, INFO, "info: rx_len = %d\n",
+				    rx_len);
 
 			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, rx_len,
 							      port)) {
-				dev_err(adapter->dev, "card_to_host_mpa failed:"
-					" int status=%#x\n", sdio_ireg);
+				mwifiex_dbg(adapter, ERROR,
+					    "card_to_host_mpa failed: int status=%#x\n",
+					    sdio_ireg);
 				goto term_cmd;
 			}
 		}
@@ -1573,19 +1619,23 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 term_cmd:
 	/* terminate cmd */
 	if (mwifiex_read_reg(adapter, CONFIGURATION_REG, &cr))
-		dev_err(adapter->dev, "read CFG reg failed\n");
+		mwifiex_dbg(adapter, ERROR, "read CFG reg failed\n");
 	else
-		dev_dbg(adapter->dev, "info: CFG reg val = %d\n", cr);
+		mwifiex_dbg(adapter, INFO,
+			    "info: CFG reg val = %d\n", cr);
 
 	if (mwifiex_write_reg(adapter, CONFIGURATION_REG, (cr | 0x04)))
-		dev_err(adapter->dev, "write CFG reg failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "write CFG reg failed\n");
 	else
-		dev_dbg(adapter->dev, "info: write success\n");
+		mwifiex_dbg(adapter, INFO, "info: write success\n");
 
 	if (mwifiex_read_reg(adapter, CONFIGURATION_REG, &cr))
-		dev_err(adapter->dev, "read CFG reg failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "read CFG reg failed\n");
 	else
-		dev_dbg(adapter->dev, "info: CFG reg val =%x\n", cr);
+		mwifiex_dbg(adapter, INFO,
+			    "info: CFG reg val =%x\n", cr);
 
 	return -1;
 }
@@ -1619,8 +1669,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	if (!card->mpa_tx.enabled ||
 	    (card->has_control_mask && (port == CTRL_PORT)) ||
 	    (card->supports_sdio_new_mode && (port == CMD_PORT_SLCT))) {
-		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
-			__func__);
+		mwifiex_dbg(adapter, WARN,
+			    "info: %s: tx aggregation disabled\n",
+			    __func__);
 
 		f_send_cur_buf = 1;
 		goto tx_curr_single;
@@ -1628,8 +1679,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 	if (next_pkt_len) {
 		/* More pkt in TX queue */
-		dev_dbg(adapter->dev, "info: %s: more packets in queue.\n",
-			__func__);
+		mwifiex_dbg(adapter, INFO,
+			    "info: %s: more packets in queue.\n",
+			    __func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
@@ -1659,8 +1711,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		}
 	} else {
 		/* Last pkt in TX queue */
-		dev_dbg(adapter->dev, "info: %s: Last packet in Tx Queue.\n",
-			__func__);
+		mwifiex_dbg(adapter, INFO,
+			    "info: %s: Last packet in Tx Queue.\n",
+			    __func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
 			/* some packs in Aggr buf already */
@@ -1677,8 +1730,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	}
 
 	if (f_precopy_cur_buf) {
-		dev_dbg(adapter->dev, "data: %s: precopy current buffer\n",
-			__func__);
+		mwifiex_dbg(adapter, DATA,
+			    "data: %s: precopy current buffer\n",
+			    __func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 
 		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
@@ -1688,9 +1742,10 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	}
 
 	if (f_send_aggr_buf) {
-		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
-			__func__,
-				card->mpa_tx.start_port, card->mpa_tx.ports);
+		mwifiex_dbg(adapter, DATA,
+			    "data: %s: send aggr buffer: %d %d\n",
+			    __func__, card->mpa_tx.start_port,
+			    card->mpa_tx.ports);
 		if (card->supports_sdio_new_mode) {
 			u32 port_count;
 			int i;
@@ -1719,15 +1774,17 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 
 tx_curr_single:
 	if (f_send_cur_buf) {
-		dev_dbg(adapter->dev, "data: %s: send current buffer %d\n",
-			__func__, port);
+		mwifiex_dbg(adapter, DATA,
+			    "data: %s: send current buffer %d\n",
+			    __func__, port);
 		ret = mwifiex_write_data_to_card(adapter, payload, pkt_len,
 						 adapter->ioport + port);
 	}
 
 	if (f_postcopy_cur_buf) {
-		dev_dbg(adapter->dev, "data: %s: postcopy current buffer\n",
-			__func__);
+		mwifiex_dbg(adapter, DATA,
+			    "data: %s: postcopy current buffer\n",
+			    __func__);
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 	}
 
@@ -1771,8 +1828,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	if (type == MWIFIEX_TYPE_DATA) {
 		ret = mwifiex_get_wr_port_data(adapter, &port);
 		if (ret) {
-			dev_err(adapter->dev, "%s: no wr_port available\n",
-				__func__);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: no wr_port available\n",
+				    __func__);
 			return ret;
 		}
 	} else {
@@ -1781,8 +1839,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 
 		if (pkt_len <= INTF_HEADER_LEN ||
 		    pkt_len > MWIFIEX_UPLD_SIZE)
-			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
-				__func__, payload, pkt_len);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: payload=%p, nb=%d\n",
+				    __func__, payload, pkt_len);
 
 		if (card->supports_sdio_new_mode)
 			port = CMD_PORT_SLCT;
@@ -1896,7 +1955,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	ret = sdio_set_block_size(card->func, MWIFIEX_SDIO_BLOCK_SIZE);
 	sdio_release_host(func);
 	if (ret) {
-		pr_err("cannot set SDIO block size\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot set SDIO block size\n");
 		return ret;
 	}
 
@@ -1977,7 +2037,8 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 					     card->mp_tx_agg_buf_size,
 					     card->mp_rx_agg_buf_size);
 	if (ret) {
-		dev_err(adapter->dev, "failed to alloc sdio mp-a buffers\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "failed to alloc sdio mp-a buffers\n");
 		kfree(card->mp_regs);
 		return -1;
 	}
@@ -2041,8 +2102,9 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 
 	card->curr_wr_port = reg->start_wr_port;
 
-	dev_dbg(adapter->dev, "cmd: mp_end_port %d, data port mask 0x%x\n",
-		port, card->mp_data_port_mask);
+	mwifiex_dbg(adapter, CMD,
+		    "cmd: mp_end_port %d, data port mask 0x%x\n",
+		    port, card->mp_data_port_mask);
 }
 
 static struct mwifiex_adapter *save_adapter;
@@ -2059,7 +2121,7 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 	 * We run it in a totally independent workqueue.
 	 */
 
-	pr_err("Resetting card...\n");
+	mwifiex_dbg(adapter, WARN, "Resetting card...\n");
 	mmc_remove_host(target);
 	/* 200ms delay is based on experiment with sdhci controller */
 	mdelay(200);
@@ -2079,14 +2141,14 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 	sdio_writeb(card->func, FW_DUMP_HOST_READY, card->reg->fw_dump_ctrl,
 		    &ret);
 	if (ret) {
-		dev_err(adapter->dev, "SDIO Write ERR\n");
+		mwifiex_dbg(adapter, ERROR, "SDIO Write ERR\n");
 		return RDWR_STATUS_FAILURE;
 	}
 	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
 		ctrl_data = sdio_readb(card->func, card->reg->fw_dump_ctrl,
 				       &ret);
 		if (ret) {
-			dev_err(adapter->dev, "SDIO read err\n");
+			mwifiex_dbg(adapter, ERROR, "SDIO read err\n");
 			return RDWR_STATUS_FAILURE;
 		}
 		if (ctrl_data == FW_DUMP_DONE)
@@ -2094,19 +2156,20 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 		if (doneflag && ctrl_data == doneflag)
 			return RDWR_STATUS_DONE;
 		if (ctrl_data != FW_DUMP_HOST_READY) {
-			dev_info(adapter->dev,
-				 "The ctrl reg was changed, re-try again!\n");
+			mwifiex_dbg(adapter, WARN,
+				    "The ctrl reg was changed, re-try again!\n");
 			sdio_writeb(card->func, FW_DUMP_HOST_READY,
 				    card->reg->fw_dump_ctrl, &ret);
 			if (ret) {
-				dev_err(adapter->dev, "SDIO write err\n");
+				mwifiex_dbg(adapter, ERROR, "SDIO write err\n");
 				return RDWR_STATUS_FAILURE;
 			}
 		}
 		usleep_range(100, 200);
 	}
 	if (ctrl_data == FW_DUMP_HOST_READY) {
-		dev_err(adapter->dev, "Fail to pull ctrl_data\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "Fail to pull ctrl_data\n");
 		return RDWR_STATUS_FAILURE;
 	}
 
@@ -2142,7 +2205,7 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 	mwifiex_pm_wakeup_card(adapter);
 	sdio_claim_host(card->func);
 
-	dev_info(adapter->dev, "== mwifiex firmware dump start ==\n");
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump start ==\n");
 
 	stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
 	if (stat == RDWR_STATUS_FAILURE)
@@ -2152,7 +2215,7 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 	/* Read the number of the memories which will dump */
 	dump_num = sdio_readb(card->func, reg, &ret);
 	if (ret) {
-		dev_err(adapter->dev, "SDIO read memory length err\n");
+		mwifiex_dbg(adapter, ERROR, "SDIO read memory length err\n");
 		goto done;
 	}
 
@@ -2169,7 +2232,7 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 		for (i = 0; i < 4; i++) {
 			read_reg = sdio_readb(card->func, reg, &ret);
 			if (ret) {
-				dev_err(adapter->dev, "SDIO read err\n");
+				mwifiex_dbg(adapter, ERROR, "SDIO read err\n");
 				goto done;
 			}
 			memory_size |= (read_reg << i*8);
@@ -2177,25 +2240,26 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 		}
 
 		if (memory_size == 0) {
-			dev_info(adapter->dev, "Firmware dump Finished!\n");
+			mwifiex_dbg(adapter, DUMP, "Firmware dump Finished!\n");
 			break;
 		}
 
-		dev_info(adapter->dev,
-			 "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
+		mwifiex_dbg(adapter, DUMP,
+			    "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
 		entry->mem_ptr = vmalloc(memory_size + 1);
 		entry->mem_size = memory_size;
 		if (!entry->mem_ptr) {
-			dev_err(adapter->dev, "Vmalloc %s failed\n",
-				entry->mem_name);
+			mwifiex_dbg(adapter, ERROR, "Vmalloc %s failed\n",
+				    entry->mem_name);
 			goto done;
 		}
 		dbg_ptr = entry->mem_ptr;
 		end_ptr = dbg_ptr + memory_size;
 
 		doneflag = entry->done_flag;
-		dev_info(adapter->dev, "Start %s output, please wait...\n",
-			 entry->mem_name);
+		mwifiex_dbg(adapter, DUMP,
+			    "Start %s output, please wait...\n",
+			    entry->mem_name);
 
 		do {
 			stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
@@ -2207,26 +2271,26 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 			for (reg = reg_start; reg <= reg_end; reg++) {
 				*dbg_ptr = sdio_readb(card->func, reg, &ret);
 				if (ret) {
-					dev_err(adapter->dev,
-						"SDIO read err\n");
+					mwifiex_dbg(adapter, ERROR,
+						    "SDIO read err\n");
 					goto done;
 				}
 				if (dbg_ptr < end_ptr)
 					dbg_ptr++;
 				else
-					dev_err(adapter->dev,
-						"Allocated buf not enough\n");
+					mwifiex_dbg(adapter, ERROR,
+						    "Allocated buf not enough\n");
 			}
 
 			if (stat != RDWR_STATUS_DONE)
 				continue;
 
-			dev_info(adapter->dev, "%s done: size=0x%tx\n",
-				 entry->mem_name, dbg_ptr - entry->mem_ptr);
+			mwifiex_dbg(adapter, DUMP, "%s done: size=0x%tx\n",
+				    entry->mem_name, dbg_ptr - entry->mem_ptr);
 			break;
 		} while (1);
 	}
-	dev_info(adapter->dev, "== mwifiex firmware dump end ==\n");
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
 
 	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
 
@@ -2285,7 +2349,7 @@ mwifiex_sdio_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
 	if (!p)
 		return 0;
 
-	dev_info(adapter->dev, "SDIO register DUMP START\n");
+	mwifiex_dbg(adapter, MSG, "SDIO register DUMP START\n");
 
 	mwifiex_pm_wakeup_card(adapter);
 
@@ -2351,13 +2415,13 @@ mwifiex_sdio_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
 				reg++;
 		}
 
-		dev_info(adapter->dev, "%s\n", buf);
+		mwifiex_dbg(adapter, MSG, "%s\n", buf);
 		p += sprintf(p, "%s\n", buf);
 	}
 
 	sdio_release_host(cardp->func);
 
-	dev_info(adapter->dev, "SDIO register DUMP END\n");
+	mwifiex_dbg(adapter, MSG, "SDIO register DUMP END\n");
 
 	return p - drv_buf;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index a76d6a4..037adcd 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -77,8 +77,8 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
 
 	if (cmd_action != HostCmd_ACT_GEN_SET) {
-		dev_err(priv->adapter->dev,
-			"mac_control: only support set cmd\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "mac_control: only support set cmd\n");
 		return -1;
 	}
 
@@ -112,7 +112,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
 
-	dev_dbg(priv->adapter->dev, "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
+	mwifiex_dbg(priv->adapter, CMD,
+		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
 				- 1 + S_DS_GEN);
@@ -129,11 +130,11 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		le16_add_cpu(&cmd->size, sizeof(u16));
 	}
 
-	dev_dbg(priv->adapter->dev,
-		"cmd: SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x,"
-		" Value=0x%x\n",
-		cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
-		le16_to_cpu(*(__le16 *) snmp_mib->value));
+	mwifiex_dbg(priv->adapter, CMD,
+		    "cmd: SNMP_CMD: Action=0x%x, OID=0x%x,\t"
+		    "OIDSize=0x%x, Value=0x%x\n",
+		    cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
+		    le16_to_cpu(*(__le16 *)snmp_mib->value));
 	return 0;
 }
 
@@ -356,9 +357,9 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	    (hscfg_param->conditions != cpu_to_le32(HS_CFG_CANCEL)) &&
 	    ((adapter->arp_filter_size > 0) &&
 	     (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
-		dev_dbg(adapter->dev,
-			"cmd: Attach %d bytes ArpFilter to HSCfg cmd\n",
-			adapter->arp_filter_size);
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: Attach %d bytes ArpFilter to HSCfg cmd\n",
+			    adapter->arp_filter_size);
 		memcpy(((u8 *) hs_cfg) +
 		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
 		       adapter->arp_filter, adapter->arp_filter_size);
@@ -378,11 +379,11 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->params.hs_config.conditions = hscfg_param->conditions;
 		hs_cfg->params.hs_config.gpio = hscfg_param->gpio;
 		hs_cfg->params.hs_config.gap = hscfg_param->gap;
-		dev_dbg(adapter->dev,
-			"cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
-		       hs_cfg->params.hs_config.conditions,
-		       hs_cfg->params.hs_config.gpio,
-		       hs_cfg->params.hs_config.gap);
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
+			    hs_cfg->params.hs_config.conditions,
+			    hs_cfg->params.hs_config.gpio,
+			    hs_cfg->params.hs_config.gap);
 	}
 
 	return 0;
@@ -462,7 +463,7 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 	/* Set AP MAC address */
 	memcpy(deauth->mac_addr, mac, ETH_ALEN);
 
-	dev_dbg(priv->adapter->dev, "cmd: Deauth: %pM\n", deauth->mac_addr);
+	mwifiex_dbg(priv->adapter, CMD, "cmd: Deauth: %pM\n", deauth->mac_addr);
 
 	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
 
@@ -540,9 +541,9 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 		} else if (!priv->wep_key[i].key_length) {
 			continue;
 		} else {
-			dev_err(priv->adapter->dev,
-				"key%d Length = %d is incorrect\n",
-			       (i + 1), priv->wep_key[i].key_length);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "key%d Length = %d is incorrect\n",
+				    (i + 1), priv->wep_key[i].key_length);
 			return -1;
 		}
 	}
@@ -562,7 +563,8 @@ static int mwifiex_set_aes_key_v2(struct mwifiex_private *priv,
 	u16 size, len = KEY_PARAMS_FIXED_LEN;
 
 	if (enc_key->is_igtk_key) {
-		dev_dbg(adapter->dev, "%s: Set CMAC AES Key\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "%s: Set CMAC AES Key\n", __func__);
 		if (enc_key->is_rx_seq_valid)
 			memcpy(km->key_param_set.key_params.cmac_aes.ipn,
 			       enc_key->pn, enc_key->pn_len);
@@ -575,7 +577,8 @@ static int mwifiex_set_aes_key_v2(struct mwifiex_private *priv,
 		       enc_key->key_material, enc_key->key_len);
 		len += sizeof(struct mwifiex_cmac_aes_param);
 	} else {
-		dev_dbg(adapter->dev, "%s: Set AES Key\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "%s: Set AES Key\n", __func__);
 		if (enc_key->is_rx_seq_valid)
 			memcpy(km->key_param_set.key_params.aes.pn,
 			       enc_key->pn, enc_key->pn_len);
@@ -619,7 +622,7 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 	km->action = cpu_to_le16(cmd_action);
 
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-		dev_dbg(adapter->dev, "%s: Get key\n", __func__);
+		mwifiex_dbg(adapter, INFO, "%s: Get key\n", __func__);
 		km->key_param_set.key_idx =
 					enc_key->key_index & KEY_INDEX_MASK;
 		km->key_param_set.type = cpu_to_le16(TLV_TYPE_KEY_PARAM_V2);
@@ -646,7 +649,7 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 	       sizeof(struct mwifiex_ie_type_key_param_set_v2));
 
 	if (enc_key->key_disable) {
-		dev_dbg(adapter->dev, "%s: Remove key\n", __func__);
+		mwifiex_dbg(adapter, INFO, "%s: Remove key\n", __func__);
 		km->action = cpu_to_le16(HostCmd_ACT_GEN_REMOVE);
 		km->key_param_set.type = cpu_to_le16(TLV_TYPE_KEY_PARAM_V2);
 		km->key_param_set.len = cpu_to_le16(KEY_PARAMS_FIXED_LEN);
@@ -667,7 +670,7 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 	memcpy(km->key_param_set.mac_addr, mac, ETH_ALEN);
 
 	if (enc_key->key_len <= WLAN_KEY_LEN_WEP104) {
-		dev_dbg(adapter->dev, "%s: Set WEP Key\n", __func__);
+		mwifiex_dbg(adapter, INFO, "%s: Set WEP Key\n", __func__);
 		len += sizeof(struct mwifiex_wep_param);
 		km->key_param_set.len = cpu_to_le16(len);
 		km->key_param_set.key_type = KEY_TYPE_ID_WEP;
@@ -710,7 +713,7 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 		key_info |= KEY_UNICAST | KEY_TX_KEY | KEY_RX_KEY;
 
 	if (enc_key->is_wapi_key) {
-		dev_dbg(adapter->dev, "%s: Set WAPI Key\n", __func__);
+		mwifiex_dbg(adapter, INFO, "%s: Set WAPI Key\n", __func__);
 		km->key_param_set.key_type = KEY_TYPE_ID_WAPI;
 		memcpy(km->key_param_set.key_params.wapi.pn, enc_key->pn,
 		       PN_LEN);
@@ -750,7 +753,8 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 		return mwifiex_set_aes_key_v2(priv, cmd, enc_key, km);
 
 	if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
-		dev_dbg(adapter->dev, "%s: Set TKIP Key\n", __func__);
+		mwifiex_dbg(adapter, INFO,
+			    "%s: Set TKIP Key\n", __func__);
 		if (enc_key->is_rx_seq_valid)
 			memcpy(km->key_param_set.key_params.tkip.pn,
 			       enc_key->pn, enc_key->pn_len);
@@ -814,7 +818,7 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 		memset(&key_material->key_param_set, 0,
 		       sizeof(struct mwifiex_ie_type_key_param_set));
 	if (enc_key->is_wapi_key) {
-		dev_dbg(priv->adapter->dev, "info: Set WAPI Key\n");
+		mwifiex_dbg(priv->adapter, INFO, "info: Set WAPI Key\n");
 		key_material->key_param_set.key_type_id =
 						cpu_to_le16(KEY_TYPE_ID_WAPI);
 		if (cmd_oid == KEY_INFO_ENABLED)
@@ -860,7 +864,7 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
 		if (enc_key->is_igtk_key) {
-			dev_dbg(priv->adapter->dev, "cmd: CMAC_AES\n");
+			mwifiex_dbg(priv->adapter, CMD, "cmd: CMAC_AES\n");
 			key_material->key_param_set.key_type_id =
 					cpu_to_le16(KEY_TYPE_ID_AES_CMAC);
 			if (cmd_oid == KEY_INFO_ENABLED)
@@ -873,7 +877,7 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 			key_material->key_param_set.key_info |=
 							cpu_to_le16(KEY_IGTK);
 		} else {
-			dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
+			mwifiex_dbg(priv->adapter, CMD, "cmd: WPA_AES\n");
 			key_material->key_param_set.key_type_id =
 						cpu_to_le16(KEY_TYPE_ID_AES);
 			if (cmd_oid == KEY_INFO_ENABLED)
@@ -892,7 +896,7 @@ mwifiex_cmd_802_11_key_material_v1(struct mwifiex_private *priv,
 							cpu_to_le16(KEY_MCAST);
 		}
 	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
-		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
+		mwifiex_dbg(priv->adapter, CMD, "cmd: WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
 						cpu_to_le16(KEY_TYPE_ID_TKIP);
 		key_material->key_param_set.key_info =
@@ -999,7 +1003,8 @@ static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		&domain_info->domain;
 	u8 no_of_triplet = adapter->domain_reg.no_of_triplet;
 
-	dev_dbg(adapter->dev, "info: 11D: no_of_triplet=0x%x\n", no_of_triplet);
+	mwifiex_dbg(adapter, INFO,
+		    "info: 11D: no_of_triplet=0x%x\n", no_of_triplet);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
 	domain_info->action = cpu_to_le16(cmd_action);
@@ -1235,8 +1240,9 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 						(u32)(card->sleep_cookie_pbase);
 		host_spec->sleep_cookie_addr_hi =
 				 (u32)(((u64)(card->sleep_cookie_pbase)) >> 32);
-		dev_dbg(priv->adapter->dev, "sleep_cook_lo phy addr: 0x%x\n",
-			host_spec->sleep_cookie_addr_lo);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "sleep_cook_lo phy addr: 0x%x\n",
+			    host_spec->sleep_cookie_addr_lo);
 	}
 
 	return 0;
@@ -1263,7 +1269,8 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 				S_DS_GEN);
 
 	subsc_evt->action = cpu_to_le16(subsc_evt_cfg->action);
-	dev_dbg(priv->adapter->dev, "cmd: action: %d\n", subsc_evt_cfg->action);
+	mwifiex_dbg(priv->adapter, CMD,
+		    "cmd: action: %d\n", subsc_evt_cfg->action);
 
 	/*For query requests, no configuration TLV structures are to be added.*/
 	if (subsc_evt_cfg->action == HostCmd_ACT_GEN_GET)
@@ -1272,14 +1279,15 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 	subsc_evt->events = cpu_to_le16(subsc_evt_cfg->events);
 
 	event_bitmap = subsc_evt_cfg->events;
-	dev_dbg(priv->adapter->dev, "cmd: event bitmap : %16x\n",
-		event_bitmap);
+	mwifiex_dbg(priv->adapter, CMD, "cmd: event bitmap : %16x\n",
+		    event_bitmap);
 
 	if (((subsc_evt_cfg->action == HostCmd_ACT_BITWISE_CLR) ||
 	     (subsc_evt_cfg->action == HostCmd_ACT_BITWISE_SET)) &&
 	    (event_bitmap == 0)) {
-		dev_dbg(priv->adapter->dev, "Error: No event specified "
-			"for bitwise action type\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Error: No event specified\t"
+			    "for bitwise action type\n");
 		return -EINVAL;
 	}
 
@@ -1304,10 +1312,11 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 		rssi_tlv->abs_value = subsc_evt_cfg->bcn_l_rssi_cfg.abs_value;
 		rssi_tlv->evt_freq = subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq;
 
-		dev_dbg(priv->adapter->dev, "Cfg Beacon Low Rssi event, "
-			"RSSI:-%d dBm, Freq:%d\n",
-			subsc_evt_cfg->bcn_l_rssi_cfg.abs_value,
-			subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq);
+		mwifiex_dbg(priv->adapter, EVENT,
+			    "Cfg Beacon Low Rssi event,\t"
+			    "RSSI:-%d dBm, Freq:%d\n",
+			    subsc_evt_cfg->bcn_l_rssi_cfg.abs_value,
+			    subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq);
 
 		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
 		le16_add_cpu(&cmd->size,
@@ -1324,10 +1333,11 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 		rssi_tlv->abs_value = subsc_evt_cfg->bcn_h_rssi_cfg.abs_value;
 		rssi_tlv->evt_freq = subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq;
 
-		dev_dbg(priv->adapter->dev, "Cfg Beacon High Rssi event, "
-			"RSSI:-%d dBm, Freq:%d\n",
-			subsc_evt_cfg->bcn_h_rssi_cfg.abs_value,
-			subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq);
+		mwifiex_dbg(priv->adapter, EVENT,
+			    "Cfg Beacon High Rssi event,\t"
+			    "RSSI:-%d dBm, Freq:%d\n",
+			    subsc_evt_cfg->bcn_h_rssi_cfg.abs_value,
+			    subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq);
 
 		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
 		le16_add_cpu(&cmd->size,
@@ -1483,12 +1493,14 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 						data, len);
 		if (ret)
 			return ret;
-		dev_dbg(adapter->dev,
-			"download cfg_data from device tree: %s\n", prop->name);
+		mwifiex_dbg(adapter, INFO,
+			    "download cfg_data from device tree: %s\n",
+			    prop->name);
 	} else if (adapter->cal_data->data && adapter->cal_data->size > 0) {
 		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
 					    adapter->cal_data->size, data);
-		dev_dbg(adapter->dev, "download cfg_data from config file\n");
+		mwifiex_dbg(adapter, INFO,
+			    "download cfg_data from config file\n");
 	} else {
 		return -1;
 	}
@@ -1603,9 +1615,9 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_CONFIG);
 
 		if (!params) {
-			dev_err(priv->adapter->dev,
-				"TDLS config params not available for %pM\n",
-				oper->peer_mac);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "TDLS config params not available for %pM\n",
+				    oper->peer_mac);
 			return -ENODATA;
 		}
 
@@ -1683,7 +1695,7 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 
 		break;
 	default:
-		dev_err(priv->adapter->dev, "Unknown TDLS operation\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS operation\n");
 		return -ENOTSUPP;
 	}
 
@@ -1890,8 +1902,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_11n_cfg(priv, cmd_ptr, cmd_action, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
-		dev_dbg(priv->adapter->dev,
-			"cmd: WMM: WMM_GET_STATUS cmd sent\n");
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: WMM: WMM_GET_STATUS cmd sent\n");
 		cmd_ptr->command = cpu_to_le16(HostCmd_CMD_WMM_GET_STATUS);
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_wmm_get_status) +
@@ -1955,8 +1967,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						   data_buf);
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
 		ret = -1;
 		break;
 	}
@@ -2047,8 +2059,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 					       &sdio_sp_rx_aggr_enable,
 					       true);
 			if (ret) {
-				dev_err(priv->adapter->dev,
-					"error while enabling SP aggregation..disable it");
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "error while enabling SP aggregation..disable it");
 				adapter->sdio_rx_aggr_enable = false;
 			}
 		}
@@ -2131,8 +2143,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 				       HostCmd_ACT_GEN_SET, DOT11D_I,
 				       &state_11d, true);
 		if (ret)
-			dev_err(priv->adapter->dev,
-				"11D: failed to enable 11D\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "11D: failed to enable 11D\n");
 	}
 
 	/* Send cmd to FW to configure 11n specific configuration
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index efe31a2..aa5b9a3 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -49,8 +49,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_ps_mode_enh *pm;
 	unsigned long flags;
 
-	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
-		resp->command, resp->result);
+	mwifiex_dbg(adapter, ERROR,
+		    "CMD_RESP: cmd %#x error, result=%#x\n",
+		    resp->command, resp->result);
 
 	if (adapter->curr_cmd->wait_q_enabled)
 		adapter->cmd_wait_q.status = -1;
@@ -58,9 +59,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		pm = &resp->params.psmode_enh;
-		dev_err(adapter->dev,
-			"PS_MODE_ENH cmd failed: result=0x%x action=0x%X\n",
-			resp->result, le16_to_cpu(pm->action));
+		mwifiex_dbg(adapter, ERROR,
+			    "PS_MODE_ENH cmd failed: result=0x%x action=0x%X\n",
+			    resp->result, le16_to_cpu(pm->action));
 		/* We do not re-try enter-ps command in ad-hoc mode. */
 		if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
 		    (le16_to_cpu(pm->params.ps_bitmap) & BITMAP_STA_PS) &&
@@ -91,7 +92,8 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		break;
 
 	case HostCmd_CMD_SDIO_SP_RX_AGGR_CFG:
-		dev_err(priv->adapter->dev, "SDIO RX single-port aggregation Not support\n");
+		mwifiex_dbg(adapter, MSG,
+			    "SDIO RX single-port aggregation Not support\n");
 		break;
 
 	default:
@@ -187,29 +189,34 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 	u16 query_type = le16_to_cpu(smib->query_type);
 	u32 ul_temp;
 
-	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
-		" query_type = %#x, buf size = %#x\n",
-		oid, query_type, le16_to_cpu(smib->buf_size));
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: SNMP_RESP: oid value = %#x,\t"
+		    "query_type = %#x, buf size = %#x\n",
+		    oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
 		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 		if (data_buf)
 			*data_buf = ul_temp;
 		switch (oid) {
 		case FRAG_THRESH_I:
-			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: FragThsd =%u\n", ul_temp);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: SNMP_RESP: FragThsd =%u\n",
+				    ul_temp);
 			break;
 		case RTS_THRESH_I:
-			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: RTSThsd =%u\n", ul_temp);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: SNMP_RESP: RTSThsd =%u\n",
+				    ul_temp);
 			break;
 		case SHORT_RETRY_LIM_I:
-			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: SNMP_RESP: TxRetryCount=%u\n",
+				    ul_temp);
 			break;
 		case DTIM_PERIOD_I:
-			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: DTIM period=%u\n", ul_temp);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: SNMP_RESP: DTIM period=%u\n",
+				    ul_temp);
 		default:
 			break;
 		}
@@ -426,14 +433,15 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 			priv->tx_power_level = (u16) pg->power_min;
 		break;
 	default:
-		dev_err(adapter->dev, "CMD_RESP: unknown cmd action %d\n",
-			action);
+		mwifiex_dbg(adapter, ERROR,
+			    "CMD_RESP: unknown cmd action %d\n",
+			    action);
 		return 0;
 	}
-	dev_dbg(adapter->dev,
-		"info: Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
-	       priv->tx_power_level, priv->max_tx_power_level,
-	       priv->min_tx_power_level);
+	mwifiex_dbg(adapter, INFO,
+		    "info: Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
+		    priv->tx_power_level, priv->max_tx_power_level,
+		    priv->min_tx_power_level);
 
 	return 0;
 }
@@ -454,10 +462,10 @@ static int mwifiex_ret_rf_tx_power(struct mwifiex_private *priv,
 		priv->min_tx_power_level = txp->min_power;
 	}
 
-	dev_dbg(priv->adapter->dev,
-		"Current TxPower Level=%d, Max Power=%d, Min Power=%d\n",
-		priv->tx_power_level, priv->max_tx_power_level,
-		priv->min_tx_power_level);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "Current TxPower Level=%d, Max Power=%d, Min Power=%d\n",
+		    priv->tx_power_level, priv->max_tx_power_level,
+		    priv->min_tx_power_level);
 
 	return 0;
 }
@@ -473,18 +481,18 @@ static int mwifiex_ret_rf_antenna(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (adapter->hw_dev_mcs_support == HT_STREAM_2X2)
-		dev_dbg(adapter->dev,
-			"RF_ANT_RESP: Tx action = 0x%x, Tx Mode = 0x%04x"
-			" Rx action = 0x%x, Rx Mode = 0x%04x\n",
-			le16_to_cpu(ant_mimo->action_tx),
-			le16_to_cpu(ant_mimo->tx_ant_mode),
-			le16_to_cpu(ant_mimo->action_rx),
-			le16_to_cpu(ant_mimo->rx_ant_mode));
+		mwifiex_dbg(adapter, INFO,
+			    "RF_ANT_RESP: Tx action = 0x%x, Tx Mode = 0x%04x\t"
+			    "Rx action = 0x%x, Rx Mode = 0x%04x\n",
+			    le16_to_cpu(ant_mimo->action_tx),
+			    le16_to_cpu(ant_mimo->tx_ant_mode),
+			    le16_to_cpu(ant_mimo->action_rx),
+			    le16_to_cpu(ant_mimo->rx_ant_mode));
 	else
-		dev_dbg(adapter->dev,
-			"RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
-			le16_to_cpu(ant_siso->action),
-			le16_to_cpu(ant_siso->ant_mode));
+		mwifiex_dbg(adapter, INFO,
+			    "RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
+			    le16_to_cpu(ant_siso->action),
+			    le16_to_cpu(ant_siso->ant_mode));
 
 	return 0;
 }
@@ -502,8 +510,8 @@ static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 
 	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr, ETH_ALEN);
 
-	dev_dbg(priv->adapter->dev,
-		"info: set mac address: %pM\n", priv->curr_addr);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: set mac address: %pM\n", priv->curr_addr);
 
 	return 0;
 }
@@ -587,7 +595,8 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
 
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key->key_param_set.key_info) & KEY_MCAST)) {
-			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
 		}
@@ -617,7 +626,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 	key_v2 = &resp->params.key_material_v2;
 	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
 		if ((le16_to_cpu(key_v2->key_param_set.key_info) & KEY_MCAST)) {
-			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
+			mwifiex_dbg(priv->adapter, INFO, "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
 		}
@@ -663,14 +672,14 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 				- IEEE80211_COUNTRY_STRING_LEN)
 			      / sizeof(struct ieee80211_country_ie_triplet));
 
-	dev_dbg(priv->adapter->dev,
-		"info: 11D Domain Info Resp: no_of_triplet=%d\n",
-		no_of_triplet);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: 11D Domain Info Resp: no_of_triplet=%d\n",
+		    no_of_triplet);
 
 	if (no_of_triplet > MWIFIEX_MAX_TRIPLET_802_11D) {
-		dev_warn(priv->adapter->dev,
-			 "11D: invalid number of triplets %d returned\n",
-			 no_of_triplet);
+		mwifiex_dbg(priv->adapter, FATAL,
+			    "11D: invalid number of triplets %d returned\n",
+			    no_of_triplet);
 		return -1;
 	}
 
@@ -680,8 +689,8 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	case HostCmd_ACT_GEN_GET:
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"11D: invalid action:%d\n", domain_info->action);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "11D: invalid action:%d\n", domain_info->action);
 		return -1;
 	}
 
@@ -843,12 +852,12 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
 		return 0;
 
-	dev_dbg(priv->adapter->dev,
-		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: new BSSID %pM\n", ibss_coal_resp->bssid);
 
 	/* If rsp has NULL BSSID, Just return..... No Action */
 	if (is_zero_ether_addr(ibss_coal_resp->bssid)) {
-		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
+		mwifiex_dbg(priv->adapter, FATAL, "new BSSID is NULL\n");
 		return 0;
 	}
 
@@ -884,48 +893,48 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 	case ACT_TDLS_DELETE:
 		if (reason) {
 			if (!node || reason == TDLS_ERR_LINK_NONEXISTENT)
-				dev_dbg(priv->adapter->dev,
-					"TDLS link delete for %pM failed: reason %d\n",
-					cmd_tdls_oper->peer_mac, reason);
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "TDLS link delete for %pM failed: reason %d\n",
+					    cmd_tdls_oper->peer_mac, reason);
 			else
-				dev_err(priv->adapter->dev,
-					"TDLS link delete for %pM failed: reason %d\n",
-					cmd_tdls_oper->peer_mac, reason);
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "TDLS link delete for %pM failed: reason %d\n",
+					    cmd_tdls_oper->peer_mac, reason);
 		} else {
-			dev_dbg(priv->adapter->dev,
-				"TDLS link delete for %pM successful\n",
-				cmd_tdls_oper->peer_mac);
+			mwifiex_dbg(priv->adapter, MSG,
+				    "TDLS link delete for %pM successful\n",
+				    cmd_tdls_oper->peer_mac);
 		}
 		break;
 	case ACT_TDLS_CREATE:
 		if (reason) {
-			dev_err(priv->adapter->dev,
-				"TDLS link creation for %pM failed: reason %d",
-				cmd_tdls_oper->peer_mac, reason);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "TDLS link creation for %pM failed: reason %d",
+				    cmd_tdls_oper->peer_mac, reason);
 			if (node && reason != TDLS_ERR_LINK_EXISTS)
 				node->tdls_status = TDLS_SETUP_FAILURE;
 		} else {
-			dev_dbg(priv->adapter->dev,
-				"TDLS link creation for %pM successful",
-				cmd_tdls_oper->peer_mac);
+			mwifiex_dbg(priv->adapter, MSG,
+				    "TDLS link creation for %pM successful",
+				    cmd_tdls_oper->peer_mac);
 		}
 		break;
 	case ACT_TDLS_CONFIG:
 		if (reason) {
-			dev_err(priv->adapter->dev,
-				"TDLS link config for %pM failed, reason %d\n",
-				cmd_tdls_oper->peer_mac, reason);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "TDLS link config for %pM failed, reason %d\n",
+				    cmd_tdls_oper->peer_mac, reason);
 			if (node)
 				node->tdls_status = TDLS_SETUP_FAILURE;
 		} else {
-			dev_dbg(priv->adapter->dev,
-				"TDLS link config for %pM successful\n",
-				cmd_tdls_oper->peer_mac);
+			mwifiex_dbg(priv->adapter, MSG,
+				    "TDLS link config for %pM successful\n",
+				    cmd_tdls_oper->peer_mac);
 		}
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"Unknown TDLS command action response %d", action);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Unknown TDLS command action response %d", action);
 		return -1;
 	}
 
@@ -942,8 +951,9 @@ static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
 
 	/* For every subscribe event command (Get/Set/Clear), FW reports the
 	 * current set of subscribed events*/
-	dev_dbg(priv->adapter->dev, "Bitmap of currently subscribed events: %16x\n",
-		le16_to_cpu(cmd_sub_event->events));
+	mwifiex_dbg(priv->adapter, EVENT,
+		    "Bitmap of currently subscribed events: %16x\n",
+		    le16_to_cpu(cmd_sub_event->events));
 
 	return 0;
 }
@@ -953,7 +963,7 @@ static int mwifiex_ret_cfg_data(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *resp)
 {
 	if (resp->result != HostCmd_RESULT_OK) {
-		dev_err(priv->adapter->dev, "Cal data cmd resp failed\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Cal data cmd resp failed\n");
 		return -1;
 	}
 
@@ -1021,8 +1031,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
-		dev_dbg(adapter->dev,
-			"info: CMD_RESP: BG_SCAN result is ready!\n");
+		mwifiex_dbg(adapter, CMD,
+			    "info: CMD_RESP: BG_SCAN result is ready!\n");
 		break;
 	case HostCmd_CMD_TXPWR_CFG:
 		ret = mwifiex_ret_tx_power_cfg(priv, resp);
@@ -1101,8 +1111,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 					/ MWIFIEX_SDIO_BLOCK_SIZE)
 				       * MWIFIEX_SDIO_BLOCK_SIZE;
 		adapter->curr_tx_buf_size = adapter->tx_buf_size;
-		dev_dbg(adapter->dev, "cmd: curr_tx_buf_size=%d\n",
-			adapter->curr_tx_buf_size);
+		mwifiex_dbg(adapter, CMD, "cmd: curr_tx_buf_size=%d\n",
+			    adapter->curr_tx_buf_size);
 
 		if (adapter->if_ops.update_mp_end_port)
 			adapter->if_ops.update_mp_end_port(adapter,
@@ -1162,8 +1172,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_sdio_rx_aggr_cfg(priv, resp);
 		break;
 	default:
-		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
-			resp->command);
+		mwifiex_dbg(adapter, ERROR,
+			    "CMD_RESP: unknown cmd response %#x\n",
+			    resp->command);
 		break;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0dc7a1d..bed67d4 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -48,7 +48,8 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	if (!priv->media_connected)
 		return;
 
-	dev_dbg(adapter->dev, "info: handles disconnect event\n");
+	mwifiex_dbg(adapter, INFO,
+		    "info: handles disconnect event\n");
 
 	priv->media_connected = false;
 
@@ -104,12 +105,14 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	 * it could be used for re-assoc
 	 */
 
-	dev_dbg(adapter->dev, "info: previous SSID=%s, SSID len=%u\n",
-		priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
+	mwifiex_dbg(adapter, INFO,
+		    "info: previous SSID=%s, SSID len=%u\n",
+		    priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
 
-	dev_dbg(adapter->dev, "info: current SSID=%s, SSID len=%u\n",
-		priv->curr_bss_params.bss_descriptor.ssid.ssid,
-		priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+	mwifiex_dbg(adapter, INFO,
+		    "info: current SSID=%s, SSID len=%u\n",
+		    priv->curr_bss_params.bss_descriptor.ssid.ssid,
+		    priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
 
 	memcpy(&priv->prev_ssid,
 	       &priv->curr_bss_params.bss_descriptor.ssid,
@@ -127,9 +130,9 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	if (adapter->is_cmd_timedout && adapter->curr_cmd)
 		return;
 	priv->media_connected = false;
-	dev_dbg(adapter->dev,
-		"info: successfully disconnected from %pM: reason code %d\n",
-		priv->cfg_bssid, reason_code);
+	mwifiex_dbg(adapter, MSG,
+		    "info: successfully disconnected from %pM: reason code %d\n",
+		    priv->cfg_bssid, reason_code);
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
 	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		cfg80211_disconnected(priv->netdev, reason_code, NULL, 0,
@@ -154,13 +157,13 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 	/* reserved 2 bytes are not mandatory in tdls event */
 	if (event_skb->len < (sizeof(struct mwifiex_tdls_generic_event) -
 			      sizeof(u16) - sizeof(adapter->event_cause))) {
-		dev_err(adapter->dev, "Invalid event length!\n");
+		mwifiex_dbg(adapter, ERROR, "Invalid event length!\n");
 		return -1;
 	}
 
 	sta_ptr = mwifiex_get_sta_entry(priv, tdls_evt->peer_mac);
 	if (!sta_ptr) {
-		dev_err(adapter->dev, "cannot get sta entry!\n");
+		mwifiex_dbg(adapter, ERROR, "cannot get sta entry!\n");
 		return -1;
 	}
 
@@ -239,21 +242,21 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
-		dev_err(adapter->dev,
-			"invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL, ignore it\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL, ignore it\n");
 		break;
 	case EVENT_LINK_SENSED:
-		dev_dbg(adapter->dev, "event: LINK_SENSED\n");
+		mwifiex_dbg(adapter, EVENT, "event: LINK_SENSED\n");
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
 		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 
 	case EVENT_DEAUTHENTICATED:
-		dev_dbg(adapter->dev, "event: Deauthenticated\n");
+		mwifiex_dbg(adapter, EVENT, "event: Deauthenticated\n");
 		if (priv->wps.session_enable) {
-			dev_dbg(adapter->dev,
-				"info: receive deauth event in wps session\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: receive deauth event in wps session\n");
 			break;
 		}
 		adapter->dbg.num_event_deauth++;
@@ -265,10 +268,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_DISASSOCIATED:
-		dev_dbg(adapter->dev, "event: Disassociated\n");
+		mwifiex_dbg(adapter, EVENT, "event: Disassociated\n");
 		if (priv->wps.session_enable) {
-			dev_dbg(adapter->dev,
-				"info: receive disassoc event in wps session\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: receive disassoc event in wps session\n");
 			break;
 		}
 		adapter->dbg.num_event_disassoc++;
@@ -280,7 +283,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_LINK_LOST:
-		dev_dbg(adapter->dev, "event: Link lost\n");
+		mwifiex_dbg(adapter, EVENT, "event: Link lost\n");
 		adapter->dbg.num_event_link_lost++;
 		if (priv->media_connected) {
 			reason_code =
@@ -290,7 +293,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_PS_SLEEP:
-		dev_dbg(adapter->dev, "info: EVENT: SLEEP\n");
+		mwifiex_dbg(adapter, EVENT, "info: EVENT: SLEEP\n");
 
 		adapter->ps_state = PS_STATE_PRE_SLEEP;
 
@@ -298,12 +301,12 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_PS_AWAKE:
-		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
+		mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
 		if (!adapter->pps_uapsd_mode &&
 		    priv->media_connected && adapter->sleep_period.period) {
 				adapter->pps_uapsd_mode = true;
-				dev_dbg(adapter->dev,
-					"event: PPS/UAPSD mode activated\n");
+				mwifiex_dbg(adapter, EVENT,
+					    "event: PPS/UAPSD mode activated\n");
 		}
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
@@ -333,26 +336,26 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_DEEP_SLEEP_AWAKE:
 		adapter->if_ops.wakeup_complete(adapter);
-		dev_dbg(adapter->dev, "event: DS_AWAKE\n");
+		mwifiex_dbg(adapter, EVENT, "event: DS_AWAKE\n");
 		if (adapter->is_deep_sleep)
 			adapter->is_deep_sleep = false;
 		break;
 
 	case EVENT_HS_ACT_REQ:
-		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
+		mwifiex_dbg(adapter, EVENT, "event: HS_ACT_REQ\n");
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_HS_CFG_ENH,
 				       0, 0, NULL, false);
 		break;
 
 	case EVENT_MIC_ERR_UNICAST:
-		dev_dbg(adapter->dev, "event: UNICAST MIC ERROR\n");
+		mwifiex_dbg(adapter, EVENT, "event: UNICAST MIC ERROR\n");
 		cfg80211_michael_mic_failure(priv->netdev, priv->cfg_bssid,
 					     NL80211_KEYTYPE_PAIRWISE,
 					     -1, NULL, GFP_KERNEL);
 		break;
 
 	case EVENT_MIC_ERR_MULTICAST:
-		dev_dbg(adapter->dev, "event: MULTICAST MIC ERROR\n");
+		mwifiex_dbg(adapter, EVENT, "event: MULTICAST MIC ERROR\n");
 		cfg80211_michael_mic_failure(priv->netdev, priv->cfg_bssid,
 					     NL80211_KEYTYPE_GROUP,
 					     -1, NULL, GFP_KERNEL);
@@ -362,7 +365,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_ADHOC_BCN_LOST:
-		dev_dbg(adapter->dev, "event: ADHOC_BCN_LOST\n");
+		mwifiex_dbg(adapter, EVENT, "event: ADHOC_BCN_LOST\n");
 		priv->adhoc_is_link_sensed = false;
 		mwifiex_clean_txrx(priv);
 		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
@@ -371,17 +374,17 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_BG_SCAN_REPORT:
-		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
+		mwifiex_dbg(adapter, EVENT, "event: BGS_REPORT\n");
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_BG_SCAN_QUERY,
 				       HostCmd_ACT_GEN_GET, 0, NULL, false);
 		break;
 
 	case EVENT_PORT_RELEASE:
-		dev_dbg(adapter->dev, "event: PORT RELEASE\n");
+		mwifiex_dbg(adapter, EVENT, "event: PORT RELEASE\n");
 		break;
 
 	case EVENT_EXT_SCAN_REPORT:
-		dev_dbg(adapter->dev, "event: EXT_SCAN Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: EXT_SCAN Report\n");
 		if (adapter->ext_scan)
 			ret = mwifiex_handle_event_ext_scan_report(priv,
 						adapter->event_skb->data);
@@ -389,7 +392,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_WMM_STATUS_CHANGE:
-		dev_dbg(adapter->dev, "event: WMM status changed\n");
+		mwifiex_dbg(adapter, EVENT, "event: WMM status changed\n");
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
 				       0, 0, NULL, false);
 		break;
@@ -401,13 +404,13 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_LOW_RECVD;
-		dev_dbg(adapter->dev, "event: Beacon RSSI_LOW\n");
+		mwifiex_dbg(adapter, EVENT, "event: Beacon RSSI_LOW\n");
 		break;
 	case EVENT_SNR_LOW:
-		dev_dbg(adapter->dev, "event: Beacon SNR_LOW\n");
+		mwifiex_dbg(adapter, EVENT, "event: Beacon SNR_LOW\n");
 		break;
 	case EVENT_MAX_FAIL:
-		dev_dbg(adapter->dev, "event: MAX_FAIL\n");
+		mwifiex_dbg(adapter, EVENT, "event: MAX_FAIL\n");
 		break;
 	case EVENT_RSSI_HIGH:
 		cfg80211_cqm_rssi_notify(priv->netdev,
@@ -416,47 +419,47 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_HIGH_RECVD;
-		dev_dbg(adapter->dev, "event: Beacon RSSI_HIGH\n");
+		mwifiex_dbg(adapter, EVENT, "event: Beacon RSSI_HIGH\n");
 		break;
 	case EVENT_SNR_HIGH:
-		dev_dbg(adapter->dev, "event: Beacon SNR_HIGH\n");
+		mwifiex_dbg(adapter, EVENT, "event: Beacon SNR_HIGH\n");
 		break;
 	case EVENT_DATA_RSSI_LOW:
-		dev_dbg(adapter->dev, "event: Data RSSI_LOW\n");
+		mwifiex_dbg(adapter, EVENT, "event: Data RSSI_LOW\n");
 		break;
 	case EVENT_DATA_SNR_LOW:
-		dev_dbg(adapter->dev, "event: Data SNR_LOW\n");
+		mwifiex_dbg(adapter, EVENT, "event: Data SNR_LOW\n");
 		break;
 	case EVENT_DATA_RSSI_HIGH:
-		dev_dbg(adapter->dev, "event: Data RSSI_HIGH\n");
+		mwifiex_dbg(adapter, EVENT, "event: Data RSSI_HIGH\n");
 		break;
 	case EVENT_DATA_SNR_HIGH:
-		dev_dbg(adapter->dev, "event: Data SNR_HIGH\n");
+		mwifiex_dbg(adapter, EVENT, "event: Data SNR_HIGH\n");
 		break;
 	case EVENT_LINK_QUALITY:
-		dev_dbg(adapter->dev, "event: Link Quality\n");
+		mwifiex_dbg(adapter, EVENT, "event: Link Quality\n");
 		break;
 	case EVENT_PRE_BEACON_LOST:
-		dev_dbg(adapter->dev, "event: Pre-Beacon Lost\n");
+		mwifiex_dbg(adapter, EVENT, "event: Pre-Beacon Lost\n");
 		break;
 	case EVENT_IBSS_COALESCED:
-		dev_dbg(adapter->dev, "event: IBSS_COALESCED\n");
+		mwifiex_dbg(adapter, EVENT, "event: IBSS_COALESCED\n");
 		ret = mwifiex_send_cmd(priv,
 				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				HostCmd_ACT_GEN_GET, 0, NULL, false);
 		break;
 	case EVENT_ADDBA:
-		dev_dbg(adapter->dev, "event: ADDBA Request\n");
+		mwifiex_dbg(adapter, EVENT, "event: ADDBA Request\n");
 		mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
 				 HostCmd_ACT_GEN_SET, 0,
 				 adapter->event_body, false);
 		break;
 	case EVENT_DELBA:
-		dev_dbg(adapter->dev, "event: DELBA Request\n");
+		mwifiex_dbg(adapter, EVENT, "event: DELBA Request\n");
 		mwifiex_11n_delete_ba_stream(priv, adapter->event_body);
 		break;
 	case EVENT_BA_STREAM_TIEMOUT:
-		dev_dbg(adapter->dev, "event:  BA Stream timeout\n");
+		mwifiex_dbg(adapter, EVENT, "event:  BA Stream timeout\n");
 		mwifiex_11n_ba_stream_timeout(priv,
 					      (struct host_cmd_ds_11n_batimeout
 					       *)
@@ -464,28 +467,31 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
 		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
-		dev_dbg(adapter->dev, "event: AMSDU_AGGR_CTRL %d\n", ctrl);
+		mwifiex_dbg(adapter, EVENT,
+			    "event: AMSDU_AGGR_CTRL %d\n", ctrl);
 
 		adapter->tx_buf_size =
 				min_t(u16, adapter->curr_tx_buf_size, ctrl);
-		dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
-			adapter->tx_buf_size);
+		mwifiex_dbg(adapter, EVENT, "event: tx_buf_size %d\n",
+			    adapter->tx_buf_size);
 		break;
 
 	case EVENT_WEP_ICV_ERR:
-		dev_dbg(adapter->dev, "event: WEP ICV error\n");
+		mwifiex_dbg(adapter, EVENT, "event: WEP ICV error\n");
 		break;
 
 	case EVENT_BW_CHANGE:
-		dev_dbg(adapter->dev, "event: BW Change\n");
+		mwifiex_dbg(adapter, EVENT, "event: BW Change\n");
 		break;
 
 	case EVENT_HOSTWAKE_STAIE:
-		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
+		mwifiex_dbg(adapter, EVENT,
+			    "event: HOSTWAKE_STAIE %d\n", eventcause);
 		break;
 
 	case EVENT_REMAIN_ON_CHAN_EXPIRED:
-		dev_dbg(adapter->dev, "event: Remain on channel expired\n");
+		mwifiex_dbg(adapter, EVENT,
+			    "event: Remain on channel expired\n");
 		cfg80211_remain_on_channel_expired(&priv->wdev,
 						   priv->roc_cfg.cookie,
 						   &priv->roc_cfg.chan,
@@ -496,7 +502,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_CHANNEL_SWITCH_ANN:
-		dev_dbg(adapter->dev, "event: Channel Switch Announcement\n");
+		mwifiex_dbg(adapter, EVENT, "event: Channel Switch Announcement\n");
 		priv->csa_expire_time =
 				jiffies + msecs_to_jiffies(DFS_CHAN_MOVE_TIME);
 		priv->csa_chan = priv->curr_bss_params.bss_descriptor.channel;
@@ -511,23 +517,23 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_TX_STATUS_REPORT:
-		dev_dbg(adapter->dev, "event: TX_STATUS Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: TX_STATUS Report\n");
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
 		break;
 
 	case EVENT_CHANNEL_REPORT_RDY:
-		dev_dbg(adapter->dev, "event: Channel Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: Channel Report\n");
 		ret = mwifiex_11h_handle_chanrpt_ready(priv,
 						       adapter->event_skb);
 		break;
 	case EVENT_RADAR_DETECTED:
-		dev_dbg(adapter->dev, "event: Radar detected\n");
+		mwifiex_dbg(adapter, EVENT, "event: Radar detected\n");
 		ret = mwifiex_11h_handle_radar_detected(priv,
 							adapter->event_skb);
 		break;
 	default:
-		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
-			eventcause);
+		mwifiex_dbg(adapter, ERROR, "event: unknown event id: %#x\n",
+			    eventcause);
 		break;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a0bc26c..d8b7d9c 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -66,7 +66,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
 	if (status <= 0) {
 		if (status == 0)
 			status = -ETIMEDOUT;
-		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
+		mwifiex_dbg(adapter, ERROR,
+			    "cmd_wait_q terminated: %d\n", status);
 		mwifiex_cancel_all_pending_cmd(adapter);
 		return status;
 	}
@@ -93,7 +94,8 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	old_pkt_filter = priv->curr_pkt_filter;
 
 	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
-		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: Enable Promiscuous mode\n");
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
 		priv->curr_pkt_filter &=
 			~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
@@ -101,16 +103,16 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
 		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
-			dev_dbg(priv->adapter->dev,
-				"info: Enabling All Multicast!\n");
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
 				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			dev_dbg(priv->adapter->dev,
-				"info: Set multicast list=%d\n",
-				mcast_list->num_multicast_addr);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: Set multicast list=%d\n",
+				    mcast_list->num_multicast_addr);
 			/* Send multicast addresses to firmware */
 			ret = mwifiex_send_cmd(priv,
 					       HostCmd_CMD_MAC_MULTICAST_ADR,
@@ -118,9 +120,9 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 					       mcast_list, false);
 		}
 	}
-	dev_dbg(priv->adapter->dev,
-		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
-	       old_pkt_filter, priv->curr_pkt_filter);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
+		    old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
 		ret = mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 				       HostCmd_ACT_GEN_SET,
@@ -153,7 +155,8 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	rcu_read_unlock();
 
 	if (!beacon_ie) {
-		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    " failed to alloc beacon_ie\n");
 		return -ENOMEM;
 	}
 
@@ -167,7 +170,8 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	bss_desc->bss_band = bss_priv->band;
 	bss_desc->fw_tsf = bss_priv->fw_tsf;
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
-		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: InterpretIE: AP WEP enabled\n");
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
 	} else {
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
@@ -221,8 +225,8 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 
 	if (!strncmp(priv->adapter->country_code, &country_ie[2], 2)) {
 		rcu_read_unlock();
-		wiphy_dbg(priv->wdev.wiphy,
-			  "11D: skip setting domain info in FW\n");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "11D: skip setting domain info in FW\n");
 		return 0;
 	}
 	memcpy(priv->adapter->country_code, &country_ie[2], 2);
@@ -243,8 +247,8 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
 			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
-		wiphy_err(priv->adapter->wiphy,
-			  "11D: setting domain info in FW\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "11D: setting domain info in FW fail\n");
 		return -1;
 	}
 
@@ -306,14 +310,15 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (mwifiex_11h_get_csa_closed_channel(priv) ==
 							(u8)bss_desc->channel) {
-			dev_err(adapter->dev,
-				"Attempt to reconnect on csa closed chan(%d)\n",
-				bss_desc->channel);
+			mwifiex_dbg(adapter, ERROR,
+				    "Attempt to reconnect on csa closed chan(%d)\n",
+				    bss_desc->channel);
 			goto done;
 		}
 
-		dev_dbg(adapter->dev, "info: SSID found in scan list ... "
-				      "associating...\n");
+		mwifiex_dbg(adapter, INFO,
+			    "info: SSID found in scan list ...\t"
+			    "associating...\n");
 
 		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 		if (netif_carrier_ok(priv->netdev))
@@ -355,15 +360,17 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			netif_carrier_off(priv->netdev);
 
 		if (!ret) {
-			dev_dbg(adapter->dev, "info: network found in scan"
-							" list. Joining...\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: network found in scan\t"
+				    " list. Joining...\n");
 			ret = mwifiex_adhoc_join(priv, bss_desc);
 			if (bss)
 				cfg80211_put_bss(priv->adapter->wiphy, bss);
 		} else {
-			dev_dbg(adapter->dev, "info: Network not found in "
-				"the list, creating adhoc with ssid = %s\n",
-				req_ssid->ssid);
+			mwifiex_dbg(adapter, INFO,
+				    "info: Network not found in\t"
+				    "the list, creating adhoc with ssid = %s\n",
+				    req_ssid->ssid);
 			ret = mwifiex_adhoc_start(priv, req_ssid);
 		}
 	}
@@ -398,8 +405,9 @@ int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
 		if (adapter->pps_uapsd_mode) {
-			dev_dbg(adapter->dev, "info: Host Sleep IOCTL"
-				" is blocked in UAPSD/PPS mode\n");
+			mwifiex_dbg(adapter, INFO,
+				    "info: Host Sleep IOCTL\t"
+				    "is blocked in UAPSD/PPS mode\n");
 			status = -1;
 			break;
 		}
@@ -496,7 +504,8 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->hs_activated) {
-		dev_dbg(adapter->dev, "cmd: HS Already activated\n");
+		mwifiex_dbg(adapter, CMD,
+			    "cmd: HS Already activated\n");
 		return true;
 	}
 
@@ -512,14 +521,16 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 						   MWIFIEX_BSS_ROLE_STA),
 				  HostCmd_ACT_GEN_SET, MWIFIEX_SYNC_CMD,
 				  &hscfg)) {
-		dev_err(adapter->dev, "IOCTL request HS enable failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "IOCTL request HS enable failed\n");
 		return false;
 	}
 
 	if (wait_event_interruptible_timeout(adapter->hs_activate_wait_q,
 					     adapter->hs_activate_wait_q_woken,
 					     (10 * HZ)) <= 0) {
-		dev_err(adapter->dev, "hs_activate_wait_q terminated\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "hs_activate_wait_q terminated\n");
 		return false;
 	}
 
@@ -639,10 +650,11 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		dbm = (u16) power_cfg->power_level;
 		if ((dbm < priv->min_tx_power_level) ||
 		    (dbm > priv->max_tx_power_level)) {
-			dev_err(priv->adapter->dev, "txpower value %d dBm"
-				" is out of range (%d dBm-%d dBm)\n",
-				dbm, priv->min_tx_power_level,
-				priv->max_tx_power_level);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "txpower value %d dBm\t"
+				    "is out of range (%d dBm-%d dBm)\n",
+				    dbm, priv->min_tx_power_level,
+				    priv->max_tx_power_level);
 			return -1;
 		}
 	}
@@ -741,14 +753,15 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 {
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wpa_ie)) {
-			dev_err(priv->adapter->dev,
-				"failed to copy WPA IE, too big\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "failed to copy WPA IE, too big\n");
 			return -1;
 		}
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
 		priv->wpa_ie_len = (u8) ie_len;
-		dev_dbg(priv->adapter->dev, "cmd: Set Wpa_ie_len=%d IE=%#x\n",
-			priv->wpa_ie_len, priv->wpa_ie[0]);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: Set Wpa_ie_len=%d IE=%#x\n",
+			    priv->wpa_ie_len, priv->wpa_ie[0]);
 
 		if (priv->wpa_ie[0] == WLAN_EID_VENDOR_SPECIFIC) {
 			priv->sec_info.wpa_enabled = true;
@@ -761,8 +774,9 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 	} else {
 		memset(priv->wpa_ie, 0, sizeof(priv->wpa_ie));
 		priv->wpa_ie_len = 0;
-		dev_dbg(priv->adapter->dev, "info: reset wpa_ie_len=%d IE=%#x\n",
-			priv->wpa_ie_len, priv->wpa_ie[0]);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: reset wpa_ie_len=%d IE=%#x\n",
+			    priv->wpa_ie_len, priv->wpa_ie[0]);
 		priv->sec_info.wpa_enabled = false;
 		priv->sec_info.wpa2_enabled = false;
 	}
@@ -782,23 +796,24 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
 {
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wapi_ie)) {
-			dev_dbg(priv->adapter->dev,
-				"info: failed to copy WAPI IE, too big\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "info: failed to copy WAPI IE, too big\n");
 			return -1;
 		}
 		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
 		priv->wapi_ie_len = ie_len;
-		dev_dbg(priv->adapter->dev, "cmd: Set wapi_ie_len=%d IE=%#x\n",
-			priv->wapi_ie_len, priv->wapi_ie[0]);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: Set wapi_ie_len=%d IE=%#x\n",
+			    priv->wapi_ie_len, priv->wapi_ie[0]);
 
 		if (priv->wapi_ie[0] == WLAN_EID_BSS_AC_ACCESS_DELAY)
 			priv->sec_info.wapi_enabled = true;
 	} else {
 		memset(priv->wapi_ie, 0, sizeof(priv->wapi_ie));
 		priv->wapi_ie_len = ie_len;
-		dev_dbg(priv->adapter->dev,
-			"info: Reset wapi_ie_len=%d IE=%#x\n",
-		       priv->wapi_ie_len, priv->wapi_ie[0]);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: Reset wapi_ie_len=%d IE=%#x\n",
+			    priv->wapi_ie_len, priv->wapi_ie[0]);
 		priv->sec_info.wapi_enabled = false;
 	}
 	return 0;
@@ -816,8 +831,8 @@ static int mwifiex_set_wps_ie(struct mwifiex_private *priv,
 {
 	if (ie_len) {
 		if (ie_len > MWIFIEX_MAX_VSIE_LEN) {
-			dev_dbg(priv->adapter->dev,
-				"info: failed to copy WPS IE, too big\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "info: failed to copy WPS IE, too big\n");
 			return -1;
 		}
 
@@ -827,13 +842,14 @@ static int mwifiex_set_wps_ie(struct mwifiex_private *priv,
 
 		memcpy(priv->wps_ie, ie_data_ptr, ie_len);
 		priv->wps_ie_len = ie_len;
-		dev_dbg(priv->adapter->dev, "cmd: Set wps_ie_len=%d IE=%#x\n",
-			priv->wps_ie_len, priv->wps_ie[0]);
+		mwifiex_dbg(priv->adapter, CMD,
+			    "cmd: Set wps_ie_len=%d IE=%#x\n",
+			    priv->wps_ie_len, priv->wps_ie[0]);
 	} else {
 		kfree(priv->wps_ie);
 		priv->wps_ie_len = ie_len;
-		dev_dbg(priv->adapter->dev,
-			"info: Reset wps_ie_len=%d\n", priv->wps_ie_len);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: Reset wps_ie_len=%d\n", priv->wps_ie_len);
 	}
 	return 0;
 }
@@ -877,8 +893,8 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
-			dev_err(adapter->dev,
-				"key not set, so cannot enable it\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "key not set, so cannot enable it\n");
 			return -1;
 		}
 
@@ -955,7 +971,8 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > WLAN_MAX_KEY_LEN) {
-		dev_err(priv->adapter->dev, "key length too long\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "key length too long\n");
 		return -1;
 	}
 
@@ -1042,7 +1059,7 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-	dev_dbg(adapter->dev, "info: MWIFIEX VERSION: %s\n", version);
+	mwifiex_dbg(adapter, MSG, "info: MWIFIEX VERSION: %s\n", version);
 
 	return 0;
 }
@@ -1130,7 +1147,8 @@ mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 	}
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_REMAIN_ON_CHAN,
 			     action, 0, &roc_cfg, true)) {
-		dev_err(priv->adapter->dev, "failed to remain on channel\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "failed to remain on channel\n");
 		return -1;
 	}
 
@@ -1315,8 +1333,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
 		    (!memcmp(pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
 			priv->wps.session_enable = true;
-			dev_dbg(priv->adapter->dev,
-				"info: WPS Session Enabled.\n");
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: WPS Session Enabled.\n");
 			ret = mwifiex_set_wps_ie(priv, ie_data_ptr, ie_len);
 		}
 
@@ -1363,7 +1381,8 @@ static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		memset(adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
 			adapter->arp_filter_size = 0;
-			dev_err(adapter->dev, "invalid ARP filter size\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "invalid ARP filter size\n");
 			return -1;
 		} else {
 			memcpy(adapter->arp_filter, gen_ie->ie_data,
@@ -1372,7 +1391,7 @@ static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		}
 		break;
 	default:
-		dev_err(adapter->dev, "invalid IE type\n");
+		mwifiex_dbg(adapter, ERROR, "invalid IE type\n");
 		return -1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index b8729c9..d4d4cb1 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -141,7 +141,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 
 	if (priv->hs2_enabled &&
 	    mwifiex_discard_gratuitous_arp(priv, skb)) {
-		dev_dbg(priv->adapter->dev, "Bypassed Gratuitous ARP\n");
+		mwifiex_dbg(priv->adapter, INFO, "Bypassed Gratuitous ARP\n");
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
@@ -166,7 +166,8 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 
 	ret = mwifiex_recv_packet(priv, skb);
 	if (ret == -1)
-		dev_err(priv->adapter->dev, "recv packet failed\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "recv packet failed\n");
 
 	return ret;
 }
@@ -203,9 +204,9 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_offset;
 
 	if ((rx_pkt_offset + rx_pkt_length) > (u16) skb->len) {
-		dev_err(adapter->dev,
-			"wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
-			skb->len, rx_pkt_offset, rx_pkt_length);
+		mwifiex_dbg(adapter, ERROR,
+			    "wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
+			    skb->len, rx_pkt_offset, rx_pkt_length);
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
 		return ret;
@@ -214,7 +215,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
-			dev_err(adapter->dev, "Rx of mgmt packet failed");
+			mwifiex_dbg(adapter, ERROR, "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 5ce2d9a..355ac59 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -53,7 +53,8 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		       INTF_HEADER_LEN;
 
 	if (!skb->len) {
-		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
+		mwifiex_dbg(adapter, ERROR,
+			    "Tx: bad packet length: %d\n", skb->len);
 		tx_info->status_code = -1;
 		return skb->data;
 	}
@@ -184,21 +185,24 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	switch (ret) {
 	case -EBUSY:
 		dev_kfree_skb_any(skb);
-		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
-			__func__, ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: host_to_card failed: ret=%d\n",
+			    __func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case -1:
 		adapter->data_sent = false;
 		dev_kfree_skb_any(skb);
-		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
-			__func__, ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: host_to_card failed: ret=%d\n",
+			    __func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case 0:
 		dev_kfree_skb_any(skb);
-		dev_dbg(adapter->dev, "data: %s: host_to_card succeeded\n",
-			__func__);
+		mwifiex_dbg(adapter, DATA,
+			    "data: %s: host_to_card succeeded\n",
+			    __func__);
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 275a476..2faa1bc 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -37,7 +37,7 @@ static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
 	u32 tid;
 	u8 tid_down;
 
-	dev_dbg(priv->adapter->dev, "%s: %pM\n", __func__, mac);
+	mwifiex_dbg(priv->adapter, DATA, "%s: %pM\n", __func__, mac);
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp) {
@@ -94,7 +94,7 @@ static void mwifiex_hold_tdls_packets(struct mwifiex_private *priv,
 	unsigned long flags;
 	int i;
 
-	dev_dbg(priv->adapter->dev, "%s: %pM\n", __func__, mac);
+	mwifiex_dbg(priv->adapter, DATA, "%s: %pM\n", __func__, mac);
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 	for (i = 0; i < MAX_NUM_TID; i++) {
@@ -132,8 +132,8 @@ mwifiex_tdls_append_rates_ie(struct mwifiex_private *priv,
 	supp_rates_size = min_t(u16, rates_size, MWIFIEX_TDLS_SUPPORTED_RATES);
 
 	if (skb_tailroom(skb) < rates_size + 4) {
-		dev_err(priv->adapter->dev,
-			"Insuffient space while adding rates\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Insuffient space while adding rates\n");
 		return -ENOMEM;
 	}
 
@@ -199,8 +199,8 @@ mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, const u8 *mac,
 
 	sta_ptr = mwifiex_get_sta_entry(priv, mac);
 	if (unlikely(!sta_ptr)) {
-		dev_warn(priv->adapter->dev,
-			 "TDLS peer station not found in list\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "TDLS peer station not found in list\n");
 		return -1;
 	}
 
@@ -247,15 +247,16 @@ static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
 
 	sta_ptr = mwifiex_get_sta_entry(priv, mac);
 	if (unlikely(!sta_ptr)) {
-		dev_warn(adapter->dev, "TDLS peer station not found in list\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "TDLS peer station not found in list\n");
 		return -1;
 	}
 
 	if (!mwifiex_is_bss_in_11ac_mode(priv)) {
 		if (sta_ptr->tdls_cap.extcap.ext_capab[7] &
 		   WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED) {
-			dev_dbg(adapter->dev,
-				"TDLS peer doesn't support wider bandwidth\n");
+			mwifiex_dbg(adapter, WARN,
+				    "TDLS peer doesn't support wider bandwidth\n");
 			return 0;
 		}
 	} else {
@@ -554,7 +555,7 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 		tf->u.discover_req.dialog_token = dialog_token;
 		break;
 	default:
-		dev_err(priv->adapter->dev, "Unknown TDLS frame type.\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS frame type.\n");
 		return -EINVAL;
 	}
 
@@ -608,8 +609,8 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 
 	skb = dev_alloc_skb(skb_len);
 	if (!skb) {
-		dev_err(priv->adapter->dev,
-			"allocate skb failed for management frame\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "allocate skb failed for management frame\n");
 		return -ENOMEM;
 	}
 	skb_reserve(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
@@ -742,7 +743,7 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv,
 		mwifiex_tdls_add_qos_capab(skb);
 		break;
 	default:
-		dev_err(priv->adapter->dev, "Unknown TDLS action frame type\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS action frame type\n");
 		return -EINVAL;
 	}
 
@@ -781,8 +782,8 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 
 	skb = dev_alloc_skb(skb_len);
 	if (!skb) {
-		dev_err(priv->adapter->dev,
-			"allocate skb failed for management frame\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "allocate skb failed for management frame\n");
 		return -ENOMEM;
 	}
 
@@ -848,8 +849,8 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 	peer = buf + ETH_ALEN;
 	action = *(buf + sizeof(struct ethhdr) + 2);
-	dev_dbg(priv->adapter->dev,
-		"rx:tdls action: peer=%pM, action=%d\n", peer, action);
+	mwifiex_dbg(priv->adapter, DATA,
+		    "rx:tdls action: peer=%pM, action=%d\n", peer, action);
 
 	switch (action) {
 	case WLAN_TDLS_SETUP_REQUEST:
@@ -880,7 +881,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 		ie_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
 		break;
 	default:
-		dev_dbg(priv->adapter->dev, "Unknown TDLS frame type.\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS frame type.\n");
 		return;
 	}
 
@@ -967,8 +968,8 @@ mwifiex_tdls_process_config_link(struct mwifiex_private *priv, const u8 *peer)
 	sta_ptr = mwifiex_get_sta_entry(priv, peer);
 
 	if (!sta_ptr || sta_ptr->tdls_status == TDLS_SETUP_FAILURE) {
-		dev_err(priv->adapter->dev,
-			"link absent for peer %pM; cannot config\n", peer);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "link absent for peer %pM; cannot config\n", peer);
 		return -EINVAL;
 	}
 
@@ -988,8 +989,8 @@ mwifiex_tdls_process_create_link(struct mwifiex_private *priv, const u8 *peer)
 	sta_ptr = mwifiex_get_sta_entry(priv, peer);
 
 	if (sta_ptr && sta_ptr->tdls_status == TDLS_SETUP_INPROGRESS) {
-		dev_dbg(priv->adapter->dev,
-			"Setup already in progress for peer %pM\n", peer);
+		mwifiex_dbg(priv->adapter, WARN,
+			    "Setup already in progress for peer %pM\n", peer);
 		return 0;
 	}
 
@@ -1046,8 +1047,8 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 	sta_ptr = mwifiex_get_sta_entry(priv, peer);
 
 	if (sta_ptr && (sta_ptr->tdls_status != TDLS_SETUP_FAILURE)) {
-		dev_dbg(priv->adapter->dev,
-			"tdls: enable link %pM success\n", peer);
+		mwifiex_dbg(priv->adapter, MSG,
+			    "tdls: enable link %pM success\n", peer);
 
 		sta_ptr->tdls_status = TDLS_SETUP_COMPLETE;
 
@@ -1076,8 +1077,8 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 		mwifiex_auto_tdls_update_peer_status(priv, peer,
 						     TDLS_SETUP_COMPLETE);
 	} else {
-		dev_dbg(priv->adapter->dev,
-			"tdls: enable link %pM failed\n", peer);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tdls: enable link %pM failed\n", peer);
 		if (sta_ptr) {
 			mwifiex_11n_cleanup_reorder_tbl(priv);
 			spin_lock_irqsave(&priv->wmm.ra_list_spinlock,
@@ -1180,9 +1181,9 @@ void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv)
 		tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
 		if (mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_OPER,
 				     HostCmd_ACT_GEN_SET, 0, &tdls_oper, false))
-			dev_warn(priv->adapter->dev,
-				 "Disable link failed for TDLS peer %pM",
-				 sta_ptr->mac_addr);
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Disable link failed for TDLS peer %pM",
+				    sta_ptr->mac_addr);
 	}
 
 	mwifiex_del_all_sta_list(priv);
@@ -1204,9 +1205,9 @@ int mwifiex_tdls_check_tx(struct mwifiex_private *priv, struct sk_buff *skb)
 			    (peer->failure_count <
 			     MWIFIEX_TDLS_MAX_FAIL_COUNT)) {
 				peer->tdls_status = TDLS_SETUP_INPROGRESS;
-				dev_dbg(priv->adapter->dev,
-					"setup TDLS link, peer=%pM rssi=%d\n",
-					peer->mac_addr, peer->rssi);
+				mwifiex_dbg(priv->adapter, INFO,
+					    "setup TDLS link, peer=%pM rssi=%d\n",
+					    peer->mac_addr, peer->rssi);
 
 				cfg80211_tdls_oper_request(priv->netdev,
 							   peer->mac_addr,
@@ -1272,8 +1273,8 @@ void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac)
 		tdls_peer->rssi_jiffies = jiffies;
 		INIT_LIST_HEAD(&tdls_peer->list);
 		list_add_tail(&tdls_peer->list, &priv->auto_tdls_list);
-		dev_dbg(priv->adapter->dev, "Add auto TDLS peer= %pM to list\n",
-			mac);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "Add auto TDLS peer= %pM to list\n", mac);
 	}
 
 	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
@@ -1341,8 +1342,8 @@ void mwifiex_check_auto_tdls(unsigned long context)
 		return;
 
 	if (!priv->auto_tdls_timer_active) {
-		dev_dbg(priv->adapter->dev,
-			"auto TDLS timer inactive; return");
+		mwifiex_dbg(priv->adapter, INFO,
+			    "auto TDLS timer inactive; return");
 		return;
 	}
 
@@ -1368,9 +1369,9 @@ void mwifiex_check_auto_tdls(unsigned long context)
 		     !tdls_peer->rssi) &&
 		    tdls_peer->tdls_status == TDLS_SETUP_COMPLETE) {
 			tdls_peer->tdls_status = TDLS_LINK_TEARDOWN;
-			dev_dbg(priv->adapter->dev,
-				"teardown TDLS link,peer=%pM rssi=%d\n",
-				tdls_peer->mac_addr, -tdls_peer->rssi);
+			mwifiex_dbg(priv->adapter, MSG,
+				    "teardown TDLS link,peer=%pM rssi=%d\n",
+				    tdls_peer->mac_addr, -tdls_peer->rssi);
 			tdls_peer->do_discover = true;
 			priv->check_tdls_tx = true;
 			cfg80211_tdls_oper_request(priv->netdev,
@@ -1384,9 +1385,10 @@ void mwifiex_check_auto_tdls(unsigned long context)
 			   MWIFIEX_TDLS_MAX_FAIL_COUNT) {
 				priv->check_tdls_tx = true;
 				tdls_peer->do_setup = true;
-				dev_dbg(priv->adapter->dev,
-					"check TDLS with peer=%pM rssi=%d\n",
-					tdls_peer->mac_addr, -tdls_peer->rssi);
+				mwifiex_dbg(priv->adapter, INFO,
+					    "check TDLS with peer=%pM\t"
+					    "rssi=%d\n", tdls_peer->mac_addr,
+					    tdls_peer->rssi);
 		}
 	}
 	spin_unlock_irqrestore(&priv->auto_tdls_lock, flags);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 73082b5..28dcc84 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -50,7 +50,8 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
 	if (!priv) {
-		dev_err(adapter->dev, "data: priv not found. Drop RX packet\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "data: priv not found. Drop RX packet\n");
 		dev_kfree_skb_any(skb);
 		return -1;
 	}
@@ -120,7 +121,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 
 	switch (ret) {
 	case -ENOSR:
-		dev_dbg(adapter->dev, "data: -ENOSR is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -ENOSR is returned\n");
 		break;
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
@@ -129,13 +130,14 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 				if (local_tx_pd)
 					local_tx_pd->flags = 0;
 		}
-		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
 		if (adapter->iface_type != MWIFIEX_PCIE)
 			adapter->data_sent = false;
-		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
-			ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "mwifiex_write_data_async failed: 0x%X\n",
+			    ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
@@ -167,7 +169,8 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 	priv = mwifiex_get_priv_by_id(adapter, tx_info->bss_num,
 				      tx_info->bss_type);
 	if (!priv) {
-		dev_err(adapter->dev, "data: priv not found. Drop TX packet\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "data: priv not found. Drop TX packet\n");
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, 0);
 		return ret;
@@ -192,7 +195,7 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 	}
 	switch (ret) {
 	case -ENOSR:
-		dev_err(adapter->dev, "data: -ENOSR is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -ENOSR is returned\n");
 		break;
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
@@ -207,13 +210,13 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 			atomic_add(tx_info->aggr_num, &adapter->tx_queued);
 		else
 			atomic_inc(&adapter->tx_queued);
-		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
 		if (adapter->iface_type != MWIFIEX_PCIE)
 			adapter->data_sent = false;
-		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
-			ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "mwifiex_write_data_async failed: 0x%X\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
@@ -324,7 +327,7 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		txq = netdev_get_tx_queue(priv->netdev, index);
 		if (netif_tx_queue_stopped(txq)) {
 			netif_tx_wake_queue(txq);
-			dev_dbg(adapter->dev, "wake queue: %d\n", index);
+			mwifiex_dbg(adapter, DATA, "wake queue: %d\n", index);
 		}
 	}
 done:
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 3d02811..a4ae283 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -184,8 +184,8 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
 			break;
 		default:
-			dev_warn(priv->adapter->dev,
-				 "Unsupported RX-STBC, default to 2x2\n");
+			mwifiex_dbg(priv->adapter, WARN,
+				    "Unsupported RX-STBC, default to 2x2\n");
 			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
 			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
 			break;
@@ -767,8 +767,8 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 			return -1;
 		break;
 	default:
-		dev_err(priv->adapter->dev,
-			"PREP_CMD: unknown cmd %#x\n", cmd_no);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "PREP_CMD: unknown cmd %#x\n", cmd_no);
 		return -1;
 	}
 
@@ -806,24 +806,28 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 			     struct mwifiex_uap_bss_param *bss_cfg)
 {
 	if (mwifiex_del_mgmt_ies(priv))
-		dev_err(priv->adapter->dev, "Failed to delete mgmt IEs!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to delete mgmt IEs!\n");
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		dev_err(priv->adapter->dev, "Failed to stop the BSS\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to stop the BSS\n");
 		return -1;
 	}
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
 			     HostCmd_ACT_GEN_SET,
 			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
-		dev_err(priv->adapter->dev, "Failed to set the SSID\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to set the SSID\n");
 		return -1;
 	}
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
 			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
-		dev_err(priv->adapter->dev, "Failed to start the BSS\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to start the BSS\n");
 		return -1;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index f4794cd..06ce3fe 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -80,8 +80,8 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 
 		node = mwifiex_add_sta_entry(priv, event->sta_addr);
 		if (!node) {
-			dev_warn(adapter->dev,
-				 "could not create station entry!\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "could not create station entry!\n");
 			return -1;
 		}
 
@@ -128,7 +128,8 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 	case EVENT_UAP_BSS_START:
-		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		mwifiex_dbg(adapter, EVENT,
+			    "AP EVENT: event id: %#x\n", eventcause);
 		memcpy(priv->netdev->dev_addr, adapter->event_body + 2,
 		       ETH_ALEN);
 		if (priv->hist_data)
@@ -136,50 +137,53 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_UAP_MIC_COUNTERMEASURES:
 		/* For future development */
-		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
+		mwifiex_dbg(adapter, EVENT,
+			    "AP EVENT: event id: %#x\n", eventcause);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
 		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
-		dev_dbg(adapter->dev, "event: AMSDU_AGGR_CTRL %d\n", ctrl);
+		mwifiex_dbg(adapter, EVENT,
+			    "event: AMSDU_AGGR_CTRL %d\n", ctrl);
 
 		if (priv->media_connected) {
 			adapter->tx_buf_size =
 				min_t(u16, adapter->curr_tx_buf_size, ctrl);
-			dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
-				adapter->tx_buf_size);
+			mwifiex_dbg(adapter, EVENT,
+				    "event: tx_buf_size %d\n",
+				    adapter->tx_buf_size);
 		}
 		break;
 	case EVENT_ADDBA:
-		dev_dbg(adapter->dev, "event: ADDBA Request\n");
+		mwifiex_dbg(adapter, EVENT, "event: ADDBA Request\n");
 		if (priv->media_connected)
 			mwifiex_send_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
 					 HostCmd_ACT_GEN_SET, 0,
 					 adapter->event_body, false);
 		break;
 	case EVENT_DELBA:
-		dev_dbg(adapter->dev, "event: DELBA Request\n");
+		mwifiex_dbg(adapter, EVENT, "event: DELBA Request\n");
 		if (priv->media_connected)
 			mwifiex_11n_delete_ba_stream(priv, adapter->event_body);
 		break;
 	case EVENT_BA_STREAM_TIEMOUT:
-		dev_dbg(adapter->dev, "event:  BA Stream timeout\n");
+		mwifiex_dbg(adapter, EVENT, "event:  BA Stream timeout\n");
 		if (priv->media_connected) {
 			ba_timeout = (void *)adapter->event_body;
 			mwifiex_11n_ba_stream_timeout(priv, ba_timeout);
 		}
 		break;
 	case EVENT_EXT_SCAN_REPORT:
-		dev_dbg(adapter->dev, "event: EXT_SCAN Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: EXT_SCAN Report\n");
 		if (adapter->ext_scan)
 			return mwifiex_handle_event_ext_scan_report(priv,
 						adapter->event_skb->data);
 		break;
 	case EVENT_TX_STATUS_REPORT:
-		dev_dbg(adapter->dev, "event: TX_STATUS Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: TX_STATUS Report\n");
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
 		break;
 	case EVENT_PS_SLEEP:
-		dev_dbg(adapter->dev, "info: EVENT: SLEEP\n");
+		mwifiex_dbg(adapter, EVENT, "info: EVENT: SLEEP\n");
 
 		adapter->ps_state = PS_STATE_PRE_SLEEP;
 
@@ -187,12 +191,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_PS_AWAKE:
-		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
+		mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
 		if (!adapter->pps_uapsd_mode &&
 		    priv->media_connected && adapter->sleep_period.period) {
 				adapter->pps_uapsd_mode = true;
-				dev_dbg(adapter->dev,
-					"event: PPS/UAPSD mode activated\n");
+				mwifiex_dbg(adapter, EVENT,
+					    "event: PPS/UAPSD mode activated\n");
 		}
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
@@ -218,16 +222,16 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_CHANNEL_REPORT_RDY:
-		dev_dbg(adapter->dev, "event: Channel Report\n");
+		mwifiex_dbg(adapter, EVENT, "event: Channel Report\n");
 		mwifiex_11h_handle_chanrpt_ready(priv, adapter->event_skb);
 		break;
 	case EVENT_RADAR_DETECTED:
-		dev_dbg(adapter->dev, "event: Radar detected\n");
+		mwifiex_dbg(adapter, EVENT, "event: Radar detected\n");
 		mwifiex_11h_handle_radar_detected(priv, adapter->event_skb);
 		break;
 	default:
-		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
-			eventcause);
+		mwifiex_dbg(adapter, EVENT,
+			    "event: unknown event id: %#x\n", eventcause);
 		break;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 38ac4d7..61c52fd 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -103,8 +103,8 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 
 	if ((atomic_read(&adapter->pending_bridged_pkts) >=
 					     MWIFIEX_BRIDGED_PKTS_THR_HIGH)) {
-		dev_err(priv->adapter->dev,
-			"Tx: Bridge packet limit reached. Drop packet!\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Tx: Bridge packet limit reached. Drop packet!\n");
 		kfree_skb(skb);
 		mwifiex_uap_cleanup_tx_queues(priv);
 		return;
@@ -153,15 +153,15 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	skb_pull(skb, hdr_chop);
 
 	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
-		dev_dbg(priv->adapter->dev,
-			"data: Tx: insufficient skb headroom %d\n",
-			skb_headroom(skb));
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "data: Tx: insufficient skb headroom %d\n",
+			    skb_headroom(skb));
 		/* Insufficient skb headroom - allocate a new skb */
 		new_skb =
 			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
 		if (unlikely(!new_skb)) {
-			dev_err(priv->adapter->dev,
-				"Tx: cannot allocate new_skb\n");
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Tx: cannot allocate new_skb\n");
 			kfree_skb(skb);
 			priv->stats.tx_dropped++;
 			return;
@@ -169,8 +169,9 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 
 		kfree_skb(skb);
 		skb = new_skb;
-		dev_dbg(priv->adapter->dev, "info: new skb headroom %d\n",
-			skb_headroom(skb));
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: new skb headroom %d\n",
+			    skb_headroom(skb));
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
@@ -225,7 +226,8 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
 
 	/* don't do packet forwarding in disconnected state */
 	if (!priv->media_connected) {
-		dev_err(adapter->dev, "drop packet in disconnected state.\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "drop packet in disconnected state.\n");
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
@@ -275,10 +277,10 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 
 	if ((le16_to_cpu(uap_rx_pd->rx_pkt_offset) +
 	     le16_to_cpu(uap_rx_pd->rx_pkt_length)) > (u16) skb->len) {
-		dev_err(adapter->dev,
-			"wrong rx packet: len=%d, offset=%d, length=%d\n",
-			skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset),
-			le16_to_cpu(uap_rx_pd->rx_pkt_length));
+		mwifiex_dbg(adapter, ERROR,
+			    "wrong rx packet: len=%d, offset=%d, length=%d\n",
+			    skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset),
+			    le16_to_cpu(uap_rx_pd->rx_pkt_length));
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
 		return 0;
@@ -287,7 +289,8 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
-			dev_err(adapter->dev, "Rx of mgmt packet failed");
+			mwifiex_dbg(adapter, ERROR,
+				    "Rx of mgmt packet failed");
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
@@ -354,7 +357,8 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 		       INTF_HEADER_LEN;
 
 	if (!skb->len) {
-		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
+		mwifiex_dbg(adapter, ERROR,
+			    "Tx: bad packet length: %d\n", skb->len);
 		tx_info->status_code = -1;
 		return skb->data;
 	}
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index fd8027f..aada934 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -60,7 +60,6 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size);
 static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			    struct sk_buff *skb, u8 ep)
 {
-	struct device *dev = adapter->dev;
 	u32 recv_type;
 	__le32 tmp;
 	int ret;
@@ -69,13 +68,15 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		mwifiex_process_hs_config(adapter);
 
 	if (skb->len < INTF_HEADER_LEN) {
-		dev_err(dev, "%s: invalid skb->len\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: invalid skb->len\n", __func__);
 		return -1;
 	}
 
 	switch (ep) {
 	case MWIFIEX_USB_EP_CMD_EVENT:
-		dev_dbg(dev, "%s: EP_CMD_EVENT\n", __func__);
+		mwifiex_dbg(adapter, EVENT,
+			    "%s: EP_CMD_EVENT\n", __func__);
 		skb_copy_from_linear_data(skb, &tmp, INTF_HEADER_LEN);
 		recv_type = le32_to_cpu(tmp);
 		skb_pull(skb, INTF_HEADER_LEN);
@@ -83,11 +84,12 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		switch (recv_type) {
 		case MWIFIEX_USB_TYPE_CMD:
 			if (skb->len > MWIFIEX_SIZE_OF_CMD_BUFFER) {
-				dev_err(dev, "CMD: skb->len too large\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "CMD: skb->len too large\n");
 				ret = -1;
 				goto exit_restore_skb;
 			} else if (!adapter->curr_cmd) {
-				dev_dbg(dev, "CMD: no curr_cmd\n");
+				mwifiex_dbg(adapter, WARN, "CMD: no curr_cmd\n");
 				if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 					mwifiex_process_sleep_confirm_resp(
 							adapter, skb->data,
@@ -104,16 +106,19 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			break;
 		case MWIFIEX_USB_TYPE_EVENT:
 			if (skb->len < sizeof(u32)) {
-				dev_err(dev, "EVENT: skb->len too small\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "EVENT: skb->len too small\n");
 				ret = -1;
 				goto exit_restore_skb;
 			}
 			skb_copy_from_linear_data(skb, &tmp, sizeof(u32));
 			adapter->event_cause = le32_to_cpu(tmp);
-			dev_dbg(dev, "event_cause %#x\n", adapter->event_cause);
+			mwifiex_dbg(adapter, EVENT,
+				    "event_cause %#x\n", adapter->event_cause);
 
 			if (skb->len > MAX_EVENT_SIZE) {
-				dev_err(dev, "EVENT: event body too large\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "EVENT: event body too large\n");
 				ret = -1;
 				goto exit_restore_skb;
 			}
@@ -125,14 +130,16 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			adapter->event_skb = skb;
 			break;
 		default:
-			dev_err(dev, "unknown recv_type %#x\n", recv_type);
+			mwifiex_dbg(adapter, ERROR,
+				    "unknown recv_type %#x\n", recv_type);
 			return -1;
 		}
 		break;
 	case MWIFIEX_USB_EP_DATA:
-		dev_dbg(dev, "%s: EP_DATA\n", __func__);
+		mwifiex_dbg(adapter, DATA, "%s: EP_DATA\n", __func__);
 		if (skb->len > MWIFIEX_RX_DATA_BUF_SIZE) {
-			dev_err(dev, "DATA: skb->len too large\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "DATA: skb->len too large\n");
 			return -1;
 		}
 
@@ -141,7 +148,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		atomic_inc(&adapter->rx_pending);
 		break;
 	default:
-		dev_err(dev, "%s: unknown endport %#x\n", __func__, ep);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: unknown endport %#x\n", __func__, ep);
 		return -1;
 	}
 
@@ -176,8 +184,8 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 
 	if (recv_length) {
 		if (urb->status || (adapter->surprise_removed)) {
-			dev_err(adapter->dev,
-				"URB status is failed: %d\n", urb->status);
+			mwifiex_dbg(adapter, ERROR,
+				    "URB status is failed: %d\n", urb->status);
 			/* Do not free skb in case of command ep */
 			if (card->rx_cmd_ep != context->ep)
 				dev_kfree_skb_any(skb);
@@ -190,8 +198,9 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 
 		status = mwifiex_usb_recv(adapter, skb, context->ep);
 
-		dev_dbg(adapter->dev, "info: recv_length=%d, status=%d\n",
-			recv_length, status);
+		mwifiex_dbg(adapter, INFO,
+			    "info: recv_length=%d, status=%d\n",
+			    recv_length, status);
 		if (status == -EINPROGRESS) {
 			mwifiex_queue_main_work(adapter);
 
@@ -203,8 +212,8 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 				return;
 		} else {
 			if (status == -1)
-				dev_err(adapter->dev,
-					"received data processing failed!\n");
+				mwifiex_dbg(adapter, ERROR,
+					    "received data processing failed!\n");
 
 			/* Do not free skb in case of command ep */
 			if (card->rx_cmd_ep != context->ep)
@@ -212,8 +221,8 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 		}
 	} else if (urb->status) {
 		if (!adapter->is_suspended) {
-			dev_warn(adapter->dev,
-				 "Card is removed: %d\n", urb->status);
+			mwifiex_dbg(adapter, FATAL,
+				    "Card is removed: %d\n", urb->status);
 			adapter->surprise_removed = true;
 		}
 		dev_kfree_skb_any(skb);
@@ -249,14 +258,17 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	struct mwifiex_adapter *adapter = context->adapter;
 	struct usb_card_rec *card = adapter->card;
 
-	dev_dbg(adapter->dev, "%s: status: %d\n", __func__, urb->status);
+	mwifiex_dbg(adapter, INFO,
+		    "%s: status: %d\n", __func__, urb->status);
 
 	if (context->ep == card->tx_cmd_ep) {
-		dev_dbg(adapter->dev, "%s: CMD\n", __func__);
+		mwifiex_dbg(adapter, CMD,
+			    "%s: CMD\n", __func__);
 		atomic_dec(&card->tx_cmd_urb_pending);
 		adapter->cmd_sent = false;
 	} else {
-		dev_dbg(adapter->dev, "%s: DATA\n", __func__);
+		mwifiex_dbg(adapter, DATA,
+			    "%s: DATA\n", __func__);
 		atomic_dec(&card->tx_data_urb_pending);
 		mwifiex_write_data_complete(adapter, context->skb, 0,
 					    urb->status ? -1 : 0);
@@ -275,8 +287,8 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	if (card->rx_cmd_ep != ctx->ep) {
 		ctx->skb = dev_alloc_skb(size);
 		if (!ctx->skb) {
-			dev_err(adapter->dev,
-				"%s: dev_alloc_skb failed\n", __func__);
+			mwifiex_dbg(adapter, ERROR,
+				    "%s: dev_alloc_skb failed\n", __func__);
 			return -ENOMEM;
 		}
 	}
@@ -291,7 +303,7 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 		atomic_inc(&card->rx_data_urb_pending);
 
 	if (usb_submit_urb(ctx->urb, GFP_ATOMIC)) {
-		dev_err(adapter->dev, "usb_submit_urb failed\n");
+		mwifiex_dbg(adapter, ERROR, "usb_submit_urb failed\n");
 		dev_kfree_skb_any(ctx->skb);
 		ctx->skb = NULL;
 
@@ -468,7 +480,8 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	adapter = card->adapter;
 
 	if (unlikely(adapter->is_suspended))
-		dev_warn(adapter->dev, "Device already suspended\n");
+		mwifiex_dbg(adapter, WARN,
+			    "Device already suspended\n");
 
 	mwifiex_enable_hs(adapter);
 
@@ -519,7 +532,8 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	adapter = card->adapter;
 
 	if (unlikely(!adapter->is_suspended)) {
-		dev_warn(adapter->dev, "Device already resumed\n");
+		mwifiex_dbg(adapter, WARN,
+			    "Device already resumed\n");
 		return 0;
 	}
 
@@ -578,7 +592,8 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 
 	mwifiex_usb_free(card);
 
-	dev_dbg(adapter->dev, "%s: removing card\n", __func__);
+	mwifiex_dbg(adapter, FATAL,
+		    "%s: removing card\n", __func__);
 	mwifiex_remove_card(adapter, &add_remove_card_sem);
 
 	usb_set_intfdata(intf, NULL);
@@ -608,7 +623,8 @@ static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
 
 	card->tx_cmd.urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!card->tx_cmd.urb) {
-		dev_err(adapter->dev, "tx_cmd.urb allocation failed\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "tx_cmd.urb allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -620,8 +636,8 @@ static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
 
 		card->tx_data_list[i].urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!card->tx_data_list[i].urb) {
-			dev_err(adapter->dev,
-				"tx_data_list[] urb allocation failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "tx_data_list[] urb allocation failed\n");
 			return -ENOMEM;
 		}
 	}
@@ -639,15 +655,13 @@ static int mwifiex_usb_rx_init(struct mwifiex_adapter *adapter)
 
 	card->rx_cmd.urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!card->rx_cmd.urb) {
-		dev_err(adapter->dev, "rx_cmd.urb allocation failed\n");
+		mwifiex_dbg(adapter, ERROR, "rx_cmd.urb allocation failed\n");
 		return -ENOMEM;
 	}
 
 	card->rx_cmd.skb = dev_alloc_skb(MWIFIEX_RX_CMD_BUF_SIZE);
-	if (!card->rx_cmd.skb) {
-		dev_err(adapter->dev, "rx_cmd.skb allocation failed\n");
+	if (!card->rx_cmd.skb)
 		return -ENOMEM;
-	}
 
 	if (mwifiex_usb_submit_rx_urb(&card->rx_cmd, MWIFIEX_RX_CMD_BUF_SIZE))
 		return -1;
@@ -658,8 +672,8 @@ static int mwifiex_usb_rx_init(struct mwifiex_adapter *adapter)
 
 		card->rx_data_list[i].urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!card->rx_data_list[i].urb) {
-			dev_err(adapter->dev,
-				"rx_data_list[] urb allocation failed\n");
+			mwifiex_dbg(adapter, ERROR,
+				    "rx_data_list[] urb allocation failed\n");
 			return -1;
 		}
 		if (mwifiex_usb_submit_rx_urb(&card->rx_data_list[i],
@@ -683,7 +697,8 @@ static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 	ret = usb_bulk_msg(card->udev, usb_sndbulkpipe(card->udev, ep), pbuf,
 			   *len, &actual_length, timeout);
 	if (ret) {
-		dev_err(adapter->dev, "usb_bulk_msg for tx failed: %d\n", ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "usb_bulk_msg for tx failed: %d\n", ret);
 		return ret;
 	}
 
@@ -702,7 +717,8 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
 	ret = usb_bulk_msg(card->udev, usb_rcvbulkpipe(card->udev, ep), pbuf,
 			   *len, &actual_length, timeout);
 	if (ret) {
-		dev_err(adapter->dev, "usb_bulk_msg for rx failed: %d\n", ret);
+		mwifiex_dbg(adapter, ERROR,
+			    "usb_bulk_msg for rx failed: %d\n", ret);
 		return ret;
 	}
 
@@ -722,13 +738,13 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	struct urb *tx_urb;
 
 	if (adapter->is_suspended) {
-		dev_err(adapter->dev,
-			"%s: not allowed while suspended\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: not allowed while suspended\n", __func__);
 		return -1;
 	}
 
 	if (adapter->surprise_removed) {
-		dev_err(adapter->dev, "%s: device removed\n", __func__);
+		mwifiex_dbg(adapter, ERROR, "%s: device removed\n", __func__);
 		return -1;
 	}
 
@@ -737,7 +753,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		return -EBUSY;
 	}
 
-	dev_dbg(adapter->dev, "%s: ep=%d\n", __func__, ep);
+	mwifiex_dbg(adapter, INFO, "%s: ep=%d\n", __func__, ep);
 
 	if (ep == card->tx_cmd_ep) {
 		context = &card->tx_cmd;
@@ -764,7 +780,8 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		atomic_inc(&card->tx_data_urb_pending);
 
 	if (usb_submit_urb(tx_urb, GFP_ATOMIC)) {
-		dev_err(adapter->dev, "%s: usb_submit_urb failed\n", __func__);
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: usb_submit_urb failed\n", __func__);
 		if (ep == card->tx_cmd_ep) {
 			atomic_dec(&card->tx_cmd_urb_pending);
 		} else {
@@ -843,8 +860,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u8 check_winner = 1;
 
 	if (!firmware) {
-		dev_err(adapter->dev,
-			"No firmware image found! Terminating download\n");
+		mwifiex_dbg(adapter, ERROR,
+			    "No firmware image found! Terminating download\n");
 		ret = -1;
 		goto fw_exit;
 	}
@@ -889,8 +906,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 						MWIFIEX_USB_EP_CMD_EVENT,
 						MWIFIEX_USB_TIMEOUT);
 			if (ret) {
-				dev_err(adapter->dev,
-					"write_data_sync: failed: %d\n", ret);
+				mwifiex_dbg(adapter, ERROR,
+					    "write_data_sync: failed: %d\n",
+					    ret);
 				continue;
 			}
 
@@ -902,8 +920,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 						MWIFIEX_USB_EP_CMD_EVENT,
 						MWIFIEX_USB_TIMEOUT);
 			if (ret) {
-				dev_err(adapter->dev,
-					"read_data_sync: failed: %d\n", ret);
+				mwifiex_dbg(adapter, ERROR,
+					    "read_data_sync: failed: %d\n",
+					    ret);
 				continue;
 			}
 
@@ -913,17 +932,17 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			/* check 1st firmware block resp for highest bit set */
 			if (check_winner) {
 				if (le32_to_cpu(sync_fw.cmd) & 0x80000000) {
-					dev_warn(adapter->dev,
-						 "USB is not the winner %#x\n",
-						 sync_fw.cmd);
+					mwifiex_dbg(adapter, WARN,
+						    "USB is not the winner %#x\n",
+						    sync_fw.cmd);
 
 					/* returning success */
 					ret = 0;
 					goto cleanup;
 				}
 
-				dev_dbg(adapter->dev,
-					"USB is the winner, start to download FW\n");
+				mwifiex_dbg(adapter, MSG,
+					    "start to download FW...\n");
 
 				check_winner = 0;
 				break;
@@ -931,9 +950,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 			/* check the firmware block response for CRC errors */
 			if (sync_fw.cmd) {
-				dev_err(adapter->dev,
-					"FW received block with CRC %#x\n",
-					sync_fw.cmd);
+				mwifiex_dbg(adapter, ERROR,
+					    "FW received block with CRC %#x\n",
+					    sync_fw.cmd);
 				ret = -1;
 				continue;
 			}
@@ -945,8 +964,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	} while ((dnld_cmd != FW_HAS_LAST_BLOCK) && retries);
 
 cleanup:
-	dev_notice(adapter->dev,
-		   "info: FW download over, size %d bytes\n", tlen);
+	mwifiex_dbg(adapter, MSG,
+		    "info: FW download over, size %d bytes\n", tlen);
 
 	kfree(recv_buff);
 	kfree(fwdata);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 22d93af..3c0b3c1 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -160,7 +160,8 @@ int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
 	} else {
-		dev_err(priv->adapter->dev, "unsupported parameter\n");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "unsupported parameter\n");
 		return -1;
 	}
 
@@ -339,9 +340,9 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 		action_code = *(payload + sizeof(struct ieee80211_hdr) + 1);
 		if (category == WLAN_CATEGORY_PUBLIC &&
 		    action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
-			dev_dbg(priv->adapter->dev,
-				"TDLS discovery response %pM nf=%d, snr=%d\n",
-				ieee_hdr->addr2, rx_pd->nf, rx_pd->snr);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "TDLS discovery response %pM nf=%d, snr=%d\n",
+				    ieee_hdr->addr2, rx_pd->nf, rx_pd->snr);
 			mwifiex_auto_tdls_update_peer_signal(priv,
 							     ieee_hdr->addr2,
 							     rx_pd->snr,
@@ -349,8 +350,8 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 		}
 		break;
 	default:
-		dev_dbg(priv->adapter->dev,
-			"unknown mgmt frame subytpe %#x\n", stype);
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "unknown mgmt frame subytpe %#x\n", stype);
 	}
 
 	return 0;
@@ -372,8 +373,8 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 
 	if (!priv->mgmt_frame_mask ||
 	    priv->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED) {
-		dev_dbg(priv->adapter->dev,
-			"do not receive mgmt frames on uninitialized intf");
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "do not receive mgmt frames on uninitialized intf");
 		return -1;
 	}
 
@@ -467,13 +468,14 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
 			 struct cmd_ctrl_node *cmd_node)
 {
-	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
-		adapter->cmd_wait_q.status);
+	mwifiex_dbg(adapter, CMD,
+		    "cmd completed: status=%d\n",
+		    adapter->cmd_wait_q.status);
 
 	*(cmd_node->condition) = true;
 
 	if (adapter->cmd_wait_q.status == -ETIMEDOUT)
-		dev_err(adapter->dev, "cmd timeout\n");
+		mwifiex_dbg(adapter, ERROR, "cmd timeout\n");
 	else
 		wake_up_interruptible(&adapter->cmd_wait_q.wait);
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8be9d13..a8ea21c 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -107,7 +107,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, const u8 *ra)
 
 	ra_list->total_pkt_count = 0;
 
-	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
+	mwifiex_dbg(adapter, INFO, "info: allocated ra_list %p\n", ra_list);
 
 	return ra_list;
 }
@@ -150,7 +150,8 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
-		dev_dbg(adapter->dev, "info: created ra_list %p\n", ra_list);
+		mwifiex_dbg(adapter, INFO,
+			    "info: created ra_list %p\n", ra_list);
 
 		if (!ra_list)
 			break;
@@ -178,8 +179,8 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		}
 
-		dev_dbg(adapter->dev, "data: ralist %p: is_11n_enabled=%d\n",
-			ra_list, ra_list->is_11n_enabled);
+		mwifiex_dbg(adapter, DATA, "data: ralist %p: is_11n_enabled=%d\n",
+			    ra_list, ra_list->is_11n_enabled);
 
 		if (ra_list->is_11n_enabled) {
 			ra_list->ba_pkt_count = 0;
@@ -241,11 +242,12 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		return;
 	}
 
-	dev_dbg(priv->adapter->dev, "info: WMM Parameter IE: version=%d, "
-		"qos_info Parameter Set Count=%d, Reserved=%#x\n",
-		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
-		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
-		wmm_ie->reserved);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: WMM Parameter IE: version=%d,\t"
+		    "qos_info Parameter Set Count=%d, Reserved=%#x\n",
+		    wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		    IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
+		    wmm_ie->reserved);
 
 	for (num_ac = 0; num_ac < ARRAY_SIZE(wmm_ie->ac_params); num_ac++) {
 		u8 ecw = wmm_ie->ac_params[num_ac].ecw_bitmap;
@@ -257,10 +259,10 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		priv->wmm.queue_priority[ac_idx] = ac_idx;
 		tmp[ac_idx] = avg_back_off;
 
-		dev_dbg(priv->adapter->dev,
-			"info: WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
-			(1 << ((ecw & MWIFIEX_ECW_MAX) >> 4)) - 1,
-			cw_min, avg_back_off);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
+			    (1 << ((ecw & MWIFIEX_ECW_MAX) >> 4)) - 1,
+			    cw_min, avg_back_off);
 		mwifiex_wmm_ac_debug_print(&wmm_ie->ac_params[num_ac]);
 	}
 
@@ -333,8 +335,8 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 {
 	int ac_val;
 
-	dev_dbg(priv->adapter->dev, "info: WMM: AC Priorities:"
-			"BK(0), BE(1), VI(2), VO(3)\n");
+	mwifiex_dbg(priv->adapter, INFO, "info: WMM: AC Priorities:\t"
+		    "BK(0), BE(1), VI(2), VO(3)\n");
 
 	if (!priv->wmm_enabled) {
 		/* WMM is not enabled, default priorities */
@@ -346,9 +348,10 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 			priv->wmm.ac_down_graded_vals[ac_val]
 				= mwifiex_wmm_eval_downgrade_ac(priv,
 						(enum mwifiex_wmm_ac_e) ac_val);
-			dev_dbg(priv->adapter->dev,
-				"info: WMM: AC PRIO %d maps to %d\n",
-				ac_val, priv->wmm.ac_down_graded_vals[ac_val]);
+			mwifiex_dbg(priv->adapter, INFO,
+				    "info: WMM: AC PRIO %d maps to %d\n",
+				    ac_val,
+				    priv->wmm.ac_down_graded_vals[ac_val]);
 		}
 	}
 }
@@ -521,8 +524,8 @@ static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 	int i;
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
-		dev_dbg(priv->adapter->dev,
-			"info: ra_list: freeing buf for tid %d\n", i);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "info: ra_list: freeing buf for tid %d\n", i);
 		list_for_each_entry_safe(ra_list, tmp_node,
 					 &priv->wmm.tid_tbl_ptr[i].ra_list,
 					 list) {
@@ -694,14 +697,15 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
 	    ISSUPP_TDLS_ENABLED(adapter->fw_cap_info)) {
 		if (ntohs(eth_hdr->h_proto) == ETH_P_TDLS)
-			dev_dbg(adapter->dev,
-				"TDLS setup packet for %pM. Don't block\n", ra);
+			mwifiex_dbg(adapter, DATA,
+				    "TDLS setup packet for %pM.\t"
+				    "Don't block\n", ra);
 		else if (memcmp(priv->cfg_bssid, ra, ETH_ALEN))
 			tdls_status = mwifiex_get_tdls_link_status(priv, ra);
 	}
 
 	if (!priv->media_connected && !mwifiex_is_skb_mgmt_frame(skb)) {
-		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
+		mwifiex_dbg(adapter, DATA, "data: drop packet in disconnect\n");
 		mwifiex_write_data_complete(adapter, skb, 0, -1);
 		return;
 	}
@@ -782,6 +786,7 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 {
 	u8 *curr = (u8 *) &resp->params.get_wmm_status;
 	uint16_t resp_len = le16_to_cpu(resp->size), tlv_len;
+	int mask = IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK;
 	bool valid = true;
 
 	struct mwifiex_ie_types_data *tlv_hdr;
@@ -789,8 +794,9 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	struct ieee_types_wmm_parameter *wmm_param_ie = NULL;
 	struct mwifiex_wmm_ac_status *ac_status;
 
-	dev_dbg(priv->adapter->dev, "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
-		resp_len);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
+		    resp_len);
 
 	while ((resp_len >= sizeof(tlv_hdr->header)) && valid) {
 		tlv_hdr = (struct mwifiex_ie_types_data *) curr;
@@ -804,12 +810,12 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			tlv_wmm_qstatus =
 				(struct mwifiex_ie_types_wmm_queue_status *)
 				tlv_hdr;
-			dev_dbg(priv->adapter->dev,
-				"info: CMD_RESP: WMM_GET_STATUS:"
-				" QSTATUS TLV: %d, %d, %d\n",
-				tlv_wmm_qstatus->queue_index,
-				tlv_wmm_qstatus->flow_required,
-				tlv_wmm_qstatus->disabled);
+			mwifiex_dbg(priv->adapter, CMD,
+				    "info: CMD_RESP: WMM_GET_STATUS:\t"
+				    "QSTATUS TLV: %d, %d, %d\n",
+				    tlv_wmm_qstatus->queue_index,
+				    tlv_wmm_qstatus->flow_required,
+				    tlv_wmm_qstatus->disabled);
 
 			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
 							 queue_index];
@@ -832,11 +838,10 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			wmm_param_ie->vend_hdr.element_id =
 						WLAN_EID_VENDOR_SPECIFIC;
 
-			dev_dbg(priv->adapter->dev,
-				"info: CMD_RESP: WMM_GET_STATUS:"
-				" WMM Parameter Set Count: %d\n",
-				wmm_param_ie->qos_info_bitmap &
-				IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK);
+			mwifiex_dbg(priv->adapter, CMD,
+				    "info: CMD_RESP: WMM_GET_STATUS:\t"
+				    "WMM Parameter Set Count: %d\n",
+				    wmm_param_ie->qos_info_bitmap & mask);
 
 			memcpy((u8 *) &priv->curr_bss_params.bss_descriptor.
 			       wmm_ie, wmm_param_ie,
@@ -884,9 +889,9 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	if (!wmm_ie)
 		return 0;
 
-	dev_dbg(priv->adapter->dev,
-		"info: WMM: process assoc req: bss->wmm_ie=%#x\n",
-		wmm_ie->vend_hdr.element_id);
+	mwifiex_dbg(priv->adapter, INFO,
+		    "info: WMM: process assoc req: bss->wmm_ie=%#x\n",
+		    wmm_ie->vend_hdr.element_id);
 
 	if ((priv->wmm_required ||
 	     (ht_cap && (priv->adapter->config_bands & BAND_GN ||
@@ -936,8 +941,8 @@ mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 	 */
 	ret_val = (u8) (min(queue_delay, priv->wmm.drv_pkt_delay_max) >> 1);
 
-	dev_dbg(priv->adapter->dev, "data: WMM: Pkt Delay: %d ms,"
-				" %d ms sent to FW\n", queue_delay, ret_val);
+	mwifiex_dbg(priv->adapter, DATA, "data: WMM: Pkt Delay: %d ms,\t"
+		    "%d ms sent to FW\n", queue_delay, ret_val);
 
 	return ret_val;
 }
@@ -1091,14 +1096,15 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	if (skb_queue_empty(&ptr->skb_head)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		dev_dbg(adapter->dev, "data: nothing to send\n");
+		mwifiex_dbg(adapter, DATA, "data: nothing to send\n");
 		return;
 	}
 
 	skb = skb_dequeue(&ptr->skb_head);
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
-	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
+	mwifiex_dbg(adapter, DATA,
+		    "data: dequeuing the packet %p %p\n", ptr, skb);
 
 	ptr->total_pkt_count--;
 
@@ -1214,7 +1220,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 
 	switch (ret) {
 	case -EBUSY:
-		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
@@ -1233,7 +1239,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	case -1:
 		if (adapter->iface_type != MWIFIEX_PCIE)
 			adapter->data_sent = false;
-		dev_err(adapter->dev, "host_to_card failed: %#x\n", ret);
+		mwifiex_dbg(adapter, ERROR, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
@@ -1272,7 +1278,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 
 	tid = mwifiex_get_tid(ptr);
 
-	dev_dbg(adapter->dev, "data: tid=%d\n", tid);
+	mwifiex_dbg(adapter, DATA, "data: tid=%d\n", tid);
 
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-- 
1.8.1.4

