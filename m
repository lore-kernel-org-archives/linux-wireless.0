Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161428Ab2COU2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:02 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/26] iwlwifi: extend notification wait
Date: Thu, 15 Mar 2012 13:26:44 -0700
Message-Id: <1331843226-29860-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212814_929480_AD12AB4D)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes, for example when we ask the uCode
for calibration, we wait for the "complete"
response while we also need the results that
are sent in other, interim, notifications.

Currently we handle this by installing an RX
handler globally, but that isn't needed as
this is the only time we want to use these
notifications.

So in order to be able to simplify at least
future code that does the same, extend the
notification wait framework to allow you to
wait for multiple commands and decide based
on the command whether the wait finished.

While at it, also fix a race that can then
become relevant -- if the wait function has
returned true once it shouldn't be called
again, today this can happen due to races
between the triggering and the wakeup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c |   44 ++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h |   21 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c   |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |   20 +++++++----
 5 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 3690907..8125f4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -59,9 +59,12 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	__le32 old_filter = send->filter_flags;
 	u8 old_dev_type = send->dev_type;
 	int ret;
+	static const u8 deactivate_cmd[] = {
+		REPLY_WIPAN_DEACTIVATION_COMPLETE
+	};
 
 	iwl_init_notification_wait(&priv->notif_wait, &disable_wait,
-				   REPLY_WIPAN_DEACTIVATION_COMPLETE,
+				   deactivate_cmd, ARRAY_SIZE(deactivate_cmd),
 				   NULL, NULL);
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
index 88dc4a0..0066b89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -75,21 +75,45 @@ void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_wait)
 void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 				  struct iwl_rx_packet *pkt)
 {
+	bool triggered = false;
+
 	if (!list_empty(&notif_wait->notif_waits)) {
 		struct iwl_notification_wait *w;
 
 		spin_lock(&notif_wait->notif_wait_lock);
 		list_for_each_entry(w, &notif_wait->notif_waits, list) {
-			if (w->cmd != pkt->hdr.cmd)
+			int i;
+			bool found = false;
+
+			/*
+			 * If it already finished (triggered) or has been
+			 * aborted then don't evaluate it again to avoid races,
+			 * Otherwise the function could be called again even
+			 * though it returned true before
+			 */
+			if (w->triggered || w->aborted)
+				continue;
+
+			for (i = 0; i < w->n_cmds; i++) {
+				if (w->cmds[i] == pkt->hdr.cmd) {
+					found = true;
+					break;
+				}
+			}
+			if (!found)
 				continue;
-			w->triggered = true;
-			if (w->fn)
-				w->fn(notif_wait, pkt, w->fn_data);
+
+			if (!w->fn || w->fn(notif_wait, pkt, w->fn_data)) {
+				w->triggered = true;
+				triggered = true;
+			}
 		}
 		spin_unlock(&notif_wait->notif_wait_lock);
 
-		wake_up_all(&notif_wait->notif_waitq);
 	}
+
+	if (triggered)
+		wake_up_all(&notif_wait->notif_waitq);
 }
 
 void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
@@ -109,14 +133,18 @@ void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_wait)
 void
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
 			   struct iwl_notification_wait *wait_entry,
-			   u8 cmd,
-			   void (*fn)(struct iwl_notif_wait_data *notif_wait,
+			   const u8 *cmds, int n_cmds,
+			   bool (*fn)(struct iwl_notif_wait_data *notif_wait,
 				      struct iwl_rx_packet *pkt, void *data),
 			   void *fn_data)
 {
+	if (WARN_ON(n_cmds > MAX_NOTIF_CMDS))
+		n_cmds = MAX_NOTIF_CMDS;
+
 	wait_entry->fn = fn;
 	wait_entry->fn_data = fn_data;
-	wait_entry->cmd = cmd;
+	wait_entry->n_cmds = n_cmds;
+	memcpy(wait_entry->cmds, cmds, n_cmds);
 	wait_entry->triggered = false;
 	wait_entry->aborted = false;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
index 5e8af95..8215231 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
@@ -72,11 +72,19 @@ struct iwl_notif_wait_data {
 	wait_queue_head_t notif_waitq;
 };
 
+#define MAX_NOTIF_CMDS	5
+
 /**
  * struct iwl_notification_wait - notification wait entry
  * @list: list head for global list
- * @fn: function called with the notification
- * @cmd: command ID
+ * @fn: Function called with the notification. If the function
+ *	returns true, the wait is over, if it returns false then
+ *	the waiter stays blocked. If no function is given, any
+ *	of the listed commands will unblock the waiter.
+ * @cmds: command IDs
+ * @n_cmds: number of command IDs
+ * @triggered: waiter should be woken up
+ * @aborted: wait was aborted
  *
  * This structure is not used directly, to wait for a
  * notification declare it on the stack, and call
@@ -93,11 +101,12 @@ struct iwl_notif_wait_data {
 struct iwl_notification_wait {
 	struct list_head list;
 
-	void (*fn)(struct iwl_notif_wait_data *notif_data,
+	bool (*fn)(struct iwl_notif_wait_data *notif_data,
 		   struct iwl_rx_packet *pkt, void *data);
 	void *fn_data;
 
-	u8 cmd;
+	u8 cmds[MAX_NOTIF_CMDS];
+	u8 n_cmds;
 	bool triggered, aborted;
 };
 
@@ -112,8 +121,8 @@ void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_data);
 void __acquires(wait_entry)
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_data,
 			   struct iwl_notification_wait *wait_entry,
-			   u8 cmd,
-			   void (*fn)(struct iwl_notif_wait_data *notif_data,
+			   const u8 *cmds, int n_cmds,
+			   bool (*fn)(struct iwl_notif_wait_data *notif_data,
 				      struct iwl_rx_packet *pkt, void *data),
 			   void *fn_data);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 76f7f92..645b850 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -420,10 +420,13 @@ nla_put_failure:
 static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
+	static const u8 calib_complete[] = {
+		CALIBRATION_COMPLETE_NOTIFICATION
+	};
 	int ret;
 
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
-				   CALIBRATION_COMPLETE_NOTIFICATION,
+				   calib_complete, ARRAY_SIZE(calib_complete),
 				   NULL, NULL);
 	ret = iwl_init_alive_start(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 2528287..44b0e72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -417,9 +417,8 @@ struct iwl_alive_data {
 	u8 subtype;
 };
 
-static void iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
-			    struct iwl_rx_packet *pkt,
-			    void *data)
+static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
+			 struct iwl_rx_packet *pkt, void *data)
 {
 	struct iwl_priv *priv =
 		container_of(notif_wait, struct iwl_priv, notif_wait);
@@ -440,6 +439,8 @@ static void iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 
 	alive_data->subtype = palive->ver_subtype;
 	alive_data->valid = palive->is_valid == UCODE_VALID_OK;
+
+	return true;
 }
 
 #define UCODE_ALIVE_TIMEOUT	HZ
@@ -453,6 +454,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	const struct fw_img *fw;
 	int ret;
 	enum iwl_ucode_type old_type;
+	static const u8 alive_cmd[] = { REPLY_ALIVE };
 
 	old_type = priv->shrd->ucode_type;
 	priv->shrd->ucode_type = ucode_type;
@@ -463,8 +465,9 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (!fw)
 		return -EINVAL;
 
-	iwl_init_notification_wait(&priv->notif_wait, &alive_wait, REPLY_ALIVE,
-				      iwl_alive_fn, &alive_data);
+	iwl_init_notification_wait(&priv->notif_wait, &alive_wait,
+				   alive_cmd, ARRAY_SIZE(alive_cmd),
+				   iwl_alive_fn, &alive_data);
 
 	ret = iwl_trans_start_fw(trans(priv), fw);
 	if (ret) {
@@ -522,6 +525,9 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 int iwl_run_init_ucode(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
+	static const u8 calib_complete[] = {
+		CALIBRATION_COMPLETE_NOTIFICATION
+	};
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
@@ -534,8 +540,8 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 		return 0;
 
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
-				      CALIBRATION_COMPLETE_NOTIFICATION,
-				      NULL, NULL);
+				   calib_complete, ARRAY_SIZE(calib_complete),
+				   NULL, NULL);
 
 	/* Will also start the device */
 	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_INIT);
-- 
1.7.0.4

