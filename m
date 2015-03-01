Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbbCATcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/31] iwlwifi: mvm: remove unused function in BT coex
Date: Sun,  1 Mar 2015 21:31:23 +0200
Message-Id: <1425238304-498-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203215_957174_10A5C5FB)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Cleanup unused code.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 6 ------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 85144d5..adfd1ec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1167,12 +1167,6 @@ bool iwl_mvm_bt_coex_is_mimo_allowed_old(struct iwl_mvm *mvm,
 	return lut_type != BT_COEX_LOOSE_LUT;
 }
 
-bool iwl_mvm_bt_coex_is_ant_avail_old(struct iwl_mvm *mvm, u8 ant)
-{
-	u32 ag = le32_to_cpu(mvm->last_bt_notif_old.bt_activity_grading);
-	return ag < BT_HIGH_TRAFFIC;
-}
-
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm)
 {
 	u32 ag = le32_to_cpu(mvm->last_bt_notif_old.bt_activity_grading);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6c69d05..07b91d6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1238,7 +1238,6 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
 
-bool iwl_mvm_bt_coex_is_ant_avail_old(struct iwl_mvm *mvm, u8 ant);
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm);
 void iwl_mvm_bt_coex_vif_change_old(struct iwl_mvm *mvm);
 int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm);
-- 
1.9.1

