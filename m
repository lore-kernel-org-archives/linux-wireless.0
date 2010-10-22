Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab0JVPBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:01:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/7] iwlwifi: fix set_tx_power vs scan
Date: Fri, 22 Oct 2010 17:04:26 +0200
Message-Id: <1287759870-5758-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to comment in iwl_bg_scan_completed, setting tx power should
be deferred during pending scan, but we are not doing this.

This patch change code to really defer setting tx power after scan
complete. Additionally refactor iwl_set_tx_power code and call
lib->send_tx_power() directly from iwlagn_commit_rxon.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 ++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   54 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   10 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 5 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c2636a7..d3435c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -245,13 +245,10 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-	if (ret) {
+	ret = priv->cfg->ops->lib->send_tx_power(priv);
+	if (ret)
 		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 void iwl_update_chain_flags(struct iwl_priv *priv)
@@ -4179,6 +4176,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	 * this value will get overwritten by channel max power avg
 	 * from eeprom */
 	priv->tx_power_user_lmt = IWLAGN_TX_POWER_TARGET_POWER_MIN;
+	priv->tx_power_next = IWLAGN_TX_POWER_TARGET_POWER_MIN;
 
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 25fb391..8bbd152 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1206,8 +1206,16 @@ EXPORT_SYMBOL(iwl_apm_init);
 
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
-	int ret = 0;
-	s8 prev_tx_power = priv->tx_power_user_lmt;
+	int ret;
+	s8 prev_tx_power;
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (priv->tx_power_user_lmt == tx_power && !force)
+		return 0;
+
+	if (!priv->cfg->ops->lib->send_tx_power)
+		return -EOPNOTSUPP;
 
 	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
 		IWL_WARN(priv,
@@ -1224,30 +1232,26 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (priv->tx_power_user_lmt != tx_power)
-		force = true;
+	if (!iwl_is_ready_rf(priv))
+		return -EIO;
 
-	/* if nic is not up don't send command */
-	if (iwl_is_ready_rf(priv)) {
-		priv->tx_power_user_lmt = tx_power;
-		if (force && priv->cfg->ops->lib->send_tx_power)
-			ret = priv->cfg->ops->lib->send_tx_power(priv);
-		else if (!priv->cfg->ops->lib->send_tx_power)
-			ret = -EOPNOTSUPP;
-		/*
-		 * if fail to set tx_power, restore the orig. tx power
-		 */
-		if (ret)
-			priv->tx_power_user_lmt = prev_tx_power;
+	/* scan complete use tx_power_next, need to be updated */
+	priv->tx_power_next = tx_power;
+	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
+		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
+		return 0;
 	}
 
-	/*
-	 * Even this is an async host command, the command
-	 * will always report success from uCode
-	 * So once driver can placing the command into the queue
-	 * successfully, driver can use priv->tx_power_user_lmt
-	 * to reflect the current tx power
-	 */
+	prev_tx_power = priv->tx_power_user_lmt;
+	priv->tx_power_user_lmt = tx_power;
+
+	ret = priv->cfg->ops->lib->send_tx_power(priv);
+
+	/* if fail to set tx_power, restore the orig. tx power */
+	if (ret) {
+		priv->tx_power_user_lmt = prev_tx_power;
+		priv->tx_power_next = prev_tx_power;
+	}
 	return ret;
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
@@ -2016,7 +2020,9 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
 			priv->tx_power_user_lmt, conf->power_level);
 
-		iwl_set_tx_power(priv, conf->power_level, false);
+		ret = iwl_set_tx_power(priv, conf->power_level, false);
+		if (ret)
+			IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 	}
 
 	if (!iwl_is_ready(priv)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 70e07fa..cd6daed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1517,6 +1517,7 @@ struct iwl_priv {
 	s8 tx_power_user_lmt;
 	s8 tx_power_device_lmt;
 	s8 tx_power_lmt_in_half_dbm; /* max tx power in half-dBm format */
+	s8 tx_power_next;
 
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 67da312..d63e30e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -603,13 +603,15 @@ out_settings:
 	if (!iwl_is_ready_rf(priv))
 		goto out;
 
-	/* Since setting the TXPOWER may have been deferred while
-	 * performing the scan, fire one off */
-	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	/*
+	 * We do not commit power settings while scan is pending,
+	 * do it now if the settings changed.
+	 */
+	iwl_set_tx_power(priv, priv->tx_power_next, false);
 
 	priv->cfg->ops->utils->post_scan(priv);
 
- out:
+out:
 	mutex_unlock(&priv->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8f8c4b7..a754291 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3866,6 +3866,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
+	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
-- 
1.7.1

