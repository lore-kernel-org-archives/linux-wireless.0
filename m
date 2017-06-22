Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34238 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753740AbdFVVVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:40 +0300
Message-Id: <20170622212101.16422-5-luca@coelho.fi> (sfid-20170622_232155_207030_445CEA24)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: Enable security on new TX API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Install GTKs on AP side for new TX API.
Don't add IV space, it's added by the HW.

While at that fix GCMP abnd GCMP-256 GTK installation
which work similarly to the new TX API.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  12 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 108 ++++++++++++++--------
 2 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 08f86e77eba5..05041d37773b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2883,7 +2883,8 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		if (!iwl_mvm_has_new_tx_api(mvm))
+			key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
@@ -2929,8 +2930,13 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 				ret = -EOPNOTSUPP;
 			else
 				ret = 0;
-			key->hw_key_idx = STA_KEY_IDX_INVALID;
-			break;
+
+			if (key->cipher != WLAN_CIPHER_SUITE_GCMP &&
+			    key->cipher != WLAN_CIPHER_SUITE_GCMP_256 &&
+			    !iwl_mvm_has_new_tx_api(mvm)) {
+				key->hw_key_idx = STA_KEY_IDX_INVALID;
+				break;
+			}
 		}
 
 		/* During FW restart, in order to restore the state as it was,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c76ffe1476b4..59cd2486a449 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2980,7 +2980,7 @@ static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
 }
 
 static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
-				struct iwl_mvm_sta *mvm_sta,
+				u32 sta_id,
 				struct ieee80211_key_conf *key, bool mcast,
 				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
 				u8 key_offset)
@@ -2998,6 +2998,9 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
 				  IWL_UCODE_TLV_API_TKIP_MIC_KEYS);
 
+	if (sta_id == IWL_MVM_INVALID_STA)
+		return -EINVAL;
+
 	keyidx = (key->keyidx << STA_KEY_FLG_KEYID_POS) &
 		 STA_KEY_FLG_KEYID_MSK;
 	key_flags = cpu_to_le16(keyidx);
@@ -3056,7 +3059,7 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 
 	u.cmd.common.key_offset = key_offset;
 	u.cmd.common.key_flags = key_flags;
-	u.cmd.common.sta_id = mvm_sta->sta_id;
+	u.cmd.common.sta_id = sta_id;
 
 	if (new_api) {
 		u.cmd.transmit_seq_cnt = cpu_to_le64(pn);
@@ -3189,19 +3192,37 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 				 u8 key_offset,
 				 bool mcast)
 {
-	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	int ret;
 	const u8 *addr;
 	struct ieee80211_key_seq seq;
 	u16 p1k[5];
+	u32 sta_id;
+
+	if (sta) {
+		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
+		sta_id = mvm_sta->sta_id;
+	} else if (vif->type == NL80211_IFTYPE_AP &&
+		   !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+		sta_id = mvmvif->mcast_sta.sta_id;
+	} else {
+		IWL_ERR(mvm, "Failed to find station id\n");
+		return -EINVAL;
+	}
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
+		if (vif->type == NL80211_IFTYPE_AP) {
+			ret = -EINVAL;
+			break;
+		}
 		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
 		/* get phase 1 key from mac80211 */
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
+		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
 					   seq.tkip.iv32, p1k, 0, key_offset);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
@@ -3209,11 +3230,11 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	case WLAN_CIPHER_SUITE_WEP104:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
+		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
 					   0, NULL, 0, key_offset);
 		break;
 	default:
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
+		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
 					   0, NULL, 0, key_offset);
 	}
 
@@ -3234,6 +3255,9 @@ static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
 	int ret, size;
 	u32 status;
 
+	if (sta_id == IWL_MVM_INVALID_STA)
+		return -EINVAL;
+
 	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
 				 STA_KEY_FLG_KEYID_MSK);
 	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
@@ -3277,42 +3301,48 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 	struct iwl_mvm_sta *mvm_sta;
-	u8 sta_id;
+	u8 sta_id = IWL_MVM_INVALID_STA;
 	int ret;
 	static const u8 __maybe_unused zero_addr[ETH_ALEN] = {0};
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Get the station id from the mvm local station table */
-	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
-	if (!mvm_sta) {
-		IWL_ERR(mvm, "Failed to find station\n");
-		return -EINVAL;
-	}
-	sta_id = mvm_sta->sta_id;
+	if (vif->type != NL80211_IFTYPE_AP ||
+	    keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+		/* Get the station id from the mvm local station table */
+		mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
+		if (!mvm_sta) {
+			IWL_ERR(mvm, "Failed to find station\n");
+			return -EINVAL;
+		}
+		sta_id = mvm_sta->sta_id;
 
-	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
-	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
-	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256) {
-		ret = iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, false);
-		goto end;
-	}
+		if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
+		    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
+		    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256) {
+			ret = iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id,
+						    false);
+			goto end;
+		}
 
-	/*
-	 * It is possible that the 'sta' parameter is NULL, and thus
-	 * there is a need to retrieve  the sta from the local station table.
-	 */
-	if (!sta) {
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-						lockdep_is_held(&mvm->mutex));
-		if (IS_ERR_OR_NULL(sta)) {
-			IWL_ERR(mvm, "Invalid station id\n");
-			return -EINVAL;
+		/*
+		 * It is possible that the 'sta' parameter is NULL, and thus
+		 * there is a need to retrieve  the sta from the local station
+		 * table.
+		 */
+		if (!sta) {
+			sta = rcu_dereference_protected(
+				mvm->fw_id_to_mac_id[sta_id],
+				lockdep_is_held(&mvm->mutex));
+			if (IS_ERR_OR_NULL(sta)) {
+				IWL_ERR(mvm, "Invalid station id\n");
+				return -EINVAL;
+			}
 		}
-	}
 
-	if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
-		return -EINVAL;
+		if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
+			return -EINVAL;
+	}
 
 	/* If the key_offset is not pre-assigned, we need to find a
 	 * new offset to use.  In normal cases, the offset is not
@@ -3342,8 +3372,9 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	 * to the same key slot (offset).
 	 * If this fails, remove the original as well.
 	 */
-	if (keyconf->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-	    keyconf->cipher == WLAN_CIPHER_SUITE_WEP104) {
+	if ((keyconf->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     keyconf->cipher == WLAN_CIPHER_SUITE_WEP104) &&
+	    sta) {
 		ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf,
 					    key_offset, !mcast);
 		if (ret) {
@@ -3377,6 +3408,9 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
 	if (mvm_sta)
 		sta_id = mvm_sta->sta_id;
+	else if (!sta && vif->type == NL80211_IFTYPE_AP && mcast)
+		sta_id = iwl_mvm_vif_from_mac80211(vif)->mcast_sta.sta_id;
+
 
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
@@ -3399,7 +3433,7 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	}
 	mvm->fw_key_deleted[keyconf->hw_key_idx] = 0;
 
-	if (!mvm_sta) {
+	if (sta && !mvm_sta) {
 		IWL_DEBUG_WEP(mvm, "station non-existent, early return.\n");
 		return 0;
 	}
@@ -3430,7 +3464,7 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
 	if (WARN_ON_ONCE(!mvm_sta))
 		goto unlock;
-	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
+	iwl_mvm_send_sta_key(mvm, mvm_sta->sta_id, keyconf, mcast,
 			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx);
 
  unlock:
-- 
2.11.0
