Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbZAWVmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:53 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/15] iwl3945: Getting rid of priv->antenna
Date: Fri, 23 Jan 2009 13:45:18 -0800
Message-Id: <1232747123-7261-11-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224302_106426_2882834A)
In-Reply-To: <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

The iwl_priv antenna field is useless as we can simply use the corresponding
mod_params antenna field.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   35 ---------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   44 +++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b9c5cf9..7f1e042 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -197,41 +197,6 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
 	return -1;
 }
 
-/**
- * iwl3945_get_antenna_flags - Get antenna flags for RXON command
- * @priv: eeprom and antenna fields are used to determine antenna flags
- *
- * priv->eeprom39  is used to determine if antenna AUX/MAIN are reversed
- * priv->antenna specifies the antenna diversity mode:
- *
- * IWL_ANTENNA_DIVERSITY - NIC selects best antenna by itself
- * IWL_ANTENNA_MAIN      - Force MAIN antenna
- * IWL_ANTENNA_AUX       - Force AUX antenna
- */
-__le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
-{
-	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
-
-	switch (priv->antenna) {
-	case IWL_ANTENNA_DIVERSITY:
-		return 0;
-
-	case IWL_ANTENNA_MAIN:
-		if (eeprom->antenna_switch_type)
-			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
-		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
-
-	case IWL_ANTENNA_AUX:
-		if (eeprom->antenna_switch_type)
-			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
-		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
-	}
-
-	/* bad antenna selector value */
-	IWL_ERR(priv, "Bad antenna selector value (0x%x)\n", priv->antenna);
-	return 0;		/* "diversity" is default if error */
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5dbab76..437c05b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -978,7 +978,6 @@ struct iwl_priv {
 	u16 rates_mask;
 
 	u32 power_mode;
-	u32 antenna;
 	u8 bssid[ETH_ALEN];
 	u16 rts_threshold;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d832cb9..8aaa6bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -448,6 +448,43 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 }
 
 /**
+ * iwl3945_get_antenna_flags - Get antenna flags for RXON command
+ * @priv: eeprom and antenna fields are used to determine antenna flags
+ *
+ * priv->eeprom39  is used to determine if antenna AUX/MAIN are reversed
+ * iwl3945_mod_params.antenna specifies the antenna diversity mode:
+ *
+ * IWL_ANTENNA_DIVERSITY - NIC selects best antenna by itself
+ * IWL_ANTENNA_MAIN      - Force MAIN antenna
+ * IWL_ANTENNA_AUX       - Force AUX antenna
+ */
+__le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
+{
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
+
+	switch (iwl3945_mod_params.antenna) {
+	case IWL_ANTENNA_DIVERSITY:
+		return 0;
+
+	case IWL_ANTENNA_MAIN:
+		if (eeprom->antenna_switch_type)
+			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
+		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
+
+	case IWL_ANTENNA_AUX:
+		if (eeprom->antenna_switch_type)
+			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
+		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
+	}
+
+	/* bad antenna selector value */
+	IWL_ERR(priv, "Bad antenna selector value (0x%x)\n",
+		iwl3945_mod_params.antenna);
+
+	return 0;		/* "diversity" is default if error */
+}
+
+/**
  * iwl3945_commit_rxon - commit staging_rxon to hardware
  *
  * The RXON command in staging_rxon is committed to the hardware and
@@ -5804,7 +5841,7 @@ static ssize_t show_antenna(struct device *d,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
-	return sprintf(buf, "%d\n", priv->antenna);
+	return sprintf(buf, "%d\n", iwl3945_mod_params.antenna);
 }
 
 static ssize_t store_antenna(struct device *d,
@@ -5824,7 +5861,7 @@ static ssize_t store_antenna(struct device *d,
 
 	if ((ant >= 0) && (ant <= 2)) {
 		IWL_DEBUG_INFO("Setting antenna select to %d.\n", ant);
-		priv->antenna = (enum iwl3945_antenna)ant;
+		iwl3945_mod_params.antenna = (enum iwl3945_antenna)ant;
 	} else
 		IWL_DEBUG_INFO("Bad antenna select value %d.\n", ant);
 
@@ -6089,9 +6126,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	hw->rate_control_algorithm = "iwl-3945-rs";
 	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
 
-	/* Select antenna (may be helpful if only one antenna is connected) */
-	priv->antenna = (enum iwl3945_antenna)iwl3945_mod_params.antenna;
-
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM;
-- 
1.5.4.3

