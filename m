Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXIFNpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:45:43 -0400
Message-Id: <20070905234624.154022000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 06/21] mac80211: remove IEEE80211_CONF_SSID_HIDDEN and  PRISM2_PARAM_BROADCAST_SSID
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_CONF_SSID_HIDDEN setting is not useful for any driver
we have and should be a per-interface setting anyway. Remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |    3 +--
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_ioctl.c |   13 -------------
 3 files changed, 1 insertion(+), 16 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:13.764453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:16.124453431 +0200
@@ -322,8 +322,7 @@ struct ieee80211_conf {
 
 #define IEEE80211_CONF_SHORT_SLOT_TIME	(1<<0) /* use IEEE 802.11g Short Slot
 						* Time */
-#define IEEE80211_CONF_SSID_HIDDEN	(1<<1) /* do not broadcast the ssid */
-#define IEEE80211_CONF_RADIOTAP		(1<<2) /* use radiotap if supported
+#define IEEE80211_CONF_RADIOTAP		(1<<1) /* use radiotap if supported
 						  check this bit at RX time */
 	u32 flags;			/* configuration flags defined above */
 
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-09-06 01:35:14.614453431 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-09-06 01:35:16.144453431 +0200
@@ -36,7 +36,6 @@ enum {
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
-	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_WIFI_WME_NOACK_TEST = 1033,
 	PRISM2_PARAM_SCAN_FLAGS = 1035,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:35:14.624453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:35:16.144453431 +0200
@@ -1673,15 +1673,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->next_mode = hostapd_mode_to_mode(value);
 		break;
 
-	case PRISM2_PARAM_BROADCAST_SSID:
-		if ((value < 0) || (value > 1))
-			ret = -EINVAL;
-		else if (value)
-			local->hw.conf.flags |= IEEE80211_CONF_SSID_HIDDEN;
-		else
-			local->hw.conf.flags &= ~IEEE80211_CONF_SSID_HIDDEN;
-		break;
-
 	case PRISM2_PARAM_EAPOL:
 		sdata->eapol = value;
 		break;
@@ -1809,10 +1800,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->next_mode;
 		break;
 
-	case PRISM2_PARAM_BROADCAST_SSID:
-		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SSID_HIDDEN);
-		break;
-
 	case PRISM2_PARAM_EAPOL:
 		*param = sdata->eapol;
 		break;

-- 

