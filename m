Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1KDKVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:36 -0400
Message-Id: <20111104101944.868455520@sipsolutions.net> (sfid-20111104_112139_039623_3A04D0AB)
Date: Fri, 04 Nov 2011 11:18:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/12] mac80211: report OBSS beacons
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there's an interface in AP mode, OBSS beacons
are needed by hostapd/wpa_s to implement logic to
enable/disable protection etc. Report the frames
and set the capability flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/main.c        |    3 ++-
 net/mac80211/rx.c          |   12 ++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211_i.h	2011-11-03 14:02:28.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-03 14:02:35.000000000 +0100
@@ -184,12 +184,15 @@ enum ieee80211_packet_rx_flags {
  * enum ieee80211_rx_flags - RX data flags
  *
  * @IEEE80211_RX_CMNTR: received on cooked monitor already
+ * @IEEE80211_RX_BEACON_REPORTED: This frame was already reported
+ *	to cfg80211_report_obss_beacon().
  *
  * These flags are used across handling multiple interfaces
  * for a single frame.
  */
 enum ieee80211_rx_flags {
 	IEEE80211_RX_CMNTR		= BIT(0),
+	IEEE80211_RX_BEACON_REPORTED	= BIT(1),
 };
 
 struct ieee80211_rx_data {
--- a/net/mac80211/main.c	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/main.c	2011-11-03 14:02:35.000000000 +0100
@@ -595,7 +595,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
-			WIPHY_FLAG_4ADDR_STATION;
+			WIPHY_FLAG_4ADDR_STATION |
+			WIPHY_FLAG_REPORTS_OBSS;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
--- a/net/mac80211/rx.c	2011-11-03 14:02:28.000000000 +0100
+++ b/net/mac80211/rx.c	2011-11-03 14:02:35.000000000 +0100
@@ -2177,6 +2177,18 @@ ieee80211_rx_h_mgmt_check(struct ieee802
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		return RX_DROP_MONITOR;
 
+	if (rx->sdata->vif.type == NL80211_IFTYPE_AP &&
+	    ieee80211_is_beacon(mgmt->frame_control) &&
+	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
+		struct ieee80211_rx_status *status;
+
+		status = IEEE80211_SKB_RXCB(rx->skb);
+		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
+					    rx->skb->data, rx->skb->len,
+					    status->freq, GFP_ATOMIC);
+		rx->flags |= IEEE80211_RX_BEACON_REPORTED;
+	}
+
 	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 


