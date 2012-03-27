Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2C0MUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:20:18 -0400
Message-Id: <20120327121921.180639599@sipsolutions.net> (sfid-20120327_142024_253382_83D54583)
Date: Tue, 27 Mar 2012 14:18:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] mac80211: fix mesh TX coding style
References: <20120327121835.299635879@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix bad indentation & pointless if nesting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/tx.c	2012-03-23 16:51:10.000000000 +0100
+++ b/net/mac80211/tx.c	2012-03-23 17:03:05.000000000 +0100
@@ -1468,12 +1468,12 @@ void ieee80211_xmit(struct ieee80211_sub
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    ieee80211_is_data(hdr->frame_control) &&
-		!is_multicast_ether_addr(hdr->addr1))
-			if (mesh_nexthop_resolve(skb, sdata)) {
-				/* skb queued: don't free */
-				rcu_read_unlock();
-				return;
-			}
+	    !is_multicast_ether_addr(hdr->addr1) &&
+	    mesh_nexthop_resolve(skb, sdata)) {
+		/* skb queued: don't free */
+		rcu_read_unlock();
+		return;
+	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
 	ieee80211_tx(sdata, skb, false);


