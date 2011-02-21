Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1BUTV0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:21:26 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/4] iwlwifi: Limit number of firmware reload
Date: Mon, 21 Feb 2011 11:06:46 -0800
Message-Id: <1298315209-17986-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device has serious problem and cause firmware can not recover itself.
Keep reloading firmware will not help, it can only fill up the syslog and
lock up the system because busy reloading.

Introduce the limit reload counter, if the reload reach the maximum within
the pre-defined duration;stop the reload operation.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    9 +++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4ad8938..977ddfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -948,6 +948,9 @@ EXPORT_SYMBOL(iwl_print_rx_config_cmd);
  */
 void iwl_irq_handle_error(struct iwl_priv *priv)
 {
+	unsigned int reload_msec;
+	unsigned long reload_jiffies;
+
 	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
 
@@ -991,6 +994,25 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	 * commands by clearing the INIT status bit */
 	clear_bit(STATUS_READY, &priv->status);
 
+	/*
+	 * If firmware keep reloading, then it indicate something
+	 * serious wrong and firmware having problem to recover
+	 * from it. Instead of keep trying which will fill the syslog
+	 * and hang the system, let's just stop it
+	 */
+	reload_jiffies = jiffies;
+	reload_msec = jiffies_to_msecs((long) reload_jiffies -
+				(long) priv->reload_jiffies);
+	priv->reload_jiffies = reload_jiffies;
+	if (reload_msec <= IWL_MIN_RELOAD_DURATION) {
+		priv->reload_count++;
+		if (priv->reload_count >= IWL_MAX_CONTINUE_RELOAD_CNT) {
+			IWL_ERR(priv, "BUG_ON, Stop restarting\n");
+			return;
+		}
+	} else
+		priv->reload_count = 0;
+
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ecfbef4..065615e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1110,6 +1110,11 @@ struct iwl_event_log {
 /* BT Antenna Coupling Threshold (dB) */
 #define IWL_BT_ANTENNA_COUPLING_THRESHOLD	(35)
 
+/* Firmware reload counter and Timestamp */
+#define IWL_MIN_RELOAD_DURATION		1000 /* 1000 ms */
+#define IWL_MAX_CONTINUE_RELOAD_CNT	4
+
+
 enum iwl_reset {
 	IWL_RF_RESET = 0,
 	IWL_FW_RESET,
@@ -1262,6 +1267,10 @@ struct iwl_priv {
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
 
+	/* firmware reload counter and timestamp */
+	unsigned long reload_jiffies;
+	int reload_count;
+
 	/* we allocate array of iwl_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
 	struct iwl_channel_info *channel_info;	/* channel info array */
-- 
1.7.0.4

