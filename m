Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1KRO1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:27:38 -0500
Subject: [PATCH] mac80211: minor cleanup to mesh state locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 15:27:31 +0100
Message-ID: <1321626451.10266.58.camel@jlt3.sipsolutions.net> (sfid-20111118_152741_812110_D4B35F82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

First time I tried smatch, and it says:
mesh_hwmp.c +870 mesh_queue_preq(21) error: double lock 'bottom_half:'
mesh_hwmp.c +873 mesh_queue_preq(24) error: double unlock 'bottom_half:'
mesh_hwmp.c +886 mesh_queue_preq(37) error: double unlock 'bottom_half:'

Which is indeed true -- there's no point in disabling BHs
again if we just did that a few lines earlier, so remove.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_hwmp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/mesh_hwmp.c	2011-11-18 09:46:26.000000000 +0100
+++ b/net/mac80211/mesh_hwmp.c	2011-11-18 15:25:36.000000000 +0100
@@ -867,9 +867,9 @@ static void mesh_queue_preq(struct mesh_
 		return;
 	}
 
-	spin_lock_bh(&mpath->state_lock);
+	spin_lock(&mpath->state_lock);
 	if (mpath->flags & MESH_PATH_REQ_QUEUED) {
-		spin_unlock_bh(&mpath->state_lock);
+		spin_unlock(&mpath->state_lock);
 		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		return;
@@ -879,7 +879,7 @@ static void mesh_queue_preq(struct mesh_
 	preq_node->flags = flags;
 
 	mpath->flags |= MESH_PATH_REQ_QUEUED;
-	spin_unlock_bh(&mpath->state_lock);
+	spin_unlock(&mpath->state_lock);
 
 	list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
 	++ifmsh->preq_queue_len;


