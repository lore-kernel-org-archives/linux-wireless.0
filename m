Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0LVJOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 04:14:52 -0500
Subject: [PATCH 2.6.37] mac80211: fix mesh forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 10:15:07 +0100
Message-ID: <1293009307.3531.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Under memory pressure, the mac80211 mesh code
may helpfully print a message that it failed
to clone a mesh frame and then will proceed
to crash trying to use it anyway. Fix that.

Cc: stable@kernel.org [2.6.27+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-12-22 10:05:58.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-12-22 10:06:08.000000000 +0100
@@ -1831,9 +1831,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			fwd_skb = skb_copy(skb, GFP_ATOMIC);
 
-			if (!fwd_skb && net_ratelimit())
+			if (!fwd_skb && net_ratelimit()) {
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
 						   sdata->name);
+				goto out;
+			}
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
@@ -1871,6 +1873,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 		}
 	}
 
+ out:
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->dev->flags & IFF_PROMISC)
 		return RX_CONTINUE;


