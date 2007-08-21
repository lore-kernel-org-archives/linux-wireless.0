Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761726AbXHUPC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:02:29 -0400
Message-Id: <20070821150051.672926000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 25/27] mac80211: kill key_mgmt, use key_management_enabled
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
 net/mac80211/ieee80211_ioctl.c |   20 +++++---------------
 net/mac80211/ieee80211_sta.c   |    3 +--
 4 files changed, 7 insertions(+), 26 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-21 15:58:33.805923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-21 15:59:22.705923881 +0200
@@ -279,7 +279,7 @@ struct ieee80211_if_sta {
 	unsigned long request;
 	struct sk_buff_head skb_queue;
 
-	int key_mgmt;
+	int key_management_enabled;
 	unsigned long last_probe;
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:58:33.845923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:59:22.725923881 +0200
@@ -2323,22 +2323,12 @@ static int ieee80211_ioctl_siwauth(struc
 			ret = -EINVAL;
 		else {
 			/*
-			 * TODO: sdata->u.sta.key_mgmt does not match with WE18
-			 * value completely; could consider modifying this to
-			 * be closer to WE18. For now, this value is not really
-			 * used for anything else than Privacy matching, so the
-			 * current code here should be more or less OK.
+			 * Key management was set by wpa_supplicant,
+			 * we only need this to associate to a network
+			 * that has privacy enabled regardless of not
+			 * having a key.
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
+			sdata->u.sta.key_management_enabled = !!data->value;
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-21 15:58:34.025923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-21 15:59:22.735923881 +0200
@@ -1168,8 +1168,7 @@ static int ieee80211_privacy_mismatch(st
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
 
-	if (!ifsta || ifsta->mixed_cell ||
-	    ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
+	if (!ifsta || ifsta->mixed_cell || ifsta->key_management_enabled)
 		return 0;
 
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-21 15:58:34.065923881 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-21 15:59:22.735923881 +0200
@@ -184,14 +184,6 @@ struct prism2_hostapd_param {
 #define HOSTAP_CRYPT_ERR_TX_KEY_SET_FAILED 6
 #define HOSTAP_CRYPT_ERR_CARD_CONF_FAILED 7
 
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

-- 

