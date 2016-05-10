Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40822 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbcEJUak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:15 +0300
Message-Id: <1462910797-20303-19-git-send-email-luca@coelho.fi> (sfid-20160510_223043_986335_257B171D)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 19/41] iwlwifi: consider VHT 160MHz while parsing NVM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Devices belonging to 9000 family can support VHT 160MHz channel
width, so need to consider it when configuring VHT capabilities.
However, NVM file doesn't have a single bit specifying that 160MHz
is supported. This patch turns on 160MHz support in VHT capabilities
in case there's at least one channel supporting 160MHz.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index 53f39a3..1f4e502 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -98,6 +98,7 @@ struct iwl_nvm_data {
 	s8 max_tx_pwr_half_dbm;
 
 	bool lar_enabled;
+	bool vht160_supported;
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels[];
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 14743c3..b13f409 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -288,6 +288,9 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		    !data->sku_cap_band_52GHz_enable)
 			continue;
 
+		if (ch_flags & NVM_CHANNEL_160MHZ)
+			data->vht160_supported = true;
+
 		if (!lar_supported && !(ch_flags & NVM_CHANNEL_VALID)) {
 			/*
 			 * Channels might become valid later if lar is
@@ -331,17 +334,20 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			channel->flags = 0;
 
 		IWL_DEBUG_EEPROM(dev,
-				 "Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
+				 "Ch. %d [%sGHz] flags 0x%x %s%s%s%s%s%s%s%s%s%s(%ddBm): Ad-Hoc %ssupported\n",
 				 channel->hw_value,
 				 is_5ghz ? "5.2" : "2.4",
+				 ch_flags,
 				 CHECK_AND_PRINT_I(VALID),
 				 CHECK_AND_PRINT_I(IBSS),
 				 CHECK_AND_PRINT_I(ACTIVE),
 				 CHECK_AND_PRINT_I(RADAR),
-				 CHECK_AND_PRINT_I(WIDE),
 				 CHECK_AND_PRINT_I(INDOOR_ONLY),
 				 CHECK_AND_PRINT_I(GO_CONCURRENT),
-				 ch_flags,
+				 CHECK_AND_PRINT_I(WIDE),
+				 CHECK_AND_PRINT_I(40MHZ),
+				 CHECK_AND_PRINT_I(80MHZ),
+				 CHECK_AND_PRINT_I(160MHZ),
 				 channel->max_power,
 				 ((ch_flags & NVM_CHANNEL_IBSS) &&
 				  !(ch_flags & NVM_CHANNEL_RADAR))
@@ -370,6 +376,10 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       max_ampdu_exponent <<
 		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
+	if (data->vht160_supported)
+		vht_cap->cap |=
+			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+
 	if (cfg->vht_mu_mimo_supported)
 		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
 
-- 
2.8.1

