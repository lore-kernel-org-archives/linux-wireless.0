Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2DWVwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/29] iwlwifi: first enable RF kill interrupt, then check register
Date: Mon, 23 Apr 2012 14:47:13 -0700
Message-Id: <1335217660-21950-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235352_980013_735F4A73)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can solve a race (very unlikely to happen though).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 1d9724d..78aa320 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -980,14 +980,13 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return -EIO;
 	}
 
+	iwl_enable_rfkill_int(trans);
+
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
-
-	if (hw_rfkill) {
-		iwl_enable_rfkill_int(trans);
+	if (hw_rfkill)
 		return -ERFKILL;
-	}
 
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
@@ -1560,15 +1559,14 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
 	bool hw_rfkill;
 
+	iwl_enable_rfkill_int(trans);
+
 	hw_rfkill = iwl_is_rfkill_set(trans);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
-	if (hw_rfkill)
-		iwl_enable_rfkill_int(trans);
-	else
+	if (!hw_rfkill)
 		iwl_enable_interrupts(trans);
 
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
-
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
-- 
1.7.0.4

