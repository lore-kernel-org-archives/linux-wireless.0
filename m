Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38628 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2EDEi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 00:38:27 -0400
Received: by pbbrp8 with SMTP id rp8so3337957pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 21:38:26 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] fix the increment of unicast/multicast counters for forwarded PREQ
Date: Fri,  4 May 2012 12:36:55 +0800
Message-Id: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120504_063831_413619_21ED1BFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forwarded PREQ is either unicast or multicast. The appropriate counters
should be incremented accordingly.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_hwmp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 503016f..f0695e5 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -603,7 +603,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
-		ifmsh->mshstats.fwded_mcast++;
+		if (da != broadcast_addr)
+			ifmsh->mshstats.fwded_unicast++;
+		else
+			ifmsh->mshstats.fwded_mcast++;
 		ifmsh->mshstats.fwded_frames++;
 	}
 }
--
1.7.0.4

