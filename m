Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761395AbZJIUW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/17] iwl3945: rename tx to tx_cmd
Date: Fri,  9 Oct 2009 13:20:31 -0700
Message-Id: <1255119634-3060-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Rename iwl3945_tx_cmd variable tx to tx_cmd for better
readability.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   20 +++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 +++++++++++++-------------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1372ce4..a6944bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -785,10 +785,10 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	u8 data_retry_limit;
 	__le32 tx_flags;
 	__le16 fc = hdr->frame_control;
-	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
+	struct iwl3945_tx_cmd *tx_cmd = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 
 	rate = iwl3945_rates[rate_index].plcp;
-	tx_flags = tx->tx_flags;
+	tx_flags = tx_cmd->tx_flags;
 
 	/* We need to figure out how to get the sta->supp_rates while
 	 * in this running context */
@@ -825,22 +825,22 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		}
 	}
 
-	tx->rts_retry_limit = rts_retry_limit;
-	tx->data_retry_limit = data_retry_limit;
-	tx->rate = rate;
-	tx->tx_flags = tx_flags;
+	tx_cmd->rts_retry_limit = rts_retry_limit;
+	tx_cmd->data_retry_limit = data_retry_limit;
+	tx_cmd->rate = rate;
+	tx_cmd->tx_flags = tx_flags;
 
 	/* OFDM */
-	tx->supp_rates[0] =
+	tx_cmd->supp_rates[0] =
 	   ((rate_mask & IWL_OFDM_RATES_MASK) >> IWL_FIRST_OFDM_RATE) & 0xFF;
 
 	/* CCK */
-	tx->supp_rates[1] = (rate_mask & 0xF);
+	tx_cmd->supp_rates[1] = (rate_mask & 0xF);
 
 	IWL_DEBUG_RATE(priv, "Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
 		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
-		       tx->rate, le32_to_cpu(tx->tx_flags),
-		       tx->supp_rates[1], tx->supp_rates[0]);
+		       tx_cmd->rate, le32_to_cpu(tx_cmd->tx_flags),
+		       tx_cmd->supp_rates[1], tx_cmd->supp_rates[0]);
 }
 
 u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f4d4353..03612b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -365,13 +365,13 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
-	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
+	struct iwl3945_tx_cmd *tx_cmd = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
-		tx->sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(tx->key, keyinfo->key, keyinfo->keylen);
+		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
+		memcpy(tx_cmd->key, keyinfo->key, keyinfo->keylen);
 		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
@@ -379,13 +379,13 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_WEP:
-		tx->sec_ctl = TX_CMD_SEC_WEP |
+		tx_cmd->sec_ctl = TX_CMD_SEC_WEP |
 		    (info->control.hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
 		if (keyinfo->keylen == 13)
-			tx->sec_ctl |= TX_CMD_SEC_KEY128;
+			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
 
-		memcpy(&tx->key[3], keyinfo->key, keyinfo->keylen);
+		memcpy(&tx_cmd->key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
 			     "with key %d\n", info->control.hw_key->hw_key_idx);
@@ -405,11 +405,11 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr, u8 std_id)
 {
-	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
-	__le32 tx_flags = tx->tx_flags;
+	struct iwl3945_tx_cmd *tx_cmd = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
+	__le32 tx_flags = tx_cmd->tx_flags;
 	__le16 fc = hdr->frame_control;
 
-	tx->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if (ieee80211_is_mgmt(fc))
@@ -422,13 +422,13 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	tx->sta_id = std_id;
+	tx_cmd->sta_id = std_id;
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		tx->tid_tspec = qc[0] & 0xf;
+		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
@@ -442,16 +442,16 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
 		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
-			tx->timeout.pm_frame_timeout = cpu_to_le16(3);
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
-			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
-		tx->timeout.pm_frame_timeout = 0;
+		tx_cmd->timeout.pm_frame_timeout = 0;
 	}
 
-	tx->driver_txop = 0;
-	tx->tx_flags = tx_flags;
-	tx->next_frame_len = 0;
+	tx_cmd->driver_txop = 0;
+	tx_cmd->tx_flags = tx_flags;
+	tx_cmd->next_frame_len = 0;
 }
 
 /*
@@ -461,7 +461,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl3945_tx_cmd *tx;
+	struct iwl3945_tx_cmd *tx_cmd;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
 	struct iwl_device_cmd *out_cmd;
@@ -560,9 +560,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
-	tx = (struct iwl3945_tx_cmd *)out_cmd->cmd.payload;
+	tx_cmd = (struct iwl3945_tx_cmd *)out_cmd->cmd.payload;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(tx, 0, sizeof(*tx));
+	memset(tx_cmd, 0, sizeof(*tx_cmd));
 
 	/*
 	 * Set up the Tx-command (not MAC!) header.
@@ -575,7 +575,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(tx->hdr, hdr, hdr_len);
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
 
 	if (info->control.hw_key)
@@ -589,12 +589,12 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
-	tx->len = cpu_to_le16(len);
+	tx_cmd->len = cpu_to_le16(len);
 
 	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 	iwl_update_stats(priv, true, fc, len);
-	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
-	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
+	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
+	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -607,9 +607,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
+	iwl_print_hex_dump(priv, IWL_DL_TX, tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr,
 			   ieee80211_hdrlen(fc));
 
 	/*
-- 
1.5.6.3

