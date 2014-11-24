Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52929 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaKXOf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:56 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5863437wiv.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/75] iwlwifi: mvm: refactor key add/remove functions
Date: Mon, 24 Nov 2014 16:34:12 +0200
Message-Id: <1416839691-28533-36-git-send-email-egrumbach@gmail.com> (sfid-20141124_154346_799233_0FDE3129)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the key add/remove functions to be able to reuse parts
of them later for RX WEP keys, which need to be uploaded twice.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 143 ++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 74a7c91..f94be3c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1072,8 +1072,7 @@ static u8 iwl_mvm_get_key_sta_id(struct ieee80211_vif *vif,
 static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 				struct iwl_mvm_sta *mvm_sta,
 				struct ieee80211_key_conf *keyconf,
-				u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
-				u32 cmd_flags)
+				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags)
 {
 	struct iwl_mvm_add_sta_key_cmd cmd = {};
 	__le16 key_flags;
@@ -1081,6 +1080,7 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 	u32 status;
 	u16 keyidx;
 	int i;
+	u8 sta_id = mvm_sta->sta_id;
 
 	keyidx = (keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
 		 STA_KEY_FLG_KEYID_MSK;
@@ -1196,17 +1196,83 @@ static inline u8 *iwl_mvm_get_mac_addr(struct iwl_mvm *mvm,
 	return NULL;
 }
 
+static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 struct ieee80211_key_conf *keyconf)
+{
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	int ret;
+	const u8 *addr;
+	struct ieee80211_key_seq seq;
+	u16 p1k[5];
+
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
+		/* get phase 1 key from mac80211 */
+		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
+		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
+		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
+					   seq.tkip.iv32, p1k, 0);
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
+					   0, NULL, 0);
+		break;
+	default:
+		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
+					   0, NULL, 0);
+	}
+
+	return ret;
+}
+
+static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
+				    struct ieee80211_key_conf *keyconf)
+{
+	struct iwl_mvm_add_sta_key_cmd cmd = {};
+	__le16 key_flags;
+	int ret;
+	u32 status;
+
+	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
+				 STA_KEY_FLG_KEYID_MSK);
+	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
+	key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
+
+	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
+
+	cmd.key_flags = key_flags;
+	cmd.key_offset = keyconf->hw_key_idx;
+	cmd.sta_id = sta_id;
+
+	status = ADD_STA_SUCCESS;
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
+					  &cmd, &status);
+
+	switch (status) {
+	case ADD_STA_SUCCESS:
+		IWL_DEBUG_WEP(mvm, "MODIFY_STA: remove sta key passed\n");
+		break;
+	default:
+		ret = -EIO;
+		IWL_ERR(mvm, "MODIFY_STA: remove sta key failed\n");
+		break;
+	}
+
+	return ret;
+}
+
 int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta,
 			struct ieee80211_key_conf *keyconf,
 			bool have_key_offset)
 {
-	struct iwl_mvm_sta *mvm_sta;
+	u8 sta_id;
 	int ret;
-	u8 *addr, sta_id;
-	struct ieee80211_key_seq seq;
-	u16 p1k[5];
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1235,8 +1301,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		}
 	}
 
-	mvm_sta = (struct iwl_mvm_sta *)sta->drv_priv;
-	if (WARN_ON_ONCE(mvm_sta->vif != vif))
+	if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
 		return -EINVAL;
 
 	if (!have_key_offset) {
@@ -1250,24 +1315,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			return -ENOSPC;
 	}
 
-	switch (keyconf->cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
-		/* get phase 1 key from mac80211 */
-		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
-		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
-					   seq.tkip.iv32, p1k, 0);
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
-					   0, NULL, 0);
-		break;
-	default:
-		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
-					   sta_id, 0, NULL, 0);
-	}
-
+	ret = __iwl_mvm_set_sta_key(mvm, vif, sta, keyconf);
 	if (ret)
 		__clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
 
@@ -1283,11 +1331,6 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 			   struct ieee80211_sta *sta,
 			   struct ieee80211_key_conf *keyconf)
 {
-	struct iwl_mvm_sta *mvm_sta;
-	struct iwl_mvm_add_sta_key_cmd cmd = {};
-	__le16 key_flags;
-	int ret;
-	u32 status;
 	u8 sta_id;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1301,8 +1344,7 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		return iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, true);
 
-	ret = __test_and_clear_bit(keyconf->hw_key_idx, mvm->fw_key_table);
-	if (!ret) {
+	if (!__test_and_clear_bit(keyconf->hw_key_idx, mvm->fw_key_table)) {
 		IWL_ERR(mvm, "offset %d not used in fw key table.\n",
 			keyconf->hw_key_idx);
 		return -ENOENT;
@@ -1328,37 +1370,10 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 		}
 	}
 
-	mvm_sta = (struct iwl_mvm_sta *)sta->drv_priv;
-	if (WARN_ON_ONCE(mvm_sta->vif != vif))
+	if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
 		return -EINVAL;
 
-	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
-				 STA_KEY_FLG_KEYID_MSK);
-	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
-	key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
-
-	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
-		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
-
-	cmd.key_flags = key_flags;
-	cmd.key_offset = keyconf->hw_key_idx;
-	cmd.sta_id = sta_id;
-
-	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
-					  &cmd, &status);
-
-	switch (status) {
-	case ADD_STA_SUCCESS:
-		IWL_DEBUG_WEP(mvm, "MODIFY_STA: remove sta key passed\n");
-		break;
-	default:
-		ret = -EIO;
-		IWL_ERR(mvm, "MODIFY_STA: remove sta key failed\n");
-		break;
-	}
-
-	return ret;
+	return __iwl_mvm_remove_sta_key(mvm, sta_id, keyconf);
 }
 
 void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
@@ -1383,8 +1398,8 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 		}
 	}
 
-	mvm_sta = (void *)sta->drv_priv;
-	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
+	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
 			     iv32, phase1key, CMD_ASYNC);
 	rcu_read_unlock();
 }
-- 
1.9.1

