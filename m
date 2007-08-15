Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37116 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbXHOEMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 00:12:44 -0400
Subject: [PATCHv3] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 00:12:41 -0400
Message-Id: <1187151162.3253.18.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) Instead of hacking around ieee80211_privacy_mismatch, remove it
completely. It serves no useful purpose.

2) Don't make assumptions about keyidx==0 on unicast keys.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>


diff -rup a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
--- a/net/mac80211/ieee80211.c	2007-08-13 17:08:33.000000000 -0400
+++ b/net/mac80211/ieee80211.c	2007-08-14 18:12:06.000000000 -0400
@@ -3488,7 +3488,6 @@ static ieee80211_txrx_result
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
-	int always_sta_key;
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
@@ -3556,29 +3555,19 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		return TXRX_QUEUED;
 	}
 
-	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
-		always_sta_key = 0;
-	else
-		always_sta_key = 1;
-
-	if (rx->sta && rx->sta->key && always_sta_key) {
-		rx->key = rx->sta->key;
-	} else {
-		if (rx->sta && rx->sta->key)
+	if (rx->fc & IEEE80211_FCTL_PROTECTED) {		
+		if (rx->skb->pkt_type == PACKET_HOST && 
+		    rx->sta && rx->sta->key)
 			rx->key = rx->sta->key;
-		else
-			rx->key = rx->sdata->default_key;
-
-		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-		    rx->fc & IEEE80211_FCTL_PROTECTED) {
+		else { 
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
@@ -3587,8 +3576,10 @@ ieee80211_rx_h_check(struct ieee80211_tx
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
@@ -3597,7 +3588,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		}
 	}
 
-	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
+	if (rx->key && rx->u.rx.ra_match) {
 		rx->key->tx_rx_count++;
 		if (unlikely(rx->local->key_tx_rx_threshold &&
 			     rx->key->tx_rx_count >
diff -rup a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
--- a/net/mac80211/ieee80211_ioctl.c	2007-08-13 17:08:33.000000000 -0400
+++ b/net/mac80211/ieee80211_ioctl.c	2007-08-13 17:12:48.000000000 -0400
@@ -479,13 +479,14 @@ static int ieee80211_set_encryption(stru
 
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
@@ -499,7 +500,7 @@ static int ieee80211_set_encryption(stru
 		 * being, this can be only set at compile time. */
 	} else {
 		set_tx_key = 0;
-		if (idx != 0) {
+		if (idx != 0 && alg != ALG_WEP) {
 			printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
 			       "individual key\n", dev->name);
 			return -EINVAL;
diff -rup a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
--- a/net/mac80211/ieee80211_sta.c	2007-08-13 17:08:33.000000000 -0400
+++ b/net/mac80211/ieee80211_sta.c	2007-08-14 15:35:45.000000000 -0400
@@ -1117,30 +1117,6 @@ void ieee80211_send_dls_teardown(struct 
 }
 
 
-static int ieee80211_privacy_mismatch(struct net_device *dev,
-				      struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_sta_bss *bss;
-	int res = 0;
-
-	if (!ifsta || ifsta->mixed_cell ||
-	    ifsta->key_mgmt != IEEE80211_KEY_MGMT_NONE)
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
@@ -1156,12 +1132,6 @@ static void ieee80211_associate(struct n
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
 
@@ -3549,14 +3519,6 @@ void ieee80211_sta_work(struct work_stru
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
 
 


