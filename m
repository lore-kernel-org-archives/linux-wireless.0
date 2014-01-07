Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaAGPYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:24:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clean up prepare_for_handlers() return value
Date: Tue,  7 Jan 2014 16:24:11 +0100
Message-Id: <1389108251-19311-1-git-send-email-johannes@sipsolutions.net> (sfid-20140107_162417_967806_8D93F92D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using an int with 0/1 is not very common, make the function
return a bool instead with the same values (false/true).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8cb20d7..c24ca0d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3076,8 +3076,8 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 
 /* main receive path */
 
-static int prepare_for_handlers(struct ieee80211_rx_data *rx,
-				struct ieee80211_hdr *hdr)
+static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
+				 struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct sk_buff *skb = rx->skb;
@@ -3088,29 +3088,29 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 		if (!bssid && !sdata->u.mgd.use_4addr)
-			return 0;
+			return false;
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC) ||
 			    sdata->u.mgd.use_4addr)
-				return 0;
+				return false;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
-			return 0;
+			return false;
 		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
 		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
-			return 0;
+			return false;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
-			return 1;
+			return true;
 		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-			return 0;
+			return false;
 		} else if (!multicast &&
 			   !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
-				return 0;
+				return false;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta) {
 			int rate_idx;
@@ -3126,7 +3126,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
 			if (!(sdata->dev->flags & IFF_PROMISC))
-				return 0;
+				return false;
 
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
@@ -3135,7 +3135,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_AP:
 		if (!bssid) {
 			if (!ether_addr_equal(sdata->vif.addr, hdr->addr1))
-				return 0;
+				return false;
 		} else if (!ieee80211_bssid_match(bssid, sdata->vif.addr)) {
 			/*
 			 * Accept public action frames even when the
@@ -3145,26 +3145,26 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 */
 			if (!multicast &&
 			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
-				return 0;
+				return false;
 			if (ieee80211_is_public_action(hdr, skb->len))
-				return 1;
+				return true;
 			if (!ieee80211_is_beacon(hdr->frame_control))
-				return 0;
+				return false;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
 		if (bssid || !ieee80211_is_data(hdr->frame_control))
-			return 0;
+			return false;
 		if (!ether_addr_equal(sdata->u.wds.remote_addr, hdr->addr2))
-			return 0;
+			return false;
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (!ieee80211_is_public_action(hdr, skb->len) &&
 		    !ieee80211_is_probe_req(hdr->frame_control) &&
 		    !ieee80211_is_probe_resp(hdr->frame_control) &&
 		    !ieee80211_is_beacon(hdr->frame_control))
-			return 0;
+			return false;
 		if (!ether_addr_equal(sdata->vif.addr, hdr->addr1) &&
 		    !multicast)
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
@@ -3175,7 +3175,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		break;
 	}
 
-	return 1;
+	return true;
 }
 
 /*
-- 
1.8.5.1

