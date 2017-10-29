Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42206 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751935AbdJ2JvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 05:51:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 11:51:07 +0200
Message-Id: <20171029095111.17078-2-luca@coelho.fi> (sfid-20171029_105208_563374_7A715C3E)
In-Reply-To: <20171029095111.17078-1-luca@coelho.fi>
References: <20171029095111.17078-1-luca@coelho.fi>
Subject: [PATCH 1/5] mac80211: always update the PM state of a peer on MGMT / DATA frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The 2016 version of the spec is more generic about when the
AP should update the power management state of the peer:
the AP shall update the state based on any management or
data frames. This means that even non-bufferable management
frames should be looked at to update to maintain the power
management state of the peer.

This can avoid problematic cases for example if a station
disappears while being asleep and then re-appears. The AP
would remember it as in power save, but the Authentication
frame couldn't be used to set the peer as awake again.
Note that this issues wasn't really critical since at some
point (after the association) we would have removed the
station and created another one with all the states cleared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/rx.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..b3cff69bfd66 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1607,23 +1607,16 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 
 	/*
 	 * Change STA power saving mode only at the end of a frame
-	 * exchange sequence.
+	 * exchange sequence, and only for a data or management
+	 * frame as specified in IEEE 802.11-2016 11.2.3.2
 	 */
 	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
-	    !ieee80211_is_back_req(hdr->frame_control) &&
+	    (ieee80211_is_mgmt(hdr->frame_control) ||
+	     ieee80211_is_data(hdr->frame_control)) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
-	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
-	    /*
-	     * PM bit is only checked in frames where it isn't reserved,
-	     * in AP mode it's reserved in non-bufferable management frames
-	     * (cf. IEEE 802.11-2012 8.2.4.1.7 Power Management field)
-	     * BAR frames should be ignored as specified in
-	     * IEEE 802.11-2012 10.2.1.2.
-	     */
-	    (!ieee80211_is_mgmt(hdr->frame_control) ||
-	     ieee80211_is_bufferable_mmpdu(hdr->frame_control))) {
+	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
 		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 			if (!ieee80211_has_pm(hdr->frame_control))
 				sta_ps_end(sta);
-- 
2.14.2
