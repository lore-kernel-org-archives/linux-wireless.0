Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2BCAQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/28] iwlwifi: release IRQ in error path
Date: Thu,  2 Feb 2012 15:09:18 -0800
Message-Id: <1328224159-18134-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011710_923903_5860FB3C)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

smatch correctly complains:
iwl-trans-pcie.c +1528 iwl_trans_pcie_start_hw(50) warn: 'trans->irq' was not released on error

Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ec26950..836caf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1504,7 +1504,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	err = iwl_prepare_card_hw(trans);
 	if (err) {
 		IWL_ERR(trans, "Error while preparing HW: %d", err);
-		goto error;
+		goto err_free_irq;
 	}
 
 	iwl_apm_init(trans);
@@ -1522,6 +1522,8 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	return err;
 
+err_free_irq:
+	free_irq(trans->irq, trans);
 error:
 	iwl_free_isr_ict(trans);
 	tasklet_kill(&trans_pcie->irq_tasklet);
-- 
1.7.0.4

