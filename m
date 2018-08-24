Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOEs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:13 +0300
Message-Id: <20180824103018.15011-12-luca@coelho.fi> (sfid-20180824_123105_140152_F71F220D)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: rs-fw: enable STBC in he correctly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

In the HE phy capabilities IE there are 2 bits to signal support for
STBC in bandwidths of 80Mhz or less, and of 160Mhz.
Use these bits to determine STBC support if this IE exists.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rs.h    | 10 +++++++---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 20 +++++++++++++++----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index fe2763cfc3b5..955f2c3718e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -66,12 +66,16 @@
 
 /**
  * enum iwl_tlc_mng_cfg_flags_enum - options for TLC config flags
- * @IWL_TLC_MNG_CFG_FLAGS_STBC_MSK: enable STBC
+ * @IWL_TLC_MNG_CFG_FLAGS_STBC_MSK: enable STBC. For HE this enables STBC for
+ *				    bandwidths <= 80MHz
  * @IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK: enable LDPC
+ * @IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK: enable STBC in HE at 160MHz
+ *					      bandwidth
  */
 enum iwl_tlc_mng_cfg_flags {
-	IWL_TLC_MNG_CFG_FLAGS_STBC_MSK		= BIT(0),
-	IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK		= BIT(1),
+	IWL_TLC_MNG_CFG_FLAGS_STBC_MSK			= BIT(0),
+	IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK			= BIT(1),
+	IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK	= BIT(2),
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 1a7a158890cb..f00ff466ec1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -117,14 +117,26 @@ static u16 rs_fw_set_config_flags(struct iwl_mvm *mvm,
 {
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	struct ieee80211_sta_he_cap *he_cap = &sta->he_cap;
 	bool vht_ena = vht_cap && vht_cap->vht_supported;
 	u16 flags = 0;
 
 	if (mvm->cfg->ht_params->stbc &&
-	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
-	    ((ht_cap && (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)) ||
-	     (vht_ena && (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))))
-		flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1)) {
+		if (he_cap && he_cap->has_he) {
+			if (he_cap->he_cap_elem.phy_cap_info[2] &
+			    IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
+				flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+
+			if (he_cap->he_cap_elem.phy_cap_info[7] &
+			    IEEE80211_HE_PHY_CAP7_STBC_RX_ABOVE_80MHZ)
+				flags |= IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK;
+		} else if ((ht_cap &&
+			    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)) ||
+			   (vht_ena &&
+			    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)))
+			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+	}
 
 	if (mvm->cfg->ht_params->ldpc &&
 	    ((ht_cap && (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING)) ||
-- 
2.18.0
