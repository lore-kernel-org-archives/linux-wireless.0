Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1ITPk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 11:40:56 -0400
Subject: [PATCH] mac80211: fix AP/VLAN PS buffer race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 17:40:51 +0200
Message-ID: <1316533251.3953.46.camel@jlt3.sipsolutions.net> (sfid-20110920_174059_898103_ABD4BCDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an AP interface is removed without the
AP/VLAN interfaces having been removed before
already, the AP-VLAN interface might still
have sleeping stations and buffer multicast
frames which will happen on the AP interface.
Thus, we need to remove AP/VLAN interfaces
before purging buffered broadcast frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/mac80211/iface.c	2011-09-09 08:52:27.000000000 +0200
+++ b/net/mac80211/iface.c	2011-09-09 08:58:28.000000000 +0200
@@ -460,17 +460,15 @@ static void ieee80211_do_stop(struct iee
 		synchronize_rcu();
 		kfree(old_beacon);
 
-		/* free all potentially still buffered bcast frames */
-		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
-			local->total_ps_buffered--;
-			dev_kfree_skb(skb);
-		}
-
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+
+		/* free all potentially still buffered bcast frames */
+		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
+		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
 	}
 
 	if (going_down)


