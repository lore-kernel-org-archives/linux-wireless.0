Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbDBGm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/31] iwlwifi: mvm: add debugfs entry with the number of net-detect scans
Date: Thu,  2 Apr 2015 09:41:10 +0300
Message-Id: <1427956879-11725-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090418_918004_1FD5D9AF)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Our testers need to know the number of scans performed while in
net-detect mode before the device wakes up.  The firmware already
passes this information to the driver, so we can save it and report it
in a debugfs entry.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c      | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index e730ea2..a6c48c7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1726,6 +1726,10 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 	results->matched_profiles = le32_to_cpu(query->matched_profiles);
 	memcpy(results->matches, query->matches, sizeof(results->matches));
 
+#ifdef CPTCFG_IWLWIFI_DEBUGFS
+	mvm->last_netdetect_scans = le32_to_cpu(query->n_scans_done);
+#endif
+
 out_free_resp:
 	iwl_free_resp(&cmd);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 01b97a0..9ac04c1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1569,6 +1569,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (!debugfs_create_bool("d3_wake_sysassert", S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir, &mvm->d3_wake_sysassert))
 		goto err;
+	if (!debugfs_create_u32("last_netdetect_scans", S_IRUSR,
+				mvm->debugfs_dir, &mvm->last_netdetect_scans))
+		goto err;
 	MVM_DEBUGFS_ADD_FILE(netdetect, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 3513f27..a3f2078 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -748,6 +748,7 @@ struct iwl_mvm {
 	void *d3_resume_sram;
 	u32 d3_test_pme_ptr;
 	struct ieee80211_vif *keep_vif;
+	u32 last_netdetect_scans; /* no. of scans in the last net-detect wake */
 #endif
 #endif
 
-- 
1.9.1

