Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36104 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751183AbdAWWED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:03 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:27 +0200
Message-Id: <20170123220350.25305-3-luca@coelho.fi> (sfid-20170123_230406_689223_09086693)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: don't restart HW if suspend fails with unified image
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

For unified images, we shouldn't restart the HW if suspend fails.  The
only reason for restarting the HW with non-unified images is to go
back to the D0 image.

Fixes: 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b88e2048ae0b..207d8ae1e116 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1262,12 +1262,15 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	iwl_trans_d3_suspend(mvm->trans, test, !unified_image);
  out:
 	if (ret < 0) {
-		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
-		if (mvm->restart_fw > 0) {
-			mvm->restart_fw--;
-			ieee80211_restart_hw(mvm->hw);
-		}
 		iwl_mvm_free_nd(mvm);
+
+		if (!unified_image) {
+			iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
+			if (mvm->restart_fw > 0) {
+				mvm->restart_fw--;
+				ieee80211_restart_hw(mvm->hw);
+			}
+		}
 	}
  out_noreset:
 	mutex_unlock(&mvm->mutex);
-- 
2.11.0
