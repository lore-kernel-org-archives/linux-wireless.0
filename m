Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39498 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754735AbeDMMny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:50 +0300
Message-Id: <20180413124256.21769-20-luca@coelho.fi> (sfid-20180413_144358_378049_4379DC35)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: set the MFP flag for keys that are used by MFP stations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

22000 devices rely on this flag to install the key to the right
queues.  For earlier devices we didn't have a key / queue mapping and
the key was sent along with the Tx command for each Tx hence the
problem didn't arise.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 80067eb9ea05..4f9d3e13d7e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -2887,7 +2888,7 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 				u32 sta_id,
 				struct ieee80211_key_conf *key, bool mcast,
 				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
-				u8 key_offset)
+				u8 key_offset, bool mfp)
 {
 	union {
 		struct iwl_mvm_add_sta_key_cmd_v1 cmd_v1;
@@ -2960,6 +2961,8 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 
 	if (mcast)
 		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
+	if (mfp)
+		key_flags |= cpu_to_le16(STA_KEY_MFP);
 
 	u.cmd.common.key_offset = key_offset;
 	u.cmd.common.key_flags = key_flags;
@@ -3101,11 +3104,13 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	struct ieee80211_key_seq seq;
 	u16 p1k[5];
 	u32 sta_id;
+	bool mfp = false;
 
 	if (sta) {
 		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 		sta_id = mvm_sta->sta_id;
+		mfp = sta->mfp;
 	} else if (vif->type == NL80211_IFTYPE_AP &&
 		   !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -3127,7 +3132,8 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
 		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
-					   seq.tkip.iv32, p1k, 0, key_offset);
+					   seq.tkip.iv32, p1k, 0, key_offset,
+					   mfp);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -3135,11 +3141,11 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
-					   0, NULL, 0, key_offset);
+					   0, NULL, 0, key_offset, mfp);
 		break;
 	default:
 		ret = iwl_mvm_send_sta_key(mvm, sta_id, keyconf, mcast,
-					   0, NULL, 0, key_offset);
+					   0, NULL, 0, key_offset, mfp);
 	}
 
 	return ret;
@@ -3366,6 +3372,7 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_sta *mvm_sta;
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+	bool mfp = sta ? sta->mfp : false;
 
 	rcu_read_lock();
 
@@ -3373,7 +3380,8 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 	if (WARN_ON_ONCE(!mvm_sta))
 		goto unlock;
 	iwl_mvm_send_sta_key(mvm, mvm_sta->sta_id, keyconf, mcast,
-			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx);
+			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx,
+			     mfp);
 
  unlock:
 	rcu_read_unlock();
-- 
2.16.3
