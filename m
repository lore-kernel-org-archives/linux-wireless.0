Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:38857 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1HHXbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 19:31:15 -0400
Received: by iye16 with SMTP id 16so9873546iye.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 16:31:15 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: fix erroneous clearing of MESH_PATH_SN_VALID flag
Date: Mon,  8 Aug 2011 16:30:50 -0700
Message-Id: <1312846250-14612-1-git-send-email-javier@cozybit.com> (sfid-20110809_013121_432434_11262D9A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a PREQ or PREP is received from an intermediate node, it contains
useful information for path selection but it doesn't include the
originator's sequence number.   Therefore, when updating the mesh path
to that intermediate node, we should not set the MESH_PATH_SN_VALID
flag.  BUT, if the flag is set, it should not be unset as we might have
received a valid sequence number for that intermediate node in the past.

This issue was reported, fixed and tested by Ya Bo (游波) and Pedro
Larbig (ASPj).

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 8404fa5..3d8e55a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -449,7 +449,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 
 		if (fresh_info) {
 			mesh_path_assign_nexthop(mpath, sta);
-			mpath->flags &= ~MESH_PATH_SN_VALID;
 			mpath->metric = last_hop_metric;
 			mpath->exp_time = time_after(mpath->exp_time, exp_time)
 					  ?  mpath->exp_time : exp_time;
-- 
1.7.6

