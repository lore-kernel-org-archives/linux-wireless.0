Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42434 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751588AbdJ2M3P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:29:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:09 +0200
Message-Id: <20171029122816.8802-11-luca@coelho.fi> (sfid-20171029_132920_640846_C5E9E82C)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 10/17] iwlwifi: mvm: refactor iwl_mvm_flush_no_vif
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This function is very indented and hard to read.
Refactor it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 40 +++++++++++------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 26caea62df9b..941dbdebe143 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4002,6 +4002,8 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 
 static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 {
+	int i;
+
 	if (drop) {
 		if (iwl_mvm_has_new_tx_api(mvm))
 			/* TODO new tx api */
@@ -4009,32 +4011,28 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 				  "Need to implement flush TX queue\n");
 		else
 			iwl_mvm_flush_tx_path(mvm,
-				iwl_mvm_flushable_queues(mvm) & queues,
-				0);
-	} else {
-		if (iwl_mvm_has_new_tx_api(mvm)) {
-			struct ieee80211_sta *sta;
-			int i;
+				iwl_mvm_flushable_queues(mvm) & queues, 0);
+		return;
+	}
 
-			mutex_lock(&mvm->mutex);
+	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		iwl_trans_wait_tx_queues_empty(mvm->trans, queues);
+		return;
+	}
 
-			for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
-				sta = rcu_dereference_protected(
-						mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-				if (IS_ERR_OR_NULL(sta))
-					continue;
+	mutex_lock(&mvm->mutex);
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
+		struct ieee80211_sta *sta;
 
-				iwl_mvm_wait_sta_queues_empty(mvm,
-						iwl_mvm_sta_from_mac80211(sta));
-			}
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(sta))
+			continue;
 
-			mutex_unlock(&mvm->mutex);
-		} else {
-			iwl_trans_wait_tx_queues_empty(mvm->trans,
-						       queues);
-		}
+		iwl_mvm_wait_sta_queues_empty(mvm,
+					      iwl_mvm_sta_from_mac80211(sta));
 	}
+	mutex_unlock(&mvm->mutex);
 }
 
 static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
-- 
2.14.2
