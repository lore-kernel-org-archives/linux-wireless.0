Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35040 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751134AbdFYLNY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:48 +0300
Message-Id: <20170625111158.1792-17-luca@coelho.fi> (sfid-20170625_131327_455258_5BDB07B8)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 16/26] iwlwifi: pcie: make iwl_pcie_apm_stop_master() return void
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Nothing ever checks the return value of iwl_pcie_apm_stop_master(),
so there's no point in it having one - make it return void.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 4295b8409720..1f4bc933f0f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -779,7 +779,7 @@ void iwl_trans_pcie_handle_stop_rfkill(struct iwl_trans *trans,
 				       bool was_in_rfkill);
 void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 int iwl_queue_space(const struct iwl_txq *q);
-int iwl_pcie_apm_stop_master(struct iwl_trans *trans);
+void iwl_pcie_apm_stop_master(struct iwl_trans *trans);
 void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie);
 int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 		      int slots_num, bool cmd_queue);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 67343b10b0da..106e822308c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -448,9 +448,9 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 				 ~SHR_APMG_XTAL_CFG_XTAL_ON_REQ);
 }
 
-int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
+void iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 {
-	int ret = 0;
+	int ret;
 
 	/* stop device's busmaster DMA activity */
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
@@ -462,8 +462,6 @@ int iwl_pcie_apm_stop_master(struct iwl_trans *trans)
 		IWL_WARN(trans, "Master Disable Timed Out, 100 usec\n");
 
 	IWL_DEBUG_INFO(trans, "stop master\n");
-
-	return ret;
 }
 
 static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
-- 
2.11.0
