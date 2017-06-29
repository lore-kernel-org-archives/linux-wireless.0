Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753432AbdF2ScB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:32:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:25 +0300
Message-Id: <20170629183027.15408-14-luca@coelho.fi> (sfid-20170629_203210_867108_63B28B37)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 13/15] iwlwifi: pcie: propagate iwl_pcie_apm_init's status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_pcie_apm_init can fail so make sure that the caller
takes the status into account.
Also, ensure that the error that iwl_pcie_apm_init can emit
will appear in the kernel log by default.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index a7d0b5c5e4a0..cac584cc07b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -236,7 +236,8 @@ void iwl_pcie_apm_config(struct iwl_trans *trans)
  */
 static int iwl_pcie_apm_init(struct iwl_trans *trans)
 {
-	int ret = 0;
+	int ret;
+
 	IWL_DEBUG_INFO(trans, "Init card's basic functions\n");
 
 	/*
@@ -287,8 +288,8 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IWL_DEBUG_INFO(trans, "Failed to init the card\n");
-		goto out;
+		IWL_ERR(trans, "Failed to init the card\n");
+		return ret;
 	}
 
 	if (trans->cfg->host_interrupt_operation_mode) {
@@ -336,8 +337,7 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 
 	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -514,13 +514,16 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 static int iwl_pcie_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
 
 	/* nic_init */
 	spin_lock(&trans_pcie->irq_lock);
-	iwl_pcie_apm_init(trans);
-
+	ret = iwl_pcie_apm_init(trans);
 	spin_unlock(&trans_pcie->irq_lock);
 
+	if (ret)
+		return ret;
+
 	iwl_pcie_set_pwr(trans, false);
 
 	iwl_op_mode_nic_config(trans->op_mode);
@@ -1658,7 +1661,9 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 	usleep_range(1000, 2000);
 
-	iwl_pcie_apm_init(trans);
+	err = iwl_pcie_apm_init(trans);
+	if (err)
+		return err;
 
 	iwl_pcie_init_msix(trans_pcie);
 
-- 
2.11.0
