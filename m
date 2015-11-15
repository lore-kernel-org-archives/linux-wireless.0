Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbbKOTeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 14:34:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] iwlwifi: mvm: don't overwrite the key indices in D3 entry
Date: Sun, 15 Nov 2015 21:34:04 +0200
Message-Id: <1447616045-31484-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151115_203418_430640_EA1FB120)
In-Reply-To: <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
 <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When entering D3, we need to use hardcoded key indices because the
firmware requires that.  To do so, we are overwriting the HW key index
in the keyconf structure, which makes it impossible to reuse the
indices that were used before entering D3.  Additionally, we overwrite
all the non-PTK keys with index 1, because the firmware only allows
one non-PTK key to be set.  This is bad, because when we resume, we
may try to set more than one key with index 1, which will obviously
fail.

To fix this, allow the callers to set a pre-defined index to use in
iwl_mvm_set_sta_key() instead of relying on the hw_key_idx value from
the keyconf struct (which requires overwriting it).  In normal cases,
the caller can pass STA_KEY_IDX_INVALID, which will cause a new key
offset to be chosen.  During HW_RESTART, we pass the offset that is in
use.  And during D3 entry, we pass the hardcoded indices we need to
use.

Additionally, don't clear the fw_key_table in D3 entry, so that the
flags are still set with the pre-D3 values when exiting D3.

fixes=I3165c22362483f0152d9ec1d2a987fb5529727c1

Fixes: b546dcd6b742 ("iwlwifi: mvm: don't reset key index on HW restart")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  8 ++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 ++++++--
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 44 ++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  4 +--
 4 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 85ae902..29ae58e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -309,9 +309,9 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 	 * to transmit packets to the AP, i.e. the PTK.
 	 */
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
-		key->hw_key_idx = 0;
 		mvm->ptk_ivlen = key->iv_len;
 		mvm->ptk_icvlen = key->icv_len;
+		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, 0);
 	} else {
 		/*
 		 * firmware only supports TSC/RSC for a single key,
@@ -319,12 +319,11 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 		 * with new ones -- this relies on mac80211 doing
 		 * list_add_tail().
 		 */
-		key->hw_key_idx = 1;
 		mvm->gtk_ivlen = key->iv_len;
 		mvm->gtk_icvlen = key->icv_len;
+		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, 1);
 	}
 
-	ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, true);
 	data->error = ret != 0;
 out_unlock:
 	mutex_unlock(&mvm->mutex);
@@ -772,9 +771,6 @@ static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
 	 */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 
-	/* We reprogram keys and shouldn't allocate new key indices */
-	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
-
 	mvm->ptk_ivlen = 0;
 	mvm->ptk_icvlen = 0;
 	mvm->ptk_ivlen = 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1fb6846..e88afac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2941,6 +2941,7 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
+	u8 key_offset;
 
 	if (iwlwifi_mod_params.sw_crypto) {
 		IWL_DEBUG_MAC80211(mvm, "leave - hwcrypto disabled\n");
@@ -3006,10 +3007,14 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			break;
 		}
 
+		/* in HW restart reuse the index, otherwise request a new one */
+		if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+			key_offset = key->hw_key_idx;
+		else
+			key_offset = STA_KEY_IDX_INVALID;
+
 		IWL_DEBUG_MAC80211(mvm, "set hwcrypto key\n");
-		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key,
-					  test_bit(IWL_MVM_STATUS_IN_HW_RESTART,
-						   &mvm->status));
+		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, key_offset);
 		if (ret) {
 			IWL_WARN(mvm, "set key failed\n");
 			/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 300a249..4e26008 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1227,7 +1227,8 @@ static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
 static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 				struct iwl_mvm_sta *mvm_sta,
 				struct ieee80211_key_conf *keyconf, bool mcast,
-				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags)
+				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
+				u8 key_offset)
 {
 	struct iwl_mvm_add_sta_key_cmd cmd = {};
 	__le16 key_flags;
@@ -1269,7 +1270,7 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 	if (mcast)
 		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
 
-	cmd.key_offset = keyconf->hw_key_idx;
+	cmd.key_offset = key_offset;
 	cmd.key_flags = key_flags;
 	cmd.sta_id = sta_id;
 
@@ -1360,6 +1361,7 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
 				 struct ieee80211_key_conf *keyconf,
+				 u8 key_offset,
 				 bool mcast)
 {
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
@@ -1375,17 +1377,17 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
-					   seq.tkip.iv32, p1k, 0);
+					   seq.tkip.iv32, p1k, 0, key_offset);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
-					   0, NULL, 0);
+					   0, NULL, 0, key_offset);
 		break;
 	default:
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
-					   0, NULL, 0);
+					   0, NULL, 0, key_offset);
 	}
 
 	return ret;
@@ -1433,7 +1435,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta,
 			struct ieee80211_key_conf *keyconf,
-			bool have_key_offset)
+			u8 key_offset)
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 	u8 sta_id;
@@ -1470,18 +1472,25 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
 		return -EINVAL;
 
-	if (!have_key_offset) {
-		/*
-		 * The D3 firmware hardcodes the PTK offset to 0, so we have to
-		 * configure it there. As a result, this workaround exists to
-		 * let the caller set the key offset (hw_key_idx), see d3.c.
-		 */
-		keyconf->hw_key_idx = iwl_mvm_set_fw_key_idx(mvm);
-		if (keyconf->hw_key_idx == STA_KEY_IDX_INVALID)
+	/* If the key_offset is not pre-assigned, we need to find a
+	 * new offset to use.  In normal cases, the offset is not
+	 * pre-assigned, but during HW_RESTART we want to reuse the
+	 * same indices, so we pass them when this function is called.
+	 *
+	 * In D3 entry, we need to hardcoded the indices (because the
+	 * firmware hardcodes the PTK offset to 0).  In this case, we
+	 * need to make sure we don't overwrite the hw_key_idx in the
+	 * keyconf structure, because otherwise we cannot configure
+	 * the original ones back when resuming.
+	 */
+	if (key_offset == STA_KEY_IDX_INVALID) {
+		key_offset  = iwl_mvm_set_fw_key_idx(mvm);
+		if (key_offset == STA_KEY_IDX_INVALID)
 			return -ENOSPC;
+		keyconf->hw_key_idx = key_offset;
 	}
 
-	ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf, mcast);
+	ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf, key_offset, mcast);
 	if (ret) {
 		__clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
 		goto end;
@@ -1495,7 +1504,8 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	 */
 	if (keyconf->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	    keyconf->cipher == WLAN_CIPHER_SUITE_WEP104) {
-		ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf, !mcast);
+		ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf,
+					    key_offset, !mcast);
 		if (ret) {
 			__clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
 			__iwl_mvm_remove_sta_key(mvm, sta_id, keyconf, mcast);
@@ -1602,7 +1612,7 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
-			     iv32, phase1key, CMD_ASYNC);
+			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx);
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index eedb215..0631cc0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -365,8 +365,8 @@ int iwl_mvm_rm_sta_id(struct iwl_mvm *mvm,
 int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta,
-			struct ieee80211_key_conf *key,
-			bool have_key_offset);
+			struct ieee80211_key_conf *keyconf,
+			u8 key_offset);
 int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
-- 
2.5.0

