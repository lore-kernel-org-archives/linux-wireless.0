Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40624 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751967AbZAWHNx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 02:13:53 -0500
Cc: linux-wireless@vger.kernel.org, maximlevitsky@gmail.com,
	kalle.valo@iki.fi, samuel@sortiz.org
Content-Type: multipart/mixed; boundary="========GMX270731232694825862252"
Date: Fri, 23 Jan 2009 08:13:45 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <4979567D.2020005@lwfinger.net>
Message-ID: <20090123071345.270730@gmx.net> (sfid-20090123_081401_012300_0C8607C7)
MIME-Version: 1.0
References: <4979269F.1060500@lwfinger.net>
 <20090123021413.GB3177@tuxdriver.com> <4979567D.2020005@lwfinger.net>
Subject: Re: Regression caused by commit
	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
To: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX270731232694825862252
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello!

> > I reverted this in wireless-testing (and it never went anywhere
> > upstream).  Of course, now it looks like Samuel has a fix...maybe
> > I'll combine them...
> 
> Samuel's fix works for me.

If this works for the others too, I would propose the following patch. Without it, e.g. the beacon messages in IBSS mode are broken, if you set a fixed BSSID.

(The iwl4965 low level driver sends back an error code, if you want to set a fixed BSSID, so I think, we should simply ignore it, as it will be tried the next time when the initiated new network join is complete.)

Regards
Alina

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX270731232694825862252
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="fixed-bssid-revisited-v3.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="fixed-bssid-revisited-v3.patch"

diff -urN compat-wireless-2009-01-23.orig/net/mac80211/mlme.c compat-wireless-2009-01-23/net/mac80211/mlme.c
--- compat-wireless-2009-01-23.orig/net/mac80211/mlme.c	2009-01-23 06:12:14.000000000 +0100
+++ compat-wireless-2009-01-23/net/mac80211/mlme.c	2009-01-23 07:58:31.000000000 +0100
@@ -1614,6 +1614,7 @@
 
 	ieee80211_sta_def_wmm_params(sdata, bss);
 
+	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
@@ -2177,19 +2178,18 @@
 	int i;
 	int ret;
 
-#if 0
-	/* Easier testing, use fixed BSSID. */
-	memset(bssid, 0xfe, ETH_ALEN);
-#else
-	/* Generate random, not broadcast, locally administered BSSID. Mix in
-	 * own MAC address to make sure that devices that do not have proper
-	 * random number generator get different BSSID. */
-	get_random_bytes(bssid, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		bssid[i] ^= sdata->dev->dev_addr[i];
-	bssid[0] &= ~0x01;
-	bssid[0] |= 0x02;
-#endif
+	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) {
+		memcpy(bssid, ifsta->bssid, ETH_ALEN);
+	} else {
+		/* Generate random, not broadcast, locally administered BSSID. Mix in
+		 * own MAC address to make sure that devices that do not have proper
+		 * random number generator get different BSSID. */
+		get_random_bytes(bssid, ETH_ALEN);
+		for (i = 0; i < ETH_ALEN; i++)
+			bssid[i] ^= sdata->dev->dev_addr[i];
+		bssid[0] &= ~0x01;
+		bssid[0] |= 0x02;
+	}
 
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->dev->name, bssid);
@@ -2250,6 +2250,9 @@
 		    memcmp(ifsta->ssid, bss->ssid, bss->ssid_len) != 0
 		    || !(bss->capability & WLAN_CAPABILITY_IBSS))
 			continue;
+		if ((ifsta->flags & IEEE80211_STA_BSSID_SET) &&
+		    memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) != 0)
+			continue;
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "   bssid=%pM found\n", bss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
@@ -2266,7 +2269,9 @@
 		       "%pM\n", bssid, ifsta->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
+	if (found &&
+	    ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
+	     memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0)) {
 		int ret;
 		int search_freq;
 
@@ -2604,16 +2609,16 @@
 		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
 		memcpy(ifsta->ssid, ssid, len);
 		ifsta->ssid_len = len;
-		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 	}
 
+	ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+
 	if (len)
 		ifsta->flags |= IEEE80211_STA_SSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
 		return ieee80211_sta_find_ibss(sdata, ifsta);
@@ -2633,36 +2638,21 @@
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
 {
 	struct ieee80211_if_sta *ifsta;
-	int res;
-	bool valid;
 
 	ifsta = &sdata->u.sta;
-	valid = is_valid_ether_addr(bssid);
 
-	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		if(valid)
-			memcpy(ifsta->bssid, bssid, ETH_ALEN);
-		else
-			memset(ifsta->bssid, 0, ETH_ALEN);
-		res = 0;
-		/*
-		 * Hack! See also ieee80211_sta_set_ssid.
-		 */
-		if (netif_running(sdata->dev))
-			res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-		if (res) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-			return res;
-		}
-	}
-
-	if (valid)
+	if (is_valid_ether_addr(bssid)) {
+		memcpy(ifsta->bssid, bssid, ETH_ALEN);
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
-	else
+	} else {
+		memset(ifsta->bssid, 0, ETH_ALEN);
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
+	}
 
-	return 0;
+	if (netif_running(sdata->dev))
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
+
+	return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
 }
 
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)

--========GMX270731232694825862252--
