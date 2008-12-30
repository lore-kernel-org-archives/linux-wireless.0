Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57486 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752015AbYL3WgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 17:36:13 -0500
Cc: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	berlin@berlin.freifunk.net
Content-Type: multipart/mixed; boundary="========GMX163111230676571497411"
Date: Tue, 30 Dec 2008 23:36:11 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1230633565.3850.7.camel@johannes>
Message-ID: <20081230223611.163110@gmx.net> (sfid-20081230_233618_935336_A03FB019)
MIME-Version: 1.0
References: <20081230025651.6500@gmx.net>	
 (sfid-20081230_035657_768921_742B8565) <1230633565.3850.7.camel@johannes>
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX163111230676571497411
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi Johannes,

thanks for your comments. I'm not so familiar with your coding style for now. Here is the revised patch.

> Can you move the memcmp() into the other condition to avoid indenting
> twice please?

Done.

> Also, it seems there needs to be a STA_BSSID_SET exclusion
> somewhere above to avoid doing merges?

Yes this function is even called if you set a fixed BSSID, where you don't want any merges. Done in line 1663.

> please use a bool for that

Yes, but the called function is written in the old C style before C99, so I think I should use the same type.

> static inline int is_valid_ether_addr(const u8 *addr)

> and indent these properly

Done.

> I won't comment on the actual code right now, the IBSS code is pretty
> much unknown to me and I don't use it.

You only need it for mesh networks.

Regards
Alina

-- 
Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a

--========GMX163111230676571497411
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="mac80211-setbssid-1.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mac80211-setbssid-1.patch"

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
+	int valid;
 
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

--========GMX163111230676571497411--
