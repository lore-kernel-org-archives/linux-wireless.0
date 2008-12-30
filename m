Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752273AbYL3XHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 18:07:53 -0500
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	berlin@berlin.freifunk.net
Content-Type: multipart/mixed; boundary="========GMX163101230678471384781"
Date: Wed, 31 Dec 2008 00:07:51 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1230676811.3850.22.camel@johannes>
Message-ID: <20081230230751.163100@gmx.net> (sfid-20081231_000758_412792_0480B932)
MIME-Version: 1.0
References: <20081230025651.6500@gmx.net>	
 (sfid-20081230_035657_768921_742B8565) <1230633565.3850.7.camel@johannes>	
 <20081230223611.163110@gmx.net> (sfid-20081230_233642_601178_E4AB42EE)
 <1230676811.3850.22.camel@johannes>
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX163101230678471384781
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi Johannes!

> I disagree, even if the function doesn't use the proper types
> pervasively, we shouldn't be adding old-style stuff.

Okay, I can use bool to if you want, too.

> What Jouni pointed out still stands, you should separate the bugfix and
> the 'disregard ibss join' feature into two patches.

As I say, the "the 'disregard ibss join' feature" is already implemented only not complete. If you want a driver, that do in some situations merges and some others don't, you can easily remove the line 1663. But I think it would nice, if the main driver implement it properly, not half.

For now we can only use the madwifi and an awful hacked proprietary 2.4er kernel broadcom driver for it. It would nice to have a clean free software implementation for it.

Regards
Alina

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX163101230678471384781
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="mac80211-setbssid-2.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mac80211-setbssid-2.patch"

diff -urN compat-wireless-2008-12-29.orig/net/mac80211/mlme.c compat-wireless-2008-12-29/net/mac80211/mlme.c
--- compat-wireless-2008-12-29.orig/net/mac80211/mlme.c	2008-12-29 06:14:35.000000000 +0100
+++ compat-wireless-2008-12-29/net/mac80211/mlme.c	2008-12-30 23:08:08.000000000 +0100
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
@@ -2031,6 +2033,9 @@
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
+	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)
+		return;
+
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);
@@ -2576,11 +2581,16 @@
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
@@ -2594,7 +2604,7 @@
 		}
 	}
 
-	if (is_valid_ether_addr(bssid))
+	if (valid)
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;

--========GMX163101230678471384781--
