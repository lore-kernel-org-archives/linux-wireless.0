Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934097AbXGaC7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/7] iwlwifi: Endianity fix for tx configuration
Date: Tue, 31 Jul 2007 10:56:35 +0800
Message-Id: <11858506062806-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858506051195-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
 <11858505994113-git-send-email-yi.zhu@intel.com>
 <11858506013260-git-send-email-yi.zhu@intel.com>
 <11858506033857-git-send-email-yi.zhu@intel.com>
 <11858506051195-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes most of the endianity issues in the TX
configuration path.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-hw.h  |    2 +-
 drivers/net/wireless/iwl-4965.c     |    7 +-
 drivers/net/wireless/iwl-base.c     |  158 ++++++++++++++++++-----------------
 drivers/net/wireless/iwl-commands.h |   88 ++++++++++----------
 drivers/net/wireless/iwl-hw.h       |    2 +-
 drivers/net/wireless/iwlwifi.h      |    5 +-
 6 files changed, 135 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index 61229c8..d7b69f5 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -778,7 +778,7 @@ static inline u16 iwl_hw_get_rate_n_flags(__le32 rate_n_flags)
 }
 static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u16 flags)
 {
-	return cpu_to_le32(flags|rate);
+	return cpu_to_le32(flags|(u16)rate);
 }
 #if 0
 
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 786c5d0..1b90838 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2663,7 +2663,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	u8 rate;
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
-	u32 tx_flags;
+	__le32 tx_flags;
 
 	tx_flags = cmd->cmd.tx.tx_flags;
 
@@ -3287,7 +3287,8 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 	    offsetof(struct iwl_tx_cmd, scratch);
-	tx->dram_lsb_ptr = iwl4965_get_dma_lo_address(scratch_phys);
+	tx->dram_lsb_ptr = cpu_to_le32(
+			iwl4965_get_dma_lo_address(scratch_phys));
 	tx->dram_msb_ptr = iwl4965_get_dma_hi_address(scratch_phys);
 
 	/* Hard coded to start at the highest retry fallback position
@@ -4166,7 +4167,7 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
 			ack? "ACK":"NACK", i, idx, agg->start_idx + i);
 		iwl4965_set_tx_status(priv, ba_resp->tid, idx, ack, 1,
-			agg->rate.rate_n_flags);
+			agg->rate_n_flags);
 
 	}
 
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index b7854b5..683f07d 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -561,7 +561,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
 	u32 idx = 0;
-	u16 fix_size = (u16) (cmd->meta.len + sizeof(out_cmd->hdr));
+	u16 fix_size = (u16)(cmd->meta.len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
 #if IWL == 3945
 	int pad;
@@ -596,10 +596,10 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * information */
 
 	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence = QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
-	    INDEX_TO_SEQ(q->first_empty);
+	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
+			INDEX_TO_SEQ(q->first_empty));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
+		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
 	    offsetof(struct iwl_cmd, hdr);
@@ -614,7 +614,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
 		     "%d bytes at %d[%d]:%d\n",
 		     get_cmd_string(out_cmd->hdr.cmd),
-		     out_cmd->hdr.cmd, out_cmd->hdr.sequence,
+		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
 		     fix_size, q->first_empty, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
@@ -1797,7 +1797,7 @@ void static iwl_set_ht_capab(struct ieee80211_hw *hw,
 /**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
-static int iwl_fill_probe_req(struct iwl_priv *priv,
+static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 			      struct ieee80211_mgmt *frame,
 			      int left, int is_direct)
 {
@@ -1892,7 +1892,7 @@ static int iwl_fill_probe_req(struct iwl_priv *priv,
 #endif
 
  fill_end:
-	return len;
+	return (u16)len;
 }
 
 /*
@@ -2672,13 +2672,11 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
-	u32 tx_flags;
-	u16 fc = le16_to_cpu(hdr->frame_control);
 	__le16 *qc;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
-	tx_flags = cmd->cmd.tx.tx_flags;
-
-	cmd->cmd.tx.stop_time.life_time = 0xFFFFFFFF;
+	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT)
@@ -2717,9 +2715,11 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 	if (WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT) {
 		if (((WLAN_FC_GET_STYPE(fc)) == IEEE80211_STYPE_ASSOC_REQ) ||
 		    ((WLAN_FC_GET_STYPE(fc)) == IEEE80211_STYPE_REASSOC_REQ))
-			cmd->cmd.tx.timeout.pm_frame_timeout = 3;
+			cmd->cmd.tx.timeout.pm_frame_timeout =
+				cpu_to_le16(3);
 		else
-			cmd->cmd.tx.timeout.pm_frame_timeout = 2;
+			cmd->cmd.tx.timeout.pm_frame_timeout =
+				cpu_to_le16(2);
 	} else
 		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
 
@@ -2848,7 +2848,8 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
-			(hdr->seq_ctrl & IEEE80211_SCTL_FRAG);
+			(hdr->seq_ctrl &
+				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
 #if IWL == 4965
 #ifdef CONFIG_IWLWIFI_HT
@@ -2879,8 +2880,8 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
 	out_cmd->hdr.cmd = REPLY_TX;
-	out_cmd->hdr.sequence = QUEUE_TO_SEQ(txq_id) |
-		INDEX_TO_SEQ(q->first_empty);
+	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->first_empty)));
 	/* copy frags header */
 	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
 
@@ -2913,7 +2914,6 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 		iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, phys_addr, len);
 	}
 
-	out_cmd->cmd.tx.len = skb->len;
 
 #if IWL == 3945
 	/* If there is no payload, then only one TFD is used */
@@ -2926,6 +2926,8 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	if (len_org)
 		out_cmd->cmd.tx.tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
 #endif
+	len = (u16)skb->len;
+	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
 	iwl_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
@@ -2933,8 +2935,6 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
 
-	len = out_cmd->cmd.tx.len;
-
 #if IWL == 4965
 	iwl4965_tx_cmd(priv, out_cmd, sta_id, txcmd_phys,
 		       hdr, hdr_len, ctl, NULL);
@@ -2958,7 +2958,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	printk_buf(IWL_DL_TX, out_cmd->cmd.payload, sizeof(out_cmd->cmd.tx));
 
 	printk_buf(IWL_DL_TX, (u8 *) out_cmd->cmd.tx.hdr,
-		   ieee80211_get_hdrlen(out_cmd->cmd.tx.hdr->frame_control));
+		   ieee80211_get_hdrlen(fc));
 
 	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
 
@@ -3503,8 +3503,6 @@ static int iwl_is_tx_success(u32 status)
 #ifdef  CONFIG_IWLWIFI_HT
 #ifdef  CONFIG_IWLWIFI_HT_AGG
 
-#define MAX_SN             ((IEEE80211_SCTL_SEQ) >> 4)
-
 static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
 {
@@ -3525,20 +3523,25 @@ static struct ieee80211_hdr *iwl_tx_queue_get_hdr(
 	return NULL;
 }
 
+static inline u32 iwl_get_scd_ssn(struct iwl_tx_resp *tx_resp)
+{
+	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
+				tx_resp->frame_count);
+	return le32_to_cpu(*scd_ssn & MAX_SN);
+
+}
 int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
 				      struct iwl_tx_resp *tx_resp,
 				      u16 start_idx)
 {
-	u16 status;
-	u16 seq;
-	u32 *frame_status = (u32 *)&tx_resp->status;
-
-	int txq_id, idx;
+	u32 status;
+	__le32 *frame_status = &tx_resp->status;
 	struct ieee80211_tx_status *tx_status = NULL;
-
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = NULL;
 	int i, sh;
+	int txq_id, idx;
+	u16 seq;
 
 	if (agg->wait_for_ba) {
 		IWL_DEBUG_TX_REPLY("got tx repsons w/o back\n");
@@ -3547,11 +3550,11 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
-	memcpy(&agg->rate, &tx_resp->rate, sizeof(agg->rate));
+	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	agg->bitmap0 = agg->bitmap1 = 0;
 	if (agg->frame_count == 1) {
-		status = frame_status[0] & 0xff;
-		seq  = frame_status[0] >> 16;
+		status = le32_to_cpu(frame_status[0]);
+		seq  = status >> 16;
 		idx = SEQ_TO_INDEX(seq);
 		txq_id = SEQ_TO_QUEUE(seq);
 
@@ -3561,23 +3564,22 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
-		tx_status->queue_number = tx_resp->status;
+		tx_status->queue_number = status & 0xff;
 		tx_status->queue_length = tx_resp->bt_kill_count;
 		tx_status->queue_length |= tx_resp->failure_rts;
 
 		tx_status->flags = iwl_is_tx_success(tx_resp->status)?
 			IEEE80211_TX_STATUS_ACK : 0;
-		tx_status->control.tx_rate = tx_resp->rate.s.rate |
-					     (tx_resp->rate.s.flags << 8);
+		tx_status->control.tx_rate =
+				iwl_hw_get_rate_n_flags(tx_resp->rate_n_flags);
 
 /* FIXME: code repetition end */
 
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x idx %d failure :%d\n",
 				    status & 0xff, idx, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY("Rate Info rate=%d flags=0x%x extf=0x%x\n",
-				    tx_resp->rate.s.rate, tx_resp->rate.s.flags,
-				    tx_resp->rate.s.ext_flags);
+		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n",
+				iwl_hw_get_rate_n_flags(tx_resp->rate_n_flags));
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -3585,8 +3587,8 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		int start = agg->start_idx;
 		for (i = 0; i < agg->frame_count; i++) {
 
-			status = frame_status[i] & 0xff;
-			seq  = frame_status[i] >> 16;
+			status = le32_to_cpu(frame_status[i]);
+			seq  = status >> 16;
 			idx = SEQ_TO_INDEX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
@@ -3629,7 +3631,7 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		agg->bitmap0 = bitmap & 0xFFFFFFFF;
 		agg->bitmap1 = bitmap >> 32;
 		agg->start_idx = start;
-		memcpy(&agg->rate, &tx_resp->rate, sizeof(agg->rate));
+		agg->rate_n_flags = cpu_to_le32(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%x\n",
 				agg->frame_count,
 				agg->start_idx,
@@ -3647,12 +3649,13 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	u16 sequence = pkt->hdr.sequence;
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_status *status;
-	struct iwl_tx_resp *resp = (void *)&pkt->u.raw[0];
+	struct ieee80211_tx_status *tx_status;
+	struct iwl_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	u32  status = le32_to_cpu(tx_resp->status);
 #if IWL == 4965
 #ifdef  CONFIG_IWLWIFI_HT
 #ifdef  CONFIG_IWLWIFI_HT_AGG
@@ -3673,8 +3676,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 #ifdef  CONFIG_IWLWIFI_HT
 #ifdef  CONFIG_IWLWIFI_HT_AGG
 	if (txq->sched_retry) {
-		const int scd_ssn = *((u32 *)&resp->status + resp->frame_count) &
-				      MAX_SN;
+		const u32 scd_ssn = iwl_get_scd_ssn(tx_resp);
 		struct ieee80211_hdr *hdr = iwl_tx_queue_get_hdr(priv, txq_id,
 								 index);
 		struct iwl_ht_agg *agg = NULL;
@@ -3695,10 +3697,11 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
-		iwl4965_tx_status_reply_tx(priv, agg, resp, index);
-
-		if ((resp->frame_count == 1) && !iwl_is_tx_success(resp->status) ) {
+		iwl4965_tx_status_reply_tx(priv, agg, tx_resp, index);
 
+		if ((tx_resp->frame_count == 1) &&
+		    !iwl_is_tx_success(status)) {
+			/* TODO: send BAR */
 		}
 
 		if (txq->q.last_used != (scd_ssn & 0xff)) {
@@ -3711,33 +3714,34 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 #endif /* CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
 #endif /* 4965 */
-	status = &(txq->txb[txq->q.last_used].status);
+	tx_status = &(txq->txb[txq->q.last_used].status);
 
-	status->retry_count = resp->failure_frame;
-	status->queue_number = resp->status;
-	status->queue_length = resp->bt_kill_count;
-	status->queue_length |= resp->failure_rts;
+	tx_status->retry_count = tx_resp->failure_frame;
+	tx_status->queue_number = status;
+	tx_status->queue_length = tx_resp->bt_kill_count;
+	tx_status->queue_length |= tx_resp->failure_rts;
 
-	status->flags =
-	    iwl_is_tx_success(resp->status) ? IEEE80211_TX_STATUS_ACK : 0;
+	tx_status->flags =
+	    iwl_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 
 #if IWL == 3945
 
-	status->control.tx_rate = iwl_rate_index_from_plcp(resp->rate);
+	tx_status->control.tx_rate = iwl_rate_index_from_plcp(tx_resp->rate);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
-		     txq_id, iwl_get_tx_fail_reason(resp->status),
-		     resp->status, resp->rate, resp->failure_frame);
+			txq_id, iwl_get_tx_fail_reason(status), status,
+			tx_resp->rate, tx_resp->failure_frame);
 
 #elif IWL == 4965
 
-	status->control.tx_rate = (u16) resp->rate.rate_n_flags;
+	tx_status->control.tx_rate =
+		iwl_hw_get_rate_n_flags(tx_resp->rate_n_flags);
 
-	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate 0x%x%02x	"
+	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
 			"retries %d\n",
-		     txq_id, iwl_get_tx_fail_reason(resp->status),
-		     resp->status, resp->rate.s.flags,
-		     resp->rate.s.rate, resp->failure_frame);
+			txq_id, iwl_get_tx_fail_reason(status),
+			status, le32_to_cpu(tx_resp->rate_n_flags),
+			tx_resp->failure_frame);
 #endif
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
@@ -3751,7 +3755,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 #endif /* CONFIG_IWLWIFI_HT */
 #endif /* 4965 */
 
-	if (iwl_check_bits(resp->status, TX_ABORT_REQUIRED_MSK))
+	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
@@ -3879,11 +3883,11 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 #if IWL == 3945
 	u8 rate = beacon->beacon_notify_hdr.rate;
 #elif IWL == 4965
-	u8 rate = beacon->beacon_notify_hdr.rate.s.rate;
+	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 #endif
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
-		le32_to_cpu(beacon->beacon_notify_hdr.status & TX_STATUS_MSK),
+		le32_to_cpu(beacon->beacon_notify_hdr.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
 		le32_to_cpu(beacon->ibss_mgr_status),
 		le32_to_cpu(beacon->high_tsf),
@@ -4129,9 +4133,10 @@ static void iwl_tx_cmd_complete(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	int txq_id = SEQ_TO_QUEUE(pkt->hdr.sequence);
-	int index = SEQ_TO_INDEX(pkt->hdr.sequence);
-	int is_huge = (pkt->hdr.sequence & SEQ_HUGE_FRAME);
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int index = SEQ_TO_INDEX(sequence);
+	int is_huge = (sequence & SEQ_HUGE_FRAME);
 	int cmd_index;
 	struct iwl_cmd *cmd;
 
@@ -4985,7 +4990,7 @@ static void iwl_error_recovery(struct iwl_priv *priv)
 	iwl_rxon_add_station(priv, priv->bssid, 1);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = priv->staging_rxon.assoc_id;
+	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
 	priv->error_recovering = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
@@ -7079,9 +7084,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
-	scan->tx_cmd.len =
-	    iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			       IWL_MAX_SCAN_SIZE - sizeof(scan), 0);
+	scan->tx_cmd.len = cpu_to_le16(
+		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
+			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = IWL_BROADCAST_ID;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
@@ -7089,7 +7094,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	/* flags + rate selection */
 
 #if IWL == 4965
-	scan->tx_cmd.tx_flags |= 0x200;
+	scan->tx_cmd.tx_flags |= cpu_to_le32(0x200);
 #endif
 
 	switch (priv->scan_bands) {
@@ -7102,6 +7107,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 				iwl_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
 				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
 #endif
+
 		scan->good_CRC_th = 0;
 		phymode = MODE_IEEE80211G;
 		break;
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index 0faf9c0..1942c8c 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -162,45 +162,43 @@ enum {
  */
 
 /* Tx flags */
-enum {
-	TX_CMD_FLG_RTS_MSK = (1 << 1),
-	TX_CMD_FLG_CTS_MSK = (1 << 2),
-	TX_CMD_FLG_ACK_MSK = (1 << 3),
-	TX_CMD_FLG_STA_RATE_MSK = (1 << 4),
-	TX_CMD_FLG_IMM_BA_RSP_MASK = (1 << 6),
-	TX_CMD_FLG_FULL_TXOP_PROT_MSK = (1 << 7),
-	TX_CMD_FLG_ANT_SEL_MSK = 0xf00,
-	TX_CMD_FLG_ANT_A_MSK = (1 << 8),
-	TX_CMD_FLG_ANT_B_MSK = (1 << 9),
+#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
+#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
+#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
 
-	/* ucode ignores BT priority for this frame */
-	TX_CMD_FLG_BT_DIS_MSK = (1 << 12),
+/* ucode ignores BT priority for this frame */
+#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
 
-	/* ucode overrides sequence control */
-	TX_CMD_FLG_SEQ_CTL_MSK = (1 << 13),
+/* ucode overrides sequence control */
+#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
 
-	/* signal that this frame is non-last MPDU */
-	TX_CMD_FLG_MORE_FRAG_MSK = (1 << 14),
+/* signal that this frame is non-last MPDU */
+#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
 
-	/* calculate TSF in outgoing frame */
-	TX_CMD_FLG_TSF_MSK = (1 << 16),
+/* calculate TSF in outgoing frame */
+#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
 
-	/* activate TX calibration. */
-	TX_CMD_FLG_CALIB_MSK = (1 << 17),
+/* activate TX calibration. */
+#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
 
-	/* signals that 2 bytes pad was inserted
-	 * after the MAC header */
-	TX_CMD_FLG_MH_PAD_MSK = (1 << 20),
+/* signals that 2 bytes pad was inserted
+   after the MAC header */
+#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
 
-	/* HCCA-AP - disable duration overwriting. */
-	TX_CMD_FLG_DUR_MSK = (1 << 25),
-};
+/* HCCA-AP - disable duration overwriting. */
+#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
 
 /*
  * TX command security control
  */
-#define TX_CMD_SEC_CCM               0x2
-#define TX_CMD_SEC_TKIP              0x3
+#define TX_CMD_SEC_CCM  	0x2
+#define TX_CMD_SEC_TKIP		0x3
 
 /*
  * TX command Frame life time
@@ -313,11 +311,9 @@ enum {
 	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
 };
 
-enum {
-	TX_PACKET_MODE_REGULAR = 0x0000,
-	TX_PACKET_MODE_BURST_PART = 0x00100,
-	TX_PACKET_MODE_BURST_FIRST = 0x0200,
-};
+#define	TX_PACKET_MODE_REGULAR		0x0000
+#define	TX_PACKET_MODE_BURST_SEQ	0x0100
+#define	TX_PACKET_MODE_BURST_FIRST	0x0200
 
 enum {
 	TX_POWER_PA_NOT_ACTIVE = 0x0,
@@ -365,27 +361,32 @@ enum {
 #define AGG_TX_STATE_SEQ_NUM_POS 16
 #define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
 
-struct iwl_tx_resp {
 #if IWL == 4965
+struct iwl_tx_resp {
 	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
 	u8 bt_kill_count;
-#endif
 	u8 failure_rts;
 	u8 failure_frame;
-#if IWL == 3945
-	u8 bt_kill_count;
-	u8 rate;
-	__le32 wireless_media_time;
-#elif IWL == 4965
-	struct iwl_rate rate;
+	__le32 rate_n_flags;
 	__le16 wireless_media_time;
 	__le16 reserved;
 	__le32 pa_power1;
 	__le32 pa_power2;
-#endif
 	__le32 status;	/* TX status (for aggregation status of 1st frame) */
 } __attribute__ ((packed));
 
+#elif IWL == 3945
+struct iwl_tx_resp {
+	u8 failure_rts;
+	u8 failure_frame;
+	u8 bt_kill_count;
+	u8 rate;
+	__le32 wireless_media_time;
+	__le32 status;	/* TX status (for aggregation status of 1st frame) */
+} __attribute__ ((packed));
+#endif
+
+
 /* TX command response is sent after *all* transmission attempts.
  *
  * NOTES:
@@ -441,8 +442,7 @@ struct iwl_ssid_ie {
 } __attribute__ ((packed));
 
 #define PROBE_OPTION_MAX        0x4
-#define TX_CMD_FLG_SEQ_CTL_MSK  0x2000
-#define TX_CMD_LIFE_TIME_INFINITE       0xFFFFFFFF
+#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
 
 #define IWL_MAX_SCAN_SIZE 1024
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 0cc341b..933a367 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -1207,7 +1207,7 @@ struct statistics {
 #define IWL_TX_QUEUE_HCCA_1     5
 #define IWL_TX_QUEUE_HCCA_2     6
 
-#define U32_PAD(n)                     ((4-(n%4))%4)
+#define U32_PAD(n)		((4-(n))&0x3)
 
 #define AC_BE_TID_MASK 0x9	/* TID 0 and 3 */
 #define AC_BK_TID_MASK 0x6	/* TID 1 and 2 */
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index dff6f6f..3de6425 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -229,9 +229,10 @@ struct iwl_frame {
 #define SEQ_TO_INDEX(x) (x & 0xff)
 #define INDEX_TO_SEQ(x) (x & 0xff)
 #define SEQ_HUGE_FRAME  (0x4000)
-#define SEQ_RX_FRAME    (0x8000)
+#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn) (((ssn) << 4 ) & IEEE80211_SCTL_SEQ)
+#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
 enum {
 	/* CMD_SIZE_NORMAL = 0, */
@@ -398,7 +399,7 @@ struct iwl_ht_agg {
 	u16 start_idx;
 	u32 bitmap0;
 	u32 bitmap1;
-	struct iwl_rate rate;
+	u32 rate_n_flags;
 };
 #endif /* CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
-- 
1.5.2
