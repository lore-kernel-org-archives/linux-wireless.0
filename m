Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54263 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbXHJBEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 21:04:11 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IJIvB-0000We-Nc
	for linux-wireless@vger.kernel.org; Fri, 10 Aug 2007 03:04:09 +0200
Received: from carrot.hep.upenn.edu ([128.91.45.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2007 03:04:09 +0200
Received: from volker.braun by carrot.hep.upenn.edu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2007 03:04:09 +0200
To: linux-wireless@vger.kernel.org
From: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: [PATCH] mac80211: dynamic wep
Date: Fri, 10 Aug 2007 01:03:56 +0000 (UTC)
Message-ID: <pan.2007.08.10.01.03.45@physik.hu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: ipw3945-devel@lists.sourceforge.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes my problems with "dynamic wep" (widely used in
universities), and I can successfully associate and transfer data. The
corresponding wpa_supplicant.conf is:

network={
    ssid="airsas"
    key_mgmt=IEEE8021X
    eap=TTLS
    anonymous_identity="anon@no.org"
    phase2="auth=PAP"
    identity="username"
    password="password"
}

The patch contains basically two changes:
1) Allow privacy mismatch until associated
2) Decrypt unicast frames with the per-STA key, not making any
   assumptions about it being key index 0.



diff -ru linux+mac80211-9.0.3/include/linux/ieee80211.h linux-2.6.22.1/include/linux/ieee80211.h
--- linux+mac80211-9.0.3/include/linux/ieee80211.h	2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/include/linux/ieee80211.h	2007-08-07 13:35:18.000000000 -0400
@@ -357,7 +357,7 @@
 #define WLAN_CAPABILITY_IBSS		(1<<1)
 #define WLAN_CAPABILITY_CF_POLLABLE	(1<<2)
 #define WLAN_CAPABILITY_CF_POLL_REQUEST	(1<<3)
-#define WLAN_CAPABILITY_PRIVACY		(1<<4)
+#define WLAN_CAPABILITY_PRIVACY		(1<<4) /* Force WEP on data packets */
 #define WLAN_CAPABILITY_SHORT_PREAMBLE	(1<<5)
 #define WLAN_CAPABILITY_PBCC		(1<<6)
 #define WLAN_CAPABILITY_CHANNEL_AGILITY	(1<<7)
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211.c linux-2.6.22.1/net/mac80211/ieee80211.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211.c	2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211.c	2007-08-09 20:03:07.000000000 -0400
@@ -3488,7 +3488,6 @@
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
-	int always_sta_key;
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
@@ -3556,29 +3555,23 @@
 		return TXRX_QUEUED;
 	}
 
-	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
-		always_sta_key = 0;
-	else
-		always_sta_key = 1;
+	if (rx->fc & IEEE80211_FCTL_PROTECTED && /* WEP */
+	    (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
+
+		if (rx->skb->pkt_type == PACKET_HOST && 
+		    rx->sta && rx->sta->key) {
 
-	if (rx->sta && rx->sta->key && always_sta_key) {
-		rx->key = rx->sta->key;
-	} else {
-		if (rx->sta && rx->sta->key)
 			rx->key = rx->sta->key;
-		else
-			rx->key = rx->sdata->default_key;
 
-		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-		    rx->fc & IEEE80211_FCTL_PROTECTED) {
+		} else { 
 			int keyidx = ieee80211_wep_get_keyidx(rx->skb);
+			if (keyidx < 0 || keyidx >= NUM_DEFAULT_KEYS)
+				return TXRX_DROP;
+		
+			rx->key = rx->sdata->keys[keyidx];
 
-			if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS &&
-			    (!rx->sta || !rx->sta->key || keyidx > 0))
-				rx->key = rx->sdata->keys[keyidx];
-
-			if (!rx->key) {
-				if (!rx->u.rx.ra_match)
+			if (unlikely(!rx->key)) {
+				if (!rx->u.rx.ra_match) 
 					return TXRX_DROP;
 				printk(KERN_DEBUG "%s: RX WEP frame with "
 				       "unknown keyidx %d (A1=" MAC_FMT " A2="
@@ -3587,14 +3580,21 @@
 				       MAC_ARG(hdr->addr1),
 				       MAC_ARG(hdr->addr2),
 				       MAC_ARG(hdr->addr3));
-				if (!rx->local->apdev)
+				if (!rx->local->apdev) {
+					rx->local->dot11WEPUndecryptableCount++;
 					return TXRX_DROP;
+				}
 				ieee80211_rx_mgmt(
 					rx->local, rx->skb, rx->u.rx.status,
 					ieee80211_msg_wep_frame_unknown_key);
 				return TXRX_QUEUED;
 			}
 		}
+	} else { /* No WEP */
+		if (rx->sta && rx->sta->key)
+			rx->key = rx->sta->key;
+		else
+			rx->key = rx->sdata->default_key;
 	}
 
 	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211_ioctl.c linux-2.6.22.1/net/mac80211/ieee80211_ioctl.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211_ioctl.c	2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211_ioctl.c	2007-08-09 19:01:56.000000000 -0400
@@ -479,13 +479,14 @@
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (is_broadcast_ether_addr(sta_addr)) {
+	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
+		printk(KERN_DEBUG "%s: set_encrypt - invalid idx = %d\n",
+		       dev->name, idx);
+		return -EINVAL;
+	}
+
+	if (is_multicast_ether_addr(sta_addr)) {
 		sta = NULL;
-		if (idx >= NUM_DEFAULT_KEYS) {
-			printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
-			       dev->name, idx);
-			return -EINVAL;
-		}
 		key = sdata->keys[idx];
 
 		/* TODO: consider adding hwaccel support for these; at least
@@ -499,7 +500,7 @@
 		 * being, this can be only set at compile time. */
 	} else {
 		set_tx_key = 0;
-		if (idx != 0) {
+		if (idx != 0 && alg != ALG_WEP) {
 			printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
 			       "individual key\n", dev->name);
 			return -EINVAL;
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211_sta.c linux-2.6.22.1/net/mac80211/ieee80211_sta.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211_sta.c	2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211_sta.c	2007-08-07 15:01:31.000000000 -0400
@@ -1131,10 +1131,11 @@
 	bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
 	if (!bss)
 		return 0;
-
-	if (ieee80211_sta_wep_configured(dev) !=
-	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
-		res = 1;
+	
+	if (ifsta->associated && ieee80211_sta_wep_configured(dev) != 
+	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY)) {
+		res = 1;  /* associated and WEP encryption mismatch */
+	}
 
 	ieee80211_rx_bss_put(dev, bss);

