Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZHGWly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/16] iwlwifi: name changed from "fat" to "ht40"
Date: Fri,  7 Aug 2009 15:41:38 -0700
Message-Id: <1249684912-22936-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Rename "fat" to "ht40"
The term "fat channel" is deprecated in favor of "HT40"

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   42 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   67 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   22 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   24 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   22 ++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   54 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |   34 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    6 +-
 17 files changed, 155 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index cf3fbc6..191718a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -117,8 +117,8 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
-			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index b569c6f..1677278 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -176,7 +176,7 @@ struct iwl3945_eeprom {
  * in EEPROM containing EEPROM_CHANNEL_* usage flags (LSB) and max regulatory
  * txpower (MSB).
  *
- * Entries immediately below are for 20 MHz channel width.  FAT (40 MHz)
+ * Entries immediately below are for 20 MHz channel width.  HT40 (40 MHz)
  * channels (only for 4965, not supported by 3945) appear later in the EEPROM.
  *
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7ad0207..9e33507 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2851,8 +2851,8 @@ static struct iwl_lib_ops iwl3945_lib = {
 			EEPROM_REGULATORY_BAND_3_CHANNELS,
 			EEPROM_REGULATORY_BAND_4_CHANNELS,
 			EEPROM_REGULATORY_BAND_5_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_FAT,
-			EEPROM_REGULATORY_BAND_NO_FAT,
+			EEPROM_REGULATORY_BAND_NO_HT40,
+			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwl3945_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index a71a489..b34322a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -188,7 +188,7 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *
  * 1)  Regulatory information (max txpower and channel usage flags) is provided
  *     separately for each channel that can possibly supported by 4965.
- *     40 MHz wide (.11n fat) channels are listed separately from 20 MHz
+ *     40 MHz wide (.11n HT40) channels are listed separately from 20 MHz
  *     (legacy) channels.
  *
  *     See struct iwl4965_eeprom_channel for format, and struct iwl4965_eeprom
@@ -251,8 +251,8 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
  *     no reduction (such as with regulatory txpower limits) is required.
  *
  *     Saturation and Backoff values apply equally to 20 Mhz (legacy) channel
- *     widths and 40 Mhz (.11n fat) channel widths; there is no separate
- *     factory measurement for fat channels.
+ *     widths and 40 Mhz (.11n HT40) channel widths; there is no separate
+ *     factory measurement for ht40 channels.
  *
  *     The result of this step is the final target txpower.  The rest of
  *     the steps figure out the proper settings for the device to achieve
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 62436a9..f02023e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -317,7 +317,7 @@ restart:
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static bool is_fat_channel(__le32 rxon_flags)
+static bool is_ht40_channel(__le32 rxon_flags)
 {
 	int chan_mod = le32_to_cpu(rxon_flags & RXON_FLG_CHANNEL_MODE_MSK)
 				    >> RXON_FLG_CHANNEL_MODE_POS;
@@ -806,7 +806,7 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL49_RTC_INST_SIZE;
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
-	priv->hw_params.fat_channel = BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
 
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
@@ -1266,7 +1266,7 @@ static const struct gain_entry gain_table[2][108] = {
 };
 
 static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
-				    u8 is_fat, u8 ctrl_chan_high,
+				    u8 is_ht40, u8 ctrl_chan_high,
 				    struct iwl4965_tx_power_db *tx_power_tbl)
 {
 	u8 saturation_power;
@@ -1298,8 +1298,8 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	user_target_power = 2 * priv->tx_power_user_lmt;
 
 	/* Get current (RXON) channel, band, width */
-	IWL_DEBUG_TXPOWER(priv, "chan %d band %d is_fat %d\n", channel, band,
-			  is_fat);
+	IWL_DEBUG_TXPOWER(priv, "chan %d band %d is_ht40 %d\n", channel, band,
+			  is_ht40);
 
 	ch_info = iwl_get_channel_info(priv, priv->band, channel);
 
@@ -1318,7 +1318,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	IWL_DEBUG_TXPOWER(priv, "channel %d belongs to txatten group %d\n",
 			  channel, txatten_grp);
 
-	if (is_fat) {
+	if (is_ht40) {
 		if (ctrl_chan_high)
 			channel -= 2;
 		else
@@ -1342,8 +1342,8 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 
 	/* regulatory txpower limits ... reg_limit values are in half-dBm,
 	 *   max_power_avg values are in dBm, convert * 2 */
-	if (is_fat)
-		reg_limit = ch_info->fat_max_power_avg * 2;
+	if (is_ht40)
+		reg_limit = ch_info->ht40_max_power_avg * 2;
 	else
 		reg_limit = ch_info->max_power_avg * 2;
 
@@ -1509,7 +1509,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 /**
  * iwl4965_send_tx_power - Configure the TXPOWER level user limit
  *
- * Uses the active RXON for channel, band, and characteristics (fat, high)
+ * Uses the active RXON for channel, band, and characteristics (ht40, high)
  * The power limit is taken from priv->tx_power_user_lmt.
  */
 static int iwl4965_send_tx_power(struct iwl_priv *priv)
@@ -1517,7 +1517,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 	struct iwl4965_txpowertable_cmd cmd = { 0 };
 	int ret;
 	u8 band = 0;
-	bool is_fat = false;
+	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
@@ -1530,9 +1530,9 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	is_fat =  is_fat_channel(priv->active_rxon.flags);
+	is_ht40 =  is_ht40_channel(priv->active_rxon.flags);
 
-	if (is_fat &&
+	if (is_ht40 &&
 	    (priv->active_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
@@ -1541,7 +1541,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 
 	ret = iwl4965_fill_txpower_tbl(priv, band,
 				le16_to_cpu(priv->active_rxon.channel),
-				is_fat, ctrl_chan_high, &cmd.tx_power);
+				is_ht40, ctrl_chan_high, &cmd.tx_power);
 	if (ret)
 		goto out;
 
@@ -1595,7 +1595,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
-	bool is_fat = false;
+	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
 	struct iwl4965_channel_switch_cmd cmd = { 0 };
 	const struct iwl_channel_info *ch_info;
@@ -1604,9 +1604,9 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 	ch_info = iwl_get_channel_info(priv, priv->band, channel);
 
-	is_fat = is_fat_channel(priv->staging_rxon.flags);
+	is_ht40 = is_ht40_channel(priv->staging_rxon.flags);
 
-	if (is_fat &&
+	if (is_ht40 &&
 	    (priv->active_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
@@ -1621,7 +1621,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	else
 		cmd.expect_beacon = 1;
 
-	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_fat,
+	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_ht40,
 				      ctrl_chan_high, &cmd.tx_power);
 	if (rc) {
 		IWL_DEBUG_11H(priv, "error:%d  fill txpower_tbl\n", rc);
@@ -1688,8 +1688,8 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 	u32 R4;
 
 	if (test_bit(STATUS_TEMPERATURE, &priv->status) &&
-		(priv->statistics.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)) {
-		IWL_DEBUG_TEMP(priv, "Running FAT temperature calibration\n");
+		(priv->statistics.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
+		IWL_DEBUG_TEMP(priv, "Running HT40 temperature calibration\n");
 		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[1]);
 		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[1]);
 		R3 = (s32)le32_to_cpu(priv->card_alive_init.therm_r3[1]);
@@ -2330,8 +2330,8 @@ static struct iwl_lib_ops iwl4965_lib = {
 			EEPROM_REGULATORY_BAND_3_CHANNELS,
 			EEPROM_REGULATORY_BAND_4_CHANNELS,
 			EEPROM_REGULATORY_BAND_5_CHANNELS,
-			EEPROM_4965_REGULATORY_BAND_24_FAT_CHANNELS,
-			EEPROM_4965_REGULATORY_BAND_52_FAT_CHANNELS
+			EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS,
+			EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 87957c0..755c184 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -845,7 +845,7 @@ int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_bsm_size = 0;
-	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
@@ -1547,8 +1547,8 @@ struct iwl_lib_ops iwl5000_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
-			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
@@ -1597,8 +1597,8 @@ static struct iwl_lib_ops iwl5150_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
-			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4450943..c3ec6c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -118,8 +118,8 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_5000_REG_BAND_3_CHANNELS,
 			EEPROM_5000_REG_BAND_4_CHANNELS,
 			EEPROM_5000_REG_BAND_5_CHANNELS,
-			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
-			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
 		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 52a4810..0c3ed23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -97,7 +97,7 @@ struct iwl_scale_tbl_info {
 	enum iwl_table_type lq_type;
 	u8 ant_type;
 	u8 is_SGI;	/* 1 = short guard interval */
-	u8 is_fat;	/* 1 = 40 MHz channel width */
+	u8 is_ht40;	/* 1 = 40 MHz channel width */
 	u8 is_dup;	/* 1 = duplicated data streams */
 	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
 	u8 max_search;	/* maximun number of tables we can search */
@@ -539,11 +539,11 @@ static u32 rate_n_flags_from_tbl(struct iwl_priv *priv,
 						     RATE_MCS_ANT_ABC_MSK);
 
 	if (is_Ht(tbl->lq_type)) {
-		if (tbl->is_fat) {
+		if (tbl->is_ht40) {
 			if (tbl->is_dup)
 				rate_n_flags |= RATE_MCS_DUP_MSK;
 			else
-				rate_n_flags |= RATE_MCS_FAT_MSK;
+				rate_n_flags |= RATE_MCS_HT40_MSK;
 		}
 		if (tbl->is_SGI)
 			rate_n_flags |= RATE_MCS_SGI_MSK;
@@ -579,7 +579,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 		return -EINVAL;
 	}
 	tbl->is_SGI = 0;	/* default legacy setup */
-	tbl->is_fat = 0;
+	tbl->is_ht40 = 0;
 	tbl->is_dup = 0;
 	tbl->ant_type = (ant_msk >> RATE_MCS_ANT_POS);
 	tbl->lq_type = LQ_NONE;
@@ -598,9 +598,9 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 		if (rate_n_flags & RATE_MCS_SGI_MSK)
 			tbl->is_SGI = 1;
 
-		if ((rate_n_flags & RATE_MCS_FAT_MSK) ||
+		if ((rate_n_flags & RATE_MCS_HT40_MSK) ||
 		    (rate_n_flags & RATE_MCS_DUP_MSK))
-			tbl->is_fat = 1;
+			tbl->is_ht40 = 1;
 
 		if (rate_n_flags & RATE_MCS_DUP_MSK)
 			tbl->is_dup = 1;
@@ -776,7 +776,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type = ANT_A;/*FIXME:RS*/
 
-		tbl->is_fat = 0;
+		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
 		tbl->max_search = IWL_MAX_SEARCH;
 	}
@@ -880,7 +880,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 
 	if ((info->status.rates[0].idx < 0) ||
 	    (tbl_type.is_SGI != !!(info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)) ||
-	    (tbl_type.is_fat != !!(info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
+	    (tbl_type.is_ht40 != !!(info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
 	    (tbl_type.is_dup != !!(info->status.rates[0].flags & IEEE80211_TX_RC_DUP_DATA)) ||
 	    (tbl_type.ant_type != info->antenna_sel_tx) ||
 	    (!!(tx_rate & RATE_MCS_HT_MSK) != !!(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) ||
@@ -1049,7 +1049,7 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		else
 			tbl->expected_tpt = expected_tpt_A;
 	} else if (is_siso(tbl->lq_type)) {
-		if (tbl->is_fat && !lq_sta->is_dup)
+		if (tbl->is_ht40 && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_siso40MHzSGI;
 			else
@@ -1059,7 +1059,7 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		else
 			tbl->expected_tpt = expected_tpt_siso20MHz;
 	} else if (is_mimo2(tbl->lq_type)) {
-		if (tbl->is_fat && !lq_sta->is_dup)
+		if (tbl->is_ht40 && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_mimo2_40MHzSGI;
 			else
@@ -1069,7 +1069,7 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		else
 			tbl->expected_tpt = expected_tpt_mimo2_20MHz;
 	} else if (is_mimo3(tbl->lq_type)) {
-		if (tbl->is_fat && !lq_sta->is_dup)
+		if (tbl->is_ht40 && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_mimo3_40MHzSGI;
 			else
@@ -1217,13 +1217,13 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
-		tbl->is_fat = 1;
+	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+		tbl->is_ht40 = 1;
 	else
-		tbl->is_fat = 0;
+		tbl->is_ht40 = 0;
 
 	/* FIXME: - don't toggle SGI here
-	if (tbl->is_fat) {
+	if (tbl->is_ht40) {
 		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
 		else
@@ -1283,13 +1283,13 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 	rate_mask = lq_sta->active_mimo3_rate;
 
-	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
-		tbl->is_fat = 1;
+	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+		tbl->is_ht40 = 1;
 	else
-		tbl->is_fat = 0;
+		tbl->is_ht40 = 0;
 
 	/* FIXME: - don't toggle SGI here
-	if (tbl->is_fat) {
+	if (tbl->is_ht40) {
 		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
 		else
@@ -1342,13 +1342,13 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
-		tbl->is_fat = 1;
+	if (iwl_is_ht40_tx_allowed(priv, &sta->ht_cap))
+		tbl->is_ht40 = 1;
 	else
-		tbl->is_fat = 0;
+		tbl->is_ht40 = 0;
 
 	/* FIXME: - don't toggle SGI here
-	if (tbl->is_fat) {
+	if (tbl->is_ht40) {
 		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
 		else
@@ -1586,11 +1586,11 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				goto out;
 			break;
 		case IWL_SISO_SWITCH_GI:
-			if (!tbl->is_fat &&
+			if (!tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
 				break;
-			if (tbl->is_fat &&
+			if (tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_40MHZ))
 				break;
@@ -1726,11 +1726,11 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO2_SWITCH_GI:
-			if (!tbl->is_fat &&
+			if (!tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
 				break;
-			if (tbl->is_fat &&
+			if (tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_40MHZ))
 				break;
@@ -1890,11 +1890,11 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO3_SWITCH_GI:
-			if (!tbl->is_fat &&
+			if (!tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_20MHZ))
 				break;
-			if (tbl->is_fat &&
+			if (tbl->is_ht40 &&
 				!(priv->current_ht_config.sgf &
 						HT_SHORT_GI_40MHZ))
 				break;
@@ -2576,7 +2576,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			info->control.rates[0].flags |= IEEE80211_TX_RC_SHORT_GI;
 		if (lq_sta->last_rate_n_flags & RATE_MCS_DUP_MSK)
 			info->control.rates[0].flags |= IEEE80211_TX_RC_DUP_DATA;
-		if (lq_sta->last_rate_n_flags & RATE_MCS_FAT_MSK)
+		if (lq_sta->last_rate_n_flags & RATE_MCS_HT40_MSK)
 			info->control.rates[0].flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
 			info->control.rates[0].flags |= IEEE80211_TX_RC_GREEN_FIELD;
@@ -2963,7 +2963,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		   (is_siso(tbl->lq_type)) ? "SISO" :
 		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
 		   desc += sprintf(buff+desc, " %s",
-		   (tbl->is_fat) ? "40MHz" : "20MHz");
+		   (tbl->is_ht40) ? "40MHz" : "20MHz");
 		   desc += sprintf(buff+desc, " %s %s\n", (tbl->is_SGI) ? "SGI" : "",
 		   (lq_sta->is_green) ? "GF enabled" : "");
 	}
@@ -3028,12 +3028,13 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 		return -ENOMEM;
 
 	for (i = 0; i < LQ_SIZE; i++) {
-		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d GF=%d\n"
+		desc += sprintf(buff+desc,
+				"%s type=%d SGI=%d HT40=%d DUP=%d GF=%d\n"
 				"rate=0x%X\n",
 				lq_sta->active_tbl == i ? "*" : "x",
 				lq_sta->lq_info[i].lq_type,
 				lq_sta->lq_info[i].is_SGI,
-				lq_sta->lq_info[i].is_fat,
+				lq_sta->lq_info[i].is_ht40,
 				lq_sta->lq_info[i].is_dup,
 				lq_sta->is_green,
 				lq_sta->lq_info[i].current_rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 39ede57..6188c54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -283,7 +283,7 @@ struct iwl3945_power_per_rate {
  *        1)  Dual stream (MIMO)
  *        2)  Triple stream (MIMO)
  *
- *    5:  Value of 0x20 in bits 7:0 indicates 6 Mbps FAT duplicate data
+ *    5:  Value of 0x20 in bits 7:0 indicates 6 Mbps HT40 duplicate data
  *
  * Legacy OFDM rate format for bits 7:0 (bit 8 must be "0", bit 9 "0"):
  *  3-0:  0xD)   6 Mbps
@@ -320,11 +320,11 @@ struct iwl3945_power_per_rate {
 #define RATE_MCS_GF_POS 10
 #define RATE_MCS_GF_MSK 0x400
 
-/* Bit 11: (1) Use 40Mhz FAT chnl width, (0) use 20 MHz legacy chnl width */
-#define RATE_MCS_FAT_POS 11
-#define RATE_MCS_FAT_MSK 0x800
+/* Bit 11: (1) Use 40Mhz HT40 chnl width, (0) use 20 MHz legacy chnl width */
+#define RATE_MCS_HT40_POS 11
+#define RATE_MCS_HT40_MSK 0x800
 
-/* Bit 12: (1) Duplicate data on both 20MHz chnls.  FAT (bit 11) must be set. */
+/* Bit 12: (1) Duplicate data on both 20MHz chnls. HT40 (bit 11) must be set. */
 #define RATE_MCS_DUP_POS 12
 #define RATE_MCS_DUP_MSK 0x1000
 
@@ -459,7 +459,7 @@ struct iwl_init_alive_resp {
 
 	/* calibration values from "initialize" uCode */
 	__le32 voltage;		/* signed, higher value is lower voltage */
-	__le32 therm_r1[2];	/* signed, 1st for normal, 2nd for FAT channel*/
+	__le32 therm_r1[2];	/* signed, 1st for normal, 2nd for HT40 */
 	__le32 therm_r2[2];	/* signed */
 	__le32 therm_r3[2];	/* signed */
 	__le32 therm_r4[2];	/* signed */
@@ -610,7 +610,7 @@ enum {
 #define RXON_FLG_HT_OPERATING_MODE_POS		(23)
 
 #define RXON_FLG_HT_PROT_MSK			cpu_to_le32(0x1 << 23)
-#define RXON_FLG_FAT_PROT_MSK			cpu_to_le32(0x2 << 23)
+#define RXON_FLG_HT40_PROT_MSK			cpu_to_le32(0x2 << 23)
 
 #define RXON_FLG_CHANNEL_MODE_POS		(25)
 #define RXON_FLG_CHANNEL_MODE_MSK		cpu_to_le32(0x3 << 25)
@@ -891,7 +891,7 @@ struct iwl_qosparam_cmd {
 #define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
 #define STA_FLG_MAX_AGG_SIZE_MSK	cpu_to_le32(3 << 19)
-#define STA_FLG_FAT_EN_MSK		cpu_to_le32(1 << 21)
+#define STA_FLG_HT40_EN_MSK		cpu_to_le32(1 << 21)
 #define STA_FLG_MIMO_DIS_MSK		cpu_to_le32(1 << 22)
 #define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
 #define STA_FLG_AGG_MPDU_DENSITY_MSK	cpu_to_le32(7 << 23)
@@ -1984,10 +1984,10 @@ struct iwl_link_qual_agg_params {
  *     a) Use this same initial rate for first 3 entries.
  *     b) Find next lower available rate using same mode (SISO or MIMO),
  *        use for next 3 entries.  If no lower rate available, switch to
- *        legacy mode (no FAT channel, no MIMO, no short guard interval).
+ *        legacy mode (no HT40 channel, no MIMO, no short guard interval).
  *     c) If using MIMO, set command's mimo_delimiter to number of entries
  *        using MIMO (3 or 6).
- *     d) After trying 2 HT rates, switch to legacy mode (no FAT channel,
+ *     d) After trying 2 HT rates, switch to legacy mode (no HT40 channel,
  *        no MIMO, no short guard interval), at the next lower bit rate
  *        (e.g. if second HT bit rate was 54, try 48 legacy), and follow
  *        legacy procedure for remaining table entries.
@@ -3017,7 +3017,7 @@ struct iwl_statistics_cmd {
  * one channel that has just been scanned.
  */
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         cpu_to_le32(0x8)
+#define STATISTICS_REPLY_FLG_HT40_MODE_MSK        cpu_to_le32(0x8)
 
 struct iwl3945_notif_statistics {
 	__le32 flag;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 30f1953..5315d34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -105,7 +105,7 @@ void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 		r->flags |= IEEE80211_TX_RC_MCS;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
 		r->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-	if (rate_n_flags & RATE_MCS_FAT_MSK)
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
 		r->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 	if (rate_n_flags & RATE_MCS_DUP_MSK)
 		r->flags |= IEEE80211_TX_RC_DUP_DATA;
@@ -400,7 +400,7 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
 
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (priv->hw_params.fat_channel & BIT(band)) {
+	if (priv->hw_params.ht40_channel & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
 		ht_info->mcs.rx_mask[4] = 0x01;
@@ -540,7 +540,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
-			geo_ch->flags |= ch->fat_extension_channel;
+			geo_ch->flags |= ch->ht40_extension_channel;
 
 			if (ch->max_power_avg > priv->tx_power_channel_lmt)
 				priv->tx_power_channel_lmt = ch->max_power_avg;
@@ -604,16 +604,16 @@ static u8 iwl_is_channel_extension(struct iwl_priv *priv,
 		return 0;
 
 	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
-		return !(ch_info->fat_extension_channel &
+		return !(ch_info->ht40_extension_channel &
 					IEEE80211_CHAN_NO_HT40PLUS);
 	else if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		return !(ch_info->fat_extension_channel &
+		return !(ch_info->ht40_extension_channel &
 					IEEE80211_CHAN_NO_HT40MINUS);
 
 	return 0;
 }
 
-u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
+u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf)
 {
 	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
@@ -637,7 +637,7 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			le16_to_cpu(priv->staging_rxon.channel),
 			iwl_ht_conf->extension_chan_offset);
 }
-EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
+EXPORT_SYMBOL(iwl_is_ht40_tx_allowed);
 
 static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 {
@@ -866,7 +866,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 	if (!ht_info->is_ht) {
 		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
-			RXON_FLG_FAT_PROT_MSK |
+			RXON_FLG_HT40_PROT_MSK |
 			RXON_FLG_HT_PROT_MSK);
 		return;
 	}
@@ -877,12 +877,12 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 	rxon->flags |= cpu_to_le32(ht_info->ht_protection << RXON_FLG_HT_OPERATING_MODE_POS);
 
 	/* Set up channel bandwidth:
-	 * 20 MHz only, 20/40 mixed or pure 40 if fat ok */
+	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
 	/* clear the HT channel mode before set the mode */
 	rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-	if (iwl_is_fat_tx_allowed(priv, NULL)) {
-		/* pure 40 fat */
+	if (iwl_is_ht40_tx_allowed(priv, NULL)) {
+		/* pure ht40 */
 		if (ht_info->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
 			/* Note: control channel is opposite of extension channel */
@@ -2428,7 +2428,7 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	else if (conf_is_ht40_plus(&priv->hw->conf))
 		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 
-	/* If no above or below channel supplied disable FAT channel */
+	/* If no above or below channel supplied disable HT40 channel */
 	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
 	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW)
 		iwl_conf->supported_chan_width = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 10ddcdd..dd66148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -264,7 +264,7 @@ int iwl_full_rxon_required(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
-u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
+u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
 void iwl_set_flags_for_band(struct iwl_priv *priv, enum ieee80211_band band);
 void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1bf3e4c..624656a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -277,8 +277,8 @@ struct iwl_channel_info {
 	struct iwl4965_channel_tgd_info tgd;
 	struct iwl4965_channel_tgh_info tgh;
 	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
-						 * FAT channel */
+	struct iwl_eeprom_channel ht40_eeprom;	/* EEPROM regulatory limit for
+						 * HT40 channel */
 
 	u8 channel;	  /* channel number */
 	u8 flags;	  /* flags copied from EEPROM */
@@ -291,13 +291,13 @@ struct iwl_channel_info {
 	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
 	enum ieee80211_band band;
 
-	/* FAT channel info */
-	s8 fat_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 fat_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
-	s8 fat_min_power;	/* always 0 */
-	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
-	u8 fat_flags;		/* flags copied from EEPROM */
-	u8 fat_extension_channel; /* HT_IE_EXT_CHANNEL_* */
+	/* HT40 channel info */
+	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
+	s8 ht40_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
+	s8 ht40_min_power;	/* always 0 */
+	s8 ht40_scan_power;	/* (dBm) eeprom, direct scans, any rate */
+	u8 ht40_flags;		/* flags copied from EEPROM */
+	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
 
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
@@ -649,7 +649,7 @@ struct iwl_sensitivity_ranges {
  * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
  * @bcast_sta_id:
- * @fat_channel: is 40MHz width possible in band 2.4
+ * @ht40_channel: is 40MHz width possible in band 2.4
  * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
@@ -673,7 +673,7 @@ struct iwl_hw_params {
 	u32 max_pkt_size;
 	u8  max_stations;
 	u8  bcast_sta_id;
-	u8 fat_channel;
+	u8  ht40_channel;
 	u8  max_beacon_itrvl;	/* in 1024 ms */
 	u32 max_inst_size;
 	u32 max_data_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 51eed72..78c4a32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -127,11 +127,11 @@ static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
 	145, 149, 153, 157, 161, 165
 };
 
-static const u8 iwl_eeprom_band_6[] = {       /* 2.4 FAT channel */
+static const u8 iwl_eeprom_band_6[] = {       /* 2.4 ht40 channel */
 	1, 2, 3, 4, 5, 6, 7
 };
 
-static const u8 iwl_eeprom_band_7[] = {       /* 5.2 FAT channel */
+static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
 };
 
@@ -462,13 +462,13 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_5;
 		break;
-	case 6:		/* 2.4GHz FAT channels */
+	case 6:		/* 2.4GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_6;
 		break;
-	case 7:		/* 5 GHz FAT channels */
+	case 7:		/* 5 GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
 		*eeprom_ch_info = (struct iwl_eeprom_channel *)
 				iwl_eeprom_query_addr(priv, offset);
@@ -484,14 +484,14 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			    ? # x " " : "")
 
 /**
- * iwl_set_fat_chan_info - Copy fat channel info into driver's priv.
+ * iwl_set_ht40_chan_info - Copy ht40 channel info into driver's priv.
  *
  * Does not set up a command, or touch hardware.
  */
-static int iwl_set_fat_chan_info(struct iwl_priv *priv,
+static int iwl_set_ht40_chan_info(struct iwl_priv *priv,
 			      enum ieee80211_band band, u16 channel,
 			      const struct iwl_eeprom_channel *eeprom_ch,
-			      u8 fat_extension_channel)
+			      u8 ht40_extension_channel)
 {
 	struct iwl_channel_info *ch_info;
 
@@ -501,7 +501,7 @@ static int iwl_set_fat_chan_info(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO(priv, "FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
+	IWL_DEBUG_INFO(priv, "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
 			" Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
@@ -517,13 +517,13 @@ static int iwl_set_fat_chan_info(struct iwl_priv *priv,
 			 && !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ?
 			"" : "not ");
 
-	ch_info->fat_eeprom = *eeprom_ch;
-	ch_info->fat_max_power_avg = eeprom_ch->max_power_avg;
-	ch_info->fat_curr_txpow = eeprom_ch->max_power_avg;
-	ch_info->fat_min_power = 0;
-	ch_info->fat_scan_power = eeprom_ch->max_power_avg;
-	ch_info->fat_flags = eeprom_ch->flags;
-	ch_info->fat_extension_channel = fat_extension_channel;
+	ch_info->ht40_eeprom = *eeprom_ch;
+	ch_info->ht40_max_power_avg = eeprom_ch->max_power_avg;
+	ch_info->ht40_curr_txpow = eeprom_ch->max_power_avg;
+	ch_info->ht40_min_power = 0;
+	ch_info->ht40_scan_power = eeprom_ch->max_power_avg;
+	ch_info->ht40_flags = eeprom_ch->flags;
+	ch_info->ht40_extension_channel = ht40_extension_channel;
 
 	return 0;
 }
@@ -589,9 +589,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			/* Copy the run-time flags so they are there even on
 			 * invalid channels */
 			ch_info->flags = eeprom_ch_info[ch].flags;
-			/* First write that fat is not enabled, and then enable
+			/* First write that ht40 is not enabled, and then enable
 			 * one by one */
-			ch_info->fat_extension_channel =
+			ch_info->ht40_extension_channel =
 				(IEEE80211_CHAN_NO_HT40PLUS |
 				 IEEE80211_CHAN_NO_HT40MINUS);
 
@@ -642,17 +642,17 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		}
 	}
 
-	/* Check if we do have FAT channels */
+	/* Check if we do have HT40 channels */
 	if (priv->cfg->ops->lib->eeprom_ops.regulatory_bands[5] ==
-	    EEPROM_REGULATORY_BAND_NO_FAT &&
+	    EEPROM_REGULATORY_BAND_NO_HT40 &&
 	    priv->cfg->ops->lib->eeprom_ops.regulatory_bands[6] ==
-	    EEPROM_REGULATORY_BAND_NO_FAT)
+	    EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
-	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
+	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
 	for (band = 6; band <= 7; band++) {
 		enum ieee80211_band ieeeband;
-		u8 fat_extension_chan;
+		u8 ht40_extension_chan;
 
 		iwl_init_band_reference(priv, band, &eeprom_ch_count,
 					&eeprom_ch_info, &eeprom_ch_index);
@@ -669,19 +669,19 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 				 (eeprom_ch_index[ch] == 6) ||
 				 (eeprom_ch_index[ch] == 7)))
 				/* both are allowed: above and below */
-				fat_extension_chan = 0;
+				ht40_extension_chan = 0;
 			else
-				fat_extension_chan =
+				ht40_extension_chan =
 					IEEE80211_CHAN_NO_HT40MINUS;
 
 			/* Set up driver's info for lower half */
-			iwl_set_fat_chan_info(priv, ieeeband,
+			iwl_set_ht40_chan_info(priv, ieeeband,
 						eeprom_ch_index[ch],
 						&(eeprom_ch_info[ch]),
-						fat_extension_chan);
+						ht40_extension_chan);
 
 			/* Set up driver's info for upper half */
-			iwl_set_fat_chan_info(priv, ieeeband,
+			iwl_set_ht40_chan_info(priv, ieeeband,
 						(eeprom_ch_index[ch] + 4),
 						&(eeprom_ch_info[ch]),
 						IEEE80211_CHAN_NO_HT40PLUS);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 195b4ef..05d4fc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -88,10 +88,10 @@ struct iwl_priv;
  * requirement for establishing a new network for legal operation on channels
  * requiring RADAR detection or restricting ACTIVE scanning.
  *
- * NOTE:  "WIDE" flag does not indicate anything about "FAT" 40 MHz channels.
- *        It only indicates that 20 MHz channel use is supported; FAT channel
+ * NOTE:  "WIDE" flag does not indicate anything about "HT40" 40 MHz channels.
+ *        It only indicates that 20 MHz channel use is supported; HT40 channel
  *        usage is indicated by a separate set of regulatory flags for each
- *        FAT channel pair.
+ *        HT40 channel pair.
  *
  * NOTE:  Using a channel inappropriately will result in a uCode error!
  */
@@ -112,7 +112,7 @@ enum {
 #define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
 
 /* *regulatory* channel data format in eeprom, one for each channel.
- * There are separate entries for FAT (40 MHz) vs. normal (20 MHz) channels. */
+ * There are separate entries for HT40 (40 MHz) vs. normal (20 MHz) channels. */
 struct iwl_eeprom_channel {
 	u8 flags;		/* EEPROM_CHANNEL_* flags copied from EEPROM */
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
@@ -170,9 +170,9 @@ struct iwl_eeprom_channel {
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22 bytes */
 #define EEPROM_5000_REG_BAND_5_CHANNELS       ((0x74)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 12 bytes */
-#define EEPROM_5000_REG_BAND_24_FAT_CHANNELS  ((0x82)\
+#define EEPROM_5000_REG_BAND_24_HT40_CHANNELS  ((0x82)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-#define EEPROM_5000_REG_BAND_52_FAT_CHANNELS  ((0x92)\
+#define EEPROM_5000_REG_BAND_52_HT40_CHANNELS  ((0x92)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
 
 /* 5050 Specific */
@@ -313,7 +313,7 @@ struct iwl_eeprom_calib_info {
  * in EEPROM containing EEPROM_CHANNEL_* usage flags (LSB) and max regulatory
  * txpower (MSB).
  *
- * Entries immediately below are for 20 MHz channel width.  FAT (40 MHz)
+ * Entries immediately below are for 20 MHz channel width.  HT40 (40 MHz)
  * channels (only for 4965, not supported by 3945) appear later in the EEPROM.
  *
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
@@ -352,29 +352,29 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
 
 /*
- * 2.4 GHz FAT channels 1 (5), 2 (6), 3 (7), 4 (8), 5 (9), 6 (10), 7 (11)
+ * 2.4 GHz HT40 channels 1 (5), 2 (6), 3 (7), 4 (8), 5 (9), 6 (10), 7 (11)
  *
  * The channel listed is the center of the lower 20 MHz half of the channel.
  * The overall center frequency is actually 2 channels (10 MHz) above that,
- * and the upper half of each FAT channel is centered 4 channels (20 MHz) away
- * from the lower half; e.g. the upper half of FAT channel 1 is channel 5,
- * and the overall FAT channel width centers on channel 3.
+ * and the upper half of each HT40 channel is centered 4 channels (20 MHz) away
+ * from the lower half; e.g. the upper half of HT40 channel 1 is channel 5,
+ * and the overall HT40 channel width centers on channel 3.
  *
  * NOTE:  The RXON command uses 20 MHz channel numbers to specify the
  *        control channel to which to tune.  RXON also specifies whether the
- *        control channel is the upper or lower half of a FAT channel.
+ *        control channel is the upper or lower half of a HT40 channel.
  *
- * NOTE:  4965 does not support FAT channels on 2.4 GHz.
+ * NOTE:  4965 does not support HT40 channels on 2.4 GHz.
  */
-#define EEPROM_4965_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
+#define EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS (2*0xA0)	/* 14 bytes */
 
 /*
- * 5.2 GHz FAT channels 36 (40), 44 (48), 52 (56), 60 (64),
+ * 5.2 GHz HT40 channels 36 (40), 44 (48), 52 (56), 60 (64),
  * 100 (104), 108 (112), 116 (120), 124 (128), 132 (136), 149 (153), 157 (161)
  */
-#define EEPROM_4965_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
+#define EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS (2*0xA8)	/* 22 bytes */
 
-#define EEPROM_REGULATORY_BAND_NO_FAT			(0)
+#define EEPROM_REGULATORY_BAND_NO_HT40			(0)
 
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 00937b3..594b5c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -583,7 +583,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 				/* disable HT */
 				rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
 					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
-					RXON_FLG_FAT_PROT_MSK |
+					RXON_FLG_HT40_PROT_MSK |
 					RXON_FLG_HT_PROT_MSK);
 			else {
 				/* check HT capability and set
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 98f0142..9e63f9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -544,8 +544,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	change = ((priv->statistics.general.temperature !=
 		   pkt->u.stats.general.temperature) ||
 		  ((priv->statistics.flag &
-		    STATISTICS_REPLY_FLG_FAT_MODE_MSK) !=
-		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)));
+		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index def1254..c6633fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -214,10 +214,10 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	sta_flags |= cpu_to_le32(
 	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (iwl_is_fat_tx_allowed(priv, sta_ht_inf))
-		sta_flags |= STA_FLG_FAT_EN_MSK;
+	if (iwl_is_ht40_tx_allowed(priv, sta_ht_inf))
+		sta_flags |= STA_FLG_HT40_EN_MSK;
 	else
-		sta_flags &= ~STA_FLG_FAT_EN_MSK;
+		sta_flags &= ~STA_FLG_HT40_EN_MSK;
 
 	priv->stations[index].sta.station_flags = sta_flags;
  done:
-- 
1.5.6.3

