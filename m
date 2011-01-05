Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1AEAbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlagn: add support for waiting for notifications
Date: Tue,  4 Jan 2011 16:22:00 -0800
Message-Id: <1294186923-4582-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to implement waiting for notifications,
add a structure that captures the information,
and a list of such structures that will be
traversed when a command is received from the
ucode.

Use sparse checking to make sure calls to the
prepare/wait/cancel functions are always nested
correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   46 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   21 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |   15 +++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   33 ++++++++++++++++++++
 4 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3dee87e..29dcda0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -473,6 +473,11 @@ void iwlagn_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
 					iwlagn_rx_calib_complete;
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
+
+	/* set up notification wait support */
+	spin_lock_init(&priv->_agn.notif_wait_lock);
+	INIT_LIST_HEAD(&priv->_agn.notif_waits);
+	init_waitqueue_head(&priv->_agn.notif_waitq);
 }
 
 void iwlagn_setup_deferred_work(struct iwl_priv *priv)
@@ -2389,3 +2394,44 @@ int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display)
 	}
 	return 0;
 }
+
+/* notification wait support */
+void iwlagn_init_notification_wait(struct iwl_priv *priv,
+				   struct iwl_notification_wait *wait_entry,
+				   void (*fn)(struct iwl_priv *priv,
+					      struct iwl_rx_packet *pkt),
+				   u8 cmd)
+{
+	wait_entry->fn = fn;
+	wait_entry->cmd = cmd;
+	wait_entry->triggered = false;
+
+	spin_lock_bh(&priv->_agn.notif_wait_lock);
+	list_add(&wait_entry->list, &priv->_agn.notif_waits);
+	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+}
+
+signed long iwlagn_wait_notification(struct iwl_priv *priv,
+				     struct iwl_notification_wait *wait_entry,
+				     unsigned long timeout)
+{
+	int ret;
+
+	ret = wait_event_timeout(priv->_agn.notif_waitq,
+				 &wait_entry->triggered,
+				 timeout);
+
+	spin_lock_bh(&priv->_agn.notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+
+	return ret;
+}
+
+void iwlagn_remove_notification(struct iwl_priv *priv,
+				struct iwl_notification_wait *wait_entry)
+{
+	spin_lock_bh(&priv->_agn.notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&priv->_agn.notif_wait_lock);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bd7ae27..9ac87da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -910,6 +910,27 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
+		/*
+		 * Do the notification wait before RX handlers so
+		 * even if the RX handler consumes the RXB we have
+		 * access to it in the notification wait entry.
+		 */
+		if (!list_empty(&priv->_agn.notif_waits)) {
+			struct iwl_notification_wait *w;
+
+			spin_lock(&priv->_agn.notif_wait_lock);
+			list_for_each_entry(w, &priv->_agn.notif_waits, list) {
+				if (w->cmd == pkt->hdr.cmd) {
+					w->triggered = true;
+					if (w->fn)
+						w->fn(priv, pkt);
+				}
+			}
+			spin_unlock(&priv->_agn.notif_wait_lock);
+
+			wake_up_all(&priv->_agn.notif_waitq);
+		}
+
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index e725784..7b6cb83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -329,6 +329,21 @@ void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
+/* notification wait support */
+void __acquires(wait_entry)
+iwlagn_init_notification_wait(struct iwl_priv *priv,
+			      struct iwl_notification_wait *wait_entry,
+			      void (*fn)(struct iwl_priv *priv,
+					 struct iwl_rx_packet *pkt),
+			      u8 cmd);
+signed long __releases(wait_entry)
+iwlagn_wait_notification(struct iwl_priv *priv,
+			 struct iwl_notification_wait *wait_entry,
+			 unsigned long timeout);
+void __releases(wait_entry)
+iwlagn_remove_notification(struct iwl_priv *priv,
+			   struct iwl_notification_wait *wait_entry);
+
 /* mac80211 handlers (for 4965) */
 int iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwlagn_mac_start(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8dda678..2ec680b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -34,6 +34,7 @@
 
 #include <linux/pci.h> /* for struct pci_device_id */
 #include <linux/kernel.h>
+#include <linux/wait.h>
 #include <net/ieee80211_radiotap.h>
 
 #include "iwl-eeprom.h"
@@ -1139,6 +1140,33 @@ struct iwl_force_reset {
  */
 #define IWLAGN_EXT_BEACON_TIME_POS	22
 
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
+	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt);
+
+	u8 cmd;
+	bool triggered;
+};
+
 enum iwl_rxon_context_id {
 	IWL_RXON_CTX_BSS,
 	IWL_RXON_CTX_PAN,
@@ -1463,6 +1491,11 @@ struct iwl_priv {
 			struct iwl_bt_notif_statistics delta_statistics_bt;
 			struct iwl_bt_notif_statistics max_delta_bt;
 #endif
+
+			/* notification wait support */
+			struct list_head notif_waits;
+			spinlock_t notif_wait_lock;
+			wait_queue_head_t notif_waitq;
 		} _agn;
 #endif
 	};
-- 
1.7.0.4

