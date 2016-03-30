Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbcC3OFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/43] iwlwifi: mvm: modify the max SP to infinite
Date: Wed, 30 Mar 2016 17:04:44 +0300
Message-Id: <1459346715-7954-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160801_874178_F9BA2983)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes u-APSD work with more peers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0668601..2e0a882 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -208,7 +208,7 @@ enum iwl_power_scheme {
 };
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	10
-#define IWL_UAPSD_MAX_SP		IEEE80211_WMM_IE_STA_QOSINFO_SP_2
+#define IWL_UAPSD_MAX_SP		IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 enum iwl_dbgfs_pm_mask {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index f313910..7b1f6ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -227,7 +227,7 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 			cpu_to_le16(IWL_MVM_PS_SNOOZE_WINDOW);
 	}
 
-	cmd->uapsd_max_sp = IWL_UAPSD_MAX_SP;
+	cmd->uapsd_max_sp = mvm->hw->uapsd_max_sp_len;
 
 	if (mvm->cur_ucode == IWL_UCODE_WOWLAN || cmd->flags &
 	    cpu_to_le16(POWER_FLAGS_SNOOZE_ENA_MSK)) {
-- 
2.5.0

