Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXJ2QIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:08:54 -0400
Subject: [RFC] mac80211: use IW_AUTH_PRIVACY_INVOKED rather than
	IW_AUTH_KEY_MGMT
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	Dan Williams <dcbw@redhat.com>, dragoran <drago01@gmail.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 16:19:15 +0100
Message-Id: <1193671155.5197.71.camel@johannes.berg> (sfid-20071029_160856_690673_FAA443AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the long bug-hunt for why dynamic WEP networks didn't work it
turned out that mac80211 incorrectly uses IW_AUTH_KEY_MGMT while
it should use IW_AUTH_PRIVACY_INVOKED to determine whether to
associate to protected networks or not.

This patch changes the behaviour to be that way.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>

---
Dan or Dragoran, can you try this patch with a dynamic WEP network and
an unmodified wpa_supplicant (the one that previously didn't work)? It
might need the other patch I sent just before this one ("mac80211:
remove unused driver ops") to apply.

 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_ioctl.c |   16 +++++++++-------
 net/mac80211/ieee80211_sta.c   |    9 +++++----
 3 files changed, 15 insertions(+), 12 deletions(-)

--- linux-2.6.orig/net/mac80211/ieee80211_i.h	2007-10-29 16:05:21.829056966 +0100
+++ linux-2.6/net/mac80211/ieee80211_i.h	2007-10-29 16:06:16.299031412 +0100
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
--- linux-2.6.orig/net/mac80211/ieee80211_ioctl.c	2007-10-29 16:04:16.039043186 +0100
+++ linux-2.6/net/mac80211/ieee80211_ioctl.c	2007-10-29 16:08:53.269031358 +0100
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
--- linux-2.6.orig/net/mac80211/ieee80211_sta.c	2007-10-29 16:07:19.699065863 +0100
+++ linux-2.6/net/mac80211/ieee80211_sta.c	2007-10-29 16:08:48.599031196 +0100
@@ -705,9 +705,9 @@ static int ieee80211_privacy_mismatch(st
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	int res = 0;
+	int privacy;
 
-	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
-	    ifsta->key_management_enabled)
+	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
@@ -715,8 +715,9 @@ static int ieee80211_privacy_mismatch(st
 	if (!bss)
 		return 0;
 
-	if (ieee80211_sta_wep_configured(dev) !=
-	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
+	privacy = !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
+	if ((ieee80211_sta_wep_configured(dev) != privacy) &&
+	    !!((ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED) != privacy))
 		res = 1;
 
 	ieee80211_rx_bss_put(dev, bss);


