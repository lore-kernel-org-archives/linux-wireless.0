Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbJYMCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:02:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/16] iwlwifi: mvm: take scan ref only on success
Date: Sun, 25 Oct 2015 14:01:14 +0200
Message-Id: <1445774476-24792-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_131654_813541_C865DC0C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In some cases, scan reference was taken, but wasn't
released even though scan command wasn't actually issued.

Change the current code to simply take the reference
only on success.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 0e9d28c..d6e0c1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1190,8 +1190,6 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
-
 	/* we should have failed registration if scan_cmd was NULL */
 	if (WARN_ON(!mvm->scan_cmd))
 		return -ENOMEM;
@@ -1232,21 +1230,20 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return ret;
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
-	if (!ret) {
-		IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
-		mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
-	} else {
+	if (ret) {
 		/* If the scan failed, it usually means that the FW was unable
 		 * to allocate the time events. Warn on it, but maybe we
 		 * should try to send the command again with different params.
 		 */
 		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
+		return ret;
 	}
 
-	if (ret)
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+	IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
+	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
+	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	return ret;
+	return 0;
 }
 
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
-- 
2.1.4

