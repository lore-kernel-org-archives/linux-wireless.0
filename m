Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbbHDU7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/37] iwlwifi: return error if d0i3 was aborted
Date: Tue,  4 Aug 2015 23:43:13 +0300
Message-Id: <1438721007-23283-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_705325_AE27D554)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow the transport layer to return an error upon suspend.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 10 ++++++----
 drivers/net/wireless/iwlwifi/mvm/d3.c    |  8 ++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8f67004..e698ed5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -598,7 +598,7 @@ struct iwl_trans_ops {
 			      u32 value);
 	void (*ref)(struct iwl_trans *trans);
 	void (*unref)(struct iwl_trans *trans);
-	void (*suspend)(struct iwl_trans *trans);
+	int  (*suspend)(struct iwl_trans *trans);
 	void (*resume)(struct iwl_trans *trans);
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans);
@@ -807,10 +807,12 @@ static inline void iwl_trans_unref(struct iwl_trans *trans)
 		trans->ops->unref(trans);
 }
 
-static inline void iwl_trans_suspend(struct iwl_trans *trans)
+static inline int iwl_trans_suspend(struct iwl_trans *trans)
 {
-	if (trans->ops->suspend)
-		trans->ops->suspend(trans);
+	if (!trans->ops->suspend)
+		return 0;
+
+	return trans->ops->suspend(trans);
 }
 
 static inline void iwl_trans_resume(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 246e60a..68d7218 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1168,13 +1168,17 @@ remove_notif:
 int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	ret = iwl_trans_suspend(mvm->trans);
+	if (ret)
+		return ret;
 
-	iwl_trans_suspend(mvm->trans);
 	mvm->trans->wowlan_d0i3 = wowlan->any;
 	if (mvm->trans->wowlan_d0i3) {
 		/* 'any' trigger means d0i3 usage */
 		if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
-			int ret = iwl_mvm_enter_d0i3_sync(mvm);
+			ret = iwl_mvm_enter_d0i3_sync(mvm);
 
 			if (ret)
 				return ret;
-- 
2.1.4

