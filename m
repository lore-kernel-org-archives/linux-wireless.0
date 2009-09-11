Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36995 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZIKRiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/13] iwlwifi: clean up ht config naming
Date: Fri, 11 Sep 2009 10:38:15 -0700
Message-Id: <1252690699-25796-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Daniel Halperin pointed out that the naming
here is rather inconsistent with at least 3
different names being used for one thing in
different contexts. Rename the struct to
iwl_ht_config (rather than iwl_ht_info) and
use ht_conf as a variable for it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |   48 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    4 +-
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index fd73153..9d0758a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -662,7 +662,7 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
  * there are no non-GF stations present in the BSS.
  */
 static inline u8 rs_use_green(struct ieee80211_sta *sta,
-			      struct iwl_ht_info *ht_conf)
+			      struct iwl_ht_config *ht_conf)
 {
 	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
 		!(ht_conf->non_GF_STA_present);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7c50065..d9a757a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -634,9 +634,9 @@ static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf)
 {
-	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 
-	if (!iwl_ht_conf->is_ht || !iwl_ht_conf->is_40mhz)
+	if (!ht_conf->is_ht || !ht_conf->is_40mhz)
 		return 0;
 
 	/* We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
@@ -652,7 +652,7 @@ u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 #endif
 	return iwl_is_channel_extension(priv, priv->band,
 			le16_to_cpu(priv->staging_rxon.channel),
-			iwl_ht_conf->extension_chan_offset);
+			ht_conf->extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_ht40_tx_allowed);
 
@@ -876,11 +876,11 @@ u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_rate_get_lowest_plcp);
 
-void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
-	if (!ht_info->is_ht) {
+	if (!ht_conf->is_ht) {
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
 			RXON_FLG_HT40_PROT_MSK |
@@ -891,7 +891,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 	/* FIXME: if the definition of ht_protection changed, the "translation"
 	 * will be needed for rxon->flags
 	 */
-	rxon->flags |= cpu_to_le32(ht_info->ht_protection << RXON_FLG_HT_OPERATING_MODE_POS);
+	rxon->flags |= cpu_to_le32(ht_conf->ht_protection << RXON_FLG_HT_OPERATING_MODE_POS);
 
 	/* Set up channel bandwidth:
 	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
@@ -900,10 +900,10 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 	if (iwl_is_ht40_tx_allowed(priv, NULL)) {
 		/* pure ht40 */
-		if (ht_info->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
+		if (ht_conf->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
 			/* Note: control channel is opposite of extension channel */
-			switch (ht_info->extension_chan_offset) {
+			switch (ht_conf->extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &= ~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
 				break;
@@ -913,7 +913,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 			}
 		} else {
 			/* Note: control channel is opposite of extension channel */
-			switch (ht_info->extension_chan_offset) {
+			switch (ht_conf->extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
@@ -939,11 +939,11 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 	IWL_DEBUG_ASSOC(priv, "supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
-			ht_info->mcs.rx_mask[0],
-			ht_info->mcs.rx_mask[1],
-			ht_info->mcs.rx_mask[2],
-			le32_to_cpu(rxon->flags), ht_info->ht_protection,
-			ht_info->extension_chan_offset);
+			ht_conf->mcs.rx_mask[0],
+			ht_conf->mcs.rx_mask[1],
+			ht_conf->mcs.rx_mask[2],
+			le32_to_cpu(rxon->flags), ht_conf->ht_protection,
+			ht_conf->extension_chan_offset);
 	return;
 }
 EXPORT_SYMBOL(iwl_set_rxon_ht);
@@ -2408,13 +2408,13 @@ EXPORT_SYMBOL(iwl_mac_conf_tx);
 static void iwl_ht_conf(struct iwl_priv *priv,
 			    struct ieee80211_bss_conf *bss_conf)
 {
-	struct ieee80211_sta_ht_cap *ht_conf;
-	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta *sta;
 
 	IWL_DEBUG_MAC80211(priv, "enter: \n");
 
-	if (!iwl_conf->is_ht)
+	if (!ht_conf->is_ht)
 		return;
 
 
@@ -2430,15 +2430,15 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 		rcu_read_unlock();
 		return;
 	}
-	ht_conf = &sta->ht_cap;
+	ht_cap = &sta->ht_cap;
 
-	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
+	ht_conf->sm_ps = (u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
-	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
+	memcpy(&ht_conf->mcs, &ht_cap->mcs, 16);
 
-	iwl_conf->ht_protection =
+	ht_conf->ht_protection =
 		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	iwl_conf->non_GF_STA_present =
+	ht_conf->non_GF_STA_present =
 		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 
 	rcu_read_unlock();
@@ -2748,7 +2748,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct iwl_ht_info *ht_conf = &priv->current_ht_config;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	unsigned long flags = 0;
 	int ret = 0;
 	u16 ch;
@@ -2915,7 +2915,7 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
-	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
+	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_config));
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_reset_qos(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dfeca62..cab148d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -274,7 +274,7 @@ int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
-void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
 void iwl_set_flags_for_band(struct iwl_priv *priv, enum ieee80211_band band);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 961d534..e161f8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -502,7 +502,7 @@ union iwl_ht_rate_supp {
 #define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
 
-struct iwl_ht_info {
+struct iwl_ht_config {
 	/* self configuration data */
 	bool is_ht;
 	bool is_40mhz;
@@ -1077,7 +1077,7 @@ struct iwl_priv {
 	struct iwl_chain_noise_data chain_noise_data;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
 
-	struct iwl_ht_info current_ht_config;
+	struct iwl_ht_config current_ht_config;
 	u8 last_phy_res[100];
 
 	/* Rate scaling data */
-- 
1.5.6.3

