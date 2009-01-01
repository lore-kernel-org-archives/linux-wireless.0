Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752532AbZAAWlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 17:41:47 -0500
Cc: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org
Content-Type: multipart/mixed; boundary="========GMX232021230849704374536"
Date: Thu, 01 Jan 2009 23:41:44 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20081230230751.163100@gmx.net>
Message-ID: <20090101224144.232020@gmx.net> (sfid-20090101_234150_586253_0EA2690D)
MIME-Version: 1.0
References: <20081230025651.6500@gmx.net>	
 (sfid-20081230_035657_768921_742B8565) <1230633565.3850.7.camel@johannes>	
 <20081230223611.163110@gmx.net> (sfid-20081230_233642_601178_E4AB42EE)
 <1230676811.3850.22.camel@johannes> <20081230230751.163100@gmx.net>
Subject: Re: mac80211 (ath9k, ath5k, etc.) set fixed BSSID + channel Patch
To: "Alina Friedrichsen" <x-alina@gmx.net>, johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX232021230849704374536
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello,

here is a new version of this patch, that fixes a bug that manual channel setting in the ad-hoc (IBSS) mode doesn't work properly, too.

It would nice, if it can be committed, before it's out of sync.

Regards
Alina

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX232021230849704374536
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="mac80211-setbssid-3.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mac80211-setbssid-3.patch"

diff -urN compat-wireless-2008-12-29.orig/net/mac80211/mlme.c compat-wireless-2008-12-29/net/mac80211/mlme.c
--- compat-wireless-2008-12-29.orig/net/mac80211/mlme.c	2008-12-29 06:14:35.000000000 +0100
+++ compat-wireless-2008-12-29/net/mac80211/mlme.c	2009-01-01 23:32:46.000000000 +0100
@@ -1660,6 +1660,7 @@
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&
@@ -1705,7 +1706,8 @@
 		       (unsigned long long)(rx_timestamp - beacon_timestamp),
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-		if (beacon_timestamp > rx_timestamp) {
+		if (beacon_timestamp > rx_timestamp &&
+		    memcmp(sdata->u.sta.bssid, mgmt->bssid, ETH_ALEN) != 0) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: beacon TSF higher than "
 			       "local TSF - IBSS merge with BSSID %s\n",
@@ -2031,6 +2033,10 @@
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
+	if ((sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_AUTO_CHANNEL_SEL)))
+		return;
+
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);
@@ -2576,11 +2582,16 @@
 {
 	struct ieee80211_if_sta *ifsta;
 	int res;
+	bool valid;
 
 	ifsta = &sdata->u.sta;
+	valid = is_valid_ether_addr(bssid);
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		if(valid)
+			memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		else
+			memset(ifsta->bssid, 0, ETH_ALEN);
 		res = 0;
 		/*
 		 * Hack! See also ieee80211_sta_set_ssid.
@@ -2594,7 +2605,7 @@
 		}
 	}
 
-	if (is_valid_ether_addr(bssid))
+	if (valid)
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
diff -urN compat-wireless-2008-12-29.orig/net/mac80211/wext.c compat-wireless-2008-12-29/net/mac80211/wext.c
--- compat-wireless-2008-12-29.orig/net/mac80211/wext.c	2008-12-29 06:14:35.000000000 +0100
+++ compat-wireless-2008-12-29/net/mac80211/wext.c	2009-01-01 23:07:55.000000000 +0100
@@ -230,13 +230,15 @@
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+			    sdata->vif.type == NL80211_IFTYPE_STATION)
 				sdata->u.sta.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;

--========GMX232021230849704374536--
