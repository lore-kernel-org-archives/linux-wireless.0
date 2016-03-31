Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbcCaREQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/10] mac80211: count MSDUs in A-MSDU properly
Date: Thu, 31 Mar 2016 20:02:03 +0300
Message-Id: <1459443731-4614-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190419_459205_3A4B8CEE)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For the RX MSDU statistics, we need to count the number of
MSDUs created and accepted from an A-MSDU. Right now, all
frames in any A-MSDUs were completely ignored. Fix this by
moving the RX MSDU statistics accounting into the deliver
function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6c3829d..d979818 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2111,6 +2111,15 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 
 	ieee80211_rx_stats(dev, skb->len);
 
+	if (rx->sta) {
+		/* The seqno index has the same property as needed
+		 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
+		 * for non-QoS-data frames. Here we know it's a data
+		 * frame, so count MSDUs.
+		 */
+		rx->sta->rx_stats.msdu[rx->seqno_idx]++;
+	}
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
@@ -2397,15 +2406,6 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return RX_DROP_MONITOR;
 
-	if (rx->sta) {
-		/* The seqno index has the same property as needed
-		 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
-		 * for non-QoS-data frames. Here we know it's a data
-		 * frame, so count MSDUs.
-		 */
-		rx->sta->rx_stats.msdu[rx->seqno_idx]++;
-	}
-
 	/*
 	 * Send unexpected-4addr-frame event to hostapd. For older versions,
 	 * also drop the frame to cooked monitor interfaces.
-- 
2.5.0

