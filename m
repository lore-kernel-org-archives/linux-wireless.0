Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0HNPly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 11:41:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlwifi: long monitor timer
Date: Sat, 14 Aug 2010 08:45:50 -0700
Message-Id: <1281800751-20784-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Change the name for monitor timer, also adding define for long monitor
timer; long monitor timer can be used for the type of devices require longer
time to determine the uCode is stuck on tx and needed reload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 ++++++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   32 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 6 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index fec0262..0b779a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -265,7 +265,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -297,7 +297,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6950a78..8ccfcd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2731,7 +2731,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 };
@@ -2752,7 +2752,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d6da356..d92b729 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2322,7 +2322,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index aacf377..cd9f9fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -510,7 +510,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -541,7 +541,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -570,7 +570,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -601,7 +601,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -632,7 +632,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -663,7 +663,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -693,7 +693,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index af4fd50..b6468e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -388,7 +388,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -424,7 +424,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -459,7 +459,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -496,7 +496,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -532,7 +532,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -570,7 +570,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -606,7 +606,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -644,7 +644,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -680,7 +680,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -721,7 +721,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -756,7 +756,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -791,7 +791,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -828,7 +828,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -866,7 +866,7 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -902,7 +902,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -940,7 +940,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f35bcad..2e97cd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1049,7 +1049,8 @@ struct iwl_event_log {
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* timer constants use to monitor and recover stuck tx queues in mSecs */
-#define IWL_MONITORING_PERIOD  (1000)
+#define IWL_DEF_MONITORING_PERIOD	(1000)
+#define IWL_LONG_MONITORING_PERIOD	(5000)
 #define IWL_ONE_HUNDRED_MSECS   (100)
 #define IWL_SIXTY_SECS          (60000)
 
-- 
1.7.0.4

