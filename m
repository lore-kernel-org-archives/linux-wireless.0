Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33035 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965018AbcAUNM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:12:27 -0500
Received: by mail-lf0-f42.google.com with SMTP id m198so26302592lfm.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:12:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: implement basic support for new tx path firmware
Date: Thu, 21 Jan 2016 14:13:27 +0100
Message-Id: <1453382007-24622-6-git-send-email-michal.kazior@tieto.com> (sfid-20160121_141234_262903_7D5AC254)
In-Reply-To: <1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
 <1453382007-24622-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to use the new firmware which
implements the new tx data path. Without this
patch firmware supporting new tx path stops
responding shortly after booting.

This patch doesn't implement the entire pull-push
logic available in the new firmware. This will be
done in subsequent patches.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  8 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 88 +++++++++++++++++++++++++++++---
 3 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 0c5628dafabf..13391ea4422d 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1665,6 +1665,14 @@ struct ath10k_htt {
 		dma_addr_t paddr;
 		struct ath10k_htt_txbuf *vaddr;
 	} txbuf;
+
+	struct {
+		struct htt_q_state *vaddr;
+		dma_addr_t paddr;
+		u16 num_peers;
+		u16 num_tids;
+		enum htt_q_depth_type type;
+	} tx_q_state;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d923f64e4f42..248405b53ef4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2123,10 +2123,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case HTT_T2H_MSG_TYPE_AGGR_CONF:
 		break;
-	case HTT_T2H_MSG_TYPE_EN_STATS:
 	case HTT_T2H_MSG_TYPE_TX_FETCH_IND:
 	case HTT_T2H_MSG_TYPE_TX_FETCH_CONFIRM:
 	case HTT_T2H_MSG_TYPE_TX_MODE_SWITCH_IND:
+		/* TODO: Implement pull-push logic */
+		break;
+	case HTT_T2H_MSG_TYPE_EN_STATS:
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
 			    resp->hdr.msg_type);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 28b8d7af8506..95acb727c068 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -132,6 +132,50 @@ static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
 	return 0;
 }
 
+static void ath10k_htt_tx_free_txq(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	size_t size;
+
+	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+		return;
+
+	size = sizeof(*htt->tx_q_state.vaddr);
+
+	dma_unmap_single(ar->dev, htt->tx_q_state.paddr, size, DMA_TO_DEVICE);
+	kfree(htt->tx_q_state.vaddr);
+}
+
+static int ath10k_htt_tx_alloc_txq(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	size_t size;
+	int ret;
+
+	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+		return 0;
+
+	htt->tx_q_state.num_peers = HTT_TX_Q_STATE_NUM_PEERS;
+	htt->tx_q_state.num_tids = HTT_TX_Q_STATE_NUM_TIDS;
+	htt->tx_q_state.type = HTT_Q_DEPTH_TYPE_BYTES;
+
+	size = sizeof(*htt->tx_q_state.vaddr);
+	htt->tx_q_state.vaddr = kzalloc(size, GFP_KERNEL);
+	if (!htt->tx_q_state.vaddr)
+		return -ENOMEM;
+
+	htt->tx_q_state.paddr = dma_map_single(ar->dev, htt->tx_q_state.vaddr,
+					       size, DMA_TO_DEVICE);
+	ret = dma_mapping_error(ar->dev, htt->tx_q_state.paddr);
+	if (ret) {
+		ath10k_warn(ar, "failed to dma map tx_q_state: %d\n", ret);
+		kfree(htt->tx_q_state.vaddr);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
@@ -159,8 +203,17 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 		goto free_txbuf;
 	}
 
+	ret = ath10k_htt_tx_alloc_txq(htt);
+	if (ret) {
+		ath10k_err(ar, "failed to alloc txq: %d\n", ret);
+		goto free_frag_desc;
+	}
+
 	return 0;
 
+free_frag_desc:
+	ath10k_htt_tx_free_cont_frag_desc(htt);
+
 free_txbuf:
 	size = htt->max_num_pending_tx *
 			  sizeof(struct ath10k_htt_txbuf);
@@ -203,6 +256,7 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 				  htt->txbuf.paddr);
 	}
 
+	ath10k_htt_tx_free_txq(htt);
 	ath10k_htt_tx_free_cont_frag_desc(htt);
 }
 
@@ -292,7 +346,9 @@ int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
 	struct ath10k *ar = htt->ar;
 	struct sk_buff *skb;
 	struct htt_cmd *cmd;
+	struct htt_frag_desc_bank_cfg *cfg;
 	int ret, size;
+	u8 info;
 
 	if (!ar->hw_params.continuous_frag_desc)
 		return 0;
@@ -310,14 +366,30 @@ int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
 	skb_put(skb, size);
 	cmd = (struct htt_cmd *)skb->data;
 	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG;
-	cmd->frag_desc_bank_cfg.info = 0;
-	cmd->frag_desc_bank_cfg.num_banks = 1;
-	cmd->frag_desc_bank_cfg.desc_size = sizeof(struct htt_msdu_ext_desc);
-	cmd->frag_desc_bank_cfg.bank_base_addrs[0] =
-				__cpu_to_le32(htt->frag_desc.paddr);
-	cmd->frag_desc_bank_cfg.bank_id[0].bank_min_id = 0;
-	cmd->frag_desc_bank_cfg.bank_id[0].bank_max_id =
-				__cpu_to_le16(htt->max_num_pending_tx - 1);
+
+	info = 0;
+	info |= SM(htt->tx_q_state.type,
+		   HTT_FRAG_DESC_BANK_CFG_INFO_Q_STATE_DEPTH_TYPE);
+
+	if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL, ar->fw_features))
+		info |= HTT_FRAG_DESC_BANK_CFG_INFO_Q_STATE_VALID;
+
+	cfg = &cmd->frag_desc_bank_cfg;
+	cfg->info = info;
+	cfg->num_banks = 1;
+	cfg->desc_size = sizeof(struct htt_msdu_ext_desc);
+	cfg->bank_base_addrs[0] = __cpu_to_le32(htt->frag_desc.paddr);
+	cfg->bank_id[0].bank_min_id = 0;
+	cfg->bank_id[0].bank_max_id = __cpu_to_le16(htt->max_num_pending_tx -
+						    1);
+
+	cfg->q_state.paddr = cpu_to_le32(htt->tx_q_state.paddr);
+	cfg->q_state.num_peers = cpu_to_le16(htt->tx_q_state.num_peers);
+	cfg->q_state.num_tids = cpu_to_le16(htt->tx_q_state.num_tids);
+	cfg->q_state.record_size = HTT_TX_Q_STATE_ENTRY_SIZE;
+	cfg->q_state.record_multiplier = HTT_TX_Q_STATE_ENTRY_MULTIPLIER;
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt frag desc bank cmd\n");
 
 	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
-- 
2.1.4

