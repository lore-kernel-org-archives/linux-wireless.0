Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48700 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbXHRDAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 23:00:19 -0400
Subject: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Volker Braun <vbraun@physics.upenn.edu>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 23:00:18 -0400
Message-Id: <1187406018.30247.17.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ieee80211_privacy_mismatch() and associated variable
"privacy_enabled". It serves no purpose and breaks dynamic wep.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>

---

The patch is on top of Johannes' patches.

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b028cac..d13c06a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -278,7 +278,6 @@ struct ieee80211_if_sta {
 	unsigned long request;
 	struct sk_buff_head skb_queue;
 
-	int privacy_enabled;
 	unsigned long last_probe;
 
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index b68da75..fbdd1d1 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1955,23 +1955,7 @@ static int ieee80211_ioctl_siwauth(struct net_device *dev,
 	case IW_AUTH_CIPHER_GROUP:
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-		break;
 	case IW_AUTH_KEY_MGMT:
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			ret = -EINVAL;
-		else {
-			/*
-			 * What are the semantics in wext supposed to be?
-			 *
-			 * Don't bother figuring that out... It's wext after
-			 * all so figuring it out will most likely require a
-			 * moderate amount of clairvoyance.
-			 *
-			 * TODO: remove in favour of something well-defined
-			 *       in cfg80211/nl80211.
-			 */
-			sdata->u.sta.privacy_enabled = !!data->value;
-		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
 		if (sdata->type == IEEE80211_IF_TYPE_STA ||
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9234183..f2cf4de 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1162,29 +1162,6 @@ void ieee80211_send_dls_teardown(struct net_device *dev,
 }
 
 
-static int ieee80211_privacy_mismatch(struct net_device *dev,
-				      struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_sta_bss *bss;
-	int res = 0;
-
-	if (!ifsta || ifsta->privacy_enabled)
-		return 0;
-
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
-	if (!bss)
-		return 0;
-
-	if (ieee80211_sta_wep_configured(dev) !=
-	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
-		res = 1;
-
-	ieee80211_rx_bss_put(dev, bss);
-
-	return res;
-}
-
-
 static void ieee80211_associate(struct net_device *dev,
 				struct ieee80211_if_sta *ifsta)
 {
@@ -1200,12 +1177,6 @@ static void ieee80211_associate(struct net_device *dev,
 	ifsta->state = IEEE80211_ASSOCIATE;
 	printk(KERN_DEBUG "%s: associate with AP " MAC_FMT "\n",
 	       dev->name, MAC_ARG(ifsta->bssid));
-	if (ieee80211_privacy_mismatch(dev, ifsta)) {
-		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
-		       "mixed-cell disabled - abort association\n", dev->name);
-		ifsta->state = IEEE80211_DISABLED;
-		return;
-	}
 
 	ieee80211_send_assoc(dev, ifsta);
 
@@ -2949,14 +2920,6 @@ void ieee80211_sta_work(struct work_struct *work)
 		       ifsta->state);
 		break;
 	}
-
-	if (ieee80211_privacy_mismatch(dev, ifsta)) {
-		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
-		       "mixed-cell disabled - disassociate\n", dev->name);
-
-		ieee80211_send_disassoc(dev, ifsta, WLAN_REASON_UNSPECIFIED);
-		ieee80211_set_disassoc(dev, ifsta, 0);
-	}
 }
 
 


