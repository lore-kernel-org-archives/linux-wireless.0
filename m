Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab1GAPxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/11] iwlagn: add module parameter to disable stuck queue watchdog timer
Date: Fri,  1 Jul 2011 08:19:58 -0700
Message-Id: <1309533605-25774-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175331_181231_D77318D3)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the parameter to disable stuck queue watchdog timer, different platforms
might have different timing. Provide the option to disable the timer to prevent
un-necessary firmware reload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e2f6b2a..58789e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3820,6 +3820,10 @@ MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
 module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
 MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
 
+module_param_named(wd_disable, iwlagn_mod_params.wd_disable, bool, S_IRUGO);
+MODULE_PARM_DESC(wd_disable,
+		"Disable stuck queue watchdog timer (default: 0 [enabled])");
+
 /*
  * set bt_coex_active to true, uCode will do kill/defer
  * every time the priority line is asserted (BT is sending signals on the
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7f16d12..c5fa232 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1853,7 +1853,7 @@ void iwl_setup_watchdog(struct iwl_priv *priv)
 {
 	unsigned int timeout = priv->cfg->base_params->wd_timeout;
 
-	if (timeout)
+	if (timeout && !iwlagn_mod_params.wd_disable)
 		mod_timer(&priv->watchdog,
 			  jiffies + msecs_to_jiffies(IWL_WD_TICK(timeout)));
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f881678..a311cf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -160,6 +160,7 @@ struct iwl_mod_params {
 	int restart_fw;		/* def: 1 = restart firmware */
 	bool plcp_check;	/* def: true = enable plcp health check */
 	bool ack_check;		/* def: false = disable ack health check */
+	bool wd_disable;	/* def: false = enable stuck queue check */
 	bool bt_coex_active;	/* def: true = enable bt coex */
 	int led_mode;		/* def: 0 = system default */
 	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
-- 
1.7.0.4

