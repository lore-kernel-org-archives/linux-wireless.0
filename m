Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYICDbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 30/39] iwlwifi: allow association on radar channel in power save
Date: Wed,  3 Sep 2008 11:26:50 +0800
Message-Id: <1220412419-15404-31-git-send-email-yi.zhu@intel.com> (sfid-20080903_055043_908921_A126E8FA)
In-Reply-To: <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch disables power save upon association and enables it back
after association. This allows to associate to AP on a radar channel
if power save is enabled.

Radar and passive channels are not allowed for TX (required for association)
unless RX is received but PS may close the radio and no RX will be received
effectively failing association.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   24 ++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c |   39 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-power.h |    4 ++-
 4 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3743e4b..42cb3dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2486,6 +2486,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	if (!priv->vif || !priv->is_open)
 		return;
 
+	iwl_power_cancel_timeout(priv);
 	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -2550,10 +2551,6 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		break;
 	}
 
-	/* Enable Rx differential gain and sensitivity calibrations */
-	iwl_chain_noise_reset(priv);
-	priv->start_calib = 1;
-
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
 
@@ -2561,7 +2558,12 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	iwl_activate_qos(priv, 0);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_power_update_mode(priv, 0);
+	iwl_power_enable_management(priv);
+
+	/* Enable Rx differential gain and sensitivity calibrations */
+	iwl_chain_noise_reset(priv);
+	priv->start_calib = 1;
+
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
@@ -3543,6 +3545,16 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	/* Per mac80211.h: This is only used in IBSS mode... */
 	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
 
+		/* switch to CAM during association period.
+		 * the ucode will block any association/authentication
+		 * frome during assiciation period if it can not hear
+		 * the AP because of PM. the timer enable PM back is
+		 * association do not complete
+		 */
+		if (priv->hw->conf.channel->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
+						     IEEE80211_CHAN_RADAR))
+				iwl_power_disable_management(priv, 3000);
+
 		IWL_DEBUG_MAC80211("leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -4095,6 +4107,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	/* FIXME : remove when resolved PENDING */
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	iwl_setup_scan_deferred_work(priv);
+	iwl_setup_power_deferred_work(priv);
 
 	if (priv->cfg->ops->lib->setup_deferred_work)
 		priv->cfg->ops->lib->setup_deferred_work(priv);
@@ -4114,6 +4127,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
+	cancel_delayed_work_sync(&priv->set_power_save);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 45ae68a..8daeafd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1018,6 +1018,7 @@ struct iwl_priv {
 
 	struct tasklet_struct irq_tasklet;
 
+	struct delayed_work set_power_save;
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
 	struct delayed_work scan_check;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index eb6312d..16f834d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -319,7 +319,7 @@ EXPORT_SYMBOL(iwl_power_update_mode);
  * this will be usefull for rate scale to disable PM during heavy
  * Tx/Rx activities
  */
-int iwl_power_disable_management(struct iwl_priv *priv)
+int iwl_power_disable_management(struct iwl_priv *priv, u32 ms)
 {
 	u16 prev_mode;
 	int ret = 0;
@@ -332,6 +332,11 @@ int iwl_power_disable_management(struct iwl_priv *priv)
 	ret = iwl_power_update_mode(priv, 0);
 	priv->power_data.power_disabled = 1;
 	priv->power_data.user_power_setting = prev_mode;
+	cancel_delayed_work(&priv->set_power_save);
+	if (ms)
+		queue_delayed_work(priv->workqueue, &priv->set_power_save,
+				   msecs_to_jiffies(ms));
+
 
 	return ret;
 }
@@ -426,3 +431,35 @@ int iwl_power_temperature_change(struct iwl_priv *priv)
 	return ret;
 }
 EXPORT_SYMBOL(iwl_power_temperature_change);
+
+static void iwl_bg_set_power_save(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work,
+				struct iwl_priv, set_power_save.work);
+	IWL_DEBUG(IWL_DL_STATE, "update power\n");
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	/* on starting association we disable power managment
+	 * until association, if association failed then this
+	 * timer will expire and enable PM again.
+	 */
+	if (!iwl_is_associated(priv))
+		iwl_power_enable_management(priv);
+
+	mutex_unlock(&priv->mutex);
+}
+void iwl_setup_power_deferred_work(struct iwl_priv *priv)
+{
+	INIT_DELAYED_WORK(&priv->set_power_save, iwl_bg_set_power_save);
+}
+EXPORT_SYMBOL(iwl_setup_power_deferred_work);
+
+void iwl_power_cancel_timeout(struct iwl_priv *priv)
+{
+	cancel_delayed_work(&priv->set_power_save);
+}
+EXPORT_SYMBOL(iwl_power_cancel_timeout);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index abcbbf9..aa99f36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -78,8 +78,10 @@ struct iwl_power_mgr {
 	u8 power_disabled; /* flag to disable using power saving level */
 };
 
+void iwl_setup_power_deferred_work(struct iwl_priv *priv);
+void iwl_power_cancel_timeout(struct iwl_priv *priv);
 int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh);
-int iwl_power_disable_management(struct iwl_priv *priv);
+int iwl_power_disable_management(struct iwl_priv *priv, u32 ms);
 int iwl_power_enable_management(struct iwl_priv *priv);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
 int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode);
-- 
1.5.3.6

