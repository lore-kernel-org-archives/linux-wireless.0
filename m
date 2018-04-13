Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754666AbeDMMnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:38 +0300
Message-Id: <20180413124256.21769-8-luca@coelho.fi> (sfid-20180413_144324_605805_055AF1B5)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: fix OOC priority in scans
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The code that sets the correct out-of-channel priority depending on
the scan type was accidentally removed during a rebase.  Add it back.

Fixes: c1a7515393e4 ("iwlwifi: mvm: add adaptive dwell support")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 8c5f4f96d6d4..4b3753d78d03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1297,6 +1297,11 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				cpu_to_le32(timing->suspend_time);
 		}
 	}
+
+	if (iwl_mvm_is_regular_scan(params))
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_6);
+	else
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_EXT_2);
 }
 
 static void
-- 
2.16.3
