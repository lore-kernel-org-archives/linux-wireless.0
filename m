Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13487 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbbFCHb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/15] iwlwifi: pcie: re-enable interrupts on resume
Date: Wed,  3 Jun 2015 10:31:27 +0300
Message-Id: <1433316696-4612-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093203_480103_8EA38ED6)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On resume, all the interrupts are masked (CSR_INT_MASK is 0),
and ict is disabled.

Re-configure them both.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c    |  3 ++-
 drivers/net/wireless/iwlwifi/pcie/drv.c  | 17 ++++++++++++++---
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index eb34b94..87a230a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -641,6 +641,8 @@ struct iwl_trans {
 
 	enum iwl_d0i3_mode d0i3_mode;
 
+	bool wowlan_d0i3;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 423c519..4165d10 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1170,7 +1170,8 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
 	iwl_trans_suspend(mvm->trans);
-	if (wowlan->any) {
+	mvm->trans->wowlan_d0i3 = wowlan->any;
+	if (mvm->trans->wowlan_d0i3) {
 		/* 'any' trigger means d0i3 usage */
 		if (mvm->trans->d0i3_mode == IWL_D0I3_MODE_ON_SUSPEND) {
 			int ret = iwl_mvm_enter_d0i3_sync(mvm);
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index b185697..2ed1e4d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -629,7 +629,18 @@ static int iwl_pci_resume(struct device *device)
 	if (!trans->op_mode)
 		return 0;
 
-	iwl_enable_rfkill_int(trans);
+	/*
+	 * On suspend, ict is disabled, and the interrupt mask
+	 * gets cleared. Reconfigure them both in case of d0i3
+	 * image. Otherwise, only enable rfkill interrupt (in
+	 * order to keep track of the rfkill status)
+	 */
+	if (trans->wowlan_d0i3) {
+		iwl_pcie_reset_ict(trans);
+		iwl_enable_interrupts(trans);
+	} else {
+		iwl_enable_rfkill_int(trans);
+	}
 
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	iwl_trans_pcie_rf_kill(trans, hw_rfkill);
-- 
2.1.4

