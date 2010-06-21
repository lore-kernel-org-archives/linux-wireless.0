Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48346 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab0FUKji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 06:39:38 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <samuel.ortiz@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCHv2 1/2] cfg80211/mac80211: Update set_tx_power to use mBm instead of dBm units
Date: Mon, 21 Jun 2010 13:39:25 +0300
Message-Id: <1277116766-4764-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for a TX power setting interface in the nl80211, change the
.set_tx_power function to use mBm units instead of dBm for greater accuracy and
smaller power levels.

Also, already in advance move the tx_power_setting enumeration to nl80211.

This change affects the .tx_set_power function prototype. As a result, the
corresponding changes are needed to modules using it. These are mac80211,
iwmc3200wifi and rndis_wlan.

Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   12 ++++++++----
 drivers/net/wireless/rndis_wlan.c            |   20 +++++++++++++-------
 include/linux/nl80211.h                      |   13 +++++++++++++
 include/net/cfg80211.h                       |   15 +--------------
 net/mac80211/cfg.c                           |   22 +++++++++++-----------
 net/wireless/wext-compat.c                   |   10 +++++-----
 6 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 902e95f..6061967 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -670,20 +670,24 @@ static int iwm_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
-				    enum tx_power_setting type, int dbm)
+				    enum nl80211_tx_power_setting type, int mbm)
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 	int ret;
 
 	switch (type) {
-	case TX_POWER_AUTOMATIC:
+	case NL80211_TX_POWER_AUTOMATIC:
 		return 0;
-	case TX_POWER_FIXED:
+	case NL80211_TX_POWER_FIXED:
+		if (mbm < 0 || (mbm % 100))
+			return -EOPNOTSUPP;
+
 		if (!test_bit(IWM_STATUS_READY, &iwm->status))
 			return 0;
 
 		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
-					      CFG_TX_PWR_LIMIT_USR, dbm * 2);
+					      CFG_TX_PWR_LIMIT_USR,
+					      MBM_TO_DBM(mbm) * 2);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 4102cca..5e26edb 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -520,8 +520,9 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 
 static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed);
 
-static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
-				int dbm);
+static int rndis_set_tx_power(struct wiphy *wiphy,
+			      enum nl80211_tx_power_setting type,
+			      int mbm);
 static int rndis_get_tx_power(struct wiphy *wiphy, int *dbm);
 
 static int rndis_connect(struct wiphy *wiphy, struct net_device *dev,
@@ -1856,20 +1857,25 @@ static int rndis_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
-static int rndis_set_tx_power(struct wiphy *wiphy, enum tx_power_setting type,
-				int dbm)
+static int rndis_set_tx_power(struct wiphy *wiphy,
+			      enum nl80211_tx_power_setting type,
+			      int mbm)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
 
-	netdev_dbg(usbdev->net, "%s(): type:0x%x dbm:%i\n",
-		   __func__, type, dbm);
+	netdev_dbg(usbdev->net, "%s(): type:0x%x mbm:%i\n",
+		   __func__, type, mbm);
+
+	if (mbm < 0 || (mbm % 100))
+		return -ENOTSUPP;
 
 	/* Device doesn't support changing txpower after initialization, only
 	 * turn off/on radio. Support 'auto' mode and setting same dBm that is
 	 * currently used.
 	 */
-	if (type == TX_POWER_AUTOMATIC || dbm == get_bcm4320_power_dbm(priv)) {
+	if (type == NL80211_TX_POWER_AUTOMATIC ||
+	    MBM_TO_DBM(mbm) == get_bcm4320_power_dbm(priv)) {
 		if (!priv->radio_on)
 			disassociate(usbdev, true); /* turn on radio */
 
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 64fb32b..07aa046 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1659,4 +1659,17 @@ enum nl80211_cqm_rssi_threshold_event {
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 };
 
+
+/**
+ * enum nl80211_tx_power_setting - TX power adjustment
+ * @NL80211_TX_POWER_AUTOMATIC: automatically determine transmit power
+ * @NL80211_TX_POWER_LIMITED: limit TX power by the mBm parameter
+ * @NL80211_TX_POWER_FIXED: fix TX power to the mBm parameter
+ */
+enum nl80211_tx_power_setting {
+	NL80211_TX_POWER_AUTOMATIC,
+	NL80211_TX_POWER_LIMITED,
+	NL80211_TX_POWER_FIXED,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64374f4..9b8b3f4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -875,19 +875,6 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
 };
 
-/**
- * enum tx_power_setting - TX power adjustment
- *
- * @TX_POWER_AUTOMATIC: the dbm parameter is ignored
- * @TX_POWER_LIMITED: limit TX power by the dbm parameter
- * @TX_POWER_FIXED: fix TX power to the dbm parameter
- */
-enum tx_power_setting {
-	TX_POWER_AUTOMATIC,
-	TX_POWER_LIMITED,
-	TX_POWER_FIXED,
-};
-
 /*
  * cfg80211_bitrate_mask - masks for bitrate control
  */
@@ -1149,7 +1136,7 @@ struct cfg80211_ops {
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
 	int	(*set_tx_power)(struct wiphy *wiphy,
-				enum tx_power_setting type, int dbm);
+				enum nl80211_tx_power_setting type, int mbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 003b6ad..f4efbfa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1329,28 +1329,28 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
-				  enum tx_power_setting type, int dbm)
+				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	u32 changes = 0;
 
 	switch (type) {
-	case TX_POWER_AUTOMATIC:
+	case NL80211_TX_POWER_AUTOMATIC:
 		local->user_power_level = -1;
 		break;
-	case TX_POWER_LIMITED:
-		if (dbm < 0)
-			return -EINVAL;
-		local->user_power_level = dbm;
+	case NL80211_TX_POWER_LIMITED:
+		if (mbm < 0 || (mbm % 100))
+			return -EOPNOTSUPP;
+		local->user_power_level = MBM_TO_DBM(mbm);
 		break;
-	case TX_POWER_FIXED:
-		if (dbm < 0)
-			return -EINVAL;
+	case NL80211_TX_POWER_FIXED:
+		if (mbm < 0 || (mbm % 100))
+			return -EOPNOTSUPP;
 		/* TODO: move to cfg80211 when it knows the channel */
-		if (dbm > chan->max_power)
+		if (MBM_TO_DBM(mbm) > chan->max_power)
 			return -EINVAL;
-		local->user_power_level = dbm;
+		local->user_power_level = MBM_TO_DBM(mbm);
 		break;
 	}
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9634299..1ff1e9f 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -829,7 +829,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	enum tx_power_setting type;
+	enum nl80211_tx_power_setting type;
 	int dbm = 0;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
@@ -852,7 +852,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 			if (data->txpower.value < 0)
 				return -EINVAL;
 			dbm = data->txpower.value;
-			type = TX_POWER_FIXED;
+			type = NL80211_TX_POWER_FIXED;
 			/* TODO: do regulatory check! */
 		} else {
 			/*
@@ -860,10 +860,10 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 			 * passed in from userland.
 			 */
 			if (data->txpower.value < 0) {
-				type = TX_POWER_AUTOMATIC;
+				type = NL80211_TX_POWER_AUTOMATIC;
 			} else {
 				dbm = data->txpower.value;
-				type = TX_POWER_LIMITED;
+				type = NL80211_TX_POWER_LIMITED;
 			}
 		}
 	} else {
@@ -872,7 +872,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);
+	return rdev->ops->set_tx_power(wdev->wiphy, type, DBM_TO_MBM(dbm));
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
-- 
1.6.3.3

