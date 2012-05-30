Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43471 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2E3BbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 21:31:14 -0400
Received: by dady13 with SMTP id y13so6205580dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 18:31:14 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: Fix the Problem of Unreachable Mesh Station when joining from one MBSS to another MBSS
Date: Wed, 30 May 2012 09:30:41 +0800
Message-Id: <1338341441-26969-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120530_033118_438671_A13D26F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh station that joins an MBSS is reachable using mesh portal with 6 address frame
by mesh stations from another MBSS if these two different MBSSes are bridged. However,
if the mesh station later moves into the same MBSS of those mesh stations, it is unreachable
by mesh stations in the MBSS due to the mpp_paths table is not deleted. A quick fix is
to perform mesh_path_lookup, if it is available for the target destination, mpp_path_lookup
is not performed. When the mesh station moves back to its original MBSS, the mesh_paths will
be deleted once expired. So, it will be reachable using mpp_path_lookup again.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/tx.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d67d36f..f44cd9d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1740,7 +1740,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	__le16 fc;
 	struct ieee80211_hdr hdr;
 	struct ieee80211s_hdr mesh_hdr __maybe_unused;
-	struct mesh_path __maybe_unused *mppath = NULL;
+	struct mesh_path __maybe_unused *mppath = NULL, *mpath = NULL;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1806,8 +1806,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto fail;
 		}
 		rcu_read_lock();
-		if (!is_multicast_ether_addr(skb->data))
-			mppath = mpp_path_lookup(skb->data, sdata);
+		if (!is_multicast_ether_addr(skb->data)) {
+			mpath = mesh_path_lookup(skb->data, sdata);
+			if (!mpath)
+				mppath = mpp_path_lookup(skb->data, sdata);
+		}
 
 		/*
 		 * Use address extension if it is a packet from
-- 
1.7.0.4

