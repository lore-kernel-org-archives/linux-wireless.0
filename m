Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39336 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754260AbeDMMnF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:33 +0300
Message-Id: <20180413124256.21769-3-luca@coelho.fi> (sfid-20180413_144311_165990_5E082037)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: use TCM data to decide scan priority
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The code for changing the scan priority is already implemented, but
isn't yet in use.  Now that TCM data is available, we can base the
scan priority decision on the traffic load.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index cd7ae6976935..8f3185b9d365 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -228,7 +228,7 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 
 static enum iwl_mvm_traffic_load iwl_mvm_get_traffic_load(struct iwl_mvm *mvm)
 {
-	return IWL_MVM_TRAFFIC_LOW;
+	return mvm->tcm.result.global_load;
 }
 
 static enum
-- 
2.16.3
