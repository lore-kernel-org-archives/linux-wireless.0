Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47473 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbcJEITP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 04:19:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "M . Braun" <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: discard multicast and 4-addr A-MSDUs
Date: Wed,  5 Oct 2016 10:19:11 +0200
Message-Id: <1475655551-13504-1-git-send-email-johannes@sipsolutions.net> (sfid-20161005_101921_386301_30B9F665)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In mac80211, multicast A-MSDUs are accepted in many cases that
they shouldn't be accepted in:
 * drop A-MSDUs with a multicast A1 (RA), as required by the
   spec in 9.11 (802.11-2012 version)
 * drop A-MSDUs with a 4-addr header, since the fourth address
   can't actually be useful for them; this was already done in
   the case where 4-addr behaviour was requested, but bizarrely
   not in the common cases

Accepting the first case, in particular, is very problematic
since it allows anyone else with possession of a GTK to send
unicast frames encapsulated in a multicast A-MSDU, even when
the AP has client isolation enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6175db385ba7..31aadc769021 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2308,16 +2308,10 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (!(status->rx_flags & IEEE80211_RX_AMSDU))
 		return RX_CONTINUE;
 
-	if (ieee80211_has_a4(hdr->frame_control) &&
-	    rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-	    !rx->sdata->u.vlan.sta)
+	if (ieee80211_has_a4(hdr->frame_control))
 		return RX_DROP_UNUSABLE;
 
-	if (is_multicast_ether_addr(hdr->addr1) &&
-	    ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-	      rx->sdata->u.vlan.sta) ||
-	     (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
-	      rx->sdata->u.mgd.use_4addr)))
+	if (is_multicast_ether_addr(hdr->addr1))
 		return RX_DROP_UNUSABLE;
 
 	skb->dev = dev;
-- 
2.8.1
