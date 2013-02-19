Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42005 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab3BSCfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 21:35:31 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so3144702pab.32
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 18:35:31 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] mac80211: fix the problem of forwarding from DS to DS in Mesh
Date: Tue, 19 Feb 2013 10:04:50 +0800
Message-Id: <1361239490-4630-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130219_033538_451686_E4C83E84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unicast frame with unknown forwarding information always trigger
the path discovery assuming destination is always located inside the
MBSS. This patch allows the forwarding to look for mesh gate if path
discovery inside the MBSS has failed.

Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: rebase on mac80211-next and redefine the logic clearer (Johannes & Thomas)

 net/mac80211/tx.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b9602b..c79860f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1844,9 +1844,24 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 
 		if (!is_multicast_ether_addr(skb->data)) {
+			struct sta_info *next_hop;
+			bool mpp_lookup = true;
+
 			mpath = mesh_path_lookup(sdata, skb->data);
-			if (!mpath)
+			if (mpath) {
+				mpp_lookup = false;
+				next_hop = rcu_dereference(mpath->next_hop);
+				if (!next_hop ||
+				    !(mpath->flags & (MESH_PATH_ACTIVE |
+						      MESH_PATH_RESOLVING)))
+					mpp_lookup = true;
+			}
+
+			if (mpp_lookup)
 				mppath = mpp_path_lookup(sdata, skb->data);
+
+			if (mppath && mpath)
+				mesh_path_del(mpath->sdata, mpath->dst);
 		}
 
 		/*
-- 
1.7.0.4

