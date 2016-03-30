Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbcC3OFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/43] iwlwifi: add missing mutex_destroy statements
Date: Wed, 30 Mar 2016 17:04:47 +0300
Message-Id: <1459346715-7954-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160610_892172_CA7BC00F)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi / iwlmvm didn't destroy their mutexes. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6153c8e..d4b71a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -782,6 +782,9 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_tof_clean(mvm);
 
+	mutex_destroy(&mvm->mutex);
+	mutex_destroy(&mvm->d0i3_suspend_mutex);
+
 	ieee80211_free_hw(mvm->hw);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 28fe220..0c40209 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1695,6 +1695,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	}
 
 	free_percpu(trans_pcie->tso_hdr_page);
+	mutex_destroy(&trans_pcie->mutex);
 	iwl_trans_free(trans);
 }
 
-- 
2.5.0

