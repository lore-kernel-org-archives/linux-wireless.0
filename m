Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:3060 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZAQC7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 21:59:06 -0500
Received: by nf-out-0910.google.com with SMTP id d3so302789nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 18:59:04 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: decrement ref count to netdev after launching mesh discovery
Date: Fri, 16 Jan 2009 19:04:49 -0800
Message-Id: <1232161489-29528-1-git-send-email-brian@cozybit.com> (sfid-20090117_035914_261825_19227D28)
In-Reply-To: <mesh netdev decrement>
References: <mesh netdev decrement>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After launching mesh discovery in tx path, reference count was not being
decremented.  This was preventing module unload.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a7392af..d0ae7f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1358,8 +1358,10 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (is_multicast_ether_addr(hdr->addr3))
 			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
 		else
-			if (mesh_nexthop_lookup(skb, osdata))
-				return  0;
+			if (mesh_nexthop_lookup(skb, osdata)) {
+				dev_put(odev);
+				return 0;
+			}
 		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							    fwded_frames);
-- 
1.5.5.3

