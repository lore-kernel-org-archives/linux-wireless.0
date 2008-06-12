Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48781 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYFLBtb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/29] iwlwifi: removes the RUN_TIME_CALIB ifdef
Date: Thu, 12 Jun 2008 09:46:52 +0800
Message-Id: <1213235239-2954-3-git-send-email-yi.zhu@intel.com> (sfid-20080612_034939_665168_5BCE0B91)
In-Reply-To: <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes the possibility not to compile the run time
calibrations. It also renames priv->sensitivity_work to
priv->run_time_calib_work, and moves bg_run_time_calib to iwl4965_base
since it is common to both: 4965 and 5000.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   28 -------------------
 drivers/net/wireless/iwlwifi/Makefile       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   39 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 -------
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 -
 drivers/net/wireless/iwlwifi/iwl-calib.h    |   20 --------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    4 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 +-------
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 ++++++++++++++++
 12 files changed, 27 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b992428..a382c00 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -14,15 +14,6 @@ config IWLWIFI_LEDS
 	bool
 	default n
 
-config IWLWIFI_RUN_TIME_CALIB
-	bool
-	depends on IWLCORE
-	default n
-	---help---
-	  This option will enable run time calibration for the iwlwifi driver.
-	  These calibrations are Sensitivity and Chain Noise.
-
-
 config IWLWIFI_RFKILL
 	boolean "IWLWIFI RF kill support"
 	depends on IWLCORE
@@ -68,15 +59,6 @@ config IWL4965_SPECTRUM_MEASUREMENT
 	---help---
 	  This option will enable spectrum measurement for the iwl4965 driver.
 
-config IWL4965_RUN_TIME_CALIB
-	bool "Enable run time Calibration for 4965 NIC"
-	select IWLWIFI_RUN_TIME_CALIB
-	depends on IWL4965
-	default y
-	---help---
-	  This option will enable run time calibration for the iwl4965 driver.
-	  These calibrations are Sensitivity and Chain Noise. If unsure, say yes
-
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in iwl4965 driver"
 	depends on IWL4965
@@ -110,16 +92,6 @@ config IWL5000
 	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
 	  Dependency on 4965 is temporary
 
-config IWL5000_RUN_TIME_CALIB
-	bool "Enable run time Calibration for 5000 NIC"
-	select IWLWIFI_RUN_TIME_CALIB
-	depends on IWL5000
-	default y
-	---help---
-	  This option will enable run time calibration for the iwl5000 driver.
-	  These calibrations are Sensitivity and Chain Noise. If unsure, say yes
-
-
 config IWLWIFI_DEBUGFS
         bool "Iwlwifi debugfs support"
         depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 5c73eed..184fdee 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,10 +1,9 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
-iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
+iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o iwl-calib.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
-iwlcore-$(CONFIG_IWLWIFI_RUN_TIME_CALIB) += iwl-calib.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 84414da..e2c2d9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -652,8 +652,6 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 			cmd.critical_temperature_R);
 }
 
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
@@ -741,30 +739,6 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 	data->beacon_count = 0;
 }
 
-static void iwl4965_bg_sensitivity_work(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-			sensitivity_work);
-
-	mutex_lock(&priv->mutex);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    test_bit(STATUS_SCANNING, &priv->status)) {
-		mutex_unlock(&priv->mutex);
-		return;
-	}
-
-	if (priv->start_calib) {
-		iwl_chain_noise_calibration(priv, &priv->statistics);
-
-		iwl_sensitivity_calibration(priv, &priv->statistics);
-	}
-
-	mutex_unlock(&priv->mutex);
-	return;
-}
-#endif /*CONFIG_IWL4965_RUN_TIME_CALIB*/
-
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -920,7 +894,6 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	return ret;
 }
 
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 	.min_nrg_cck = 97,
 	.max_nrg_cck = 0,
@@ -943,7 +916,6 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 	.nrg_th_cck = 100,
 	.nrg_th_ofdm = 100,
 };
-#endif
 
 /**
  * iwl4965_hw_set_hw_params
@@ -983,9 +955,7 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_rx_ant = ANT_A | ANT_B;
 	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
 
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	priv->hw_params.sens = &iwl4965_sensitivity;
-#endif
 
 	return 0;
 }
@@ -2123,9 +2093,7 @@ void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl4965_rx_calc_noise(priv);
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-		queue_work(priv->workqueue, &priv->sensitivity_work);
-#endif
+		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
 
 	iwl_leds_background(priv);
@@ -3504,9 +3472,6 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
-#endif
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
@@ -3527,10 +3492,8 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.get_hcmd_size = iwl4965_get_hcmd_size,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
-#endif
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6548477..fc8ad73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -300,8 +300,6 @@ err:
 
 }
 
-#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
-
 static void iwl5000_gain_computation(struct iwl_priv *priv,
 		u32 average_noise[NUM_RX_CHAINS],
 		u16 min_average_noise_antenna_i,
@@ -354,7 +352,6 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 	data->beacon_count = 0;
 }
 
-
 static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
@@ -393,10 +390,6 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.nrg_th_ofdm = 95,
 };
 
-#endif /* CONFIG_IWL5000_RUN_TIME_CALIB */
-
-
-
 static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
@@ -847,9 +840,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
 	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
 	priv->hw_params.sens = &iwl5000_sensitivity;
-#endif
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_5100:
@@ -1309,10 +1300,8 @@ static struct iwl_hcmd_ops iwl5000_hcmd = {
 static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.get_hcmd_size = iwl5000_get_hcmd_size,
 	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
-#ifdef CONFIG_IWL5000_RUN_TIME_CALIB
 	.gain_computation = iwl5000_gain_computation,
 	.chain_noise_reset = iwl5000_chain_noise_reset,
-#endif
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index a6c7f0d..72242a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -435,8 +435,6 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data = &(priv->sensitivity_data);
 
 	if (ranges == NULL)
-		/* can happen if IWLWIFI_RUN_TIME_CALIB is selected
-		 * but no IWLXXXX_RUN_TIME_CALIB for specific is selected */
 		return;
 
 	memset(data, 0, sizeof(struct iwl_sensitivity_data));
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index b8e57c5..45f37cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -71,7 +71,6 @@
 #include "iwl-core.h"
 #include "iwl-dev.h"
 
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 void iwl_chain_noise_calibration(struct iwl_priv *priv,
 				struct iwl4965_notif_statistics *stat_resp);
 void iwl_sensitivity_calibration(struct iwl_priv *priv,
@@ -86,24 +85,5 @@ static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
 	    priv->cfg->ops->utils->chain_noise_reset)
 		priv->cfg->ops->utils->chain_noise_reset(priv);
 }
-#else
-static inline void iwl_chain_noise_calibration(struct iwl_priv *priv,
-				struct iwl4965_notif_statistics *stat_resp)
-{
-}
-static inline void iwl_sensitivity_calibration(struct iwl_priv *priv,
-				struct iwl4965_notif_statistics *resp)
-{
-}
-static inline void iwl_init_sensitivity(struct iwl_priv *priv)
-{
-}
-static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
-{
-}
-static inline void iwl_reset_run_time_calib(struct iwl_priv *priv)
-{
-}
-#endif
 
 #endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d9c5bd1..192cda2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -88,13 +88,11 @@ struct iwl_hcmd_ops {
 struct iwl_hcmd_utils_ops {
 	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	void (*gain_computation)(struct iwl_priv *priv,
 			u32 *average_noise,
 			u16 min_average_noise_antennat_i,
 			u32 min_average_noise);
 	void (*chain_noise_reset)(struct iwl_priv *priv);
-#endif
 };
 
 struct iwl_lib_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 11de561..48563a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -55,10 +55,8 @@ struct iwl_debugfs {
 		struct dentry *file_log_event;
 	} dbgfs_data_files;
 	struct dir_rf_files {
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 		struct dentry *file_disable_sensitivity;
 		struct dentry *file_disable_chain_noise;
-#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 	} dbgfs_rf_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d5f9df1..da6dcb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -385,11 +385,9 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(stations, data);
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
-#endif  /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 	return 0;
 
 err:
@@ -415,10 +413,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 	DEBUGFS_REMOVE(priv->dbgfs->dir_rf);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
 	kfree(priv->dbgfs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 59a6960..631931c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -602,9 +602,7 @@ struct iwl_hw_params {
 	u32 max_data_size;
 	u32 max_bsm_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	const struct iwl_sensitivity_ranges *sens;
-#endif
 };
 
 #define HT_SHORT_GI_20MHZ	(1 << 0)
@@ -882,7 +880,6 @@ enum ucode_type {
 	UCODE_RT
 };
 
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 /* Sensitivity calib data */
 struct iwl_sensitivity_data {
 	u32 auto_corr_ofdm;
@@ -924,7 +921,6 @@ struct iwl_chain_noise_data {
 	u8 delta_gain_code[NUM_RX_CHAINS];
 	u8 radio_write;
 };
-#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
@@ -1057,11 +1053,9 @@ struct iwl_priv {
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
 	u8 start_calib;
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
-#endif /*CONFIG_IWLWIFI_RUN_TIME_CALIB*/
 
 	struct iwl_ht_info current_ht_config;
 	u8 last_phy_res[100];
@@ -1211,13 +1205,9 @@ struct iwl_priv {
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 	struct work_struct txpower_work;
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	u32 disable_sens_cal;
 	u32 disable_chain_noise_cal;
-#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
-#ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-	struct work_struct sensitivity_work;
-#endif /* CONFIG_IWL4965_RUN_TIME_CALIB */
+	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index cc61c93..c248448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -451,7 +451,6 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 
 {
-#ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_missed_beacon_notif *missed_beacon;
 
@@ -465,6 +464,5 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 		if (!test_bit(STATUS_SCANNING, &priv->status))
 			iwl_init_sensitivity(priv);
 	}
-#endif /* CONFIG_IWLWIFI_RUN_TIME_CALIB */
 }
 EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 88229e2..a8dfdcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3423,6 +3423,29 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwl_bg_run_time_calib_work(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
+			run_time_calib_work);
+
+	mutex_lock(&priv->mutex);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    test_bit(STATUS_SCANNING, &priv->status)) {
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
+	if (priv->start_calib) {
+		iwl_chain_noise_calibration(priv, &priv->statistics);
+
+		iwl_sensitivity_calibration(priv, &priv->statistics);
+	}
+
+	mutex_unlock(&priv->mutex);
+	return;
+}
+
 static void iwl4965_bg_up(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
@@ -5014,6 +5037,7 @@ static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->rf_kill, iwl4965_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl4965_bg_beacon_update);
 	INIT_WORK(&priv->set_monitor, iwl4965_bg_set_monitor);
+	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_DELAYED_WORK(&priv->post_associate, iwl4965_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
-- 
1.5.3.6

