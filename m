Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025Ab1JGM5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:57:23 -0400
Message-Id: <20111007125640.484954800@sipsolutions.net> (sfid-20111007_145725_633041_376F14D2)
Date: Fri, 07 Oct 2011 14:55:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: dont orphan TX skb
References: <20111007125538.433891720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was another workaround for truesize "bugs".
The reason we did this was that when we orphaned
the SKB it wouldn't be truesize-checked later.
Now that the check is gone (and we just charge
the former smaller size to the socket) there's
no longer a reason to orphan the skb here.

Keep the skb charged to the socket until it is
really freed (or orphaned in TX status). This
helps flow control and allows us to get at the
socket later for other purposes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/mac80211/tx.c	2011-10-07 14:50:27.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 14:50:30.000000000 +0200
@@ -1384,11 +1384,6 @@ static int ieee80211_skb_resize(struct i
 		tail_need = max_t(int, tail_need, 0);
 	}
 
-	if (head_need || tail_need) {
-		/* Sorry. Can't account for this any more */
-		skb_orphan(skb);
-	}
-
 	if (skb_cloned(skb))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 	else if (head_need || tail_need)


