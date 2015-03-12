Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbbCLNFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Jonathan Doron <jonathanx.doron@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/49] iwlwifi: mvm: set LAR MCC on D3/D0 transitions
Date: Thu, 12 Mar 2015 15:04:04 +0200
Message-Id: <1426165474-25586-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140554_969878_8BF7B408)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jonathan Doron <jonathanx.doron@intel.com>

When moving to the D3 FW give it the valid MCC from the D0 FW. When
returning from D3 to D0, query the D3 FW for the latest MCC, as
it might have changed internally. This MCC will be replayed to the D0 FW
when it boots.

Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  9 ++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 33 ++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  7 ++++--
 drivers/net/wireless/iwlwifi/mvm/nvm.c      |  8 +++----
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  4 ++++
 6 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 9bdfa95..486fd4c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -694,6 +694,9 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		IWL_ERR(mvm, "Failed to send quota: %d\n", ret);
 
+	if (iwl_mvm_is_lar_supported(mvm) && iwl_mvm_init_fw_regd(mvm))
+		IWL_ERR(mvm, "Failed to initialize D3 LAR information\n");
+
 	return 0;
 }
 
@@ -1874,6 +1877,12 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	/* query SRAM first in case we want event logging */
 	iwl_mvm_read_d3_sram(mvm);
 
+	/*
+	 * Query the current location and source from the D3 firmware so we
+	 * can play it back when we re-intiailize the D0 firmware
+	 */
+	iwl_mvm_update_changed_regdom(mvm);
+
 	if (mvm->net_detect) {
 		iwl_mvm_query_netdetect_reasons(mvm, vif);
 		/* has unlocked the mutex, so skip that */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 7e49365..d89b0dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1503,7 +1503,7 @@ struct iwl_mcc_update_cmd {
  * Contains the new channel control profile map, if changed, and the new MCC
  * (mobile country code).
  * The new MCC may be different than what was requested in MCC_UPDATE_CMD.
- * @status: 0 for success, 1 no change in channel profile, 2 invalid input.
+ * @status: see &enum iwl_mcc_update_status
  * @mcc: the new applied MCC
  * @cap: capabilities for all channels which matches the MCC
  * @source_id: the MCC source, see iwl_mcc_source
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 303a7a0..7484724 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -304,7 +304,8 @@ static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 
 struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 						  const char *alpha2,
-						  enum iwl_mcc_source src_id)
+						  enum iwl_mcc_source src_id,
+						  bool *changed)
 {
 	struct ieee80211_regdomain *regd = NULL;
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
@@ -322,6 +323,9 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 		goto out;
 	}
 
+	if (changed)
+		*changed = (resp->status == MCC_RESP_NEW_CHAN_PROFILE);
+
 	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev, mvm->cfg,
 				      __le32_to_cpu(resp->n_channels),
 				      resp->channels,
@@ -344,12 +348,31 @@ out:
 	return regd;
 }
 
-struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm)
+void iwl_mvm_update_changed_regdom(struct iwl_mvm *mvm)
+{
+	bool changed;
+	struct ieee80211_regdomain *regd;
+
+	if (!iwl_mvm_is_lar_supported(mvm))
+		return;
+
+	regd = iwl_mvm_get_current_regdomain(mvm, &changed);
+	if (!IS_ERR_OR_NULL(regd)) {
+		/* only update the regulatory core if changed */
+		if (changed)
+			regulatory_set_wiphy_regd(mvm->hw->wiphy, regd);
+
+		kfree(regd);
+	}
+}
+
+struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm,
+							  bool *changed)
 {
 	return iwl_mvm_get_regdomain(mvm->hw->wiphy, "ZZ",
 				     iwl_mvm_is_wifi_mcc_supported(mvm) ?
 				     MCC_SOURCE_GET_CURRENT :
-				     MCC_SOURCE_OLD_FW);
+				     MCC_SOURCE_OLD_FW, changed);
 }
 
 int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
@@ -366,13 +389,13 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 	used_src = mvm->mcc_src;
 	if (iwl_mvm_is_wifi_mcc_supported(mvm)) {
 		/* Notify the firmware we support wifi location updates */
-		regd = iwl_mvm_get_current_regdomain(mvm);
+		regd = iwl_mvm_get_current_regdomain(mvm, NULL);
 		if (!IS_ERR_OR_NULL(regd))
 			kfree(regd);
 	}
 
 	/* Now set our last stored MCC and source */
-	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, r->alpha2, used_src);
+	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, r->alpha2, used_src, NULL);
 	if (IS_ERR_OR_NULL(regd))
 		return -EIO;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5d5be37..9a8868e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1426,9 +1426,12 @@ int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 			       struct iwl_device_cmd *cmd);
 struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 						  const char *alpha2,
-						  enum iwl_mcc_source src_id);
-struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm);
+						  enum iwl_mcc_source src_id,
+						  bool *changed);
+struct ieee80211_regdomain *iwl_mvm_get_current_regdomain(struct iwl_mvm *mvm,
+							  bool *changed);
 int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm);
+void iwl_mvm_update_changed_regdom(struct iwl_mvm *mvm);
 
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index d08ea69..123e0a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -655,7 +655,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	IWL_DEBUG_LAR(mvm,
 		      "MCC response status: 0x%x. new MCC: 0x%x ('%c%c') change: %d n_chans: %d\n",
 		      status, mcc, mcc >> 8, mcc & 0xff,
-		      !!(status == MCC_RESP_SAME_CHAN_PROFILE), n_channels);
+		      !!(status == MCC_RESP_NEW_CHAN_PROFILE), n_channels);
 
 	resp_len = sizeof(*mcc_resp) + n_channels * sizeof(__le32);
 	resp_cp = kmemdup(mcc_resp, resp_len, GFP_KERNEL);
@@ -802,7 +802,7 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	 */
 	mvm->lar_regdom_set = false;
 
-	regd = iwl_mvm_get_current_regdomain(mvm);
+	regd = iwl_mvm_get_current_regdomain(mvm, NULL);
 	if (IS_ERR_OR_NULL(regd))
 		return -EIO;
 
@@ -810,7 +810,7 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	    !iwl_mvm_get_bios_mcc(mvm, mcc)) {
 		kfree(regd);
 		regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc,
-					     MCC_SOURCE_BIOS);
+					     MCC_SOURCE_BIOS, NULL);
 		if (IS_ERR_OR_NULL(regd))
 			return -EIO;
 	}
@@ -843,7 +843,7 @@ int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 	IWL_DEBUG_LAR(mvm,
 		      "RX: received chub update mcc cmd (mcc '%s' src %d)\n",
 		      mcc, src);
-	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc, src);
+	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc, src, NULL);
 	if (IS_ERR_OR_NULL(regd))
 		return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index c1de23c..7b555f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1272,6 +1272,10 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	iwl_free_resp(&get_status_cmd);
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
+
+	/* the FW might have updated the regdomain */
+	iwl_mvm_update_changed_regdom(mvm);
+
 	iwl_mvm_unref(mvm, IWL_MVM_REF_EXIT_WORK);
 	mutex_unlock(&mvm->mutex);
 }
-- 
1.9.1

