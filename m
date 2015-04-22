Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54708 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820AbbDVNZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 09:25:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: clean up/rename prepare_for_handlers()
Date: Wed, 22 Apr 2015 15:25:21 +0200
Message-Id: <1429709122-13734-3-git-send-email-johannes@sipsolutions.net> (sfid-20150422_152548_833801_87D24F71)
In-Reply-To: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
References: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function really shouldn't be called prepare_for_handlers(),
all it does is check if the frame should be dropped. Rename it
to ieee80211_accept_frame() and clean it up a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 80 +++++++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2d8c83892214..5fea34b158fe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3223,11 +3223,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 
 /* main receive path */
 
-static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
-				 struct ieee80211_hdr *hdr)
+static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
 	int multicast = is_multicast_ether_addr(hdr->addr1);
@@ -3236,24 +3236,23 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
 			return false;
-		if (!multicast &&
-		    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
-			return false;
-		break;
+		if (multicast)
+			return true;
+		return ether_addr_equal(sdata->vif.addr, hdr->addr1);
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return false;
 		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
 		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
 			return false;
-		if (ieee80211_is_beacon(hdr->frame_control)) {
+		if (ieee80211_is_beacon(hdr->frame_control))
 			return true;
-		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
+		if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid))
 			return false;
-		} else if (!multicast &&
-			   !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
+		if (!multicast &&
+		    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
 			return false;
-		} else if (!rx->sta) {
+		if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
 				rate_idx = 0; /* TODO: HT/VHT rates */
@@ -3262,20 +3261,18 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			ieee80211_ibss_rx_no_sta(sdata, bssid, hdr->addr2,
 						 BIT(rate_idx));
 		}
-		break;
+		return true;
 	case NL80211_IFTYPE_OCB:
 		if (!bssid)
 			return false;
-		if (ieee80211_is_beacon(hdr->frame_control)) {
+		if (ieee80211_is_beacon(hdr->frame_control))
 			return false;
-		} else if (!is_broadcast_ether_addr(bssid)) {
-			ocb_dbg(sdata, "BSSID mismatch in OCB mode!\n");
+		if (!is_broadcast_ether_addr(bssid))
 			return false;
-		} else if (!multicast &&
-			   !ether_addr_equal(sdata->dev->dev_addr,
-					     hdr->addr1)) {
+		if (!multicast &&
+		    !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1))
 			return false;
-		} else if (!rx->sta) {
+		if (!rx->sta) {
 			int rate_idx;
 			if (status->flag & RX_FLAG_HT)
 				rate_idx = 0; /* TODO: HT rates */
@@ -3284,18 +3281,17 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			ieee80211_ocb_rx_no_sta(sdata, bssid, hdr->addr2,
 						BIT(rate_idx));
 		}
-		break;
+		return true;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (!multicast &&
-		    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
-			return false;
-		break;
+		if (multicast)
+			return true;
+		return ether_addr_equal(sdata->vif.addr, hdr->addr1);
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_AP:
-		if (!bssid) {
-			if (!ether_addr_equal(sdata->vif.addr, hdr->addr1))
-				return false;
-		} else if (!ieee80211_bssid_match(bssid, sdata->vif.addr)) {
+		if (!bssid)
+			return ether_addr_equal(sdata->vif.addr, hdr->addr1);
+
+		if (!ieee80211_bssid_match(bssid, sdata->vif.addr)) {
 			/*
 			 * Accept public action frames even when the
 			 * BSSID doesn't match, this is used for P2P
@@ -3308,7 +3304,9 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return true;
 			return ieee80211_is_beacon(hdr->frame_control);
-		} else if (!ieee80211_has_tods(hdr->frame_control)) {
+		}
+
+		if (!ieee80211_has_tods(hdr->frame_control)) {
 			/* ignore data frames to TDLS-peers */
 			if (ieee80211_is_data(hdr->frame_control))
 				return false;
@@ -3317,27 +3315,22 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 			    !ether_addr_equal(bssid, hdr->addr1))
 				return false;
 		}
-		break;
+		return true;
 	case NL80211_IFTYPE_WDS:
 		if (bssid || !ieee80211_is_data(hdr->frame_control))
 			return false;
-		if (!ether_addr_equal(sdata->u.wds.remote_addr, hdr->addr2))
-			return false;
-		break;
+		return ether_addr_equal(sdata->u.wds.remote_addr, hdr->addr2);
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (!ieee80211_is_public_action(hdr, skb->len) &&
-		    !ieee80211_is_probe_req(hdr->frame_control) &&
-		    !ieee80211_is_probe_resp(hdr->frame_control) &&
-		    !ieee80211_is_beacon(hdr->frame_control))
-			return false;
-		break;
+		return ieee80211_is_public_action(hdr, skb->len) ||
+		       ieee80211_is_probe_req(hdr->frame_control) ||
+		       ieee80211_is_probe_resp(hdr->frame_control) ||
+		       ieee80211_is_beacon(hdr->frame_control);
 	default:
-		/* should never get here */
-		WARN_ON_ONCE(1);
 		break;
 	}
 
-	return true;
+	WARN_ON_ONCE(1);
+	return false;
 }
 
 /*
@@ -3351,11 +3344,10 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_hdr *hdr = (void *)skb->data;
 
 	rx->skb = skb;
 
-	if (!prepare_for_handlers(rx, hdr))
+	if (!ieee80211_accept_frame(rx))
 		return false;
 
 	if (!consume) {
-- 
2.1.4

