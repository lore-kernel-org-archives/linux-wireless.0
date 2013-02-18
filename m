Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:43656 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3BRLrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 06:47:22 -0500
Received: by mail-da0-f43.google.com with SMTP id u36so2451698dak.30
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 03:47:21 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the problem of unicast forwarding from DS to DS in Mesh
Date: Mon, 18 Feb 2013 19:16:47 +0800
Message-Id: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130218_124725_354994_8BCFB82A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unicast frame with unknown forwarding information always trigger
the path discovery assuming destination is always located inside the
MBSS. This patch allows the forwarding to look for mesh gate if path
discovery inside the MBSS has failed.

Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/tx.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b9602b..dce3af3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1844,9 +1844,18 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 
 		if (!is_multicast_ether_addr(skb->data)) {
-			mpath = mesh_path_lookup(sdata, skb->data);
-			if (!mpath)
-				mppath = mpp_path_lookup(sdata, skb->data);
+			struct sta_info *next_hop;
+
+			mpath = mesh_path_lookup(skb->data, sdata);
+			if (mpath)
+				next_hop = rcu_dereference(mpath->next_hop);
+
+			if (!mpath || (mpath && (!next_hop ||
+					!(mpath->flags & MESH_PATH_ACTIVE))))
+				mppath = mpp_path_lookup(skb->data, sdata);
+
+			if (mppath && mpath)
+				mesh_path_del(mpath->dst, mpath->sdata);
 		}
 
 		/*
-- 
1.7.0.4

