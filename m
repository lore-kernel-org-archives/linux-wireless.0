Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYLVDir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:47 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/10] iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
Date: Mon, 22 Dec 2008 11:31:19 +0800
Message-Id: <1229916683-9772-7-git-send-email-yi.zhu@intel.com> (sfid-20081222_043856_782227_1A12532E)
In-Reply-To: <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

The patch replaces iwl_tx_cmd with iwl3945_tx_cmd to complete
transitions introduced by commit
77cb4db173d72d1a8c6c89015784a815bfd85221 "iwlwifi: use iwl_cmd instead
of iwl3945_cmd"

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   64 ++++++++++++++-------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7cace6d..32cfc8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2047,36 +2047,37 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int last_frag)
 {
+	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 	struct iwl3945_hw_key *keyinfo =
 	    &priv->stations_39[info->control.hw_key->hw_key_idx].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
+		tx->sec_ctl = TX_CMD_SEC_CCM;
+		memcpy(tx->key, keyinfo->key, keyinfo->keylen);
 		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
 #if 0
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
+		tx->sec_ctl = TX_CMD_SEC_TKIP;
 
 		if (last_frag)
-			memcpy(cmd->cmd.tx.tkip_mic.byte, skb_frag->tail - 8,
+			memcpy(tx->tkip_mic.byte, skb_frag->tail - 8,
 			       8);
 		else
-			memset(cmd->cmd.tx.tkip_mic.byte, 0, 8);
+			memset(tx->tkip_mic.byte, 0, 8);
 #endif
 		break;
 
 	case ALG_WEP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_WEP |
+		tx->sec_ctl = TX_CMD_SEC_WEP |
 		    (info->control.hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
 		if (keyinfo->keylen == 13)
-			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
+			tx->sec_ctl |= TX_CMD_SEC_KEY128;
 
-		memcpy(&cmd->cmd.tx.key[3], keyinfo->key, keyinfo->keylen);
+		memcpy(&tx->key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
 			     "with key %d\n", info->control.hw_key->hw_key_idx);
@@ -2094,14 +2095,14 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct iwl_cmd *cmd,
 				  struct ieee80211_tx_info *info,
-				  struct ieee80211_hdr *hdr,
-				  int is_unicast, u8 std_id)
+				  struct ieee80211_hdr *hdr, u8 std_id)
 {
+	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
+	__le32 tx_flags = tx->tx_flags;
 	__le16 fc = hdr->frame_control;
-	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 	u8 rc_flags = info->control.rates[0].flags;
 
-	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	tx->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if (ieee80211_is_mgmt(fc))
@@ -2114,13 +2115,13 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	cmd->cmd.tx.sta_id = std_id;
+	tx->sta_id = std_id;
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
+		tx->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
@@ -2140,16 +2141,16 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
 		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
+			tx->timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
+			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
-		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
+		tx->timeout.pm_frame_timeout = 0;
 	}
 
-	cmd->cmd.tx.driver_txop = 0;
-	cmd->cmd.tx.tx_flags = tx_flags;
-	cmd->cmd.tx.next_frame_len = 0;
+	tx->driver_txop = 0;
+	tx->tx_flags = tx_flags;
+	tx->next_frame_len = 0;
 }
 
 /**
@@ -2220,12 +2221,13 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl3945_tfd *tfd;
-	int txq_id = skb_get_queue_mapping(skb);
+	struct iwl3945_tx_cmd *tx;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
+	struct iwl_cmd *out_cmd = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
-	struct iwl_cmd *out_cmd = NULL;
+	int txq_id = skb_get_queue_mapping(skb);
 	u16 len, idx, len_org, hdr_len;
 	u8 id;
 	u8 unicast;
@@ -2316,8 +2318,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
+	tx = (struct iwl3945_tx_cmd *)out_cmd->cmd.payload;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
+	memset(tx, 0, sizeof(*tx));
 
 	/*
 	 * Set up the Tx-command (not MAC!) header.
@@ -2330,7 +2333,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
+	memcpy(tx->hdr, hdr, hdr_len);
 
 	/*
 	 * Use the first empty entry in this queue's command buffer array
@@ -2390,16 +2393,16 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
-	out_cmd->cmd.tx.len = cpu_to_le16(len);
+	tx->len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
-	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, unicast, sta_id);
+	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, sta_id);
 
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
 
-	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
-	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
+	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
+	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -2410,10 +2413,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
-	iwl_print_hex_dump(priv, IWL_DL_TX, out_cmd->cmd.payload,
-			   sizeof(out_cmd->cmd.tx));
+	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
 
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
-- 
1.5.3.6

