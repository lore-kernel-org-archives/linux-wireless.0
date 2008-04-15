Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYDOXCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:07 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/11] iwlwifi: remove the statistics work
Date: Tue, 15 Apr 2008 16:01:37 -0700
Message-Id: <1208300507-25628-2-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000224_920616_A41BA8CD)
In-Reply-To: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch does 3 things

1) It removes the statistics work. The request statistics command is
sent in ASYNC mode in this flow, the mutex is uneeded, so the request
statistics function can't go to sleep. No need for a workqueue anymore.

2) iwl4965_send_statistics_request has been renamed to
iwl_send_statistics_request and moved to iwl-core.c

3) A request for statistics is sent in alive_notify, the makes the uCode
sends statistics notification periodically starting from association.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   29 +++++---------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   12 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    9 +-------
 5 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a10a6e8..3df70f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -976,40 +976,21 @@ int iwl4965_hw_nic_reset(struct iwl_priv *priv)
 /**
  * iwl4965_bg_statistics_periodic - Timer callback to queue statistics
  *
- * This callback is provided in order to queue the statistics_work
- * in work_queue context (v. softirq)
+ * This callback is provided in order to send a statistics request.
  *
  * This timer function is continually reset to execute within
  * REG_RECALIB_PERIOD seconds since the last STATISTICS_NOTIFICATION
  * was received.  We need to ensure we receive the statistics in order
- * to update the temperature used for calibrating the TXPOWER.  However,
- * we can't send the statistics command from softirq context (which
- * is the context which timers run at) so we have to queue off the
- * statistics_work to actually send the command to the hardware.
+ * to update the temperature used for calibrating the TXPOWER.
  */
 static void iwl4965_bg_statistics_periodic(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 
-	queue_work(priv->workqueue, &priv->statistics_work);
-}
-
-/**
- * iwl4965_bg_statistics_work - Send the statistics request to the hardware.
- *
- * This is queued by iwl4965_bg_statistics_periodic.
- */
-static void iwl4965_bg_statistics_work(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     statistics_work);
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	mutex_lock(&priv->mutex);
-	iwl4965_send_statistics_request(priv);
-	mutex_unlock(&priv->mutex);
+	iwl_send_statistics_request(priv, CMD_ASYNC);
 }
 
 #define CT_LIMIT_CONST		259
@@ -2026,6 +2007,9 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* Ask for statistics now, the uCode will send statistics notification
+	 * periodically after association */
+	iwl_send_statistics_request(priv, CMD_ASYNC);
 	return ret;
 }
 
@@ -4903,7 +4887,6 @@ void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv)
 void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
-	INIT_WORK(&priv->statistics_work, iwl4965_bg_statistics_work);
 #ifdef CONFIG_IWL4965_SENSITIVITY
 	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index e5ab4c0..c8e73a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -638,7 +638,6 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					const u8 *dest, int left);
 extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl4965_rx_queue *q);
-extern int iwl4965_send_statistics_request(struct iwl_priv *priv);
 extern void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
@@ -1206,7 +1205,6 @@ struct iwl_priv {
 #ifdef CONFIG_IWL4965_SENSITIVITY
 	struct work_struct sensitivity_work;
 #endif
-	struct work_struct statistics_work;
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d8a226e..88d6246 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -277,3 +277,15 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwlcore_low_level_notify);
 
+int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
+{
+	u32 stat_flags = 0;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_STATISTICS_CMD,
+		.meta.flags = flags,
+		.len = sizeof(stat_flags),
+		.data = (u8 *) &stat_flags,
+	};
+	return iwl_send_cmd(priv, &cmd);
+}
+EXPORT_SYMBOL(iwl_send_statistics_request);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 23c21e3..aef1b48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -228,4 +228,6 @@ enum iwlcore_card_notify {
 
 int iwlcore_low_level_notify(struct iwl_priv *priv,
 			     enum iwlcore_card_notify notify);
+extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5ec0af4..42e519b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -596,13 +596,6 @@ static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 
 }
 
-int iwl4965_send_statistics_request(struct iwl_priv *priv)
-{
-	u32 flags = 0;
-	return iwl_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
-				      sizeof(flags), &flags);
-}
-
 /**
  * iwl4965_rxon_add_station - add station into station table.
  *
@@ -7530,7 +7523,7 @@ static ssize_t show_statistics(struct device *d,
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
-	rc = iwl4965_send_statistics_request(priv);
+	rc = iwl_send_statistics_request(priv, 0);
 	mutex_unlock(&priv->mutex);
 
 	if (rc) {
-- 
1.5.3.4

