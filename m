Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbXKCNJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2007 09:09:51 -0400
Subject: [PATCH] mac80211: use IW_AUTH_PRIVACY_INVOKED rather than
	IW_AUTH_KEY_MGMT
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Dan Williams <dcbw@redhat.com>, dragoran <drago01@gmail.com>
In-Reply-To: <1193996986.12078.32.camel@johannes.berg> (sfid-20071102_094840_102694_6460C3FA)
References: <1193671155.5197.71.camel@johannes.berg>
	 <200711011523.03063.flamingice@sourmilk.net>
	 <1193996986.12078.32.camel@johannes.berg>
	 (sfid-20071102_094840_102694_6460C3FA)
Content-Type: text/plain
Date: Sat, 03 Nov 2007 13:11:10 +0000
Message-Id: <1194095471.25744.16.camel@johannes.berg> (sfid-20071103_130957_174069_88A78670)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the long bug-hunt for why dynamic WEP networks didn't work it
turned out that mac80211 incorrectly uses IW_AUTH_KEY_MGMT while
it should use IW_AUTH_PRIVACY_INVOKED to determine whether to
associate to protected networks or not.

This patch changes the behaviour to be that way and clarifies the
existing code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>

---
 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_ioctl.c |   16 +++++++++-------
 net/mac80211/ieee80211_sta.c   |   18 +++++++++++-------
 3 files changed, 21 insertions(+), 15 deletions(-)

--- linux-2.6.orig/net/mac80211/ieee80211_i.h	2007-10-30 14:33:38.267388454 +0000
+++ linux-2.6/net/mac80211/ieee80211_i.h	2007-11-03 12:58:35.749217448 +0000
@@ -230,6 +230,7 @@ struct ieee80211_if_vlan {
 #define IEEE80211_STA_AUTO_SSID_SEL	BIT(10)
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
+#define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
 struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
@@ -259,7 +260,6 @@ struct ieee80211_if_sta {
 	unsigned long request;
 	struct sk_buff_head skb_queue;
 
-	int key_management_enabled;
 	unsigned long last_probe;
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
--- linux-2.6.orig/net/mac80211/ieee80211_ioctl.c	2007-10-30 14:36:01.067382704 +0000
+++ linux-2.6/net/mac80211/ieee80211_ioctl.c	2007-11-03 12:58:36.319230631 +0000
@@ -926,19 +926,21 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_CIPHER_GROUP:
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-	case IW_AUTH_PRIVACY_INVOKED:
-		break;
 	case IW_AUTH_KEY_MGMT:
+		break;
+	case IW_AUTH_PRIVACY_INVOKED:
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			ret = -EINVAL;
 		else {
+			sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
 			/*
-			 * Key management was set by wpa_supplicant,
-			 * we only need this to associate to a network
-			 * that has privacy enabled regardless of not
-			 * having a key.
+			 * Privacy invoked by wpa_supplicant, store the
+			 * value and allow associating to a protected
+			 * network without having a key up front.
 			 */
-			sdata->u.sta.key_management_enabled = !!data->value;
+			if (data->value)
+				sdata->u.sta.flags |=
+					IEEE80211_STA_PRIVACY_INVOKED;
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
--- linux-2.6.orig/net/mac80211/ieee80211_sta.c	2007-10-30 14:33:38.357384602 +0000
+++ linux-2.6/net/mac80211/ieee80211_sta.c	2007-11-03 13:07:16.659226671 +0000
@@ -704,10 +704,11 @@ static int ieee80211_privacy_mismatch(st
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
-	int res = 0;
+	int bss_privacy;
+	int wep_privacy;
+	int privacy_invoked;
 
-	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
-	    ifsta->key_management_enabled)
+	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
@@ -715,13 +716,16 @@ static int ieee80211_privacy_mismatch(st
 	if (!bss)
 		return 0;
 
-	if (ieee80211_sta_wep_configured(dev) !=
-	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
-		res = 1;
+	bss_privacy = !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
+	wep_privacy = !!ieee80211_sta_wep_configured(dev);
+	privacy_invoked = !!(ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED);
 
 	ieee80211_rx_bss_put(dev, bss);
 
-	return res;
+	if ((bss_privacy == wep_privacy) || (bss_privacy == privacy_invoked))
+		return 0;
+
+	return 1;
 }
 
 


