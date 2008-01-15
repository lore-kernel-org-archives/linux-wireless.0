Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbYAOC04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/12] iwlwifi: remove iwl4965_tx_cmd
Date: Mon, 14 Jan 2008 17:46:16 -0800
Message-Id: <1200361585-31801-4-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022707_377832_15863BD0)
In-Reply-To: <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes iwl4965_tx_cmd function and splits its content to
iwl4965_hw_build_tx_cmd_rate, iwl4965_build_tx_cmd_basic,
and iwl4965_tl_get_stats function. The latest one will be deprecated
when traffic load will move to rate scale module.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  112 +++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   19 ++++-
 3 files changed, 55 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a945788..e6a0397 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2673,19 +2673,23 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl4965_priv *priv,
 			      struct ieee80211_hdr *hdr, int sta_id,
 			      int is_hcca)
 {
-	u8 rate;
+	struct iwl4965_tx_cmd *tx = &cmd->cmd.tx;
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
-	__le32 tx_flags;
 	u16 fc = le16_to_cpu(hdr->frame_control);
+	u8 rate_plcp;
+	u16 rate_flags = 0;
+	int rate_idx = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
 
-	tx_flags = cmd->cmd.tx.tx_flags;
-
-	rate = iwl4965_rates[ctrl->tx_rate].plcp;
+	rate_plcp = iwl4965_rates[rate_idx].plcp;
 
 	rts_retry_limit = (is_hcca) ?
 	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
 
+	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+
 	if (ieee80211_is_probe_response(fc)) {
 		data_retry_limit = 3;
 		if (data_retry_limit < rts_retry_limit)
@@ -2696,26 +2700,38 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl4965_priv *priv,
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
 
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
+
+	if (ieee80211_is_data(fc)) {
+		tx->initial_rate_index = 0;
+		tx->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
+	} else {
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_AUTH:
 		case IEEE80211_STYPE_DEAUTH:
 		case IEEE80211_STYPE_ASSOC_REQ:
 		case IEEE80211_STYPE_REASSOC_REQ:
-			if (tx_flags & TX_CMD_FLG_RTS_MSK) {
-				tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-				tx_flags |= TX_CMD_FLG_CTS_MSK;
+			if (tx->tx_flags & TX_CMD_FLG_RTS_MSK) {
+				tx->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+				tx->tx_flags |= TX_CMD_FLG_CTS_MSK;
 			}
 			break;
 		default:
 			break;
 		}
+
+		/* Alternate between antenna A and B for successive frames */
+		if (priv->use_ant_b_for_management_frame) {
+			priv->use_ant_b_for_management_frame = 0;
+			rate_flags |= RATE_MCS_ANT_B_MSK;
+		} else {
+			priv->use_ant_b_for_management_frame = 1;
+			rate_flags |= RATE_MCS_ANT_A_MSK;
+		}
 	}
 
-	cmd->cmd.tx.rts_retry_limit = rts_retry_limit;
-	cmd->cmd.tx.data_retry_limit = data_retry_limit;
-	cmd->cmd.tx.rate_n_flags = iwl4965_hw_set_rate_n_flags(rate, 0);
-	cmd->cmd.tx.tx_flags = tx_flags;
+	tx->rts_retry_limit = rts_retry_limit;
+	tx->data_retry_limit = data_retry_limit;
+	tx->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }
 
 int iwl4965_hw_get_rx_read(struct iwl4965_priv *priv)
@@ -3254,69 +3270,13 @@ static void iwl4965_bg_agg_work(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
 	return;
 }
-#endif /*CONFIG_IWL4965_HT_AGG */
-#endif /* CONFIG_IWL4965_HT */
 
-int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
-		   u8 sta_id, dma_addr_t txcmd_phys,
-		   struct ieee80211_hdr *hdr, u8 hdr_len,
-		   struct ieee80211_tx_control *ctrl, void *sta_in)
+/* TODO: move this functionality to rate scaling */
+void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
+		   struct ieee80211_hdr *hdr)
 {
-	struct iwl4965_tx_cmd *tx = &out_cmd->cmd.tx;
-	dma_addr_t scratch_phys;
-	u8 unicast = 0;
-	u8 is_data = 1;
-	u16 fc;
-	u16 rate_flags;
-	int rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
-#ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-	__le16 *qc;
-#endif /*CONFIG_IWL4965_HT_AGG */
-#endif /* CONFIG_IWL4965_HT */
-
-	unicast = !is_multicast_ether_addr(hdr->addr1);
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
-		is_data = 0;
+	__le16 *qc = ieee80211_get_qos_ctrl(hdr);
 
-	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
-	    offsetof(struct iwl4965_tx_cmd, scratch);
-	tx->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
-
-	/* Hard coded to start at the highest retry fallback position
-	 * until the 4965 specific rate control algorithm is tied in */
-	tx->initial_rate_index = LINK_QUAL_MAX_RETRY_NUM - 1;
-
-	/* Alternate between antenna A and B for successive frames */
-	if (priv->use_ant_b_for_management_frame) {
-		priv->use_ant_b_for_management_frame = 0;
-		rate_flags = RATE_MCS_ANT_B_MSK;
-	} else {
-		priv->use_ant_b_for_management_frame = 1;
-		rate_flags = RATE_MCS_ANT_A_MSK;
-	}
-
-	if (!unicast || !is_data) {
-		if ((rate_index >= IWL_FIRST_CCK_RATE) &&
-		    (rate_index <= IWL_LAST_CCK_RATE))
-			rate_flags |= RATE_MCS_CCK_MSK;
-	} else {
-		tx->initial_rate_index = 0;
-		tx->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
-	}
-
-	tx->rate_n_flags = iwl4965_hw_set_rate_n_flags(iwl4965_rates[rate_index].plcp,
-						rate_flags);
-
-	if (ieee80211_is_back_request(fc))
-		tx->tx_flags |= TX_CMD_FLG_ACK_MSK |
-			TX_CMD_FLG_IMM_BA_RSP_MASK;
-#ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc &&
 	    (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
 		u8 tid = 0;
@@ -3334,11 +3294,11 @@ int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
 		spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
 		schedule_work(&priv->agg_work);
 	}
-#endif
-#endif
-	return 0;
 }
 
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
+
 /**
  * sign_extend - Sign extend a value using specified bit as sign-bit
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index c386482..78bc148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -758,10 +758,6 @@ extern int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 extern void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr,
 				int is_ap);
 extern void iwl4965_set_rxon_chain(struct iwl4965_priv *priv);
-extern int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
-			  u8 sta_id, dma_addr_t txcmd_phys,
-			  struct ieee80211_hdr *hdr, u8 hdr_len,
-			  struct ieee80211_tx_control *ctrl, void *sta_in);
 extern int iwl4965_alive_notify(struct iwl4965_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl4965_priv *priv, u8 mode);
 extern void iwl4965_chain_noise_reset(struct iwl4965_priv *priv);
@@ -789,6 +785,8 @@ extern int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 extern int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
+extern void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
+				struct ieee80211_hdr *hdr);
 #endif /* CONFIG_IWL4965_HT_AGG */
 #endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ef5f4ef..4d3ae28 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2772,6 +2772,10 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
+	if (ieee80211_is_back_request(fc))
+		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
+
+
 	cmd->cmd.tx.sta_id = std_id;
 	if (ieee80211_get_morefrag(hdr))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
@@ -2880,6 +2884,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	struct iwl4965_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
+	dma_addr_t scratch_phys;
 	struct iwl4965_cmd *out_cmd = NULL;
 	u16 len, idx, len_org;
 	u8 id, hdr_len, unicast;
@@ -3053,8 +3058,18 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl4965_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
 
-	iwl4965_tx_cmd(priv, out_cmd, sta_id, txcmd_phys,
-		       hdr, hdr_len, ctl, NULL);
+	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
+		offsetof(struct iwl4965_tx_cmd, scratch);
+	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	out_cmd->cmd.tx.dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
+
+#ifdef CONFIG_IWL4965_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+	/* TODO: move this functionality to rate scaling */
+	iwl4965_tl_get_stats(priv, hdr);
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /*CONFIG_IWL4965_HT */
+
 
 	if (!ieee80211_get_morefrag(hdr)) {
 		txq->need_update = 1;
-- 
1.5.3.4

