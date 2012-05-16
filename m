Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686Ab2EPUyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/9] iwlwifi: move notification wait into core
Date: Wed, 16 May 2012 22:54:28 +0200
Message-Id: <1337201670-21604-8-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225452_741942_61F6FD06)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code is a library to be used by multiple
opmodes, so move it into the iwlwifi module.

Reviewed-by: Donald H Fry <donald.h.fry@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f284ea8..9310027 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -7,7 +7,6 @@ iwldvm-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
 iwldvm-objs		+= iwl-eeprom.o iwl-power.o
 iwldvm-objs		+= iwl-scan.o iwl-led.o
 iwldvm-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
-iwldvm-objs		+= iwl-notif-wait.o
 
 iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwldvm-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
@@ -24,6 +23,7 @@ iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-pci.o
 iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
+iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
index 0066b89..5cfed29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -61,6 +61,7 @@
  *
  *****************************************************************************/
 #include <linux/sched.h>
+#include <linux/export.h>
 
 #include "iwl-notif-wait.h"
 
@@ -71,6 +72,7 @@ void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_wait)
 	INIT_LIST_HEAD(&notif_wait->notif_waits);
 	init_waitqueue_head(&notif_wait->notif_waitq);
 }
+EXPORT_SYMBOL_GPL(iwl_notification_wait_init);
 
 void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 				  struct iwl_rx_packet *pkt)
@@ -115,6 +117,7 @@ void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 	if (triggered)
 		wake_up_all(&notif_wait->notif_waitq);
 }
+EXPORT_SYMBOL_GPL(iwl_notification_wait_notify);
 
 void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
 {
@@ -128,7 +131,7 @@ void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
 
 	wake_up_all(&notif_wait->notif_waitq);
 }
-
+EXPORT_SYMBOL_GPL(iwl_abort_notification_waits);
 
 void
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
@@ -152,6 +155,7 @@ iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
 	list_add(&wait_entry->list, &notif_wait->notif_waits);
 	spin_unlock_bh(&notif_wait->notif_wait_lock);
 }
+EXPORT_SYMBOL_GPL(iwl_init_notification_wait);
 
 int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
 			  struct iwl_notification_wait *wait_entry,
@@ -175,6 +179,7 @@ int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
 		return -ETIMEDOUT;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iwl_wait_notification);
 
 void iwl_remove_notification(struct iwl_notif_wait_data *notif_wait,
 			     struct iwl_notification_wait *wait_entry)
@@ -183,3 +188,4 @@ void iwl_remove_notification(struct iwl_notif_wait_data *notif_wait,
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&notif_wait->notif_wait_lock);
 }
+EXPORT_SYMBOL_GPL(iwl_remove_notification);
-- 
1.7.10

