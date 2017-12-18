Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51050 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933852AbdLRMin (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 07:38:43 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 14:38:15 +0200
Message-Id: <20171218123815.3968-12-luca@coelho.fi> (sfid-20171218_133847_344561_37A45AC3)
In-Reply-To: <20171218123815.3968-1-luca@coelho.fi>
References: <20171218123815.3968-1-luca@coelho.fi>
Subject: [PATCH 11/11] iwlwifi: define and use if iwl_mvm_has_tlc_offload
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This aligns the code with the existing pattern to check
if the firmware has a certain capability.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 3 +--
 7 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 037dc4a0f133..a7892c1254a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1914,7 +1914,7 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+	if (iwl_mvm_has_tlc_offload(mvm))
 		MVM_DEBUGFS_ADD_STA_FILE(rs_data, dir, S_IRUSR);
 
 	return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 357380a791c3..8aed40a8bc38 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -421,7 +421,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)) {
+	if (iwl_mvm_has_tlc_offload(mvm)) {
 		ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
 		ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	}
@@ -460,7 +460,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	/* this is the case for CCK frames, it's better (only 8) for OFDM */
 	hw->radiotap_timestamp.accuracy = 22;
 
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+	if (!iwl_mvm_has_tlc_offload(mvm))
 		hw->rate_control_algorithm = RS_NAME;
 
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index fea56d211e97..3962a47a8444 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1275,6 +1275,12 @@ static inline bool iwl_mvm_has_quota_low_latency(struct iwl_mvm *mvm)
 			  IWL_UCODE_TLV_API_QUOTA_LOW_LATENCY);
 }
 
+static inline bool iwl_mvm_has_tlc_offload(const struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_TLC_OFFLOAD);
+}
+
 static inline struct agg_tx_status *
 iwl_mvm_get_agg_status(struct iwl_mvm *mvm, void *tx_resp)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 56b3cf1834e5..60abb0084ee5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4052,7 +4052,7 @@ static const struct rate_control_ops rs_mvm_ops_drv = {
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum nl80211_band band, bool init)
 {
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+	if (iwl_mvm_has_tlc_offload(mvm))
 		rs_fw_rate_init(mvm, sta, band);
 	else
 		rs_drv_rate_init(mvm, sta, band, init);
@@ -4096,7 +4096,7 @@ static int rs_drv_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			  bool enable)
 {
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+	if (iwl_mvm_has_tlc_offload(mvm))
 		return rs_fw_tx_protection(mvm, mvmsta, enable);
 	else
 		return rs_drv_tx_protection(mvm, mvmsta, enable);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 6ed9a8eae107..44d26197a25a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1443,7 +1443,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	 * if rs is registered with mac80211, then "add station" will be handled
 	 * via the corresponding ops, otherwise need to notify rate scaling here
 	 */
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+	if (iwl_mvm_has_tlc_offload(mvm))
 		iwl_mvm_rs_add_sta(mvm, mvm_sta);
 
 update_fw:
@@ -2559,8 +2559,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 * When FW supports TLC_OFFLOAD, it also implements Tx aggregation
 	 * manager, so this function should never be called in this case.
 	 */
-	if (WARN_ON_ONCE(fw_has_capa(&mvm->fw->ucode_capa,
-				     IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)))
+	if (WARN_ON_ONCE(iwl_mvm_has_tlc_offload(mvm)))
 		return -EINVAL;
 
 	BUILD_BUG_ON((sizeof(mvmsta->agg_tids) * BITS_PER_BYTE)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index b926fd49e734..13f7cfd6e2b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1717,8 +1717,7 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 		ba_info->band = chanctx_conf->def.chan->band;
 		iwl_mvm_hwrate_to_tx_status(rate, ba_info);
 
-		if (!fw_has_capa(&mvm->fw->ucode_capa,
-				 IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)) {
+		if (!iwl_mvm_has_tlc_offload(mvm)) {
 			IWL_DEBUG_TX_REPLY(mvm,
 					   "No reclaim. Update rs directly\n");
 			iwl_mvm_rs_tx_status(mvm, sta, tid, ba_info, false);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index e94fcf16c513..62a7f0c29d40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -912,8 +912,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 	};
 
 	if (WARN_ON(lq->sta_id == IWL_MVM_INVALID_STA ||
-		    fw_has_capa(&mvm->fw->ucode_capa,
-				IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)))
+		    iwl_mvm_has_tlc_offload(mvm)))
 		return -EINVAL;
 
 	return iwl_mvm_send_cmd(mvm, &cmd);
-- 
2.15.1
