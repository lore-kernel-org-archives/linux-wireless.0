Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161450Ab2COU2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/26] iwlwifi: use scan while idle
Date: Thu, 15 Mar 2012 13:26:51 -0700
Message-Id: <1331843226-29860-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212818_848527_143887C1)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As idle is just a deep powersave mode for
the device, it will easily scan while idle
since that turns off powersave.

This reduces the number of commands sent
to the device when scanning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b6805f8..d2be4b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -157,7 +157,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	 */
 
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		     IEEE80211_HW_SCAN_WHILE_IDLE;
 
 	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 863ad0c..4338d49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -806,8 +806,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
-	/* In power save mode use one chain, otherwise use all chains */
-	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
+	/*
+	 * In power save mode while associated use one chain,
+	 * otherwise use all chains
+	 */
+	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status) &&
+	    !(priv->hw->conf.flags & IEEE80211_CONF_IDLE)) {
 		/* rx_ant has been set to all valid chains previously */
 		active_chains = rx_ant &
 				((u8)(priv->chain_noise_data.active_chains));
-- 
1.7.0.4

