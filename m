Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46271 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZKIXrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:32 -0500
Received: by ewy3 with SMTP id 3so3717715ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:37 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 14/20] mac80211: set the AID field correctly for mesh peer frames
Date: Mon,  9 Nov 2009 23:46:52 +0000
Message-Id: <1257810418-30075-15-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This sets the AID field correctly for mesh peer confirm frames.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_plink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cf12f61..ec68d20 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -181,7 +181,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (action == PLINK_CONFIRM) {
 			pos = skb_put(skb, 4);
 			/* two-byte status code followed by two-byte AID */
-			memset(pos, 0, 4);
+			memset(pos, 0, 2);
+			memcpy(pos + 2, &plid, 2);
 		}
 		mesh_mgmt_ies_add(skb, sdata);
 	}
-- 
1.5.6.5

