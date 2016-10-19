Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50146 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943511AbcJSOzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:23 +0300
Message-Id: <20161019072726.22018-5-luca@coelho.fi> (sfid-20161019_165529_321628_B93997DF)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 4/7] iwlwifi: mvm: comply with fw_restart mod param on suspend
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

If the suspend flow fails, we restart the hardware to go back to
the D0 image (with non-unified images), but we don't comply with
the fw_restart module parameter.  If something goes wrong when
starting the D3 image, we may want to debug it, so we should
comply with the fw_restart flag to avoid clearing everything up
and losing the firmware state when the error occurred.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 0e17cb2..03a8fc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1254,7 +1254,10 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
  out:
 	if (ret < 0) {
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
-		ieee80211_restart_hw(mvm->hw);
+		if (mvm->restart_fw > 0) {
+			mvm->restart_fw--;
+			ieee80211_restart_hw(mvm->hw);
+		}
 		iwl_mvm_free_nd(mvm);
 	}
  out_noreset:
-- 
2.9.3
