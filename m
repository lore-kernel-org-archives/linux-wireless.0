Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab2BCAQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/28] iwlwifi: move the RF kill logic from iwl_probe to transport
Date: Thu,  2 Feb 2012 15:09:06 -0800
Message-Id: <1328224159-18134-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011743_683579_669AA3D9)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is another clean up of the proble flow.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   23 -----------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   11 +++++++++++
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8846246..14f8b75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1815,13 +1815,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	spin_lock_init(&trans(priv)->reg_lock);
 	spin_lock_init(&priv->shrd->lock);
 
-	/*
-	 * stop and reset the on-board processor just in case it is in a
-	 * strange state ... like being left stranded by a primary kernel
-	 * and this is now the kdump kernel trying to start up
-	 */
-	iwl_write32(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
-
 	/***********************
 	 * 3. Read REV register
 	 ***********************/
@@ -1890,22 +1883,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_setup_rx_handlers(priv);
 	iwl_testmode_init(priv);
 
-	/*********************************************
-	 * 8. Enable interrupts
-	 *********************************************/
-
-	iwl_enable_rfkill_int(priv);
-
-	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(trans(priv),
-			CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
-
-	wiphy_rfkill_set_hw_state(priv->hw->wiphy,
-		test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
-
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 43e894f..362444a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1393,6 +1393,17 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	iwl_apm_init(trans);
 
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl_read32(trans,
+			CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+
+	iwl_set_hw_rfkill_state(priv(trans),
+				test_bit(STATUS_RF_KILL_HW,
+					 &trans->shrd->status));
+
 	return err;
 
 error:
-- 
1.7.0.4

