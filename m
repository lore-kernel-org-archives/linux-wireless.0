Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbXHUPIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:08:52 -0400
Message-Id: <20070821150042.289917000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/27] mac80211: remove PRISM2_PARAM_RADIO_ENABLED
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This now is unused in hostapd/wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |   14 --------------
 2 files changed, 15 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 14:39:01.695923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 14:40:10.365923881 +0200
@@ -37,7 +37,6 @@ enum {
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
-	PRISM2_PARAM_RADIO_ENABLED = 1010,
 	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:39:42.055923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:40:10.375923881 +0200
@@ -1157,16 +1157,6 @@ static int ieee80211_ioctl_set_regulator
 }
 
 
-static int ieee80211_ioctl_set_radio_enabled(struct net_device *dev,
-					     int val)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
-
-	conf->radio_enabled = val;
-	return ieee80211_hw_config(wdev_priv(dev->ieee80211_ptr));
-}
-
 static int
 ieee80211_ioctl_set_tx_queue_params(struct net_device *dev,
 				    struct prism2_hostapd_param *param)
@@ -2227,10 +2217,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->next_mode = value;
 		break;
 
-	case PRISM2_PARAM_RADIO_ENABLED:
-		ret = ieee80211_ioctl_set_radio_enabled(dev, value);
-		break;
-
 	case PRISM2_PARAM_ANTENNA_MODE:
 		local->hw.conf.antenna_mode = value;
 		if (ieee80211_hw_config(local))

-- 

