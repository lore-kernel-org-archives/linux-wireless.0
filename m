Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbcCBH5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:05 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/43] iwlwifi: mvm: enable VHT MU-MIMO for supported hardware
Date: Wed,  2 Mar 2016 09:56:13 +0200
Message-Id: <1456905404-14435-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085723_074309_FDA4D0D2)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Incoming hardware will support VHT MU-MIMO. Declare this
capability for relevant hardware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    | 2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index ad8c588..97be104 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -217,6 +217,7 @@ const struct iwl_cfg iwl8265_2ac_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.vht_mu_mimo_supported = true,
 };
 
 const struct iwl_cfg iwl4165_2ac_cfg = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 0835906..8e32a57 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -139,7 +139,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.smem_len = IWL9000_SMEM_LEN,					\
 	.thermal_params = &iwl9000_tt_params,				\
 	.apmg_not_supported = true,					\
-	.mq_rx_supported = true
+	.mq_rx_supported = true,					\
+	.vht_mu_mimo_supported = true
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
 		.name = "Intel(R) Dual Band Wireless AC 9260",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index dad5570..4f2b57e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -312,6 +312,7 @@ struct iwl_pwr_tx_backoff {
  * @smem_offset: offset from which the SMEM begins
  * @smem_len: the length of SMEM
  * @mq_rx_supported: multi-queue rx support
+ * @vht_mu_mimo_supported: VHT MU-MIMO support
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -364,6 +365,7 @@ struct iwl_cfg {
 	const struct iwl_tt_params *thermal_params;
 	bool apmg_not_supported;
 	bool mq_rx_supported;
+	bool vht_mu_mimo_supported;
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 50f4cc6..e84cb8d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -366,6 +366,9 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		       max_ampdu_exponent <<
 		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
+	if (cfg->vht_mu_mimo_supported)
+		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+
 	if (cfg->ht_params->ldpc)
 		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
 
-- 
2.5.0

