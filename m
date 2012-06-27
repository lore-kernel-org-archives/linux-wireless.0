Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2F0NjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 09:39:05 -0400
Message-ID: <1340804336.11012.15.camel@jlt3.sipsolutions.net> (sfid-20120627_153909_072954_03C7880F)
Subject: [PATCH 3.5 v2] mac80211: correct behaviour on unrecognised action
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 15:38:56 +0200
In-Reply-To: <1340799198.11012.14.camel@jlt3.sipsolutions.net> (sfid-20120627_141326_508742_B55D32C3)
References: <1340799198.11012.14.camel@jlt3.sipsolutions.net>
	 (sfid-20120627_141326_508742_B55D32C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When receiving an "individually addressed" action frame, the
receiver is required to return it to the sender. mac80211
gets this wrong as it also returns group addressed (mcast)
frames to the sender. Fix this and update the reference to
the new 802.11 standards version since things were shuffled
around significantly.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Fix logic, d'oh. Thanks nbd.

 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7bcecf7..965e6ec 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2455,7 +2455,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 	 * frames that we didn't handle, including returning unknown
 	 * ones. For all other modes we will return them to the sender,
 	 * setting the 0x80 bit in the action category, as required by
-	 * 802.11-2007 7.3.1.11.
+	 * 802.11-2012 9.24.4.
 	 * Newer versions of hostapd shall also use the management frame
 	 * registration mechanisms, but older ones still use cooked
 	 * monitor interfaces so push all frames there.
@@ -2465,6 +2465,9 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_MONITOR;
 
+	if (is_multicast_ether_addr(mgmt->da))
+		return RX_DROP_MONITOR;
+
 	/* do not return rejected action frames */
 	if (mgmt->u.action.category & 0x80)
 		return RX_DROP_UNUSABLE;
-- 
1.7.10


