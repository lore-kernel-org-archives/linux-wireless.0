Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59130 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaBWT5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:24 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so4051458wgh.7
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/17] iwlwifi: mvm: new NVM format in family 8000
Date: Sun, 23 Feb 2014 21:56:58 +0200
Message-Id: <1393185428-8524-7-git-send-email-egrumbach@gmail.com> (sfid-20140223_211708_907504_CE156EBF)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Support the changes below:
- Fields and sections structure were changed.
- the NVM file built from DWord instead of Words.
- sections header format was changed.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c          |    6 +
 drivers/net/wireless/iwlwifi/iwl-drv.h          |   14 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    5 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  239 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |    3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |    4 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c          |   63 ++++--
 8 files changed, 271 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index b3bc30b..662d993 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -728,6 +728,12 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			if (tlv_len != sizeof(u32))
 				goto invalid_tlv_len;
 			drv->fw.phy_config = le32_to_cpup((__le32 *)tlv_data);
+			drv->fw.valid_tx_ant = (drv->fw.phy_config &
+						FW_PHY_CFG_TX_CHAIN) >>
+						FW_PHY_CFG_TX_CHAIN_POS;
+			drv->fw.valid_rx_ant = (drv->fw.phy_config &
+						FW_PHY_CFG_RX_CHAIN) >>
+						FW_PHY_CFG_RX_CHAIN_POS;
 			break;
 		 case IWL_UCODE_TLV_SECURE_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 592c01e..3c72cb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -70,6 +70,20 @@
 #define DRV_COPYRIGHT	"Copyright(c) 2003- 2014 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
+/* radio config bits (actual values from NVM definition) */
+#define NVM_RF_CFG_DASH_MSK(x)   (x & 0x3)         /* bits 0-1   */
+#define NVM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
+#define NVM_RF_CFG_TYPE_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
+#define NVM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
+#define NVM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
+#define NVM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
+
+#define NVM_RF_CFG_FLAVOR_MSK_FAMILY_8000(x)   (x & 0xF)
+#define NVM_RF_CFG_DASH_MSK_FAMILY_8000(x)   ((x >> 4) & 0xF)
+#define NVM_RF_CFG_STEP_MSK_FAMILY_8000(x)   ((x >> 8) & 0xF)
+#define NVM_RF_CFG_TYPE_MSK_FAMILY_8000(x)   ((x >> 12) & 0xFFF)
+#define NVM_RF_CFG_TX_ANT_MSK_FAMILY_8000(x) ((x >> 24) & 0xF)
+#define NVM_RF_CFG_RX_ANT_MSK_FAMILY_8000(x) ((x >> 28) & 0xF)
 
 /**
  * DOC: Driver system flows - drv component
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index e3c7dea..f0548b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -81,16 +81,17 @@ struct iwl_nvm_data {
 	bool sku_cap_band_24GHz_enable;
 	bool sku_cap_band_52GHz_enable;
 	bool sku_cap_11n_enable;
+	bool sku_cap_11ac_enable;
 	bool sku_cap_amt_enable;
 	bool sku_cap_ipan_enable;
 
-	u8 radio_cfg_type;
+	u16 radio_cfg_type;
 	u8 radio_cfg_step;
 	u8 radio_cfg_dash;
 	u8 radio_cfg_pnum;
 	u8 valid_tx_ant, valid_rx_ant;
 
-	u16 nvm_version;
+	u32 nvm_version;
 	s8 max_tx_pwr_half_dbm;
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index b0d0998..7367107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -288,6 +288,8 @@ struct iwl_fw {
 
 	struct iwl_tlv_calib_ctrl default_calib[IWL_UCODE_TYPE_MAX];
 	u32 phy_config;
+	u8 valid_tx_ant;
+	u8 valid_rx_ant;
 
 	bool mvm_fw;
 
@@ -296,14 +298,12 @@ struct iwl_fw {
 
 static inline u8 iwl_fw_valid_tx_ant(const struct iwl_fw *fw)
 {
-	return (fw->phy_config & FW_PHY_CFG_TX_CHAIN) >>
-		FW_PHY_CFG_TX_CHAIN_POS;
+	return fw->valid_tx_ant;
 }
 
 static inline u8 iwl_fw_valid_rx_ant(const struct iwl_fw *fw)
 {
-	return (fw->phy_config & FW_PHY_CFG_RX_CHAIN) >>
-		FW_PHY_CFG_RX_CHAIN_POS;
+	return fw->valid_rx_ant;
 }
 
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 4278097..df3ea60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -71,7 +71,7 @@ enum wkp_nvm_offsets {
 	/* NVM HW-Section offset (in words) definitions */
 	HW_ADDR = 0x15,
 
-/* NVM SW-Section offset (in words) definitions */
+	/* NVM SW-Section offset (in words) definitions */
 	NVM_SW_SECTION = 0x1C0,
 	NVM_VERSION = 0,
 	RADIO_CFG = 1,
@@ -79,11 +79,32 @@ enum wkp_nvm_offsets {
 	N_HW_ADDRS = 3,
 	NVM_CHANNELS = 0x1E0 - NVM_SW_SECTION,
 
-/* NVM calibration section offset (in words) definitions */
+	/* NVM calibration section offset (in words) definitions */
 	NVM_CALIB_SECTION = 0x2B8,
 	XTAL_CALIB = 0x316 - NVM_CALIB_SECTION
 };
 
+enum family_8000_nvm_offsets {
+	/* NVM HW-Section offset (in words) definitions */
+	HW_ADDR0_FAMILY_8000 = 0x12,
+	HW_ADDR1_FAMILY_8000 = 0x16,
+	MAC_ADDRESS_OVERRIDE_FAMILY_8000 = 1,
+
+	/* NVM SW-Section offset (in words) definitions */
+	NVM_SW_SECTION_FAMILY_8000 = 0x1C0,
+	NVM_VERSION_FAMILY_8000 = 0,
+	RADIO_CFG_FAMILY_8000 = 2,
+	SKU_FAMILY_8000 = 4,
+	N_HW_ADDRS_FAMILY_8000 = 5,
+
+	/* NVM REGULATORY -Section offset (in words) definitions */
+	NVM_CHANNELS_FAMILY_8000 = 0,
+
+	/* NVM calibration section offset (in words) definitions */
+	NVM_CALIB_SECTION_FAMILY_8000 = 0x2B8,
+	XTAL_CALIB_FAMILY_8000 = 0x316 - NVM_CALIB_SECTION_FAMILY_8000
+};
+
 /* SKU Capabilities (actual values from NVM definition) */
 enum nvm_sku_bits {
 	NVM_SKU_CAP_BAND_24GHZ	= BIT(0),
@@ -92,14 +113,6 @@ enum nvm_sku_bits {
 	NVM_SKU_CAP_11AC_ENABLE	= BIT(3),
 };
 
-/* radio config bits (actual values from NVM definition) */
-#define NVM_RF_CFG_DASH_MSK(x)   (x & 0x3)         /* bits 0-1   */
-#define NVM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
-#define NVM_RF_CFG_TYPE_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
-#define NVM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
-#define NVM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
-#define NVM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
-
 /*
  * These are the channel numbers in the order that they are stored in the NVM
  */
@@ -112,7 +125,17 @@ static const u8 iwl_nvm_channels[] = {
 	149, 153, 157, 161, 165
 };
 
+static const u8 iwl_nvm_channels_family_8000[] = {
+	/* 2.4 GHz */
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
+	/* 5 GHz */
+	36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92,
+	96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
+	149, 153, 157, 161, 165, 169, 173, 177, 181
+};
+
 #define IWL_NUM_CHANNELS	ARRAY_SIZE(iwl_nvm_channels)
+#define IWL_NUM_CHANNELS_FAMILY_8000	ARRAY_SIZE(iwl_nvm_channels_family_8000)
 #define NUM_2GHZ_CHANNELS	14
 #define FIRST_2GHZ_HT_MINUS	5
 #define LAST_2GHZ_HT_PLUS	9
@@ -179,13 +202,23 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	struct ieee80211_channel *channel;
 	u16 ch_flags;
 	bool is_5ghz;
+	int num_of_ch;
+	const u8 *nvm_chan;
+
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		num_of_ch = IWL_NUM_CHANNELS;
+		nvm_chan = &iwl_nvm_channels[0];
+	} else {
+		num_of_ch = IWL_NUM_CHANNELS_FAMILY_8000;
+		nvm_chan = &iwl_nvm_channels_family_8000[0];
+	}
 
-	for (ch_idx = 0; ch_idx < IWL_NUM_CHANNELS; ch_idx++) {
+	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
 		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
 		if (!(ch_flags & NVM_CHANNEL_VALID)) {
 			IWL_DEBUG_EEPROM(dev,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
-					 iwl_nvm_channels[ch_idx],
+					 nvm_chan[ch_idx],
 					 ch_flags,
 					 (ch_idx >= NUM_2GHZ_CHANNELS) ?
 					 "5.2" : "2.4");
@@ -195,7 +228,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		channel = &data->channels[n_channels];
 		n_channels++;
 
-		channel->hw_value = iwl_nvm_channels[ch_idx];
+		channel->hw_value = nvm_chan[ch_idx];
 		channel->band = (ch_idx < NUM_2GHZ_CHANNELS) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 		channel->center_freq =
@@ -206,11 +239,11 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		channel->flags = IEEE80211_CHAN_NO_HT40;
 		if (ch_idx < NUM_2GHZ_CHANNELS &&
 		    (ch_flags & NVM_CHANNEL_40MHZ)) {
-			if (iwl_nvm_channels[ch_idx] <= LAST_2GHZ_HT_PLUS)
+			if (nvm_chan[ch_idx] <= LAST_2GHZ_HT_PLUS)
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
-			if (iwl_nvm_channels[ch_idx] >= FIRST_2GHZ_HT_MINUS)
+			if (nvm_chan[ch_idx] >= FIRST_2GHZ_HT_MINUS)
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
-		} else if (iwl_nvm_channels[ch_idx] <= LAST_5GHZ_HT &&
+		} else if (nvm_chan[ch_idx] <= LAST_5GHZ_HT &&
 			   (ch_flags & NVM_CHANNEL_40MHZ)) {
 			if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
@@ -302,14 +335,23 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 }
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
-			    struct iwl_nvm_data *data, const __le16 *nvm_sw,
-			    bool enable_vht, u8 tx_chains, u8 rx_chains)
+			    struct iwl_nvm_data *data,
+			    const __le16 *ch_section, bool enable_vht,
+			    u8 tx_chains, u8 rx_chains)
 {
-	int n_channels = iwl_init_channel_map(dev, cfg, data,
-			&nvm_sw[NVM_CHANNELS]);
+	int n_channels;
 	int n_used = 0;
 	struct ieee80211_supported_band *sband;
 
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		n_channels = iwl_init_channel_map(
+				dev, cfg, data,
+				&ch_section[NVM_CHANNELS]);
+	else
+		n_channels = iwl_init_channel_map(
+				dev, cfg, data,
+				&ch_section[NVM_CHANNELS_FAMILY_8000]);
+
 	sband = &data->bands[IEEE80211_BAND_2GHZ];
 	sband->band = IEEE80211_BAND_2GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
@@ -335,35 +377,122 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 			    n_used, n_channels);
 }
 
+static int iwl_get_sku(const struct iwl_cfg *cfg,
+		       const __le16 *nvm_sw)
+{
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		return le16_to_cpup(nvm_sw + SKU);
+	else
+		return le32_to_cpup((__le32 *)(nvm_sw + SKU_FAMILY_8000));
+}
+
+static int iwl_get_nvm_version(const struct iwl_cfg *cfg,
+			       const __le16 *nvm_sw)
+{
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		return le16_to_cpup(nvm_sw + NVM_VERSION);
+	else
+		return le32_to_cpup((__le32 *)(nvm_sw +
+					       NVM_VERSION_FAMILY_8000));
+}
+
+static int iwl_get_radio_cfg(const struct iwl_cfg *cfg,
+			     const __le16 *nvm_sw)
+{
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		return le16_to_cpup(nvm_sw + RADIO_CFG);
+	else
+		return le32_to_cpup((__le32 *)(nvm_sw + RADIO_CFG_FAMILY_8000));
+}
+
+#define N_HW_ADDRS_MASK_FAMILY_8000	0xF
+static int iwl_get_n_hw_addrs(const struct iwl_cfg *cfg,
+			      const __le16 *nvm_sw)
+{
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		return le16_to_cpup(nvm_sw + N_HW_ADDRS);
+	else
+		return le32_to_cpup((__le32 *)(nvm_sw + N_HW_ADDRS_FAMILY_8000))
+		       & N_HW_ADDRS_MASK_FAMILY_8000;
+}
+
+static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
+			      struct iwl_nvm_data *data,
+			      u32 radio_cfg)
+{
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		data->radio_cfg_type = NVM_RF_CFG_TYPE_MSK(radio_cfg);
+		data->radio_cfg_step = NVM_RF_CFG_STEP_MSK(radio_cfg);
+		data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK(radio_cfg);
+		data->radio_cfg_pnum = NVM_RF_CFG_PNUM_MSK(radio_cfg);
+		data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK(radio_cfg);
+		return;
+	}
+
+	/* set the radio configuration for family 8000 */
+	data->radio_cfg_type = NVM_RF_CFG_TYPE_MSK_FAMILY_8000(radio_cfg);
+	data->radio_cfg_step = NVM_RF_CFG_STEP_MSK_FAMILY_8000(radio_cfg);
+	data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK_FAMILY_8000(radio_cfg);
+	data->radio_cfg_pnum = NVM_RF_CFG_FLAVOR_MSK_FAMILY_8000(radio_cfg);
+	data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK_FAMILY_8000(radio_cfg);
+	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK_FAMILY_8000(radio_cfg);
+}
+
+static void iwl_set_hw_address(const struct iwl_cfg *cfg,
+			       struct iwl_nvm_data *data,
+			       const __le16 *nvm_sec)
+{
+	u8 hw_addr[ETH_ALEN];
+
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		memcpy(hw_addr, nvm_sec + HW_ADDR, ETH_ALEN);
+	else
+		memcpy(hw_addr, nvm_sec + MAC_ADDRESS_OVERRIDE_FAMILY_8000,
+		       ETH_ALEN);
+
+	/* The byte order is little endian 16 bit, meaning 214365 */
+	data->hw_addr[0] = hw_addr[1];
+	data->hw_addr[1] = hw_addr[0];
+	data->hw_addr[2] = hw_addr[3];
+	data->hw_addr[3] = hw_addr[2];
+	data->hw_addr[4] = hw_addr[5];
+	data->hw_addr[5] = hw_addr[4];
+}
+
 struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
-		   const __le16 *nvm_calib, u8 tx_chains, u8 rx_chains)
+		   const __le16 *nvm_calib, const __le16 *regulatory,
+		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains)
 {
 	struct iwl_nvm_data *data;
-	u8 hw_addr[ETH_ALEN];
-	u16 radio_cfg, sku;
-
-	data = kzalloc(sizeof(*data) +
-		       sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
-		       GFP_KERNEL);
+	u32 sku;
+	u32 radio_cfg;
+
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
+		data = kzalloc(sizeof(*data) +
+			       sizeof(struct ieee80211_channel) *
+			       IWL_NUM_CHANNELS,
+			       GFP_KERNEL);
+	else
+		data = kzalloc(sizeof(*data) +
+			       sizeof(struct ieee80211_channel) *
+			       IWL_NUM_CHANNELS_FAMILY_8000,
+			       GFP_KERNEL);
 	if (!data)
 		return NULL;
 
-	data->nvm_version = le16_to_cpup(nvm_sw + NVM_VERSION);
+	data->nvm_version = iwl_get_nvm_version(cfg, nvm_sw);
 
-	radio_cfg = le16_to_cpup(nvm_sw + RADIO_CFG);
-	data->radio_cfg_type = NVM_RF_CFG_TYPE_MSK(radio_cfg);
-	data->radio_cfg_step = NVM_RF_CFG_STEP_MSK(radio_cfg);
-	data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK(radio_cfg);
-	data->radio_cfg_pnum = NVM_RF_CFG_PNUM_MSK(radio_cfg);
-	data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK(radio_cfg);
-	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK(radio_cfg);
+	radio_cfg = iwl_get_radio_cfg(cfg, nvm_sw);
+	iwl_set_radio_cfg(cfg, data, radio_cfg);
 
-	sku = le16_to_cpup(nvm_sw + SKU);
+	sku = iwl_get_sku(cfg, nvm_sw);
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
+	data->sku_cap_11ac_enable = sku & NVM_SKU_CAP_11AC_ENABLE;
 	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		data->sku_cap_11n_enable = false;
 
@@ -380,22 +509,34 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		return NULL;
 	}
 
-	data->n_hw_addrs = le16_to_cpup(nvm_sw + N_HW_ADDRS);
+	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
-	data->xtal_calib[0] = *(nvm_calib + XTAL_CALIB);
-	data->xtal_calib[1] = *(nvm_calib + XTAL_CALIB + 1);
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		/* Checking for required sections */
+		if (!nvm_calib) {
+			IWL_ERR_DEV(dev,
+				    "Can't parse empty Calib NVM sections\n");
+			return NULL;
+		}
+		/* in family 8000 Xtal calibration values moved to OTP */
+		data->xtal_calib[0] = *(nvm_calib + XTAL_CALIB);
+		data->xtal_calib[1] = *(nvm_calib + XTAL_CALIB + 1);
+	}
 
-	/* The byte order is little endian 16 bit, meaning 214365 */
-	memcpy(hw_addr, nvm_hw + HW_ADDR, ETH_ALEN);
-	data->hw_addr[0] = hw_addr[1];
-	data->hw_addr[1] = hw_addr[0];
-	data->hw_addr[2] = hw_addr[3];
-	data->hw_addr[3] = hw_addr[2];
-	data->hw_addr[4] = hw_addr[5];
-	data->hw_addr[5] = hw_addr[4];
+	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		iwl_set_hw_address(cfg, data, nvm_hw);
+
+		iwl_init_sbands(dev, cfg, data, nvm_sw,
+				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
+				rx_chains);
+	} else {
+		/* MAC address in family 8000 */
+		iwl_set_hw_address(cfg, data, mac_override);
 
-	iwl_init_sbands(dev, cfg, data, nvm_sw, sku & NVM_SKU_CAP_11AC_ENABLE,
-			tx_chains, rx_chains);
+		iwl_init_sbands(dev, cfg, data, regulatory,
+				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
+				rx_chains);
+	}
 
 	data->calib_version = 255;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index 0c4399a..c9c45a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -75,6 +75,7 @@
 struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
-		   const __le16 *nvm_calib, u8 tx_chains, u8 rx_chains);
+		   const __le16 *nvm_calib, const __le16 *regulatory,
+		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains);
 
 #endif /* __iwl_nvm_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index a7c88f1..4d808a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -306,7 +306,6 @@ struct iwl_phy_cfg_cmd {
 #define PHY_CFG_RX_CHAIN_B	BIT(13)
 #define PHY_CFG_RX_CHAIN_C	BIT(14)
 
-#define NVM_MAX_NUM_SECTIONS	11
 
 /* Target of the NVM_ACCESS_CMD */
 enum {
@@ -318,8 +317,11 @@ enum {
 /* Section types for NVM_ACCESS_CMD */
 enum {
 	NVM_SECTION_TYPE_SW = 1,
+	NVM_SECTION_TYPE_REGULATORY = 3,
 	NVM_SECTION_TYPE_CALIBRATION = 4,
 	NVM_SECTION_TYPE_PRODUCTION = 5,
+	NVM_SECTION_TYPE_MAC_OVERRIDE = 11,
+	NVM_MAX_NUM_SECTIONS = 12,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 2d5251b..e80e81a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -228,13 +228,23 @@ static struct iwl_nvm_data *
 iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 {
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
-	const __le16 *hw, *sw, *calib;
+	const __le16 *hw, *sw, *calib, *regulatory, *mac_override;
 
 	/* Checking for required sections */
-	if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
-	    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
-		IWL_ERR(mvm, "Can't parse empty NVM sections\n");
-		return NULL;
+	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
+		    !mvm->nvm_sections[mvm->cfg->nvm_hw_section_num].data) {
+			IWL_ERR(mvm, "Can't parse empty NVM sections\n");
+			return NULL;
+		}
+	} else {
+		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
+		    !mvm->nvm_sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data ||
+		    !mvm->nvm_sections[NVM_SECTION_TYPE_REGULATORY].data) {
+			IWL_ERR(mvm,
+				"Can't parse empty family 8000 NVM sections\n");
+			return NULL;
+		}
 	}
 
 	if (WARN_ON(!mvm->cfg))
@@ -243,7 +253,12 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	hw = (const __le16 *)sections[mvm->cfg->nvm_hw_section_num].data;
 	sw = (const __le16 *)sections[NVM_SECTION_TYPE_SW].data;
 	calib = (const __le16 *)sections[NVM_SECTION_TYPE_CALIBRATION].data;
+	regulatory = (const __le16 *)sections[NVM_SECTION_TYPE_REGULATORY].data;
+	mac_override =
+		(const __le16 *)sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data;
+
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
+				  regulatory, mac_override,
 				  iwl_fw_valid_tx_ant(mvm->fw),
 				  iwl_fw_valid_rx_ant(mvm->fw));
 }
@@ -285,6 +300,8 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 
 #define NVM_WORD1_LEN(x) (8 * (x & 0x03FF))
 #define NVM_WORD2_ID(x) (x >> 12)
+#define NVM_WORD2_LEN_FAMILY_8000(x) (2 * ((x & 0xFF) << 8 | x >> 8))
+#define NVM_WORD1_ID_FAMILY_8000(x) (x >> 4)
 
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from external NVM\n");
 
@@ -335,8 +352,16 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 			break;
 		}
 
-		section_size = 2 * NVM_WORD1_LEN(le16_to_cpu(file_sec->word1));
-		section_id = NVM_WORD2_ID(le16_to_cpu(file_sec->word2));
+		if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+			section_size =
+				2 * NVM_WORD1_LEN(le16_to_cpu(file_sec->word1));
+			section_id = NVM_WORD2_ID(le16_to_cpu(file_sec->word2));
+		} else {
+			section_size = 2 * NVM_WORD2_LEN_FAMILY_8000(
+						le16_to_cpu(file_sec->word2));
+			section_id = NVM_WORD1_ID_FAMILY_8000(
+						le16_to_cpu(file_sec->word1));
+		}
 
 		if (section_size > IWL_MAX_NVM_SECTION_SIZE) {
 			IWL_ERR(mvm, "ERROR - section too large (%d)\n",
@@ -406,6 +431,8 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 {
 	int ret, i, section;
 	u8 *nvm_buffer, *temp;
+	int nvm_to_read[NVM_MAX_NUM_SECTIONS];
+	int num_of_sections_to_read;
 
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
 		return -EINVAL;
@@ -418,12 +445,20 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 			return ret;
 	} else {
 		/* list of NVM sections we are allowed/need to read */
-		int nvm_to_read[] = {
-			mvm->cfg->nvm_hw_section_num,
-			NVM_SECTION_TYPE_SW,
-			NVM_SECTION_TYPE_CALIBRATION,
-			NVM_SECTION_TYPE_PRODUCTION,
-		};
+		if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+			nvm_to_read[0] = mvm->cfg->nvm_hw_section_num;
+			nvm_to_read[1] = NVM_SECTION_TYPE_SW;
+			nvm_to_read[2] = NVM_SECTION_TYPE_CALIBRATION;
+			nvm_to_read[3] = NVM_SECTION_TYPE_PRODUCTION;
+			num_of_sections_to_read = 4;
+		} else {
+			nvm_to_read[0] = NVM_SECTION_TYPE_SW;
+			nvm_to_read[1] = NVM_SECTION_TYPE_CALIBRATION;
+			nvm_to_read[2] = NVM_SECTION_TYPE_PRODUCTION;
+			nvm_to_read[3] = NVM_SECTION_TYPE_REGULATORY;
+			nvm_to_read[4] = NVM_SECTION_TYPE_MAC_OVERRIDE;
+			num_of_sections_to_read = 5;
+		}
 
 		/* Read From FW NVM */
 		IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
@@ -433,7 +468,7 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 				     GFP_KERNEL);
 		if (!nvm_buffer)
 			return -ENOMEM;
-		for (i = 0; i < ARRAY_SIZE(nvm_to_read); i++) {
+		for (i = 0; i < num_of_sections_to_read; i++) {
 			section = nvm_to_read[i];
 			/* we override the constness for initial read */
 			ret = iwl_nvm_read_section(mvm, section, nvm_buffer);
-- 
1.7.9.5

