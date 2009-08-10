Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:33616 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZHJT11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:27 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1077455rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:29 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Subject: [PATCH 2/7] mac80211: Use correct sign for mesh active path refresh.
Date: Mon, 10 Aug 2009 12:15:47 -0700
Message-Id: <1249931752-18127-3-git-send-email-javier@cozybit.com>
In-Reply-To: <1249931752-18127-2-git-send-email-javier@cozybit.com>
References: <20090810175225.GF2733@tuxdriver.com>
 <1249931752-18127-1-git-send-email-javier@cozybit.com>
 <1249931752-18127-2-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Yurovsky <andrey@cozybit.com>

On locally originated traffic, we refresh active paths after a timeout.  The
decision to do this was using the wrong sign and therefore the refresh timer
was triggered for every frame.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b54c21c..1cd1e72 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -791,7 +791,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	}
 
 	if (mpath->flags & MESH_PATH_ACTIVE) {
-		if (time_after(jiffies, mpath->exp_time -
+		if (time_after(jiffies, mpath->exp_time +
 			msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time))
 				&& !memcmp(sdata->dev->dev_addr, hdr->addr4,
 					   ETH_ALEN)
-- 
1.5.4.3

