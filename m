Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762498AbXHHHho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 17/28] iwlwifi: Endianity fix for channel number
Date: Wed,  8 Aug 2007 15:33:34 +0800
Message-Id: <11865584661209-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584631842-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endinaity issue for channel number. It tries to
introduce some more consistency in channel number type (u16).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c    |    4 +---
 drivers/net/wireless/iwl-4965.c    |   22 ++++++++++------------
 drivers/net/wireless/iwl-4965.h    |    4 ++--
 drivers/net/wireless/iwl-base.c    |    4 ++--
 drivers/net/wireless/iwl-channel.h |    2 +-
 drivers/net/wireless/iwlwifi.h     |    2 +-
 6 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index d209873..a9a1921 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -1695,7 +1695,6 @@ int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 {
 	struct iwl_channel_info *ch_info;
 	s8 max_power;
-	u8 channel;
 	u8 a_band;
 	u8 i;
 
@@ -1713,7 +1712,6 @@ int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 	for (i = 0; i < priv->channel_count; i++) {
 		ch_info = &priv->channel_info[i];
 		a_band = is_channel_a_band(ch_info);
-		channel = ch_info->channel;
 
 		/* find minimum power of all user and regulatory constraints
 		 *    (does not consider h/w clipping limitations) */
@@ -1736,7 +1734,7 @@ int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 }
 
 /* will add 3945 channel switch cmd handling later */
-int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel)
+int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index e907f06..a3e6603 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -298,7 +298,7 @@ static int iwl4965_kw_alloc(struct iwl_priv *priv)
 #define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
-int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode, int channel,
+int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode, u16 channel,
 			      const struct iwl_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
 {
@@ -1878,7 +1878,7 @@ static s32 iwl4965_get_voltage_compensation(s32 eeprom_voltage,
 }
 
 static const struct iwl_channel_info *
-iwl4965_get_channel_txpower_info(struct iwl_priv *priv, u8 phymode, u8 channel)
+iwl4965_get_channel_txpower_info(struct iwl_priv *priv, u8 phymode, u16 channel)
 {
 	const struct iwl_channel_info *ch_info;
 
@@ -1890,7 +1890,7 @@ iwl4965_get_channel_txpower_info(struct iwl_priv *priv, u8 phymode, u8 channel)
 	return ch_info;
 }
 
-static s32 iwl4965_get_tx_atten_grp(u32 channel)
+static s32 iwl4965_get_tx_atten_grp(u16 channel)
 {
 	if (channel >= CALIB_IWL_TX_ATTEN_GR5_FCH &&
 	    channel <= CALIB_IWL_TX_ATTEN_GR5_LCH)
@@ -2277,7 +2277,7 @@ static const struct gain_entry gain_table[2][108] = {
 	 }
 };
 
-static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u8 channel,
+static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 				    u8 is_fat, u8 ctrl_chan_high,
 				    struct iwl_tx_power_db *tx_power_tbl)
 {
@@ -2549,7 +2549,6 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 	struct iwl_tx_power_table_cmd cmd = { 0 };
 	int rc = 0;
 	u8 band = 0;
-	u8 channel = 0;
 	u8 is_fat = 0;
 	u8 ctrl_chan_high = 0;
 
@@ -2565,8 +2564,6 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 		(priv->phymode == MODE_IEEE80211G) ||
 		(priv->phymode == MODE_ATHEROS_TURBOG)) ? 1 : 0;
 
-	channel = priv->active_rxon.channel;
-
 	is_fat =  is_fat_channel(priv->active_rxon.flags);
 
 	if (is_fat &&
@@ -2574,11 +2571,12 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
-	cmd.channel = channel;
+	cmd.channel = priv->active_rxon.channel;
 	cmd.channel_normal_width = 0;
 
-	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_fat,
-				      ctrl_chan_high, &cmd.tx_power);
+	rc = iwl4965_fill_txpower_tbl(priv, band,
+				le32_to_cpu(priv->active_rxon.channel),
+				is_fat, ctrl_chan_high, &cmd.tx_power);
 	if (rc)
 		return rc;
 
@@ -2586,7 +2584,7 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 	return rc;
 }
 
-int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel)
+int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
@@ -4404,7 +4402,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 #ifdef CONFIG_IWLWIFI_HT
 
 static u8 iwl_is_channel_extension(struct iwl_priv *priv, int phymode,
-				   int channel, u8 extension_chan_offset)
+				   u16 channel, u8 extension_chan_offset)
 {
 	const struct iwl_channel_info *ch_info;
 
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index db4a02e..5a3266f 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -63,7 +63,7 @@ static inline void iwl4965_chain_noise_reset(struct iwl_priv *priv) {}
 static inline void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
 					    u8 force) {}
 static inline int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode,
-				int channel,
+				u16 channel,
 				const struct iwl_eeprom_channel *eeprom_ch,
 				u8 fat_extension_channel) { return 0; }
 static inline void iwl4965_rf_kill_ct_config(struct iwl_priv *priv) {}
@@ -98,7 +98,7 @@ extern void iwl4965_chain_noise_reset(struct iwl_priv *priv);
 extern void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
 				     u8 force);
 extern int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode,
-				int channel,
+				u16 channel,
 				const struct iwl_eeprom_channel *eeprom_ch,
 				u8 fat_extension_channel);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8f19494..3b08c7c 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -5314,7 +5314,7 @@ static void iwl_init_band_reference(const struct iwl_priv *priv, int band,
 }
 
 const struct iwl_channel_info *iwl_get_channel_info(const struct iwl_priv *priv,
-						    int phymode, int channel)
+						    int phymode, u16 channel)
 {
 	int i;
 
@@ -8503,7 +8503,7 @@ static ssize_t store_measurement(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
-		.channel = priv->active_rxon.channel,
+		.channel = le16_to_cpu(priv->active_rxon.channel),
 		.start_time = priv->last_tsf,
 		.duration = 1,
 	};
diff --git a/drivers/net/wireless/iwl-channel.h b/drivers/net/wireless/iwl-channel.h
index d320c2b..97da370 100644
--- a/drivers/net/wireless/iwl-channel.h
+++ b/drivers/net/wireless/iwl-channel.h
@@ -158,6 +158,6 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 }
 
 extern const struct iwl_channel_info *iwl_get_channel_info(
-	const struct iwl_priv *priv, int phymode, int channel);
+	const struct iwl_priv *priv, int phymode, u16 channel);
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 6fea9a4..029b590 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -717,6 +717,6 @@ extern int iwl4965_get_temperature(const struct iwl_priv *priv);
  */
 extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
-extern int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel);
+extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 #endif
-- 
1.5.2
