Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:50219 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1HLCyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:54:20 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so634961iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:54:20 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 4/8] mac80211: fix mesh path flushing
Date: Thu, 11 Aug 2011 19:53:57 -0700
Message-Id: <1313117641-27351-4-git-send-email-thomas@cozybit.com> (sfid-20110812_045426_353677_D5E72AEF)
In-Reply-To: <1313117641-27351-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
 <1313117641-27351-1-git-send-email-thomas@cozybit.com>
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
index 0d80d7d..b5f2a14 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -751,8 +751,7 @@ void mesh_path_flush_pending(struct mesh_path *mpath)
 {
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
-			(mpath->flags & MESH_PATH_ACTIVE))
+	while ((skb = skb_dequeue(&mpath->frame_queue)) != NULL)
 		mesh_path_discard_frame(skb, mpath->sdata);
 }
 
-- 
1.7.4.1

