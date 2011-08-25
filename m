Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45445 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1HYBWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:22:16 -0400
Received: by mail-gx0-f174.google.com with SMTP id 21so1333929gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:22:16 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 5/8] mac80211: fix mpath timer removal
Date: Wed, 24 Aug 2011 18:21:50 -0700
Message-Id: <1314235313-4564-6-git-send-email-thomas@cozybit.com> (sfid-20110825_032224_722462_6775779A)
In-Reply-To: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Initialize mpath timers added to mpp_table.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---

v2: - initialize timer instead of checking for NULL (Johannes)

 net/mac80211/mesh_pathtbl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 41036a2..55ccd62 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -487,6 +487,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
+	init_timer(&new_mpath->timer);
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
-- 
1.7.4.1

