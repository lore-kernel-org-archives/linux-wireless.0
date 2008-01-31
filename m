Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYBAMJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:46 -0500
Message-Id: <20080131185054.684023000@sipsolutions.net> (sfid-20080201_120951_608835_F68F3A7F)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mac80211: move some code into
	ieee80211_invoke_rx_handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is some duplicated code that sits in front of each function
call to ieee80211_invoke_rx_handlers() that can very well be part
of that function if it gets slightly different arguments.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-01-31 15:46:13.135794379 +0100
+++ everything/net/mac80211/rx.c	2008-01-31 19:26:11.032266928 +0100
@@ -1450,7 +1450,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
 					    struct ieee80211_hdr *hdr,
-					    struct sta_info *sta,
 					    struct ieee80211_txrx_data *rx)
 {
 	int keyidx, hdrlen;
@@ -1469,7 +1468,7 @@ static void ieee80211_rx_michael_mic_rep
 		       dev->name, print_mac(mac, hdr->addr2),
 		       print_mac(mac2, hdr->addr1), keyidx);
 
-	if (!sta) {
+	if (!rx->sta) {
 		/*
 		 * Some hardware seem to generate incorrect Michael MIC
 		 * reports; ignore them to avoid triggering countermeasures.
@@ -1544,13 +1543,17 @@ static ieee80211_rx_handler ieee80211_rx
 	NULL
 };
 
-static void ieee80211_invoke_rx_handlers(struct ieee80211_local *local,
+static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_txrx_data *rx,
-					 struct sta_info *sta)
+					 struct sk_buff *skb)
 {
 	ieee80211_rx_handler *handler;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
+	rx->skb = skb;
+	rx->sdata = sdata;
+	rx->dev = sdata->dev;
+
 	for (handler = ieee80211_rx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
 
@@ -1559,12 +1562,12 @@ static void ieee80211_invoke_rx_handlers
 			continue;
 		case RX_DROP_UNUSABLE:
 		case RX_DROP_MONITOR:
-			I802_DEBUG_INC(local->rx_handlers_drop);
-			if (sta)
-				sta->rx_dropped++;
+			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
+			if (rx->sta)
+				rx->sta->rx_dropped++;
 			break;
 		case RX_QUEUED:
-			I802_DEBUG_INC(local->rx_handlers_queued);
+			I802_DEBUG_INC(sdata->local->rx_handlers_queued);
 			break;
 		}
 		break;
@@ -1669,7 +1672,6 @@ static void __ieee80211_rx_handle_packet
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_txrx_data rx;
 	u16 type;
@@ -1692,14 +1694,14 @@ static void __ieee80211_rx_handle_packet
 	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
 
-	sta = rx.sta = sta_info_get(local, hdr->addr2);
-	if (sta) {
+	rx.sta = sta_info_get(local, hdr->addr2);
+	if (rx.sta) {
 		rx.dev = rx.sta->dev;
 		rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
 	}
 
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
-		ieee80211_rx_michael_mic_report(local->mdev, hdr, sta, &rx);
+		ieee80211_rx_michael_mic_report(local->mdev, hdr, &rx);
 		goto end;
 	}
 
@@ -1721,8 +1723,6 @@ static void __ieee80211_rx_handle_packet
 		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
 		prepares = prepare_for_handlers(sdata, bssid, &rx, hdr);
-		/* prepare_for_handlers can change sta */
-		sta = rx.sta;
 
 		if (!prepares)
 			continue;
@@ -1753,24 +1753,18 @@ static void __ieee80211_rx_handle_packet
 			continue;
 		}
 		rx.fc = le16_to_cpu(hdr->frame_control);
-		rx.skb = skb_new;
-		rx.dev = prev->dev;
-		rx.sdata = prev;
-		ieee80211_invoke_rx_handlers(local, &rx, sta);
+		ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
 		prev = sdata;
 	}
 	if (prev) {
 		rx.fc = le16_to_cpu(hdr->frame_control);
-		rx.skb = skb;
-		rx.dev = prev->dev;
-		rx.sdata = prev;
-		ieee80211_invoke_rx_handlers(local, &rx, sta);
+		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	} else
 		dev_kfree_skb(skb);
 
  end:
-	if (sta)
-		sta_info_put(sta);
+	if (rx.sta)
+		sta_info_put(rx.sta);
 }
 
 #define SEQ_MODULO 0x1000

-- 

