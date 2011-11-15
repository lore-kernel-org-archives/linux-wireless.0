Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63946 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1KOGeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:34:24 -0500
Date: Tue, 15 Nov 2011 09:33:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: memory leak in mesh_queue_preq()
Message-ID: <20111115063331.GC30827@elgon.mountain> (sfid-20111115_073429_176274_8CB91B94)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We recently introduced a return here, but we need to call kfree
first.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index a7afb2d..8a81591 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -871,6 +871,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 	if (mpath->flags & MESH_PATH_REQ_QUEUED) {
 		spin_unlock_bh(&mpath->state_lock);
 		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
+		kfree(preq_node);
 		return;
 	}
 
