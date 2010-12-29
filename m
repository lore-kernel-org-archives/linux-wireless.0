Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63469 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab0L2BSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 20:18:41 -0500
Received: by gwj20 with SMTP id 20so4963241gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 17:18:40 -0800 (PST)
Message-ID: <4D1A8C6C.6030306@gmail.com>
Date: Tue, 28 Dec 2010 19:18:36 -0600
From: Joel A Fernandes <agnel.joel@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/1] mac80211: Fix mesh portal communication with other mesh
 nodes.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a bug where if a mesh interface has a different MAC address from its bridge
interface, then it would not be able to send data traffic to any other mesh node.
This also adds support for communication between mesh nodes and external bridged
nodes by using a 6 address format if the source is a node within the mesh and the
destination is an external node proxied by a mesh portal.

Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
---
 net/mac80211/tx.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ad5bc90..8f78a26 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1751,6 +1751,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	__le16 fc;
 	struct ieee80211_hdr hdr;
 	struct ieee80211s_hdr mesh_hdr __maybe_unused;
+	struct mesh_path *mppath = NULL;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1811,16 +1812,23 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			ret = NETDEV_TX_OK;
 			goto fail;
 		}
+		if (!is_multicast_ether_addr(skb->data))
+			mppath = mpp_path_lookup(skb->data, sdata);
 
+		/*
+		 * Do not use address extension, if it is a packet from
+		 * the same interface and the destination is not being
+		 * proxied by any other mest point.
+		 */
 		if (compare_ether_addr(sdata->vif.addr,
-				       skb->data + ETH_ALEN) == 0) {
+				       skb->data + ETH_ALEN) == 0 &&
+		    (!mppath || !compare_ether_addr(mppath->mpp, skb->data))) {
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
 					sdata, NULL, NULL);
 		} else {
 			/* packet from other interface */
-			struct mesh_path *mppath;
 			int is_mesh_mcast = 1;
 			const u8 *mesh_da;
 
@@ -1831,8 +1839,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			else {
 				static const u8 bcast[ETH_ALEN] =
 					{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
-				mppath = mpp_path_lookup(skb->data, sdata);
 				if (mppath) {
 					/* RA TA mDA mSA AE:DA SA */
 					mesh_da = mppath->mpp;
