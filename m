Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0DIUJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/12] iwlwifi: default max event log size
Date: Fri,  9 Apr 2010 13:09:18 -0700
Message-Id: <1270843769-30017-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Size of event log is determined by uCode which is different per NICs.
Set the maximum event log size per device to better match uCode
configuration.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 ++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 ++++++---------
 8 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index b941b3e..9a0191a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -253,6 +253,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 128,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -282,6 +283,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 128,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f88f75d..7424586 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2770,6 +2770,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2789,6 +2790,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 DEFINE_PCI_DEVICE_TABLE(iwl3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6edae9b..0164c3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2250,6 +2250,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.temperature_kelvin = true,
 	.off_channel_workaround = true,
+	.max_event_log_size = 512,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ecc302e..e967cfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -423,6 +423,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -450,6 +451,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -475,6 +477,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -502,6 +505,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -529,6 +533,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -556,6 +561,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -581,6 +587,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7473518..dd03384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -394,6 +394,7 @@ struct iwl_cfg iwl6000i_g2_2agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6000i_2agn_cfg = {
@@ -427,6 +428,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -459,6 +461,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -491,6 +494,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -524,6 +528,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -556,6 +561,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -589,6 +595,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4f0cb80..978604f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1990,9 +1990,6 @@ static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 	return pos;
 }
 
-/* For sanity check only.  Actual size is determined by uCode, typ. 512 */
-#define MAX_EVENT_LOG_SIZE (512)
-
 #define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
 
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
@@ -2025,16 +2022,16 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
-	if (capacity > MAX_EVENT_LOG_SIZE) {
+	if (capacity > priv->cfg->max_event_log_size) {
 		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, MAX_EVENT_LOG_SIZE);
-		capacity = MAX_EVENT_LOG_SIZE;
+			capacity, priv->cfg->max_event_log_size);
+		capacity = priv->cfg->max_event_log_size;
 	}
 
-	if (next_entry > MAX_EVENT_LOG_SIZE) {
+	if (next_entry > priv->cfg->max_event_log_size) {
 		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, MAX_EVENT_LOG_SIZE);
-		next_entry = MAX_EVENT_LOG_SIZE;
+			next_entry, priv->cfg->max_event_log_size);
+		next_entry = priv->cfg->max_event_log_size;
 	}
 
 	size = num_wraps ? capacity : next_entry;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 10f9572..d89755f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -307,6 +307,7 @@ struct iwl_cfg {
 	u32 monitor_recover_period;
 	bool temperature_kelvin;
 	bool off_channel_workaround;
+	u32 max_event_log_size;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c9188b9..24e9694 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1603,9 +1603,6 @@ static int iwl3945_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 	return pos;
 }
 
-/* For sanity check only.  Actual size is determined by uCode, typ. 512 */
-#define IWL3945_MAX_EVENT_LOG_SIZE (512)
-
 #define DEFAULT_IWL3945_DUMP_EVENT_LOG_ENTRIES (20)
 
 int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
@@ -1632,16 +1629,16 @@ int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
-	if (capacity > IWL3945_MAX_EVENT_LOG_SIZE) {
+	if (capacity > priv->cfg->max_event_log_size) {
 		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, IWL3945_MAX_EVENT_LOG_SIZE);
-		capacity = IWL3945_MAX_EVENT_LOG_SIZE;
+			capacity, priv->cfg->max_event_log_size);
+		capacity = priv->cfg->max_event_log_size;
 	}
 
-	if (next_entry > IWL3945_MAX_EVENT_LOG_SIZE) {
+	if (next_entry > priv->cfg->max_event_log_size) {
 		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, IWL3945_MAX_EVENT_LOG_SIZE);
-		next_entry = IWL3945_MAX_EVENT_LOG_SIZE;
+			next_entry, priv->cfg->max_event_log_size);
+		next_entry = priv->cfg->max_event_log_size;
 	}
 
 	size = num_wraps ? capacity : next_entry;
-- 
1.6.3.3

