Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2HTS2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 14:28:31 -0400
Received: by pbbrr13 with SMTP id rr13so7300544pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 11:28:31 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: fix DS to MBSS address translation
Date: Mon, 20 Aug 2012 11:28:25 -0700
Message-Id: <1345487305-23759-1-git-send-email-thomas@cozybit.com> (sfid-20120820_202839_931488_49FFDE68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The destination address of unicast frames forwarded through a mesh gate
was being replaced with the broadcast address. Instead leave the
original destination address as the mesh DA. If the nexthop address is
not in the mpath table it will be resolved. If that fails, the frame
will be forwarded to known mesh gates.

Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/tx.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index acf712f..c5e8c9c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1811,37 +1811,31 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
 					sdata, NULL, NULL);
 		} else {
-			int is_mesh_mcast = 1;
-			const u8 *mesh_da;
+			/* DS -> MBSS (802.11-2012 13.11.3.3).
+			 * For unicast with unknown forwarding information,
+			 * destination might be in the MBSS or if that fails
+			 * forwarded to another mesh gate. In either case
+			 * resolution will be handled in ieee80211_xmit(), so
+			 * leave the original DA. This also works for mcast */
+			const u8 *mesh_da = skb->data;
+
+			if (mppath)
+				mesh_da = mppath->mpp;
+			else if (mpath)
+				mesh_da = mpath->dst;
+			rcu_read_unlock();
 
-			if (is_multicast_ether_addr(skb->data))
-				/* DA TA mSA AE:SA */
-				mesh_da = skb->data;
-			else {
-				static const u8 bcast[ETH_ALEN] =
-					{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-				if (mppath) {
-					/* RA TA mDA mSA AE:DA SA */
-					mesh_da = mppath->mpp;
-					is_mesh_mcast = 0;
-				} else if (mpath) {
-					mesh_da = mpath->dst;
-					is_mesh_mcast = 0;
-				} else {
-					/* DA TA mSA AE:SA */
-					mesh_da = bcast;
-				}
-			}
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					mesh_da, sdata->vif.addr);
-			rcu_read_unlock();
-			if (is_mesh_mcast)
+			if (is_multicast_ether_addr(mesh_da))
+				/* DA TA mSA AE:SA */
 				meshhdrlen =
 					ieee80211_new_mesh_header(&mesh_hdr,
 							sdata,
 							skb->data + ETH_ALEN,
 							NULL);
 			else
+				/* RA TA mDA mSA AE:DA SA */
 				meshhdrlen =
 					ieee80211_new_mesh_header(&mesh_hdr,
 							sdata,
-- 
1.7.5.4

