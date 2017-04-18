Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52904 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755063AbdDRWWs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:24 +0300
Message-Id: <20170418221729.28372-21-luca@coelho.fi> (sfid-20170419_002251_903294_32F2B521)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: split the handler and the wake parts of the notification infra
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The notification infrastructure (iwl_notification_wait_*
functions) allows to wait until a list of notifications
will come up from the firmware and to run a special handler
(notif_wait handler) when those are received.

The operation mode notifies the notification infrastructure
about any Rx being received by the mean of
iwl_notification_wait_notify() which will do two things:
1) call the notif_wait handler
2) wakeup the thread that was waiting for the notification

Typically, only after those two steps happened, the
operation mode will run its own handler for the notification
that was received from the firmware. This means that the
thread that was waiting for that notification can be
running before the operation mode's handler was called.

When the operation mode's handler is ASYNC, things get even
worse since the thread that was waiting for the
notification isn't even guaranteed that the ASYNC callback
was added to async_handlers_list before it starts to run.
This means that even calling
iwl_mvm_wait_for_async_handlers() can't guarantee that
absolutely everything related to that notification has run.
The following can happen:

Thread sending the command        Operation mode's Rx path
--------------------------        ------------------------
iwl_init_notification_wait()
iwl_mvm_send_cmd()
                                  iwl_mvm_rx_common()
                                  iwl_notification_wait_notify()
iwl_mvm_wait_for_async_handlers()
// Possibly free some data
// structure
                                  list_add_tail(async_handlers_list);
                                  schedule_work(async_handlers_wk);
                                  // Access the freed structure

Split the 'run notif_wait's handler' and the 'wake up the
thread' parts to fix this. This allows the operation mode
to do the following:

Thread sending the command        Operation mode's Rx path
--------------------------        ------------------------
iwl_init_notification_wait()
iwl_mvm_send_cmd()
                                  iwl_mvm_rx_common()
                                  iwl_notification_wait()
                                  // Will run the notif_wait's handler
                                  list_add_tail(async_handlers_list);
                                  schedule_work(async_handlers_wk);
                                  iwl_notification_notify()
iwl_mvm_wait_for_async_handlers()

This way, the waiter is guaranteed that all the handlers
have been run (if SYNC), or at least enqueued (if ASYNC)
by the time it wakes up.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.c    | 10 ++++-----
 .../net/wireless/intel/iwlwifi/iwl-notif-wait.h    | 25 +++++++++++++++++-----
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
index 88f260db3744..68412ff2112e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
@@ -76,8 +76,8 @@ void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_wait)
 }
 IWL_EXPORT_SYMBOL(iwl_notification_wait_init);
 
-void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
-				  struct iwl_rx_packet *pkt)
+bool iwl_notification_wait(struct iwl_notif_wait_data *notif_wait,
+			   struct iwl_rx_packet *pkt)
 {
 	bool triggered = false;
 
@@ -118,13 +118,11 @@ void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 			}
 		}
 		spin_unlock(&notif_wait->notif_wait_lock);
-
 	}
 
-	if (triggered)
-		wake_up_all(&notif_wait->notif_waitq);
+	return triggered;
 }
-IWL_EXPORT_SYMBOL(iwl_notification_wait_notify);
+IWL_EXPORT_SYMBOL(iwl_notification_wait);
 
 void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
index 0f9995ed71cd..368884be4e7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
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
@@ -89,10 +90,10 @@ struct iwl_notif_wait_data {
  *
  * This structure is not used directly, to wait for a
  * notification declare it on the stack, and call
- * iwlagn_init_notification_wait() with appropriate
+ * iwl_init_notification_wait() with appropriate
  * parameters. Then do whatever will cause the ucode
  * to notify the driver, and to wait for that then
- * call iwlagn_wait_notification().
+ * call iwl_wait_notification().
  *
  * Each notification is one-shot. If at some point we
  * need to support multi-shot notifications (which
@@ -114,10 +115,24 @@ struct iwl_notification_wait {
 
 /* caller functions */
 void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_data);
-void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_data,
-				  struct iwl_rx_packet *pkt);
+bool iwl_notification_wait(struct iwl_notif_wait_data *notif_data,
+			   struct iwl_rx_packet *pkt);
 void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_data);
 
+static inline void
+iwl_notification_notify(struct iwl_notif_wait_data *notif_data)
+{
+	wake_up_all(&notif_data->notif_waitq);
+}
+
+static inline void
+iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_data,
+			     struct iwl_rx_packet *pkt)
+{
+	if (iwl_notification_wait(notif_data, pkt))
+		iwl_notification_notify(notif_data);
+}
+
 /* user functions */
 void __acquires(wait_entry)
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_data,
-- 
2.11.0
