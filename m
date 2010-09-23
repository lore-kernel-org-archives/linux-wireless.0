Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab0IWVD7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 17:03:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: greg@kroah.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6.35] use long timer for un-necessary reload the firmware
Date: Thu, 23 Sep 2010 14:04:24 -0700
Message-Id: <1285275864-12703-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different devices has different timing requirement, change the timeout
value for 5000 series devices to avoid un-necessary firmware reload which
can cause device become unstable.For 5000 series of devices, use long monitor timer to check
stuck tx queues.

It is being reported firmware got reload more
often than necessary, so extend the timer to avoid un-necessary reload.

This fixes:
http://article.gmane.org/gmane.linux.kernel.wireless.general/53552

Cc: stable@kernel.org [2.6.35]
Reported-by: drago01 <drago01@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 ++-
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 6be2992..f9fdb53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -257,7 +257,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -289,7 +289,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index c44a303..a52c468 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2895,7 +2895,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 };
@@ -2916,7 +2916,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d3afdda..abbfa02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2274,7 +2274,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a28af7e..b5629a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -462,7 +462,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -493,7 +493,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -522,7 +522,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -553,7 +553,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -584,7 +584,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -615,7 +615,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -644,7 +644,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9fbf54c..eaee975 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -438,7 +438,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -478,7 +478,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -513,7 +513,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -548,7 +548,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -585,7 +585,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -620,7 +620,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -657,7 +657,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f3f3473..df69540 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1057,7 +1057,8 @@ struct iwl_event_log {
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* timer constants use to monitor and recover stuck tx queues in mSecs */
-#define IWL_MONITORING_PERIOD  (1000)
+#define IWL_DEF_MONITORING_PERIOD	(1000)
+#define IWL_LONG_MONITORING_PERIOD	(5000)
 #define IWL_ONE_HUNDRED_MSECS   (100)
 #define IWL_SIXTY_SECS          (60000)
 
-- 
1.7.0.4

