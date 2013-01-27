Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33254 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3A0BBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 20:01:03 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so898565pad.10
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 17:01:02 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: fix mesh_sta_info_get() reshuffle damage
Date: Sat, 26 Jan 2013 17:00:02 -0800
Message-Id: <1359248402-6595-1-git-send-email-thomas@cozybit.com> (sfid-20130127_020107_927860_AC351D61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before "mac80211: clean up mesh sta allocation warning"
was applied, mesh_sta_info_get() was reshuffled to please
sparse. As a result we neglect to initialize newly created
STAs. Fix this.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ca4f2d8..6787d69 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -468,6 +468,8 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
 			return NULL;
 		}
 
+		mesh_sta_info_init(sdata, sta, elems, true);
+
 		if (sta_info_insert_rcu(sta))
 			return NULL;
 	}
-- 
1.7.10.4

