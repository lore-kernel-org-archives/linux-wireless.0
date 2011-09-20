Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60245 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab1ITXX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/8] iwlagn: simplify the iwl_device_cmd layout
Date: Tue, 20 Sep 2011 15:37:24 -0700
Message-Id: <1316558247-10018-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012345_292079_CEF1749F)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This simplifies both the transport layer and the upper layer.

Kill the union in the device command, which avoids the funny syntax
we had: cmd->cmd.payload.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   12 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   10 +---------
 5 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 4aa414a..abb702d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -322,7 +322,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock_sta;
 
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
-	tx_cmd = &dev_cmd->cmd.tx;
+	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 7028f90..580a4d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -127,7 +127,7 @@ int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_addsta_cmd *addsta =
-		(struct iwl_addsta_cmd *)cmd->cmd.payload;
+		(struct iwl_addsta_cmd *) cmd->payload;
 
 	return iwl_process_add_sta_resp(priv, addsta, pkt);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 48ef6c2..ee7059d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -59,13 +59,15 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 	u8 sta_id = 0;
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
+	struct iwl_tx_cmd *tx_cmd =
+		(struct iwl_tx_cmd *) txq->cmd[txq->q.write_ptr]->payload;
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 
 	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+	sta_id = tx_cmd->sta_id;
+	sec_ctl = tx_cmd->sec_ctl;
 
 	switch (sec_ctl & TX_CMD_SEC_MSK) {
 	case TX_CMD_SEC_CCM:
@@ -353,11 +355,13 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 	int read_ptr = txq->q.read_ptr;
 	u8 sta_id = 0;
 	__le16 bc_ent;
+	struct iwl_tx_cmd *tx_cmd =
+		(struct iwl_tx_cmd *) txq->cmd[txq->q.read_ptr]->payload;
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
 	if (txq_id != trans->shrd->cmd_queue)
-		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
+		sta_id = tx_cmd->sta_id;
 
 	bc_ent = cpu_to_le16(1 | (sta_id << 12));
 	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
@@ -773,7 +777,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	/* and copy the data that needs to be copied */
 
-	cmd_dest = &out_cmd->cmd.payload[0];
+	cmd_dest = out_cmd->payload;
 	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
 		if (!cmd->len[i])
 			continue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ca13eeb..dbb7eb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1043,7 +1043,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl_tx_cmd *tx_cmd = &dev_cmd->cmd.tx;
+	struct iwl_tx_cmd *tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ddb7741..c592312 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -97,15 +97,7 @@ enum {
  */
 struct iwl_device_cmd {
 	struct iwl_cmd_header hdr;	/* uCode API */
-	union {
-		u32 flags;
-		u8 val8;
-		u16 val16;
-		u32 val32;
-		struct iwl_tx_cmd tx;
-		struct iwl6000_channel_switch_cmd chswitch;
-		u8 payload[DEF_CMD_PAYLOAD_SIZE];
-	} __packed cmd;
+	u8 payload[DEF_CMD_PAYLOAD_SIZE];
 } __packed;
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
-- 
1.7.0.4

