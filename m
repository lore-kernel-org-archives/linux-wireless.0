Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbZFBLMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:12:50 -0400
Message-Id: <20090602110150.149497638@sipsolutions.net>
References: <20090602110136.631660156@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:01:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] cfg80211: move txpower wext from mac80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces new cfg80211 API to set the TX power
via cfg80211, puts the wext code into cfg80211 and updates
mac80211 to use all that. The -ENETDOWN bits are a hack but
will go away soon.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   30 ++++++++++++++++
 net/mac80211/cfg.c         |   54 ++++++++++++++++++++++++++++++
 net/mac80211/wext.c        |   80 +--------------------------------------------
 net/wireless/wext-compat.c |   80 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+), 78 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-02 12:53:52.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-02 12:55:01.000000000 +0200
@@ -752,6 +752,21 @@ enum wiphy_params_flags {
 };
 
 /**
+ * enum tx_power_setting - TX power adjustment
+ *
+ * @TX_POWER_AUTOMATIC: the dbm parameter is ignored
+ * @TX_POWER_LIMITED: limit TX power by the dbm parameter
+ * @TX_POWER_FIXED: fix TX power to the dbm parameter
+ * @TX_POWER_OFF: turn off completely (will go away)
+ */
+enum tx_power_setting {
+	TX_POWER_AUTOMATIC,
+	TX_POWER_LIMITED,
+	TX_POWER_FIXED,
+	TX_POWER_OFF,
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -837,6 +852,11 @@ enum wiphy_params_flags {
  *	@changed bitfield (see &enum wiphy_params_flags) describes which values
  *	have changed. The actual parameter values are available in
  *	struct wiphy. If returning an error, no value should be changed.
+ *
+ * @set_tx_power: set the transmit power according to the parameters
+ * @get_tx_power: store the current TX power into the dbm variable;
+ *	return 0 if successful; or -ENETDOWN if successful but power
+ *	is disabled (this will go away)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -928,6 +948,10 @@ struct cfg80211_ops {
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
+
+	int	(*set_tx_power)(struct wiphy *wiphy,
+				enum tx_power_setting type, int dbm);
+	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 };
 
 /*
@@ -1451,6 +1475,12 @@ int cfg80211_wext_siwencode(struct net_d
 int cfg80211_wext_giwencode(struct net_device *dev,
 			    struct iw_request_info *info,
 			    struct iw_point *erq, char *keybuf);
+int cfg80211_wext_siwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *keybuf);
+int cfg80211_wext_giwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *keybuf);
 
 /*
  * callbacks for asynchronous cfg80211 methods, notification
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-02 12:53:52.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-02 12:55:01.000000000 +0200
@@ -1334,6 +1334,58 @@ static int ieee80211_set_wiphy_params(st
 	return 0;
 }
 
+static int ieee80211_set_tx_power(struct wiphy *wiphy,
+				  enum tx_power_setting type, int dbm)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_channel *chan = local->hw.conf.channel;
+	u32 changes = 0;
+	bool radio_enabled = true;
+
+	switch (type) {
+	case TX_POWER_AUTOMATIC:
+		local->user_power_level = -1;
+		break;
+	case TX_POWER_LIMITED:
+		if (dbm < 0)
+			return -EINVAL;
+		local->user_power_level = dbm;
+		break;
+	case TX_POWER_FIXED:
+		if (dbm < 0)
+			return -EINVAL;
+		/* TODO: move to cfg80211 when it knows the channel */
+		if (dbm > chan->max_power)
+			return -EINVAL;
+		local->user_power_level = dbm;
+		break;
+	case TX_POWER_OFF:
+		radio_enabled = false;
+		break;
+	}
+
+	if (radio_enabled != local->hw.conf.radio_enabled) {
+		changes |= IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+		local->hw.conf.radio_enabled = radio_enabled;
+	}
+
+	ieee80211_hw_config(local, changes);
+
+	return 0;
+}
+
+static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	*dbm = local->hw.conf.power_level;
+
+	if (!local->hw.conf.radio_enabled)
+		return -ENETDOWN;
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1373,4 +1425,6 @@ struct cfg80211_ops mac80211_config_ops 
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
+	.set_tx_power = ieee80211_set_tx_power,
+	.get_tx_power = ieee80211_get_tx_power,
 };
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-02 12:53:52.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-02 12:54:40.000000000 +0200
@@ -306,82 +306,6 @@ static int ieee80211_ioctl_giwrate(struc
 	return 0;
 }
 
-static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
-				      struct iw_request_info *info,
-				      union iwreq_data *data, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_channel* chan = local->hw.conf.channel;
-	bool reconf = false;
-	u32 reconf_flags = 0;
-	int new_power_level;
-
-	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
-		return -EINVAL;
-	if (data->txpower.flags & IW_TXPOW_RANGE)
-		return -EINVAL;
-	if (!chan)
-		return -EINVAL;
-
-	/* only change when not disabling */
-	if (!data->txpower.disabled) {
-		if (data->txpower.fixed) {
-			if (data->txpower.value < 0)
-				return -EINVAL;
-			new_power_level = data->txpower.value;
-			/*
-			 * Debatable, but we cannot do a fixed power
-			 * level above the regulatory constraint.
-			 * Use "iwconfig wlan0 txpower 15dBm" instead.
-			 */
-			if (new_power_level > chan->max_power)
-				return -EINVAL;
-		} else {
-			/*
-			 * Automatic power level setting, max being the value
-			 * passed in from userland.
-			 */
-			if (data->txpower.value < 0)
-				new_power_level = -1;
-			else
-				new_power_level = data->txpower.value;
-		}
-
-		reconf = true;
-
-		/*
-		 * ieee80211_hw_config() will limit to the channel's
-		 * max power and possibly power constraint from AP.
-		 */
-		local->user_power_level = new_power_level;
-	}
-
-	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
-		local->hw.conf.radio_enabled = !(data->txpower.disabled);
-		reconf_flags |= IEEE80211_CONF_CHANGE_RADIO_ENABLED;
-		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
-	}
-
-	if (reconf || reconf_flags)
-		ieee80211_hw_config(local, reconf_flags);
-
-	return 0;
-}
-
-static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
-				   struct iw_request_info *info,
-				   union iwreq_data *data, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	data->txpower.fixed = 1;
-	data->txpower.disabled = !(local->hw.conf.radio_enabled);
-	data->txpower.value = local->hw.conf.power_level;
-	data->txpower.flags = IW_TXPOW_DBM;
-
-	return 0;
-}
-
 static int ieee80211_ioctl_siwpower(struct net_device *dev,
 				    struct iw_request_info *info,
 				    struct iw_param *wrq,
@@ -658,8 +582,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) cfg80211_wext_siwfrag,		/* SIOCSIWFRAG */
 	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) ieee80211_ioctl_siwtxpower,	/* SIOCSIWTXPOW */
-	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
+	(iw_handler) cfg80211_wext_siwtxpower,		/* SIOCSIWTXPOW */
+	(iw_handler) cfg80211_wext_giwtxpower,		/* SIOCGIWTXPOW */
 	(iw_handler) cfg80211_wext_siwretry,		/* SIOCSIWRETRY */
 	(iw_handler) cfg80211_wext_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-02 12:53:52.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-02 12:55:01.000000000 +0200
@@ -744,3 +744,83 @@ int cfg80211_wext_giwencode(struct net_d
 	return err;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwencode);
+
+int cfg80211_wext_siwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	enum tx_power_setting type;
+	int dbm = 0;
+
+	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
+		return -EINVAL;
+	if (data->txpower.flags & IW_TXPOW_RANGE)
+		return -EINVAL;
+
+	if (!rdev->ops->set_tx_power)
+		return -EOPNOTSUPP;
+
+	/* only change when not disabling */
+	if (!data->txpower.disabled) {
+		if (data->txpower.fixed) {
+			/*
+			 * wext doesn't support negative values, see
+			 * below where it's for automatic
+			 */
+			if (data->txpower.value < 0)
+				return -EINVAL;
+			dbm = data->txpower.value;
+			type = TX_POWER_FIXED;
+			/* TODO: do regulatory check! */
+		} else {
+			/*
+			 * Automatic power level setting, max being the value
+			 * passed in from userland.
+			 */
+			if (data->txpower.value < 0) {
+				type = TX_POWER_AUTOMATIC;
+			} else {
+				dbm = data->txpower.value;
+				type = TX_POWER_LIMITED;
+			}
+		}
+	} else {
+		type = TX_POWER_OFF;
+	}
+
+	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
+
+int cfg80211_wext_giwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	int err, val;
+
+	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
+		return -EINVAL;
+	if (data->txpower.flags & IW_TXPOW_RANGE)
+		return -EINVAL;
+
+	if (!rdev->ops->get_tx_power)
+		return -EOPNOTSUPP;
+
+	err = rdev->ops->get_tx_power(wdev->wiphy, &val);
+	/* HACK!!! */
+	if (err && err != -ENETDOWN)
+		return err;
+
+	/* well... oh well */
+	data->txpower.fixed = 1;
+	data->txpower.disabled = err == -ENETDOWN;
+	data->txpower.value = val;
+	data->txpower.flags = IW_TXPOW_DBM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwtxpower);

-- 

