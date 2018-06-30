Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52074 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751063AbeF3NXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:16 +0300
Message-Id: <20180630132330.14928-2-luca@coelho.fi> (sfid-20180630_152355_575192_B5BE5487)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 01/15] iwlwifi: 22000 devices: restrict to HT A-MPDU size
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Our current HE devices don't support BlockAck with the large bitmap,
so can't do TX aggregation with 256 frames. Restrict to the lower HT
size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index d4ba66aecdc9..6eb0894bd910 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -179,6 +179,12 @@ const struct iwl_cfg iwl22000_2ax_cfg_hr = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_f0 = {
@@ -190,6 +196,12 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_f0 = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0 = {
@@ -201,6 +213,12 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0 = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
@@ -212,6 +230,12 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-- 
2.18.0
