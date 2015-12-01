Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbbLAJ7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/41] iwlwifi: mvm: remove stray nd_config element
Date: Tue,  1 Dec 2015 11:58:44 +0200
Message-Id: <1448963947-24302-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110313_817621_3BD5E3BD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When the netdetect debugfs entry was removed, the nd_config element
was accidentally left in the iwl_mvm structure.  Remove it.

Fixes: dbb04b0d29f8 ("iwlwifi: mvm: remove netdetect debugfs entry")
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 ------
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 76c2002..7bb5496 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1057,13 +1057,13 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT) {
 		/* if we're not associated, this must be netdetect */
-		if (!wowlan->nd_config && !mvm->nd_config) {
+		if (!wowlan->nd_config) {
 			ret = 1;
 			goto out_noreset;
 		}
 
 		ret = iwl_mvm_netdetect_config(
-			mvm, wowlan, wowlan->nd_config ?: mvm->nd_config, vif);
+			mvm, wowlan, wowlan->nd_config, vif);
 		if (ret)
 			goto out;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 897d06f..ff32f36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -732,7 +732,6 @@ struct iwl_mvm {
 	int gtk_ivlen, gtk_icvlen, ptk_ivlen, ptk_icvlen;
 
 	/* sched scan settings for net detect */
-	struct cfg80211_sched_scan_request *nd_config;
 	struct ieee80211_scan_ies nd_ies;
 	struct cfg80211_match_set *nd_match_sets;
 	int n_nd_match_sets;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1646cdd..9264928 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -642,12 +642,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_IWLWIFI_DEBUGFS)
 	kfree(mvm->d3_resume_sram);
-	if (mvm->nd_config) {
-		kfree(mvm->nd_config->match_sets);
-		kfree(mvm->nd_config->scan_plans);
-		kfree(mvm->nd_config);
-		mvm->nd_config = NULL;
-	}
 #endif
 
 	iwl_trans_op_mode_leave(mvm->trans);
-- 
2.5.0

