Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:26409 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZKIMl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:41:26 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1189980fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:41:31 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 15/21] mac80211: set the AID field correctly for mesh peer frames
Date: Mon,  9 Nov 2009 12:39:35 +0000
Message-Id: <1257770381-7680-16-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
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

