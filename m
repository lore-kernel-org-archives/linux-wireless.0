Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37978 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752521AbdBCOjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:39:44 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:02 +0200
Message-Id: <20170203143812.7525-16-luca@coelho.fi> (sfid-20170203_153947_931599_0BDC39F7)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm/pcie: adjust A-MSDU tx_cmd length in PCIe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of setting the tx_cmd length in the mvm code, which is
complicated by the fact that DQA may want to temporarily store
the SKB on the side, adjust the length in the PCIe code which
also knows about this since it's responsible for duplicating
all those headers that are account for in this code.

As the PCIe code already relies on the tx_cmd->len field, this
doesn't really introduce any new dependencies.

To make this possible we need to move the memcpy() of the TX
command until after it was updated.

This does even simplify the code though, since the PCIe code
already does a lot of manipulations to build A-MSDUs correctly
and changing the length becomes a simple operation to see how
much was added/removed, rather than predicting it.

Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  | 38 +++-------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 23 ++++++++++++++---
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0dcf0ebab45d..8daf4fbe4534 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -202,7 +202,6 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 			struct iwl_tx_cmd *tx_cmd,
 			struct ieee80211_tx_info *info, u8 sta_id)
 {
-	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	__le16 fc = hdr->frame_control;
 	u32 tx_flags = le32_to_cpu(tx_cmd->tx_flags);
@@ -284,9 +283,8 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_flags |= TX_CMD_FLG_WRITE_TX_POWER;
 
 	tx_cmd->tx_flags = cpu_to_le32(tx_flags);
-	/* Total # bytes to be transmitted */
-	tx_cmd->len = cpu_to_le16((u16)skb->len +
-		(uintptr_t)skb_info->driver_data[0]);
+	/* Total # bytes to be transmitted - PCIe code will adjust for A-MSDU */
+	tx_cmd->len = cpu_to_le16((u16)skb->len);
 	tx_cmd->life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	tx_cmd->sta_id = sta_id;
 
@@ -562,9 +560,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			  info.hw_queue != info.control.vif->cab_queue)))
 		return -1;
 
-	/* This holds the amsdu headers length */
-	skb_info->driver_data[0] = (void *)(uintptr_t)0;
-
 	queue = info.hw_queue;
 
 	/*
@@ -651,7 +646,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
 	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
 	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
-	u16 amsdu_add, snap_ip_tcp, pad, i = 0;
+	u16 snap_ip_tcp, pad, i = 0;
 	unsigned int dbg_max_amsdu_len;
 	netdev_features_t netdev_features = NETIF_F_CSUM_MASK | NETIF_F_SG;
 	u8 *qc, tid, txf;
@@ -753,21 +748,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	/* This skb fits in one single A-MSDU */
 	if (num_subframes * mss >= tcp_payload_len) {
-		struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
-
-		/*
-		 * Compute the length of all the data added for the A-MSDU.
-		 * This will be used to compute the length to write in the TX
-		 * command. We have: SNAP + IP + TCP for n -1 subframes and
-		 * ETH header for n subframes. Note that the original skb
-		 * already had one set of SNAP / IP / TCP headers.
-		 */
-		num_subframes = DIV_ROUND_UP(tcp_payload_len, mss);
-		amsdu_add = num_subframes * sizeof(struct ethhdr) +
-			(num_subframes - 1) * (snap_ip_tcp + pad);
-		/* This holds the amsdu headers length */
-		skb_info->driver_data[0] = (void *)(uintptr_t)amsdu_add;
-
 		__skb_queue_tail(mpdus_skb, skb);
 		return 0;
 	}
@@ -806,14 +786,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 			ip_hdr(tmp)->id = htons(ip_base_id + i * num_subframes);
 
 		if (tcp_payload_len > mss) {
-			struct ieee80211_tx_info *skb_info =
-				IEEE80211_SKB_CB(tmp);
-
-			num_subframes = DIV_ROUND_UP(tcp_payload_len, mss);
-			amsdu_add = num_subframes * sizeof(struct ethhdr) +
-				(num_subframes - 1) * (snap_ip_tcp + pad);
-			skb_info->driver_data[0] =
-				(void *)(uintptr_t)amsdu_add;
 			skb_shinfo(tmp)->gso_size = mss;
 		} else {
 			qc = ieee80211_get_qos_ctl((void *)tmp->data);
@@ -1059,7 +1031,6 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 		   struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_info info;
 	struct sk_buff_head mpdus_skbs;
 	unsigned int payload_len;
@@ -1073,9 +1044,6 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	memcpy(&info, skb->cb, sizeof(info));
 
-	/* This holds the amsdu headers length */
-	skb_info->driver_data[0] = (void *)(uintptr_t)0;
-
 	if (!skb_is_gso(skb))
 		return iwl_mvm_tx_mpdu(mvm, skb, &info, sta);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index e44e5adc2b95..911cf9868107 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2096,6 +2096,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_cmd_meta *out_meta,
 				   struct iwl_device_cmd *dev_cmd, u16 tb1_len)
 {
+	struct iwl_tx_cmd *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
@@ -2145,6 +2146,13 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	 */
 	skb_pull(skb, hdr_len + iv_len);
 
+	/*
+	 * Remove the length of all the headers that we don't actually
+	 * have in the MPDU by themselves, but that we duplicate into
+	 * all the different MSDUs inside the A-MSDU.
+	 */
+	le16_add_cpu(&tx_cmd->len, -snap_ip_tcp_hdrlen);
+
 	tso_start(skb, &tso);
 
 	while (total_len) {
@@ -2155,7 +2163,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 		unsigned int hdr_tb_len;
 		dma_addr_t hdr_tb_phys;
 		struct tcphdr *tcph;
-		u8 *iph;
+		u8 *iph, *subf_hdrs_start = hdr_page->pos;
 
 		total_len -= data_left;
 
@@ -2216,6 +2224,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 				       hdr_tb_len, false);
 		trace_iwlwifi_dev_tx_tso_chunk(trans->dev, start_hdr,
 					       hdr_tb_len);
+		/* add this subframe's headers' length to the tx_cmd */
+		le16_add_cpu(&tx_cmd->len, hdr_page->pos - subf_hdrs_start);
 
 		/* prepare the start_hdr for the next subframe */
 		start_hdr = hdr_page->pos;
@@ -2408,9 +2418,10 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		tb1_len = len;
 	}
 
-	/* The first TB points to bi-directional DMA data */
-	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
-	       IWL_FIRST_TB_SIZE);
+	/*
+	 * The first TB points to bi-directional DMA data, we'll
+	 * memcpy the data into it later.
+	 */
 	iwl_pcie_txq_build_tfd(trans, txq, tb0_phys,
 			       IWL_FIRST_TB_SIZE, true);
 
@@ -2434,6 +2445,10 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	}
 
+	/* building the A-MSDU might have changed this data, so memcpy it now */
+	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
+	       IWL_FIRST_TB_SIZE);
+
 	tfd = iwl_pcie_get_tfd(trans_pcie, txq, txq->write_ptr);
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
-- 
2.11.0
