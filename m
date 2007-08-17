Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbXHQLZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 07:25:07 -0400
Subject: [PATCH v2 14/20] mac80211: kill key_mgmt variable, use   privacy_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1187312949.23489.97.camel@johannes.berg>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145047.834125000@sipsolutions.net>
	 <1187312949.23489.97.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 13:27:39 +0200
Message-Id: <1187350060.23489.165.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key_mgmt variable for STA interfaces doesn't seem well-defined
nor do we actually use the values other than "NONE", so change it to
be named better.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    8 --------
 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_ioctl.c |   24 +++++++++---------------
 net/mac80211/ieee80211_sta.c   |    2 +-
 4 files changed, 11 insertions(+), 25 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-16 23:26:41.153466559 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-16 23:49:41.323466559 +0200
@@ -277,7 +277,7 @@ struct ieee80211_if_sta {
 	unsigned long request;
 	struct sk_buff_head skb_queue;
 
-	int key_mgmt;
+	int privacy_enabled;
 	unsigned long last_probe;
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-16 23:26:36.253466559 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-16 23:49:36.263466559 +0200
@@ -2245,22 +2245,16 @@ static int ieee80211_ioctl_siwauth(struc
 			ret = -EINVAL;
 		else {
 			/*
-			 * TODO: sdata->u.sta.key_mgmt does not match with WE18
-			 * value completely; could consider modifying this to
-			 * be closer to WE18. For now, this value is not really
-			 * used for anything else than Privacy matching, so the
-			 * current code here should be more or less OK.
+			 * What are the semantics in wext supposed to be?
+			 *
+			 * Don't bother figuring that out... It's wext after
+			 * all so figuring it out will most likely require a
+			 * moderate amount of clairvoyance.
+			 *
+			 * TODO: remove in favour of something well-defined
+			 *       in cfg80211/nl80211.
 			 */
-			if (data->value & IW_AUTH_KEY_MGMT_802_1X) {
-				sdata->u.sta.key_mgmt =
-					IEEE80211_KEY_MGMT_WPA_EAP;
-			} else if (data->value & IW_AUTH_KEY_MGMT_PSK) {
-				sdata->u.sta.key_mgmt =
-					IEEE80211_KEY_MGMT_WPA_PSK;
-			} else {
-				sdata->u.sta.key_mgmt =
-					IEEE80211_KEY_MGMT_NONE;
-			}
+			sdata->u.sta.privacy_enabled = !!data->value;
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-16 23:26:38.253466559 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-16 23:50:29.983466559 +0200
@@ -1168,7 +1168,7 @@ static int ieee80211_privacy_mismatch(st
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
 
-	if (!ifsta || ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
+	if (!ifsta || ifsta->privacy_enabled)
 		return 0;
 
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-16 23:26:35.603466559 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-16 23:49:35.443466559 +0200
@@ -180,14 +180,6 @@ struct prism2_hostapd_param {
 
 #define HOSTAP_HW_FLAG_NULLFUNC_OK BIT(0)
 
-enum {
-	IEEE80211_KEY_MGMT_NONE = 0,
-	IEEE80211_KEY_MGMT_IEEE8021X = 1,
-	IEEE80211_KEY_MGMT_WPA_PSK = 2,
-	IEEE80211_KEY_MGMT_WPA_EAP = 3,
-};
-
-
 /* Data structures used for get_hw_features ioctl */
 struct hostapd_ioctl_hw_modes_hdr {
 	int mode;


