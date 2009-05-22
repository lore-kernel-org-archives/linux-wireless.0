Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbZEVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/10] iwlwifi: support "pure 40MHz" in RXON command
Date: Fri, 22 May 2009 11:01:49 -0700
Message-Id: <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Fix the bug when using 11n "pure 40MHz" mode cause uCode
crashing by adding support for "pure 40MHz" in RX_ON command flag.
the "mode" field (bits 25:26) has value of 0-3
    0 = 20 MHz only
    1 = 40MHz only
    2 = Mixed
    3 = Reserved
Control Channel ID (bit 22) is valid only in Mixed mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   14 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   84 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    5 +-
 4 files changed, 72 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4be7bd2..7df4116 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -293,10 +293,12 @@ restart:
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static int is_fat_channel(__le32 rxon_flags)
+static bool is_fat_channel(__le32 rxon_flags)
 {
-	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
-		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
+	int chan_mod = le32_to_cpu(rxon_flags & RXON_FLG_CHANNEL_MODE_MSK)
+				    >> RXON_FLG_CHANNEL_MODE_POS;
+	return ((chan_mod == CHANNEL_MODE_PURE_40) ||
+		  (chan_mod == CHANNEL_MODE_MIXED));
 }
 
 /*
@@ -1490,7 +1492,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 	struct iwl4965_txpowertable_cmd cmd = { 0 };
 	int ret;
 	u8 band = 0;
-	u8 is_fat = 0;
+	bool is_fat = false;
 	u8 ctrl_chan_high = 0;
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
@@ -1568,7 +1570,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
-	u8 is_fat = 0;
+	bool is_fat = false;
 	u8 ctrl_chan_high = 0;
 	struct iwl4965_channel_switch_cmd cmd = { 0 };
 	const struct iwl_channel_info *ch_info;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7b84d52..e581dc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -614,8 +614,18 @@ enum {
 
 #define RXON_FLG_CHANNEL_MODE_POS		(25)
 #define RXON_FLG_CHANNEL_MODE_MSK		cpu_to_le32(0x3 << 25)
-#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	cpu_to_le32(0x1 << 25)
-#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		cpu_to_le32(0x2 << 25)
+
+/* channel mode */
+enum {
+	CHANNEL_MODE_LEGACY = 0,
+	CHANNEL_MODE_PURE_40 = 1,
+	CHANNEL_MODE_MIXED = 2,
+	CHANNEL_MODE_RESERVED = 3,
+};
+#define RXON_FLG_CHANNEL_MODE_LEGACY	cpu_to_le32(CHANNEL_MODE_LEGACY << RXON_FLG_CHANNEL_MODE_POS)
+#define RXON_FLG_CHANNEL_MODE_PURE_40	cpu_to_le32(CHANNEL_MODE_PURE_40 << RXON_FLG_CHANNEL_MODE_POS)
+#define RXON_FLG_CHANNEL_MODE_MIXED	cpu_to_le32(CHANNEL_MODE_MIXED << RXON_FLG_CHANNEL_MODE_POS)
+
 /* CTS to self (if spec allows) flag */
 #define RXON_FLG_SELF_CTS_EN			cpu_to_le32(0x1<<30)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c7cbb2e..a15f795 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -617,19 +617,23 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
 
 	if ((!iwl_ht_conf->is_ht) ||
-	   (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ) ||
-	   (iwl_ht_conf->extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_NONE))
+	    (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ))
 		return 0;
 
+	/* We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
+	 * the bit will not set if it is pure 40MHz case
+	 */
 	if (sta_ht_inf) {
-		if ((!sta_ht_inf->ht_supported) ||
-		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)))
+		if (!sta_ht_inf->ht_supported)
 			return 0;
 	}
 
-	return iwl_is_channel_extension(priv, priv->band,
-					le16_to_cpu(priv->staging_rxon.channel),
-					iwl_ht_conf->extension_chan_offset);
+	if (iwl_ht_conf->ht_protection & IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
+		return 1;
+	else
+		return iwl_is_channel_extension(priv, priv->band,
+				le16_to_cpu(priv->staging_rxon.channel),
+				iwl_ht_conf->extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
@@ -799,42 +803,51 @@ EXPORT_SYMBOL(iwl_rate_get_lowest_plcp);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-	u32 val;
 
 	if (!ht_info->is_ht) {
-		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
-			RXON_FLG_CHANNEL_MODE_PURE_40_MSK |
+		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
 			RXON_FLG_FAT_PROT_MSK |
 			RXON_FLG_HT_PROT_MSK);
 		return;
 	}
 
-	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
-	if (iwl_is_fat_tx_allowed(priv, NULL))
-		rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED_MSK;
-	else
-		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
-				 RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
-
-	/* Note: control channel is opposite of extension channel */
-	switch (ht_info->extension_chan_offset) {
-	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-	default:
-		rxon->flags &= ~RXON_FLG_CHANNEL_MODE_MIXED_MSK;
-		break;
+	/* FIXME: if the definition of ht_protection changed, the "translation"
+	 * will be needed for rxon->flags
+	 */
+	rxon->flags |= cpu_to_le32(ht_info->ht_protection << RXON_FLG_HT_OPERATING_MODE_POS);
+
+	/* Set up channel bandwidth:
+	 * 20 MHz only, 20/40 mixed or pure 40 if fat ok */
+	/* clear the HT channel mode before set the mode */
+	rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
+			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
+	if (iwl_is_fat_tx_allowed(priv, NULL)) {
+		/* pure 40 fat */
+		if (rxon->flags & RXON_FLG_FAT_PROT_MSK)
+			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
+		else {
+			/* Note: control channel is opposite of extension channel */
+			switch (ht_info->extension_chan_offset) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
+				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+			default:
+				/* channel location only valid if in Mixed mode */
+				IWL_ERR(priv, "invalid extension channel offset\n");
+				break;
+			}
+		}
+	} else {
+		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
 	}
 
-	val = ht_info->ht_protection;
-
-	rxon->flags |= cpu_to_le32(val << RXON_FLG_HT_OPERATING_MODE_POS);
-
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
@@ -1122,8 +1135,9 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 	priv->staging_rxon.cck_basic_rates =
 	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 
-	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
-					RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
+	/* clear both MIX and PURE40 mode flag */
+	priv->staging_rxon.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
+					RXON_FLG_CHANNEL_MODE_PURE_40);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	memcpy(priv->staging_rxon.wlap_bssid_addr, priv->mac_addr, ETH_ALEN);
 	priv->staging_rxon.ofdm_ht_single_stream_basic_rates = 0xff;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 41358cf..b60ff28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -583,6 +583,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	u8 rx_ant = priv->hw_params.valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
+	int  chan_mod;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -702,7 +703,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
 		band = IEEE80211_BAND_2GHZ;
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		if (priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) {
+		chan_mod = le32_to_cpu(priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_MSK)
+				       >> RXON_FLG_CHANNEL_MODE_POS;
+		if (chan_mod == CHANNEL_MODE_PURE_40) {
 			rate = IWL_RATE_6M_PLCP;
 		} else {
 			rate = IWL_RATE_1M_PLCP;
-- 
1.5.6.3

