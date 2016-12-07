Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:42094 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcLGKO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 05:14:29 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: Ensure enough headroom when forwarding mesh pkt
Date: Wed, 7 Dec 2016 09:59:00 +0000
Message-ID: <1ffe01100a724290ab910d68980604ba@ceva-dsp.com> (sfid-20161207_111435_589586_8DB320B6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a buffer is duplicated during MESH packet forwarding,
this patch ensures that the new buffer has enough headroom.

Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2a00f2..bfa5f4d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2468,7 +2468,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (!ifmsh->mshcfg.dot11MeshForwarding)
 		goto out;
 
-	fwd_skb = skb_copy(skb, GFP_ATOMIC);
+	fwd_skb = skb_copy_expand(skb, local->tx_headroom, 0, GFP_ATOMIC);
 	if (!fwd_skb) {
 		net_info_ratelimited("%s: failed to clone mesh frame\n",
 				    sdata->name);
-- 
2.7.4
