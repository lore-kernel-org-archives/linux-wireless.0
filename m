Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33308 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756272AbcJGIJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 04:09:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: validate DA/SA during A-MSDU decapsulation
Date: Fri,  7 Oct 2016 10:09:39 +0200
Message-Id: <1475827779-29808-3-git-send-email-johannes@sipsolutions.net> (sfid-20161007_101149_405306_5F684B2B)
In-Reply-To: <1475827779-29808-1-git-send-email-johannes@sipsolutions.net>
References: <1475827779-29808-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As pointed out by Michael Braun, we don't check inner L2 addresses
during A-MSDU decapsulation, leading to the possibility that, for
example, a station associated to an AP sends frames as though they
came from somewhere else.

Fix this problem by letting cfg80211 validate the addresses, as
indicated by passing in the ones that need to be validated.

Reported-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cf53fe1a0aa2..a47bbc973f2d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2299,6 +2299,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	struct sk_buff_head frame_list;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct ethhdr ethhdr;
+	const u8 *check_da = ethhdr.h_dest, *check_sa = ethhdr.h_source;
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -2322,6 +2323,23 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 		default:
 			return RX_DROP_UNUSABLE;
 		}
+		check_da = NULL;
+		check_sa = NULL;
+	} else switch (rx->sdata->vif.type) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_AP_VLAN:
+			check_da = NULL;
+			break;
+		case NL80211_IFTYPE_STATION:
+			if (!rx->sta ||
+			    !test_sta_flag(rx->sta, WLAN_STA_TDLS_PEER))
+				check_sa = NULL;
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			check_sa = NULL;
+			break;
+		default:
+			break;
 	}
 
 	if (is_multicast_ether_addr(hdr->addr1))
@@ -2338,7 +2356,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom,
-				 NULL, NULL);
+				 check_da, check_sa);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
-- 
2.8.1
