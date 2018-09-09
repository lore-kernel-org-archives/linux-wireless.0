Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48002 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbeIIO0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:49 +0300
Message-Id: <20180909093656.10194-10-luca@coelho.fi> (sfid-20180909_113714_010304_34C781F8)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 09/16] iwlwifi: mvm: set wep key for all stations in soft ap mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

When operating as a soft ap with wep security, the key was not
configured to the fw for the stations, based on the fact that the
key will be specified in the tx command.

However, in the new tx api the tx command does not include the key,
which resulted in all data frames going out un-encrypted.

Fix it by configuring the key for all the stations as they are added.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 29 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 21 ++++++++++++++
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b55a2e4a0024..c445e93951bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2476,6 +2476,9 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
+	kfree(mvmvif->ap_wep_key);
+	mvmvif->ap_wep_key = NULL;
+
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -2968,7 +2971,13 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
 				     true);
 
-		ret = 0;
+		/* if wep is used, need to set the key for the station now */
+		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key)
+			ret = iwl_mvm_set_sta_key(mvm, vif, sta,
+						  mvmvif->ap_wep_key,
+						  STA_KEY_IDX_INVALID);
+		else
+			ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		/* disable beacon filtering */
@@ -3174,13 +3183,17 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		/* For non-client mode, only use WEP keys for TX as we probably
-		 * don't have a station yet anyway and would then have to keep
-		 * track of the keys, linking them to each of the clients/peers
-		 * as they appear. For now, don't do that, for performance WEP
-		 * offload doesn't really matter much, but we need it for some
-		 * other offload features in client mode.
-		 */
+		if (vif->type == NL80211_IFTYPE_AP) {
+			struct iwl_mvm_vif *mvmvif =
+				iwl_mvm_vif_from_mac80211(vif);
+
+			mvmvif->ap_wep_key = kmemdup(key,
+						     sizeof(*key) + key->keylen,
+						     GFP_KERNEL);
+			if (!mvmvif->ap_wep_key)
+				return -ENOMEM;
+		}
+
 		if (vif->type != NL80211_IFTYPE_STATION)
 			return 0;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 087e8a454ac2..33f8697740a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -471,6 +471,7 @@ struct iwl_mvm_vif {
 	netdev_features_t features;
 
 	struct iwl_probe_resp_data __rcu *probe_resp_data;
+	struct ieee80211_key_conf *ap_wep_key;
 };
 
 static inline struct iwl_mvm_vif *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 6ebc715d90df..550e24da0f5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -67,6 +67,14 @@
 #include "sta.h"
 #include "rs.h"
 
+static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm);
+
+static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
+				u32 sta_id,
+				struct ieee80211_key_conf *key, bool mcast,
+				u32 tkip_iv32, u16 *tkip_p1k, u32 cmd_flags,
+				u8 key_offset, bool mfp);
+
 /*
  * New version of ADD_STA_sta command added new fields at the end of the
  * structure, so sending the size of the relevant API's structure is enough to
@@ -2096,6 +2104,19 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
 				   &cfg, timeout);
 
+	if (mvmvif->ap_wep_key) {
+		u8 key_offset = iwl_mvm_set_fw_key_idx(mvm);
+
+		if (key_offset == STA_KEY_IDX_INVALID)
+			return -ENOSPC;
+
+		ret = iwl_mvm_send_sta_key(mvm, mvmvif->mcast_sta.sta_id,
+					   mvmvif->ap_wep_key, 1, 0, NULL, 0,
+					   key_offset, 0);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
2.18.0
