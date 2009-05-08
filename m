Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbZEHUiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/11] iwlwifi: clean up PS code
Date: Fri,  8 May 2009 13:44:38 -0700
Message-Id: <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This removes all the dead code that tries to adjust the power
saving level based on the system AC state (inacceptable policy
in the kernel) or based on overtemp conditions (unused).

Also, pass _all_ policy wrt. enabling PS to mac80211, since
we do not use the power_disabled internally I now use that to
mirror the mac80211 CONF_PS setting. When mac80211 turns off
CONF_PS we follow suit. This means that the user power level
(which can currently only be set from sysfs) is not touched
for mac80211 powersave changes.

This means no "association status" checks are necessary since
mac80211 will not allow power save to be enabled when not
associated.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   24 +---
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   26 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c    |  228 ++++-----------------------
 drivers/net/wireless/iwlwifi/iwl-power.h    |   39 +----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   20 +--
 7 files changed, 48 insertions(+), 292 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 43bc8a6..13a35dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1838,7 +1838,6 @@ void iwl_post_associate(struct iwl_priv *priv)
 	if (!priv->vif || !priv->is_open)
 		return;
 
-	iwl_power_cancel_timeout(priv);
 	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -1914,7 +1913,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 	 * If chain noise has already been run, then we need to enable
 	 * power management here */
 	if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
-		iwl_power_enable_management(priv);
+		iwl_power_update_mode(priv, 0);
 
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl_chain_noise_reset(priv);
@@ -2465,26 +2464,11 @@ static ssize_t show_power_level(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	int mode = priv->power_data.user_power_setting;
-	int system = priv->power_data.system_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	switch (system) {
-	case IWL_POWER_SYS_AUTO:
-		p += sprintf(p, "SYSTEM:auto");
-		break;
-	case IWL_POWER_SYS_AC:
-		p += sprintf(p, "SYSTEM:ac");
-		break;
-	case IWL_POWER_SYS_BATTERY:
-		p += sprintf(p, "SYSTEM:battery");
-		break;
-	}
-
-	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
-			"fixed" : "auto");
-	p += sprintf(p, "\tINDEX:%d", level);
-	p += sprintf(p, "\n");
+	p += sprintf(p, "INDEX:%d\t", level);
+	p += sprintf(p, "USER:%d\n", mode);
 	return p - buf + 1;
 }
 
@@ -2553,7 +2537,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
 	iwl_setup_scan_deferred_work(priv);
-	iwl_setup_power_deferred_work(priv);
 
 	if (priv->cfg->ops->lib->setup_deferred_work)
 		priv->cfg->ops->lib->setup_deferred_work(priv);
@@ -2573,7 +2556,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
-	cancel_delayed_work_sync(&priv->set_power_save);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 735f3f1..a5d6367 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -857,7 +857,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		priv->cfg->ops->lib->update_chain_flags(priv);
 
 	data->state = IWL_CHAIN_NOISE_DONE;
-	iwl_power_enable_management(priv);
+	iwl_power_update_mode(priv, 0);
 }
 EXPORT_SYMBOL(iwl_chain_noise_calibration);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b50fc9b..1ecb77d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1353,7 +1353,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -2577,14 +2576,13 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_rate(priv);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS)
-			ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
-		else
-			ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
+	if (changed & IEEE80211_CONF_CHANGE_PS &&
+	    priv->iw_mode == NL80211_IFTYPE_STATION) {
+		priv->power_data.power_disabled =
+			!(conf->flags & IEEE80211_CONF_PS);
+		ret = iwl_power_update_mode(priv, 0);
 		if (ret)
 			IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
-
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -2720,21 +2718,7 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 		iwlcore_commit_rxon(priv);
 	}
 
-	iwl_power_update_mode(priv, 0);
-
-	/* Per mac80211.h: This is only used in IBSS mode... */
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-
-		/* switch to CAM during association period.
-		 * the ucode will block any association/authentication
-		 * frome during assiciation period if it can not hear
-		 * the AP because of PM. the timer enable PM back is
-		 * association do not complete
-		 */
-		if (priv->hw->conf.channel->flags &
-		    (IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_RADAR))
-				iwl_power_disable_management(priv, 3000);
-
 		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0f2c1b2..3049ba2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1075,7 +1075,6 @@ struct iwl_priv {
 
 	struct tasklet_struct irq_tasklet;
 
-	struct delayed_work set_power_save;
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index c913069..f2ea3f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -41,38 +41,33 @@
 #include "iwl-power.h"
 
 /*
- * Setting power level allow the card to go to sleep when not busy
- * there are three factor that decide the power level to go to, they
- * are list here with its priority
- *  1- critical_power_setting this will be set according to card temperature.
- *  2- system_power_setting this will be set by system PM manager.
- *  3- user_power_setting this will be set by user either by writing to sys or
- *  	mac80211
+ * Setting power level allow the card to go to sleep when not busy.
  *
- * if system_power_setting and user_power_setting is set to auto
- * the power level will be decided according to association status and battery
- * status.
+ * The power level is set to INDEX_1 (the least deep state) by
+ * default, and will, in the future, be the deepest state unless
+ * otherwise required by pm_qos network latency requirements.
  *
+ * Using INDEX_1 without pm_qos is ok because mac80211 will disable
+ * PS when even checking every beacon for the TIM bit would exceed
+ * the required latency.
  */
 
-#define MSEC_TO_USEC 1024
 #define IWL_POWER_RANGE_0_MAX  (2)
 #define IWL_POWER_RANGE_1_MAX  (10)
 
 
-
-#define IWL_POWER_ON_BATTERY		IWL_POWER_INDEX_5
-#define IWL_POWER_ON_AC_DISASSOC	IWL_POWER_MODE_CAM
-#define IWL_POWER_ON_AC_ASSOC		IWL_POWER_MODE_CAM
-
-
-#define IWL_CT_KILL_TEMPERATURE		110
-#define IWL_MIN_POWER_TEMPERATURE	100
-#define IWL_REDUCED_POWER_TEMPERATURE	95
-
+#define NOSLP cpu_to_le16(0), 0, 0
+#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
+#define TU_TO_USEC 1024
+#define SLP_TOUT(T) cpu_to_le32((T) * TU_TO_USEC)
+#define SLP_VEC(X0, X1, X2, X3, X4) {cpu_to_le32(X0), \
+				     cpu_to_le32(X1), \
+				     cpu_to_le32(X2), \
+				     cpu_to_le32(X3), \
+				     cpu_to_le32(X4)}
 /* default power management (not Tx power) table values */
-/* for TIM  0-10 */
-static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
+/* for DTIM period 0 through IWL_POWER_RANGE_0_MAX */
+static const struct iwl_power_vec_entry range_0[IWL_POWER_NUM] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
@@ -82,8 +77,8 @@ static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
 };
 
 
-/* for TIM = 3-10 */
-static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
+/* for DTIM period IWL_POWER_RANGE_0_MAX + 1 through IWL_POWER_RANGE_1_MAX */
+static const struct iwl_power_vec_entry range_1[IWL_POWER_NUM] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 3, 4, 7)}, 0},
@@ -92,8 +87,8 @@ static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 7, 10, 10)}, 2}
 };
 
-/* for TIM > 11 */
-static struct iwl_power_vec_entry range_2[IWL_POWER_MAX] = {
+/* for DTIM period > IWL_POWER_RANGE_1_MAX */
+static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
@@ -109,35 +104,12 @@ static int iwl_set_power(struct iwl_priv *priv, void *cmd)
 	return iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
-/* decide the right power level according to association status
- * and battery status
- */
-static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
-{
-	u16 mode;
-
-	switch (priv->power_data.user_power_setting) {
-	case IWL_POWER_AUTO:
-		/* if running on battery */
-		if (priv->power_data.is_battery_active)
-			mode = IWL_POWER_ON_BATTERY;
-		else if (iwl_is_associated(priv))
-			mode = IWL_POWER_ON_AC_ASSOC;
-		else
-			mode = IWL_POWER_ON_AC_DISASSOC;
-		break;
-	default:
-		mode = priv->power_data.user_power_setting;
-		break;
-	}
-	return mode;
-}
 
 /* initialize to default */
 static void iwl_power_init_handle(struct iwl_priv *priv)
 {
 	struct iwl_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
+	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_NUM;
 	struct iwl_powertable_cmd *cmd;
 	int i;
 	u16 lctl;
@@ -156,7 +128,7 @@ static void iwl_power_init_handle(struct iwl_priv *priv)
 
 	IWL_DEBUG_POWER(priv, "adjust power command flags\n");
 
-	for (i = 0; i < IWL_POWER_MAX; i++) {
+	for (i = 0; i < IWL_POWER_NUM; i++) {
 		cmd = &pow_data->pwr_range_0[i].cmd;
 
 		if (lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN)
@@ -246,33 +218,12 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
 			priv->chain_noise_data.state == IWL_CHAIN_NOISE_ALIVE;
 
-	/* If on battery, set to 3,
-	 * if plugged into AC power, set to CAM ("continuously aware mode"),
-	 * else user level */
-
-	switch (setting->system_power_setting) {
-	case IWL_POWER_SYS_AUTO:
-		final_mode = iwl_get_auto_power_mode(priv);
-		break;
-	case IWL_POWER_SYS_BATTERY:
-		final_mode = IWL_POWER_INDEX_3;
-		break;
-	case IWL_POWER_SYS_AC:
-		final_mode = IWL_POWER_MODE_CAM;
-		break;
-	default:
-		final_mode = IWL_POWER_INDEX_3;
-		WARN_ON(1);
-	}
-
-	if (setting->critical_power_setting > final_mode)
-		final_mode = setting->critical_power_setting;
+	final_mode = priv->power_data.user_power_setting;
 
-	/* driver only support CAM for non STA network */
-	if (priv->iw_mode != NL80211_IFTYPE_STATION)
+	if (setting->power_disabled)
 		final_mode = IWL_POWER_MODE_CAM;
 
-	if (iwl_is_ready_rf(priv) && !setting->power_disabled &&
+	if (iwl_is_ready_rf(priv) &&
 	    ((setting->power_mode != final_mode) || force)) {
 		struct iwl_powertable_cmd cmd;
 
@@ -289,8 +240,6 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 
 		if (final_mode == IWL_POWER_MODE_CAM)
 			clear_bit(STATUS_POWER_PMI, &priv->status);
-		else
-			set_bit(STATUS_POWER_PMI, &priv->status);
 
 		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
 			priv->cfg->ops->lib->update_chain_flags(priv);
@@ -306,51 +255,10 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 }
 EXPORT_SYMBOL(iwl_power_update_mode);
 
-/* Allow other iwl code to disable/enable power management active
- * this will be useful for rate scale to disable PM during heavy
- * Tx/Rx activities
- */
-int iwl_power_disable_management(struct iwl_priv *priv, u32 ms)
-{
-	u16 prev_mode;
-	int ret = 0;
-
-	if (priv->power_data.power_disabled)
-		return -EBUSY;
-
-	prev_mode = priv->power_data.user_power_setting;
-	priv->power_data.user_power_setting = IWL_POWER_MODE_CAM;
-	ret = iwl_power_update_mode(priv, 0);
-	priv->power_data.power_disabled = 1;
-	priv->power_data.user_power_setting = prev_mode;
-	cancel_delayed_work(&priv->set_power_save);
-	if (ms)
-		queue_delayed_work(priv->workqueue, &priv->set_power_save,
-				   msecs_to_jiffies(ms));
-
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_power_disable_management);
-
-/* Allow other iwl code to disable/enable power management active
- * this will be useful for rate scale to disable PM during high
- * volume activities
- */
-int iwl_power_enable_management(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	priv->power_data.power_disabled = 0;
-	ret = iwl_power_update_mode(priv, 0);
-	return ret;
-}
-EXPORT_SYMBOL(iwl_power_enable_management);
-
 /* set user_power_setting */
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 {
-	if (mode > IWL_POWER_MAX)
+	if (mode >= IWL_POWER_NUM)
 		return -EINVAL;
 
 	priv->power_data.user_power_setting = mode;
@@ -359,86 +267,12 @@ int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 }
 EXPORT_SYMBOL(iwl_power_set_user_mode);
 
-/* set system_power_setting. This should be set by over all
- * PM application.
- */
-int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode)
-{
-	if (mode < IWL_POWER_SYS_MAX)
-		priv->power_data.system_power_setting = mode;
-	else
-		return -EINVAL;
-	return iwl_power_update_mode(priv, 0);
-}
-EXPORT_SYMBOL(iwl_power_set_system_mode);
-
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
 	iwl_power_init_handle(priv);
-	priv->power_data.user_power_setting = IWL_POWER_AUTO;
-	priv->power_data.system_power_setting = IWL_POWER_SYS_AUTO;
-	priv->power_data.power_disabled = 0;
-	priv->power_data.is_battery_active = 0;
-	priv->power_data.critical_power_setting = 0;
+	priv->power_data.user_power_setting = IWL_POWER_INDEX_1;
+	/* default to disabled until mac80211 says otherwise */
+	priv->power_data.power_disabled = 1;
 }
 EXPORT_SYMBOL(iwl_power_initialize);
-
-/* set critical_power_setting according to temperature value */
-int iwl_power_temperature_change(struct iwl_priv *priv)
-{
-	int ret = 0;
-	s32 temperature = KELVIN_TO_CELSIUS(priv->last_temperature);
-	u16 new_critical = priv->power_data.critical_power_setting;
-
-	if (temperature > IWL_CT_KILL_TEMPERATURE)
-		return 0;
-	else if (temperature > IWL_MIN_POWER_TEMPERATURE)
-		new_critical = IWL_POWER_INDEX_5;
-	else if (temperature > IWL_REDUCED_POWER_TEMPERATURE)
-		new_critical = IWL_POWER_INDEX_3;
-	else
-		new_critical = IWL_POWER_MODE_CAM;
-
-	if (new_critical != priv->power_data.critical_power_setting)
-		priv->power_data.critical_power_setting = new_critical;
-
-	if (priv->power_data.critical_power_setting >
-				priv->power_data.power_mode)
-		ret = iwl_power_update_mode(priv, 0);
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_power_temperature_change);
-
-static void iwl_bg_set_power_save(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work,
-				struct iwl_priv, set_power_save.work);
-	IWL_DEBUG_POWER(priv, "update power\n");
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	/* on starting association we disable power management
-	 * until association, if association failed then this
-	 * timer will expire and enable PM again.
-	 */
-	if (!iwl_is_associated(priv))
-		iwl_power_enable_management(priv);
-
-	mutex_unlock(&priv->mutex);
-}
-void iwl_setup_power_deferred_work(struct iwl_priv *priv)
-{
-	INIT_DELAYED_WORK(&priv->set_power_save, iwl_bg_set_power_save);
-}
-EXPORT_SYMBOL(iwl_setup_power_deferred_work);
-
-void iwl_power_cancel_timeout(struct iwl_priv *priv)
-{
-	cancel_delayed_work(&priv->set_power_save);
-}
-EXPORT_SYMBOL(iwl_power_cancel_timeout);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 1896339..37ba3bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -40,56 +40,29 @@ enum {
 	IWL_POWER_INDEX_3,
 	IWL_POWER_INDEX_4,
 	IWL_POWER_INDEX_5,
-	IWL_POWER_AUTO,
-	IWL_POWER_MAX = IWL_POWER_AUTO,
+	IWL_POWER_NUM
 };
 
-enum {
-	IWL_POWER_SYS_AUTO,
-	IWL_POWER_SYS_AC,
-	IWL_POWER_SYS_BATTERY,
-	IWL_POWER_SYS_MAX,
-};
-
-
 /* Power management (not Tx power) structures */
 
-#define NOSLP cpu_to_le16(0), 0, 0
-#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
-#define SLP_TOUT(T) cpu_to_le32((T) * MSEC_TO_USEC)
-#define SLP_VEC(X0, X1, X2, X3, X4) {cpu_to_le32(X0), \
-				     cpu_to_le32(X1), \
-				     cpu_to_le32(X2), \
-				     cpu_to_le32(X3), \
-				     cpu_to_le32(X4)}
 struct iwl_power_vec_entry {
 	struct iwl_powertable_cmd cmd;
 	u8 no_dtim;
 };
 
 struct iwl_power_mgr {
-	spinlock_t lock;
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_MAX];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_MAX];
-	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_MAX];
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_NUM];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_NUM];
+	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_NUM];
 	u32 dtim_period;
 	/* final power level that used to calculate final power command */
 	u8 power_mode;
-	u8 user_power_setting; /* set by user through mac80211 or sysfs */
-	u8 system_power_setting; /* set by kernel system tools */
-	u8 critical_power_setting; /* set if driver over heated */
-	u8 is_battery_active; /* DC/AC power */
-	u8 power_disabled; /* flag to disable using power saving level */
+	u8 user_power_setting; /* set by user through sysfs */
+	u8 power_disabled; /* set by mac80211's CONF_PS */
 };
 
-void iwl_setup_power_deferred_work(struct iwl_priv *priv);
-void iwl_power_cancel_timeout(struct iwl_priv *priv);
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
-int iwl_power_disable_management(struct iwl_priv *priv, u32 ms);
-int iwl_power_enable_management(struct iwl_priv *priv);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
-int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode);
 void iwl_power_initialize(struct iwl_priv *priv);
-int iwl_power_temperature_change(struct iwl_priv *priv);
 
 #endif  /* __iwl_power_setting_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 271e5d1..c32ec80 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3845,26 +3845,11 @@ static ssize_t show_power_level(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	int mode = priv->power_data.user_power_setting;
-	int system = priv->power_data.system_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	switch (system) {
-	case IWL_POWER_SYS_AUTO:
-		p += sprintf(p, "SYSTEM:auto");
-		break;
-	case IWL_POWER_SYS_AC:
-		p += sprintf(p, "SYSTEM:ac");
-		break;
-	case IWL_POWER_SYS_BATTERY:
-		p += sprintf(p, "SYSTEM:battery");
-		break;
-	}
-
-	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
-			"fixed" : "auto");
-	p += sprintf(p, "\tINDEX:%d", level);
-	p += sprintf(p, "\n");
+	p += sprintf(p, "INDEX:%d\t", level);
+	p += sprintf(p, "USER:%d\n", mode);
 	return p - buf + 1;
 }
 
@@ -4108,7 +4093,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
-- 
1.5.6.3

