Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab0FYWnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwlwifi: read rfkill during resume
Date: Fri, 25 Jun 2010 15:42:58 -0700
Message-Id: <1277505781-25268-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When resuming from hibernate or suspend,
the status of the rfkill switch isn't
known since it might have been toggled
while the system was asleep. Therefore,
we need to read out the status at resume
time to make sure the system knows about
an up-to-date status.

Reported-by: Mark Tung <mark.y.tung@intel.com>
Tested-by: Mark Tung <mark.y.tung@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f47a58f..a56fb46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2845,6 +2845,7 @@ int iwl_pci_resume(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	int ret;
+	bool hw_rfkill = false;
 
 	/*
 	 * We disable the RETRY_TIMEOUT register (0x41) to keep
@@ -2859,6 +2860,17 @@ int iwl_pci_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 	iwl_enable_interrupts(priv);
 
+	if (!(iwl_read32(priv, CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+		hw_rfkill = true;
+
+	if (hw_rfkill)
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+
+	wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rfkill);
+
 	return 0;
 }
 EXPORT_SYMBOL(iwl_pci_resume);
-- 
1.7.0.4

