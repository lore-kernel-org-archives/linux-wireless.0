Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab1DVRzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlagn: leave notification waits on firmware errors
Date: Fri, 22 Apr 2011 10:33:15 -0700
Message-Id: <1303493598-10979-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the firmware encounters an error while the
driver is waiting for a notification, it will
never get that notification. Therefore, instead
of timing out, bail out on errors when waiting
for notifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.c    |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 +-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8284168..a29e2e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2266,6 +2266,7 @@ void iwlagn_init_notification_wait(struct iwl_priv *priv,
 	wait_entry->fn_data = fn_data;
 	wait_entry->cmd = cmd;
 	wait_entry->triggered = false;
+	wait_entry->aborted = false;
 
 	spin_lock_bh(&priv->_agn.notif_wait_lock);
 	list_add(&wait_entry->list, &priv->_agn.notif_waits);
@@ -2279,13 +2280,16 @@ int iwlagn_wait_notification(struct iwl_priv *priv,
 	int ret;
 
 	ret = wait_event_timeout(priv->_agn.notif_waitq,
-				 wait_entry->triggered,
+				 wait_entry->triggered || wait_entry->aborted,
 				 timeout);
 
 	spin_lock_bh(&priv->_agn.notif_wait_lock);
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 
+	if (wait_entry->aborted)
+		return -EIO;
+
 	/* return value is always >= 0 */
 	if (ret <= 0)
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 885167f..46d6965 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -867,6 +867,19 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
+static void iwlagn_abort_notification_waits(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl_notification_wait *wait_entry;
+
+	spin_lock_irqsave(&priv->_agn.notif_wait_lock, flags);
+	list_for_each_entry(wait_entry, &priv->_agn.notif_waits, list)
+		wait_entry->aborted = true;
+	spin_unlock_irqrestore(&priv->_agn.notif_wait_lock, flags);
+
+	wake_up_all(&priv->_agn.notif_waitq);
+}
+
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 {
 	unsigned int reload_msec;
@@ -878,6 +891,8 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
+	iwlagn_abort_notification_waits(priv);
+
 	/* Keep the restart process from trying to send host
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d8bf117..0345292 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1110,7 +1110,7 @@ struct iwl_notification_wait {
 	void *fn_data;
 
 	u8 cmd;
-	bool triggered;
+	bool triggered, aborted;
 };
 
 enum iwl_rxon_context_id {
-- 
1.7.0.4

