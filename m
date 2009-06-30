Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZF3LyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 07:54:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLbuY-0003R8-6m
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 13:54:07 +0200
Message-Id: <20090630115302.253393877@sipsolutions.net>
References: <20090630115245.675553951@sipsolutions.net>
Date: Tue, 30 Jun 2009 13:52:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8 v3] cfg80211: implement iwpower
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just on/off and timeout, and with a hacky cfg80211 method
until we figure out what we want, though this is probably
sufficient as we want to use pm_qos for wifi everywhere.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   22 ++++++++
 drivers/net/wireless/iwmc3200wifi/wext.c     |   47 ------------------
 include/net/cfg80211.h                       |   13 +++++
 net/mac80211/Kconfig                         |   16 ------
 net/mac80211/cfg.c                           |   26 ++++++++++
 net/mac80211/mlme.c                          |    5 -
 net/mac80211/wext.c                          |   70 ---------------------------
 net/wireless/Kconfig                         |   16 ++++++
 net/wireless/core.c                          |   11 +++-
 net/wireless/wext-compat.c                   |   60 +++++++++++++++++++++++
 10 files changed, 151 insertions(+), 135 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-06-30 13:47:13.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-30 13:47:31.000000000 +0200
@@ -1023,6 +1023,10 @@ struct cfg80211_ops {
 #ifdef CONFIG_NL80211_TESTMODE
 	int	(*testmode_cmd)(struct wiphy *wiphy, void *data, int len);
 #endif
+
+	/* some temporary stuff to finish wext */
+	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
+				  bool enabled, int timeout);
 };
 
 /*
@@ -1274,6 +1278,8 @@ struct wireless_dev {
 		u8 bssid[ETH_ALEN];
 		u8 ssid[IEEE80211_MAX_SSID_LEN];
 		s8 default_key, default_mgmt_key;
+		bool ps;
+		int ps_timeout;
 	} wext;
 #endif
 };
@@ -1618,6 +1624,13 @@ int cfg80211_wext_giwtxpower(struct net_
 			     struct iw_request_info *info,
 			     union iwreq_data *data, char *keybuf);
 
+int cfg80211_wext_siwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra);
+int cfg80211_wext_giwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
--- wireless-testing.orig/net/mac80211/Kconfig	2009-06-30 13:42:33.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-06-30 13:47:31.000000000 +0200
@@ -14,22 +14,6 @@ config MAC80211
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
 
-config MAC80211_DEFAULT_PS
-	bool "enable powersave by default"
-	depends on MAC80211
-	default y
-	help
-	  This option enables powersave mode by default.
-
-	  If this causes your applications to misbehave you should fix your
-	  applications instead -- they need to register their network
-	  latency requirement, see Documentation/power/pm_qos_interface.txt.
-
-config MAC80211_DEFAULT_PS_VALUE
-	int
-	default 1 if MAC80211_DEFAULT_PS
-	default 0
-
 menu "Rate control algorithm selection"
 	depends on MAC80211 != n
 
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-30 13:47:13.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-30 13:47:31.000000000 +0200
@@ -255,72 +255,6 @@ static int ieee80211_ioctl_giwrate(struc
 	return 0;
 }
 
-static int ieee80211_ioctl_siwpower(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_param *wrq,
-				    char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
-	int timeout = 0;
-	bool ps;
-
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
-		return -EOPNOTSUPP;
-
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EINVAL;
-
-	if (wrq->disabled) {
-		ps = false;
-		timeout = 0;
-		goto set;
-	}
-
-	switch (wrq->flags & IW_POWER_MODE) {
-	case IW_POWER_ON:       /* If not specified */
-	case IW_POWER_MODE:     /* If set all mask */
-	case IW_POWER_ALL_R:    /* If explicitely state all */
-		ps = true;
-		break;
-	default:                /* Otherwise we ignore */
-		return -EINVAL;
-	}
-
-	if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
-		return -EINVAL;
-
-	if (wrq->flags & IW_POWER_TIMEOUT)
-		timeout = wrq->value / 1000;
-
- set:
-	if (ps == sdata->u.mgd.powersave && timeout == conf->dynamic_ps_timeout)
-		return 0;
-
-	sdata->u.mgd.powersave = ps;
-	conf->dynamic_ps_timeout = timeout;
-
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-
-	ieee80211_recalc_ps(local, -1);
-
-	return 0;
-}
-
-static int ieee80211_ioctl_giwpower(struct net_device *dev,
-				    struct iw_request_info *info,
-				    union iwreq_data *wrqu,
-				    char *extra)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	wrqu->power.disabled = !sdata->u.mgd.powersave;
-
-	return 0;
-}
-
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -436,8 +370,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) cfg80211_wext_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
-	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
+	(iw_handler) cfg80211_wext_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) cfg80211_wext_siwgenie,		/* SIOCSIWGENIE */
--- wireless-testing.orig/net/wireless/Kconfig	2009-06-30 13:42:33.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-06-30 13:47:31.000000000 +0200
@@ -26,6 +26,22 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
+config CFG80211_DEFAULT_PS
+	bool "enable powersave by default"
+	depends on CFG80211
+	default y
+	help
+	  This option enables powersave mode by default.
+
+	  If this causes your applications to misbehave you should fix your
+	  applications instead -- they need to register their network
+	  latency requirement, see Documentation/power/pm_qos_interface.txt.
+
+config CFG80211_DEFAULT_PS_VALUE
+	int
+	default 1 if CFG80211_DEFAULT_PS
+	default 0
+
 config CFG80211_DEBUGFS
 	bool "cfg80211 DebugFS entries"
 	depends on CFG80211 && DEBUG_FS
--- wireless-testing.orig/net/wireless/core.c	2009-06-30 13:47:13.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-30 13:47:31.000000000 +0200
@@ -550,12 +550,21 @@ static int cfg80211_netdev_notifier_call
 		}
 		wdev->netdev = dev;
 		wdev->sme_state = CFG80211_SME_IDLE;
+		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_WIRELESS_EXT
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+		wdev->wext.ps = CONFIG_CFG80211_DEFAULT_PS_VALUE;
+		wdev->wext.ps_timeout = 500;
+		if (rdev->ops->set_power_mgmt)
+			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
+						      wdev->wext.ps,
+						      wdev->wext.ps_timeout)) {
+				/* assume this means it's off */
+				wdev->wext.ps = false;
+			}
 #endif
-		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_GOING_DOWN:
 		if (!wdev->ssid_len)
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-30 13:47:13.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-30 13:47:31.000000000 +0200
@@ -988,3 +988,63 @@ int cfg80211_wext_giwauth(struct net_dev
 	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwauth);
+
+int cfg80211_wext_siwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	bool ps = wdev->wext.ps;
+	int timeout = wdev->wext.ps_timeout;
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION)
+		return -EINVAL;
+
+	if (!rdev->ops->set_power_mgmt)
+		return -EOPNOTSUPP;
+
+	if (wrq->disabled) {
+		ps = false;
+	} else {
+		switch (wrq->flags & IW_POWER_MODE) {
+		case IW_POWER_ON:       /* If not specified */
+		case IW_POWER_MODE:     /* If set all mask */
+		case IW_POWER_ALL_R:    /* If explicitely state all */
+			ps = true;
+			break;
+		default:                /* Otherwise we ignore */
+			return -EINVAL;
+		}
+
+		if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
+			return -EINVAL;
+
+		if (wrq->flags & IW_POWER_TIMEOUT)
+			timeout = wrq->value / 1000;
+	}
+
+	err = rdev->ops->set_power_mgmt(wdev->wiphy, dev, ps, timeout);
+	if (err)
+		return err;
+
+	wdev->wext.ps = ps;
+	wdev->wext.ps_timeout = timeout;
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_siwpower);
+
+int cfg80211_wext_giwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	wrq->disabled = !wdev->wext.ps;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cfg80211_wext_giwpower);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-30 13:42:33.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-30 13:47:31.000000000 +0200
@@ -1388,6 +1388,31 @@ int ieee80211_testmode_cmd(struct wiphy 
 }
 #endif
 
+static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+				    bool enabled, int timeout)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+		return -EOPNOTSUPP;
+
+	if (enabled == sdata->u.mgd.powersave &&
+	    timeout == conf->dynamic_ps_timeout)
+		return 0;
+
+	sdata->u.mgd.powersave = enabled;
+	conf->dynamic_ps_timeout = timeout;
+
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+
+	ieee80211_recalc_ps(local, -1);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1431,4 +1456,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.get_tx_power = ieee80211_get_tx_power,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
+	.set_power_mgmt = ieee80211_set_power_mgmt,
 };
--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-30 13:47:13.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-30 13:47:31.000000000 +0200
@@ -2360,11 +2360,6 @@ void ieee80211_sta_setup_sdata(struct ie
 		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
 
 	hw_flags = sdata->local->hw.flags;
-
-	if (hw_flags & IEEE80211_HW_SUPPORTS_PS) {
-		ifmgd->powersave = CONFIG_MAC80211_DEFAULT_PS_VALUE;
-		sdata->local->hw.conf.dynamic_ps_timeout = 500;
-	}
 }
 
 /* configuration hooks */
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-06-30 13:42:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2009-06-30 13:47:31.000000000 +0200
@@ -522,6 +522,27 @@ static int iwm_cfg80211_get_txpower(stru
 	return 0;
 }
 
+static int iwm_cfg80211_set_power_mgmt(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       bool enabled, int timeout)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+	u32 power_index;
+
+	if (enabled)
+		power_index = IWM_POWER_INDEX_DEFAULT;
+	else
+		power_index = IWM_POWER_INDEX_MIN;
+
+	if (power_index == iwm->conf.power_index)
+		return 0;
+
+	iwm->conf.power_index = power_index;
+
+	return iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+				       CFG_POWER_INDEX, iwm->conf.power_index);
+}
+
 static struct cfg80211_ops iwm_cfg80211_ops = {
 	.change_virtual_intf = iwm_cfg80211_change_iface,
 	.add_key = iwm_cfg80211_add_key,
@@ -534,6 +555,7 @@ static struct cfg80211_ops iwm_cfg80211_
 	.leave_ibss = iwm_cfg80211_leave_ibss,
 	.set_tx_power = iwm_cfg80211_set_txpower,
 	.get_tx_power = iwm_cfg80211_get_txpower,
+	.set_power_mgmt = iwm_cfg80211_set_power_mgmt,
 };
 
 struct wireless_dev *iwm_wdev_alloc(int sizeof_bus, struct device *dev)
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/wext.c	2009-06-30 13:42:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/wext.c	2009-06-30 13:47:31.000000000 +0200
@@ -238,49 +238,6 @@ static int iwm_set_wpa_version(struct iw
 	return 0;
 }
 
-static int iwm_wext_siwpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *wrq, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-	u32 power_index;
-
-	if (wrq->disabled) {
-		power_index = IWM_POWER_INDEX_MIN;
-		goto set;
-	} else
-		power_index = IWM_POWER_INDEX_DEFAULT;
-
-	switch (wrq->flags & IW_POWER_MODE) {
-	case IW_POWER_ON:
-	case IW_POWER_MODE:
-	case IW_POWER_ALL_R:
-		break;
-	default:
-		return -EINVAL;
-	}
-
- set:
-	if (power_index == iwm->conf.power_index)
-		return 0;
-
-	iwm->conf.power_index = power_index;
-
-	return iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
-				       CFG_POWER_INDEX, iwm->conf.power_index);
-}
-
-static int iwm_wext_giwpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *wrqu, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-
-	wrqu->power.disabled = (iwm->conf.power_index == IWM_POWER_INDEX_MIN);
-
-	return 0;
-}
-
 static int iwm_set_key_mgt(struct iwm_priv *iwm, u8 key_mgt)
 {
 	u8 *auth_type = &iwm->umac_profile->sec.auth_type;
@@ -458,8 +415,8 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) NULL,				/* SIOCGIWRETRY */
 	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) iwm_wext_siwpower,			/* SIOCSIWPOWER */
-	(iw_handler) iwm_wext_giwpower,			/* SIOCGIWPOWER */
+	(iw_handler) cfg80211_wext_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,                              /* SIOCSIWGENIE */

-- 

