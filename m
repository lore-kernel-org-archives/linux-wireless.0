Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031500Ab2CFWni (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 23/33] iwlwifi: abstract out notification wait support
Date: Tue,  6 Mar 2012 13:30:58 -0800
Message-Id: <1331069468-11074-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234356_282714_5D376568)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will be sharable, but needs to live in the
op_mode as it is dependent on command processing.
Make a library out of the notification wait code.

Since I wrote all of the code originally and only
Intel employees changed it, we can also relicense
it to dual BSD/GPL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |   24 +----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |   11 +-
 drivers/net/wireless/iwlwifi/iwl-core.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    3 +
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c |  157 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h |  130 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h     |   55 ---------
 drivers/net/wireless/iwlwifi/iwl-testmode.c   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |   81 ++-----------
 10 files changed, 314 insertions(+), 160 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-notif-wait.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-notif-wait.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f2a903d..85d163e 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,6 +14,7 @@ iwlwifi-objs		+= iwl-1000.o
 iwlwifi-objs		+= iwl-2000.o
 iwlwifi-objs		+= iwl-pci.o
 iwlwifi-objs		+= iwl-drv.o
+iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 5c9c88b..f17142b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1142,9 +1142,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
 
 	/* set up notification wait support */
-	spin_lock_init(&priv->shrd->notif_wait_lock);
-	INIT_LIST_HEAD(&priv->shrd->notif_waits);
-	init_waitqueue_head(&priv->shrd->notif_waitq);
+	iwl_notification_wait_init(&priv->notif_wait);
 
 	/* Set up BT Rx handlers */
 	if (cfg(priv)->lib->bt_rx_handler_setup)
@@ -1164,25 +1162,7 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	 * even if the RX handler consumes the RXB we have
 	 * access to it in the notification wait entry.
 	 */
-	if (!list_empty(&priv->shrd->notif_waits)) {
-		struct iwl_notification_wait *w;
-
-		spin_lock(&priv->shrd->notif_wait_lock);
-		list_for_each_entry(w, &priv->shrd->notif_waits, list) {
-			if (w->cmd != pkt->hdr.cmd)
-				continue;
-			IWL_DEBUG_RX(priv,
-				"Notif: %s, 0x%02x - wake the callers up\n",
-				get_cmd_string(pkt->hdr.cmd),
-				pkt->hdr.cmd);
-			w->triggered = true;
-			if (w->fn)
-				w->fn(priv, pkt, w->fn_data);
-		}
-		spin_unlock(&priv->shrd->notif_wait_lock);
-
-		wake_up_all(&priv->shrd->notif_waitq);
-	}
+	iwl_notification_wait_notify(&priv->notif_wait, pkt);
 
 	if (priv->pre_rx_handler &&
 	    priv->shrd->ucode_owner == IWL_OWNERSHIP_TM)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index e191d39..9d955fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -60,9 +60,9 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	u8 old_dev_type = send->dev_type;
 	int ret;
 
-	iwl_init_notification_wait(priv->shrd, &disable_wait,
-				      REPLY_WIPAN_DEACTIVATION_COMPLETE,
-				      NULL, NULL);
+	iwl_init_notification_wait(&priv->notif_wait, &disable_wait,
+				   REPLY_WIPAN_DEACTIVATION_COMPLETE,
+				   NULL, NULL);
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
@@ -74,9 +74,10 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	if (ret) {
 		IWL_ERR(priv, "Error disabling PAN (%d)\n", ret);
-		iwl_remove_notification(priv->shrd, &disable_wait);
+		iwl_remove_notification(&priv->notif_wait, &disable_wait);
 	} else {
-		ret = iwl_wait_notification(priv->shrd, &disable_wait, HZ);
+		ret = iwl_wait_notification(&priv->notif_wait,
+					    &disable_wait, HZ);
 		if (ret)
 			IWL_ERR(priv, "Timed out waiting for PAN disable\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 71c5621..c60c4a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -845,7 +845,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 
-	iwl_abort_notification_waits(priv->shrd);
+	iwl_abort_notification_waits(&priv->notif_wait);
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the ready bit */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0c397fd..c57e605 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -51,6 +51,7 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-op-mode.h"
+#include "iwl-notif-wait.h"
 
 struct iwl_tx_queue;
 
@@ -739,6 +740,8 @@ struct iwl_priv {
 				       struct iwl_rx_cmd_buffer *rxb,
 				       struct iwl_device_cmd *cmd);
 
+	struct iwl_notif_wait_data notif_wait;
+
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
 	/* spectrum measurement report caching */
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
new file mode 100644
index 0000000..88dc4a0
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -0,0 +1,157 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#include <linux/sched.h>
+
+#include "iwl-notif-wait.h"
+
+
+void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_wait)
+{
+	spin_lock_init(&notif_wait->notif_wait_lock);
+	INIT_LIST_HEAD(&notif_wait->notif_waits);
+	init_waitqueue_head(&notif_wait->notif_waitq);
+}
+
+void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
+				  struct iwl_rx_packet *pkt)
+{
+	if (!list_empty(&notif_wait->notif_waits)) {
+		struct iwl_notification_wait *w;
+
+		spin_lock(&notif_wait->notif_wait_lock);
+		list_for_each_entry(w, &notif_wait->notif_waits, list) {
+			if (w->cmd != pkt->hdr.cmd)
+				continue;
+			w->triggered = true;
+			if (w->fn)
+				w->fn(notif_wait, pkt, w->fn_data);
+		}
+		spin_unlock(&notif_wait->notif_wait_lock);
+
+		wake_up_all(&notif_wait->notif_waitq);
+	}
+}
+
+void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
+{
+	unsigned long flags;
+	struct iwl_notification_wait *wait_entry;
+
+	spin_lock_irqsave(&notif_wait->notif_wait_lock, flags);
+	list_for_each_entry(wait_entry, &notif_wait->notif_waits, list)
+		wait_entry->aborted = true;
+	spin_unlock_irqrestore(&notif_wait->notif_wait_lock, flags);
+
+	wake_up_all(&notif_wait->notif_waitq);
+}
+
+
+void
+iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
+			   struct iwl_notification_wait *wait_entry,
+			   u8 cmd,
+			   void (*fn)(struct iwl_notif_wait_data *notif_wait,
+				      struct iwl_rx_packet *pkt, void *data),
+			   void *fn_data)
+{
+	wait_entry->fn = fn;
+	wait_entry->fn_data = fn_data;
+	wait_entry->cmd = cmd;
+	wait_entry->triggered = false;
+	wait_entry->aborted = false;
+
+	spin_lock_bh(&notif_wait->notif_wait_lock);
+	list_add(&wait_entry->list, &notif_wait->notif_waits);
+	spin_unlock_bh(&notif_wait->notif_wait_lock);
+}
+
+int iwl_wait_notification(struct iwl_notif_wait_data *notif_wait,
+			  struct iwl_notification_wait *wait_entry,
+			  unsigned long timeout)
+{
+	int ret;
+
+	ret = wait_event_timeout(notif_wait->notif_waitq,
+				 wait_entry->triggered || wait_entry->aborted,
+				 timeout);
+
+	spin_lock_bh(&notif_wait->notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&notif_wait->notif_wait_lock);
+
+	if (wait_entry->aborted)
+		return -EIO;
+
+	/* return value is always >= 0 */
+	if (ret <= 0)
+		return -ETIMEDOUT;
+	return 0;
+}
+
+void iwl_remove_notification(struct iwl_notif_wait_data *notif_wait,
+			     struct iwl_notification_wait *wait_entry)
+{
+	spin_lock_bh(&notif_wait->notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&notif_wait->notif_wait_lock);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
new file mode 100644
index 0000000..419f1ad
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
@@ -0,0 +1,130 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_notif_wait_h__
+#define __iwl_notif_wait_h__
+
+#include <linux/wait.h>
+
+/* TODO: remove later */
+#include "iwl-commands.h"
+
+struct iwl_notif_wait_data {
+	struct list_head notif_waits;
+	spinlock_t notif_wait_lock;
+	wait_queue_head_t notif_waitq;
+};
+
+/**
+ * struct iwl_notification_wait - notification wait entry
+ * @list: list head for global list
+ * @fn: function called with the notification
+ * @cmd: command ID
+ *
+ * This structure is not used directly, to wait for a
+ * notification declare it on the stack, and call
+ * iwlagn_init_notification_wait() with appropriate
+ * parameters. Then do whatever will cause the ucode
+ * to notify the driver, and to wait for that then
+ * call iwlagn_wait_notification().
+ *
+ * Each notification is one-shot. If at some point we
+ * need to support multi-shot notifications (which
+ * can't be allocated on the stack) we need to modify
+ * the code for them.
+ */
+struct iwl_notification_wait {
+	struct list_head list;
+
+	void (*fn)(struct iwl_notif_wait_data *notif_data,
+		   struct iwl_rx_packet *pkt, void *data);
+	void *fn_data;
+
+	u8 cmd;
+	bool triggered, aborted;
+};
+
+
+/* caller functions */
+void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_data);
+void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_data,
+				  struct iwl_rx_packet *pkt);
+void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_data);
+
+/* user functions */
+void __acquires(wait_entry)
+iwl_init_notification_wait(struct iwl_notif_wait_data *notif_data,
+			   struct iwl_notification_wait *wait_entry,
+			   u8 cmd,
+			   void (*fn)(struct iwl_notif_wait_data *notif_data,
+				      struct iwl_rx_packet *pkt, void *data),
+			   void *fn_data);
+
+int __must_check __releases(wait_entry)
+iwl_wait_notification(struct iwl_notif_wait_data *notif_data,
+		      struct iwl_notification_wait *wait_entry,
+		      unsigned long timeout);
+
+void __releases(wait_entry)
+iwl_remove_notification(struct iwl_notif_wait_data *notif_data,
+			struct iwl_notification_wait *wait_entry);
+
+#endif /* __iwl_notif_wait_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index e2bcc99..1ec5a22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -210,35 +210,6 @@ enum iwl_ucode_type {
 };
 
 /**
- * struct iwl_notification_wait - notification wait entry
- * @list: list head for global list
- * @fn: function called with the notification
- * @cmd: command ID
- *
- * This structure is not used directly, to wait for a
- * notification declare it on the stack, and call
- * iwlagn_init_notification_wait() with appropriate
- * parameters. Then do whatever will cause the ucode
- * to notify the driver, and to wait for that then
- * call iwlagn_wait_notification().
- *
- * Each notification is one-shot. If at some point we
- * need to support multi-shot notifications (which
- * can't be allocated on the stack) we need to modify
- * the code for them.
- */
-struct iwl_notification_wait {
-	struct list_head list;
-
-	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
-		   void *data);
-	void *fn_data;
-
-	u8 cmd;
-	bool triggered, aborted;
-};
-
-/**
  * enum iwl_pa_type - Power Amplifier type
  * @IWL_PA_SYSTEM:  based on uCode configuration
  * @IWL_PA_INTERNAL: use Internal only
@@ -398,9 +369,6 @@ struct iwl_cfg {
  * @wait_command_queue: the wait_queue for SYNC host command nad uCode load
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
- * @notif_waits: things waiting for notification
- * @notif_wait_lock: lock protecting notification
- * @notif_waitq: head of notification wait queue
  * @device_pointers: pointers to ucode event tables
  */
 struct iwl_shared {
@@ -426,11 +394,6 @@ struct iwl_shared {
 	/* ucode related variables */
 	enum iwl_ucode_type ucode_type;
 
-	/* notification wait support */
-	struct list_head notif_waits;
-	spinlock_t notif_wait_lock;
-	wait_queue_head_t notif_waitq;
-
 	struct {
 		u32 error_event_table;
 		u32 log_event_table;
@@ -460,24 +423,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_nic_config(struct iwl_priv *priv);
 const char *get_cmd_string(u8 cmd);
 
-/* notification wait support */
-void iwl_abort_notification_waits(struct iwl_shared *shrd);
-void __acquires(wait_entry)
-iwl_init_notification_wait(struct iwl_shared *shrd,
-			   struct iwl_notification_wait *wait_entry,
-			   u8 cmd,
-			   void (*fn)(struct iwl_priv *priv,
-				      struct iwl_rx_packet *pkt,
-				      void *data),
-			   void *fn_data);
-int __must_check __releases(wait_entry)
-iwl_wait_notification(struct iwl_shared *shrd,
-			 struct iwl_notification_wait *wait_entry,
-			 unsigned long timeout);
-void __releases(wait_entry)
-iwl_remove_notification(struct iwl_shared *shrd,
-			   struct iwl_notification_wait *wait_entry);
-
 #define IWL_CMD(x) case x: return #x
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 095d71d..cc049d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -418,23 +418,23 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	iwl_init_notification_wait(priv->shrd, &calib_wait,
-				      CALIBRATION_COMPLETE_NOTIFICATION,
-				      NULL, NULL);
+	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
+				   CALIBRATION_COMPLETE_NOTIFICATION,
+				   NULL, NULL);
 	ret = iwl_init_alive_start(priv);
 	if (ret) {
 		IWL_ERR(priv, "Fail init calibration: %d\n", ret);
 		goto cfg_init_calib_error;
 	}
 
-	ret = iwl_wait_notification(priv->shrd, &calib_wait, 2 * HZ);
+	ret = iwl_wait_notification(&priv->notif_wait, &calib_wait, 2 * HZ);
 	if (ret)
 		IWL_ERR(priv, "Error detecting"
 			" CALIBRATION_COMPLETE_NOTIFICATION: %d\n", ret);
 	return ret;
 
 cfg_init_calib_error:
-	iwl_remove_notification(priv->shrd, &calib_wait);
+	iwl_remove_notification(&priv->notif_wait, &calib_wait);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 686d456..4d34327 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -29,7 +29,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/sched.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -434,10 +433,12 @@ struct iwl_alive_data {
 	u8 subtype;
 };
 
-static void iwl_alive_fn(struct iwl_priv *priv,
+static void iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 			    struct iwl_rx_packet *pkt,
 			    void *data)
 {
+	struct iwl_priv *priv =
+		container_of(notif_wait, struct iwl_priv, notif_wait);
 	struct iwl_alive_data *alive_data = data;
 	struct iwl_alive_resp *palive;
 
@@ -457,70 +458,6 @@ static void iwl_alive_fn(struct iwl_priv *priv,
 	alive_data->valid = palive->is_valid == UCODE_VALID_OK;
 }
 
-/* notification wait support */
-void iwl_init_notification_wait(struct iwl_shared *shrd,
-				struct iwl_notification_wait *wait_entry,
-				u8 cmd,
-				void (*fn)(struct iwl_priv *priv,
-					   struct iwl_rx_packet *pkt,
-					   void *data),
-				void *fn_data)
-{
-	wait_entry->fn = fn;
-	wait_entry->fn_data = fn_data;
-	wait_entry->cmd = cmd;
-	wait_entry->triggered = false;
-	wait_entry->aborted = false;
-
-	spin_lock_bh(&shrd->notif_wait_lock);
-	list_add(&wait_entry->list, &shrd->notif_waits);
-	spin_unlock_bh(&shrd->notif_wait_lock);
-}
-
-int iwl_wait_notification(struct iwl_shared *shrd,
-			     struct iwl_notification_wait *wait_entry,
-			     unsigned long timeout)
-{
-	int ret;
-
-	ret = wait_event_timeout(shrd->notif_waitq,
-				 wait_entry->triggered || wait_entry->aborted,
-				 timeout);
-
-	spin_lock_bh(&shrd->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&shrd->notif_wait_lock);
-
-	if (wait_entry->aborted)
-		return -EIO;
-
-	/* return value is always >= 0 */
-	if (ret <= 0)
-		return -ETIMEDOUT;
-	return 0;
-}
-
-void iwl_remove_notification(struct iwl_shared *shrd,
-				struct iwl_notification_wait *wait_entry)
-{
-	spin_lock_bh(&shrd->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&shrd->notif_wait_lock);
-}
-
-void iwl_abort_notification_waits(struct iwl_shared *shrd)
-{
-	unsigned long flags;
-	struct iwl_notification_wait *wait_entry;
-
-	spin_lock_irqsave(&shrd->notif_wait_lock, flags);
-	list_for_each_entry(wait_entry, &shrd->notif_waits, list)
-		wait_entry->aborted = true;
-	spin_unlock_irqrestore(&shrd->notif_wait_lock, flags);
-
-	wake_up_all(&shrd->notif_waitq);
-}
-
 #define UCODE_ALIVE_TIMEOUT	HZ
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
@@ -540,13 +477,13 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (!fw)
 		return -EINVAL;
 
-	iwl_init_notification_wait(priv->shrd, &alive_wait, REPLY_ALIVE,
+	iwl_init_notification_wait(&priv->notif_wait, &alive_wait, REPLY_ALIVE,
 				      iwl_alive_fn, &alive_data);
 
 	ret = iwl_trans_start_fw(trans(priv), fw);
 	if (ret) {
 		priv->shrd->ucode_type = old_type;
-		iwl_remove_notification(priv->shrd, &alive_wait);
+		iwl_remove_notification(&priv->notif_wait, &alive_wait);
 		return ret;
 	}
 
@@ -554,7 +491,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	 * Some things may run in the background now, but we
 	 * just wait for the ALIVE notification here.
 	 */
-	ret = iwl_wait_notification(priv->shrd, &alive_wait,
+	ret = iwl_wait_notification(&priv->notif_wait, &alive_wait,
 					UCODE_ALIVE_TIMEOUT);
 	if (ret) {
 		priv->shrd->ucode_type = old_type;
@@ -608,7 +545,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
-	iwl_init_notification_wait(priv->shrd, &calib_wait,
+	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
 
@@ -625,13 +562,13 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	 * Some things may run in the background now, but we
 	 * just wait for the calibration complete notification.
 	 */
-	ret = iwl_wait_notification(priv->shrd, &calib_wait,
+	ret = iwl_wait_notification(&priv->notif_wait, &calib_wait,
 					UCODE_CALIB_TIMEOUT);
 
 	goto out;
 
  error:
-	iwl_remove_notification(priv->shrd, &calib_wait);
+	iwl_remove_notification(&priv->notif_wait, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
 	iwl_trans_stop_device(trans(priv));
-- 
1.7.0.4

