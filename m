Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2DWVwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/29] iwlwifi: check RF kill register when interrupts have been disabled
Date: Mon, 23 Apr 2012 14:47:15 -0700
Message-Id: <1335217660-21950-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235352_346237_3E81D3C0)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the interrupts have been disabled, we may have missed an RF
kill interrupt. Check the register to be sure the op_mode is in
sync.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 589037d..8e1cf97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1438,12 +1438,22 @@ error:
 
 static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 {
+	bool hw_rfkill;
+
 	iwl_apm_stop(trans);
 
 	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	/* Even if we stop the HW, we still want the RF kill interrupt */
 	iwl_enable_rfkill_int(trans);
+
+	/*
+	 * Check again since the RF kill state may have changed while all the
+	 * interrupts were disabled, in this case we couldn't receive the
+	 * RF kill interrupt and update the state in the op_mode.
+	 */
+	hw_rfkill = iwl_is_rfkill_set(trans);
+	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 }
 
 static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
-- 
1.7.0.4

