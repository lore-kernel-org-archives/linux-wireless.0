Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab1KDKVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:43 -0400
Message-Id: <20111104101945.533357720@sipsolutions.net> (sfid-20111104_112929_247471_64DB7487)
Date: Fri, 04 Nov 2011 11:18:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/12] mac80211: send unexpected 4addr event
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the cfg80211 notification but only send
one event per associated station to avoid having
tons of events if the station thinks it should be
allowed to use 4addr frames but it isn't.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |   24 +++++++++++++++++-------
 net/mac80211/sta_info.h |    8 ++++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

--- a/net/mac80211/rx.c	2011-11-03 14:17:00.000000000 +0100
+++ b/net/mac80211/rx.c	2011-11-03 14:25:14.000000000 +0100
@@ -1330,15 +1330,20 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 		/*
 		 * If we receive a 4-addr nullfunc frame from a STA
-		 * that was not moved to a 4-addr STA vlan yet, drop
-		 * the frame to the monitor interface, to make sure
-		 * that hostapd sees it
+		 * that was not moved to a 4-addr STA vlan yet send
+		 * the event to userspace and for older hostapd drop
+		 * the frame to the monitor interface.
 		 */
 		if (ieee80211_has_a4(hdr->frame_control) &&
 		    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		     (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-		      !rx->sdata->u.vlan.sta)))
+		      !rx->sdata->u.vlan.sta))) {
+			if (!test_and_set_sta_flag(sta, WLAN_STA_4ADDR_EVENT))
+				cfg80211_rx_unexpected_4addr_frame(
+					rx->sdata->dev, sta->sta.addr,
+					GFP_ATOMIC);
 			return RX_DROP_MONITOR;
+		}
 		/*
 		 * Update counter and free packet here to avoid
 		 * counting this as a dropped packed.
@@ -2017,12 +2022,17 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 		return RX_DROP_MONITOR;
 
 	/*
-	 * Allow the cooked monitor interface of an AP to see 4-addr frames so
-	 * that a 4-addr station can be detected and moved into a separate VLAN
+	 * Send unexpected-4addr-frame event to hostapd. For older versions,
+	 * also drop the frame to cooked monitor interfaces.
 	 */
 	if (ieee80211_has_a4(hdr->frame_control) &&
-	    sdata->vif.type == NL80211_IFTYPE_AP)
+	    sdata->vif.type == NL80211_IFTYPE_AP) {
+		if (rx->sta &&
+		    !test_and_set_sta_flag(rx->sta, WLAN_STA_4ADDR_EVENT))
+			cfg80211_rx_unexpected_4addr_frame(
+				rx->sdata->dev, rx->sta->sta.addr, GFP_ATOMIC);
 		return RX_DROP_MONITOR;
+	}
 
 	err = __ieee80211_data_to_8023(rx, &port_control);
 	if (unlikely(err))
--- a/net/mac80211/sta_info.h	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-11-03 14:20:15.000000000 +0100
@@ -52,6 +52,7 @@
  *	unblocks the station.
  * @WLAN_STA_SP: Station is in a service period, so don't try to
  *	reply to other uAPSD trigger frames or PS-Poll.
+ * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -71,6 +72,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TDLS_PEER_AUTH,
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
+	WLAN_STA_4ADDR_EVENT,
 };
 
 #define STA_TID_NUM 16
@@ -390,6 +392,12 @@ static inline int test_and_clear_sta_fla
 	return test_and_clear_bit(flag, &sta->_flags);
 }
 
+static inline int test_and_set_sta_flag(struct sta_info *sta,
+					enum ieee80211_sta_info_flags flag)
+{
+	return test_and_set_bit(flag, &sta->_flags);
+}
+
 void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx);
 


