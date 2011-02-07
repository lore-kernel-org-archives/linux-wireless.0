Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57605 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab1BGLFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 06:05:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	dmitry.torokhov@gmail.com
Subject: [PATCH 2.6.38] mac80211: fix the skb cloned check in the tx path
Date: Mon,  7 Feb 2011 12:05:00 +0100
Message-Id: <1297076700-76871-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using skb_header_cloned to check if it's safe to write to the skb is not
enough - mac80211 also touches the tailroom of the skb.
Initially this check was only used to increase a counter, however this
commit changed the code to also skip skb data reallocation if no extra
head/tailroom was needed:

commit 4cd06a344db752f513437138953af191cbe9a691
mac80211: skip unnecessary pskb_expand_head calls

It added a regression at least with iwl3945, which is fixed by this patch.

Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2915168..fc1d728 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1549,7 +1549,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 		skb_orphan(skb);
 	}
 
-	if (skb_header_cloned(skb))
+	if (skb_cloned(skb))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 	else if (head_need || tail_need)
 		I802_DEBUG_INC(local->tx_expand_skb_head);
-- 
1.7.3.2

