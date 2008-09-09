Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIII6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:58:30 -0400
Subject: [PATCH 13/8] mac80211: consolidate deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Tue, 09 Sep 2008 10:58:25 +0200
Message-Id: <1220950705.31304.121.camel@johannes.berg> (sfid-20080909_105833_730947_E8877A11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

deauth and disassoc frames are completely identical so there's
little point in having two functions to send them rather than
one that gets a parameter. This same a bit of code size.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   47 +++++++++++------------------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-09 09:47:27.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 09:50:07.000000000 +0200
@@ -416,17 +416,18 @@ static void ieee80211_send_assoc(struct 
 }
 
 
-static void ieee80211_send_deauth(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_if_sta *ifsta, u16 reason)
+static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
+					   u16 stype, u16 reason)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
 	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for deauth "
-		       "frame\n", sdata->dev->name);
+		printk(KERN_DEBUG "%s: failed to allocate buffer for "
+		       "deauth/disassoc frame\n", sdata->dev->name);
 		return;
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
@@ -436,42 +437,14 @@ static void ieee80211_send_deauth(struct
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_DEAUTH);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
 	skb_put(skb, 2);
+	/* u.deauth.reason_code == u.disassoc.reason_code */
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
-				    struct ieee80211_if_sta *ifsta, u16 reason)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for disassoc "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_DISASSOC);
-	skb_put(skb, 2);
-	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
 					u8 dialog_token, u16 status, u16 policy,
 					u16 buf_size, u16 timeout)
@@ -920,9 +893,11 @@ static void ieee80211_set_disassoc(struc
 
 	if (self_disconnected) {
 		if (deauth)
-			ieee80211_send_deauth(sdata, ifsta, reason);
+			ieee80211_send_deauth_disassoc(sdata,
+				IEEE80211_STYPE_DEAUTH, reason);
 		else
-			ieee80211_send_disassoc(sdata, ifsta, reason);
+			ieee80211_send_deauth_disassoc(sdata,
+				IEEE80211_STYPE_DISASSOC, reason);
 	}
 
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;


