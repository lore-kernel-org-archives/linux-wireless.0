Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382Ab0LNARK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/14] iwlwifi: use IWL_DEBUG_EEPROM for EEPROM related info
Date: Mon, 13 Dec 2010 16:09:28 -0800
Message-Id: <1292285372-11373-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For logging EEPROM related info, instead of using IWL_DEBUG_INFO,
use the dedicated logging (IWL_DEBUG_EEPROM) for easier debugging

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |   25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 3ea006d..77d92b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -203,7 +203,7 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
-	IWL_DEBUG_INFO(priv, "%d - "
+	IWL_DEBUG_EEPROM(priv, "%d - "
 			"chain_a: %d dB chain_b: %d dB "
 			"chain_c: %d dB mimo2: %d dB mimo3: %d dB\n",
 			element,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 87cd10f..358cfd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -147,7 +147,7 @@ static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
-	IWL_DEBUG_INFO(priv, "EEPROM signature=0x%08x\n", gp);
+	IWL_DEBUG_EEPROM(priv, "EEPROM signature=0x%08x\n", gp);
 	switch (gp) {
 	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
 		if (priv->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
@@ -354,7 +354,7 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		 */
 		valid_addr = next_link_addr;
 		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
-		IWL_DEBUG_INFO(priv, "OTP blocks %d addr 0x%x\n",
+		IWL_DEBUG_EEPROM(priv, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
 		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
 			return -EINVAL;
@@ -374,7 +374,7 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 	} while (usedblocks <= priv->cfg->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
-	IWL_DEBUG_INFO(priv, "OTP has no valid blocks\n");
+	IWL_DEBUG_EEPROM(priv, "OTP has no valid blocks\n");
 	return -EINVAL;
 }
 
@@ -414,7 +414,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		return -ENOENT;
 	/* allocate eeprom */
 	sz = priv->cfg->base_params->eeprom_size;
-	IWL_DEBUG_INFO(priv, "NVM size = %d\n", sz);
+	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
 		ret = -ENOMEM;
@@ -492,7 +492,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		}
 	}
 
-	IWL_DEBUG_INFO(priv, "NVM Type: %s, version: 0x%x\n",
+	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
 		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		       ? "OTP" : "EEPROM",
 		       iwl_eeprom_query16(priv, EEPROM_VERSION));
@@ -594,7 +594,7 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO(priv, "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
+	IWL_DEBUG_EEPROM(priv, "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
 			" Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
@@ -634,11 +634,11 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	struct iwl_channel_info *ch_info;
 
 	if (priv->channel_count) {
-		IWL_DEBUG_INFO(priv, "Channel map already initialized.\n");
+		IWL_DEBUG_EEPROM(priv, "Channel map already initialized.\n");
 		return 0;
 	}
 
-	IWL_DEBUG_INFO(priv, "Initializing regulatory info from EEPROM\n");
+	IWL_DEBUG_EEPROM(priv, "Initializing regulatory info from EEPROM\n");
 
 	priv->channel_count =
 	    ARRAY_SIZE(iwl_eeprom_band_1) +
@@ -647,7 +647,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	    ARRAY_SIZE(iwl_eeprom_band_4) +
 	    ARRAY_SIZE(iwl_eeprom_band_5);
 
-	IWL_DEBUG_INFO(priv, "Parsing data for %d channels.\n", priv->channel_count);
+	IWL_DEBUG_EEPROM(priv, "Parsing data for %d channels.\n",
+			priv->channel_count);
 
 	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
@@ -686,7 +687,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 					IEEE80211_CHAN_NO_HT40;
 
 			if (!(is_channel_valid(ch_info))) {
-				IWL_DEBUG_INFO(priv, "Ch. %d Flags %x [%sGHz] - "
+				IWL_DEBUG_EEPROM(priv,
+					       "Ch. %d Flags %x [%sGHz] - "
 					       "No traffic\n",
 					       ch_info->channel,
 					       ch_info->flags,
@@ -702,7 +704,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO(priv, "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm):"
+			IWL_DEBUG_EEPROM(priv, "Ch. %d [%sGHz] "
+				       "%s%s%s%s%s%s(0x%02x %ddBm):"
 				       " Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
-- 
1.7.0.4

