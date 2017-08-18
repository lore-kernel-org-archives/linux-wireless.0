Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44492 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751674AbdHRPth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:06 +0300
Message-Id: <20170818154922.2904-9-luca@coelho.fi> (sfid-20170818_174941_100562_E6339FDE)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 08/24] iwlwifi: mvm: group all dummy SAR function declarations together
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We have some of the SAR dummy functions when ACPI is not set declared
in mvm.h and some declared in fw.c.  Group them all together in fw.c
for consistency and to avoid static/non-static issues.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 11 +++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 14 --------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index ed18479a7b8c..90ae50f7768a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -996,6 +996,17 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 {
 	return 0;
 }
+
+int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a,
+			       int prof_b)
+{
+	return -ENOENT;
+}
+
+int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
+{
+	return -ENOENT;
+}
 #endif /* CONFIG_ACPI */
 
 static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d58de9b80886..74fdd33fd9fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1825,21 +1825,7 @@ int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
 			 u32 duration, u32 timeout);
 bool iwl_mvm_lqm_active(struct iwl_mvm *mvm);
 
-#ifdef CONFIG_ACPI
 int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b);
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm);
-#else
-static inline
-int iwl_mvm_sar_select_profile(struct iwl_mvm *mvm, int prof_a, int prof_b)
-{
-	return -ENOENT;
-}
-
-static inline
-int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
-{
-	return -ENOENT;
-}
-#endif /* CONFIG_ACPI */
 
 #endif /* __IWL_MVM_H__ */
-- 
2.14.1
