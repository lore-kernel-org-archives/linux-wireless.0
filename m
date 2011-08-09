Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52194 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HIXq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 19:46:28 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so23646iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 16:46:28 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 4/8] mac80211: fix mesh path flushing
Date: Tue,  9 Aug 2011 16:45:07 -0700
Message-Id: <1312933511-9486-5-git-send-email-thomas@cozybit.com> (sfid-20110810_014634_154260_0CDAA2C7)
In-Reply-To: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Previously, mpaths were never flushed since the mpath is not active once
we call this function.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index b4480a9..de8c4f6 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -735,8 +735,7 @@ void mesh_path_flush_pending(struct mesh_path *mpath)
 {
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
-			(mpath->flags & MESH_PATH_ACTIVE))
+	while ((skb = skb_dequeue(&mpath->frame_queue)) != NULL)
 		mesh_path_discard_frame(skb, mpath->sdata);
 }
 
-- 
1.7.6

