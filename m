Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab1GHQUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/21] iwlagn: Enable/disable PS poll based on RSSI and BT coex traffic state
Date: Fri,  8 Jul 2011 08:46:23 -0700
Message-Id: <1310139989-27661-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182047_944948_CBA4F520)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

WiFi throughput drops drastically when BT is turned on, BT and WiFi
are simultaneously transmitting/receiving traffic. This is particularly true
when BT has higher priority over WiFi, and hence the device defers TX frames.
The AP assumes that the channel is bad and reduces the data rate, implying
longer airtime, which exacerbates the problem further, resulting ultimately
in what is popularly called the "death-spiral" phenomenon. The use of PS-poll
in such scenarios guarantees a low but consistent throughput.

Since the death-spiral phenomenon is observed only when the RSSI is low, use
PS-poll only when RSSI is low and disable when high, with a known hysterisis.

This feature specifies the high and low thresholds and implements the
callbacks registered with mac80211, which will be called when threshold events
occur.

iwlwifi: dynamic pspoll: optimize rssi monitor code

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  106 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   36 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +
 6 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 94f6d60..eb2be0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1634,9 +1634,11 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	} else {
 		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
 					IWLAGN_BT_FLAG_COEX_MODE_SHIFT;
-		if (priv->cfg->bt_params &&
-		    priv->cfg->bt_params->bt_sco_disable)
+
+		if (!priv->bt_enable_pspoll)
 			basic.flags |= IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE;
+		else
+			basic.flags &= ~IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE;
 
 		if (priv->bt_ch_announce)
 			basic.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
@@ -1671,6 +1673,84 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 
 }
 
+void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena)
+{
+	struct iwl_rxon_context *ctx, *found_ctx = NULL;
+	bool found_ap = false;
+
+	lockdep_assert_held(&priv->mutex);
+
+	/* Check whether AP or GO mode is active. */
+	if (rssi_ena) {
+		for_each_context(priv, ctx) {
+			if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_AP &&
+			    iwl_is_associated_ctx(ctx)) {
+				found_ap = true;
+				break;
+			}
+		}
+	}
+
+	/*
+	 * If disable was received or If GO/AP mode, disable RSSI
+	 * measurements.
+	 */
+	if (!rssi_ena || found_ap) {
+		if (priv->cur_rssi_ctx) {
+			ctx = priv->cur_rssi_ctx;
+			ieee80211_disable_rssi_reports(ctx->vif);
+			priv->cur_rssi_ctx = NULL;
+		}
+		return;
+	}
+
+	/*
+	 * If rssi measurements need to be enabled, consider all cases now.
+	 * Figure out how many contexts are active.
+	 */
+	for_each_context(priv, ctx) {
+		if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
+		    iwl_is_associated_ctx(ctx)) {
+			found_ctx = ctx;
+			break;
+		}
+	}
+
+	/*
+	 * rssi monitor already enabled for the correct interface...nothing
+	 * to do.
+	 */
+	if (found_ctx == priv->cur_rssi_ctx)
+		return;
+
+	/*
+	 * Figure out if rssi monitor is currently enabled, and needs
+	 * to be changed. If rssi monitor is already enabled, disable
+	 * it first else just enable rssi measurements on the
+	 * interface found above.
+	 */
+	if (priv->cur_rssi_ctx) {
+		ctx = priv->cur_rssi_ctx;
+		if (ctx->vif)
+			ieee80211_disable_rssi_reports(ctx->vif);
+	}
+
+	priv->cur_rssi_ctx = found_ctx;
+
+	if (!found_ctx)
+		return;
+
+	ieee80211_enable_rssi_reports(found_ctx->vif,
+			IWLAGN_BT_PSP_MIN_RSSI_THRESHOLD,
+			IWLAGN_BT_PSP_MAX_RSSI_THRESHOLD);
+}
+
+static bool iwlagn_bt_traffic_is_sco(struct iwl_bt_uart_msg *uart_msg)
+{
+	return BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3 >>
+			BT_UART_MSG_FRAME3SCOESCO_POS;
+}
+
 static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -1732,10 +1812,30 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 				ieee80211_request_smps(ctx->vif, smps_request);
 		}
 	}
+
+	/*
+	 * Dynamic PS poll related functionality. Adjust RSSI measurements if
+	 * necessary.
+	 */
+	iwlagn_bt_coex_rssi_monitor(priv);
 out:
 	mutex_unlock(&priv->mutex);
 }
 
+/*
+ * If BT sco traffic, and RSSI monitor is enabled, move measurements to the
+ * correct interface or disable it if this is the last interface to be
+ * removed.
+ */
+void iwlagn_bt_coex_rssi_monitor(struct iwl_priv *priv)
+{
+	if (priv->bt_is_sco &&
+	    priv->bt_traffic_load == IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS)
+		iwlagn_bt_adjust_rssi_monitor(priv, true);
+	else
+		iwlagn_bt_adjust_rssi_monitor(priv, false);
+}
+
 static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
@@ -1851,6 +1951,8 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	iwlagn_print_uartmsg(priv, uart_msg);
 
 	priv->last_bt_traffic_load = priv->bt_traffic_load;
+	priv->bt_is_sco = iwlagn_bt_traffic_is_sco(uart_msg);
+
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		if (priv->bt_status != coex->bt_status ||
 		    priv->last_bt_traffic_load != coex->bt_traffic_load) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d32cee1..fca376e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -731,6 +731,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			}
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		}
+
+		iwlagn_bt_coex_rssi_monitor(priv);
 	}
 
 	if (ctx->ht.enabled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3a4fca1..cbd8d10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2015,11 +2015,18 @@ int iwl_alive_start(struct iwl_priv *priv)
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
+		if (priv->cfg->bt_params->bt_sco_disable)
+			priv->bt_enable_pspoll = false;
+		else
+			priv->bt_enable_pspoll = true;
+
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		iwlagn_send_advance_bt_config(priv);
 		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
+		priv->cur_rssi_ctx = NULL;
+
 		iwlagn_send_prio_tbl(priv);
 
 		/* FIXME: w/a to force change uCode BT state machine */
@@ -2102,6 +2109,8 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	/* reset BT coex data */
 	priv->bt_status = 0;
+	priv->cur_rssi_ctx = NULL;
+	priv->bt_is_sco = 0;
 	if (priv->cfg->bt_params)
 		priv->bt_traffic_load =
 			 priv->cfg->bt_params->bt_init_traffic_load;
@@ -2277,6 +2286,7 @@ static void iwlagn_prepare_restart(struct iwl_priv *priv)
 	u8 bt_ci_compliance;
 	u8 bt_load;
 	u8 bt_status;
+	bool bt_is_sco;
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -2297,6 +2307,7 @@ static void iwlagn_prepare_restart(struct iwl_priv *priv)
 	bt_ci_compliance = priv->bt_ci_compliance;
 	bt_load = priv->bt_traffic_load;
 	bt_status = priv->bt_status;
+	bt_is_sco = priv->bt_is_sco;
 
 	__iwl_down(priv);
 
@@ -2304,6 +2315,7 @@ static void iwlagn_prepare_restart(struct iwl_priv *priv)
 	priv->bt_ci_compliance = bt_ci_compliance;
 	priv->bt_traffic_load = bt_load;
 	priv->bt_status = bt_status;
+	priv->bt_is_sco = bt_is_sco;
 }
 
 static void iwl_bg_restart(struct work_struct *data)
@@ -3330,6 +3342,29 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->beacon_cmd);
 }
 
+void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
+			   enum ieee80211_rssi_event rssi_event)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->cfg->bt_params &&
+			priv->cfg->bt_params->advanced_bt_coexist) {
+		if (rssi_event == RSSI_EVENT_LOW)
+			priv->bt_enable_pspoll = true;
+		else if (rssi_event == RSSI_EVENT_HIGH)
+			priv->bt_enable_pspoll = false;
+
+		iwlagn_send_advance_bt_config(priv);
+	} else {
+		IWL_DEBUG_MAC80211(priv, "Advanced BT coex disabled,"
+				"ignoring RSSI callback\n");
+	}
+
+	mutex_unlock(&priv->mutex);
+}
+
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
@@ -3355,6 +3390,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
 	.offchannel_tx = iwl_mac_offchannel_tx,
 	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
+	.rssi_callback = iwl_mac_rssi_callback,
 	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index bde03b4..81a009b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -261,6 +261,8 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
+void iwlagn_bt_coex_rssi_monitor(struct iwl_priv *priv);
+void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_get_tx_fail_reason(u32 status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8a2edf8..ee25637 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1931,6 +1931,9 @@ struct iwl_bt_cmd {
 /* Disable Sync PSPoll on SCO/eSCO */
 #define IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE	BIT(7)
 
+#define IWLAGN_BT_PSP_MIN_RSSI_THRESHOLD	-75 /* dBm */
+#define IWLAGN_BT_PSP_MAX_RSSI_THRESHOLD	-65 /* dBm */
+
 #define IWLAGN_BT_PRIO_BOOST_MAX	0xFF
 #define IWLAGN_BT_PRIO_BOOST_MIN	0x00
 #define IWLAGN_BT_PRIO_BOOST_DEFAULT	0xF0
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 92f8ce9..29eb41d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1525,6 +1525,9 @@ struct iwl_priv {
 	u16 dynamic_frag_thresh;
 	u8 bt_ci_compliance;
 	struct work_struct bt_traffic_change_work;
+	bool bt_enable_pspoll;
+	struct iwl_rxon_context *cur_rssi_ctx;
+	bool bt_is_sco;
 
 	struct iwl_hw_params hw_params;
 
-- 
1.7.0.4

