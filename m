Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:50219 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1HLCyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:54:16 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so634961iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:54:15 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 2/8] mac80211: fix mpath timer removal
Date: Thu, 11 Aug 2011 19:53:55 -0700
Message-Id: <1313117641-27351-2-git-send-email-thomas@cozybit.com> (sfid-20110812_045424_398509_D91B9511)
In-Reply-To: <1313117641-27351-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
 <1313117641-27351-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Initialize mpath timers added to mpp_table.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3ce6c85..7d050af 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -503,6 +503,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
+	init_timer(&new_mpath->timer);
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
-- 
1.7.4.1

