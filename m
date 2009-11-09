Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:19838 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZKIXr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:29 -0500
Received: by ey-out-2122.google.com with SMTP id 4so87855eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:35 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 13/20] mac80211: properly forward the RANN IE
Date: Mon,  9 Nov 2009 23:46:51 +0000
Message-Id: <1257810418-30075-14-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase hopcount and convert metric to LE before forwarding the RANN
action frame.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c12cf5a..355099f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -686,6 +686,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	orig_addr = rann->rann_addr;
 	orig_dsn = rann->rann_seq;
 	hopcount = rann->rann_hopcount;
+	hopcount++;
 	metric = rann->rann_metric;
 	mhwmp_dbg("received RANN from %pM\n", orig_addr);
 
@@ -706,7 +707,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_dsn),
 				       0, NULL, 0, sdata->dev->broadcast,
-				       hopcount, ttl, 0, cpu_to_le32(metric),
+				       hopcount, ttl, 0,
+				       cpu_to_le32(metric + mpath->metric),
 				       0, sdata);
 		mpath->dsn = orig_dsn;
 	}
-- 
1.5.6.5

