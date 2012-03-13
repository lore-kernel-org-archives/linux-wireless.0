Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48879 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758329Ab2CMCi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:38:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 15/15] mwifiex: fix checkpatch --strict warnings/errors  Part 9
Date: Mon, 12 Mar 2012 19:38:11 -0700
Message-Id: <1331606291-322-6-git-send-email-bzhao@marvell.com> (sfid-20120313_033859_195355_DA34957A)
In-Reply-To: <1331606291-322-1-git-send-email-bzhao@marvell.com>
References: <1331606291-322-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files sta_rx.c, sta_tx.c, txrx.c, util.c and wmm.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_rx.c |   12 ++--
 drivers/net/wireless/mwifiex/sta_tx.c |   21 +++---
 drivers/net/wireless/mwifiex/txrx.c   |   13 ++--
 drivers/net/wireless/mwifiex/util.c   |   20 +++---
 drivers/net/wireless/mwifiex/wmm.c    |  118 ++++++++++++++++-----------------
 5 files changed, 91 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index d7a5d76..750b695 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -43,8 +43,9 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 {
 	int ret;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
-			rx_info->bss_num, rx_info->bss_type);
+	struct mwifiex_private *priv =
+			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
+					       rx_info->bss_type);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct rxpd *local_rx_pd;
 	int hdr_chop;
@@ -125,8 +126,9 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
 	u16 rx_pkt_type;
-	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
-			rx_info->bss_num, rx_info->bss_type);
+	struct mwifiex_private *priv =
+			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
+					       rx_info->bss_type);
 
 	if (!priv)
 		return -1;
@@ -157,7 +159,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		skb_trim(skb, local_rx_pd->rx_pkt_length);
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-				priv->wdev->iftype, 0, false);
+					 priv->wdev->iftype, 0, false);
 
 		while (!skb_queue_empty(&list)) {
 			rx_skb = __skb_dequeue(&list);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 94d31a9..23d04b2 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -51,7 +51,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n",
-		       skb->len);
+			skb->len);
 		tx_info->status_code = -1;
 		return skb->data;
 	}
@@ -60,19 +60,20 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
 
 	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN
-								+ pad));
+				    + pad));
 	skb_push(skb, sizeof(*local_tx_pd) + pad);
 
 	local_tx_pd = (struct txpd *) skb->data;
 	memset(local_tx_pd, 0, sizeof(struct txpd));
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
-	local_tx_pd->tx_pkt_length = cpu_to_le16((u16) (skb->len -
-						(sizeof(struct txpd) + pad)));
+	local_tx_pd->tx_pkt_length = cpu_to_le16((u16)(skb->len -
+						       (sizeof(struct txpd)
+							+ pad)));
 
 	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
-		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
+				mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
 	if (local_tx_pd->priority <
 	    ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
@@ -82,7 +83,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		 */
 		local_tx_pd->tx_control =
 			cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[local_tx_pd->
-							 priority]);
+								   priority]);
 
 	if (adapter->pps_uapsd_mode) {
 		if (mwifiex_check_last_packet_indication(priv)) {
@@ -160,13 +161,13 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	case -1:
 		dev_kfree_skb_any(skb);
 		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
-						__func__, ret);
+			__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case 0:
 		dev_kfree_skb_any(skb);
 		dev_dbg(adapter->dev, "data: %s: host_to_card succeeded\n",
-						__func__);
+			__func__);
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
@@ -192,8 +193,8 @@ mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
 	if (mwifiex_wmm_lists_empty(adapter))
 			ret = true;
 
-	if (ret && !adapter->cmd_sent && !adapter->curr_cmd
-	    && !is_command_pending(adapter)) {
+	if (ret && !adapter->cmd_sent && !adapter->curr_cmd &&
+	    !is_command_pending(adapter)) {
 		adapter->delay_null_pkt = false;
 		ret = true;
 	} else {
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 9a6eacc..d2af8cb 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -85,8 +85,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	switch (ret) {
 	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
-			(adapter->pps_uapsd_mode) &&
-			(adapter->tx_lock_flag)) {
+		    (adapter->pps_uapsd_mode) && (adapter->tx_lock_flag)) {
 				priv->adapter->tx_lock_flag = false;
 				if (local_tx_pd)
 					local_tx_pd->flags = 0;
@@ -96,7 +95,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	case -1:
 		adapter->data_sent = false;
 		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
-		       ret);
+			ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
@@ -132,7 +131,7 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	priv = mwifiex_get_priv_by_id(adapter, tx_info->bss_num,
-			tx_info->bss_type);
+				      tx_info->bss_type);
 	if (!priv)
 		goto done;
 
@@ -151,11 +150,11 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 		tpriv = adapter->priv[i];
 
-		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA)
-				&& (tpriv->media_connected)) {
+		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA) &&
+		    (tpriv->media_connected)) {
 			if (netif_queue_stopped(tpriv->netdev))
 				mwifiex_wake_up_net_dev_queue(tpriv->netdev,
-								adapter);
+							      adapter);
 		}
 	}
 done:
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 9c48f37..6b39997 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -93,10 +93,10 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		       sizeof(priv->wmm.packets_out));
 		info->max_tx_buf_size = (u32) adapter->max_tx_buf_size;
 		info->tx_buf_size = (u32) adapter->tx_buf_size;
-		info->rx_tbl_num = mwifiex_get_rx_reorder_tbl(
-					priv, info->rx_tbl);
-		info->tx_tbl_num = mwifiex_get_tx_ba_stream_tbl(
-					priv, info->tx_tbl);
+		info->rx_tbl_num = mwifiex_get_rx_reorder_tbl(priv,
+							      info->rx_tbl);
+		info->tx_tbl_num = mwifiex_get_tx_ba_stream_tbl(priv,
+								info->tx_tbl);
 		info->ps_mode = adapter->ps_mode;
 		info->ps_state = adapter->ps_state;
 		info->is_deep_sleep = adapter->is_deep_sleep;
@@ -105,19 +105,19 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->is_hs_configured = adapter->is_hs_configured;
 		info->hs_activated = adapter->hs_activated;
 		info->num_cmd_host_to_card_failure
-			= adapter->dbg.num_cmd_host_to_card_failure;
+				= adapter->dbg.num_cmd_host_to_card_failure;
 		info->num_cmd_sleep_cfm_host_to_card_failure
 			= adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure;
 		info->num_tx_host_to_card_failure
-			= adapter->dbg.num_tx_host_to_card_failure;
+				= adapter->dbg.num_tx_host_to_card_failure;
 		info->num_event_deauth = adapter->dbg.num_event_deauth;
 		info->num_event_disassoc = adapter->dbg.num_event_disassoc;
 		info->num_event_link_lost = adapter->dbg.num_event_link_lost;
 		info->num_cmd_deauth = adapter->dbg.num_cmd_deauth;
 		info->num_cmd_assoc_success =
-			adapter->dbg.num_cmd_assoc_success;
+					adapter->dbg.num_cmd_assoc_success;
 		info->num_cmd_assoc_failure =
-			adapter->dbg.num_cmd_assoc_failure;
+					adapter->dbg.num_cmd_assoc_failure;
 		info->num_tx_timeout = adapter->dbg.num_tx_timeout;
 		info->num_cmd_timeout = adapter->dbg.num_cmd_timeout;
 		info->timeout_cmd_id = adapter->dbg.timeout_cmd_id;
@@ -160,7 +160,7 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	rx_info = MWIFIEX_SKB_RXCB(skb);
 	priv = mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
-			rx_info->bss_type);
+				      rx_info->bss_type);
 	if (!priv)
 		return -1;
 
@@ -191,7 +191,7 @@ int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
 {
 	atomic_dec(&adapter->cmd_pending);
 	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
-					adapter->cmd_wait_q.status);
+		adapter->cmd_wait_q.status);
 
 	*(cmd_node->condition) = true;
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6f0cc21..c9f0d12 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -87,15 +87,15 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
 	const char *ac_str[] = { "BK", "BE", "VI", "VO" };
 
 	pr_debug("info: WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
-	       "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
-	       ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
-	       & MWIFIEX_ACI) >> 5]],
-	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACI) >> 5,
-	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACM) >> 4,
-	       ac_param->aci_aifsn_bitmap & MWIFIEX_AIFSN,
-	       ac_param->ecw_bitmap & MWIFIEX_ECW_MIN,
-	       (ac_param->ecw_bitmap & MWIFIEX_ECW_MAX) >> 4,
-	       le16_to_cpu(ac_param->tx_op_limit));
+		 "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
+		 ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
+					     & MWIFIEX_ACI) >> 5]],
+		 (ac_param->aci_aifsn_bitmap & MWIFIEX_ACI) >> 5,
+		 (ac_param->aci_aifsn_bitmap & MWIFIEX_ACM) >> 4,
+		 ac_param->aci_aifsn_bitmap & MWIFIEX_AIFSN,
+		 ac_param->ecw_bitmap & MWIFIEX_ECW_MIN,
+		 (ac_param->ecw_bitmap & MWIFIEX_ECW_MAX) >> 4,
+		 le16_to_cpu(ac_param->tx_op_limit));
 }
 
 /*
@@ -112,7 +112,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 
 	if (!ra_list) {
 		dev_err(adapter->dev, "%s: failed to alloc ra_list\n",
-						__func__);
+			__func__);
 		return NULL;
 	}
 	INIT_LIST_HEAD(&ra_list->list);
@@ -154,7 +154,7 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 			ra_list, ra_list->is_11n_enabled);
 
 		list_add_tail(&ra_list->list,
-				&priv->wmm.tid_tbl_ptr[i].ra_list);
+			      &priv->wmm.tid_tbl_ptr[i].ra_list);
 
 		if (!priv->wmm.tid_tbl_ptr[i].ra_list_curr)
 			priv->wmm.tid_tbl_ptr[i].ra_list_curr = ra_list;
@@ -217,22 +217,18 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		wmm_ie->reserved);
 
 	for (num_ac = 0; num_ac < ARRAY_SIZE(wmm_ie->ac_params); num_ac++) {
-		cw_min = (1 << (wmm_ie->ac_params[num_ac].ecw_bitmap &
-			MWIFIEX_ECW_MIN)) - 1;
-		avg_back_off = (cw_min >> 1) +
-			(wmm_ie->ac_params[num_ac].aci_aifsn_bitmap &
-			MWIFIEX_AIFSN);
-
-		ac_idx = wmm_aci_to_qidx_map[(wmm_ie->ac_params[num_ac].
-					     aci_aifsn_bitmap &
-					     MWIFIEX_ACI) >> 5];
+		u8 ecw = wmm_ie->ac_params[num_ac].ecw_bitmap;
+		u8 aci_aifsn = wmm_ie->ac_params[num_ac].aci_aifsn_bitmap;
+		cw_min = (1 << (ecw & MWIFIEX_ECW_MIN)) - 1;
+		avg_back_off = (cw_min >> 1) + (aci_aifsn & MWIFIEX_AIFSN);
+
+		ac_idx = wmm_aci_to_qidx_map[(aci_aifsn & MWIFIEX_ACI) >> 5];
 		priv->wmm.queue_priority[ac_idx] = ac_idx;
 		tmp[ac_idx] = avg_back_off;
 
 		dev_dbg(priv->adapter->dev, "info: WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
-		       (1 << ((wmm_ie->ac_params[num_ac].ecw_bitmap &
-		       MWIFIEX_ECW_MAX) >> 4)) - 1,
-		       cw_min, avg_back_off);
+			(1 << ((ecw & MWIFIEX_ECW_MAX) >> 4)) - 1,
+			cw_min, avg_back_off);
 		mwifiex_wmm_ac_debug_print(&wmm_ie->ac_params[num_ac]);
 	}
 
@@ -312,13 +308,14 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 		/* WMM is not enabled, default priorities */
 		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++)
 			priv->wmm.ac_down_graded_vals[ac_val] =
-				(enum mwifiex_wmm_ac_e) ac_val;
+						(enum mwifiex_wmm_ac_e) ac_val;
 	} else {
 		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++) {
 			priv->wmm.ac_down_graded_vals[ac_val]
 				= mwifiex_wmm_eval_downgrade_ac(priv,
 						(enum mwifiex_wmm_ac_e) ac_val);
-			dev_dbg(priv->adapter->dev, "info: WMM: AC PRIO %d maps to %d\n",
+			dev_dbg(priv->adapter->dev,
+				"info: WMM: AC PRIO %d maps to %d\n",
 				ac_val, priv->wmm.ac_down_graded_vals[ac_val]);
 		}
 	}
@@ -394,13 +391,13 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 		}
 
 		priv->aggr_prio_tbl[6].amsdu
-			= priv->aggr_prio_tbl[6].ampdu_ap
-			= priv->aggr_prio_tbl[6].ampdu_user
-			= BA_STREAM_NOT_ALLOWED;
+					= priv->aggr_prio_tbl[6].ampdu_ap
+					= priv->aggr_prio_tbl[6].ampdu_user
+					= BA_STREAM_NOT_ALLOWED;
 
 		priv->aggr_prio_tbl[7].amsdu = priv->aggr_prio_tbl[7].ampdu_ap
-			= priv->aggr_prio_tbl[7].ampdu_user
-			= BA_STREAM_NOT_ALLOWED;
+					= priv->aggr_prio_tbl[7].ampdu_user
+					= BA_STREAM_NOT_ALLOWED;
 
 		priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
 		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
@@ -472,7 +469,7 @@ static void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 
 	for (i = 0; i < MAX_NUM_TID; i++)
 		mwifiex_wmm_del_pkts_in_ralist(priv, &priv->wmm.tid_tbl_ptr[i].
-						     ra_list);
+								       ra_list);
 
 	atomic_set(&priv->wmm.tx_pkts_queued, 0);
 	atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
@@ -488,9 +485,10 @@ static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		dev_dbg(priv->adapter->dev,
-				"info: ra_list: freeing buf for tid %d\n", i);
+			"info: ra_list: freeing buf for tid %d\n", i);
 		list_for_each_entry_safe(ra_list, tmp_node,
-				&priv->wmm.tid_tbl_ptr[i].ra_list, list) {
+					 &priv->wmm.tid_tbl_ptr[i].ra_list,
+					 list) {
 			list_del(&ra_list->list);
 			kfree(ra_list);
 		}
@@ -652,7 +650,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	if (atomic_read(&priv->wmm.highest_queued_prio) <
 						tos_to_tid_inv[tid_down])
 		atomic_set(&priv->wmm.highest_queued_prio,
-						tos_to_tid_inv[tid_down]);
+			   tos_to_tid_inv[tid_down]);
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
@@ -681,7 +679,7 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	struct mwifiex_wmm_ac_status *ac_status;
 
 	dev_dbg(priv->adapter->dev, "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
-			resp_len);
+		resp_len);
 
 	while ((resp_len >= sizeof(tlv_hdr->header)) && valid) {
 		tlv_hdr = (struct mwifiex_ie_types_data *) curr;
@@ -695,15 +693,15 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			dev_dbg(priv->adapter->dev,
 				"info: CMD_RESP: WMM_GET_STATUS:"
 				" QSTATUS TLV: %d, %d, %d\n",
-			       tlv_wmm_qstatus->queue_index,
-			       tlv_wmm_qstatus->flow_required,
-			       tlv_wmm_qstatus->disabled);
+				tlv_wmm_qstatus->queue_index,
+				tlv_wmm_qstatus->flow_required,
+				tlv_wmm_qstatus->disabled);
 
 			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
 							 queue_index];
 			ac_status->disabled = tlv_wmm_qstatus->disabled;
 			ac_status->flow_required =
-				tlv_wmm_qstatus->flow_required;
+						tlv_wmm_qstatus->flow_required;
 			ac_status->flow_created = tlv_wmm_qstatus->flow_created;
 			break;
 
@@ -773,28 +771,25 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 		return 0;
 
 	dev_dbg(priv->adapter->dev, "info: WMM: process assoc req:"
-			"bss->wmmIe=0x%x\n",
-			wmm_ie->vend_hdr.element_id);
-
-	if ((priv->wmm_required
-	     || (ht_cap && (priv->adapter->config_bands & BAND_GN
-		     || priv->adapter->config_bands & BAND_AN))
-	    )
-	    && wmm_ie->vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC) {
+		"bss->wmmIe=0x%x\n", wmm_ie->vend_hdr.element_id);
+
+	if ((priv->wmm_required ||
+	     (ht_cap && (priv->adapter->config_bands & BAND_GN ||
+	     priv->adapter->config_bands & BAND_AN))) &&
+	    wmm_ie->vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC) {
 		wmm_tlv = (struct mwifiex_ie_types_wmm_param_set *) *assoc_buf;
 		wmm_tlv->header.type = cpu_to_le16((u16) wmm_info_ie[0]);
 		wmm_tlv->header.len = cpu_to_le16((u16) wmm_info_ie[1]);
 		memcpy(wmm_tlv->wmm_ie, &wmm_info_ie[2],
-			le16_to_cpu(wmm_tlv->header.len));
+		       le16_to_cpu(wmm_tlv->header.len));
 		if (wmm_ie->qos_info_bitmap & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD)
 			memcpy((u8 *) (wmm_tlv->wmm_ie
-					+ le16_to_cpu(wmm_tlv->header.len)
-					 - sizeof(priv->wmm_qosinfo)),
-					&priv->wmm_qosinfo,
-					sizeof(priv->wmm_qosinfo));
+				       + le16_to_cpu(wmm_tlv->header.len)
+				       - sizeof(priv->wmm_qosinfo)),
+			       &priv->wmm_qosinfo, sizeof(priv->wmm_qosinfo));
 
 		ret_len = sizeof(wmm_tlv->header)
-			+ le16_to_cpu(wmm_tlv->header.len);
+			  + le16_to_cpu(wmm_tlv->header.len);
 
 		*assoc_buf += ret_len;
 	}
@@ -813,7 +808,7 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
  */
 u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
-					const struct sk_buff *skb)
+				  const struct sk_buff *skb)
 {
 	u8 ret_val;
 	struct timeval out_tstamp, in_tstamp;
@@ -857,11 +852,11 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				flags);
+				  flags);
 		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
-				.bss_prio_head);
+					   .bss_prio_head);
 		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				flags);
+				       flags);
 		if (is_list_empty)
 			continue;
 
@@ -1210,10 +1205,11 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		return 0;
 	}
 
-	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
-	    || ((priv->sec_info.wpa_enabled
-		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set)
-		) {
+	if (!ptr->is_11n_enabled ||
+	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
+	    ((priv->sec_info.wpa_enabled ||
+	      priv->sec_info.wpa2_enabled) &&
+	     !priv->wpa_is_gtk_set)) {
 		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
-- 
1.7.0.2

