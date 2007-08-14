Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbXHNLoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:44:19 -0400
Message-Id: <20070814092441.432331000@sipsolutions.net>
References: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/13] mac80211: remove PRISM2_PARAM_RADIO_ENABLED
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This now is unused in hostapd/wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |   14 --------------
 2 files changed, 15 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-14 11:07:30.814229604 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-14 11:08:49.724229604 +0200
@@ -35,7 +35,6 @@ enum {
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
-	PRISM2_PARAM_RADIO_ENABLED = 1010,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-14 11:07:30.854229604 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-14 11:08:49.724229604 +0200
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
@@ -2202,10 +2192,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->next_mode = value;
 		break;
 
-	case PRISM2_PARAM_RADIO_ENABLED:
-		ret = ieee80211_ioctl_set_radio_enabled(dev, value);
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		if ((value < 0) || (value > 1))
 			ret = -EINVAL;

-- 

