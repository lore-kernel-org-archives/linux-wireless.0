Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54156 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYJSTSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 15:18:33 -0400
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: inform userspace of probe/auth/assoc timeout
Date: Sun, 19 Oct 2008 22:18:23 +0300
Message-Id: <1224443903-9135-1-git-send-email-kalle.valo@nokia.com> (sfid-20081019_211837_089837_DEF6C67A)
In-Reply-To: <873ait6s4e.fsf@nokia.com>
References: <873ait6s4e.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

I noticed that when for some reason [1] the probe or auth times
out, wpa_supplicant doesn't realise this and only tries the next
AP when it runs into its own timeout, which is ten seconds, and
that's quite long. Fix this by making mac80211 notify userspace
that it didn't associate.

[1] my wrt350n in mixed B/G/HT mode often runs into this, maybe
it's because one of the antennas is broken off and for whatever
reason it decides to use that antenna to transmit the response
frames (auth, probe); I do see beacons fine so it's not totally
broken. Works fine in pure-G mode.

kvalo: backported to 2.6.27

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

Here's a backport of Johannes' patch for 2.6.27 in case anyone 
considers this for stable releases.

 net/mac80211/mlme.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 902cac1..ca80acd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -475,6 +475,17 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 	return 0;
 }
 
+static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_if_sta *ifsta)
+{
+	union iwreq_data wrqu;
+	memset(&wrqu, 0, sizeof(wrqu));
+	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
+		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
+}
+
 static void ieee80211_sta_send_associnfo(struct net_device *dev,
 					 struct ieee80211_if_sta *ifsta)
 {
@@ -533,7 +544,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
-	union iwreq_data wrqu;
 	u32 changed = BSS_CHANGED_ASSOC;
 
 	if (assoc) {
@@ -567,7 +577,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 
 		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(dev, ifsta);
 	} else {
 		netif_carrier_off(dev);
@@ -578,8 +587,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 		sdata->bss_conf.assoc_ht = 0;
 		sdata->bss_conf.ht_conf = NULL;
 		sdata->bss_conf.ht_bss_conf = NULL;
-
-		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	}
 	ifsta->last_probe = jiffies;
 	ieee80211_led_assoc(local, assoc);
@@ -590,8 +597,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 	if (assoc)
 		netif_carrier_on(dev);
 
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	ieee80211_sta_send_apinfo(sdata, ifsta);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
@@ -662,6 +668,7 @@ static void ieee80211_send_auth(struct net_device *dev,
 static void ieee80211_authenticate(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
 
 	ifsta->auth_tries++;
@@ -670,6 +677,7 @@ static void ieee80211_authenticate(struct net_device *dev,
 		       " timed out\n",
 		       dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 
@@ -1003,6 +1011,7 @@ static int ieee80211_privacy_mismatch(struct net_device *dev,
 static void ieee80211_associate(struct net_device *dev,
 				struct ieee80211_if_sta *ifsta)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
 
 	ifsta->assoc_tries++;
@@ -1011,6 +1020,7 @@ static void ieee80211_associate(struct net_device *dev,
 		       " timed out\n",
 		       dev->name, print_mac(mac, ifsta->bssid));
 		ifsta->state = IEEE80211_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 
@@ -1021,6 +1031,7 @@ static void ieee80211_associate(struct net_device *dev,
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", dev->name);
 		ifsta->state = IEEE80211_DISABLED;
+		ieee80211_sta_send_apinfo(sdata, ifsta);
 		return;
 	}
 
-- 
1.5.6.5

