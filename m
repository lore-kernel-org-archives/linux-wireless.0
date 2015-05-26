Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbEZTSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/39] iwlwifi: mvm: fix ROC reference accounting
Date: Tue, 26 May 2015 22:17:15 +0300
Message-Id: <1432667872-18092-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_212042_293136_2DFFBB9B)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

commit b112889c5af8124 ("iwlwifi: mvm: add Aux ROC request/response flow")
added aux ROC flow in addition to the existing ROC flow. While doing
it, it moved the ROC reference release to a common work item, which
is being called for both the ROC and aux ROC flows.

This resulted in invalid reference accounting, as no reference was
taken in case of aux ROC, while a reference was released on completion.

Fix it by adding a reference for the aux ROC as well, and release
only the relevant references on completion (according to the set bits).

While at it, convert cancel_work_sync() to flush_work(), in order
to make sure the references are being cleaned properly.

Fixes: b112889c5af8 ("iwlwifi: mvm: add Aux ROC request/response flow")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    |  5 +++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  1 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 15 +++++++++------
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9ac04c1..8c17b94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1356,6 +1356,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_UCODE_DOWN);
 	PRINT_MVM_REF(IWL_MVM_REF_SCAN);
 	PRINT_MVM_REF(IWL_MVM_REF_ROC);
+	PRINT_MVM_REF(IWL_MVM_REF_ROC_AUX);
 	PRINT_MVM_REF(IWL_MVM_REF_P2P_CLIENT);
 	PRINT_MVM_REF(IWL_MVM_REF_AP_IBSS);
 	PRINT_MVM_REF(IWL_MVM_REF_USER);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c131ce6..ccbe575 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1410,7 +1410,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 * The work item could be running or queued if the
 	 * ROC time event stops just as we get here.
 	 */
-	cancel_work_sync(&mvm->roc_done_wk);
+	flush_work(&mvm->roc_done_wk);
 
 	iwl_trans_stop_device(mvm->trans);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6d33234..dde83ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -276,6 +276,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_UCODE_DOWN,
 	IWL_MVM_REF_SCAN,
 	IWL_MVM_REF_ROC,
+	IWL_MVM_REF_ROC_AUX,
 	IWL_MVM_REF_P2P_CLIENT,
 	IWL_MVM_REF_AP_IBSS,
 	IWL_MVM_REF_USER,
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index fd7b0d3..a7448cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -108,12 +108,14 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	 * in the case that the time event actually completed in the firmware
 	 * (which is handled in iwl_mvm_te_handle_notif).
 	 */
-	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status))
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status)) {
 		queues |= BIT(IWL_MVM_OFFCHANNEL_QUEUE);
-	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
+		iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
+	}
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status)) {
 		queues |= BIT(mvm->aux_queue);
-
-	iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_ROC_AUX);
+	}
 
 	synchronize_net();
 
@@ -393,6 +395,7 @@ static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 	} else if (le32_to_cpu(notif->action) == TE_V2_NOTIF_HOST_EVENT_START) {
 		set_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status);
 		te_data->running = true;
+		iwl_mvm_ref(mvm, IWL_MVM_REF_ROC_AUX);
 		ieee80211_ready_on_channel(mvm->hw); /* Start TE */
 	} else {
 		IWL_DEBUG_TE(mvm,
-- 
2.1.4

