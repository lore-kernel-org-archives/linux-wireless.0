Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:35344 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506AbZLJCnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 21:43:37 -0500
Received: by ywh36 with SMTP id 36so7298422ywh.15
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 18:43:44 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>, stable@kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: Fixed bug in mesh portal paths
Date: Wed,  9 Dec 2009 18:43:00 -0800
Message-Id: <1260412981-2982-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paths to mesh portals were being timed out immediately after each use in
intermediate forwarding nodes.  mppath->exp_time is set to the expiration time
so assigning it to jiffies was marking the path as expired.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/rx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8b3faa8..3d88541 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1712,7 +1712,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			mpp_path_add(proxied_addr, mpp_addr, sdata);
 		} else {
 			spin_lock_bh(&mppath->state_lock);
-			mppath->exp_time = jiffies;
 			if (compare_ether_addr(mppath->mpp, mpp_addr) != 0)
 				memcpy(mppath->mpp, mpp_addr, ETH_ALEN);
 			spin_unlock_bh(&mppath->state_lock);
-- 
1.6.3.3

