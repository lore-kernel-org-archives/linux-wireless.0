Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbXFVIlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:35 -0400
Message-Id: <20070621221757.443025000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 05/14] mac80211: split up __ieee80211_rx
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The really indented part that does the huge switch on the interface
type is a nuisance. Put it into an own function 'prepare_for_handlers'.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |  157 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 83 insertions(+), 74 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 21:27:42.378638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 21:29:55.848638003 +0200
@@ -1407,6 +1407,73 @@ ieee80211_rx_handler ieee80211_rx_handle
 
 /* main receive path */
 
+static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
+				u8 *bssid, struct ieee80211_txrx_data *rx,
+				struct ieee80211_hdr *hdr)
+{
+	int multicast = is_multicast_ether_addr(hdr->addr1);
+
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_STA:
+		if (!bssid)
+			return 0;
+		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+			if (!rx->u.rx.in_scan)
+				return 0;
+			rx->u.rx.ra_match = 0;
+		} else if (!multicast &&
+			   compare_ether_addr(sdata->dev->dev_addr,
+					      hdr->addr1) != 0) {
+			if (!sdata->promisc)
+				return 0;
+			rx->u.rx.ra_match = 0;
+		}
+		break;
+	case IEEE80211_IF_TYPE_IBSS:
+		if (!bssid)
+			return 0;
+		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+			if (!rx->u.rx.in_scan)
+				return 0;
+			rx->u.rx.ra_match = 0;
+		} else if (!multicast &&
+			   compare_ether_addr(sdata->dev->dev_addr,
+					      hdr->addr1) != 0) {
+			if (!sdata->promisc)
+				return 0;
+			rx->u.rx.ra_match = 0;
+		} else if (!rx->sta)
+			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
+							 bssid, hdr->addr2);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		if (!bssid) {
+			if (compare_ether_addr(sdata->dev->dev_addr,
+					       hdr->addr1))
+				return 0;
+		} else if (!ieee80211_bssid_match(bssid,
+					sdata->dev->dev_addr)) {
+			if (!rx->u.rx.in_scan)
+				return 0;
+			rx->u.rx.ra_match = 0;
+		}
+		if (sdata->dev == sdata->local->mdev && !rx->u.rx.in_scan)
+			/* do not receive anything via
+			 * master device when not scanning */
+			return 0;
+		break;
+	case IEEE80211_IF_TYPE_WDS:
+		if (bssid ||
+		    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+			return 0;
+		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
+			return 0;
+		break;
+	}
+
+	return 1;
+}
+
 /*
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
@@ -1420,8 +1487,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_txrx_data rx;
 	u16 type;
-	int multicast;
-	int radiotap_len = 0;
+	int radiotap_len = 0, prepres;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
@@ -1441,18 +1507,16 @@ void __ieee80211_rx(struct ieee80211_hw 
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
-	multicast = is_multicast_ether_addr(hdr->addr1);
 
-	if (skb->len >= 16)
+	if (skb->len >= 16) {
 		sta = rx.sta = sta_info_get(local, hdr->addr2);
-	else
+		if (sta) {
+			rx.dev = rx.sta->dev;
+			rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
+		}
+	} else
 		sta = rx.sta = NULL;
 
-	if (sta) {
-		rx.dev = sta->dev;
-		rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
-	}
-
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
 		ieee80211_rx_michael_mic_report(local->mdev, hdr, sta, &rx);
 		goto end;
@@ -1468,10 +1532,10 @@ void __ieee80211_rx(struct ieee80211_hw 
 
 	skb_push(skb, radiotap_len);
 	if (sta && !sta->assoc_ap && !(sta->flags & WLAN_STA_WDS) &&
-	    !local->iff_promiscs && !multicast) {
+	    !local->iff_promiscs && !is_multicast_ether_addr(hdr->addr1)) {
 		rx.u.rx.ra_match = 1;
 		ieee80211_invoke_rx_handlers(local, local->rx_handlers, &rx,
-					     sta);
+					     rx.sta);
 		sta_info_put(sta);
 		return;
 	}
@@ -1481,68 +1545,13 @@ void __ieee80211_rx(struct ieee80211_hw 
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		rx.u.rx.ra_match = 1;
-		switch (sdata->type) {
-		case IEEE80211_IF_TYPE_STA:
-			if (!bssid)
-				continue;
-			if (!ieee80211_bssid_match(bssid,
-						   sdata->u.sta.bssid)) {
-				if (!rx.u.rx.in_scan)
-					continue;
-				rx.u.rx.ra_match = 0;
-			} else if (!multicast &&
-				   compare_ether_addr(sdata->dev->dev_addr,
-						      hdr->addr1) != 0) {
-				if (!sdata->promisc)
-					continue;
-				rx.u.rx.ra_match = 0;
-			}
-			break;
-		case IEEE80211_IF_TYPE_IBSS:
-			if (!bssid)
-				continue;
-			if (!ieee80211_bssid_match(bssid,
-						sdata->u.sta.bssid)) {
-				if (!rx.u.rx.in_scan)
-					continue;
-				rx.u.rx.ra_match = 0;
-			} else if (!multicast &&
-				   compare_ether_addr(sdata->dev->dev_addr,
-						      hdr->addr1) != 0) {
-				if (!sdata->promisc)
-					continue;
-				rx.u.rx.ra_match = 0;
-			} else if (!sta)
-				sta = rx.sta =
-					ieee80211_ibss_add_sta(sdata->dev,
-							       skb, bssid,
-							       hdr->addr2);
-			break;
-		case IEEE80211_IF_TYPE_AP:
-			if (!bssid) {
-				if (compare_ether_addr(sdata->dev->dev_addr,
-						       hdr->addr1))
-					continue;
-			} else if (!ieee80211_bssid_match(bssid,
-						sdata->dev->dev_addr)) {
-				if (!rx.u.rx.in_scan)
-					continue;
-				rx.u.rx.ra_match = 0;
-			}
-			if (sdata->dev == local->mdev && !rx.u.rx.in_scan)
-				/* do not receive anything via
-				 * master device when not scanning */
-				continue;
-			break;
-		case IEEE80211_IF_TYPE_WDS:
-			if (bssid ||
-			    (rx.fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
-				continue;
-			if (compare_ether_addr(sdata->u.wds.remote_addr,
-					       hdr->addr2))
-				continue;
-			break;
-		}
+
+		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
+		/* prepare_for_handlers can change sta */
+		sta = rx.sta;
+
+		if (!prepres)
+			continue;
 
 		if (prev) {
 			skb_new = skb_copy(skb, GFP_ATOMIC);

-- 

