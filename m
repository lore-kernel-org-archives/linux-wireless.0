Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab2DWVwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/29] iwlwifi: enable RF kill interrupt in start_hw
Date: Mon, 23 Apr 2012 14:47:14 -0700
Message-Id: <1335217660-21950-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235353_579320_3287B7B0)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The op_mode wants to know about changes in HW RF kill state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 78aa320..589037d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1420,6 +1420,9 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	iwl_apm_init(trans);
 
+	/* From now on, the op_mode will be kept updated about RF kill state */
+	iwl_enable_rfkill_int(trans);
+
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 
-- 
1.7.0.4

