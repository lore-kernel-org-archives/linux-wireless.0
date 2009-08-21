Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbZHUUe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/14] iwlwifi: error checking for setting tx_power in sysfs
Date: Fri, 21 Aug 2009 13:34:17 -0700
Message-Id: <1250886867-4112-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Perform error checking and report failure when setting tx power from
sysfs.
If fail to set the tx power, do not update the local copy, so user will
not see the incorrect tx power in sysfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   13 +++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.c |   28 +++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2232b17..533b393 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2477,10 +2477,15 @@ static ssize_t store_tx_power(struct device *d,
 	ret = strict_strtoul(buf, 10, &val);
 	if (ret)
 		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
-	else
-		iwl_set_tx_power(priv, val, false);
-
-	return count;
+	else {
+		ret = iwl_set_tx_power(priv, val, false);
+		if (ret)
+			IWL_ERR(priv, "failed setting tx power (0x%d).\n",
+				ret);
+		else
+			ret = count;
+	}
+	return ret;
 }
 
 static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 82dadd0..c62c081 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1701,6 +1701,8 @@ EXPORT_SYMBOL(iwl_init_drv);
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
+	s8 prev_tx_power = priv->tx_power_user_lmt;
+
 	if (tx_power < IWL_TX_POWER_TARGET_POWER_MIN) {
 		IWL_WARN(priv, "Requested user TXPOWER %d below lower limit %d.\n",
 			 tx_power,
@@ -1718,15 +1720,27 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	if (priv->tx_power_user_lmt != tx_power)
 		force = true;
 
-	priv->tx_power_user_lmt = tx_power;
-
 	/* if nic is not up don't send command */
-	if (!iwl_is_ready_rf(priv))
-		return ret;
-
-	if (force && priv->cfg->ops->lib->send_tx_power)
-		ret = priv->cfg->ops->lib->send_tx_power(priv);
+	if (iwl_is_ready_rf(priv)) {
+		priv->tx_power_user_lmt = tx_power;
+		if (force && priv->cfg->ops->lib->send_tx_power)
+			ret = priv->cfg->ops->lib->send_tx_power(priv);
+		else if (!priv->cfg->ops->lib->send_tx_power)
+			ret = -EOPNOTSUPP;
+		/*
+		 * if fail to set tx_power, restore the orig. tx power
+		 */
+		if (ret)
+			priv->tx_power_user_lmt = prev_tx_power;
+	}
 
+	/*
+	 * Even this is an async host command, the command
+	 * will always report success from uCode
+	 * So once driver can placing the command into the queue
+	 * successfully, driver can use priv->tx_power_user_lmt
+	 * to reflect the current tx power
+	 */
 	return ret;
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
-- 
1.5.6.3

