Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1JGM5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:57:19 -0400
Message-Id: <20111007125640.149058520@sipsolutions.net> (sfid-20111007_145722_656487_FF477BB9)
Date: Fri, 07 Oct 2011 14:55:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: dont adjust truesize
References: <20111007125538.433891720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to adjust truesize.

The history of this was that we always ran into
skb_truesize_bug (via skb_truesize_check) which
has since been removed in commit 92a0acce186cd.
skb_truesize_check() checked that truesize  was
bigger or equal to the actual allocation, which
would trigger in mac80211 due to header adding.
The check no longer exists and we shouldn't be
messing with the truesize anwyay.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mac80211/tx.c	2011-10-07 14:50:23.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 14:50:27.000000000 +0200
@@ -1402,9 +1402,6 @@ static int ieee80211_skb_resize(struct i
 		return -ENOMEM;
 	}
 
-	/* update truesize too */
-	skb->truesize += head_need + tail_need;
-
 	return 0;
 }
 


