Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbECTdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/42] iwlwifi: mvm: don't reset key index on HW restart
Date: Sun,  3 May 2015 22:31:50 +0300
Message-Id: <1430681513-7838-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213357_210202_CB8A07AD)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a firmware restart is done, don't try to reprogram the keys to new
slots but rather just keep the old key index, while skipping keys that
weren't programmed before.

Not only does this restore the state more faithfully, but it will also
allow using the HW key index for internal purposes as an array index.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index eca1666..b56a445 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1249,7 +1249,6 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 
 	iwl_mvm_reset_phy_ctxts(mvm);
-	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
 	memset(mvm->sta_drained, 0, sizeof(mvm->sta_drained));
 	memset(mvm->tfd_drained, 0, sizeof(mvm->tfd_drained));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
@@ -2843,8 +2842,21 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			break;
 		}
 
+		/* During FW restart, in order to restore the state as it was,
+		 * don't try to reprogram keys we previously failed for.
+		 */
+		if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
+		    key->hw_key_idx == STA_KEY_IDX_INVALID) {
+			IWL_DEBUG_MAC80211(mvm,
+					   "skip invalid idx key programming during restart\n");
+			ret = 0;
+			break;
+		}
+
 		IWL_DEBUG_MAC80211(mvm, "set hwcrypto key\n");
-		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, false);
+		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key,
+					  test_bit(IWL_MVM_STATUS_IN_HW_RESTART,
+						   &mvm->status));
 		if (ret) {
 			IWL_WARN(mvm, "set key failed\n");
 			/*
-- 
2.1.0

