Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53503 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZKIMlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:41:10 -0500
Received: by ewy3 with SMTP id 3so3048965ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:41:15 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 14/21] mac80211: properly forward the RANN IE
Date: Mon,  9 Nov 2009 12:39:34 +0000
Message-Id: <1257770381-7680-15-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
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
index 1499bfd..1780c97 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -692,6 +692,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	orig_addr = RANN_IE_ORIG_ADDR(rann_elem);
 	orig_dsn = RANN_IE_ORIG_DSN(rann_elem);
 	hopcount = RANN_IE_HOPCOUNT(rann_elem);
+	hopcount++;
 	metric = RANN_IE_METRIC(rann_elem);
 	mhwmp_dbg("received RANN from %pM\n", orig_addr);
 
@@ -712,7 +713,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
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

