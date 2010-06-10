Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:28 -0400
Message-Id: <20100610082233.036307919@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 23/23] mac80211: fix mgmt frame accounting
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The recent change to processing action frames from
the management frame queue had already broken action
frame accounting, and my rework didn't help either.
So add back accounting and simplify the code with a
label rather than duplicating it, and also add
accounting for management frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-06-10 08:37:20.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-06-10 08:41:02.000000000 +0200
@@ -1966,10 +1966,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 			goto invalid;
 		}
 
-		rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-		skb_queue_tail(&sdata->skb_queue, rx->skb);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-		return RX_QUEUED;
+		goto queue;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
 		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
 			break;
@@ -1999,10 +1996,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
 				break;
 
-			rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-			skb_queue_tail(&sdata->skb_queue, rx->skb);
-			ieee80211_queue_work(&local->hw, &sdata->work);
-			return RX_QUEUED;
+			goto queue;
 		}
 		break;
 	case WLAN_CATEGORY_SA_QUERY:
@@ -2022,10 +2016,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
-		rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-		skb_queue_tail(&sdata->skb_queue, rx->skb);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-		return RX_QUEUED;
+		goto queue;
 	}
 
  invalid:
@@ -2076,6 +2067,14 @@ ieee80211_rx_h_action(struct ieee80211_r
 		rx->sta->rx_packets++;
 	dev_kfree_skb(rx->skb);
 	return RX_QUEUED;
+
+ queue:
+	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+	skb_queue_tail(&sdata->skb_queue, rx->skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+	if (rx->sta)
+		rx->sta->rx_packets++;
+	return RX_QUEUED;
 }
 
 static ieee80211_rx_result debug_noinline
@@ -2131,6 +2130,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&rx->local->hw, &sdata->work);
+	if (rx->sta)
+		rx->sta->rx_packets++;
 
 	return RX_QUEUED;
 }


