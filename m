Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46624 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2LEFNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 00:13:39 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC] mac80211: dont drop mesh Peering Open frames from unknown STA
Date: Tue,  4 Dec 2012 21:13:30 -0800
Message-Id: <1354684410-31170-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121205_061342_789683_448C9739)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are valid mesh peering frames. The STA entry will then be created in
mesh_peer_init.
The problem was previously worked around, since both STA receive the beacons
of one another, which create the STA entry. This may not be the case when
either node is in PS mode.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8d267ec..89bfbbb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2319,7 +2319,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return RX_DROP_UNUSABLE;
 
-	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
+	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC &&
+	    mgmt->u.action.category != WLAN_CATEGORY_SELF_PROTECTED)
 		return RX_DROP_UNUSABLE;
 
 	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-- 
1.7.9.5

