Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40772 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752023AbYL3C4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 21:56:53 -0500
Content-Type: multipart/mixed; boundary="========GMX6501230605811221214"
Date: Tue, 30 Dec 2008 03:56:51 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20081230025651.6500@gmx.net> (sfid-20081230_035657_768921_742B8565)
MIME-Version: 1.0
Subject: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
To: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX6501230605811221214
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

this patch corrects some bugs of the mac80211 wireless driver framework related to setting a static BSSID in the ad-hoc mode (e.g. for mesh networks like OLSR).

This patch should correct the bug which was reported by Elektra in that wiki, too. Elektra, can you please test it?
http://wiki.villagetelco.org/index.php/Information_about_cell-id_splitting%2C_stuck_beacons%2C_and_failed_IBSS_merges!#The_phenomenon_of_IBSS-ID_cell_splits

Regards
Alina

-- 
Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a

--========GMX6501230605811221214
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="mac80211-setbssid.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="mac80211-setbssid.patch"

diff -urN compat-wireless-2008-12-29.orig/net/mac80211/mlme.c compat-wireless-2008-12-29/net/mac80211/mlme.c
--- compat-wireless-2008-12-29.orig/net/mac80211/mlme.c	2008-12-29 06:14:35.000000000 +0100
+++ compat-wireless-2008-12-29/net/mac80211/mlme.c	2008-12-30 03:18:12.000000000 +0100
@@ -1660,6 +1660,7 @@
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&
@@ -1706,13 +1707,15 @@
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 		if (beacon_timestamp > rx_timestamp) {
+			if (memcmp(sdata->u.sta.bssid, mgmt->bssid, ETH_ALEN) != 0) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-			printk(KERN_DEBUG "%s: beacon TSF higher than "
-			       "local TSF - IBSS merge with BSSID %s\n",
-			       sdata->dev->name, print_mac(mac, mgmt->bssid));
+				printk(KERN_DEBUG "%s: beacon TSF higher than "
+				       "local TSF - IBSS merge with BSSID %s\n",
+				       sdata->dev->name, print_mac(mac, mgmt->bssid));
 #endif
-			ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+				ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
+				ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+			}
 		}
 	}
 
@@ -2031,6 +2034,9 @@
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
+	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)
+		return;
+
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);
@@ -2576,11 +2582,14 @@
 {
 	struct ieee80211_if_sta *ifsta;
 	int res;
+	int valid;
 
 	ifsta = &sdata->u.sta;
+	valid = is_valid_ether_addr(bssid);
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		if(valid) memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		else memset(ifsta->bssid, 0, ETH_ALEN);
 		res = 0;
 		/*
 		 * Hack! See also ieee80211_sta_set_ssid.
@@ -2594,7 +2603,7 @@
 		}
 	}
 
-	if (is_valid_ether_addr(bssid))
+	if (valid)
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;

--========GMX6501230605811221214--
