Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44698 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab0LRSbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 13:31:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/3] mac80211: skip unnecessary pskb_expand_head calls
Date: Sat, 18 Dec 2010 19:30:49 +0100
Message-Id: <1292697050-25741-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
References: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the skb is not cloned and we don't need any extra headroom, there
is no point in reallocating the skb head.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7d78aca..56ae175 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1549,8 +1549,10 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 
 	if (skb_header_cloned(skb))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
-	else
+	else if (head_need || tail_need)
 		I802_DEBUG_INC(local->tx_expand_skb_head);
+	else
+		return 0;
 
 	if (pskb_expand_head(skb, head_need, tail_need, GFP_ATOMIC)) {
 		wiphy_debug(local->hw.wiphy,
-- 
1.7.3.2

