Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXFVItN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:49:13 -0400
Subject: [PATCH] mac80211: kill PRISM2_PARAM_AP_AUTH_ALGS
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:08:15 +0200
Message-Id: <1182499695.21939.59.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would be used by wpa_supplicant's hostap driver, but, alas,
it runs with the wext driver on mac80211. Kill it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |   16 ----------------
 2 files changed, 17 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 10:05:15.658632620 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 10:06:16.918632620 +0200
@@ -28,7 +28,6 @@ enum {
 	PRISM2_PARAM_BEACON_INT = 3,
 	PRISM2_PARAM_AP_BRIDGE_PACKETS = 10,
 	PRISM2_PARAM_DTIM_PERIOD = 11,
-	PRISM2_PARAM_AP_AUTH_ALGS = 15,
 	PRISM2_PARAM_HOST_ENCRYPT = 17,
 	PRISM2_PARAM_HOST_DECRYPT = 18,
 	PRISM2_PARAM_IEEE_802_1X = 23,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:05:10.558632620 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:06:45.578632620 +0200
@@ -2147,14 +2147,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->bridge_packets = value;
 		break;
 
-	case PRISM2_PARAM_AP_AUTH_ALGS:
-		if (sdata->type == IEEE80211_IF_TYPE_STA ||
-		    sdata->type == IEEE80211_IF_TYPE_IBSS) {
-			sdata->u.sta.auth_algs = value;
-		} else
-			ret = -EOPNOTSUPP;
-		break;
-
 	case PRISM2_PARAM_DTIM_PERIOD:
 		if (value < 1)
 			ret = -EINVAL;
@@ -2374,14 +2366,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->bridge_packets;
 		break;
 
-	case PRISM2_PARAM_AP_AUTH_ALGS:
-		if (sdata->type == IEEE80211_IF_TYPE_STA ||
-		    sdata->type == IEEE80211_IF_TYPE_IBSS) {
-			*param = sdata->u.sta.auth_algs;
-		} else
-			ret = -EOPNOTSUPP;
-		break;
-
 	case PRISM2_PARAM_DTIM_PERIOD:
 		if (sdata->type != IEEE80211_IF_TYPE_AP)
 			ret = -ENOENT;


