Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0BSGDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: separated time check for different type of force reset
Date: Thu, 18 Feb 2010 22:03:06 -0800
Message-Id: <1266559387-19637-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Use different timing duration check for different type of force reset,
force reset request can come from different source and based on
different reason; one type of reset request should not block other type of
reset request.

Adding structure to keep track of different force reset request.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   25 ++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   14 +++++++++++++-
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 52b6beb..c5b724e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3378,6 +3378,12 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 	priv->agg_tids_count = 0;
 
+	/* initialize force reset */
+	priv->force_reset[IWL_RF_RESET].reset_duration =
+		IWL_DELAY_NEXT_FORCE_RF_RESET;
+	priv->force_reset[IWL_FW_RESET].reset_duration =
+		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
+
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index bd56827..55252a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3357,22 +3357,30 @@ static void iwl_force_rf_reset(struct iwl_priv *priv)
 	return;
 }
 
-#define IWL_DELAY_NEXT_FORCE_RESET (HZ*3)
 
 int iwl_force_reset(struct iwl_priv *priv, int mode)
 {
+	struct iwl_force_reset *force_reset;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EINVAL;
 
-	if (priv->last_force_reset_jiffies &&
-	    time_after(priv->last_force_reset_jiffies +
-		       IWL_DELAY_NEXT_FORCE_RESET, jiffies)) {
+	if (mode >= IWL_MAX_FORCE_RESET) {
+		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
+		return -EINVAL;
+	}
+	force_reset = &priv->force_reset[mode];
+	force_reset->reset_request_count++;
+	if (force_reset->last_force_reset_jiffies &&
+	    time_after(force_reset->last_force_reset_jiffies +
+	    force_reset->reset_duration, jiffies)) {
 		IWL_DEBUG_INFO(priv, "force reset rejected\n");
+		force_reset->reset_reject_count++;
 		return -EAGAIN;
 	}
-
+	force_reset->reset_success_count++;
+	force_reset->last_force_reset_jiffies = jiffies;
 	IWL_DEBUG_INFO(priv, "perform force reset (%d)\n", mode);
-
 	switch (mode) {
 	case IWL_RF_RESET:
 		iwl_force_rf_reset(priv);
@@ -3389,12 +3397,7 @@ int iwl_force_reset(struct iwl_priv *priv, int mode)
 		clear_bit(STATUS_READY, &priv->status);
 		queue_work(priv->workqueue, &priv->restart);
 		break;
-	default:
-		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
-		return -EINVAL;
 	}
-	priv->last_force_reset_jiffies = jiffies;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 021c686..7914d65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1036,9 +1036,21 @@ struct iwl_event_log {
 #define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	(200)
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
 
+#define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
+#define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
+
 enum iwl_reset {
 	IWL_RF_RESET = 0,
 	IWL_FW_RESET,
+	IWL_MAX_FORCE_RESET,
+};
+
+struct iwl_force_reset {
+	int reset_request_count;
+	int reset_success_count;
+	int reset_reject_count;
+	unsigned long reset_duration;
+	unsigned long last_force_reset_jiffies;
 };
 
 struct iwl_priv {
@@ -1076,7 +1088,7 @@ struct iwl_priv {
 	u8 agg_tids_count;
 
 	/* force reset */
-	unsigned long last_force_reset_jiffies;
+	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
 
 	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
-- 
1.6.3.3

