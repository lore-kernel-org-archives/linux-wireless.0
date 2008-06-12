Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbYFLBtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 18/29] iwlwifi: refactor setting tx power
Date: Thu, 12 Jun 2008 09:47:08 +0800
Message-Id: <1213235239-2954-19-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_468473_D46A685A)
In-Reply-To: <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. Refactors settings of tx power
2. enables iwconfig txpower <value>
3. adds 5000 HW tx power

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   51 ++++++---------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   14 +++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   37 +++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 ++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   12 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   17 ++++++---
 8 files changed, 96 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3f24e97..1b8dc2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -46,6 +46,8 @@
 #include "iwl-calib.h"
 #include "iwl-sta.h"
 
+static int iwl4965_send_tx_power(struct iwl_priv *priv);
+
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
 	.num_of_queues = IWL49_NUM_QUEUES,
@@ -737,7 +739,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	/* Regardless of if we are assocaited, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
 	 * not associated */
-	iwl4965_hw_reg_send_txpower(priv);
+	iwl4965_send_tx_power(priv);
 
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
@@ -952,11 +954,6 @@ static int iwl4965_set_power(struct iwl_priv *priv,
 				    cmd, NULL);
 	return ret;
 }
-int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
-{
-	IWL_ERROR("TODO: Implement iwl4965_hw_reg_set_txpower!\n");
-	return -EINVAL;
-}
 
 static s32 iwl4965_math_div_round(s32 num, s32 denom, s32 *res)
 {
@@ -1007,20 +1004,6 @@ static s32 iwl4965_get_voltage_compensation(s32 eeprom_voltage,
 	return comp;
 }
 
-static const struct iwl_channel_info *
-iwl4965_get_channel_txpower_info(struct iwl_priv *priv,
-				 enum ieee80211_band band, u16 channel)
-{
-	const struct iwl_channel_info *ch_info;
-
-	ch_info = iwl_get_channel_info(priv, band, channel);
-
-	if (!is_channel_valid(ch_info))
-		return NULL;
-
-	return ch_info;
-}
-
 static s32 iwl4965_get_tx_atten_grp(u16 channel)
 {
 	if (channel >= CALIB_IWL_TX_ATTEN_GR5_FCH &&
@@ -1444,30 +1427,17 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	s32 factory_actual_pwr[2];
 	s32 power_index;
 
-	/* Sanity check requested level (dBm) */
-	if (priv->user_txpower_limit < IWL_TX_POWER_TARGET_POWER_MIN) {
-		IWL_WARNING("Requested user TXPOWER %d below limit.\n",
-			    priv->user_txpower_limit);
-		return -EINVAL;
-	}
-	if (priv->user_txpower_limit > IWL_TX_POWER_TARGET_POWER_MAX) {
-		IWL_WARNING("Requested user TXPOWER %d above limit.\n",
-			    priv->user_txpower_limit);
-		return -EINVAL;
-	}
-
 	/* user_txpower_limit is in dBm, convert to half-dBm (half-dB units
 	 *   are used for indexing into txpower table) */
-	user_target_power = 2 * priv->user_txpower_limit;
+	user_target_power = 2 * priv->tx_power_user_lmt;
 
 	/* Get current (RXON) channel, band, width */
-	ch_info =
-		iwl4965_get_channel_txpower_info(priv, priv->band, channel);
-
 	IWL_DEBUG_TXPOWER("chan %d band %d is_fat %d\n", channel, band,
 			  is_fat);
 
-	if (!ch_info)
+	ch_info = iwl_get_channel_info(priv, priv->band, channel);
+
+	if (!is_channel_valid(ch_info))
 		return -EINVAL;
 
 	/* get txatten group, used to select 1) thermal txpower adjustment
@@ -1668,12 +1638,12 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 }
 
 /**
- * iwl4965_hw_reg_send_txpower - Configure the TXPOWER level user limit
+ * iwl4965_send_tx_power - Configure the TXPOWER level user limit
  *
  * Uses the active RXON for channel, band, and characteristics (fat, high)
- * The power limit is taken from priv->user_txpower_limit.
+ * The power limit is taken from priv->tx_power_user_lmt.
  */
-int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv)
+static int iwl4965_send_tx_power(struct iwl_priv *priv)
 {
 	struct iwl4965_txpowertable_cmd cmd = { 0 };
 	int ret;
@@ -3507,6 +3477,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 	.radio_kill_sw = iwl4965_radio_kill_sw,
 	.set_power = iwl4965_set_power,
+	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl4965_update_chain_flags,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2a30306..da8750b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1424,6 +1424,19 @@ static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
 
 	return ret;
 }
+static int  iwl5000_send_tx_power(struct iwl_priv *priv)
+{
+	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
+
+	/* half dBm need to multiply */
+	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
+	tx_power_cmd.flags = 0;
+	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
+	return  iwl_send_cmd_pdu_async(priv, REPLY_TX_POWER_DBM_CMD,
+				       sizeof(tx_power_cmd), &tx_power_cmd,
+				       NULL);
+}
+
 
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
@@ -1452,6 +1465,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
+	.send_tx_power = iwl5000_send_tx_power,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9b64a39..a093f5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -126,6 +126,7 @@ enum {
 	/* Miscellaneous commands */
 	QUIET_NOTIFICATION = 0x96,		/* not used */
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
+	REPLY_TX_POWER_DBM_CMD = 0x98,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
 	/* Bluetooth device coexistance config command */
@@ -339,6 +340,17 @@ struct iwl4965_tx_power_db {
 	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
 } __attribute__ ((packed));
 
+/**
+ * Commad REPLY_TX_POWER_DBM_CMD = 0x98
+ * struct iwl5000_tx_power_dbm_cmd
+ */
+#define IWL50_TX_POWER_AUTO 0x7f
+struct iwl5000_tx_power_dbm_cmd {
+	s8 global_lmt; /*in half-dBm (e.g. 30 = 15 dBm) */
+	u8 flags;
+	s8 srv_chan_lmt; /*in half-dBm (e.g. 30 = 15 dBm) */
+	u8 reserved;
+} __attribute__ ((packed));
 
 /******************************************************************************
  * (0a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 21995ff..164697a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -480,9 +480,8 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 
 			geo_ch->flags |= ch->fat_extension_channel;
 
-			if (ch->max_power_avg > priv->max_channel_txpower_limit)
-				priv->max_channel_txpower_limit =
-				    ch->max_power_avg;
+			if (ch->max_power_avg > priv->tx_power_channel_lmt)
+				priv->tx_power_channel_lmt = ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
@@ -832,7 +831,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
-	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MAX;
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
@@ -871,6 +870,34 @@ void iwl_free_calib_results(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_free_calib_results);
 
+int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
+{
+	int ret = 0;
+	if (tx_power < IWL_TX_POWER_TARGET_POWER_MIN) {
+		IWL_WARNING("Requested user TXPOWER %d below limit.\n",
+			    priv->tx_power_user_lmt);
+		return -EINVAL;
+	}
+
+	if (tx_power > IWL_TX_POWER_TARGET_POWER_MAX) {
+		IWL_WARNING("Requested user TXPOWER %d above limit.\n",
+			    priv->tx_power_user_lmt);
+		return -EINVAL;
+	}
+
+	if (priv->tx_power_user_lmt != tx_power)
+		force = true;
+
+	priv->tx_power_user_lmt = tx_power;
+
+	if (force && priv->cfg->ops->lib->send_tx_power)
+		ret = priv->cfg->ops->lib->send_tx_power(priv);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_set_tx_power);
+
+
 void iwl_uninit_drv(struct iwl_priv *priv)
 {
 	iwl_free_calib_results(priv);
@@ -880,6 +907,8 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_uninit_drv);
 
+
+
 /* Low level driver call this function to update iwlcore with
  * driver status.
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 44d0fcf..5bae691 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -140,6 +140,7 @@ struct iwl_lib_ops {
 	} apm_ops;
 	/* power */
 	int (*set_power)(struct iwl_priv *priv, void *cmd);
+	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
@@ -238,6 +239,11 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
 int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
 
 /*****************************************************
+ * TX power
+ ****************************************************/
+int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
+
+/*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 54e6ac8..b420f64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -683,8 +683,6 @@ extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
-extern int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv);
-extern int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
 extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
@@ -1167,10 +1165,9 @@ struct iwl_priv {
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
 	struct delayed_work post_associate;
-
-#define IWL_DEFAULT_TX_POWER 0x0F
-	s8 user_txpower_limit;
-	s8 max_channel_txpower_limit;
+	/* TX Power */
+	s8 tx_power_user_lmt;
+	s8 tx_power_channel_lmt;
 
 #ifdef CONFIG_PM
 	u32 pm_state[16];
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index cbb812f..4a08a1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -382,8 +382,8 @@ static int iwl_set_fat_chan_info(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x"
-			" %ddBm): Ad-Hoc %ssupported\n",
+	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
+			" Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
 			"5.2" : "2.4",
@@ -493,8 +493,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
-				       " %ddBm): Ad-Hoc %ssupported\n",
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm):"
+				       " Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
 				       "5.2" : "2.4",
@@ -515,8 +515,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			/* Set the user_txpower_limit to the highest power
 			 * supported by any channel */
 			if (eeprom_ch_info[ch].max_power_avg >
-			    priv->user_txpower_limit)
-				priv->user_txpower_limit =
+						priv->tx_power_user_lmt)
+				priv->tx_power_user_lmt =
 				    eeprom_ch_info[ch].max_power_avg;
 
 			ch_info++;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 510e403..af44819 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -367,9 +367,9 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = iwl4965_hw_reg_send_txpower(priv);
+	rc = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 	if (rc) {
-		IWL_ERROR("Error setting Tx power (%d).\n", rc);
+		IWL_ERROR("Error sending TX power (%d).\n", rc);
 		return rc;
 	}
 
@@ -3637,7 +3637,7 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 
-	IWL_DEBUG(IWL_DL_SCAN, "SCAN complete scan\n");
+	IWL_DEBUG_SCAN("SCAN complete scan\n");
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -3650,7 +3650,7 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	mutex_lock(&priv->mutex);
-	iwl4965_hw_reg_send_txpower(priv);
+	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -3930,6 +3930,11 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
+	IWL_DEBUG_MAC80211("TX Power old=%d new=%d\n",
+			   priv->tx_power_user_lmt, conf->power_level);
+
+	iwl_set_tx_power(priv, conf->power_level, false);
+
 	iwl4965_set_rate(priv);
 
 	if (memcmp(&priv->active_rxon,
@@ -4713,7 +4718,7 @@ static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	return sprintf(buf, "%d\n", priv->user_txpower_limit);
+	return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
 }
 
 static ssize_t store_tx_power(struct device *d,
@@ -4729,7 +4734,7 @@ static ssize_t store_tx_power(struct device *d,
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in decimal form.\n", buf);
 	else
-		iwl4965_hw_reg_set_txpower(priv, val);
+		iwl_set_tx_power(priv, val, false);
 
 	return count;
 }
-- 
1.5.3.6

