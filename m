Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33567
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXITUIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 16:08:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Add support for setting TX power and radio status
Date: Thu, 20 Sep 2007 22:06:39 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709202206.39874.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for disabling the radio and setting the TXpower
through wext.
This also fixes the prism TXpower ioctl (It always overwrote the TXpower
value in ieee80211_hw_config())

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-19 21:59:54.000000000 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-20 21:58:00.000000000 +0200
@@ -704,7 +704,12 @@ int ieee80211_hw_config(struct ieee80211
 
 	local->hw.conf.channel = chan->chan;
 	local->hw.conf.channel_val = chan->val;
-	local->hw.conf.power_level = chan->power_level;
+	if (!local->hw.conf.power_level) {
+		local->hw.conf.power_level = chan->power_level;
+	} else {
+		local->hw.conf.power_level = min(chan->power_level,
+						 local->hw.conf.power_level);
+	}
 	local->hw.conf.freq = chan->freq;
 	local->hw.conf.phymode = mode->mode;
 	local->hw.conf.antenna_max = chan->antenna_max;
Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-19 21:59:54.000000000 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-20 22:01:43.000000000 +0200
@@ -1429,6 +1429,38 @@ static int ieee80211_ioctl_giwrate(struc
 	return 0;
 }
 
+static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
+				      struct iw_request_info *info,
+				      union iwreq_data *data, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	bool need_reconfig = 0;
+
+	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
+		return -EINVAL;
+	if (data->txpower.flags & IW_TXPOW_RANGE)
+		return -EINVAL;
+	if (!data->txpower.fixed)
+		return -EINVAL;
+
+	if (local->hw.conf.power_level != data->txpower.value) {
+		local->hw.conf.power_level = data->txpower.value;
+		need_reconfig = 1;
+	}
+	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
+		local->hw.conf.radio_enabled = !(data->txpower.disabled);
+		need_reconfig = 1;
+	}
+	if (need_reconfig) {
+		ieee80211_hw_config(local);
+		/* The return value of hw_config is not of big interest here,
+		 * as it doesn't say that it failed because of _this_ config
+		 * change or something else. Ignore it. */
+	}
+
+	return 0;
+}
+
 static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *data, char *extra)
@@ -2208,7 +2240,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
 	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
 	(iw_handler) ieee80211_ioctl_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) NULL,				/* SIOCSIWTXPOW */
+	(iw_handler) ieee80211_ioctl_siwtxpower,	/* SIOCSIWTXPOW */
 	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
 	(iw_handler) ieee80211_ioctl_siwretry,		/* SIOCSIWRETRY */
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
