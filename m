Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1LBRqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/16] iwlwifi: move ucode notification from iwl_priv to iwl_shared
Date: Fri,  2 Dec 2011 08:48:40 -0800
Message-Id: <1322844520-21149-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184631_580154_63087FC0)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the notification structures for ucode operations from the
iwl_priv structure to the iwl_shared structure, with associated
code changes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   51 -----------------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   16 ------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 +-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   33 -----------
 drivers/net/wireless/iwlwifi/iwl-shared.h   |   56 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   78 ++++++++++++++++++++++++--
 9 files changed, 143 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0bc9622..575d1bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -934,57 +934,6 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 	return ant;
 }
 
-/* notification wait support */
-void iwlagn_init_notification_wait(struct iwl_priv *priv,
-				   struct iwl_notification_wait *wait_entry,
-				   u8 cmd,
-				   void (*fn)(struct iwl_priv *priv,
-					      struct iwl_rx_packet *pkt,
-					      void *data),
-				   void *fn_data)
-{
-	wait_entry->fn = fn;
-	wait_entry->fn_data = fn_data;
-	wait_entry->cmd = cmd;
-	wait_entry->triggered = false;
-	wait_entry->aborted = false;
-
-	spin_lock_bh(&priv->notif_wait_lock);
-	list_add(&wait_entry->list, &priv->notif_waits);
-	spin_unlock_bh(&priv->notif_wait_lock);
-}
-
-int iwlagn_wait_notification(struct iwl_priv *priv,
-			     struct iwl_notification_wait *wait_entry,
-			     unsigned long timeout)
-{
-	int ret;
-
-	ret = wait_event_timeout(priv->notif_waitq,
-				 wait_entry->triggered || wait_entry->aborted,
-				 timeout);
-
-	spin_lock_bh(&priv->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&priv->notif_wait_lock);
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
-void iwlagn_remove_notification(struct iwl_priv *priv,
-				struct iwl_notification_wait *wait_entry)
-{
-	spin_lock_bh(&priv->notif_wait_lock);
-	list_del(&wait_entry->list);
-	spin_unlock_bh(&priv->notif_wait_lock);
-}
-
 #ifdef CONFIG_PM_SLEEP
 static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 087fd52..90c55ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1131,9 +1131,9 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_TX] = iwlagn_rx_reply_tx;
 
 	/* set up notification wait support */
-	spin_lock_init(&priv->notif_wait_lock);
-	INIT_LIST_HEAD(&priv->notif_waits);
-	init_waitqueue_head(&priv->notif_waitq);
+	spin_lock_init(&priv->shrd->notif_wait_lock);
+	INIT_LIST_HEAD(&priv->shrd->notif_waits);
+	init_waitqueue_head(&priv->shrd->notif_waitq);
 
 	/* Set up BT Rx handlers */
 	if (priv->cfg->lib->bt_rx_handler_setup)
@@ -1152,11 +1152,11 @@ int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	 * even if the RX handler consumes the RXB we have
 	 * access to it in the notification wait entry.
 	 */
-	if (!list_empty(&priv->notif_waits)) {
+	if (!list_empty(&priv->shrd->notif_waits)) {
 		struct iwl_notification_wait *w;
 
-		spin_lock(&priv->notif_wait_lock);
-		list_for_each_entry(w, &priv->notif_waits, list) {
+		spin_lock(&priv->shrd->notif_wait_lock);
+		list_for_each_entry(w, &priv->shrd->notif_waits, list) {
 			if (w->cmd != pkt->hdr.cmd)
 				continue;
 			IWL_DEBUG_RX(priv,
@@ -1167,9 +1167,9 @@ int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			if (w->fn)
 				w->fn(priv, pkt, w->fn_data);
 		}
-		spin_unlock(&priv->notif_wait_lock);
+		spin_unlock(&priv->shrd->notif_wait_lock);
 
-		wake_up_all(&priv->notif_waitq);
+		wake_up_all(&priv->shrd->notif_waitq);
 	}
 
 	if (priv->pre_rx_handler)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 00b3871..466e4ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -60,7 +60,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	u8 old_dev_type = send->dev_type;
 	int ret;
 
-	iwlagn_init_notification_wait(priv, &disable_wait,
+	iwl_init_notification_wait(priv->shrd, &disable_wait,
 				      REPLY_WIPAN_DEACTIVATION_COMPLETE,
 				      NULL, NULL);
 
@@ -74,9 +74,9 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 
 	if (ret) {
 		IWL_ERR(priv, "Error disabling PAN (%d)\n", ret);
-		iwlagn_remove_notification(priv, &disable_wait);
+		iwl_remove_notification(priv->shrd, &disable_wait);
 	} else {
-		ret = iwlagn_wait_notification(priv, &disable_wait, HZ);
+		ret = iwl_wait_notification(priv->shrd, &disable_wait, HZ);
 		if (ret)
 			IWL_ERR(priv, "Timed out waiting for PAN disable\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0db0a8f..f2f1070 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -356,22 +356,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv);
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 
-/* notification wait support */
-void __acquires(wait_entry)
-iwlagn_init_notification_wait(struct iwl_priv *priv,
-			      struct iwl_notification_wait *wait_entry,
-			      u8 cmd,
-			      void (*fn)(struct iwl_priv *priv,
-					 struct iwl_rx_packet *pkt,
-					 void *data),
-			      void *fn_data);
-int __must_check __releases(wait_entry)
-iwlagn_wait_notification(struct iwl_priv *priv,
-			 struct iwl_notification_wait *wait_entry,
-			 unsigned long timeout);
-void __releases(wait_entry)
-iwlagn_remove_notification(struct iwl_priv *priv,
-			   struct iwl_notification_wait *wait_entry);
 extern int iwlagn_init_alive_start(struct iwl_priv *priv);
 extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f9e9170..b320582 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -836,19 +836,6 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-static void iwlagn_abort_notification_waits(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	struct iwl_notification_wait *wait_entry;
-
-	spin_lock_irqsave(&priv->notif_wait_lock, flags);
-	list_for_each_entry(wait_entry, &priv->notif_waits, list)
-		wait_entry->aborted = true;
-	spin_unlock_irqrestore(&priv->notif_wait_lock, flags);
-
-	wake_up_all(&priv->notif_waitq);
-}
-
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 {
 	unsigned int reload_msec;
@@ -860,7 +847,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
 
-	iwlagn_abort_notification_waits(priv);
+	iwl_abort_notification_waits(priv->shrd);
 
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the ready bit */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0019a23..6f6a647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -689,35 +689,6 @@ struct iwl_force_reset {
  */
 #define IWLAGN_EXT_BEACON_TIME_POS	22
 
-/**
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
 struct iwl_rxon_context {
 	struct ieee80211_vif *vif;
 
@@ -992,10 +963,6 @@ struct iwl_priv {
 	/* counts reply_tx error */
 	struct reply_tx_error_statistics reply_tx_stats;
 	struct reply_agg_tx_error_statistics reply_agg_tx_stats;
-	/* notification wait support */
-	struct list_head notif_waits;
-	spinlock_t notif_wait_lock;
-	wait_queue_head_t notif_waitq;
 
 	/* remain-on-channel offload support */
 	struct ieee80211_channel *hw_roc_channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 70bb9b8..c23e26d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -274,6 +274,35 @@ enum iwl_ucode_type {
 };
 
 /**
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
+	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
+		   void *data);
+	void *fn_data;
+
+	u8 cmd;
+	bool triggered, aborted;
+};
+
+/**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
@@ -290,6 +319,10 @@ enum iwl_ucode_type {
  * @sta_lock: protects the station table.
  *	If lock and sta_lock are needed, lock must be acquired first.
  * @mutex:
+ * @ucode_type: indicator of loaded ucode image
+ * @notif_waits: things waiting for notification
+ * @notif_wait_lock: lock protecting notification
+ * @notif_waitq: head of notification wait queue
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -320,6 +353,11 @@ struct iwl_shared {
 
 	/* ucode related variables */
 	enum iwl_ucode_type ucode_type;
+
+	/* notification wait support */
+	struct list_head notif_waits;
+	spinlock_t notif_wait_lock;
+	wait_queue_head_t notif_waitq;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
@@ -463,6 +501,24 @@ bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 void iwl_stop_sw_queue(struct iwl_priv *priv, u8 ac);
 void iwl_wake_sw_queue(struct iwl_priv *priv, u8 ac);
 
+/* notification wait support */
+void iwl_abort_notification_waits(struct iwl_shared *shrd);
+void __acquires(wait_entry)
+iwl_init_notification_wait(struct iwl_shared *shrd,
+			      struct iwl_notification_wait *wait_entry,
+			      u8 cmd,
+			      void (*fn)(struct iwl_priv *priv,
+					 struct iwl_rx_packet *pkt,
+					 void *data),
+			      void *fn_data);
+int __must_check __releases(wait_entry)
+iwl_wait_notification(struct iwl_shared *shrd,
+			 struct iwl_notification_wait *wait_entry,
+			 unsigned long timeout);
+void __releases(wait_entry)
+iwl_remove_notification(struct iwl_shared *shrd,
+			   struct iwl_notification_wait *wait_entry);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_reset_traffic_log(struct iwl_priv *priv);
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index ed2a3d7..ff72dbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -373,7 +373,7 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	iwlagn_init_notification_wait(priv, &calib_wait,
+	iwl_init_notification_wait(priv->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
 	ret = iwlagn_init_alive_start(priv);
@@ -383,14 +383,14 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 		goto cfg_init_calib_error;
 	}
 
-	ret = iwlagn_wait_notification(priv, &calib_wait, 2 * HZ);
+	ret = iwl_wait_notification(priv->shrd, &calib_wait, 2 * HZ);
 	if (ret)
 		IWL_DEBUG_INFO(priv, "Error detecting"
 			" CALIBRATION_COMPLETE_NOTIFICATION: %d\n", ret);
 	return ret;
 
 cfg_init_calib_error:
-	iwlagn_remove_notification(priv, &calib_wait);
+	iwl_remove_notification(priv->shrd, &calib_wait);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 1b23b99..b365de4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -571,6 +571,70 @@ static void iwl_alive_fn(struct iwl_priv *priv,
 	alive_data->valid = palive->is_valid == UCODE_VALID_OK;
 }
 
+/* notification wait support */
+void iwl_init_notification_wait(struct iwl_shared *shrd,
+				   struct iwl_notification_wait *wait_entry,
+				   u8 cmd,
+				   void (*fn)(struct iwl_priv *priv,
+					      struct iwl_rx_packet *pkt,
+					      void *data),
+				   void *fn_data)
+{
+	wait_entry->fn = fn;
+	wait_entry->fn_data = fn_data;
+	wait_entry->cmd = cmd;
+	wait_entry->triggered = false;
+	wait_entry->aborted = false;
+
+	spin_lock_bh(&shrd->notif_wait_lock);
+	list_add(&wait_entry->list, &shrd->notif_waits);
+	spin_unlock_bh(&shrd->notif_wait_lock);
+}
+
+int iwl_wait_notification(struct iwl_shared *shrd,
+			     struct iwl_notification_wait *wait_entry,
+			     unsigned long timeout)
+{
+	int ret;
+
+	ret = wait_event_timeout(shrd->notif_waitq,
+				 wait_entry->triggered || wait_entry->aborted,
+				 timeout);
+
+	spin_lock_bh(&shrd->notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&shrd->notif_wait_lock);
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
+void iwl_remove_notification(struct iwl_shared *shrd,
+				struct iwl_notification_wait *wait_entry)
+{
+	spin_lock_bh(&shrd->notif_wait_lock);
+	list_del(&wait_entry->list);
+	spin_unlock_bh(&shrd->notif_wait_lock);
+}
+
+void iwl_abort_notification_waits(struct iwl_shared *shrd)
+{
+	unsigned long flags;
+	struct iwl_notification_wait *wait_entry;
+
+	spin_lock_irqsave(&shrd->notif_wait_lock, flags);
+	list_for_each_entry(wait_entry, &shrd->notif_waits, list)
+		wait_entry->aborted = true;
+	spin_unlock_irqrestore(&shrd->notif_wait_lock, flags);
+
+	wake_up_all(&shrd->notif_waitq);
+}
+
 #define UCODE_ALIVE_TIMEOUT	HZ
 #define UCODE_CALIB_TIMEOUT	(2*HZ)
 
@@ -587,7 +651,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (ret)
 		return ret;
 
-	iwlagn_init_notification_wait(priv, &alive_wait, REPLY_ALIVE,
+	iwl_init_notification_wait(trans->shrd, &alive_wait, REPLY_ALIVE,
 				      iwl_alive_fn, &alive_data);
 
 	old_type = trans->shrd->ucode_type;
@@ -596,7 +660,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	ret = iwl_load_given_ucode(trans, ucode_type);
 	if (ret) {
 		trans->shrd->ucode_type = old_type;
-		iwlagn_remove_notification(priv, &alive_wait);
+		iwl_remove_notification(trans->shrd, &alive_wait);
 		return ret;
 	}
 
@@ -606,7 +670,8 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	 * Some things may run in the background now, but we
 	 * just wait for the ALIVE notification here.
 	 */
-	ret = iwlagn_wait_notification(priv, &alive_wait, UCODE_ALIVE_TIMEOUT);
+	ret = iwl_wait_notification(trans->shrd, &alive_wait,
+					UCODE_ALIVE_TIMEOUT);
 	if (ret) {
 		trans->shrd->ucode_type = old_type;
 		return ret;
@@ -659,7 +724,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
-	iwlagn_init_notification_wait(priv, &calib_wait,
+	iwl_init_notification_wait(priv->shrd, &calib_wait,
 				      CALIBRATION_COMPLETE_NOTIFICATION,
 				      NULL, NULL);
 
@@ -676,12 +741,13 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	 * Some things may run in the background now, but we
 	 * just wait for the calibration complete notification.
 	 */
-	ret = iwlagn_wait_notification(priv, &calib_wait, UCODE_CALIB_TIMEOUT);
+	ret = iwl_wait_notification(priv->shrd, &calib_wait,
+					UCODE_CALIB_TIMEOUT);
 
 	goto out;
 
  error:
-	iwlagn_remove_notification(priv, &calib_wait);
+	iwl_remove_notification(priv->shrd, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
 	iwl_trans_stop_device(trans(priv));
-- 
1.7.0.4

