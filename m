Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:21156 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYEETi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:38:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so873146waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 12:38:56 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 5 May 2008 12:29:42 -0700
Subject: [PATCH] mac80211: fix access to null skb
Message-ID: <481f6250.16be600a.0e4c.ffffb9ea@mx.google.com> (sfid-20080505_213815_083861_A35F2D17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this patch, if xmit_skb is null but net_ratelimit() returns 0 we would
go to the else branch and access the null xmit_skb. Pointed out by Johannes
Berg.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/rx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e8b89c8..bc66d99 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1300,11 +1300,11 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		if (is_multicast_ether_addr(skb->data)) {
 			if (*mesh_ttl > 0) {
 				xmit_skb = skb_copy(skb, GFP_ATOMIC);
-				if (!xmit_skb && net_ratelimit())
+				if (xmit_skb)
+					xmit_skb->pkt_type = PACKET_OTHERHOST;
+				else if (net_ratelimit())
 					printk(KERN_DEBUG "%s: failed to clone "
 					       "multicast frame\n", dev->name);
-				else
-					xmit_skb->pkt_type = PACKET_OTHERHOST;
 			} else
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
 							     dropped_frames_ttl);
-- 
1.5.4.3



