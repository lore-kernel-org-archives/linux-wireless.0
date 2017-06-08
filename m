Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52682 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdFHLBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 07:01:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't look at the PM bit of BAR frames
Date: Thu,  8 Jun 2017 14:00:49 +0300
Message-Id: <20170608110049.8747-1-emmanuel.grumbach@intel.com> (sfid-20170608_130104_649578_6E1C9125)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a peer sends a BAR frame with PM bit clear, we should
not modify its PM state as madated by the spec in
802.11-20012 10.2.1.2.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e48724a6725e..bb1e4bbf55e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1558,12 +1558,16 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 */
 	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
+	    !ieee80211_is_back_req(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
-	    /* PM bit is only checked in frames where it isn't reserved,
+	    /*
+	     * PM bit is only checked in frames where it isn't reserved,
 	     * in AP mode it's reserved in non-bufferable management frames
 	     * (cf. IEEE 802.11-2012 8.2.4.1.7 Power Management field)
+	     * BAR frames should be ignored as specified in
+	     * IEEE 802.11-2012 10.2.1.2.
 	     */
 	    (!ieee80211_is_mgmt(hdr->frame_control) ||
 	     ieee80211_is_bufferable_mmpdu(hdr->frame_control))) {
-- 
2.9.3
