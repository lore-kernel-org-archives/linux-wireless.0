Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:52868 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcLFMkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 07:40:11 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Laurent Trarieux <Laurent.Trarieux@ceva-dsp.com>
Subject: [PATCH] mac80211: Ensure enough headroom when forwarding mesh pkt
Date: Tue, 6 Dec 2016 12:23:28 +0000
Message-ID: <356db1fcf788467f9145abc10e218d66@ceva-dsp.com> (sfid-20161206_134746_387190_5D33F815)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a buffer is duplicated during MESH packet forwarding,
this patch ensures that the new buffer has enough headroom.

Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d2a00f2..1ed32b4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2468,7 +2468,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (!ifmsh->mshcfg.dot11MeshForwarding)
 		goto out;
 
-	fwd_skb = skb_copy(skb, GFP_ATOMIC);
+	if (skb_headroom(skb) >= local->tx_headroom)
+		fwd_skb = skb_copy(skb, GFP_ATOMIC);
+	else
+		fwd_skb = skb_copy_expand(skb, local->tx_headroom,
+					  0, GFP_ATOMIC);
 	if (!fwd_skb) {
 		net_info_ratelimited("%s: failed to clone mesh frame\n",
 				    sdata->name);
-- 
2.7.4
