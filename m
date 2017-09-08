Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49404 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751907AbdIHJNI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:47 +0300
Message-Id: <20170908091256.25279-2-luca@coelho.fi> (sfid-20170908_111312_474309_3417D120)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: mvm: fix wowlan resume failed to load INIT ucode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

If we set disconnect on wowlan and run suspend/resume, will run
into:
...snipped
iwlwifi 0000:01:00.0: Failed to load firmware chunk!
iwlwifi 0000:01:00.0: Could not load the [0] uCode section
iwlwifi 0000:01:00.0: Failed to start INIT ucode: -110
iwlwifi 0000:01:00.0: Failed to run INIT ucode: -110
iwlwifi 0000:01:00.0: Failed to start RT ucode: -110

It is because we still keep IWL_MVM_STATUS_IN_HW_RESTART in
__iwl_mvm_resume.  When mac80211 starts the device as
__iwl_mvm_mac_start(), we will miss iwl_mvm_restart_cleanup(mvm).

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 5de19ea10575..b205a7bfb828 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2167,7 +2167,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	 * 1. We are not using a unified image
 	 * 2. We are using a unified image but had an error while exiting D3
 	 */
-	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+	set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 	set_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status);
 	/*
 	 * When switching images we return 1, which causes mac80211
-- 
2.14.1
