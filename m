Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYFLBt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 21/29] iwlwifi: move rate helpers to iwlcore
Date: Thu, 12 Jun 2008 09:47:11 +0800
Message-Id: <1213235239-2954-22-git-send-email-yi.zhu@intel.com> (sfid-20080612_041912_678499_E5E0FAA3)
In-Reply-To: <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves rate helpers to iwlcore.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   13 -----
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    8 +--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   79 ++++-----------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   14 ++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   57 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   21 +++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    9 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 12 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 721f505..10f630e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -793,19 +793,6 @@ enum {
 
 /********************* END TXPOWER *****************************************/
 
-static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
-{
-	return le32_to_cpu(rate_n_flags) & 0xFF;
-}
-static inline u32 iwl4965_hw_get_rate_n_flags(__le32 rate_n_flags)
-{
-	return le32_to_cpu(rate_n_flags) & 0x1FFFF;
-}
-static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
-{
-	return cpu_to_le32(flags|(u16)rate);
-}
-
 
 /**
  * Tx/Rx Queues
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 77884e1..b9a4e4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -536,7 +536,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	u8 num_of_ant = get_num_of_ant_from_rate(rate_n_flags);
 	u8 mcs;
 
-	*rate_idx = iwl4965_hwrate_to_plcp_idx(rate_n_flags);
+	*rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
 
 	if (*rate_idx  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
@@ -1811,8 +1811,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			tbl = &(lq_sta->lq_info[active_tbl]);
 
 			/* Revert to "active" rate and throughput info */
-			index = iwl4965_hwrate_to_plcp_idx(
-							tbl->current_rate);
+			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
 			current_tpt = lq_sta->last_tpt;
 
 			/* Need to set up a new rate table in uCode */
@@ -1966,8 +1965,7 @@ lq_update:
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
 			/* Use new "search" start rate */
-			index = iwl4965_hwrate_to_plcp_idx(
-							tbl->current_rate);
+			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
 
 			IWL_DEBUG_RATE("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 1dd4124..cbd1264 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -286,8 +286,6 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 	return rate;
 }
 
-extern int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags);
-
 /**
  * iwl4965_fill_rs_info - Fill an output text buffer with the rate representation
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1b8dc2d..87648d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -307,60 +307,6 @@ static int is_fat_channel(__le32 rxon_flags)
 		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
 }
 
-int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
-{
-	int idx = 0;
-
-	/* 4965 HT rate format */
-	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		idx = (rate_n_flags & 0xff);
-
-		if (idx >= IWL_RATE_MIMO2_6M_PLCP)
-			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
-
-		idx += IWL_FIRST_OFDM_RATE;
-		/* skip 9M not supported in ht*/
-		if (idx >= IWL_RATE_9M_INDEX)
-			idx += 1;
-		if ((idx >= IWL_FIRST_OFDM_RATE) && (idx <= IWL_LAST_OFDM_RATE))
-			return idx;
-
-	/* 4965 legacy rate format, search for match in table */
-	} else {
-		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
-				return idx;
-	}
-
-	return -1;
-}
-
-/**
- * translate ucode response to mac80211 tx status control values
- */
-void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-				  struct ieee80211_tx_info *control)
-{
-	int rate_index;
-
-	control->antenna_sel_tx =
-		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
-	if (rate_n_flags & RATE_MCS_HT_MSK)
-		control->flags |= IEEE80211_TX_CTL_OFDM_HT;
-	if (rate_n_flags & RATE_MCS_GF_MSK)
-		control->flags |= IEEE80211_TX_CTL_GREEN_FIELD;
-	if (rate_n_flags & RATE_MCS_FAT_MSK)
-		control->flags |= IEEE80211_TX_CTL_40_MHZ_WIDTH;
-	if (rate_n_flags & RATE_MCS_DUP_MSK)
-		control->flags |= IEEE80211_TX_CTL_DUP_DATA;
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		control->flags |= IEEE80211_TX_CTL_SHORT_GI;
-	rate_index = iwl4965_hwrate_to_plcp_idx(rate_n_flags);
-	if (control->band == IEEE80211_BAND_5GHZ)
-		rate_index -= IWL_FIRST_OFDM_RATE;
-	control->tx_rate_idx = rate_index;
-}
-
 /*
  * EEPROM handlers
  */
@@ -1796,10 +1742,10 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
 		tx_beacon_cmd->tx.rate_n_flags =
-			iwl4965_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
+			iwl_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
 	else
 		tx_beacon_cmd->tx.rate_n_flags =
-			iwl4965_hw_set_rate_n_flags(rate, 0);
+			iwl_hw_set_rate_n_flags(rate, 0);
 
 	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
 				TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK);
@@ -2568,7 +2514,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		else
 			title = "Frame";
 
-		rate_idx = iwl4965_hwrate_to_plcp_idx(rate_sym);
+		rate_idx = iwl_hwrate_to_plcp_idx(rate_sym);
 		if (unlikely(rate_idx == -1))
 			bitrate = 0;
 		else
@@ -2633,7 +2579,7 @@ void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
-		iwl4965_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
+		iwl_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
@@ -2842,7 +2788,7 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
 	info->status.ampdu_ack_map = successes;
 	info->status.ampdu_ack_len = agg->frame_count;
-	iwl4965_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
+	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
 
@@ -3189,15 +3135,15 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	struct agg_tx_status *frame_status = tx_resp->u.agg_status;
 	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
+	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	int i, sh, idx;
 	u16 seq;
-
 	if (agg->wait_for_ba)
 		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
-	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	agg->rate_n_flags = rate_n_flags;
 	agg->bitmap = 0;
 
 	/* # frames attempted by Tx command */
@@ -3215,15 +3161,12 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
-		iwl4965_hwrate_to_tx_control(priv,
-					     le32_to_cpu(tx_resp->rate_n_flags),
-					     info);
+		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
 				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n",
-			iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags));
+		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -3281,7 +3224,6 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
-		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
 				   (unsigned long long)agg->bitmap);
@@ -3375,7 +3317,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		info->status.retry_count = tx_resp->failure_frame;
 		info->flags |=
 			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
-		iwl4965_hwrate_to_tx_control(priv,
+		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
@@ -3386,6 +3328,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				tx_resp->failure_frame);
 
 		IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+
 		if (index != -1) {
 		    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 		    if (tid != MAX_TID_COUNT)
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index da8750b..8c466b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1139,6 +1139,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 	struct agg_tx_status *frame_status = &tx_resp->status;
 	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
+	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	int i, sh, idx;
 	u16 seq;
 
@@ -1147,7 +1148,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
-	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	agg->rate_n_flags = rate_n_flags;
 	agg->bitmap = 0;
 
 	/* # frames attempted by Tx command */
@@ -1165,15 +1166,13 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
-		iwl4965_hwrate_to_tx_control(priv,
-					     le32_to_cpu(tx_resp->rate_n_flags),
-					     info);
+		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
+
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
 				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n",
-			iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags));
+		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -1231,7 +1230,6 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
-		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
 				   (unsigned long long)agg->bitmap);
@@ -1322,7 +1320,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 		info->status.retry_count = tx_resp->failure_frame;
 		info->flags =
 			iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
-		iwl4965_hwrate_to_tx_control(priv,
+		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 164697a..7e20f46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -85,6 +85,63 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 };
 EXPORT_SYMBOL(iwl_rates);
 
+/**
+ * translate ucode response to mac80211 tx status control values
+ */
+void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+				  struct ieee80211_tx_info *control)
+{
+	int rate_index;
+
+	control->antenna_sel_tx =
+		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		control->flags |= IEEE80211_TX_CTL_OFDM_HT;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		control->flags |= IEEE80211_TX_CTL_GREEN_FIELD;
+	if (rate_n_flags & RATE_MCS_FAT_MSK)
+		control->flags |= IEEE80211_TX_CTL_40_MHZ_WIDTH;
+	if (rate_n_flags & RATE_MCS_DUP_MSK)
+		control->flags |= IEEE80211_TX_CTL_DUP_DATA;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		control->flags |= IEEE80211_TX_CTL_SHORT_GI;
+	rate_index = iwl_hwrate_to_plcp_idx(rate_n_flags);
+	if (control->band == IEEE80211_BAND_5GHZ)
+		rate_index -= IWL_FIRST_OFDM_RATE;
+	control->tx_rate_idx = rate_index;
+}
+EXPORT_SYMBOL(iwl_hwrate_to_tx_control);
+
+int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
+{
+	int idx = 0;
+
+	/* HT rate format */
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		idx = (rate_n_flags & 0xff);
+
+		if (idx >= IWL_RATE_MIMO2_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
+
+		idx += IWL_FIRST_OFDM_RATE;
+		/* skip 9M not supported in ht*/
+		if (idx >= IWL_RATE_9M_INDEX)
+			idx += 1;
+		if ((idx >= IWL_FIRST_OFDM_RATE) && (idx <= IWL_LAST_OFDM_RATE))
+			return idx;
+
+	/* legacy rate format, search for match in table */
+	} else {
+		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
+			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+				return idx;
+	}
+
+	return -1;
+}
+EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
+
+
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 EXPORT_SYMBOL(iwl_bcast_addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5837577..2eb08f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -244,6 +244,27 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
 /*******************************************************************************
+ * Rate
+ ******************************************************************************/
+
+void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+			      struct ieee80211_tx_info *info);
+int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
+
+static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
+{
+	return le32_to_cpu(rate_n_flags) & 0xFF;
+}
+static inline u32 iwl_hw_get_rate_n_flags(__le32 rate_n_flags)
+{
+	return le32_to_cpu(rate_n_flags) & 0x1FFFF;
+}
+static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
+{
+	return cpu_to_le32(flags|(u32)rate);
+}
+
+/*******************************************************************************
  * Scanning
  ******************************************************************************/
 int iwl_scan_cancel(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e586987..69765c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -733,9 +733,6 @@ extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 extern int iwl4965_alive_notify(struct iwl_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
-extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
-					 u32 rate_n_flags,
-					 struct ieee80211_tx_info *info);
 
 extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 				struct ieee80211_ht_info *ht_info,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c2ed7c1..7b9475b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -792,8 +792,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	case 2:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate_n_flags =
-				iwl4965_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
-				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
+				iwl_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
+							RATE_MCS_ANT_B_MSK|
+							RATE_MCS_CCK_MSK);
 
 		scan->good_CRC_th = 0;
 		band = IEEE80211_BAND_2GHZ;
@@ -801,8 +802,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	case 1:
 		scan->tx_cmd.rate_n_flags =
-				iwl4965_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
-				RATE_MCS_ANT_B_MSK);
+				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
+							RATE_MCS_ANT_B_MSK);
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 		band = IEEE80211_BAND_5GHZ;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 3e257cf..fae5d6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -824,7 +824,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
 
 		link_cmd.rs_table[i].rate_n_flags =
-			iwl4965_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 		r = iwl4965_get_prev_ieee_rate(r);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1aa19f4..e804bf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -696,7 +696,7 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 
 	tx_cmd->rts_retry_limit = rts_retry_limit;
 	tx_cmd->data_retry_limit = data_retry_limit;
-	tx_cmd->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
+	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }
 
 static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4183bd5..2073ba6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1331,7 +1331,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_beacon_notif *beacon = &(pkt->u.beacon_status);
-	u8 rate = iwl4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
+	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
-- 
1.5.3.6

