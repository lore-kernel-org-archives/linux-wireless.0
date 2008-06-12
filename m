Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbYFLBts (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 15/29] iwlwifi enabling IBSS (Ad-Hoc) mode
Date: Thu, 12 Jun 2008 09:47:05 +0800
Message-Id: <1213235239-2954-16-git-send-email-yi.zhu@intel.com> (sfid-20080612_041913_683169_1DFD3F16)
In-Reply-To: <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch enables ibss mode. It consists of two changes upon entering ibss
mode:
1. Removing the redundant line which clears the driver's station table.
   This line creates a discrepancy between the driver and the FW's station
   table. This prevented the generation of beacons.
2. Assigning a default value to priv's assoc_id. Normally given by an AP in
   STA mode, this field is used as an indication for association. Being 0,
   it prevented normal TX flow.
3. Remove a redundant ADD_STA command that cause uCode error.
4. Delay the set_mode until after the uCode is ready.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   30 +++++++++++++++++---------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b4c9d5d..44d0fcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -284,6 +284,7 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 #define STATUS_CONF_PENDING	18
+#define STATUS_MODE_PENDING	19
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3f54dec..4570fd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2900,6 +2900,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwlcore_low_level_notify(priv, IWLCORE_START_EVT);
 	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
+
+	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
+		iwl4965_set_mode(priv, priv->iw_mode);
+
 	return;
 
  restart:
@@ -3189,16 +3193,20 @@ static void iwl4965_bg_set_monitor(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work,
 				struct iwl_priv, set_monitor);
+	int ret;
 
 	IWL_DEBUG(IWL_DL_STATE, "setting monitor mode\n");
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv))
-		IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
-	else
-		if (iwl4965_set_mode(priv, IEEE80211_IF_TYPE_MNTR) != 0)
-			IWL_ERROR("iwl4965_set_mode() failed\n");
+	ret = iwl4965_set_mode(priv, IEEE80211_IF_TYPE_MNTR);
+
+	if (ret) {
+		if (ret == -EAGAIN)
+			IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
+		else
+			IWL_ERROR("iwl4965_set_mode() failed ret = %d\n", ret);
+	}
 
 	mutex_unlock(&priv->mutex);
 }
@@ -3575,10 +3583,9 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	case IEEE80211_IF_TYPE_IBSS:
 
-		/* clear out the station table */
-		iwlcore_clear_stations_table(priv);
+		/* assume default assoc id */
+		priv->assoc_id = 1;
 
-		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
 		iwl_rxon_add_station(priv, priv->bssid, 0);
 		iwl4965_rate_scale_init(priv->hw, IWL_STA_ID);
 		iwl4965_send_beacon_cmd(priv);
@@ -3826,8 +3833,9 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl_is_ready(priv))
-		iwl4965_set_mode(priv, conf->type);
+	if (iwl4965_set_mode(priv, conf->type) == -EAGAIN)
+		/* we are not ready, will run again when ready */
+		set_bit(STATUS_MODE_PENDING, &priv->status);
 
 	mutex_unlock(&priv->mutex);
 
@@ -4608,7 +4616,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	iwl_reset_qos(priv);
 
-	queue_work(priv->workqueue, &priv->post_associate.work);
+	iwl4965_post_associate(priv);
 
 	mutex_unlock(&priv->mutex);
 
-- 
1.5.3.6

