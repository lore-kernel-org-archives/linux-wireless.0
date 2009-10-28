Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26776 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbZJ1UNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 16:13:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: make align adjustment code support paged SKB
Date: Wed, 28 Oct 2009 13:13:52 -0700
Message-Id: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

This fixed a BUG_ON in __skb_trim() when paged rx is used in
iwlwifi driver. Yes, the whole mac80211 stack doesn't support
paged SKB yet. But let's start the work slowly from small
code snippets.

Reported-and-tested-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/rx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c385e3..a50d5f3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1337,10 +1337,10 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 				skb = NULL;
 			} else {
 				u8 *data = skb->data;
-				size_t len = skb->len;
-				u8 *new = __skb_push(skb, align);
-				memmove(new, data, len);
-				__skb_trim(skb, len);
+				size_t len = skb_headlen(skb);
+				skb->data -= align;
+				memmove(skb->data, data, len);
+				skb_set_tail_pointer(skb, len);
 			}
 		}
 #endif
-- 
1.5.6.3

