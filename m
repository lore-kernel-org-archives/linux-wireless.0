Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44704 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab0LRSbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 13:31:15 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 3/3] mac80211: fix potentially redundant skb data copying
Date: Sat, 18 Dec 2010 19:30:50 +0100
Message-Id: <1292697050-25741-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292697050-25741-2-git-send-email-nbd@openwrt.org>
References: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
 <1292697050-25741-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an skb is shared, it needs to be duplicated, along with its data buffer.
If the skb does not have enough headroom, using skb_copy might cause the data
buffer to be copied twice (once by skb_copy and once by pskb_expand_head).
Fix this by using skb_clone initially and letting ieee80211_skb_resize sort
out the rest.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 56ae175..d484c07 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1939,7 +1939,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 */
 	if (skb_shared(skb)) {
 		tmp_skb = skb;
-		skb = skb_copy(skb, GFP_ATOMIC);
+		skb = skb_clone(skb, GFP_ATOMIC);
 		kfree_skb(tmp_skb);
 
 		if (!skb) {
-- 
1.7.3.2

