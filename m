Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0CJFWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/24] iwlwifi: remove never-changing priv->rates_mask variable
Date: Tue,  9 Mar 2010 21:21:36 -0800
Message-Id: <1268198512-6572-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's always just IWL_RATES_MASK.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d0fab87..e7e4bf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2103,8 +2103,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	ieee80211_wake_queues(priv->hw);
 
-	priv->active_rate = priv->rates_mask;
-	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
+	priv->active_rate = IWL_RATES_MASK;
+	priv->active_rate_basic = IWL_RATES_MASK & IWL_BASIC_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
 	if (priv->cfg->ops->hcmd->set_tx_ant)
@@ -3392,7 +3392,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 
-	priv->rates_mask = IWL_RATES_MASK;
 	/* Set the tx_power_user_lmt to the lowest power level
 	 * this value will get overwritten by channel max power avg
 	 * from eeprom */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c277e4e..4d6558f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1217,8 +1217,6 @@ struct iwl_priv {
 #endif
 
 	/* context information */
-	u16 rates_mask;
-
 	u8 bssid[ETH_ALEN];
 	u16 rts_threshold;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2b2c96b..b2b0505 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2508,8 +2508,8 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	ieee80211_wake_queues(priv->hw);
 
-	priv->active_rate = priv->rates_mask;
-	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
+	priv->active_rate = IWL_RATES_MASK;
+	priv->active_rate_basic = IWL_RATES_MASK & IWL_BASIC_RATES_MASK;
 
 	iwl_power_update_mode(priv, true);
 
@@ -3855,7 +3855,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 
-	priv->rates_mask = IWL_RATES_MASK;
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
-- 
1.6.3.3

