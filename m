Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab1DRRFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlagn: always support uCode trace
Date: Mon, 18 Apr 2011 09:44:12 -0700
Message-Id: <1303145057-6545-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All _agn devices support continuous uCode trace, remove checking

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 --
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 +--
 6 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 809117d..e784456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -242,7 +242,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 128,
-	.ucode_tracing = true,
 };
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0a330d1..dcd6608 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -348,7 +348,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.ucode_tracing = true,
 	.shadow_reg_enable = true,
 };
 
@@ -368,7 +367,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.ucode_tracing = true,
 	.shadow_reg_enable = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 79dd45c..14b75f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -467,7 +467,6 @@ static struct iwl_base_params iwl5000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.ucode_tracing = true,
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a35338e..81881aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -437,7 +437,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.ucode_tracing = true,
 	.shadow_reg_enable = true,
 };
 
@@ -456,7 +455,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.chain_noise_scale = 1500,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
-	.ucode_tracing = true,
 	.shadow_reg_enable = true,
 };
 static struct iwl_base_params iwl6000_g2_base_params = {
@@ -474,7 +472,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
-	.ucode_tracing = true,
 	.shadow_reg_enable = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 240abdf..2e8c936 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -249,7 +249,6 @@ struct iwl_mod_params {
  * @wd_timeout: TX queues watchdog timeout
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
- * @ucode_tracing: support ucode continuous tracing
  * @shadow_reg_enable: HW shadhow register bit
  */
 struct iwl_base_params {
@@ -271,7 +270,6 @@ struct iwl_base_params {
 	unsigned int wd_timeout;
 	bool temperature_kelvin;
 	u32 max_event_log_size;
-	const bool ucode_tracing;
 	const bool shadow_reg_enable;
 };
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 897efac..c272204 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1749,8 +1749,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	if (priv->cfg->base_params->ucode_tracing)
-		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
-- 
1.7.0.4

