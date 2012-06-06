Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2FFNXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 26/29] iwlwifi: fix typo 'IWL_WATCHHDOG_DISABLED'
Date: Wed,  6 Jun 2012 15:22:07 +0200
Message-Id: <1338988930-11561-26-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152334_189362_28DE16D0)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Paul Bolle <pebolle@tiscali.nl>

Commit 7c5ba4a830cbb730770129b0004e2a06e47dbac5 ("iwlwifi: move queue
watchdog into transport") introduced the named constant
'IWL_WATCHHDOG_DISABLED'. Rename it to 'IWL_WATCHDOG_DISABLED'.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-config.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/1000.c  |    2 +-
 drivers/net/wireless/iwlwifi/pcie/5000.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index ebdc8b9..c91b66c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1347,7 +1347,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		trans_cfg.queue_watchdog_timeout =
 			priv->cfg->base_params->wd_timeout;
 	else
-		trans_cfg.queue_watchdog_timeout = IWL_WATCHHDOG_DISABLED;
+		trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
 
 	ucode_flags = fw->ucode_capa.flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index e9accfc..10e4793 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -113,7 +113,7 @@ enum iwl_led_mode {
 #define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	0
 
 /* TX queue watchdog timeouts in mSecs */
-#define IWL_WATCHHDOG_DISABLED	0
+#define IWL_WATCHDOG_DISABLED	0
 #define IWL_DEF_WD_TIMEOUT	2000
 #define IWL_LONG_WD_TIMEOUT	10000
 #define IWL_MAX_WD_TIMEOUT	120000
diff --git a/drivers/net/wireless/iwlwifi/pcie/1000.c b/drivers/net/wireless/iwlwifi/pcie/1000.c
index 0269ea6..81b83f4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/1000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/1000.c
@@ -64,7 +64,7 @@ static const struct iwl_base_params iwl1000_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.wd_timeout = IWL_WATCHHDOG_DISABLED,
+	.wd_timeout = IWL_WATCHDOG_DISABLED,
 	.max_event_log_size = 128,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/5000.c b/drivers/net/wireless/iwlwifi/pcie/5000.c
index 745a358..d1665fa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/5000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/5000.c
@@ -62,7 +62,7 @@ static const struct iwl_base_params iwl5000_base_params = {
 	.led_compensation = 51,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.wd_timeout = IWL_WATCHHDOG_DISABLED,
+	.wd_timeout = IWL_WATCHDOG_DISABLED,
 	.max_event_log_size = 512,
 	.no_idle_support = true,
 };
-- 
1.7.10

