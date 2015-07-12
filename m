Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbbGLRIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/10] iwlwifi: mvm: Add preemptive flag to scheulded scan
Date: Sun, 12 Jul 2015 20:08:18 +0300
Message-Id: <1436720900-18588-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190842_541134_7FAC98D4)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add preemptive flag to scheduled scan command flags. Without this
flag, all scan requests after scheduled scan was started will be
delayed until scheduled scan stops. As a result, P2P_FIND will be
blocked while scheduled scan is active.
This flag was omitted during refactoring.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 3 ++-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 5e4cbdb..737774a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -660,7 +660,8 @@ struct iwl_scan_config {
  * iwl_umac_scan_flags
  *@IWL_UMAC_SCAN_FLAG_PREEMPTIVE: scan process triggered by this scan request
  *	can be preempted by other scan requests with higher priority.
- *	The low priority scan is aborted.
+ *	The low priority scan will be resumed when the higher proirity scan is
+ *	completed.
  *@IWL_UMAC_SCAN_FLAG_START_NOTIF: notification will be sent to the driver
  *	when scan starts.
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 5de1449..5000bfcd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1109,6 +1109,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->uid = cpu_to_le32(uid);
 	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params));
 
+	if (type == IWL_MVM_SCAN_SCHED)
+		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
+
 	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations))
 		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-- 
2.1.4

