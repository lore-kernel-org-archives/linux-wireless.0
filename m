Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753812AbdFVVVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:44 +0300
Message-Id: <20170622212101.16422-9-luca@coelho.fi> (sfid-20170622_232153_972749_1C0E0834)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: avoid variable shadowing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Avoid one kind of symbol shadowing another in iwl_mvm_flush_sta()
by renaming the function parameter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 9a9163f64553..cdd13bc343e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1370,7 +1370,7 @@ const char *iwl_mvm_get_tx_fail_reason(u32 status);
 static inline const char *iwl_mvm_get_tx_fail_reason(u32 status) { return ""; }
 #endif
 int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags);
-int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool int_sta, u32 flags);
+int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool internal, u32 flags);
 
 void iwl_mvm_async_handlers_purge(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 63b938028144..da05801c9ca1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1904,11 +1904,11 @@ int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags)
 	return ret;
 }
 
-int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool int_sta, u32 flags)
+int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool internal, u32 flags)
 {
 	u32 mask;
 
-	if (int_sta) {
+	if (internal) {
 		struct iwl_mvm_int_sta *int_sta = sta;
 
 		mask = int_sta->tfd_queue_msk;
-- 
2.11.0
