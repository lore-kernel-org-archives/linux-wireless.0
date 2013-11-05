Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44574 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab3KETW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:56 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so9278501pab.24
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:55 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 09/17] mac80211: return -ENOMEM in mesh_plink_frame_tx
Date: Tue,  5 Nov 2013 11:16:57 -0800
Message-Id: <1383679025-7150-9-git-send-email-thomas@cozybit.com> (sfid-20131105_202305_161491_87D56F62)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

All other paths return an error code, do the same here.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 550ebc1..429f692 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -283,7 +283,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
-		return -1;
+		return err;
 	info = IEEE80211_SKB_CB(skb);
 	skb_reserve(skb, local->tx_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
-- 
1.8.4.rc3

