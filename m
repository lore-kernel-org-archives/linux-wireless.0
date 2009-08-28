Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbZH1Qot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: remove incorrect uses of ieee80211_get_tx_rate to prevent TX stall
Date: Fri, 28 Aug 2009 09:44:46 -0700
Message-Id: <1251477889-13732-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
References: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Refactor and correct rate selection for outgoing transmitted
packets.

First, note that HT rates in the mac80211 rate table do not provide valid
indices when ieee80211_get_tx_rate is called; the check to see if we could to
abort a transmission early in iwl_tx_skb() would thus occasionally read invalid
memory and occasionally stall transmission (if the erroneous byte was 0xff).
We remove that code; the check wasn't valid anyway.

Second, iwl_tx_cmd_build_rate() also called ieee80211_get_tx_rate to be used
for sending management packets, which do not use the uCode station table.  This
patch refactors that function and adds comments to enhance legibility, replaces
the call to ieee80211_get_tx_rate() with a direct lookup, and adds error
handling in case the table entry is invalid.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |  111 ++++++++++++++++++--------------
 1 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7bc9c00..a7422e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -566,62 +566,81 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			      struct iwl_tx_cmd *tx_cmd,
 			      struct ieee80211_tx_info *info,
-			      __le16 fc, int sta_id,
-			      int is_hcca)
+			      __le16 fc, int is_hcca)
 {
-	u32 rate_flags = 0;
+	u32 rate_flags;
 	int rate_idx;
-	u8 rts_retry_limit = 0;
-	u8 data_retry_limit = 0;
+	u8 rts_retry_limit;
+	u8 data_retry_limit;
 	u8 rate_plcp;
 
-	rate_idx = min(ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xffff,
-			IWL_RATE_COUNT - 1);
-
-	rate_plcp = iwl_rates[rate_idx].plcp;
-
-	rts_retry_limit = (is_hcca) ?
-	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
-
-	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
-		rate_flags |= RATE_MCS_CCK_MSK;
-
-
-	if (ieee80211_is_probe_resp(fc)) {
-		data_retry_limit = 3;
-		if (data_retry_limit < rts_retry_limit)
-			rts_retry_limit = data_retry_limit;
-	} else
-		data_retry_limit = IWL_DEFAULT_TX_RETRY;
-
+	/* Set retry limit on DATA packets and Probe Responses*/
 	if (priv->data_retry_limit != -1)
 		data_retry_limit = priv->data_retry_limit;
+	else if (ieee80211_is_probe_resp(fc))
+		data_retry_limit = 3;
+	else
+		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+	tx_cmd->data_retry_limit = data_retry_limit;
 
+	/* Set retry limit on RTS packets */
+	rts_retry_limit = (is_hcca) ?  RTS_HCCA_RETRY_LIMIT :
+		RTS_DFAULT_RETRY_LIMIT;
+	if (data_retry_limit < rts_retry_limit)
+		rts_retry_limit = data_retry_limit;
+	tx_cmd->rts_retry_limit = rts_retry_limit;
 
+	/* DATA packets will use the uCode station table for rate/antenna
+	 * selection */
 	if (ieee80211_is_data(fc)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
-	} else {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_AUTH):
-		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-			if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
-				tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-				tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
-			}
-			break;
-		default:
-			break;
-		}
+		return;
+	}
+
+	/**
+	 * If the current TX rate stored in mac80211 has the MCS bit set, it's
+	 * not really a TX rate.  Thus, we use the lowest supported rate for
+	 * this band.  Also use the lowest supported rate if the stored rate
+	 * index is invalid.
+	 */
+	rate_idx = info->control.rates[0].idx;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
+			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
+		rate_idx = rate_lowest_index(&priv->bands[info->band],
+				info->control.sta);
+	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
+	if (info->band == IEEE80211_BAND_5GHZ)
+		rate_idx += IWL_FIRST_OFDM_RATE;
+	/* Get PLCP rate for tx_cmd->rate_n_flags */
+	rate_plcp = iwl_rates[rate_idx].plcp;
+	/* Zero out flags for this packet */
+	rate_flags = 0;
 
-		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
-		rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
+	/* Set CCK flag as needed */
+	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+	/* Set up RTS and CTS flags for certain packets */
+	switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+	case cpu_to_le16(IEEE80211_STYPE_AUTH):
+	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+	case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+	case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+		if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
+			tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+			tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
+		}
+		break;
+	default:
+		break;
 	}
 
-	tx_cmd->rts_retry_limit = rts_retry_limit;
-	tx_cmd->data_retry_limit = data_retry_limit;
+	/* Set up antennas */
+	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
+
+	/* Set the rate in the TX cmd */
 	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }
 
@@ -701,12 +720,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}
 
-	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) ==
-	     IWL_INVALID_RATE) {
-		IWL_ERR(priv, "ERROR: No TX rate available.\n");
-		goto drop_unlock;
-	}
-
 	fc = hdr->frame_control;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -807,7 +820,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 
 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
+	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, 0);
 
 	iwl_update_stats(priv, true, fc, len);
 	/*
-- 
1.5.6.3

