Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab1LBRQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:16:55 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/3] iwlwifi: change the default behavior of watchdog timer
Date: Fri,  2 Dec 2011 08:19:19 -0800
Message-Id: <1322842759-567-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_181701_733089_5F46E962)
In-Reply-To: <1322842759-567-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322842759-567-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current default watchdog timer is enabled, but we are seeing issues on
legacy devices. So change the default setting of watchdog timer to per
device based. But user still can use the "wd_disable" module parameter
to overwrite the system setting

Cc: stable@vger.kernel.org #3.0+
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-core.c   |   22 +++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    4 ++--
 6 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e12b48c..dd008b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -191,6 +191,7 @@ static struct iwl_base_params iwl1000_base_params = {
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 128,
+	.wd_disable = true,
 };
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c511c98..f55fb2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -364,6 +364,7 @@ static struct iwl_base_params iwl5000_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.no_idle_support = true,
+	.wd_disable = true,
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f556451..bacc06c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3498,9 +3498,10 @@ MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
 module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
 MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
 
-module_param_named(wd_disable, iwlagn_mod_params.wd_disable, bool, S_IRUGO);
+module_param_named(wd_disable, iwlagn_mod_params.wd_disable, int, S_IRUGO);
 MODULE_PARM_DESC(wd_disable,
-		"Disable stuck queue watchdog timer (default: 0 [enabled])");
+		"Disable stuck queue watchdog timer 0=system default, "
+		"1=disable, 2=enable (default: 0)");
 
 /*
  * set bt_coex_active to true, uCode will do kill/defer
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 001fdf1..fcf5416 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1810,11 +1810,23 @@ void iwl_setup_watchdog(struct iwl_priv *priv)
 {
 	unsigned int timeout = priv->cfg->base_params->wd_timeout;
 
-	if (timeout && !iwlagn_mod_params.wd_disable)
-		mod_timer(&priv->watchdog,
-			  jiffies + msecs_to_jiffies(IWL_WD_TICK(timeout)));
-	else
-		del_timer(&priv->watchdog);
+	if (!iwlagn_mod_params.wd_disable) {
+		/* use system default */
+		if (timeout && !priv->cfg->base_params->wd_disable)
+			mod_timer(&priv->watchdog,
+				jiffies +
+				msecs_to_jiffies(IWL_WD_TICK(timeout)));
+		else
+			del_timer(&priv->watchdog);
+	} else {
+		/* module parameter overwrite default configuration */
+		if (timeout && iwlagn_mod_params.wd_disable == 2)
+			mod_timer(&priv->watchdog,
+				jiffies +
+				msecs_to_jiffies(IWL_WD_TICK(timeout)));
+		else
+			del_timer(&priv->watchdog);
+	}
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 137da33..f2fc288 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -113,6 +113,7 @@ struct iwl_lib_ops {
  * @shadow_reg_enable: HW shadhow register bit
  * @no_idle_support: do not support idle mode
  * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
+ * wd_disable: disable watchdog timer
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -134,6 +135,7 @@ struct iwl_base_params {
 	const bool shadow_reg_enable;
 	const bool no_idle_support;
 	const bool hd_v2;
+	const bool wd_disable;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 1f7a93c..14eaf37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -120,7 +120,7 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @restart_fw: restart firmware, default = 1
  * @plcp_check: enable plcp health check, default = true
  * @ack_check: disable ack health check, default = false
- * @wd_disable: enable stuck queue check, default = false
+ * @wd_disable: enable stuck queue check, default = 0
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
  * @no_sleep_autoadjust: disable autoadjust, default = true
@@ -141,7 +141,7 @@ struct iwl_mod_params {
 	int restart_fw;
 	bool plcp_check;
 	bool ack_check;
-	bool wd_disable;
+	int  wd_disable;
 	bool bt_coex_active;
 	int led_mode;
 	bool no_sleep_autoadjust;
-- 
1.7.0.4

