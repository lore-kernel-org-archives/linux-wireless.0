Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab1ECX5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:46 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so260225pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:46 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 11/13] mac80211: Move call to mpp_path_lookup inside RCU-read section
Date: Tue,  3 May 2011 16:57:17 -0700
Message-Id: <1304467039-7730-12-git-send-email-javier@cozybit.com> (sfid-20110504_015752_143919_A09B9263)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PROVE_RCU caught that one:

[  431.214070] ===================================================
[  431.215341] [ INFO: suspicious rcu_dereference_check() usage. ]
[  431.215674] ---------------------------------------------------
[  431.216043] net/mac80211/mesh_pathtbl.c:184 invoked
rcu_dereference_check() without protection!

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e3e3aa1..8b20d08 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1751,6 +1751,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			ret = NETDEV_TX_OK;
 			goto fail;
 		}
+		rcu_read_lock();
 		if (!is_multicast_ether_addr(skb->data))
 			mppath = mpp_path_lookup(skb->data, sdata);
 
@@ -1765,13 +1766,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		    !(mppath && compare_ether_addr(mppath->mpp, skb->data))) {
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
+			rcu_read_unlock();
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
 					sdata, NULL, NULL);
 		} else {
 			int is_mesh_mcast = 1;
 			const u8 *mesh_da;
 
-			rcu_read_lock();
 			if (is_multicast_ether_addr(skb->data))
 				/* DA TA mSA AE:SA */
 				mesh_da = skb->data;
-- 
1.7.1

