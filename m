Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36250 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751786AbdAWWSN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:13 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:37 +0200
Message-Id: <20170123220350.25305-13-luca@coelho.fi> (sfid-20170123_231815_797682_49FC90F4)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: separate rate calculation to a new function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In preparation for the new TX cmd - move the rate calculation
to a diffrent function, and make it independent of the TX
command.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 84 +++++++++++++++--------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 7f2fe3ffe547..af828eda3330 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -299,6 +299,50 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		cpu_to_le16(iwl_mvm_tx_csum(mvm, skb, hdr, info));
 }
 
+static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
+			       struct ieee80211_tx_info *info,
+			       struct ieee80211_sta *sta)
+{
+	int rate_idx;
+	u8 rate_plcp;
+	u32 rate_flags;
+
+	/* HT rate doesn't make sense for a non data frame */
+	WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS,
+		  "Got an HT rate (flags:0x%x/mcs:%d) for a non data frame\n",
+		  info->control.rates[0].flags,
+		  info->control.rates[0].idx);
+
+	rate_idx = info->control.rates[0].idx;
+	/* if the rate isn't a well known legacy rate, take the lowest one */
+	if (rate_idx < 0 || rate_idx >= IWL_RATE_COUNT_LEGACY)
+		rate_idx = rate_lowest_index(
+				&mvm->nvm_data->bands[info->band], sta);
+
+	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
+	if (info->band == NL80211_BAND_5GHZ)
+		rate_idx += IWL_FIRST_OFDM_RATE;
+
+	/* For 2.4 GHZ band, check that there is no need to remap */
+	BUILD_BUG_ON(IWL_FIRST_CCK_RATE != 0);
+
+	/* Get PLCP rate for tx_cmd->rate_n_flags */
+	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(rate_idx);
+
+	if (info->band == NL80211_BAND_2GHZ &&
+	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
+		rate_flags = mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
+	else
+		rate_flags =
+			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
+
+	/* Set CCK flag as needed */
+	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+	return (u32)rate_plcp | rate_flags;
+}
+
 /*
  * Sets the fields in the Tx cmd that are rate related
  */
@@ -306,10 +350,6 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			    struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, __le16 fc)
 {
-	u32 rate_flags;
-	int rate_idx;
-	u8 rate_plcp;
-
 	/* Set retry limit on RTS packets */
 	tx_cmd->rts_retry_limit = IWL_RTS_DFAULT_RETRY_LIMIT;
 
@@ -338,46 +378,12 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			cpu_to_le32(TX_CMD_FLG_ACK | TX_CMD_FLG_BAR);
 	}
 
-	/* HT rate doesn't make sense for a non data frame */
-	WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS,
-		  "Got an HT rate (flags:0x%x/mcs:%d) for a non data frame (fc:0x%x)\n",
-		  info->control.rates[0].flags,
-		  info->control.rates[0].idx,
-		  le16_to_cpu(fc));
-
-	rate_idx = info->control.rates[0].idx;
-	/* if the rate isn't a well known legacy rate, take the lowest one */
-	if (rate_idx < 0 || rate_idx >= IWL_RATE_COUNT_LEGACY)
-		rate_idx = rate_lowest_index(
-				&mvm->nvm_data->bands[info->band], sta);
-
-	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == NL80211_BAND_5GHZ)
-		rate_idx += IWL_FIRST_OFDM_RATE;
-
-	/* For 2.4 GHZ band, check that there is no need to remap */
-	BUILD_BUG_ON(IWL_FIRST_CCK_RATE != 0);
-
-	/* Get PLCP rate for tx_cmd->rate_n_flags */
-	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(rate_idx);
-
 	mvm->mgmt_last_antenna_idx =
 		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
 				     mvm->mgmt_last_antenna_idx);
 
-	if (info->band == NL80211_BAND_2GHZ &&
-	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
-		rate_flags = mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
-	else
-		rate_flags =
-			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
-
-	/* Set CCK flag as needed */
-	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
-		rate_flags |= RATE_MCS_CCK_MSK;
-
 	/* Set the rate in the TX cmd */
-	tx_cmd->rate_n_flags = cpu_to_le32((u32)rate_plcp | rate_flags);
+	tx_cmd->rate_n_flags = cpu_to_le32(iwl_mvm_get_tx_rate(mvm, info, sta));
 }
 
 static inline void iwl_mvm_set_tx_cmd_pn(struct ieee80211_tx_info *info,
-- 
2.11.0
