Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349AbXHUPGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:06:46 -0400
Message-Id: <20070821150045.531854000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 14/27] mac80211: ratelimit some RX messages
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many if not all of these messages can be triggered by sending
a few rogue frames which is trivially done and then we overflow
our logs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |  134 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 81 insertions(+), 53 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 14:42:05.415923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 14:49:06.855923881 +0200
@@ -343,13 +343,16 @@ ieee80211_rx_h_load_key(struct ieee80211
 			if (!rx->key) {
 				if (!rx->u.rx.ra_match)
 					return TXRX_DROP;
-				printk(KERN_DEBUG "%s: RX WEP frame with "
-				       "unknown keyidx %d (A1=" MAC_FMT " A2="
-				       MAC_FMT " A3=" MAC_FMT ")\n",
-				       rx->dev->name, keyidx,
-				       MAC_ARG(hdr->addr1),
-				       MAC_ARG(hdr->addr2),
-				       MAC_ARG(hdr->addr3));
+				if (net_ratelimit())
+					printk(KERN_DEBUG "%s: RX WEP frame "
+					       "with unknown keyidx %d "
+					       "(A1=" MAC_FMT
+					       " A2=" MAC_FMT
+					       " A3=" MAC_FMT ")\n",
+					       rx->dev->name, keyidx,
+					       MAC_ARG(hdr->addr1),
+					       MAC_ARG(hdr->addr2),
+					       MAC_ARG(hdr->addr3));
 				if (!rx->local->apdev)
 					return TXRX_DROP;
 				ieee80211_rx_mgmt(
@@ -530,16 +533,18 @@ ieee80211_rx_h_wep_decrypt(struct ieee80
 		return TXRX_CONTINUE;
 
 	if (!rx->key) {
-		printk(KERN_DEBUG "%s: RX WEP frame, but no key set\n",
-		       rx->dev->name);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: RX WEP frame, but no key set\n",
+			       rx->dev->name);
 		return TXRX_DROP;
 	}
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED) ||
 	    rx->key->force_sw_encrypt) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
-			printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
-			       "failed\n", rx->dev->name);
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
+				       "failed\n", rx->dev->name);
 			return TXRX_DROP;
 		}
 	} else if (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
@@ -696,12 +701,15 @@ ieee80211_rx_h_defragment(struct ieee802
 		}
 		rpn = rx->key->u.ccmp.rx_pn[rx->u.rx.queue];
 		if (memcmp(pn, rpn, CCMP_PN_LEN) != 0) {
-			printk(KERN_DEBUG "%s: defrag: CCMP PN not sequential"
-			       " A2=" MAC_FMT " PN=%02x%02x%02x%02x%02x%02x "
-			       "(expected %02x%02x%02x%02x%02x%02x)\n",
-			       rx->dev->name, MAC_ARG(hdr->addr2),
-			       rpn[0], rpn[1], rpn[2], rpn[3], rpn[4], rpn[5],
-			       pn[0], pn[1], pn[2], pn[3], pn[4], pn[5]);
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: defrag: CCMP PN not "
+				       "sequential A2=" MAC_FMT
+				       " PN=%02x%02x%02x%02x%02x%02x "
+				       "(expected %02x%02x%02x%02x%02x%02x)\n",
+				       rx->dev->name, MAC_ARG(hdr->addr2),
+				       rpn[0], rpn[1], rpn[2], rpn[3], rpn[4],
+				       rpn[5], pn[0], pn[1], pn[2], pn[3],
+				       pn[4], pn[5]);
 			return TXRX_DROP;
 		}
 		memcpy(entry->last_pn, pn, CCMP_PN_LEN);
@@ -879,8 +887,9 @@ ieee80211_rx_h_drop_unencrypted(struct i
 		     (rx->key || rx->sdata->drop_unencrypted) &&
 		     (rx->sdata->eapol == 0 ||
 		      !ieee80211_is_eapol(rx->skb)))) {
-		printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
-		       "encryption\n", rx->dev->name);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
+			       "encryption\n", rx->dev->name);
 		return TXRX_DROP;
 	}
 	return TXRX_CONTINUE;
@@ -971,17 +980,19 @@ ieee80211_rx_h_data_agg(struct ieee80211
 				* in local net stack and back to the wireless
 				* media */
 				skb2 = skb_copy(frame, GFP_ATOMIC);
-				if (!skb2)
+				if (!skb2 && net_ratelimit())
 					printk(KERN_DEBUG "%s: failed to clone"
 					       " multicast frame\n", dev->name);
 			} else {
 				struct sta_info *dsta;
 
 				dsta = sta_info_get(local, frame->data);
-				if (dsta && !dsta->dev)
-					printk(KERN_DEBUG "Station with null "
-					       "dev structure!\n");
-				else if (dsta && dsta->dev == dev) {
+				if (dsta && !dsta->dev) {
+					if (net_ratelimit())
+						printk(KERN_DEBUG "Station "
+						       "with null dev "
+						       "structure!\n");
+				} else if (dsta && dsta->dev == dev) {
 					/* Destination station is associated
 					* to this AP, so send the frame
 					* directly to it and do not pass
@@ -1061,10 +1072,15 @@ ieee80211_rx_h_data(struct ieee80211_txr
 
 		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
 			     sdata->type != IEEE80211_IF_TYPE_VLAN)) {
-			printk(KERN_DEBUG "%s: dropped ToDS frame (BSSID="
-			       MAC_FMT " SA=" MAC_FMT " DA=" MAC_FMT ")\n",
-			       dev->name, MAC_ARG(hdr->addr1),
-			       MAC_ARG(hdr->addr2), MAC_ARG(hdr->addr3));
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: dropped ToDS frame "
+				       "(BSSID=" MAC_FMT
+				       " SA=" MAC_FMT
+				       " DA=" MAC_FMT ")\n",
+				       dev->name,
+				       MAC_ARG(hdr->addr1),
+				       MAC_ARG(hdr->addr2),
+				       MAC_ARG(hdr->addr3));
 			return TXRX_DROP;
 		}
 		break;
@@ -1074,12 +1090,16 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		memcpy(src, hdr->addr4, ETH_ALEN);
 
 		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS)) {
-			printk(KERN_DEBUG "%s: dropped FromDS&ToDS frame (RA="
-			       MAC_FMT " TA=" MAC_FMT " DA=" MAC_FMT " SA="
-			       MAC_FMT ")\n",
-			       rx->dev->name, MAC_ARG(hdr->addr1),
-			       MAC_ARG(hdr->addr2), MAC_ARG(hdr->addr3),
-			       MAC_ARG(hdr->addr4));
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
+				       "frame (RA=" MAC_FMT
+				       " TA=" MAC_FMT " DA=" MAC_FMT
+				       " SA=" MAC_FMT ")\n",
+				       rx->dev->name,
+				       MAC_ARG(hdr->addr1),
+				       MAC_ARG(hdr->addr2),
+				       MAC_ARG(hdr->addr3),
+				       MAC_ARG(hdr->addr4));
 			return TXRX_DROP;
 		}
 		break;
@@ -1155,15 +1175,16 @@ ieee80211_rx_h_data(struct ieee80211_txr
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless media */
 			skb2 = skb_copy(skb, GFP_ATOMIC);
-			if (!skb2)
+			if (!skb2 && net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to clone "
 				       "multicast frame\n", dev->name);
 		} else {
 			struct sta_info *dsta;
 			dsta = sta_info_get(local, skb->data);
 			if (dsta && !dsta->dev) {
-				printk(KERN_DEBUG "Station with null dev "
-				       "structure!\n");
+				if (net_ratelimit())
+					printk(KERN_DEBUG "Station with null "
+					       "dev structure!\n");
 			} else if (dsta && dsta->dev == dev) {
 				/* Destination station is associated to this
 				 * AP, so send the frame directly to it and
@@ -1275,24 +1296,28 @@ static void ieee80211_rx_michael_mic_rep
 
 	/* TODO: verify that this is not triggered by fragmented
 	 * frames (hw does not verify MIC for them). */
-	printk(KERN_DEBUG "%s: TKIP hwaccel reported Michael MIC "
-	       "failure from " MAC_FMT " to " MAC_FMT " keyidx=%d\n",
-	       dev->name, MAC_ARG(hdr->addr2), MAC_ARG(hdr->addr1), keyidx);
+	if (net_ratelimit())
+		printk(KERN_DEBUG "%s: TKIP hwaccel reported Michael MIC "
+		       "failure from " MAC_FMT " to " MAC_FMT " keyidx=%d\n",
+		       dev->name, MAC_ARG(hdr->addr2), MAC_ARG(hdr->addr1),
+		       keyidx);
 
 	if (!sta) {
 		/* Some hardware versions seem to generate incorrect
 		 * Michael MIC reports; ignore them to avoid triggering
 		 * countermeasures. */
-		printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-		       "error for unknown address " MAC_FMT "\n",
-		       dev->name, MAC_ARG(hdr->addr2));
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
+			       "error for unknown address " MAC_FMT "\n",
+			       dev->name, MAC_ARG(hdr->addr2));
 		goto ignore;
 	}
 
 	if (!(rx->fc & IEEE80211_FCTL_PROTECTED)) {
-		printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-		       "error for a frame with no ISWEP flag (src "
-		       MAC_FMT ")\n", dev->name, MAC_ARG(hdr->addr2));
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
+			       "error for a frame with no ISWEP flag (src "
+			       MAC_FMT ")\n", dev->name, MAC_ARG(hdr->addr2));
 		goto ignore;
 	}
 
@@ -1304,9 +1329,11 @@ static void ieee80211_rx_michael_mic_rep
 		 * for group keys and only the AP is sending real multicast
 		 * frames in BSS. */
 		if (keyidx) {
-			printk(KERN_DEBUG "%s: ignored Michael MIC error for "
-			       "a frame with non-zero keyidx (%d) (src " MAC_FMT
-			       ")\n", dev->name, keyidx, MAC_ARG(hdr->addr2));
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: ignored Michael MIC "
+				       "error for a frame with non-zero keyidx"
+				       " (%d) (src " MAC_FMT ")\n", dev->name,
+				       keyidx, MAC_ARG(hdr->addr2));
 			goto ignore;
 		}
 	}
@@ -1314,10 +1341,11 @@ static void ieee80211_rx_michael_mic_rep
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)) {
-		printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
-		       "error for a frame that cannot be encrypted "
-		       "(fc=0x%04x) (src " MAC_FMT ")\n",
-		       dev->name, rx->fc, MAC_ARG(hdr->addr2));
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: ignored spurious Michael MIC "
+			       "error for a frame that cannot be encrypted "
+			       "(fc=0x%04x) (src " MAC_FMT ")\n",
+			       dev->name, rx->fc, MAC_ARG(hdr->addr2));
 		goto ignore;
 	}
 

-- 

