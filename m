Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2KGNCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:02:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix TX error path
Date: Wed,  7 Nov 2012 14:03:25 +0100
Message-Id: <1352293405-27692-1-git-send-email-johannes@sipsolutions.net> (sfid-20121107_140302_585568_7ECC7434)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

One error path in ieee80211_subif_start_xmit() will
double-free the SKB. Set it to NULL to prevent that.

This issue was introduced by my channel context
changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 065f81c..b546887 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2089,6 +2089,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
 			ieee80211_free_txskb(&local->hw, skb);
+			skb = NULL;
 			goto fail_rcu;
 		}
 	}
-- 
1.8.0

