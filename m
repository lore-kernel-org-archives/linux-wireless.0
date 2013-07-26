Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3GZI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/30] iwlwifi: mvm: remove unneeded argument from iwl_mvm_tx_protection()
Date: Fri, 26 Jul 2013 10:28:20 +0200
Message-Id: <1374827327-3464-4-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102900_350757_40AB2483)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The LQ command argument isn't needed, it's always taken from the
station struct that's already passed, remove the argument.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c  | 7 ++++---
 drivers/net/wireless/iwlwifi/mvm/rs.h  | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/tt.c  | 3 +--
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index b328a98..3856c28 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3193,13 +3193,14 @@ void iwl_mvm_rate_control_unregister(void)
  * iwl_mvm_tx_protection - Gets LQ command, change it to enable/disable
  * Tx protection, according to this rquest and previous requests,
  * and send the LQ command.
- * @lq: The LQ command
  * @mvmsta: The station
  * @enable: Enable Tx protection?
  */
-int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq,
-			  struct iwl_mvm_sta *mvmsta, bool enable)
+int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
+			  bool enable)
 {
+	struct iwl_lq_cmd *lq = &mvmsta->lq_sta.lq;
+
 	lockdep_assert_held(&mvm->mutex);
 
 	if (enable) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index cff4f6d..29d699a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -404,7 +404,7 @@ extern void iwl_mvm_rate_control_unregister(void);
 
 struct iwl_mvm_sta;
 
-int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq,
-			  struct iwl_mvm_sta *mvmsta, bool enable);
+int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
+			  bool enable);
 
 #endif /* __rs__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 62fe520..0321bd3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -807,8 +807,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		 * method for HT traffic
 		 * this function also sends the LQ command
 		 */
-		return iwl_mvm_tx_protection(mvm, &mvmsta->lq_sta.lq,
-					     mvmsta, true);
+		return iwl_mvm_tx_protection(mvm, mvmsta, true);
 		/*
 		 * TODO: remove the TLC_RTS flag when we tear down the last
 		 * AGG session (agg_tids_count in DVM)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index d6ae7f1..f5ba185f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -391,8 +391,7 @@ static void iwl_mvm_tt_tx_protection(struct iwl_mvm *mvm, bool enable)
 		mvmsta = (void *)sta->drv_priv;
 		if (enable == mvmsta->tt_tx_protection)
 			continue;
-		err = iwl_mvm_tx_protection(mvm, &mvmsta->lq_sta.lq,
-					    mvmsta, enable);
+		err = iwl_mvm_tx_protection(mvm, mvmsta, enable);
 		if (err) {
 			IWL_ERR(mvm, "Failed to %s Tx protection\n",
 				enable ? "enable" : "disable");
-- 
1.8.0

