Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbbLUUwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/45] iwlwifi: mvm: refactor the way fw_key_table is handled
Date: Mon, 21 Dec 2015 22:50:31 +0200
Message-Id: <1450731046-2796-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215225_849193_D570BBD2)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Instead of keeping the fw_key_table bits set when the keys are removed
(i.e. in D3 entry or HW_RESTART flows), clear them and set them again
only when the keys have been successfully re-added.  This makes the
bitmask more closely tied to the actual firmware programming.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 10 ++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 8cd2e67..69fd10a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -779,6 +779,9 @@ static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
 	 */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 
+	/* the fw is reset, so all the keys are cleared */
+	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
+
 	mvm->ptk_ivlen = 0;
 	mvm->ptk_icvlen = 0;
 	mvm->ptk_ivlen = 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d239e97..be5703c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -984,6 +984,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 
 	iwl_mvm_reset_phy_ctxts(mvm);
+	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 	memset(mvm->sta_drained, 0, sizeof(mvm->sta_drained));
 	memset(mvm->tfd_drained, 0, sizeof(mvm->tfd_drained));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4148ebe..92edacc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1198,8 +1198,6 @@ static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm)
 	if (max_offs < 0)
 		return STA_KEY_IDX_INVALID;
 
-	__set_bit(max_offs, mvm->fw_key_table);
-
 	return max_offs;
 }
 
@@ -1507,10 +1505,8 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	}
 
 	ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf, key_offset, mcast);
-	if (ret) {
-		__clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
+	if (ret)
 		goto end;
-	}
 
 	/*
 	 * For WEP, the same key is used for multicast and unicast. Upload it
@@ -1523,11 +1519,13 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf,
 					    key_offset, !mcast);
 		if (ret) {
-			__clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
 			__iwl_mvm_remove_sta_key(mvm, sta_id, keyconf, mcast);
+			goto end;
 		}
 	}
 
+	__set_bit(key_offset, mvm->fw_key_table);
+
 end:
 	IWL_DEBUG_WEP(mvm, "key: cipher=%x len=%d idx=%d sta=%pM ret=%d\n",
 		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
-- 
2.5.0

