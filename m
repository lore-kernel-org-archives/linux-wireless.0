Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbbCLNEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/49] iwlwifi: mvm: consider LAR support during NVM parse
Date: Thu, 12 Mar 2015 15:03:51 +0200
Message-Id: <1426165474-25586-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140456_409488_6A6CCAE8)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Register to cfg80211 with all channels enabled when LAR is supported.
Appropriate channels will later be disabled when a specific regulatory
domain is defined.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 110 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |   3 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c       |   3 +-
 3 files changed, 67 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index d8d9a97..a49666f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -201,9 +201,53 @@ enum iwl_nvm_channel_flags {
 #define CHECK_AND_PRINT_I(x)	\
 	((ch_flags & NVM_CHANNEL_##x) ? # x " " : "")
 
+static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
+				 u16 nvm_flags)
+{
+	u32 flags = IEEE80211_CHAN_NO_HT40;
+
+	if (!is_5ghz && (nvm_flags & NVM_CHANNEL_40MHZ)) {
+		if (ch_num <= LAST_2GHZ_HT_PLUS)
+			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
+		if (ch_num >= FIRST_2GHZ_HT_MINUS)
+			flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
+	} else if (ch_num <= LAST_5GHZ_HT && (nvm_flags & NVM_CHANNEL_40MHZ)) {
+		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
+			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
+		else
+			flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
+	}
+	if (!(nvm_flags & NVM_CHANNEL_80MHZ))
+		flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (!(nvm_flags & NVM_CHANNEL_160MHZ))
+		flags |= IEEE80211_CHAN_NO_160MHZ;
+
+	if (!(nvm_flags & NVM_CHANNEL_IBSS))
+		flags |= IEEE80211_CHAN_NO_IR;
+
+	if (!(nvm_flags & NVM_CHANNEL_ACTIVE))
+		flags |= IEEE80211_CHAN_NO_IR;
+
+	if (nvm_flags & NVM_CHANNEL_RADAR)
+		flags |= IEEE80211_CHAN_RADAR;
+
+	if (nvm_flags & NVM_CHANNEL_INDOOR_ONLY)
+		flags |= IEEE80211_CHAN_INDOOR_ONLY;
+
+	/* Set the GO concurrent flag only in case that NO_IR is set.
+	 * Otherwise it is meaningless
+	 */
+	if ((nvm_flags & NVM_CHANNEL_GO_CONCURRENT) &&
+	    (flags & IEEE80211_CHAN_NO_IR))
+		flags |= IEEE80211_CHAN_GO_CONCURRENT;
+
+	return flags;
+}
+
 static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 				struct iwl_nvm_data *data,
-				const __le16 * const nvm_ch_flags)
+				const __le16 * const nvm_ch_flags,
+				bool lar_supported)
 {
 	int ch_idx;
 	int n_channels = 0;
@@ -230,7 +274,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		    !data->sku_cap_band_52GHz_enable)
 			ch_flags &= ~NVM_CHANNEL_VALID;
 
-		if (!(ch_flags & NVM_CHANNEL_VALID)) {
+		if (!lar_supported && !(ch_flags & NVM_CHANNEL_VALID)) {
 			IWL_DEBUG_EEPROM(dev,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
 					 nvm_chan[ch_idx],
@@ -250,45 +294,6 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			ieee80211_channel_to_frequency(
 				channel->hw_value, channel->band);
 
-		/* TODO: Need to be dependent to the NVM */
-		channel->flags = IEEE80211_CHAN_NO_HT40;
-		if (ch_idx < num_2ghz_channels &&
-		    (ch_flags & NVM_CHANNEL_40MHZ)) {
-			if (nvm_chan[ch_idx] <= LAST_2GHZ_HT_PLUS)
-				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
-			if (nvm_chan[ch_idx] >= FIRST_2GHZ_HT_MINUS)
-				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
-		} else if (nvm_chan[ch_idx] <= LAST_5GHZ_HT &&
-			   (ch_flags & NVM_CHANNEL_40MHZ)) {
-			if ((ch_idx - num_2ghz_channels) % 2 == 0)
-				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
-			else
-				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
-		}
-		if (!(ch_flags & NVM_CHANNEL_80MHZ))
-			channel->flags |= IEEE80211_CHAN_NO_80MHZ;
-		if (!(ch_flags & NVM_CHANNEL_160MHZ))
-			channel->flags |= IEEE80211_CHAN_NO_160MHZ;
-
-		if (!(ch_flags & NVM_CHANNEL_IBSS))
-			channel->flags |= IEEE80211_CHAN_NO_IR;
-
-		if (!(ch_flags & NVM_CHANNEL_ACTIVE))
-			channel->flags |= IEEE80211_CHAN_NO_IR;
-
-		if (ch_flags & NVM_CHANNEL_RADAR)
-			channel->flags |= IEEE80211_CHAN_RADAR;
-
-		if (ch_flags & NVM_CHANNEL_INDOOR_ONLY)
-			channel->flags |= IEEE80211_CHAN_INDOOR_ONLY;
-
-		/* Set the GO concurrent flag only in case that NO_IR is set.
-		 * Otherwise it is meaningless
-		 */
-		if ((ch_flags & NVM_CHANNEL_GO_CONCURRENT) &&
-		    (channel->flags & IEEE80211_CHAN_NO_IR))
-			channel->flags |= IEEE80211_CHAN_GO_CONCURRENT;
-
 		/* Initialize regulatory-based run-time data */
 
 		/*
@@ -297,6 +302,15 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		 */
 		channel->max_power = IWL_DEFAULT_MAX_TX_POWER;
 		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
+
+		/* don't put limitations in case we're using LAR */
+		if (!lar_supported)
+			channel->flags = iwl_get_channel_flags(nvm_chan[ch_idx],
+							       ch_idx, is_5ghz,
+							       ch_flags);
+		else
+			channel->flags = 0;
+
 		IWL_DEBUG_EEPROM(dev,
 				 "Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
 				 channel->hw_value,
@@ -371,7 +385,7 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 			    struct iwl_nvm_data *data,
 			    const __le16 *ch_section, bool enable_vht,
-			    u8 tx_chains, u8 rx_chains)
+			    u8 tx_chains, u8 rx_chains, bool lar_supported)
 {
 	int n_channels;
 	int n_used = 0;
@@ -380,11 +394,12 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		n_channels = iwl_init_channel_map(
 				dev, cfg, data,
-				&ch_section[NVM_CHANNELS]);
+				&ch_section[NVM_CHANNELS], lar_supported);
 	else
 		n_channels = iwl_init_channel_map(
 				dev, cfg, data,
-				&ch_section[NVM_CHANNELS_FAMILY_8000]);
+				&ch_section[NVM_CHANNELS_FAMILY_8000],
+				lar_supported);
 
 	sband = &data->bands[IEEE80211_BAND_2GHZ];
 	sband->band = IEEE80211_BAND_2GHZ;
@@ -571,7 +586,8 @@ struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
-		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains)
+		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
+		   bool lar_supported)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
@@ -627,7 +643,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 		iwl_init_sbands(dev, cfg, data, nvm_sw,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains);
+				rx_chains, lar_supported);
 	} else {
 		/* MAC address in family 8000 */
 		iwl_set_hw_address_family_8000(dev, cfg, data, mac_override,
@@ -635,7 +651,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains);
+				rx_chains, lar_supported);
 	}
 
 	data->calib_version = 255;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index fa493ce..c2fa930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -77,7 +77,8 @@ struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
-		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains);
+		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
+		   bool lar_supported);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 26c5d94..907e231 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -302,7 +302,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override,
 				  mvm->fw->valid_tx_ant,
-				  mvm->fw->valid_rx_ant);
+				  mvm->fw->valid_rx_ant,
+				  iwl_mvm_is_lar_supported(mvm));
 }
 
 #define MAX_NVM_FILE_LEN	16384
-- 
1.9.1

