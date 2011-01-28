Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1A1PsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:48:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/8] iwlwifi: introduce iwl_advanced_bt_coexist()
Date: Fri, 28 Jan 2011 16:47:47 +0100
Message-Id: <1296229671-3041-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist
conditional in few places, merge it into one function.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h    |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c   |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-scan.c    |    3 +--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index bbc5aa7..705711a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -741,6 +741,12 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 	return priv->hw->wiphy->bands[band];
 }
 
+static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
+{
+	return priv->cfg->bt_params &&
+	       priv->cfg->bt_params->advanced_bt_coexist;
+}
+
 extern bool bt_coex_active;
 extern bool bt_siso_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 418c8ac..bde16ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1771,7 +1771,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
-	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
+	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 1eec18d..25f7d47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -226,8 +226,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (iwl_advanced_bt_coexist(priv)) {
 		if (!priv->cfg->bt_params->bt_sco_disable)
 			cmd->flags |= IWL_POWER_BT_SCO_ENA;
 		else
@@ -313,8 +312,7 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (iwl_advanced_bt_coexist(priv)) {
 		if (!priv->cfg->bt_params->bt_sco_disable)
 			cmd->flags |= IWL_POWER_BT_SCO_ENA;
 		else
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 12d9363..08f1bea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -257,8 +257,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	queue_work(priv->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
-	    priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    iwl_advanced_bt_coexist(priv) &&
 	    priv->bt_status != scan_notif->bt_status) {
 		if (scan_notif->bt_status) {
 			/* BT on */
-- 
1.7.1

