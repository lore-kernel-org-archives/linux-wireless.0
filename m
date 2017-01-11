Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:64311 "EHLO
        sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932151AbdAKOyT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 09:54:19 -0500
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211: Fix headroom allocation when forwarding mesh pkt
Date: Wed, 11 Jan 2017 14:39:07 +0000
Message-ID: <e3b7a95724944c6aadc8512eadfe1c1d@ceva-dsp.com> (sfid-20170111_155422_675776_897E23BB)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix issue introduced by commit
"mac80211: Ensure enough headroom when forwarding mesh pkt"

When forwarding mesh pkt, mac80211 may also add security header,
and it must therefore be taken into account in the needed headroom.

Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c037c5b..e376093 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2472,7 +2472,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (!ifmsh->mshcfg.dot11MeshForwarding)
 		goto out;
 
-	fwd_skb = skb_copy_expand(skb, local->tx_headroom, 0, GFP_ATOMIC);
+	fwd_skb = skb_copy_expand(skb, local->tx_headroom +
+				  sdata->encrypt_headroom, 0, GFP_ATOMIC);
 	if (!fwd_skb) {
 		net_info_ratelimited("%s: failed to clone mesh frame\n",
 				    sdata->name);
-- 
2.7.4
