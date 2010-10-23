Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab0JWQSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/8] iwlagn: new RXON processing for modern devices
Date: Sat, 23 Oct 2010 09:15:41 -0700
Message-Id: <1287850546-23500-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to simplify the flow, and make new
enhancements easier, separate out the RXON
processing for modern AGN (5000 and newer)
from RXON processing for the older 3945 and
4965 devices. Avoid changing these old ones
to avoid regressions and move their code to
a new file (iwl-legacy.c). 4965 gets the
commit_rxon that used to be common for all
AGN devices, but with removed PAN support.

The new RXON processing is more central and
does more work in committing, so that it is
easier to follow.

To make it more evident what is split out
for legacy, split the necessary operations
for that into a new struct iwl_legacy_ops.
Those parts that still exist in the new AGN
code don't need to be parametrized.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    3 +
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  318 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  562 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  388 +++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   34 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |  527 -------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   30 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-led.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-legacy.c   |  560 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-legacy.h   |   74 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 +-
 17 files changed, 1631 insertions(+), 935 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 63edbe2..ce05c26 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -2,6 +2,8 @@ obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwlcore-objs 		+= iwl-scan.o iwl-led.o
+iwlcore-$(CONFIG_IWL3945) += iwl-legacy.o
+iwlcore-$(CONFIG_IWL4965) += iwl-legacy.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
@@ -16,6 +18,7 @@ iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
+iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4266c85..baedea8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -211,14 +211,10 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f708ba0..d216066 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2722,10 +2722,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	},
 	.send_tx_power	= iwl3945_send_tx_power,
 	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
-	.post_associate = iwl3945_post_associate,
 	.isr = iwl_isr_legacy,
-	.config_ap = iwl3945_config_ap,
-	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl3945_good_plcp_health,
 
@@ -2736,6 +2733,12 @@ static struct iwl_lib_ops iwl3945_lib = {
 	},
 };
 
+static const struct iwl_legacy_ops iwl3945_legacy_ops = {
+	.post_associate = iwl3945_post_associate,
+	.config_ap = iwl3945_config_ap,
+	.manage_ibss_station = iwl3945_manage_ibss_station,
+};
+
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
@@ -2749,6 +2752,7 @@ static const struct iwl_ops iwl3945_ops = {
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
 	.led = &iwl3945_led_ops,
+	.legacy = &iwl3945_legacy_ops,
 	.ieee80211_ops = &iwl3945_hw_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index b27f07c..3eef1eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -264,10 +264,8 @@ void iwl3945_reply_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
-extern void iwl3945_post_associate(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif);
-extern void iwl3945_config_ap(struct iwl_priv *priv,
-			      struct ieee80211_vif *vif);
+extern void iwl3945_post_associate(struct iwl_priv *priv);
+extern void iwl3945_config_ap(struct iwl_priv *priv);
 
 extern int iwl3945_commit_rxon(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d3cf6b2..6e80ab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -48,6 +48,7 @@
 #include "iwl-agn-led.h"
 #include "iwl-agn.h"
 #include "iwl-agn-debugfs.h"
+#include "iwl-legacy.h"
 
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
 static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
@@ -1447,6 +1448,142 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv,
 	return ret;
 }
 
+static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	/* cast away the const for active_rxon in this function */
+	struct iwl_rxon_cmd *active_rxon = (void *)&ctx->active;
+	int ret;
+	bool new_assoc =
+		!!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
+
+	if (!iwl_is_alive(priv))
+		return -EBUSY;
+
+	if (!ctx->is_active)
+		return 0;
+
+	/* always get timestamp with Rx frame */
+	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
+
+	ret = iwl_check_rxon_cmd(priv, ctx);
+	if (ret) {
+		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * receive commit_rxon request
+	 * abort any previous channel switch if still in process
+	 */
+	if (priv->switch_rxon.switch_in_progress &&
+	    (priv->switch_rxon.channel != ctx->staging.channel)) {
+		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
+		      le16_to_cpu(priv->switch_rxon.channel));
+		iwl_chswitch_done(priv, false);
+	}
+
+	/* If we don't need to send a full RXON, we can use
+	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
+	 * and other flags for the current radio configuration. */
+	if (!iwl_full_rxon_required(priv, ctx)) {
+		ret = iwl_send_rxon_assoc(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
+			return ret;
+		}
+
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		iwl_print_rx_config_cmd(priv, ctx);
+		return 0;
+	}
+
+	/* If we are currently associated and the new config requires
+	 * an RXON_ASSOC and the new config wants the associated mask enabled,
+	 * we must clear the associated from the active configuration
+	 * before we apply the new config */
+	if (iwl_is_associated_ctx(ctx) && new_assoc) {
+		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
+		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+				       sizeof(struct iwl_rxon_cmd),
+				       active_rxon);
+
+		/* If the mask clearing failed then we set
+		 * active_rxon back to what it was previously */
+		if (ret) {
+			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
+			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
+			return ret;
+		}
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
+	}
+
+	IWL_DEBUG_INFO(priv, "Sending RXON\n"
+		       "* with%s RXON_FILTER_ASSOC_MSK\n"
+		       "* channel = %d\n"
+		       "* bssid = %pM\n",
+		       (new_assoc ? "" : "out"),
+		       le16_to_cpu(ctx->staging.channel),
+		       ctx->staging.bssid_addr);
+
+	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
+
+	/* Apply the new configuration
+	 * RXON unassoc clears the station table in uCode so restoration of
+	 * stations is needed after it (the RXON command) completes
+	 */
+	if (!new_assoc) {
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
+		if (ret) {
+			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
+			return ret;
+		}
+		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
+	}
+	if (new_assoc) {
+		priv->start_calib = 0;
+		/* Apply the new configuration
+		 * RXON assoc doesn't clear the station table in uCode,
+		 */
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
+		if (ret) {
+			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
+			return ret;
+		}
+		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
+	}
+	iwl_print_rx_config_cmd(priv, ctx);
+
+	iwl_init_sensitivity(priv);
+
+	/* If we issue a new RXON command which required a tune then we must
+	 * send a new TXPOWER command or we won't be able to Tx any frames */
+	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	if (ret) {
+		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
 				     struct ieee80211_channel_switch *ch_switch)
 {
@@ -2216,7 +2353,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
-	.commit_rxon = iwlagn_commit_rxon,
+	.commit_rxon = iwl4965_commit_rxon,
 	.set_rxon_chain = iwlagn_set_rxon_chain,
 	.send_bt_config = iwl_send_bt_config,
 };
@@ -2233,6 +2370,149 @@ static void iwl4965_post_scan(struct iwl_priv *priv)
 		iwlcore_commit_rxon(priv, ctx);
 }
 
+static void iwl4965_post_associate(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct ieee80211_vif *vif = ctx->vif;
+	struct ieee80211_conf *conf = NULL;
+	int ret = 0;
+
+	if (!vif || !priv->is_open)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
+		return;
+	}
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	iwl_scan_cancel_timeout(priv, 200);
+
+	conf = ieee80211_get_hw_conf(priv->hw);
+
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv, ctx);
+
+	ret = iwl_send_rxon_timing(priv, ctx);
+	if (ret)
+		IWL_WARN(priv, "RXON timing - "
+			    "Attempting to continue.\n");
+
+	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+
+	iwl_set_rxon_ht(priv, &priv->current_ht_config);
+
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+
+	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+
+	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
+			vif->bss_conf.aid, vif->bss_conf.beacon_int);
+
+	if (vif->bss_conf.use_short_preamble)
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+
+	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+		if (vif->bss_conf.use_short_slot)
+			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		else
+			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+	}
+
+	iwlcore_commit_rxon(priv, ctx);
+
+	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
+			vif->bss_conf.aid, ctx->active.bssid_addr);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		iwlagn_send_beacon_cmd(priv);
+		break;
+	default:
+		IWL_ERR(priv, "%s Should not be called in %d mode\n",
+			  __func__, vif->type);
+		break;
+	}
+
+	/* the chain noise calibration will enabled PM upon completion
+	 * If chain noise has already been run, then we need to enable
+	 * power management here */
+	if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
+		iwl_power_update_mode(priv, false);
+
+	/* Enable Rx differential gain and sensitivity calibrations */
+	iwl_chain_noise_reset(priv);
+	priv->start_calib = 1;
+}
+
+static void iwl4965_config_ap(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct ieee80211_vif *vif = ctx->vif;
+	int ret = 0;
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* The following should be done only at AP bring up */
+	if (!iwl_is_associated_ctx(ctx)) {
+
+		/* RXON - unassoc (to set timing command) */
+		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
+
+		/* RXON Timing */
+		ret = iwl_send_rxon_timing(priv, ctx);
+		if (ret)
+			IWL_WARN(priv, "RXON timing failed - "
+					"Attempting to continue.\n");
+
+		/* AP has all antennas */
+		priv->chain_noise_data.active_chains =
+			priv->hw_params.valid_rx_ant;
+		iwl_set_rxon_ht(priv, &priv->current_ht_config);
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+
+		ctx->staging.assoc_id = 0;
+
+		if (vif->bss_conf.use_short_preamble)
+			ctx->staging.flags |=
+				RXON_FLG_SHORT_PREAMBLE_MSK;
+		else
+			ctx->staging.flags &=
+				~RXON_FLG_SHORT_PREAMBLE_MSK;
+
+		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
+			if (vif->bss_conf.use_short_slot)
+				ctx->staging.flags |=
+					RXON_FLG_SHORT_SLOT_MSK;
+			else
+				ctx->staging.flags &=
+					~RXON_FLG_SHORT_SLOT_MSK;
+		}
+		/* need to send beacon cmd before committing assoc RXON! */
+		iwlagn_send_beacon_cmd(priv);
+		/* restore RXON assoc */
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv, ctx);
+	}
+	iwlagn_send_beacon_cmd(priv);
+
+	/* FIXME - we need to add code here to detect a totally new
+	 * configuration, reset the AP, unassoc, rxon timing, assoc,
+	 * clear sta table, add BCAST sta... */
+}
+
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.get_hcmd_size = iwl4965_get_hcmd_size,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
@@ -2285,14 +2565,10 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
-	.post_associate = iwl_post_associate,
-	.config_ap = iwl_config_ap,
 	.isr = iwl_isr_legacy,
 	.temp_ops = {
 		.temperature = iwl4965_temperature_calib,
 	},
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -2304,12 +2580,42 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.check_plcp_health = iwl_good_plcp_health,
 };
 
+static const struct iwl_legacy_ops iwl4965_legacy_ops = {
+	.post_associate = iwl4965_post_associate,
+	.config_ap = iwl4965_config_ap,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
+};
+
+struct ieee80211_ops iwl4965_hw_ops = {
+	.tx = iwlagn_mac_tx,
+	.start = iwlagn_mac_start,
+	.stop = iwlagn_mac_stop,
+	.add_interface = iwl_mac_add_interface,
+	.remove_interface = iwl_mac_remove_interface,
+	.config = iwl_legacy_mac_config,
+	.configure_filter = iwlagn_configure_filter,
+	.set_key = iwlagn_mac_set_key,
+	.update_tkip_key = iwlagn_mac_update_tkip_key,
+	.conf_tx = iwl_mac_conf_tx,
+	.reset_tsf = iwl_legacy_mac_reset_tsf,
+	.bss_info_changed = iwl_legacy_mac_bss_info_changed,
+	.ampdu_action = iwlagn_mac_ampdu_action,
+	.hw_scan = iwl_mac_hw_scan,
+	.sta_add = iwlagn_mac_sta_add,
+	.sta_remove = iwl_mac_sta_remove,
+	.channel_switch = iwlagn_mac_channel_switch,
+	.flush = iwlagn_mac_flush,
+	.tx_last_beacon = iwl_mac_tx_last_beacon,
+};
+
 static const struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
 	.led = &iwlagn_led_ops,
-	.ieee80211_ops = &iwlagn_hw_ops,
+	.legacy = &iwl4965_legacy_ops,
+	.ieee80211_ops = &iwl4965_hw_ops,
 };
 
 static struct iwl_base_params iwl4965_base_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5f03277..e1f412f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -385,14 +385,10 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -453,14 +449,10 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
-	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
 	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 85bde70..eacbce0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -328,14 +328,10 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -399,14 +395,10 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.post_associate = iwl_post_associate,
 	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
new file mode 100644
index 0000000..5860245
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -0,0 +1,562 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include "iwl-dev.h"
+#include "iwl-agn.h"
+#include "iwl-sta.h"
+#include "iwl-core.h"
+#include "iwl-agn-calib.h"
+
+static int iwlagn_disable_bss(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx,
+			      struct iwl_rxon_cmd *send)
+{
+	__le32 old_filter = send->filter_flags;
+	int ret;
+
+	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+
+	send->filter_flags = old_filter;
+
+	if (ret)
+		IWL_ERR(priv, "Error clearing ASSOC_MSK on BSS (%d)\n", ret);
+
+	return ret;
+}
+
+static int iwlagn_disable_pan(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx,
+			      struct iwl_rxon_cmd *send)
+{
+	__le32 old_filter = send->filter_flags;
+	u8 old_dev_type = send->dev_type;
+	int ret;
+
+	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	send->dev_type = RXON_DEV_TYPE_P2P;
+	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+
+	send->filter_flags = old_filter;
+	send->dev_type = old_dev_type;
+
+	if (ret)
+		IWL_ERR(priv, "Error disabling PAN (%d)\n", ret);
+
+	/* FIXME: WAIT FOR PAN DISABLE */
+	msleep(300);
+
+	return ret;
+}
+
+/**
+ * iwlagn_commit_rxon - commit staging_rxon to hardware
+ *
+ * The RXON command in staging_rxon is committed to the hardware and
+ * the active_rxon structure is updated with the new data.  This
+ * function correctly transitions out of the RXON_ASSOC_MSK state if
+ * a HW tune is required based on the RXON structure changes.
+ */
+int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	/* cast away the const for active_rxon in this function */
+	struct iwl_rxon_cmd *active = (void *)&ctx->active;
+	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
+	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (!iwl_is_alive(priv))
+		return -EBUSY;
+
+	/* This function hardcodes a bunch of dual-mode assumptions */
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+
+	if (!ctx->is_active)
+		return 0;
+
+	/* always get timestamp with Rx frame */
+	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
+
+	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
+	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
+		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+
+	ret = iwl_check_rxon_cmd(priv, ctx);
+	if (ret) {
+		IWL_ERR(priv, "Invalid RXON configuration. Not committing.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * receive commit_rxon request
+	 * abort any previous channel switch if still in process
+	 */
+	if (priv->switch_rxon.switch_in_progress &&
+	    (priv->switch_rxon.channel != ctx->staging.channel)) {
+		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
+		      le16_to_cpu(priv->switch_rxon.channel));
+		iwl_chswitch_done(priv, false);
+	}
+
+	/*
+	 * If we don't need to send a full RXON, we can use
+	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
+	 * and other flags for the current radio configuration.
+	 */
+	if (!iwl_full_rxon_required(priv, ctx)) {
+		ret = iwl_send_rxon_assoc(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
+			return ret;
+		}
+
+		memcpy(active, &ctx->staging, sizeof(*active));
+		iwl_print_rx_config_cmd(priv, ctx);
+		return 0;
+	}
+
+	if (priv->cfg->ops->hcmd->set_pan_params) {
+		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
+		if (ret)
+			return ret;
+	}
+
+	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
+
+	IWL_DEBUG_INFO(priv,
+		       "Going to commit RXON\n"
+		       "  * with%s RXON_FILTER_ASSOC_MSK\n"
+		       "  * channel = %d\n"
+		       "  * bssid = %pM\n",
+		       (new_assoc ? "" : "out"),
+		       le16_to_cpu(ctx->staging.channel),
+		       ctx->staging.bssid_addr);
+
+	/*
+	 * If we are currently associated and the new config is also
+	 * going to be associated, OR if the new config is simply not
+	 * associated, clear associated.
+	 */
+	if ((old_assoc && new_assoc) || !new_assoc) {
+		struct iwl_rxon_cmd *send = active;
+
+		if (!new_assoc)
+			send = &ctx->staging;
+
+		if (ctx->ctxid == IWL_RXON_CTX_BSS)
+			ret = iwlagn_disable_bss(priv, ctx, send);
+		else
+			ret = iwlagn_disable_pan(priv, ctx, send);
+		if (ret)
+			return ret;
+
+		if (send != active)
+			memcpy(active, send, sizeof(*active));
+
+		/*
+		 * Un-assoc RXON clears the station table and WEP
+		 * keys, so we have to restore those afterwards.
+		 */
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
+	}
+
+	/* RXON timing must be before associated RXON */
+	ret = iwl_send_rxon_timing(priv, ctx);
+	if (ret) {
+		IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
+		return ret;
+	}
+
+	if (new_assoc) {
+		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_AP ||
+				 ctx->vif->type == NL80211_IFTYPE_ADHOC)) {
+			/*
+			 * We'll run into this code path when beaconing is
+			 * enabled, but then we also need to send the beacon
+			 * to the device.
+			 */
+			dev_kfree_skb(priv->beacon_skb);
+			priv->beacon_skb = ieee80211_beacon_get(priv->hw,
+								ctx->vif);
+			iwlagn_send_beacon_cmd(priv);
+		}
+
+		priv->start_calib = 0;
+		/*
+		 * Apply the new configuration.
+		 *
+		 * Associated RXON doesn't clear the station table in uCode,
+		 * so we don't need to restore stations etc. after this.
+		 */
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
+		if (ret) {
+			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
+			return ret;
+		}
+		memcpy(active, &ctx->staging, sizeof(*active));
+	}
+
+	iwl_print_rx_config_cmd(priv, ctx);
+
+	iwl_init_sensitivity(priv);
+
+	/*
+	 * If we issue a new RXON command which required a tune then we must
+	 * send a new TXPOWER command or we won't be able to Tx any frames.
+	 *
+	 * FIXME: which RXON requires a tune? Can we optimise this out in
+	 *        some cases?
+	 */
+	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	if (ret) {
+		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_channel *channel = conf->channel;
+	const struct iwl_channel_info *ch_info;
+	int ret = 0;
+
+	IWL_DEBUG_MAC80211(priv, "changed %#x", changed);
+
+	mutex_lock(&priv->mutex);
+
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
+		goto out;
+	}
+
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		goto out;
+	}
+
+	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
+		       IEEE80211_CONF_CHANGE_CHANNEL)) {
+		/* mac80211 uses static for non-HT which is what we want */
+		priv->current_ht_config.smps = conf->smps_mode;
+
+		/*
+		 * Recalculate chain counts.
+		 *
+		 * If monitor mode is enabled then mac80211 will
+		 * set up the SM PS mode to OFF if an HT channel is
+		 * configured.
+		 */
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			for_each_context(priv, ctx)
+				priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		unsigned long flags;
+
+		ch_info = iwl_get_channel_info(priv, channel->band,
+					       channel->hw_value);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		spin_lock_irqsave(&priv->lock, flags);
+
+		for_each_context(priv, ctx) {
+			/* Configure HT40 channels */
+			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled) {
+				if (conf_is_ht40_minus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+					ctx->ht.is_40mhz = true;
+				} else if (conf_is_ht40_plus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+					ctx->ht.is_40mhz = true;
+				} else {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_NONE;
+					ctx->ht.is_40mhz = false;
+				}
+			} else
+				ctx->ht.is_40mhz = false;
+
+			/*
+			 * Default to no protection. Protection mode will
+			 * later be set from BSS config in iwl_ht_conf
+			 */
+			ctx->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+
+			/* if we are switching from ht to 2.4 clear flags
+			 * from any ht related info since 2.4 does not
+			 * support ht */
+			if (le16_to_cpu(ctx->staging.channel) !=
+			    channel->hw_value)
+				ctx->staging.flags = 0;
+
+			iwl_set_rxon_channel(priv, channel, ctx);
+			iwl_set_rxon_ht(priv, &priv->current_ht_config);
+
+			iwl_set_flags_for_band(priv, ctx, channel->band,
+					       ctx->vif);
+		}
+
+		spin_unlock_irqrestore(&priv->lock, flags);
+
+		iwl_update_bcast_stations(priv);
+
+		/*
+		 * The list of supported rates and rate mask can be different
+		 * for each band; since the band may have changed, reset
+		 * the rate mask to what mac80211 lists.
+		 */
+		iwl_set_rate(priv);
+	}
+
+	if (changed & (IEEE80211_CONF_CHANGE_PS |
+			IEEE80211_CONF_CHANGE_IDLE)) {
+		ret = iwl_power_update_mode(priv, false);
+		if (ret)
+			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
+			priv->tx_power_user_lmt, conf->power_level);
+
+		iwl_set_tx_power(priv, conf->power_level, false);
+	}
+
+	for_each_context(priv, ctx) {
+		if (!memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+			continue;
+		iwlagn_commit_rxon(priv, ctx);
+	}
+ out:
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+
+static void iwlagn_update_qos(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx)
+{
+	int ret;
+
+	if (!ctx->is_active)
+		return;
+
+	ctx->qos_data.def_qos_parm.qos_flags = 0;
+
+	if (ctx->qos_data.qos_active)
+		ctx->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
+
+	if (ctx->ht.enabled)
+		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+
+	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+		      ctx->qos_data.qos_active,
+		      ctx->qos_data.def_qos_parm.qos_flags);
+
+	ret = iwl_send_cmd_pdu(priv, ctx->qos_cmd,
+			       sizeof(struct iwl_qosparam_cmd),
+			       &ctx->qos_data.def_qos_parm);
+	if (ret)
+		IWL_ERR(priv, "Failed to update QoS\n");
+}
+
+static void iwlagn_check_needed_chains(struct iwl_priv *priv,
+				       struct iwl_rxon_context *ctx,
+				       struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_vif *vif = ctx->vif;
+	struct iwl_rxon_context *tmp;
+	struct ieee80211_sta *sta;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	bool need_multiple;
+
+	lockdep_assert_held(&priv->mutex);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, bss_conf->bssid);
+		if (sta) {
+			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
+			int maxstreams;
+
+			maxstreams = (ht_cap->mcs.tx_params &
+				      IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+			maxstreams += 1;
+
+			if ((ht_cap->mcs.rx_mask[1] == 0) &&
+			    (ht_cap->mcs.rx_mask[2] == 0))
+				need_multiple = false;
+			if (maxstreams <= 1)
+				need_multiple = true;
+		} else {
+			/*
+			 * If at all, this can only happen through a race
+			 * when the AP disconnects us while we're still
+			 * setting up the connection, in that case mac80211
+			 * will soon tell us about that.
+			 */
+			need_multiple = false;
+		}
+		rcu_read_unlock();
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		/* currently */
+		need_multiple = false;
+		break;
+	default:
+		/* only AP really */
+		need_multiple = true;
+		break;
+	}
+
+	ctx->ht_need_multiple_chains = need_multiple;
+
+	if (!need_multiple) {
+		/* check all contexts */
+		for_each_context(priv, tmp) {
+			if (!tmp->vif)
+				continue;
+			if (tmp->ht_need_multiple_chains) {
+				need_multiple = true;
+				break;
+			}
+		}
+	}
+
+	ht_conf->single_chain_sufficient = !need_multiple;
+}
+
+void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *bss_conf,
+			     u32 changes)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	int ret;
+	bool force = false;
+
+	mutex_lock(&priv->mutex);
+
+	if (changes & BSS_CHANGED_BEACON_INT)
+		force = true;
+
+	if (changes & BSS_CHANGED_QOS) {
+		ctx->qos_data.qos_active = bss_conf->qos;
+		iwlagn_update_qos(priv, ctx);
+	}
+
+	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+	if (vif->bss_conf.use_short_preamble)
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+
+	if (changes & BSS_CHANGED_ASSOC) {
+		if (bss_conf->assoc) {
+			iwl_led_associate(priv);
+			priv->timestamp = bss_conf->timestamp;
+			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		} else {
+			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+			iwl_led_disassociate(priv);
+		}
+	}
+
+	if (ctx->ht.enabled) {
+		ctx->ht.protection = bss_conf->ht_operation_mode &
+					IEEE80211_HT_OP_MODE_PROTECTION;
+		ctx->ht.non_gf_sta_present = !!(bss_conf->ht_operation_mode &
+					IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+		iwlagn_check_needed_chains(priv, ctx, bss_conf);
+	}
+
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+
+	if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
+		ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
+	else
+		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+
+	if (bss_conf->use_cts_prot)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+
+	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
+
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_ADHOC) {
+		if (vif->bss_conf.enable_beacon) {
+			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
+			priv->beacon_ctx = ctx;
+		} else {
+			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+			priv->beacon_ctx = NULL;
+		}
+	}
+
+	if (force || memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+		iwlagn_commit_rxon(priv, ctx);
+
+	if (changes & BSS_CHANGED_IBSS) {
+		ret = iwlagn_manage_ibss_station(priv, vif,
+						 bss_conf->ibss_joined);
+		if (ret)
+			IWL_ERR(priv, "failed to %s IBSS station %pM\n",
+				bss_conf->ibss_joined ? "add" : "remove",
+				bss_conf->bssid);
+	}
+
+	mutex_unlock(&priv->mutex);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a126113..4afad96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -90,156 +90,6 @@ MODULE_ALIAS("iwl4965");
 static int iwlagn_ant_coupling;
 static bool iwlagn_bt_ch_announce = 1;
 
-/**
- * iwlagn_commit_rxon - commit staging_rxon to hardware
- *
- * The RXON command in staging_rxon is committed to the hardware and
- * the active_rxon structure is updated with the new data.  This
- * function correctly transitions out of the RXON_ASSOC_MSK state if
- * a HW tune is required based on the RXON structure changes.
- */
-int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	/* cast away the const for active_rxon in this function */
-	struct iwl_rxon_cmd *active_rxon = (void *)&ctx->active;
-	int ret;
-	bool new_assoc =
-		!!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
-
-	if (!iwl_is_alive(priv))
-		return -EBUSY;
-
-	if (!ctx->is_active)
-		return 0;
-
-	/* always get timestamp with Rx frame */
-	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
-
-	ret = iwl_check_rxon_cmd(priv, ctx);
-	if (ret) {
-		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * receive commit_rxon request
-	 * abort any previous channel switch if still in process
-	 */
-	if (priv->switch_rxon.switch_in_progress &&
-	    (priv->switch_rxon.channel != ctx->staging.channel)) {
-		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
-		      le16_to_cpu(priv->switch_rxon.channel));
-		iwl_chswitch_done(priv, false);
-	}
-
-	/* If we don't need to send a full RXON, we can use
-	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
-	 * and other flags for the current radio configuration. */
-	if (!iwl_full_rxon_required(priv, ctx)) {
-		ret = iwl_send_rxon_assoc(priv, ctx);
-		if (ret) {
-			IWL_ERR(priv, "Error setting RXON_ASSOC (%d)\n", ret);
-			return ret;
-		}
-
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
-		iwl_print_rx_config_cmd(priv, ctx);
-		return 0;
-	}
-
-	/* If we are currently associated and the new config requires
-	 * an RXON_ASSOC and the new config wants the associated mask enabled,
-	 * we must clear the associated from the active configuration
-	 * before we apply the new config */
-	if (iwl_is_associated_ctx(ctx) && new_assoc) {
-		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
-		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-
-		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
-				       sizeof(struct iwl_rxon_cmd),
-				       active_rxon);
-
-		/* If the mask clearing failed then we set
-		 * active_rxon back to what it was previously */
-		if (ret) {
-			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
-			return ret;
-		}
-		iwl_clear_ucode_stations(priv, ctx);
-		iwl_restore_stations(priv, ctx);
-		ret = iwl_restore_default_wep_keys(priv, ctx);
-		if (ret) {
-			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
-			return ret;
-		}
-	}
-
-	IWL_DEBUG_INFO(priv, "Sending RXON\n"
-		       "* with%s RXON_FILTER_ASSOC_MSK\n"
-		       "* channel = %d\n"
-		       "* bssid = %pM\n",
-		       (new_assoc ? "" : "out"),
-		       le16_to_cpu(ctx->staging.channel),
-		       ctx->staging.bssid_addr);
-
-	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
-
-	if (priv->cfg->ops->hcmd->set_pan_params) {
-		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
-		if (ret)
-			return ret;
-	}
-
-	/* Apply the new configuration
-	 * RXON unassoc clears the station table in uCode so restoration of
-	 * stations is needed after it (the RXON command) completes
-	 */
-	if (!new_assoc) {
-		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
-			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
-		if (ret) {
-			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
-			return ret;
-		}
-		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
-		iwl_clear_ucode_stations(priv, ctx);
-		iwl_restore_stations(priv, ctx);
-		ret = iwl_restore_default_wep_keys(priv, ctx);
-		if (ret) {
-			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
-			return ret;
-		}
-	}
-	if (new_assoc) {
-		priv->start_calib = 0;
-		/* Apply the new configuration
-		 * RXON assoc doesn't clear the station table in uCode,
-		 */
-		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
-			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
-		if (ret) {
-			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
-			return ret;
-		}
-		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
-	}
-	iwl_print_rx_config_cmd(priv, ctx);
-
-	iwl_init_sensitivity(priv);
-
-	/* If we issue a new RXON command which required a tune then we must
-	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	if (ret) {
-		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
@@ -397,7 +247,8 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	return sizeof(*tx_beacon_cmd) + frame_size;
 }
-static int iwl_send_beacon_cmd(struct iwl_priv *priv)
+
+int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_frame *frame;
 	unsigned int frame_size;
@@ -647,7 +498,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 
 	priv->beacon_skb = beacon;
 
-	iwl_send_beacon_cmd(priv);
+	iwlagn_send_beacon_cmd(priv);
  out:
 	mutex_unlock(&priv->mutex);
 }
@@ -3295,92 +3146,6 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
-
-void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
-{
-	struct iwl_rxon_context *ctx;
-	struct ieee80211_conf *conf = NULL;
-	int ret = 0;
-
-	if (!vif || !priv->is_open)
-		return;
-
-	ctx = iwl_rxon_ctx_from_vif(vif);
-
-	if (vif->type == NL80211_IFTYPE_AP) {
-		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
-		return;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	iwl_scan_cancel_timeout(priv, 200);
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv, ctx);
-
-	ret = iwl_send_rxon_timing(priv, ctx);
-	if (ret)
-		IWL_WARN(priv, "RXON timing - "
-			    "Attempting to continue.\n");
-
-	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
-
-	iwl_set_rxon_ht(priv, &priv->current_ht_config);
-
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-
-	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
-
-	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
-			vif->bss_conf.aid, vif->bss_conf.beacon_int);
-
-	if (vif->bss_conf.use_short_preamble)
-		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-	else
-		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-
-	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
-		if (vif->bss_conf.use_short_slot)
-			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
-		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-	}
-
-	iwlcore_commit_rxon(priv, ctx);
-
-	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			vif->bss_conf.aid, ctx->active.bssid_addr);
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		iwl_send_beacon_cmd(priv);
-		break;
-	default:
-		IWL_ERR(priv, "%s Should not be called in %d mode\n",
-			  __func__, vif->type);
-		break;
-	}
-
-	/* the chain noise calibration will enabled PM upon completion
-	 * If chain noise has already been run, then we need to enable
-	 * power management here */
-	if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
-		iwl_power_update_mode(priv, false);
-
-	/* Enable Rx differential gain and sensitivity calibrations */
-	iwl_chain_noise_reset(priv);
-	priv->start_calib = 1;
-
-}
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -3460,7 +3225,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 }
 
 
-static int iwl_mac_start(struct ieee80211_hw *hw)
+int iwlagn_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
@@ -3501,7 +3266,7 @@ out:
 	return 0;
 }
 
-static void iwl_mac_stop(struct ieee80211_hw *hw)
+void iwlagn_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -3523,7 +3288,7 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+int iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -3539,73 +3304,12 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
-{
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	int ret = 0;
-
-	lockdep_assert_held(&priv->mutex);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	/* The following should be done only at AP bring up */
-	if (!iwl_is_associated_ctx(ctx)) {
-
-		/* RXON - unassoc (to set timing command) */
-		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv, ctx);
-
-		/* RXON Timing */
-		ret = iwl_send_rxon_timing(priv, ctx);
-		if (ret)
-			IWL_WARN(priv, "RXON timing failed - "
-					"Attempting to continue.\n");
-
-		/* AP has all antennas */
-		priv->chain_noise_data.active_chains =
-			priv->hw_params.valid_rx_ant;
-		iwl_set_rxon_ht(priv, &priv->current_ht_config);
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-
-		ctx->staging.assoc_id = 0;
-
-		if (vif->bss_conf.use_short_preamble)
-			ctx->staging.flags |=
-				RXON_FLG_SHORT_PREAMBLE_MSK;
-		else
-			ctx->staging.flags &=
-				~RXON_FLG_SHORT_PREAMBLE_MSK;
-
-		if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
-			if (vif->bss_conf.use_short_slot)
-				ctx->staging.flags |=
-					RXON_FLG_SHORT_SLOT_MSK;
-			else
-				ctx->staging.flags &=
-					~RXON_FLG_SHORT_SLOT_MSK;
-		}
-		/* need to send beacon cmd before committing assoc RXON! */
-		iwl_send_beacon_cmd(priv);
-		/* restore RXON assoc */
-		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv, ctx);
-	}
-	iwl_send_beacon_cmd(priv);
-
-	/* FIXME - we need to add code here to detect a totally new
-	 * configuration, reset the AP, unassoc, rxon timing, assoc,
-	 * clear sta table, add BCAST sta... */
-}
-
-static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_key_conf *keyconf,
-				    struct ieee80211_sta *sta,
-				    u32 iv32, u16 *phase1key)
+void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_key_conf *keyconf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key)
 {
-
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 
@@ -3617,10 +3321,9 @@ static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			   struct ieee80211_vif *vif,
-			   struct ieee80211_sta *sta,
-			   struct ieee80211_key_conf *key)
+int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
@@ -3687,10 +3390,10 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
-static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				enum ieee80211_ampdu_mlme_action action,
-				struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
@@ -3771,10 +3474,10 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       enum sta_notify_cmd cmd,
-			       struct ieee80211_sta *sta)
+static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  enum sta_notify_cmd cmd,
+				  struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
@@ -3801,9 +3504,9 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
-static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta)
+int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
@@ -3844,8 +3547,8 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
-				   struct ieee80211_channel_switch *ch_switch)
+void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+			       struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
@@ -3942,10 +3645,10 @@ out_exit:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static void iwlagn_configure_filter(struct ieee80211_hw *hw,
-				    unsigned int changed_flags,
-				    unsigned int *total_flags,
-				    u64 multicast)
+void iwlagn_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast)
 {
 	struct iwl_priv *priv = hw->priv;
 	__le32 filter_or = 0, filter_nand = 0;
@@ -3987,7 +3690,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwl_mac_flush(struct ieee80211_hw *hw, bool drop)
+void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -4196,25 +3899,24 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 }
 
 struct ieee80211_ops iwlagn_hw_ops = {
-	.tx = iwl_mac_tx,
-	.start = iwl_mac_start,
-	.stop = iwl_mac_stop,
+	.tx = iwlagn_mac_tx,
+	.start = iwlagn_mac_start,
+	.stop = iwlagn_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
-	.config = iwl_mac_config,
+	.config = iwlagn_mac_config,
 	.configure_filter = iwlagn_configure_filter,
-	.set_key = iwl_mac_set_key,
-	.update_tkip_key = iwl_mac_update_tkip_key,
+	.set_key = iwlagn_mac_set_key,
+	.update_tkip_key = iwlagn_mac_update_tkip_key,
 	.conf_tx = iwl_mac_conf_tx,
-	.reset_tsf = iwl_mac_reset_tsf,
-	.bss_info_changed = iwl_bss_info_changed,
-	.ampdu_action = iwl_mac_ampdu_action,
+	.bss_info_changed = iwlagn_bss_info_changed,
+	.ampdu_action = iwlagn_mac_ampdu_action,
 	.hw_scan = iwl_mac_hw_scan,
-	.sta_notify = iwl_mac_sta_notify,
+	.sta_notify = iwlagn_mac_sta_notify,
 	.sta_add = iwlagn_mac_sta_add,
 	.sta_remove = iwl_mac_sta_remove,
-	.channel_switch = iwl_mac_channel_switch,
-	.flush = iwl_mac_flush,
+	.channel_switch = iwlagn_mac_channel_switch,
+	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwl_mac_tx_last_beacon,
 };
 
@@ -4285,6 +3987,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_DEBUG, &(pdev->dev),
 			"sw scan support is deprecated\n");
 		iwlagn_hw_ops.hw_scan = NULL;
+#ifdef CONFIG_IWL4965
+		iwl4965_hw_ops.hw_scan = NULL;
+#endif
 	}
 
 	hw = iwl_alloc_all(cfg);
@@ -4319,6 +4024,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		BIT(NL80211_IFTYPE_ADHOC);
 	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
 		BIT(NL80211_IFTYPE_STATION);
+	priv->contexts[IWL_RXON_CTX_BSS].ap_devtype = RXON_DEV_TYPE_AP;
 	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
 	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
 	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ba88e78..aca93f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -103,6 +103,7 @@ extern struct iwl_hcmd_ops iwlagn_bt_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
+extern struct ieee80211_ops iwl4965_hw_ops;
 
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
@@ -134,6 +135,11 @@ void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 /* RXON */
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed);
+void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *bss_conf,
+			     u32 changes);
 
 /* uCode */
 int iwlagn_load_ucode(struct iwl_priv *priv);
@@ -251,6 +257,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 			   struct iwl_rxon_context *ctx);
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
+int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
@@ -320,4 +327,31 @@ void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
+/* mac80211 handlers (for 4965) */
+int iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+int iwlagn_mac_start(struct ieee80211_hw *hw);
+void iwlagn_mac_stop(struct ieee80211_hw *hw);
+void iwlagn_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast);
+int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key);
+void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_key_conf *keyconf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key);
+int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
+void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+			       struct ieee80211_channel_switch *ch_switch);
+void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2fbcaeb..84a9514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -100,35 +100,6 @@ out:
 }
 EXPORT_SYMBOL(iwl_alloc_all);
 
-/*
- * QoS  support
-*/
-static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (!ctx->is_active)
-		return;
-
-	ctx->qos_data.def_qos_parm.qos_flags = 0;
-
-	if (ctx->qos_data.qos_active)
-		ctx->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
-
-	if (ctx->ht.enabled)
-		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-
-	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-		      ctx->qos_data.qos_active,
-		      ctx->qos_data.def_qos_parm.qos_flags);
-
-	iwl_send_cmd_pdu_async(priv, ctx->qos_cmd,
-			       sizeof(struct iwl_qosparam_cmd),
-			       &ctx->qos_data.def_qos_parm, NULL);
-}
-
 #define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
 #define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
 static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
@@ -1452,308 +1423,6 @@ int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(iwl_mac_tx_last_beacon);
 
-static void iwl_ht_conf(struct iwl_priv *priv,
-			struct ieee80211_vif *vif)
-{
-	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-	struct ieee80211_sta *sta;
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-
-	IWL_DEBUG_MAC80211(priv, "enter:\n");
-
-	if (!ctx->ht.enabled)
-		return;
-
-	ctx->ht.protection =
-		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	ctx->ht.non_gf_sta_present =
-		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-
-	ht_conf->single_chain_sufficient = false;
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		rcu_read_lock();
-		sta = ieee80211_find_sta(vif, bss_conf->bssid);
-		if (sta) {
-			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-			int maxstreams;
-
-			maxstreams = (ht_cap->mcs.tx_params &
-				      IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
-					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
-			maxstreams += 1;
-
-			if ((ht_cap->mcs.rx_mask[1] == 0) &&
-			    (ht_cap->mcs.rx_mask[2] == 0))
-				ht_conf->single_chain_sufficient = true;
-			if (maxstreams <= 1)
-				ht_conf->single_chain_sufficient = true;
-		} else {
-			/*
-			 * If at all, this can only happen through a race
-			 * when the AP disconnects us while we're still
-			 * setting up the connection, in that case mac80211
-			 * will soon tell us about that.
-			 */
-			ht_conf->single_chain_sufficient = true;
-		}
-		rcu_read_unlock();
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		ht_conf->single_chain_sufficient = true;
-		break;
-	default:
-		break;
-	}
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
-static inline void iwl_set_no_assoc(struct iwl_priv *priv,
-				    struct ieee80211_vif *vif)
-{
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-
-	iwl_led_disassociate(priv);
-	/*
-	 * inform the ucode that there is no longer an
-	 * association and that no more packets should be
-	 * sent
-	 */
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ctx->staging.assoc_id = 0;
-	iwlcore_commit_rxon(priv, ctx);
-}
-
-static void iwlcore_beacon_update(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	__le64 timestamp;
-	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
-
-	if (!skb)
-		return;
-
-	IWL_DEBUG_ASSOC(priv, "enter\n");
-
-	lockdep_assert_held(&priv->mutex);
-
-	if (!priv->beacon_ctx) {
-		IWL_ERR(priv, "update beacon but no beacon context!\n");
-		dev_kfree_skb(skb);
-		return;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->beacon_skb)
-		dev_kfree_skb(priv->beacon_skb);
-
-	priv->beacon_skb = skb;
-
-	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp);
-
-	IWL_DEBUG_ASSOC(priv, "leave\n");
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return;
-	}
-
-	priv->cfg->ops->lib->post_associate(priv, priv->beacon_ctx->vif);
-}
-
-void iwl_bss_info_changed(struct ieee80211_hw *hw,
-			  struct ieee80211_vif *vif,
-			  struct ieee80211_bss_conf *bss_conf,
-			  u32 changes)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	int ret;
-
-	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
-
-	if (!iwl_is_alive(priv))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	if (changes & BSS_CHANGED_QOS) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&priv->lock, flags);
-		ctx->qos_data.qos_active = bss_conf->qos;
-		iwl_update_qos(priv, ctx);
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
-
-	if (changes & BSS_CHANGED_BEACON_ENABLED) {
-		/*
-		 * the add_interface code must make sure we only ever
-		 * have a single interface that could be beaconing at
-		 * any time.
-		 */
-		if (vif->bss_conf.enable_beacon)
-			priv->beacon_ctx = ctx;
-		else
-			priv->beacon_ctx = NULL;
-	}
-
-	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
-		dev_kfree_skb(priv->beacon_skb);
-		priv->beacon_skb = ieee80211_beacon_get(hw, vif);
-	}
-
-	if (changes & BSS_CHANGED_BEACON_INT && vif->type == NL80211_IFTYPE_AP)
-		iwl_send_rxon_timing(priv, ctx);
-
-	if (changes & BSS_CHANGED_BSSID) {
-		IWL_DEBUG_MAC80211(priv, "BSSID %pM\n", bss_conf->bssid);
-
-		/*
-		 * If there is currently a HW scan going on in the
-		 * background then we need to cancel it else the RXON
-		 * below/in post_associate will fail.
-		 */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-			mutex_unlock(&priv->mutex);
-			return;
-		}
-
-		/* mac80211 only sets assoc when in STATION mode */
-		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
-			memcpy(ctx->staging.bssid_addr,
-			       bss_conf->bssid, ETH_ALEN);
-
-			/* currently needed in a few places */
-			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
-		} else {
-			ctx->staging.filter_flags &=
-				~RXON_FILTER_ASSOC_MSK;
-		}
-
-	}
-
-	/*
-	 * This needs to be after setting the BSSID in case
-	 * mac80211 decides to do both changes at once because
-	 * it will invoke post_associate.
-	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC && changes & BSS_CHANGED_BEACON)
-		iwlcore_beacon_update(hw, vif);
-
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
-				   bss_conf->use_short_preamble);
-		if (bss_conf->use_short_preamble)
-			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-	}
-
-	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
-		else
-			ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
-		if (bss_conf->use_cts_prot)
-			ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-		else
-			ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
-	}
-
-	if (changes & BSS_CHANGED_BASIC_RATES) {
-		/* XXX use this information
-		 *
-		 * To do that, remove code from iwl_set_rate() and put something
-		 * like this here:
-		 *
-		if (A-band)
-			ctx->staging.ofdm_basic_rates =
-				bss_conf->basic_rates;
-		else
-			ctx->staging.ofdm_basic_rates =
-				bss_conf->basic_rates >> 4;
-			ctx->staging.cck_basic_rates =
-				bss_conf->basic_rates & 0xF;
-		 */
-	}
-
-	if (changes & BSS_CHANGED_HT) {
-		iwl_ht_conf(priv, vif);
-
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-	}
-
-	if (changes & BSS_CHANGED_ASSOC) {
-		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
-		if (bss_conf->assoc) {
-			priv->timestamp = bss_conf->timestamp;
-
-			iwl_led_associate(priv);
-
-			if (!iwl_is_rfkill(priv))
-				priv->cfg->ops->lib->post_associate(priv, vif);
-		} else
-			iwl_set_no_assoc(priv, vif);
-	}
-
-	if (changes && iwl_is_associated_ctx(ctx) && bss_conf->aid) {
-		IWL_DEBUG_MAC80211(priv, "Changes (%#x) while associated\n",
-				   changes);
-		ret = iwl_send_rxon_assoc(priv, ctx);
-		if (!ret) {
-			/* Sync active_rxon with latest change. */
-			memcpy((void *)&ctx->active,
-				&ctx->staging,
-				sizeof(struct iwl_rxon_cmd));
-		}
-	}
-
-	if (changes & BSS_CHANGED_BEACON_ENABLED) {
-		if (vif->bss_conf.enable_beacon) {
-			memcpy(ctx->staging.bssid_addr,
-			       bss_conf->bssid, ETH_ALEN);
-			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
-			iwl_led_associate(priv);
-			iwlcore_config_ap(priv, vif);
-		} else
-			iwl_set_no_assoc(priv, vif);
-	}
-
-	if (changes & BSS_CHANGED_IBSS) {
-		ret = priv->cfg->ops->lib->manage_ibss_station(priv, vif,
-							bss_conf->ibss_joined);
-		if (ret)
-			IWL_ERR(priv, "failed to %s IBSS station %pM\n",
-				bss_conf->ibss_joined ? "add" : "remove",
-				bss_conf->bssid);
-	}
-
-	if (changes & BSS_CHANGED_IDLE &&
-	    priv->cfg->ops->hcmd->set_pan_params) {
-		if (priv->cfg->ops->hcmd->set_pan_params(priv))
-			IWL_ERR(priv, "failed to update PAN params\n");
-	}
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-EXPORT_SYMBOL(iwl_bss_info_changed);
-
 static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
@@ -1893,202 +1562,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_mac_remove_interface);
 
-/**
- * iwl_mac_config - mac80211 config callback
- */
-int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
-{
-	struct iwl_priv *priv = hw->priv;
-	const struct iwl_channel_info *ch_info;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = conf->channel;
-	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
-	struct iwl_rxon_context *ctx;
-	unsigned long flags = 0;
-	int ret = 0;
-	u16 ch;
-	int scan_active = 0;
-
-	mutex_lock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
-					channel->hw_value, changed);
-
-	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
-			test_bit(STATUS_SCANNING, &priv->status))) {
-		scan_active = 1;
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
-	}
-
-	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
-		       IEEE80211_CONF_CHANGE_CHANNEL)) {
-		/* mac80211 uses static for non-HT which is what we want */
-		priv->current_ht_config.smps = conf->smps_mode;
-
-		/*
-		 * Recalculate chain counts.
-		 *
-		 * If monitor mode is enabled then mac80211 will
-		 * set up the SM PS mode to OFF if an HT channel is
-		 * configured.
-		 */
-		if (priv->cfg->ops->hcmd->set_rxon_chain)
-			for_each_context(priv, ctx)
-				priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-	}
-
-	/* during scanning mac80211 will delay channel setting until
-	 * scan finish with changed = 0
-	 */
-	if (!changed || (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
-		if (scan_active)
-			goto set_ch_out;
-
-		ch = channel->hw_value;
-		ch_info = iwl_get_channel_info(priv, channel->band, ch);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
-			ret = -EINVAL;
-			goto set_ch_out;
-		}
-
-		spin_lock_irqsave(&priv->lock, flags);
-
-		for_each_context(priv, ctx) {
-			/* Configure HT40 channels */
-			ctx->ht.enabled = conf_is_ht(conf);
-			if (ctx->ht.enabled) {
-				if (conf_is_ht40_minus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-					ctx->ht.is_40mhz = true;
-				} else if (conf_is_ht40_plus(conf)) {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-					ctx->ht.is_40mhz = true;
-				} else {
-					ctx->ht.extension_chan_offset =
-						IEEE80211_HT_PARAM_CHA_SEC_NONE;
-					ctx->ht.is_40mhz = false;
-				}
-			} else
-				ctx->ht.is_40mhz = false;
-
-			/*
-			 * Default to no protection. Protection mode will
-			 * later be set from BSS config in iwl_ht_conf
-			 */
-			ctx->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
-
-			/* if we are switching from ht to 2.4 clear flags
-			 * from any ht related info since 2.4 does not
-			 * support ht */
-			if ((le16_to_cpu(ctx->staging.channel) != ch))
-				ctx->staging.flags = 0;
-
-			iwl_set_rxon_channel(priv, channel, ctx);
-			iwl_set_rxon_ht(priv, ht_conf);
-
-			iwl_set_flags_for_band(priv, ctx, channel->band,
-					       ctx->vif);
-		}
-
-		spin_unlock_irqrestore(&priv->lock, flags);
-
-		if (priv->cfg->ops->lib->update_bcast_stations)
-			ret = priv->cfg->ops->lib->update_bcast_stations(priv);
-
- set_ch_out:
-		/* The list of supported rates and rate mask can be different
-		 * for each band; since the band may have changed, reset
-		 * the rate mask to what mac80211 lists */
-		iwl_set_rate(priv);
-	}
-
-	if (changed & (IEEE80211_CONF_CHANGE_PS |
-			IEEE80211_CONF_CHANGE_IDLE)) {
-		ret = iwl_power_update_mode(priv, false);
-		if (ret)
-			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
-	}
-
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
-			priv->tx_power_user_lmt, conf->power_level);
-
-		iwl_set_tx_power(priv, conf->power_level, false);
-	}
-
-	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		goto out;
-	}
-
-	if (scan_active)
-		goto out;
-
-	for_each_context(priv, ctx) {
-		if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
-			iwlcore_commit_rxon(priv, ctx);
-		else
-			IWL_DEBUG_INFO(priv,
-				"Not re-sending same RXON configuration.\n");
-	}
-
-out:
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
-	return ret;
-}
-EXPORT_SYMBOL(iwl_mac_config);
-
-void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-	unsigned long flags;
-	/* IBSS can only be the IWL_RXON_CTX_BSS context */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-
-	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_config));
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* new association get rid of ibss beacon skb */
-	if (priv->beacon_skb)
-		dev_kfree_skb(priv->beacon_skb);
-
-	priv->beacon_skb = NULL;
-
-	priv->timestamp = 0;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	iwl_scan_cancel_timeout(priv, 100);
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	/* we are restarting association process
-	 * clear RXON_FILTER_ASSOC_MSK bit
-	 */
-	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwlcore_commit_rxon(priv, ctx);
-
-	iwl_set_rate(priv);
-
-	mutex_unlock(&priv->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-EXPORT_SYMBOL(iwl_mac_reset_tsf);
-
 int iwl_alloc_txq_mem(struct iwl_priv *priv)
 {
 	if (!priv->txq)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1b66bb4..3a8b481 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -193,9 +193,6 @@ struct iwl_lib_ops {
 	/* power */
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
-	void (*post_associate)(struct iwl_priv *priv,
-			       struct ieee80211_vif *vif);
-	void (*config_ap)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 	irqreturn_t (*isr) (int irq, void *data);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
@@ -203,10 +200,6 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
-	/* station management */
-	int (*manage_ibss_station)(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif, bool add);
-	int (*update_bcast_stations)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
@@ -235,12 +228,22 @@ struct iwl_nic_ops {
 	void (*additional_nic_config)(struct iwl_priv *priv);
 };
 
+struct iwl_legacy_ops {
+	void (*post_associate)(struct iwl_priv *priv);
+	void (*config_ap)(struct iwl_priv *priv);
+	/* station management */
+	int (*update_bcast_stations)(struct iwl_priv *priv);
+	int (*manage_ibss_station)(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif, bool add);
+};
+
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_led_ops *led;
 	const struct iwl_nic_ops *nic;
+	const struct iwl_legacy_ops *legacy;
 	const struct ieee80211_ops *ieee80211_ops;
 };
 
@@ -425,18 +428,10 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 			   u32 decrypt_res,
 			   struct ieee80211_rx_status *stats);
 void iwl_irq_handle_error(struct iwl_priv *priv);
-void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif);
-void iwl_bss_info_changed(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_bss_conf *bss_conf,
-				     u32 changes);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
-int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
-void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif);
-void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
 void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
@@ -724,11 +719,6 @@ static inline int iwlcore_commit_rxon(struct iwl_priv *priv,
 {
 	return priv->cfg->ops->hcmd->commit_rxon(priv, ctx);
 }
-static inline void iwlcore_config_ap(struct iwl_priv *priv,
-				     struct ieee80211_vif *vif)
-{
-	priv->cfg->ops->lib->config_ap(priv, vif);
-}
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 70e07fa..af3d2e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1162,6 +1162,8 @@ struct iwl_rxon_context {
 	 */
 	bool always_active, is_active;
 
+	bool ht_need_multiple_chains;
+
 	enum iwl_rxon_context_id ctxid;
 
 	u32 interface_modes, exclusive_interface_modes;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 86c2b6f..5a91292 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -134,6 +134,7 @@ int iwl_led_associate(struct iwl_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL(iwl_led_associate);
 
 int iwl_led_disassociate(struct iwl_priv *priv)
 {
@@ -141,6 +142,7 @@ int iwl_led_disassociate(struct iwl_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL(iwl_led_disassociate);
 
 /*
  * calculate blink rate according to last second Tx/Rx activities
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
new file mode 100644
index 0000000..b735fef
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -0,0 +1,560 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
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
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <net/mac80211.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-legacy.h"
+
+/**
+ * iwl_legacy_mac_config - mac80211 config callback
+ */
+int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct iwl_priv *priv = hw->priv;
+	const struct iwl_channel_info *ch_info;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_channel *channel = conf->channel;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	struct iwl_rxon_context *ctx;
+	unsigned long flags = 0;
+	int ret = 0;
+	u16 ch;
+	int scan_active = 0;
+
+	if (WARN_ON(!priv->cfg->ops->legacy))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
+					channel->hw_value, changed);
+
+	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
+			test_bit(STATUS_SCANNING, &priv->status))) {
+		scan_active = 1;
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
+	}
+
+	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
+		       IEEE80211_CONF_CHANGE_CHANNEL)) {
+		/* mac80211 uses static for non-HT which is what we want */
+		priv->current_ht_config.smps = conf->smps_mode;
+
+		/*
+		 * Recalculate chain counts.
+		 *
+		 * If monitor mode is enabled then mac80211 will
+		 * set up the SM PS mode to OFF if an HT channel is
+		 * configured.
+		 */
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			for_each_context(priv, ctx)
+				priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	}
+
+	/* during scanning mac80211 will delay channel setting until
+	 * scan finish with changed = 0
+	 */
+	if (!changed || (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
+		if (scan_active)
+			goto set_ch_out;
+
+		ch = channel->hw_value;
+		ch_info = iwl_get_channel_info(priv, channel->band, ch);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
+			ret = -EINVAL;
+			goto set_ch_out;
+		}
+
+		spin_lock_irqsave(&priv->lock, flags);
+
+		for_each_context(priv, ctx) {
+			/* Configure HT40 channels */
+			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled) {
+				if (conf_is_ht40_minus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+					ctx->ht.is_40mhz = true;
+				} else if (conf_is_ht40_plus(conf)) {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+					ctx->ht.is_40mhz = true;
+				} else {
+					ctx->ht.extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_NONE;
+					ctx->ht.is_40mhz = false;
+				}
+			} else
+				ctx->ht.is_40mhz = false;
+
+			/*
+			 * Default to no protection. Protection mode will
+			 * later be set from BSS config in iwl_ht_conf
+			 */
+			ctx->ht.protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+
+			/* if we are switching from ht to 2.4 clear flags
+			 * from any ht related info since 2.4 does not
+			 * support ht */
+			if ((le16_to_cpu(ctx->staging.channel) != ch))
+				ctx->staging.flags = 0;
+
+			iwl_set_rxon_channel(priv, channel, ctx);
+			iwl_set_rxon_ht(priv, ht_conf);
+
+			iwl_set_flags_for_band(priv, ctx, channel->band,
+					       ctx->vif);
+		}
+
+		spin_unlock_irqrestore(&priv->lock, flags);
+
+		if (priv->cfg->ops->legacy->update_bcast_stations)
+			ret = priv->cfg->ops->legacy->update_bcast_stations(priv);
+
+ set_ch_out:
+		/* The list of supported rates and rate mask can be different
+		 * for each band; since the band may have changed, reset
+		 * the rate mask to what mac80211 lists */
+		iwl_set_rate(priv);
+	}
+
+	if (changed & (IEEE80211_CONF_CHANGE_PS |
+			IEEE80211_CONF_CHANGE_IDLE)) {
+		ret = iwl_power_update_mode(priv, false);
+		if (ret)
+			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
+			priv->tx_power_user_lmt, conf->power_level);
+
+		iwl_set_tx_power(priv, conf->power_level, false);
+	}
+
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		goto out;
+	}
+
+	if (scan_active)
+		goto out;
+
+	for_each_context(priv, ctx) {
+		if (memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging)))
+			iwlcore_commit_rxon(priv, ctx);
+		else
+			IWL_DEBUG_INFO(priv,
+				"Not re-sending same RXON configuration.\n");
+	}
+
+out:
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_legacy_mac_config);
+
+void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+	/* IBSS can only be the IWL_RXON_CTX_BSS context */
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	if (WARN_ON(!priv->cfg->ops->legacy))
+		return;
+
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	spin_lock_irqsave(&priv->lock, flags);
+	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_config));
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* new association get rid of ibss beacon skb */
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
+
+	priv->beacon_skb = NULL;
+
+	priv->timestamp = 0;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_scan_cancel_timeout(priv, 100);
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
+	/* we are restarting association process
+	 * clear RXON_FILTER_ASSOC_MSK bit
+	 */
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv, ctx);
+
+	iwl_set_rate(priv);
+
+	mutex_unlock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+EXPORT_SYMBOL(iwl_legacy_mac_reset_tsf);
+
+static void iwl_ht_conf(struct iwl_priv *priv,
+			struct ieee80211_vif *vif)
+{
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	struct ieee80211_sta *sta;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
+	IWL_DEBUG_ASSOC(priv, "enter:\n");
+
+	if (!ctx->ht.enabled)
+		return;
+
+	ctx->ht.protection =
+		bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+	ctx->ht.non_gf_sta_present =
+		!!(bss_conf->ht_operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+
+	ht_conf->single_chain_sufficient = false;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, bss_conf->bssid);
+		if (sta) {
+			struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
+			int maxstreams;
+
+			maxstreams = (ht_cap->mcs.tx_params &
+				      IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+			maxstreams += 1;
+
+			if ((ht_cap->mcs.rx_mask[1] == 0) &&
+			    (ht_cap->mcs.rx_mask[2] == 0))
+				ht_conf->single_chain_sufficient = true;
+			if (maxstreams <= 1)
+				ht_conf->single_chain_sufficient = true;
+		} else {
+			/*
+			 * If at all, this can only happen through a race
+			 * when the AP disconnects us while we're still
+			 * setting up the connection, in that case mac80211
+			 * will soon tell us about that.
+			 */
+			ht_conf->single_chain_sufficient = true;
+		}
+		rcu_read_unlock();
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ht_conf->single_chain_sufficient = true;
+		break;
+	default:
+		break;
+	}
+
+	IWL_DEBUG_ASSOC(priv, "leave\n");
+}
+
+static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (!ctx->is_active)
+		return;
+
+	ctx->qos_data.def_qos_parm.qos_flags = 0;
+
+	if (ctx->qos_data.qos_active)
+		ctx->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
+
+	if (ctx->ht.enabled)
+		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+
+	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+		      ctx->qos_data.qos_active,
+		      ctx->qos_data.def_qos_parm.qos_flags);
+
+	iwl_send_cmd_pdu_async(priv, ctx->qos_cmd,
+			       sizeof(struct iwl_qosparam_cmd),
+			       &ctx->qos_data.def_qos_parm, NULL);
+}
+
+static inline void iwl_set_no_assoc(struct iwl_priv *priv,
+				    struct ieee80211_vif *vif)
+{
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
+	iwl_led_disassociate(priv);
+	/*
+	 * inform the ucode that there is no longer an
+	 * association and that no more packets should be
+	 * sent
+	 */
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	ctx->staging.assoc_id = 0;
+	iwlcore_commit_rxon(priv, ctx);
+}
+
+static void iwlcore_beacon_update(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif)
+{
+	struct iwl_priv *priv = hw->priv;
+	unsigned long flags;
+	__le64 timestamp;
+	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
+
+	if (!skb)
+		return;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (!priv->beacon_ctx) {
+		IWL_ERR(priv, "update beacon but no beacon context!\n");
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->beacon_skb)
+		dev_kfree_skb(priv->beacon_skb);
+
+	priv->beacon_skb = skb;
+
+	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+	priv->timestamp = le64_to_cpu(timestamp);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return;
+	}
+
+	priv->cfg->ops->legacy->post_associate(priv);
+}
+
+void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *bss_conf,
+				     u32 changes)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	int ret;
+
+	if (WARN_ON(!priv->cfg->ops->legacy))
+		return;
+
+	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
+
+	if (!iwl_is_alive(priv))
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	if (changes & BSS_CHANGED_QOS) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		ctx->qos_data.qos_active = bss_conf->qos;
+		iwl_update_qos(priv, ctx);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		/*
+		 * the add_interface code must make sure we only ever
+		 * have a single interface that could be beaconing at
+		 * any time.
+		 */
+		if (vif->bss_conf.enable_beacon)
+			priv->beacon_ctx = ctx;
+		else
+			priv->beacon_ctx = NULL;
+	}
+
+	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
+		dev_kfree_skb(priv->beacon_skb);
+		priv->beacon_skb = ieee80211_beacon_get(hw, vif);
+	}
+
+	if (changes & BSS_CHANGED_BEACON_INT && vif->type == NL80211_IFTYPE_AP)
+		iwl_send_rxon_timing(priv, ctx);
+
+	if (changes & BSS_CHANGED_BSSID) {
+		IWL_DEBUG_MAC80211(priv, "BSSID %pM\n", bss_conf->bssid);
+
+		/*
+		 * If there is currently a HW scan going on in the
+		 * background then we need to cancel it else the RXON
+		 * below/in post_associate will fail.
+		 */
+		if (iwl_scan_cancel_timeout(priv, 100)) {
+			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
+			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
+			mutex_unlock(&priv->mutex);
+			return;
+		}
+
+		/* mac80211 only sets assoc when in STATION mode */
+		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
+			memcpy(ctx->staging.bssid_addr,
+			       bss_conf->bssid, ETH_ALEN);
+
+			/* currently needed in a few places */
+			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+		} else {
+			ctx->staging.filter_flags &=
+				~RXON_FILTER_ASSOC_MSK;
+		}
+
+	}
+
+	/*
+	 * This needs to be after setting the BSSID in case
+	 * mac80211 decides to do both changes at once because
+	 * it will invoke post_associate.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC && changes & BSS_CHANGED_BEACON)
+		iwlcore_beacon_update(hw, vif);
+
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
+				   bss_conf->use_short_preamble);
+		if (bss_conf->use_short_preamble)
+			ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		else
+			ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	}
+
+	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
+		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
+		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
+			ctx->staging.flags |= RXON_FLG_TGG_PROTECT_MSK;
+		else
+			ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+		if (bss_conf->use_cts_prot)
+			ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+		else
+			ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+	}
+
+	if (changes & BSS_CHANGED_BASIC_RATES) {
+		/* XXX use this information
+		 *
+		 * To do that, remove code from iwl_set_rate() and put something
+		 * like this here:
+		 *
+		if (A-band)
+			ctx->staging.ofdm_basic_rates =
+				bss_conf->basic_rates;
+		else
+			ctx->staging.ofdm_basic_rates =
+				bss_conf->basic_rates >> 4;
+			ctx->staging.cck_basic_rates =
+				bss_conf->basic_rates & 0xF;
+		 */
+	}
+
+	if (changes & BSS_CHANGED_HT) {
+		iwl_ht_conf(priv, vif);
+
+		if (priv->cfg->ops->hcmd->set_rxon_chain)
+			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
+	}
+
+	if (changes & BSS_CHANGED_ASSOC) {
+		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
+		if (bss_conf->assoc) {
+			priv->timestamp = bss_conf->timestamp;
+
+			iwl_led_associate(priv);
+
+			if (!iwl_is_rfkill(priv))
+				priv->cfg->ops->legacy->post_associate(priv);
+		} else
+			iwl_set_no_assoc(priv, vif);
+	}
+
+	if (changes && iwl_is_associated_ctx(ctx) && bss_conf->aid) {
+		IWL_DEBUG_MAC80211(priv, "Changes (%#x) while associated\n",
+				   changes);
+		ret = iwl_send_rxon_assoc(priv, ctx);
+		if (!ret) {
+			/* Sync active_rxon with latest change. */
+			memcpy((void *)&ctx->active,
+				&ctx->staging,
+				sizeof(struct iwl_rxon_cmd));
+		}
+	}
+
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		if (vif->bss_conf.enable_beacon) {
+			memcpy(ctx->staging.bssid_addr,
+			       bss_conf->bssid, ETH_ALEN);
+			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+			iwl_led_associate(priv);
+			priv->cfg->ops->legacy->config_ap(priv);
+		} else
+			iwl_set_no_assoc(priv, vif);
+	}
+
+	if (changes & BSS_CHANGED_IBSS) {
+		ret = priv->cfg->ops->legacy->manage_ibss_station(priv, vif,
+							bss_conf->ibss_joined);
+		if (ret)
+			IWL_ERR(priv, "failed to %s IBSS station %pM\n",
+				bss_conf->ibss_joined ? "add" : "remove",
+				bss_conf->bssid);
+	}
+
+	mutex_unlock(&priv->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+EXPORT_SYMBOL(iwl_legacy_mac_bss_info_changed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.h b/drivers/net/wireless/iwlwifi/iwl-legacy.h
new file mode 100644
index 0000000..2a746cb
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.h
@@ -0,0 +1,74 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
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
+ *****************************************************************************/
+
+#ifndef __iwl_legacy_h__
+#define __iwl_legacy_h__
+
+/* mac80211 handlers */
+int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed);
+void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw);
+void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *bss_conf,
+				     u32 changes);
+
+#endif /* __iwl_legacy_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e20ab98..8a37b25 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -61,6 +61,7 @@
 #include "iwl-helpers.h"
 #include "iwl-dev.h"
 #include "iwl-spectrum.h"
+#include "iwl-legacy.h"
 
 /*
  * module name, copyright, version, etc.
@@ -3057,22 +3058,22 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
+void iwl3945_post_associate(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (!vif || !priv->is_open)
+	if (!ctx->vif || !priv->is_open)
 		return;
 
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if (ctx->vif->type == NL80211_IFTYPE_AP) {
 		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
 	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			vif->bss_conf.aid, ctx->active.bssid_addr);
+			ctx->vif->bss_conf.aid, ctx->active.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -3091,18 +3092,18 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	ctx->staging.assoc_id = cpu_to_le16(vif->bss_conf.aid);
+	ctx->staging.assoc_id = cpu_to_le16(ctx->vif->bss_conf.aid);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
-			vif->bss_conf.aid, vif->bss_conf.beacon_int);
+			ctx->vif->bss_conf.aid, ctx->vif->bss_conf.beacon_int);
 
-	if (vif->bss_conf.use_short_preamble)
+	if (ctx->vif->bss_conf.use_short_preamble)
 		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK) {
-		if (vif->bss_conf.use_short_slot)
+		if (ctx->vif->bss_conf.use_short_slot)
 			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
@@ -3110,7 +3111,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	iwl3945_commit_rxon(priv, ctx);
 
-	switch (vif->type) {
+	switch (ctx->vif->type) {
 	case NL80211_IFTYPE_STATION:
 		iwl3945_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
@@ -3119,7 +3120,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		break;
 	default:
 		IWL_ERR(priv, "%s Should not be called in %d mode\n",
-			__func__, vif->type);
+			__func__, ctx->vif->type);
 		break;
 	}
 }
@@ -3234,9 +3235,10 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
+void iwl3945_config_ap(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct ieee80211_vif *vif = ctx->vif;
 	int rc = 0;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -3830,12 +3832,12 @@ struct ieee80211_ops iwl3945_hw_ops = {
 	.stop = iwl3945_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
-	.config = iwl_mac_config,
+	.config = iwl_legacy_mac_config,
 	.configure_filter = iwl3945_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.conf_tx = iwl_mac_conf_tx,
-	.reset_tsf = iwl_mac_reset_tsf,
-	.bss_info_changed = iwl_bss_info_changed,
+	.reset_tsf = iwl_legacy_mac_reset_tsf,
+	.bss_info_changed = iwl_legacy_mac_bss_info_changed,
 	.hw_scan = iwl_mac_hw_scan,
 	.sta_add = iwl3945_mac_sta_add,
 	.sta_remove = iwl_mac_sta_remove,
-- 
1.7.0.4

