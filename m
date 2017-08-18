Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44450 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751593AbdHRPtd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:49:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:01 +0300
Message-Id: <20170818154922.2904-4-luca@coelho.fi> (sfid-20170818_174942_252467_85ACB7FC)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 03/24] iwlwifi: call iwl_remove_notification from iwl_wait_notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_wait_notification() function removes the wait entry from the
list.  To make it clearer that it's doing the same thing as
iwl_remove_notification(), call the latter instead of having duplicate
code.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c | 25 +++++++++++-----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
index 29bb92e3df59..1096c945a68b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -161,6 +162,15 @@ iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
 }
 IWL_EXPORT_SYMBOL(iwl_init_notification_wait);
 
+void iwl_remove_notification(struct iwl_notif_wait_data *notif_wait,
+			     struct iwl_notification_wait *wait_entry)
+{
+	spin_lock_bh(&notif_wait->notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&notif_wait->notif_wait_lock);
+}
+IWL_EXPORT_SYMBOL(iwl_remove_notification);
+
 int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
 			  struct iwl_notification_wait *wait_entry,
 			  unsigned long timeout)
@@ -171,9 +181,7 @@ int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
 				 wait_entry->triggered || wait_entry->aborted,
 				 timeout);
 
-	spin_lock_bh(&notif_wait->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&notif_wait->notif_wait_lock);
+	iwl_remove_notification(notif_wait, wait_entry);
 
 	if (wait_entry->aborted)
 		return -EIO;
@@ -184,12 +192,3 @@ int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
 	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_wait_notification);
-
-void iwl_remove_notification(struct iwl_notif_wait_data *notif_wait,
-			     struct iwl_notification_wait *wait_entry)
-{
-	spin_lock_bh(&notif_wait->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&notif_wait->notif_wait_lock);
-}
-IWL_EXPORT_SYMBOL(iwl_remove_notification);
-- 
2.14.1
