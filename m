Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9899 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdA1ACZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 19:02:25 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/3] mac80211: clear failure average upon mesh path deactivation
Date: Fri, 27 Jan 2017 16:01:48 -0800
Message-ID: <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170128_010240_390902_2886435A)
In-Reply-To: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh moving average should be cleared, whenever mesh paths
to the given station are deactivated due to bad link. This will
give enough room to analysis more tx status than retaining the
current average.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mesh_pathtbl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f0e6175a9821..208ad36c0a7f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -510,6 +510,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct mesh_path *mpath;
 	struct rhashtable_iter iter;
 	int ret;
+	bool paths_deactivated = false;
 
 	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
 	if (ret)
@@ -535,8 +536,11 @@ void mesh_plink_broken(struct sta_info *sta)
 				sdata->u.mesh.mshcfg.element_ttl,
 				mpath->dst, mpath->sn,
 				WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
+			paths_deactivated = true;
 		}
 	}
+	if (paths_deactivated)
+		sta->mesh->fail_avg = 0;
 out:
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
-- 
1.9.1
