Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58375 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaCROpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:51 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so5497277eek.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:50 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/35] iwlwifi: nvm: fix VHT capability antenna-dependent fields
Date: Tue, 18 Mar 2014 16:45:09 +0200
Message-Id: <1395153939-23897-5-git-send-email-egrumbach@gmail.com> (sfid-20140318_154555_306168_0A983BA6)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the antenna dependent fields depend on the firmware file and not
the NVM, use those fields in the VHT capability creation.

Additionally, fix the STBC and antenna pattern consistency fields.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 2f962ec..6be30c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -299,9 +299,11 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 				  struct iwl_nvm_data *data,
-				  struct ieee80211_sta_vht_cap *vht_cap)
+				  struct ieee80211_sta_vht_cap *vht_cap,
+				  u8 tx_chains, u8 rx_chains)
 {
-	int num_ants = num_of_ant(data->valid_rx_ant);
+	int num_rx_ants = num_of_ant(rx_chains);
+	int num_tx_ants = num_of_ant(tx_chains);
 
 	vht_cap->vht_supported = true;
 
@@ -311,8 +313,10 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       3 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
 		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
-	if (num_ants > 1)
+	if (num_tx_ants > 1)
 		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
+	else
+		vht_cap->cap |= IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 
 	if (iwlwifi_mod_params.amsdu_size_8K)
 		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
@@ -327,10 +331,8 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 14);
 
-	if (num_ants == 1 ||
-	    cfg->rx_with_siso_diversity) {
-		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
-				IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
+	if (num_rx_ants == 1 || cfg->rx_with_siso_diversity) {
+		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN;
 		/* this works because NOT_SUPPORTED == 3 */
 		vht_cap->vht_mcs.rx_mcs_map |=
 			cpu_to_le16(IEEE80211_VHT_MCS_NOT_SUPPORTED << 2);
@@ -375,7 +377,8 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ,
 			     tx_chains, rx_chains);
 	if (enable_vht)
-		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap);
+		iwl_init_vht_hw_capab(cfg, data, &sband->vht_cap,
+				      tx_chains, rx_chains);
 
 	if (n_channels != n_used)
 		IWL_ERR_DEV(dev, "NVM: used only %d of %d channels\n",
-- 
1.8.3.2

