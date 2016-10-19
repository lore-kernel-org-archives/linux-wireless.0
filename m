Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50164 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943533AbcJSOza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:22 +0300
Message-Id: <20161019072726.22018-4-luca@coelho.fi> (sfid-20161019_165553_398562_7C393F0A)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 3/7] iwlwifi: mvm: fix d3_test with unified D0/D3 images
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When a unified D0/D3 image is used, we don't restart the FW in the
D0->D3->D0 transitions.  Therefore, the d3_test functionality should
not call ieee8021_restart_hw() when the resuming either.

Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 4fdc3da..0e17cb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2271,7 +2271,8 @@ static void iwl_mvm_d3_test_disconn_work_iter(void *_data, u8 *mac,
 static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 {
 	struct iwl_mvm *mvm = inode->i_private;
-	int remaining_time = 10;
+	bool unified_image = fw_has_capa(&mvm->fw->ucode_capa,
+					 IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 
 	mvm->d3_test_active = false;
 
@@ -2282,17 +2283,21 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 
 	iwl_abort_notification_waits(&mvm->notif_wait);
-	ieee80211_restart_hw(mvm->hw);
+	if (!unified_image) {
+		int remaining_time = 10;
 
-	/* wait for restart and disconnect all interfaces */
-	while (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
-	       remaining_time > 0) {
-		remaining_time--;
-		msleep(1000);
-	}
+		ieee80211_restart_hw(mvm->hw);
+
+		/* wait for restart and disconnect all interfaces */
+		while (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
+		       remaining_time > 0) {
+			remaining_time--;
+			msleep(1000);
+		}
 
-	if (remaining_time == 0)
-		IWL_ERR(mvm, "Timed out waiting for HW restart to finish!\n");
+		if (remaining_time == 0)
+			IWL_ERR(mvm, "Timed out waiting for HW restart!\n");
+	}
 
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-- 
2.9.3
