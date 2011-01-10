Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39639 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab1AJGoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 01:44:25 -0500
Received: by ywl5 with SMTP id 5so7413434ywl.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 22:44:25 -0800 (PST)
Message-ID: <4D2AAAC7.6000608@gmail.com>
Date: Mon, 10 Jan 2011 00:44:23 -0600
From: Joel A Fernandes <agnel.joel@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>, javier@cozybit.com,
	devel@lists.open80211s.org
Subject: [PATCHv2 1/1] mac80211: Rewrote code for checking if destinations
 are proxied.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rewrote code for checking if the destination is proxied by a mesh portal, to facilitate better
understanding of the functionality.

Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
Acked-by: Javier Cardona <javier@cozybit.com>
--
These changes are incremental to the patch "mac80211: Fix mesh portal communication with other mesh nodes"
which was merged into wireless-testing (commit f76b57b47e5fd423f9827c7b0ba7bbd06cca6b9b).
Resending the patch as v2 because Thunderbird managed to mess up the formatting yet again.
--
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..5173fc6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1815,19 +1815,18 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
             mppath = mpp_path_lookup(skb->data, sdata);
 
         /*
-         * Do not use address extension, if it is a packet from
-         * the same interface and the destination is not being
-         * proxied by any other mest point.
+         * Use address extension if it is a packet from another interface or if
+         * we know the destination is being proxied by a portal (i.e. portal address
+         * differs from proxied address)
          */
         if (compare_ether_addr(sdata->vif.addr,
                        skb->data + ETH_ALEN) == 0 &&
-            (!mppath || !compare_ether_addr(mppath->mpp, skb->data))) {
+            !(mppath && compare_ether_addr(mppath->mpp, skb->data))) {
             hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
                     skb->data, skb->data + ETH_ALEN);
             meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
                     sdata, NULL, NULL);
         } else {
-            /* packet from other interface */
             int is_mesh_mcast = 1;
             const u8 *mesh_da;

