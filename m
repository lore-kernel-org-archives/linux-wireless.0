Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:51241 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEVHYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:08 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so3056386wes.16
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/11] iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it
Date: Thu, 22 May 2014 10:23:47 +0300
Message-Id: <1400743435-702-3-git-send-email-egrumbach@gmail.com> (sfid-20140522_092726_819837_7542CD4E)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We should not allow diversity when BT Coex needs the second
antenna. Thermal Throttling can also request to stop using
the second antenna. Honour those requests.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c |  3 +--
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 33 +++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5d2effb..4a5db07 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1008,6 +1008,7 @@ int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				enum iwl_mvm_smps_type_request req_type,
 				enum ieee80211_smps_mode smps_request);
+bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm);
 
 /* Low latency */
 int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index acb79af..539f3a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -163,8 +163,7 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	 * between the two antennas is sufficiently different to impact
 	 * performance.
 	 */
-	if (active_cnt == 1 && num_of_ant(mvm->fw->valid_rx_ant) > 1 &&
-	    !mvm->cfg->rx_with_siso_diversity) {
+	if (active_cnt == 1 && iwl_mvm_rx_diversity_allowed(mvm)) {
 		idle_cnt = 2;
 		active_cnt = 2;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index b269f1e..42cea32 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -650,6 +650,39 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ieee80211_request_smps(vif, smps_mode);
 }
 
+static void iwl_mvm_diversity_iter(void *_data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	bool *result = _data;
+	int i;
+
+	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++) {
+		if (mvmvif->smps_requests[i] == IEEE80211_SMPS_STATIC ||
+		    mvmvif->smps_requests[i] == IEEE80211_SMPS_DYNAMIC)
+			*result = false;
+	}
+}
+
+bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
+{
+	bool result = true;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
+		return false;
+
+	if (!mvm->cfg->rx_with_siso_diversity)
+		return false;
+
+	ieee80211_iterate_active_interfaces_atomic(
+			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+			iwl_mvm_diversity_iter, &result);
+
+	return result;
+}
+
 int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       bool value)
 {
-- 
1.8.3.2

