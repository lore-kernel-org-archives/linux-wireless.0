Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60610 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751150AbdFBJfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:12 +0300
Message-Id: <20170602093516.16369-7-luca@coelho.fi> (sfid-20170602_113546_906631_BFBD4AD2)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 06/10] iwlwifi: pcie: only use d0i3 in suspend/resume if system_pm is set to d0i3
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We only need to handle d0i3 entry and exit during suspend resume if
system_pm is set to IWL_PLAT_PM_MODE_D0I3, otherwise d0i3 entry
failures will cause suspend to fail.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=194791

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 70acf850a9f1..93cbc7a69bcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2803,7 +2803,8 @@ static struct iwl_trans_dump_data
 #ifdef CONFIG_PM_SLEEP
 static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 {
-	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3)
+	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3 &&
+	    (trans->system_pm_mode == IWL_PLAT_PM_MODE_D0I3))
 		return iwl_pci_fw_enter_d0i3(trans);
 
 	return 0;
@@ -2811,7 +2812,8 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 
 static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
-	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3)
+	if (trans->runtime_pm_mode == IWL_PLAT_PM_MODE_D0I3 &&
+	    (trans->system_pm_mode == IWL_PLAT_PM_MODE_D0I3))
 		iwl_pci_fw_exit_d0i3(trans);
 }
 #endif /* CONFIG_PM_SLEEP */
-- 
2.11.0
