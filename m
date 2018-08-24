Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOEv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:14 +0300
Message-Id: <20180824103018.15011-13-luca@coelho.fi> (sfid-20180824_123105_737296_2288CDF7)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 12/16] iwlwifi: rs-fw: support dcm
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

Add flags to the tlc_cfg_cmd for signaling peer support for receiving
Dual Carrier Modulation at BPSK (MCS 0), and set them according to peer
capabilities.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h |  8 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index 955f2c3718e5..9eddc4dc2ae6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -71,11 +71,19 @@
  * @IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK: enable LDPC
  * @IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK: enable STBC in HE at 160MHz
  *					      bandwidth
+ * @IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK: enable HE Dual Carrier Modulation
+ *					    for BPSK (MCS 0) with 1 spatial
+ *					    stream
+ * @IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_2_MSK: enable HE Dual Carrier Modulation
+ *					    for BPSK (MCS 0) with 2 spatial
+ *					    streams
  */
 enum iwl_tlc_mng_cfg_flags {
 	IWL_TLC_MNG_CFG_FLAGS_STBC_MSK			= BIT(0),
 	IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK			= BIT(1),
 	IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK	= BIT(2),
+	IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK		= BIT(3),
+	IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_2_MSK		= BIT(4),
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index f00ff466ec1b..7a98e1a1dc40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -143,6 +143,16 @@ static u16 rs_fw_set_config_flags(struct iwl_mvm *mvm,
 	     (vht_ena && (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))))
 		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
 
+	if (he_cap && he_cap->has_he &&
+	    (he_cap->he_cap_elem.phy_cap_info[3] &
+	     IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_MASK)) {
+		flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK;
+
+		if (he_cap->he_cap_elem.phy_cap_info[3] &
+		    IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_2)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_2_MSK;
+	}
+
 	return flags;
 }
 
-- 
2.18.0
