Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934536Ab1IOTcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/27] iwlagn: clean up PM code
Date: Thu, 15 Sep 2011 11:46:45 -0700
Message-Id: <1316112414-6341-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213242_883736_72689A0D)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The transport callbacks might as well be undefined
when CONFIG_PM_SLEEP is not set, so ifdef all of
it out and make everything available for PM_SLEEP
only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   15 ++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    5 ++++-
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 61f8ea6..5c85133 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1919,7 +1919,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int iwlagn_send_patterns(struct iwl_priv *priv,
 				struct cfg80211_wowlan *wowlan)
 {
@@ -1994,7 +1994,7 @@ struct wowlan_key_data {
 	bool error, use_rsc_tsc, use_tkip;
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
 {
 	int i;
@@ -3203,7 +3203,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend = iwlagn_mac_suspend,
 	.resume = iwlagn_mac_resume,
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 9a414b2..ca13eeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1363,8 +1363,7 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	kfree(trans);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 {
 	/*
@@ -1402,14 +1401,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 
 	return 0;
 }
-#else /* CONFIG_PM */
-static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
-{ return 0; }
-
-static int iwl_trans_pcie_resume(struct iwl_trans *trans)
-{ return 0; }
-
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 					  enum iwl_rxon_context_id ctx)
@@ -1989,7 +1981,8 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
 	.check_stuck_queue = iwl_trans_pcie_check_stuck_queue,
 
+#ifdef CONFIG_PM_SLEEP
 	.suspend = iwl_trans_pcie_suspend,
 	.resume = iwl_trans_pcie_resume,
+#endif
 };
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8fba516..5b6e684 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -208,9 +208,10 @@ struct iwl_trans_ops {
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
-
+#ifdef CONFIG_PM_SLEEP
 	int (*suspend)(struct iwl_trans *trans);
 	int (*resume)(struct iwl_trans *trans);
+#endif
 };
 
 /**
@@ -337,6 +338,7 @@ static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
 	return trans->ops->dbgfs_register(trans, dir);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static inline int iwl_trans_suspend(struct iwl_trans *trans)
 {
 	return trans->ops->suspend(trans);
@@ -346,6 +348,7 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 {
 	return trans->ops->resume(trans);
 }
+#endif
 
 /*****************************************************
 * Transport layers implementations
-- 
1.7.0.4

