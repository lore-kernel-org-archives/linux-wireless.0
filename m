Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f43.google.com ([209.85.210.43]:63078 "EHLO
	mail-pz0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2EDHES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 03:04:18 -0400
Received: by dajz8 with SMTP id z8so3237324daj.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 00:04:17 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] fix the increment of unicast/multicast counters for forwarded PREQ
Date: Fri,  4 May 2012 14:57:50 +0800
Message-Id: <1336114670-2796-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120504_090421_619451_4A757659)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forwarded PREQ is either unicast or multicast. The appropriate counters
should be incremented accordingly.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2:
use helper to check multicast address (Javier)

 net/mac80211/mesh_hwmp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 503016f..70ac7d1 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -603,7 +603,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
-		ifmsh->mshstats.fwded_mcast++;
+		if (!is_multicast_ether_addr(da))
+			ifmsh->mshstats.fwded_unicast++;
+		else
+			ifmsh->mshstats.fwded_mcast++;
 		ifmsh->mshstats.fwded_frames++;
 	}
 }
-- 
1.7.0.4

