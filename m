Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:36243 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZLJCnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 21:43:47 -0500
Received: by gxk4 with SMTP id 4so11880073gxk.8
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 18:43:53 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>, stable@kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: Revert 'Use correct sign for mesh active path refresh'
Date: Wed,  9 Dec 2009 18:43:01 -0800
Message-Id: <1260412981-2982-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1260412981-2982-1-git-send-email-javier@cozybit.com>
References: <1260412981-2982-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch (be48ad42a1a6b82108df722034aebd12680bca44) was actually a bug.
Reverted it and improved the explanation of how mesh path refresh works.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh.h      |    5 +++--
 net/mac80211/mesh_hwmp.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 31e1025..85562c5 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -188,8 +188,9 @@ struct mesh_rmc {
  */
 #define MESH_PREQ_MIN_INT	10
 #define MESH_DIAM_TRAVERSAL_TIME 50
-/* Paths will be refreshed if they are closer than PATH_REFRESH_TIME to their
- * expiration
+/* A path will be refreshed if it is used PATH_REFRESH_TIME milliseconds before
+ * timing out.  This way it will remain ACTIVE and no data frames will be
+ * unnecesarily held in the pending queue.
  */
 #define MESH_PATH_REFRESH_TIME			1000
 #define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 9aecf02..c43fa91 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -936,7 +936,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	}
 
 	if (mpath->flags & MESH_PATH_ACTIVE) {
-		if (time_after(jiffies, mpath->exp_time +
+		if (time_after(jiffies, mpath->exp_time -
 			msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time))
 				&& !memcmp(sdata->dev->dev_addr, hdr->addr4,
 					   ETH_ALEN)
-- 
1.6.3.3

