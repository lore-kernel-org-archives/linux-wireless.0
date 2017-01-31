Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14380 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbdAaULM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 15:11:12 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 3/3] mac80211: clear failure average upon mesh path deactivation
Date: Tue, 31 Jan 2017 12:07:52 -0800
Message-ID: <1485893272-6893-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170131_211117_038924_79507BB0)
In-Reply-To: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485893272-6893-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh moving average should be cleared, whenever mesh paths
to the given station are deactivated due to bad link. It makes
path deactivation logic more robust by considering more tx
status before terminating mesh link.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2:
 * removed paths_deactivated check
 * updated commit log

 net/mac80211/mesh_pathtbl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f0e6175a9821..bab443e5284d 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -537,6 +537,7 @@ void mesh_plink_broken(struct sta_info *sta)
 				WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
 		}
 	}
+	sta->mesh->fail_avg = 0;
 out:
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
-- 
1.9.1
