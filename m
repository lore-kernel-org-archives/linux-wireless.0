Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34065 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756110AbZAVCgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 21:36:33 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 22 Jan 2009 03:36:30 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090122023630.269690@gmx.net> (sfid-20090122_033639_943719_AFF11993)
MIME-Version: 1.0
Subject: [PATCH v2] mac80211: Fixed BSSID handling revisited
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleanup the fixed BSSID handling, that ieee80211_sta_set_bss=
id() works like ieee80211_sta_set_ssid(). So that the BSSID is only a s=
econd selection criterion besides the SSID. This allows us to create ne=
w IBSS networks with fixed BSSIDs, which was broken before.

In the second version of this patch the handling of the stupid merges t=
o the same BSSID is moved out to get reworked into an other patch.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN compat-wireless-2009-01-19.orig/net/mac80211/mlme.c compat-wi=
reless-2009-01-19/net/mac80211/mlme.c
--- compat-wireless-2009-01-19.orig/net/mac80211/mlme.c	2009-01-19 20:0=
7:19.000000000 +0100
+++ compat-wireless-2009-01-19/net/mac80211/mlme.c	2009-01-22 02:48:34.=
000000000 +0100
@@ -1613,6 +1613,7 @@
=20
 	ieee80211_sta_def_wmm_params(sdata, bss);
=20
+	ifsta->flags |=3D IEEE80211_STA_PREV_BSSID_SET;
 	ifsta->state =3D IEEE80211_STA_MLME_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
=20
@@ -2176,19 +2177,18 @@
 	int i;
 	int ret;
=20
-#if 0
-	/* Easier testing, use fixed BSSID. */
-	memset(bssid, 0xfe, ETH_ALEN);
-#else
-	/* Generate random, not broadcast, locally administered BSSID. Mix in
-	 * own MAC address to make sure that devices that do not have proper
-	 * random number generator get different BSSID. */
-	get_random_bytes(bssid, ETH_ALEN);
-	for (i =3D 0; i < ETH_ALEN; i++)
-		bssid[i] ^=3D sdata->dev->dev_addr[i];
-	bssid[0] &=3D ~0x01;
-	bssid[0] |=3D 0x02;
-#endif
+	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) {
+		memcpy(bssid, ifsta->bssid, ETH_ALEN);
+	} else {
+		/* Generate random, not broadcast, locally administered BSSID. Mix i=
n
+		 * own MAC address to make sure that devices that do not have proper
+		 * random number generator get different BSSID. */
+		get_random_bytes(bssid, ETH_ALEN);
+		for (i =3D 0; i < ETH_ALEN; i++)
+			bssid[i] ^=3D sdata->dev->dev_addr[i];
+		bssid[0] &=3D ~0x01;
+		bssid[0] |=3D 0x02;
+	}
=20
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->dev->name, bssid);
@@ -2249,6 +2249,9 @@
 		    memcmp(ifsta->ssid, bss->ssid, bss->ssid_len) !=3D 0
 		    || !(bss->capability & WLAN_CAPABILITY_IBSS))
 			continue;
+		if ((ifsta->flags & IEEE80211_STA_BSSID_SET) &&
+		    memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) !=3D 0)
+			continue;
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "   bssid=3D%pM found\n", bss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
@@ -2265,7 +2268,9 @@
 		       "%pM\n", bssid, ifsta->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
=20
-	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
+	if (found &&
+	    ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
+	     memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0)) {
 		int ret;
 		int search_freq;
=20
@@ -2603,16 +2608,16 @@
 		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
 		memcpy(ifsta->ssid, ssid, len);
 		ifsta->ssid_len =3D len;
-		ifsta->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
 	}
=20
+	ifsta->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
+
 	if (len)
 		ifsta->flags |=3D IEEE80211_STA_SSID_SET;
 	else
 		ifsta->flags &=3D ~IEEE80211_STA_SSID_SET;
=20
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC &&
-	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		ifsta->ibss_join_req =3D jiffies;
 		ifsta->state =3D IEEE80211_STA_MLME_IBSS_SEARCH;
 		return ieee80211_sta_find_ibss(sdata, ifsta);
@@ -2632,36 +2637,18 @@
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *b=
ssid)
 {
 	struct ieee80211_if_sta *ifsta;
-	int res;
-	bool valid;
=20
 	ifsta =3D &sdata->u.sta;
-	valid =3D is_valid_ether_addr(bssid);
-
-	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
-		if(valid)
-			memcpy(ifsta->bssid, bssid, ETH_ALEN);
-		else
-			memset(ifsta->bssid, 0, ETH_ALEN);
-		res =3D 0;
-		/*
-		 * Hack! See also ieee80211_sta_set_ssid.
-		 */
-		if (netif_running(sdata->dev))
-			res =3D ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-		if (res) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-			return res;
-		}
-	}
=20
-	if (valid)
+	if (is_valid_ether_addr(bssid)) {
+		memcpy(ifsta->bssid, bssid, ETH_ALEN);
 		ifsta->flags |=3D IEEE80211_STA_BSSID_SET;
-	else
+	} else {
+		memset(ifsta->bssid, 0, ETH_ALEN);
 		ifsta->flags &=3D ~IEEE80211_STA_BSSID_SET;
+	}
=20
-	return 0;
+	return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
 }
=20
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, ch=
ar *ie, size_t len)
--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
