Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYLIT2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:28:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/4] iwlwifi: remove qos module parameter
Date: Tue,  9 Dec 2008 11:29:01 -0800
Message-Id: <1228850941-16677-5-git-send-email-reinette.chatre@intel.com> (sfid-20081209_202812_918586_FE24CD1A)
In-Reply-To: <1228850941-16677-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-3-git-send-email-reinette.chatre@intel.com>
 <1228850941-16677-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

The ability of disabling qos from module params is not required anymore.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    8 --------
 drivers/net/wireless/iwlwifi/iwl-core.c |   30 ++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 6 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3afecf8..a7e6e32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -63,7 +63,6 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
 static struct iwl_mod_params iwl4965_mod_params = {
 	.num_of_queues = IWL49_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
-	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
@@ -2363,9 +2362,6 @@ MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
 module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
-/* QoS */
-module_param_named(qos_enable, iwl4965_mod_params.enable_qos, int, 0444);
-MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
 /* 11n */
 module_param_named(11n_disable, iwl4965_mod_params.disable_11n, int, 0444);
 MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1b82742..2344de9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1530,7 +1530,6 @@ static struct iwl_ops iwl5000_ops = {
 static struct iwl_mod_params iwl50_mod_params = {
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
-	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
@@ -1628,8 +1627,6 @@ module_param_named(debug50, iwl50_mod_params.debug, int, 0444);
 MODULE_PARM_DESC(debug50, "50XX debug output mask");
 module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
-module_param_named(qos_enable50, iwl50_mod_params.enable_qos, int, 0444);
-MODULE_PARM_DESC(qos_enable50, "enable all 50XX QoS functionality");
 module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, 0444);
 MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality");
 module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e6a82b7..3270b8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -547,9 +547,6 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!priv->qos_data.qos_enable)
-		return;
-
 	priv->qos_data.def_qos_parm.qos_flags = 0;
 
 	if (priv->qos_data.qos_cap.q_AP.queue_request &&
@@ -3122,11 +3119,6 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		return 0;
 	}
 
-	if (!priv->qos_data.qos_enable) {
-		priv->qos_data.qos_active = 0;
-		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
-		return 0;
-	}
 	q = AC_NUM - 1 - queue;
 
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3ef3c57..1c0d439 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -244,24 +244,25 @@ void iwl_reset_qos(struct iwl_priv *priv)
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
 	u8 aifs = 2;
-	u8 is_legacy = 0;
+	bool is_legacy = false;
 	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->qos_data.qos_active = 0;
+	/* QoS always active in AP and ADHOC mode
+	 * In STA mode wait for association
+	 */
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC ||
+	    priv->iw_mode == NL80211_IFTYPE_AP)
+		priv->qos_data.qos_active = 1;
+	else
+		priv->qos_data.qos_active = 0;
 
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-		if (!(priv->active_rate & 0xfff0)) {
-			cw_min = 31;
-			is_legacy = 1;
-		}
-	} else if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
+	/* check for legacy mode */
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+	    (priv->active_rate & IWL_OFDM_RATES_MASK) == 0) ||
+	    (priv->iw_mode == NL80211_IFTYPE_STATION &&
+	    (priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) == 0)) {
 		cw_min = 31;
 		is_legacy = 1;
 	}
@@ -891,9 +892,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	iwl_set_rxon_chain(priv);
 	iwl_init_scan_params(priv);
 
-	if (priv->cfg->mod_params->enable_qos)
-		priv->qos_data.qos_enable = 1;
-
 	iwl_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 983042b..72f82ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -157,7 +157,6 @@ struct iwl_mod_params {
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int num_of_ampdu_queues;/* def: HW dependent */
-	int enable_qos;		/* def: 1 = use quality of service */
 	int disable_11n;	/* def: 0 = disable 11n capabilities */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c32012e..fc859f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -436,7 +436,6 @@ union iwl_qos_capabity {
 
 /* QoS structures */
 struct iwl_qos_info {
-	int qos_enable;
 	int qos_active;
 	union iwl_qos_capabity qos_cap;
 	struct iwl_qosparam_cmd def_qos_parm;
-- 
1.5.4.3

