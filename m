Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXFVIlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:07 -0400
Message-Id: <20070621221756.722965000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 03/14] mac80211: rx cleanups (1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make some really indented code more readable by outdenting.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |  198 +++++++++++++++++++++++++++---------------------------
 1 file changed, 101 insertions(+), 97 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 19:38:16.118638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 20:45:17.428638003 +0200
@@ -1243,21 +1243,24 @@ static inline ieee80211_txrx_result __ie
 
 	for (handler = handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
-		if (res != TXRX_CONTINUE) {
-			if (res == TXRX_DROP) {
-				I802_DEBUG_INC(local->rx_handlers_drop);
-				if (sta)
-					sta->rx_dropped++;
-			}
-			if (res == TXRX_QUEUED)
-				I802_DEBUG_INC(local->rx_handlers_queued);
+
+		switch (res) {
+		case TXRX_CONTINUE:
+			continue;
+		case TXRX_DROP:
+			I802_DEBUG_INC(local->rx_handlers_drop);
+			if (sta)
+				sta->rx_dropped++;
+			break;
+		case TXRX_QUEUED:
+			I802_DEBUG_INC(local->rx_handlers_queued);
 			break;
 		}
+		break;
 	}
 
-	if (res == TXRX_DROP) {
+	if (res == TXRX_DROP)
 		dev_kfree_skb(rx->skb);
-	}
 	return res;
 }
 
@@ -1409,6 +1412,9 @@ void __ieee80211_rx(struct ieee80211_hw 
 	u16 type;
 	int multicast;
 	int radiotap_len = 0;
+	struct ieee80211_sub_if_data *prev = NULL;
+	struct sk_buff *skb_new;
+	u8 *bssid;
 
 	if (status->flag & RX_FLAG_RADIOTAP) {
 		radiotap_len = ieee80211_get_radiotap_len(skb->data);
@@ -1456,108 +1462,106 @@ void __ieee80211_rx(struct ieee80211_hw 
 		rx.u.rx.ra_match = 1;
 		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
 					     sta);
-	} else {
-		struct ieee80211_sub_if_data *prev = NULL;
-		struct sk_buff *skb_new;
-		u8 *bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
-
-		read_lock(&local->sub_if_lock);
-		list_for_each_entry(sdata, &local->sub_if_list, list) {
-			rx.u.rx.ra_match = 1;
-			switch (sdata->type) {
-			case IEEE80211_IF_TYPE_STA:
-				if (!bssid)
+		sta_info_put(sta);
+		return;
+	}
+
+	bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
+
+	read_lock(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
+		rx.u.rx.ra_match = 1;
+		switch (sdata->type) {
+		case IEEE80211_IF_TYPE_STA:
+			if (!bssid)
+				continue;
+			if (!ieee80211_bssid_match(bssid,
+						   sdata->u.sta.bssid)) {
+				if (!rx.u.rx.in_scan)
 					continue;
-				if (!ieee80211_bssid_match(bssid,
-							sdata->u.sta.bssid)) {
-					if (!rx.u.rx.in_scan)
-						continue;
-					rx.u.rx.ra_match = 0;
-				} else if (!multicast &&
-					   compare_ether_addr(sdata->dev->dev_addr,
-							      hdr->addr1) != 0) {
-					if (!sdata->promisc)
-						continue;
-					rx.u.rx.ra_match = 0;
-				}
-				break;
-			case IEEE80211_IF_TYPE_IBSS:
-				if (!bssid)
+				rx.u.rx.ra_match = 0;
+			} else if (!multicast &&
+				   compare_ether_addr(sdata->dev->dev_addr,
+						      hdr->addr1) != 0) {
+				if (!sdata->promisc)
 					continue;
-				if (!ieee80211_bssid_match(bssid,
-							sdata->u.sta.bssid)) {
-					if (!rx.u.rx.in_scan)
-						continue;
-					rx.u.rx.ra_match = 0;
-				} else if (!multicast &&
-					   compare_ether_addr(sdata->dev->dev_addr,
-							      hdr->addr1) != 0) {
-					if (!sdata->promisc)
-						continue;
-					rx.u.rx.ra_match = 0;
-				} else if (!sta)
-					sta = rx.sta =
-						ieee80211_ibss_add_sta(sdata->dev,
-								       skb, bssid,
-								       hdr->addr2);
-				break;
-			case IEEE80211_IF_TYPE_AP:
-				if (!bssid) {
-					if (compare_ether_addr(sdata->dev->dev_addr,
-							       hdr->addr1) != 0)
-						continue;
-				} else if (!ieee80211_bssid_match(bssid,
-							sdata->dev->dev_addr)) {
-					if (!rx.u.rx.in_scan)
-						continue;
-					rx.u.rx.ra_match = 0;
-				}
-				if (sdata->dev == local->mdev &&
-				    !rx.u.rx.in_scan)
-					/* do not receive anything via
-					 * master device when not scanning */
+				rx.u.rx.ra_match = 0;
+			}
+			break;
+		case IEEE80211_IF_TYPE_IBSS:
+			if (!bssid)
+				continue;
+			if (!ieee80211_bssid_match(bssid,
+						sdata->u.sta.bssid)) {
+				if (!rx.u.rx.in_scan)
 					continue;
-				break;
-			case IEEE80211_IF_TYPE_WDS:
-				if (bssid ||
-				    (rx.fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+				rx.u.rx.ra_match = 0;
+			} else if (!multicast &&
+				   compare_ether_addr(sdata->dev->dev_addr,
+						      hdr->addr1) != 0) {
+				if (!sdata->promisc)
 					continue;
-				if (compare_ether_addr(sdata->u.wds.remote_addr,
-						       hdr->addr2) != 0)
+				rx.u.rx.ra_match = 0;
+			} else if (!sta)
+				sta = rx.sta =
+					ieee80211_ibss_add_sta(sdata->dev,
+							       skb, bssid,
+							       hdr->addr2);
+			break;
+		case IEEE80211_IF_TYPE_AP:
+			if (!bssid) {
+				if (compare_ether_addr(sdata->dev->dev_addr,
+						       hdr->addr1))
 					continue;
-				break;
-			}
-
-			if (prev) {
-				skb_new = skb_copy(skb, GFP_ATOMIC);
-				if (!skb_new) {
-					if (net_ratelimit())
-						printk(KERN_DEBUG "%s: failed to copy "
-						       "multicast frame for %s",
-						       local->mdev->name, prev->dev->name);
+			} else if (!ieee80211_bssid_match(bssid,
+						sdata->dev->dev_addr)) {
+				if (!rx.u.rx.in_scan)
 					continue;
-				}
-				rx.skb = skb_new;
-				rx.dev = prev->dev;
-				rx.sdata = prev;
-				ieee80211_invoke_rx_handlers(local,
-							     local->rx_handlers,
-							     &rx, sta);
+				rx.u.rx.ra_match = 0;
 			}
-			prev = sdata;
+			if (sdata->dev == local->mdev && !rx.u.rx.in_scan)
+				/* do not receive anything via
+				 * master device when not scanning */
+				continue;
+			break;
+		case IEEE80211_IF_TYPE_WDS:
+			if (bssid ||
+			    (rx.fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+				continue;
+			if (compare_ether_addr(sdata->u.wds.remote_addr,
+					       hdr->addr2))
+				continue;
+			break;
 		}
+
 		if (prev) {
-			rx.skb = skb;
+			skb_new = skb_copy(skb, GFP_ATOMIC);
+			if (!skb_new) {
+				if (net_ratelimit())
+					printk(KERN_DEBUG "%s: failed to copy "
+					       "multicast frame for %s",
+					       local->mdev->name, prev->dev->name);
+				continue;
+			}
+			rx.skb = skb_new;
 			rx.dev = prev->dev;
 			rx.sdata = prev;
 			ieee80211_invoke_rx_handlers(local, local->rx_handlers,
 						     &rx, sta);
-		} else
-			dev_kfree_skb(skb);
-		read_unlock(&local->sub_if_lock);
+		}
+		prev = sdata;
 	}
+	if (prev) {
+		rx.skb = skb;
+		rx.dev = prev->dev;
+		rx.sdata = prev;
+		ieee80211_invoke_rx_handlers(local, local->rx_handlers,
+					     &rx, sta);
+	} else
+		dev_kfree_skb(skb);
+	read_unlock(&local->sub_if_lock);
 
-  end:
+ end:
 	if (sta)
 		sta_info_put(sta);
 }

-- 

